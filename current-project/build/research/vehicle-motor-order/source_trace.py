#!/usr/bin/env python3
"""Original7C18 -> CallSndUpdate -> main7143 motor/mailbox chronology.

No original instructions are patched. Calls cross the original function return
boundary, with declared RAM fixtures and released controls for the idle path.
"""
from pathlib import Path
import argparse, hashlib, json, sys
ROOT=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'tools'))
from verify_audio import Reference
from extract_scenes import label
ROM=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()

class MotorReference(Reference):
    def __init__(self):
        super().__init__()
        self.command_writes=[]
        def write(a,v):
            self.cpu.memory[a]=v
            if a==0xffff:self.cpu.memory[0x8000:0xc000]=ROM[v*16384:(v+1)*16384]
            if a==0xc004:self.command_writes.append(v)
        self.cpu.set_write_callback(write)
        for a in (0xffff,0xc004):self.cpu.mark_addr(a,self.cpu.WRITE_MARK)
    def motor(self,vehicle,count,moving=0,phase=0):
        c=self.cpu;c.memory[0xc30e]=vehicle;c.memory[0xc310]=count
        c.memory[0xc265]=moving;c.memory[0xc30f]=phase
        self.command_writes.clear();self.call(0x7c18)
        return {'command_writes':self.command_writes.copy(),
                'mailbox':c.memory[0xc004],'counter':c.memory[0xc310],
                'phase':c.memory[0xc30f]}
    def idle_main(self):
        c=self.cpu;c.memory[0xc265]=0;c.memory[0xc204]=0
        self.command_writes.clear();self.call(0x7143)
        assert self.command_writes==[0xd6]
        assert c.memory[0xc264]==c.memory[0xc265]==0
    def score(self):
        self.call(label('CallSndUpdate'))
        return bytes(self.writes),bytes(self.cpu.memory[0xc000:0xc200])

def sequence(name,vehicle,moving,old=0xd6,after=None,frames=24,commands=None):
    """Expected driver state after each real source tick plus main-thread write.

    A native queued implementation must run one tick on motor-or-old R4, then
    preserve a later ordinary command for the following tick. No extra tick.
    """
    ref=MotorReference();control=Reference();ref.tick(0x83);control.tick(0x83)
    rows=[];counter=0;phase=0
    for frame in range(frames):
        if frame==0:ref.cpu.memory[0xc004]=old
        if commands and frame in commands:ref.cpu.memory[0xc004]=commands[frame]
        before=ref.cpu.memory[0xc004]
        motor=ref.motor(vehicle,counter,moving,phase)
        counter,phase=motor['counter'],motor['phase']
        expected_psg,expected_ram=control.tick(motor['mailbox'])
        psg,ram=ref.score()
        assert psg==expected_psg and ram==expected_ram,(name,frame)
        if after=='idle':ref.idle_main();pending=0xd6
        elif isinstance(after,int)and frame==0:ref.cpu.memory[0xc004]=after;pending=after
        else:pending=None
        final=bytes(ref.cpu.memory[0xc000:0xc200])
        rows.append({'frame':frame,'before_motor':before,**motor,
                     'after_main':ref.cpu.memory[0xc004],
                     'main_command':pending,'psg_hex':psg.hex(),
                     'driver_after_tick_hex':ram.hex(),'driver_after_main_hex':final.hex()})
    return {'name':name,'vehicle':vehicle,'moving':moving,'old_command':old,
            'after_motor_main_command':after,'commands_before_motor':commands or {},'frames':rows}

def main():
    p=argparse.ArgumentParser();p.add_argument('--output',type=Path,default=Path(__file__).parent);a=p.parse_args();out=a.output.resolve();out.mkdir(parents=True,exist_ok=True)
    # Confirm the real world interrupt's ordering in unmodified pinned bytes.
    irq=ROM[label('LABEL_235'):label('LABEL_25F')]
    calls=[int.from_bytes(irq[i+1:i+3],'little')for i,b in enumerate(irq[:-2])if b==0xcd]
    assert calls.index(0x7c18)<calls.index(label('ReadJoypad'))<calls.index(label('CallSndUpdate'))
    ref=MotorReference();counter_cases=[]
    for vehicle in (0,4,8,12,14,15):
        for moving in (0,1):
            for counter in range(256):
                for phase in (0,1,2,255):
                    ref.cpu.memory[0xc004]=0xd6
                    got=ref.motor(vehicle,counter,moving,phase)
                    enabled=bool(vehicle and vehicle<14 and(vehicle==8 or moving))
                    expired=enabled and bool(((counter-1)&255)&128)
                    expected={'command_writes':[0xd1 if vehicle==8 else 0xd0]if expired else [],
                              'mailbox':(0xd1 if vehicle==8 else 0xd0)if expired else 0xd6,
                              'counter':3 if expired else(counter-1)&255 if enabled else counter,
                              'phase':((phase+1)&255)if expired and((phase+1)&255)<3 else 0 if expired else phase}
                    assert got==expected,(vehicle,moving,counter,phase,got,expected)
                    counter_cases.append([vehicle,moving,counter,phase,got])
    cases=[]
    for vehicle,moving in [(4,0),(4,1),(8,0),(8,1),(12,0),(12,1)]:
        cases.append(sequence(f'vehicle{vehicle:02x}-moving{moving}-oldD6',vehicle,moving))
        cases.append(sequence(f'vehicle{vehicle:02x}-moving{moving}-mainIdleD6',vehicle,moving,after='idle'))
    for command in (0x80,0x82,0x87,0x88,0x89,0xa0,0xab,0xb3,0xd0,0xd1,0xd5,0xd6,0xd8,0xd9):
        cases.append(sequence(f'hover-before-{command:02x}',8,0,old=command))
        cases.append(sequence(f'hover-after-{command:02x}',8,0,old=0xd6,after=command))
    for vehicle,moving in [(4,1),(8,0),(12,1)]:
        cases.append(sequence(f'vehicle{vehicle:02x}-score-menu-battle',vehicle,moving,frames=64,
                              commands={1:0x87,6:0xd5,9:0x89,14:0xab,19:0xd8,23:0x88,29:0xd9,35:0x83}))
    traces=out/'source-traces.json';traces.write_text(json.dumps({'counter_cases':counter_cases,'cases':cases},separators=(',',':'))+'\n')
    report={'passed':True,'original_rom_sha256':hashlib.sha256(ROM).hexdigest(),
            'script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
            'counter_phase_cases':len(counter_cases),'timeline_cases':len(cases),
            'score_frames':sum(len(x['frames'])for x in cases),
            'trace_sha256':hashlib.sha256(traces.read_bytes()).hexdigest(),
            'original_irq_calls':[f'{x:04X}'for x in calls],
            'scope':'Original unmodified Z80 motor handler7C18 and score CallSndUpdate; actual7143 released-control path emits newD6 after the score tick. All ordered PSG writes and512driver bytes match independently stepped original driver per frame. Declared fixture ordinary commands model their mailbox writes; this source oracle is not native integration or earned gameplay.',
            'findings':['Hover08 emits D1 on expiry even idle; other nonzero modes below0E emit D0 only while C265 is nonzero.','Expired countdown has original signed-byte behavior; count0 and129..255 expire, count1..128 decrement without motor.','Expiry overwrites any old C004, then one sound tick consumes the motor. New ordinary C004 written after that tick is pending for the next tick; another expired motor can overwrite it there.','Original no-direction main7143 emitsD6 after the interrupt score tick. Repeating hover-idle source frames alternates motor emission every4frames with idleD6; no added score tick.']}
    (out/'source-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
