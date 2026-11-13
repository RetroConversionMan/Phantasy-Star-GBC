#ifndef PS_PRESENTATION_H
#define PS_PRESENTATION_H
#include <stdint.h>
#define PRESENT_ODIN 1u
#define PRESENT_TORCH 2u
#define PRESENT_PRISM 3u
#define PRESENT_ENDING_SKY 4u
extern uint8_t presentation_active;
extern uint16_t presentation_frame;
/* LCD off for begin. Exact source palette sequences with native graphics
 * retaining source index identity. No input skips these original effects.
 * Call tick once per VBlank. Return1 means complete,0 still running.
 * Odin111frames, Torch1frame, Prism320frames, ending-sky216frames.
 * Odin completion is followed by a button wait before narrative4414. */
uint8_t presentation_begin(uint8_t effect) __banked;
uint8_t presentation_tick(void) __banked;
#endif
