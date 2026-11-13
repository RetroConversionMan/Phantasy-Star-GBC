#!/usr/bin/env python3
"""Controller-only campaign runner with immutable ROM and auditable checkpoints.

Reads native state for navigation/assertions, but NEVER writes emulator memory.
All progress, equipment, money, healing, saves and combat use joypad input.
Save states only preserve/resume the exact run; death/Continue is recorded.
"""
from __future__ import annotations
from collections import deque
from pathlib import Path
import argparse,hashlib,json,shutil,time,traceback,heapq
from pyboy import PyBoy
from verify_rom import capture,cartridge_header,load_symbols,read_word,is_text_revealing
from campaign_dungeon_route import DungeonRoutes
from campaign_world_route import route_cells
from campaign_hover_route import plan_hover, use_hover
from native_layout import native_event_layout
ROOT=Path(__file__).resolve().parents[1]
GROUPS=(0,1,2,3,4,4,4,5,5,5,5,5,6,6,7,7,7,7,7,8,8,9,9,10)
DIRS={'down':(0,1),'right':(1,0),'left':(-1,0),'up':(0,-1)}
class Campaign:
 def __init__(self,rom,out,resume=None):
  self.out=out;out.mkdir(parents=True,exist_ok=True);self.rom=out/'campaign.gbc'
  if self.rom.exists():assert hashlib.sha256(self.rom.read_bytes()).digest()==hashlib.sha256(rom.read_bytes()).digest(),'Use a new output for a different ROM'
  else:
   shutil.copyfile(rom,self.rom);shutil.copyfile(rom.with_suffix('.noi'),self.rom.with_suffix('.noi'))
  self.s=load_symbols(self.rom.with_suffix('.noi'));self.e=PyBoy(str(self.rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');self.e.set_emulation_speed(0)
  spell_table=self.s['rpg_battle_spells'];spell_offset=(spell_table>>16)*16384+(spell_table&16383)
  self.battle_spell_ids=self.rom.read_bytes()[spell_offset:spell_offset+15]
  source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(source).hexdigest()=='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
  self.frames=0;self.started=time.monotonic();self.force_fight=set();self.avoid_combat=False;self.mp_reserve=0;self.myau_reserve=0;self.noah_reserve=0;self.maps={};self.collisions={};self.log=(out/'controller.jsonl').open('a')
  self.report=json.loads((out/'report.json').read_text())if resume else {'header':cartridge_header(self.rom),'injected_fixtures':[],'campaign_complete':False,'milestones':[],'battles':[],'deaths':[],'checkpoints':[],'routes':[],'input_policy':'All state mutations are controller input; memory is read only. No RNG/stat/item/flag/position injections.'}
  if not resume:
   self.report['native_layout']=native_event_layout(rom)
   (out/'native-layout.json').write_text(json.dumps(self.report['native_layout'],indent=2)+'\n')
  elif 'native_layout' in self.report:
   assert native_event_layout(self.rom,out/'native-layout.json')==self.report['native_layout']
  self.event_objects=self.report.get('native_layout',{}).get('event_object_flags_offset',292)
  if resume:
   meta=json.loads(resume.with_suffix('.json').read_text());assert meta['rom_sha256']==self.report['header']['sha256'];self.frames=meta['frame']
   with resume.open('rb')as f:self.e.load_state(f)
   self.record('resume',checkpoint=str(resume))
  else:self.tick(300)
 def byte(self,n,off=0):return self.e.memory[self.s[n]+off]
 def word(self,n,off=0):return read_word(self.e,self.s[n]+off)
 def state(self):return self.byte('screen_state')
 def map(self):return self.byte('world_map_id')
 def pos(self):return self.word('player_x'),self.word('player_y')
 def cell(self):x,y=self.pos();return((x-8)//16,((y+1536-16)%1536)//16)
 def items(self):n=self.byte('game_rpg',88);return list(self.e.memory[self.s['game_rpg']+64:self.s['game_rpg']+64+n])if n else[]
 def party(self):return [list(self.e.memory[self.s['game_rpg']+i*16:self.s['game_rpg']+(i+1)*16])for i in range(4)]
 def snapshot(self):
  result= {'vehicle':self.byte('game_vehicle'),'object_flags':{str(i):self.byte('game_events',self.event_objects+i)for i in range(256)if self.byte('game_events',self.event_objects+i)},'dungeon':list(self.dungeon_state())if self.byte('game_dungeon',264)else None,'frame':self.frames,'screen':self.state(),'map':self.map(),'position':list(self.pos()),'cell':list(self.cell()),'party':self.party(),'items':self.items(),'money':self.word('game_rpg',90),'joined':self.byte('game_rpg',89),'rng':self.word('game_rpg',92),'story_flags':{str(i):self.byte('game_events',i)for i in range(256)if self.byte('game_events',i)}}
  if 'vehicle_cycle' in self.s:result['vehicle_cycle']=[self.byte('vehicle_cycle',i)for i in range(2)]
  if 'game_fade_clock' in self.s:result['fade_clock']=self.byte('game_fade_clock');result['map_music']=self.byte('game_map_music')
  return result
 def record(self,kind,**data):self.log.write(json.dumps({'frame':self.frames,'kind':kind,**data})+'\n');self.log.flush()
 def tick(self,n=1):assert self.e.tick(n);self.frames+=n
 def press(self,key,settle=32):
  screen=self.state();view=self.byte('battle_view_state')if screen==15 else None
  if is_text_revealing(self.e,self.s):self.wait(lambda:not is_text_revealing(self.e,self.s),'Source text finishes revealing')
  frame=self.word('frame_counter');self.wait(lambda:self.word('frame_counter')!=frame,'Controller sampling boundary',4000)
  if self.state()!=screen or(screen==15 and self.byte('battle_view_state')!=view):return False
  self.record('press',key=key);self.e.button_press(key);self.tick(2);self.record('release',key=key);self.e.button_release(key)
  action_frame=self.word('frame_counter');self.tick(settle)
  # Source room fades and menu closes can outlast a short button settle.
  # Await the next real controller loop, without holding or repeating input.
  if self.word('frame_counter')==action_frame:self.wait(lambda:self.word('frame_counter')!=action_frame,'Finish native action frame')
 def wait(self,test,why,limit=20000):
  for _ in range(limit):
   if test():return
   self.tick()
  raise AssertionError((why,self.snapshot(),hex(self.e.register_file.PC)))
 def flush(self):self.report['latest']=self.snapshot();self.report['elapsed_seconds']=round(time.monotonic()-self.started,1);(self.out/'report.json').write_text(json.dumps(self.report,indent=2)+'\n')
 def checkpoint(self,name,save=True):
  assert self.state()in(1,17),(name,self.state())
  frame=self.word('frame_counter');self.wait(lambda:self.word('frame_counter')!=frame,'Checkpoint input-ready frame')
  if self.state()==17:self.wait(lambda:not self.byte('dungeon_keys_delay'),'Checkpoint dungeon input delay')
  if save:
   self.press('select');self.wait(lambda:self.state()==8,'actual save');assert self.byte('saved_position_valid');self.press('a');self.wait(lambda:self.state()in(1,17),'save return');self.tick(20)
  name=f'{len(self.report["checkpoints"]):03d}-'+name
  p=self.out/(name+'.state');
  with p.open('wb')as f:self.e.save_state(f)
  meta={'rom_sha256':self.report['header']['sha256'],**self.snapshot()};p.with_suffix('.json').write_text(json.dumps(meta,indent=2)+'\n');capture(self.e,self.out/(name+'.png'))
  self.report['checkpoints'].append({'name':name,**meta});self.record('checkpoint',name=name);self.flush();print(json.dumps({'checkpoint':name,'frame':self.frames,'level':self.byte('game_rpg',5),'hp':self.byte('game_rpg',1),'money':self.word('game_rpg',90),'items':self.items()}),flush=True)
  hold=self.out/'PAUSE_AT_CHECKPOINT'
  if hold.exists():
   self.record('campaign_hold',checkpoint=name);self.flush();print(json.dumps({'held_at_checkpoint':name,'frame':self.frames}),flush=True)
   while hold.exists():time.sleep(0.1)
   self.record('campaign_hold_released',checkpoint=name)
 def drain(self,targets=(1,17),limit=30000):
  for n in range(limit):
   st=self.state()
   if st in targets:return st
   if st==15:self.battle();continue
   if st in(4,18,24,22,8,30):self.press('a',8)
   elif st in(20,21,23):self.tick()
   else:raise AssertionError(('Unexpected dialogue destination',st,targets,self.snapshot()))
  raise AssertionError(('Dialogue stalled',self.snapshot()))
 def mapdata(self):
  g=GROUPS[self.map()]
  if g not in self.maps:self.maps[g]=(ROOT/f'assets/world/world_g{g:02}.map').read_bytes();self.collisions[g]=(ROOT/f'assets/world/world_g{g:02}.collision').read_bytes()
  return self.maps[g],self.collisions[g]
 def route(self,goals,exact=False):
  data,flags=self.mapdata()
  return route_cells(data,flags,self.cell(),goals,self.map(),self.items(),self.byte('game_vehicle'),exact_goal=exact)
 def step(self,key):
  assert self.state()==1;self.heal_between();before=self.map();x,y=self.pos();dx,dy=DIRS[key];target=((x+dx*16)%2048,(y+dy*16)%1536)
  self.record('press',key=key);self.e.button_press(key)
  try:self.wait(lambda:self.byte('step_remaining')or self.pos()==target or self.state()!=1 or self.map()!=before,'world step begins',900)
  finally:self.record('release',key=key);self.e.button_release(key)
  self.wait(lambda:(self.pos()==target and not self.byte('step_remaining'))or self.state()!=1 or self.map()!=before,'world step completes',900)
  frame=self.word('frame_counter');self.wait(lambda:self.word('frame_counter')!=frame,'finish native movement frame',2400);self.tick(2)
  if self.state()==15:self.battle()
  return before!=self.map()or self.state()!=1
 def walk(self,goals,name,exact=False):
  goals=set(goals)
  if exact and self.cell()in goals:return self.state()
  start=self.snapshot();steps=self.route(goals,exact);self.record('route',name=name,map=self.map(),start=self.cell(),goals=list(goals),steps=steps)
  for _ in range(2000):
   key=self.route(goals,exact)[0]
   if self.step(key)or self.cell()in goals:break
  else:raise AssertionError(('Route did not terminate',name,self.snapshot()))
  self.tick(100);self.report['routes'].append({'name':name,'from':start['cell'],'map':start['map'],'steps':len(steps),'result':self.snapshot()});return self.state()
 def battle(self):
  self.tick(80);before=self.snapshot();enemy=self.byte('battle_view_battle',128);count=self.byte('battle_view_battle',129);turns=0;last_action=None;heal_target=None;spell_option=None;escape_queued=False;declining_optional=False
  record={'kind':'dungeon_chest'if not enemy else'encounter','before':before,'enemy':enemy,'count':count,'commands':[]};last_outcome=0
  for n in range(25000):
   if self.state()!=15:break
   native_outcome=self.byte('battle_view_battle',130)
   if last_outcome and not native_outcome:
    after=self.snapshot();record.update(outcome=last_outcome,after=after,chained_into=self.byte('battle_view_battle',128),characters_down=[c for c in range(4)if before['party'][c][0]&1 and not after['party'][c][0]&1]);self.report['battles'].append(record);self.flush();print(json.dumps({'battle':len(self.report['battles']),'enemy':enemy,'count':count,'result':last_outcome,'chained_into':record['chained_into']}),flush=True)
    before=after;enemy=self.byte('battle_view_battle',128);count=self.byte('battle_view_battle',129);record={'kind':'encounter','before':before,'enemy':enemy,'count':count,'commands':[]};escape_queued=False;heal_target=spell_option=None
   last_outcome=native_outcome
   view=self.byte('battle_view_state')
   if is_text_revealing(self.e,self.s):self.tick();continue
   if view==1:
    hp=self.byte('game_rpg',1);level=self.byte('game_rpg',5)
    # Escape threats a single beginner cannot safely defeat. This uses the
    # actual Run command and source chance; outcomes are never patched/retried.
    run=(level<8 and enemy not in(1,5))or(level==1 and enemy==5 and count>1)or hp<=max(5,count*3)
    if self.byte('game_rpg',10)==7 and enemy in(2,3)and count<=3:run=False
    actor=self.byte('battle_view_actor')
    if actor==0:escape_queued=False
    living=[c for c in range(4)if self.byte('game_rpg',89)&(1<<c)and self.byte('game_rpg',c*16)&1]
    if level>=8 and enemy not in(1,5):
     defense=min(self.byte('game_rpg',c*16+9)for c in living);attack=max(self.byte('game_rpg',c*16+8)for c in living);party_hp=sum(self.byte('game_rpg',c*16+1)for c in living)
     run=run or self.byte('battle_view_battle',8)>defense+5 or self.byte('battle_view_battle',9)>attack-8 or sum(self.byte('battle_view_battle',i*16+1)for i in range(8))>party_hp
    if self.avoid_combat:run=True
    if self.byte('battle_view_battle',157)or enemy in self.force_fight or enemy in(49,62,70,71,72,73,74):run=False
    tele_escape=run and 4 not in self.items()and bool(self.byte('battle_view_battle',155)&0xc0)and bool(self.byte('game_rpg',48)&1)and not self.byte('game_rpg',61)and self.byte('game_rpg',50)>=4 and self.byte('game_rpg',62)>=2
    if tele_escape:run=False;escape_queued=True
    if escape_queued:run=False
    target=4 if run else 0;spell_option=None;item_id=None
    if run and actor==0 and self.byte('game_rpg',2)>=2+self.mp_reserve and self.byte('game_rpg',14)>=2:
     target=1;spell_option=1;escape_queued=True
    if run and 4 in self.items()and actor==living[0]and not self.byte('game_rpg',actor*16+13)and self.byte('battle_view_battle',156):
     target=2;item_id=4;escape_queued=True
    blocked_escape=bool(self.byte('battle_view_battle',157))
    boss=blocked_escape or enemy in self.force_fight or enemy in(49,62,66,67,69,70,71,72,73)
    if not run and not escape_queued:
     wounded=[c for c in living if self.byte('game_rpg',c*16+6)-self.byte('game_rpg',c*16+1)>=20 or self.byte('game_rpg',c*16+1)*2<self.byte('game_rpg',c*16+6)]
     if actor==0 and self.byte('game_rpg',2)>=2+self.mp_reserve and self.byte('game_rpg',14)and wounded and(not boss or self.byte('game_rpg',18)<6 or not self.byte('game_rpg',16)&1):
      heal_target=min(wounded,key=lambda c:self.byte('game_rpg',c*16+1)/self.byte('game_rpg',c*16+6));target=1;spell_option=0
     elif actor==0 and boss and enemy not in(62,70) and not(enemy==73 and self.byte('game_rpg',0)&128) and self.byte('game_rpg',2)>=4+(0 if blocked_escape or enemy==72 else self.mp_reserve) and self.byte('game_rpg',14)>=4:target=1;spell_option=3
     elif actor==1 and self.byte('game_rpg',18)>=6+(0 if boss else self.myau_reserve)and self.byte('game_rpg',30):
      cure=[c for c in living if self.byte('game_rpg',c*16+6)-self.byte('game_rpg',c*16+1)>=40]
      if cure:heal_target=min(cure,key=lambda c:self.byte('game_rpg',c*16+1)/self.byte('game_rpg',c*16+6));target=1;spell_option=0
      elif enemy in(62,70,73) and self.byte('game_rpg',18)>=10 and self.byte('game_rpg',30)>=4 and self.byte('game_rpg',0)&1 and not self.byte('game_rpg',0)&128:heal_target=0;target=1;spell_option=3
      elif boss and enemy!=62 and self.byte('game_rpg',30)>=3 and self.byte('battle_view_battle',155)&16 and self.byte('battle_view_battle',131)&127<=2:target=1;spell_option=2
     elif actor==3 and boss:
      if enemy==73 and self.byte('game_rpg',50)>=12 and self.byte('game_rpg',62)>=3:target=1;spell_option=2
      elif enemy==72 and self.byte('game_rpg',50)>=12 and self.byte('game_rpg',62)>=3:target=1;spell_option=2
      elif blocked_escape and count>=3 and self.byte('game_rpg',50)>=16 and self.byte('game_rpg',62)>=5:target=1;spell_option=4
      elif self.byte('game_rpg',50)>=4 and self.byte('game_rpg',62):target=1;spell_option=0
    if boss and actor==3 and self.byte('game_rpg',49)<self.byte('game_rpg',54)//3 and 37 in self.items():target=2;item_id=37;spell_option=None
    # Actual Dark Falz retry strategy after the recorded first defeat: source
    # flags0 reject barriers. Help boosts physical attacks only; Wind gives
    # Noah three9..12 hits, while Laser reaches only the first living head.
    # Spend earned Burgers before low-HP characters lose their initiative.
    if enemy==73 and actor in(0,2,3) and 37 in self.items() and self.byte('game_rpg',actor*16+1)<self.byte('game_rpg',actor*16+6)*(2 if actor==3 else 1)//(3 if actor==3 else 2):target=2;item_id=37;spell_option=None
    if tele_escape and actor==3:target=1;spell_option=1
    for _ in range(5):
     if self.byte('battle_view_choice')==target:break
     self.press('right',6)
    record['commands'].append({'actor':self.byte('battle_view_actor'),'command':target,'spell_option':spell_option,'item':item_id,'target':heal_target if target==1 and actor in(0,1)and spell_option in(0,3)else None,'hp':hp});self.press('a',6);turns+=1
   elif view==2:
    assert spell_option is not None,'Unplanned spell selector'
    while self.byte('battle_view_choice')!=spell_option:self.press('down',6)
    selected_actor=self.byte('battle_view_actor');row=2 if selected_actor==3 else selected_actor
    self.record('battle_spell_selected',actor=selected_actor,menu_option=spell_option,source_spell_id=self.battle_spell_ids[row*5+spell_option]&31)
    self.press('a',8)
   elif view==3:
    assert item_id in self.items(),'Unplanned battle item selection'
    while self.byte('battle_view_choice')!=self.items().index(item_id):self.press('down',6)
    self.press('a',8)
   elif view==4:
    assert heal_target is not None,'Unplanned target selector'
    while self.byte('battle_view_choice')!=heal_target:self.press('down',6)
    self.press('a',8);heal_target=None
   elif view==5:self.press('a',8)
   elif view==6:
    if declining_optional and self.byte('battle_view_choice')!=1:self.press('right',6)
    self.press('a',8);declining_optional=False
   elif view==12:self.press('a',8)
   elif view==7:
    pending=self.byte('battle_view_battle',164)
    if pending==39 and 57 in self.items():
     self.record('decline_full_reward',item=pending,reason='Reusable MagicLamp already held; original No/abandon flow');declining_optional=True;self.press('b',8)
    else:
     replace=next((i for i,item in enumerate(self.items())if item==39 or(item==40 and 4 in self.items())or(item==27 and self.byte('game_rpg',44)==31)),None)
     assert replace is not None,('Full inventory has no deliberately obsolete replacement',pending,self.items())
     while self.byte('battle_view_choice')!=replace:self.press('down',6)
     self.record('replace_full_reward',item=pending,slot=replace,old=self.items()[replace]);self.press('a',8)
   else:self.tick()
  else:raise AssertionError(('Battle stalled',self.snapshot(),view))
  self.tick(80);record['outcome']=self.byte('battle_view_result');record['after']=self.snapshot();record['characters_down']=[c for c in range(4)if before['party'][c][0]&1 and not record['after']['party'][c][0]&1];self.report['battles'].append(record);self.flush()
  print(json.dumps({'battle':len(self.report['battles']),'enemy':enemy,'count':count,'result':record['outcome'],'level':self.byte('game_rpg',5),'hp':self.byte('game_rpg',1),'money':self.word('game_rpg',90)}),flush=True)
  if enemy and enemy not in(49,74)and record['outcome']==2:
   self.report['deaths'].append(record['after']);self.flush();raise RuntimeError('Natural defeat: failure checkpoint retained. Continue explicitly from actual save.')
 def newgame(self):
  assert self.state()==0;self.press('start');self.wait(lambda:self.state()==18,'Unskipped original opening');self.drain();self.wait(lambda:self.state()==1 and bool(self.e.memory[0xff40]&128),'world ready');self.tick(100)
  assert self.pos()==(1688,304)and self.byte('game_rpg',1)==16
  self.walk([(102,22)],'Suelo introduction');self.drain();self.walk([(85,16),(86,16)],'Nekise Pot');self.drain();assert self.items()==[56]and self.byte('game_events',2)==1
  self.report['milestones'].append('Opening, Suelo and Nekise via real controls');self.checkpoint('01-nekise')
 def rest(self):
  if self.map()==0:self.walk([(82,44),(83,44),(82,45),(83,45)],'Return Camineet for rest');assert self.map()==4
  assert self.map()==4;self.walk([(102,22)],'Suelo free rest');self.drain()
  assert all(p[1]==p[6]and p[2]==p[7]for c,p in enumerate(self.party())if self.byte('game_rpg',89)&(1<<c)and p[0]&1),'Suelo restores living members only; dead members require the original church'
 def revive(self,character):
  assert self.map()==4 and not self.byte('game_rpg',character*16)&1
  self.walk([(107,30),(108,30)],'Camineet church revival');self.answer(True);self.drain((11,))
  while self.byte('party_choice')!=character:self.press('down')
  self.press('a');self.answer(True);self.drain((5,));self.answer(False);self.drain();assert self.byte('game_rpg',character*16)&1
  self.rest();self.checkpoint('church-revival-'+str(character))
 def equip(self,item,character=0):
  assert item in self.items();assert self.byte('game_rpg',character*16)&1,('Cannot equip a dead character',character)
  if self.state()==17:self.wait(lambda:not self.byte('dungeon_keys_delay'),'Equipment menu native dungeon delay')
  self.press('start');assert self.state()==2
  while self.byte('menu_choice')!=2:self.press('down')
  self.press('a');assert self.state()==9
  for _ in range(self.items().index(item)):self.press('down')
  self.press('a');assert self.state()==10;self.press('down');self.press('a')
  if self.state()==11:
   while self.byte('party_choice')!=character:self.press('down')
   self.press('a')
  else:assert character==0 and self.byte('game_rpg',89)==1,'Original single-member Equip skips character selection'
  self.drain((9,));self.press('b');self.press('b');assert self.state()in(1,17)
 def shop(self,goals,option,name):
  self.walk(goals,name);st=self.drain((5,14))
  self.press('a');self.drain((6,));
  for _ in range(option):self.press('down')
  self.press('a');st=self.drain((1,5,6))
  if st==5:self.answer(False);self.drain()
  elif st==6:self.press('b');self.drain()
 def grind(self,money=330,max_battles=100):
  if self.state()==2:self.press('b');self.wait(lambda:self.state()in(1,17),'Resume after field-menu boundary')
  initial=len(self.report['battles'])
  while self.word('game_rpg',90)<money or any(self.byte('game_rpg',89)&(1<<c)and not p[0]&1 for c,p in enumerate(self.party())):
   if len(self.report['battles'])-initial>=max_battles:raise RuntimeError('Battle budget reached; checkpoint can resume')
   self.rest()
   for c in range(4):
    if self.byte('game_rpg',89)&(1<<c) and not self.byte('game_rpg',c*16)&1:self.revive(c)
   if self.word('game_rpg',90)>=money:break
   if not self.byte('game_rpg',12)and self.word('game_rpg',90)>=30:
    self.shop([(94,25),(95,25)],0,'Buy Leather Shield');self.equip(25);assert self.byte('game_rpg',12)==25;self.checkpoint('02-leather-shield')
   self.checkpoint('grind-town')
   self.walk([(109,23)],'Camineet exit to Palma');assert self.map()==0
   before=len(self.report['battles']);data,flags=self.mapdata()
   self.walk([(x,y)for y in range(96)for x in range(128)if data[y*128+x]==1],'Nearest original Palma grass')
   anchor=self.cell()
   # Stay on source-passable Palma ground beside Camineet; no encounter mutation.
   for i in range(1000):
    if len(self.report['battles'])!=before:break
    p=self.cell();choices=[]
    for key,(dx,dy)in DIRS.items():
     q=((p[0]+dx)%128,(p[1]+dy)%96)
     if abs(q[0]-anchor[0])<=2 and abs(q[1]-anchor[1])<=2 and data[q[1]*128+q[0]]==1 and not flags[1]&13:choices.append(key)
    assert choices,('No nearby source grass',p)
    self.step(choices[i%len(choices)])
   else:raise AssertionError('No natural encounter within1000steps')
  self.rest();self.checkpoint('funds-'+str(money))
 def roadpass(self):
  assert self.map()==4 and self.word('game_rpg',90)>=300
  if 39 not in self.items():self.shop([(99,25),(100,25)],0,'Buy Flash for Odin cave');assert 39 in self.items()
  self.walk([(109,23)],'Leave Camineet for Scion');self.walk([(103,43),(103,44)],'Scion entrance');assert self.map()==13
  for i in range(3):self.shop([(86,76),(87,76)],2,'Scion Secrets request'+str(i+1))
  assert 51 in self.items();self.checkpoint('04-roadpass');self.report['milestones'].append('Roadpass purchased through third Scion Secrets request for200')
 def trigger(self,event,name=None):
  index=json.loads((ROOT/'build/research/campaign-index.json').read_text())
  cells=[tuple(p)for row in index['world_triggers']if row['map']==self.map()and row['mode']==12 and (row['target']<18 or row['target']>=28) and row['a']==event for p in row['cells']]
  assert cells,(self.map(),event);return self.walk(cells,name or f'Original event{event}')
 def answer(self,yes):
  self.drain((5,))
  if self.byte('choice')!=(0 if yes else 1):self.press('right')
  self.press('a')
 def passport_myau(self):
  if self.map()==13:
   self.walk([(80,72)],'Leave Scion');self.rest()
  assert self.map()==4 and 51 in self.items();self.trigger(11,'Roadpass Camineet guard');self.drain();assert self.map()==5
  self.trigger(29,'Passport official')
  for yes in(True,False,False,True):self.answer(yes)
  self.drain();assert 52 in self.items();self.checkpoint('05-passport')
  self.trigger(26,'Passport spaceport gate');self.answer(True);self.drain();self.trigger(179,'Palma ship boarding');self.answer(True);self.drain();assert self.map()==16
  self.trigger(11,'Motavia Roadpass guard');self.drain();assert self.map()==14
  self.trigger(54,'Myau trader');self.answer(False);self.answer(True);self.drain();assert self.byte('game_rpg',89)==3 and 43 in self.items()and 56 not in self.items()
  self.report['milestones'].append('Actual Passport purchase, ship81, Myau Pot exchange/recruitment/Alsulin');self.checkpoint('06-myau')
 def return_palma(self):
  assert self.map()==14;self.trigger(19,'Paseo Passport return gate');self.answer(True);self.drain();assert self.map()==16
  self.trigger(180,'Motavia return boarding');self.answer(True);self.drain();assert self.map()==5
  self.trigger(26,'Palma Passport return gate');self.answer(True);self.drain()
  self.trigger(27,'Palma Roadpass town exit');self.drain();assert self.map()==4;self.rest();self.checkpoint('07-return-palma')
 def use(self,item):
  assert item in self.items(),(item,self.items())
  if self.state()==17:self.wait(lambda:not self.byte('dungeon_keys_delay'),'Item menu native dungeon delay')
  if self.state()in(1,17):self.press('start')
  assert self.state()==2,(self.state(),item)
  while self.byte('menu_choice')!=2:self.press('down')
  self.press('a');assert self.state()==9
  while self.byte('item_slot')!=self.items().index(item):self.press('down')
  vehicle=self.byte('game_vehicle');self.press('a')
  if vehicle and item==32+vehicle//4:return
  assert self.state()==10;self.press('a')
 def heal_between(self):
  if self.state()not in(1,17):return
  living=[c for c in range(4)if self.byte('game_rpg',89)&(1<<c)and self.byte('game_rpg',c*16)&1]
  wounded=[c for c in living if self.byte('game_rpg',c*16+1)<max(12,self.byte('game_rpg',c*16+6)//2)]
  if not wounded:return
  target=min(wounded,key=lambda c:self.byte('game_rpg',c*16+1)/self.byte('game_rpg',c*16+6));before=self.byte('game_rpg',target*16+1)
  eligible=lambda c,cost:c in living and self.byte('game_rpg',c*16+2)>=cost+(self.mp_reserve if c==0 else self.myau_reserve if c==1 else self.noah_reserve if c==3 else 0) and self.byte('game_rpg',c*16+15)
  if eligible(3,6)and self.byte('game_rpg',target*16+6)-before>=40:caster,cost,amount=3,6,80
  elif eligible(0,4):caster,cost,amount=0,2,20
  elif eligible(1,6):caster,cost,amount=1,6,80
  elif eligible(3,6):caster,cost,amount=3,6,80
  elif eligible(0,2):caster,cost,amount=0,2,20
  elif 37 in self.items():self.food_heal(target);return
  else:return
  mp=self.byte('game_rpg',caster*16+2)
  frame=self.word('frame_counter');self.wait(lambda:self.word('frame_counter')!=frame,'Field healing input-ready')
  if self.state()==17:self.wait(lambda:not self.byte('dungeon_keys_delay'),'Healing dungeon input-ready')
  self.press('start');assert self.state()==2
  while self.byte('menu_choice')!=7:self.press('down')
  self.press('a');assert self.state()==11
  while self.byte('party_choice')!=caster:self.press('down')
  self.press('a');assert self.state()==19;self.press('a');assert self.state()==11
  while self.byte('party_choice')!=target:self.press('down')
  self.press('a');self.drain((1,2,17))
  if self.state()==2:self.press('b');self.wait(lambda:self.state()in(1,17),'Healing menu return')
  assert self.byte('game_rpg',caster*16+2)==mp-cost and self.byte('game_rpg',target*16+1)==min(before+amount,self.byte('game_rpg',target*16+6));self.record('field_heal',caster=caster,target=target,before=before,after=self.byte('game_rpg',target*16+1),mp_cost=cost)
 def dungeon_state(self):return tuple(self.byte('game_dungeon',i)for i in range(4))
 def dungeon_route(self,goal):
  floor,position,direction,light=self.dungeon_state();raw=(ROOT/'assets/dungeons/dungeon_layouts.bin').read_bytes()[floor*128:(floor+1)*128];layout=[n for b in raw for n in(b>>4,b&15)]
  # Runtime door-open bits are observed, never written. Require low7 source
  # nibble equality before using the original layout as navigation evidence.
  runtime=[self.byte('game_dungeon',8+i)for i in range(256)]
  assert all((a&127)==b for a,b in zip(runtime,layout)),('Unexpected floor mutation',floor)
  start=(position,direction);q=deque([start]);prev={start:None};deltas=(-16,1,16,-1)
  while q:
   at=q.popleft()
   if at==goal:break
   p,d=at
   candidates=[('left',(p,(d+3)%4)),('right',(p,(d+1)%4))]
   f=(p+deltas[d])&255;b=(p-deltas[d])&255
   kind=layout[f]&7
   if kind==0:candidates.append(('up',(f,d)))
   elif not layout[f]&8 and(kind==4 or(kind==5 and 45 in self.items())or(kind==6 and 62 in self.items())):
    key='up'if runtime[f]&128 else'a_up'if kind==4 else'key_up'
    candidates.append((key,((f+deltas[d])&255,d)))
   elif kind==7:candidates.append(('up',((f+deltas[d])&255,d)))
   if (layout[b]&7)==0:candidates.append(('down',(b,d)))
   for key,nxt in candidates:
    if nxt not in prev:prev[nxt]=(at,key);q.append(nxt)
  assert goal in prev,('No ordinary source dungeon route',floor,start,goal)
  steps=[];at=goal
  while prev[at]:at,key=prev[at];steps.append(key)
  return steps[::-1]
 def dungeon_step(self,key):
  assert self.state()==17;self.heal_between()
  self.wait(lambda:not self.byte('dungeon_keys_delay'),'Dungeon input delay');self.tick(12);self.press(key,48)
  frame=self.word('frame_counter');self.wait(lambda:self.word('frame_counter')!=frame,'Dungeon frame completed',2400)
  if self.state()==15:self.battle()
 def odin(self):
  if not self.byte('game_dungeon',264):
   assert self.map()==4 and 43 in self.items()and 39 in self.items();self.rest();self.walk([(109,23)],'Camineet exit for Odin cave');self.walk([(77,64)],'Original Odin cave entrance')
   self.drain((2,17));assert self.dungeon_state()[:3]==(0,0xdc,0)
  if not self.dungeon_state()[3]:self.use(39);self.drain((17,))
  self.checkpoint('08-odin-cave-lit')
  for _ in range(200):
   if self.dungeon_state()[1:3]==(0xe2,1)and self.state()==2:break
   assert self.state()==17,('Unexpected dungeon action',self.state(),self.dungeon_state())
   steps=self.dungeon_route((0xe2,1));assert steps
   self.dungeon_step(steps[0])
   if self.state()==4:self.drain((2,17))
  else:raise AssertionError('Odin route exceeded200commands')
  self.use(43);self.drain((17,));assert self.byte('game_rpg',89)==7 and 43 not in self.items()and self.byte('game_events',10)==255
  self.report['milestones'].append('Original Odin cave, paid Flash, real Alsulin use, source revival and Odin recruitment');self.checkpoint('09-odin')
 def dungeon_walk(self,goal):
  for _ in range(300):
   if self.dungeon_state()[1:3]==goal:return
   assert self.state()==17,('Unexpected dungeon interaction',self.state(),self.dungeon_state(),goal)
   steps=self.dungeon_route(goal);assert steps;key=steps[0]
   if key=='a_up':self.dungeon_step('a');key='up'
   elif key=='key_up':self.use(62 if 62 in self.items() else 45);self.drain((17,));key='up'
   elif key=='trap_up':self.field_spell(1,1);key='up'
   elif key=='open_up':self.field_spell(3,3);key='up'
   self.dungeon_step(key)
   if self.state()==4:self.drain((17,2))
  raise AssertionError(('Dungeon route limit',goal))
 def compass(self):
  assert self.byte('game_rpg',89)==7 and self.dungeon_state()[0]==0
  self.dungeon_walk((0x35,1));assert 53 in self.items();self.checkpoint('10-compass')
  self.dungeon_walk((0x8c,0));self.drain((17,));self.checkpoint('11-cave-money-chest')
  self.dungeon_walk((0xdc,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Odin cave source exit');self.tick(80)
  self.rest();self.report['milestones'].append('Compass chestC600 and source cave exit');self.checkpoint('12-compass-camineet')
 def key_rumor(self):
  assert self.map()==4 and 53 in self.items();self.walk([(109,23)],'Camineet exit for Eppi');self.walk([(85,76),(86,76),(85,77),(86,77)],'Original Eppi entrance');assert self.map()==8
  self.trigger(42,'Eppi Dungeon Key rumor');self.answer(True);self.drain();self.checkpoint('13-key-rumor')
  self.walk([(71,29),(72,29)],'Leave Eppi');self.rest();self.checkpoint('14-return-from-eppi')
 def warehouse(self):
  if not self.byte('game_dungeon',264):
   assert self.map()==4;self.walk([(108,15),(109,15)],'Camineet warehouse original entrance');self.drain((17,));assert self.dungeon_state()[:3]==(2,0x5e,0)
  if 45 not in self.items():
   self.dungeon_walk((0x18,3));assert 45 in self.items();self.checkpoint('15-dungeon-key')
  # Floor2 also contains disconnected Abion houses; only50Meseta is
  # reachable from the original Camineet entrance.
  for goal in((0x68,3),):
   self.dungeon_walk(goal);self.drain((17,))
  self.checkpoint('16-warehouse-treasures');self.dungeon_walk((0x5e,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Warehouse exit');self.tick(80);self.rest();self.checkpoint('17-warehouse-return')
 def cake_prepare(self):
  assert self.map()==4
  for c in range(3):
   if not self.byte('game_rpg',c*16)&1:self.revive(c)
  if 39 not in self.items():self.shop([(99,25),(100,25)],0,'Buy Flash for Naula')
  if 40 not in self.items():self.shop([(99,25),(100,25)],1,'Buy battle Escaper reserve')
  self.walk([(109,23)],'Leave Camineet for Parolit');self.walk([(70,55),(71,55),(70,56),(71,56)],'Parolit entrance');assert self.map()==6
  self.shop([(25,70),(26,70)],1,'Buy Titanium Sword');self.equip(7);assert self.byte('game_rpg',10)==7
  self.walk([(30,78),(31,78)],'Leave Parolit');self.rest();self.checkpoint('18-naula-prepared')
 def dungeon_multi_walk(self,goal,allow_objects=False,allow_falls=False):
  planner=DungeonRoutes()
  for _ in range(1000):
   current=self.dungeon_state()[:3]
   if current==goal:return
   if self.state()==5 and self.byte('game_events',260)==130:
    self.answer(True);self.drain((17,));self.record('prison_roadpass_check',position=list(current));continue
   if self.state()==5 and self.byte('game_events',260)==147:
    self.force_fight.add(46);self.answer(False);self.drain((17,));self.record('baya_prison_robotcop_defeated',position=list(current));continue
   assert self.state()==17,('Unexpected multi-floor interaction',self.state(),current,goal)
   story=bytes(self.byte('game_events',i)for i in range(256));objects=bytes(self.byte('game_events',self.event_objects+i)for i in range(256));runtime=bytes(self.byte('game_dungeon',8+i)for i in range(256))
   path=planner.route(current,goal,self.items(),story,objects,runtime,avoid_objects=not allow_objects,allow_falls=allow_falls,can_disarm=not allow_falls and bool(self.byte('game_rpg',16)&1 and self.byte('game_rpg',31)>=2 and self.byte('game_rpg',18)>=2),can_open=bool(self.byte('game_rpg',48)&1 and self.byte('game_rpg',63)>=4 and self.byte('game_rpg',50)>=4));assert path;row=path[0];key=row['input'];self.record('dungeon_plan_step',**row)
   if key=='wait':
    self.wait(lambda:self.dungeon_state()[:3]!=current,'Original current-cell pitfall');self.wait(lambda:self.state()==17,'Pitfall presentation');continue
   if key=='a_up':self.dungeon_step('a');key='up'
   elif key=='key_up':self.use(62 if 62 in self.items() else 45);self.drain((17,));key='up'
   elif key=='trap_up':self.field_spell(1,1);key='up'
   elif key=='open_up':self.field_spell(3,3);key='up'
   self.dungeon_step(key)
   if self.dungeon_state()[:3]==goal:return
   if self.state()==4:self.drain((17,2,5))
  raise AssertionError(('Multi-floor route exceeded1000commands',goal))
 def cake(self):
  if not self.byte('game_dungeon',264):
   assert self.map()==4 and self.word('game_rpg',90)>=280 and 39 in self.items()
   self.walk([(109,23)],'Leave Camineet for Naula');self.walk([(99,10)],'Original Naula entrance');self.drain((2,17));assert self.dungeon_state()[:3]==(19,0x13,3)
   if not self.dungeon_state()[3]:self.use(39);self.drain((17,))
   self.checkpoint('19-naula-entry')
  self.dungeon_multi_walk((16,0x64,1));self.checkpoint('20-cake-door');self.dungeon_step('a');self.dungeon_step('up');self.answer(True);self.drain((17,));assert 54 in self.items();self.checkpoint('21-cake-purchased')
  self.dungeon_multi_walk((19,0x13,1));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Naula source exit');self.tick(80);self.rest();self.checkpoint('22-cake-camineet');self.report['milestones'].append('Original Naula multi-floor route,280Meseta Cake purchase and original stair return')
 def to_paseo(self):
  assert self.map()==4 and 51 in self.items()and 52 in self.items();self.trigger(11,'Camineet Roadpass to spaceport');self.drain();assert self.map()==5
  self.trigger(26,'Palma Passport gate');self.answer(True);self.drain();self.trigger(179,'Ship81 to Motavia');self.answer(True);self.drain();assert self.map()==16
  self.trigger(11,'Motavia Roadpass to Paseo');self.drain();assert self.map()==14
 def governor(self):
  if self.map()==4:
   for c in range(3):
    if not self.byte('game_rpg',c*16)&1:self.revive(c)
   if 39 not in self.items():self.shop([(99,25),(100,25)],0,'Buy Flash for Noah cave')
   self.to_paseo()
  assert self.map()==14 and 54 in self.items()
  if self.byte('game_rpg',16+11)!=20:
   self.shop([(25,28),(26,28)],1,'Buy Myau Thick Fur');self.equip(20,1);assert self.byte('game_rpg',27)==20
  self.checkpoint('23-paseo-equipped');self.walk([(33,26),(34,26)],'Paseo palace entrance');self.drain((17,));assert self.dungeon_state()[:3]==(33,0xd4,0)
  self.dungeon_multi_walk((33,0xa4,0));self.answer(True);self.drain((17,));assert 54 not in self.items()and self.byte('game_events',17)==255
  self.dungeon_multi_walk((33,0x61,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Upper palace exit');self.tick(80)
  self.trigger(55,'Governor Letter and nightmare');self.drain((1,));assert 55 in self.items();assert all(self.byte('game_rpg',c*16)&1 and self.byte('game_rpg',c*16+1)==self.byte('game_rpg',c*16+6)for c in range(3))
  self.report['milestones'].append('Cake guard flagC511, Governor Letter, actual Saccubus nightmare and scripted living-party recovery');self.checkpoint('24-governor-letter')
 def noah(self):
  if not self.byte('game_dungeon',264):
   assert self.map()==14 and 55 in self.items();self.walk([(29,19),(30,19)],'Governor palace return stairs');self.drain((17,));self.dungeon_multi_walk((33,0xd4,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Lower Paseo exit');self.tick(80)
   self.walk([(19,12),(20,12)],'Leave Paseo for Motavia');assert self.map()==1;self.walk([(54,9),(55,9)],'Original Noah cave entrance');self.drain((2,17));assert self.dungeon_state()[:3]==(30,0x69,1)
   if not self.dungeon_state()[3]:self.use(39);self.drain((17,))
   self.checkpoint('25-noah-cave-entry')
  self.dungeon_multi_walk((29,0x68,2));self.checkpoint('26-noah-door');self.dungeon_step('a');self.dungeon_step('up');self.drain((17,));assert self.byte('game_rpg',89)==15 and self.byte('game_events',6)==1 and 55 not in self.items()
  self.report['milestones'].append('Actual Motavia traversal, Noah cave stairs/door, Letter consumed and Noah recruited');self.checkpoint('27-noah')
 def noah_return(self):
  assert self.byte('game_rpg',89)==15
  if self.byte('game_dungeon',264):
   self.dungeon_multi_walk((30,0x69,3));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Noah cave original exit');self.tick(80)
  if self.map()==1:self.walk([(100,32)],'Motavia Paseo entrance')
  if self.map()==14:self.return_palma()
  assert self.map()==4
  for c in range(4):
   if not self.byte('game_rpg',c*16)&1:self.revive(c)
  self.checkpoint('28-four-party-camineet')
 def western_passage(self):
  assert self.map()==4 and self.byte('game_events',6)
  if 57 not in self.items():
   self.walk([(109,23)],'Leave Camineet for Magic Lamp');self.walk([(70,55),(71,55),(70,56),(71,56)],'Parolit Magic Lamp trip');self.shop([(29,70),(30,70)],2,'Buy original Magic Lamp');assert 57 in self.items()
   self.walk([(30,78),(31,78)],'Leave Parolit with Magic Lamp');self.rest()
  self.trigger(11,'Roadpass to Noah passage');self.drain();assert self.map()==5
  self.walk([(18,32)],'Noah-enabled original spaceport passage');self.drain((17,));assert self.dungeon_state()[:3]==(0,0xde,0)and self.dungeon_state()[3]
  self.dungeon_multi_walk((0,0x2e,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Original passage exits Gothic');self.tick(80);assert self.map()==7
  self.checkpoint('29-western-palma-passage')
 def luveno(self):
  assert self.byte('game_rpg',89)==15
  if not self.byte('game_events',4):
   if self.map()==4:self.western_passage()
   if not self.byte('game_dungeon',264):
    assert self.map()==7;self.walk([(47,23)],'Leave Gothic for Luveno prison');self.walk([(51,80),(51,81)],'Original Luveno prison entrance');self.drain((17,));assert self.dungeon_state()[:3]==(1,0xd2,0)
   self.dungeon_multi_walk((1,0x69,2));self.use(45);self.drain((17,))
   while self.byte('game_events',3)<2:
    visit=self.byte('game_events',3);self.dungeon_step('up');self.drain((17,));assert self.byte('game_events',3)==visit+1
   self.dungeon_step('up');self.drain((5,));self.answer(True);self.drain((17,));assert self.byte('game_events',4)==1
   self.checkpoint('29-luveno-freed')
  if self.byte('game_dungeon',264)and self.dungeon_state()[0]==1:
   self.dungeon_multi_walk((1,0xd2,2));self.dungeon_step('a');self.dungeon_step('up');self.wait(lambda:self.state()==1,'Luveno prison exit');self.tick(80)
  if self.map()==0:self.walk([(54,54),(55,54),(54,55),(55,55)],'Original Gothic entrance')
  assert self.map()==7
  if not self.byte('game_dungeon',264):
   self.walk([(44,15),(45,15)],'Original Gothic assistant cave');self.drain((2,17));assert self.dungeon_state()[:3]==(0,0x2e,2)
  if not self.dungeon_state()[3]:self.use(39);self.drain((17,))
  if self.byte('game_events',4)==1:
   self.dungeon_multi_walk((0,0x5d,3));self.dungeon_step('a');self.dungeon_step('up');self.drain((17,));assert self.byte('game_events',4)==2
  self.dungeon_multi_walk((0,0x2e,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Assistant cave Gothic exit');self.tick(80)
  self.report['milestones'].append('Three Luveno prison visits, original agreement, Gothic assistant flagC504=2');self.checkpoint('30-luveno-assistant')
 def hospital(self,goals):
  wounded=[c for c in range(4)if self.byte('game_rpg',89)&(1<<c)and self.byte('game_rpg',c*16)&1 and(self.byte('game_rpg',c*16+1)!=self.byte('game_rpg',c*16+6)or self.byte('game_rpg',c*16+2)!=self.byte('game_rpg',c*16+7))]
  if not wounded:return
  self.walk(goals,'Original hospital treatment');self.answer(True);self.drain((11,))
  for i,c in enumerate(wounded):
   while self.byte('party_choice')!=c:self.press('down')
   self.press('a');self.answer(True);self.drain((5,))
   assert self.byte('game_rpg',c*16+1)==self.byte('game_rpg',c*16+6)and self.byte('game_rpg',c*16+2)==self.byte('game_rpg',c*16+7)
   self.answer(i+1<len(wounded));self.drain((11,)if i+1<len(wounded)else(1,))
 def construction(self):
  assert self.map()==7 and self.byte('game_events',4)>=2
  if self.byte('game_events',4)==2:self.trigger(62,'Luveno construction payment');self.answer(True);self.drain();assert self.byte('game_events',4)==3
  while self.byte('game_events',4)<6:self.trigger(62,'Luveno original construction wait visit');self.drain()
  self.hospital([(43,26),(44,26)]);self.report['milestones'].append('Paid original1200Meseta construction and three Luveno wait visits');self.checkpoint('31-luveno-construction')
 def abion(self):
  assert self.map()==7 and self.byte('game_events',4)==6 and self.word('game_rpg',90)>=1600
  self.walk([(47,23)],'Gothic east exit for Bortevo');assert self.map()==0
  self.walk([(24,48),(25,48),(24,49),(25,49)],'Original lava route to Bortevo');assert self.map()==11;self.checkpoint('32-bortevo-lava-arrival')
  self.walk([(64,58),(64,59)],'Bortevo exit for north passage');assert self.map()==0
  self.walk([(26,46)],'Original Bortevo north cave');self.drain((17,));assert self.dungeon_state()[:3]==(22,0xde,0)
  self.dungeon_multi_walk((22,0x21,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Original cave north exit');self.tick(80);assert self.map()==0
  self.walk([(14,14),(15,14),(14,15),(15,15)],'Original northern Palma route to Abion');assert self.map()==10
  self.shop([(37,66),(38,66)],2,'Buy original Polymaterial1600');assert 44 in self.items();self.checkpoint('33-abion-polymaterial')
 def hapsby(self):
  assert self.map()==10 and 44 in self.items();self.hospital([(25,66),(26,66)])
  self.walk([(32,71),(33,71)],'Original Abion south exit');assert self.map()==0
  self.walk([(23,36)],'Original north cave return');self.drain((17,));assert self.dungeon_state()[:3]==(22,0x21,2)
  self.dungeon_multi_walk((22,0xde,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Original Bortevo cave south exit');self.tick(80)
  self.walk([(24,48),(25,48),(24,49),(25,49)],'Return Bortevo for Hapsby');assert self.map()==11
  self.trigger(161,'Bortevo Hapsby junk heap');self.drain((2,));self.use(44);self.drain();assert 50 in self.items()and 44 not in self.items();self.checkpoint('34-hapsby')
  self.walk([(64,58),(64,59)],'Leave Bortevo for Gothic');self.walk([(54,54),(55,54),(54,55),(55,55)],'Original lava return to Gothic');assert self.map()==7
  self.trigger(62,'Luveno completed ship with Hapsby');self.drain();assert self.byte('game_events',4)==7
  self.report['milestones'].append('Lava passage and original north cave,1600Meseta Polymaterial purchase, actual Hapsby junk-heap use and Luveno ship completion');self.checkpoint('35-luveno-ship')
 def ship(self,destination):
  self.trigger(181,'Original Hapsby ship destination');self.drain((16,))
  while self.byte('choice')!=destination:self.press('down')
  self.press('a');self.answer(True);self.drain();assert self.map()==(7,15,19)[destination]
 def search(self):
  if self.state()in(1,17):self.press('start')
  assert self.state()==2
  while self.byte('menu_choice')!=3:self.press('down')
  self.press('a');self.drain()
 def uzo(self):
  if self.map()==7:
   assert self.byte('game_events',4)==7;self.hospital([(43,26),(44,26)])
   self.trigger(170,'Original Gothic bridge permission');self.drain();self.ship(1);self.checkpoint('36-hapsby-uzo')
  if self.map()==15:
   self.trigger(78,'Uzo Flute rumor');self.answer(False);self.drain();assert self.byte('game_events',7)==1
   self.walk([(96,23)],'Leave Uzo for Casba');assert self.map()==1
  if not self.byte('game_dungeon',264):
   self.walk([(92,92),(93,92)],'Original Uzo-side Casba cave entrance');self.drain((17,));assert self.dungeon_state()[:3]==(39,0xd3,0)
  self.dungeon_multi_walk((39,0xdc,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Original cave exit into Casba');self.tick(80);assert self.map()==17
  self.trigger(85,'Casba Hovercraft rumor');self.answer(True);self.drain();assert self.byte('game_events',8)==1;self.checkpoint('37-casba-hovercraft-rumor')
 def hovercraft(self):
  assert self.map()==17 and self.byte('game_events',8)
  self.walk([(83,51),(84,51)],'Original Casba cave return');self.drain((17,));assert self.dungeon_state()[:3]==(39,0xdc,0)
  self.dungeon_multi_walk((39,0xd3,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Original Casba cave Uzo-side exit');self.tick(80);assert self.map()==1
  self.walk([(113,62),(114,62),(113,63),(114,63)],'Original Uzo return');assert self.map()==15;self.ship(0)
  self.trigger(170,'Original Gothic bridge east');self.drain()
  self.walk([(30,32)],'Original Flute hidden location');self.search();assert 38 in self.items()and self.byte('game_events',7)==255
  self.hospital([(43,26),(44,26)]);self.checkpoint('38-flute')
  self.walk([(47,23)],'Leave Gothic for Hovercraft');self.walk([(24,48),(25,48),(24,49),(25,49)],'Original lava route to Hovercraft');assert self.map()==11
  self.trigger(162,'Bortevo Hovercraft junk heap');self.drain((2,));self.search();assert 34 in self.items();self.checkpoint('39-hovercraft')
  self.walk([(64,58),(64,59)],'Leave Bortevo with Hovercraft');self.walk([(54,54),(55,54),(54,55),(55,55)],'Return Gothic with Hovercraft');assert self.map()==7
  self.report['milestones'].append('Actual Hapsby ship83/85, Uzo Flute rumor/search, Casba Hovercraft rumor and Bortevo SEARCH reward');self.checkpoint('40-hovercraft-gothic')
 def boss_gear(self):
  if self.map()==7:
   self.walk([(44,15),(45,15)],'Gothic passage for equipment');self.drain((17,));self.dungeon_multi_walk((0,0xde,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Gothic passage original spaceport exit');self.tick(80);assert self.map()==5
   self.trigger(27,'Roadpass return for equipment');self.drain();assert self.map()==4
  self.rest()
  for c in range(4):
   if not self.byte('game_rpg',c*16)&1:self.revive(c)
  if self.word('game_rpg',90)<2520:self.grind(2520,100)
  self.shop([(94,25),(95,25)],1,'Buy Alis Iron Shield520');self.equip(27);self.equip(25,2)
  self.walk([(109,23)],'Camineet exit for armor');self.walk([(103,43),(103,44)],'Scion armor trip');assert self.map()==13
  self.shop([(87,71),(88,71)],2,'Buy Alis Zirconian Armor1000');self.equip(21)
  self.shop([(87,71),(88,71)],2,'Buy Odin Zirconian Armor1000');self.equip(21,2)
  self.walk([(80,72)],'Leave Scion with boss armor');self.rest();self.checkpoint('41-earned-boss-equipment')
  self.western_passage();self.report['milestones'].append('Earned520Iron Shield and two1000Zirconian Armors through actual stores/equipment for source boss preparation');self.checkpoint('42-equipped-gothic')
 def blue_dragon(self):
  self.force_fight={69}
  if self.map()==7:
   self.trigger(170,'Gothic bridge for Amber Eye voyage');self.drain();self.ship(1)
  if not self.byte('game_dungeon',264):
   assert self.map()==15;self.walk([(96,23)],'Uzo exit for Blue Dragon');self.walk([(92,92),(93,92)],'Original Casba cave entrance for Amber Eye');self.drain((17,));assert self.dungeon_state()[:3]==(39,0xd3,0)
  path=DungeonRoutes().route(self.dungeon_state()[:3],(37,0x1c,1),self.items(),bytes(self.byte('game_events',i)for i in range(256)),bytes(self.byte('game_events',self.event_objects+i)for i in range(256)))
  self.dungeon_multi_walk(tuple(path[-1]['from']));self.checkpoint('43-blue-dragon-approach')
  self.dungeon_multi_walk((37,0x1c,1));assert 58 in self.items()and self.byte('game_events',self.event_objects+206)==255
  self.report['milestones'].append('Original fixed BlueDragon69 battle, actual AmberEye reward chestC6CE');self.checkpoint('44-amber-eye')
  self.use(38);self.drain((1,));assert self.map()==1;self.walk([(113,62),(114,62),(113,63),(114,63)],'Return Uzo with Amber Eye');assert self.map()==15
  self.hospital([(75,23),(76,23)]);self.checkpoint('45-amber-eye-uzo')
 def recover_party(self):
  assert self.map()in(4,15)
  goals=[(107,30),(108,30)]if self.map()==4 else[(67,15),(68,15)]
  for c in range(4):
   if not self.byte('game_rpg',89)&(1<<c)or self.byte('game_rpg',c*16)&1:continue
   self.walk(goals,'Original church recovery after Blue Dragon');self.answer(True);self.drain((11,))
   while self.byte('party_choice')!=c:self.press('down')
   self.press('a');self.answer(True);self.drain((5,));self.answer(False);self.drain();assert self.byte('game_rpg',c*16)&1
  self.checkpoint('46-party-revived')
 def dezoris_passage(self,goals,start,end,name):
  if not self.byte('game_dungeon',264):
   self.walk(goals,name+' entrance');self.drain((17,));assert self.dungeon_state()[:3]==start
  self.dungeon_multi_walk(end);self.dungeon_step('up');self.wait(lambda:self.state()==1,name+' source exit');self.tick(80);assert self.map()==2
 def dezoris(self):
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('dezoris',0)
  if stage==0:
   if self.map()==15:self.ship(2)
   assert self.map()==19;self.walk([(32,19)],'Leave Skure spaceport for original Dezoris caves');assert self.map()==2
   task['dezoris']=stage=1;self.checkpoint('47-dezoris-skure')
  routes=[
   ([(54,89),(55,89)],(47,0xdd,3),(47,0xd2,3),'Dezoris south passage'),
   ([(30,83),(31,83)],(48,0xed,3),(48,0x87,0),'Dezoris southwest passage'),
   ([(16,67),(17,67)],(50,0xdb,0),(50,0x59,0),'Dezoris western passage'),
   ([(94,43),(95,43)],(48,0x79,0),(48,0x2e,0),'Dezoris northeast passage')]
  for i,(goals,start,end,name)in enumerate(routes,1):
   if stage>i:continue
   self.dezoris_passage(goals,start,end,name);task['dezoris']=stage=i+1;self.checkpoint('48-dezoris-passage-'+str(i))
  if stage==5:
   self.walk([(52,11),(53,11)],'Original Corona Tower entrance');self.drain((17,));assert self.dungeon_state()[:3]==(43,0xd1,0)
   task['dezoris']=6;self.checkpoint('49-corona-entry')
 def torch(self):
  # The actual Corona defeat exhausted both escape casters. Keep Noah's
  # source Tele available instead of spending it on ordinary field healing.
  self.avoid_combat=True;self.mp_reserve=8;self.noah_reserve=40
  task=self.report.setdefault('campaign_tasks',{})
  if task.get('torch_preparation')==1:
   assert self.map()==22 and self.state()==1
   self.leave_aukba();task['aukba']=0
   self.dezoris_passage([(94,43),(95,43)],(48,0x79,0),(48,0x2e,0),'Rested party return through original northeast Dezoris cave')
   self.walk([(52,11),(53,11)],'Return to Corona after original hospital recovery');self.drain((17,))
   assert self.dungeon_state()[:3]==(43,0xd1,0)
   task['torch_preparation']=2;self.checkpoint('torch-prepared-corona-entry')
  assert self.byte('game_dungeon',264)and 58 in self.items()
  self.dungeon_multi_walk((46,0x2d,2));self.checkpoint('50-torch-door');self.use(45);self.drain((17,));self.dungeon_step('up');self.answer(True);self.drain((17,));assert 47 in self.items()and 58 not in self.items()
  self.checkpoint('51-eclipse-torch');self.use(38);self.drain((1,));assert self.map()==2
  self.report['milestones'].append('Original Dezoris four-cave route and203-command Corona Tower climb; AmberEye exchanged for EclipseTorch');self.checkpoint('52-torch-dezoris')
 def torch_recover(self):
  self.continue_game();self.avoid_combat=True;self.mp_reserve=8;self.noah_reserve=40
  self.record('torch_preparation_after_defeat',reason='Original Corona encounters exhausted Alis and Noah MP. Use actual Continue, Flute and the original Aukba hospital route before returning; preserve Noah MP for native Tele and escape ordinary encounters.')
  if self.byte('game_dungeon',264):self.use(38);self.drain((1,))
  if self.map()==2:self.report.setdefault('campaign_tasks',{})['aukba']=0
  else:assert self.map()==22
  self.aukba()
  assert self.map()==22 and all(p[0]&1 and p[1]==p[6] and p[2]==p[7] for p in self.party())
  self.report.setdefault('campaign_tasks',{})['torch_preparation']=1
  self.checkpoint('torch-continue-aukba-rested')
 def aukba(self):
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('aukba',0)
  if stage==0:
   self.dezoris_passage([(96,35),(97,35)],(48,0x2e,2),(48,0x79,2),'Corona return passage');task['aukba']=stage=1;self.checkpoint('53-corona-return-passage')
  if stage==1:
   self.dezoris_passage([(44,47),(45,47)],(49,0xe2,1),(49,0x1c,1),'Original Aukba outer passage');task['aukba']=stage=2;self.checkpoint('54-aukba-outside')
  if stage==2:
   self.walk([(72,42),(73,42),(72,43),(73,43)],'Aukba outer settlement');assert self.map()==20;self.walk([(56,18),(57,18)],'Aukba underground passage');self.drain((17,));assert self.dungeon_state()[:3]==(40,0xdd,0);task['aukba']=stage=3
  if stage==3:
   self.dungeon_multi_walk((40,0x87,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Aukba underground exit');self.tick(80);assert self.map()==22;task['aukba']=4;self.checkpoint('55-aukba-town')
  assert self.map()==22
  self.walk([(44,16),(45,16)],'Visit original Aukba church to record the Fly destination');self.answer(False);self.drain()
  for c in range(4):
   if not self.byte('game_rpg',c*16)&1:
    self.walk([(44,16),(45,16)],'Aukba source church recovery');self.answer(True);self.drain((11,))
    while self.byte('party_choice')!=c:self.press('down')
    self.press('a');self.answer(True);self.drain((5,));self.answer(False);self.drain();assert self.byte('game_rpg',c*16)&1
  self.hospital([(22,31),(23,31)]);self.checkpoint('56-aukba-rested')
 def ice_funds(self,money=12000,max_battles=150):
  initial=len(self.report['battles'])
  while self.word('game_rpg',90)<money:
   assert self.map()==22 and self.state()==1
   self.hospital([(22,31),(23,31)])
   for c in range(4):assert self.byte('game_rpg',c*16)&1,('Aukba farming needs actual church revival',c)
   self.checkpoint('ice-digger-funds-town')
   self.walk([(31,27),(32,27)],'Aukba cave for earned Ice Digger funds');self.drain((17,));assert self.dungeon_state()[:3]==(40,0x87,0)
   self.dungeon_multi_walk((40,0xb7,1))
   before=len(self.report['battles'])
   for i in range(3000):
    if any(not self.byte('game_rpg',c*16)&1 for c in range(4)):break
    if len(self.report['battles'])-initial>=max_battles:raise RuntimeError('Ice Digger battle budget reached; exact native state retained')
    if len(self.report['battles'])-before>=7 or self.word('game_rpg',90)>=money+200:break
    # Original dungeon encounters also run after turning. Both chosen views
    # alternate between an empty corridor and wall. The open rear cell keeps
    # source escape geometry available; no encounter probability/RNG is changed.
    if self.dungeon_state()[1]!=0xb7:self.dungeon_multi_walk((40,0xb7,1))
    self.dungeon_step('left'if self.dungeon_state()[2]==1 else'right')
    assert self.state()==17
   else:raise AssertionError('No natural cave encounter during source turns')
   self.use(38);self.drain((1,));assert self.map()==22
   if any(not self.byte('game_rpg',c*16)&1 for c in range(4)):self.aukba()
   self.hospital([(22,31),(23,31)])
  self.checkpoint('57-earned-ice-digger-funds')
 def sell_surplus(self):
  surplus=[item for item in self.items()if item in(2,6,16,17,19,21,25,39)or(item==40 and 4 in self.items())or(item==7 and self.byte('game_rpg',10)==14)or(item==27 and self.byte('game_rpg',44)==31 and self.byte('game_rpg',12)==32)]
  if not surplus:return
  self.walk([(20,31),(21,31)],'Aukba original surplus equipment sale');self.drain((14,));self.press('right');self.press('a');self.drain((9,))
  for i,item in enumerate(surplus):
   while self.byte('item_slot')!=self.items().index(item):self.press('down')
   self.press('a');self.answer(True);self.drain((5,));self.answer(i+1<len(surplus));self.drain((9,)if i+1<len(surplus)else(1,))
 def discard_surplus(self):
  if self.state()==9 and self.byte('service_active'):self.press('b');self.drain((1,))
  surplus=[item for item in self.items()if item in(2,6,16,17,19,21,25,39)or(item==40 and 4 in self.items())or(item==7 and self.byte('game_rpg',10)==14)or(item==27 and self.byte('game_rpg',44)==31 and self.byte('game_rpg',12)==32)]
  if not surplus:return
  if self.state()==17:self.wait(lambda:not self.byte('dungeon_keys_delay'),'Drop menu native dungeon delay')
  self.press('start')
  while self.byte('menu_choice')!=2:self.press('down')
  self.press('a');assert self.state()==9
  for item in surplus:
   before=len(self.items())
   while self.byte('item_slot')!=self.items().index(item):self.press('down')
   self.press('a');self.press('down');self.press('down');self.press('a');self.drain((9,));assert len(self.items())==before-1
   self.record('actual_drop',item=item,reason='Unneeded old gear/Flash; frozen4f4 SELL failure recorded separately')
  self.press('b');self.press('b');assert self.state()in(1,17)
 def ice_digger(self):
  assert self.map()==22 and self.word('game_rpg',90)>=12000
  self.discard_surplus();self.shop([(18,31),(19,31)],0,'Buy original Ice Digger12000');assert 35 in self.items();self.checkpoint('58-ice-digger-purchased')
  self.walk([(31,27),(32,27)],'Leave Aukba underground with Ice Digger');self.drain((17,));self.dungeon_multi_walk((40,0xdd,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Aukba outer exit');self.tick(80);assert self.map()==20
  self.walk([(56,22),(57,22)],'Leave Aukba settlement for ice terrain');assert self.map()==2
  self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12;self.checkpoint('59-ice-digger-active')
 def debug_sale(self):
  assert self.state()==9
  while self.byte('item_slot')!=self.items().index(2):self.press('down')
  self.press('a');self.record('sale_debug',point='selected',service=list(self.e.memory[self.s['game_service']:self.s['game_service']+18]),choice=self.byte('choice'),state=self.state())
  self.drain((5,));capture(self.e,self.out/'sale-price.png');self.record('sale_debug',point='prompt',service=list(self.e.memory[self.s['game_service']:self.s['game_service']+18]),choice=self.byte('choice'),state=self.state())
  self.answer(True);self.record('sale_debug',point='answered',service=list(self.e.memory[self.s['game_service']:self.s['game_service']+18]),choice=self.byte('choice'),state=self.state());capture(self.e,self.out/'sale-result.png');self.drain((5,9));self.record('sale_debug',point='drained',service=list(self.e.memory[self.s['game_service']:self.s['game_service']+18]),choice=self.byte('choice'),state=self.state())
  with(self.out/'sale-debug.state').open('wb')as f:self.e.save_state(f)
  (self.out/'sale-debug.json').write_text(json.dumps({'rom_sha256':self.report['header']['sha256'],**self.snapshot()},indent=2)+'\n')
 def field_spell(self,caster,option):
  assert self.state()in(1,17)
  if self.state()==17:self.wait(lambda:not self.byte('dungeon_keys_delay'),'Spell menu native dungeon delay')
  self.press('start');assert self.state()==2
  while self.byte('menu_choice')!=7:self.press('down')
  self.press('a');self.drain((11,))
  while self.byte('party_choice')!=caster:self.press('down')
  self.press('a');assert self.state()==19
  while self.byte('magic_choice')!=option:self.press('down')
  self.press('a');self.drain((1,2,17))
  if self.state()==2:self.press('b');self.wait(lambda:self.state()in(1,17),'Field spell menu return')
 def laconia_armor(self):
  if self.state()not in(1,17):self.drain((1,17))
  if not self.byte('game_dungeon',264):
   assert self.map()==2
   if self.byte('game_vehicle'):self.use(35);self.drain((1,));assert not self.byte('game_vehicle')
   self.dezoris_passage([(66,43),(67,43)],(49,0x1c,3),(49,0xe2,3),'Aukba westward cave return')
   self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.walk([(78,4),(79,4),(78,5),(79,5)],'Ice Digger route to original Laconia Armor cave');self.drain((17,));assert self.dungeon_state()[:3]==(42,0xdd,3);self.checkpoint('60-laconia-cave')
  self.dungeon_multi_walk((42,0x89,2),allow_objects=True);assert 23 in self.items()and self.byte('game_events',self.event_objects+129)==255
  if self.byte('game_rpg',32)&1:self.equip(23,2);assert self.byte('game_rpg',43)==23
  self.checkpoint('61-laconia-armor-earned')
  self.use(38);self.drain((1,))
  if self.byte('game_rpg',2)>=8 and self.byte('game_rpg')&1:
   self.field_spell(0,1);assert self.map()==22
  else:
   self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.dezoris_passage([(44,47),(45,47)],(49,0xe2,1),(49,0x1c,1),'Earned armor return through Aukba outer cave')
   self.walk([(72,42),(73,42),(72,43),(73,43)],'Aukba settlement with earned armor');assert self.map()==20
   self.walk([(56,18),(57,18)],'Aukba underground return');self.drain((17,));self.dungeon_multi_walk((40,0x87,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Aukba underground exit');self.tick(80);assert self.map()==22
  self.aukba()
  if self.byte('game_rpg',43)!=23:self.equip(23,2)
  assert self.byte('game_rpg',43)==23
  self.report['milestones'].append('Original Sphinx164, MyauTrap cleared42/69, chestC681 LaconiaArmor23 earned and equipped Odin after actual church recovery');self.checkpoint('62-laconia-armor-rested')
 def leave_aukba(self):
  assert self.map()==22
  self.walk([(31,27),(32,27)],'Leave Aukba for original Dezoris routes');self.drain((17,));self.dungeon_multi_walk((40,0xdd,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Aukba outer exit');self.tick(80);assert self.map()==20
  self.walk([(56,22),(57,22)],'Leave Aukba settlement');assert self.map()==2
  self.dezoris_passage([(66,43),(67,43)],(49,0x1c,3),(49,0xe2,3),'Aukba westward original passage')
 def diamond_shield(self):
  self.avoid_combat=True;self.mp_reserve=8;task=self.report.setdefault('campaign_tasks',{});stage=task.get('diamond',0)
  if stage==0:
   self.leave_aukba();self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.dezoris_passage([(94,43),(95,43)],(48,0x79,0),(48,0x2e,0),'Diamond route to Corona side of original caves')
   self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.walk([(10,33),(11,33)],'Ice Digger to original Diamond Shield cave');self.drain((17,));assert self.dungeon_state()[:3]==(52,0xd3,0);task['diamond']=stage=1;self.checkpoint('63-diamond-shield-cave')
  if stage==1:
   self.dungeon_multi_walk((47,0x12,3));assert 32 in self.items()and self.byte('game_events',self.event_objects+139)==255
   if self.byte('game_rpg')&1:self.equip(32,0);assert self.byte('game_rpg',12)==32
   if self.byte('game_rpg',32)&1:self.equip(27,2);assert self.byte('game_rpg',44)==27
   task['diamond']=stage=2;self.checkpoint('64-diamond-shield-earned')
  if stage==2:
   self.use(38);self.drain((1,));assert self.byte('game_rpg',2)>=8 and self.byte('game_rpg')&1
   self.field_spell(0,1);assert self.map()==22;task['diamond']=stage=3
  self.mp_reserve=0;self.aukba();self.report['milestones'].append('Original156-command LaconiaShield cave, chestC68B item32, native equipment transfer and Flute/Fly return');self.checkpoint('65-diamond-shield-rested')
 def shield_recover(self):
  self.continue_game();self.use(38);self.drain((1,));self.field_spell(0,1);assert self.map()==22
  self.aukba();self.record('shield_preparation_after_defeat',reason='Original Mammoth group with blocked rear escape defeated the party. Earn levels and Noah Thun through actual Aukba encounters before returning; conserve resources by escaping ordinary open-rear fights.')
  self.ice_funds(5000,200);self.aukba()
  while self.byte('game_rpg',62)<5:self.ice_funds(self.word('game_rpg',90)+2000,150);self.aukba()
  self.report.setdefault('campaign_tasks',{})['diamond']=0;self.checkpoint('shield-continue-thunder-prepared')
 def skure_wand(self):
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('skure_wand',0)
  if stage==0:
   self.leave_aukba();self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.dezoris_passage([(14,57),(15,57)],(50,0x59,2),(50,0xdb,2),'Return original western Dezoris passage');task['skure_wand']=stage=1;self.checkpoint('66-skure-western-return')
  if stage==1:
   self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.dezoris_passage([(22,77),(23,77)],(48,0x87,2),(48,0xed,1),'Return original southwest Dezoris passage');task['skure_wand']=stage=2;self.checkpoint('67-skure-southwest-return')
  if stage==2:
   self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.dezoris_passage([(36,89),(37,89)],(47,0xd2,1),(47,0xdd,1),'Return original southern Dezoris passage');task['skure_wand']=stage=3;self.checkpoint('68-skure-southern-return')
  if stage==3:
   self.walk([(43,70),(43,71)],'Original Skure entrance');assert self.map()==19
   self.walk([(19,16),(20,16)],'Skure underground passage');self.drain((17,));assert self.dungeon_state()[:3]==(40,0x23,2)
   self.dungeon_multi_walk((40,0x6b,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Skure underground source exit');self.tick(80);assert self.map()==21
   task['skure_wand']=stage=4;self.checkpoint('69-skure-town')
  self.shop([(97,19),(98,19)],0,'Buy original Wand1200');assert 4 in self.items()
  self.report['milestones'].append('Original southern Dezoris return caves and Skure underground, actual Wand4 purchase1200');self.checkpoint('70-wand-purchased')
 def dr_mad(self):
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('dr_mad',0)
  if stage==0:
   assert self.map()==21 and 4 in self.items();self.hospital([(84,19),(85,19)])
   self.walk([(97,31),(98,31)],'Skure church records original Fly return');self.answer(False);self.drain()
   self.walk([(95,15),(96,15)],'Leave Skure underground for Hapsby');self.drain((17,));self.dungeon_multi_walk((40,0x23,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Skure outer exit');self.tick(80);assert self.map()==19
   self.ship(0);assert self.map()==7;self.trigger(170,'Gothic bridge eastbound');self.drain();self.hospital([(43,26),(44,26)])
   task['dr_mad']=stage=1;self.checkpoint('71-gothic-wand-return')
  if stage==1:
   self.walk([(47,23)],'Gothic east exit for Dr Mad');assert self.map()==0
   self.walk([(24,48),(25,48),(24,49),(25,49)],'Original lava route to Bortevo');assert self.map()==11
   self.walk([(64,58),(64,59)],'Bortevo north passage departure');self.walk([(26,46)],'Bortevo north cave');self.drain((17,));self.dungeon_multi_walk((22,0x21,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Abion-side exit');self.tick(80)
   self.walk([(14,14),(15,14),(14,15),(15,15)],'Abion for source Dr Mad battle');assert self.map()==10;self.hospital([(25,66),(26,66)]);task['dr_mad']=stage=2;self.checkpoint('72-dr-mad-ready')
  if stage==2:
   try:self.route([(30,58),(31,58)])
   except ValueError:
    self.walk([(18,60),(19,60)],'Original Abion tunnel to laboratory island');self.drain((17,));assert self.dungeon_state()[:3]==(2,0x12,1)
    self.dungeon_multi_walk((2,0xde,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Abion laboratory island exit');self.tick(80)
   self.walk([(30,58),(31,58)],'Original Dr Mad laboratory');self.answer(False);self.drain((17,));assert 56 in self.items()and self.byte('game_events',24)==255
   task['dr_mad']=stage=3;self.checkpoint('73-dr-mad-laconia-pot')
  if self.byte('game_dungeon',264):self.use(38);self.drain((1,))
  assert self.map()==10;self.walk([(32,60),(33,60)],'Original Abion tunnel back to town');self.drain((17,));self.dungeon_multi_walk((2,0x12,3));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Abion town tunnel exit');self.tick(80);self.hospital([(25,66),(26,66)])
  self.report['milestones'].append('Source DrMad22 prompt refused Myau sacrifice, actual battle71 and LaconiaPot56 chestC518');self.checkpoint('74-dr-mad-return')
 def laerma_nuts(self):
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('nuts',0)
  if stage==0:
   assert 56 in self.items()and 47 in self.items();self.field_spell(0,1);assert self.map()==21;self.hospital([(84,19),(85,19)])
   self.walk([(95,15),(96,15)],'Skure underground departure for Laerma tree');self.drain((17,));self.dungeon_multi_walk((40,0x23,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Skure outer exit');self.tick(80)
   self.walk([(32,19)],'Leave Skure for Laerma route');assert self.map()==2
   self.dezoris_passage([(54,89),(55,89)],(47,0xdd,3),(47,0xd2,3),'Original south passage toward Laerma')
   self.dezoris_passage([(30,83),(31,83)],(48,0xed,3),(48,0x87,0),'Original southwest passage toward Laerma')
   task['nuts']=stage=1;self.checkpoint('75-laerma-southwest-region')
  if stage==1:
   self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.walk([(5,4)],'Original Ice Digger approach to Laerma tree');self.drain((2,));assert self.byte('game_events',260)==175
   self.use(47);self.drain((1,2));assert 49 in self.items()and 47 not in self.items()and 56 in self.items()
   if self.state()==2:self.press('b');self.wait(lambda:self.state()==1,'Laerma tree menu return')
   task['nuts']=stage=2;self.report['milestones'].append('Original IceDigger Laerma tree route, actual EclipseTorch47 consumed with LaconiaPot56 to receive Nuts49');self.checkpoint('76-laerma-nuts')
 def aukba_from_west(self):
  assert self.map()==2
  if not self.byte('game_vehicle'):self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
  self.dezoris_passage([(44,47),(45,47)],(49,0xe2,1),(49,0x1c,1),'Original westward region return to Aukba')
  self.walk([(72,42),(73,42),(72,43),(73,43)],'Aukba settlement');self.walk([(56,18),(57,18)],'Aukba underground return');self.drain((17,))
  self.dungeon_multi_walk((40,0x87,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Aukba underground exit');self.tick(80);self.aukba()
 def aero_prism(self):
  self.mp_reserve=8;task=self.report.setdefault('campaign_tasks',{});stage=task.get('prism',0)
  if stage==0:
   assert 49 in self.items()and self.map()==2
   self.dezoris_passage([(16,67),(17,67)],(50,0xdb,0),(50,0x59,0),'Laerma region to original western passage')
   self.aukba_from_west();task['prism']=stage=1;self.checkpoint('77-prism-prepared-aukba')
  if stage==1:
   self.leave_aukba();self.use(35);self.drain((1,));assert self.byte('game_vehicle')==12
   self.walk([(70,83),(71,83)],'Original Ice Digger path to Titan cave');self.drain((17,));assert self.dungeon_state()[:3]==(58,0xdd,0)
   task['prism']=stage=2;self.checkpoint('78-titan-cave')
  if stage==2:
   self.dungeon_multi_walk((58,0x7b,3));task['prism']=stage=3;self.checkpoint('79-titan-ready')
  if stage==3:
   self.force_fight.add(66);self.dungeon_multi_walk((58,0x7a,3));assert 48 in self.items()and self.byte('game_events',self.event_objects+216)==255
   task['prism']=stage=4;self.checkpoint('80-aero-prism-earned')
  self.use(38);self.drain((1,));assert self.byte('game_rpg',2)>=8 and self.byte('game_rpg')&1
  self.field_spell(0,1);assert self.map()in(21,22)
  self.mp_reserve=0
  if self.map()==22:self.aukba()
  else:
   for c in range(4):
    if not self.byte('game_rpg',c*16)&1:
     self.walk([(97,31),(98,31)],'Skure church recovery after Titan');self.answer(True);self.drain((11,))
     while self.byte('party_choice')!=c:self.press('down')
     self.press('a');self.answer(True);self.drain((5,));self.answer(False);self.drain();assert self.byte('game_rpg',c*16)&1
   self.hospital([(84,19),(85,19)])
  self.report['milestones'].append('Original IceDigger Titan66 cave, actual fixed battle and AeroPrism48 chestC6D8');self.checkpoint('81-aero-prism-recovered')
 def skure_recover(self):
  assert self.map()==21
  for c in range(4):
   if not self.byte('game_rpg',c*16)&1:
    self.walk([(97,31),(98,31)],'Skure church actual revival');self.answer(True);self.drain((11,))
    while self.byte('party_choice')!=c:self.press('down')
    self.press('a');self.answer(True);self.drain((5,));self.answer(False);self.drain();assert self.byte('game_rpg',c*16)&1
  self.hospital([(84,19),(85,19)])
 def endgame_gear(self,max_battles=100):
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('endgame_gear',0);self.mp_reserve=8
  if stage==0:
   assert self.map()==21 and self.word('game_rpg',90)>=3300
   self.shop([(97,19),(98,19)],2,'Buy original Myau Gloves3300');assert 29 in self.items();self.equip(29,1);assert self.byte('game_rpg',28)==29
   task['endgame_gear']=stage=1;self.checkpoint('82-myau-gloves')
  initial=len(self.report['battles'])
  while stage==1 and self.word('game_rpg',90)<4600:
   self.skure_recover();self.checkpoint('laser-gun-funds-skure')
   self.walk([(95,15),(96,15)],'Skure cave for earned Laser Gun funds');self.drain((17,));assert self.dungeon_state()[:3]==(40,0x6b,2)
   self.dungeon_multi_walk((40,0x7b,0));before=len(self.report['battles'])
   for i in range(3000):
    if any(not self.byte('game_rpg',c*16)&1 for c in range(4)):break
    if len(self.report['battles'])-initial>=max_battles:raise RuntimeError('Equipment battle budget reached; exact native state retained')
    if len(self.report['battles'])-before>=10 or self.word('game_rpg',90)>=4800:break
    if self.dungeon_state()[1]!=0x7b:self.dungeon_multi_walk((40,0x7b,0))
    self.dungeon_step('left'if self.dungeon_state()[2]==0 else'right');assert self.state()==17
   else:raise AssertionError('No original Skure cave encounter during turns')
   self.use(38);self.drain((1,));assert self.map()==21;self.skure_recover()
  if stage==1:
   self.checkpoint('83-laser-gun-funds-earned');self.shop([(97,19),(98,19)],1,'Buy original Laser Gun4120');assert 13 in self.items();self.equip(13,2);assert self.byte('game_rpg',42)==13
   task['endgame_gear']=stage=2;self.report['milestones'].append('Earned original3300Gloves29 for Myau and4120LaserGun13 for Odin, actual shops/equipment');self.checkpoint('84-laser-gun-equipped')
 def hover_to(self,goals,name):
  assert self.state()==1
  if not self.byte('game_vehicle'):
   try:self.route(goals)
   except ValueError:pass
   else:return self.walk(goals,name+' final land route')
   grid,flags=self.mapdata();plan=plan_hover(grid,flags,self.cell(),goals,self.map(),self.items());self.report['hover_route']=plan;self.record('original_hover_plan',name=name,plan=plan)
   self.walk([tuple(plan['shore'])],name+' shore approach',exact=True);self.use(34);self.drain((1,));assert self.byte('game_vehicle')==8 and self.cell()==tuple(plan['board'])
  plan=self.report['hover_route'];self.walk([tuple(plan['sea_goal'])],name+' original Hovercraft crossing',exact=True)
  grid,flags=self.mapdata();landing=use_hover(grid,flags,self.cell(),self.byte('facing'),True);assert landing
  self.use(34);self.drain((1,));assert not self.byte('game_vehicle')and self.cell()==landing
  self.record('original_hover_disembark',name=name,landing=landing);return self.walk(goals,name+' final land route')
 def heal_character(self,caster,target):
  assert self.byte('game_rpg',caster*16+2)>=6 and self.byte('game_rpg',caster*16)&1 and self.byte('game_rpg',target*16)&1
  self.press('start')
  while self.byte('menu_choice')!=7:self.press('down')
  self.press('a');assert self.state()==11
  while self.byte('party_choice')!=caster:self.press('down')
  self.press('a');assert self.state()==19;self.press('a');assert self.state()==11
  while self.byte('party_choice')!=target:self.press('down')
  self.press('a');self.drain((1,2,17))
  if self.state()==2:self.press('b');self.wait(lambda:self.state()in(1,17),'Healing menu return')
 def tarzimal(self):
  self.mp_reserve=8;task=self.report.setdefault('campaign_tasks',{});stage=task.get('tarzimal',0)
  if stage==0:
   assert self.map()==21;self.skure_recover();self.walk([(95,15),(96,15)],'Skure departure for Noah teacher');self.drain((17,));self.dungeon_multi_walk((40,0x23,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Skure outer exit');self.tick(80)
   self.ship(1);assert self.map()==15;self.hospital([(75,23),(76,23)])
   self.walk([(67,15),(68,15)],'Uzo church records source Fly return');self.answer(False);self.drain();task['tarzimal']=stage=1;self.checkpoint('85-uzo-tarzimal-prepared')
  if stage==1:
   if self.map()==15:self.walk([(96,23)],'Uzo departure for original Tarzimal island')
   self.hover_to([(42,71),(43,71)],'Tarzimal original island');self.drain((17,));assert self.dungeon_state()[:3]==(36,0xd9,0)
   task['tarzimal']=stage=2;self.checkpoint('86-tarzimal-cave')
  if stage==2:
   self.dungeon_multi_walk((34,0x26,3))
   while self.byte('game_rpg',48)&1 and self.byte('game_rpg',16)&1 and self.byte('game_rpg',49)<self.byte('game_rpg',54)and self.byte('game_rpg',18)>=6:self.heal_character(1,3)
   task['tarzimal']=stage=3;self.checkpoint('87-tarzimal-noah-ready')
  if stage==3:
   self.dungeon_multi_walk((34,0x25,3));self.drain((17,));assert 24 in self.items(),'Tarzimal source duel unsuccessful; native HP restoration retained'
   self.equip(24,3);assert self.byte('game_rpg',59)==24;task['tarzimal']=stage=4;self.checkpoint('88-noah-frade-mantle')
  self.use(38);self.drain((1,));self.field_spell(0,1);assert self.map()==15;self.hospital([(75,23),(76,23)])
  self.report['milestones'].append('Original Hovercraft boarding/sea/disembark to Tarzimal island,139-command cave and Noah-only duel, FradeMantle24 equipped');self.checkpoint('89-tarzimal-return')
 def gas_shield(self):
  self.mp_reserve=8;task=self.report.setdefault('campaign_tasks',{});stage=task.get('gas_shield',0)
  if stage==0:
   assert self.map()==15;self.discard_surplus();self.ship(0);assert self.map()==7
   self.trigger(170,'Gothic bridge for original Drasgow route');self.drain();self.walk([(47,23)],'Gothic east exit for Hovercraft');assert self.map()==0
   self.hover_to([(118,77),(119,77),(118,78),(119,78)],'Drasgow original island');assert self.map()==12
   task['gas_shield']=stage=1;self.checkpoint('90-drasgow-island')
  if stage==1:
   self.walk([(34,27)],'Original Drasgow warehouse');self.drain((17,));assert self.dungeon_state()[:3]==(21,0xd1,0)
   self.dungeon_multi_walk((21,0x2e,2));self.dungeon_step('a');self.dungeon_step('up');self.answer(True);self.drain((17,));assert 59 in self.items()
   task['gas_shield']=stage=2;self.checkpoint('91-gas-shield-purchased')
  self.use(38);self.drain((1,));self.field_spell(0,1);assert self.map()==15;self.hospital([(75,23),(76,23)])
  self.report['milestones'].append('Original Hovercraft route to Drasgow, warehouse event146 and1000Meseta GasShield59 purchase');self.checkpoint('92-gas-shield-uzo')
 def mirror_shield(self):
  self.mp_reserve=8;task=self.report.setdefault('campaign_tasks',{});stage=task.get('mirror_shield',0)
  if stage==0:
   assert self.map()==15 and 59 in self.items();self.walk([(96,23)],'Uzo exit for original Sopia route')
   self.hover_to([(39,29),(40,29),(39,30),(40,30)],'Sopia with original Gas Shield');assert self.map()==18
   self.trigger(116,'Original Sopia Mirror Shield information');self.answer(True);self.drain();assert self.byte('game_events',9)==1
   task['mirror_shield']=stage=1;self.checkpoint('93-mirror-shield-information')
  if stage==1:
   self.walk([(120,59)],'Leave Sopia for original Mirror Shield search');assert self.map()==1
   self.hover_to([(72,36)],'Original Mirror Shield search location');assert self.cell()==(72,36)
   self.search();assert 31 in self.items();self.equip(31,2);assert self.byte('game_rpg',44)==31
   task['mirror_shield']=stage=2;self.checkpoint('94-odin-mirror-shield')
  self.field_spell(0,1);assert self.map()==15;self.hospital([(75,23),(76,23)])
  self.report['milestones'].append('Original Sopia400Meseta informationC509, protected gas traversal, exact Motavia72,36 SEARCH and OdinMirrorShield31');self.checkpoint('95-mirror-shield-uzo')
 def food_heal(self,target):
  before=self.byte('game_rpg',target*16+1);count=self.items().count(37);self.use(37);self.drain((11,))
  while self.byte('party_choice')!=target:self.press('down')
  self.press('a');self.drain((1,2,17))
  if self.state()==2:self.press('b');self.wait(lambda:self.state()in(1,17),'Food menu return')
  assert self.items().count(37)==count-1 and self.byte('game_rpg',target*16+1)==min(before+40,self.byte('game_rpg',target*16+6))
  self.record('field_food',target=target,before=before,after=self.byte('game_rpg',target*16+1),item=37)
 def crystal(self):
  self.mp_reserve=8;self.myau_reserve=30;self.noah_reserve=32
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('crystal',0)
  if stage==0:
   assert self.map()==15;self.ship(0);self.trigger(170,'Gothic bridge for Baya route');self.drain()
   self.walk([(44,15),(45,15)],'Original Gothic tunnel return to Palma spaceport');self.drain((17,));self.dungeon_multi_walk((0,0xde,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Palma spaceport tunnel exit');self.tick(80);assert self.map()==5
   self.trigger(27,'Original Roadpass Camineet exit');self.drain();assert self.map()==4;self.rest()
   self.walk([(107,30),(108,30)],'Camineet church records original Fly return');self.answer(False);self.drain()
   while self.items().count(37)<5:self.shop([(97,25),(98,25)],1,'Buy original Burger40 for Baya supplies')
   task['crystal']=stage=1;self.checkpoint('96-baya-camineet-prepared')
  if stage==1:
   self.walk([(109,23)],'Leave Camineet for Baya prison');self.walk([(104,32),(105,32)],'Original Baya prison south entrance');self.drain((17,));assert self.dungeon_state()[:3]==(20,0xcb,0)
   task['crystal']=stage=2;self.checkpoint('97-baya-prison')
  if stage==2:
   self.dungeon_multi_walk((20,0x21,0),allow_objects=True);self.dungeon_step('a');self.dungeon_step('up');self.wait(lambda:self.state()==1,'Baya prison north door');self.tick(80)
   task['crystal']=stage=3;self.checkpoint('98-baya-prison-crossed')
  if stage==3:
   self.walk([(121,13)],'Original Baya connecting cave');self.drain((17,));self.dungeon_multi_walk((0,0x15,3));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Baya cave north exit');self.tick(80)
   self.walk([(104,18),(105,18),(104,19),(105,19)],'Original Baya Malay Tower entrance');self.drain((17,));assert self.dungeon_state()[:3]==(11,0xb9,0)
   task['crystal']=stage=4;self.checkpoint('99-baya-tower')
  if stage==4:
   self.dungeon_multi_walk((15,0xc4,1),allow_objects=True);self.use(45);self.drain((17,));self.dungeon_step('up')
   for yes in(True,True,True,False,False):self.answer(yes)
   self.drain((17,));assert 60 in self.items();task['crystal']=stage=5;self.report['milestones'].append('Original Baya prison Robotcop refused/fought, native NoahOpen, connecting cave/tower, source YYYNN Crystal sage answers');self.checkpoint('100-crystal-earned')
 def laconia_sword(self):
  self.mp_reserve=8;task=self.report.setdefault('campaign_tasks',{});stage=task.get('laconia_sword',0)
  if stage==0:
   assert 60 in self.items()
   if self.byte('game_dungeon',264):self.use(38);self.drain((1,));self.field_spell(0,1);assert self.map()==4
   if self.map()==4:self.rest();self.trigger(11,'Camineet Roadpass for source sword expedition');self.drain();assert self.map()==5
   if self.map()==5:
    self.walk([(18,32)],'Original Noah-enabled passage to Gothic');self.drain((17,));self.dungeon_multi_walk((0,0x2e,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Gothic passage exit');self.tick(80)
   if self.map()==7:self.walk([(47,23)],'Gothic exit for original sword cave')
   assert self.map()==0
   self.hover_to([(6,41),(7,41),(6,42),(7,42)],'Original Laconia Sword island');self.drain((17,));assert self.dungeon_state()[:3]==(23,0xd7,0)
   task['laconia_sword']=stage=1;self.checkpoint('101-laconia-sword-cave')
  if stage==1:
   self.dungeon_multi_walk((27,0x57,1));task['laconia_sword']=stage=2;self.checkpoint('102-red-dragon-ready')
  if stage==2:
   self.force_fight.add(60);self.dungeon_multi_walk((27,0x59,1));assert 14 in self.items()and self.byte('game_events',self.event_objects+203)==255
   self.equip(14,0);assert self.byte('game_rpg',10)==14;task['laconia_sword']=stage=3;self.checkpoint('103-laconia-sword-earned')
  if self.byte('game_dungeon',264):self.use(38);self.drain((1,))
  if self.map()!=4:
   if self.byte('game_rpg')&1 and self.byte('game_rpg',2)>=8:
    self.field_spell(0,1);assert self.map()==4
   else:
    assert self.map()==0
    self.record('source_return_without_fly',phase='laconia_sword',reason='Actual remaining MP cannot pay original Fly8. Return by original shore boarding, Hovercraft sea crossing and Camineet entrance.')
    self.avoid_combat=True
    self.hover_to([(82,44),(83,44),(82,45),(83,45)],'Earned Laconia Sword return to Camineet without Fly')
  assert self.map()==4;self.rest()
  self.report['milestones'].append('Original Palma23/D7→27/5A RedDragon60 dungeon, actual fixed LaconiaSword14 rewardC6CB and Alis equipment');self.checkpoint('104-laconia-sword-camineet')
 def silver_fang(self):
  self.mp_reserve=8;task=self.report.setdefault('campaign_tasks',{});stage=task.get('silver_fang',0)
  if stage==0:
   assert self.map()==4;self.discard_surplus();self.rest();self.walk([(109,23)],'Camineet departure for original Loar armory')
   self.hover_to([(67,28),(68,28),(67,29),(68,29)],'Loar original Hovercraft route');assert self.map()==9
   task['silver_fang']=stage=1;self.checkpoint('105-loar-armory')
  if stage==1:
   self.shop([(99,18),(100,18)],2,'Buy original Silver Fang1620');assert 10 in self.items();self.equip(10,1);assert self.byte('game_rpg',26)==10
   task['silver_fang']=stage=2;self.checkpoint('106-myau-silver-fang')
  self.field_spell(0,1);assert self.map()==4;self.rest()
  while self.items().count(37)<8:self.shop([(97,25),(98,25)],1,'Buy original Burger40 for final expedition')
  self.report['milestones'].append('Original Hovercraft route to Loar,1620SilverFang10 purchase/equip, original final expedition food supplies');self.checkpoint('107-final-expedition-prepared')
 def final_climb(self):
  self.avoid_combat=True;self.mp_reserve=8;self.myau_reserve=24;self.noah_reserve=40
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('final_climb',0)
  if stage==0:
   assert self.map()==4 and 60 in self.items();self.walk([(109,23)],'Final departure from Camineet');self.walk([(104,32),(105,32)],'Original Baya prison return');self.drain((17,));assert self.dungeon_state()[:3]==(20,0xcb,0)
   self.dungeon_multi_walk((20,0x21,0),allow_objects=True);self.dungeon_step('a');self.dungeon_step('up');self.wait(lambda:self.state()==1,'Baya north door');self.tick(80)
   self.walk([(121,13)],'Original Baya connecting cave return');self.drain((17,));self.dungeon_multi_walk((0,0x15,3));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Baya cave north exit');self.tick(80)
   self.walk([(104,18),(105,18),(104,19),(105,19)],'Final Baya tower ascent');self.drain((17,));assert self.dungeon_state()[:3]==(11,0xb9,0)
   task['final_climb']=stage=1;self.checkpoint('108-final-baya-tower')
  if stage==1:
   if 62 not in self.items():self.dungeon_multi_walk((12,0x21,0),allow_objects=True);self.drain((17,))
   assert 62 in self.items()and self.byte('game_events',self.event_objects+49)==255
   task['final_climb']=stage=2;self.checkpoint('109-miracle-key-earned')
  if stage==2:
   self.dungeon_multi_walk((15,0x1c,1),allow_objects=True)
   # Actual consumables preserve the spell reserves needed for the source bosses.
   for c in range(4):
    while self.byte('game_rpg',c*16)&1 and self.byte('game_rpg',c*16+6)-self.byte('game_rpg',c*16+1)>=20 and 37 in self.items():self.food_heal(c)
   for c in range(4):
    while self.byte('game_rpg',c*16)&1 and self.byte('game_rpg',c*16+6)-self.byte('game_rpg',c*16+1)>=25:
     caster=1 if self.byte('game_rpg',16)&1 and self.byte('game_rpg',18)>=16 else 3 if self.byte('game_rpg',48)&1 and self.byte('game_rpg',50)>=42 else None
     if caster is None:break
     self.heal_character(caster,c)
   task['final_climb']=stage=3;self.checkpoint('110-baya-summit-prepared')
  if stage==3:
   if self.state()==17:self.dungeon_step('up');self.drain((2,))
   self.use(48);self.drain((2,));assert self.byte('game_events',262)==255
   self.use(49);self.drain((1,));assert self.map()==23 and self.pos()==(504,528)
   task['final_climb']=stage=4;self.report['milestones'].append('Original MiracleKey62 chestC631, Baya summit Prism/Nuts, real GoldenDragon70 victory and flying castle arrival');self.checkpoint('111-flying-castle-earned')
 def castle_shadow(self):
  self.avoid_combat=True;self.mp_reserve=8;self.myau_reserve=24;self.noah_reserve=40
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('castle',0)
  if stage==0:
   assert self.map()==23;self.walk([(31,17),(32,17)],'Original flying castle entrance');self.drain((17,));assert self.dungeon_state()[:3]==(57,0xd6,0)
   task['castle']=stage=1;self.checkpoint('113-flying-castle-dungeon')
  if stage==1:
   self.dungeon_multi_walk((53,0x92,2));task['castle']=stage=2;self.checkpoint('114-shadow-approach')
  if stage==2:
   self.dungeon_multi_walk((53,0xb2,2));self.drain((17,));assert self.byte('game_events',23)==255
   task['castle']=stage=3;self.checkpoint('115-shadow-defeated')
 def lassic(self):
  self.avoid_combat=True;self.mp_reserve=8;self.myau_reserve=18;self.noah_reserve=36
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('castle',0)
  if stage==3:
   self.dungeon_multi_walk((57,0xcc,3))
   for c in range(4):
    while self.byte('game_rpg',c*16)&1 and self.byte('game_rpg',c*16+6)-self.byte('game_rpg',c*16+1)>=20 and 37 in self.items():self.food_heal(c)
    while self.byte('game_rpg',c*16)&1 and self.byte('game_rpg',16)&1 and self.byte('game_rpg',c*16+6)-self.byte('game_rpg',c*16+1)>=40 and self.byte('game_rpg',18)>=6:self.heal_character(1,c)
   task['castle']=stage=4;self.checkpoint('116-lassic-approach')
  if stage==4:
   self.use(62);self.drain((17,));self.dungeon_step('up');self.answer(True);self.drain((17,));assert self.byte('game_events',22)==1
   task['castle']=stage=5;self.report['milestones'].append('Original Shadow62 and Lassic72 battles won, source C517FF/C5161 and Crystal protection');self.checkpoint('117-lassic-defeated')
 def final_governor_prepare(self):
  self.avoid_combat=True;self.mp_reserve=0;self.myau_reserve=24;self.noah_reserve=36
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('final_governor',0)
  if stage==0:
   assert self.byte('game_events',22)==1
   if self.byte('game_dungeon',264):self.use(38);self.drain((1,))
   assert self.map()==23;self.use(49);self.drain((1,));assert self.map()==0 and self.pos()==(1224,784)
   self.rest();task['final_governor']=stage=1;self.checkpoint('118-lassic-return-camineet')
  if stage==1:
   if self.map()==4:
    for c in range(4):
     if not self.byte('game_rpg',c*16)&1:self.revive(c)
    self.discard_surplus()
    while self.items().count(37)<8:self.shop([(97,25),(98,25)],1,'Buy original food for governor final maze')
    self.western_passage()
   if self.map()==7:self.trigger(170,'Gothic bridge for final Motavia trip');self.drain();self.ship(1)
   if self.map()==15:self.walk([(96,23)],'Uzo departure for final Paseo return')
   if self.map()==1:self.hover_to([(100,32)],'Original Hovercraft route to Paseo')
   assert self.map()==14
   task['final_governor']=stage=2;self.checkpoint('119-paseo-after-lassic')
  if stage==2:
   self.walk([(33,26),(34,26)],'Original palace after Lassic');self.drain((17,));self.dungeon_multi_walk((33,0x61,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Upper palace return');self.tick(80)
   self.trigger(57,'Original governor guest-room rest before final maze');self.drain();assert all(p[0]&1 and p[1]==p[6]and p[2]==p[7]for p in self.party())
   task['final_governor']=stage=3;self.report['milestones'].append('Native Flute and Nuts return after Lassic, rest/resupply, Hapsby Motavia route and governor guest-room rest');self.checkpoint('120-final-governor-ready')
 def final_maze(self):
  self.avoid_combat=True;self.mp_reserve=0;self.myau_reserve=36;self.noah_reserve=54
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('final_maze',0)
  if stage==0:
   assert self.map()==14 and self.byte('game_events',22)==1
   self.trigger(55,'Original governor after Lassic');self.drain((17,));assert self.dungeon_state()[:3]==(33,0xe6,0),'Governor must apply original661C floor decrement, never bypass it'
   task['final_maze']=stage=1;self.checkpoint('121-original-governor-fall')
  if stage==1:
   self.dungeon_multi_walk((31,0xde,0),allow_falls=True)
   for c in range(4):
    while self.byte('game_rpg',c*16)&1 and self.byte('game_rpg',c*16+6)-self.byte('game_rpg',c*16+1)>=20 and 37 in self.items():self.food_heal(c)
   task['final_maze']=stage=2;self.checkpoint('122-dark-falz-approach')
  if stage==2:
   self.use(62);self.drain((17,));self.dungeon_step('up');self.drain((5,));assert self.byte('battle_view_result')==1
   task['final_maze']=stage=3;self.record('dark_falz_victory',state=self.snapshot())
   capture(self.e,self.out/'dark-falz-victory.png')
  if stage==3:
   self.answer(True);self.drain((0,),limit=60000)
   self.wait(lambda:bool(self.e.memory[0xff40]&0x80),'Ending title LCD enabled',12000)
   frame=self.word('frame_counter');self.wait(lambda:self.word('frame_counter')!=frame,'Ending title native display frame',12000);self.tick(3)
   assert self.state()==0,'Ending must remain at title after display settles'
   self.record('ending_returned_to_title',state=self.snapshot());capture(self.e,self.out/'ending-returned-to-title.png')
   self.report['campaign_complete']=True;self.report['completion_kind']='Documented earned-save continuation' if 'save_continuation'in self.report else'Controller playthrough from New Game'
   self.report['milestones'].append('Original governor fall and two mandatory pitfalls, DarkFalz victory, original ending and credits returned to title')
   self.flush()
 def paseo_lower(self):
  assert self.map()==14 and self.state()==1
  self.walk([(29,19),(30,19)],'Original upper-palace stairs to Paseo');self.drain((17,));self.dungeon_multi_walk((33,0xd4,2));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Original lower Paseo exit');self.tick(80)
 def paseo_upper(self):
  assert self.map()==14 and self.state()==1
  self.walk([(33,26),(34,26)],'Original Paseo palace entrance');self.drain((17,));self.dungeon_multi_walk((33,0x61,0));self.dungeon_step('up');self.wait(lambda:self.state()==1,'Original upper palace exit');self.tick(80)
 def final_training(self,target=16000,max_battles=200):
  """Earn the source15000DiamondArmor in the final maze, with actual rest."""
  self.avoid_combat=False;self.mp_reserve=0;self.myau_reserve=6;self.noah_reserve=0
  task=self.report.setdefault('campaign_tasks',{});stage=task.get('final_training',0)
  if stage==0:
   if self.byte('game_dungeon',264):self.use(38);self.drain((1,))
   assert self.map()==14
   initial=len(self.report['battles'])
   while self.word('game_rpg',90)<target or any(not p[0]&1 for p in self.party()):
    if len(self.report['battles'])-initial>=max_battles:raise RuntimeError('Original final-maze training battle budget reached; native state retained')
    dead=[c for c in range(4)if not self.byte('game_rpg',c*16)&1]
    if dead:
     self.paseo_lower();self.walk([(25,32),(26,32)],'Original Paseo church after training');self.answer(True);self.drain((11,))
     for i,c in enumerate(dead):
      while self.byte('party_choice')!=c:self.press('down')
      self.press('a');self.answer(True);self.drain((5,));self.answer(i+1<len(dead));self.drain((11,)if i+1<len(dead)else(1,));assert self.byte('game_rpg',c*16)&1
     self.paseo_upper()
    if self.word('game_rpg',90)>=target:break
    self.trigger(57,'Governor guest-room rest for original final-maze training');self.drain();self.checkpoint('final-training-rested')
    self.trigger(55,'Original governor fall for earned Diamond Armor');self.drain((17,));assert self.dungeon_state()[:3]==(33,0xe6,0)
    self.dungeon_multi_walk((32,0x32,0),allow_falls=True);visit=len(self.report['battles'])
    # Source floor33 has encounter chance0. Floor32 has25/256,pool88
    # (Manticore/Giant/RedDragon). Cells22/32 are an ordinary north/south
    # corridor, so actual movement keeps a legal rear escape for the Wand.
    for _ in range(3000):
     if self.word('game_rpg',90)>=target or len(self.report['battles'])-visit>=8 or any(not self.byte('game_rpg',c*16)&1 for c in range(4)):break
     if self.dungeon_state()[:3]not in((32,0x32,0),(32,0x22,0)):self.dungeon_multi_walk((32,0x32,0))
     self.dungeon_step('up'if self.dungeon_state()[1]==0x32 else'down')
    else:raise AssertionError('No source final-maze encounter within3000movements')
    self.use(38);self.drain((1,));assert self.map()==14
   self.trigger(57,'Original guest-room rest after earned armor funds');self.drain();task['final_training']=stage=1;self.checkpoint('125-diamond-armor-funds-earned')
  if stage==1:
   if len(self.items())==24:
    self.record('story_inventory_slot',reason='Use one original Burger to make room for the Diamond Armor purchase');self.food_heal(0)
   assert len(self.items())<24
   self.paseo_lower();self.shop([(25,28),(26,28)],2,'Original Paseo Diamond Armor15000');assert 22 in self.items();self.equip(22,0);assert self.byte('game_rpg',11)==22
   self.paseo_upper();self.trigger(57,'Original guest-room rest with Diamond Armor');self.drain();task['final_training']=stage=2
   task['final_maze']=0;self.report['milestones'].append('Actual final-maze encounters earned original15000Meseta DiamondArmor22; purchased atPaseoshop12 and equippedAlis, with original church/guest-room recovery')
   self.checkpoint('126-diamond-armor-ready')
 def final_recover(self):
  self.continue_game();self.use(38);self.drain((1,));self.field_spell(0,1);assert self.map()==4;self.rest();self.discard_surplus()
  while self.items().count(37)<8:self.shop([(97,25),(98,25)],1,'Resupply after original Golden Dragon defeat')
  self.report.setdefault('campaign_tasks',{})['final_climb']=0;self.checkpoint('112-golden-dragon-continue-resupplied')
 def continue_game(self):
  assert self.state()in(0,8)
  if self.state()==8:self.press('a')
  assert self.state()==0;self.press('start')
  for _ in range(1000):
   if self.state()in(1,17):break
   if self.state()in(25,26):self.press('a')
   elif self.state()==4:self.drain((1,17))
   else:self.tick()
  self.wait(lambda:self.state()in(1,17),'Actual Continue');self.tick(100);self.record('native_continue',restored=self.snapshot());self.report.setdefault('continues',[]).append(self.snapshot())
 def stop(self):self.flush();self.e.stop(save=True);self.log.close()

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);p.add_argument('--output',type=Path,default=ROOT/'build/campaign/attempt01');p.add_argument('--resume',type=Path);p.add_argument('--phase',choices=('newgame','grind','roadpass','myau','return','odin','compass','key-rumor','warehouse','cake-prepare','cake','governor','noah','noah-return','western','luveno','construction','abion','hapsby','uzo','hovercraft','boss-gear','blue-dragon','recover-party','dezoris','torch','aukba','ice-funds','ice-digger','debug-sale','laconia-armor','diamond-shield','skure-wand','dr-mad','laerma-nuts','aero-prism','endgame-gear','tarzimal','gas-shield','mirror-shield','crystal','laconia-sword','silver-fang','final-climb','final-recover','castle-shadow','lassic','final-governor-prepare','final-maze','continue','recover-myau','early'),default='early');p.add_argument('--money',type=int,default=330);p.add_argument('--max-battles',type=int,default=100);a=p.parse_args()
 q=Campaign(a.rom.resolve(),a.output.resolve(),a.resume)
 try:
  if q.state()==15 and q.byte('battle_view_state')==7:q.battle()
  if a.phase in('newgame','early')and not a.resume:q.newgame()
  if a.phase in('grind','early'):q.grind(a.money,a.max_battles)
  if a.phase in('roadpass','early'):q.roadpass()
  if a.phase=='recover-myau':q.continue_game()
  if a.phase in('myau','recover-myau','early'):q.passport_myau()
  if a.phase in('return','early'):q.return_palma()
  if a.phase in('odin','early'):q.odin()
  if a.phase=='compass':q.compass()
  if a.phase=='key-rumor':q.key_rumor()
  if a.phase=='warehouse':q.warehouse()
  if a.phase=='cake-prepare':q.cake_prepare()
  if a.phase=='cake':q.cake()
  if a.phase=='governor':q.governor()
  if a.phase=='noah':q.noah()
  if a.phase=='noah-return':q.noah_return()
  if a.phase=='western':q.western_passage()
  if a.phase=='luveno':q.luveno()
  if a.phase=='construction':q.construction()
  if a.phase=='abion':q.abion()
  if a.phase=='hapsby':q.hapsby()
  if a.phase=='uzo':q.uzo()
  if a.phase=='hovercraft':q.hovercraft()
  if a.phase=='boss-gear':q.boss_gear()
  if a.phase=='blue-dragon':q.blue_dragon()
  if a.phase=='recover-party':q.recover_party()
  if a.phase=='dezoris':q.dezoris()
  if a.phase=='torch':q.torch()
  if a.phase=='aukba':q.aukba()
  if a.phase=='ice-funds':q.ice_funds(a.money,a.max_battles)
  if a.phase=='ice-digger':q.ice_digger()
  if a.phase=='debug-sale':q.debug_sale()
  if a.phase=='laconia-armor':q.laconia_armor()
  if a.phase=='diamond-shield':q.diamond_shield()
  if a.phase=='skure-wand':q.skure_wand()
  if a.phase=='dr-mad':q.dr_mad()
  if a.phase=='laerma-nuts':q.laerma_nuts()
  if a.phase=='aero-prism':q.aero_prism()
  if a.phase=='endgame-gear':q.endgame_gear(a.max_battles)
  if a.phase=='tarzimal':q.tarzimal()
  if a.phase=='gas-shield':q.gas_shield()
  if a.phase=='mirror-shield':q.mirror_shield()
  if a.phase=='crystal':q.crystal()
  if a.phase=='laconia-sword':q.laconia_sword()
  if a.phase=='silver-fang':q.silver_fang()
  if a.phase=='final-climb':q.final_climb()
  if a.phase=='final-recover':q.final_recover()
  if a.phase=='castle-shadow':q.castle_shadow()
  if a.phase=='lassic':q.lassic()
  if a.phase=='final-governor-prepare':q.final_governor_prepare()
  if a.phase=='final-maze':q.final_maze()
  if a.phase=='continue':q.continue_game();q.checkpoint('native-continue')
  q.report['current_status']='Requested phase completed';q.report.pop('failure',None)
 except BaseException as ex:
  q.report['failure']={'type':type(ex).__name__,'message':str(ex),'traceback':traceback.format_exc(),'state':q.snapshot()}
  q.report['current_status']='Stopped at recorded failure'
  q.report.setdefault('failures',[]).append(q.report['failure'])
  with(q.out/'failure.state').open('wb')as f:q.e.save_state(f)
  (q.out/'failure.json').write_text(json.dumps({'rom_sha256':q.report['header']['sha256'],**q.snapshot()},indent=2)+'\n');capture(q.e,q.out/'failure.png');raise
 finally:q.stop()
if __name__=='__main__':main()
