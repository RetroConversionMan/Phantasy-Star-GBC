"""Z80 reference for LABEL454E tail: real graphics, maps, credits and VBlank handlers.

WaitForVInt is a host boundary invoking the actual source handler in a separate
Z80 register context. Only the sound engine is stubbed; controller ports return
released buttons. Main CPU RAM and SMS mapper behavior remain source-driven.
"""
import sys,collections,hashlib,pickle
sys.path.insert(0,'tools')
import z80
from extract_scenes import ROOT,label,SYMBOLS,Source,cpu_offset
ROM=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
class Ending:
 def __init__(self,light=1):
  self.vram=bytearray(16384);self.cram=bytearray(32);self.regs=bytearray(16);self.regs[9]=0
  self.latch=None;self.address=0;self.code=0;self.frames=[];self.unique={};self.audio=[];self.logs=[];self.vwrites=0;self.targets=[];self.credits=[]
  self.main=self.machine(False);self.irq=self.machine(True)
  c=self.main;c.memory[0xc315]=light;c.memory[0xc900]=0xd0;c.memory[0xc21d]=3;c.memory[0xc21c]=32
  self.cram[:17]=ROM[label('LABEL_B31_9676'):label('LABEL_B31_9676')+17]
  c.memory[0xc220:0xc240]=self.cram;c.memory[0xc240:0xc260]=self.cram
  tiles=Source(ROM).graphics(*SYMBOLS['LABEL_B31_9687'])
  for t,pixels in enumerate(tiles):
   for y in range(8):
    for bit in range(4):self.vram[t*32+y*4+bit]=sum(((pixels[y*8+x]>>bit)&1)<<(7-x)for x in range(8))
  p=label('LABEL_B24_A5E0')
  for y in range(19):self.vram[0x38d4+y*64:0x38d4+y*64+22]=ROM[p+y*22:p+y*22+22]
  self.initial=(bytes(self.vram),bytes(self.cram),bytes(self.regs))
 def machine(self,irq):
  c=z80.Z80Machine();c.memory[:0x8000]=ROM[:0x8000];c.memory[0x8000:0xc000]=ROM[28*16384:29*16384];c.memory[0xffff]=28
  c.set_breakpoint(0x100);c.set_output_callback(lambda p,v:self.output(c,p,v));c.set_input_callback(lambda p:255)
  def memwrite(a,v):
   c.memory[a]=v
   if a==0xffff:c.memory[0x8000:0xc000]=ROM[v*16384:(v+1)*16384]
   if a==0xc004 and not irq:self.audio.append((len(self.frames),v))
   if a==0xc2f5 and not irq:self.credits.append((len(self.frames),v))
  c.set_write_callback(memwrite);c.mark_addr(0xffff,c.WRITE_MARK);c.mark_addr(0xc004,c.WRITE_MARK);c.mark_addr(0xc2f5,c.WRITE_MARK)
  c.memory[label('WaitForVInt'):label('WaitForVInt')+4]=bytes((0xd3,0xfd,0xaf,0xc9))
  for name in ('CallSndUpdate',):c.memory[label(name)]=0xc9
  if irq:c.memory[label('LABEL_143')]=0xc9
  return c
 def run(self,c,pc,sp):
  c.pc=pc;c.sp=sp;c.memory[sp:sp+2]=b'\x00\x01'
  for _ in range(10000):
   c.ticks_to_stop=500000;c.run()
   if c.pc==0x100:return
  raise AssertionError(('hang',hex(c.pc),len(self.frames)))
 def output(self,c,p,v):
  p&=255
  if p==0xfd:
   assert c==self.main
   c.memory[0xc208]=v
   irq=self.irq;irq.memory[0xc000:0xe000]=c.memory[0xc000:0xe000]
   bank=c.memory[0xffff];irq.memory[0xffff]=bank;irq.memory[0x8000:0xc000]=ROM[bank*16384:(bank+1)*16384]
   off=label('LABEL_18F')+(v&31);handler=int.from_bytes(ROM[off:off+2],'little')
   self.run(irq,handler,0xeffc);c.memory[0xc000:0xe000]=irq.memory[0xc000:0xe000];c.memory[0xc208]=0
   snap=(bytes(self.vram),bytes(self.cram),bytes(self.regs));key=hashlib.sha256(b''.join(snap)).digest()
   if key not in self.unique:self.unique[key]=(len(self.unique),snap)
   self.frames.append(self.unique[key][0]);self.targets.append(bytes(c.memory[0xc240:0xc260]));self.logs.append(tuple(c.memory[0xc30a:0xc30e])+(c.memory[0xc2f5],v))
  elif p==0xbf:
   if self.latch is None:self.latch=v
   else:
    self.address=self.latch|((v&63)<<8);self.code=v>>6
    if self.code==2:self.regs[v&15]=self.latch
    self.latch=None
  elif p==0xbe:
   if self.code==1:self.vram[self.address]=v
   elif self.code==3:self.cram[self.address&31]=v&63
   else:raise AssertionError(('vdpwrite',self.code))
   self.vwrites+=1;self.address=(self.address+1)&16383
 def trace(self):
  pattern=bytes.fromhex('21f73d220cc3af320ac3cd1c66');pc=ROM.index(pattern)
  self.run(self.main,pc,0xdffc)
  assert self.main.memory[0xc202]==2
  print('frames',len(self.frames),'vramunique',len(self.unique),'audio',self.audio,'credit',self.main.memory[0xc2f5],'mode',self.main.memory[0xc202], 'writes',self.vwrites)
  return self
