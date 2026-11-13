#!/usr/bin/env python3
"""Actual chest decline/menu/Tele/Trap/Save route with an explicit nearby save."""
from pathlib import Path
import argparse,json,shutil,tempfile
from verify_rom import finish_continue_menu,confirm_existing_save,cartridge_header,load_symbols,read_word,finish_new_game_intro
from verify_story_ui import read_save_record,save_record,seal_save,save_record_size,Session,patch_save
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');a=p.parse_args()
 out=ROOT/'build/verification/chest-menu-integration';out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc';shutil.copyfile(a.rom,frozen);shutil.copyfile(a.rom.with_suffix('.noi'),frozen.with_suffix('.noi'))
 s=load_symbols(frozen.with_suffix('.noi'));report={'header':cartridge_header(frozen),'checks':[],'screenshots':[],'injected_fixtures':['Valid SRAM fixture:floor0/9C facing original money chest7C, Alis/Myau/Noah joined with32HP/60MP and learned mapspells,10000Meseta and RNG1234; C602 remains0. All subsequent chest, spell and save actions use controller input.'],'campaign_complete':False}
 with tempfile.TemporaryDirectory(prefix='ps-chest-menu-')as tmp:
  rom=Path(tmp)/'game.gbc';shutil.copyfile(frozen,rom);q=Session(rom,s,out,report)
  q.press('start');finish_new_game_intro(q.e,s);q.press('select');q.wait(lambda:q.state()==8,'base save')
  q.e.memory[0]=10;base=read_save_record(q.e);q.e.memory[0]=0
  q.install(patch_save(base,party=11,dungeon=(0,0x9c,0)))
  q.wait(lambda:q.state()==17,'floor entry');q.press('up')
  def prompt():
   for n in range(6000):
    if q.state()==15 and q.byte('battle_view_state')==6:return
    if not q.revealing()and(q.state()==4 or(q.state()==15 and q.byte('battle_view_state')==5)):q.press('a',2)
    else:q.tick()
   raise AssertionError(('chest prompt',q.state(),q.byte('battle_view_state')))
  prompt();q.shot('closed-chest');q.press('right');q.press('a');q.wait(lambda:q.state()==2,'decline returns original field menu')
  assert q.byte('battle_view_chest_pending')==1 and q.byte('battle_view_field_menu_pending')==1
  r=s['game_rpg'];prepared_rng=read_word(q.e,r+92);hp=bytes(q.e.memory[r:r+32]);money=read_word(q.e,r+90)
  def magic(caster,option):
   assert q.state()==2
   for _ in range(8):
    if q.byte('menu_choice')==7:break
    q.press('down')
   q.press('a');assert q.state()==11
   while q.byte('party_choice')!=caster:q.press('down')
   q.press('a');assert q.state()==19
   for _ in range(option):q.press('down')
   q.press('a')
  magic(3,2);prompt();assert q.e.memory[r+50]==56 and read_word(q.e,r+92)==prepared_rng
  q.shot('tele-reopens-prompt');q.press('right');q.press('a');q.wait(lambda:q.state()==2,'Tele declined')
  magic(1,1)
  for n in range(6000):
   if q.state()==2 and not q.byte('battle_view_chest_pending'):break
   if not q.revealing()and(q.state()==4 or(q.state()==15 and q.byte('battle_view_state')==5)):q.press('a',2)
   else:q.tick()
  else:raise AssertionError(('Trap completion',q.state(),q.byte('battle_view_state')))
  assert q.byte('battle_view_field_menu_pending')==1 and q.e.memory[r+18]==58
  assert read_word(q.e,r+92)==prepared_rng and q.e.memory[r+1]==hp[1] and q.e.memory[r+17]==hp[17]
  assert read_word(q.e,r+90)>money;q.shot('trap-opened-field-menu')
  report['checks'].append('NO opens full field menu; Noah Tele costs4MP and reopens question; Myau Trap costs2MP, disarms/opens with no RNG reroll or HP loss, and retains field menu after rewards')
  for _ in range(8):
   if q.byte('menu_choice')==4:break
   q.press('down')
  q.press('a');confirm_existing_save(q.e,s);q.wait(lambda:q.state()==8,'save while original post-open menu remains')
  q.e.memory[0]=10;record=read_save_record(q.e);q.e.memory[0]=0
  assert record[364]==255,'C602 must be saved before leaving post-open menu'
  saved_money=read_word(q.e,r+90);q.press('a');q.wait(lambda:q.state()==2,'save confirmation returns menu');q.press('b');q.wait(lambda:q.state()==17,'menu cancellation resumes dungeon')
  q.e.stop(save=True);q.boot();q.press('start');finish_continue_menu(q.e,s);q.wait(lambda:q.state()==17,'continued dungeon');q.tick(100)
  assert q.state()==17 and not q.byte('battle_view_chest_pending') and read_word(q.e,r+90)==saved_money
  q.shot('continued-open-chest');q.close()
  report['checks'].append('Saving before leaving post-open menu persists C602; cancel completes once; power-cycle restores dungeon and money without reopening/rewarding the chest')
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
if __name__=='__main__':main()
