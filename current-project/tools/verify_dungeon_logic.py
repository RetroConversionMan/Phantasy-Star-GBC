#!/usr/bin/env python3
"""Verify real C dungeon traversal against pinned ROM data and source branches."""
import ctypes as C
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
from collections import Counter
ROOT=Path(__file__).resolve().parents[1]
class State(C.Structure):
    _fields_=[(n,C.c_uint8) for n in ('floor','position','direction','light','encounter_rate','encounter_pool','palette_index','music')]+[('layout',C.c_uint8*256)]
class Action(C.Structure):
    _fields_=[(n,C.c_uint8) for n in ('mode','target','a','b','interaction','step_count')]+[('positions',C.c_uint8*2)]
class Object(C.Structure):
    _fields_=[('flag_address',C.c_uint16)]+[(n,C.c_uint8) for n in ('type','a','b','position','view')]
def addr(bank,cpu):return bank*16384+(cpu&16383)
def main():
    rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
    sha=hashlib.sha256(rom).hexdigest();assert sha=='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
    layouts=[]
    for floor in range(61):
        raw=rom[addr(15,0x9f6e)+floor*128:addr(15,0x9f6e)+(floor+1)*128]
        layouts.append(bytes(n for b in raw for n in (b>>4,b&15)))
    objects={};p=addr(3,0xaf5c)
    while rom[p]!=255:
        floor,pos,lo,hi,typ,a,b=rom[p:p+7];objects.setdefault((floor,pos),(lo|hi<<8,typ,a,b));p+=7
    transitions={};p=addr(3,0xb473)
    while rom[p]!=255:
        floor,pos,target,a,b=rom[p:p+5];transitions[(floor,pos)]=(target,a,b);p+=5
    offsets=rom[0x6c06:0x6c46];natural=set(rom[0x6dfe:0x6e04]);counts=Counter()
    info=rom[addr(3,0xb619):addr(3,0xb619)+61*4]
    def expect(floor,pos,direction,command,opened=False):
        # Source flow: initial trap dispatch precedes input, byte-address
        # geometry samples precede type dispatch. Results stop before effects.
        if layouts[floor][pos]==8 and (floor,pos) not in objects:
            return 5,max(0,floor-1),pos,direction,0
        if command in (3,4):return 2,floor,pos,(direction+(3 if command==3 else 1))&3,0
        if command==0:return 0,floor,pos,direction,0
        ahead=(pos+offsets[direction*16+(11 if command==2 else 1)])&255
        cell=layouts[floor][ahead];typ=cell&7
        if command==5:return (3 if typ==4 and not opened else 14),floor,pos,direction,0
        if command==2:return (0,floor,pos,direction,0) if typ else (1,floor,ahead,direction,1)
        if typ==1:return 0,floor,pos,direction,0
        if typ in (4,5,6) and not opened:return 0,floor,pos,direction,0
        if typ in (2,3,4,5,6) and cell&8:
            row=transitions.get((floor,ahead))
            return (13 if row is None else 8 if row[0]<128 else 12),floor,pos,direction,0
        if typ in (2,3):
            nf=(floor+(1 if typ==2 else -1))&255
            if nf>=61:return 255,floor,pos,direction,0
            return 4,nf,(pos+2*offsets[direction*16+1])&255,direction,2
        if typ in (4,5,6,7):return 1,floor,(pos+2*offsets[direction*16+1])&255,direction,2
        return 1,floor,ahead,direction,1
    with tempfile.TemporaryDirectory(prefix='ps-dungeon-test-') as temp:
        libpath=Path(temp)/'dungeon.dylib'
        subprocess.run(['cc','-std=c99','-O2','-Wno-unknown-pragmas','-dynamiclib','-o',str(libpath),
                        *[str(ROOT/'src'/n) for n in ('dungeon.c','dungeon_data.c','bank_io.c')]],check=True)
        lib=C.CDLL(str(libpath))
        for name,args,result in [
          ('dungeon_enter',[C.POINTER(State),C.c_uint8,C.c_uint8,C.c_uint8],C.c_uint8),
          ('dungeon_load_floor',[C.POINTER(State),C.c_uint8],C.c_uint8),
          ('dungeon_refresh_light',[C.POINTER(State)],None),
          ('dungeon_sample',[C.POINTER(State),C.c_uint8],C.c_uint8),
          ('dungeon_step',[C.POINTER(State),C.c_uint8,C.POINTER(Action)],C.c_uint8),
          ('dungeon_transition',[C.POINTER(State),C.POINTER(Action)],C.c_uint8),
          ('dungeon_find_object',[C.POINTER(State),C.c_uint8,C.POINTER(Object)],C.c_uint8),
          ('dungeon_active_object',[C.POINTER(State),C.c_uint8,C.POINTER(C.c_uint8),C.POINTER(C.c_uint8),C.POINTER(Object)],C.c_uint8),
        ]:
            f=getattr(lib,name);f.argtypes=args;f.restype=result
        for floor in range(61):
            original=State();assert lib.dungeon_enter(C.byref(original),floor,0,0)
            assert bytes(original.layout)==layouts[floor];counts['layout_cells']+=256
            assert original.light==(info[floor*4+2]+1 if floor in natural else 0)
            assert (original.encounter_rate,original.encounter_pool,original.music)==tuple(info[floor*4:floor*4+2])+ (info[floor*4+3],)
            original.light=1;lib.dungeon_refresh_light(C.byref(original));assert original.light==info[floor*4+2]+1
            original.light=0;lib.dungeon_refresh_light(C.byref(original))
            for pos in range(256):
                for direction in range(4):
                    original.position=pos;original.direction=direction
                    for view in range(16):
                        expected=layouts[floor][(pos+offsets[direction*16+view])&255]
                        assert lib.dungeon_sample(C.byref(original),view)==expected
                        counts['relative_samples']+=1
                    for command in range(6):
                        s=State.from_buffer_copy(original);a=Action();lib.dungeon_step(C.byref(s),command,C.byref(a))
                        want=expect(floor,pos,direction,command)
                        got=(a.mode,s.floor,s.position,s.direction,a.step_count)
                        assert got==want,(floor,pos,direction,command,got,want)
                        if s.floor!=floor:assert bytes(s.layout)==layouts[s.floor]
                        counts['commands']+=1;counts['outcome_'+str(a.mode)]+=1
                    ahead=(pos+offsets[direction*16+1])&255
                    if layouts[floor][ahead]&7 in (4,5,6):
                        s=State.from_buffer_copy(original);s.layout[ahead]|=128;a=Action()
                        lib.dungeon_step(C.byref(s),1,C.byref(a));want=expect(floor,pos,direction,1,True)
                        assert (a.mode,s.floor,s.position,s.direction,a.step_count)==want
                        counts['opened_door_commands']+=1
            original.layout[0]|=128;assert lib.dungeon_load_floor(C.byref(original),floor)
            assert original.layout[0]==layouts[floor][0];counts['door_reset_checks']+=1
        for (floor,pos),(target,pa,pb) in transitions.items():
            s=State();assert lib.dungeon_enter(C.byref(s),floor,(pos+16)&255,0)
            a=Action();lib.dungeon_transition(C.byref(s),C.byref(a))
            # Dormant table entries must not bypass the source bit3 check.
            if not layouts[floor][pos]&8:
                assert a.mode==0
                counts['inactive_transition_records']+=1
                continue
            assert (a.target,a.a,a.b)==(target,pa,pb)
            assert a.mode==(8 if target<128 else 12)
            if target>=128:assert a.interaction=={255:15,254:13,253:30,252:255}[target]
            counts['transition_records']+=1
        for (floor,pos),(flag,typ,pa,pb) in objects.items():
            s=State();lib.dungeon_enter(C.byref(s),floor,(pos+16)&255,0)
            obj=Object();found=lib.dungeon_find_object(C.byref(s),1,C.byref(obj))
            if layouts[floor][pos]!=8:
                assert not found;counts['inactive_object_records']+=1;continue
            assert found,(floor,pos)
            assert (obj.flag_address,obj.type,obj.a,obj.b,obj.position,obj.view)==(flag,typ,pa,pb,pos,1)
            sf=(C.c_uint8*256)();of=(C.c_uint8*256)();arr=sf if flag>>8==0xc5 else of
            for value in (0,1,127,254,255):
                arr[flag&255]=value
                assert lib.dungeon_active_object(C.byref(s),1,sf,of,C.byref(obj))==int(value!=255)
                counts['object_flag_cases']+=1
            counts['object_records']+=1
        s=State();assert not lib.dungeon_enter(C.byref(s),61,0,0)
        assert not lib.dungeon_enter(C.byref(s),0,0,4)
    report={'passed':True,'source_sha256':sha,**counts,
            'limits':['Host traversal kernel only; not playable dungeon integration',
                      'No renderer, movement/door animations, object effects, battle or event dispatch',
                      'Runtime guards reject out-of-range floor/direction instead of reading unrelated ROM']}
    path=ROOT/'build/verification/dungeon-logic-report.json';path.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
if __name__=='__main__':main()
