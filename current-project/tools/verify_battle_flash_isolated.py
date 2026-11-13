#!/usr/bin/env python3
"""Live-PPU atomic flash checks using the built native battle-art probe."""
from pathlib import Path
import hashlib,json
import numpy as np
from pyboy import PyBoy
from verify_rom import load_symbols
ROOT=Path(__file__).resolve().parents[1]
def main():
 rom=ROOT/'build/verification/battle-scenes/battle-scenes.gbc';s=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);cases=[]
 def issue(command):
  before=e.screen.ndarray.copy();frames=[];e.memory[s['probe_command']]=command
  for _ in range(500):
   e.tick(1);frames.append(e.screen.ndarray.copy());assert not e.memory[s['probe_error']]
   if not e.memory[s['probe_command']]:break
  else:raise AssertionError('Flash command timed out')
  for _ in range(3):e.tick(1);frames.append(e.screen.ndarray.copy())
  after=frames[-1];bad=[i for i,f in enumerate(frames)if not(np.array_equal(f,before)or np.array_equal(f,after))];return len(frames),bad,int(np.any(before!=after,axis=2).sum())
 try:
  e.tick(180);assert e.memory[s['probe_ready']]
  for scene,enemy in[(1,1),(1,13),(14,70),(30,72),(31,73),(32,73)]:
   e.memory[s['probe_type']]=scene;e.memory[s['probe_enemy']]=enemy;e.memory[s['probe_palette']]=0;issue(1)
   for command in(15,16):
    for white in(1,0):
     e.memory[s['probe_clip']]=white;frames,bad,changed=issue(command);assert not bad,(scene,enemy,command,white,bad)
     cases.append({'scene':scene,'enemy':enemy,'effect':'enemy'if command==15 else'party_with_index16','white':white,'physical_frames':frames,'changed_pixels':changed,'mixed_frames':bad})
  out=ROOT/'build/verification/battle-flash-isolated';out.mkdir(parents=True,exist_ok=True);report={'passed':True,'rom_sha256':hashlib.sha256(rom.read_bytes()).hexdigest(),'cases':cases,'mixed_frames':0,'scope':'24live-PPU before/after transitions in the production battle renderer, including real source14 Gold and original Lassic/DarkFalz contexts. Separate art probe has no production audio IRQ; full-main audio/PPU integration is separately verified.'};(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
