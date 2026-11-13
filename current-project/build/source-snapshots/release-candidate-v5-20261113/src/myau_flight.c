#pragma bank 132
#include <gb/gb.h>
#include <gb/cgb.h>
#include "myau_flight.h"
#include "myau_flight_data.h"
#include "scene.h"
#include "bank_io.h"
extern uint16_t scene_shared_colors[32];
extern uint8_t scene_shared_bytes[40];
uint16_t myau_flight_frame;
static uint8_t returning;
static void draw_flight(uint8_t pose,uint8_t x,uint8_t y) __banked {
 const MyauFlightFrame *f=myau_flight_frames+pose;uint8_t i;
 x=(uint8_t)(((uint16_t)x*5u)>>3);y=(uint8_t)(((uint16_t)y*5u)>>3);
 for(i=0;i<f->sprites;++i){
  bank_copy(scene_shared_bytes,131,myau_flight_data+f->offset+(uint16_t)i*4u,4u);
  set_sprite_tile(i,84u+scene_shared_bytes[2]);set_sprite_prop(i,scene_shared_bytes[3]);
  move_sprite(i,x+scene_shared_bytes[0],y+scene_shared_bytes[1]);
 }
 for(;i<40u;++i)move_sprite(i,0,0);
 bank_copy(scene_shared_colors,131,myau_flight_data+f->offset+(uint16_t)f->sprites*4u,64u);
 set_sprite_palette(0,8,scene_shared_colors);scene_actor_active=1;SHOW_SPRITES;
}
uint8_t myau_flight_begin(uint8_t return_trip) __banked {
 uint8_t i;if(!scene_show(15,0,0))return 0;
 scene_actor_hide();HIDE_WIN;returning=!!return_trip;myau_flight_frame=0;
 for(i=0;i<MYAU_FLIGHT_TILES;++i){bank_copy(scene_shared_bytes,131,myau_flight_data+(uint16_t)i*16u,16u);VBK_REG=1;set_sprite_data(84u+i,1,scene_shared_bytes);}
 VBK_REG=0;SPRITES_8x8;return 1;
}
uint8_t myau_flight_tick(void) __banked {
 uint8_t updates,pose,x,y;uint16_t last=returning?571u:507u;
 if(myau_flight_frame>=last)return 1;
 ++myau_flight_frame;
 if(myau_flight_frame==last)return 1;
 if(myau_flight_frame==1u){draw_flight(returning?4u:0u,returning?80u:208u,returning?48u:136u);return 0;}
 if((myau_flight_frame-2u)&7u)return 0;
 updates=(uint8_t)((myau_flight_frame-2u)>>3)+1u;pose=(updates-1u)&3u;
 if(returning){pose+=4u;y=48u+updates;x=80u-(updates==72u?8u:updates>>3);}
 else{x=208u-updates;y=136u-updates;}
 draw_flight(pose,x,y);return 0;
}

void myau_battle_palette(uint8_t restore) __banked {
 uint8_t i;
 if(restore)bank_copy(scene_shared_colors,131,myau_flight_data+MYAU_BATTLE_PALETTE_OFFSET,64u);
 else for(i=0;i<32u;++i)scene_shared_colors[i]=0x7c00u;
 set_sprite_palette(0,8,scene_shared_colors);
}
