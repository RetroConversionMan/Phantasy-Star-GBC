#ifndef PS_GAME_FIELD_H
#define PS_GAME_FIELD_H
#include "field_actions.h"
extern FieldAction field_action;
extern uint8_t field_active;
void game_field_item(uint8_t slot,uint8_t target) RPG_BANKED;
void game_field_spell(uint8_t caster,uint8_t spell,uint8_t target) RPG_BANKED;
void game_field_advance(void) RPG_BANKED;
void game_field_scene_done(void) RPG_BANKED;
/* Original ItemAction_Use during an initiative turn. Fills field_action; caller
 * displays its lines without executing deferred C2D8 field actions. */
void game_field_battle_item(uint8_t item,uint8_t actor) RPG_BANKED;
#endif
