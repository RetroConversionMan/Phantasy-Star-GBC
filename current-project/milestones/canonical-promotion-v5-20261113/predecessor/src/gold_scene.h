#ifndef PS_GOLD_SCENE_H
#define PS_GOLD_SCENE_H
#include "battle_scene.h"
/* Source4497 phases:0 all high16 blue,1 shadow low8 restored,2 enemy loaded.
 * Phase1 is an internal source buffer state; it is not an added visible wait. */
void gold_scene_show(uint8_t phase) BATTLE_SCENE_BANKED;
void gold_scene_prepare(uint8_t phase,uint8_t effect,uint8_t white) BATTLE_SCENE_BANKED;
void gold_scene_blue(void) BATTLE_SCENE_BANKED;
#endif
