#ifndef PS_DUNGEON_MOTION_UPLOAD_H
#define PS_DUNGEON_MOTION_UPLOAD_H
#include "dungeon_motion.h"
#include "dungeon_graphics.h"
/* Called from bank77 with all motion metadata in that bank. */
void dungeon_motion_upload_begin(void) BANK_IO_FIXED;
void dungeon_motion_expand_map(const DungeonGraphicAsset *map) BANK_IO_FIXED;
void dungeon_motion_prepare_variant(const DungeonGraphicAsset *variant) BANK_IO_FIXED;
void dungeon_motion_upload_end(void) BANK_IO_FIXED;
#endif
