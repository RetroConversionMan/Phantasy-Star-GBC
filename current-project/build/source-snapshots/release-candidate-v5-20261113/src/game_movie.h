#ifndef PS_GAME_MOVIE_H
#define PS_GAME_MOVIE_H
#include "rpg.h"
#define STATE_MOVIE 23u
#define STATE_MOVIE_TEXT 24u
extern uint8_t game_movie_mode,game_movie_stage;
void start_opening(void) RPG_BANKED;
void start_ending(void) RPG_BANKED;
void start_myau_flight(void) RPG_BANKED;
void start_dark_falz_reveal(void) RPG_BANKED;
void start_governor_room(void) RPG_BANKED;
void game_movie_tick(uint8_t keys) RPG_BANKED;
void game_movie_text_done(void) RPG_BANKED;
uint8_t game_movie_story_done(void) RPG_BANKED;
void game_movie_battle_done(uint8_t outcome) RPG_BANKED;
#endif
