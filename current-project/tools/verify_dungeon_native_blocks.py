#!/usr/bin/env python3
"""Exhaustive native-block experiment comparison without production mutation."""
import argparse,collections,hashlib,json,pickle,struct,time
from pathlib import Path
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'build/verification/dungeon-native-blocks'
def main():
 global OUT
 parser=argparse.ArgumentParser();parser.add_argument('--directory');parser.add_argument('--path-only',action='store_true');parser.add_argument('--standing-wait',action='store_true');args=parser.parse_args()
 if args.directory:OUT=ROOT/'build/verification'/args.directory
 rom=OUT/'profile.gbc';s=load_symbols(rom.with_suffix('.noi'));data=pickle.load(open(ROOT/'build/verification/dungeon-motion/source-data.pkl','rb'))
 baseline=json.loads((ROOT/'build/verification/dungeon-motion/quick-report.json').read_text());path=baseline['source_path']
 e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0);counts=collections.Counter();timings=[]
 def word(name,value=None):
  p=s[name]
  if value is not None:e.memory[p]=value&255;e.memory[p+1]=value>>8
  return e.memory[p]|e.memory[p+1]<<8
 def command(value):
  e.memory[s['command']]=value
  for elapsed in range(200):
   e.tick(1)
   if not e.memory[s['command']]:break
  else:raise AssertionError(('timeout',word('image')))
  assert not e.memory[s['bank_error']]and not e.memory[s['audio_fault']]and not e.memory[s['dungeon_motion_fault']]
  assert bytes(e.memory[0xdc00:0xdc40])==bytes([0xa5])*64
  return elapsed+1
 def protected():return bytes(e.memory[1,0x8000:0x8800])+bytes(e.memory[1,0x9000:0x9400])
 try:
  e.tick(180);assert e.memory[s['ready']];e.memory[0xdc00:0xdc40]=[0xa5]*64;fixed=protected();start=time.monotonic()
  for palette in range(0 if args.path_only else 12):
   e.memory[s['palette_index']]=palette
   colors=(ROOT/f'assets/dungeon-graphics/dungeon_colors_{palette:02}.bin').read_bytes()[312:368]
   for image,rawmap in enumerate(data['tilemaps']):
    word('image',image);timings.append(command(1 if not counts['images'] else 2));assert e.memory[s['result']]==1
    base=0x9c00 if e.memory[0xff40]&8 else 0x9800;seen={}
    for n,raw in enumerate(rawmap):
     p=base+n//20*32+n%20;tile=e.memory[0,p];attr=e.memory[1,p];pattern,pal=data['variants'][palette][raw][:2]
     assert attr&247==pal,(palette,image,n,'palette',attr,pal)
     address=0x9000+tile*16 if tile<128 else 0x8800+(tile-128)*16;key=(attr>>3&1,address)
     if key not in seen:seen[key]=bytes(e.memory[key[0],address:address+16])
     assert seen[key]==data['patterns'][pattern],(palette,image,n,'native pattern',pattern,key)
    assert bytes(e.memory[s['palette']:s['palette']+56])==colors
    assert protected()==fixed
    counts['images']+=1;counts['tile_attributes']+=300;counts['pattern_bytes']+=len(seen)*16;counts['protected_bytes']+=len(fixed)
   print('palette',palette,'images',counts['images'],'elapsed',round(time.monotonic()-start,1),flush=True)
  e.memory[s['palette_index']]=path['palette'];wanted=[];keys={}
  for p in path['frames']:
   word('image',p['image']);command(2);e.tick(2);key=hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest();wanted.append(key);keys[key]=p['image']
  first=wanted[-1]
  for i,p in enumerate(path['frames']):
   number=p['image']|(32768 if args.standing_wait and not p['frame']else 0);a=s['free_images']+i*2;e.memory[a]=number&255;e.memory[a+1]=number>>8
  e.memory[s['free_index']]=0;e.memory[s['free_run']]=1;seen=[first];unknown=0;physical=0;irq=word('audio_frames')
  while e.memory[s['free_run']]and physical<1000:
   e.tick(1);physical+=1;key=hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest()
   unknown+=key not in keys
   if key!=seen[-1]:seen.append(key)
   assert e.memory[0xff40]&128 and not e.memory[s['audio_fault']]and not e.memory[s['dungeon_motion_fault']]
   assert bytes(e.memory[0xdc00:0xdc40])==bytes([0xa5])*64
  for _ in range(2):
   e.tick(1);key=hashlib.sha256(e.screen.ndarray.tobytes()).hexdigest();unknown+=key not in keys
   if key!=seen[-1]:seen.append(key)
  expected=[first]
  for k in wanted:
   if k!=expected[-1]:expected.append(k)
  assert seen==expected and not unknown,(len(seen),len(expected),unknown)
  ticks=(word('audio_frames')-irq)&65535;assert abs(ticks-(physical+2))<=2
  report={'passed':True,'header':cartridge_header(rom),'exhaustive_all_image_palette_pairs':not args.path_only,**counts,'command_frames':{'min':min(timings),'max':max(timings),'mean':sum(timings)/len(timings)}if timings else None,'source_path':{'poses':40,'physical_frames':physical,'audio_IRQ_ticks_including_two_drain_frames':ticks,'unmatched_frames':unknown,'visible_changes':len(seen)-1},'guard_bytes':64,'guard_address':'DC00','production_changed':False}
  (OUT/'verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
