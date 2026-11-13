#ifndef PS_INVENTORY_MENU_H
#define PS_INVENTORY_MENU_H
#include "rpg.h"
#define STATE_EQUIPMENT_PANEL 30u
void inventory_equip_begin(uint8_t slot) RPG_BANKED;
void inventory_equip_select(uint8_t character) RPG_BANKED;
void inventory_drop_begin(uint8_t slot) RPG_BANKED;
void inventory_action_advance(void) RPG_BANKED;
void inventory_equipment_done(void) RPG_BANKED;
#endif
