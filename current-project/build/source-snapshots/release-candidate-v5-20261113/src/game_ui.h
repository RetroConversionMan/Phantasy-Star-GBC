#ifndef PS_GAME_UI_H
#define PS_GAME_UI_H
#include "rpg.h"
void title_screen(void) RPG_BANKED;
void menu_screen(void) RPG_BANKED;
void help_screen(void) RPG_BANKED;
void notice(const char *s,uint8_t return_to) RPG_BANKED;
void result(uint8_t code,uint8_t return_to) RPG_BANKED;
void prompt_screen(void) RPG_BANKED;
void shop_screen(void) RPG_BANKED;
void inventory_screen(void) RPG_BANKED;
void item_screen(void) RPG_BANKED;
void party_screen(void) RPG_BANKED;
void status_screen(void) RPG_BANKED;
void travel_menu(void) RPG_BANKED;
void map_magic_screen(void) RPG_BANKED;
#endif
