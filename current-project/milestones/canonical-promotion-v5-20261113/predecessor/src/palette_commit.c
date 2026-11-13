#pragma bank 119
#include <gb/gb.h>
#include <gb/cgb.h>
#include "scene.h"
uint16_t scene_palette_background[32];
static uint16_t palette_color(uint8_t sprites,uint8_t index) {
    uint8_t lo,hi;
    while(STAT_REG&2u);
    if(sprites){OCPS_REG=index*2u;lo=OCPD_REG;}else{BCPS_REG=index*2u;lo=BCPD_REG;}
    while(STAT_REG&2u);
    if(sprites){OCPS_REG=index*2u+1u;hi=OCPD_REG;}else{BCPS_REG=index*2u+1u;hi=BCPD_REG;}
    return (uint16_t)lo|((uint16_t)hi<<8);
}
static void commit_palette_bytes(void) __naked {
    __asm
        ld hl,#_scene_palette_background
        ld a,#0x80
        ldh (#0x68),a
        ld c,#0x69
        ld b,#64
001$:
        ld a,(hl+)
        ldh (c),a
        dec b
        jr nz,001$
        ld hl,#_scene_shared_colors
        ld a,#0x80
        ldh (#0x6a),a
        ld c,#0x6b
        ld b,#64
002$:
        ld a,(hl+)
        ldh (c),a
        dec b
        jr nz,002$
        ret
    __endasm;
}
void scene_palette_commit(void) __banked {
    /* All64 colors must be prepared before VBlank. Calculating between the
     * BG and OBJ writes exposes mixed source fade steps within one frame. */
    if(LCDC_REG&LCDCF_ON)vsync();
    /*128 auto-incremented bytes take under4,400 CPU cycles, fitting the
     * double-speed VBlank even after the standard OAM interrupt. */
    CRITICAL {commit_palette_bytes();}
}

void scene_palette_capture(void) __banked {
    uint8_t i;
    for(i=0;i<32u;++i)scene_palette_background[i]=palette_color(0u,i);
    for(i=0;i<32u;++i)scene_shared_colors[i]=palette_color(1u,i);
}
