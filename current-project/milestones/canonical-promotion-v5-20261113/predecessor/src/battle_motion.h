#ifndef PS_BATTLE_MOTION_H
#define PS_BATTLE_MOTION_H
#include <stdint.h>
#include "battle_scene.h"
#define BATTLE_MOTION_FRAME 1u
#define BATTLE_MOTION_IMPACT 2u
#define BATTLE_MOTION_DONE 4u
/* Native ordinary attack actor state, matching C880 fields. Enemy bit7
 * selects the original alternate magic sequence without enlarging state. */
typedef struct {uint8_t enemy,frame,timer,cursor,phase,active;} BattleMotion;
uint8_t battle_motion_begin(BattleMotion *motion,uint8_t enemy) BATTLE_SCENE_BANKED;
uint8_t battle_motion_begin_magic(BattleMotion *motion,uint8_t enemy) BATTLE_SCENE_BANKED;
/* Exactly one source VBlank/actor update. Final1-frame upload wait included. */
uint8_t battle_motion_tick(BattleMotion *motion) BATTLE_SCENE_BANKED;
uint16_t battle_motion_asset(uint8_t enemy,uint8_t frame,uint8_t palette) BATTLE_SCENE_BANKED;
#endif
