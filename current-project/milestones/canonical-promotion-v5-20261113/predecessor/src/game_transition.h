#ifndef PS_GAME_TRANSITION_H
#define PS_GAME_TRANSITION_H
#include "rpg.h"
/* Original C21D countdown and C2F4 persistent map/dungeon music latch. */
extern uint8_t game_fade_clock,game_map_music;
uint8_t game_transition_vint16(void) RPG_BANKED;
void game_transition_fade_out(void) RPG_BANKED;
/* Call scene_fade_begin(1) while the new colors are installed and LCD is off,
 * then enable the LCD before calling this original FadeIn2 wait sequence. */
void game_transition_fade_in(void) RPG_BANKED;
void game_transition_wait(uint8_t frames,uint8_t sample_input) RPG_BANKED;
void game_transition_close(void) RPG_BANKED;
void game_transition_map_music(uint8_t command) RPG_BANKED;
uint8_t game_transition_interaction_music(uint8_t type) RPG_BANKED;
#endif
