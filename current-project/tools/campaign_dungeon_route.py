#!/usr/bin/env python3
"""Source-data geometry planner; execution always remains native joypad input.

Models the original byte-position wrapping and two-cell stairs/doors. Avoids
unrecorded pitfalls, active fixed enemies/NPCs and empty trap chests by default.
The caller must replan after native callbacks/escape can change position.
"""
from pathlib import Path
from collections import deque
import hashlib,json,argparse
ROOT=Path(__file__).resolve().parents[1]
class DungeonRoutes:
 def __init__(self):
  rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()=='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
  start=15*16384+(0x9f6e&16383);self.layout=[bytes(n for b in rom[start+f*128:start+(f+1)*128]for n in(b>>4,b&15))for f in range(61)];self.offsets=rom[0x6c06:0x6c46]
  self.objects={};p=3*16384+(0xaf5c&16383)
  while rom[p]!=255:
   f,at,lo,hi,kind,a,b=rom[p:p+7];self.objects.setdefault((f,at),(lo|hi<<8,kind,a,b));p+=7
 def route(self,start,goal,items=(),story_flags=None,object_flags=None,runtime=None,avoid_objects=True,allow_falls=False,can_disarm=False,can_open=False):
  story_flags=story_flags or bytes(256);object_flags=object_flags or bytes(256)
  def grid_for(f):
   return bytes(v&127 for v in runtime)if runtime is not None and f==start[0]else self.layout[f]
  def pit(f,p):return grid_for(f)[p]==8 and(f,p)not in self.objects
  def safe(node,rear=False):
   f,p,d=node
   if pit(f,p)and not(allow_falls or can_disarm):return False
   ahead=(p+self.offsets[d*16+(11 if rear else 1)])&255;obj=self.objects.get((f,ahead))
   if not avoid_objects or not obj or grid_for(f)[ahead]!=8:return True
   flag,kind,a,b=obj;value=(story_flags if flag>>8==0xc5 else object_flags)[flag&255]
   if value==255:return True
   # Luveno prison Robotcop accepts the already-earned Roadpass. The runner
   # explicitly answers the native prompt rather than hiding this callback.
   if kind==3 and a==130 and 51 in items:return True
   return kind<2 and not(kind==0 and not a and b)
  queue=deque([start]);prev={start:None}
  while queue:
   node=queue.popleft()
   if node==goal:break
   f,p,d=node;grid=grid_for(f);delta=self.offsets[d*16+1];front=(p+delta)&255;back=(p+self.offsets[d*16+11])&255;cell=grid[front];typ=cell&7
   if pit(f,p)and allow_falls and not can_disarm:
    nxt=(max(0,f-1),p,d)
    if nxt not in prev:prev[nxt]=(node,'wait');queue.append(nxt)
    continue
   choices=[('left',(f,p,(d+3)&3)),('right',(f,p,(d+1)&3))]
   if not grid[back]&7:choices.append(('down',(f,back,d)))
   if not typ:choices.append(('trap_up'if pit(f,front)and can_disarm else'up',(f,front,d)))
   elif typ in(2,3) and not cell&8:
    nf=f+(1 if typ==2 else-1)
    if 0<=nf<61:choices.append(('up',(nf,(p+2*delta)&255,d)))
   elif typ in(4,5,6) and not cell&8 and(typ==4 or(typ==5 and(45 in items or 62 in items))or(typ==6 and(62 in items or can_open))or(runtime is not None and f==start[0]and runtime[front]&128)):
    opened=runtime is not None and f==start[0]and runtime[front]&128
    choices.append(('up'if opened else'a_up'if typ==4 else'open_up'if typ==6 and 62 not in items else'key_up',(f,(p+2*delta)&255,d)))
   elif typ==7:choices.append(('up',(f,(p+2*delta)&255,d)))
   for key,nxt in choices:
    if can_disarm and pit(nxt[0],nxt[1])and nxt[:2]!=node[:2]and key!='trap_up':continue
    if key=='down'and not safe(nxt,rear=True):continue
    if key=='up'and typ==7 and not safe((f,front,d)):continue
    if nxt not in prev and(nxt==goal or safe(nxt)):prev[nxt]=(node,key);queue.append(nxt)
  if goal not in prev:raise ValueError(('No source dungeon route',start,goal))
  result=[];node=goal
  while prev[node]:before,key=prev[node];result.append({'input':key,'from':list(before),'to':list(node)});node=before
  return result[::-1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('--start',nargs=3,type=lambda v:int(v,0),default=[19,0x13,3]);p.add_argument('--goal',nargs=3,type=lambda v:int(v,0),default=[16,0x64,1]);a=p.parse_args();path=DungeonRoutes().route(tuple(a.start),tuple(a.goal),items=(45,));print(json.dumps({'commands':len(path),'path':path},indent=2))
if __name__=='__main__':main()
