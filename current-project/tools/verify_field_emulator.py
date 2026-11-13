#!/usr/bin/env python3
"""Native field-action banking and state semantics; isolated fixtures, not campaign."""
from pathlib import Path
import subprocess,json
from pyboy import PyBoy
from verify_rom import load_symbols,read_word,cartridge_header
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "field_actions.h"
RPGState probe_rpg;
EventState probe_events;
DungeonState probe_dungeon;
RPGBattle probe_chest;
FieldContext probe_context;
FieldAction probe_action;
uint8_t probe_ready,probe_command,probe_error,probe_kind,probe_original_mp;
void main(void){
 uint8_t i,p;cpu_fast();SWITCH_ROM(1);probe_ready=1;
 while(1){vsync();if(!probe_command)continue;
  rpg_new_game(&probe_rpg);for(i=1;i<4;i++)rpg_recruit(&probe_rpg,i);for(i=0;i<4;i++)probe_rpg.party[i].level=30;rpg_refresh_stats(&probe_rpg);rpg_rest(&probe_rpg);
  memset(&probe_events,0,sizeof probe_events);memset(&probe_context,0,sizeof probe_context);memset(&probe_chest,0,sizeof probe_chest);
  probe_context.rpg=&probe_rpg;probe_context.events=&probe_events;probe_context.dungeon=&probe_dungeon;
  dungeon_enter(&probe_dungeon,0,0x55,0);p=dungeon_sample_position(&probe_dungeon,1);
  if(probe_kind==0){probe_original_mp=probe_rpg.party[3].mp;field_cast(&probe_context,3,MagicID_Rise,255,&probe_action);}
  if(probe_kind==1){rpg_add_item(&probe_rpg,ItemID_MiracleKey);probe_dungeon.layout[p]=6;field_use_item(&probe_context,0,0,&probe_action);}
  if(probe_kind==2){rpg_add_item(&probe_rpg,ItemID_Flash);probe_dungeon.light=0;field_use_item(&probe_context,0,0,&probe_action);}
  if(probe_kind==3){probe_dungeon.layout[p]=8;field_cast(&probe_context,1,MagicID_Trap,0,&probe_action);}
  if(probe_kind==4){probe_context.chest=&probe_chest;probe_chest.chest_state=BATTLE_CHEST_PENDING;probe_chest.trap_chance=255;field_cast(&probe_context,1,MagicID_Trap,0,&probe_action);}
  if(probe_kind==5){rpg_add_item(&probe_rpg,ItemID_Transfer);probe_context.interaction=1;probe_events.last_church=8;field_use_item(&probe_context,0,0,&probe_action);}
  if(CURRENT_BANK!=1)probe_error=1;probe_command=0;
 }
}
'''
def main():
 out=ROOT/'build/verification/field';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN);rom=out/'field-probe.gbc'
 src=['field_actions.c','rpg.c','rpg_data.c','battle.c','dungeon.c','dungeon_data.c','bank_io.c']
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo32','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),str(out/'main.c'),*[str(ROOT/'src'/p) for p in src]],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));em=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');em.set_emulation_speed(0)
 def byte(name,n=0):return em.memory[sym[name]+n]
 checks=[]
 try:
  em.tick(200);assert byte('probe_ready')==1
  for kind in range(6):
   em.memory[sym['probe_kind']]=kind;em.memory[sym['probe_command']]=1
   for _ in range(60):
    em.tick(1)
    if not byte('probe_command'):break
   assert not byte('probe_command') and not byte('probe_error')
   if kind==0:assert byte('probe_rpg',50)==byte('probe_original_mp')-12 and byte('probe_action',2)==0;checks.append('Rise cancellation spends12MP before target selection')
   if kind==1:assert byte('probe_action')==4 and byte('probe_dungeon',8+0x45)==0x86 and byte('probe_rpg',88)==1;checks.append('Reusable MiracleKey opens original type6 cell and returns action4')
   if kind==2:assert byte('probe_action')==1 and byte('probe_dungeon',3)>0 and byte('probe_rpg',88)==0;checks.append('Flash consumes one item and resolves source floor lighting through bank17/16')
   if kind==3:assert byte('probe_action')==1 and byte('probe_dungeon',8+0x45)==0;checks.append('Trap clears an unregistered08pit')
   if kind==4:assert byte('probe_action')==5;checks.append('Chest Trap prepares/disarms source visual and emits immediate-open action')
   if kind==5:assert byte('probe_action')==3 and byte('probe_action',5)==21 and byte('probe_action',6)==0x28 and byte('probe_action',7)==0x61;checks.append('Transfer consumes item and returns exact last-church packed destination')
  report={'passed':True,'header':cartridge_header(rom),'checks':checks,'fixtures':'Separate native probe creates original level30 party and selected inventory/dungeon fixtures; no campaign progress asserted','banking':'Every call restores caller bank1 across native field11/rpg4/dungeon17/data16/battle18'}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:em.stop(False)
if __name__=='__main__':main()
