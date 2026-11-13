#!/usr/bin/env python3
"""Source1656 victory/clear timing versus frozen native battle presentation."""
from pathlib import Path
import argparse,json,re
from pyboy import PyBoy
from verify_rom import load_symbols,read_word,cartridge_header
from verify_dark_falz_prelude_source import trace
from extract_scenes import label
import verify_support_commands as support
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "battle_view.h"
#include "battle_scene.h"
#include "audio.h"
#include "font.h"
extern RPGState game_rpg;
volatile uint8_t victory_ready,victory_command,victory_enemy,victory_scene;
static const uint16_t palette[]={RGB(2,3,8),RGB(6,10,19),RGB(30,22,8),RGB(30,30,27)};
void main(void){
 cpu_fast();DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;set_bkg_palette(7,1,palette);SWITCH_ROM_MBC5(1);audio_install();SHOW_BKG;DISPLAY_ON;victory_ready=1;
 while(1){vsync();
  if(victory_command==1){rpg_new_game(&game_rpg);battle_scene_configure(victory_scene,0);battle_view_begin(&game_rpg,victory_enemy);victory_command=0;}
  else if(victory_command==2){battle_view_battle.outcome=RPG_VICTORY;battle_view_battle.exp_reward=battle_view_battle.money_reward=0;battle_view_battle.item_reward=0;battle_view_state=BVIEW_EXECUTE;victory_command=0;}
  else battle_view_tick(0,0);
 }
}
'''

def source_trace(enemy):
 s,phases=trace();c=s.main;c.memory[0xc2e6]=enemy;s.frames.clear();s.unique.clear();s.logs.clear();s.audio.clear();c.pc=label('LABEL_1656');c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';end=label('ShowDialogue_B12');c.set_breakpoint(end)
 for _ in range(1000):
  c.ticks_to_stop=500000;c.run()
  if c.pc in(0x100,end):break
 else:raise AssertionError(('sourcevictory',enemy,hex(c.pc)))
 if enemy!=49:assert c.pc==end
 return {'enemy':enemy,'audio':s.audio,'wait_commands':[r[-1]for r in s.logs],'frames':len(s.frames),'clear_map':bytes(c.memory[0xd000:0xd600])==b'\0\x08'*768}

def main():
 p=argparse.ArgumentParser();p.add_argument('--snapshot',type=Path,default=ROOT/'build/source-snapshots/victory-window-candidate');p.add_argument('--output',type=Path,default=ROOT/'build/verification/victory-window');a=p.parse_args();out=a.output.resolve();out.mkdir(parents=True,exist_ok=True);snap=a.snapshot.resolve();support.MAIN=MAIN;rom,objects=support.build(snap,out)
 s=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0);events=[];active=[False];pending=[None];waits=[]
 guard=bytes((0x9d+i*17)&255 for i in range(64));guard_active=[False]
 def clock():return read_word(e,s['audio_frames'])
 def hook(kind):
  if not active[0]:return
  if kind=='sound':events.append((kind,e.memory[e.register_file.SP+6],clock()))
  elif kind=='text':events.append((kind,read_word(e,e.register_file.SP+8),clock()))
  elif kind=='close':pending[0]=(e.register_file.A,e.register_file.E,clock());events.append(('wait_start',pending[0][0],clock()))
  elif kind=='resume':
   if pending[0]and e.register_file.A==pending[0][1]:
    length,after,start=pending[0];elapsed=(clock()-start)&65535;assert elapsed==length,(length,elapsed);waits.append(length);pending[0]=None
  else:events.append((kind,None,clock()))
 for name,kind in [('audio_command','sound'),('dialogue_open','text'),('battle_scene_clear','clear')]:
  address=s[name];e.hook_register(address>>16,address&65535,hook,kind)
 local={m[1]:int(m[2],16)for m in re.finditer(r'^\s*8 _([A-Za-z0-9_]+)\s+([0-9A-Fa-f]+) [GR]+$',(snap/'build/obj/battle_view.sym').read_text(),re.M)}
 bases={s[n]-v for n,v in local.items()if n in s and n.startswith('battle_view_')};assert len(bases)==1;base=bases.pop()
 for name,kind in [('close_delay','close'),('resume','resume')]:address=base+local[name];e.hook_register(address>>16,address&65535,hook,kind)
 def tick(n=1):
  for _ in range(n):
   e.tick(1);assert not e.memory[s['audio_fault']]
   if guard_active[0]:assert bytes(e.memory[0xdbc0:0xdc00])==guard,'64-byte stack guard changed'
 report={'header':cartridge_header(rom),'production_header':cartridge_header(snap/'build/phantasy-star-gbc-world.gbc'),'objects_sha256':objects,'cases':[],'scope':'Explicit forced victory fixtures; real native scene clear, original audio driver and controller. Source wait/audio oracle executes1656 through firstB71B. No earned-campaign claim.'}
 try:
  tick(180);assert e.memory[s['victory_ready']]
  areas=re.findall(r'^(_DATA|_INITIALIZED|_BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+=',rom.with_suffix('.map').read_text(),re.M)
  assert areas and max(int(v,16)+int(n,16)for k,v,n in areas)<=0xdbc0
  e.memory[0xdbc0:0xdc00]=guard;guard_active[0]=True
  for enemy,scene in [(1,1),(49,1),(70,14),(72,30),(73,32)]:
   source=source_trace(enemy);active[0]=False;e.memory[s['victory_enemy']]=enemy;e.memory[s['victory_scene']]=scene;e.memory[s['victory_command']]=1
   for _ in range(600):
    tick()
    if not e.memory[s['victory_command']]:break
   else:raise AssertionError(('fixture',enemy))
   tick(4);events.clear();waits.clear();pending[0]=None;active[0]=True;e.memory[s['victory_command']]=2;black_frames=0
   for _ in range(1000):
    tick()
    if enemy==73 and e.memory[s['battle_view_state']]==10:
     assert not(e.memory[0xff40]&32),'Battle window remained visible after restoration'
     if black_frames>1:assert not e.screen.ndarray[:120,:,:3].any(),'DarkFalz viewport is not black during the victory hold'
     black_frames+=1
    if (enemy==49 and e.memory[s['battle_view_state']]==9)or any(k=='text'and v==0xb71b for k,v,c in events):break
   else:raise AssertionError(('completion',enemy,events))
   active[0]=False;sounds=[v for k,v,c in events if k=='sound'];assert sounds==([0xd8]if enemy==49 else[0xaf,0xd8]),(enemy,events)
   assert [v for frame,v in source['audio']]==sounds
   if enemy==49:assert not waits and not any(k=='clear'for k,v,c in events)and not source['wait_commands']
   else:
    expected=4 if enemy==73 else 14;assert waits==[expected,1],(enemy,waits)
    assert source['wait_commands']==[10]*expected+[16]+([8]*180 if enemy in(72,73)else[])
    af=next(c for k,v,c in events if k=='sound'and v==0xaf);clear=next(c for k,v,c in events if k=='clear');d8=next(c for k,v,c in events if k=='sound'and v==0xd8)
    assert ((clear-af)&65535)>=expected,(enemy,'clear precedes rows',events)
    last_wait=next(c for k,v,c in reversed(events)if k=='wait_start');assert ((d8-last_wait)&65535)==(181 if enemy in(72,73) else 1),(enemy,'upload then boss hold',events)
   if enemy==73:assert black_frames>=179
   report['cases'].append({'enemy':enemy,'scene':scene,'source':source,'native_events':events.copy(),'exact_row_and_upload_waits':waits.copy(),'black_DarkFalz_hold_frames':black_frames,'guard64_preserved':True})
  report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'cases':5,'rom_sha256':report['header']['sha256']}))
 finally:e.stop(save=False)
if __name__=='__main__':main()
