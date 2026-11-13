#ifndef PS_WORLD_RULES_H
#define PS_WORLD_RULES_H
#include "world.h"
#include "rpg.h"
#define WORLD_RULE_NONE 0u
#define WORLD_RULE_DUNGEON 10u
#define WORLD_RULE_EVENT 12u
#define WORLD_RULE_BATTLE 14u
typedef struct {
    uint8_t kind,target,a,b,rollback,death_mask;
} WorldRuleAction;
/* LABEL_792A: dispatch only after the original metatile flags select a special. */
uint8_t world_special(RPGState *rpg,uint8_t map,uint8_t metatile,uint8_t vehicle,
    uint8_t noah_flag,WorldRuleAction *action) RPG_BANKED;
/* Source LABEL_ABF: departure/arrival/exit triplets for route tags81..88.
 * This decodes routes; it does not implement ship animation or its sound. */
uint8_t travel_route(uint8_t tag,WorldAction *departure,WorldAction *arrival,WorldAction *exit) RPG_BANKED;
uint8_t world_interaction_type(uint8_t group,uint8_t type) RPG_BANKED;
#endif
