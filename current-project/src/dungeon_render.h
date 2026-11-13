#ifndef PS_DUNGEON_RENDER_H
#define PS_DUNGEON_RENDER_H
#include "dungeon.h"
#include "dungeon_upload.h"
#define DUNGEON_RENDER_WIDTH 160u
#define DUNGEON_RENDER_HEIGHT 120u
#ifdef PS_DUNGEON_LEAN
extern uint8_t dungeon_render_map[600];
extern uint8_t dungeon_render_palette[56];
#else
extern uint8_t dungeon_render_map[1536];
extern uint8_t dungeon_render_palette[376];
#endif
/* Frame0 selects standing corridor/wall from source geometry; frames1..37
 * select original movement frames. Caller owns timing and object dispatch. */
uint8_t dungeon_compose(const DungeonState *state,uint8_t frame) DUNGEON_BANKED;
/* Invalidate view cache after any world/battle BG pattern upload.
 * Hides LCD during transfer and enables it afterward. Caller hides world
 * sprites/window. Bottom24 pixels are reserved for native UI, font preserved. */
uint8_t dungeon_render(const DungeonState *state,uint8_t frame) DUNGEON_BANKED;
#endif
