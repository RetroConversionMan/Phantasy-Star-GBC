#pragma bank 12
#include <gb/gb.h>
#include <gb/cgb.h>
#include "presentation.h"
#include "presentation_data.h"
#include "bank_io.h"
#include "scene.h"
#include "game_transition.h"
extern uint16_t scene_shared_colors[32];
extern uint8_t scene_shared_bytes[40];
uint8_t presentation_active;
uint16_t presentation_frame;
static uint8_t palette_index;
static void effect_palette(uint8_t index) __banked {
 const PresentationAsset *a=presentation_assets+presentation_active-1u;
 uint16_t offset=a->tiles*16u;
 if(a->sprites){offset+=(uint16_t)a->sprites*4u+(uint16_t)index*64u;bank_copy(scene_shared_colors,a->bank,a->data+offset,64u);set_sprite_palette(0,8,scene_shared_colors);}
 else {offset+=600u+(uint16_t)index*56u;bank_copy(scene_shared_colors,a->bank,a->data+offset,56u);set_bkg_palette(0,7,scene_shared_colors);}
 palette_index=index;
}
uint8_t presentation_begin(uint8_t effect) __banked {
 const PresentationAsset *a;uint8_t row,col;uint16_t first,offset;
 if(!effect||effect>4u)return 0;
 a=presentation_assets+effect-1u;presentation_active=effect;presentation_frame=0;
 if(a->sprites){scene_actor_show_data(a->bank,a->data,(uint8_t)a->tiles,a->sprites);}
 else {
  scene_actor_hide();HIDE_SPRITES;
  first=a->tiles>256u?256u:a->tiles;
  bank_bkg_data(a->bank,0,(uint8_t)first,a->data,0);
  if(a->tiles>256u)bank_bkg_data(a->bank,64,(uint8_t)(a->tiles-256u),a->data+4096u,1);
  offset=a->tiles*16u;
  for(row=0;row<15u;++row){
   bank_copy(scene_shared_bytes,a->bank,a->data+offset+(uint16_t)row*20u,20u);VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
   bank_copy(scene_shared_bytes,a->bank,a->data+offset+300u+(uint16_t)row*20u,20u);VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
  }
  for(col=0;col<20u;++col){scene_shared_bytes[col]=0;scene_shared_bytes[col+20u]=15;}
  for(row=15;row<18u;++row){VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes+20);}
  VBK_REG=0;move_bkg(0,0);
 }
 effect_palette(effect==PRESENT_ODIN?0u:1u);return 1;
}
uint8_t presentation_tick(void) __banked {
 uint8_t index=0;uint16_t duration;
 if(!presentation_active)return 1;
 game_transition_vint16();++presentation_frame;
 if(presentation_active==PRESENT_ODIN){
  duration=111u;if(presentation_frame>=15u){index=(uint8_t)((presentation_frame-15u)/16u)+1u;if(index>6u)index=6u;}
 } else if(presentation_active==PRESENT_TORCH){duration=1u;index=1;}
 else if(presentation_active==PRESENT_PRISM){
  duration=320u;index=presentation_frame<216u?(uint8_t)((presentation_frame/3u)%24u)+1u:(uint8_t)((presentation_frame-216u)/8u)+25u;
 } else {duration=216u;index=(uint8_t)(presentation_frame/24u)+1u;}
 if(presentation_frame>=duration){presentation_active=0;return 1;}
 if(index!=palette_index)effect_palette(index);
 return 0;
}
