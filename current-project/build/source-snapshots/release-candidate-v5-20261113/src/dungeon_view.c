#pragma bank 17
#include "dungeon_view.h"
#include "dungeon_views.h"
#include "dungeon_render.h"
#include "bank_io.h"
#include "dungeon_upload.h"
#ifdef PS_DUNGEON_MOTION
#include "dungeon_motion.h"
#endif
#ifdef __SDCC
#include <gb/gb.h>
#include <gb/cgb.h>
#endif
static uint16_t asset_word(const DungeonGraphicAsset *asset,uint16_t offset) {
    uint8_t value[2];bank_copy(value,asset->bank,asset->data+offset,2u);
    return (uint16_t)value[0]|((uint16_t)value[1]<<8);
}
uint16_t dungeon_view_scene_id(const DungeonState *state) DUNGEON_BANKED {
    uint8_t front,kind,depth,nibble,pos;
    uint16_t key=0;
    pos=dungeon_sample_position(state,1u);front=state->layout[pos];
    if(front&7u) {
        kind=(front&7u)|((front&128u)?8u:0u);
        return asset_word(&dungeon_view_front,(uint16_t)kind*2u);
    }
    for(depth=0;depth<3u;++depth) {
        front=dungeon_sample(state,depth*3u+4u)&7u;
        kind=!front?0u:(front==1u||front==7u)?1u:2u;
        nibble=(dungeon_sample(state,depth*3u+2u)&7u)?1u:0u;
        if(dungeon_sample(state,depth*3u+3u)&7u)nibble|=2u;
        nibble|=kind<<2;
        key|=(uint16_t)nibble<<(depth*4u);
        if(kind)break;
    }
    return asset_word(&dungeon_view_index,key*2u);
}
uint8_t dungeon_draw_view(const DungeonState *state) DUNGEON_BANKED {
#ifdef PS_DUNGEON_MOTION
    return dungeon_motion_render(state,0);
#else
    uint16_t scene_id=dungeon_view_scene_id(state);
#ifdef __SDCC
    const DungeonGraphicAsset *scene,*palette;
#endif
    if(scene_id>=DUNGEON_VIEW_SCENES || state->palette_index>=12u)return 0;
#ifdef __SDCC
    scene=&dungeon_view_maps[scene_id];palette=&dungeon_graphic_palettes[state->palette_index];
#ifdef PS_DUNGEON_LEAN
    bank_copy(dungeon_render_palette,palette->bank,palette->data+312u,56u);
    DISPLAY_OFF;
    set_bkg_palette(0,7,(const uint16_t *)dungeon_render_palette);
#else
    bank_copy(dungeon_render_palette,palette->bank,palette->data,376u);
    DISPLAY_OFF;
    set_bkg_palette(0,7,(const uint16_t *)(dungeon_render_palette+312u));
#endif
    dungeon_upload_view(state->palette_index,scene->bank,scene->data,dungeon_view_variants[state->palette_index]);
    VBK_REG=0;move_bkg(0,0);DISPLAY_ON;
#endif
    return 1;
#endif
}
