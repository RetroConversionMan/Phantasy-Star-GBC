#!/usr/bin/env python3
"""Capture every native music/effect command for listening; no subjective review claim."""
from pathlib import Path
import hashlib,json,subprocess,wave
import numpy as np
from pyboy import PyBoy
from verify_rom import load_symbols,read_word,cartridge_header
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "audio.h"
volatile uint8_t review_ready,review_pending,review_command;
void main(void){
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;SWITCH_ROM_MBC5(1);
 audio_install();DISPLAY_ON;review_ready=1;
 while(1){vsync();if(review_pending){audio_command(review_command);review_pending=0;}}
}
'''
def main():
 out=ROOT/'build/verification/audio-review';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 sources=[out/'main.c']+[ROOT/'src'/s for s in ('audio.c','audio_data.c','audio_tables.c','audio_low_62.c','audio_low_63.c','audio_irq.c','bank_io.c')];rom=out/'audio-review.gbc'
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo64','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),*map(str,sources)],cwd=ROOT,check=True)
 symbols=load_symbols(rom.with_suffix('.noi'));cases=[]
 for command in [*range(0x81,0x95),*range(0xa0,0xd5)]:
  music=command<0xa0;frames=600 if music else 180;name=f'{"music"if music else"effect"}-{command:02x}'
  e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0)
  try:
   e.tick(180);assert e.memory[symbols['review_ready']]
   def send(value):
    e.memory[symbols['review_command']]=value;e.memory[symbols['review_pending']]=1
    for _ in range(20):
     e.tick(1)
     if not e.memory[symbols['review_pending']]:return
    raise AssertionError('Audio command mailbox timeout')
   if not music:send(0x85);e.tick(60)
   send(command);before=read_word(e,symbols['audio_frames']);samples=[];registers=set()
   for _ in range(frames):
    e.tick(1);samples.append(e.sound.ndarray.copy());registers.add(bytes(e.memory[0xff10:0xff26]))
    assert not e.memory[symbols['audio_fault']],(name,e.memory[symbols['audio_fault']])
   after=read_word(e,symbols['audio_frames']);ticks=(after-before)&65535
   assert abs(ticks-frames)<=1,(name,ticks,frames)
   pcm=np.concatenate(samples,axis=0);span=int(pcm.max())-int(pcm.min());assert span>0,(name,'silent native APU')
   output=out/(name+'.wav')
   with wave.open(str(output),'wb')as f:
    f.setnchannels(2);f.setsampwidth(1);f.setframerate(e.sound.sample_rate);f.writeframes((pcm.astype(np.int16)+128).astype(np.uint8).tobytes())
   cases.append({'command':f'{command:02X}','kind':'music'if music else'effect over85','physical_frames':frames,'score_updates':ticks,'peak_to_peak':span,'distinct_APU_register_states':len(registers),'samples':len(pcm),'sample_rate':e.sound.sample_rate,'wav':str(output.relative_to(ROOT)),'wav_sha256':hashlib.sha256(output.read_bytes()).hexdigest()})
  finally:e.stop(save=False)
 report={'passed':True,'header':cartridge_header(rom),'music_commands':20,'effect_commands':53,'native_frames':sum(c['physical_frames']for c in cases),'scope':'Native GBC APU captures under the production scanline0 score scheduler; no injected game state and no source-driver substitutions. Effect clips include track85 underneath. Machine checks establish non-silent PCM, continuing score IRQs and no driver fault, not subjective sound quality or effect identity.','listened_to':False,'hardware_tested':False,'input_sha256':{p.name:hashlib.sha256(p.read_bytes()).hexdigest()for p in sources},'cases':cases}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='cases'},indent=2))
if __name__=='__main__':main()
