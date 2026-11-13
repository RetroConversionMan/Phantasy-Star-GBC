#!/usr/bin/env python3
"""Real walking/text-input regression; no game-state or RNG fixtures."""
from pathlib import Path
import argparse,json,shutil,tempfile
from pyboy import PyBoy
from verify_rom import finish_new_game_intro,is_text_revealing,button,capture,cartridge_header,load_symbols,read_word
from verify_integrated_battle import source_route,DIRS
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);a=p.parse_args()
 out=ROOT/'build/verification/dialogue-input';out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc';shutil.copyfile(a.rom,frozen);shutil.copyfile(a.rom.with_suffix('.noi'),frozen.with_suffix('.noi'))
 s=load_symbols(frozen.with_suffix('.noi'));assert 'dialogue_revealing'in s
 report={'header':cartridge_header(frozen),'checks':[],'screenshots':[],'injected_fixtures':[],'campaign_complete':False}
 grid=(ROOT/'assets/world/world_g04.map').read_bytes();flags=(ROOT/'assets/world/world_g04.collision').read_bytes()
 with tempfile.TemporaryDirectory(prefix='ps-text-input-')as tmp:
  rom=Path(tmp)/'game.gbc';shutil.copyfile(frozen,rom);e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
  def value(n):return e.memory[s[n]]
  def state():return value('screen_state')
  def pos():return read_word(e,s['player_x']),read_word(e,s['player_y'])
  def lines():return tuple(''.join(chr(e.memory[0,0x9c00+row*32+x]+32)for x in range(1,19))for row in(1,2))
  def wait(fn,why,limit=6000):
   for _ in range(limit):
    if fn():return
    e.tick(1)
   raise AssertionError((why,state(),pos(),lines(),hex(e.register_file.PC)))
  def press(key,expected=None):
   e.button_release(key);before=read_word(e,s['frame_counter'])
   wait(lambda:read_word(e,s['frame_counter'])!=before,'released gameplay frame');e.tick(1)
   if expected is not None and(state()!=expected or is_text_revealing(e,s)):return
   button(e,key,2,4)
  def shot(name):e.tick(2);report['screenshots'].append(capture(e,out/(name+'.png')))
  def walk(target):
   x,y=pos();goals={(target[0]+dx,(target[1]+dy)%96)for dx in(0,1)for dy in(0,1)}
   route,_=source_route(grid,flags,((x-8)//16,(y-16)//16),lambda q:q in goals and flags[grid[q[1]*128+q[0]]]&8)
   for key in route:
    assert state()==1
    x,y=pos();dx,dy=DIRS[key];end=((x+dx*16)%2048,(y+dy*16)%1536);e.button_press(key)
    try:wait(lambda:(pos()==end and not value('step_remaining'))or state()!=1,'step')
    finally:e.button_release(key)
    before=read_word(e,s['frame_counter']);wait(lambda:read_word(e,s['frame_counter'])!=before,'completed frame')
  def drain(target):
   for _ in range(6000):
    if state()==target:return
    assert state()==4,('drain',target,state())
    if is_text_revealing(e,s):e.tick(1)
    else:press('a',4)
   raise AssertionError('Text drain stalled')
  try:
   e.tick(300);press('start');finish_new_game_intro(e,s);walk((102,22));assert state()==4 and is_text_revealing(e,s)
   press('a');wait(lambda:not is_text_revealing(e,s),'first page complete');assert state()==4 and "I'M SUELO."in lines()[0]
   first=lines();e.tick(30);assert lines()==first and state()==4;shot('transient-press-ignored')
   report['checks'].append('A press and release entirely during typing is ignored; first Suelo page remains at its original61 wait')
   e.button_press('a');wait(lambda:is_text_revealing(e,s),'second page starts');wait(lambda:not is_text_revealing(e,s),'second page complete')
   assert state()==4;second=lines();assert second!=first and any('STOP YOU FROM'in line for line in second)
   e.tick(30);assert state()==4 and lines()==second;e.button_release('a');e.tick(3)
   report['checks'].append('Holding the page-advance button through the next reveal does not advance again; release must be sampled at the next original input wait')
   press('a');assert state()==4 and is_text_revealing(e,s);drain(1)
   assert e.memory[s['game_events']+1]==1;walk((94,24));drain(5);assert value('choice')==0
   press('b');wait(lambda:state()==6,'B confirms selected YES');shot('b-confirms-yes');press('b');drain(1)
   walk((94,24));drain(5);assert value('choice')==0
   e.button_press('down');e.button_press('b');e.tick(2);e.button_release('down');e.button_release('b');e.tick(4);drain(1)
   assert read_word(e,s['game_rpg']+90)==0 and e.memory[s['game_rpg']+88]==0
   report['checks'].append('Armory default YES accepts B; simultaneous Down+B selects and confirms NO, matching source CheckOptionSelect order, without changing money/inventory')
   report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
  finally:e.stop(False)
if __name__=='__main__':main()
