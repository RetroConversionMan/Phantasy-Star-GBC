#ifndef PS_BOSS_EFFECTS_DATA_H
#define PS_BOSS_EFFECTS_DATA_H
#include "battle_animation_data.h"
#define BOSS_DATA_BANK 254u
#define BOSS_POSES 39u
#define BOSS_PATCH_CELLS 10u
extern const uint8_t boss_pose_keys[BOSS_POSES][3],boss_patch_cells[BOSS_PATCH_CELLS];
extern const uint16_t boss_pose_lookup[BOSS_POSES];
extern const BattleAnimation boss_animations[5];
extern const BattleSceneAsset boss_assets[39];
extern const BattleScenePool boss_pools[1];
extern const uint8_t *const boss_patches[3];
#endif
