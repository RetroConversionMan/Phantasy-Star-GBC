#pragma bank 121
#include <gb/gb.h>
#include "game_movie.h"
#include "game_ui.h"
#include "opening.h"
#include "myau_flight.h"
#include "ending_walk.h"
#include "travel.h"
#include "presentation.h"
#include "cutscene.h"
#include "scene.h"
#include "gold_scene.h"
#include "audio.h"
#include "world.h"
#include "dungeon_play.h"
#include "game_flow.h"
#include "game_transition.h"
extern uint8_t screen_state,background_changed,scene_context_type,title_choice,saved_position_valid;
extern DungeonPlay game_dungeon;
extern EventState game_events;
void start_cutscene(uint8_t);
void start_movie_text(uint16_t);
void enter_map(uint8_t,uint16_t,uint16_t);
void begin_battle(uint8_t,uint8_t);
uint8_t game_movie_mode,game_movie_stage;
static uint8_t movie_keys,fade_in,fade_step,fade_clock,returning,text_index;
static uint16_t hold_frames;
enum {INTRO_OUT=1,INTRO_IN,INTRO_PAN,INTRO_HOLD,CITY_OUT,CITY_WAIT,CITY_IN,CITY_HOLD,INTRO_TEXT_OUT,INTRO_TEXT,
 MYAU_TEXT_OUT=20,MYAU_TEXT,FLIGHT_OUT,FLIGHT_WAIT,FLIGHT_IN,FLIGHT_MOVE,FLIGHT_END,GOLD_WAIT,GOLD_IN,GOLD_HOLD,GOLD_BATTLE,
 END_OUT=40,END_WAIT,END_IN,END_HOLD,END_SKY,END_TEXT,END_STORY_OUT,END_STORY,END_IMAGE_OUT,END_IMAGE_WAIT,END_IMAGE_IN,END_IMAGE_HOLD,END_WALK,
 DARK_HOLD=60,DARK_WAIT,DARK_IN,DARK_UPLOAD,DARK_REVEAL,GOV_OUT,GOV_WAIT,GOV_IN,GOV_ACTOR};
static const uint16_t ending_texts[6]={0xbeb6,0xbed0,0xbee8,0xbefd,0xbf09,0xbf21};
static void fade(uint8_t stage,uint8_t in) {
    game_movie_stage=stage;screen_state=STATE_MOVIE;fade_in=in;fade_step=0;fade_clock=audio_clock;
    HIDE_WIN;if(!in)scene_fade_begin(0);
}
static uint8_t fade_done(void) {
    uint8_t elapsed=audio_clock-fade_clock;fade_clock=audio_clock;
    while(elapsed--){
        if(!game_transition_vint16())continue;
        ++fade_step;if(fade_step<=9u)scene_fade_step(fade_step,fade_in);
        if(fade_step>=(fade_in?10u:9u))return 1;
    }
    return 0;
}
static uint8_t action_edge(uint8_t keys) {
    uint8_t pressed=(keys&~movie_keys)&(J_A|J_B);movie_keys=keys;return pressed;
}
static void movie_begin(uint8_t mode) {
    game_movie_mode=mode;movie_keys=joypad();background_changed=1;HIDE_WIN;
}
void start_opening(void) RPG_BANKED {
    movie_begin(1);audio_command(0xd7);fade(INTRO_OUT,0);
}
void start_ending(void) RPG_BANKED {
    movie_begin(3);fade(END_OUT,0);
}
void start_myau_flight(void) RPG_BANKED {
    movie_begin(2);returning=world_map_id==23u;
    fade(returning?FLIGHT_OUT:MYAU_TEXT_OUT,0);
}
void start_dark_falz_reveal(void) RPG_BANKED {
    movie_begin(4);audio_command(0x93);hold_frames=208u;fade_clock=audio_clock;
    game_movie_stage=DARK_HOLD;screen_state=STATE_MOVIE;
}
void start_governor_room(void) RPG_BANKED {
    movie_begin(5);fade(GOV_OUT,0);
}
uint8_t game_movie_story_done(void) RPG_BANKED {
    if(game_movie_mode==1u&&game_movie_stage==INTRO_TEXT) {
        game_movie_mode=0;audio_command(0xd7);enter_map(WORLD_START_MAP,WORLD_START_X,WORLD_START_Y);return 1;
    }
    if(game_movie_mode==2u&&game_movie_stage==MYAU_TEXT){fade(FLIGHT_OUT,0);return 1;}
    if(game_movie_mode==3u&&game_movie_stage==END_STORY){fade(END_IMAGE_OUT,0);return 1;}
    return 0;
}
void game_movie_text_done(void) RPG_BANKED {
    if(game_movie_mode!=3u||game_movie_stage!=END_TEXT)return;
    if(++text_index<6u)start_movie_text(ending_texts[text_index]);
    else fade(END_STORY_OUT,0);
}
void game_movie_battle_done(uint8_t outcome) RPG_BANKED {
    game_movie_mode=0;
    if(outcome==RPG_DEFEAT){title_choice=saved_position_valid?1u:0u;title_screen();}
    else enter_map(23u,504u,528u); /* Original4511:17,28,1F. */
}
void game_movie_tick(uint8_t keys) RPG_BANKED {
    uint8_t pressed,elapsed;
    switch(game_movie_stage) {
    case INTRO_OUT:
        if(!fade_done())break;
        DISPLAY_OFF;opening_begin();audio_command(0x8c);scene_fade_begin(1);DISPLAY_ON;
        fade(INTRO_IN,1);break;
    case INTRO_IN:if(fade_done())game_movie_stage=INTRO_PAN;break;
    case INTRO_PAN:
        pressed=action_edge(keys);if(!opening_tick(pressed))break;
        if(pressed)fade(CITY_OUT,0);else{hold_frames=180;game_movie_stage=INTRO_HOLD;}break;
    case INTRO_HOLD:
        if(action_edge(keys)||!--hold_frames)fade(CITY_OUT,0);break;
    case CITY_OUT:
        if(!fade_done())break;
        DISPLAY_OFF;movie_scene_show(MOVIE_OPENING_CITY);scene_fade_begin(1);DISPLAY_ON;
        game_movie_stage=CITY_WAIT;break;
    case CITY_WAIT:fade(CITY_IN,1);break;
    case CITY_IN:
        if(fade_done()){movie_city_caption();hold_frames=180;game_movie_stage=CITY_HOLD;}break;
    case CITY_HOLD:if(action_edge(keys)||!--hold_frames)fade(INTRO_TEXT_OUT,0);break;
    case INTRO_TEXT_OUT:
        if(fade_done()){game_movie_stage=INTRO_TEXT;start_cutscene(CUTSCENE_INTRO_DIALOGUE);}break;
    case MYAU_TEXT_OUT:
        if(fade_done()){game_movie_stage=MYAU_TEXT;start_cutscene(CUTSCENE_LAERMA);}break;
    case FLIGHT_OUT:
        if(!fade_done())break;
        DISPLAY_OFF;myau_flight_begin(returning);scene_fade_begin(1);DISPLAY_ON;game_movie_stage=FLIGHT_WAIT;break;
    case FLIGHT_WAIT:fade(FLIGHT_IN,1);break;
    case FLIGHT_IN:if(fade_done())game_movie_stage=FLIGHT_MOVE;break;
    case FLIGHT_MOVE:
        movie_keys=keys; /* Source A8 handler samples input throughout flight. */
        if(!myau_flight_frame)audio_command(0xb9);
        if(myau_flight_tick())fade(FLIGHT_END,0);break;
    case FLIGHT_END:
        if(!fade_done())break;
        if(returning){game_movie_mode=0;enter_map(0u,1224u,784u);break;} /*4514:00,40,4C.*/
        DISPLAY_OFF;gold_scene_show(0u);scene_context_type=14;
        myau_battle_palette(0);scene_fade_begin(1);DISPLAY_ON;game_movie_stage=GOLD_WAIT;break;
    case GOLD_WAIT:fade(GOLD_IN,1);break;
    case GOLD_IN:if(fade_done()){hold_frames=30;game_movie_stage=GOLD_HOLD;}break;
    case GOLD_HOLD:
        if(action_edge(keys)||!--hold_frames){game_movie_stage=GOLD_BATTLE;begin_battle(70,3);}break;
    case END_OUT:
        if(!fade_done())break;
        audio_command(0x8b);DISPLAY_OFF;scene_actor_hide();scene_show(13,0,0);
        scene_fade_begin(1);DISPLAY_ON;game_movie_stage=END_WAIT;break;
    case END_WAIT:fade(END_IN,1);break;
    case END_IN:if(fade_done()){hold_frames=128;game_movie_stage=END_HOLD;}break;
    case END_HOLD:
        if(!--hold_frames){DISPLAY_OFF;presentation_begin(PRESENT_ENDING_SKY);DISPLAY_ON;game_movie_stage=END_SKY;}break;
    case END_SKY:
        if(presentation_tick()){text_index=0;game_movie_stage=END_TEXT;start_movie_text(ending_texts[0]);}break;
    case END_STORY_OUT:
        if(fade_done()){game_movie_stage=END_STORY;start_cutscene(CUTSCENE_ENDING_DIALOGUE);}break;
    case END_IMAGE_OUT:
        if(!fade_done())break;
        DISPLAY_OFF;scene_actor_hide();movie_scene_show(MOVIE_ENDING_BITMAP);scene_fade_begin(1);DISPLAY_ON;
        game_movie_stage=END_IMAGE_WAIT;break;
    case END_IMAGE_WAIT:fade(END_IMAGE_IN,1);break;
    case END_IMAGE_IN:if(fade_done()){hold_frames=208;game_movie_stage=END_IMAGE_HOLD;}break;
    case END_IMAGE_HOLD:
        if(!--hold_frames){DISPLAY_OFF;ending_walk_begin(game_dungeon.dungeon.light);DISPLAY_ON;game_movie_stage=END_WALK;}break;
    case END_WALK:
        if(ending_walk_tick()){game_movie_mode=0;title_choice=saved_position_valid?1u:0u;title_screen();}break;
    case DARK_HOLD:
        movie_keys=keys;elapsed=audio_clock-fade_clock;fade_clock=audio_clock;
        if(hold_frames>elapsed){hold_frames-=elapsed;break;}
        hold_frames=0;
        /*5619 installs B19_8000 high colors before showing the scene. Its
         * initial5FFE patch is pixel-identical to the complete31/73 image. */
        /* GBDK display_off waits a fresh VBlank even when called at LY148.
         * The completed208th wait is already in VBlank: disable there to
         * avoid adding an unintended209th score/input interval. */
        if(LY_REG>=144u)LCDC_REG&=(uint8_t)~LCDCF_ON;else DISPLAY_OFF;
        scene_actor_hide();scene_show(31u,0u,73u);scene_context_type=31u;
        scene_fade_begin(1);DISPLAY_ON;game_movie_stage=DARK_WAIT;break;
    case DARK_WAIT:
        movie_keys=keys;fade(DARK_IN,1);break;
    case DARK_IN:
        movie_keys=keys;if(fade_done())game_movie_stage=DARK_UPLOAD;break;
    case DARK_UPLOAD:
        /* Original5FFE's single10 VBlank. DarkFalz has a fixed two-enemy
         * record and no initial OBJ sprites; setup consumes no random draw. */
        movie_keys=keys;hold_frames=30u;game_movie_stage=DARK_REVEAL;break;
    case DARK_REVEAL:
        if(action_edge(keys)||!--hold_frames){
            /* This changes source Interaction_Type only. Scene31 stays
             * behind the boss; the battle renderer preserves that image. */
            scene_context_type=32u;game_movie_mode=0;event_advance(&game_events);apply_event();
        }break;
    case GOV_OUT:
        if(!fade_done())break;
        DISPLAY_OFF;scene_actor_hide();scene_show(29u,0u,0u);scene_context_type=29u;
        event_governor_room_loaded(&game_events);scene_fade_begin(1);DISPLAY_ON;
        game_movie_stage=GOV_WAIT;break;
    case GOV_WAIT:fade(GOV_IN,1);break;
    case GOV_IN:
        if(!fade_done())break;
        DISPLAY_OFF;scene_portrait_show(53u);DISPLAY_ON;game_movie_stage=GOV_ACTOR;break;
    case GOV_ACTOR:
        game_movie_mode=0;event_advance(&game_events);apply_event();break;
    }
}
