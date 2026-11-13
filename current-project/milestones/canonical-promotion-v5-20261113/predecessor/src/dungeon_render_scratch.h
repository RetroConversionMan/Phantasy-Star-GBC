#ifndef PS_DUNGEON_RENDER_SCRATCH_H
#define PS_DUNGEON_RENDER_SCRATCH_H
#include "dungeon_views.h"
typedef union {
    uint8_t strip[1280];
    struct {
        uint8_t mapping[DUNGEON_VIEW_PATTERNS];
        uint16_t patterns[255];
        uint8_t used[32],attributes[255];
    } cache;
} DungeonRenderScratch;
extern DungeonRenderScratch dungeon_render_scratch;
#endif
