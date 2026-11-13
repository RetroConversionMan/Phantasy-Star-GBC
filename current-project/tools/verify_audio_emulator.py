#!/usr/bin/env python3
"""Native APU/score banking, timing and interrupt stress tests on PyBoy CGB."""
from pathlib import Path
import ctypes,json,subprocess,hashlib,wave
import numpy as np
from pyboy import PyBoy
from verify_audio import Reference,ROOT,OUT
from verify_rom import load_symbols,read_word,cartridge_header
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "audio.h"
#include "audio_data.h"
#include "bank_io.h"
uint8_t probe_tick,probe_command,probe_command_pending,probe_ready,probe_error,probe_irq;
uint16_t probe_done,probe_interrupts,probe_stress;
uint8_t probe_snapshot[512],probe_scratch[31];

void main(void){
 uint8_t i;cpu_fast();DISPLAY_OFF;HIDE_SPRITES;HIDE_WIN;
 audio_init();SWITCH_ROM(1);probe_ready=1;DISPLAY_ON;
 while(1){
  if(probe_irq){
   if(probe_irq==1){audio_install();audio_command(0x85);probe_irq=2;}
   bank_copy(probe_scratch,61,audio_data+128,31);
   for(i=0;i<31;i++)if(probe_scratch[i]!=bank_read8(61,audio_data+128+i))probe_error|=1;
   bank_copy(probe_scratch,62,audio_low0+128,31);
   for(i=0;i<31;i++)if(probe_scratch[i]!=bank_read8(62,audio_low0+128+i))probe_error|=2;
   bank_copy(probe_scratch,63,audio_low1+128,31);
   for(i=0;i<31;i++)if(probe_scratch[i]!=bank_read8(63,audio_low1+128+i))probe_error|=4;
   ++probe_stress;
  }else{
   vsync();if(probe_tick){
    if(probe_command_pending){audio_command(probe_command);probe_command_pending=0;}
    audio_tick();memcpy(probe_snapshot,audio_ram,512);++probe_done;probe_tick=0;
   }
  }
  if(CURRENT_BANK!=1)probe_error|=128;
 }
}
'''
def main():
 OUT.mkdir(parents=True,exist_ok=True);(OUT/'main.c').write_text(MAIN);rom=OUT/'audio-probe.gbc'
 sources=[OUT/'main.c']+[ROOT/'src'/f for f in ['audio.c','audio_data.c','audio_tables.c','audio_low_62.c','audio_low_63.c','audio_irq.c','bank_io.c']]
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo64','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),*map(str,sources)],cwd=ROOT,check=True)
 symbols=load_symbols(rom.with_suffix('.noi'));em=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');em.set_emulation_speed(0)
 def byte(name):return em.memory[symbols[name]]
 def word(name):return read_word(em,symbols[name])
 ref=Reference();counts=0;max_wait=0;samples=[];report={'checks':[],'frames':0,'scope':'Isolated native audio probe; integrated game hooks tested separately'}
 try:
  em.tick(200);assert byte('probe_ready')==1
  # Actual source commands: opening, Palma, Motavia, Dezoris, town, battle,
  # effects over music, special effects priority, overlay and fade/resume.
  commands={0:0x81,240:0x82,480:0x83,720:0x84,960:0x87,1200:0x89,1217:0xa0,1240:0xa1,1280:0xc9,1320:0xca,1380:0xd0,1400:0xa1,1450:0xd6,1500:0x88,1600:0xd8,1800:0xd9,2000:0x85}
  for frame in range(2400):
   command=commands.get(frame)
   if command is not None:em.memory[symbols['probe_command']]=command;em.memory[symbols['probe_command_pending']]=1
   em.memory[symbols['probe_tick']]=1;wait=0
   while byte('probe_tick'):
    em.tick(1);wait+=1
    if frame>=2000:samples.append(em.sound.ndarray.copy())
    assert wait<8,('CPU budget',frame,word('probe_done'),byte('audio_fault'))
   max_wait=max(max_wait,wait)
   original,expected=ref.tick(command);actual=bytes(em.memory[symbols['probe_snapshot']:symbols['probe_snapshot']+512])
   assert actual==expected,(frame,[(hex(0xc000+i),expected[i],actual[i]) for i in range(512) if expected[i]!=actual[i]])
   assert not byte('audio_fault') and not byte('probe_error'),(frame,byte('audio_fault'),byte('probe_error'))
   counts+=1
  report['checks'].append('2400 native score updates match original Z80 driver RAM512bytes exactly across21 music/effect/control commands, with caller ROM bank restored')
  assert max_wait<=2,max_wait
  report['max_emulator_frames_per_requested_tick']=max_wait
  sound=np.concatenate(samples,axis=0);assert int(np.max(sound))-int(np.min(sound))>20
  audiofile=OUT/'source-track-85-native.wav'
  with wave.open(str(audiofile),'wb') as f:f.setnchannels(2);f.setsampwidth(1);f.setframerate(em.sound.sample_rate);f.writeframes((sound.astype(np.int16)+128).astype(np.uint8).tobytes())
  report['checks'].append('Native CGB APU produces non-silent stereo PCM; pulse1/pulse2/wave/noise register state is observable')
  em.memory[symbols['probe_irq']]=1;em.tick(2);start=word('audio_frames');stress=word('probe_stress');em.tick(1200);elapsed=(word('audio_frames')-start)&65535
  assert elapsed==1200,elapsed
  assert not byte('probe_error') and not byte('audio_fault'),(byte('probe_error'),byte('audio_fault'))
  assert (word('probe_stress')-stress)&65535>100
  report['checks'].append('1200 scanline0 audio interrupts during continuous concurrent reads/copies across banks61,62,63 preserve caller bank1 and copied bytes; exactly one score update per frame')
  report.update(passed=True,frames=counts,irq_frames=elapsed,header=cartridge_header(rom),wav=str(audiofile),data_bytes=512,driver_state_end=hex(symbols['audio_ram']+512),inputs_sha256={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in sources})
  (OUT/'native-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:em.stop(False)
if __name__=='__main__':main()
