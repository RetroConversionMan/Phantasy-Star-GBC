#ifndef PS_VEHICLE_ART_H
#define PS_VEHICLE_ART_H
#include <stdint.h>
/* LCD off when loading. Valid modes4/8/12, native facing0down1up2left3right.
 * Shared actor VRAM bank1 tiles84..115,OAM0..31,allOBJ palettes. Separate static/cycling source-index layers.
 * scene_actor_active remains0: this is the world player, not a dialogue actor.
 * Reload after facing change or battle/scene ownership; scene_actor_hide
 * explicitly clears the vehicle and restores Alis palettes on dismount. */
uint8_t vehicle_sprite_load(uint8_t mode,uint8_t facing) __banked;
/* Draw original32x32 footprint at(screen centre/feetX-24,Y-32). */
void vehicle_sprite_draw(uint8_t x,uint8_t y) __banked;
/* Full source map palette reload resets displayed colors, not C30F/C310. */
void vehicle_palette_reset(void) __banked;
void vehicle_palette_cycle(uint8_t mode,uint8_t phase) __banked;
#endif
