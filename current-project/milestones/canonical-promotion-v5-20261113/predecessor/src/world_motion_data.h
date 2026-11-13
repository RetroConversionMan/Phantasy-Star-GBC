/* Generated source62BC/630A animation descriptors. */
#ifndef PS_WORLD_MOTION_DATA_H
#define PS_WORLD_MOTION_DATA_H
#include <stdint.h>
typedef struct WorldMotionSlot {
    uint8_t bank, tile, count, vram_bank;
    const uint8_t *frames;
} WorldMotionSlot;
extern const uint8_t world_motion_enables[11][6];
extern const uint8_t world_motion_reloads[6];
extern const WorldMotionSlot world_motion_slots[2][6];
#endif
