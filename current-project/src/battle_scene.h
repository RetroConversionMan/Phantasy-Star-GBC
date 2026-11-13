#ifndef PS_BATTLE_SCENE_H
#define PS_BATTLE_SCENE_H
#include <stdint.h>
#ifdef __SDCC
#define BATTLE_SCENE_BANKED __banked
#else
#define BATTLE_SCENE_BANKED
#endif
/* Exact GameMode_LoadInteraction terrain-nibble remapping. */
uint8_t battle_scene_world_type(uint8_t group,uint8_t flags) BATTLE_SCENE_BANKED;
/* 0 keeps the already rendered standing dungeon;1..32 original scene table;
 *64..75 original FF rooms. palette_index supplies floor-specific C250 color.
 * Configure before each encounter; does not modify display or persistent state. */
void battle_scene_configure(uint8_t type,uint8_t palette_index) BATTLE_SCENE_BANKED;
/* Begin/clear require LCD off. begin renders static original first pose.
 * Ordinary actors are8x16OBJ over the existing background. Original boss
 * composites use BG; clear restores their original empty background. */
uint8_t battle_scene_begin(uint8_t enemy) BATTLE_SCENE_BANKED;
void battle_scene_clear(void) BATTLE_SCENE_BANKED;
/* Clips native actors at the window top; zero hides actors for full menus.
 * LCD may be on. Original pair patterns reload when the window changes. */
void battle_scene_clip(uint8_t window_y) BATTLE_SCENE_BANKED;
void battle_scene_hide(void) BATTLE_SCENE_BANKED;
/* One decoded original ordinary-enemy animation pose; LCD may be on. */
uint8_t battle_scene_animation_frame(uint8_t frame) BATTLE_SCENE_BANKED;
/* Source10-VBlank palette flashes: callers supply alternating white phases.
 * Enemy hit changes SMS19..31. Party hit changes3..15; extra includes16 for
 * enemies70/73/74. Original colors restore on white0; UI palette7 preserved. */
void battle_scene_flash_enemy(uint8_t white) BATTLE_SCENE_BANKED;
void battle_scene_flash_party(uint8_t white,uint8_t extra) BATTLE_SCENE_BANKED;
/* Weapon/effect frames retain original source anchors and sprite priority.
 * Enemy palettes0..5, effects6..7; clear restores current enemy OAM/palettes. */
uint8_t battle_scene_weapon_frame(uint8_t frame) BATTLE_SCENE_BANKED;
void battle_scene_weapon_clear(void) BATTLE_SCENE_BANKED;
uint8_t battle_scene_magic_frame(uint8_t frame) BATTLE_SCENE_BANKED;
uint8_t battle_scene_boss_frame(uint8_t frame,uint8_t y) BATTLE_SCENE_BANKED;
void battle_scene_boss_patch(uint8_t patch) BATTLE_SCENE_BANKED;
extern uint8_t battle_scene_type,battle_scene_palette,battle_scene_enemy;
#endif
