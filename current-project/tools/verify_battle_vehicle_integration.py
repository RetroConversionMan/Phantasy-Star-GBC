#!/usr/bin/env python3
"""Actual world encounter, combat boarding/reboarding, return and battery save."""
from pathlib import Path
import argparse,json,shutil,tempfile
from pyboy import PyBoy
from verify_rom import button,finish_new_game_intro,finish_continue_menu,is_text_revealing,load_symbols,read_word,cartridge_header,capture
from verify_integrated_battle import source_route,DIRS
from verify_vehicles import source_use
from verify_world_logic import source_group
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);a=p.parse_args()
 out=ROOT/'build/verification/battle-vehicle-integration';out.mkdir(parents=True,exist_ok=True);frozen=out/'tested.gbc';shutil.copyfile(a.rom,frozen);shutil.copyfile(a.rom.with_suffix('.noi'),frozen.with_suffix('.noi'))
 s=load_symbols(frozen.with_suffix('.noi'));source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();groups={n:source_group(source,n)for n in(0,4)}
 report={'header':cartridge_header(frozen),'checks':[],'screenshots':[],'boarding':[],'injected_fixtures':['Alis level30 with200HP/maxHP/defense and40attack plus one Landrover; map, position, flags, RNG, encounter and outcomes are never injected'],'campaign_complete':False}
 with tempfile.TemporaryDirectory(prefix='ps-battle-vehicle-')as tmp:
  rom=Path(tmp)/'game.gbc';shutil.copyfile(frozen,rom)
  def boot():
   e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);e.tick(300);return e
  e=boot();r=s['game_rpg']
  def val(n):return e.memory[s[n]]
  def state():return val('screen_state')
  def view():return val('battle_view_state')
  def pos():return read_word(e,s['player_x']),read_word(e,s['player_y'])
  def wait(fn,why,limit=8000):
   for _ in range(limit):
    if fn():return
    e.tick(1)
   raise AssertionError((why,state(),view(),pos(),val('game_vehicle'),hex(e.register_file.PC)))
  def press(k):e.button_release(k);e.tick(3);button(e,k,3,40)
  def complete_frame():
   before=read_word(e,s['frame_counter']);wait(lambda:read_word(e,s['frame_counter'])!=before,'completed frame')
  def step(k):
   x,y=pos();dx,dy=DIRS[k];end=((x+dx*16)%2048,(y+dy*16)%1536);m=val('world_map_id');e.button_press(k)
   try:wait(lambda:(pos()==end and not val('step_remaining'))or state()!=1 or val('world_map_id')!=m,'step')
   finally:e.button_release(k)
   complete_frame()
  def drain_command(texts):
   for _ in range(10000):
    if state()!=15:return
    if view()==1:return
    if view()==5:
     text=read_word(e,s['battle_view_dialogue_id'])
     if text and(not texts or texts[-1]!=text):texts.append(text)
     if is_text_revealing(e,s):e.tick(1)
     else:
      e.button_release('a');complete_frame();e.tick(1)
      if state()==15 and view()==5 and not is_text_revealing(e,s):press('a')
    elif view()==6:press('a')
    else:e.tick(1)
   raise AssertionError('Battle did not reach a command')
  def shot(name):e.tick(3);report['screenshots'].append(capture(e,out/(name+'.png')))
  try:
   press('start');finish_new_game_intro(e,s);wait(lambda:state()==1,'new game')
   for offset,value in((1,200),(5,30),(6,200),(8,40),(9,200),(64,33),(88,1)):e.memory[r+offset]=value
   grid,flags,_=groups[4];route,_=source_route(grid,flags,(105,18),lambda q:q==(109,23))
   for k in route:step(k)
   wait(lambda:state()==1 and val('world_map_id')==0,'Palma');complete_frame()
   grid,flags,_=groups[0];x,y=pos();route,_=source_route(grid,flags,((x-8)//16,(y-16)//16),lambda q:grid[q[1]*128+q[0]]==1)
   for k in route:
    if state()==15:break
    step(k)
   steps=0
   while state()!=15 and steps<500:
    x,y=pos();cell=((x-8)//16,(y-16)//16);choices=[]
    for k,(dx,dy)in DIRS.items():
     q=((cell[0]+dx)%128,(cell[1]+dy)%96)
     if grid[q[1]*128+q[0]]==1 and not flags[1]&13:choices.append(k)
    assert choices;step(choices[steps%len(choices)]);steps+=1
   wait(lambda:state()==15,'natural encounter');drain_command([]);assert view()==1 and val('game_vehicle')==0
   for n in range(2):
    before=pos();mode=val('game_vehicle');expected=source_use(source,grid,flags,0,*before,val('facing'),val('battle_scene_type'),4,0)
    assert expected[0]==1,('Fixture reached geometry where boarding fails',before,expected)
    while val('battle_view_choice')!=2:press('right')
    press('a');wait(lambda:view()==3,'item list');press('a');texts=[];drain_command(texts)
    assert state()==15 and view()==1 and val('game_vehicle')==4 and pos()==expected[1:3]
    assert e.memory[r+88]==1 and e.memory[r+64]==33
    assert 0xb2ac in texts and 0xb305 in texts,(n,texts)
    report['boarding'].append({'previous_mode':mode,'from':before,'source_expected':expected,'dialogues':[hex(x)for x in texts]});shot('boarded'if not n else'reboarded')
   saved_pos=pos()
   for _ in range(20):
    if state()!=15:break
    if view()==1:
     while val('battle_view_choice'):press('left')
     press('a')
    drain_command([])
   wait(lambda:state()==1,'victory return');complete_frame();assert val('game_vehicle')==4 and pos()==saved_pos and val('battle_view_result')==1
   shot('vehicle-after-battle');report['checks'].append('Two actual combat Landrover selections board/reboard using original geometry, preserve item, and continue combat; neither acts as field-menu dismount')
   party=bytes(e.memory[r:r+94]);press('select');wait(lambda:state()==8,'save');e.stop(save=True);e=boot();press('start');finish_continue_menu(e,s);wait(lambda:state()==1,'continue');complete_frame()
   assert val('game_vehicle')==4 and pos()==saved_pos and bytes(e.memory[r:r+94])==party
   shot('continued-vehicle');report['checks'].append('Victory restores vehicle art/world at the boarding coordinates; power-cycle Continue preserves mode, location and full party/RNG/inventory state')
   report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
  finally:e.stop(False)
if __name__=='__main__':main()
