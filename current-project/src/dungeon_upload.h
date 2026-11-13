#ifndef PS_DUNGEON_UPLOAD_H
#define PS_DUNGEON_UPLOAD_H
#include "bank_io.h"
#include "dungeon_graphics.h"
extern uint16_t dungeon_uploaded_patterns;
void dungeon_invalidate_view_cache(void) BANK_IO_FIXED;
void dungeon_upload_view(uint8_t palette_index,uint8_t bank,const uint8_t *map,
    const DungeonGraphicAsset *variants) BANK_IO_FIXED;
#endif
