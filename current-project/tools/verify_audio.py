#!/usr/bin/env python3
"""Compare native score driver against ORIGINAL Z80 ROM machine code per frame."""
from pathlib import Path
import ctypes,hashlib,json,subprocess,os,re
import z80
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/verification/audio'
class Reference:
 def __init__(self):
  self.cpu=z80.Z80Machine();self.writes=[]
  rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
  self.cpu.memory[:0x8000]=rom[:0x8000];self.cpu.memory[0x8000:0xc000]=rom[12*16384:13*16384]
  self.cpu.set_breakpoint(0x100)
  self.cpu.set_output_callback(lambda p,v:self.writes.append(v) if p&255==0x7f else None)
  self.call(0x8000);self.cpu.memory[0xc004]=0x80
 def call(self,address):
  self.writes.clear();self.cpu.pc=address;self.cpu.sp=0xdffc;self.cpu.memory[0xdffc:0xdffe]=bytes([0,1]);self.cpu.ticks_to_stop=500000
  for _ in range(30):
   event=self.cpu.run()
   if self.cpu.pc==0x100:return
  raise AssertionError(('Z80 sound driver did not return',hex(self.cpu.pc),event))
 def tick(self,command=None):
  if command is not None:self.cpu.memory[0xc004]=command
  self.call(0x8043)
  return bytes(self.writes),bytes(self.cpu.memory[0xc000:0xc200])
def main():
 OUT.mkdir(parents=True,exist_ok=True);libpath=OUT/'audio-test.dylib'
 subprocess.run([os.environ.get('CC','cc'),'-std=c99','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas','-O2','-shared','-fPIC','-Isrc','src/audio.c','src/audio_data.c','src/audio_tables.c','src/audio_low_62.c','src/audio_low_63.c','src/bank_io.c','-o',str(libpath)],cwd=ROOT,check=True)
 
 logic=OUT/"logic-test"
 subprocess.run([os.environ.get("CC","cc"),"-std=c99","-Wall","-Wextra","-Werror","-Wno-unknown-pragmas","-fsanitize=address,undefined","-Isrc",*[str(ROOT/"src"/f) for f in ["audio.c","audio_data.c","audio_tables.c","audio_low_62.c","audio_low_63.c","bank_io.c"]],str(ROOT/"tests/test_audio.c"),"-o",str(logic)],cwd=ROOT,check=True)
 logic_output=subprocess.check_output([str(logic)],text=True,cwd=ROOT);logic_checks=int(re.search(r"passed: (\d+)",logic_output)[1])
 lib=ctypes.CDLL(str(libpath));ram=(ctypes.c_uint8*512).in_dll(lib,'audio_ram');trace=(ctypes.c_uint8*1024).in_dll(lib,'audio_trace');count=ctypes.c_uint16.in_dll(lib,'audio_trace_count');fault=ctypes.c_uint8.in_dll(lib,'audio_fault')
 cases=[];checks=0
 def scenario(name,frames,commands):
  nonlocal checks
  ref=Reference();lib.audio_init();digest=hashlib.sha256();writes=0
  for frame in range(frames):
   command=commands.get(frame)
   if command is not None:lib.audio_command(command)
   original,expected=ref.tick(command);lib.audio_tick();actual=bytes(trace[:count.value]);state=bytes(ram)
   if original!=actual or expected!=state or fault.value:
    differences=[(hex(0xc000+i),expected[i],state[i]) for i in range(512) if expected[i]!=state[i]]
    raise AssertionError((name,frame,hex(command or 0),'PSG',original.hex(),actual.hex(),'RAM',differences,'fault',fault.value))
   digest.update(len(original).to_bytes(2,'little')+original+expected);writes+=len(original);checks+=2
  cases.append({'name':name,'frames':frames,'psg_writes':writes,'trace_and_ram_sha256':digest.hexdigest(),'commands':{k:hex(v) for k,v in commands.items()}})
 for cmd in range(0x81,0x95):scenario(f'music-{cmd:02x}',7200,{0:cmd})
 for cmd in range(0xa0,0xd5):scenario(f'effect-{cmd:02x}',1200,{0:0x85,37:cmd})
 for cmd in range(0xd5,0xda):scenario(f'control-{cmd:02x}',1200,{0:0x85,137:0x88,350:cmd})
 scenario('effect-priorities',4000,{0:0x85,20:0xd0,30:0xa1,70:0xa0,90:0xd1,110:0xab,120:0xd2,150:0xac,180:0xd6,210:0xbb,400:0xd5,600:0x88,900:0xd8,1100:0xd9})
 scenario('invalid-commands-and-reset',1000,{0:0x85,100:0x80,110:0x95,120:0x9f,130:0,140:0x82,500:0xda,700:0x83,800:0xff})
 report={'passed':True,'checks':checks,'asan_ubsan_checks':logic_checks,'reference':'Original pinned SMS bank12 machine code, executed by z80 1.2.0; compare every ordered PSG write and512-byte driver RAM every frame','cases':cases,'campaign_complete':False}
 (OUT/'reference-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='cases'},indent=2))
if __name__=='__main__':main()
