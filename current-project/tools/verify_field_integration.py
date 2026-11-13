#!/usr/bin/env python3
"""Exercise real field-menu inputs, cancellation costs and vehicle save state."""
from pathlib import Path
import argparse,json,shutil,tempfile
from pyboy import PyBoy
from verify_rom import is_text_revealing,finish_continue_menu,finish_new_game_intro,button,capture,cartridge_header,load_symbols,read_word,wait_dispatch
from verify_integrated_battle import source_route,DIRS
from verify_world_logic import source_group,source_action
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');a=p.parse_args()
 out=ROOT/'build/verification/field-integration';out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc';shutil.copyfile(a.rom,frozen);shutil.copyfile(a.rom.with_suffix('.noi'),frozen.with_suffix('.noi'))
 s=load_symbols(frozen.with_suffix('.noi'));report={'header':cartridge_header(frozen),'checks':[],'screenshots':[],'injected_fixtures':['Alis HP1, MP/maxMP20 and2 mapspells; Noah joined with MP/maxMP60, HP/maxHP100 and5 mapspells to test menu costs without campaign grinding','Landrover inventory item for vehicle UI; map location, flags and RNG unchanged'],'campaign_complete':False}
 with tempfile.TemporaryDirectory(prefix='ps-field-ui-')as tmp:
  rom=Path(tmp)/'game.gbc';shutil.copyfile(frozen,rom)
  def boot():
   e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);e.tick(300);return e
  e=boot();r=s['game_rpg']
  def val(n):return e.memory[s[n]]
  def state():return val('screen_state')
  def pos():return read_word(e,s['player_x']),read_word(e,s['player_y'])
  def press(k):
   # world_map_id and STATE_WALK can change before the synchronous map
   # upload/fade returns. Send a fresh controller action only after release
   # was sampled by two completed logical dispatches.
   wait_dispatch(e,s)
   before={'key':k,'state':state(),'position':pos(),'frame':read_word(e,s['frame_counter'])}
   button(e,k,4,72);wait_dispatch(e,s)
   before.update(after=state(),after_position=pos(),menu_choice=val('menu_choice'),field_active=val('field_active'),last_keys=val('last_keys'))
   report.setdefault('inputs',[]).append(before);(out/'input-trace.json').write_text(json.dumps({'header':report['header'],'inputs':report['inputs']},indent=2)+'\n')
  def wait(fn,why,limit=2400):
   for _ in range(limit):
    if fn():return
    e.tick(1)
   raise AssertionError((why,state(),pos(),hex(e.register_file.PC)))
  def dismiss():
   for _ in range(5000):
    if state()!=4:return
    if is_text_revealing(e,s):e.tick(1)
    else:
     e.button_release('a');before=read_word(e,s['frame_counter'])
     wait(lambda:read_word(e,s['frame_counter'])!=before,'released text frame');e.tick(1)
     if state()==4 and not is_text_revealing(e,s):press('a')
   raise AssertionError('dialogue loop')
  def shot(n):e.tick(4);report['screenshots'].append(capture(e,out/(n+'.png')))
  def magic_menu():
   assert state()==2
   for _ in range(8):
    if val('menu_choice')==7:break
    press('down')
   press('a');assert state()==11
  press('start');finish_new_game_intro(e,s);wait(lambda:state()==1,'new game')
  e.memory[r+1]=1;e.memory[r+2]=20;e.memory[r+7]=20;e.memory[r+15]=2
  for off,value in [(0,1),(1,100),(2,60),(5,1),(6,100),(7,60),(15,5)]:e.memory[r+48+off]=value
  e.memory[r+89]=9
  press('start');magic_menu();press('a');assert state()==19;press('a');assert state()==11;press('b')
  assert state()==2 and e.memory[r+2]==20 and e.memory[r+1]==1
  report['checks'].append('Canceling Heal target selection spends no MP and heals nobody')
  magic_menu();press('a');press('a');press('a');dismiss()
  assert state()==2 and e.memory[r+1]==16 and e.memory[r+2]==18;shot('heal-result')
  report['checks'].append('Heal selected through field menu restores20 HP capped at maximum and spends2 MP')
  magic_menu();press('down');assert val('party_choice')==3;press('a');assert state()==19
  for _ in range(4):press('down')
  press('a');assert state()==11;press('b')
  assert state()==2 and e.memory[r+50]==48
  report['checks'].append('Canceling Rise after selecting Noah spends12 MP as in source')
  # Keep the source-valid party record for a later cartridge save; field magic
  # fixtures remain explicit. No movement/state shortcuts are used.
  e.memory[r+64]=33;e.memory[r+88]=1
  press('b');assert state()==1
  source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();g,f,entries=source_group(source,4)
  route,_=source_route(g,f,(105,18),lambda p:source_action(source,4,g,f,entries,*p)[0]==8)
  for key in route:
   x,y=pos();dx,dy=DIRS[key];target=((x+dx*16)%2048,(y+dy*16)%1536);m=val('world_map_id')
   e.button_press(key)
   try:wait(lambda:(pos()==target and not val('step_remaining'))or val('world_map_id')!=m,'walk '+key)
   finally:e.button_release(key)
   e.tick(8)
  wait(lambda:state()==1 and val('world_map_id')==0 and pos()==(1368,736) and e.memory[0xff40]&128,'Palma map load');e.tick(80)
  press('start');press('down');press('down');press('a');assert state()==9
  press('a');assert state()==10;press('a');dismiss();wait(lambda:state()==1,'Landrover entry')
  assert val('game_vehicle')==4 and e.memory[r+64]==33 and e.memory[r+88]==1
  shot('landrover');saved_pos=pos();saved_party=bytes(e.memory[r:r+94])
  press('select');wait(lambda:state()==8,'vehicle save');assert val('saved_position_valid')==1
  e.stop(save=True);e=boot();press('start');finish_continue_menu(e,s);wait(lambda:state()==1,'vehicle continue');e.tick(80)
  assert val('game_vehicle')==4 and pos()==saved_pos and bytes(e.memory[r:r+94])==saved_party
  shot('landrover-continued');report['checks'].append('Landrover entry uses original geometry, retains item, and survives save/power-cycle with party state intact')
  press('start');press('down');press('down');press('a');press('a');dismiss()
  wait(lambda:state()==1,'Landrover exit');assert val('game_vehicle')==0 and e.memory[r+64]==33
  assert all(e.memory[0xfe00+i*4] for i in range(12)) and all(e.memory[0xfe00+i*4]==0 for i in range(12,40));shot('dismounted')
  report['checks'].append('Selecting the active vehicle item dismounts directly and restores the living Alis/Noah party without leaving stale vehicle sprites')
  e.stop(save=False)
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
if __name__=='__main__':main()
