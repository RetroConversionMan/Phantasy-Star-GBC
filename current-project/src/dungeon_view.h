#ifndef PS_DUNGEON_VIEW_H
#define PS_DUNGEON_VIEW_H
#include "dungeon.h"
uint16_t dungeon_view_scene_id(const DungeonState *state) DUNGEON_BANKED;
uint8_t dungeon_draw_view(const DungeonState *state) DUNGEON_BANKED;
#endif
