#pragma bank 122
#include <gb/gb.h>
#include "save_ui.h"
#include "game_ui.h"
#include "ui.h"
extern uint8_t screen_state,saved_position_valid,title_choice;
void start_game(uint8_t continued);
static char labels[5][6];
static SaveName editor;
static uint8_t return_state,answer,name_repeat,name_keys;
uint8_t save_active_slot,save_valid_mask,save_ui_choice,save_ui_mode;
static void text(uint8_t x,uint8_t y,const char *s) {
    char copy[21];uint8_t i=0;while(s[i]&&i<20u){copy[i]=s[i];++i;}copy[i]=0;ui_text(x,y,copy);
}
static void read_label(uint8_t slot) {
    uint8_t data[8],i;uint16_t address=0xa000u+SAVE_LABEL_OFFSET+(uint16_t)slot*SAVE_LABEL_BYTES;
    ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);
    for(i=0;i<8u;++i)data[i]=*(volatile uint8_t *)(address+i);
    DISABLE_RAM_MBC5;save_label_decode(labels[slot],data);labels[slot][5]=0;
}
static void write_label(uint8_t slot) {
    uint8_t data[8],i;uint16_t address=0xa000u+SAVE_LABEL_OFFSET+(uint16_t)slot*SAVE_LABEL_BYTES;
    if(!save_label_encode(data,editor.name))return;
    ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);*(volatile uint8_t *)(address+5u)=0;
    for(i=0;i<8u;++i)if(i!=5u)*(volatile uint8_t *)(address+i)=data[i];
    *(volatile uint8_t *)(address+5u)=data[5];DISABLE_RAM_MBC5;read_label(slot);
}
void save_ui_scan(void) RPG_BANKED {
    uint8_t i,first=255;save_valid_mask=0;
    for(i=0;i<5u;++i){if(game_read_slot(i)){save_valid_mask|=1u<<i;if(first==255u)first=i;}read_label(i);}
    if(first==255u)save_active_slot=0;
    else if(!(save_valid_mask&(1u<<save_active_slot)))save_active_slot=first;
    game_read_slot(save_active_slot);saved_position_valid=!!save_valid_mask;
}
static void back(void) {
    if(return_state==0u){title_choice=saved_position_valid?1u:0u;title_screen();}
    else menu_screen();
}
static void action_screen(void) {
    screen_state=STATE_SAVE_ACTION;HIDE_SPRITES;ui_panel(40,13);
    text(4,1,"SAVED GAMES");text(4,4,"CONTINUE");text(4,6,"DELETE");
    text(2,4+save_ui_choice*2u,">");text(1,10,"A:CHOOSE  B:BACK");
}
static void slot_screen(void) {
    uint8_t i;screen_state=STATE_SAVE_SELECT;HIDE_SPRITES;ui_panel(0,18);
    text(3,1,save_ui_mode==SAVE_UI_SAVE?"SAVE WHICH FILE?":save_ui_mode==SAVE_UI_LOAD?"LOAD WHICH FILE?":"ERASE WHICH FILE?");
    for(i=0;i<5u;++i){ui_number(3,4+i*2u,i+1u);text(6,4+i*2u,(save_valid_mask&(1u<<i))?labels[i]:"EMPTY");}
    text(1,4+save_ui_choice*2u,">");text(1,16,"A:CHOOSE  B:BACK");
}
static void confirm_screen(void) {
    screen_state=STATE_SAVE_CONFIRM;ui_panel(64,10);
    text(2,1,save_ui_mode==SAVE_UI_SAVE?"SAVE THIS FILE?":"ERASE THIS FILE?");
    text(4,4,"YES");text(12,4,"NO");text(answer?10:2,4,">");
    text(1,7,"A:CHOOSE  B:BACK");
}
static void name_screen(void) {
    uint8_t i,c;char one[2],name[6];screen_state=STATE_SAVE_NAME;HIDE_SPRITES;ui_panel(0,18);
    text(3,0,"NAME THIS FILE");for(i=0;i<5u;++i)name[i]=editor.name[i];name[5]=0;text(7,2,name);
    text(7+editor.cursor,3,"^");one[1]=0;
    for(i=0;i<36u;++i){c=save_name_character(i);one[0]=c;
        text(1+(i%6u)*3u,5+(i/6u)*2u,c==0x5cu?">":c==0x5du?"<":c==0x5eu?"END":one);}
    text((editor.option%6u)*3u,5+(editor.option/6u)*2u,">");
    text(1,17,"A:ENTER  B:ERASE");
}
void save_ui_open(uint8_t mode,uint8_t returning) RPG_BANKED {
    save_ui_scan();save_ui_mode=mode;return_state=returning;
    save_ui_choice=mode==SAVE_UI_LOAD?0u:save_active_slot;
    if(mode==SAVE_UI_LOAD)action_screen();else slot_screen();
}
void save_ui_tick(uint8_t keys,uint8_t pressed) RPG_BANKED {
    uint8_t was_valid,move=0;uint16_t offset;
    if(screen_state==STATE_SAVE_ACTION) {
        if(pressed&J_B){back();return;}
        if(pressed&(J_UP|J_DOWN)){save_ui_choice^=1u;action_screen();}
        else if(pressed&J_A){save_ui_mode=save_ui_choice?SAVE_UI_DELETE:SAVE_UI_LOAD;save_ui_choice=save_active_slot;slot_screen();}
    } else if(screen_state==STATE_SAVE_SELECT) {
        if(pressed&J_B){if(return_state==0u){save_ui_choice=0;action_screen();}else back();return;}
        if(pressed&J_UP){if(save_ui_choice)--save_ui_choice;slot_screen();}
        else if(pressed&J_DOWN){if(save_ui_choice<4u)++save_ui_choice;slot_screen();}
        else if(pressed&J_A) {
            if(save_ui_mode==SAVE_UI_LOAD){if(save_valid_mask&(1u<<save_ui_choice)){save_active_slot=save_ui_choice;start_game(1);}}
            else if(save_ui_mode==SAVE_UI_SAVE||(save_valid_mask&(1u<<save_ui_choice))){answer=0;confirm_screen();}
        }
    } else if(screen_state==STATE_SAVE_CONFIRM) {
        if(pressed&(J_UP|J_DOWN|J_LEFT|J_RIGHT)){answer^=1u;confirm_screen();}
        else if(pressed&J_B){slot_screen();}
        else if(pressed&J_A) {
            if(answer){slot_screen();return;}
            if(save_ui_mode==SAVE_UI_DELETE) {
                offset=save_slot_offset(save_ui_choice);ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);
                *(volatile uint8_t *)(0xa000u+offset)=0;
                *(volatile uint8_t *)(0xa000u+SAVE_LABEL_OFFSET+(uint16_t)save_ui_choice*8u+5u)=0;
                DISABLE_RAM_MBC5;save_ui_scan();back();
            } else {
                was_valid=save_valid_mask&(1u<<save_ui_choice);
                if(!game_write_slot(save_ui_choice)){char failed[]="SAVE FAILED";notice(failed,return_state);return;}
                if(was_valid){char saved[]="GAME SAVED";notice(saved,return_state);}
                else {save_name_begin(&editor);name_keys=keys;name_repeat=24;name_screen();}
            }
        }
    } else if(screen_state==STATE_SAVE_NAME) {
        if(pressed&J_B){save_name_input(&editor,1);name_screen();}
        else if(pressed&J_A){if(save_name_input(&editor,0)){write_label(save_active_slot);back();}else name_screen();}
        else {
            if(pressed&(J_UP|J_DOWN|J_LEFT|J_RIGHT)){move=1;name_repeat=24;}
            else if(keys&(J_UP|J_DOWN|J_LEFT|J_RIGHT)){if(keys!=name_keys)name_repeat=24;else if(!--name_repeat){move=1;name_repeat=5;}}
            if(move){save_name_move(&editor,(keys&J_LEFT)?-1:(keys&J_RIGHT)?1:0,(keys&J_UP)?-1:(keys&J_DOWN)?1:0);name_screen();}
        }
        name_keys=keys;
    }
}
