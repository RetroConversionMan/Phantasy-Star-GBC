#ifndef PS_DUNGEON_PLAY_H
#define PS_DUNGEON_PLAY_H
#include "dungeon.h"
#include "events.h"
#define DPLAY_VIEW 0u
#define DPLAY_MENU 1u
#define DPLAY_BATTLE 2u
#define DPLAY_CHEST 3u
#define DPLAY_EVENT 4u
#define DPLAY_MAP 5u
#define DPLAY_EXIT 6u
#define DPLAY_DARK 7u
#define DPLAY_INVALID 255u
typedef struct {
    uint8_t kind,target,a,b,type;
    uint16_t flag_address,money;
} DungeonPlayAction;
typedef struct {
    DungeonState dungeon;
    uint8_t active,check_count,check_cursor,positions[2],views[2];
    uint8_t encounter_latch,initial_dark,advance_second,retained_trap;
    DungeonPlayAction action;
} DungeonPlay;
/* Last argument seeds the retained original C2E0 trap byte before object scan. */
uint8_t dplay_enter(DungeonPlay *,RPGState *,EventState *,uint8_t,uint8_t,uint8_t,uint8_t) RPG_BANKED;
/* Original4C70/661C scene entry: preserve current light, decrement the staged
 * floor, animate the existing room, then check the destination front object.
 * This bypasses ordinary entry's MagicLamp/dark-menu initialization. */
uint8_t dplay_scene_fall(DungeonPlay *,RPGState *,EventState *,uint8_t,uint8_t,uint8_t,uint8_t) RPG_BANKED;
uint8_t dplay_step(DungeonPlay *,RPGState *,EventState *,uint8_t) RPG_BANKED;
uint8_t dplay_resume(DungeonPlay *,RPGState *,EventState *) RPG_BANKED;
uint8_t dplay_escape(DungeonPlay *,RPGState *,EventState *) RPG_BANKED;
uint8_t dplay_escape_blocked(const DungeonPlay *) RPG_BANKED;
void dplay_mark_object(EventState *,uint16_t) RPG_BANKED;
/* The caller's original item/spell validation has already set the opened bit.
 * style is original6E75 start index2(normal),3(key),4(magic/miracle). */
void dplay_show_opening(DungeonPlay *,uint8_t style) RPG_BANKED;
#endif
