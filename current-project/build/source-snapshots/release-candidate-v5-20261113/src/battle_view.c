/* GBC battle presentation/controller; actual rules remain in battle.c. */
#include <stdint.h>
#ifdef __SDCC
#pragma bank 30
#include <gb/gb.h>
#include <gb/cgb.h>
#include "ui.h"
#include "battle_scene.h"
#include "battle_motion.h"
#include "battle_weapon.h"
#include "enemy_magic.h"
#include "boss_motion.h"
#include "gold_scene.h"
#else
#define J_RIGHT 1u
#define J_LEFT 2u
#define J_UP 4u
#define J_DOWN 8u
#define J_A 16u
#define J_B 32u
static void ui_panel(uint8_t y,uint8_t rows);
static void ui_text(uint8_t x,uint8_t y,const char *s);
static void ui_number(uint8_t x,uint8_t y,uint16_t value);
#endif
#include <stdint.h>
#include <string.h>
#include "battle_view.h"
#include "dialogue.h"
#include "audio.h"
#include "chest_motion.h"
#include "game_field.h"
#ifdef __SDCC
#include "chest_art.h"
#include "scene.h"
#endif
#ifndef __SDCC
static void ui_panel(uint8_t y,uint8_t rows) {(void)y;(void)rows;}
static void ui_text(uint8_t x,uint8_t y,const char *s) {(void)x;(void)y;(void)s;}
static void ui_number(uint8_t x,uint8_t y,uint16_t value) {(void)x;(void)y;(void)value;}
#endif
/* ui_text executes in bank1, so a string in bank30 must first be copied to
 * WRAM. Dialogue cursor and numeric strings are already WRAM, but using this
 * wrapper for every string prevents accidental bank-dependent presentation. */
static void view_text(uint8_t x,uint8_t y,const char *text) {
    char copy[21];uint8_t i=0;
    while(text[i]&&i<20u){copy[i]=text[i];++i;}copy[i]=0;
    ui_text(x,y,copy);
}
#define ui_text view_text
static void view_panel(uint8_t y,uint8_t rows) {
    ui_panel(y,rows);
#ifdef __SDCC
    battle_scene_clip(y);
    if(!battle_scene_enemy && scene_actor_active){if(y)SHOW_SPRITES;else HIDE_SPRITES;}
#endif
}
#define ui_panel view_panel
RPGBattle battle_view_battle;
uint8_t battle_view_state,battle_view_actor,battle_view_choice,battle_view_result;
uint8_t battle_view_hit_cursor,battle_view_text_revealing;
uint16_t battle_view_dialogue_id;
uint8_t battle_view_chest_pending,battle_view_field_menu_pending,battle_view_menu_allowed;
static ChestMotion chest_motion;
static uint8_t chest_clock;
static RPGState *party;
static RPGAction actions[4];
static DialogueCursor message;
static uint8_t after_message, is_literal, prompt_kind, selected_slot;
/* Selection and action playback never overlap; reuse this byte. */
static union {uint8_t spell,barrier_reported;} selection_phase;
#define selected_spell selection_phase.spell
static uint16_t message_wait;
static uint8_t message_clock,item_line,item_after,item_close_frames;
static uint8_t level_cursor, old_battle_magic[4], old_map_magic[4], replacement_slot;
static uint8_t deaths_pending,dragon_fall,previous_alive[4];
static uint8_t audio_delay_start,audio_delay_frames;
#ifdef __SDCC
static BattleMotion enemy_motion;
static WeaponMotion weapon_motion;
static EnemyMagicEffect enemy_effect;
static BossMotion boss_motion;
static uint8_t magic_phase;
static uint8_t motion_clock,motion_last_frame,feedback_animated,motion_hit_hold;
#endif
static char enemy_name[9], item_name[9];
static const char *const names[]={"ALIS","MYAU","ODIN","NOAH"};
static const char *const spells[]={"","HEAL","CURE","WALL","PROT","FIRE","THUN","WIND","ROPE","BYE","HELP","TERR","TRAP","EXIT","OPEN","RISE","CHAT","TELE","FLY"};
static const uint16_t talk_texts[19]={0xbaae,0xbad0,0xbae6,0xbaf4,0xbb06,0xbb0d,0xbb20,0xbb3d,0xbb45,0xbb5c,0xbb8d,0xbbbf,0xbbd2,0xbbf0,0xbc1a,0xbc42,0xbc5b,0xbc89,0xbcaa};
#define NEXT_CHOOSE 1u
#define NEXT_STEP 2u
#define NEXT_RESULT 3u
#define NEXT_REWARDS 4u
#define NEXT_LEVEL 5u
#define NEXT_LEARNED 6u
#define NEXT_CHEST 7u
#define NEXT_ASK_CHEST 8u
#define NEXT_PROMPT_CHEST 9u
#define NEXT_MONEY 10u
#define NEXT_FOUND 11u
#define NEXT_GIFT 12u
#define NEXT_PROMPT_FULL 13u
#define NEXT_PROMPT_ABANDON 14u
#define NEXT_REPLACE 15u
#define NEXT_APPLY_REPLACE 16u
#define NEXT_DONE 17u
#define NEXT_TALK_REPLY 18u
#define NEXT_DEFEAT 19u
#define NEXT_SPELLS 20u
#define NEXT_ITEMS 21u
#define NEXT_TARGET 22u
#define NEXT_BEGIN_TALK 23u
#define NEXT_ITEM_LINE 24u
#define NEXT_MAGIC_DEATH 25u
#define NEXT_MAGIC_HOLD 26u
#define NEXT_PRESENT_ACTION 27u
#define NEXT_MAGIC_BEGIN 28u
#define NEXT_PHYSICAL_DEATH 29u
#define NEXT_PHYSICAL_HOLD 30u
#define NEXT_HIDE_RETURN 31u
#define NEXT_RETURN 32u
#define NEXT_VICTORY_CLEAR 33u
#define NEXT_VICTORY_UPLOAD 34u
#define NEXT_CHEST_CLOSE 35u
#define PROMPT_CHEST 1u
#define PROMPT_FULL 2u
#define PROMPT_ABANDON 3u
static void resume(uint8_t next);
static void command_feedback(void);
static void one_line(uint16_t id,uint8_t sound,uint8_t after,uint8_t character);
static void close_delay(uint8_t frames,uint8_t next);
static uint8_t present_action(void);
static void chest_pose(uint8_t frame) {
#ifdef __SDCC
    DISPLAY_OFF;chest_show(frame);DISPLAY_ON;
#else
    (void)frame;
#endif
}
static void command_screen(void);
static void spell_screen(void);
static void item_screen(uint8_t replace);
static void target_screen(void);
static uint8_t eligible(uint8_t c) {
    return (party->joined_mask&(1u<<c)) && (party->party[c].status&1u) && party->party[c].hp && !party->party[c].bound;
}
static uint8_t character_for_message(void) {
    uint8_t c=battle_view_battle.last_actor;
    if(c>=4u)c=battle_view_battle.last_target;
    return c<4u?c:battle_view_actor<4u?battle_view_actor:0u;
}
static void message_page(void) {
    battle_view_text_revealing=1;ui_text(17,4," ");
    battle_view_state=BVIEW_MESSAGE;message_clock=audio_clock;
}
static void say(uint16_t id,uint8_t next,uint8_t character,uint8_t item,uint16_t number) {
    after_message=next;is_literal=0;battle_view_dialogue_id=id;battle_view_text_revealing=0;
    if(!dialogue_open(&message,id)) {
        ui_panel(104,5);ui_text(1,1,"TEXT UNAVAILABLE");ui_text(1,3,"A / B");is_literal=1;battle_view_state=BVIEW_MESSAGE;return;
    }
    if(character<4u)strcpy(message.character,names[character]);
    strcpy(message.enemy,enemy_name);dialogue_item_name(item,message.item);message.number=number;
    dialogue_stream_begin(&message,0);ui_panel(104,5);message_page();
}
static void literal(const char *first,const char *second,uint8_t next) {
    after_message=next;is_literal=1;battle_view_dialogue_id=0;battle_view_text_revealing=0;battle_view_state=BVIEW_MESSAGE;
    ui_panel(104,5);ui_text(1,1,first);ui_text(1,2,second);ui_text(17,4,">");
}
static void command_screen(void) {
    static const uint8_t x[5]={0,7,14,0,7},y[5]={2,2,2,3,3};
    RPGCharacter *p=&party->party[battle_view_actor];
    battle_view_state=BVIEW_COMMAND;ui_panel(96,6);
    ui_text(0,0,names[battle_view_actor]);ui_text(5,0,"HP");ui_number(8,0,p->hp);
    ui_text(12,0,"MP");ui_number(15,0,p->mp);
    ui_text(1,2,"ATTACK");ui_text(8,2,"MAGIC");ui_text(15,2,"ITEM");
    ui_text(1,3,"TALK");ui_text(8,3,"RUN");ui_text(x[battle_view_choice],y[battle_view_choice],">");
    ui_text(1,5,"A:CHOOSE B:BACK");
}
static void spell_screen(void) {
    uint8_t i,id;
    battle_view_state=BVIEW_SPELL;ui_panel(0,18);ui_text(1,1,names[battle_view_actor]);ui_text(8,1,"MAGIC");
    for(i=0;i<5u;++i){
        id=rpg_spell_option(party,battle_view_actor,i,1);if(!id)break;
        ui_text(3,4+i*2u,spells[id]);ui_text(11,4+i*2u,"MP");ui_number(15,4+i*2u,rpg_magic_cost(id));
    }
    ui_text(1,4+battle_view_choice*2u,">");ui_text(1,17,"A:CHOOSE B:BACK");
}
static void item_screen(uint8_t replace) {
    uint8_t i,slot,start;
    if(battle_view_choice>=party->inventory_count)battle_view_choice=party->inventory_count?party->inventory_count-1u:0u;
    start=(battle_view_choice/6u)*6u;battle_view_state=replace?BVIEW_REPLACE:BVIEW_ITEM;
    ui_panel(0,18);ui_text(2,1,replace?"WHAT TO DROP?":"ITEMS");
    for(i=0;i<6u;++i){slot=start+i;if(slot>=party->inventory_count)break;
        dialogue_item_name(party->inventory[slot],item_name);ui_text(4,4+i*2u,item_name);
    }
    if(!party->inventory_count)ui_text(4,5,"EMPTY");
    else ui_text(2,4+(battle_view_choice-start)*2u,">");
    ui_text(1,17,"A:CHOOSE B:BACK");
}
static void target_screen(void) {
    uint8_t i;
    battle_view_state=BVIEW_TARGET;ui_panel(0,18);ui_text(1,1,"WHICH CHARACTER?");
    for(i=0;i<4u;++i)if(party->joined_mask&(1u<<i)){
        ui_text(3,4+i*3u,names[i]);ui_number(9,4+i*3u,party->party[i].hp);
        ui_text(12,4+i*3u,"/");ui_number(14,4+i*3u,party->party[i].max_hp);
    }
    ui_text(1,4+battle_view_choice*3u,">");ui_text(1,17,"A:CHOOSE B:BACK");
}
static void prompt(uint8_t kind) {
    prompt_kind=kind;battle_view_choice=0;battle_view_state=BVIEW_PROMPT;
    ui_panel(104,5);ui_text(3,1,"YES");ui_text(12,1,"NO");ui_text(1,1,">");ui_text(1,4,"A:CHOOSE");
}
static void start_resolution(void) {
    uint8_t result=rpg_battle_prepare(party,&battle_view_battle,actions);
    if(result){
        if(result==RPG_NO_MP)say(0xb6f7,NEXT_CHOOSE,battle_view_actor,0,0);
        else if(result==RPG_NOT_LEARNED)say(0xb5c8,NEXT_CHOOSE,battle_view_actor,0,0);
        else if(result==RPG_DEAD)say(0xb730,NEXT_CHOOSE,battle_view_actor,0,0);
        else literal("ACTION UNAVAILABLE","CHOOSE AGAIN",NEXT_CHOOSE);
        return;
    }
    if(actions[battle_view_actor<4u?battle_view_actor:0u].kind==RPG_ACT_RUN ||
       battle_view_battle.last_effect==BATTLE_EFFECT_TALK || battle_view_battle.suppress_party)command_feedback();
    else battle_view_state=BVIEW_EXECUTE;
}
static void next_character(void) {
    ++battle_view_actor;
    while(battle_view_actor<4u && !eligible(battle_view_actor))++battle_view_actor;
    battle_view_choice=0;
    if(battle_view_actor<4u)command_screen();else start_resolution();
}
static void new_round(void) {
    memset(actions,0,sizeof actions);battle_view_actor=0;battle_view_choice=0;
    while(battle_view_actor<4u && !eligible(battle_view_actor))++battle_view_actor;
    if(battle_view_actor<4u)command_screen();else start_resolution();
}
static void result_screen(void) {
    uint8_t outcome=battle_view_battle.outcome;
    if(outcome==RPG_VICTORY){
        if(battle_view_battle.enemy_id==EnemyID_Tarzimal){audio_command(0xd8);rpg_claim_rewards(party,&battle_view_battle);resume(NEXT_DONE);}
        else {
            /*1671 queues victory before15D9 restores rows and clears actors.
             * Its final upload wait precedes the bosses' separate180 waits. */
            audio_command(0xaf);
#ifdef __SDCC
            if(battle_view_battle.enemy_id==70u&&battle_scene_type==14u)gold_scene_blue();
#endif
            close_delay(battle_view_battle.enemy_id==EnemyID_DarkFalz?4u:14u,NEXT_VICTORY_CLEAR);
        }
    }else if(outcome==RPG_DEFEAT){
#ifdef __SDCC
        if(battle_view_battle.enemy_id==70u&&battle_scene_type==14u)gold_scene_blue();
#endif
        if(battle_view_battle.enemy_id==EnemyID_Tarzimal || battle_view_battle.enemy_id==EnemyID_Saccubus){audio_command(0xd8);resume(NEXT_DONE);}
        else {audio_command(0x94);if(party->joined_mask!=1u)say(0xbd17,NEXT_DEFEAT,0,0,0);else say(0xbd23,NEXT_DONE,0,0,0);}
    }else if(outcome==RPG_TALKED)say(0xb132,NEXT_TALK_REPLY,character_for_message(),0,0);
    else if(outcome==RPG_ESCAPED)say(0xb25f,NEXT_DONE,0,0,0);
    else new_round();
}
static void item_next_line(void) {
    if(item_line>=field_action.line_count){
        /* Source3464 restores six dialogue rows through3A57, one VBlank each.
         * Keep the sound mailbox alive through that original close interval. */
        close_delay(6u,item_after);return;
    }
    if(field_action.lines[item_line].sound_before)audio_command(field_action.lines[item_line].sound_before);
    say(field_action.lines[item_line].dialogue,NEXT_ITEM_LINE,field_action.character,field_action.item,0);
}
static void close_delay(uint8_t frames,uint8_t next) {
    item_close_frames=frames;item_after=next;message_clock=audio_clock;battle_view_state=BVIEW_ITEM_CLOSE;
}
static void one_line(uint16_t id,uint8_t sound,uint8_t after,uint8_t character) {
    memset(&field_action,0,sizeof field_action);field_action.character=character;
    field_action.lines[0].dialogue=id;field_action.lines[0].sound_before=sound;
    field_action.line_count=1;item_line=0;item_after=after;item_next_line();
}
static void command_feedback(void) {
    RPGBattle *b=&battle_view_battle;RPGAction *a=actions+b->last_actor;
    if(a->kind==RPG_ACT_RUN){
        if(b->outcome==RPG_ESCAPED){audio_command(0xbc);resume(NEXT_DONE);}
        else one_line(0xb15e,0,NEXT_STEP,b->last_actor);
        return;
    }
    memset(&field_action,0,sizeof field_action);field_action.character=b->last_actor;
    if(a->kind==RPG_ACT_MAGIC&&a->id==MagicID_Chat)audio_command(0xab);
    field_action.lines[0].dialogue=b->outcome==RPG_TALKED?0xb132:0xb13d;
    field_action.line_count=1;item_after=NEXT_STEP;
    if(b->outcome==RPG_TALKED){
        field_action.lines[1].dialogue=talk_texts[b->talk_index<19u?b->talk_index:0u];field_action.line_count=2;item_after=NEXT_DONE;
        if(a->kind==RPG_ACT_MAGIC&&(b->enemy_flags&0x40u)){
            field_action.lines[0].sound_before=0xac;field_action.lines[1].sound_after=0xd5;
        }
    }
    item_line=0;item_next_line();
}
static uint8_t support_feedback(void) {
    RPGBattle *b=&battle_view_battle;uint8_t c=b->last_actor,id,target;
    if(c>=4u||actions[c].kind!=RPG_ACT_MAGIC)return 0;
    if(!b->last_error&&(b->last_effect==BATTLE_EFFECT_NONE||b->last_effect==BATTLE_EFFECT_BOUND||b->last_effect==BATTLE_EFFECT_RECOVERED))return 0;
    id=actions[c].id;target=actions[c].target;
    if(id!=MagicID_Heal&&id!=MagicID_Cure&&id!=MagicID_Help&&id!=MagicID_Wall&&id!=MagicID_Prot&&id!=MagicID_Rope&&id!=MagicID_Terr&&id!=MagicID_Bye)return 0;
    if(b->last_error&&b->last_error!=RPG_DEAD)return 0;
    if(b->last_error==RPG_DEAD){one_line(0xb730,id==MagicID_Help?0xab:0,NEXT_STEP,target);return 1;}
    if(id==MagicID_Bye){one_line(b->outcome==RPG_ESCAPED?0xb25f:0xb172,b->outcome==RPG_ESCAPED?0xbc:0,b->outcome==RPG_ESCAPED?NEXT_DONE:NEXT_STEP,c);return 1;}
    memset(&field_action,0,sizeof field_action);field_action.character=(id==MagicID_Heal||id==MagicID_Cure||id==MagicID_Help)?target:c;
    field_action.line_count=1;field_action.lines[0].sound_before=0xab;
    if(id==MagicID_Heal||id==MagicID_Cure){field_action.lines[0].dialogue=0xb1d0;field_action.lines[0].sound_after=0xc1;}
    else if(id==MagicID_Help)field_action.lines[0].dialogue=0xb22f;
    else if(id==MagicID_Wall||id==MagicID_Prot)field_action.lines[0].dialogue=0xb18b;
    else field_action.lines[0].dialogue=b->last_effect==BATTLE_EFFECT_NO_EFFECT?0xb172:id==MagicID_Rope?0xb1e0:0xb24c;
    item_line=0;item_after=NEXT_STEP;item_next_line();return 1;
}
static uint8_t core_item_feedback(void) {
    RPGBattle *b=&battle_view_battle;uint8_t c=b->last_actor,item;
    if(c>=4u||actions[c].kind!=RPG_ACT_ITEM)return 0;
    if(b->last_error&&b->last_error!=RPG_ACTION_FAILED)return 0;
    if(b->last_effect!=BATTLE_EFFECT_HEAL&&b->last_effect!=BATTLE_EFFECT_NO_EFFECT&&b->last_effect!=BATTLE_EFFECT_ESCAPE&&b->last_effect!=BATTLE_EFFECT_TALK)return 0;
    item=actions[c].id;
    if(item!=ItemID_Cola&&item!=ItemID_Burger&&item!=ItemID_Wand&&item!=ItemID_Escaper&&item!=ItemID_MagicHat&&item!=ItemID_Sphere)return 0;
    memset(&field_action,0,sizeof field_action);field_action.character=c;field_action.item=item;
    field_action.lines[0].dialogue=0xb2ac;field_action.line_count=2;item_after=NEXT_STEP;
    if(item==ItemID_Cola||item==ItemID_Burger){field_action.lines[1].dialogue=0xb1d0;field_action.lines[1].sound_after=0xc1;}
    else if(item==ItemID_Wand||item==ItemID_Escaper){
        field_action.lines[1].dialogue=b->outcome==RPG_ESCAPED?0xb25f:0xb2cd;
        if(b->outcome==RPG_ESCAPED){field_action.lines[1].sound_before=0xbc;item_after=NEXT_DONE;}
    }else if(b->outcome!=RPG_TALKED)field_action.lines[1].dialogue=0xb13d;
    else{
        field_action.lines[1].dialogue=0xb132;field_action.line_count=3;
        field_action.lines[2].dialogue=talk_texts[b->talk_index<19u?b->talk_index:0u];item_after=NEXT_DONE;
        if(b->enemy_flags&0x40u){field_action.lines[1].sound_before=0xac;field_action.lines[2].sound_after=0xd5;}
    }
    item_line=0;item_next_line();return 1;
}
static void action_feedback(void) {
    RPGBattle *b=&battle_view_battle;
    uint8_t c=character_for_message(),enemy=b->last_actor>=4u;
    /* Animated hits supply their own sound; support effects use source stores. */
    if(b->last_effect==BATTLE_EFFECT_ATTACK||b->last_effect==BATTLE_EFFECT_MISS||b->last_effect==BATTLE_EFFECT_BLOCKED||b->last_effect==BATTLE_EFFECT_PETRIFY){
        if(enemy){
#ifdef __SDCC
            if(!feedback_animated)
#endif
            audio_command(audio_enemy_effect(b->enemy_id&127u));
        }
        else {
#ifdef __SDCC
            if(!feedback_animated)
#endif
            audio_command(b->last_effect==BATTLE_EFFECT_MISS?0xbb:0xad);
        }
    }else if(b->last_effect==BATTLE_EFFECT_HEAL||b->last_effect==BATTLE_EFFECT_BOOST||b->last_effect==BATTLE_EFFECT_ROPE){audio_command(enemy?0xa1:b->last_effect==BATTLE_EFFECT_HEAL?0xc1:0xab);}
    else if(b->last_effect==BATTLE_EFFECT_WEAKEN||b->last_effect==BATTLE_EFFECT_BARRIER)audio_command(0xab);
    switch(b->last_effect){
    case BATTLE_EFFECT_FIELD_ITEM:
        game_field_battle_item(actions[b->last_actor].id,b->last_actor);item_line=0;item_after=NEXT_STEP;
        if(field_action.sound_start)audio_command(field_action.sound_start);
        item_next_line();break;
    case BATTLE_EFFECT_MISS:one_line(enemy?0xb118:0xb108,0,enemy?NEXT_PHYSICAL_DEATH:NEXT_STEP,c);break;
    case BATTLE_EFFECT_BLOCKED:one_line(0xb1a3,0,NEXT_PHYSICAL_DEATH,c);break;
    case BATTLE_EFFECT_MAGIC_BLOCKED:one_line(0xb1b2,0,NEXT_STEP,c);break;
    case BATTLE_EFFECT_BOUND:one_line(enemy?0xb203:0xb1fc,0,NEXT_STEP,c);break;
    case BATTLE_EFFECT_RECOVERED:one_line(enemy?0xb21d:0xb20a,0,NEXT_STEP,c);break;
    case BATTLE_EFFECT_HEAL:one_line(enemy?0xb1d8:0xb1d0,0,NEXT_STEP,b->last_target<4u?b->last_target:c);break;
    case BATTLE_EFFECT_BOOST:one_line(enemy?0xbcc2:0xb22f,0,NEXT_STEP,b->last_target<4u?b->last_target:c);break;
    case BATTLE_EFFECT_ROPE:one_line(enemy?0xb1ee:0xb1e0,0,NEXT_STEP,c);break;
    case BATTLE_EFFECT_WEAKEN:one_line(0xb24c,0,NEXT_STEP,c);break;
    case BATTLE_EFFECT_BARRIER:one_line(0xb18b,0,NEXT_STEP,c);break;
    case BATTLE_EFFECT_PETRIFY:one_line(0xbe93,0,NEXT_PHYSICAL_HOLD,c);break;
    case BATTLE_EFFECT_NO_EFFECT:one_line(!enemy && actions[b->last_actor].kind==RPG_ACT_MAGIC?0xb172:0xb2cd,0,NEXT_STEP,c);break;
    case BATTLE_EFFECT_ESCAPE:one_line(0xb25f,0xbc,NEXT_DONE,c);break;
    case BATTLE_EFFECT_TALK:say(0xb132,NEXT_TALK_REPLY,c,0,0);break;
    default:
        ui_panel(96,6);if(enemy)ui_text(1,0,enemy_name);else ui_text(1,0,names[c]);
        ui_text(1,1,b->last_effect==BATTLE_EFFECT_FIRE?"FIRE":b->last_effect==BATTLE_EFFECT_THUNDER?"THUNDER":b->last_effect==BATTLE_EFFECT_WIND?"WIND":"ATTACK");
        if(b->last_target<4u){ui_text(1,4,names[b->last_target]);ui_text(7,4,"HP");ui_number(11,4,party->party[b->last_target].hp);}
        else if(b->last_target<12u && b->enemy_id!=EnemyID_DarkFalz){ui_text(1,4,"ENEMY HP");ui_number(11,4,b->enemies[b->last_target-4u].hp);}
        /* Source3105/2F93 refresh HP without an invented damage-message wait. */
        resume(enemy?NEXT_PHYSICAL_DEATH:NEXT_STEP);break;
    }
}
#ifdef __SDCC
static void magic_hit_begin(void) {
    RPGHit *hit=battle_view_battle.hits+battle_view_hit_cursor;
    uint8_t boss;
    if(!selection_phase.barrier_reported&&battle_view_battle.barrier_break_before==battle_view_hit_cursor+1u){
        selection_phase.barrier_reported=1;one_line(0xb1c1,0,NEXT_MAGIC_BEGIN,0);return;
    }
    boss=boss_motion_begin(&boss_motion,battle_view_battle.enemy_id,hit->target);
    if(!boss)battle_motion_begin_magic(&enemy_motion,battle_view_battle.enemy_id);
    enemy_effect.active=0;magic_phase=motion_hit_hold=0;motion_last_frame=enemy_motion.frame;
    ui_panel(96,6);ui_text(1,0,enemy_name);ui_text(1,1,battle_view_battle.enemy_id==73u?"ATTACK":battle_view_battle.last_magic_mode==0x80u?"FIRE":"THUNDER");
    ui_text(1,3,names[hit->target]);ui_text(7,3,"HP");ui_number(11,3,(uint8_t)(hit->hp+hit->damage));
    audio_command(audio_enemy_effect(battle_view_battle.enemy_id));motion_clock=audio_clock;battle_view_state=boss?BVIEW_BOSS_ANIMATION:BVIEW_ENEMY_MAGIC;
}
#endif
static uint8_t present_action(void) {
#ifdef __SDCC
    uint8_t i;
#endif
    if(core_item_feedback()||support_feedback())return 1;
    if(!selection_phase.barrier_reported&&battle_view_battle.barrier_break_before==1u){selection_phase.barrier_reported=1;one_line(0xb1c1,0,NEXT_PRESENT_ACTION,0);return 1;}
        if(battle_view_battle.last_error!=RPG_OK){
            say(battle_view_battle.last_error==RPG_DEAD?0xb730:battle_view_battle.last_error==RPG_NO_MP?0xb6f7:battle_view_battle.last_error==RPG_ACTION_FAILED?0xb13d:0xbea1,NEXT_STEP,character_for_message(),0,0);return 1;
        }
        if(battle_view_battle.last_effect){
#ifdef __SDCC
            feedback_animated=0;
            if(battle_view_battle.last_actor>=4u && battle_view_battle.hit_count &&
               (battle_view_battle.enemy_id==72u||battle_view_battle.enemy_id==73u)){
                battle_view_hit_cursor=0;magic_hit_begin();return 1;
            }
            if(battle_view_battle.last_actor>=4u && battle_view_battle.last_magic_mode && battle_view_battle.hit_count &&
               battle_motion_begin_magic(&enemy_motion,battle_view_battle.enemy_id)){
                battle_view_hit_cursor=0;magic_hit_begin();return 1;
            }
            if(battle_view_battle.last_actor>=4u &&
               (battle_view_battle.last_effect==BATTLE_EFFECT_ATTACK || battle_view_battle.last_effect==BATTLE_EFFECT_MISS || battle_view_battle.last_effect==BATTLE_EFFECT_BLOCKED || battle_view_battle.last_effect==BATTLE_EFFECT_PETRIFY) &&
               battle_motion_begin(&enemy_motion,battle_view_battle.enemy_id)) {
                ui_panel(96,6);ui_text(1,0,enemy_name);ui_text(1,2,"ATTACK");
                motion_clock=audio_clock;motion_last_frame=enemy_motion.frame;motion_hit_hold=0;
                audio_command(audio_enemy_effect(battle_view_battle.enemy_id));battle_view_state=BVIEW_ENEMY_ANIMATION;return 1;
            }
            if(battle_view_battle.last_actor<4u && battle_view_battle.hit_count &&
               (battle_view_battle.last_effect==BATTLE_EFFECT_ATTACK || battle_view_battle.last_effect==BATTLE_EFFECT_MISS ||
                battle_view_battle.last_effect==BATTLE_EFFECT_FIRE || battle_view_battle.last_effect==BATTLE_EFFECT_THUNDER || battle_view_battle.last_effect==BATTLE_EFFECT_WIND)){
                i=battle_view_battle.last_effect==BATTLE_EFFECT_FIRE?16u:battle_view_battle.last_effect==BATTLE_EFFECT_THUNDER?17u:battle_view_battle.last_effect==BATTLE_EFFECT_WIND?18u:party->party[battle_view_battle.last_actor].weapon;
                if(battle_weapon_begin(&weapon_motion,i)){
                    battle_view_hit_cursor=0;ui_panel(96,6);ui_text(1,0,names[battle_view_battle.last_actor]);
                    ui_text(1,1,i==16u?"FIRE":i==17u?"THUNDER":i==18u?"WIND":"ATTACK");
                    motion_clock=audio_clock;battle_view_state=BVIEW_PLAYER_WEAPON;return 1;
                }
            }
#endif
            action_feedback();return 1;
        }
    return 0;
}
static void execute_step(void) {
    uint8_t safety=12,i;
    while(safety--){
        if(battle_view_battle.outcome!=RPG_ONGOING){result_screen();return;}
        if(battle_view_battle.turn_cursor>=12u){new_round();return;}
        for(i=0;i<4u;++i)previous_alive[i]=(party->party[i].status&1u)&&party->party[i].hp;
        rpg_battle_step(party,&battle_view_battle);selection_phase.barrier_reported=0;
        for(i=0;i<4u;++i)if(previous_alive[i]&&!party->party[i].hp && battle_view_battle.last_effect!=BATTLE_EFFECT_PETRIFY)deaths_pending|=1u<<i;
        if(battle_view_battle.enemy_id==EnemyID_GdDragn && (deaths_pending&2u) && battle_view_battle.outcome==RPG_DEFEAT)dragon_fall=1;
        if(present_action())return;
    }
}
static void resume(uint8_t next) {
    uint8_t i,result;
    RPGBattle *b=&battle_view_battle;
    switch(next){
    case NEXT_CHOOSE:
        if(battle_view_actor>=4u)battle_view_actor=0;
        while(battle_view_actor<3u && !eligible(battle_view_actor))++battle_view_actor;
        battle_view_choice=0;command_screen();break;
    case NEXT_STEP:
        if(deaths_pending){for(i=0;i<4u;++i)if(deaths_pending&(1u<<i))break;deaths_pending&=~(1u<<i);say(0xb728,NEXT_STEP,i,0,0);}
        else if(dragon_fall){dragon_fall=0;say(0xbf3b,NEXT_STEP,1,0,0);}
        else{battle_view_state=BVIEW_EXECUTE;execute_step();}break;
    case NEXT_PRESENT_ACTION:
        if(!present_action())resume(NEXT_STEP);break;
    case NEXT_PHYSICAL_DEATH:
        i=b->last_target;
        if(i<4u&&(deaths_pending&(1u<<i))){
            deaths_pending&=~(1u<<i);memset(&field_action,0,sizeof field_action);
            field_action.character=i;field_action.lines[0].dialogue=0xb728;field_action.line_count=1;
            if(dragon_fall){dragon_fall=0;field_action.lines[1].dialogue=0xbf3b;field_action.line_count=2;}
            item_line=0;item_after=NEXT_PHYSICAL_HOLD;item_next_line();
        }else resume(NEXT_PHYSICAL_HOLD);break;
    case NEXT_PHYSICAL_HOLD:close_delay(4u,NEXT_STEP);break;
    case NEXT_RESULT:result_screen();break;
    case NEXT_REWARDS:
        for(i=0;i<4u;++i){old_battle_magic[i]=party->party[i].battle_magic_count;old_map_magic[i]=party->party[i].map_magic_count;}
        rpg_claim_rewards(party,b);level_cursor=0;
        if(b->exp_reward)say(0xb604,NEXT_LEVEL,0,0,b->exp_reward);else resume(NEXT_CHEST);
        break;
    case NEXT_LEVEL:
        while(level_cursor<4u && !(b->leveled_mask&(1u<<level_cursor)))++level_cursor;
        if(level_cursor<4u){audio_command(0xba);say(0xb621,NEXT_LEARNED,level_cursor,0,0);}else resume(NEXT_CHEST);
        break;
    case NEXT_LEARNED:
        i=level_cursor++;
        if(old_battle_magic[i]!=party->party[i].battle_magic_count || old_map_magic[i]!=party->party[i].map_magic_count)say(0xb635,NEXT_LEVEL,i,0,0);
        else resume(NEXT_LEVEL);break;
    case NEXT_CHEST:if(b->chest_state==BATTLE_CHEST_PENDING){battle_view_chest_pending=1;rpg_battle_prepare_chest(party,b);chest_pose(0x3a);say(0xbce1,NEXT_ASK_CHEST,0,0,0);}else resume(NEXT_DONE);break;
    case NEXT_ASK_CHEST:say(0xb656,NEXT_PROMPT_CHEST,0,0,0);break;
    case NEXT_PROMPT_CHEST:prompt(PROMPT_CHEST);break;
    case NEXT_MONEY:
        if(b->money_reward)say(0xb648,NEXT_FOUND,0,0,b->money_reward);else resume(NEXT_FOUND);break;
    case NEXT_FOUND:if(b->item_reward)say(0xb592,NEXT_GIFT,0,b->item_reward,0);else resume(NEXT_CHEST_CLOSE);break;
    case NEXT_GIFT:
        /*28EE calls Inventory_AddItem only after the found-item text returns. */
        result=rpg_battle_open_chest(party,b);
        if(result==RPG_FULL)say(0xb671,NEXT_PROMPT_FULL,0,b->item_pending,0);
        else if(result==RPG_OK){audio_command(0xb3);resume(NEXT_CHEST_CLOSE);}
        else literal("CHEST UNAVAILABLE","",NEXT_CHEST_CLOSE);
        break;
    case NEXT_PROMPT_FULL:prompt(PROMPT_FULL);break;
    case NEXT_PROMPT_ABANDON:prompt(PROMPT_ABANDON);break;
    case NEXT_REPLACE:battle_view_choice=0;item_screen(1);break;
    case NEXT_APPLY_REPLACE:
        result=rpg_battle_replace_reward(party,b,replacement_slot);
        if(result==RPG_OK){audio_command(0xb3);say(0xb6ad,NEXT_CHEST_CLOSE,0,b->item_reward,0);}else resume(NEXT_REPLACE);
        break;
    case NEXT_TALK_REPLY:say(talk_texts[b->talk_index<19u?b->talk_index:0u],NEXT_DONE,character_for_message(),0,0);break;
    case NEXT_DEFEAT:say(0xbd23,NEXT_DONE,0,0,0);break;
    case NEXT_SPELLS:spell_screen();break;
    case NEXT_ITEMS:item_screen(0);break;
    case NEXT_TARGET:target_screen();break;
    case NEXT_BEGIN_TALK:start_resolution();break;
#ifdef __SDCC
    case NEXT_MAGIC_BEGIN:magic_hit_begin();break;
    case NEXT_MAGIC_DEATH:
        i=b->hits[battle_view_hit_cursor].target;
        if(!b->hits[battle_view_hit_cursor].hp){deaths_pending&=~(1u<<i);one_line(0xb728,0,NEXT_MAGIC_HOLD,i);}
        else resume(NEXT_MAGIC_HOLD);break;
    case NEXT_MAGIC_HOLD:
        motion_hit_hold=4;motion_clock=audio_clock;battle_view_state=BVIEW_ENEMY_MAGIC_HOLD;break;
#endif
    case NEXT_ITEM_LINE:
        if(field_action.lines[item_line].sound_after)audio_command(field_action.lines[item_line].sound_after);
        ++item_line;item_next_line();break;
    case NEXT_CHEST_CLOSE:
        /*28EE hides the chest before3464's six row-restoration waits, including
         * an empty chest and an abandoned full-inventory award. Keep B3 alive
         * across this boundary before the outer scene can restore its score. */
#ifdef __SDCC
        HIDE_WIN;HIDE_SPRITES;
#endif
        close_delay(6u,NEXT_DONE);break;
    case NEXT_DONE:
        if(b->outcome==RPG_ESCAPED||b->outcome==RPG_TALKED){
            /* 319E restores ten enemy rows (exceptDarkFalz) and four party
             * rows, then15FC waits once for the cleared scene upload. */
            close_delay(b->enemy_id==EnemyID_DarkFalz?4u:14u,NEXT_HIDE_RETURN);break;
        }
        resume(NEXT_RETURN);break;
    case NEXT_HIDE_RETURN:
#ifdef __SDCC
        DISPLAY_OFF;HIDE_WIN;battle_scene_clear();DISPLAY_ON;
#endif
        close_delay(1u,NEXT_RETURN);break;
    case NEXT_VICTORY_CLEAR:
#ifdef __SDCC
        DISPLAY_OFF;HIDE_WIN;battle_scene_clear();DISPLAY_ON;
#endif
        close_delay(1u,NEXT_VICTORY_UPLOAD);break;
    case NEXT_VICTORY_UPLOAD:
        if(b->enemy_id==EnemyID_Lassic||b->enemy_id==EnemyID_DarkFalz){audio_delay_start=audio_clock;audio_delay_frames=180u;battle_view_state=BVIEW_AUDIO_WAIT;}
        else{audio_command(0xd8);say(0xb71b,NEXT_REWARDS,0,0,0);}break;
    case NEXT_RETURN:
#ifdef __SDCC
        battle_scene_hide();
#endif
        if(b->outcome==RPG_ESCAPED||b->outcome==RPG_TALKED)audio_command(0xd8);
        if(battle_view_field_menu_pending){battle_view_state=BVIEW_CHEST_MENU;battle_view_result=BATTLE_VIEW_MENU;}
        else{battle_view_state=BVIEW_DONE;battle_view_result=b->outcome;}break;
    default:break;
    }
}
uint8_t battle_view_begin(RPGState *state,uint8_t enemy) RPG_BANKED {
    uint8_t error,track;
    party=state;battle_view_result=0;battle_view_dialogue_id=0;battle_view_text_revealing=0;battle_view_hit_cursor=0;deaths_pending=0;dragon_fall=0;battle_view_chest_pending=0;battle_view_field_menu_pending=0;battle_view_menu_allowed=1;
    error=rpg_battle_begin(party,&battle_view_battle,enemy);if(error)return error;
    track=audio_battle_track(enemy);if(track)audio_command(track);
    rpg_enemy_name(enemy&127u,enemy_name);
#ifdef __SDCC
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;battle_scene_begin(enemy&127u);DISPLAY_ON;
#endif
    new_round();return RPG_OK;
}
void battle_view_chest_begin(RPGState *state,uint8_t item,uint16_t money,uint8_t trap) RPG_BANKED {
    party=state;battle_view_result=0;battle_view_dialogue_id=0;battle_view_text_revealing=0;battle_view_hit_cursor=0;deaths_pending=0;dragon_fall=0;
    battle_view_field_menu_pending=0;battle_view_menu_allowed=1;
    memset(&battle_view_battle,0,sizeof(battle_view_battle));
    battle_view_battle.outcome=RPG_VICTORY;battle_view_battle.rewards_claimed=1;
    battle_view_battle.exp_claimed=1;battle_view_battle.chest_state=BATTLE_CHEST_PENDING;
    battle_view_battle.item_reward=item;battle_view_battle.money_reward=money;battle_view_battle.trap_chance=trap;
    rpg_battle_prepare_chest(party,&battle_view_battle);battle_view_chest_pending=1;
    chest_pose(0x3a);
    say(0xbd97,NEXT_ASK_CHEST,0,0,0);
}
void battle_view_chest_prompt(uint8_t search) RPG_BANKED {
    if(!battle_view_chest_pending)return;
    battle_view_result=0;chest_pose(0x3a);
    if(search)say(0xb569,NEXT_ASK_CHEST,0,0,0);else resume(NEXT_ASK_CHEST);
}
void battle_view_chest_open(void) RPG_BANKED {
    if(!battle_view_chest_pending)return;
    battle_view_result=0;audio_command(0xb0);chest_motion_begin(&chest_motion,battle_view_battle.chest_visual);
    chest_clock=audio_clock;battle_view_state=BVIEW_CHEST_ANIMATION;
#ifdef __SDCC
    HIDE_WIN;
#endif
}
void battle_view_chest_leave(void) RPG_BANKED {
    if(!battle_view_field_menu_pending&&!battle_view_chest_pending)return;
    battle_view_field_menu_pending=0;if(battle_view_chest_pending)rpg_battle_decline_chest(&battle_view_battle);
    battle_view_chest_pending=0;resume(NEXT_DONE);
}
void battle_view_chest_abandon(void) RPG_BANKED {
    if(!battle_view_field_menu_pending&&!battle_view_chest_pending)return;
    battle_view_field_menu_pending=0;if(battle_view_chest_pending)rpg_battle_decline_chest(&battle_view_battle);
    battle_view_chest_pending=0;
#ifdef __SDCC
    battle_scene_hide();
#endif
    battle_view_result=0;battle_view_state=0;battle_view_text_revealing=0;
}
uint8_t battle_view_tick(uint8_t keys,uint8_t pressed) RPG_BANKED {
    uint8_t count,id,next,yes,err;char glyph[2]; (void)keys;
    if(battle_view_state==BVIEW_ITEM_CLOSE){
        while((uint8_t)(audio_clock-message_clock)){++message_clock;if(!--item_close_frames){resume(item_after);return battle_view_result;}}
        return battle_view_result;
    }
#ifdef __SDCC
    if(battle_view_state==BVIEW_ENEMY_MAGIC_HOLD){
        while((uint8_t)(audio_clock-motion_clock)){
            ++motion_clock;if(--motion_hit_hold)continue;
            ++battle_view_hit_cursor;
            if(battle_view_hit_cursor<battle_view_battle.hit_count)magic_hit_begin();
            else if(!selection_phase.barrier_reported&&battle_view_battle.barrier_break_before){selection_phase.barrier_reported=1;one_line(0xb1c1,0,NEXT_STEP,0);}
            else{feedback_animated=1;resume(NEXT_STEP);}return battle_view_result;
        }return battle_view_result;
    }
    if(battle_view_state==BVIEW_BOSS_ANIMATION){
        if(audio_clock!=motion_clock){
            motion_clock=audio_clock;
            id=boss_motion_tick(&boss_motion);
            if(id&BOSS_MOTION_PATCH)battle_scene_boss_patch(boss_motion.patch);
            if(id&BOSS_MOTION_FRAME)battle_scene_boss_frame(boss_motion.frame,boss_motion.y);
            if(id&BOSS_MOTION_IMPACT){
                /* Lassic's magic marker unconditionally enters5E1D, even for
                 * a physical miss or an active Protection post-message. */
                if(battle_view_battle.enemy_id==72u||battle_view_battle.hits[battle_view_hit_cursor].damage){
                    audio_command(0xae);
                    /* Original7BC4 blocks inside this actor for ten VBlanks.
                     * Atomic commits supply those waits; returning to main's
                     * vsync between phases would double their visible length. */
                    for(motion_hit_hold=10u;motion_hit_hold;){--motion_hit_hold;battle_scene_flash_party(motion_hit_hold&1u,battle_view_battle.enemy_id==73u);}
                    ui_number(11,3,battle_view_battle.hits[battle_view_hit_cursor].hp);motion_clock=audio_clock;
                }else audio_command(0xbb);
            }
            if(id&BOSS_MOTION_DONE){
                if(battle_view_battle.enemy_id==72u && (battle_view_battle.hit_blocked&(1u<<battle_view_hit_cursor)))one_line(0xb1b2,0,NEXT_MAGIC_DEATH,battle_view_battle.hits[battle_view_hit_cursor].target);
                else if(battle_view_battle.enemy_id==73u&&!battle_view_battle.hits[battle_view_hit_cursor].damage)one_line(battle_view_battle.last_effect==BATTLE_EFFECT_BLOCKED?0xb1a3:0xb118,0,NEXT_MAGIC_DEATH,battle_view_battle.hits[battle_view_hit_cursor].target);
                else resume(NEXT_MAGIC_DEATH);
                return battle_view_result;
            }
        }return battle_view_result;
    }
    if(battle_view_state==BVIEW_ENEMY_MAGIC){
        while((uint8_t)(audio_clock-motion_clock)){
            ++motion_clock;
            if(magic_phase==2u){
                --motion_hit_hold;battle_scene_flash_party(motion_hit_hold&1u,0);
                if(motion_hit_hold)continue;
                ui_number(11,3,battle_view_battle.hits[battle_view_hit_cursor].hp);magic_phase=0;
            }else if(magic_phase==1u){
                id=enemy_magic_tick(&enemy_effect);
                if(id&ENEMY_MAGIC_SOUND)audio_command(enemy_magic_sound(&enemy_effect));
                if(id&ENEMY_MAGIC_FRAME)battle_scene_magic_frame(enemy_effect.frame);
                if(!(id&ENEMY_MAGIC_IMPACT))continue;
                battle_scene_weapon_clear();
                if(battle_view_battle.hit_blocked&(1u<<battle_view_hit_cursor)){audio_command(0xbb);magic_phase=0;}
                else{audio_command(0xae);motion_hit_hold=10;magic_phase=2;continue;}
            }
            id=battle_motion_tick(&enemy_motion);
            if((id&BATTLE_MOTION_FRAME)&&enemy_motion.frame!=motion_last_frame){battle_scene_animation_frame(enemy_motion.frame);motion_last_frame=enemy_motion.frame;}
            if(id&BATTLE_MOTION_IMPACT){enemy_magic_begin(&enemy_effect,battle_view_battle.enemy_id);magic_phase=1;}
            if(id&BATTLE_MOTION_DONE){
                if(battle_view_battle.hit_blocked&(1u<<battle_view_hit_cursor))one_line(0xb1b2,0,NEXT_MAGIC_DEATH,battle_view_battle.hits[battle_view_hit_cursor].target);
                else resume(NEXT_MAGIC_DEATH);
                return battle_view_result;
            }
        }return battle_view_result;
    }
    if(battle_view_state==BVIEW_PLAYER_WEAPON){
        while((uint8_t)(audio_clock-motion_clock)){
            ++motion_clock;id=battle_weapon_tick(&weapon_motion);
            if(id&WEAPON_MOTION_SOUND)audio_command(battle_weapon_sound(weapon_motion.effect));
            if(id&WEAPON_MOTION_FRAME)battle_scene_weapon_frame(weapon_motion.frame);
            if(id&WEAPON_MOTION_CLEAR)battle_scene_weapon_clear();
            if(id&WEAPON_MOTION_DONE){
                if(battle_view_battle.last_effect!=BATTLE_EFFECT_MISS){motion_hit_hold=10;audio_command(0xad);battle_view_state=BVIEW_PLAYER_HIT;}
                else{audio_command(0xbb);feedback_animated=1;action_feedback();}return battle_view_result;
            }
        }
        return battle_view_result;
    }
    if(battle_view_state==BVIEW_PLAYER_HIT){
        while((uint8_t)(audio_clock-motion_clock)){
            ++motion_clock;--motion_hit_hold;battle_scene_flash_enemy(motion_hit_hold&1u);
            if(!motion_hit_hold){
                if(battle_view_battle.enemy_id!=EnemyID_DarkFalz){
                    ui_text(1,3,"ENEMY HP");ui_number(11,3,battle_view_battle.hits[battle_view_hit_cursor].hp);
                }
                ++battle_view_hit_cursor;
                if(battle_view_hit_cursor<battle_view_battle.hit_count){
                    battle_weapon_begin(&weapon_motion,weapon_motion.effect);battle_view_state=BVIEW_PLAYER_WEAPON;
                }else{feedback_animated=1;action_feedback();}
                return battle_view_result;
            }
        }
        return battle_view_result;
    }
    if(battle_view_state==BVIEW_ENEMY_ANIMATION){
        while((uint8_t)(audio_clock-motion_clock)) {
            ++motion_clock;if(motion_hit_hold){
                --motion_hit_hold;battle_scene_flash_party(motion_hit_hold&1u,battle_view_battle.enemy_id==70u||battle_view_battle.enemy_id==73u||battle_view_battle.enemy_id==74u);continue;
            }id=battle_motion_tick(&enemy_motion);
            if((id&BATTLE_MOTION_FRAME) && enemy_motion.frame!=motion_last_frame){battle_scene_animation_frame(enemy_motion.frame);motion_last_frame=enemy_motion.frame;}
            if(id&BATTLE_MOTION_IMPACT){audio_command(battle_view_battle.last_damage?0xae:0xbb);if(battle_view_battle.last_damage)motion_hit_hold=10;}
            if(id&BATTLE_MOTION_DONE){feedback_animated=1;action_feedback();return battle_view_result;}
        }
        return battle_view_result;
    }
#endif
    if(battle_view_state==BVIEW_CHEST_MENU)return BATTLE_VIEW_MENU;
    if(battle_view_state==BVIEW_CHEST_ANIMATION){
        while((uint8_t)(audio_clock-chest_clock)) {
            ++chest_clock;err=chest_motion.hold;id=chest_motion_tick(&chest_motion);
#ifdef __SDCC
            if(err)battle_scene_flash_party(chest_motion.hold&1u,battle_view_battle.enemy_id==70u||battle_view_battle.enemy_id==73u||battle_view_battle.enemy_id==74u);
            if(id&CHEST_MOTION_FRAME)chest_show(chest_motion.frame);
#endif
            if(id&CHEST_MOTION_SOUND)audio_command(chest_motion.visual==0x3eu?0xb1:0xb2);
            if(id&CHEST_MOTION_DONE){
                /* Resolve source trap/money after actor animation, but stage
                 * the item until B592 completes. The pure rules API retains
                 * its immediate whole-chest contract for standalone callers. */
                id=battle_view_battle.item_reward;battle_view_battle.item_reward=0;
                err=rpg_battle_open_chest(party,&battle_view_battle);
                battle_view_battle.item_reward=id;
                if(err==RPG_OK&&id){battle_view_battle.item_pending=id;battle_view_battle.rewards_claimed=0;}
                battle_view_chest_pending=0;
                if(err!=RPG_OK&&err!=RPG_FULL)literal("CHEST UNAVAILABLE","",NEXT_DONE);
                else if(!battle_view_battle.money_reward&&!battle_view_battle.item_reward)say(0xb665,NEXT_CHEST_CLOSE,0,0,0);
                else resume(NEXT_MONEY);return battle_view_result;
            }
        }
        return battle_view_result;
    }
    if(battle_view_state==BVIEW_AUDIO_WAIT){if((uint8_t)(audio_clock-audio_delay_start)>=audio_delay_frames){audio_command(0xd8);say(0xb71b,NEXT_REWARDS,0,0,0);}return battle_view_result;}
    if(battle_view_state==BVIEW_DONE)return battle_view_result;
    if(battle_view_state==BVIEW_EXECUTE){execute_step();return battle_view_result;}
    if(battle_view_state==BVIEW_MESSAGE){
        if(battle_view_text_revealing){
            if((uint8_t)(audio_clock-message_clock)){
                message_clock=audio_clock;count=message.row;next=message.column;
                id=dialogue_stream_next(&message,0);
                if(id==DIALOGUE_STREAM_SCROLL||(id==DIALOGUE_STREAM_CHAR&&(message.row<count||(message.row==count&&message.column<=next)))){
                    ui_text(1,1,message.lines[0]);ui_text(1,2,message.lines[1]);
                }else if(id==DIALOGUE_STREAM_CHAR){
                    glyph[0]=message.lines[message.row][message.column-1u];glyph[1]=0;
                    ui_text(message.column,1u+message.row,glyph);
                }
                else if(id==DIALOGUE_STREAM_WAIT){
                    battle_view_text_revealing=0;message_wait=dialogue_wait_frames(message.done?message.terminator:0x61u,0);
                    if(!message_wait){if(!message.done)message_page();else resume(after_message);}
                    else if(message_wait==65535u)ui_text(17,4,">");return battle_view_result;
                }
                /* If VRAM upload crossed LY0, the completed glyph belongs to
                 * that newer frame. Never catch up with another visible glyph. */
                message_clock=audio_clock;
            }
            return battle_view_result;
        }
        if(is_literal?(pressed&(J_A|J_B)):dialogue_wait_tick(&message_wait,message.done?message.terminator:0x61u,0,pressed&(J_A|J_B))){if(!is_literal&&!message.done)message_page();else resume(after_message);}
        return battle_view_result;
    }
    if(battle_view_state==BVIEW_PROMPT){
        if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN)){
            battle_view_choice^=1u;ui_text(1,1,battle_view_choice?" ":">");ui_text(10,1,battle_view_choice?">":" ");
        }
        if(!(pressed&(J_A|J_B)))return battle_view_result;
        yes=!battle_view_choice;
        if(prompt_kind==PROMPT_CHEST){
            if(!yes){
                if(battle_view_menu_allowed){battle_view_field_menu_pending=1;battle_view_state=BVIEW_CHEST_MENU;battle_view_result=BATTLE_VIEW_MENU;}
                else{battle_view_chest_pending=0;rpg_battle_decline_chest(&battle_view_battle);resume(NEXT_DONE);}
            }
            else battle_view_chest_open();
        }else if(prompt_kind==PROMPT_FULL){
            if(yes)say(0xb68c,NEXT_REPLACE,0,0,0);else say(0xb6c1,NEXT_PROMPT_ABANDON,0,battle_view_battle.item_pending,0);
        }else{
            if(yes){id=battle_view_battle.item_pending;rpg_battle_decline_chest(&battle_view_battle);say(0xb6d0,NEXT_CHEST_CLOSE,0,id,0);}
            else say(0xb68c,NEXT_REPLACE,0,0,0);
        }
        return battle_view_result;
    }
    if(battle_view_state==BVIEW_COMMAND){
        if(pressed&J_B){
            next=battle_view_actor;while(next){--next;if(eligible(next))break;}
            if(eligible(next))battle_view_actor=next;
            battle_view_choice=0;command_screen();return battle_view_result;
        }
        if(pressed&(J_UP|J_LEFT)){battle_view_choice=battle_view_choice?battle_view_choice-1u:4u;command_screen();}
        if(pressed&(J_DOWN|J_RIGHT)){battle_view_choice=(battle_view_choice+1u)%5u;command_screen();}
        if(!(pressed&J_A))return battle_view_result;
        if(battle_view_choice==0u){actions[battle_view_actor].kind=RPG_ACT_ATTACK;next_character();}
        else if(battle_view_choice==1u){
            battle_view_choice=0;
            if(!rpg_spell_option(party,battle_view_actor,0,1))say(battle_view_actor==2u?0xb5ba:0xb5c8,NEXT_CHOOSE,battle_view_actor,0,0);
            else spell_screen();
        }else if(battle_view_choice==2u){battle_view_choice=0;item_screen(0);}
        else{actions[battle_view_actor].kind=battle_view_choice==3u?RPG_ACT_TALK:RPG_ACT_RUN;if(battle_view_choice==3u)say(0xb128,NEXT_BEGIN_TALK,battle_view_actor,0,0);else start_resolution();}
        return battle_view_result;
    }
    if(battle_view_state==BVIEW_SPELL){
        count=0;while(count<5u&&rpg_spell_option(party,battle_view_actor,count,1))++count;
        if(pressed&J_B){battle_view_choice=1;command_screen();return battle_view_result;}
        if(count && (pressed&(J_UP|J_LEFT))){battle_view_choice=battle_view_choice?battle_view_choice-1u:count-1u;spell_screen();}
        if(count && (pressed&(J_DOWN|J_RIGHT))){battle_view_choice=(battle_view_choice+1u)%count;spell_screen();}
        if(!(pressed&J_A)||!count)return battle_view_result;
        selected_spell=rpg_spell_option(party,battle_view_actor,battle_view_choice,1);
        if(party->party[battle_view_actor].mp<rpg_magic_cost(selected_spell)){say(0xb6f7,NEXT_SPELLS,battle_view_actor,0,0);return battle_view_result;}
        actions[battle_view_actor].kind=RPG_ACT_MAGIC;actions[battle_view_actor].id=selected_spell;
        if(selected_spell==MagicID_Heal||selected_spell==MagicID_Cure||selected_spell==MagicID_Help){battle_view_choice=battle_view_actor;target_screen();}
        else if(selected_spell==MagicID_Chat||selected_spell==MagicID_Tele)start_resolution();
        else next_character();
        return battle_view_result;
    }
    if(battle_view_state==BVIEW_TARGET){
        if(pressed&J_B){battle_view_choice=0;spell_screen();return battle_view_result;}
        if(pressed&(J_UP|J_LEFT)){do{battle_view_choice=(battle_view_choice+3u)&3u;}while(!(party->joined_mask&(1u<<battle_view_choice)));target_screen();}
        if(pressed&(J_DOWN|J_RIGHT)){do{battle_view_choice=(battle_view_choice+1u)&3u;}while(!(party->joined_mask&(1u<<battle_view_choice)));target_screen();}
        if(pressed&J_A){
            if(!(party->party[battle_view_choice].status&1u))say(0xb730,NEXT_TARGET,battle_view_choice,0,0);
            else{actions[battle_view_actor].target=battle_view_choice;next_character();}
        }
        return battle_view_result;
    }
    if(battle_view_state==BVIEW_ITEM||battle_view_state==BVIEW_REPLACE){
        next=battle_view_state==BVIEW_REPLACE;
        if(pressed&J_B){if(next)say(0xb671,NEXT_PROMPT_FULL,0,battle_view_battle.item_pending,0);else{battle_view_choice=2;command_screen();}return battle_view_result;}
        count=party->inventory_count;
        if(count&&(pressed&(J_UP|J_LEFT))){battle_view_choice=battle_view_choice?battle_view_choice-1u:count-1u;item_screen(next);}
        if(count&&(pressed&(J_DOWN|J_RIGHT))){battle_view_choice=(battle_view_choice+1u)%count;item_screen(next);}
        if(!(pressed&J_A)||!count)return battle_view_result;
        selected_slot=battle_view_choice;id=party->inventory[selected_slot];
        if(next){
            if(!rpg_item_discardable(id))say(0xb6de,NEXT_REPLACE,0,id,0);
            else{replacement_slot=selected_slot;say(0xb69e,NEXT_APPLY_REPLACE,0,id,0);}
        }else{
            actions[battle_view_actor].kind=RPG_ACT_ITEM;actions[battle_view_actor].id=id;next_character();
        }
    }
    return battle_view_result;
}
