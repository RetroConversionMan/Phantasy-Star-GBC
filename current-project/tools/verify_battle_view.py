#!/usr/bin/env python3
"""Host controller regression plus a separate native banked battle UI probe."""
from pathlib import Path
import hashlib,json,os,re,subprocess
from pyboy import PyBoy
from verify_rom import button,cartridge_header,load_symbols,read_word
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "battle_view.h"
#include "font.h"
#include "audio.h"
#include "battle_scene.h"
#include "field_actions.h"
#include <string.h>
#include <stddef.h>
typedef char battle_layout_check[(sizeof(RPGBattle)==208u&&offsetof(RPGBattle,barrier_break_before)==207u)?1:-1];
RPGState probe_rpg;
FieldAction field_action;
FieldContext probe_item_context;
DungeonState probe_dungeon;
void game_field_battle_item(uint8_t item,uint8_t actor) __banked {field_use_item(&probe_item_context,rpg_find_item(&probe_rpg,item),actor,&field_action);field_action.character=actor;}

uint8_t probe_command,probe_ready,probe_error,probe_kind,probe_result;
uint8_t probe_force_first,probe_actor,probe_recorded,probe_hit_count,probe_hit_blocked;
RPGHit probe_hits[8];
static const uint8_t magic_enemies[]={13,23,47,49,56,57,65,47,56,13};
static const uint16_t palette[]={RGB(2,3,8),RGB(6,10,19),RGB(30,22,8),RGB(30,30,27)};
void main(void){
 uint8_t keys,pressed,last=0,i,was_revealing;FieldContext context;FieldAction action;
 cpu_fast();audio_install();DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;
 set_bkg_palette(7,1,palette);SWITCH_ROM(1);SHOW_BKG;DISPLAY_ON;probe_ready=1;
 while(1){
  vsync();keys=joypad();pressed=keys&~last;was_revealing=battle_view_text_revealing;
  if(probe_command==2){
   memset(&context,0,sizeof context);context.rpg=&probe_rpg;context.chest=&battle_view_battle;
   field_cast(&context,probe_kind==7u?3u:1u,probe_kind==7u?MagicID_Tele:MagicID_Trap,255,&action);
   probe_error=action.error;
   if(action.kind==FIELD_CHEST_OPEN)battle_view_chest_open();else if(action.kind==FIELD_CHEST_PROMPT)battle_view_chest_prompt(0);
   probe_command=0;
  }else if(probe_command){
   rpg_new_game(&probe_rpg);
   if(probe_kind==3){rpg_recruit(&probe_rpg,1);probe_rpg.party[0].level=4;rpg_refresh_stats(&probe_rpg);rpg_rest(&probe_rpg);probe_rpg.party[1].status=0;probe_rpg.party[1].hp=0;}
   if(probe_kind==4){probe_rpg.party[0].level=30;rpg_refresh_stats(&probe_rpg);rpg_rest(&probe_rpg);}
   if(probe_kind>=8u&&probe_kind<=15u){
    probe_actor=probe_kind>=11u&&probe_kind<=13u?2u:3u;
    rpg_recruit(&probe_rpg,probe_actor);probe_rpg.party[probe_actor].level=30;rpg_refresh_stats(&probe_rpg);rpg_rest(&probe_rpg);
    probe_rpg.party[0].status=0;probe_rpg.party[0].hp=0;
    if(probe_actor==2u)probe_rpg.party[2].weapon=probe_kind==11u?9u:probe_kind==12u?11u:13u;
   }
   if((probe_kind>=26u&&probe_kind<=35u)||probe_kind>=53u){
    for(i=1;i<4u;i++)rpg_recruit(&probe_rpg,i);for(i=0;i<4u;i++)probe_rpg.party[i].level=30;rpg_refresh_stats(&probe_rpg);rpg_rest(&probe_rpg);probe_actor=4;
   }
   battle_scene_configure(probe_kind>=57u?14u:probe_kind==15u||probe_kind>=55u?32u:probe_kind>=53u?30u:1u,0);probe_error=battle_view_begin(&probe_rpg,probe_kind>=57u?70u:probe_kind==15u||probe_kind>=55u?73u:probe_kind>=53u?72u:probe_kind>=26u&&probe_kind<=35u?magic_enemies[probe_kind-26u]:1u);rpg_seed_rng(&probe_rpg,1);probe_result=0;
   if(probe_kind>=16u&&probe_kind<=25u){
    static const uint8_t items[10]={ItemID_DungeonKey,ItemID_MiracleKey,ItemID_DungeonKey,ItemID_Nuts,ItemID_Nuts,ItemID_Flash,ItemID_Alsulin,ItemID_Polymaterial,ItemID_Flute,ItemID_Compass};
    probe_actor=0;rpg_add_item(&probe_rpg,items[probe_kind-16u]);
    memset(&probe_item_context,0,sizeof probe_item_context);probe_item_context.rpg=&probe_rpg;probe_item_context.in_battle=1;
    dungeon_enter(&probe_dungeon,0,0x55,0);probe_dungeon.layout[dungeon_sample_position(&probe_dungeon,1u)]=probe_kind==17u?6u:5u;probe_dungeon.light=0;
    probe_item_context.dungeon=&probe_dungeon;probe_item_context.interaction=probe_kind==18u;
    probe_item_context.event_id=0xb0;probe_item_context.projection=255;probe_item_context.map_id=probe_kind==20u?23u:0u;
    probe_rpg.party[1].status=2;
   }
   if(probe_kind>=36u&&probe_kind<=52u){
    static const uint8_t items[]={ItemID_Cola,ItemID_Burger,ItemID_Cola,ItemID_Burger,ItemID_Wand,ItemID_Wand,ItemID_Escaper,ItemID_Escaper,ItemID_MagicHat,ItemID_MagicHat,ItemID_MagicHat,ItemID_MagicHat,ItemID_Sphere,ItemID_Sphere,ItemID_Sphere,ItemID_MagicHat,ItemID_Sphere};
    probe_actor=0;rpg_add_item(&probe_rpg,items[probe_kind-36u]);rpg_add_item(&probe_rpg,ItemID_Alsulin);
    probe_rpg.party[0].hp=probe_kind==38u?95u:probe_kind==39u?250u:7u;probe_rpg.party[0].max_hp=probe_kind==39u?255u:100u;
    probe_rpg.party[0].attack=probe_kind==46u?49u:50u;battle_view_battle.enemies[0].attack=50u;
    battle_view_battle.run_chance=probe_kind==41u||probe_kind==43u?0u:1u;battle_view_battle.escape_blocked=0;
    battle_view_battle.enemy_flags=probe_kind==44u||probe_kind==48u?0x80u:probe_kind==45u||probe_kind==46u||probe_kind==49u?0x40u:probe_kind==51u||probe_kind==52u?0xc0u:0u;
   }
   if(probe_kind==53u)rpg_add_item(&probe_rpg,ItemID_Crystal);
   if(probe_kind>=55u&&probe_kind<=56u){battle_view_battle.enemies[0].attack=probe_kind==55u?255u:0u;for(i=0;i<4u;i++)probe_rpg.party[i].defense=probe_kind==55u?0u:255u;}
   probe_force_first=probe_kind>=8u;probe_recorded=probe_hit_count=0;
   if(probe_kind>=8u&&probe_kind<=15u){
    battle_view_battle.count=probe_kind==14u?1u:probe_actor==2u?8u:2u;
    for(i=0;i<8u;++i){battle_view_battle.enemies[i].status=i<battle_view_battle.count; battle_view_battle.enemies[i].hp=i<battle_view_battle.count?(probe_kind==14u?1u:255u):0u;}
   }
   if(probe_kind==2){
    for(i=0;i<23;i++)rpg_add_item(&probe_rpg,ItemID_LaconiaPot);rpg_add_item(&probe_rpg,ItemID_Cola);
    battle_view_battle.outcome=RPG_VICTORY;battle_view_battle.money_reward=20;battle_view_battle.item_reward=ItemID_Flute;battle_view_battle.trap_chance=0;battle_view_state=BVIEW_EXECUTE;
   }
   if(probe_kind==4)for(i=0;i<battle_view_battle.count;i++)battle_view_battle.enemies[i].hp=1;
   if(probe_kind==5){probe_rpg.party[0].hp=255;probe_rpg.party[0].max_hp=255;probe_rpg.party[0].defense=255;for(i=0;i<battle_view_battle.count;i++){battle_view_battle.enemies[i].hp=255;battle_view_battle.enemies[i].max_hp=255;}}
   if(probe_kind==6u){
    for(i=1;i<4;i++)rpg_recruit(&probe_rpg,i);for(i=0;i<4;i++)probe_rpg.party[i].level=30;rpg_refresh_stats(&probe_rpg);rpg_rest(&probe_rpg);
    battle_view_chest_begin(&probe_rpg,0,10,240);
   }
   if((probe_kind>=26u&&probe_kind<=35u)||probe_kind>=53u){
    for(i=0;i<4u;i++)probe_rpg.party[i].hp=255;
    if(probe_kind==33u||probe_kind==34u)battle_view_battle.barrier=0x86;
    if(probe_kind==35u){probe_rpg.party[0].hp=1;for(i=1;i<4u;i++){probe_rpg.party[i].hp=0;probe_rpg.party[i].status=0;}}
   }
   if(probe_kind>=57u){battle_view_battle.outcome=probe_kind==57u?RPG_VICTORY:RPG_DEFEAT;battle_view_battle.money_reward=battle_view_battle.item_reward=0;probe_force_first=0;battle_view_state=BVIEW_EXECUTE;if(probe_kind==58u)for(i=0;i<4u;i++){probe_rpg.party[i].hp=probe_rpg.party[i].status=0;}}
   probe_command=0;
  }else if(battle_view_state)probe_result=battle_view_tick(keys,pressed);
  if(probe_force_first&&battle_view_state==BVIEW_EXECUTE){
   for(i=0;i<12u;++i)battle_view_battle.turn_order[i]=255u;
   battle_view_battle.turn_order[0]=probe_actor;battle_view_battle.turn_cursor=0;probe_force_first=0;if((probe_kind>=26u&&probe_kind<=35u)||probe_kind>=53u)rpg_seed_rng(&probe_rpg,2);
  }
  if(probe_kind>=8u&&!probe_recorded&&(battle_view_state==BVIEW_PLAYER_WEAPON||battle_view_state==BVIEW_ENEMY_MAGIC||battle_view_state==BVIEW_BOSS_ANIMATION)){
   probe_hit_blocked=battle_view_battle.hit_blocked;probe_hit_count=battle_view_battle.hit_count;memcpy(probe_hits,battle_view_battle.hits,sizeof probe_hits);probe_recorded=1;
  }
  if(!was_revealing)last=keys;
  if(CURRENT_BANK!=1)probe_error|=128;
 }
}
'''
def main():
 out=ROOT/'build/verification/battle-view';out.mkdir(parents=True,exist_ok=True)
 host_sources=['chest_motion.c','field_actions.c','dungeon.c','dungeon_data.c','rpg.c','rpg_data.c','battle.c','battle_view.c','dialogue.c','dialogue_data.c','dialogue_text_09.c','dialogue_text_10.c','bank_io.c']
 binary=out/'controller-test'
 subprocess.run([os.environ.get('CC','cc'),'-std=c99','-Wall','-Wextra','-Werror','-Wno-unknown-pragmas','-fsanitize=address,undefined','-Isrc',*[str(ROOT/'src'/p) for p in host_sources],str(ROOT/'tests/test_battle_view.c'),'-o',str(binary)],cwd=ROOT,check=True)
 output=subprocess.check_output([str(binary)],text=True,cwd=ROOT);match=re.fullmatch(r'Battle controller checks passed: (\d+)\n',output);assert match,output
 (out/'main.c').write_text(MAIN);rom=out/'battle-view-probe.gbc'
 src=[out/'main.c']+[ROOT/'src'/p for p in host_sources+['ui.c','font.c','assets_sprites.c','dungeon_graphics.c','battle_scene.c','battle_scene_data.c','battle_motion.c','battle_weapon.c','enemy_magic.c','boss_motion.c','gold_scene.c','gold_scene_bank_123.c','palette_commit.c','battle_animation_data.c','scene.c','scene_data.c','chest_art.c','scene_actor.c','scene_actor_data.c','audio.c','audio_irq.c','audio_data.c','audio_tables.c','audio_low_62.c','audio_low_63.c']]+sorted((ROOT/'src').glob('battle_scene_bank_*.c'))+sorted((ROOT/'src').glob('battle_animation_bank_*.c'))+sorted((ROOT/'src').glob('scene_bank_*.c'))+sorted((ROOT/'src').glob('scene_actor_bank*.c'))+sorted((ROOT/'src').glob('dungeon_graphics_*.c'))+sorted((ROOT/'src').glob('weapon_bank_*.c'))+sorted((ROOT/'src').glob('enemy_magic_bank_*.c'))+sorted((ROOT/'src').glob('boss_effects_bank_*.c'))
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),*map(str,src)],check=True,cwd=ROOT)
 syms=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 report={'host_checks':int(match[1]),'native_checks':[],'injected_fixtures':[],'screenshots':[]}
 def val(name):return e.memory[syms[name]]
 def state():return val('battle_view_state')
 def press(key):button(e,key,8,30)
 def wait(condition,reason,limit=600):
  for _ in range(limit):
   if condition():return
   e.tick(1)
  raise AssertionError((reason,state(),hex(e.register_file.PC),val('probe_error')))
 def fixture(kind):
  e.memory[syms['probe_kind']]=kind;e.memory[syms['probe_command']]=1
  wait(lambda:not val('probe_command'),'fixture');e.tick(60);assert not val('probe_error'),val('probe_error')
 def drain():
  for _ in range(600):
   if state() in (10,11,13,14,15,16,17,18,19):e.tick(1);continue
   if state()!=5:e.tick(2);return
   if val('battle_view_text_revealing'):e.tick(1)
   else:press('a')
  raise AssertionError('Message loop')
 def shot(name):
  e.tick(5);path=out/(name+'.png');e.screen.image.save(path);report['screenshots'].append(str(path))
 try:
  e.tick(200);assert val('probe_ready')==1
  fixture(1);assert state()==1;shot('command');
  window=0x9c00 if e.memory[0xff40]&64 else 0x9800
  assert bytes(e.memory[0,window:window+4])==bytes(ord(c)-32 for c in 'ALIS')
  assert bytes(e.memory[0,window+65:window+71])==bytes(ord(c)-32 for c in 'ATTACK')
  report['native_checks'].append('Bank30 menu strings copied to WRAM before bank1 UI call; ALIS and ATTACK VRAM tiles match expected font IDs')
  for _ in range(4):press('right')
  press('a');drain();wait(lambda:val('probe_result')==3,'run result');assert not val('probe_error')
  report['native_checks'].append('Native bank30 controller calls bank18 battle, bank4 RNG/stats, bank8 dialogue, bank31 art and restores caller bank1; Run exits')
  fixture(5);button(e,'a',1,1)
  for _ in range(200):
   if state()==11:break
   if state()==5:button(e,'a',1,1)
   else:e.tick(1)
  assert state()==11
  motion_frames=0
  while state()==11:
   e.tick(1);motion_frames+=1;assert motion_frames<80
  assert 1<=motion_frames<=35,(motion_frames,state());report['observed_physical_animation_frames']=motion_frames
  report['native_checks'].append('Original Sworm physical motion and10-frame hit hold execute, continue automatically after the source HP update, and restore caller bank1; observed duration includes input/render alignment, exact actor cadence is tested against Z80 separately')
  report['injected_fixtures'].append('HighHP/defense Alis and255HP Sworms force observation of an ordinary enemy physical animation; no campaign reward claim')
  fixture(3);press('right');press('a');assert state()==2;shot('spells');press('a');assert state()==4;press('down');press('a');shot('dead-target');drain();assert state()==4
  assert e.memory[syms['probe_rpg']+2]==4
  report['native_checks'].append('Heal target selection rejects dead Myau with original dialogue and spends no MP')
  fixture(4);weapon_frames=0;hit_frames=0
  for _ in range(1500):
   if state()==9:break
   if state()==15:weapon_frames+=1
   if state()==14:hit_frames+=1
   if state() in [1,5,6]:button(e,'a',1,1)
   else:e.tick(1)
  assert state()==9 and val('probe_result')==1
  assert weapon_frames and hit_frames,(weapon_frames,hit_frames)
  report['observed_player_weapon_frames']=weapon_frames;report['observed_player_hit_frames']=hit_frames
  report['native_checks'].append('Original unarmed source weapon actor executes before10-frame enemy-hit palette feedback; visible effect/HP resolution returns to genuine battle reward flow')
  assert read_word(e,syms['probe_rpg']+3)>0 and read_word(e,syms['probe_rpg']+90)>0
  report['native_checks'].append('Native physical battle resolves to victory, awards EXP and opens source money chest')
  report['injected_fixtures'].append('Level30 Alis and1HP Sworms shorten isolated combat test; no campaign reward claim')
  fixture(2);drain();assert state()==6;press('a');drain();assert state()==6;press('a');drain();assert state()==7;shot('full-inventory');press('a');shot('protected-item');drain();assert state()==7
  press('b');drain();assert state()==6;press('right');press('a');drain();assert state()==6;press('right');press('a');drain();assert state()==7
  for _ in range(23):press('down')
  press('a');drain();wait(lambda:val('probe_result')==1,'replacement result')
  assert state()==9 and e.memory[syms['probe_rpg']+64+23]==38 and e.memory[syms['probe_rpg']+88]==24
  assert read_word(e,syms['probe_rpg']+90)==20 and not val('probe_error')
  report['native_checks'].append('Chest full-inventory prompts: protected replacement refused, cancel repeats, abandon declined, valid replacement succeeds without duplicate money')
  report['injected_fixtures'].append('Victory with20meseta/Flute reward and24 items exercises native chest overflow; source inventory data unchanged')
  fixture(6);drain();assert state()==6 and val('battle_view_chest_pending')
  press('right');press('a');assert state()==12 and val('probe_result')==254
  rpg=syms['probe_rpg'];seed=read_word(e,rpg+92);hp=e.memory[rpg+1];mp=e.memory[rpg+50]
  e.memory[syms['probe_kind']]=7;e.memory[syms['probe_command']]=2;wait(lambda:not val('probe_command'),'Tele native bridge');drain()
  assert state()==6 and read_word(e,rpg+92)==seed and e.memory[rpg+50]==mp-4 and not val('probe_error')
  press('right');press('a');assert state()==12
  mp=e.memory[rpg+18];e.memory[syms['probe_kind']]=6;e.memory[syms['probe_command']]=2;wait(lambda:not val('probe_command'),'Trap native bridge')
  assert state()==13 and e.memory[rpg+18]==mp-2 and not val('probe_error')
  wait(lambda:state()!=13,'disarmed opening animation',100);assert e.memory[rpg+1]==hp and read_word(e,rpg+90)==10 and read_word(e,rpg+92)==seed
  drain();assert state()==12 and not val('battle_view_chest_pending') and val('battle_view_field_menu_pending')
  report['native_checks'].append('Closed chest decline returns254 with preparation retained; native field Tele spends4MP and reopens question, Trap spends2MP and disarms,49-frame lid opening grants10meseta without HP loss or RNG reroll')
  report['injected_fixtures'].append('Level30 recruited party, forced party-trap chest and direct field-menu bridge API calls verify native cross-bank chest magic; full main-menu controller route is a separate integration test')
  # Real free-running window writes: one source glyph per visible frame;
  # a held button during typing must not collapse text into a complete page.
  e.memory[syms['probe_kind']]=6;e.memory[syms['probe_command']]=1
  wait(lambda:not val('probe_command'),'stream fixture')
  assert val('battle_view_text_revealing')
  window=0x9c00 if e.memory[0xff40]&64 else 0x9800
  glyph_masks={}
  for code in range(64):
   tile=bytes(e.memory[1,0x9000+code*16:0x9010+code*16])
   glyph_masks[tuple(bool((tile[y*2]|tile[y*2+1])>>(7-x)&1)for y in range(8)for x in range(8))]=code
  def text_cells():
   pixels=e.screen.image;bg=pixels.getpixel((0,112));result=[]
   for row in range(2):
    for col in range(18):
     mask=tuple(pixels.getpixel((8+col*8+x,112+row*8+y))!=bg for y in range(8)for x in range(8))
     result.append(glyph_masks.get(mask,255))
   return bytes(result)
  previous=text_cells();updates=[];frames=0;e.button_press('a')
  while read_word(e,syms['battle_view_dialogue_id'])==0xbd97:
   e.tick(1);frames+=1
   current=text_cells();changed=sum(a!=b for a,b in zip(previous,current));assert changed<=1,(frames,changed,previous,current)
   updates.append(changed);previous=current;assert frames<80
  e.button_release('a');assert sum(c!=0 for c in previous)==22,(frames,previous)
  report['native_text_stream']={'dialogue':'BD97','observed_frames':frames,'changed_cells_per_frame':updates,'final_nonspace_glyphs':22,'held_A_did_not_skip':True}
  drain();assert state()==6
  report['native_deferred_item_cases']=[]
  for kind,expected in ((16,[0xb2ac]),(17,[0xb2ac]),(18,[0xb366,0xb569]),(19,[0xb743]),(20,[0xb366,0xb35c]),(21,[0xb366,0xb35c]),(22,[0xb366,0xb35c]),(23,[0xb366,0xb35c]),(24,[0xb2ac,0xb322]),(25,[0xb366,0xb35c])):
   fixture(kind);rpg=syms['probe_rpg'];seed=None
   press('right');press('right');press('a');assert state()==3
   e.button_press('a');e.tick(1);e.button_release('a')
   seen=[]
   for frame in range(1200):
    if state()==5:
     current=read_word(e,syms['battle_view_dialogue_id'])
     if not seen or seen[-1]!=current:seen.append(current)
     if seed is None:seed=read_word(e,rpg+92)
     assert read_word(e,rpg+92)==seed
     if val('battle_view_text_revealing'):e.tick(1)
     else:press('a')
    elif state()==1 and seen:break
    else:e.tick(1)
   assert frame<1199 and seen==expected,(kind,seen,state())
   assert e.memory[rpg+88]==1 and e.memory[syms['probe_dungeon']+8+0x45]==(6 if kind==17 else 5)
   assert val('field_action')==(4 if kind in (16,17)else 8 if kind==19 else 0)
   report['native_deferred_item_cases'].append({'fixture':kind,'dialogue_ids':[hex(x)for x in seen],'inventory_retained':True,'battle_continued':True,'door_cell_unchanged':True,'RNG_unchanged_during_text':True})
  report['injected_fixtures'].append('Battle item fixtures supply source dungeon/context fields through an isolated bridge; deferred key/Nuts requests never invoke field actions. Production bridge/world geometry has a separate probe.')
  report['native_enemy_magic_cases']=[]
  actor_counts={name:0 for name in ('battle_motion_tick','enemy_magic_tick','battle_scene_flash_party')}
  def count_actor(name):actor_counts[name]+=1
  for name in actor_counts:
   address=syms[name];e.hook_register(address>>16,address&65535,count_actor,name)
  source_motion=json.loads((ROOT/'build/verification/enemy-magic/motion-report.json').read_text())
  actor_lengths={r['enemy']:r['frames_excluding_effect_pause']for r in source_motion['movement']}
  spell_length=source_motion['effects'][0]['frames']
  enemies=(13,23,47,49,56,57,65,47,56,13)
  for kind in range(26,36):
   fixture(kind)
   for name in actor_counts:actor_counts[name]=0
   for _ in range(1 if kind==35 else 4):press('a')
   wait(lambda:val('probe_recorded'),'enemy spell begins')
   seed=read_word(e,syms['probe_rpg']+92);trace=bytes(e.memory[syms['probe_hits']:syms['probe_hits']+val('probe_hit_count')*3]);blocked=val('probe_hit_blocked');frames=0;messages=[]
   while state()not in(1,9):
    assert read_word(e,syms['probe_rpg']+92)==seed,(kind,state(),'presentation advanced RNG')
    if state()==5:
     did=read_word(e,syms['battle_view_dialogue_id'])
     entry=(val('battle_view_hit_cursor'),did)
     if not messages or messages[-1]!=entry:messages.append(entry)
     if val('battle_view_text_revealing'):e.tick(1)
     else:press('a')
    else:e.tick(1)
    frames+=1;assert frames<3000,(kind,state(),messages)
   assert trace and val('battle_view_hit_cursor')==val('probe_hit_count')
   if kind==35:assert state()==9 and val('battle_view_result')==2 and any(did==0xb728 for hit,did in messages)
   else:assert state()==1
   count=val('probe_hit_count');enemy=enemies[kind-26]
   assert count==(1 if kind==35 else 4 if enemy in(56,65)else 2)
   assert blocked==(3 if kind==33 else 15 if kind==34 else 0)
   assert actor_counts=={'battle_motion_tick':count*actor_lengths[enemy],'enemy_magic_tick':count*spell_length,'battle_scene_flash_party':(count-blocked.bit_count())*10},(kind,actor_counts)
   assert sum(did==0xb1b2 for hit,did in messages)==blocked.bit_count()
   report['native_enemy_magic_cases'].append({'fixture':kind,'source_verified_actor_call_counts':dict(actor_counts),'hits':val('probe_hit_count'),'blocked_mask':blocked,'trace':list(trace),'observed_loop_iterations':frames,'messages':[{'hit':hit,'dialogue':hex(did)}for hit,did in messages],'RNG_unchanged_during_presentation':True})
  # Capture actual banked dialogue/audio function entry, preserving within-frame
  # ordering. The six-row source close is an explicit six-clock controller state.
  report['native_core_item_timelines']=[]
  timeline=[];capture=[False]
  def record_item(kind):
   if capture[0]:
    sp=e.register_file.SP
    value=read_word(e,sp+8) if kind=='text' else e.memory[sp+6]
    timeline.append((kind,value))
  for name,kind in (('dialogue_open','text'),('audio_command','sound')):
   address=syms[name];e.hook_register(address>>16,address&65535,record_item,kind)
  from audit_battle_item_timeline import trace as source_trace,tokens as source_tokens,ROM as source_rom,ADDR as source_address,TEXT as source_text
  core_cases=[('Cola',{}),('Burger',{}),('Cola',{'hp':95}),('Burger',{'hp':250,'maxhp':255}),('Wand',{}),('Wand',{'chance':0}),('Escaper',{}),('Escaper',{'chance':0}),('MagicHat',{'flags':128}),('MagicHat',{'flags':64}),('MagicHat',{'flags':64,'attack':49}),('MagicHat',{'flags':0}),('Sphere',{'flags':128}),('Sphere',{'flags':64}),('Sphere',{'flags':0}),('MagicHat',{'flags':192}),('Sphere',{'flags':192})]
  reply_sets={monster:{source_text[int.from_bytes(source_rom[source_address('LABEL_1B73'if monster else'LABEL_198A')+i*2:][:2],'little')]for i in range(10 if monster else 9)}for monster in(False,True)}
  for kind,(item,options) in enumerate(core_cases,36):
   fixture(kind);press('right');press('right');press('a');assert state()==3
   timeline.clear();capture[0]=True;e.button_press('a');e.tick(1);e.button_release('a');close_clock=None;close_elapsed=0;seed=None
   for frame in range(1600):
    if state()==18:
     if close_clock is None:
      timeline.append(('close',None));close_clock=val('audio_clock')
      # No elapsed clock must mean no close progress; ordinary IRQ then releases.
     close_elapsed=(val('audio_clock')-close_clock)&255
    if state()in(1,9)and timeline:break
    if state()==5:
     if seed is None:seed=read_word(e,syms['probe_rpg']+92)
     assert read_word(e,syms['probe_rpg']+92)==seed
     if val('battle_view_text_revealing'):e.tick(1)
     else:button(e,'a',1,1)
    else:e.tick(1)
   capture[0]=False;assert frame<1599 and close_clock is not None,(item,state(),timeline)
   original=source_trace(item,**options);expected=[(a,int(b,16)if b else None)for a,b in source_tokens(original)]
   actual=timeline[:-1]if timeline[-1]==('sound',0xd8)else timeline
   if item in('MagicHat','Sphere')and any(a=='text'and b==0xb132 for a,b in expected):
    reply_index=3 if options.get('flags',128)&64 else 2
    assert actual[reply_index][1]in reply_sets[bool(options.get('flags',128)&64)],(kind,actual,reply_sets)
    expected[reply_index]=actual[reply_index]
   assert actual==expected,(kind,item,actual,expected)
   teardown=15 if original['final']['actor'] in(5,6) else 0
   # Entry can be sampled one frame late. Native DISPLAY_OFF also waits for
   # VBlank before the final scene clear, adding at most one upload boundary.
   assert 4+teardown<=close_elapsed<=6+teardown+bool(teardown),(kind,close_elapsed)
   assert e.memory[syms['probe_rpg']+88]==original['final']['count']
   if item in('Cola','Burger'):assert e.memory[syms['probe_rpg']+1]==original['final']['hp']
   assert state()==(9 if original['final']['actor']in(5,6)else 1),(item,state())
   report['native_core_item_timelines'].append({'fixture':kind,'item':item,'source_inputs':options,'events':[(a,hex(b)if b is not None else None)for a,b in timeline],'close_clock_span_sampled':close_elapsed,'state_commit_timing':'kernel precomputed; final HP/inventory checked','random_reply':'original branch/table; native RNG refresh adaptation retained'})
  report['injected_fixtures'].append('17 core-item fixtures set source HP/maxHP, flags/run gates and force Alis first; actual item menu and rules execute. Original Z80 traces supply expected message/audio/close order; reply chosen from original human/monster table, not assumed identical Z80 R timing.')
  report['native_boss_cases']=[]
  boss_counts={name:0 for name in ('boss_motion_tick','battle_scene_boss_patch')}
  boss_clocks=[]
  def count_boss(name):
   boss_counts[name]+=1
   if name=='boss_motion_tick':boss_clocks.append(val('audio_clock'))
  for name in boss_counts:
   address=syms[name];e.hook_register(address>>16,address&65535,count_boss,name)
  source_boss=json.loads((ROOT/'build/verification/boss-motion/report.json').read_text())['cases']
  for kind in range(53,57):
   fixture(kind)
   for name in boss_counts:boss_counts[name]=0
   boss_clocks.clear()
   actor_counts['battle_scene_flash_party']=0
   for _ in range(4):press('a')
   wait(lambda:val('probe_recorded'),'boss animation begins')
   seed=read_word(e,syms['probe_rpg']+92);trace=bytes(e.memory[syms['probe_hits']:syms['probe_hits']+val('probe_hit_count')*3]);messages=[]
   for frame in range(4000):
    assert read_word(e,syms['probe_rpg']+92)==seed,(kind,state(),'boss presentation RNG')
    if state()in(1,9):break
    if state()==5:
     did=read_word(e,syms['battle_view_dialogue_id']);entry=(val('battle_view_hit_cursor'),did)
     if not messages or messages[-1]!=entry:messages.append(entry)
     if val('battle_view_text_revealing'):e.tick(1)
     else:press('a')
    else:e.tick(1)
   assert frame<3999 and trace and val('battle_view_hit_cursor')==val('probe_hit_count')
   hits=[tuple(trace[i:i+3])for i in range(0,len(trace),3)];expected_updates=sum((source_boss[target]['updates']+1)if kind<55 else 170 for target,damage,hp in hits)
   assert boss_counts=={'boss_motion_tick':expected_updates,'battle_scene_boss_patch':0 if kind<55 else 4},(kind,boss_counts,hits)
   assert all((b-a)&255 for a,b in zip(boss_clocks,boss_clocks[1:])),(kind,'multiple actor updates in one IRQ clock',boss_clocks)
   expected_flashes=sum(10 for target,damage,hp in hits if kind<55 or damage)
   assert actor_counts['battle_scene_flash_party']==expected_flashes,(kind,actor_counts,hits)
   assert all(e.memory[0xfe00+i*4]==0 for i in range(40)),(kind,'boss actor not cleared')
   report['native_boss_cases'].append({'fixture':kind,'enemy':72 if kind<55 else 73,'crystal':kind==53,'hits':hits,'source_verified_actor_calls':dict(boss_counts),'actor_clock_deltas':[(b-a)&255 for a,b in zip(boss_clocks,boss_clocks[1:])],'flash_phases':expected_flashes,'messages':[(hit,hex(did))for hit,did in messages],'RNG_unchanged_during_presentation':True})
  report['injected_fixtures'].append('Four boss actor fixtures use level30 party/255HP and forced enemy initiative. Lassic with/without Crystal and Dark Falz high/zero attack isolate real rule traces; no campaign completion claim.')
  gold=json.loads((ROOT/'assets/gold-scene/manifest.json').read_text());gold_data=(ROOT/'assets/gold-scene/scene.bin').read_bytes();report['native_gold_outcomes']=[]
  for kind in(57,58):
   timeline.clear();capture[0]=True;fixture(kind);capture[0]=False
   palette=[]
   for index in range(56):e.memory[0xff68]=index;palette.append(e.memory[0xff69])
   assert bytes(palette)==gold_data[gold['palette_offset']:gold['palette_offset']+56]
   if kind==58:
    palette=[]
    for index in range(64):e.memory[0xff6a]=index;palette.append(e.memory[0xff6b])
    assert bytes(palette)==b'\0\x7c'*32
   else:assert all(e.memory[0xfe00+i*4]==0 for i in range(40))
   sounds=[value for event,value in timeline if event=='sound'];assert sounds[:3 if kind==57 else 2]==([0x89,0xaf,0xd8]if kind==57 else[0x89,0x94]),(kind,sounds)
   shot('gold-victory'if kind==57 else'gold-defeat');report['native_gold_outcomes'].append({'fixture':kind,'outcome':'victory'if kind==57 else'defeat','BG_source_high_indices_blue':True,'OBJ_blue_or_cleared':True,'audio_commands':[hex(v)for v in sounds]})
  report['injected_fixtures'].append('Two forced GoldDragon outcomes with actual source scene14 verify blue BG/OBJ and89/AF/D8 or89/94 order; these are palette/outcome fixtures, not earned victories.')
  player_counts={name:0 for name in('battle_weapon_tick','battle_scene_flash_enemy')}
  def count_player(name):player_counts[name]+=1
  for name in player_counts:
   address=syms[name];e.hook_register(address>>16,address&65535,count_player,name)
  report['native_multi_hit_cases']=[]
  for kind,spell_option,expected_hits,cost in ((8,0,2,4),(9,2,3,12),(10,4,2,16),(11,None,8,0),(12,None,8,0),(13,None,8,0),(14,0,1,4),(15,4,1,16)):
   fixture(kind);actor=val('probe_actor');rpg=syms['probe_rpg'];mp=e.memory[rpg+actor*16+2]
   for name in player_counts:player_counts[name]=0
   if spell_option is not None:
    press('right');press('a');assert state()==2
    for _ in range(spell_option):press('down')
   button(e,'a',1,1);wait(lambda:state()==15,'multi-hit begins');assert val('probe_recorded')
   assert val('probe_hit_count')==expected_hits,(kind,val('probe_hit_count'))
   seed=read_word(e,rpg+92);epochs=0;previous=0;duration=0
   while state()in(15,14):
    if state()==15 and previous!=15:epochs+=1
    previous=state();e.tick(1);duration+=1
    assert duration<700 and read_word(e,rpg+92)==seed,(kind,duration,'presentation RNG')
   assert epochs==expected_hits and val('battle_view_hit_cursor')==expected_hits,(kind,epochs,val('battle_view_hit_cursor'))
   assert e.memory[rpg+actor*16+2]==mp-cost and not val('probe_error')
   wait(lambda:state()!=8,'automatic source HP continuation')
   assert state()in(1,5,10,18),(kind,state()) # Victory now restores source rows before the jingle hold.
   trace=bytes(e.memory[syms['probe_hits']:syms['probe_hits']+3*expected_hits])
   if kind==14:assert trace==bytes((4,1,0))
   if kind==15:assert trace[0]==4
   if 11<=kind<=13:
    amount=(5,10,20)[kind-11]
    assert trace==b''.join(bytes((4+i,amount,255-amount))for i in range(8))
   source_effect=16 if kind in(8,14)else 18 if kind==9 else 17 if kind in(10,15)else(9,11,13)[kind-11]
   row=json.loads((ROOT/'assets/weapon-effects/manifest.json').read_text())['effects'][source_effect]
   expected_duration=expected_hits*((row[3]-row[2]-1)*(row[1]+1)+3+10)+1
   expected_calls=expected_hits*((row[3]-row[2]-1)*(row[1]+1)+3)
   assert player_counts=={'battle_weapon_tick':expected_calls,'battle_scene_flash_enemy':expected_hits*10},(kind,player_counts,expected_calls)
   assert duration>=expected_duration,(kind,duration,expected_duration,'compressed source timeline')
   report['native_multi_hit_cases'].append({'fixture':kind,'hits':epochs,'observed_frames':duration,'source_frames_without_atomic_upload_overhead':expected_duration,'atomic_upload_overhead':duration-expected_duration,'source_verified_actor_calls':dict(player_counts),'trace':list(trace),'MP_spent':cost,'RNG_unchanged_during_presentation':True})
  report['native_checks'].append('Fire2/Wind3/Thunder2 and all3guns8targets animate every actual hit automatically, withMPchargedonce and no presentation RNG; earlykillFire stopsafter1 and DarkFalzThunder hitsfirstlivingrecordonly')
  report['injected_fixtures'].append('Level30 soleNoah/Odin, forced255HP enemy groups and initiative override isolate8offensive-action sequences; native menus choose real learned spells/equipped weapons. These are presentation fixtures, not campaign progression.')
  report['inputs_sha256']={p:hashlib.sha256((ROOT/'src'/p).read_bytes()).hexdigest() for p in host_sources}
  report.update(passed=True,header=cartridge_header(rom),probe_sha256=hashlib.sha256(rom.read_bytes()).hexdigest(),scope='Separate native controller/art/rules probe, not integrated world encounter or campaign test')
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 except Exception:
  print('Native failure state',state(),'dialogue',hex(read_word(e,syms['battle_view_dialogue_id'])),'typing',val('battle_view_text_revealing'),'PC',hex(e.register_file.PC));raise
 finally:e.stop(False)
if __name__=='__main__':main()
