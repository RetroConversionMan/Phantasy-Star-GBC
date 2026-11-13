#ifdef __SDCC
#pragma bank 29
#include <gb/gb.h>
#endif
#include "game_transition.h"
#include "audio.h"
#include "travel.h"
uint8_t game_fade_clock,game_map_music;
extern uint8_t last_keys;
uint8_t game_transition_vint16(void) RPG_BANKED {
    /* Original7B40 decrements C21D on every16 handler, even with no fade. */
    --game_fade_clock;if(!(game_fade_clock&128u))return 0;
    game_fade_clock=3u;return 1;
}
void game_transition_map_music(uint8_t command) RPG_BANKED {
    if(command!=game_map_music){game_map_music=command;audio_command(command);}
}
uint8_t game_transition_interaction_music(uint8_t type) RPG_BANKED {
    static const uint8_t tracks[16]={0,0,0,0,0,0x8d,0x8d,0x8e,0x8e,0x8e,0x8e,0x8e,0x8e,0,0,0};
    return tracks[(type>=15u?type-15u:0u)&15u];
}
void game_transition_wait(uint8_t frames,uint8_t sample_input) RPG_BANKED {
    while(frames--){
#ifdef __SDCC
        vsync();if(sample_input)last_keys=joypad();
#else
        (void)sample_input;
#endif
    }
}
void game_transition_close(void) RPG_BANKED {
#ifdef __SDCC
    HIDE_WIN;
#endif
    /* Native eight-pixel glyph rows close together; source3464 still waits
     * six0A VBlanks without reading controls. */
    game_transition_wait(6u,0u);
}
static void fade_wait(uint8_t in) {
    uint8_t step=0;
    while(step<(in?10u:9u)){
        if(game_transition_vint16()){
            ++step;
#ifdef __SDCC
            if(step<=9u)scene_fade_step(step,in);
            else game_transition_wait(1u,0u);
#endif
        } else game_transition_wait(1u,0u);
    }
}
void game_transition_fade_out(void) RPG_BANKED {
#ifdef __SDCC
    scene_fade_begin(0u);
#endif
    fade_wait(0u);
}
void game_transition_fade_in(void) RPG_BANKED {fade_wait(1u);}
