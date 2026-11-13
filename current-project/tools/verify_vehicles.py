#!/usr/bin/env python3
"""Actual native C vehicle geometry against independently read original tables."""
import ctypes as C,hashlib,json,subprocess,tempfile
from pathlib import Path
from verify_world_logic import ROOT,ROM_SHA,source_group
from extract_scenes import label

def source_use(rom,grid,flags,group,x,y,facing,interaction,requested,current):
    leaving=requested==current
    if requested not in (4,8,12) or facing>3:return 0,x,y,current
    if not leaving and (group>=4 or not interaction or requested==12 and group!=2):return 0,x,y,current
    offsets=rom[label('LABEL_7A8D'):label('LABEL_7A8D')+44]
    def blocked(code,mask):
        mx=((x-136+offsets[code+1])%2048)//16
        my=((y-112+offsets[code])%1536)//16
        return bool(flags[grid[my*128+mx]]&mask)
    signed=lambda v:v if v<128 else v-256
    if requested!=8:
        data=rom[label('LABEL_7A35'):label('LABEL_7A35')+16]
        candidates=[(data[i:i+4],13,16*(i//8),16*((i//4)&1))for i in range(0,16,4)]
    elif not leaving:
        data=rom[label('LABEL_7A45'):label('LABEL_7A45')+48]
        candidates=[(data[i:i+4],10,signed(data[i+4]),signed(data[i+5]))for i in range(0,48,6)]
    else:
        data=rom[label('LABEL_7A75'):label('LABEL_7A75')+24]
        # C2D7 holds the current vehicle art index. Its low two bits differ
        # from the native facing enum: original5A94 maps up0,right1,down2,left3.
        start=(2,0,3,1)[facing]*6
        candidates=[]
        for n in range(8):
            i=(start+n*3)%24;candidates.append(([data[i]],13,signed(data[i+1]),signed(data[i+2])))
    for codes,mask,dy,dx in candidates:
        if not any(blocked(c,mask)for c in codes):return 2 if leaving else 1,(x+dx)%2048,(y+dy)%1536,0 if leaving else requested
    return 0,x,y,current

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==ROM_SHA
 groups=[source_group(rom,g)for g in range(11)];mapping=rom[0xdc1:0xdd9]
 counters={'entry_exit_cases':0,'movement_cases':0,'footprint_cases':0,'changed_cells':0,'reload_resets':0,'gates':0}
 with tempfile.TemporaryDirectory(prefix='ps-vehicle-')as temp:
  library=Path(temp)/'world.dylib';sources=[ROOT/'src'/p for p in ('world.c','bank_io.c','world_assets.c')]+sorted((ROOT/'src').glob('world_assets_*_*.c'))
  subprocess.run(['cc','-std=c99','-O2','-Wall','-Wextra','-Wno-unknown-pragmas','-dynamiclib','-o',str(library),*[str(p)for p in sources]],check=True)
  lib=C.CDLL(str(library))
  word=C.c_uint16;byte=C.c_uint8
  for name,args,result in [
   ('world_select',[byte],byte),('world_meta_at',[word,word],byte),('world_flags_at',[word,word],byte),
   ('world_vehicle_use',[C.POINTER(word),C.POINTER(word),byte,byte,byte,C.POINTER(byte)],byte),
   ('world_step_allowed',[word,word,byte,byte],byte),('world_terrain_sync',[word,word],None),
   ('world_vehicle_footprint',[word,word,byte],None)]:
   f=getattr(lib,name);f.argtypes=args;f.restype=result
  changed=byte.in_dll(lib,'world_ice_changed')
  def use(x,y,facing,interaction,requested,current):
   xx,yy,v=word(x),word(y),byte(current)
   result=lib.world_vehicle_use(C.byref(xx),C.byref(yy),facing,interaction,requested,C.byref(v))
   return result,xx.value,yy.value,v.value
  def native_cell(mx,my):return lib.world_meta_at(mx*16,my*16)
  for group,(grid,flags,_)in enumerate(groups):
   mapid=list(mapping).index(group);lib.world_select(mapid)
   for my in range(96):
    for mx in range(128):
     x=mx*16+8;y=(my*16+16)%1536
     for facing,requested,current in [(0,4,0),(0,8,0),(0,12,0),(0,4,4)]+[(f,8,8)for f in range(4)]:
      expected=source_use(rom,grid,flags,group,x,y,facing,1,requested,current)
      actual=use(x,y,facing,1,requested,current)
      assert actual==expected,(group,mx,my,facing,requested,current,actual,expected)
      counters['entry_exit_cases']+=1
     for mode in (0,4,8):
      for facing,source_code in enumerate((4,2,6,8)):
       table=label('LABEL_7A21'if not mode else'LABEL_7A2B')
       codes=rom[table+source_code:table+source_code+(2 if mode else 1)]
       offsets=rom[label('LABEL_7A8D'):label('LABEL_7A8D')+44]
       values=[flags[grid[((y-112+offsets[c])%1536)//16*128+((x-136+offsets[c+1])%2048)//16]]for c in codes]
       expected=int(not any(v&(10 if mode==8 else 1)for v in values))
       assert lib.world_step_allowed(x,y,facing,mode)==expected,(group,mx,my,mode,facing)
       counters['movement_cases']+=1
   for interaction in (0,1,15,255):
    for requested in (0,4,8,12,16,255):
     for current in (0,4,8,12):
      for facing in range(5):
       expected=source_use(rom,grid,flags,group,8,0,facing,interaction,requested,current)
       assert use(8,0,facing,interaction,requested,current)==expected
       counters['gates']+=1
  grid,flags,_=groups[2];mapid=list(mapping).index(2)
  offsets=rom[label('LABEL_7A8D'):label('LABEL_7A8D')+44]
  for my in range(96):
   for mx in range(128):
    x=mx*16+8;y=(my*16+16)%1536
    for facing,source_code in enumerate((4,2,6,8)):
     lib.world_select(mapid)
     codes=rom[label('LABEL_7A2B')+source_code:label('LABEL_7A2B')+source_code+2]
     cells=[(((x-136+offsets[c+1])%2048)//16,((y-112+offsets[c])%1536)//16)for c in codes]
     expected=[0xd7 if 0xd8<=grid[yy*128+xx]<0xe0 else grid[yy*128+xx]for xx,yy in cells]
     assert lib.world_step_allowed(x,y,facing,12)==int(not any(flags[v]&1 for v in expected))
     assert changed.value==int(any(0xd8<=grid[yy*128+xx]<0xe0 for xx,yy in cells))
     for(xx,yy),value in zip(cells,expected):assert native_cell(xx,yy)==value
     counters['movement_cases']+=1
    lib.world_select(mapid);lib.world_vehicle_footprint(x,y,12)
    cells=[((mx+dx)%128,(my+dy)%96)for dx,dy in ((-1,-1),(0,-1),(-1,0),(0,0))]
    broken=[(xx,yy)for xx,yy in cells if 0xd8<=grid[yy*128+xx]<0xe0]
    assert changed.value==bool(broken)
    for xx,yy in cells:assert native_cell(xx,yy)==(0xd7 if(xx,yy)in broken else grid[yy*128+xx])
    counters['footprint_cases']+=1;counters['changed_cells']+=len(broken)
    if broken:
     lib.world_terrain_sync(x,y)
     assert all(native_cell(xx,yy)==0xd7 for xx,yy in broken)
     # Original723D re-decodes all four chunks; even an overlapping chunk loses edits.
     lib.world_terrain_sync((x+256)%2048,y)
     assert all(native_cell(xx,yy)==grid[yy*128+xx]for xx,yy in broken)
     counters['reload_resets']+=1
 report={'passed':True,'source_sha256':ROM_SHA,**counters,
  'limits':['Host geometry and mutable-map evidence; vehicle sprite art/input integration separate',
            'Original item availability, dialogue, character selection and mode persistence are caller responsibilities']}
 out=ROOT/'build/verification/vehicles-report.json';out.write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
