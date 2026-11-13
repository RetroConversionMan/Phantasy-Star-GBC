#!/usr/bin/env python3
"""Execute original661C and prove the native translated-view fall kernel."""
import hashlib,json
from ending_reference import Ending,ROM,ROOT
from extract_scenes import label,SYMBOLS
from extract_dungeon_graphics import SHA

def pixels(snapshot):
 v,_,r=snapshot;out=bytearray()
 for y in range(120):
  sy=(y*8//5+r[9])%224
  for x in range(160):
   sx=x*8//5;off=0x3800+sy//8*64+sx//8*2;word=int.from_bytes(v[off:off+2],'little')
   tx=7-sx%8 if word&512 else sx%8;ty=7-sy%8 if word&1024 else sy%8;raw=(word&511)*32+ty*4
   out.append(sum(((v[raw+b]>>(7-tx))&1)<<b for b in range(4))+(16 if word&2048 else 0))
 return bytes(out)
def trace(floor,position,direction,light):
 s=Ending(light);s.vram[:]=bytes(16384);s.cram[:]=bytes(32);s.regs[:]=bytes(16);c=s.main
 c.memory[0xc30a]=direction;c.memory[0xc30c]=position;c.memory[0xc30d]=floor;c.memory[0xc315]=light;c.memory[0xc2f5]=0
 c.memory[0xffff]=16;c.memory[0x8000:0xc000]=ROM[16*16384:17*16384];c.hl=SYMBOLS['LABEL_B16_BAD8'][1];c.de=0x5800;s.run(c,label('LABEL_3FA'),0xdffc)
 assert bytes(s.vram[0x1800:0x1820])==bytes((255,0,0,0))*8,'Original fontC0 must be solid palette color1'
 s.run(c,label('LABEL_6D56'),0xdffc);c.a=0;s.run(c,label('LABEL_6AE5'),0xdffc);s.cram[:]=c.memory[0xc240:0xc260];c.memory[0xc220:0xc240]=s.cram
 initial=(bytes(s.vram),bytes(s.cram),bytes(s.regs));s.frames.clear();s.unique.clear();s.targets.clear();s.audio.clear();s.logs.clear()
 # The first post-animation object callback is the capture endpoint.
 c.memory[label('LABEL_6963')]=0xc9;s.run(c,label('LABEL_661C'),0xdffc)
 frames=[list(s.unique.values())[i][1]for i in s.frames];assert len(frames)==30
 assert [f[2][9]for f in frames]==list(range(16,193,16))+[192]+list(range(32,209,16))+[0,216,0,216,0]
 assert c.memory[0xc30c]==position and c.memory[0xc30a]==direction and c.memory[0xc30d]==max(0,floor-1)
 assert s.audio==[(0,0xc0)] and initial[1][1]==0 and all(f[1][1]==0 for f in frames)
 original=pixels(initial);rendered=[pixels(f)for f in frames];final=rendered[-1];blank=bytes([1])*160
 for i in range(12):assert rendered[i]==original[(i+1)*1600:]+blank*((i+1)*10)
 assert rendered[12]==blank*120
 for i in range(12):assert rendered[13+i]==blank*(120-i*10)+final[:i*1600]
 for i in range(5):assert rendered[25+i]==(blank*5+final[:115*160]if i&1 else final)
 return {'floor':floor,'position':position,'direction':direction,'light':light,'frames':30,'pixels':30*160*120,'sound':0xc0,'destination_floor':max(0,floor-1)}
def main():
 assert hashlib.sha256(ROM).hexdigest()==SHA
 cases=[trace(*case)for case in((19,0x39,0,255),(4,0x5a,1,255),(42,0x69,2,255),(60,0x85,3,255),(0,0x11,0,0))]
 report={'passed':True,'source_sha256':SHA,'cases':cases,'reference':'Actual original661C,6D56,6AED,VDP DMA/VBlank handlers; only sound engine and final6963 callback are capture endpoints.','native_mapping':'Outgoing image shifts up10 pixels; incoming image shifts down120..10; shake alternates0/5 pixels. Blank is original fontC0 source palette index1 (black), independent of dungeon background color.'}
 out=ROOT/'build/verification/dungeon-motion/fall-source-report.json';out.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
