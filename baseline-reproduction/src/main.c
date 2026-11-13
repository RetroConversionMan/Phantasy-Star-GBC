/* Native Game Boy Color exploration milestone.
 * Original RPG logic (events, combat, dungeons and audio) is not implemented.
 * Game data is converted by tools/extract_assets.py; no SMS CPU is emulated.
 */
#include <gb/gb.h>
#include <gb/cgb.h>
#include <stdint.h>
#include <string.h>
#include "assets.h"
#include "font.h"

#define STATE_TITLE 0u
#define STATE_WALK 1u
#define STATE_MENU 2u
#define STATE_HELP 3u
#define MAP_BANK 2u
#define SPRITE_BANK 3u
#define WORLD_W (CAMINEET_WIDTH * 8u)
#define WORLD_H (CAMINEET_HEIGHT * 8u)
#define SAVE_BASE ((volatile uint8_t *)0xa000)

/* Deliberately exported for emulator-based behavior checks. */
uint16_t player_x, player_y;
uint16_t camera_x, camera_y;
uint8_t screen_state;
uint8_t facing, walk_frame;
uint8_t saved_position_valid;
uint16_t saved_x, saved_y;
uint8_t saved_facing;
static uint8_t last_keys, menu_choice, title_choice, toast_timer, anim_tick;
static uint8_t row_tiles[32], row_attrs[32];
static uint8_t old_camera_tile_x, old_camera_tile_y;
static const uint16_t ui_palette[] = { RGB(2,3,8),RGB(6,10,19),RGB(30,22,8),RGB(30,30,27) };

static uint8_t tile_at(uint8_t x, uint8_t y) {
    if (x >= CAMINEET_WIDTH || y >= CAMINEET_HEIGHT) return 0;
    return camineet_map[(uint16_t)y * CAMINEET_WIDTH + x];
}
static uint8_t attr_at(uint8_t x, uint8_t y) {
    if (x >= CAMINEET_WIDTH || y >= CAMINEET_HEIGHT) return 0;
    return camineet_attrs[(uint16_t)y * CAMINEET_WIDTH + x];
}
static void draw_row(uint8_t x, uint8_t y, uint8_t n) {
    uint8_t i, first = 32u - (x & 31u);
    if (first > n) first = n;
    for (i=0; i<n; ++i) { row_tiles[i]=tile_at(x+i,y); row_attrs[i]=attr_at(x+i,y); }
    VBK_REG=0;
    set_bkg_tiles(x&31u,y&31u,first,1,row_tiles);
    if (n>first) set_bkg_tiles(0,y&31u,n-first,1,row_tiles+first);
    VBK_REG=1;
    set_bkg_tiles(x&31u,y&31u,first,1,row_attrs);
    if (n>first) set_bkg_tiles(0,y&31u,n-first,1,row_attrs+first);
    VBK_REG=0;
}
static void draw_column(uint8_t x, uint8_t y, uint8_t n) {
    uint8_t i, first=32u-(y&31u);
    if(first>n) first=n;
    for(i=0;i<n;++i) { row_tiles[i]=tile_at(x,y+i); row_attrs[i]=attr_at(x,y+i); }
    VBK_REG=0;
    set_bkg_tiles(x&31u,y&31u,1,first,row_tiles);
    if(n>first) set_bkg_tiles(x&31u,0,1,n-first,row_tiles+first);
    VBK_REG=1;
    set_bkg_tiles(x&31u,y&31u,1,first,row_attrs);
    if(n>first) set_bkg_tiles(x&31u,0,1,n-first,row_attrs+first);
    VBK_REG=0;
}
static void compute_camera(void) {
    camera_x=player_x>80u ? player_x-80u : 0u;
    camera_y=player_y>80u ? player_y-80u : 0u;
    if(camera_x>WORLD_W-160u) camera_x=WORLD_W-160u;
    if(camera_y>WORLD_H-144u) camera_y=WORLD_H-144u;
}
static void refresh_map(void) {
    uint8_t row;
    SWITCH_ROM_MBC5(MAP_BANK);
    compute_camera();
    old_camera_tile_x=camera_x>>3;
    old_camera_tile_y=camera_y>>3;
    for(row=0;row<19;++row) draw_row(old_camera_tile_x,old_camera_tile_y+row,21);
    move_bkg(camera_x&255u,camera_y&255u);
}
static void scroll_map(void) {
    uint8_t x,y;
    compute_camera(); x=camera_x>>3; y=camera_y>>3;
    if(x!=old_camera_tile_x) draw_column(x>old_camera_tile_x ? x+20u:x,y,19);
    if(y!=old_camera_tile_y) draw_row(x,y>old_camera_tile_y ? y+18u:y,21);
    old_camera_tile_x=x;old_camera_tile_y=y;
    move_bkg(camera_x&255u,camera_y&255u);
}
static uint8_t blocked(uint16_t x,uint16_t y) {
    if(x>=WORLD_W || y>=WORLD_H) return 1;
    return camineet_collision[(y>>4)*(CAMINEET_WIDTH/2u)+(x>>4)];
}
static uint8_t can_stand(uint16_t x,uint16_t y) {
    if(x<6u || x>WORLD_W-6u || y<8u || y>=WORLD_H) return 0;
    return !(blocked(x-5u,y-2u)||blocked(x+4u,y-2u)||blocked(x-5u,y-7u)||blocked(x+4u,y-7u));
}
static void draw_player(void) {
    uint8_t i,frame;
    int16_t sx=(int16_t)(player_x-camera_x)-8;
    int16_t sy=(int16_t)(player_y-camera_y)-24;
    /* Frame lookup is supplied by the asset converter. */
    frame=alis_frame_order[facing*3u+walk_frame];
    for(i=0;i<6;++i) {
        set_sprite_tile(i,frame*6u+i);
        set_sprite_prop(i,0x08u | alis_attrs[frame*6u+i]);
        move_sprite(i,(uint8_t)(sx+(i&1u)*8u+8u),(uint8_t)(sy+(i>>1)*8u+16u));
    }
}
static void text(uint8_t x,uint8_t y,const char *s) {
    uint8_t n=0;
    while(*s && n<20u-x) {row_tiles[n++]=(uint8_t)*s++-32u;}
    VBK_REG=0;set_win_tiles(x,y,n,1,row_tiles);
}
static void panel(uint8_t y,uint8_t rows) {
    uint8_t row;
    memset(row_tiles,0,20);memset(row_attrs,15,20); /* VRAM bank1, palette7 */
    for(row=0;row<rows;++row) {
        VBK_REG=0;set_win_tiles(0,row,20,1,row_tiles);
        VBK_REG=1;set_win_tiles(0,row,20,1,row_attrs);
    }
    VBK_REG=0;move_win(7,y);SHOW_WIN;
}
static void title_screen(void) {
    screen_state=STATE_TITLE;HIDE_SPRITES;
    panel(56,11);
    text(4,1,"PHANTASY STAR");text(3,3,"INCOMPLETE PORT");
    text(4,5,"NEW WALK");text(4,6,saved_position_valid?"CONTINUE WALK":"NO SAVED WALK");
    text(2,5+title_choice,">");
    text(1,9,"START / A TO CHOOSE");
}
static void menu_screen(void) {
    screen_state=STATE_MENU;HIDE_SPRITES;panel(48,12);
    text(6,1,"CAMINEET");
    text(4,3,"RESUME");text(4,5,"SAVE POSITION");text(4,7,"TITLE");
    text(2,3+menu_choice*2u,">");
    text(2,10,"A:CHOOSE  B:BACK");
}
static void help_screen(void) {
    screen_state=STATE_HELP;HIDE_SPRITES;panel(0,18);
    text(4,1,"PHANTASY STAR");text(2,3,"EXPLORATION BUILD");
    text(1,5,"D-PAD   WALK");text(1,6,"HOLD B  WALK FASTER");
    text(1,7,"START   MENU");text(1,8,"SELECT  SAVE WALK");
    text(1,10,"ORIGINAL TOWN / ART");
    text(1,12,"STORY AND BATTLES");text(1,13,"ARE NOT PLAYABLE.");
    text(2,16,"A / B TO RETURN");
}
static uint16_t save_checksum(const uint8_t *data) {
    uint8_t i;uint16_t c=0x53a1;
    for(i=0;i<10;++i) c=(c<<1)^(c>>15)^data[i];
    return c;
}
static void load_saved_position(void) {
    uint8_t data[12],i;uint16_t c;
    saved_position_valid=0;
    ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);
    for(i=0;i<12;++i) data[i]=SAVE_BASE[i];
    DISABLE_RAM_MBC5;
    c=save_checksum(data);
    if(data[0]!='P'||data[1]!='S'||data[2]!='W'||data[3]!=1||data[8]>3||
       data[10]!=(uint8_t)c||data[11]!=(uint8_t)(c>>8)) return;
    saved_x=(uint16_t)data[4]|((uint16_t)data[5]<<8);
    saved_y=(uint16_t)data[6]|((uint16_t)data[7]<<8);
    saved_facing=data[8];
    if(can_stand(saved_x,saved_y)) saved_position_valid=1;
}
static void save_position(void) {
    uint8_t data[12],i;uint16_t c;
    data[0]='P';data[1]='S';data[2]='W';data[3]=1;
    data[4]=player_x;data[5]=player_x>>8;data[6]=player_y;data[7]=player_y>>8;
    data[8]=facing;data[9]=0;c=save_checksum(data);data[10]=c;data[11]=c>>8;
    ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);
    SAVE_BASE[0]=0; /* An interrupted write must not pass validation. */
    for(i=1;i<12;++i) SAVE_BASE[i]=data[i];
    SAVE_BASE[0]=data[0];DISABLE_RAM_MBC5;
    saved_x=player_x;saved_y=player_y;saved_facing=facing;saved_position_valid=1;
}
static void resume_walk(void) {
    HIDE_WIN;SHOW_SPRITES;screen_state=STATE_WALK;toast_timer=0;draw_player();
}
static void start_walk(uint8_t continued) {
    DISPLAY_OFF;HIDE_WIN;
    player_x=continued?saved_x:START_X;
    player_y=continued?saved_y:START_Y;
    facing=continued?saved_facing:0;walk_frame=0;anim_tick=0;
    refresh_map();resume_walk();DISPLAY_ON;
}
static void move_player(uint8_t keys) {
    int8_t dx=0,dy=0;uint8_t steps=(keys&J_B)?2u:1u,moved=0;
    if(keys&J_DOWN) {dy=1;facing=0;}
    else if(keys&J_UP) {dy=-1;facing=1;}
    else if(keys&J_LEFT) {dx=-1;facing=2;}
    else if(keys&J_RIGHT) {dx=1;facing=3;}
    while(steps-- && (dx||dy)) {
        uint16_t nx=player_x+dx,ny=player_y+dy;
        if(can_stand(nx,ny)) {player_x=nx;player_y=ny;moved=1;}
    }
    if(moved) {++anim_tick;walk_frame=(anim_tick>>3)%3u;} else {walk_frame=0;anim_tick=0;}
    scroll_map();draw_player();
}
void main(void) {
    uint8_t keys,pressed;
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
    /* CGB-only flag is set by the linker; all graphics depend on color VRAM. */
    SWITCH_ROM_MBC5(MAP_BANK);
    VBK_REG=0;set_bkg_data(0,BG_TILE_COUNT,bg_tiles);
    set_bkg_palette(0,7,bg_palettes);set_bkg_palette(7,1,ui_palette);
    VBK_REG=1;set_bkg_data(0,64,ui_font);
    SWITCH_ROM_MBC5(SPRITE_BANK);
    set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);
    set_sprite_palette(0,ALIS_PALETTE_COUNT,alis_palettes);
    VBK_REG=0;SPRITES_8x8;
    SWITCH_ROM_MBC5(MAP_BANK);
    player_x=START_X;player_y=START_Y;facing=0;walk_frame=0;
    refresh_map();load_saved_position();title_choice=saved_position_valid?1u:0u;
    SHOW_BKG;title_screen();DISPLAY_ON;
    while(1) {
        vsync();keys=joypad();pressed=keys&~last_keys;last_keys=keys;
        if(screen_state==STATE_TITLE) {
            if((pressed&(J_UP|J_DOWN))&&saved_position_valid) {title_choice^=1;title_screen();}
            if(pressed&(J_START|J_A)) start_walk(title_choice&&saved_position_valid);
        } else if(screen_state==STATE_WALK) {
            if(pressed&J_START) {menu_choice=0;menu_screen();}
            else if(pressed&J_A) help_screen();
            else {
                move_player(keys);
                if(pressed&J_SELECT) {save_position();panel(128,2);text(2,0,"POSITION SAVED");toast_timer=90;}
                else if(toast_timer && !--toast_timer) HIDE_WIN;
            }
        } else if(screen_state==STATE_MENU) {
            if(pressed&(J_B|J_START)) resume_walk();
            else if(pressed&J_UP) {menu_choice=menu_choice?menu_choice-1u:2u;menu_screen();}
            else if(pressed&J_DOWN) {menu_choice=menu_choice<2u?menu_choice+1u:0u;menu_screen();}
            else if(pressed&J_A) {
                if(menu_choice==0) resume_walk();
                else if(menu_choice==1) {save_position();text(2,9,"POSITION SAVED");}
                else {title_choice=saved_position_valid?1u:0u;title_screen();}
            }
        } else if(pressed&(J_A|J_B|J_START)) resume_walk();
    }
}
