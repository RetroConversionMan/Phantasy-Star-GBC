#!/usr/bin/env python3
"""Extend frozen motor source oracle with reset and moving/stopped boundaries."""
from pathlib import Path
import hashlib,json
from source_trace import MotorReference,Reference,ROM,sequence

def alternating(name,vehicle,pattern,frames=96):
    ref=MotorReference();control=Reference();ref.tick(0x83);control.tick(0x83)
    rows=[];counter=0;phase=0
    commands={7:0x87,19:0xd5,26:0x89,37:0xab,43:0xd8,55:0,63:0x83,71:0x80,83:0xd9}
    for frame in range(frames):
        moving=pattern[frame%len(pattern)]
        if frame==0:ref.cpu.memory[0xc004]=0xd6
        if frame in commands:ref.cpu.memory[0xc004]=commands[frame]
        before=ref.cpu.memory[0xc004]
        motor=ref.motor(vehicle,counter,moving,phase)
        counter,phase=motor['counter'],motor['phase']
        expected_psg,expected_ram=control.tick(motor['mailbox'])
        psg,ram=ref.score();assert psg==expected_psg and ram==expected_ram,(name,frame)
        pending=None
        if not moving:ref.idle_main();pending=0xd6
        rows.append({'frame':frame,'moving':moving,'before_motor':before,**motor,
                     'after_main':ref.cpu.memory[0xc004],'main_command':pending,
                     'psg_hex':psg.hex(),'driver_after_tick_hex':ram.hex(),
                     'driver_after_main_hex':bytes(ref.cpu.memory[0xc000:0xc200]).hex()})
    return {'name':name,'vehicle':vehicle,'moving':pattern,'old_command':0xd6,
            'after_motor_main_command':'actual7143 on stopped frames',
            'commands_before_motor':commands,'frames':rows}

def main():
    out=Path(__file__).parent
    original=json.loads((out/'source-traces.json').read_text())
    cases=original['cases'].copy();added=[]
    for vehicle,moving in [(4,1),(8,0),(12,1)]:
        for old,after in [(0,None),(0,0xd6),(0xd6,0),(0,0),(0,0x80),(0x80,0),(0xd6,0x80)]:
            added.append(sequence(f'vehicle{vehicle:02x}-old{old:02x}-after{after if after is not None else "none"}',vehicle,moving,old=old,after=after))
        for pattern in ([0,1],[1]*8+[0]*8,[0]*7+[1]*9+[0]*3+[1]*5):
            added.append(alternating(f'vehicle{vehicle:02x}-alternating-{len(pattern)}',vehicle,pattern))
    cases+=added
    trace=out/'source-traces-v2.json';trace.write_text(json.dumps({'counter_cases':original['counter_cases'],'cases':cases},separators=(',',':'))+'\n')
    report={'passed':True,'original_rom_sha256':hashlib.sha256(ROM).hexdigest(),
            'base_trace_sha256':hashlib.sha256((out/'source-traces.json').read_bytes()).hexdigest(),
            'base_script_sha256':hashlib.sha256((out/'source_trace.py').read_bytes()).hexdigest(),
            'extension_script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'counter_phase_cases':len(original['counter_cases']),'timeline_cases':len(cases),
            'added_timeline_cases':len(added),'score_frames':sum(len(x['frames'])for x in cases),
            'trace_sha256':hashlib.sha256(trace.read_bytes()).hexdigest(),
            'coverage':['Old0 reset is discarded when motor expires; retained if no motor expires.','New0 survives after the motor tick and resets the source driver next tick unless a newly expired motor overwrites it.','Later80 remains the exact source idle mailbox value.','Land/hover/ice alternate moving and stopped, including one-frame alternation, full8frame vehicle steps and irregular pauses; only hover continues its counter while stopped. Actual7143 emitsD6 on every stopped main step.'],
            'scope':'Extension of source-only frozen oracle. Ordinary commands and moving/stopped inputs are declared fixtures; actual7C18, CallSndUpdate and idle7143 instructions execute. Native helper proof remains separate.'}
    (out/'source-report-v2.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
