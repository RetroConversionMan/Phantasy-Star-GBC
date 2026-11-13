#ifndef PS_FIELD_ACTIONS_H
#define PS_FIELD_ACTIONS_H
#include "events.h"
#include "dungeon.h"
#include "battle.h"
#define FIELD_DONE 0u
#define FIELD_REDRAW 1u
#define FIELD_EXIT_DUNGEON 2u
#define FIELD_TRANSFER 3u
#define FIELD_OPEN_DOOR 4u
#define FIELD_CHEST_OPEN 5u
#define FIELD_CHEST_PROMPT 6u
#define FIELD_PRISM 7u
#define FIELD_MYAU_FLY 8u
#define FIELD_TORCH_SCENE 9u
#define FIELD_STORY_ITEM 10u
#define FIELD_VEHICLE 11u
#define FIELD_UNIMPLEMENTED 255u
typedef struct {
 RPGState *rpg;
 EventState *events;
 DungeonState *dungeon; /* NULL outside dungeon; source Interaction_Type remains authoritative. */
 RPGBattle *chest; /* NULL except the active closed source chest. */
 uint8_t interaction,in_battle,map_id,map_group,event_id,projection,vehicle;
} FieldContext;
typedef struct {
 uint16_t dialogue;
 uint8_t sound_before,sound_after;
} FieldLine;
typedef struct {
 uint8_t kind,error,line_count,item,character,target,a,b,sound_start,sound_end;
 FieldLine lines[3];
} FieldAction;
/* Target255 means the original character-selection cancel. Rise still spends
 * MP on cancellation, while Heal/Cure spend only on a living target. */
uint8_t field_cast(FieldContext *,uint8_t caster,uint8_t spell,uint8_t target,FieldAction *) RPG_BANKED;
uint8_t field_use_item(FieldContext *,uint8_t slot,uint8_t target,FieldAction *) RPG_BANKED;
void field_torch_reply(RPGState *,FieldAction *) RPG_BANKED;
void field_torch_finish(RPGState *,FieldAction *) RPG_BANKED;
#endif
