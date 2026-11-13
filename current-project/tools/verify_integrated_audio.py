#!/usr/bin/env python3
"""Verify production score scheduling, audible output and lower-stack guard."""
from pathlib import Path
import argparse,json,re,shutil,tempfile,wave
import numpy as np
from pyboy import PyBoy
from verify_rom import finish_new_game_intro,button,cartridge_header,load_symbols,read_word,wait_dispatch
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');a=p.parse_args()
s=load_symbols(a.rom.with_suffix('.noi'));out=ROOT/'build/verification/integrated-audio';out.mkdir(parents=True,exist_ok=True)
sections=re.findall(r'^_(?:DATA|INITIALIZED|BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)',a.rom.with_suffix('.map').read_text(),re.M);guard=max(int(x,16)+int(y,16)for x,y in sections)
report={'header':cartridge_header(a.rom),'diagnostic':'128-byte unused-WRAM guard above static data; no game state injected','sections':[],'hardware_tested':False}
with tempfile.TemporaryDirectory(prefix='ps-audio-game-')as tmp:
 r=Path(tmp)/'game.gbc';shutil.copyfile(a.rom,r)
 e=PyBoy(str(r),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0);e.tick(180);wait_dispatch(e,s)
 for i in range(128):e.memory[guard+i]=0xa5
 samples=[]
 for section in ['title','Camineet','menu']:
  if section=='Camineet':
   button(e,'start',4,120);finish_new_game_intro(e,s)
  if section=='menu':button(e,'start',4,80);wait_dispatch(e,s)
  # A completed game-mode transition may stop PyBoy at LY0 with its first
  # audio ISR still in progress. Settle that boundary before measuring a
  # steady300-frame interval; do not weaken the once-per-frame assertion.
  e.tick(2)
  begin=read_word(e,s['audio_frames']);blocks=[]
  for _ in range(300):e.tick(1);blocks.append(e.sound.ndarray.copy())
  frames=(read_word(e,s['audio_frames'])-begin)&65535;pcm=np.concatenate(blocks,axis=0)
  assert frames==300,(section,frames)
  assert e.memory[s['audio_fault']]==0
  assert int(pcm.max())-int(pcm.min())>20
  samples.append(pcm);report['sections'].append({'name':section,'score_frames':frames,'music_command':e.memory[s['audio_music']],'pcm_peak_to_peak':int(pcm.max())-int(pcm.min())})
 assert bytes(e.memory[guard:guard+128])==bytes([0xa5])*128
 report['lower_stack_guard_intact']=True;report['guard_start']=hex(guard)
 pcm=np.concatenate(samples,axis=0);path=out/'production-title-town-menu.wav'
 with wave.open(str(path),'wb')as w:w.setnchannels(2);w.setsampwidth(1);w.setframerate(e.sound.sample_rate);w.writeframes((pcm.astype(np.int16)+128).astype(np.uint8).tobytes())
 report['audio_artifact']=str(path);e.stop(save=False)
report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
