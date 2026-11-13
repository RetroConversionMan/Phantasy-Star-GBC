#!/usr/bin/env python3
"""Validate planned Ice Digger paths against actual native C/source ROM data.

Host geometry only. Fixtures never enter the controller campaign.
"""
import ctypes as C
import hashlib
import json
from pathlib import Path
import subprocess
import tempfile
from campaign_world_route import route_cells, DIRECTIONS
from campaign_hover_route import plan_hover
from verify_world_logic import ROOT, ROM_SHA, source_group, Action


def main():
    original = (ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
    assert hashlib.sha256(original).hexdigest() == ROM_SHA
    grid, flags, _ = source_group(original, 2)
    results = []
    with tempfile.TemporaryDirectory(prefix='campaign-ice-routes-') as temporary:
        library = Path(temporary)/'world.dylib'
        sources = [ROOT/'src'/p for p in ('world.c','bank_io.c','world_assets.c')]
        sources += sorted((ROOT/'src').glob('world_assets_*_*.c'))
        subprocess.run(['cc','-std=c99','-O2','-Wno-unknown-pragmas','-dynamiclib',
                        '-o',str(library),*[str(p) for p in sources]], check=True)
        native = C.CDLL(str(library))
        for name, origin, goals, expected in [
            ('Laconia Armor cave', (43,47), {(78,4),(79,4),(78,5),(79,5)}, (10,42)),
            ('Laconia Shield cave', (95,35), {(10,33),(11,33)}, (10,52)),
            ('Titan cave', (43,47), {(70,83),(71,83)}, (10,58)),
            ('Laerma tree', (23,75), {(5,4)}, (12,6)),
        ]:
            native.world_select(2)
            x,y,vehicle = C.c_uint16(origin[0]*16+8),C.c_uint16(origin[1]*16+16),C.c_uint8(0)
            assert native.world_vehicle_use(C.byref(x),C.byref(y),0,6,12,C.byref(vehicle)) == 1
            native.world_vehicle_footprint(x.value,y.value,12)
            start = ((x.value-8)//16, (y.value+1536-16)%1536//16)
            path = route_cells(grid,flags,start,goals,2,(),12)
            for index,key in enumerate(path):
                direction = {'down':0,'up':1,'left':2,'right':3}[key]
                assert native.world_step_allowed(x.value,y.value,direction,12), (name,index,key)
                dx,dy = DIRECTIONS[key]
                x.value=(x.value+dx*16)%2048
                y.value=(y.value+dy*16)%1536
                native.world_terrain_sync(x.value,y.value)
                action=Action()
                native.world_check_trigger(x.value,y.value,12,C.byref(action))
                if index+1<len(path):
                    assert action.mode == 0, (name,index,list(bytes(action)))
            assert (action.mode,action.target) == expected, (name,list(bytes(action)))
            results.append({'name':name,'steps':len(path),'actual_source_action':list(bytes(action))})
        native.world_select(1)
        grid,flags,_=source_group(original,1)
        plan=plan_hover(grid,flags,(115,63),{(42,71),(43,71)},1)
        x,y,vehicle=C.c_uint16(115*16+8),C.c_uint16(63*16+16),C.c_uint8(0)
        facing=0
        def walk(path):
            nonlocal facing
            for key in path:
                facing={'down':0,'up':1,'left':2,'right':3}[key]
                assert native.world_step_allowed(x.value,y.value,facing,vehicle.value),(key,x.value,y.value,vehicle.value)
                dx,dy=DIRECTIONS[key];x.value=(x.value+dx*16)%2048;y.value=(y.value+dy*16)%1536
                action=Action();native.world_check_trigger(x.value,y.value,vehicle.value,C.byref(action))
                assert not action.mode,(key,list(bytes(action)))
        walk(plan['foot_path'])
        assert native.world_vehicle_use(C.byref(x),C.byref(y),facing,1,8,C.byref(vehicle))==1
        assert ((x.value-8)//16,(y.value+1536-16)%1536//16)==plan['board']
        walk(plan['sea_path'])
        assert native.world_vehicle_use(C.byref(x),C.byref(y),facing,1,8,C.byref(vehicle))==2
        land=((x.value-8)//16,(y.value+1536-16)%1536//16)
        assert land==plan['exit_land'][facing]
        path=route_cells(grid,flags,land,{(42,71),(43,71)},1)
        walk(path[:-1]);key=path[-1];facing={'down':0,'up':1,'left':2,'right':3}[key]
        assert native.world_step_allowed(x.value,y.value,facing,0)
        dx,dy=DIRECTIONS[key];x.value=(x.value+dx*16)%2048;y.value=(y.value+dy*16)%1536
        action=Action();native.world_check_trigger(x.value,y.value,0,C.byref(action))
        assert tuple(bytes(action))[:4]==(10,36,217,0)
        results.append({'name':'Original Hovercraft to Tarzimal island','foot_steps':len(plan['foot_path'])+len(path),'sea_steps':len(plan['sea_path']),'boarding':plan['board'],'disembark':land,'actual_source_action':list(bytes(action))})
    report={'passed':True,'scope':'Host source/native geometry; no campaign state injection',
            'source_sha256':ROM_SHA,'routes':results}
    output=ROOT/'build/verification/campaign-world-routes'
    output.mkdir(parents=True,exist_ok=True)
    (output/'report.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))


if __name__=='__main__':main()
