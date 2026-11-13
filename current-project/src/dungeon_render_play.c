/* Production buffers and renderer dispatch. PS_DUNGEON_MOTION selects the
 * source-derived native cache; legacy standalone probes retain standing-only
 * behavior. The original full compositor remains a separate research target. */
#pragma bank 17
#include "dungeon_render.h"
#include "dungeon_view.h"
#include "dungeon_render_scratch.h"
#ifdef PS_DUNGEON_MOTION
#include "dungeon_motion.h"
#endif
uint8_t dungeon_render_map[600];
uint8_t dungeon_render_palette[56];
DungeonRenderScratch dungeon_render_scratch;
uint8_t dungeon_render_phase;
uint8_t dungeon_render(const DungeonState *state,uint8_t frame) DUNGEON_BANKED {
#ifdef PS_DUNGEON_MOTION
    return dungeon_motion_render(state,frame);
#else
    if(frame)return 0; /* No silent substitution of unsupported animation. */
    return dungeon_draw_view(state);
#endif
}
