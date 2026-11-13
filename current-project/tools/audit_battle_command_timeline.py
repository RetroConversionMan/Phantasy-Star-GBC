#!/usr/bin/env python3
"""Execute original support spells/commands and record message/audio chronology.

UI entry points return immediately; no port implementation is the oracle.
Persistent-state commit boundaries are recorded separately from playback order.
"""
import hashlib,json
import z80
from audit_battle_item_timeline import ROOT,ROM,SHA,ADDR,TEXT

SPELLS={'Heal':(1,'LABEL_1E46'),'Cure':(2,'LABEL_1E4A'),'Wall':(3,'LABEL_1E8A'),'Prot':(4,'LABEL_1E8E'),'Rope':(8,'LABEL_1F36'),'Bye':(9,'LABEL_1F80'),'Help':(10,'LABEL_1FC0'),'Terr':(11,'LABEL_1FDF'),'Chat':(16,'LABEL_1B0D'),'Tele':(17,'LABEL_1B31')}
ENTRIES={**{name:entry for name,(spell,entry) in SPELLS.items()},'Talk':'BattleMenu_Talk','Run':'BattleMenu_Run','Barrier':'LABEL_12D4','PlayerBound':'LABEL_1148','EnemyBound':'LABEL_128C','EnemyRope':'LABEL_1386','EnemyHeal':'LABEL_13CC','EnemyHelp':'LABEL_13FF','EnemyThunder':'LABEL_149D'}
COST={1:2,2:6,3:6,4:10,8:4,9:2,10:10,11:2,16:2,17:4}

def trace(name,actor=0,target=0,alive=True,hp=7,maxhp=100,chance=1,interaction=1,blocked=False,flags=0x80,attack=50,enemy_attack=50,seed=0x733c,bound=0,enemy_bound=0,enemy_status=1,barrier=0,living_mask=15,rng_zero=False):
 c=z80.Z80Machine();c.memory[:0x8000]=ROM[:0x8000]
 for i in range(4):
  p=0xc400+i*16;c.memory[p:p+16]=bytes([1,hp,100,0,0,0,maxhp,100,attack,80,30,0,0,0,5,5])
 p=0xc400+16*target;c.memory[p]=int(alive);c.memory[p+13]=bound
 for i in range(4):
  if not (living_mask&(1<<i)):c.memory[0xc400+i*16]=0;c.memory[0xc401+i*16]=0
 c.memory[0xc440:0xc450]=bytes([enemy_status,hp,0,0,0,0,maxhp,0,enemy_attack,40,0,0,0,enemy_bound,0,0])
 c.memory[0xc29d]=255;c.memory[0xc29e]=interaction;c.memory[0xc267]=actor;c.memory[0xc2c2]=target
 c.memory[0xc2e7]=chance;c.memory[0xc2e8]=flags;c.memory[0xc2ef]=barrier
 c.memory[0xc20c:0xc20e]=seed.to_bytes(2,'little');c.iy=0xc440
 c.b=SPELLS.get(name,(0,None))[0];c.a=actor if name=='PlayerBound' else 4 if name=='EnemyBound' else 0
 c.pc=ADDR(ENTRIES[name]);c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1'
 hooks={ADDR('ShowDialogue_B12'):'text',ADDR('LABEL_3464'):'close',ADDR('LABEL_687A'):'escape_geometry',ADDR('LABEL_2ECD'):'ui',ADDR('LABEL_30B7'):'ui',ADDR('LABEL_30E1'):'ui',ADDR('LABEL_3105'):'refresh',ADDR('LABEL_1305'):'fallback_attack',ADDR('LABEL_18CE'):'hit',ADDR('LABEL_2F93'):'ui',ADDR('WaitForVInt'):'wait'}
 if rng_zero:hooks[ADDR('LABEL_5C8')]='rng_zero'
 sounds={i for i in range(0x8000-3) if ROM[i:i+3]==b'\x32\x04\xc0'}
 for at in [0x100,*hooks,*sounds]:c.set_breakpoint(at)
 events=[]
 def state():
  return {'hp':c.memory[p+1],'mp':c.memory[0xc402+actor*16],'target_status':c.memory[p],'target_bound':c.memory[p+13],'enemy_hp':c.memory[0xc441],'enemy_status':c.memory[0xc440],'enemy_bound':c.memory[0xc44d],'barrier':c.memory[0xc2ef],'actor':c.memory[0xc267],'character':c.memory[0xc2c2],'party_hp':[c.memory[0xc401+i*16] for i in range(4)],'suppress_party':c.memory[0xc2d4],'rng':int.from_bytes(c.memory[0xc20c:0xc20e],'little')}
 for _ in range(100):
  c.ticks_to_stop=100000;c.run()
  if c.pc==0x100:break
  before=state()
  if c.pc in sounds:
   events.append({'kind':'sound','value':f'{c.a:02X}',**before});c.memory[0xc004]=c.a;c.pc+=3;continue
  assert c.pc in hooks,('unexpected source stop',name,hex(c.pc))
  hook=hooks[c.pc]
  if hook=='rng_zero':c.a=0;c.pc+=2;continue # Only unavailableZ80R contribution; feedback instructions execute.
  if hook=='text':events.append({'kind':'text','value':f'{TEXT[c.hl]:04X}',**before})
  elif hook in ('close','refresh','hit'):events.append({'kind':hook,**before})
  elif hook=='fallback_attack':events.append({'kind':hook,**before});break
  elif hook=='escape_geometry':c.f=(c.f&~64)|(0 if blocked else 64)
  elif hook=='ui'and c.pc==ADDR('LABEL_2F93'):
   #2F93/2FA1 selects IX as well as drawing the target's HP panel. Preserve
   #that register effect when omitting the window upload;15C2 damages IX.
   assert c.a<4;c.ix=0xc400+16*c.a
  c.pc=int.from_bytes(c.memory[c.sp:c.sp+2],'little');c.sp+=2
 else:raise AssertionError(('Original command did not return',name,hex(c.pc)))
 return {'command':name,'inputs':dict(actor=actor,target=target,alive=alive,hp=hp,maxhp=maxhp,chance=chance,interaction=interaction,blocked=blocked,flags=flags,attack=attack,enemy_attack=enemy_attack,seed=seed,bound=bound,enemy_bound=enemy_bound,enemy_status=enemy_status,barrier=barrier,living_mask=living_mask,rng_zero=rng_zero),'events':events,'final':state()}

def tokens(t):return [(e['kind'],e.get('value')) for e in t['events'] if e['kind']!='refresh']

def exit_trace(enemy=1,interaction=1,outcome=5):
 c=z80.Z80Machine();c.memory[:0x8000]=ROM[:0x8000];c.memory[0xc2e6]=enemy;c.memory[0xc29e]=interaction;c.a=outcome
 c.pc=ADDR('LABEL_163E');c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1'
 hooks={ADDR('WaitForVInt'):'wait',ADDR('LABEL_3D36'):'restore_scene',ADDR('LABEL_6B3A'):'restore_dungeon',ADDR('UpdateCharStats'):'refresh_stats',ADDR('LABEL_688C'):'dungeon_escape_step'}
 sounds={i for i in range(0x8000-3) if ROM[i:i+3]==b'\x32\x04\xc0'}
 for at in (0x100,*hooks,*sounds):c.set_breakpoint(at)
 events=[]
 for _ in range(100):
  c.ticks_to_stop=100000;c.run()
  if c.pc==0x100:return events
  if c.pc in sounds:events.append(('sound',c.a));c.pc+=3;continue
  assert c.pc in hooks,hex(c.pc)
  events.append((hooks[c.pc],c.a if hooks[c.pc]=='wait' else None));c.pc=int.from_bytes(c.memory[c.sp:c.sp+2],'little');c.sp+=2
 raise AssertionError('Exit did not return')

def main():
 cases=[]
 def add(name,**kw):
  t=trace(name,**kw);cases.append(t);return t
 for name,amount in [('Heal',20),('Cure',80)]:
  for actor in (0,1,3):
   for target in range(4):
    for alive in (False,True):
     for hp,maxhp in ((7,100),(95,100),(250,255)):
      t=add(name,actor=actor,target=target,alive=alive,hp=hp,maxhp=maxhp)
      assert tokens(t)==([('sound','AB'),('text','B1D0'),('sound','C1'),('close',None)] if alive else [('text','B730'),('close',None)]),t
      assert t['final']['hp']==(min(hp+amount,255,maxhp) if alive else hp)
      assert t['final']['mp']==100-(COST[SPELLS[name][0]] if alive else 0)
 for name in ('Wall','Prot'):
  t=add(name);assert tokens(t)==[('sound','AB'),('text','B18B'),('close',None)]
  assert t['final']['barrier']==(6 if name=='Wall' else 0x86)
 for target in range(4):
  for alive in (False,True):
   t=add('Help',actor=1,target=target,alive=alive)
   assert tokens(t)==[('sound','AB'),('text','B22F' if alive else 'B730'),('close',None)],t
   assert t['final']['mp']==90 and t['final']['target_status']==(129 if alive else 0)
 for name in ('Rope','Terr'):
  for flags in (0,0x20):
   for attack in (49,50):
    for enemy_status in (0,1,0x41):
     for enemy_bound in (0,3):
      for seed in (0,1,0x733c,65535):
       t=add(name,flags=flags,attack=attack,enemy_status=enemy_status,enemy_bound=enemy_bound,seed=seed)
       tok=tokens(t);assert tok[0]==('sound','AB') and tok[-1]==('close',None)
       assert tok[1] in [('text','B172'),('text','B1E0' if name=='Rope' else 'B24C')]
 for chance in (0,1,255):
  for interaction in (0,1):
   for blocked in (False,True):
    t=add('Bye',chance=chance,interaction=interaction,blocked=blocked);success=bool(chance and (interaction or not blocked))
    assert tokens(t)==([('sound','BC'),('text','B25F'),('close',None)] if success else [('text','B172'),('close',None)])
 for chance in (0,1,255):
  for interaction in (0,1):
   for blocked in (False,True):
    for seed in (0,1,0x733c,65535):
     t=add('Run',chance=chance,interaction=interaction,blocked=blocked,seed=seed)
     assert tokens(t)==([('sound','BC')] if t['final']['actor']==5 else [('text','B15E'),('close',None)]),t
 for name in ('Talk','Chat','Tele'):
  for flags in (0,0x40,0x80,0xc0):
   for attack in (49,50,51):
    for seed in (0,1,0x733c,65535):
     t=add(name,flags=flags,attack=attack,seed=seed)
     success=bool((flags&0x80 and attack>=50) if name=='Talk' else flags and (name=='Tele' or not flags&0x40 or attack>=50))
     monster=name!='Talk' and bool(flags&0x40);tok=tokens(t);prefix=[('text','B128')] if name=='Talk' else [('sound','AB')] if name=='Chat' else []
     if not success:assert tok==prefix+[('text','B13D'),('close',None)] and t['final']['actor']==4,t
     else:
      assert tok[:len(prefix)+1+monster]==prefix+([('sound','AC')] if monster else [])+[('text','B132')],t
      assert tok[-(2 if monster else 1):]==([('sound','D5'),('close',None)] if monster else [('close',None)]) and t['final']['actor']==6,t
 for flags in (0,0x10):
  for barrier in (1,6,0x81,0x86):
   for seed in (0,1,0x733c,65535):
    t=add('Barrier',flags=flags,barrier=barrier,seed=seed)
    assert tokens(t)==([] if t['final']['barrier'] else [('text','B1C1'),('close',None)])
 for name in ('PlayerBound','EnemyBound'):
  for remaining in (1,2,3):
   for seed in (0,1,0x733c,65535):
    t=add(name,bound=remaining,enemy_bound=remaining,seed=seed)
    final=t['final']['target_bound' if name=='PlayerBound' else 'enemy_bound']
    text=('B1FC' if final else 'B20A') if name=='PlayerBound' else ('B203' if final else 'B21D')
    assert tokens(t)==[('text',text),('close',None)]
 for name in ('EnemyRope','EnemyHeal','EnemyHelp'):
  for seed in (0,1,0x733c,65535):
   for barrier in (0,0x81,0x86):
    for flags in (0,0x10):
     for hp in (7,95):add(name,seed=seed,barrier=barrier,flags=flags,hp=hp)
 out=ROOT/'build/research/battle-command-timeline';out.mkdir(parents=True,exist_ok=True)
 exits=[]
 for enemy in (1,49,73):
  for interaction in (0,1):
   for outcome in (5,6):
    events=exit_trace(enemy,interaction,outcome);waits=[value for kind,value in events if kind=='wait']
    assert waits==[10]*(4 if enemy==73 else 14)+[16],(enemy,events)
    assert events.index(('sound',0xd8))>max(i for i,e in enumerate(events) if e[0]=='wait')
    exits.append({'enemy':enemy,'interaction':interaction,'outcome':outcome,'events':events})
 (out/'traces.json').write_text(json.dumps(cases,indent=2)+'\n')
 (out/'exit-traces.json').write_text(json.dumps(exits,indent=2)+'\n')
 report={'source_sha256':SHA,'source_cases_passed':len(cases),'commands':sorted({t['command'] for t in cases}),'source_executed':['Original handler branches andRNG','MP/HP/status/binding/barrier mutations','Dialogue pointers and sound-mailbox stores','Talk/escape outcome and party-suppression flags'],'hooks':['Dialogue and six-row UI close recorded at entry and returned immediately','UI refresh routines returned;3105 refresh position recorded','Escape geometry supplied as an explicitZflag fixture','Enemy support fallthrough1305 recorded without physical combat'],'port_validated':False,'state_chronology_note':'Port rules precompute the action. This reference records original mutation boundaries; matching observable messages/audio does not alone prove source-timed persistent mutation.'}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
