#pragma bank 0
#include "bank_io.h"
#include <string.h>
#ifdef __SDCC
#include <gb/gb.h>
#include <gb/cgb.h>
#endif
uint8_t bank_read8(uint8_t bank, const void *address) BANK_IO_FIXED {
#ifdef __SDCC
    uint8_t saved = CURRENT_BANK;
    uint8_t value;
    SWITCH_ROM_MBC5(bank);
    value = *(const uint8_t *)address;
    SWITCH_ROM_MBC5(saved);
    return value;
#else
    (void)bank;
    return *(const uint8_t *)address;
#endif
}
void bank_copy(void *destination, uint8_t bank, const void *source, uint16_t length) BANK_IO_FIXED {
#ifdef __SDCC
    uint8_t saved = CURRENT_BANK;
    SWITCH_ROM_MBC5(bank);
    memcpy(destination, source, length);
    SWITCH_ROM_MBC5(saved);
#else
    (void)bank;
    memcpy(destination, source, length);
#endif
}
void bank_bkg_data(uint8_t bank, uint8_t first, uint8_t count, const uint8_t *source, uint8_t vram_bank) BANK_IO_FIXED {
#ifdef __SDCC
    uint8_t saved = CURRENT_BANK, saved_vram = VBK_REG;
    SWITCH_ROM_MBC5(bank);
    VBK_REG = vram_bank;
    set_bkg_data(first, count, source);
    VBK_REG = saved_vram;
    SWITCH_ROM_MBC5(saved);
#else
    (void)bank; (void)first; (void)count; (void)source; (void)vram_bank;
#endif
}
void bank_bkg_phase(uint8_t bank,uint8_t first,uint8_t count,const uint8_t *source,uint8_t vram_bank) BANK_IO_FIXED {
#ifdef __SDCC
    uint16_t from=(uint16_t)source;
    uint16_t destination=(LCDC_REG&LCDCF_BG8000)?0x8000u+(uint16_t)first*16u:
        (uint16_t)(0x9000+(int16_t)(int8_t)first*16);
    uint8_t saved=CURRENT_BANK,saved_vram=VBK_REG;
    if(!count||count>16u||(from&15u))return;
    /* GP DMA takes about8us per16B block. At most128us here; entering by
     * scanline149 leaves ample time before active display resumes. */
    if(LCDC_REG&LCDCF_ON)while(LY_REG<144u||LY_REG>149u){}
    CRITICAL {
        SWITCH_ROM_MBC5(bank);VBK_REG=vram_bank;
        HDMA1_REG=(uint8_t)(from>>8);HDMA2_REG=(uint8_t)from;
        HDMA3_REG=(uint8_t)(destination>>8)&31u;HDMA4_REG=(uint8_t)destination;
        HDMA5_REG=count-1u;
        VBK_REG=saved_vram;SWITCH_ROM_MBC5(saved);
    }
#else
    (void)bank;(void)first;(void)count;(void)source;(void)vram_bank;
#endif
}
