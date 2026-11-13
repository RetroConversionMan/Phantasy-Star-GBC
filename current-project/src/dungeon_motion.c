#pragma bank 77
#include <stdint.h>
#include "dungeon_motion.h"
#include "dungeon_motion_data.h"
#include "dungeon_motion_upload.h"
#include "dungeon_view.h"
#include "dungeon_views.h"
#include "dungeon_render.h"
static uint16_t last_image;
static uint8_t last_palette;
static uint16_t word(const DungeonGraphicAsset *a,uint16_t offset) {
    uint8_t bytes[2];bank_copy(bytes,a->bank,a->data+offset,2u);return(uint16_t)bytes[0]|((uint16_t)bytes[1]<<8);
}
uint16_t dungeon_motion_scene(const DungeonState *s,uint8_t frame) __banked {
    uint16_t key=0,view;uint8_t depth,front,kind,nibble;
    if(frame>=38u)return 65535u;
    if(frame>6u)return motion_fixed[frame];
    if(frame==0u)return motion_lookup[0][dungeon_view_scene_id(s)];
    if(frame==6u){front=s->layout[dungeon_sample_position(s,1u)];kind=(front&7u)|((front&128u)?8u:0u);if(!(kind&7u))kind=1u;
        view=word(&dungeon_view_front,(uint16_t)kind*2u);return motion_lookup[0][view];}
    for(depth=0;depth<3u;++depth) {
        front=dungeon_sample(s,depth*3u+4u)&7u;kind=!front?0u:(front==1u||front==7u)?1u:2u;
        nibble=(dungeon_sample(s,depth*3u+2u)&7u)?1u:0u;
        if(dungeon_sample(s,depth*3u+3u)&7u)nibble|=2u;nibble|=kind<<2;key|=(uint16_t)nibble<<(depth*4u);
        if(kind)break;
    }
    view=word(&dungeon_view_index,key*2u);return view<232u?motion_lookup[frame][view]:65535u;
}
uint8_t dungeon_motion_render_image(uint16_t image,uint8_t palette) __banked {
    const DungeonGraphicAsset *asset,*variant;
    if(image>=MOTION_IMAGE_COUNT||palette>=12u)return 0;
    asset=dungeon_graphic_palettes+palette;bank_copy(dungeon_render_palette,asset->bank,asset->data+312u,56u);
    variant=motion_variants+palette;dungeon_motion_upload_begin();dungeon_motion_expand_map(motion_maps+image);
    dungeon_motion_prepare_variant(variant);dungeon_motion_upload_end();
    last_image=image;last_palette=palette;return dungeon_motion_fault?0u:1u;
}
uint16_t dungeon_motion_door_image(uint8_t index) __banked {
    uint8_t kind;
    if(index>10u)return 65535u;
    kind=index<5u?index+2u:index==5u?10u:index+4u;
    return motion_lookup[0][word(&dungeon_view_front,(uint16_t)kind*2u)];
}
uint8_t dungeon_motion_render(const DungeonState *s,uint8_t frame) __banked {
    uint16_t image=dungeon_motion_scene(s,frame);uint8_t result;
    /* Large source actors use OBJbank1 beyond tile127. Standing backgrounds
     * must therefore use only patternbuffer0 before any actor is displayed. */
    if(frame==0u&&dungeon_motion_active&&!dungeon_motion_buffer&&last_image==image&&last_palette==s->palette_index) {
        dungeon_motion_home();return 1u;
    }
    result=dungeon_motion_render_image(image,s->palette_index);
    if(result&&frame==0u) {
        if(dungeon_motion_buffer)result=dungeon_motion_render_image(image,s->palette_index);
        dungeon_motion_home();
    }
    return result;
}
uint8_t dungeon_motion_sequence_frame(uint8_t sequence,uint8_t ordinal) __banked {
    return sequence<10u&&ordinal<9u?motion_sequences[sequence][ordinal]:255u;
}
uint8_t dungeon_motion_turn_sequence(const DungeonState *s,uint8_t right) __banked {
    uint8_t sequence=right?6u:2u;
    if(dungeon_sample(s,right?12u:13u)&7u)sequence+=2u;
    if(dungeon_sample(s,1u)&7u)++sequence;return sequence;
}
