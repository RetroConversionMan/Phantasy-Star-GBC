#ifndef PS_SAVE_UI_H
#define PS_SAVE_UI_H
#include "save_slots.h"
#define STATE_SAVE_ACTION 25u
#define STATE_SAVE_SELECT 26u
#define STATE_SAVE_CONFIRM 27u
#define STATE_SAVE_NAME 28u
#define SAVE_UI_SAVE 1u
#define SAVE_UI_LOAD 2u
#define SAVE_UI_DELETE 3u
extern uint8_t save_active_slot,save_valid_mask,save_ui_choice,save_ui_mode;
void save_ui_scan(void) RPG_BANKED;
void save_ui_open(uint8_t mode,uint8_t return_state) RPG_BANKED;
void save_ui_tick(uint8_t keys,uint8_t pressed) RPG_BANKED;
/* Main owns the shared serialization buffer and actual running game state. */
uint8_t game_read_slot(uint8_t slot);
uint8_t game_write_slot(uint8_t slot);
#endif
