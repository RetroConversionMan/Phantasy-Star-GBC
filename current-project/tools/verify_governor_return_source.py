#!/usr/bin/env python3
"""Original5666 and post-nightmare palace fade/portrait/healing boundaries."""
import hashlib,json,struct
from ending_reference import Ending,ROM,ROOT
from extract_scenes import Source,label,SHA
from verify_dark_falz_prelude_source import indexed

def run_to(s,entry,stop):
 c=s.main;c.pc=entry;c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';c.set_breakpoint(stop)
 for _ in range(1000):
  c.ticks_to_stop=500000;c.run()
  if c.pc==stop:break
 else:raise AssertionError(hex(c.pc))
 c.clear_breakpoint(stop)

def picture(s):
 result=bytearray(indexed((bytes(s.vram),bytes(s.cram),bytes(s.regs))));used=bytearray(256*192);c=s.main
 # Source617D/576A already built the SAT. Lower entries win equal-position
 # pixels; the original scene has no high-priority background cells.
 count=int.from_bytes(c.memory[0xc217:0xc219],'little')-0xc900
 for i in range(count):
  sy=c.memory[0xc900+i];sx=c.memory[0xc980+i*2];tile=c.memory[0xc981+i*2]
  if sy==208:break
  for py in range(8):
   y=(sy+py+1)&255
   if y>=192:continue
   for px in range(8):
    x=(sx+px)&255;n=y*256+x;off=0x2000+tile*32+py*4;v=sum(((s.vram[off+b]>>(7-px))&1)<<b for b in range(4))
    if v and not used[n]:result[n]=v+16;used[n]=1
 return bytes(result)

def case(nightmare,clock):
 s=Ending(6);c=s.main;c.memory[0xc800:0xc900]=bytes(256);c.memory[0xc900]=208;c.memory[0xc29e]=32;c.memory[0xc21d]=clock
 for i in range(4):
  c.memory[0xc400+i*16]=1 if i!=1 else 0;c.memory[0xc401+i*16:0xc403+i*16]=bytes((i+1,i+2));c.memory[0xc406+i*16:0xc408+i*16]=bytes((100+i,30+i))
 before=bytes(c.memory[0xc400:0xc440]);s.audio.clear();s.frames.clear();s.unique.clear();s.logs.clear();s.targets.clear()
 if nightmare:
  pattern=b'\xcd'+struct.pack('<H',label('FadeOut2'))+b'\x3e\x1d\x32\x9e\xc2\xcd'+struct.pack('<H',label('LABEL_3D47'))+b'\xcd'+struct.pack('<H',label('LABEL_2A6D'))
  entry=ROM.index(pattern,label('LABEL_4C70'),label('LABEL_4D6C'))
 else:entry=label('LABEL_5666')
 run_to(s,entry,label('ShowDialogue_B2'));assert c.hl==(0xaa if nightmare else 0x272)
 actual=picture(s);expected,palette,_=Source(ROM).compose(29,portrait=53,return_indices=True)
 assert bytes(s.cram[v]for v in actual)==bytes(palette[v]for v in expected),'Governor portrait/source background composition'
 assert c.memory[0xc29e]==29 and c.memory[0xc800] and c.memory[0xc801]
 for i in range(4):
  hp,mp=c.memory[0xc401+i*16:0xc403+i*16]
  assert(hp,mp)==((100+i,30+i)if nightmare and i!=1 else(i+1,i+2))
 waits=[row[-1]for row in s.logs];assert waits.count(12)==1 and waits[-1]==22 and not s.audio
 return {'nightmare':nightmare,'initial_fade_clock':clock,'entry':hex(entry),'text':hex(c.hl),'frames':len(s.frames),'wait_commands':waits,'source_rgb_pixels':len(actual),'governor_actor':list(c.memory[0xc800:0xc805]),'party_before':list(before),'party_after':list(c.memory[0xc400:0xc440]),'source_image_sha256':hashlib.sha256(bytes(s.cram[v]for v in actual)).hexdigest()}

def main():
 assert hashlib.sha256(ROM).hexdigest()==SHA
 cases=[case(nightmare,clock)for nightmare in(False,True)for clock in range(4)]
 out=ROOT/'build/verification/governor-return-source';out.mkdir(parents=True,exist_ok=True);report={'passed':True,'source_sha256':SHA,'cases':cases,'source_rgb_pixel_checks':sum(c['source_rgb_pixels']for c in cases),'reference':'Actual original5666 and exact post-nightmare code span through ShowDialogue_B2 entry. All original fades, scene decode, portrait617D/576A and2A6D healing execute. Sound driver only is stubbed. Dialogue text drawing is an endpoint.'};(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'cases':len(cases),'source_rgb_pixel_checks':report['source_rgb_pixel_checks'],'frames':[c['frames']for c in cases]}))
if __name__=='__main__':main()
