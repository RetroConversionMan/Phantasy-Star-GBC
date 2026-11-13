#ifndef PS_CHEST_MOTION_H
#define PS_CHEST_MOTION_H
#include "battle_scene.h"
#define CHEST_MOTION_FRAME 1u
#define CHEST_MOTION_SOUND 2u
#define CHEST_MOTION_FLASH 4u
#define CHEST_MOTION_DONE 8u
typedef struct {uint8_t frame,timer,visual,phase,active,hold,deferred;} ChestMotion;
void chest_motion_begin(ChestMotion *,uint8_t visual) BATTLE_SCENE_BANKED;
uint8_t chest_motion_tick(ChestMotion *) BATTLE_SCENE_BANKED;
#endif
