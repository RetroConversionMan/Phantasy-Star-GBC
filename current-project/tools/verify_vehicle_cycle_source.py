#!/usr/bin/env python3
"""Independent original7C18 state, command and color-write oracle."""
from pathlib import Path
import ctypes as C,hashlib,json,subprocess,sys
ROOT=next(p for p in Path(__file__).resolve().parents if(p/'upstream/ps1disasm/ps1original.sms').exists());WORK=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
import z80
from extract_assets import ROM_SHA256
class State(C.Structure):_fields_=[('phase',C.c_uint8),('clock',C.c_uint8)]
def main():
 out=WORK/'evidence';libpath=out/'vehicle-cycle.dylib';subprocess.run(['cc','-shared','-fPIC','-O2','-I'+str(WORK/'src'),str(WORK/'src/vehicle_cycle.c'),'-o',str(libpath)],check=True)
 lib=C.CDLL(str(libpath));lib.vehicle_cycle_step.argtypes=[C.POINTER(State),C.c_uint8,C.c_uint8];lib.vehicle_cycle_step.restype=C.c_uint8
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==ROM_SHA256
 cpu=z80.Z80Machine();cpu.memory[:0x8000]=rom[:0x8000];cpu.set_breakpoint(0x100);writes=[];cpu.set_output_callback(lambda p,v:writes.append((p&255,v)))
 def call():
  cpu.sp=0xdffc;cpu.memory[0xdffc:0xdffe]=b'\0\1';cpu.pc=0x7c18
  for _ in range(10):
   cpu.ticks_to_stop=100000;cpu.run()
   if cpu.pc==0x100:return
  raise AssertionError(hex(cpu.pc))
 checks=colors=0
 for mode in range(20):
  for phase in(0,1,2,3,127,255):
   for clock in(0,1,2,3,4,127,128,255):
    for remaining in(0,1,7,15):
     state=State(phase,clock);cpu.memory[0xc30e]=mode;cpu.memory[0xc30f]=phase;cpu.memory[0xc310]=clock
     for step in range(24):
      moving=remaining if step<12 else 0;cpu.memory[0xc265]=moving;cpu.memory[0xc004]=128;writes.clear();call()
      result=lib.vehicle_cycle_step(C.byref(state),mode,moving)
      assert bytes(state)==bytes(cpu.memory[0xc30f:0xc311]),(mode,phase,clock,remaining,step,'state')
      assert(result or 128)==cpu.memory[0xc004],(mode,phase,clock,remaining,step,'audio')
      if result:
       values=[v for p,v in writes if p==0xbe];start=(0x7c73 if mode==8 else 0x7c6d)+state.phase
       assert values==list(rom[start:start+3]),(mode,phase,clock,remaining,step,'colors',values)
       address=[v for p,v in writes if p==0xbf];assert address==[0x17 if mode==8 else 0x1d,0xc0]
       colors+=3
      checks+=1
 report=dict(passed=True,original_sha256=ROM_SHA256,steps=checks,source_palette_color_writes=colors,scope='Actual original7C18 including output ports; modes0..19, phase/clock byte edge cases, movement-to-stop. Ship16/17 full palette reuploads are observed but remain travel-render ownership.',persistence='Original5E8 clearsC300..C6FF; save/load copies this same1024-byte span, includingC30F/C310. No boarding, dismount, mapload or battle return code resets these bytes.')
 (out/'source-cycle.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
