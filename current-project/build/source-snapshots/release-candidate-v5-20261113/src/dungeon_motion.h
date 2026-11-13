#ifndef PS_DUNGEON_MOTION_H
#define PS_DUNGEON_MOTION_H
#include "dungeon.h"
#include "bank_io.h"
extern uint8_t dungeon_motion_active,dungeon_motion_buffer,dungeon_motion_fault;
extern uint8_t dungeon_motion_palette_muted;
extern uint16_t dungeon_motion_uploaded;
/* Invalidate after external BG-pattern or shared-scratch use. Production's
 * legacy invalidator delegates here; research builds clear the legacy cache. */
void dungeon_motion_invalidate(void) BANK_IO_FIXED;
/* Exact source view selection.0..37 are original6AED frame numbers. */
uint16_t dungeon_motion_scene(const DungeonState *,uint8_t frame) DUNGEON_BANKED;
/* Original6E75 door layer index0..10, including the shared5/6 layer. */
uint16_t dungeon_motion_door_image(uint8_t index) DUNGEON_BANKED;
/* Native source image, retaining the preceding complete image during HBlank
 * uploads. Frame0 guarantees map9800 AND primary BGbank0 patterns, allowing
 * large source actors to overwrite the overlapping secondary BGbank1 buffer. */
uint8_t dungeon_motion_render(const DungeonState *,uint8_t frame) DUNGEON_BANKED;
uint8_t dungeon_motion_render_image(uint16_t image,uint8_t palette) DUNGEON_BANKED;
void dungeon_motion_home(void) BANK_IO_FIXED;
/* Forget patterns without touching an externally drawn primary BG map. The
 * next image uploads to secondary patterns/map while the caller hides it. */
void dungeon_motion_external_view(void) BANK_IO_FIXED;
/* Original6A76 sequences.255 marks end. Turn selection takes the already
 * rotated source state, exactly as67B7/67E2 do before selecting their script. */
uint8_t dungeon_motion_sequence_frame(uint8_t sequence,uint8_t ordinal) DUNGEON_BANKED;
uint8_t dungeon_motion_turn_sequence(const DungeonState *,uint8_t right) DUNGEON_BANKED;
#endif
