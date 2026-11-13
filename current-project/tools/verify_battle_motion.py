#!/usr/bin/env python3
"""Ordinary enemy motion compared against original Z80 actor machine code."""
import ctypes,hashlib,json,os,subprocess
from pathlib import Path
import z80
from extract_scenes import ROOT,label
class Motion(ctypes.Structure):
 _fields_=[(s,ctypes.c_uint8) for s in ('enemy','frame','timer','cursor','phase','active')]
class Chest(ctypes.Structure):
 _fields_=[(s,ctypes.c_uint8) for s in ('frame','timer','visual','phase','active','hold','deferred')]
class Reference:
 def __init__(self,rom,enemy):
  self.cpu=z80.Z80Machine();self.cpu.memory[:0x8000]=rom[:0x8000];self.cpu.memory[0x8000:0xc000]=rom[3*16384:4*16384];self.cpu.set_breakpoint(0x100);self.cpu.set_breakpoint(label('WaitForVInt'))
  row=rom[label('B03_EnemyData')+enemy*32:][:32];d=rom[label('LABEL_B03_8FC7')+(row[19]-1)*24:][:24]
  self.cpu.memory[0xc880]=d[0];self.cpu.memory[0xc881]=d[1];self.cpu.memory[0xc88d]=1;self.cpu.memory[0xc88e]=d[8];self.cpu.memory[0xc894:0xc89d]=d[4:13];self.cpu.memory[0xc29f]=255
 def tick(self,address='LABEL_5DA0',actor=0xc880):
  waits=0;c=self.cpu;c.pc=label(address);c.iy=actor;c.sp=0xdffc;c.memory[0xdffc:0xdffe]=bytes([0,1]);c.ticks_to_stop=100000
  for _ in range(50):
   c.run()
   if c.pc==0x100:return waits
   if c.pc==label('WaitForVInt'):waits+=1;c.pc=label('LABEL_7BEE')
  raise AssertionError(('reference actor did not return',hex(c.pc)))
def main():
 out=ROOT/'build/verification/battle-motion';out.mkdir(parents=True,exist_ok=True);libpath=out/'motion.dylib'
 sources=['src/chest_motion.c','src/battle_motion.c','src/battle_animation_data.c','src/bank_io.c','src/enemy_magic.c']+[str(p.relative_to(ROOT))for p in sorted((ROOT/'src').glob('enemy_magic_bank_*.c'))]+[str(p.relative_to(ROOT)) for p in sorted((ROOT/'src').glob('battle_animation_bank_*.c'))]
 subprocess.run([os.environ.get('CC','cc'),'-std=c99','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas','-O2','-shared','-fPIC','-Isrc',*sources,'-o',str(libpath)],cwd=ROOT,check=True)
 lib=ctypes.CDLL(str(libpath));lib.battle_motion_asset.restype=ctypes.c_uint16
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();manifest=json.loads((ROOT/'assets/battle-animation/manifest.json').read_text());assert hashlib.sha256(rom).hexdigest()==manifest['source_sha256'];checks=0;cases=[]
 for enemy in range(1,75):
  m=Motion();valid=lib.battle_motion_begin(ctypes.byref(m),enemy)
  if enemy in(72,73):assert not valid;checks+=1;continue
  assert valid;ref=Reference(rom,enemy);impact=0;frames=0;trace=bytearray()
  while ref.cpu.memory[0xc29f]:
   oldphase=ref.cpu.memory[0xc88a]&1;ref.tick();flags=lib.battle_motion_tick(ctypes.byref(m));frames+=1
   assert (m.frame,m.timer,m.cursor)==(ref.cpu.memory[0xc881],ref.cpu.memory[0xc88e],ref.cpu.memory[0xc88d]),(enemy,frames,list(bytes(m)))
   phase=ref.cpu.memory[0xc88a]&1
   assert bool(flags&2)==bool(not oldphase and phase),(enemy,frames,flags,phase);impact+=bool(flags&2)
   assert m.active;trace.extend(bytes(m)+bytes([flags]));checks+=3
   assert frames<1000
  assert impact==1 and m.phase==2;assert lib.battle_motion_tick(ctypes.byref(m))==4 and not m.active;checks+=2
  cases.append({'enemy':enemy,'frames':frames+1,'impact_markers':impact,'trace_sha256':hashlib.sha256(trace).hexdigest()})
 for r in manifest['records']:
  assert lib.battle_motion_asset(r['enemy'],r['frame'],r['palette'])==r['asset'];checks+=1
 for e in (0,75,255):
  m=Motion();assert not lib.battle_motion_begin(ctypes.byref(m),e);assert lib.battle_motion_asset(e,0,0)==65535;checks+=2
 chest_cases=[]
 for visual in (0x3d,0x3e,0x43):
  ref=Reference(rom,1);c=ref.cpu;c.memory[0xc800]=14;c.memory[0xc801]=0x3a;c.memory[0xc80a]=1;c.memory[0xc80e]=7;c.memory[0xc80f]=visual
  expected=[];clock=0;lastframe=0x3a;flash=0
  while c.memory[0xc800]:
   clock+=1;waits=ref.tick('LABEL_5C99',0xc800);clock+=waits;flash+=waits
   if c.memory[0xc801]!=lastframe:expected.append((clock,c.memory[0xc801]));lastframe=c.memory[0xc801]
  duration=clock+1;m=Chest();lib.chest_motion_begin(ctypes.byref(m),visual);actual=[];clock=0;lastframe=m.frame
  while m.active:
   clock+=1;flags=lib.chest_motion_tick(ctypes.byref(m))
   if flags&1 and m.frame!=lastframe:actual.append((clock,m.frame));lastframe=m.frame
   assert clock<200
  assert actual==expected,(visual,actual,expected)
  assert clock==duration and flash==(0 if visual==0x3d else 10);checks+=2+len(actual)
  chest_cases.append({'visual':visual,'frames':clock,'flash_block_frames':flash,'frame_changes':actual})
 flash_cases=[]
 for start,count in ((19,13),(3,13),(3,14)):
  ref=Reference(rom,1);cpu=ref.cpu;original=bytes(range(32));cpu.memory[0xc240:0xc260]=original;cpu.memory[0xc220:0xc240]=original
  cpu.memory[0xc2be]=10;cpu.memory[0xc2c0]=start;cpu.memory[0xc2c1]=count;trace=[]
  for frame in range(1,11):
   assert ref.tick('LABEL_7BEE')==0
   expected=bytearray(original)
   if frame&1:expected[start:start+count]=bytes([63])*count
   assert bytes(cpu.memory[0xc220:0xc240])==expected
   assert cpu.memory[0xc2be]==10-frame;checks+=2;trace.append(list(expected))
  flash_cases.append({'first_source_index':start,'colors':count,'frames':10,'alternation':'white,original repeated5 times; final original'})
 report={'passed':True,'flash_cases':flash_cases,'checks':checks,'physical_enemies':len(cases),'source_actor_updates':sum(c['frames']-1 for c in cases),'asset_lookups':len(manifest['records']),'reference':'Pinned original Z80 LABEL5DA0/LABEL5DB1 machine code; compare frame,timer,sequence cursor and impact marker every actor update. C2ED0 isolates movement from native damage-flash subroutine. One final source VBlank added after actor exits.','cases':cases,'chest_cases':chest_cases,'scope':'Ordinary physical enemy attack motion and original safe/party/single chest frame timelines; excludes Lassic/Dark Falz special handlers, magic overlays, native VRAM timing and campaign playthrough.'}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='cases'},indent=2))
if __name__=='__main__':main()
