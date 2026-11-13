#pragma bank 13
#include <gb/gb.h>
#include <gb/cgb.h>
#include "scene.h"
#include "scene_data.h"
#include "bank_io.h"
uint8_t scene_shared_bytes[40];
uint16_t scene_shared_colors[32];
static uint8_t map_row[20],attribute_row[20];
static uint16_t active_scene=65535u;
uint8_t scene_show(uint8_t type,uint8_t portrait,uint8_t enemy) __banked {
    const SceneAsset *asset;
    const ScenePatternPool *pool;
    uint8_t row,col,index,vram_bank,found=0;
    uint16_t n,word,pattern,cell=0;
    for(n=0;n<SCENE_ASSET_COUNT;++n) {
        asset=scene_assets+n;
        if(asset->type==type && asset->portrait==portrait && asset->enemy==enemy) {found=1;break;}
    }
    if(!found)return 0;
    active_scene=n;
    bank_copy(scene_shared_colors,asset->bank,asset->map+600u,56u);
    set_bkg_palette(0,7,scene_shared_colors);
    for(row=0;row<15u;++row) {
        bank_copy(scene_shared_bytes,asset->bank,asset->map+(uint16_t)row*40u,40u);
        for(col=0;col<20u;++col,++cell) {
            word=scene_shared_bytes[col*2u]|((uint16_t)scene_shared_bytes[col*2u+1u]<<8);
            pattern=word&8191u;pool=scene_pattern_pools+(pattern>>9);
            vram_bank=cell>=256u;
            index=vram_bank?(uint8_t)(cell-256u+64u):(uint8_t)cell;
            bank_bkg_data(pool->bank,index,1u,pool->data+((pattern&511u)<<4),vram_bank);
            map_row[col]=index;attribute_row[col]=(uint8_t)(word>>13)|(vram_bank?8u:0u);
        }
        VBK_REG=0;set_bkg_tiles(0,row,20,1,map_row);
        VBK_REG=1;set_bkg_tiles(0,row,20,1,attribute_row);
    }
    /* Reserve the final three rows for UI instead of exposing stale map data. */
    for(col=0;col<20u;++col){map_row[col]=0;attribute_row[col]=15;}
    for(row=15;row<18u;++row){
        VBK_REG=0;set_bkg_tiles(0,row,20,1,map_row);
        VBK_REG=1;set_bkg_tiles(0,row,20,1,attribute_row);
    }
    VBK_REG=0;move_bkg(0,0);return 1;
}

uint8_t scene_show_room(uint8_t palette_index,uint8_t portrait,uint8_t enemy) __banked {
    if(palette_index>11u)return 0;
    return scene_show(64u+palette_index,portrait,enemy);
}

/* Palette-effect masks encode original index identity even when two source
 * palette entries initially have the same RGB value. Bit0:3..15, bit1:16,
 * bit2:19..31. Source7BEE restores the entire original palette on even ticks. */
void scene_palette_prepare(uint8_t effect,uint8_t white) __banked {
    const SceneAsset *asset;uint8_t p,c,mask;
    if(active_scene==65535u)return;
    asset=scene_assets+active_scene;
    bank_copy(scene_palette_background,asset->bank,asset->map+600u,56u);
    if(white){
        bank_copy(scene_shared_bytes,asset->bank,asset->map+656u,21u);
        for(p=0;p<7u;++p){
            mask=0;if(effect&1u)mask|=scene_shared_bytes[p];
            if(effect&2u)mask|=scene_shared_bytes[p+7u];
            if(effect&4u)mask|=scene_shared_bytes[p+14u];
            for(c=0;c<4u;++c)if(mask&(1u<<c))scene_palette_background[p*4u+c]=RGB(31,31,31);
        }
    }
}

void scene_palette_flash(uint8_t effect,uint8_t white) __banked {
    scene_palette_capture();scene_palette_prepare(effect,white);scene_palette_commit();
}
