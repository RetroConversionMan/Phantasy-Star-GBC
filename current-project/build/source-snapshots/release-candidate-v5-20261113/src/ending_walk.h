#ifndef PS_ENDING_WALK_H
#define PS_ENDING_WALK_H
#include <stdint.h>
#include "world.h"

/* Source LABEL_454E tail, after the final bitmap's 208-frame hold.
 * The caller invokes begin with the retained source C315 lighting value,
 * then tick once per VBlank.  The sequence owns its original sound commands.
 * A nonzero tick result means the final 180-frame hold has completed and
 * the caller should enter the original title/load-intro mode (Game_mode 2).
 * There is no action-button skip in this source sequence.
 */
extern uint16_t ending_walk_frame;
extern uint8_t ending_walk_busy; /* DMA preparing the next complete image. */
void ending_walk_begin(uint8_t light) WORLD_BANKED;
uint8_t ending_walk_tick(void) WORLD_BANKED;
#endif
