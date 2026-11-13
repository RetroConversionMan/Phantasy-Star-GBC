#!/usr/bin/env python3
"""Source termination semantics including unskippable208-frame holds."""
from pathlib import Path
import subprocess,json
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <assert.h>
#include <stdio.h>
#include "dialogue.h"
int main(void){
 unsigned checks=0;uint8_t narrative,term;uint16_t frames,remaining,t;
 for(narrative=0;narrative<2;narrative++)for(term=0x61;term<=0x65;term++){
  frames=dialogue_wait_frames(term,narrative);++checks;
  if(narrative)assert(frames==(term==0x63?208:65535));
  else assert(frames==(term==0x62?0:term==0x63?30:term==0x64?208:65535));
  remaining=frames;
  if(frames==65535){for(t=0;t<300;t++){assert(!dialogue_wait_tick(&remaining,term,narrative,0));assert(remaining==65535);checks+=2;}assert(dialogue_wait_tick(&remaining,term,narrative,1));++checks;}
  else if(!frames){assert(dialogue_wait_tick(&remaining,term,narrative,0));assert(!remaining);checks+=2;}
  else{
   for(t=1;t<=frames;t++){assert(dialogue_wait_tick(&remaining,term,narrative,0)==(t==frames));assert(remaining==frames-t);checks+=2;}
   assert(dialogue_wait_tick(&remaining,term,narrative,0));++checks;
   remaining=frames;
   if(!narrative&&term==0x63){assert(dialogue_wait_tick(&remaining,term,narrative,1));assert(!remaining);checks+=2;}
   else for(t=1;t<=frames;t++){assert(dialogue_wait_tick(&remaining,term,narrative,1)==(t==frames));++checks;}
  }
 }
 printf("%u\n",checks);return 0;
}
'''
def main():
 out=ROOT/'build/verification/dialogue-timing';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN);binary=out/'timing'
 subprocess.run(['clang','-std=c99','-fsanitize=address,undefined','-Isrc',str(out/'main.c'),'src/dialogue.c','src/dialogue_data.c','src/dialogue_text_09.c','src/dialogue_text_10.c','-o',str(binary)],cwd=ROOT,check=True)
 r=subprocess.run([str(binary)],capture_output=True,text=True,check=True);report={'passed':True,'assertions':int(r.stdout),'source':'31FA regular62 immediate/63 30-skippable/64 208-unskippable/65 button;337D narrative63 208-unskippable/65 button','limits':['Pure wait rules; native UI integration and typewriter reveal tested separately']};(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
