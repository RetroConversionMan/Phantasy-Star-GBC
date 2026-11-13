#!/usr/bin/env python3
"""Real walking, passport purchase, road-pass gate and ship prompts."""
from pathlib import Path
import argparse,json,shutil,tempfile
from pyboy import PyBoy
from verify_rom import finish_continue_menu,finish_new_game_intro,button,capture,cartridge_header,load_symbols,read_word
from verify_integrated_battle import source_route,DIRS
from verify_world_logic import source_group,source_action
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');a=p.parse_args()
 out=ROOT/'build/verification/travel-integration';out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc';shutil.copyfile(a.rom,frozen);shutil.copyfile(a.rom.with_suffix('.noi'),frozen.with_suffix('.noi'))
 s=load_symbols(frozen.with_suffix('.noi'));source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
 report={'header':cartridge_header(frozen),'checks':[],'routes':[],'screenshots':[],'injected_fixtures':['One Road Pass and100 Meseta for an actual Passport purchase; no map, position, event, party-stat or RNG fixtures'],'campaign_complete':False}
 with tempfile.TemporaryDirectory(prefix='ps-travel-ui-')as tmp:
  rom=Path(tmp)/'game.gbc';shutil.copyfile(frozen,rom)
  def boot():
   e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);e.tick(300);return e
  e=boot();r=s['game_rpg']
  def val(n):return e.memory[s[n]]
  def state():return val('screen_state')
  def pos():return read_word(e,s['player_x']),read_word(e,s['player_y'])
  def wait(fn,why,limit=12000):
   for _ in range(limit):
    if fn():return
    e.tick(1)
   raise AssertionError((why,state(),pos(),val('world_map_id'),hex(e.register_file.PC)))
  def completed_frame():
   before=read_word(e,s['frame_counter']);wait(lambda:read_word(e,s['frame_counter'])!=before,'completed frame')
  def press(k):button(e,k,4,40)
  def shot(n):e.tick(4);report['screenshots'].append(capture(e,out/(n+'.png')))
  def walk_event(event):
   m=val('world_map_id');g=source[0xdc1+m];grid,flags,entries=source_group(source,g)
   x,y=pos();cell=((x-8)//16,(y+1536-16)%1536//16)
   def trigger(q):
    a=source_action(source,m,grid,flags,entries,*q)
    return a[0]==12 and a[1]<18 and a[2]==event
   route,goal=source_route(grid,flags,cell,trigger)
   for key in route:
    assert state()==1,(key,state(),pos())
    x,y=pos();dx,dy=DIRS[key];target=((x+16*dx)%2048,(y+16*dy)%1536)
    e.button_press(key)
    try:wait(lambda:(pos()==target and not val('step_remaining'))or state()!=1,'walking '+key)
    finally:e.button_release(key)
    completed_frame()
   wait(lambda:state()in(4,5),'event dialogue or immediate source prompt');completed_frame()
   report['routes'].append({'map':m,'event':event,'from':cell,'trigger':goal,'controller_steps':len(route)})
  def advance_to_travel():
   for _ in range(5000):
    if state()==21:return
    assert state()in(4,5),(state(),pos())
    if state()==4 and 'dialogue_revealing'in s and val('dialogue_revealing'):e.tick(1)
    else:press('a')
   raise AssertionError('travel prompt stalled')
  def complete_travel(map_id,position,skip=False):
   count=0
   while state()==21:
    if skip and count%90==0:press('a')
    else:e.tick(1)
    count+=1
    assert count<18000,(state(),pos())
   wait(lambda:state()==1 and val('world_map_id')==map_id and pos()==position and bool(e.memory[0xff40]&128),'travel destination')
   completed_frame();e.tick(4)
   assert val('game_vehicle')==0 and all(e.memory[0xfe00+i*4]==0 for i in range(6,40))
   return count
  press('start');finish_new_game_intro(e,s);wait(lambda:state()==1,'new game');completed_frame()
  e.memory[r+64]=51;e.memory[r+88]=1;e.memory[r+90]=100
  walk_event(11);shot('road-pass-guard');advance_to_travel();shot('road-departure')
  report['road_ticks']=complete_travel(5,(44*16+8,25*16+16));shot('spaceport-road-arrival')
  report['checks'].append('Actual Camineet guard accepts Road Pass; original road1 plays and arrives at Palma spaceport exit triple')
  walk_event(29)
  for answer in (True,False,False,True):
   for _ in range(3000):
    if state()==5:break
    assert state()==4
    if 'dialogue_revealing'in s and val('dialogue_revealing'):e.tick(1)
    else:press('a')
   assert state()==5
   if not answer:press('down')
   press('a')
  while state()==4:press('a')
  wait(lambda:state()==1,'passport purchase');completed_frame()
  assert e.memory[r+88]==2 and e.memory[r+65]==52 and read_word(e,r+90)==0
  walk_event(26)
  for _ in range(40):
   if state()==1:break
   assert state()in(4,5);press('a')
  completed_frame();assert state()==1
  report['checks'].append('Original Passport application answers and100-Meseta payment grant Passport; spaceport guard admits party through actual dialogue')
  walk_event(179);shot('ship-question');advance_to_travel();shot('ship-departure')
  report['ship_full_ticks']=complete_travel(16,(23*16+8,63*16+16));shot('motavia-arrival')
  report['checks'].append('Original ship81 prompt starts ascent, space transfer and descent; full route reaches Motavia spaceport')
  walk_event(180);advance_to_travel();report['ship_skip_ticks']=complete_travel(5,(23*16+8,19*16+16),True);shot('palma-return')
  report['checks'].append('Original return ship82 accepts action-button skips and preserves its correct Palma destination')
  saved=pos();party=bytes(e.memory[r:r+94]);press('select');wait(lambda:state()==8,'save after travel')
  e.stop(save=True);e=boot();press('start');finish_continue_menu(e,s);wait(lambda:state()==1,'continue after travel');completed_frame()
  assert pos()==saved and val('world_map_id')==5 and bytes(e.memory[r:r+94])==party
  report['checks'].append('Power-cycle Continue restores post-travel map, coordinates, party and Road Pass')
  e.stop(save=False)
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
if __name__=='__main__':main()
