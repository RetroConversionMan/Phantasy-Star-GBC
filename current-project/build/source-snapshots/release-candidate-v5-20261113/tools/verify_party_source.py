#!/usr/bin/env python3
"""Independent original Z80 actor/SAT oracle versus the native party kernel.

Only 7143 is stubbed: the test supplies accepted movement/C265 traces. Original
CA6, actor initialization, 576A sorting, 5A98 followers and 5853 SAT run intact.
Collision/control integration is tested separately against the full cartridge.
"""
from pathlib import Path
import ctypes as C,hashlib,json,subprocess,sys
ROOT=Path(__file__).resolve().parents[4];WORK=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
import z80
from extract_assets import ROM_SHA256
class Actor(C.Structure):_fields_=[(n,C.c_uint8)for n in ('identity','x','y','flags','phase','clock','frame','loaded','direction','previous')]
class State(C.Structure):_fields_=[('actors',Actor*4),('count',C.c_uint8),('road',C.c_uint8)]
# Production RPG records are packed on SM83; host RPGCharacter has 16-bit
# alignment. Define the identical host C ABI for the shared native kernel.
class Character(C.Structure):_fields_=[('status',C.c_uint8),('hp',C.c_uint8),('mp',C.c_uint8),('exp',C.c_uint16)]+[(n,C.c_uint8)for n in('level','max_hp','max_mp','attack','defense','weapon','armor','shield','bound','battle_magic_count','map_magic_count')]
class RPG(C.Structure):_fields_=[('party',Character*4),('inventory',C.c_uint8*24),('inventory_count',C.c_uint8),('joined_mask',C.c_uint8),('money',C.c_uint16),('rng',C.c_uint16)]
def call(c,pc):
 c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\x00\x01';c.pc=pc
 for _ in range(10):
  c.ticks_to_stop=1000000;c.run()
  if c.pc==0x100:return
 raise AssertionError(('original timeout',hex(pc),hex(c.pc)))
def original(rom,mask,road):
 c=z80.Z80Machine();c.memory[:0x8000]=rom[:0x8000];c.memory[0x8000:0xc000]=rom[3*16384:4*16384]
 c.memory[0x7143]=0xc9;c.memory[0xc2ea]=road;c.memory[0xc2e9]=bool(road)
 for i in range(4):c.memory[0xc400+i*16]=1 if mask>>i&1 else 0
 c.set_breakpoint(0x100);call(c,0xca6);call(c,0x576a);return c
def compare(c,s,case):
 fields={'x':4,'y':2,'flags':10,'phase':13,'clock':14,'frame':16,'direction':18,'previous':19}
 for i in range(s.count):
  a=s.actors[i];base=0xc800+i*32
  assert a.identity==c.memory[base+1]-1,(case,'identity',i)
  for name,offset in fields.items():assert getattr(a,name)==c.memory[base+offset],(case,i,name,getattr(a,name),c.memory[base+offset])
 return (int.from_bytes(c.memory[0xc217:0xc219],'little')-0xc900)
def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==ROM_SHA256
 out=WORK/'evidence';libpath=out/'party.dylib'
 subprocess.run(['cc','-shared','-fPIC','-O2','-I'+str(WORK/'src'),str(WORK/'src/party_world.c'),'-o',str(libpath)],check=True)
 lib=C.CDLL(str(libpath));lib.party_reset.argtypes=[C.POINTER(State),C.POINTER(RPG),C.c_uint8];lib.party_step.argtypes=[C.POINTER(State),C.c_uint8,C.c_uint8,C.c_uint8]
 cases=steps=satbytes=0;sat_cases=[]
 # Straight lines, every turn, idle facing changes, blocked held directions,
 # simultaneous held bits, and long paths that wrap source byte coordinates.
 trace=[]
 for mask in(2,8,1,4,8,2,4,1,2,8,1,4):
  for _ in range(4):trace.extend((mask,15-i,mask)for i in range(16))
  trace.extend(((0,0,mask),(0,0,0),(0,0,15),(0,0,5)))
 for living in range(16):
  for road in(0,1,2,4,8):
   r=RPG();s=State()
   for i in range(4):r.party[i].status=1 if living>>i&1 else 0
   lib.party_reset(C.byref(s),C.byref(r),road);c=original(rom,living,road)
   compare(c,s,(living,road,'init'));cases+=1
   for n,(accepted,remaining,held)in enumerate(trace):
    c.memory[0xc264]=accepted;c.memory[0xc265]=remaining;c.memory[0xc204]=held
    call(c,0x576a);lib.party_step(C.byref(s),accepted,remaining,held);count=compare(c,s,(living,road,n))
    sat=bytes(c.memory[0xc900:0xc900+count])+bytes(c.memory[0xc980:0xc980+count*2])
    satbytes+=len(sat);steps+=1
    if living==15 and road==0 and n%16==0:sat_cases.append(dict(step=n,actors=[list(bytes(a))for a in s.actors],sat=sat.hex()))
 report=dict(passed=True,original_sha256=ROM_SHA256,reset_cases=cases,source_actor_steps=steps,SAT_bytes=satbytes,runtime_bytes=C.sizeof(State),sat_cases=sat_cases,scope='Original 7143 is replaced by RET solely to supply accepted movement traces. All party packing, actor handlers and SAT production execute from the pinned original ROM.')
 (out/'source-oracle.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='sat_cases'}))
if __name__=='__main__':main()
