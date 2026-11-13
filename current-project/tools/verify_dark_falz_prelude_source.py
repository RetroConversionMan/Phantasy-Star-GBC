#!/usr/bin/env python3
"""Actual5619 VDP/audio trace through the first100F instruction.

Only the existing sound-driver boundary is stubbed. Scene decode, fades,
enemy setup, actor processing, waits and palette upload execute original Z80.
"""
import hashlib,json,pickle
from PIL import Image
from ending_reference import Ending,ROM,ROOT
from extract_scenes import Source,label,SYMBOLS,SHA

def indexed(snapshot):
 v,p,r=snapshot;out=bytearray()
 for y in range(192):
  for x in range(256):
   off=0x3800+y//8*64+x//8*2;w=int.from_bytes(v[off:off+2],'little');tx=7-x%8 if w&512 else x%8;ty=7-y%8 if w&1024 else y%8;raw=(w&511)*32+ty*4
   out.append(sum(((v[raw+b]>>(7-tx))&1)<<b for b in range(4))+(16 if w&2048 else 0))
 return bytes(out)

def trace(skip_frame=None,fade_clock=3,skip_button=16):
 class Prelude(Ending):
  def output(self,c,p,v):
   super().output(c,p,v)
   if p&255==0xfd and c==self.main and skip_frame is not None and len(self.frames)>=skip_frame:
    # The source30-frame hold checks original Ctrl_1_pressed after its IRQ.
    c.memory[int.from_bytes(ROM[label('LABEL_2D39')+6:label('LABEL_2D39')+8],'little')]=skip_button
 s=Prelude(6);c=s.main;c.memory[0xc800:0xc900]=bytes(256);c.memory[0xc30a]=0;c.memory[0xc30c]=0xde;c.memory[0xc30d]=31;c.memory[0xc315]=6;c.memory[0xc2f5]=0;c.memory[0xc29f]=0
 c.memory[0xffff]=16;c.memory[0x8000:0xc000]=ROM[16*16384:17*16384];c.hl=SYMBOLS['LABEL_B16_BAD8'][1];c.de=0x5800;s.run(c,label('LABEL_3FA'),0xdffc)
 s.run(c,label('LABEL_6D56'),0xdffc);c.a=0;s.run(c,label('LABEL_6AE5'),0xdffc);s.cram[:]=c.memory[0xc240:0xc260];c.memory[0xc220:0xc240]=s.cram;c.memory[0xc21d]=fade_clock
 s.frames.clear();s.unique.clear();s.audio.clear();s.logs.clear();s.targets.clear()
 c.pc=label('LABEL_5619');c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';phases=[]
 for boundary in('LABEL_5FFE','LABEL_100F'):
  address=label(boundary);c.set_breakpoint(address)
  for _ in range(1000):
   c.ticks_to_stop=500000;c.run()
   if c.pc==address:break
  else:raise AssertionError(hex(c.pc))
  c.clear_breakpoint(address);snap=(bytes(s.vram),bytes(s.cram),bytes(s.regs));phases.append({'boundary':boundary,'frame':len(s.frames),'indices':indexed(snap),'palette':snap[1],'snapshot':snap})
 assert s.audio==[(0,147)] and c.memory[0xc2e6]==73 and c.memory[0xc2c7]==2
 assert c.memory[0xc440]==c.memory[0xc450]==1 and c.memory[0xc441]==c.memory[0xc451]==255
 assert all(c.memory[0xc900+i]==208 for i in range(1)),'DarkFalz initial state has no OBJ sprites'
 return s,phases

def main():
 assert hashlib.sha256(ROM).hexdigest()==SHA
 out=ROOT/'build/research/dark-falz-prelude';out.mkdir(parents=True,exist_ok=True);s,phases=trace();assert len(s.frames)==280 and [p['frame']for p in phases]==[249,280]
 for n,p in enumerate(phases):
  (out/f'phase{n}-indices.bin').write_bytes(p['indices']);(out/f'phase{n}-palette.bin').write_bytes(p['palette'])
  image=Image.new('RGB',(256,192));image.putdata([((p['palette'][v]&3)*85,((p['palette'][v]>>2)&3)*85,(p['palette'][v]>>4)*85)for v in p['indices']]);image.save(out/f'phase{n}-source.png')
 # The battle type is changed only in RAM. No background clear occurs.
 expected,palette,_=Source(ROM).compose(31,enemy=73,return_indices=True)
 assert bytes(palette[v]for v in expected)==bytes(phases[1]['palette'][v]for v in phases[1]['indices'])
 differences=sum(a!=b for a,b in zip(phases[0]['indices'],phases[1]['indices']))
 report={'passed':True,'source_sha256':SHA,'entry':'5619','endpoint':'100F','frames':len(s.frames),'audio':s.audio,'phases':[{k:v for k,v in p.items()if k not in('indices','palette','snapshot')}for p in phases],'enemy_count':2,'enemy_HP':[255,255],'source_index_changes_at_5FFE':differences,'before_battle_matches_scene31_enemy73':True,'wait_commands':[v[-1]for v in s.logs],'source_palette_after_override':list(phases[0]['palette']),'limits':['Boundary is before battle menu initialization. Native controller/PPU and battle execution are separate evidence.']}
 (out/'source-report.json').write_text(json.dumps(report,indent=2)+'\n');(out/'source-trace.pkl').write_bytes(pickle.dumps({'frames':[list(s.unique.values())[i][1]for i in s.frames],'logs':s.logs,'audio':s.audio,'phases':phases}))
 cases=[]
 for clock in range(4):
  x,q=trace(fade_clock=clock);assert len(x.frames)==277+clock;cases.append({'clock':clock,'skip':None,'frames':len(x.frames),'phases':[v['frame']for v in q]})
  for button in(16,32):
   for skip in(q[0]['frame']+2,q[0]['frame']+29):
    y,r=trace(fade_clock=clock,skip_frame=skip,skip_button=button);assert len(y.frames)==skip and r[1]['frame']==skip;cases.append({'clock':clock,'skip':skip,'button':button,'frames':len(y.frames),'phases':[v['frame']for v in r]})
 (out/'clock-and-skip-cases.json').write_text(json.dumps({'passed':True,'cases':cases},indent=2)+'\n');report['clock_and_input_cases']=len(cases);print(json.dumps({k:v for k,v in report.items()if k not in('wait_commands','source_palette_after_override')}))
if __name__=='__main__':main()
