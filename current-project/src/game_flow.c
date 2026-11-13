#pragma bank 12
#include <gb/gb.h>
#include <string.h>
#include "game_flow.h"
#include "game_ui.h"
#include "world.h"
#include "world_rules.h"
#include "events.h"
#include "services.h"
#include "battle_view.h"
#include "battle_scene.h"
#include "dungeon_play.h"
#include "scene.h"
#include "audio.h"
#include "game_sequence.h"
#include "game_movie.h"
#include "game_transition.h"
#include "travel.h"
extern RPGState game_rpg;
extern EventState game_events;
extern ServiceState game_service;
extern DungeonPlay game_dungeon;
extern WorldAction world_action,ship_departure,ship_arrival,ship_exit;
extern uint16_t player_x,player_y,battle_object_flag;
extern uint8_t screen_state,choice,menu_choice,replace_source,item_slot,title_choice,saved_position_valid;
extern uint8_t service_active,service_selector,battle_from_event;
extern uint8_t retained_trap,background_changed,dark_menu_pending,dungeon_keys_delay;
extern uint8_t game_vehicle,scene_context_type;
void resume_walk(void);
void begin_battle(uint8_t,uint8_t);
void draw_dungeon(void);
void draw_dungeon_faded(void);
void enter_map(uint8_t,uint16_t,uint16_t);
void show_dialogue(uint16_t);
void apply_service(void);
void start_cutscene(uint8_t);
static void flow_notice(const char *text,uint8_t state) {
 char copy[21];uint8_t i=0;while(text[i]&&i<20u){copy[i]=text[i];++i;}copy[i]=0;notice(copy,state);
}
#define notice flow_notice
#define STATE_TITLE 0u
#define STATE_WALK 1u
#define STATE_MENU 2u
#define STATE_HELP 3u
#define STATE_DIALOGUE 4u
#define STATE_PROMPT 5u
#define STATE_SHOP 6u
#define STATE_REPLACE 7u
#define STATE_NOTICE 8u
#define STATE_INVENTORY 9u
#define STATE_ITEM 10u
#define STATE_PARTY 11u
#define STATE_BUY 12u
#define STATE_STATUS 13u
#define STATE_BUY_SELL 14u
#define STATE_BATTLE 15u
#define STATE_TRAVEL_MENU 16u
#define STATE_DUNGEON 17u
#define STATE_CUTSCENE 18u
static void event_presentation(uint8_t effect) {
    if(effect==EVENT_PRESENT_SUEL_HEAL)return;
    if(effect==EVENT_PRESENT_GUEST_WAKE){game_transition_fade_in();return;}
    if(effect==EVENT_PRESENT_GUEST_SLEEP) {
        game_transition_fade_out();game_transition_close();audio_command(0xa0);
        game_transition_wait(208u,1u);
        /* Restore the original room colors while keeping its picture black.
         * The palette target is retained by scene_fade_begin(0) above. */
        return;
    }
    if(effect==EVENT_PRESENT_NIGHTMARE_HOLD) {
        game_transition_close();audio_command(0xa0);game_transition_wait(208u,1u);return;
    }
    game_transition_fade_out();
    if(effect==EVENT_PRESENT_NIGHTMARE_SCENE)game_transition_close();
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;scene_actor_hide();
    scene_show(32u,0u,0u);scene_context_type=32u;background_changed=1;
    scene_fade_begin(1u);DISPLAY_ON;
    game_transition_wait(1u,0u);game_transition_fade_in();
}
void apply_event(void) RPG_BANKED {
    EventAction *a=&game_events.action;
    if(a->sound){audio_command(a->sound);a->sound=0;}
    if(a->kind==EVENT_PRESENTATION){event_presentation(a->target);event_advance(&game_events);apply_event();return;}
    if(a->kind==EVENT_DONE) resume_walk();
    else if(a->kind==EVENT_MENU) {menu_choice=0;menu_screen();}
    else if(a->kind==EVENT_BATTLE) {
        begin_battle(a->target,1);
        if(game_events.battle.options&EVENT_BATTLE_OVERRIDE_ITEM) battle_view_battle.item_reward=game_events.battle.item_reward;
        if(game_events.battle.options&EVENT_BATTLE_ZERO_MONEY) battle_view_battle.money_reward=0;
    }
    else if(a->kind==EVENT_DUNGEON)enter_dungeon(a->target,a->a,a->b);
    else if(a->kind==EVENT_DARK_FALZ_REVEAL)start_dark_falz_reveal();
    else if(a->kind==EVENT_GOVERNOR_ROOM)start_governor_room();
    else if(a->kind==EVENT_DUNGEON_FALL) {
        uint8_t close_frames;
        /* Original4C70 keeps the governor room visible for661C. The staged
         * floor34 is decremented by the fall before loading the maze. */
        HIDE_WIN;for(close_frames=0;close_frames<6u;++close_frames)vsync();
        if(scene_actor_active)scene_actor_hide();
        game_vehicle=0;game_events.type=0;game_events.event=0;dark_menu_pending=0;background_changed=0;
        dplay_scene_fall(&game_dungeon,&game_rpg,&game_events,a->target,a->a,a->b,retained_trap);
        game_transition_map_music(0x85);apply_dungeon();
    }
    else if(a->kind==EVENT_DUNGEON_BACK) {
        dplay_escape(&game_dungeon,&game_rpg,&game_events);apply_dungeon();
    }
    else if(a->kind==EVENT_DUNGEON_CELL) {
        if(game_dungeon.active)game_dungeon.dungeon.layout[a->target]=a->a;
        event_advance(&game_events);apply_event();
    }
    else if(a->kind==EVENT_SCENE) {
        if(scene_actor_active)scene_actor_hide();
        DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
        if(scene_show(a->target,0,0)){background_changed=1;scene_context_type=a->target;}
        DISPLAY_ON;event_advance(&game_events);apply_event();
    }
    else if(a->kind==EVENT_CUTSCENE)start_recruitment(a->target);
    else if(a->kind==EVENT_ENDING)start_ending();
    else if(a->kind==EVENT_GAME_OVER) {title_choice=saved_position_valid?1u:0u;notice("GAME OVER",STATE_TITLE);}
    else if(a->kind==EVENT_TRAVEL_MENU) {choice=0;travel_menu();}
    else if(a->kind==EVENT_TRAVEL) {
        start_travel(a->target);
    }
    else if(a->kind==EVENT_DIALOGUE||a->kind==EVENT_YES_NO) show_dialogue(a->dialogue_id);
    else if(a->kind==EVENT_SHOP||a->kind==EVENT_HOSPITAL||a->kind==EVENT_CHURCH||a->kind==EVENT_SELL) {
        service_active=1;service_begin(&game_service,&game_events,game_events.type,game_events.event);apply_service();
    }
    else if(a->kind==EVENT_REPLACE_ITEM) {replace_source=1;item_slot=0;inventory_screen();}
    else if(a->kind==EVENT_TRANSITION) {
        start_travel(a->target);
    } else if(a->kind==EVENT_MAP_TRANSITION) {
        uint16_t x,y;world_action.target=a->target;world_action.a=a->a;world_action.b=a->b;
        world_decode_destination(&world_action,&x,&y);enter_map(world_action.target,x,y);
    } else notice("EVENT NOT YET PORTED",STATE_WALK);
}

void apply_dungeon(void) RPG_BANKED {
    DungeonPlayAction *a=&game_dungeon.action;
    uint16_t x,y;uint8_t type;
    retained_trap=game_dungeon.retained_trap;
    if(a->kind==DPLAY_VIEW){draw_dungeon();screen_state=STATE_DUNGEON;dungeon_keys_delay=8;}
    else if(a->kind==DPLAY_MENU){menu_choice=0;menu_screen();}
    else if(a->kind==DPLAY_BATTLE) {
        battle_object_flag=a->flag_address;begin_battle(a->target,2);
        if(a->type)battle_view_battle.item_reward=a->a;
    }
    else if(a->kind==DPLAY_CHEST) {
        draw_dungeon();battle_from_event=2;battle_object_flag=a->flag_address;
        retained_trap=a->a;
        battle_scene_configure(scene_context_type,game_dungeon.dungeon.palette_index);
        battle_view_chest_begin(&game_rpg,a->target,a->money,retained_trap);screen_state=STATE_BATTLE;
    }
    else if(a->kind==DPLAY_EVENT) {
        draw_dungeon();
        type=a->type==255u?game_events.type:a->type;
        if(a->type) {
            /* Original68EC/6947 room transitions are distinct from the
             * overworld LoadInteraction: no D6/music and one0C upload. */
            game_transition_fade_out();background_changed=1;
            if(a->b>=253u) {
                DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;scene_actor_hide();
                if(a->b==255u) {
                    scene_show_room(game_dungeon.dungeon.palette_index,0u,0u);
                    scene_context_type=64u+game_dungeon.dungeon.palette_index;
                } else {scene_show(type,0u,0u);scene_context_type=type;}
                background_changed=1;scene_fade_begin(1u);DISPLAY_ON;
                game_transition_wait(1u,0u);game_transition_fade_in();
            }
        }
        /* Original6A2F begins event state changes after the room fade. */
        event_begin(&game_events,type,a->target,a->a,world_map_id);
        DISPLAY_OFF;
        if(game_events.prepared_enemy)scene_enemy_show(game_events.prepared_enemy,game_dungeon.dungeon.palette_index);
        else scene_portrait_show(game_events.portrait);
        DISPLAY_ON;
        apply_event();
    }
    else if(a->kind==DPLAY_MAP) {
        world_action.target=a->target;world_action.a=a->a;world_action.b=a->b;
        world_decode_destination(&world_action,&x,&y);enter_map(world_action.target,x,y);
    }
    else if(a->kind==DPLAY_EXIT)enter_map(world_map_id,player_x,player_y);
    else if(a->kind==DPLAY_DARK) {
        draw_dungeon();dark_menu_pending=1;
        game_events.action.kind=EVENT_MENU;game_events.action.dialogue_id=0xb392;show_dialogue(0xb392);
    }
    else notice("DUNGEON STATE ERROR",STATE_WALK);
}

void show_interaction_scene(uint8_t type,uint8_t portrait,uint8_t enemy) RPG_BANKED {
    uint8_t music;
    audio_command(0xd6);game_transition_fade_out();
    scene_context_type=type;
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;scene_actor_hide();
    if(scene_show(type,0u,0u))background_changed=1;
    music=game_transition_interaction_music(type);if(music)audio_command(music);
    scene_fade_begin(1u);DISPLAY_ON;
    game_transition_wait(2u,0u); /* Original0C upload, then2FD's14 upload. */
    game_transition_fade_in();
    /* GameMode_Interaction08 samples controls, then617D prepares the actor. */
    game_transition_wait(1u,1u);
    if(portrait||enemy){
        DISPLAY_OFF;
        if(enemy)scene_enemy_show(enemy,game_dungeon.active?game_dungeon.dungeon.palette_index:0u);
        else scene_portrait_show(portrait);
        DISPLAY_ON;
    }
}

void enter_dungeon(uint8_t floor,uint8_t position,uint8_t direction) RPG_BANKED {
    game_transition_fade_out();
    if(game_vehicle){scene_actor_hide();game_vehicle=0;}
    game_events.type=0;game_events.event=0;background_changed=1;dark_menu_pending=0;
    dplay_enter(&game_dungeon,&game_rpg,&game_events,floor,position,direction,retained_trap);
    game_transition_map_music(game_dungeon.dungeon.music);
    draw_dungeon_faded();
    game_transition_wait(2u,0u);game_transition_fade_in();apply_dungeon();
}
