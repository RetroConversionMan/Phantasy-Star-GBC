#pragma bank 13
#include <gb/gb.h>
#include <gb/cgb.h>
#include "scene.h"
#include "scene_actor_data.h"
#include "bank_io.h"
#include "assets.h"
uint8_t scene_actor_active;
extern uint16_t scene_shared_colors[32];
extern uint8_t scene_shared_bytes[40];
static void clear_actors(void) {
    uint8_t i;HIDE_SPRITES;
    for(i=0;i<40u;++i)move_sprite(i,0,0);
    scene_actor_active=0;
}
void scene_actor_hide(void) __banked {
    clear_actors();
    bank_copy(scene_shared_colors,3u,alis_palettes,64u);
    set_sprite_palette(0,8,scene_shared_colors);
}
static uint8_t actor_show(uint8_t kind,uint8_t identity,uint8_t palette) __banked {
    uint8_t i,found=0;
    const SceneActorAsset *asset;
    for(i=0;i<SCENE_ACTOR_COUNT;++i) {
        asset=scene_actors+i;
        if(asset->kind==kind && asset->id==identity &&
           (asset->palette==255u || asset->palette==palette)){found=1;break;}
    }
    if(!found)return 0;
    return scene_actor_show_data(asset->bank,asset->data,asset->tiles,asset->sprites);
}
uint8_t scene_actor_show_data(uint8_t bank,const uint8_t *data,uint8_t tiles,uint8_t sprites) __banked {
    uint8_t i;uint16_t offset;
    if(!data || !tiles || tiles>172u || !sprites || sprites>40u)return 0;
    clear_actors();
    for(i=0;i<tiles;++i) {
        bank_copy(scene_shared_bytes,bank,data+(uint16_t)i*16u,16u);
        VBK_REG=1;set_sprite_data(84u+i,1,scene_shared_bytes);
    }
    VBK_REG=0;offset=(uint16_t)tiles*16u;
    for(i=0;i<sprites;++i) {
        bank_copy(scene_shared_bytes,bank,data+offset+(uint16_t)i*4u,4u);
        set_sprite_tile(i,84u+scene_shared_bytes[2]);set_sprite_prop(i,scene_shared_bytes[3]);
        move_sprite(i,scene_shared_bytes[0],scene_shared_bytes[1]);
    }
    offset+=(uint16_t)sprites*4u;
    bank_copy(scene_shared_colors,bank,data+offset,64u);
    set_sprite_palette(0,8,scene_shared_colors);SPRITES_8x8;
    scene_actor_active=1;SHOW_SPRITES;return 1;
}

uint8_t scene_portrait_show(uint8_t portrait) __banked {return actor_show(0,portrait,255u);}
uint8_t scene_enemy_show(uint8_t enemy,uint8_t palette_index) __banked {
    if(palette_index>11u)return 0;
    return actor_show(1,enemy,palette_index);
}
