/* Original ItemAction_Equip/Drop chronology; no additional static RAM. */
#pragma bank 19
#include <gb/gb.h>
#include <string.h>
#include "inventory_menu.h"
#include "game_field.h"
#include "game_ui.h"
#include "dialogue.h"
#include "ui.h"
extern RPGState game_rpg;
extern uint8_t screen_state,party_choice;
void show_dialogue(uint16_t);
void inventory_dialogue_overlay(void);
enum { ITEM_CLOSE=1,ITEM_DROP,ITEM_EQUIP_TEXT,ITEM_EQUIP_DENIED };
static void close_rows(uint8_t rows) {while(rows--)vsync();}
static void finish(uint8_t refresh) {
    HIDE_WIN;close_rows(6u);
    if(refresh)rpg_refresh_stats(&game_rpg);
    if(refresh&&(game_rpg.joined_mask&14u))close_rows(9u);
    field_active=0;inventory_screen();
}
static void start(uint8_t slot) {
    memset(&field_action,0,sizeof(field_action));field_active=2;
    field_action.a=slot;field_action.item=game_rpg.inventory[slot];field_action.character=255;
}
void inventory_equip_begin(uint8_t slot) RPG_BANKED {
    start(slot);
    if(!rpg_item_equippers(field_action.item)) {
        field_action.target=ITEM_CLOSE;show_dialogue(0xb5f0);return;
    }
    if(!(game_rpg.joined_mask&14u)){inventory_equip_select(0u);return;}
    party_choice=0;party_screen();
}
void inventory_equip_select(uint8_t character) RPG_BANKED {
    uint8_t result;
    if(character==255u){
        rpg_refresh_stats(&game_rpg);
        if(game_rpg.joined_mask&14u)close_rows(9u);
        field_active=0;inventory_screen();return;
    }
    field_action.character=character;
    result=rpg_equip_stage(&game_rpg,field_action.a,character);
    field_action.target=result==RPG_OK?ITEM_EQUIP_TEXT:ITEM_EQUIP_DENIED;
    show_dialogue(result==RPG_OK?0xb2b6:result==RPG_DEAD?0xb730:0xb5de);
}
void inventory_drop_begin(uint8_t slot) RPG_BANKED {
    start(slot);field_action.target=rpg_item_discardable(field_action.item)?ITEM_DROP:ITEM_CLOSE;
    show_dialogue(field_action.target==ITEM_DROP?0xb2c2:0xb6de);
}
void inventory_action_advance(void) RPG_BANKED {
    uint8_t i,item;char name[9];RPGCharacter *p;
    if(field_action.target==ITEM_EQUIP_TEXT){
        /*3707 presents the three original equipment names, then explicitly
         * waits for a fresh action edge even after B2B6's terminator wait. */
        p=&game_rpg.party[field_action.character];ui_panel(40u,13u);
        for(i=0;i<3u;++i){
            item=i==0u?p->weapon:i==1u?p->armor:p->shield;
            dialogue_item_name(item,name);ui_text(3u,2u+i*2u,name);
        }
        inventory_dialogue_overlay();screen_state=STATE_EQUIPMENT_PANEL;return;
    }
    if(field_action.target==ITEM_DROP)rpg_remove_item(&game_rpg,field_action.a);
    finish(field_action.target==ITEM_EQUIP_DENIED);
}
void inventory_equipment_done(void) RPG_BANKED {
    HIDE_WIN;close_rows(8u);close_rows(6u);
    rpg_equip_finish(&game_rpg,field_action.a);
    if(game_rpg.joined_mask&14u)close_rows(9u);
    field_active=0;inventory_screen();
}
