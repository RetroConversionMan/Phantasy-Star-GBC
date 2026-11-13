#!/usr/bin/env python3
"""Source-only navigation index for planning, never a campaign completion claim."""
from collections import deque,defaultdict
from pathlib import Path
import hashlib,json,struct
from verify_world_logic import source_group,source_action
from extract_scenes import ROOT,SHA,label
from extract_rpg import extract,LOCATIONS

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 groups=[source_group(rom,g)for g in range(11)];mapping=rom[0xdc1:0xdd9];incoming=defaultdict(set);actions={}
 incoming[4].add((105,18));incoming[23].add((31,32))
 def decoded(a,b):return b%128,((a>>4)*12+(a&15))%96
 for m,g in enumerate(mapping):
  grid,flags,entries=groups[g];rows=defaultdict(list)
  for y in range(96):
   for x in range(128):
    a=source_action(rom,m,grid,flags,entries,x,y)
    if a[0]in(8,10,12):
     rows[a[:4]].append((x,y))
     if a[0]==8:incoming[a[1]].add(decoded(a[2],a[3]))
  actions[m]=rows
 for n in range(6):
  row=rom[0xf0c+n*8:0xf14+n*8];incoming[row[2]].add(decoded(row[3],row[4]));incoming[row[5]].add(decoded(row[6],row[7]))
 for n in range(8):
  row=rom[0xabf+n*9:0xac8+n*9]
  for i in (0,3,6):incoming[row[i]].add(decoded(row[i+1],row[i+2]))
 p=3*16384+(0xb473&16383)
 while rom[p]!=255:
  f,pos,target,a,b=rom[p:p+5];p+=5
  if target<24:incoming[target].add(decoded(a,b))
 potential=[]
 for m,rows in actions.items():
  for action,cells in rows.items():potential.append({'map':m,'group':mapping[m],'mode':action[0],'target':action[1],'a':action[2],'b':action[3],'cells':cells})
 world=[]
 for m,g in enumerate(mapping):
  grid,flags,entries=groups[g];seen=set(incoming[m]);q=deque(seen)
  while q:
   x,y=q.popleft()
   for dx,dy in((1,0),(-1,0),(0,1),(0,-1)):
    p=((x+dx)%128,(y+dy)%96)
    if p in seen or flags[grid[p[1]*128+p[0]]]&1:continue
    seen.add(p)
    # Entering an interaction/map/dungeon returns to caller, so don't walk
    # through it while claiming this town's ordinary connected region.
    a=source_action(rom,m,grid,flags,entries,*p)
    if a[0]not in(8,10,12):q.append(p)
  for action,cells in actions[m].items():
   reachable=[c for c in cells if c in seen]
   if reachable:world.append({'map':m,'group':g,'mode':action[0],'target':action[1],'a':action[2],'b':action[3],'cells':reachable})
 objects=[];p=3*16384+(0xaf5c&16383)
 while rom[p]!=255:
  f,pos,lo,hi,kind,a,b=rom[p:p+7];p+=7
  objects.append({'floor':f,'position':pos,'flag_address':f'{hi:02X}{lo:02X}','kind':kind,'a':a,'b':b})
 transitions=[];p=3*16384+(0xb473&16383)
 while rom[p]!=255:
  f,pos,target,a,b=rom[p:p+5];p+=5;transitions.append({'floor':f,'position':pos,'target':target,'a':a,'b':b})
 shops=[];raw=extract(rom,*LOCATIONS['shops'])
 for shop in range(29):
  row=raw[shop*10:shop*10+10];count=row[0]+1;assert count<=3
  shops.append({'shop':shop,'items':[{'item':row[1+i*3],'price':row[2+i*3]|row[3+i*3]<<8}for i in range(count)if row[1+i*3]]})
 enemies=extract(rom,*LOCATIONS['enemies']);drops=[]
 for enemy in range(1,75):
  row=enemies[enemy*32:(enemy+1)*32]
  # Original reward fields are documented in rpg_battle_begin; retain raw
  # record so navigation consumers do not infer a guaranteed random drop.
  drops.append({'enemy':enemy,'name':row[:8].split(b'e')[0].decode('ascii').rstrip(),'record_hex':row.hex()})
 out=ROOT/'build/research';out.mkdir(parents=True,exist_ok=True)
 report={'source_sha256':SHA,'world_incoming':{str(m):sorted(v)for m,v in incoming.items()},'world_triggers':world,'potential_world_triggers':potential,'dungeon_objects':objects,'dungeon_transitions':transitions,'shops':shops,'enemies':drops,'limits':['Source navigation/index only; no route was executed by this extraction','World reachability ignores damage, encounters, vehicle restrictions and story gates; use source runtime for actual traversal','Shared group rows filtered through incoming connected regions, not assumed reachable just because present in a table','Dungeon doors/layout mutations and battle prerequisites require explicit route state']}
 (out/'campaign-index.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'world_triggers':len(world),'dungeon_objects':len(objects),'dungeon_transitions':len(transitions),'shops':len(shops)},indent=2))
if __name__=='__main__':main()
