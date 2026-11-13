#!/usr/bin/env python3
"""Compare compiled world-pattern scheduling with executed original62BC/630A.

The original routine runs without patched instructions; actual VDP writes are
captured. This is source/host evidence, not native cartridge integration proof.
"""
from pathlib import Path
import argparse, ctypes as C, hashlib, json, struct, subprocess, tempfile
from ending_reference import Ending, ROM, ROOT
from extract_scenes import label
from extract_world_motion import RANGES, RELOADS, TABLES
from extract_assets import address

class OriginalWorld(Ending):
    def __init__(self,group,road=0,seed=None):
        self.writes=[]
        super().__init__()
        c=self.main
        c.memory[0xC26F:0xC287]=bytes(24)
        for i,reload in enumerate(RELOADS):
            c.memory[0xC26F+i*4]=ROM[0xDF1+group*14+3+i]
            c.memory[0xC270+i*4]=reload
        if road:
            c.memory[0xC26F:0xC287]=bytes(24)
            c.memory[0xC27B]=1
        c.memory[0xC2E9]=road
        if seed is not None:
            for i in range(6):
                c.memory[0xC271+i*4]=seed
                c.memory[0xC272+i*4]=(seed+i*17)&255
    def output(self,c,port,value):
        if port&255==0xBE:
            self.writes.append((self.address,value))
        super().output(c,port,value)
    def step(self):
        self.writes=[]
        self.run(self.main,label('LABEL_62BC'),0xDFFC)
        clocks=[self.main.memory[0xC271+i*4] for i in range(6)]
        phases=[self.main.memory[0xC272+i*4] for i in range(6)]
        slot=255
        if self.writes:
            first=self.writes[0][0]
            slot=next(i for i,(tile,_) in enumerate(RANGES) if tile*32==first)
            tile,count=RANGES[slot]
            assert [a for a,_ in self.writes]==list(range(tile*32,(tile+count)*32))
            pointer=struct.unpack_from('<H',ROM,TABLES[slot]+(phases[slot]&7)*2)[0]
            expected=ROM[address(14,pointer):address(14,pointer)+count*32]
            assert bytes(v for _,v in self.writes)==expected,'Original phase pointer/VDP payload differs'
        return slot,clocks,phases

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source',type=Path,required=True)
    p.add_argument('--output',type=Path,required=True)
    args=p.parse_args();src=args.source.resolve()/'src';out=args.output.resolve();out.mkdir(parents=True,exist_ok=True)
    sources=[src/n for n in ('world.c','bank_io.c','world_assets.c','world_motion.c','world_motion_data.c')]
    sources+=sorted(src.glob('world_assets_*_*.c'))+sorted(src.glob('world_motion_bank_*.c'))
    records=[];checks=written=0
    with tempfile.TemporaryDirectory(prefix='ps-world-motion-host-') as tmp:
        libfile=Path(tmp)/'world-motion.dylib'
        subprocess.run(['cc','-std=c99','-O2','-Wno-unknown-pragmas','-dynamiclib','-o',str(libfile),*[str(x) for x in sources]],check=True)
        lib=C.CDLL(str(libfile));lib.world_select.argtypes=[C.c_uint8];lib.world_motion_reset.argtypes=[C.c_uint8];lib.world_motion_step.restype=C.c_uint8
        group=C.c_uint8.in_dll(lib,'world_group_id');clock=(C.c_uint8*6).in_dll(lib,'world_motion_countdown');phase=(C.c_uint8*6).in_dll(lib,'world_motion_phase')
        cases=[(g,0,None,512) for g in range(11)]+[(g,road,None,512) for g in range(2) for road in range(1,7)]
        cases += [(0,road,seed,1) for road in (0,4) for seed in range(256)]
        for g,road,seed,steps in cases:
            original=OriginalWorld(g,road,seed);group.value=g;lib.world_motion_reset(road)
            if seed is not None:
                for i in range(6):clock[i]=seed;phase[i]=(seed+i*17)&255
            rows=[]
            for tick in range(steps):
                expected=original.step();actual=(lib.world_motion_step(),list(clock),list(phase))
                assert actual==expected,(g,road,seed,tick,actual,expected)
                checks+=1;written+=len(original.writes)
                rows.append([expected[0],expected[1],expected[2]])
            records.append({'group':g,'road':road,'initial_counter_seed':seed,'ticks':steps,'trace':rows})
            if seed is None:print(json.dumps({'group':g,'road':road,'ticks':steps,'passed':True}),flush=True)
    trace=out/'source-host-traces.json';trace.write_text(json.dumps(records,separators=(',',':'))+'\n')
    report={'passed':True,'original_rom_sha256':hashlib.sha256(ROM).hexdigest(),'source_entry':'62BC/630A','source_bank':14,
            'logical_ticks_compared':checks,'source_vdp_payload_bytes_compared':written,'cases':len(records),
            'source_path':str(args.source),'source_files':{str(x.relative_to(src)):hashlib.sha256(x.read_bytes()).hexdigest() for x in sources},
            'trace_sha256':hashlib.sha256(trace.read_bytes()).hexdigest(),
            'coverage':['all11mapgroups','all6roadtags inbothanimatedgroups','sourcefirst-expired-slot earlyreturn','all256counter-byte/sign cases','forward/reversephase bytewrap','originalphasepointer/contiguousVDPpayload'],
            'scope':'Compiled host C scheduler versus actual original Z80; native rendering and campaign are separate checks'}
    (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='source_files'},indent=2))

if __name__=='__main__':main()
