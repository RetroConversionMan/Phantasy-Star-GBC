#pragma bank 14
#include <gb/gb.h>
#include <stdint.h>
#include "game_ui.h"
#include "dialogue.h"
#include "ui.h"
#include "audio.h"
#include "game_transition.h"
#include "travel.h"
#include "opening.h"
#include "scene.h"
extern RPGState game_rpg;
extern uint8_t screen_state,saved_position_valid,menu_choice,title_choice;
extern uint8_t choice,shop_id,shop_count,item_slot,item_action,party_choice,notice_return,replace_source;
extern uint8_t magic_caster,magic_choice;
extern uint8_t background_changed;
static uint8_t title_loaded;
static char item_name[9];
static const char *const names[]={"ALIS","MYAU","ODIN","NOAH"};
static void bank_text(uint8_t x,uint8_t y,const char *text) {
    char copy[21];uint8_t i=0;
    while(text[i]&&i<20u){copy[i]=text[i];++i;}copy[i]=0;
    ui_text(x,y,copy);
}
#define ui_text bank_text
#define STATE_TITLE 0u
#define STATE_WALK 1u
#define STATE_MENU 2u
#define STATE_HELP 3u
#define STATE_DIALOGUE 4u
#define STATE_PROMPT 5u
#define STATE_SHOP 6u
#define STATE_REPLACE 7u
#define STATE_NOTICE 8u
#define STATE_INVENTORY 9u
#define STATE_ITEM 10u
#define STATE_PARTY 11u
#define STATE_BUY 12u
#define STATE_STATUS 13u
#define STATE_BUY_SELL 14u
#define STATE_BATTLE 15u
#define STATE_TRAVEL_MENU 16u
#define STATE_DUNGEON 17u
void title_screen(void) RPG_BANKED {
    if(screen_state!=STATE_TITLE||!title_loaded) {
        /* Original LoadIntro preserves C21D across its outgoing fade. Cold
         * boot begins with a black screen; native LCD must run for VBlank. */
        if(!(LCDC_REG&LCDCF_ON)){scene_fade_begin(1u);DISPLAY_ON;}
        game_transition_fade_out();DISPLAY_OFF;audio_stop();
        scene_actor_hide();movie_scene_show(MOVIE_TITLE);
        game_map_music=0; /* Source C260..C2FF clear, including C2F4. */
        audio_command(0x81);scene_fade_begin(1u);
        background_changed=1;title_loaded=1;DISPLAY_ON;
        game_transition_wait(2u,0u); /* Original0C, then2FD's14 upload. */
        game_transition_fade_in();
    }
    screen_state=STATE_TITLE;HIDE_SPRITES;ui_panel(80,8);
    ui_text(4,1,"NEW GAME");ui_text(4,3,saved_position_valid?"CONTINUE":"NO SAVE");
    ui_text(2,1+title_choice*2u,">");
}

void menu_screen(void) RPG_BANKED {
    screen_state=STATE_MENU;HIDE_SPRITES;ui_panel(0,18);
    ui_text(4,1,"PHANTASY STAR");ui_text(4,3,"RESUME");ui_text(4,5,"STATUS");
    ui_text(4,7,"ITEMS");ui_text(4,9,"SEARCH");ui_text(4,11,"SAVE");ui_text(4,13,"TITLE");ui_text(4,15,"HELP");
    ui_text(4,17,"MAGIC");ui_text(2,3+menu_choice*2u,">");ui_text(1,0,"MESETA");ui_number(10,0,game_rpg.money);
}

void help_screen(void) RPG_BANKED {
    screen_state=STATE_HELP;HIDE_SPRITES;ui_panel(0,18);
    ui_text(2,1,"PHANTASY STAR");ui_text(1,3,"D-PAD  WALK");ui_text(1,4,"A / B  FIELD MENU");
    ui_text(1,5,"A      CONFIRM");ui_text(1,6,"START  MENU");ui_text(1,7,"SELECT SAVE");
    ui_text(1,9,"SELECT SAVES IN THE");ui_text(1,10,"WORLD AND DUNGEONS");
    ui_text(1,12,"MENU SAVE SUPPORTS");ui_text(1,13,"FIVE NAMED FILES");ui_text(1,16,"A / B TO RETURN");
}

void notice(const char *s,uint8_t return_to) RPG_BANKED {
    notice_return=return_to;screen_state=STATE_NOTICE;HIDE_SPRITES;
    ui_panel(88,7);ui_text(1,1,s);ui_text(1,5,"A / B TO RETURN");
}

void result(uint8_t code,uint8_t return_to) RPG_BANKED {
    if(code==RPG_OK) notice("DONE",return_to);
    else if(code==RPG_FULL) notice("INVENTORY FULL",return_to);
    else if(code==RPG_NO_MONEY) notice("NOT ENOUGH MESETA",return_to);
    else if(code==RPG_PROTECTED_ITEM) notice("CANNOT DISCARD",return_to);
    else if(code==RPG_CANNOT_EQUIP) notice("CANNOT EQUIP",return_to);
    else if(code==RPG_DEAD) notice("CHARACTER IS DEAD",return_to);
    else if(code==RPG_NO_MP) notice("NOT ENOUGH MP",return_to);
    else if(code==RPG_NOT_IMPLEMENTED) notice("NOT YET IMPLEMENTED",return_to);
    else notice("CANNOT DO THAT",return_to);
}

void prompt_screen(void) RPG_BANKED {
    screen_state=STATE_PROMPT;ui_panel(104,5);ui_text(3,1,"YES");ui_text(12,1,"NO");
    ui_text(choice?10:1,1,">");ui_text(1,4,"A / B:CHOOSE");
}

void shop_screen(void) RPG_BANKED {
    uint8_t i,item;uint16_t price;
    screen_state=STATE_SHOP;HIDE_SPRITES;ui_panel(0,18);shop_count=0;
    ui_text(7,1,"SHOP");ui_text(1,3,"MESETA");ui_number(10,3,game_rpg.money);
    for(i=0;i<3;++i) if(rpg_shop_option(shop_id,i,&item,&price)==RPG_OK) {
        dialogue_item_name(item,item_name);ui_text(3,6+i*3u,item_name);ui_number(12,6+i*3u,price);++shop_count;
    }
    if(choice>=shop_count) choice=0;
    ui_text(1,6+choice*3u,">");ui_text(1,16,"A:BUY  B:LEAVE");
}

void inventory_screen(void) RPG_BANKED {
    uint8_t row,slot,start;
    if(item_slot>=game_rpg.inventory_count) item_slot=game_rpg.inventory_count?game_rpg.inventory_count-1u:0;
    start=(item_slot/6u)*6u;
    screen_state=replace_source?STATE_REPLACE:STATE_INVENTORY;HIDE_SPRITES;ui_panel(0,18);
    ui_text(2,1,replace_source?"REPLACE WHICH ITEM?":"INVENTORY");
    if(!game_rpg.inventory_count) ui_text(4,5,"EMPTY");
    for(row=0;row<6u;++row) {
        slot=start+row;if(slot>=game_rpg.inventory_count) break;
        dialogue_item_name(game_rpg.inventory[slot],item_name);ui_text(4,4+row*2u,item_name);
    }
    ui_text(2,4+(item_slot-start)*2u,">");ui_text(1,17,"A:CHOOSE  B:BACK");
}

void item_screen(void) RPG_BANKED {
    screen_state=STATE_ITEM;ui_panel(32,14);dialogue_item_name(game_rpg.inventory[item_slot],item_name);
    ui_text(5,1,item_name);ui_text(4,4,"USE");ui_text(4,6,"EQUIP");ui_text(4,8,"DROP");
    ui_text(2,4+item_action*2u,">");ui_text(1,12,"A:CHOOSE  B:BACK");
}

void party_screen(void) RPG_BANKED {
    uint8_t i;
    screen_state=STATE_PARTY;ui_panel(0,18);ui_text(3,1,"WHICH CHARACTER?");
    for(i=0;i<4u;++i) if(game_rpg.joined_mask&(1u<<i)) {
        ui_text(3,4+i*3u,names[i]);ui_number(9,4+i*3u,game_rpg.party[i].hp);
        ui_text(12,4+i*3u,"/");ui_number(14,4+i*3u,game_rpg.party[i].max_hp);
    }
    ui_text(1,4+party_choice*3u,">");ui_text(1,17,"A:CHOOSE  B:BACK");
}

void status_screen(void) RPG_BANKED {
    uint8_t i;
    screen_state=STATE_STATUS;ui_panel(0,18);ui_text(6,0,"STATUS");
    for(i=0;i<4u;++i) if(game_rpg.joined_mask&(1u<<i)) {
        ui_text(1,2+i*3u,names[i]);ui_text(7,2+i*3u,"LV");ui_number(10,2+i*3u,game_rpg.party[i].level);
        ui_text(1,3+i*3u,"HP");ui_number(4,3+i*3u,game_rpg.party[i].hp);
        ui_text(9,3+i*3u,"MP");ui_number(12,3+i*3u,game_rpg.party[i].mp);
    }
    ui_text(1,15,"MESETA");ui_number(10,15,game_rpg.money);ui_text(1,17,"A / B TO RETURN");
}

void travel_menu(void) RPG_BANKED {
    screen_state=STATE_TRAVEL_MENU;HIDE_SPRITES;ui_panel(48,12);
    ui_text(4,1,"DESTINATION");ui_text(4,4,"GOTHIC");ui_text(4,6,"UZO");ui_text(4,8,"SKURE");
    ui_text(2,4+choice*2u,">");ui_text(1,11,"A:CHOOSE  B:BACK");
}
void map_magic_screen(void) RPG_BANKED {
    static const char *const spells[]={"","HEAL","CURE","WALL","PROT","FIRE","THUN","WIND","ROPE","BYE","HELP","TERR","TRAP","EXIT","OPEN","RISE","CHAT","TELE","FLY"};
    uint8_t i,id;screen_state=19;HIDE_SPRITES;ui_panel(0,18);
    ui_text(1,1,names[magic_caster]);ui_text(8,1,"MAGIC");
    for(i=0;i<5u;++i){id=rpg_spell_option(&game_rpg,magic_caster,i,0);if(!id)break;
        ui_text(3,4+i*2u,spells[id]);ui_text(11,4+i*2u,"MP");ui_number(15,4+i*2u,rpg_magic_cost(id));}
    ui_text(1,4+magic_choice*2u,">");ui_text(1,17,"A:CHOOSE B:BACK");
}
