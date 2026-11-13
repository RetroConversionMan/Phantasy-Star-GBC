/* ROM0 double-buffered CGB DMA. Existing dungeon scratch owns all staging. */
#pragma bank 0
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "ending_upload.h"
#include "dungeon_render.h"
#include "dungeon_render_scratch.h"
#define MAP_BYTES 576u
#define COMMAND_OFFSET 1152u
uint16_t ending_uploaded_patterns;
uint8_t ending_upload_buffer,ending_upload_fault;
uint8_t ending_dma_before,ending_dma_after,ending_dma_count;
static uint8_t *work;
static uint8_t target_buffer,groups_left,group_index,group_progress,maps_done;
/* The compact image has300tile IDs followed by300attributes. Convert the
 * inactive buffer's slot addressing, then pad each20-cell row to32 for DMA.
 * Only WRAM is touched here, so interrupts can restore any selected ROM bank. */
static void pack_maps(void) __nonbanked __naked {
    __asm
    ld a,(#_target_buffer)
    or a
    jr z,010$
    ld hl,#_dungeon_render_map
    ld de,#(_dungeon_render_map+300)
    ld bc,#300
001$:
    ld a,(hl)
    cp #192
    jr nc,002$
    add #64
    ld (hl),a
    ld a,(de)
    or #8
    ld (de),a
    jr 003$
002$:
    add #17
    ld (hl),a
003$:
    inc hl
    inc de
    dec bc
    ld a,b
    or c
    jr nz,001$
010$:
    ld hl,#_dungeon_render_map
    ld a,(#_work)
    ld e,a
    ld a,(#_work+1)
    ld d,a
    call 020$
    ld b,#96
    xor a
011$:
    ld (de),a
    inc de
    dec b
    jr nz,011$
    call 020$
    ld b,#96
    ld a,#15
012$:
    ld (de),a
    inc de
    dec b
    jr nz,012$
    ret
020$:
    ld b,#15
021$:
    ld c,#20
022$:
    ld a,(hl+)
    ld (de),a
    inc de
    dec c
    jr nz,022$
    ld c,#12
    xor a
023$:
    ld (de),a
    inc de
    dec c
    jr nz,023$
    dec b
    jr nz,021$
    ret
    __endasm;
}
static void dma(uint8_t bank,uint16_t source,uint16_t dest,uint8_t vram,uint8_t tiles) __critical {
    uint8_t saved=CURRENT_BANK;
    /* HBlank DMA reads the selected ROM bank at each block. Mask interrupts
     * for this short synchronous chunk, restore the bank, then let queued
     * audio/VBlank interrupts run. Pattern chunks are <=16 scanlines; map
     * chunks36 scanlines, so no chunk can swallow two frame interrupts. */
    SWITCH_ROM_MBC5(bank);VBK_REG=vram;
    HDMA1_REG=(uint8_t)(source>>8);HDMA2_REG=(uint8_t)source;
    HDMA3_REG=(uint8_t)(dest>>8);HDMA4_REG=(uint8_t)dest;
    ending_dma_before=LY_REG;ending_dma_count=tiles;
    HDMA5_REG=(tiles-1u)|((LCDC_REG&LCDCF_ON)?0x80u:0u);
    while(!(HDMA5_REG&0x80u));
    ending_dma_after=LY_REG;
    if(HDMA5_REG!=255u)ending_upload_fault=1;
    VBK_REG=0;SWITCH_ROM_MBC5(saved);
}
void ending_upload_begin(uint8_t bank,const uint8_t *data,uint8_t target) BANK_IO_FIXED {
    uint8_t saved=CURRENT_BANK,count,color;
    uint16_t i=0;
    work=(uint8_t *)(((uint16_t)&dungeon_render_scratch+15u)&0xfff0u);
    target_buffer=target;group_index=0;group_progress=0;maps_done=0;ending_uploaded_patterns=0;
    SWITCH_ROM_MBC5(bank);groups_left=*data++;
    memcpy(work+COMMAND_OFFSET,data,(uint16_t)groups_left*6u);data+=(uint16_t)groups_left*6u;
    memcpy(dungeon_render_map,data,300u);data+=300u;
    while(i<300u){count=*data++;color=*data++;while(count--)dungeon_render_map[300u+i++]=color;}
    SWITCH_ROM_MBC5(saved);
    pack_maps();
}
static void maps(uint16_t dest) {
    dma(CURRENT_BANK,(uint16_t)work,dest,0u,36u);
    dma(CURRENT_BANK,(uint16_t)(work+MAP_BYTES),dest,1u,36u);
}
uint8_t ending_upload_step(void) BANK_IO_FIXED {
    const uint8_t *command;
    uint8_t count,slot,vram,limit;
    uint16_t source,dest;
    while(groups_left) {
        command=work+COMMAND_OFFSET+(uint16_t)group_index*6u;
        source=((uint16_t)command[1]<<8)|command[2];source+=(uint16_t)group_progress*16u;
        dest=((uint16_t)command[3]<<8)|command[4];dest+=(uint16_t)group_progress*16u;
        slot=(uint8_t)((dest-0x9000u)>>4);vram=0;
        count=command[5]+1u-group_progress;if(count>16u)count=16u;
        if(target_buffer) {
            if(slot<64u){dest=0x9400u+(uint16_t)slot*16u;vram=1u;limit=64u-slot;}
            else if(slot<192u){dest=0x8800u+(uint16_t)(slot-64u)*16u;vram=1u;limit=192u-slot;}
            else {dest=0x8d10u+(uint16_t)(slot-192u)*16u;limit=17u;}
            if(count>limit)count=limit;
        }
        dma(command[0],source,dest,vram,count);ending_uploaded_patterns+=count;
        group_progress+=count;
        if(group_progress==command[5]+1u){group_progress=0;++group_index;--groups_left;}
        /* Each short DMA restores the mapper and interrupt state. Continue
         * preparing the inactive image instead of adding an idle VBlank
         * after every64 patterns; queued audio interrupts run between chunks. */
    }
    if(!maps_done){maps(target_buffer?0x9c00u:0x9800u);maps_done=1;}
    return 1;
}
void ending_upload_commit(void) BANK_IO_FIXED {
    if(LCDC_REG&LCDCF_ON)while(LY_REG<144u);
    ending_upload_buffer=target_buffer;
    if(target_buffer)LCDC_REG|=LCDCF_BG9C00;
    else LCDC_REG&=(uint8_t)~LCDCF_BG9C00;
    move_bkg(0,0);
}
void ending_upload_home(void) BANK_IO_FIXED {
    if(ending_upload_buffer){maps(0x9800u);while(LY_REG<144u);ending_upload_buffer=0;LCDC_REG&=(uint8_t)~LCDCF_BG9C00;}
}
