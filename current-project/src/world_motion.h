#ifndef PS_WORLD_MOTION_H
#define PS_WORLD_MOTION_H
#include <stdint.h>
#ifdef __SDCC
#define WORLD_MOTION_BANKED __banked
#else
#define WORLD_MOTION_BANKED
#endif
/* Reset after original map graphics load. Road0 is normal map behavior;
 * roads1..6 enable only source slot3 with a zero reload counter. */
void world_motion_reset(uint8_t road) WORLD_MOTION_BANKED;
/* One original WaitForVInt0E/62BC tick. Returns updated source slot or255.
 * Only the first expired enabled slot uploads; later counters stay unchanged. */
uint8_t world_motion_step(void) WORLD_MOTION_BANKED;
#endif
