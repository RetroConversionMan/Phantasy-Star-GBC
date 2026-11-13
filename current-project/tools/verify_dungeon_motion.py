#!/usr/bin/env python3
"""Native source-image/palette/VRAM checks for every dungeon motion geometry."""
import argparse,collections,hashlib,json,pickle,struct,subprocess,shutil
from pyboy import PyBoy
from extract_dungeon_graphics import ROOT,SHA,source_composite,indices_image
from verify_rom import load_symbols,cartridge_header
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "dungeon_motion.h"
#include "dungeon_render.h"
#include "dungeon_render_scratch.h"
#include "font.h"
#include "audio.h"
uint8_t dungeon_render_map[600],dungeon_render_palette[56];
DungeonRenderScratch dungeon_render_scratch;
DungeonState probe_state;
uint8_t ready,command,palette_index,frame,result,bank_error,palette[64],sequence,ordinal,free_run,free_index;
uint16_t image,scene_id,free_images[40];
void main(void){uint8_t i;
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;
 ((uint16_t *)dungeon_render_palette)[0]=0;((uint16_t *)dungeon_render_palette)[1]=0x7fff;
 ((uint16_t *)dungeon_render_palette)[2]=0x4210;((uint16_t *)dungeon_render_palette)[3]=0;
 set_bkg_palette(7,1,(uint16_t *)dungeon_render_palette);
 audio_install();audio_command(0x91);SWITCH_ROM_MBC5(1);SHOW_BKG;DISPLAY_ON;ready=1;
 while(1){vsync();if(command||free_run){
  if(free_run){result=dungeon_motion_render_image(free_images[free_index++],palette_index);if(free_index==40u)free_run=0;}
  else if(command==1){dungeon_motion_invalidate();result=dungeon_motion_render_image(image,palette_index);}
  else if(command==2)result=dungeon_motion_render_image(image,palette_index);
  else if(command==3){scene_id=dungeon_motion_scene(&probe_state,frame);result=dungeon_motion_turn_sequence(&probe_state,sequence);}
  else if(command==4)result=dungeon_motion_sequence_frame(sequence,ordinal);
  else if(command==5)dungeon_motion_home();
  if(CURRENT_BANK!=1)bank_error=1;
  if(!free_run)for(i=0;i<64u;++i){while(STAT_REG&2u);BCPS_REG=i;palette[i]=BCPD_REG;}
  command=0;
 }}
}
'''
def main():
 args=argparse.ArgumentParser();args.add_argument('--quick',action='store_true');args.add_argument('--skip-build',action='store_true');args=args.parse_args()
 out=ROOT/'build/verification/dungeon-motion';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 data=pickle.load(open(out/'source-data.pkl','rb'));manifest=json.loads((ROOT/'assets/dungeon-motion/manifest.json').read_text())
 source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(source).hexdigest()==SHA
 # Actual Naula floor19 geometry: forward twice, left, forward, backward,
 # right. Source6758 uses the old position until the final standing frame;
 # source6792 changes position before reverse frames, and turns rotate first.
 raw=(ROOT/'assets/dungeons/dungeon_layouts.bin').read_bytes()[19*128:20*128]
 layout=[n for byte in raw for n in(byte>>4,byte&15)]
 offsets=(ROOT/'assets/dungeons/dungeon_view_offsets.bin').read_bytes()
 image_ids={p:i for i,p in enumerate(data['indexed'])};position=0x13;direction=3;path=[]
 path_palette=(ROOT/'assets/dungeons/dungeon_floor_info.bin').read_bytes()[19*4+2]+1
 def source_image(frame):
  samples=[layout[(position+offsets[direction*16+n])&255]for n in range(16)]
  _,g,m=source_composite(source,frame,samples);return image_ids[indices_image(g,m)]
 initial_image=source_image(0)
 for operation in('forward','forward','left','forward','back','right'):
  if operation=='forward':
   destination=(position+offsets[direction*16+1])&255;assert not(layout[destination]&7)
   for frame in(1,2,3,4,5):path.append((operation,frame,source_image(frame)))
   position=destination;path.append((operation,0,source_image(0)))
  elif operation=='back':
   position=(position+offsets[direction*16+11])&255;assert not(layout[position]&7)
   for frame in(5,4,3,2,1,0):path.append((operation,frame,source_image(frame)))
  else:
   right=operation=='right';direction=(direction+(1 if right else -1))&3
   wall=layout[(position+offsets[direction*16+(12 if right else 13)])&255]&7
   front=layout[(position+offsets[direction*16+1])&255]&7
   sequence=(6 if right else 2)+2*bool(wall)+bool(front)
   for frame in manifest['sequences'][sequence]:
    if frame!=255:path.append((operation,frame,source_image(frame)))
 assert len(path)==40 and (position,direction)==(0x11,3)
 sources=[out/'main.c']+[ROOT/'src'/n for n in('dungeon_motion.c','dungeon_motion_data.c','dungeon_motion_upload.c','dungeon.c','dungeon_data.c','dungeon_view.c','dungeon_views.c','dungeon_upload.c','dungeon_graphics.c','bank_io.c','font.c','audio.c','audio_tables.c','audio_data.c','audio_low_62.c','audio_low_63.c','audio_irq.c')]
 sources+=sorted((ROOT/'src').glob('dungeon_motion_bank_*.c'))+sorted((ROOT/'src').glob('dungeon_views_*.c'))+sorted((ROOT/'src').glob('dungeon_graphics_*.c'))
 rom=out/'motion.gbc'
 if not args.skip_build:subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-DPS_DUNGEON_LEAN','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));assert sym['s__DATA']+sym['l__DATA']<0xdc00
 e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0)
 counts=collections.Counter();timings=[];screenkeys={}
 def word(name,value=None):
  p=sym[name]
  if value is not None:e.memory[p]=value&255;e.memory[p+1]=value>>8
  return e.memory[p]|e.memory[p+1]<<8
 def command(value):
  e.memory[sym['command']]=value
  for elapsed in range(180):
   e.tick(1)
   if not e.memory[sym['command']]:break
  else:raise AssertionError(('motion timed out',word('image')))
  assert not e.memory[sym['bank_error']]
  assert bytes(e.memory[0xdc00:0xdc40])==bytes([0xa5]*64), '1KiB stack-window guard changed'
  assert not e.memory[sym['audio_fault']]
  assert not e.memory[sym['dungeon_motion_fault']],('motion fault',word('image'),e.memory[sym['dungeon_motion_fault']])
  return elapsed+1
 def protected():return bytes(e.memory[1,0x8000:0x8800])+bytes(e.memory[1,0x9000:0x9400])
 try:
  e.tick(180);assert e.memory[sym['ready']];e.memory[0xdc00:0xdc40]=[0xa5]*64;audio_start=word('audio_frames');fixed=protected();ui=struct.pack('<4H',0,0x7fff,0x4210,0)
  # Every original sequence byte, including source terminators and invalid IDs.
  for seq,row in enumerate(manifest['sequences']):
   for ordinal,frame in enumerate(row):
    e.memory[sym['sequence']]=seq;e.memory[sym['ordinal']]=ordinal;command(4)
    assert e.memory[sym['result']]==frame;counts['sequence_bytes']+=1
  for seq,ordinal in((10,0),(255,255),(0,9)):
   e.memory[sym['sequence']]=seq;e.memory[sym['ordinal']]=ordinal;command(4);assert e.memory[sym['result']]==255
  # The explicit wall/door frame must preserve the source cell's opened bit;
  # dungeon_sample intentionally masks it for collision callers.
  for direction in(0,3):
   for position in(0,255):
    for front in(0,1,4,7,132,134):
     state=bytearray(264);state[1]=position;state[2]=direction
     state[8+((position+offsets[direction*16+1])&255)]=front
     e.memory[sym['probe_state']:sym['probe_state']+264]=state;e.memory[sym['frame']]=6;command(3)
     samples=[0]*16;samples[1]=front;_,g,m=source_composite(source,6,samples)
     assert word('scene_id')==image_ids[indices_image(g,m)];counts['banked_door_selectors']+=1
  cases={(i,1)for i in range(manifest['images'])}
  # Every fixed turn frame, all palettes; moving geometry samples per depth.
  for palette in range(12):
   for frame in range(38):
    if frame==6:continue
    if frame<6:
     for case in(0,3,17,75,125,231):cases.add((manifest['lookup'][frame][case],palette))
    else:cases.add((manifest['fixed'][frame],palette))
  if args.quick:cases={(0,1),(241,3),(242,1),(474,11),(938,9),(1401,1),(1429,1),(0,0)}
  cases=sorted(cases)
  for number,(image,palette)in enumerate(cases):
   word('image',image);e.memory[sym['palette_index']]=palette;timings.append(command(1 if not number else 2));assert e.memory[sym['result']]==1
   base=0x9c00 if e.memory[0xff40]&8 else 0x9800;variant=data['variants'][palette];seen={}
   for n,raw in enumerate(data['tilemaps'][image]):
    p=base+n//20*32+n%20;tile=e.memory[0,p];attr=e.memory[1,p];pattern,pal=variant[raw][:2]
    assert attr&247==pal,(image,palette,n,'palette/flip/priority',attr,pal)
    address=0x9000+tile*16 if tile<128 else 0x8800+(tile-128)*16;key=(attr>>3&1,address)
    if key not in seen:seen[key]=bytes(e.memory[key[0],address:address+16])
    assert seen[key]==data['patterns'][pattern],(image,palette,n,pattern,'pattern')
    counts['map_attribute_pairs']+=1
   counts['pattern_bytes']+=len(seen)*16
   want=(ROOT/f'assets/dungeon-graphics/dungeon_colors_{palette:02}.bin').read_bytes()[312:368]
   assert bytes(e.memory[sym['palette']:sym['palette']+56])==want
   assert bytes(e.memory[sym['palette']+56:sym['palette']+64])==ui
   assert protected()==fixed;counts['protected_bytes']+=len(fixed);counts['palette_bytes']+=56;counts['images']+=1
   if palette==1:
    e.tick(2);screenkeys[image]=hashlib.sha256(e.screen.ndarray.tobytes()).digest()
   if number<8:e.screen.image.save(out/f'native-{image:04d}-p{palette:02d}.png')
  # Reject invalid input without mutating displayed VRAM or palette state.
  before=bytes(e.memory[0,0x8000:0x9fff])+bytes(e.memory[1,0x8000:0x9fff])
  for image,palette in((65535,0),(manifest['images'],1),(0,12)):
   word('image',image);e.memory[sym['palette_index']]=palette;command(2);assert not e.memory[sym['result']]
   assert bytes(e.memory[0,0x8000:0x9fff])+bytes(e.memory[1,0x8000:0x9fff])==before
  command(5);assert not(e.memory[0xff40]&8);assert protected()==fixed
  path_timings=[];path_hashes=[];expected_screens={};e.memory[sym['palette_index']]=path_palette
  def capture(image):
   word('image',image);elapsed=command(2);uploaded=word('dungeon_motion_uploaded');e.tick(2)
   key=hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest();expected_screens[key]=image
   return elapsed,uploaded,key
  _,_,initial_hash=capture(initial_image)
  for operation,frame,image in path:
   elapsed,uploaded,key=capture(image);path_timings.append({'operation':operation,'frame':frame,'image':image,'native_frames':elapsed,'dirty_patterns':uploaded});path_hashes.append(key)
  repeat=[]
  for _ in range(3):
   elapsed,uploaded,key=capture(path[-1][2]);repeat.append({'native_frames':elapsed,'dirty_patterns':uploaded})
  capture(initial_image)
  for i,(_,_,image)in enumerate(path):
   p=sym['free_images']+i*2;e.memory[p]=image&255;e.memory[p+1]=image>>8
  e.memory[sym['free_index']]=0;e.memory[sym['free_run']]=1
  physical=0;irq_begin=word('audio_frames');visible=[initial_hash];unmatched=collections.Counter()
  while e.memory[sym['free_run']] and physical<1000:
   e.tick(1);physical+=1;key=hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest()
   if key not in expected_screens:unmatched[key]+=1
   elif key!=visible[-1]:visible.append(key)
   assert e.memory[0xff40]&128,'LCD restarted during motion'
   assert not e.memory[sym['audio_fault']] and not e.memory[sym['dungeon_motion_fault']]
   assert bytes(e.memory[0xdc00:0xdc40])==bytes([0xa5]*64),'Audio/motion stack guard changed'
  # Drain the last PPU frame after the final VBlank map switch.
  for _ in range(2):
   e.tick(1);key=hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest()
   if key not in expected_screens:unmatched[key]+=1
   elif key!=visible[-1]:visible.append(key)
  expected=[initial_hash]
  for key in path_hashes:
   if key!=expected[-1]:expected.append(key)
  assert physical<1000 and visible==expected,('Source motion image order changed',len(visible),len(expected))
  assert not unmatched,('Partial/blank motion images reached PPU',sum(unmatched.values()))
  irq_ticks=(word('audio_frames')-irq_begin)&65535;assert abs(irq_ticks-(physical+2))<=2,(irq_ticks,physical)
  assert protected()==fixed
  report={'passed':True,'quick':args.quick,'header':cartridge_header(rom),**counts,'audio_irq_ticks':(word('audio_frames')-audio_start)&65535,'stack_guard_bytes':64,'stack_window':1024,'static_data_end':hex(sym['s__DATA']+sym['l__DATA']),'native_command_frames':{'min':min(timings),'max':max(timings),'mean':round(sum(timings)/len(timings),2)},'source_path':{'floor':19,'start_position':19,'start_direction':3,'palette':path_palette,'logical_frames':40,'free_running_frames':physical,'audio_irq_ticks':irq_ticks,'visible_changes':len(visible)-1,'unmatched_display_frames':sum(unmatched.values()),'frames':path_timings,'same_image_repeats':repeat},'limits':['Native renderer and original sequence table only; main-controller sequencing/event callbacks remain separate integration work.','HBlank DMA keeps the prior frame visible; original SMS60fps timing is not claimed.','Real audio IRQ and1KiB stack-window guard are exercised; full production battle/audio stack checks require the combined build.']}
  report_path=out/('quick-report.json'if args.quick else'report.json');report_path.write_text(json.dumps(report,indent=2)+'\n')
  if not args.quick:
   verified='motion-verified-'+report['header']['sha256'][:12];shutil.copyfile(rom,out/(verified+'.gbc'));shutil.copyfile(report_path,out/(verified+'.json'))
  print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
