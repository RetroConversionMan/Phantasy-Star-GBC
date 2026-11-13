#!/usr/bin/env python3
"""Compare travel coordinates, VDP row uploads and fades with original Z80 code."""
import ctypes as C,hashlib,json,subprocess
import z80
from extract_travel_graphics import ROOT,SHA,extract,label

class State(C.Structure):
 _fields_=[(n,C.c_uint16)for n in ('x','y','speed','phase_frames')]+[(n,C.c_uint32)for n in ('updated_rows','arrival_rows')]+[(n,C.c_uint8)for n in ('tag','stage','next_stage','map','facing','ship_mode','music','road_steps','step_pixels','fraction','scroll','turns','planet','arrival_planet','space_visible','fade_step','fade_clock','fade_in')]
class Original:
 def __init__(self,rom):
  self.cpu=z80.Z80Machine();self.cpu.memory[:0x8000]=rom[:0x8000];self.cpu.memory[0x8000:0xc000]=rom[28*16384:29*16384]
  self.cpu.set_breakpoint(0x100);self.cpu.set_output_callback(self.write)
  # These callbacks transfer newly decoded world graphics. They do not change
  # the motion state being checked. Space73D0 executes unmodified below.
  for name in ('LABEL_723D','LABEL_72A6','LABEL_733A'):self.cpu.memory[label(name)]=0xc9
  self.vram=bytearray(16384);self.latch=None;self.address=0;self.code=0
 def write(self,port,value):
  if port&255==0xbf:
   if self.latch is None:self.latch=value
   else:self.address=self.latch|((value&63)<<8);self.code=value>>6;self.latch=None
  elif port&255==0xbe:
   assert self.code==1
   self.vram[self.address]=value;self.address=(self.address+1)&16383
 def call(self,name):
  self.cpu.pc=label(name);self.cpu.sp=0xdffc;self.cpu.memory[0xdffc:0xdffe]=b'\x00\x01';self.cpu.ticks_to_stop=500000
  for _ in range(30):
   self.cpu.run()
   if self.cpu.pc==0x100:return
  raise AssertionError(('Z80 routine did not return',name,hex(self.cpu.pc)))
 def byte(self,p,v=None):
  if v is not None:self.cpu.memory[p]=v&255
  return self.cpu.memory[p]
 def word(self,p,v=None):
  if v is not None:self.cpu.memory[p:p+2]=bytes((v&255,(v>>8)&255))
  return self.byte(p)|(self.byte(p+1)<<8)
 def position(self,x,y):
  self.word(0xc301,(x-136)%2048);cy=(y-112)%1536
  self.word(0xc305,(cy//192)*256+cy%192);self.byte(0xc304,cy%192)
 def native_position(self):
  return(self.word(0xc301)+136)%2048,((self.byte(0xc306)*192+self.byte(0xc305))+112)%1536

def main():
 out=ROOT/'build/verification/travel';out.mkdir(parents=True,exist_ok=True)
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 library=out/'travel.dylib';subprocess.run(['cc','-std=c99','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC','-Isrc','src/travel.c','-o',str(library)],cwd=ROOT,check=True)
 lib=C.CDLL(str(library));lib.travel_begin.argtypes=[C.POINTER(State),C.c_uint8];lib.travel_begin.restype=C.c_uint8
 lib.travel_step.argtypes=[C.POINTER(State),C.c_uint8];lib.travel_step.restype=C.c_uint8
 lib.travel_space_row.argtypes=[C.POINTER(State),C.c_uint8,C.POINTER(C.c_uint8)];lib.travel_space_row.restype=C.c_uint8
 lib.travel_fade_color.argtypes=[C.c_uint8]*3;lib.travel_fade_color.restype=C.c_uint8
 counts={'source_road_frames':0,'source_ship_motion_frames':0,'source_space_frames':0,'source_vram_bytes':0,'source_palette_cases':0,'skip_cases':0,'routes':0}
 _,words,_,_=extract(rom);maps=[b''.join(w.to_bytes(2,'little')for w in layout)for layout in words]
 def until(s,stage):
  for ticks in range(100):
   if s.stage==stage:return ticks
   lib.travel_step(C.byref(s),0)
  raise AssertionError(('phase did not finish',s.stage,stage))
 def destination(p):return p[0],(p[2]*16+8)%2048,(((p[1]>>4)*12+(p[1]&15))*16+16)%1536
 def finish(s,expected):
  assert until(s,8)==76
  assert(s.map,s.x,s.y)==expected and s.ship_mode==0
  assert lib.travel_step(C.byref(s),1)==0
 for color in range(64):
  for inward in(0,1):
   ref=Original(rom);ref.byte(0xc21d,3);ref.byte(0xc21b,0x89 if inward else 9);ref.byte(0xc21c,1)
   ref.byte(0xc240,color);ref.byte(0xc220,0 if inward else color)
   for step in range(10):
    assert lib.travel_fade_color(color,step,inward)==ref.byte(0xc220)
    for _ in range(4):ref.call('LABEL_7B40')
    counts['source_palette_cases']+=1
 for tag in range(1,7):
  record=rom[label('LABEL_F0C')+(tag-1)*8:label('LABEL_F0C')+tag*8]
  s=State();assert lib.travel_begin(C.byref(s),tag)==45;assert(s.map,s.x,s.y)==destination(record[2:5]);assert until(s,2)==40
  ref=Original(rom);ref.position(s.x,s.y);ref.byte(0xc2e9,tag);ref.byte(0xc204,record[0])
  for frame in range(record[1]*16):
   ref.call('LABEL_7143');lib.travel_step(C.byref(s),0)
   assert(s.x,s.y)==ref.native_position(),(tag,frame,s.x,s.y,ref.native_position())
   assert s.step_pixels==(frame+1)%16;counts['source_road_frames']+=1
  assert s.stage==7;finish(s,destination(record[5:]));counts['routes']+=1
 for tag in range(0x81,0x89):
  record=rom[label('LABEL_ABF')+(tag-0x81)*9:label('LABEL_ABF')+(tag-0x80)*9]
  s=State();lib.travel_begin(C.byref(s),tag);assert(s.map,s.x,s.y)==destination(record[:3]);assert s.music==0xb8;assert until(s,3)==40
  ref=Original(rom);ref.position(s.x,s.y);ref.byte(0xc21d,3);ref.byte(0xc21b,9);ref.byte(0xc21c,32)
  for frame in range(256):
   ref.word(0xc2f2,frame*8);ref.call('LABEL_998');lib.travel_step(C.byref(s),0)
   assert(s.x,s.y)==ref.native_position(),(tag,frame,'ascent')
   assert(s.scroll,s.fraction)==(ref.byte(0xc304),ref.byte(0xc307))
   assert s.fade_step==9-ref.byte(0xc21b);counts['source_ship_motion_frames']+=1
  assert s.stage==4;assert until(s,1)==4;assert s.space_visible and s.music==0x8f
  assert until(s,5)==40
  ref=Original(rom);ref.byte(0xc2e9,tag);ref.byte(0xc264,1);ref.byte(0xc307,8)
  ref.cpu.memory[0xd000:0xd700]=maps[0]+maps[0]+maps[1][:256]
  ref.vram[0x3800:0x3f00]=maps[0]+maps[1]+maps[1][:256]
  for frame in range(785):
   ref.call('LABEL_73D0');ref.call('LABEL_9E9');lib.travel_step(C.byref(s),0)
   if frame<784:
    assert(s.scroll,s.turns)==(ref.byte(0xc304),ref.byte(0xc307)),(tag,frame,'space',(s.scroll,s.turns),(ref.byte(0xc304),ref.byte(0xc307)))
    native=bytearray()
    for row in range(28):
     r=C.c_uint8();kind=lib.travel_space_row(C.byref(s),row,C.byref(r));native.extend(maps[kind][r.value*64:(r.value+1)*64])
    assert native==ref.vram[0x3800:0x3f00],(tag,frame,'VDP rows')
    counts['source_vram_bytes']+=1792
   counts['source_space_frames']+=1
  assert s.stage==1 and not s.space_visible and s.music==0xb8
  assert(s.map,s.x,s.y)==destination(record[3:6]);assert until(s,6)==40
  ref=Original(rom);ref.position(s.x,s.y);ref.byte(0xc307,s.fraction)
  for frame in range(257):
   ref.word(0xc2f2,0x800-frame*8);ref.call('LABEL_998');lib.travel_step(C.byref(s),0)
   assert(s.x,s.y)==ref.native_position(),(tag,frame,'arrival')
   assert(s.scroll,s.fraction)==(ref.byte(0xc304),ref.byte(0xc307));counts['source_ship_motion_frames']+=1
  assert s.stage==7;finish(s,destination(record[6:]));counts['routes']+=1
 # Independent action-button skips per phase, including retained C307 counter.
 for tag in list(range(1,7))+list(range(0x81,0x89)):
  stages=(2,)if tag<128 else(3,5,6)
  for target in stages:
   for skip_after in(0,1,15,31):
    s=State();lib.travel_begin(C.byref(s),tag)
    for _ in range(2500):
     if s.stage==target:break
     lib.travel_step(C.byref(s),0)
    else:raise AssertionError(('never reached skip phase',tag,target))
    for _ in range(skip_after):lib.travel_step(C.byref(s),0)
    before=(s.x,s.y,s.turns);lib.travel_step(C.byref(s),1)
    assert(s.x,s.y)==before[:2]if target!=5 else s.fraction==before[2]
    assert s.stage==({2:7,3:4,5:1,6:7}[target]);counts['skip_cases']+=1
 report={'passed':True,'source_sha256':SHA,**counts,
  'reference':'Unmodified original Z807143/998/9E9/73D0/7B40 routines; world graphics callbacks723D/72A6/733A are stubbed only in motion tests',
  'limits':['Reference verifies logic, source VDP rows and palette arithmetic, not native presentation performance',
            'Caller owns initial fade-out into travel; native asset load time is platform-specific']}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
