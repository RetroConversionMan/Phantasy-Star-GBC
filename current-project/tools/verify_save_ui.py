#!/usr/bin/env python3
"""Create/load/overwrite/delete five real native files and test isolated damage."""
from pathlib import Path
import argparse,json,shutil,tempfile
from verify_rom import cartridge_header,load_symbols,read_word,finish_new_game_intro,finish_continue_menu
from verify_story_ui import Session,crc16
from verify_integrated_battle import DIRS
ROOT=Path(__file__).resolve().parents[1]
CHARACTERS='ABCDEFGHIJKLMNOPQRSTUVWXYZ,;.!?-"\\]^'
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');a=p.parse_args()
 out=ROOT/'build/verification/save-ui';out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc';shutil.copyfile(a.rom,frozen);shutil.copyfile(a.rom.with_suffix('.noi'),frozen.with_suffix('.noi'))
 s=load_symbols(frozen.with_suffix('.noi'));report={'header':cartridge_header(frozen),'checks':[],'screenshots':[],'injected_fixtures':['Final diagnostic flips one bit in temporary slot5 SRAM to verify isolated CRC rejection; no game-state fixtures used in normal save/name/load/delete/overwrite routes'],'campaign_complete':False}
 with tempfile.TemporaryDirectory(prefix='ps-five-save-')as tmp:
  rom=Path(tmp)/'game.gbc';shutil.copyfile(frozen,rom);q=Session(rom,s,out,report)
  def ram():
   q.e.memory[0]=10;data=bytes(q.e.memory[0xa000:0xc000]);q.e.memory[0]=0;return data
  def pos():return q.word('player_x'),q.word('player_y')
  def settle():
   frame=q.word('frame_counter');q.wait(lambda:q.word('frame_counter')!=frame,'main frame')
  def choose(slot):
   q.wait(lambda:q.state()==26,'file list')
   while q.byte('save_ui_choice')!=slot:q.press('down' if q.byte('save_ui_choice')<slot else 'up')
   q.press('a')
  def menu(option):
   if q.state()==1:q.press('start')
   q.wait(lambda:q.state()==2,'main menu')
   while q.byte('menu_choice')!=option:q.press('down')
   q.press('a')
  def name_file(name,erase_check=False):
   q.wait(lambda:q.state()==28,'name entry');current=0
   def pick(target):
    nonlocal current
    while current%6!=target%6:
     move=1 if current%6<target%6 else -1;q.press('right' if move>0 else 'left');current+=move
    while current//6!=target//6:
     move=6 if current//6<target//6 else -6;q.press('down' if move>0 else 'up');current+=move
    q.press('a')
   for ch in (name[:3]+'Z' if erase_check else name.rstrip()):pick(CHARACTERS.index(ch))
   if erase_check:q.press('b');pick(CHARACTERS.index(name[3]))
   visible=''.join(chr(q.e.memory[0,0x9c00+2*32+7+i]+32)for i in range(5))
   assert visible==name,(visible,name)
   pick(35);q.wait(lambda:q.state()==2,'name committed')
  q.press('start');finish_new_game_intro(q.e,s);q.wait(lambda:q.state()==1,'new game');settle()
  q.press('select');q.wait(lambda:q.state()==8,'legacy-compatible quick save');data=ram()
  assert data[:3]==b'PSG' and data[3] in (4,5),data[:4]
  version=data[3];record_bytes={4:626,5:628}[version];signature=b'PSG'+bytes([version])
  record0=data[:record_bytes]
  assert int.from_bytes(record0[-2:],'little')==crc16(record0[:-2])
  report.update(save_version=version,record_bytes=record_bytes)
  q.press('a');q.wait(lambda:q.state()==1,'return from quick save')
  records={0:record0};positions={0:pos()};labels={1:'ALIS ',2:'MYAU ',3:'ODIN ',4:'NOAH '}
  grid=(ROOT/'assets/world/world_g04.map').read_bytes();flags=(ROOT/'assets/world/world_g04.collision').read_bytes();visited={(105,18)}
  for slot in range(1,5):
   x,y=pos();cell=((x-8)//16,(y-16)//16)
   for key,(dx,dy)in DIRS.items():
    nxt=((cell[0]+dx)%128,(cell[1]+dy)%96)
    if nxt not in visited and not flags[grid[nxt[1]*128+nxt[0]]]&13:break
   else:raise AssertionError('No new safe save-test position')
   target=(nxt[0]*16+8,(nxt[1]*16+16)%1536);q.e.button_press(key)
   try:q.wait(lambda:q.byte('step_remaining') or pos()==target,'controller step begins')
   finally:q.e.button_release(key)
   q.wait(lambda:pos()==target and not q.byte('step_remaining'),'controller movement')
   settle();visited.add(nxt);positions[slot]=pos()
   menu(4);choose(slot);q.wait(lambda:q.state()==27,'save confirmation');q.press('a');name_file(labels[slot],slot==1)
   data=ram();records[slot]=data[slot*1024:slot*1024+record_bytes]
   assert data[:record_bytes]==record0 and records[slot][:4]==signature
   assert int.from_bytes(records[slot][-2:],'little')==crc16(records[slot][:-2])
   label=data[5120+slot*8:5128+slot*8]
   assert label[:5]==labels[slot].encode()and label[5]==0xa5 and int.from_bytes(label[6:],'little')==crc16(label[:6])
   assert q.byte('save_active_slot')==slot;q.press('b');q.wait(lambda:q.state()==1,'resume after save')
  assert q.byte('save_valid_mask')==31;q.shot('five-files-created')
  report['checks'].append(f'Five independent{record_bytes}-byte records fit original1024-byte slot strides and pass CRC; slot1 remains byte-identical while four controller-moved positions receive original five-character labels, including erase/back behavior')
  q.e.stop(save=True);q.boot();q.wait(lambda:q.state()==0,'title after power cycle');assert q.byte('save_valid_mask')==31
  for slot in range(5):
   q.press('start');finish_continue_menu(q.e,s,slot);q.wait(lambda:q.state()==1,'load slot');settle()
   assert pos()==positions[slot]and q.byte('save_active_slot')==slot,(slot,pos(),positions[slot])
   assert bytes(q.e.memory[s['game_rpg']:s['game_rpg']+94])==records[slot][10:104]
   menu(5);q.wait(lambda:q.state()==0,'return to title')
  report['checks'].append('After a real power cycle, Continue loads every chosen file with its exact position, party, inventory, money and RNG')
  q.press('start');q.wait(lambda:q.state()==25,'load/delete choice');q.press('down');q.press('a');choose(1)
  q.wait(lambda:q.state()==27,'delete confirmation');q.press('a');q.wait(lambda:q.state()==0,'delete returns title');data=ram()
  assert q.byte('save_valid_mask')==29 and data[1024]==0 and data[5120+8+5]==0
  for slot in (0,2,3,4):assert data[slot*1024:slot*1024+record_bytes]==records[slot]
  q.press('start');finish_continue_menu(q.e,s,4);q.wait(lambda:q.state()==1,'load last file');settle()
  menu(4);choose(2);q.wait(lambda:q.state()==27,'overwrite confirmation');q.press('a');q.wait(lambda:q.state()==8,'overwrite existing file skips naming');data=ram()
  assert data[5120+2*8:5120+2*8+5]==b'MYAU ' and data[:record_bytes]==record0
  records[2]=data[2048:2048+record_bytes];assert records[2][6:10]==records[4][6:10]
  report['checks'].append('Delete invalidates only selected record and label; overwriting another existing file retains its label and all other records')
  q.e.memory[0]=10;q.e.memory[0xa000+4*1024+620]^=1;q.e.memory[0]=0
  q.e.stop(save=True);q.boot();assert q.byte('save_valid_mask')==13
  q.press('start');finish_continue_menu(q.e,s,2);q.wait(lambda:q.state()==1,'load uncorrupted file');settle()
  assert pos()==positions[4];q.shot('uncorrupted-file-loaded');q.close()
  report['checks'].append('A single-bit corruption invalidates only slot5; another valid file still loads normally')
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
if __name__=='__main__':main()
