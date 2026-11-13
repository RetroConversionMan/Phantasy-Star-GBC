#!/usr/bin/env python3
"""Source geometry/frame selection and real Z80 turn-script oracle checks."""
import ctypes as C,functools,hashlib,json,pickle,struct,subprocess
import z80
from extract_dungeon_graphics import ROOT,SHA,source_composite,indices_image,c_array
from extract_dungeon_views import scenes
from extract_scenes import label
class State(C.Structure):
 _fields_=[(n,C.c_uint8)for n in('floor','position','direction','light','encounter_rate','encounter_pool','palette_index','music')]+[('layout',C.c_uint8*256)]
def main():
 out=ROOT/'build/verification/dungeon-motion';out.mkdir(parents=True,exist_ok=True)
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 data=pickle.load(open(out/'source-data.pkl','rb'));images={p:i for i,p in enumerate(data['indexed'])}
 manifest=json.loads((ROOT/'assets/dungeon-motion/manifest.json').read_text())
 index=(ROOT/'assets/dungeon-views/dungeon_view_lookup.bin').read_bytes();front=(ROOT/'assets/dungeon-views/dungeon_front_lookup.bin').read_bytes()
 stub='#include "dungeon_motion_data.h"\n#include "dungeon_views.h"\n#include "dungeon_render.h"\n'+c_array('index_data',index)+c_array('front_data',front)
 stub+='const DungeonGraphicAsset dungeon_view_index={0,index_data},dungeon_view_front={0,front_data};\n'
 stub+='const DungeonGraphicAsset dungeon_view_maps[DUNGEON_VIEW_SCENES]={{0}},dungeon_view_variants[12][DUNGEON_VIEW_CHUNKS]={{{0}}},dungeon_graphic_palettes[12]={{0}};\n'
 stub+='const DungeonGraphicAsset motion_maps[MOTION_IMAGE_COUNT]={{0}},motion_variants[12]={{0}},motion_blocks[2]={{0}},motion_patterns[15]={{0}};\n'
 stub+='const uint16_t motion_lookup[6][243]={'+','.join('{'+','.join(map(str,row))+'}'for row in data['lookup'])+'};\n'
 stub+='const uint16_t motion_fixed[38]={'+','.join(map(str,data['fixed']))+'};\n'
 stub+='const uint8_t motion_sequences[10][9]={'+','.join('{'+','.join(map(str,row))+'}'for row in manifest['sequences'])+'};\n'
 stub+='uint8_t dungeon_render_map[600],dungeon_render_palette[56],dungeon_motion_fault,dungeon_motion_active,dungeon_motion_buffer;\nvoid dungeon_motion_upload_begin(void){}\nvoid dungeon_motion_expand_map(const DungeonGraphicAsset *a){(void)a;}\nvoid dungeon_motion_prepare_variant(const DungeonGraphicAsset *a){(void)a;}\nvoid dungeon_motion_upload_end(void){}\nvoid dungeon_motion_home(void){}\n'
 (out/'logic-stub.c').write_text(stub);library=out/'logic.dylib'
 subprocess.run(['cc','-std=c99','-O2','-shared','-fPIC','-D__banked=','-DPS_DUNGEON_LEAN','-Isrc','src/dungeon_motion.c','src/dungeon.c','src/dungeon_data.c','src/dungeon_view.c','src/bank_io.c',str(out/'logic-stub.c'),'-o',str(library)],cwd=ROOT,check=True)
 lib=C.CDLL(str(library));lib.dungeon_motion_scene.argtypes=[C.POINTER(State),C.c_uint8];lib.dungeon_motion_scene.restype=C.c_uint16
 lib.dungeon_motion_turn_sequence.argtypes=[C.POINTER(State),C.c_uint8];lib.dungeon_motion_turn_sequence.restype=C.c_uint8
 counts={'geometry_cases':0,'turn_oracle_cases':0};offsets=rom[label('LABEL_6C06'):label('LABEL_6C06')+64]
 @functools.lru_cache(None)
 def expected(frame,samples):
  _,g,m=source_composite(rom,frame,samples);return images[indices_image(g,m)]
 for samples in scenes():
  for direction in range(4):
   for position in(0,0x77,255):
    s=State();s.position=position;s.direction=direction
    for n,value in enumerate(samples):s.layout[(position+offsets[direction*16+n])&255]=value
    actual=tuple(s.layout[(position+offsets[direction*16+n])&255]for n in range(16))
    for frame in range(7):
     assert lib.dungeon_motion_scene(C.byref(s),frame)==expected(frame,actual),(frame,direction,position,samples)
     counts['geometry_cases']+=1
 for frame in range(7,38):
  s=State();assert lib.dungeon_motion_scene(C.byref(s),frame)==expected(frame,tuple([0]*16));counts['geometry_cases']+=1
 assert lib.dungeon_motion_scene(C.byref(s),38)==65535
 cpu=z80.Z80Machine();cpu.memory[:0x8000]=rom[:0x8000];cpu.set_breakpoint(0x100);answer=[]
 cpu.memory[label('LABEL_6A58'):label('LABEL_6A58')+3]=bytes((0xd3,0xfc,0xc9));cpu.set_output_callback(lambda p,v:answer.append(v))
 for right in(0,1):
  for direction in range(4):
   for position in(0,0x77,255):
    for wall in(0,1,7,8,0x80,0x81,0x87,0x88,255):
     for forward in(0,1,7,8,0x80,0x81,0x87,0x88,255):
      s=State();s.direction=(direction+(1 if right else -1))&3;s.position=position
      s.layout[(position+offsets[s.direction*16+1])&255]=forward
      s.layout[(position+offsets[s.direction*16+(12 if right else 13)])&255]=wall
      cpu.memory[0xcb00:0xcc00]=bytes(s.layout);cpu.memory[0xc30a]=direction;cpu.memory[0xc30c]=position
      cpu.pc=label('LABEL_67E2'if right else'LABEL_67B7');cpu.sp=0xdffc;cpu.memory[0xdffc:0xdffe]=b'\x00\x01';answer.clear()
      for _ in range(3):
       cpu.ticks_to_stop=50000;cpu.run()
       if cpu.pc==0x100:break
      assert cpu.pc==0x100 and len(answer)==1 and cpu.memory[0xc30a]==s.direction,(right,direction,position,wall,forward,cpu.pc,answer)
      assert lib.dungeon_motion_turn_sequence(C.byref(s),right)==answer[0];counts['turn_oracle_cases']+=1
 report={'passed':True,'source_sha256':SHA,**counts,'reference':'Source6AED/6C46 layer composition and actual Z8067B7/67E2 turn selectors;6A58 is a capture endpoint.'}
 (out/'logic-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
