#ifndef PS_BOSS_MOTION_H
#define PS_BOSS_MOTION_H
#include "battle_scene.h"
#define BOSS_MOTION_FRAME 1u
#define BOSS_MOTION_IMPACT 2u
#define BOSS_MOTION_PATCH 4u
#define BOSS_MOTION_DONE 8u
typedef struct {uint8_t variant,frame,y,timer,cursor,phase,stage,stage_timer,patch,active;} BossMotion;
uint8_t boss_motion_begin(BossMotion *,uint8_t enemy,uint8_t target) BATTLE_SCENE_BANKED;
uint8_t boss_motion_tick(BossMotion *) BATTLE_SCENE_BANKED;
uint16_t boss_motion_asset(uint8_t enemy,uint8_t frame,uint8_t y) BATTLE_SCENE_BANKED;
#endif
