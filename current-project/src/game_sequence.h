#ifndef PS_GAME_SEQUENCE_H
#define PS_GAME_SEQUENCE_H
#include "rpg.h"
/* Display states owned by the source-sequence dispatcher. */
#define STATE_PRESENTATION 20u
#define STATE_TRAVEL 21u
#define STATE_ODIN_WAIT 22u
void start_recruitment(uint8_t sequence) RPG_BANKED;
void start_field_scene(uint8_t kind) RPG_BANKED;
void start_travel(uint8_t tag) RPG_BANKED;
void game_sequence_tick(uint8_t keys,uint8_t pressed) RPG_BANKED;
#endif
