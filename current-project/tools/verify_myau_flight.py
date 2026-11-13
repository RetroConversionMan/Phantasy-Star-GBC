#!/usr/bin/env python3
"""Native original flight state/timing and all source pose/anchor updates."""
import json,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header,read_word
from extract_scenes import ROOT
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "myau_flight.h"
#include "font.h"
#include "assets.h"
uint8_t probe_ready,probe_command,probe_return,probe_result,probe_bank_error,probe_palette[64];
void main(void){
 DISPLAY_OFF;cpu_fast();VBK_REG=1;set_bkg_data(0,64,ui_font);SWITCH_ROM_MBC5(3);set_sprite_data(0,84,alis_tiles);
 SWITCH_ROM_MBC5(1);VBK_REG=0;probe_ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(probe_command){
  if(probe_command==1){DISPLAY_OFF;probe_result=myau_flight_begin(probe_return);DISPLAY_ON;}
  else if(probe_command==2)probe_result=myau_flight_tick();
  else{uint8_t i;DISPLAY_OFF;myau_battle_palette(probe_command==4);for(i=0;i<64u;++i){OCPS_REG=i;probe_palette[i]=OCPD_REG;}DISPLAY_ON;probe_result=1;}
  if(CURRENT_BANK!=1)probe_bank_error=1;probe_command=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/myau-flight';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN);rom=out/'flight-probe.gbc'
 names=('myau_flight.c','myau_flight_data.c','myau_flight_bank_131.c','scene.c','palette_commit.c','scene_data.c','scene_actor.c','scene_actor_data.c','bank_io.c','font.c','assets_sprites.c')
 sources=[out/'main.c']+[ROOT/'src'/n for n in names]+sorted((ROOT/'src').glob('scene_bank_*.c'))+sorted((ROOT/'src').glob('scene_actor_bank_*.c'))
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 data=(ROOT/'assets/myau-flight/flight.bin').read_bytes();manifest=json.loads((ROOT/'assets/myau-flight/manifest.json').read_text());counts={'routes':0,'source_ticks':0,'pose_updates':0,'oam_records':0}
 def command(c):
  e.memory[sym['probe_command']]=c
  for _ in range(600):
   e.tick(1)
   if not e.memory[sym['probe_command']]:break
  else:raise AssertionError('Flight probe timeout')
  assert not e.memory[sym['probe_bank_error']];return e.memory[sym['probe_result']]
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[0,0x8000:0x8800])+bytes(e.memory[1,0x8000:0x8540])
 try:
  e.tick(180);assert e.memory[sym['probe_ready']];keep=protected()
  for returning in (0,1):
   e.memory[sym['probe_return']]=returning;assert command(1)==1;assert protected()==keep
   assert bytes(e.memory[1,0x8540:0x8540+manifest['tiles']*16])==data[:manifest['tiles']*16]
   # Direct source actor15 init then actor16 counter/branch simulation.
   mode=21;delay=counter=0;x=y=pose=0;frame=0;finished=False
   while not finished:
    frame+=1
    if mode==21:x=80 if returning else 208;y=48 if returning else 136;pose=base=4 if returning else 0;mode=22;changed=True
    elif mode==0:finished=True;changed=False
    else:
     delay-=1;changed=delay<0
     if changed:
      delay=7;pose=base+(counter&3);counter=(counter+1)&255
      if returning:
       y+=1
       if y==0x78:mode=0
       elif not y&7:x-=1
      else:
       x-=1;y-=1
       if x==0x90:mode=0
    assert command(2)==int(finished),(returning,frame,mode)
    assert read_word(e,sym['myau_flight_frame'])==frame;counts['source_ticks']+=1
    if changed:counts['pose_updates']+=1
    record=manifest['frames'][pose];meta=data[record['offset']:record['offset']+record['sprites']*4]
    # Allow the following VBlank to DMA shadow OAM; this is not another actor tick.
    e.tick(1)
    for n in range(record['sprites']):
     xx,yy,tile,attr=meta[n*4:n*4+4];expected=(y*5//8+yy,x*5//8+xx,84+tile,attr)
     assert tuple(e.memory[0xfe00+n*4:0xfe04+n*4])==expected,(returning,frame,n,expected)
     counts['oam_records']+=1
    if frame in (1,2,250,506,570):e.screen.image.save(out/f'route{returning}-{frame:03}.png')
   assert frame==(571 if returning else 507);assert protected()==keep;counts['routes']+=1
  command(3);assert bytes(e.memory[sym['probe_palette']:sym['probe_palette']+64])==bytes([0,124])*32
  command(4);offset=manifest['battle_palette_offset'];assert bytes(e.memory[sym['probe_palette']:sym['probe_palette']+64])==data[offset:offset+64]
  report={'passed':True,'header':cartridge_header(rom),**counts,'limits':['Logical actor ticks tested independently from production UI cadence','Source soundB9/fades and GoldDragon battle belong to outer sequence','Original anchors are scaled5/8 to native viewport']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
