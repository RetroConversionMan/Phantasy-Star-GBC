#!/usr/bin/env python3
"""Compare the native motor/IRQ mailbox chronology with original source traces.

Explicit fixture commands control the LCD between requests. Each request runs
one real installed scanline IRQ; production score objects are unchanged. This
tests scheduling, not vehicle art, whole-game integration or earned gameplay.
"""
from pathlib import Path
import argparse, hashlib, json, os, subprocess
from pyboy import PyBoy
from verify_rom import load_symbols, read_word, cartridge_header

ROOT = Path(__file__).resolve().parents[1]
MAIN = r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "audio.h"
uint8_t probe_request,probe_ready,probe_error;
uint8_t probe_old,probe_old_valid,probe_motor,probe_after,probe_after_valid,probe_early;
uint16_t probe_ticks,probe_done;
uint8_t probe_snapshot[512];
void main(void) {
 uint16_t before;
 cpu_fast();DISPLAY_OFF;HIDE_SPRITES;HIDE_WIN;
 audio_install();SWITCH_ROM_MBC5(1);probe_ready=0x55;
 while(1) {
  if(probe_request==1u) {
   audio_init();audio_command(0x83u);audio_tick();
   memcpy(probe_snapshot,audio_ram,512u);probe_request=0;
  } else if(probe_request==2u) {
   if(probe_old_valid)audio_command(probe_old);
   if(probe_motor)audio_command_before_tick(probe_motor);
   if(probe_early&&probe_after_valid)audio_command(probe_after);
   before=audio_frames;DISPLAY_ON;
   while(audio_frames==before){}
   DISPLAY_OFF;
   probe_ticks=audio_frames-before;
   if(!probe_early&&probe_after_valid)audio_command(probe_after);
   memcpy(probe_snapshot,audio_ram,512u);
   if(CURRENT_BANK!=1u)probe_error=1u;
   ++probe_done;probe_request=0;
  } else if(probe_request==3u) {
   audio_command(0x83u);DISPLAY_ON;probe_request=0;
  } else if(probe_request==4u) {
   DISPLAY_OFF;probe_request=0;
  }
 }
}
'''

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--helper',type=Path,required=True)
    parser.add_argument('--objects',type=Path,required=True)
    parser.add_argument('--traces',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    args=parser.parse_args()
    helper=args.helper.resolve();objects=args.objects.resolve();out=args.output.resolve()
    out.mkdir(parents=True,exist_ok=True)
    traces=json.loads(args.traces.read_text())
    source=out/'main.c';source.write_text(MAIN)
    audio_objects=[objects/f'{n}.o' for n in ['audio','audio_data','audio_tables','audio_low_62','audio_low_63','bank_io']]
    lcc='.tools/gbdk/bin/lcc'
    def rel(path):return os.path.relpath(path,ROOT)
    built=[]
    for path in [source,helper/'audio_irq.c']:
        obj=out/(path.stem+'.o');built.append(obj)
        subprocess.run([lcc,'-msm83:gb','-I'+rel(helper),'-c','-o',rel(obj),rel(path)],cwd=ROOT,check=True)
    rom=out/'audio-motor-order.gbc'
    subprocess.run([lcc,'-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo64','-Wm-ya1','-Wm-ynPSMOTOR-ORDER','-Wl-m','-Wl-j','-o',rel(rom),*[rel(x) for x in [*built,*audio_objects]]],cwd=ROOT,check=True)
    import sys
    subprocess.run([sys.executable,str(ROOT/'tools/verify_layout.py'),str(rom)],cwd=ROOT,check=True)
    s=load_symbols(rom.with_suffix('.noi'))
    e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR')
    e.set_emulation_speed(0)
    def byte(n):return e.memory[s[n]]
    def put(n,v):e.memory[s[n]]=v
    def issue(command):
        put('probe_request',command)
        for _ in range(20):
            assert e.tick()
            if not byte('probe_request'):return
        raise AssertionError(('Native request hung',command,read_word(e,s['audio_frames']),hex(e.memory[0xff40]),e.memory[0xff44]))
    for _ in range(300):
        e.tick()
        if byte('probe_ready')==0x55:break
    assert byte('probe_ready')==0x55
    guard=bytes((i*19+3)&255 for i in range(64));e.memory[0xdbc0:0xdc00]=guard
    total=0;early=0;records=[]
    # Both legal native timings: later main command arrives before the queued
    # IRQ (must be preserved) or after it (ordinary byte mailbox semantics).
    for timing in ('before_irq','after_irq'):
        for case in traces['cases']:
            issue(1)
            for row in case['frames']:
                commands=case['commands_before_motor']
                old=case['old_command'] if row['frame']==0 else commands.get(str(row['frame']))
                put('probe_old_valid',old is not None);put('probe_old',old or 0)
                writes=row['command_writes'];motor=writes[-1] if writes else 0
                after=row['main_command']
                put('probe_motor',motor);put('probe_after_valid',after is not None);put('probe_after',after or 0)
                is_early=timing=='before_irq' and motor!=0
                put('probe_early',is_early);early+=bool(is_early and after is not None)
                issue(2)
                got=bytes(e.memory[s['probe_snapshot']:s['probe_snapshot']+512])
                expected=bytes.fromhex(row['driver_after_main_hex'])
                assert got==expected,(timing,case['name'],row['frame'],[(hex(0xc000+i),expected[i],got[i])for i in range(512)if got[i]!=expected[i]])
                assert read_word(e,s['probe_ticks'])==1,(timing,case['name'],row['frame'],'extra score ticks')
                assert not byte('probe_error') and not byte('audio_fault')
                assert bytes(e.memory[0xdbc0:0xdc00])==guard
                total+=1
            records.append({'timing':timing,'case':case['name'],'score_ticks':len(case['frames'])})
    issue(3);e.tick(2);start=read_word(e,s['audio_frames']);e.tick(1200)
    elapsed=(read_word(e,s['audio_frames'])-start)&65535
    assert elapsed==1200,('Idle installed IRQ cadence',elapsed)
    assert not byte('audio_fault') and not byte('probe_error')
    issue(4);e.stop(save=False)
    report={'passed':True,'header':cartridge_header(rom),'timeline_cases':len(records),'score_ticks':total,'exact_source_driver_bytes':512*total,'later_command_before_irq_cases':early,'continuous_irq_frames':elapsed,'guard_bytes':64,'cases':records,'source_trace_sha256':sha(args.traces),'helper_files':{p.name:sha(p)for p in [helper/'audio_irq.c',helper/'audio.h']},'production_objects':{p.name:sha(p)for p in audio_objects},'test_script_sha256':sha(Path(__file__)),'scope':__doc__}
    (out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items()if k!='cases'},indent=2))

if __name__=='__main__':main()
