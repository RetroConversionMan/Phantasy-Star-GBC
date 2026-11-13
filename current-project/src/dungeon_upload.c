/* ROM0 upload/cache of source-derived native standing scenes. LCD must be off. */
#pragma bank 0
#include "dungeon_upload.h"
#include "dungeon_render.h"
#include "dungeon_render_scratch.h"
#include <string.h>
#ifdef PS_DUNGEON_MOTION
#include "dungeon_motion.h"
uint16_t dungeon_uploaded_patterns;
void dungeon_invalidate_view_cache(void) BANK_IO_FIXED {dungeon_motion_invalidate();}
#else
#ifdef __SDCC
#include <gb/gb.h>
#include <gb/cgb.h>
#endif
static uint8_t cache_valid,cache_palette;
uint16_t dungeon_uploaded_patterns;
void dungeon_invalidate_view_cache(void) BANK_IO_FIXED {cache_valid=0;}
void dungeon_upload_view(uint8_t palette_index,uint8_t bank,const uint8_t *map,
    const DungeonGraphicAsset *variants) BANK_IO_FIXED {
#ifdef __SDCC
    uint8_t saved=CURRENT_BANK,row,col,slot,i,cursor=0;
    uint16_t number,pattern,address,previous;
    const uint8_t *source,*ids;
    const DungeonGraphicAsset *variant;
    volatile uint8_t *dest;
    dungeon_uploaded_patterns=0;
    if(!cache_valid || cache_palette!=palette_index) {
        memset(dungeon_render_scratch.cache.mapping,255,sizeof(dungeon_render_scratch.cache.mapping));
        cache_palette=palette_index;cache_valid=1;
    }
    memset(dungeon_render_scratch.cache.used,0,32u);
    /* The fast path reuses the compositor buffer. The slow pixel path never
     * runs concurrently and invalidates this cache before using its union. */
    bank_copy(dungeon_render_map,bank,map,600u);
    ids=dungeon_render_map;
    for(number=0;number<300u;++number) {
        pattern=*ids++;pattern|=(uint16_t)*ids++<<8;
        slot=dungeon_render_scratch.cache.mapping[pattern];
        if(slot!=255u)dungeon_render_scratch.cache.used[slot>>3]|=1u<<(slot&7u);
    }
    ids=dungeon_render_map;
    for(row=0;row<15u;++row)for(col=0;col<20u;++col) {
        pattern=*ids++;pattern|=(uint16_t)*ids++<<8;
        slot=dungeon_render_scratch.cache.mapping[pattern];
        if(slot==255u) {
            while(dungeon_render_scratch.cache.used[cursor>>3]&(1u<<(cursor&7u)))++cursor;
            slot=cursor++;
            previous=dungeon_render_scratch.cache.patterns[slot];
            if(previous<DUNGEON_VIEW_PATTERNS && dungeon_render_scratch.cache.mapping[previous]==slot)
                dungeon_render_scratch.cache.mapping[previous]=255u;
            dungeon_render_scratch.cache.patterns[slot]=pattern;
            dungeon_render_scratch.cache.mapping[pattern]=slot;
            dungeon_render_scratch.cache.used[slot>>3]|=1u<<(slot&7u);
            variant=variants+(pattern>>9);pattern&=511u;
            source=variant->data+pattern*17u;
            SWITCH_ROM_MBC5(variant->bank);
            dungeon_render_scratch.cache.attributes[slot]=source[16];
            VBK_REG=0;
            address=slot<128u?0x9000u+(uint16_t)slot*16u:0x8800u+(uint16_t)(slot-128u)*16u;
            dest=(volatile uint8_t *)address;
            for(i=0;i<16u;++i)*dest++=*source++;
            ++dungeon_uploaded_patterns;
        }
        address=0x9800u+(uint16_t)row*32u+col;
        VBK_REG=0;*(volatile uint8_t *)address=slot;
        VBK_REG=1;*(volatile uint8_t *)address=dungeon_render_scratch.cache.attributes[slot];
    }
    for(row=15u;row<18u;++row)for(col=0;col<20u;++col) {
        address=0x9800u+(uint16_t)row*32u+col;
        VBK_REG=0;*(volatile uint8_t *)address=0;
        VBK_REG=1;*(volatile uint8_t *)address=15;
    }
    VBK_REG=0;move_bkg(0,0);SWITCH_ROM_MBC5(saved);
#else
    (void)palette_index;(void)bank;(void)map;(void)variants;
#endif
}
#endif
