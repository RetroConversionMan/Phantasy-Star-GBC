#ifndef PS_GAME_FLOW_H
#define PS_GAME_FLOW_H
#include "rpg.h"
void apply_event(void) RPG_BANKED;
void apply_dungeon(void) RPG_BANKED;
void show_interaction_scene(uint8_t type,uint8_t portrait,uint8_t enemy) RPG_BANKED;
void enter_dungeon(uint8_t floor,uint8_t position,uint8_t direction) RPG_BANKED;
#endif
