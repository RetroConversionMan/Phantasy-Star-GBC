#ifndef PS_ENEMY_MAGIC_H
#define PS_ENEMY_MAGIC_H
#include "battle_animation_data.h"
#include "battle_scene.h"
#define ENEMY_MAGIC_FRAME 1u
#define ENEMY_MAGIC_SOUND 2u
#define ENEMY_MAGIC_IMPACT 4u
/* Original actor17/18. Final IMPACT clears the actor and hands the source
 * flash/blocked sound to its caller; no invented final-frame hold. */
typedef struct {uint8_t kind,frame,timer,speed,end,phase,active;} EnemyMagicEffect;
uint8_t enemy_magic_animation(uint8_t enemy,BattleAnimation *result) BATTLE_SCENE_BANKED;
uint8_t enemy_magic_begin(EnemyMagicEffect *,uint8_t enemy) BATTLE_SCENE_BANKED;
uint8_t enemy_magic_tick(EnemyMagicEffect *) BATTLE_SCENE_BANKED;
uint8_t enemy_magic_sound(const EnemyMagicEffect *) BATTLE_SCENE_BANKED;
uint16_t enemy_magic_pose(uint8_t enemy,uint8_t frame,uint8_t palette) BATTLE_SCENE_BANKED;
uint16_t enemy_magic_asset(uint8_t enemy,uint8_t frame) BATTLE_SCENE_BANKED;
#endif
