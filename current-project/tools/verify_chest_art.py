#!/usr/bin/env python3
"""Native chest OBJ/frame/palette/bank ownership verification."""
import hashlib,json,subprocess
from pyboy import PyBoy
from verify_scene_actors import MAIN as ACTOR_MAIN
from verify_rom import load_symbols,cartridge_header
from extract_chest_graphics import ROOT,SHA,Source,source_chest,convert

MAIN=ACTOR_MAIN.replace('#include "scene.h"','#include "scene.h"\n#include "chest_art.h"').replace(
 'probe_result=probe_kind?scene_enemy_show(probe_id,probe_floor_palette):scene_portrait_show(probe_id);',
 'probe_result=chest_show(probe_id);')

def main():
 out=ROOT/'build/verification/chest-art';out.mkdir(parents=True,exist_ok=True)
 manifest=json.loads((ROOT/'assets/chest-art/manifest.json').read_text());(out/'main.c').write_text(MAIN)
 original=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(original).hexdigest()==SHA
 source=Source(original)
 sources=[out/'main.c']+[ROOT/'src'/s for s in ('chest_art.c','scene_actor.c','scene_actor_data.c','bank_io.c','font.c','assets_sprites.c')]+sorted((ROOT/'src').glob('scene_actor_bank_*.c'))
 rom=out/'chest.gbc'
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo128','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 counts={'native_poses':0,'source_pixels':0,'native_pattern_bytes':0,'native_oam_records':0,'protected_bytes':0,'palette_bytes':0};timings=[]
 def palette():return bytes(e.memory[sym['probe_palette']:sym['probe_palette']+64])
 def protected():return bytes(e.memory[0,0x8000:0x9fff])+bytes(e.memory[1,0x8800:0x9fff])+bytes(e.memory[1,0x8000:0x8540])
 def command(number=1,expected=1):
  e.memory[sym['probe_command']]=number
  for ticks in range(600):
   e.tick(1)
   if not e.memory[sym['probe_command']]:break
  else:raise AssertionError('Chest upload timed out')
  timings.append(ticks+1);assert e.memory[sym['probe_result']]==expected
 try:
  e.tick(180);assert e.memory[sym['probe_ready']]==1;baseline=protected();baseline_palette=palette()
  for record in manifest['records']:
   frame=record['frame'];image,source_record=source_chest(source,frame)
   gfx,meta,colors,expected,errors=convert(image);data=gfx+meta+colors
   assert data==(ROOT/'assets/chest-art'/f'{frame:02x}.bin').read_bytes()
   assert hashlib.sha256(data).hexdigest()==record['data_sha256']
   assert source_record['source_metatile_pointer']==record['source_metatile_pointer']
   counts['source_pixels']+=256*192
   e.memory[sym['probe_id']]=frame;command();assert e.memory[sym['scene_actor_active']]==1
   assert bytes(e.memory[1,0x8540:0x8540+len(gfx)])==gfx;counts['native_pattern_bytes']+=len(gfx)
   e.tick(2)
   for n in range(record['sprites']):
    x,y,tile,attribute=meta[n*4:n*4+4]
    assert bytes(e.memory[0xfe00+n*4:0xfe04+n*4])==bytes((y,x,84+tile,attribute)),(frame,n)
    counts['native_oam_records']+=1
   assert all(e.memory[0xfe00+n*4]==0 for n in range(record['sprites'],40))
   assert palette()==colors;counts['palette_bytes']+=64
   assert max(sum(meta[n*4+1]-16<=y<meta[n*4+1]-8 for n in range(record['sprites']))for y in range(144))<=10
   assert protected()==baseline;counts['protected_bytes']+=len(baseline);counts['native_poses']+=1
   e.screen.image.save(out/f'{frame:02x}-native.png');expected.save(out/f'{frame:02x}-expected-overlay.png')
   # Rejected frame IDs must leave visible state and palettes untouched.
   before=bytes(e.memory[0xfe00:0xfea0]);before_palette=palette()
   for invalid in (0,0x39,0x47,255):
    e.memory[sym['probe_id']]=invalid;command(expected=0);e.tick(2)
    assert bytes(e.memory[0xfe00:0xfea0])==before and palette()==before_palette
   command(2);e.tick(2);assert not e.memory[sym['scene_actor_active']] and palette()==baseline_palette
   assert all(e.memory[0xfe00+n*4]==0 for n in range(40))
  report={'passed':True,'header':cartridge_header(rom),**counts,'native_frames':{'min':min(timings),'max':max(timings)},
   'limits':['Isolated CGB actor probe with source-derived images, not full dungeon/battle presentation',
             'All source poses verified; original animation timing, sound and screen shake not implemented here']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
