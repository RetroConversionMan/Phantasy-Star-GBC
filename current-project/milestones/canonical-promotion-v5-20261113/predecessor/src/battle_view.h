#ifndef PS_BATTLE_VIEW_H
#define PS_BATTLE_VIEW_H
#include "battle.h"
#define BVIEW_COMMAND 1u
#define BVIEW_SPELL 2u
#define BVIEW_ITEM 3u
#define BVIEW_TARGET 4u
#define BVIEW_MESSAGE 5u
#define BVIEW_PROMPT 6u
#define BVIEW_REPLACE 7u
#define BVIEW_EXECUTE 8u
#define BVIEW_DONE 9u
#define BVIEW_AUDIO_WAIT 10u
#define BVIEW_ENEMY_ANIMATION 11u
#define BVIEW_CHEST_MENU 12u
#define BVIEW_CHEST_ANIMATION 13u
#define BVIEW_PLAYER_HIT 14u
#define BVIEW_PLAYER_WEAPON 15u
#define BVIEW_ENEMY_MAGIC 16u
#define BVIEW_ENEMY_MAGIC_HOLD 17u
#define BVIEW_ITEM_CLOSE 18u
#define BVIEW_BOSS_ANIMATION 19u
#define BATTLE_VIEW_MENU 254u
extern RPGBattle battle_view_battle;
extern uint8_t battle_view_state, battle_view_actor, battle_view_choice;
extern uint8_t battle_view_result,battle_view_hit_cursor;
/* Freeze caller input latch for frames that begin with this flag set. */
extern uint8_t battle_view_text_revealing;
extern uint16_t battle_view_dialogue_id;
extern uint8_t battle_view_chest_pending,battle_view_field_menu_pending,battle_view_menu_allowed;
/* Begins a battle using the single shared party/inventory state. Art load needs
 * LCD off internally. tick returns ONGOING until all result/chest messages end.
 * Caller first configures battle_scene context, and restores world graphics
 * after a nonzero result. */
uint8_t battle_view_begin(RPGState *state, uint8_t enemy) RPG_BANKED;
/* Source dungeon chest: keeps the current background, no encounter/EXP. */
void battle_view_chest_begin(RPGState *state,uint8_t item,uint16_t money,uint8_t trap) RPG_BANKED;
/* A declined closed chest retains its prepared trap in the full field menu.
 * field_menu_pending remains set after opening until menu cancellation.
 * menu_allowed defaults1; story callers override when their wrapper lacks1BE1.
 * search1 emits original Search text; search0 is Tele's reopen question. */
void battle_view_chest_prompt(uint8_t search) RPG_BANKED;
void battle_view_chest_open(void) RPG_BANKED;
void battle_view_chest_leave(void) RPG_BANKED;
void battle_view_chest_abandon(void) RPG_BANKED;
uint8_t battle_view_tick(uint8_t keys, uint8_t pressed) RPG_BANKED;
#endif
