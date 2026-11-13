#pragma bank 21
#include "world_motion_data.h"

extern const uint8_t world_motion_g0_s0[];
extern const uint8_t world_motion_g0_s1[];
extern const uint8_t world_motion_g0_s3[];
extern const uint8_t world_motion_g0_s4[];
extern const uint8_t world_motion_g1_s2[];
extern const uint8_t world_motion_g1_s3[];
extern const uint8_t world_motion_g1_s5[];

const uint8_t world_motion_enables[11][6] = {
    {1,1,0,1,1,0},
    {0,0,1,1,0,1},
    {0,0,0,0,0,0},
    {0,0,0,0,0,0},
    {0,0,0,0,0,0},
    {0,0,0,0,0,0},
    {0,0,0,0,0,0},
    {0,0,0,0,0,0},
    {0,0,0,0,0,0},
    {0,0,0,0,0,0},
    {0,0,0,0,0,0}
};
const uint8_t world_motion_reloads[6] = {
    0x1f,0x0f,0x0f,0x03,0x0f,0x07
};

const WorldMotionSlot world_motion_slots[2][6] = {
    {
        {24,3,12,0,world_motion_g0_s0},
        {24,15,3,0,world_motion_g0_s1},
        {0,0,0,0,0},
        {24,18,6,0,world_motion_g0_s3},
        {24,24,8,0,world_motion_g0_s4},
        {0,0,0,0,0}
    },
    {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {25,15,4,0,world_motion_g1_s2},
        {25,19,3,0,world_motion_g1_s3},
        {0,0,0,0,0},
        {25,22,16,0,world_motion_g1_s5}
    },
};
