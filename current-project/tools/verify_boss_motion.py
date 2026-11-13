#!/usr/bin/env python3
"""Every native actor19/20 update compared with original Z80 execution."""
import ctypes as C,hashlib,json,subprocess,struct
from PIL import Image
from extract_scenes import ROOT,SHA
from measure_boss_motion import BossReference
class Motion(C.Structure):
 _fields_=[(s,C.c_uint8)for s in('variant','frame','y','timer','cursor','phase','stage','stage_timer','patch','active')]
def main():
 out=ROOT/'build/verification/boss-motion';out.mkdir(parents=True,exist_ok=True);library=out/'boss.dylib'
 subprocess.run(['cc','-O2','-std=c99','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas','-shared','-fPIC','-Isrc','src/boss_motion.c','src/boss_effects_bank_254.c','src/boss_effects_bank_255.c','src/bank_io.c','-o',str(library)],cwd=ROOT,check=True)
 lib=C.CDLL(str(library));lib.boss_motion_asset.restype=C.c_uint16;rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 cases=[];checks=0
 for enemy,target,magic in[(72,t,0xc0)for t in range(4)]+[(73,0,0)]:
  m=Motion();assert lib.boss_motion_begin(C.byref(m),enemy,target);ref=BossReference(rom,enemy,target,magic);updates=0;impacts=[];patches=[]
  while ref.cpu.memory[0xc29f]:
   source=ref.step();flags=lib.boss_motion_tick(C.byref(m));updates+=1
   assert (m.frame,m.y,m.timer,m.cursor,m.phase)==tuple(source[k]for k in('frame','y','timer','cursor','phase')),(enemy,target,updates,list(bytes(m)),source)
   if enemy==73:assert (m.stage if m.stage!=5 else 0,m.stage_timer)==(source['stage'],source['stage_timer']);checks+=1
   assert bool(flags&2)==source['impact'];assert bool(flags&4)==(source['patch']is not None);checks+=3
   if flags&2:impacts.append(updates)
   if flags&4:assert (0xbf20,0xbf50,0xbf80)[m.patch]==source['patch'];patches.append([updates,m.patch]);checks+=1
  assert lib.boss_motion_tick(C.byref(m))==8 and not m.active;checks+=1
  cases.append({'enemy':enemy,'target':target,'updates':updates,'final_upload_frames':1,'impacts':impacts,'patches':patches})
 manifest=json.loads((ROOT/'assets/boss-effects/manifest.json').read_text())
 for pose in manifest['poses']:assert lib.boss_motion_asset(pose['enemy'],pose['frame'],pose['y'])==pose['asset'];checks+=1
 pixels=0;patterns=(ROOT/'assets/boss-effects/patterns.2bpp').read_bytes()
 for pose in manifest['poses']:
  data=(ROOT/f'assets/boss-effects/{pose["name"]}.bin').read_bytes();count=pose['sprites'];masks=data[count*5+64:count*5+80]
  indexed=Image.open(ROOT/f'assets/boss-effects/{pose["name"]}-source-indices.png').resize((160,120),Image.Resampling.NEAREST)
  for i in range(count):
   x,y,pair,prop=struct.unpack_from('<BBHB',data,i*5);pattern=patterns[pair*32:pair*32+32]
   for row in range(16):
    for col in range(8):
     if y-16+row>=120:continue
     r,g,b,a=indexed.getpixel((x-8+col,y-16+row));source_index=r//85+(g//85)*4+(b//85)*16
     code=((pattern[row*2]>>(7-col))&1)|(((pattern[row*2+1]>>(7-col))&1)<<1)
     assert bool(code)==bool(a),(pose['name'],'source alpha')
     if a:
      assert bool(masks[prop&7]>>code&1)==(source_index>=3)
      assert bool(masks[(prop&7)+8]>>code&1)==(source_index==0);pixels+=1
 report={'passed':True,'checks':checks,'source_sha256':SHA,'cases':cases,'asset_lookups':len(manifest['poses']),'source_alpha_and_flash_pixels':pixels,'scope':'Source actor19/20 control flow, including target-specific sequences, two-marker reset, Y changes and selected-bank24 patch pointers. Flash/HP refresh and VDP upload intercepted; native rendering verified separately.'};(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
