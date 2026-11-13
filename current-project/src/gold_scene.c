#pragma bank 31
#include <gb/gb.h>
#include <gb/cgb.h>
#include "gold_scene.h"
#include "gold_scene_data.h"
#include "scene.h"
#include "bank_io.h"
extern uint8_t scene_shared_bytes[40];
void gold_scene_prepare(uint8_t phase,uint8_t effect,uint8_t white) __banked {
 uint8_t i,p,c,mask;if(phase>2u)return;
 bank_copy(scene_palette_background,GOLD_SCENE_BANK,gold_scene_data+GOLD_SCENE_PALETTE+(uint16_t)phase*56u,56u);
 if(!white)return;
 bank_copy(scene_shared_bytes,GOLD_SCENE_BANK,gold_scene_data+GOLD_SCENE_MASKS,21u);
 for(p=0;p<7u;++p){mask=0;for(i=0;i<3u;++i)if(effect&(1u<<i))mask|=scene_shared_bytes[i*7u+p];
  for(c=0;c<4u;++c)if(mask&(1u<<c))scene_palette_background[p*4u+c]=RGB(31,31,31);
 }
}
void gold_scene_show(uint8_t phase) __banked {
 uint8_t row,i;
 bank_bkg_data(GOLD_SCENE_BANK,0u,GOLD_SCENE_TILES,gold_scene_data,0u);
 for(row=0;row<15u;++row){
  bank_copy(scene_shared_bytes,GOLD_SCENE_BANK,gold_scene_data+GOLD_SCENE_MAP+(uint16_t)row*20u,20u);
  bank_copy(scene_shared_bytes+20u,GOLD_SCENE_BANK,gold_scene_data+GOLD_SCENE_MAP+300u+(uint16_t)row*20u,20u);
  VBK_REG=0;set_bkg_tiles(0u,row,20u,1u,scene_shared_bytes);VBK_REG=1;set_bkg_tiles(0u,row,20u,1u,scene_shared_bytes+20u);
 }
 for(i=0;i<20u;++i){scene_shared_bytes[i]=0;scene_shared_bytes[i+20u]=15u;}
 for(row=15u;row<18u;++row){VBK_REG=0;set_bkg_tiles(0u,row,20u,1u,scene_shared_bytes);VBK_REG=1;set_bkg_tiles(0u,row,20u,1u,scene_shared_bytes+20u);}
 VBK_REG=0;move_bkg(0,0);gold_scene_prepare(phase,0u,0u);set_bkg_palette(0u,7u,scene_palette_background);
}
void gold_scene_blue(void) __banked {
 uint8_t i;gold_scene_prepare(0u,0u,0u);for(i=0;i<32u;++i)scene_shared_colors[i]=RGB(0,0,31);
 scene_palette_commit();
}
