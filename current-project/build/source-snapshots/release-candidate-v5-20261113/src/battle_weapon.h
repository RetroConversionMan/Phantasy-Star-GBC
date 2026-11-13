#ifndef PS_BATTLE_WEAPON_H
#define PS_BATTLE_WEAPON_H
#include "battle_scene.h"
#define WEAPON_MOTION_FRAME 1u
#define WEAPON_MOTION_SOUND 2u
#define WEAPON_MOTION_CLEAR 4u
#define WEAPON_MOTION_DONE 8u
typedef struct {uint8_t effect,frame,timer,speed,end,phase,active;} WeaponMotion;
uint8_t battle_weapon_begin(WeaponMotion *,uint8_t effect) BATTLE_SCENE_BANKED;
uint8_t battle_weapon_tick(WeaponMotion *) BATTLE_SCENE_BANKED;
uint8_t battle_weapon_sound(uint8_t effect) BATTLE_SCENE_BANKED;
uint16_t battle_weapon_asset(uint8_t enemy,uint8_t frame) BATTLE_SCENE_BANKED;
#endif
