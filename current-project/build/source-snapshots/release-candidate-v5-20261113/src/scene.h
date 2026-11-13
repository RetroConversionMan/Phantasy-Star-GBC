#ifndef PS_SCENE_H
#define PS_SCENE_H
#include <stdint.h>
/* Original scene-table backgrounds and actual world NPC combinations.
 * LCD must be off. Preserves OBJ pattern memory, BG bank1 font tiles0..63,
 * and font palette7. Draws20x15 BG cells; caller owns dialogue/window state.
 * Returns0 without changing VRAM for an unsupported tuple (including type0
 * dynamic dungeon overlays and special FF-transition dungeon rooms).
 * Set portrait/enemy to0 when a scene action clears the original visual list.
 * A nonzero enemy selects its original initial pose, never a generic NPC. */
uint8_t scene_show(uint8_t type,uint8_t portrait,uint8_t prepared_enemy) __banked;
/* LABEL_68EC FF-transition bank9 room; palette_index is DungeonState.palette_index.
 * The original Interaction_Type is15, but this is NOT scene-table background15. */
uint8_t scene_show_room(uint8_t palette_index,uint8_t portrait,uint8_t prepared_enemy) __banked;
/* Source7BEE palette effect: bits1=indices3..15,2=index16,4=indices19..31.
 * white0 restores original colors. LCD may be on; UI palette7 is preserved. */
void scene_palette_flash(uint8_t effect,uint8_t white) __banked;
/* Shared atomic palette staging. Fill all28 BG colors and32 OBJ colors before
 * committing; this waits for VBlank when LCD is on, preserves BG palette7,
 * and writes both sets in one short transfer. Scratch is main-thread owned. */
extern uint16_t scene_palette_background[32],scene_shared_colors[32];
void scene_palette_commit(void) __banked;
void scene_palette_capture(void) __banked;
/* Stage only active-scene BG colors using the source-index flash mask. */
void scene_palette_prepare(uint8_t effect,uint8_t white) __banked;
/* Source-scaled OBJ actors over the existing dungeon background. LCD off for
 * show; static initial poses only. Supported enemy IDs8,22,27,43,46,49,62,71.
 * Active overlays occupy OAM0..39, OBJ bank1 tiles84+, and all OBJ palettes.
 * Hide clears OAM and restores original Alis palettes before world rendering. */
extern uint8_t scene_actor_active;
uint8_t scene_portrait_show(uint8_t portrait) __banked;
uint8_t scene_enemy_show(uint8_t enemy,uint8_t palette_index) __banked;
void scene_actor_hide(void) __banked;
/* Shared original actor format: tiles*16 bytes, sprites*4 (x,y,tile,attr),
 * then64 little-endian OBJ palette bytes. Used by the original chest actor. */
uint8_t scene_actor_show_data(uint8_t bank,const uint8_t *data,uint8_t tiles,uint8_t sprites) __banked;
#endif
