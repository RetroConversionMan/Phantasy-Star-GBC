#!/usr/bin/env python3
"""Cycle-profile an isolated copy of the verified native dungeon renderer.

Only symbol visibility and zero-instruction labels change in the diagnostic
uploader. Production sources, canonical ROMs and common reports are untouched.
"""
import argparse,collections,hashlib,json,pickle,re,shutil,statistics,subprocess
from pathlib import Path
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header
from verify_dungeon_motion import MAIN
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/verification/dungeon-motion-profile'
FROZEN=ROOT/'build/source-snapshots/dungeon-motion-candidate/src'

def main():
 global OUT
 parser=argparse.ArgumentParser();parser.add_argument('--native-blocks',action='store_true');parser.add_argument('--continuous',action='store_true');parser.add_argument('--standing-wait',action='store_true');args=parser.parse_args()
 if args.native_blocks:OUT=ROOT/'build/verification/dungeon-native-blocks'
 if args.standing_wait:OUT=OUT.with_name(OUT.name+'-standing-wait');args.continuous=True
 elif args.continuous:OUT=OUT.with_name(OUT.name+'-continuous')
 OUT.mkdir(parents=True,exist_ok=True);source=OUT/'src';source.mkdir(exist_ok=True)
 names=['dungeon_motion.c','dungeon_motion_data.c','dungeon_motion_upload.c','dungeon.c','dungeon_data.c','dungeon_view.c','dungeon_upload.c','dungeon_production_data.c','dungeon_production_tables.c','bank_io.c','font.c','audio.c','audio_tables.c','audio_data.c','audio_low_62.c','audio_low_63.c','audio_irq.c']
 names += [p.name for p in sorted(FROZEN.glob('dungeon_motion_bank_*.c'))]
 for p in [FROZEN/n for n in names]+list(FROZEN.glob('*.h')):shutil.copyfile(p,source/p.name)
 data=pickle.load(open(ROOT/'build/verification/dungeon-motion/source-data.pkl','rb'))
 if args.native_blocks:
  from experiment_dungeon_native_blocks import install
  names+=install(source,data)
 p=source/'dungeon_motion_upload.c';original=p.read_text();text=original
 for name in('expand_blocks','convert_map','upload_patterns','pack_map','maps'):
  text=text.replace('static void '+name+'(', 'void '+name+'(')
 def marker(name):return '\n    __asm\n    .globl _profile_'+name+'\n_profile_'+name+':\n    __endasm;\n'
 text=text.replace('    maps(target_map?0x9c00u:0x9800u);','    maps(target_map?0x9c00u:0x9800u);'+marker('maps_done'))
 text=text.replace('    if(target_map)LCDC_REG|=LCDCF_BG9C00;',marker('wait_done')+'    if(target_map)LCDC_REG|=LCDCF_BG9C00;')
 text=text.replace('dungeon_motion_buffer=target_pattern;dungeon_motion_active=1;SHOW_BKG;DISPLAY_ON;','dungeon_motion_buffer=target_pattern;dungeon_motion_active=1;SHOW_BKG;DISPLAY_ON;'+marker('pose_done'))
 p.write_text(text)
 # The production uploader's legacy diagnostic counter is normally defined
 # by dungeon_upload.c, which remains linked here. The MAIN owns shared buffers.
 main_text=MAIN.replace('while(1){vsync();if(command||free_run){','while(1){if(!free_run)vsync();if(command||free_run){')if args.continuous else MAIN
 if args.standing_wait:main_text=main_text.replace('result=dungeon_motion_render_image(free_images[free_index++],palette_index);','image=free_images[free_index++];result=dungeon_motion_render_image(image&32767u,palette_index);if(image&32768u)vsync();')
 (source/'main.c').write_text(main_text)
 rom=OUT/'profile.gbc'
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-DPS_DUNGEON_LEAN','-DPS_DUNGEON_MOTION','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-I'+str(source.relative_to(ROOT)),'-o',str(rom.relative_to(ROOT)),str((source/'main.c').relative_to(ROOT)),*[str((source/n).relative_to(ROOT))for n in names]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0)
 path=json.loads((ROOT/'build/verification/dungeon-motion/quick-report.json').read_text())['source_path'];data=pickle.load(open(ROOT/'build/verification/dungeon-motion/source-data.pkl','rb'))
 samples=[];current=None;record=False;kind='';trace=[]
 order=['render','begin','expand','variant','patterns','pack','maps','maps_done','wait_done','pose_done']
 labels={'render':'dungeon_motion_render_image','begin':'dungeon_motion_upload_begin','expand':'dungeon_motion_expand_map','variant':'dungeon_motion_prepare_variant','patterns':'upload_patterns','pack':'pack_map','maps':'maps','maps_done':'profile_maps_done','wait_done':'profile_wait_done','pose_done':'profile_pose_done'}
 if args.native_blocks:order.remove('variant');labels.pop('variant');labels['expand']='dungeon_motion_expand_native'
 def word(name,value=None):
  p=sym[name]
  if value is not None:e.memory[p]=value&255;e.memory[p+1]=value>>8
  return e.memory[p]|e.memory[p+1]<<8
 def hook(point):
  nonlocal current
  if not record:return
  if point=='render':current={'kind':kind,'points':{},'ordinal':len(samples),'start_audio':word('audio_frames')}
  if current is None:return
  current['points'][point]=e._cycles();trace.append((len(samples),point,e._cycles(),e.memory[0xff44]))
  if point=='pose_done':
   assert list(current['points'])==order,list(current['points'])
   current['dirty_patterns']=word('dungeon_motion_uploaded');current['pattern_buffer']=e.memory[sym['dungeon_motion_buffer']]
   current['audio_ticks']=(word('audio_frames')-current.pop('start_audio'))&65535;samples.append(current);current=None
 for point,label in labels.items():
  address=sym[label];e.hook_register(address>>16,address&65535,lambda context:hook(context),point)
 def command(value):
  e.memory[sym['command']]=value
  for _ in range(200):
   e.tick(1)
   assert not e.memory[sym['audio_fault']] and not e.memory[sym['dungeon_motion_fault']]
   if not e.memory[sym['command']]:return
  raise AssertionError('profile command timed out')
 try:
  e.tick(180);assert e.memory[sym['ready']];c=e._cycles();e.tick(10);frame_cycles=(e._cycles()-c)//10;assert frame_cycles==140448,frame_cycles
  e.memory[0xdc00:0xdc40]=[0xa5]*64;e.memory[sym['palette_index']]=path['palette'];word('image',path['frames'][0]['image']);command(1)
  # Warm the actual fixed-palette image sequence, then profile the identical
  # free-running sequence. No inserted pause separates successive poses.
  for pass_index in range(2):
   for i,frame in enumerate(path['frames']):
    number=frame['image']|(32768 if args.standing_wait and not frame['frame']else 0);p=sym['free_images']+i*2;e.memory[p]=number&255;e.memory[p+1]=number>>8
   e.memory[sym['free_index']]=0;e.memory[sym['free_run']]=1;kind='source_path';record=bool(pass_index)
   for _ in range(1000):
    e.tick(1)
    assert bytes(e.memory[0xdc00:0xdc40])==bytes([0xa5])*64
    if not e.memory[sym['free_run']]:break
   else:raise AssertionError('profile path timed out')
  record=False;word('image',path['frames'][-1]['image']);command(2);command(2)
  kind='same_image';record=True
  for _ in range(4):command(2)
  record=False
 finally:e.stop(False)
 phases={'palette_and_entry':('render','begin'),'begin_cache':('begin','expand'),'block_expansion':('expand','variant'),'variant_conversion':('variant','patterns'),'pattern_uploads':('patterns','pack'),'map_packing':('pack','maps'),'map_uploads':('maps','maps_done'),'final_VBlank_wait':('maps_done','wait_done'),'commit_palette_and_registers':('wait_done','pose_done')}
 if args.native_blocks:phases.pop('block_expansion');phases.pop('variant_conversion');phases['native_block_expansion']=('expand','patterns')
 for sample in samples:
  sample['cycles']={name:sample['points'][b]-sample['points'][a]for name,(a,b)in phases.items()};sample['total_cycles']=sample['points']['pose_done']-sample['points']['render'];sample['frame_equivalents']=round(sample['total_cycles']/frame_cycles,4)
  if sample['kind']=='source_path':sample.update({k:v for k,v in path['frames'][sample['ordinal']].items()if k in('operation','frame','image')})
 summary={}
 for kind in('source_path','same_image'):
  group=[p for p in samples if p['kind']==kind]
  summary[kind]={'poses':len(group),'mean_dirty_patterns':statistics.mean(p['dirty_patterns']for p in group),'mean_frame_equivalents':statistics.mean(p['frame_equivalents']for p in group),'mean_cycles':{phase:round(statistics.mean(p['cycles'][phase]for p in group),1)for phase in phases}}
 # Extra gap includes the source caller's VBlank and geometry work; renderer
 # phase intervals above include real IRQ and HBlank stalls in their own phase.
 group=[p for p in samples if p['kind']=='source_path']
 summary['source_path']['mean_gap_after_pose_cycles']=statistics.mean(b['points']['render']-a['points']['pose_done']for a,b in zip(group,group[1:]))
 notes=['Isolated diagnostic copy only; production sources are unchanged. Symbol exports and zero-instruction profiling labels add no emulated instructions.','Measured emulator CPU cycle counter includes actual score IRQ and HBlank DMA stalls.','This diagnostic is not a replacement for source-image/PPU correctness tests.']
 if args.native_blocks:notes.append('Experimental palette-specific native blocks combine map expansion and variant conversion.')
 if args.continuous:notes.append('Experimental free-running caller omits the second VBlank wait after the uploader has already committed a complete image.')
 if args.standing_wait:notes.append('Narrower production proposal retains the extra final VBlank for every frame0, preserving standing before callbacks.')
 report={'passed':True,'diagnostic_header':cartridge_header(rom),'production_reference':'30fcd2fe47b494532202629444ace2aa25cc881fec2ea8273a70258f29bad9f5','original_uploader_sha256':hashlib.sha256(original.encode()).hexdigest(),'diagnostic_uploader_sha256':hashlib.sha256(text.encode()).hexdigest(),'extra_production_WRAM':0,'native_blocks_experiment':args.native_blocks,'continuous_caller':args.continuous,'CPU_cycles_per_physical_frame':frame_cycles,'source_palette':path['palette'],'summary':summary,'poses':samples,'notes':notes}
 (OUT/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='poses'},indent=2))
if __name__=='__main__':main()
