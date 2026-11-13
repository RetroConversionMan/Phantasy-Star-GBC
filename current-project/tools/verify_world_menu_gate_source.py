#!/usr/bin/env python3
"""Original LoadMap/77AC/GameMode_Map stationary-menu trigger latch."""
import hashlib,json
from pathlib import Path
from ending_reference import Ending,ROM
from extract_scenes import label,SHA
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'build/verification/world-menu-gate-source'
def case(clock,buttons):
 s=Ending(6);c=s.main;c.memory[0xc21d]=clock;c.memory[0xc202]=8
 # Original coordinates matching native Palma arrival1368,736.
 c.memory[0xc301:0xc303]=bytes((0xd0,4));c.memory[0xc305:0xc307]=bytes((0x30,3));c.memory[0xc308:0xc30a]=bytes((0,0));c.memory[0xc400]=1
 s.run(c,label('GameMode_LoadMap'),0xdffc);assert c.memory[0xc202]==9 and c.memory[0xc2d5]==1
 initial_position=list(c.memory[0xc300:0xc307]);s.frames.clear();s.logs.clear();s.audio.clear();s.unique.clear()
 s.irq.set_input_callback(lambda port:255^buttons if port&255==0xdc else 255)
 s.run(c,label('GameMode_Map'),0xdffc)
 assert c.memory[0xc202]==12 and c.memory[0xc29d]==0 and c.memory[0xc265]==0
 assert list(c.memory[0xc300:0xc307])==initial_position and [r[-1]for r in s.logs]==[14]
 return {'initial_phase':clock,'buttons':buttons,'native_equivalent_position':[1368,736],'original_camera':initial_position,'latch_after_LoadMap':1,'game_mode_after_held_button':12,'wait_commands':[14],'coordinates_preserved':True}
def main():
 assert hashlib.sha256(ROM).hexdigest()==SHA
 cases=[case(clock,button)for clock in range(4)for button in(16,32,48)]
 s=Ending();c=s.main
 for latch in range(1,256):
  c.memory[0xc265]=0;c.memory[0xc2d5]=latch;c.memory[0xc202]=9;c.memory[0xc29e]=7;s.run(c,label('LABEL_77AC'),0xdffc)
  assert c.memory[0xc2d5]==latch and c.memory[0xc202]==9 and c.memory[0xc29e]==7
 OUT.mkdir(parents=True,exist_ok=True);report={'passed':True,'source_sha256':SHA,'cases':cases,'nonzero_latches':255,'reference':'Actual original LoadMap initializes C2D5=1; original GameMode_Map invokes77AC once, whose nonzero latch prevents a repeated metatile dispatch. Held A/B then executesB41 and reaches LoadInteraction without re-running77AC. Full loaders, VBlank and actor routines execute; only sound updater is stubbed.','native_correction':'Remove redundant check_trigger() call from stationary field-menu button branch; movement already performs the once-per-completed-step trigger check.'};(OUT/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'source_cases':len(cases),'nonzero_latches':255}))
if __name__=='__main__':main()
