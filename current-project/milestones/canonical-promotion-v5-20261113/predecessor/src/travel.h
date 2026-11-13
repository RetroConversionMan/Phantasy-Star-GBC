#ifndef PS_TRAVEL_H
#define PS_TRAVEL_H
#include <stdint.h>
#ifdef __SDCC
#define TRAVEL_BANKED __banked
#else
#define TRAVEL_BANKED
#endif
#define TRAVEL_WORLD 1u
#define TRAVEL_SPACE 2u
#define TRAVEL_PALETTE 4u
#define TRAVEL_AUDIO 8u
#define TRAVEL_DONE 16u
#define TRAVEL_DRAW 32u
#define TRAVEL_FADE_IN 1u
#define TRAVEL_ROAD 2u
#define TRAVEL_ASCEND 3u
#define TRAVEL_ASCEND_FADE 4u
#define TRAVEL_SPACE_RUN 5u
#define TRAVEL_ARRIVE 6u
#define TRAVEL_EXIT_FADE 7u
#define TRAVEL_FINISHED 8u
typedef struct {
    uint16_t x,y,speed,phase_frames;
    uint32_t updated_rows,arrival_rows;
    uint8_t tag,stage,next_stage,map,facing,ship_mode,music;
    uint8_t road_steps,step_pixels,fraction,scroll,turns;
    uint8_t planet,arrival_planet,space_visible,fade_step,fade_clock,fade_in;
} TravelState;
/* Roads1..6, ships81..88. Initial screen fade-out belongs to caller; begin
 * loads the source departure and runs its fade-in. Return0 rejects tag.
 * Call step exactly once per display frame, with either action-button edge.
 * Changes/audio are explicit flags; positions are native centre/feet. */
uint8_t travel_begin(TravelState *,uint8_t tag) TRAVEL_BANKED;
uint8_t travel_step(TravelState *,uint8_t skip_pressed) TRAVEL_BANKED;
/* Source row recipe for the224px space ring: kind0stars,1departure,2arrival;
 * returned row is0..11. This preserves source73D0's progressive row upload. */
uint8_t travel_space_row(const TravelState *,uint8_t row,uint8_t *source_row) TRAVEL_BANKED;
/* Original7B40 palette transition applied to one SMS6-bit color. */
uint8_t travel_fade_color(uint8_t color,uint8_t step,uint8_t fade_in) TRAVEL_BANKED;
#ifdef __SDCC
/* Optional native presenter. Preserves font/Alis, owns BG/OBJ during travel;
 * caller dispatches audio flags and resumes world state only at DONE. */
void travel_present(const TravelState *,uint8_t flags) __banked;
/* One source7B40 fade-out color update of current BG0..6 and OBJ0..7.
 * Call nine times, one call every four display frames. Preserves UI palette7,
 * waits for palette-port access, and reuses shared scene scratch (no new RAM). */
void travel_fade_current(void) __banked;
/* Generic scene transition: captures current BG0..6/OBJ0..7 as60 SMS colors.
 * begin(1) blacks them immediately; step selects original7B40 progression.
 * UI BG palette7 is preserved. begin/step can run with LCD enabled. */
void scene_fade_begin(uint8_t fade_in) __banked;
void scene_fade_step(uint8_t step,uint8_t fade_in) __banked;
#endif
#endif
