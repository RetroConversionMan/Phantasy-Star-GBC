#include "battle_view.h"
#include "audio.h"
#include "field_actions.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#define A 16u
#define B 32u
#define RIGHT 1u
#define DOWN 8u
static unsigned checks;
volatile uint8_t audio_clock;
static uint8_t last_audio;
FieldAction field_action;
static FieldContext item_context;
void game_field_battle_item(uint8_t item,uint8_t actor){field_use_item(&item_context,rpg_find_item(item_context.rpg,item),actor,&field_action);field_action.character=actor;}

void audio_command(uint8_t value){last_audio=value;}
uint8_t audio_battle_track(uint8_t enemy){return enemy==73?0:enemy==72?0x92:0x89;}
uint8_t audio_enemy_effect(uint8_t enemy){(void)enemy;return 0xc0;}
static uint8_t tick(uint8_t keys,uint8_t pressed){++audio_clock;return battle_view_tick(keys,pressed);}
#define CHECK(x) do{++checks;if(!(x)){fprintf(stderr,"FAIL %d: %s [view=%u dialogue=%x actor=%u choice=%u]\n",__LINE__,#x,battle_view_state,battle_view_dialogue_id,battle_view_actor,battle_view_choice);assert(x);}}while(0)
static void press(uint8_t button){tick(button,button);}
static void drain(void){unsigned i=0;while((battle_view_state==BVIEW_MESSAGE||battle_view_state==BVIEW_AUDIO_WAIT||battle_view_state==BVIEW_CHEST_ANIMATION||battle_view_state==BVIEW_ITEM_CLOSE) && i++<1000)press(A);CHECK(i<1000);}
static void encounter(RPGState *s){rpg_new_game(s);CHECK(battle_view_begin(s,EnemyID_Sworm)==RPG_OK);CHECK(battle_view_state==BVIEW_COMMAND&&battle_view_actor==0);}
static void run_and_invalid(void){
 RPGState s;unsigned i;
 encounter(&s);rpg_seed_rng(&s,1);for(i=0;i<4;++i)press(RIGHT);press(A);drain();
 CHECK(battle_view_state==BVIEW_DONE && battle_view_result==RPG_ESCAPED);
 encounter(&s);press(RIGHT);press(A);CHECK(battle_view_dialogue_id==0xb5c8);drain();CHECK(battle_view_state==BVIEW_COMMAND);
 press(RIGHT);press(RIGHT);press(A);CHECK(battle_view_state==BVIEW_ITEM);press(A);CHECK(battle_view_state==BVIEW_ITEM);press(B);CHECK(battle_view_state==BVIEW_COMMAND);
}
static void heal_target(void){
 RPGState s;
 rpg_new_game(&s);rpg_recruit(&s,1);s.party[0].level=4;rpg_refresh_stats(&s);rpg_rest(&s);s.party[1].status=0;s.party[1].hp=0;
 CHECK(battle_view_begin(&s,EnemyID_Sworm)==RPG_OK);press(RIGHT);press(A);CHECK(battle_view_state==BVIEW_SPELL);
 press(A);CHECK(battle_view_state==BVIEW_TARGET);press(DOWN);press(A);CHECK(battle_view_dialogue_id==0xb730);drain();
 CHECK(battle_view_state==BVIEW_TARGET && s.party[0].mp==4);press(B);CHECK(battle_view_state==BVIEW_SPELL);
}
static void victory_and_chest(void){
 RPGState s;unsigned i,guard=0;uint16_t exp;
 encounter(&s);s.party[0].level=30;rpg_refresh_stats(&s);rpg_rest(&s);exp=battle_view_battle.exp_reward;
 for(i=0;i<battle_view_battle.count;++i)battle_view_battle.enemies[i].hp=1;
 while(battle_view_state!=BVIEW_DONE && guard++<500){
  if(battle_view_state==BVIEW_MESSAGE)press(A);
  else if(battle_view_state==BVIEW_COMMAND){while(battle_view_choice)press(RIGHT);press(A);}
  else if(battle_view_state==BVIEW_PROMPT)press(A);
  else tick(0,0);
 }
 CHECK(guard<500 && battle_view_result==RPG_VICTORY);CHECK(s.party[0].exp==exp && s.money==battle_view_battle.money_reward);
}
static void full_reward(void){
 RPGState s;unsigned i;
 encounter(&s);for(i=0;i<23;++i)rpg_add_item(&s,ItemID_LaconiaPot);rpg_add_item(&s,ItemID_Cola);
 battle_view_battle.outcome=RPG_VICTORY;battle_view_battle.money_reward=20;battle_view_battle.item_reward=ItemID_Flute;battle_view_battle.trap_chance=0;battle_view_state=BVIEW_EXECUTE;
 tick(0,0);drain();CHECK(battle_view_state==BVIEW_PROMPT);press(A);drain();
 CHECK(battle_view_state==BVIEW_PROMPT&&battle_view_battle.item_pending==ItemID_Flute&&s.money==20);
 press(A);drain();CHECK(battle_view_state==BVIEW_REPLACE);press(A);CHECK(battle_view_dialogue_id==0xb6de);drain();
 CHECK(battle_view_state==BVIEW_REPLACE&&s.inventory[0]==ItemID_LaconiaPot);
 press(B);drain();CHECK(battle_view_state==BVIEW_PROMPT);press(RIGHT);press(A);drain();CHECK(battle_view_state==BVIEW_PROMPT);
 press(RIGHT);press(A);drain();CHECK(battle_view_state==BVIEW_REPLACE);
 for(i=0;i<23;++i)press(DOWN);press(A);CHECK(battle_view_dialogue_id==0xb69e);CHECK(s.inventory[23]==ItemID_Cola);drain();
 CHECK(battle_view_state==BVIEW_DONE && s.inventory[23]==ItemID_Flute && s.inventory_count==24 && s.money==20);
}
static void decline_and_dead(void){
 RPGState s;
 encounter(&s);battle_view_battle.outcome=RPG_VICTORY;battle_view_battle.money_reward=20;battle_view_state=BVIEW_EXECUTE;
 tick(0,0);drain();CHECK(battle_view_state==BVIEW_PROMPT);press(RIGHT);press(A);CHECK(battle_view_state==BVIEW_CHEST_MENU&&battle_view_chest_pending&&s.money==0);battle_view_chest_leave();CHECK(battle_view_state==BVIEW_DONE&&!battle_view_chest_pending);
 encounter(&s);battle_view_battle.outcome=RPG_DEFEAT;battle_view_state=BVIEW_EXECUTE;tick(0,0);drain();CHECK(battle_view_state==BVIEW_DONE&&battle_view_result==RPG_DEFEAT);
}
static void audio_sequence(void){
 RPGState s;unsigned i;encounter(&s);CHECK(last_audio==0x89);
 battle_view_battle.outcome=RPG_VICTORY;battle_view_state=BVIEW_EXECUTE;tick(0,0);CHECK(last_audio==0xaf&&battle_view_state==BVIEW_ITEM_CLOSE);
 battle_view_tick(0,0);CHECK(last_audio==0xaf);for(i=0;i<14u;++i)tick(0,0);CHECK(last_audio==0xaf);tick(0,0);CHECK(last_audio==0xd8&&battle_view_dialogue_id==0xb71b);
 battle_view_begin(&s,EnemyID_Lassic);CHECK(last_audio==0x92);battle_view_battle.outcome=RPG_VICTORY;battle_view_state=BVIEW_EXECUTE;tick(0,0);for(i=0;i<15u;++i)tick(0,0);CHECK(battle_view_state==BVIEW_AUDIO_WAIT&&last_audio==0xaf);for(i=0;i<179u;++i)tick(0,0);CHECK(last_audio==0xaf);tick(0,0);CHECK(last_audio==0xd8);
 last_audio=0;battle_view_begin(&s,EnemyID_DarkFalz);CHECK(last_audio==0);
 encounter(&s);battle_view_battle.outcome=RPG_DEFEAT;battle_view_state=BVIEW_EXECUTE;tick(0,0);CHECK(last_audio==0x94);
}
static void chest_magic(void){
 RPGState s;FieldContext c;FieldAction a;uint16_t seed;uint8_t hp,mp;unsigned i;
 rpg_new_game(&s);for(i=1;i<4;i++)rpg_recruit(&s,i);for(i=0;i<4;i++)s.party[i].level=30;rpg_refresh_stats(&s);rpg_rest(&s);
 memset(&c,0,sizeof c);c.rpg=&s;c.chest=&battle_view_battle;
 battle_view_chest_begin(&s,0,10,240);drain();CHECK(battle_view_state==BVIEW_PROMPT&&battle_view_chest_pending);seed=s.rng;hp=s.party[0].hp;
 press(RIGHT);press(A);CHECK(tick(0,0)==BATTLE_VIEW_MENU&&battle_view_battle.chest_state==BATTLE_CHEST_PENDING);
 mp=s.party[3].mp;field_cast(&c,3,MagicID_Tele,255,&a);CHECK(a.kind==FIELD_CHEST_PROMPT&&s.party[3].mp==mp-4&&s.rng==seed&&a.lines[0].dialogue==0xb404);
 battle_view_chest_prompt(0);drain();CHECK(battle_view_state==BVIEW_PROMPT);press(RIGHT);press(A);
 s.party[1].mp=1;field_cast(&c,1,MagicID_Trap,255,&a);CHECK(a.error==RPG_NO_MP&&s.party[1].mp==1&&battle_view_battle.chest_visual==0x3e);
 s.party[1].mp=10;field_cast(&c,1,MagicID_Trap,255,&a);CHECK(a.kind==FIELD_CHEST_OPEN&&s.party[1].mp==8&&battle_view_battle.chest_visual==0x3d&&s.rng==seed);
 battle_view_chest_open();for(i=0;i<48;i++)tick(0,0);CHECK(s.money==0&&s.party[0].hp==hp&&battle_view_chest_pending);tick(0,0);CHECK(s.money==10&&!battle_view_chest_pending&&s.party[0].hp==hp);drain();CHECK(battle_view_state==BVIEW_CHEST_MENU&&battle_view_field_menu_pending&&!battle_view_chest_pending);battle_view_chest_leave();CHECK(battle_view_state==BVIEW_DONE&&!battle_view_field_menu_pending&&battle_view_battle.chest_state==BATTLE_CHEST_OPEN);
 battle_view_chest_begin(&s,0,10,240);drain();hp=s.party[0].hp;battle_view_chest_open();for(i=0;i<78;i++)tick(0,0);CHECK(s.party[0].hp==hp);tick(0,0);CHECK(s.party[0].hp==hp-hp/3&&s.money==20);drain();
 battle_view_chest_begin(&s,0,10,241);seed=s.rng;battle_view_chest_abandon();CHECK(!battle_view_chest_pending&&s.rng==seed&&s.money==20&&!battle_view_state);
}
static void script_decline(void){
 RPGState s;rpg_new_game(&s);battle_view_chest_begin(&s,0,100,0);battle_view_menu_allowed=0;drain();press(RIGHT);press(A);
 CHECK(battle_view_state==BVIEW_DONE&&!battle_view_chest_pending&&!battle_view_field_menu_pending&&s.money==0);
}
static void streamed_chest_text(void){
 RPGState s;unsigned i;uint16_t seed;rpg_new_game(&s);battle_view_chest_begin(&s,0,10,0);seed=s.rng;
 CHECK(battle_view_state==BVIEW_MESSAGE&&battle_view_text_revealing&&battle_view_dialogue_id==0xbd97);
 for(i=0;i<10u;++i)battle_view_tick(A,A); /* No logical frame, no character. */
 /* BD97 has25glyphs, B656 has22; each has one zero-wait62 terminator step. */
 for(i=0;i<48u;++i){tick(A,A);CHECK(battle_view_state==BVIEW_MESSAGE&&battle_view_text_revealing);}
 tick(A,A);CHECK(battle_view_state==BVIEW_PROMPT&&!battle_view_text_revealing&&s.rng==seed&&battle_view_chest_pending);
 battle_view_chest_abandon();CHECK(!battle_view_text_revealing);
}
static void deferred_battle_items(void){
 RPGState s;DungeonState d;unsigned i;uint8_t p;uint16_t seed;
 const uint8_t items[4]={ItemID_DungeonKey,ItemID_MiracleKey,ItemID_Nuts,ItemID_Flash};
 for(i=0;i<4;i++){
  encounter(&s);rpg_add_item(&s,items[i]);dungeon_enter(&d,0,0x55,0);p=dungeon_sample_position(&d,1);d.layout[p]=i==1?6:5;d.light=0;
  memset(&item_context,0,sizeof item_context);item_context.rpg=&s;item_context.dungeon=&d;item_context.in_battle=1;
  item_context.event_id=0xb0;item_context.projection=255;s.party[1].status=2;
  press(RIGHT);press(RIGHT);press(A);CHECK(battle_view_state==BVIEW_ITEM);press(A);CHECK(battle_view_state==BVIEW_EXECUTE);
  memset(battle_view_battle.turn_order,255,12);battle_view_battle.turn_order[0]=0;battle_view_battle.turn_cursor=0;seed=s.rng;tick(0,0);
  CHECK(battle_view_state==BVIEW_MESSAGE&&battle_view_dialogue_id==(i==2?0xb743:i==3?0xb366:0xb2ac));
  drain();CHECK(battle_view_state==BVIEW_COMMAND&&battle_view_battle.outcome==RPG_ONGOING);
  CHECK(d.layout[p]==(i==1?6:5)&&!d.light&&s.inventory_count==1&&s.rng==seed);
  CHECK(field_action.kind==(i<2?FIELD_OPEN_DOOR:i==2?FIELD_MYAU_FLY:FIELD_DONE));
 }
}
static void core_item_close(void){
 RPGState s;unsigned i,k;uint8_t prior,expected;
 const uint8_t items[]={ItemID_Cola,ItemID_Escaper,ItemID_MagicHat,ItemID_Sphere};
 for(k=0;k<4;k++){
  encounter(&s);rpg_add_item(&s,items[k]);s.party[0].attack=100;
  battle_view_battle.enemy_flags=k==3?0u:0x40u;battle_view_battle.run_chance=1;
  press(RIGHT);press(RIGHT);press(A);press(A);
  memset(battle_view_battle.turn_order,255,12);battle_view_battle.turn_order[0]=0;battle_view_battle.turn_cursor=0;
  for(i=0;i<1000u&&battle_view_state!=BVIEW_ITEM_CLOSE;i++)tick(A,A);
  CHECK(i<1000u);prior=last_audio;expected=k==0?0xc1:k==1?0xbc:k==2?0xd5:0x89;CHECK(prior==expected);
  for(i=0;i<10u;i++)battle_view_tick(A,A);CHECK(battle_view_state==BVIEW_ITEM_CLOSE&&last_audio==prior);
  for(i=0;i<5u;i++){tick(0,0);CHECK(battle_view_state==BVIEW_ITEM_CLOSE&&last_audio==prior);}
  tick(0,0);
  if(k==1||k==2){
   CHECK(battle_view_state==BVIEW_ITEM_CLOSE&&last_audio==prior);
   for(i=0;i<14u;i++){tick(0,0);CHECK(battle_view_state==BVIEW_ITEM_CLOSE&&last_audio==prior);}
   tick(0,0);
  }
  CHECK(battle_view_state==(k==1||k==2?BVIEW_DONE:BVIEW_COMMAND));
  CHECK(last_audio==(k==1||k==2?0xd8:prior));
 }
}
int main(void){core_item_close();deferred_battle_items();streamed_chest_text();script_decline();chest_magic();audio_sequence();run_and_invalid();heal_target();victory_and_chest();full_reward();decline_and_dead();printf("Battle controller checks passed: %u\n",checks);return 0;}
