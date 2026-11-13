#pragma bank 0
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "dungeon_motion_upload.h"
#include "dungeon_motion_data.h"
#include "dungeon_render.h"
#include "dungeon_render_scratch.h"
#include "dungeon_upload.h"
uint8_t dungeon_motion_active,dungeon_motion_buffer,dungeon_motion_fault,dungeon_motion_palette_muted;
uint16_t dungeon_motion_uploaded;
static uint8_t target_pattern,target_map;
static uint16_t buffer_patterns[2][MOTION_CACHE_SLOTS];
static uint8_t *map_work;
static void dma(uint8_t bank,uint16_t source,uint16_t dest,uint8_t vram,uint8_t tiles) __critical {
    uint8_t saved=CURRENT_BANK;
    SWITCH_ROM_MBC5(bank);VBK_REG=vram;
    HDMA1_REG=source>>8;HDMA2_REG=(uint8_t)source;
    HDMA3_REG=dest>>8;HDMA4_REG=(uint8_t)dest;
    HDMA5_REG=tiles-1u|((LCDC_REG&LCDCF_ON)?0x80u:0u);
    while(!(HDMA5_REG&0x80u));
    if(HDMA5_REG!=255u)dungeon_motion_fault=1;
    VBK_REG=0;SWITCH_ROM_MBC5(saved);
}
void dungeon_motion_invalidate(void) BANK_IO_FIXED {
    dungeon_motion_active=0;
#ifndef PS_DUNGEON_MOTION
    dungeon_invalidate_view_cache();
#endif
}
void dungeon_motion_external_view(void) BANK_IO_FIXED {
    memset(buffer_patterns,255,sizeof(buffer_patterns));
    dungeon_motion_buffer=0;dungeon_motion_active=1;
}
void dungeon_motion_upload_begin(void) BANK_IO_FIXED {
#ifndef PS_DUNGEON_MOTION
    dungeon_invalidate_view_cache();
#endif
    dungeon_motion_fault=0;dungeon_motion_uploaded=0;
    if(!dungeon_motion_active){DISPLAY_OFF;target_pattern=target_map=0;memset(buffer_patterns,255,sizeof(buffer_patterns));}
    else {target_pattern=dungeon_motion_buffer^1u;target_map=(LCDC_REG&LCDCF_BG9C00)?0u:1u;}
}
static uint8_t block_sources[6],pack_row,pack_col;
static uint16_t variant_base;
static const uint8_t pattern_banks[]={MOTION_PATTERN_BANKS};
static uint8_t upload_slot;
static void expand_blocks(void) __nonbanked __naked {
    __asm
    ld hl,#_dungeon_render_scratch
    ld de,#_dungeon_render_map
    ld b,#8
001$:
    ld c,#10
002$:
    push bc
    ld a,(hl+)
    ld c,a
    ld a,(hl+)
    ld b,a
    push hl
    push de
    ld hl,#_block_sources
    bit 3,b
    jr z,003$
    inc hl
    inc hl
    inc hl
003$:
    ld a,(hl+)
    ldh (__current_bank),a
    ld (#0x2000),a
    ld a,(hl+)
    ld e,a
    ld d,(hl)
    ld a,b
    and #7
    ld b,a
    sla c
    rl b
    sla c
    rl b
    sla c
    rl b
    ld h,b
    ld l,c
    add hl,de
    pop de
    ld a,(hl+)
    ld (de),a
    inc de
    ld a,(hl+)
    ld (de),a
    inc de
    ld a,(hl+)
    ld (de),a
    inc de
    ld a,(hl+)
    ld (de),a
    inc de
    push de
    push hl
    ldhl sp,#7
    ld a,(hl)
    pop hl
    cp #1
    jr z,005$
    ld a,e
    add #36
    ld e,a
    jr nc,004$
    inc d
004$:
    ld a,(hl+)
    ld (de),a
    inc de
    ld a,(hl+)
    ld (de),a
    inc de
    ld a,(hl+)
    ld (de),a
    inc de
    ld a,(hl+)
    ld (de),a
005$:
    pop de
    pop hl
    pop bc
    dec c
    jp nz,002$
    ld a,e
    add #40
    ld e,a
    jr nc,006$
    inc d
006$:
    dec b
    jp nz,001$
    ret
    __endasm;
}
void dungeon_motion_expand_map(const DungeonGraphicAsset *map) BANK_IO_FIXED {
    uint8_t saved=CURRENT_BANK;
    bank_copy(&dungeon_render_scratch,map->bank,map->data,160u);
    memcpy(block_sources,motion_blocks,6u);expand_blocks();SWITCH_ROM_MBC5(saved);
}
static void convert_map(void) __nonbanked __naked {
    __asm
    ld hl,#_dungeon_render_map
    ld bc,#300
007$:
    push bc
    ld a,(hl+)
    ld c,a
    ld b,(hl)
    dec hl
    push hl
    sla c
    rl b
    sla c
    rl b
    ld a,(#_variant_base)
    ld e,a
    ld a,(#_variant_base+1)
    ld d,a
    ld h,b
    ld l,c
    add hl,de
    ld a,(hl+)
    ld e,a
    ld a,(hl+)
    ld d,a
    ld a,(hl+)
    ld b,a
    ld c,(hl)
    push bc
    ld a,c
    add a
    ld l,a
    ld h,#0
    rl h
    ld bc,#_dungeon_render_scratch
    add hl,bc
    ld (hl),e
    inc hl
    ld (hl),d
    pop bc
    pop hl
    ld (hl),c
    inc hl
    ld (hl),b
    inc hl
    pop bc
    dec bc
    ld a,b
    or c
    jp nz,007$
    ret
    __endasm;
}
void dungeon_motion_prepare_variant(const DungeonGraphicAsset *variant) BANK_IO_FIXED {
    uint8_t saved=CURRENT_BANK,bank=variant->bank;
    memset(&dungeon_render_scratch,255,MOTION_CACHE_SLOTS*2u);
    variant_base=(uint16_t)variant->data;SWITCH_ROM_MBC5(bank);convert_map();SWITCH_ROM_MBC5(saved);
}
/* Pools start at4000. This ROM0 loop touches only WRAM and fixed metadata
 * while an art bank is selected; every one-tile DMA finishes before IRQs run. */
static void upload_patterns(void) __nonbanked __naked {
    __asm
    ldh a,(__current_bank)
    push af
    xor a
    ld (#_upload_slot),a
    ld hl,#_dungeon_render_scratch
    ld de,#_buffer_patterns
    ld a,(#_target_pattern)
    or a
    jr z,020$
    ld de,#(_buffer_patterns+MOTION_CACHE_SLOTS*2)
020$:
    ld a,(hl+)
    ld c,a
    ld a,(hl+)
    ld b,a
    cp #255
    jr z,022$
    ld a,(de)
    cp c
    jr nz,023$
    inc de
    ld a,(de)
    cp b
    jr nz,021$
    inc de
    jp 028$
021$:
    dec de
    jr 023$
022$:
    inc de
    inc de
    jp 028$
023$:
    ld a,c
    ld (de),a
    inc de
    ld a,b
    ld (de),a
    inc de
    push hl
    push de
    ld a,b
    srl a
    srl a
    ld l,a
    ld h,#0
    ld de,#_pattern_banks
    add hl,de
    ld a,(hl)
    di
    ldh (__current_bank),a
    ld (#0x2000),a
    ld a,c
    swap a
    and #240
    ldh (#0x52),a
    ld a,b
    and #3
    swap a
    ld b,a
    ld a,c
    swap a
    and #15
    or b
    or #64
    ldh (#0x51),a
    ld b,#0
    ld a,(#_target_pattern)
    or a
    ld a,(#_upload_slot)
    jr z,025$
    cp #192
    jr nc,024$
    add #64
    inc b
    jr 025$
024$:
    add #(MOTION_CACHE_SLOTS-192)
025$:
    ld c,a
    ld a,b
    ldh (#0x4f),a
    ld a,c
    swap a
    and #240
    ldh (#0x54),a
    ld a,c
    swap a
    and #15
    bit 7,c
    jr nz,026$
    or #16
026$:
    or #128
    ldh (#0x53),a
    ldh a,(#0x40)
    and #128
    ldh (#0x55),a
027$:
    ldh a,(#0x55)
    bit 7,a
    jr z,027$
    cp #255
    jr z,029$
    ld a,#1
    ld (#_dungeon_motion_fault),a
029$:
    ei
    ld hl,#_dungeon_motion_uploaded
    inc (hl)
    pop de
    pop hl
028$:
    ld a,(#_upload_slot)
    inc a
    ld (#_upload_slot),a
    cp #MOTION_CACHE_SLOTS
    jp nz,020$
    pop af
    ldh (__current_bank),a
    ld (#0x2000),a
    xor a
    ldh (#0x4f),a
    ret
    __endasm;
}
static void maps(uint16_t dest) {
    dma(CURRENT_BANK,(uint16_t)map_work,dest,0u,36u);
    dma(CURRENT_BANK,(uint16_t)(map_work+576u),dest,1u,36u);
}
static void pack_map(void) __nonbanked __naked {
    __asm
    ld a,(#_map_work)
    ld e,a
    ld a,(#_map_work+1)
    ld d,a
    ld h,d
    ld l,e
    ld bc,#576
    add hl,bc
    ld b,h
    ld c,l
    ld hl,#_dungeon_render_map
    ld a,#15
    ld (#_pack_row),a
008$:
    ld a,#20
    ld (#_pack_col),a
009$:
    ld a,(#_target_pattern)
    or a
    jr z,011$
    ld a,(hl+)
    cp #192
    jr nc,010$
    add #64
    ld (de),a
    inc de
    ld a,(hl+)
    or #8
    jr 012$
010$:
    add #(MOTION_CACHE_SLOTS-192)
    jr 013$
011$:
    ld a,(hl+)
013$:
    ld (de),a
    inc de
    ld a,(hl+)
012$:
    ld (bc),a
    inc bc
    ld a,(#_pack_col)
    dec a
    ld (#_pack_col),a
    jr nz,009$
    ld a,#12
    ld (#_pack_col),a
014$:
    xor a
    ld (de),a
    inc de
    ld (bc),a
    inc bc
    ld a,(#_pack_col)
    dec a
    ld (#_pack_col),a
    jr nz,014$
    ld a,(#_pack_row)
    dec a
    ld (#_pack_row),a
    jr nz,008$
    ret
    __endasm;
}
void dungeon_motion_upload_end(void) BANK_IO_FIXED {
    upload_patterns();map_work=(uint8_t *)(((uint16_t)&dungeon_render_scratch+15u)&0xfff0u);
    pack_map();memset(map_work+480u,0,96u);memset(map_work+1056u,15,96u);
    maps(target_map?0x9c00u:0x9800u);
    if(LCDC_REG&LCDCF_ON)while(LY_REG<144u);
    if(target_map)LCDC_REG|=LCDCF_BG9C00;else LCDC_REG&=(uint8_t)~LCDCF_BG9C00;
    if(!dungeon_motion_palette_muted)set_bkg_palette(0,7,(uint16_t *)dungeon_render_palette);
    move_bkg(0,0);
#ifdef PS_DUNGEON_MOTION
    dungeon_uploaded_patterns=dungeon_motion_uploaded;
#endif
    dungeon_motion_buffer=target_pattern;dungeon_motion_active=1;SHOW_BKG;DISPLAY_ON;
}
void dungeon_motion_home(void) BANK_IO_FIXED {
    if(LCDC_REG&LCDCF_BG9C00){maps(0x9800u);while(LY_REG<144u);LCDC_REG&=(uint8_t)~LCDCF_BG9C00;}
}
