#ifndef PS_CHEST_ART_H
#define PS_CHEST_ART_H
#include <stdint.h>
#define CHEST_FRAME_CLOSED 0x3au
#define CHEST_FRAME_OPEN 0x3du
#define CHEST_FRAME_PARTY_TRAP 0x3eu
#define CHEST_FRAME_SINGLE_TRAP 0x43u
/* Exact source pose indices3A..46. Caller turns LCD off. Occupies shared actor
 * OAM0..39, OBJ bank1 tiles84+, palettes0..7; scene_actor_hide restores Alis.
 * These are poses only: original timing, shake and effects remain caller work. */
uint8_t chest_show(uint8_t frame) __banked;
#endif
