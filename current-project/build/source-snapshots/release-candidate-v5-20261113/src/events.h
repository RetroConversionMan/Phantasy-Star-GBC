#ifndef PS_EVENTS_H
#define PS_EVENTS_H
#include "rpg.h"
#define EVENT_DONE 0u
#define EVENT_DIALOGUE 1u
#define EVENT_YES_NO 2u
#define EVENT_SHOP 3u
#define EVENT_HOSPITAL 4u
#define EVENT_CHURCH 5u
#define EVENT_SELL 6u
#define EVENT_REPLACE_ITEM 7u
#define EVENT_TRANSITION 8u
#define EVENT_MAP_TRANSITION 9u
#define EVENT_MENU 10u
#define EVENT_OBJECT_FLAG 11u
#define EVENT_BATTLE 12u
#define EVENT_DUNGEON 13u
#define EVENT_DUNGEON_BACK 14u
#define EVENT_TRAVEL 15u
#define EVENT_TRAVEL_MENU 16u
#define EVENT_ENDING 17u
#define EVENT_GAME_OVER 18u
#define EVENT_SCENE 19u
#define EVENT_CUTSCENE 21u /* target=Cutscene sequence; advance after completion. */
#define EVENT_DUNGEON_FALL 22u /* target=staged floor BEFORE original661C decrements it. */
#define EVENT_DARK_FALZ_REVEAL 23u /* Original5619 music/hold/reveal before100F. */
#define EVENT_GOVERNOR_ROOM 24u /* Original5666 or4D41 fade/portrait continuation. */
#define EVENT_PRESENTATION 25u /* target: source event visual/audio continuation. */
#define EVENT_PRESENT_SUEL_HEAL 0u
#define EVENT_PRESENT_GUEST_SLEEP 1u
#define EVENT_PRESENT_GUEST_WAKE 2u
#define EVENT_PRESENT_NIGHTMARE_SCENE 3u
#define EVENT_PRESENT_NIGHTMARE_HOLD 4u
#define EVENT_PRESENT_NIGHTMARE_WAKE 5u
#define EVENT_DUNGEON_CELL 20u /* target=index in current CB00 floor; a=new cell. */
#define EVENT_BATTLE_OVERRIDE_ITEM 1u
#define EVENT_BATTLE_ZERO_MONEY 2u
#define EVENT_UNIMPLEMENTED 255u
typedef struct {
    uint8_t kind;
    uint16_t dialogue_id,number;
    uint8_t item,target,a,b,character,sound;
} EventAction;
typedef struct {
    uint8_t options,item_reward,flag_index,status_snapshot[3],noah_hp;
} EventBattleContext;
typedef struct {
    uint8_t flags[256]; /* Original C500..C5FF. */
    RPGState *rpg;
    uint8_t secrets_requests; /* Original C2EC, persistent across shop visits. */
    uint8_t last_church; /* Original C317, set on church entry for Transfer. */
    uint8_t event,type,portrait,map_id,packed_y;
    uint8_t stage,resume_stage,pending_item,selected_slot;
    uint8_t item_in_battle;
    uint8_t prepared_enemy,death_mask,death_cursor,camera_x_low,travel_destination;
    EventBattleContext battle;
    EventAction action;
    uint8_t object_flags[256]; /* Original C600..C6FF, shared with dungeon kernel. */
} EventState;
void event_init(EventState *state,RPGState *rpg) RPG_BANKED;
/* Caller may set packed_y (original C305) before beginning event26. */
const EventAction *event_begin(EventState *state,uint8_t type,uint8_t event_id,uint8_t portrait,uint8_t map_id) RPG_BANKED;
const EventAction *event_advance(EventState *state) RPG_BANKED;
/* Original post-nightmare2A6D runs after the palace loads, before fade-in. */
void event_governor_room_loaded(EventState *state) RPG_BANKED;
const EventAction *event_respond(EventState *state,uint8_t yes) RPG_BANKED;
/* slot 255 cancels the selection and returns to original inventory-full question. */
const EventAction *event_replace_item(EventState *state,uint8_t slot) RPG_BANKED;
/* Scion Secrets option only; validates capacity/money before advancing original C2EC. */
const EventAction *event_buy_secret(EventState *state,uint8_t shop,uint8_t option) RPG_BANKED;
/* Actual current interaction event/type must be retained for source-specific use restrictions. */
const EventAction *event_use_story_item(EventState *state,uint8_t slot,uint8_t in_battle) RPG_BANKED;
/* Normalized original metatile coordinates, after accounting for camera-origin offsets. */
const EventAction *event_search(EventState *state,uint8_t map_id,uint8_t cell_x,uint8_t cell_y) RPG_BANKED;
/* Caller applies battle reward overrides after battle begin. Report actual chest OPEN,
 * including opened-but-item-abandoned, so original C2E1 flags are updated accurately. */
const EventAction *event_battle_result(EventState *state,uint8_t outcome,uint8_t chest_opened) RPG_BANKED;
const EventAction *event_choose_destination(EventState *state,uint8_t destination) RPG_BANKED;
#endif
