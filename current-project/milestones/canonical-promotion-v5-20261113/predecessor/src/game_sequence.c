#pragma bank 14
#include <gb/gb.h>
#include "game_sequence.h"
#include "game_ui.h"
#include "presentation.h"
#include "travel.h"
#include "cutscene.h"
#include "field_actions.h"
#include "scene.h"
#include "audio.h"
#include "game_movie.h"
#include "game_field.h"
#include "party_world.h"
#include "game_transition.h"
#include "world_motion.h"
extern uint8_t screen_state,background_changed,facing,game_vehicle;
void start_cutscene(uint8_t);
void enter_map_ready(uint8_t,uint16_t,uint16_t);
static uint8_t effect_kind,travel_tag,travel_fade_clock,travel_fade_step,travel_keys;
static TravelState game_travel;
static void begin_effect(uint8_t effect) {
    DISPLAY_OFF;if(effect!=PRESENT_TORCH)HIDE_WIN;
    presentation_begin(effect);effect_kind=effect;background_changed=1;
    SHOW_BKG;DISPLAY_ON;screen_state=STATE_PRESENTATION;
}
void start_recruitment(uint8_t sequence) RPG_BANKED {
    if(sequence==CUTSCENE_ODIN)begin_effect(PRESENT_ODIN);
    else start_cutscene(sequence);
}
void start_field_scene(uint8_t kind) RPG_BANKED {
    if(kind==FIELD_PRISM)begin_effect(PRESENT_PRISM);
    else if(kind==FIELD_TORCH_SCENE)begin_effect(PRESENT_TORCH);
    else if(kind==FIELD_MYAU_FLY)start_myau_flight();
    else {char message[]="SCENE NOT YET PORTED";notice(message,2);}
}
void start_travel(uint8_t tag) RPG_BANKED {
    travel_tag=tag;travel_fade_clock=audio_clock;travel_fade_step=0;
    scene_fade_begin(0u);
    travel_keys=joypad();HIDE_WIN;screen_state=STATE_TRAVEL;
}
void game_sequence_tick(uint8_t keys,uint8_t pressed) RPG_BANKED {
    uint8_t flags,skip=0;
    if(screen_state==STATE_PRESENTATION) {
        if(!presentation_tick())return;
        if(effect_kind==PRESENT_ODIN)screen_state=STATE_ODIN_WAIT;
        else if(effect_kind==PRESENT_TORCH)game_field_scene_done();
        else menu_screen();
    } else if(screen_state==STATE_ODIN_WAIT) {
        if(pressed&(J_A|J_B))start_cutscene(CUTSCENE_ODIN);
    } else if(screen_state==STATE_TRAVEL) {
        if(travel_tag) {
            if(!game_transition_vint16())return;
            scene_fade_step(travel_fade_step+1u,0u);
            if(++travel_fade_step<9u)return;
            flags=travel_begin(&game_travel,travel_tag);game_travel.fade_clock=game_fade_clock;travel_tag=0;game_vehicle=0;
        } else {
            if(game_travel.stage==TRAVEL_ROAD||game_travel.stage==TRAVEL_ASCEND||
               game_travel.stage==TRAVEL_SPACE_RUN||game_travel.stage==TRAVEL_ARRIVE) {
                skip=(keys&~travel_keys)&(J_A|J_B);travel_keys=keys;
            }
            if(game_travel.stage==TRAVEL_ROAD)world_motion_step();
            /* Road movement uses the same original follower actors, but
             * source5B30 keeps standing poses while C2E9 is nonzero. */
            if(game_travel.stage==TRAVEL_ROAD&&!skip) {
                uint8_t mask=1u<<(game_travel.facing<2u?game_travel.facing^1u:game_travel.facing);
                party_world_tick(mask,15u-game_travel.step_pixels,mask);
            }
            game_travel.fade_clock=game_fade_clock;
            flags=travel_step(&game_travel,skip);game_fade_clock=game_travel.fade_clock;
        }
        if(flags&TRAVEL_AUDIO){
            if(flags&TRAVEL_WORLD)game_transition_map_music(game_travel.music);
            else audio_command(game_travel.music);
        }
        if(flags)travel_present(&game_travel,flags);
        if(flags&TRAVEL_DONE) {
            facing=game_travel.facing;enter_map_ready(game_travel.map,game_travel.x,game_travel.y);
        }
    }
}
