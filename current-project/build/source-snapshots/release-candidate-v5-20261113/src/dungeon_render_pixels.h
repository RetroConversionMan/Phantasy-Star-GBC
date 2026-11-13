#ifndef PS_DUNGEON_RENDER_PIXELS_H
#define PS_DUNGEON_RENDER_PIXELS_H
#include "bank_io.h"
void dungeon_render_pixels(uint8_t bank,const uint8_t *graphics,
    const uint8_t *tilemap,const uint8_t *palette) BANK_IO_FIXED;
#endif
