#!/usr/bin/env python3
"""Execute original4C70 through661C, including original six-row text close."""
import hashlib,json
from ending_reference import Ending,ROM,ROOT
from extract_scenes import Source,label,SYMBOLS
from verify_dungeon_fall_source import pixels
from extract_dungeon_graphics import SHA

class Governor(Ending):
 def __init__(self,light):
  super().__init__(light);self.texts=[]
  self.main.memory[label('ShowDialogue_B2'):label('ShowDialogue_B2')+3]=bytes((0xd3,0xfb,0xc9))
 def output(self,c,p,v):
  if p&255==0xfb:
   self.texts.append(c.hl);c.memory[0xc2d3]=255;return
  super().output(c,p,v)

def trace(light,trap,flag):
 s=Governor(light);c=s.main;t,w,p=Source(ROM).background(29)
 s.vram[:]=bytes(16384);s.cram[:]=bytes(p);s.regs[:]=bytes(16)
 for tile,values in enumerate(t):
  for y in range(8):
   for bit in range(4):s.vram[tile*32+y*4+bit]=sum(((values[y*8+x]>>bit)&1)<<(7-x)for x in range(8))
 for i,word in enumerate(w):s.vram[0x3800+i*2:0x3802+i*2]=word.to_bytes(2,'little')
 c.memory[0xc220:0xc240]=bytes(p);c.memory[0xc240:0xc260]=bytes(p)
 c.memory[0xffff]=16;c.memory[0x8000:0xc000]=ROM[16*16384:17*16384];c.hl=SYMBOLS['LABEL_B16_BAD8'][1];c.de=0x5800;s.run(c,label('LABEL_3FA'),0xdffc)
 for row in range(6):c.memory[0xda18+row*40:0xda18+(row+1)*40]=s.vram[0x3c8c+row*64:0x3c8c+row*64+40]
 c.memory[0xc516]=flag;c.memory[0xc2e0]=trap;c.memory[0xc2f4]=0;c.memory[0xc30a:0xc30e]=bytes((3,0,0x77,7))
 initial=(bytes(s.vram),bytes(s.cram),bytes(s.regs));s.frames.clear();s.unique.clear();s.audio.clear();s.logs.clear();s.targets.clear()
 c.memory[label('LABEL_6963')]=0xc9;c.memory[0xdffe:0xe000]=b'\x00\x01';s.run(c,label('LABEL_4C70'),0xdffc)
 frames=[list(s.unique.values())[i][1]for i in s.frames];assert s.texts==[0x2a6] and len(frames)==36
 assert [r[-1]for r in s.logs]==[10]*6+[8]*12+[22]+[8]*17
 assert list(c.memory[0xc30a:0xc30e])==[0,0,0xe6,33]
 assert c.memory[0xc202]==11 and c.memory[0xc2e0]==trap and c.memory[0xc315]==6
 assert s.audio==[(6,0xc0),(36,0x85)]
 original=pixels(initial);rendered=[pixels(f)for f in frames];final=rendered[-1];blank=bytes([1])*160
 assert all(f==original for f in rendered[:6])
 for i in range(12):assert rendered[6+i]==original[(i+1)*1600:]+blank*((i+1)*10)
 assert rendered[18]==blank*120
 for i in range(12):assert rendered[19+i]==blank*(120-i*10)+final[:i*1600]
 for i in range(5):assert rendered[31+i]==(blank*5+final[:115*160]if i&1 else final)
 return {'initial_light':light,'retained_trap':trap,'C516':flag,'arrival':[33,230,0],'arrival_light':6,'frames':36,'pixel_checks':36*19200,'sounds':s.audio,'source_frame_hashes':[hashlib.sha256(f).hexdigest()for f in rendered]}

def main():
 assert hashlib.sha256(ROM).hexdigest()==SHA
 cases=[trace(light,trap,flag)for light in(0,1,255)for trap,flag in((0,1),(255,255))]
 report={'passed':True,'source_sha256':SHA,'cases':cases,'reference':'Original4C70/3464/661C/6D56/6AED/3FA and VBlank handlers execute. ShowDialogue_B2 is a text capture boundary; final6963 object callback is an endpoint. Initial room is loaded from original scene29 tile/palette/map records.','chronology':'2A6; six close VBlanks; staged34/E6/North; C0; twelve outgoing room strips; original floor decrement to33; palette/maze load; twelve incoming strips; five shake frames; object callback;85.'}
 out=ROOT/'build/verification/governor-source';out.mkdir(parents=True,exist_ok=True);(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'cases':len(cases),'pixel_checks':sum(c['pixel_checks']for c in cases)}))
if __name__=='__main__':main()
