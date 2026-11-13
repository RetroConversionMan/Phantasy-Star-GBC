#pragma bank 12
#include <gb/gb.h>
#include <gb/cgb.h>
#include "cutscene.h"
#include "cutscene_art_data.h"
#include "bank_io.h"
/* Reuse actor upload scratch to keep the production WRAM budget bounded. */
extern uint16_t scene_shared_colors[32];
extern uint8_t scene_shared_bytes[40];
uint8_t cutscene_portrait_show(uint8_t portrait) __banked {
 const CutscenePortrait *p;uint8_t row,col;uint16_t first,offset;
 if(portrait>8u)return 0;p=cutscene_portraits+portrait;
 first=p->tiles>256u?256u:p->tiles;
 bank_bkg_data(p->bank,0,(uint8_t)first,p->data,0);
 if(p->tiles>256u)bank_bkg_data(p->bank,64,(uint8_t)(p->tiles-256u),p->data+4096u,1);
 offset=p->tiles*16u;
 bank_copy(scene_shared_colors,p->bank,p->data+offset+600u,56u);set_bkg_palette(0,7,scene_shared_colors);
 for(row=0;row<15u;++row){
  bank_copy(scene_shared_bytes,p->bank,p->data+offset+(uint16_t)row*20u,20u);
  VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
  bank_copy(scene_shared_bytes,p->bank,p->data+offset+300u+(uint16_t)row*20u,20u);
  VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
 }
 for(col=0;col<20u;++col){scene_shared_bytes[col]=0;scene_shared_bytes[col+20u]=15;}
 for(row=15;row<18u;++row){
  VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
  VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes+20);
 }
 VBK_REG=0;move_bkg(0,0);return 1;
}
