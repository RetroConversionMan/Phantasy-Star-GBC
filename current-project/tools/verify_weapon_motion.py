#!/usr/bin/env python3
"""Weapon actor cadence compared with original Z80 mode11/12 code."""
import ctypes,hashlib,json,os,subprocess
import z80
from extract_scenes import ROOT,label
class Motion(ctypes.Structure):
 _fields_=[(n,ctypes.c_uint8)for n in ('effect','frame','timer','speed','end','phase','active')]
class Reference:
 def __init__(self,rom,effect):
  c=self.cpu=z80.Z80Machine();c.memory[:0x8000]=rom[:0x8000];c.memory[0x8000:0xc000]=rom[3*16384:4*16384];c.set_breakpoint(0x100);c.set_breakpoint(label('LABEL_3FA'))
  c.memory[0xc800]=11;c.memory[0xc80a]=effect;c.memory[0xc894]=87;c.memory[0xc895]=124
 def tick(self):
  c=self.cpu;c.pc=label('LABEL_5B87')if c.memory[0xc800]==11 else label('LABEL_5BCE');c.iy=0xc800;c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';c.ticks_to_stop=100000
  for _ in range(20):
   c.run()
   if c.pc==0x100:return
   if c.pc==label('LABEL_3FA'):
    # Graphics decompression/VDP upload is verified by asset tests. The original
    # init handler is otherwise executed, including its hidden initial frame.
    c.pc=c.memory[c.sp]|(c.memory[c.sp+1]<<8);c.sp+=2
  raise AssertionError('Source weapon actor did not return')
def main():
 out=ROOT/'build/verification/weapon-motion';out.mkdir(parents=True,exist_ok=True);libpath=out/'weapon.dylib'
 files=['src/battle_weapon.c','src/bank_io.c']+[str(p.relative_to(ROOT))for p in sorted((ROOT/'src').glob('weapon_bank_*.c'))]
 subprocess.run([os.environ.get('CC','cc'),'-std=c99','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas','-O2','-shared','-fPIC','-Isrc',*files,'-o',str(libpath)],cwd=ROOT,check=True)
 lib=ctypes.CDLL(str(libpath));lib.battle_weapon_asset.restype=ctypes.c_uint16
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();manifest=json.loads((ROOT/'assets/weapon-effects/manifest.json').read_text());checks=0;cases=[]
 for effect in range(19):
  m=Motion();assert lib.battle_weapon_begin(ctypes.byref(m),effect);ref=Reference(rom,effect);frames=0;visible=[]
  while ref.cpu.memory[0xc800]:
   ref.tick();flags=lib.battle_weapon_tick(ctypes.byref(m));frames+=1;c=ref.cpu
   assert (m.frame,m.timer,m.speed,m.end)==(c.memory[0xc801],c.memory[0xc80e],c.memory[0xc818],c.memory[0xc80f]),(effect,frames,bytes(m))
   assert bool(flags&1)==bool(c.a and frames>1 and m.timer==m.speed),(effect,frames,flags,c.a)
   if flags&1:visible.append((frames,m.frame))
   if frames==1:assert flags==2 and not c.a and lib.battle_weapon_sound(effect)==c.memory[0xc004]
   checks+=3;assert frames<100
  assert flags==4 and m.phase==2;assert lib.battle_weapon_tick(ctypes.byref(m))==8 and not m.active;checks+=2
  cases.append({'effect':effect,'frames':frames+1,'visible_frame_changes':visible})
 for r in manifest['records']:
  assert lib.battle_weapon_asset(r['enemy'],r['frame'])==r['asset'];checks+=1
 for effect in (19,255):
  m=Motion();assert not lib.battle_weapon_begin(ctypes.byref(m),effect);assert lib.battle_weapon_sound(effect)==0;checks+=2
 assert lib.battle_weapon_asset(0,6)==65535 and lib.battle_weapon_asset(75,6)==65535 and lib.battle_weapon_asset(1,0)==65535;checks+=3
 report={'passed':True,'checks':checks,'effects':19,'source_actor_updates':sum(c['frames']-1 for c in cases),'asset_lookups':len(manifest['records']),'source_sha256':hashlib.sha256(rom).hexdigest(),'cases':cases,'scope':'Original5B87 initialization and5BCE update state every tick; bypasses3FA graphics upload only. Native rendering and battle choreography tested separately.'}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='cases'},indent=2))
if __name__=='__main__':main()
