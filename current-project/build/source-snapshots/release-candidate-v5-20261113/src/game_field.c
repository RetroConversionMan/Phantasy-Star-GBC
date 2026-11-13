#pragma bank 12
#include <gb/gb.h>
#include <string.h>
#include "game_field.h"
#include "game_flow.h"
#include "game_ui.h"
#include "dungeon_play.h"
#include "world.h"
#include "audio.h"
#include "game_sequence.h"
#include "battle_view.h"
#include "battle_scene.h"
extern RPGState game_rpg;
extern EventState game_events;
extern DungeonPlay game_dungeon;
extern uint16_t player_x,player_y;
extern uint8_t facing,game_vehicle,screen_state;
void show_dialogue(uint16_t);
void resume_walk(void);
void enter_map(uint8_t,uint16_t,uint16_t);
FieldAction field_action;
uint8_t field_active;
static uint8_t field_line;
static void context(FieldContext *c) {
 memset(c,0,sizeof(*c));c->rpg=&game_rpg;c->events=&game_events;
 c->dungeon=game_dungeon.active?&game_dungeon.dungeon:0;
 c->interaction=game_events.event?game_events.type:game_dungeon.active?0:
  world_flags_at((player_x-8u)&2047u,(player_y+1536u-16u)%1536u)>>4;
 c->map_id=world_map_id;c->map_group=world_group_id;c->event_id=game_events.event;
 c->projection=game_events.portrait;c->vehicle=game_vehicle;
 if(battle_view_chest_pending)c->chest=&battle_view_battle;
}
static void finish(void) {
 WorldAction destination;uint16_t x,y;uint8_t close_frames;
 /*3464 restores six SMS text rows before the Torch handler can award Nuts.
  * The native window has five rows: hide it, retain the six source VBlanks,
  * then commit the inventory award and its B3 sound. Denials close too. */
 if(field_action.item==ItemID_EclipseTorch){HIDE_WIN;for(close_frames=0;close_frames<6u;++close_frames)vsync();}
 field_active=0;if(field_action.sound_end&&field_action.kind!=FIELD_OPEN_DOOR&&field_action.kind!=FIELD_TORCH_SCENE)audio_command(field_action.sound_end);
 switch(field_action.kind) {
 case FIELD_DONE:menu_screen();break;
 case FIELD_CHEST_OPEN:battle_view_chest_open();screen_state=15;break;
 case FIELD_CHEST_PROMPT:battle_view_chest_prompt(0);screen_state=15;break;
 case FIELD_REDRAW:resume_walk();break;
 case FIELD_OPEN_DOOR:dplay_show_opening(&game_dungeon,field_action.a);resume_walk();break;
 case FIELD_EXIT_DUNGEON:enter_map(world_map_id,player_x,player_y);break;
 case FIELD_TRANSFER:
  destination.target=field_action.target;destination.a=field_action.a;destination.b=field_action.b;
  world_decode_destination(&destination,&x,&y);enter_map(destination.target,x,y);break;
 case FIELD_STORY_ITEM:event_use_story_item(&game_events,field_action.target,0);apply_event();break;
 case FIELD_VEHICLE:resume_walk();break;
 case FIELD_TORCH_SCENE:field_torch_finish(&game_rpg,&field_action);if(field_action.sound_end)audio_command(field_action.sound_end);menu_screen();break;
 case FIELD_PRISM:case FIELD_MYAU_FLY:start_field_scene(field_action.kind);break;
 default:result(RPG_NOT_IMPLEMENTED,2);break;
 }
}
static void next_line(void) {
 if(field_line>=field_action.line_count){finish();return;}
 if(field_action.lines[field_line].sound_before)audio_command(field_action.lines[field_line].sound_before);
 show_dialogue(field_action.lines[field_line].dialogue);
}
static void start(void) {
 field_active=1;field_line=0;
 if(field_action.sound_start)audio_command(field_action.sound_start);
 next_line();
}
void game_field_advance(void) RPG_BANKED {
 if(field_line<field_action.line_count&&field_action.lines[field_line].sound_after)
  audio_command(field_action.lines[field_line].sound_after);
 ++field_line;
 /* ItemUse_EclipseTorch calls7CA6 between B458 and the Pot-dependent reply.
  * Its one-frame source palette change must already be visible in that reply. */
 if(field_action.kind==FIELD_TORCH_SCENE&&field_line==1u&&!field_action.b){
  start_field_scene(FIELD_TORCH_SCENE);return;
 }
 next_line();
}
void game_field_scene_done(void) RPG_BANKED {
 if(field_active){
  if(field_action.kind==FIELD_TORCH_SCENE)field_torch_reply(&game_rpg,&field_action);
  next_line();
 }else menu_screen();
}
void game_field_item(uint8_t slot,uint8_t target) RPG_BANKED {
 FieldContext c;uint8_t mode,exiting,result;
 context(&c);field_use_item(&c,slot,target,&field_action);game_events.portrait=c.projection;
 if(field_action.kind==FIELD_VEHICLE) {
  mode=(field_action.item-32u)*4u;exiting=mode==game_vehicle;
  result=world_vehicle_use(&player_x,&player_y,facing,c.interaction,mode,&game_vehicle);
  field_action.line_count=exiting?1u:2u;
  field_action.lines[0].dialogue=exiting?(result?0xb30a:0xb2fb):0xb2ac;
  if(!exiting)field_action.lines[1].dialogue=result?0xb305:0xb2e3;
  if(!result)field_action.kind=FIELD_DONE;
 }
 start();
}
void game_field_spell(uint8_t caster,uint8_t spell,uint8_t target) RPG_BANKED {
 FieldContext c;context(&c);field_cast(&c,caster,spell,target,&field_action);start();
}

void game_field_battle_item(uint8_t item,uint8_t actor) RPG_BANKED {
 FieldContext c;uint8_t mode,boarding=0,result;
 context(&c);c.in_battle=1;c.chest=0;c.interaction=battle_scene_type;
 field_use_item(&c,rpg_find_item(&game_rpg,item),actor,&field_action);
 field_action.character=actor;
 if(field_action.kind==FIELD_VEHICLE) {
  /* BattleMenu_Item dispatches ItemAction_Use directly. Unlike PlayerMenu_Item,
   * even using the currently boarded vehicle attempts boarding again. */
  mode=(item-32u)*4u;
  result=world_vehicle_use(&player_x,&player_y,facing,c.interaction,mode,&boarding);
  field_action.line_count=2;field_action.lines[0].dialogue=0xb2ac;
  field_action.lines[1].dialogue=result?0xb305:0xb2e3;
  if(result)game_vehicle=boarding;else field_action.kind=FIELD_DONE;
 }
 /* Source keys/Nuts set C2D8 here, but only1BE1 reads it and clears it first.
  * Keep the emitted kind observable; never call finish() or start_field_scene.
  * Vehicle mode/position above are immediate C30E/player-coordinate writes. */
}
