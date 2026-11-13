#!/usr/bin/env python3
"""Original Z80 alternate enemy movement and actor17/18 effect comparison."""
import ctypes as C,hashlib,json,subprocess
import z80
from extract_scenes import ROOT,label
from verify_battle_motion import Motion,Reference
class Effect(C.Structure):
 _fields_=[(n,C.c_uint8)for n in ('kind','frame','timer','speed','end','phase','active')]
class EffectReference:
 def __init__(self,rom,mode,blocked):
  c=self.cpu=z80.Z80Machine();c.memory[:0x8000]=rom[:0x8000];c.memory[0xc800]=17;c.memory[0xc88a]=0xc0 if mode else 0x80;c.memory[0xc896]=95;c.memory[0xc897]=124;c.memory[0xc2ef]=128 if blocked else 0
  for at in (0x100,label('LABEL_3FA'),label('LABEL_5E1D')):c.set_breakpoint(at)
 def tick(self):
  c=self.cpu;c.pc=label('LABEL_5E2E')if c.memory[0xc800]==17 else label('LABEL_5E72');c.iy=0xc800;c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1'
  impact=False
  for _ in range(20):
   c.ticks_to_stop=100000;c.run()
   if c.pc==0x100:return impact
   if c.pc==label('LABEL_5E1D'):impact=True
   assert c.pc in (label('LABEL_3FA'),label('LABEL_5E1D'))
   c.pc=c.memory[c.sp]|c.memory[c.sp+1]<<8;c.sp+=2
  raise AssertionError('Effect handler did not return')
def main():
 out=ROOT/'build/verification/enemy-magic';out.mkdir(parents=True,exist_ok=True);library=out/'motion.dylib'
 sources=['battle_motion.c','battle_animation_data.c','enemy_magic.c','bank_io.c']
 sources=[ROOT/'src'/s for s in sources]+sorted((ROOT/'src').glob('battle_animation_bank_*.c'))+sorted((ROOT/'src').glob('enemy_magic_bank_*.c'))
 subprocess.run(['cc','-std=c99','-O2','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas','-shared','-fPIC','-Isrc',*map(str,sources),'-o',str(library)],cwd=ROOT,check=True)
 lib=C.CDLL(str(library));lib.enemy_magic_asset.restype=lib.enemy_magic_pose.restype=C.c_uint16
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();manifest=json.loads((ROOT/'assets/enemy-magic/manifest.json').read_text());assert hashlib.sha256(rom).hexdigest()==manifest['source_sha256']
 checks=0;movement=[];effects=[]
 for record in manifest['motions']:
  enemy=record['enemy'];m=Motion();assert lib.battle_motion_begin_magic(C.byref(m),enemy);ref=Reference(rom,enemy);ref.cpu.memory[0xc88a]=128;frames=0;marker=0
  while ref.cpu.memory[0xc29f]:
   # The effect pauses the enemy actor externally. Here isolate its alternate
   # sequence while validating the exact effect spawn at the first marker.
   ref.cpu.memory[0xc800]=0;ref.tick();flags=lib.battle_motion_tick(C.byref(m));frames+=1
   assert (m.frame,m.timer,m.cursor)==(ref.cpu.memory[0xc881],ref.cpu.memory[0xc88e],ref.cpu.memory[0xc88d])
   assert bool(flags&2)==bool(ref.cpu.memory[0xc800]==17);marker+=bool(flags&2);checks+=2
   assert frames<1000
  assert marker==1 and lib.battle_motion_tick(C.byref(m))==4;checks+=1;movement.append({'enemy':enemy,'frames_excluding_effect_pause':frames+1})
 for mode,enemy in ((0,13),(1,56)):
  for blocked in (0,1):
   m=Effect();assert lib.enemy_magic_begin(C.byref(m),enemy);ref=EffectReference(rom,mode,blocked);frames=0;visible=[]
   while ref.cpu.memory[0xc800]:
    impact=ref.tick();flags=lib.enemy_magic_tick(C.byref(m));c=ref.cpu;frames+=1
    assert (m.frame,m.timer,m.speed,m.end)==(c.memory[0xc801],c.memory[0xc80e],c.memory[0xc818],c.memory[0xc80f]),(mode,frames,list(bytes(m)))
    assert bool(flags&4)==(not c.memory[0xc800]);assert impact==bool((flags&4)and not blocked);checks+=3
    if frames==1:assert flags==2 and c.a==0 and lib.enemy_magic_sound(C.byref(m))==c.memory[0xc004];checks+=1
    if flags&1:visible.append([frames,m.frame])
    assert frames<100
   assert not m.active and (not blocked or c.memory[0xc004]==0xbb);checks+=1
   effects.append({'kind':mode,'blocked':bool(blocked),'frames':frames,'visible_frame_changes':visible})
 for r in manifest['records']:
  actual=lib.enemy_magic_pose(r['enemy'],r['frame'],r['palette'])if r['kind']=='pose'else lib.enemy_magic_asset(r['enemy'],r['frame'])
  assert actual==r['asset'];checks+=1
 for enemy in (0,1,72,73,74,255):
  m=Effect();assert not lib.enemy_magic_begin(C.byref(m),enemy);assert lib.enemy_magic_asset(enemy,1)==65535;checks+=2
 report={'passed':True,'checks':checks,'source_sha256':manifest['source_sha256'],'movement':movement,'effects':effects,'asset_lookups':len(manifest['records']),'scope':'Original alternate mode15 motion and actor17/18 initialization/updates, with graphics upload and final impact flash/UI intercepted. Native art and full multi-hit controller choreography remain separate.'}
 (out/'motion-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
