#!/usr/bin/env python3
"""Execute original Lassic/Dark Falz actor handlers; no battle outcome fixtures."""
import hashlib,json,struct
from extract_scenes import ROOT,SHA,Source,label,cpu_offset
from extract_weapon_effects import descriptor
from verify_battle_motion import Reference

def sequence(rom,pointer):
 start=cpu_offset(3,pointer);data=[rom[start]];markers=0
 while markers<2:
  value=rom[start+len(data)];data.append(value);markers+=value==0
  assert len(data)<64
 return data

class BossReference(Reference):
 def __init__(self,rom,enemy,target=0,magic=0):
  super().__init__(rom,enemy);self.rom=rom;self.enemy=enemy;d=descriptor(Source(rom),enemy);c=self.cpu
  c.memory[0xc882]=d[2];c.memory[0xc884]=d[3];c.memory[0xc88a]=magic;c.memory[0xc2ee]=target;c.memory[0xc2e6]=enemy;c.memory[0xc2ed]=1
  for at in(label('LABEL_5E1D'),label('LABEL_390')):c.set_breakpoint(at)
 def step(self):
  c=self.cpu;c.memory[0x8000:0xc000]=self.rom[3*16384:4*16384]
  c.pc=label('LABEL_5EAE'if self.enemy==72 else'LABEL_5EEA');c.iy=0xc880;c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';impact=False;patch=None
  for _ in range(8):
   c.ticks_to_stop=100000;c.run()
   if c.pc==0x100:return {'frame':c.memory[0xc881],'y':c.memory[0xc882],'timer':c.memory[0xc88e],'cursor':c.memory[0xc88d],'phase':c.memory[0xc88a]&1,'stage':c.memory[0xc88c],'stage_timer':c.memory[0xc88b],'active':bool(c.memory[0xc29f]),'impact':impact,'patch':patch}
   if c.pc==label('LABEL_5E1D'):impact=True
   elif c.pc==label('LABEL_390'):
    assert (c.de,c.bc)==(0x7a5c,0x0608);patch=c.hl
   else:raise AssertionError(('Unexpected boss hook',hex(c.pc)))
   c.pc=int.from_bytes(c.memory[c.sp:c.sp+2],'little');c.sp+=2
  raise AssertionError('Boss actor did not return')

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 cases=[]
 for enemy,target,magic in [(72,t,0xc0)for t in range(4)]+[(73,0,0)]:
  ref=BossReference(rom,enemy,target,magic);trace=[]
  while ref.cpu.memory[0xc29f]:
   trace.append(ref.step());assert len(trace)<300
  cases.append({'enemy':enemy,'target':target,'actor_updates':len(trace),'source_final_upload':1,'impact_updates':[i+1 for i,t in enumerate(trace)if t['impact']],'patch_updates':[(i+1,t['patch'])for i,t in enumerate(trace)if t['patch']is not None],'trace':trace})
 # Execute the original sorter/emission loop, intercepting only sprite writes.
 # Equal-Y actor4 must be emitted before actor5 and therefore win SMS OAM.
 c=Reference(rom,72).cpu;c.memory[0xc29f]=0;c.memory[0xc881]=236;c.memory[0xc882]=255
 c.memory[0xc8a0]=16;c.memory[0xc8a1]=203;c.memory[0xc8a2]=255;c.set_breakpoint(label('LABEL_5853'))
 c.pc=label('LABEL_576A');c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';order=[]
 for _ in range(4):
  c.ticks_to_stop=100000;c.run()
  if c.pc==0x100:break
  assert c.pc==label('LABEL_5853');order.append((c.iy-0xc800)//32);c.pc=int.from_bytes(c.memory[c.sp:c.sp+2],'little');c.sp+=2
 assert order==[4,5],order
 out=ROOT/'build/research/boss-motion';out.mkdir(parents=True,exist_ok=True)
 report={'source_sha256':SHA,'equal_Y_sprite_emission_order':order,'cases':cases,'scope':'Actual original actor19/20 updates. Source impact flash/HP refresh and VDP rectangle upload intercepted; ten flash waits and final upload remain caller timing.'}
 (out/'source-traces.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({**report,'cases':[{k:v for k,v in c.items()if k!='trace'}for c in cases]},indent=2))
if __name__=='__main__':main()
