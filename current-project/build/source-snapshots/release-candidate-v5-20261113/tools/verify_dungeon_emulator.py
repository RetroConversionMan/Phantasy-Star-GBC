#!/usr/bin/env python3
"""Controller-driven dungeon integration; combat/Flash fixtures are explicit."""
from pathlib import Path
import argparse,json,shutil,tempfile
from pyboy import PyBoy
from verify_rom import finish_continue_menu,finish_new_game_intro,button,capture,cartridge_header,load_symbols,read_word
from verify_integrated_battle import source_route,DIRS
from verify_world_logic import source_group,source_action
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');args=p.parse_args()
 out=ROOT/'build/verification/dungeon-emulator';out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc';shutil.copyfile(args.rom,frozen);shutil.copyfile(args.rom.with_suffix('.noi'),frozen.with_suffix('.noi'))
 s=load_symbols(frozen.with_suffix('.noi'));source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
 report={'header':cartridge_header(frozen),'checks':[],'controller_steps':0,'battles':0,'injected_fixtures':['Alis level30, HP/maxHP200 and attack/defense200 for integration coverage without grinding','One Flash item in inventory before walking to the dungeon; no source flags, coordinates, RNG or dungeon state modified'],'screenshots':[],'campaign_complete':False}
 with tempfile.TemporaryDirectory(prefix='ps-dungeon-game-')as tmp:
  rom=Path(tmp)/'test.gbc';shutil.copyfile(frozen,rom)
  def boot():
   e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);e.tick(300);return e
  e=boot()
  def val(n):return e.memory[s[n]]
  def state():return val('screen_state')
  def pos():return read_word(e,s['player_x']),read_word(e,s['player_y'])
  def ds():return tuple(e.memory[s['game_dungeon']:s['game_dungeon']+4])
  def wait(fn,why,limit=2400):
   for _ in range(limit):
    if fn():return
    e.tick(1)
   raise AssertionError((why,state(),pos(),ds(),hex(e.register_file.PC)))
  def press(k):button(e,k,4,48)
  def completed_frame():
   # Coordinates/step_remaining update before the same step's encounter and
   # scene upload complete. Wait for the main loop, not a guessed tick delay.
   before=read_word(e,s['frame_counter'])
   wait(lambda:read_word(e,s['frame_counter'])!=before,'completed gameplay frame')
  def shot(n):e.tick(4);report['screenshots'].append(capture(e,out/(n+'.png')))
  def finish_battle():
   if state()!=15:return
   report['battles']+=1
   for _ in range(1200):
    if state()!=15:return
    press('a')
   raise AssertionError(('battle stuck',state(),ds()))
  def step(k):
   assert state()==1,(state(),k)
   x,y=pos();dx,dy=DIRS[k];target=((x+dx*16)%2048,(y+dy*16)%1536);m=val('world_map_id')
   e.button_press(k)
   try:wait(lambda:pos()!=(x,y) or bool(val('step_remaining'))or state()!=1 or val('world_map_id')!=m,'start walking '+k)
   finally:e.button_release(k)
   wait(lambda:(pos()==target and not val('step_remaining'))or state()!=1 or val('world_map_id')!=m,'finish walking '+k)
   completed_frame();report['controller_steps']+=1
   finish_battle()
   completed_frame()
  press('start');finish_new_game_intro(e,s);wait(lambda:state()==1,'new game')
  r=s['game_rpg'];e.memory[r+5]=30;e.memory[r+1]=200;e.memory[r+6]=200;e.memory[r+8]=200;e.memory[r+9]=200
  e.memory[r+64]=39;e.memory[r+88]=1
  g,f,entries=source_group(source,4)
  route,_=source_route(g,f,(105,18),lambda p:source_action(source,4,g,f,entries,*p)[0]==8)
  for key in route:step(key)
  wait(lambda:state()==1 and val('world_map_id')==0,'Palma arrival')
  g,f,entries=source_group(source,0);x,y=pos();cell=((x-8)//16,(y+1536-16)%1536//16)
  route,goal=source_route(g,f,cell,lambda p:source_action(source,0,g,f,entries,*p)[0]==10)
  expected=source_action(source,0,g,f,entries,*goal)
  for key in route:step(key)
  wait(lambda:state()==4,'dark dungeon introduction')
  assert ds()[:3]==tuple(expected[1:4]),(ds(),expected)
  assert ds()[3]==0;shot('dark-entry')
  report['checks'].append('Walked original Camineet exit and Palma cave entry; exact floor/position/direction match source transition')
  while state()==4:press('a')
  assert state()==2;press('down');press('down');press('a');assert state()==9
  press('a');assert state()==10;press('a')
  while state()==4:press('a')
  wait(lambda:state()==17,'Flash returns to lit dungeon')
  assert ds()[3]!=0 and e.memory[r+88]==0;shot('flash-lit')
  report['checks'].append('Original darkness prompt leads to menu; using Flash consumes it and lights the floor')
  def dstep(k):
   before=ds();e.tick(12);e.button_press(k)
   try:wait(lambda:ds()!=before or state()!=17,'dungeon '+k)
   finally:e.button_release(k)
   # Native source animation updates direction/position before its remaining
   # poses and callback checkpoints. Observe the next main-loop iteration.
   completed_frame();e.tick(2)
  original=ds();dstep('left');assert ds()[1]==original[1] and ds()[2]==(original[2]+3)%4
  finish_battle();dstep('right');finish_battle();assert ds()==original
  report['checks'].append('Controller rotation retains position and follows source direction order')
  # The nearest source entrance is floor0/DC facingnorth; money object7C is
  # reached when position8C faces it. No coordinates are injected.
  assert ds()[:3]==(0,0xdc,0),ds()
  for expected_position in [0xcc,0xbc,0xac,0x9c,0x8c]:
   dstep('up');assert ds()[1]==expected_position,ds();finish_battle()
  assert ds()[1]==0x8c;shot('chest-collected')
  press('select');wait(lambda:state()==8,'dungeon save');assert val('saved_position_valid')==1
  expected_dungeon=ds();e.memory[0x0000]=0x0a
  record=bytes(e.memory[0xa000:0xa000+626]);e.memory[0x0000]=0
  assert record[362+2]==255,('Source chest C602 not marked',record[362:370])
  assert record[618:623]==bytes([1,*expected_dungeon]),(record[618:623],expected_dungeon)
  persistent=bytes(e.memory[r:r+94]);e.stop(save=True);e=boot();assert val('saved_position_valid')==1
  press('start');finish_continue_menu(e,s);wait(lambda:state()==17,'Continue in dungeon');assert ds()==expected_dungeon
  assert bytes(e.memory[r:r+94])==persistent;shot('continued-dungeon')
  report['checks'].append('Money chest C602 opens once; save records its flag and dungeon floor/position/direction/light; Continue preserves RPG state')
  # Walk back to the source entrance and leave via its special stair.
  dstep('left');finish_battle();dstep('left');finish_battle()
  for target in [0x9c,0xac,0xbc,0xcc,0xdc]:
   dstep('up');assert ds()[1]==target;finish_battle()
  dstep('up');wait(lambda:state()==1 and val('world_map_id')==0,'source dungeon exit')
  shot('returned-to-palma');report['checks'].append('Original special stair returns to the stored outside world position')
  e.stop(save=False)
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
if __name__=='__main__':main()
