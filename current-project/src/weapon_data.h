#ifndef PS_WEAPON_DATA_H
#define PS_WEAPON_DATA_H
#include "battle_scene_data.h"
#define WEAPON_DATA_BANK 182u
#define WEAPON_FRAMES 79u
#define WEAPON_ASSETS 1561u
#define WEAPON_POOL_SHIFT 7u
extern const uint8_t weapon_effects[19][4],weapon_frame_indices[256],weapon_enemy_groups[74];
extern const uint16_t weapon_lookup[22][WEAPON_FRAMES];
extern const BattleSceneAsset weapon_assets[WEAPON_ASSETS];
extern const BattleScenePool weapon_pools[30];
#endif
