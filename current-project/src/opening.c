#pragma bank 132
#include <gb/gb.h>
#include <gb/cgb.h>
#include "opening.h"
#include "opening_data.h"
#include "bank_io.h"
extern uint16_t scene_shared_colors[32];
extern uint8_t scene_shared_bytes[40];
uint16_t opening_position;
static uint8_t opening_head;
/* C304 is a224-pixel ring, but native SCY is256. Keep an absolute source
 * position so a wrap never rewinds the native tilemap ring. LABEL73D0
 * uploads the row32pixels behind scroll from WRAM before43AA advances.
 * Planet WRAM replaces rows0..11 at position224; their VRAM updates start
 * at position256. The cropped viewport reaches them24pixels later. */
static void pan_row(uint8_t logical) __banked {
 uint8_t row=logical%28u,planet=0;uint16_t offset;
 if(row<12u&&opening_position>=(uint16_t)257u+(uint16_t)row*8u)planet=1;
 row%=12u;
 offset=1624u+(uint16_t)planet*768u+(uint16_t)row*32u+6u;
 bank_copy(scene_shared_bytes,129,opening_pan+offset,20u);
 bank_copy(scene_shared_bytes+20,129,opening_pan+offset+384u,20u);
 VBK_REG=0;set_bkg_tiles(0,logical&31u,20,1,scene_shared_bytes);
 VBK_REG=1;set_bkg_tiles(0,logical&31u,20,1,scene_shared_bytes+20);VBK_REG=0;
}
void opening_begin(void) __banked {
 uint8_t row;opening_position=128u;opening_head=19u;
 HIDE_SPRITES;HIDE_WIN;
 bank_bkg_data(129,0,98,opening_pan,0);
 bank_copy(scene_shared_colors,129,opening_pan+1568u,56u);set_bkg_palette(0,7,scene_shared_colors);
 for(row=0;row<19u;++row)pan_row(opening_head+row);
 move_bkg(0,152u);SHOW_BKG;
}
uint8_t opening_tick(uint8_t skip_pressed) __banked {
 uint8_t head;
 if(skip_pressed||opening_position>=352u)return 1;
 ++opening_position;head=(uint8_t)((opening_position+24u)>>3);
 if(head!=opening_head){opening_head=head;pan_row(head+18u);}
 move_bkg(0,(uint8_t)(opening_position+24u));
 return opening_position==352u;
}
uint8_t movie_scene_show(uint8_t image) __banked {
 const MovieImage *p;uint8_t row,col;uint16_t first,offset;
 if(!image||image>3u)return 0;p=movie_images+image-1u;
 HIDE_SPRITES;HIDE_WIN;first=p->tiles>256u?256u:p->tiles;
 bank_bkg_data(p->bank,0,(uint8_t)first,p->data,0);
 if(p->tiles>256u)bank_bkg_data(p->bank,64,(uint8_t)(p->tiles-256u),p->data+4096u,1);
 offset=p->tiles*16u;bank_copy(scene_shared_colors,p->bank,p->data+offset+600u,56u);set_bkg_palette(0,7,scene_shared_colors);
 for(row=0;row<15u;++row){
  bank_copy(scene_shared_bytes,p->bank,p->data+offset+(uint16_t)row*20u,20u);VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
  bank_copy(scene_shared_bytes,p->bank,p->data+offset+300u+(uint16_t)row*20u,20u);VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
 }
 for(col=0;col<20u;++col){scene_shared_bytes[col]=0;scene_shared_bytes[col+20u]=15;}
 for(row=15;row<18u;++row){VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes+20);}
 VBK_REG=0;move_bkg(0,0);SHOW_BKG;return 1;
}

void movie_city_caption(void) __banked {
 const MovieImage *p=movie_images;uint8_t row;uint16_t offset=p->tiles*16u+656u;
 /* Only the four native rows touched by the source caption change. Both
  * variants share patterns/palettes, so no LCD disable or graphics reload. */
 for(row=1;row<5u;++row){
  bank_copy(scene_shared_bytes,p->bank,p->data+offset+(uint16_t)row*20u+1u,14u);
  VBK_REG=0;set_bkg_tiles(1,row,14,1,scene_shared_bytes);
  bank_copy(scene_shared_bytes,p->bank,p->data+offset+300u+(uint16_t)row*20u+1u,14u);
  VBK_REG=1;set_bkg_tiles(1,row,14,1,scene_shared_bytes);
 }
 VBK_REG=0;
}
