#!/usr/bin/env python3
"""Original AddItem B3 menus; exact objects, bank30 diagnostic body and verified layout."""
from pathlib import Path
import sys,argparse,json,re,hashlib,subprocess
ROOT=Path(__file__).resolve().parents[3];sys.path.insert(0,str(ROOT/'tools'))
import verify_support_commands as support
from verify_rom import load_symbols,read_word,cartridge_header
from pyboy import PyBoy
MAIN=r'''
#pragma bank 30
#include <gb/gb.h>
#include <gb/cgb.h>
#include "battle_view.h"
#include "battle_scene.h"
#include "audio.h"
#include "font.h"
extern RPGState game_rpg;
volatile uint8_t chest_probe_ready,chest_probe_command,chest_probe_case;
static const uint16_t palette[]={RGB(2,3,8),RGB(6,10,19),RGB(30,22,8),RGB(30,30,27)};
void chest_probe_run(void) __banked {uint8_t i,keys,last=0,pressed,revealing;
 cpu_fast();DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;set_bkg_palette(7,1,palette);audio_install();SHOW_BKG;DISPLAY_ON;chest_probe_ready=1;
 while(1){vsync();keys=joypad();pressed=keys&~last;revealing=battle_view_text_revealing;
  if(chest_probe_command){rpg_new_game(&game_rpg);
   if(chest_probe_case>=2u&&chest_probe_case<=4u)for(i=0;i<24u;++i)rpg_add_item(&game_rpg,i==0u?56u:36u);
   if(chest_probe_case==1u)rpg_add_item(&game_rpg,38u);
   battle_scene_configure(1u,0u);battle_view_chest_begin(&game_rpg,chest_probe_case==5u?0u:38u,10u,0u);battle_view_menu_allowed=0;chest_probe_command=0;
  }else battle_view_tick(keys,pressed);
  if(!revealing)last=keys;
 }
}
void main(void) __nonbanked {chest_probe_run();}
'''
def main():
 p=argparse.ArgumentParser();p.add_argument('--snapshot',type=Path,default=ROOT/'build/source-snapshots/service-inventory-candidate');p.add_argument('--output',type=Path,default=ROOT/'build/verification/service-inventory-chest');a=p.parse_args();snap=a.snapshot.resolve();out=a.output.resolve();out.mkdir(parents=True,exist_ok=True);support.MAIN=MAIN;rom,objects=support.build(snap,out)
 subprocess.run([sys.executable,str(ROOT/'tools/verify_layout.py'),str(rom)],check=True,capture_output=True,text=True)
 s=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0);events=[];active=[False];pending=[None];closes=[];guard=bytes((0x9d+i*17)&255 for i in range(64))
 def value(n):return e.memory[s[n]]
 def state():return value('battle_view_state')
 def items():
  count=e.memory[s['game_rpg']+88];return list(e.memory[s['game_rpg']+64:s['game_rpg']+64+count])if count else[]
 def hook(kind):
  if active[0]and kind=='close':
   pending[0]=(e.register_file.A,e.register_file.E,read_word(e,s['audio_frames']));assert not(e.memory[0xff40]&34),('source chest hidden during close',e.memory[0xff40]);return
  if active[0]and kind=='resume':
   if pending[0]and e.register_file.A==pending[0][1]:
    length,after,start=pending[0];assert((read_word(e,s['audio_frames'])-start)&65535)==length;closes.append(length);pending[0]=None
   return
  if active[0]:events.append({'kind':kind,'value':e.memory[e.register_file.SP+6]if kind=='sound'else read_word(e,e.register_file.SP+8),'clock':read_word(e,s['audio_frames']),'items':items()})
 for name,kind in [('audio_command','sound'),('dialogue_open','text')]:address=s[name];e.hook_register(address>>16,address&65535,hook,kind)
 local={m[1]:int(m[2],16)for m in re.finditer(r'^\s*8 _([A-Za-z0-9_]+)\s+([0-9A-Fa-f]+) [GR]+$',(snap/'build/obj/battle_view.sym').read_text(),re.M)}
 bases={s[n]-v for n,v in local.items()if n in s and n.startswith('battle_view_')};assert len(bases)==1;base=bases.pop()
 for name,kind in [('close_delay','close'),('resume','resume')]:address=base+local[name];e.hook_register(address>>16,address&65535,hook,kind)
 def tick(n=1):
  for _ in range(n):e.tick(1);assert not value('audio_fault')
 def press(key):e.button_release(key);tick(4);e.button_press(key);tick(3);e.button_release(key);tick(12)
 def wait(fn,why):
  for _ in range(12000):
   if fn():return
   tick()
  raise AssertionError((why,state(),events))
 def drain(fn):
  for frame in range(12000):
   if fn():e.button_release('a');tick(20);return
   if state()==5 and not value('battle_view_text_revealing')and frame%24==0:e.button_press('a')
   else:e.button_release('a')
   tick()
  raise AssertionError(('drain',state(),events))
 report={'header':cartridge_header(rom),'production_header':cartridge_header(snap/'build/phantasy-star-gbc-world.gbc'),'objects_sha256':objects,'cases':[],'scope':'Explicit chest/inventory setup before menus. Source AddItem/27D8 audio boundaries tested; native chest item awards are staged after B592; pure rules API remains immediate. This is not earned campaign progression.'}
 try:
  tick(180);assert value('chest_probe_ready');areas=re.findall(r'^(_DATA|_INITIALIZED|_BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+=',rom.with_suffix('.map').read_text(),re.M);assert max(int(x,16)+int(y,16)for _,x,y in areas)<=0xdbc0;e.memory[0xdbc0:0xdc00]=guard
  for case,name in enumerate(['free','duplicate','full_replace','protected_cancel_replace','full_abandon','money_only']):
   active[0]=False;e.memory[s['chest_probe_case']]=case;e.memory[s['chest_probe_command']]=1;wait(lambda:not value('chest_probe_command'),'fixture');events.clear();closes.clear();pending[0]=None;active[0]=True;drain(lambda:state()==6);press('a')
   if case in(2,3,4):
    drain(lambda:state()==6);assert not any(x['kind']=='sound'and x['value']==0xb3 for x in events)
    if case==4:press('right');press('a');drain(lambda:state()==6);press('a');drain(lambda:state()==9)
    else:
     press('a');drain(lambda:state()==7)
     if case==3:
      press('a');assert read_word(e,s['battle_view_dialogue_id'])==0xb6de;drain(lambda:state()==7);press('b');drain(lambda:state()==6);press('a');drain(lambda:state()==7)
     press('down');press('a');assert read_word(e,s['battle_view_dialogue_id'])==0xb69e;assert items()[1]==36;drain(lambda:state()==9)
   else:drain(lambda:state()==9)
   found=[x for x in events if x['kind']=='text'and x['value']==0xb592]
   if case==0:assert found[0]['items']==[]
   if case==1:assert found[0]['items']==[38]
   sounds=[x for x in events if x['kind']=='sound'and x['value']==0xb3];assert len(sounds)==(0 if case in(4,5)else 1),(name,events)
   if sounds:
    sound=events.index(sounds[0]);assert events[sound-1]['kind']=='text'and events[sound-1]['value']==(0xb69e if case in(2,3)else 0xb592),(name,events)
    if case in(2,3):assert events[sound+1]['kind']=='text'and events[sound+1]['value']==0xb6ad and sounds[0]['items'][1]==38
   assert closes==[6],(name,closes);assert read_word(e,s['game_rpg']+90)==10;assert bytes(e.memory[0xdbc0:0xdc00])==guard
   report['cases'].append({'name':name,'events':events.copy(),'final_items':items(),'exact_chest_close_frames':closes.copy(),'guard64_preserved':True})
  report['source_files_sha256']={str(p.relative_to(snap)):hashlib.sha256(p.read_bytes()).hexdigest()for p in sorted((snap/'src').glob('*'))if p.is_file()};report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'cases':6,'probe_sha256':report['header']['sha256']}))
 finally:e.stop(save=False)
if __name__=='__main__':main()
