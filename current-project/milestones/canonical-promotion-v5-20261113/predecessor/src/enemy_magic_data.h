#ifndef PS_ENEMY_MAGIC_DATA_H
#define PS_ENEMY_MAGIC_DATA_H
#include "battle_animation_data.h"
#define ENEMY_MAGIC_BANK 252u
#define ENEMY_MAGIC_ASSETS 100u
#define ENEMY_MAGIC_POSES 4u
extern const uint8_t enemy_magic_enemies[7],enemy_magic_kinds[7],enemy_magic_effects[2][4];
extern const BattleAnimation enemy_magic_animations[7];
extern const uint8_t enemy_magic_pose_keys[ENEMY_MAGIC_POSES][2];
extern const uint16_t enemy_magic_pose_lookup[ENEMY_MAGIC_POSES][12],enemy_magic_effect_lookup[7][8];
extern const BattleSceneAsset enemy_magic_assets[ENEMY_MAGIC_ASSETS];
extern const BattleScenePool enemy_magic_pools[1];
#endif
