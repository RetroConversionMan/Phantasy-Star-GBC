#!/usr/bin/env python3
"""Run the entire source-derived ending tail on the native CGB CPU and VDP."""
import hashlib,json,struct,subprocess,collections,pickle,shutil
from pathlib import Path
from pyboy import PyBoy
from extract_dungeon_graphics import ROOT,SHA
from verify_rom import load_symbols,cartridge_header
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "ending_walk.h"
#include "ending_upload.h"
#include "dungeon_render.h"
#include "dungeon_render_scratch.h"
#include "audio.h"
#include "font.h"
uint8_t dungeon_render_map[600],dungeon_render_palette[56];
DungeonRenderScratch dungeon_render_scratch;
uint8_t ready,command,light,result,bank_error,palette[64],sound_count,sound_commands[8],invalidations,free_run;
uint16_t sound_frames[8],probe_start,probe_end;
void dungeon_invalidate_view_cache(void) __nonbanked {++invalidations;}
void audio_command(uint8_t c) __banked {if(sound_count<8u){sound_commands[sound_count]=c;sound_frames[sound_count++]=ending_walk_frame;}}
void main(void){
 uint8_t i;DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;
 for(i=0;i<28u;++i)((uint16_t *)dungeon_render_palette)[i]=0;
 set_bkg_palette(0,7,(uint16_t *)dungeon_render_palette);
 ((uint16_t *)dungeon_render_palette)[0]=0;((uint16_t *)dungeon_render_palette)[1]=0x7fff;
 ((uint16_t *)dungeon_render_palette)[2]=0x4210;((uint16_t *)dungeon_render_palette)[3]=0;
 set_bkg_palette(7,1,(uint16_t *)dungeon_render_palette);
 SWITCH_ROM_MBC5(1);ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(command||free_run){
  if(command==1){sound_count=0;ending_walk_begin(light);result=0;}
  else result=ending_walk_tick();
  if(CURRENT_BANK!=1)bank_error=1;
  if(!free_run)for(i=0;i<64u;++i){while(STAT_REG&2u);BCPS_REG=i;palette[i]=BCPD_REG;}
  command=0;if(result)free_run=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/ending-walk';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 manifest=json.loads((ROOT/'assets/ending-walk/manifest.json').read_text())
 assert hashlib.sha256((ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()).hexdigest()==SHA
 sources=[out/'main.c']+[ROOT/'src'/n for n in('ending_walk.c','ending_walk_data.c','ending_upload.c','bank_io.c','font.c')]+sorted((ROOT/'src').glob('ending_walk_bank_*.c'))
 rom=out/'ending.gbc';subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-DPS_DUNGEON_LEAN','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'))
 for bank in manifest['banks']:
  if int(bank)==136:continue
  assert sym[f'ending_walk_bank_{bank}']&0xffff==0x4000,(bank,hex(sym[f'ending_walk_bank_{bank}']))
 e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 counts=collections.Counter();timings=[];images={};logical=[];expected_screens=collections.defaultdict(set)
 for image,lit,dark,n in manifest['runs']:logical.extend([(image,lit,dark)]*n)
 patterns=b''.join((ROOT/'assets/ending-walk'/f'ending_patterns_{i}.bin').read_bytes()for i in range(len(manifest['pattern_locations'])))
 def word(name):p=sym[name];return e.memory[p]|e.memory[p+1]<<8
 def command(c):
  e.memory[sym['command']]=c
  for elapsed in range(90):
   e.tick(1)
   if not e.memory[sym['command']]:break
  else:raise AssertionError(('ending timeout',word('ending_walk_frame')))
  assert not e.memory[sym['bank_error']]
  assert not e.memory[sym['ending_upload_fault']],('DMA crossed active display',word('ending_walk_frame'),e.memory[sym['ending_upload_fault']],e.memory[sym['ending_dma_before']],e.memory[sym['ending_dma_after']],e.memory[sym['ending_dma_count']])
  return elapsed+1
 def palette():return bytes(e.memory[sym['palette']:sym['palette']+64])
 try:
  e.tick(180);assert e.memory[sym['ready']];protected=bytes(e.memory[1,0x8000:0x8800])+bytes(e.memory[1,0x9000:0x9400]);ui=struct.pack('<4H',0,0x7fff,0x4210,0)
  for light in(1,0):
   e.memory[sym['light']]=light;timings.append(command(1));previous=None
   for frame,(image,lit,dark)in enumerate(logical):
    if frame:
     for _ in range(90):
      timings.append(command(2))
      if word('ending_walk_frame')==frame and not e.memory[sym['ending_walk_busy']]:break
     else:raise AssertionError(('image preparation stalled',frame))
    assert word('ending_walk_frame')==frame and not e.memory[sym['result']]
    colors=manifest['palettes'][lit if light else dark];want=struct.pack('<28H',*colors)
    assert palette()[:56]==want,(light,frame,'palette');counts['palette_bytes']+=56
    assert palette()[56:]==ui
    if previous!=image:
     raw=(ROOT/'assets/ending-walk'/f'ending_image_{image:03d}.bin').read_bytes();n=raw[0];commands=raw[1:1+n*6];tiles=raw[1+n*6:301+n*6];attrs=bytearray()
     encoded=raw[301+n*6:]
     for p in range(0,len(encoded),2):attrs.extend([encoded[p+1]]*encoded[p])
     assert len(attrs)==300
     active=e.memory[sym['ending_upload_buffer']]
     for p in range(0,len(commands),6):
      bank,shi,slo,dhi,dlo,count=commands[p:p+6];source=shi*256+slo;address=dhi*256+dlo;size=(count+1)*16
      assert not(source&15 or address&15) and source+size<=0x8000 and address+size<=0x9800
      pool=[row[0]for row in manifest['pattern_locations']].index(bank)
      wanted=patterns[pool*16384+source-0x4000:pool*16384+source-0x4000+size]
      first=((address-0x9000)&65535)//16&255
      for k in range(count+1):
       slot=first+k;vram=0;native_slot=slot
       if active:
        if slot<192:vram=1;native_slot=(slot+64)&255
        else:native_slot=209+slot-192
       dest=0x9000+native_slot*16 if native_slot<128 else 0x8800+(native_slot-128)*16
       assert bytes(e.memory[vram,dest:dest+16])==wanted[k*16:k*16+16],(light,frame,p,k,'DMA pattern group')

      counts['pattern_bytes']+=size

     for row in range(15):
      address=(0x9c00 if active else 0x9800)+row*32
      rowtiles=tiles[row*20:row*20+20];rowattrs=attrs[row*20:row*20+20]
      if active:
       rowattrs=bytes(a|(8 if t<192 else 0)for a,t in zip(rowattrs,rowtiles))
       rowtiles=bytes((t+64)&255 if t<192 else 209+t-192 for t in rowtiles)
      assert bytes(e.memory[0,address:address+20])==rowtiles,(frame,row,'map')
      assert bytes(e.memory[1,address:address+20])==rowattrs,(frame,row,'attrs')
      counts['map_attribute_pairs']+=20
     assert bytes(e.memory[1,0x8000:0x8800])+bytes(e.memory[1,0x9000:0x9400])==protected;counts['protected_vram_bytes']+=len(protected)
     previous=image;counts['image_changes']+=1
    if light and (not frame or logical[frame]!=logical[frame-1]):
     e.tick(2);expected_screens[hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest()].add(image)
    if light and frame in(0,29,47,253,1145,2152,3138,3319,3498):
     e.screen.image.save(out/f'frame-{frame:04d}.png')
    counts['logical_frames']+=1
   assert command(2) and e.memory[sym['result']] and word('ending_walk_frame')==3499
   assert e.memory[sym['sound_count']]==7
   sounds=[(e.memory[sym['sound_frames']+i*2]|e.memory[sym['sound_frames']+i*2+1]<<8,e.memory[sym['sound_commands']+i])for i in range(7)]
   assert sounds==[tuple(v)for v in manifest['audio']];counts['audio_commands']+=7
  # Run without command/diagnostic waits to measure native real-frame cadence.
  e.memory[sym['light']]=1;command(1);e.memory[sym['free_run']]=1
  physical=0;visible_images=set();unmatched=collections.Counter()
  while e.memory[sym['free_run']] and physical<20000:
   e.tick(1);physical+=1;key=hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest()
   if key in expected_screens:visible_images.update(expected_screens[key])
   else:unmatched[key]+=1
   assert e.memory[0xff40]&128, 'LCD restarted during motion'
   assert not e.memory[sym['ending_upload_fault']]
  assert visible_images==set(i for i,_,_ in logical),('Not all original images reached visible PPU output',sorted(set(i for i,_,_ in logical)-visible_images))
  assert physical<20000 and word('ending_walk_frame')==3499
  report={'passed':True,'header':cartridge_header(rom),**counts,'source_frames_per_run':3499,'free_running_emulator_frames':physical,'visible_native_images':len(visible_images),'unmatched_display_frames':sum(unmatched.values()),'double_buffered':True,'command_roundtrip_frames':{'min':min(timings),'max':max(timings)},'limits':manifest['limits']+['Standalone controller/render/audio-command probe; full main ending trigger and APU playback are separate integration checks.','The source trace is quantized and scaled; screenshot colors are not claimed pixel-identical to original SMS hardware.']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
  verified='ending-verified-'+report['header']['sha256'][:12]
  shutil.copyfile(rom,out/(verified+'.gbc'));shutil.copyfile(out/'report.json',out/(verified+'.json'))
  print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
