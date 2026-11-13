#!/usr/bin/env python3
"""Inspect every rendered scanline during native movie/travel palette fades."""
from pathlib import Path
import argparse, hashlib, json, subprocess
import numpy as np
from pyboy import PyBoy
from verify_rom import load_symbols, read_word, cartridge_header

ROOT = Path(__file__).resolve().parents[1]
MAIN = r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "travel.h"
#include "audio.h"
uint16_t scene_shared_colors[32];uint8_t scene_shared_bytes[40];
volatile uint8_t ready,command,step,inward;
uint8_t palette_readback[120];
static const uint8_t solid[16]={255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0};
static void setup(void){
 uint8_t i,x,y;DISPLAY_OFF;HIDE_WIN;
 for(i=0;i<32;++i)scene_shared_colors[i]=RGB(31,31,31);
 set_bkg_palette(0,8,scene_shared_colors);set_sprite_palette(0,8,scene_shared_colors);
 VBK_REG=0;set_bkg_data(0,1,solid);set_sprite_data(0,1,solid);
 for(y=0;y<18;++y)for(x=0;x<20;++x){
  uint8_t value=0;VBK_REG=0;set_bkg_tiles(x,y,1,1,&value);
  value=x%7;VBK_REG=1;set_bkg_tiles(x,y,1,1,&value);
 }
 VBK_REG=0;
 for(i=0;i<32;++i){set_sprite_tile(i,0);set_sprite_prop(i,i&7);move_sprite(i,16+(i&7)*16,32+(i>>3)*32);}
 for(i=32;i<40;++i)move_sprite(i,0,0);
 SHOW_BKG;SHOW_SPRITES;DISPLAY_ON;
}
void main(void){
 uint8_t i;DISPLAY_OFF;cpu_fast();SWITCH_ROM_MBC5(1);audio_install();setup();audio_command(0x85);ready=1;
 while(1){vsync();if(command){
  if(command==1)setup();
  else if(command==2)scene_fade_begin(inward);
  else if(command==3)scene_fade_step(step,inward);
  else if(command==4)travel_fade_current();
  /* Readback is outside rendering checks; each byte waits for palette access. */
  for(i=0;i<56;++i){while(STAT_REG&2);BCPS_REG=i;palette_readback[i]=BCPD_REG;}
  for(i=0;i<64;++i){while(STAT_REG&2);OCPS_REG=i;palette_readback[i+56]=OCPD_REG;}
  command=0;
 }}
}
'''

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--label', default='current')
    parser.add_argument('--allow-failure', action='store_true')
    args = parser.parse_args()
    out = ROOT / 'build/verification/scene-fades' / args.label
    out.mkdir(parents=True, exist_ok=True)
    (out/'main.c').write_text(MAIN)
    sources = [out/'main.c']+[ROOT/'src'/p for p in (
        'palette_commit.c','travel.c','travel_render.c','travel_art.c','world.c','world_assets.c',
        'scene_actor.c','scene_actor_data.c','bank_io.c','assets.c','assets_sprites.c',
        'audio.c','audio_irq.c','audio_data.c','audio_tables.c','audio_low_62.c','audio_low_63.c')]
    sources += sorted((ROOT/'src').glob('world_assets_*_*.c'))+sorted((ROOT/'src').glob('scene_actor_bank_*.c'))
    rom = out/'scene-fades.gbc'
    subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo128','-Wm-ya1',
                    '-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),
                    *[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
    sym = load_symbols(rom.with_suffix('.noi'))
    e = PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR')
    e.set_emulation_speed(0)
    cases=[];failures=[];frames=0
    def issue(command, label, inspect=True):
        nonlocal frames
        audio_start=read_word(e,sym['audio_frames'])
        e.memory[sym['command']]=command
        rendered=[]
        for tick in range(120):
            e.tick(1);frames+=1
            pixels=e.screen.ndarray[:,:,:3]
            colors=np.unique(pixels.reshape(-1,3),axis=0)
            rendered.append(len(colors))
            if inspect and len(colors)!=1:
                name=f'{label}-{tick:02d}.png';e.screen.image.save(out/name)
                failures.append({'case':label,'physical_frame':tick,'colors':len(colors),'screenshot':name})
            assert not e.memory[sym['audio_fault']],label
            assert bytes(e.memory[0xDBC0:0xDC00])==bytes([0xA7])*64,label
            if not e.memory[sym['command']]:
                # A completed palette write can still split the frame being rendered.
                for tail in range(2):
                    e.tick(1);frames+=1
                    colors=np.unique(e.screen.ndarray[:,:,:3].reshape(-1,3),axis=0)
                    rendered.append(len(colors))
                    if inspect and len(colors)!=1:
                        name=f'{label}-tail{tail}.png';e.screen.image.save(out/name)
                        failures.append({'case':label,'physical_frame':f'tail{tail}','colors':len(colors),'screenshot':name})
                audio_ticks=(read_word(e,sym['audio_frames'])-audio_start)&65535
                if inspect:assert abs(audio_ticks-len(rendered))<=1,(label,'audio cadence',audio_ticks,len(rendered))
                cases.append({'case':label,'physical_frames':len(rendered),'audio_updates':audio_ticks,
                              'lcd_off_reset':not inspect,'maximum_colors':max(rendered)})
                return bytes(e.memory[sym['palette_readback']:sym['palette_readback']+120])
        raise AssertionError(('fade mailbox timeout',label))
    def expected(step,inward):
        color=0 if inward else 63
        for _ in range(step):
            if inward:
                if color==63:continue
                color +=16 if color+16<=63 else 4 if color+4<=63 else 1
            elif color&3:color-=1
            elif color&12:color-=4
            elif color&48:color-=16
        native=sum((((color>>shift)&3)*10+(((color>>shift)&3)>=2))<<(i*5)for i,shift in enumerate((0,2,4)))
        return native.to_bytes(2,'little')*60
    try:
        e.tick(180);assert e.memory[sym['ready']]
        e.memory[0xDBC0:0xDC00]=[0xA7]*64
        start=read_word(e,sym['audio_frames'])
        e.memory[sym['inward']]=0;issue(2,'capture-out')
        for step in range(1,10):
            e.memory[sym['step']]=step
            assert issue(3,f'out-{step}')==expected(step,False)
        # Recapture the white target while the LCD is off, then fade from black.
        issue(1,'reset-in',False)
        e.memory[sym['inward']]=1
        assert issue(2,'capture-in')==expected(0,True)
        for step in range(1,11):
            e.memory[sym['step']]=step
            assert issue(3,f'in-{step}')==expected(step,True)
        issue(1,'reset-current',False)
        for step in range(1,10):
            assert issue(4,f'current-{step}')==expected(step,False)
        updates=(read_word(e,sym['audio_frames'])-start)&65535
        report={'passed':not failures,'header':cartridge_header(rom),'physical_frames':frames,
                'audio_updates':updates,'guard_bytes':64,'cases':cases,'mixed_scanline_frames':failures,
                'source_files':{p.name:hashlib.sha256(p.read_bytes()).hexdigest()for p in sources},
                'scope':'Production movie and departure fade helpers, actual CGB PPU with all seven BG and eight OBJ palettes, real score IRQs. Uniform white fixture isolates partial-frame palette commits; exact 60-color readbacks check all source fade steps. LCD-off reset frames excluded.'}
        (out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps({k:v for k,v in report.items()if k not in ('source_files','cases','mixed_scanline_frames')},indent=2))
        print('Mixed frames:',len(failures))
        if not args.allow_failure:assert not failures,failures[:3]
    finally:e.stop(save=False)

if __name__=='__main__':main()
