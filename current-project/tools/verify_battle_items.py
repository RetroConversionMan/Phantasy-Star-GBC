#!/usr/bin/env python3
"""Production native battle-item bridge against original geometry and deferred flags."""
from pathlib import Path
import hashlib,json,subprocess
from pyboy import PyBoy
import z80
from extract_enemies import SYMBOLS
from verify_rom import load_symbols,read_word,cartridge_header
from verify_vehicles import source_use
from verify_world_logic import source_group,ROM_SHA
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "game_field.h"
#include "game_flow.h"
#include "game_ui.h"
#include "game_sequence.h"
#include "battle_view.h"
#include "dungeon_play.h"
#include "world.h"
#include "audio.h"
RPGState game_rpg;EventState game_events;DungeonPlay game_dungeon;
RPGBattle battle_view_battle;
uint16_t player_x,player_y;
uint8_t facing,game_vehicle,screen_state,battle_view_chest_pending,battle_scene_type;
uint8_t probe_ready,probe_command,probe_map,probe_interaction,probe_item,probe_cell,probe_event,probe_projection,probe_myau;
uint8_t probe_bad_calls,probe_door,probe_count,probe_kind,probe_lines,probe_mode,probe_error;
uint16_t probe_line0,probe_line1,probe_x,probe_y,probe_rng;
void show_dialogue(uint16_t a){(void)a;++probe_bad_calls;}
void resume_walk(void){++probe_bad_calls;}
void enter_map(uint8_t a,uint16_t b,uint16_t c){(void)a;(void)b;(void)c;++probe_bad_calls;}
void reload_world_mode(void){++probe_bad_calls;}
void audio_command(uint8_t a) __banked{(void)a;++probe_bad_calls;}
void menu_screen(void) __banked{++probe_bad_calls;}
void result(uint8_t a,uint8_t b) __banked{(void)a;(void)b;++probe_bad_calls;}
void apply_event(void) __banked{++probe_bad_calls;}
void start_field_scene(uint8_t a) __banked{(void)a;++probe_bad_calls;}
void battle_view_chest_open(void) __banked{++probe_bad_calls;}
void battle_view_chest_prompt(uint8_t a) __banked{(void)a;++probe_bad_calls;}
void dplay_show_opening(DungeonPlay *a,uint8_t b) __banked{(void)a;(void)b;++probe_bad_calls;}
const EventAction *event_use_story_item(EventState *a,uint8_t b,uint8_t c) __banked{(void)a;(void)b;(void)c;++probe_bad_calls;return 0;}
void main(void){
 cpu_fast();DISPLAY_OFF;probe_ready=1;
 while(1){
  if(probe_command){
   probe_error=world_select(probe_map)?0:1;rpg_new_game(&game_rpg);rpg_add_item(&game_rpg,probe_item);
   memset(&game_events,0,sizeof game_events);game_events.rpg=&game_rpg;game_events.event=probe_event;game_events.type=probe_interaction;game_events.portrait=probe_projection;
   game_dungeon.active=probe_command==2;dungeon_enter(&game_dungeon.dungeon,0,0x55,0);game_dungeon.dungeon.layout[0x45]=probe_cell;
   game_rpg.party[1].status=probe_myau;probe_bad_calls=0;battle_scene_type=probe_interaction;game_field_battle_item(probe_item,0);
   probe_door=game_dungeon.dungeon.layout[0x45];probe_count=game_rpg.inventory_count;probe_kind=field_action.kind;probe_lines=field_action.line_count;
   probe_line0=field_action.lines[0].dialogue;probe_line1=field_action.lines[1].dialogue;probe_x=player_x;probe_y=player_y;probe_mode=game_vehicle;probe_rng=game_rpg.rng;
   probe_command=0;
  }
 }
}
'''
def source_deferred(rom,item,cell,map_id,interaction,event,projection,myau):
 c=z80.Z80Machine();c.memory[:0x8000]=rom[:0x8000]
 address=lambda name:SYMBOLS[name][1]
 hooks={address('ShowDialogue_B12'):'text',address('LABEL_3464'):'ui',address('LABEL_6BE9'):'cell'}
 text_ids={address('LABEL_B12_'+format(n,'X')):n for n in (0xb2ac,0xb2cd,0xb366,0xb569,0xb743,0xb35c)}
 for at in [0x100,*hooks]:c.set_breakpoint(at)
 c.memory[0xc29d]=255;c.memory[0xc29e]=interaction;c.memory[0xc309]=map_id;c.memory[0xc2db]=event;c.memory[0xc2dc]=projection;c.memory[0xc410]=myau;c.memory[0xd000]=cell
 c.pc=address('ItemUse_'+('DungeonKey'if item==45 else'MiracleKey'if item==62 else'Nuts'));c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';lines=[]
 for _ in range(30):
  c.ticks_to_stop=100000;c.run()
  if c.pc==0x100:break
  hook=hooks[c.pc]
  if hook=='text':lines.append(text_ids[c.hl])
  elif hook=='cell':c.a=cell;c.hl=0xd000
  c.pc=c.memory[c.sp]|c.memory[c.sp+1]<<8;c.sp+=2
 else:raise AssertionError('Original item handler did not return')
 assert c.memory[0xd000]==cell
 deferred=c.memory[0xc2d8]
 # Only the field-menu entry reads C2D8; it clears it before the first menu.
 c.pc=address('LABEL_1BE1');c.set_breakpoint(address('LABEL_36DD'));c.ticks_to_stop=100000;c.run()
 assert c.pc==address('LABEL_36DD')and c.memory[0xc2d8]==0 and c.memory[0xc29d]==0
 return deferred,lines
def main():
 out=ROOT/'build/verification/battle-items';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 rom=out/'battle-items-probe.gbc'
 sources=[out/'main.c']+[ROOT/'src'/x for x in ['game_field.c','field_actions.c','world.c','world_assets.c','bank_io.c','rpg.c','rpg_data.c','battle.c','dungeon.c','dungeon_data.c']]+sorted((ROOT/'src').glob('world_assets_*_*.c'))
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo64','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),*map(str,sources)],cwd=ROOT,check=True)
 syms=load_symbols(rom.with_suffix('.noi'));emu=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');emu.set_emulation_speed(0)
 def put(name,value):emu.memory[syms[name]]=value
 def word(name,value):put(name,value&255);emu.memory[syms[name]+1]=value>>8
 def val(name):return emu.memory[syms[name]]
 def getword(name):return read_word(emu,syms[name])
 def run(command=1):
  put('probe_command',command)
  for n in range(120):
   emu.tick(1,False,False)
   if not val('probe_command'):break
  else:raise AssertionError(('timeout',hex(emu.register_file.PC)))
  assert not val('probe_bad_calls') and not val('probe_error')
  assert val('probe_count')==1 and getword('probe_rng')==0x733c
  return val('probe_kind'),[getword('probe_line0'),getword('probe_line1')][:val('probe_lines')]
 counts={'vehicle_contexts':0,'boarding_successes':0,'boarding_failures':0,'reboarding_cases':0,'deferred_door_cases':0,'nuts_contexts':0,'original_Z80_deferred_cases':0}
 try:
  for _ in range(240):
   emu.tick(1,False,False)
   if val('probe_ready'):break
  assert val('probe_ready')
  source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(source).hexdigest()==ROM_SHA
  groups=[source_group(source,n)for n in range(11)];mapping=source[0xdc1:0xdd9]
  for group,(grid,flags,_)in enumerate(groups):
   put('probe_map',list(mapping).index(group));put('probe_event',1);put('probe_projection',0);put('probe_myau',0)
   # Fixed evenly spaced and wrap-boundary coordinates; no seed search.
   for x,y in ((8,0),(8,16),(264,208),(520,400),(776,592),(1032,784),(1288,976),(1544,1168),(1800,1360),(2040,1520)):
    for requested,item in ((4,33),(8,34),(12,35)):
     for current in (0,4,8,12):
      for interaction in (0,1):
       word('player_x',x);word('player_y',y);put('facing',2);put('game_vehicle',current);put('probe_item',item);put('probe_interaction',interaction)
       expected=source_use(source,grid,flags,group,x,y,2,interaction,requested,0)
       kind,lines=run()
       assert lines==[0xb2ac,0xb305 if expected[0]else 0xb2e3]
       assert kind==(11 if expected[0]else 0)
       actual=(getword('probe_x'),getword('probe_y'),val('probe_mode'))
       assert actual==(expected[1],expected[2],requested if expected[0]else current),(group,x,y,requested,current,interaction,actual,expected)
       counts['vehicle_contexts']+=1;counts['boarding_successes'if expected[0]else'boarding_failures']+=1
       if requested==current:counts['reboarding_cases']+=1
  put('probe_map',4);put('probe_event',0xb0);put('probe_projection',255);put('probe_interaction',0)
  for item in (45,62):
   put('probe_item',item)
   for cell in range(256):
    put('probe_cell',cell);kind,lines=run(2);eligible=not(cell&128)and((cell&7)==5 or item==62 and(cell&7)==6)
    assert kind==(4 if eligible else 0)and lines==([0xb2ac]if eligible else[0xb2ac,0xb2cd])
    assert val('probe_door')==cell;counts['deferred_door_cases']+=1
    source_request,source_lines=source_deferred(source,item,cell,4,0,0xb0,255,0)
    assert lines==source_lines and source_request==((cell&7)-2 if eligible else 0);counts['original_Z80_deferred_cases']+=1
  put('probe_item',49)
  for map_id in (4,23):
   put('probe_map',map_id)
   for status in (0,1,2,128):
    put('probe_myau',status)
    for interaction in (0,1):
     put('probe_interaction',interaction)
     for event in (0xaf,0xb0):
      put('probe_event',event)
      for projection in (0,255):
       put('probe_projection',projection);kind,lines=run(2);eligible=bool(status)and map_id!=23 and event==0xb0 and projection==255
       assert kind==(8 if eligible else 0)and lines==([0xb743]if eligible else[0xb366,0xb35c]);counts['nuts_contexts']+=1
       source_request,source_lines=source_deferred(source,49,val('probe_cell'),map_id,interaction,event,projection,status)
       assert lines==source_lines and source_request==(7 if eligible else 0);counts['original_Z80_deferred_cases']+=1
  report={'passed':True,'source_sha256':ROM_SHA,'probe_sha256':hashlib.sha256(rom.read_bytes()).hexdigest(),'cartridge':cartridge_header(rom),**counts,'unexpected_UI_or_scene_calls':0,'inventory_and_RNG_unchanged':True,'scope':'Production game_field battle bridge + original native world geometry. Context/position fixtures are explicit; combat controller is separately verified.'}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:emu.stop(save=False)
if __name__=='__main__':main()
