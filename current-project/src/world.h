/* Native world renderer and source-gated transition decoder. */
#ifndef PS_WORLD_H
#define PS_WORLD_H
#include <stdint.h>
#include "world_assets.h"
#ifdef __SDCC
#define WORLD_BANKED __banked
#else
#define WORLD_BANKED
#endif
#define WORLD_PIXEL_WIDTH 2048u
#define WORLD_PIXEL_HEIGHT 1536u
#define WORLD_TILE_WIDTH 256u
#define WORLD_TILE_HEIGHT 192u
#define WORLD_START_MAP 4u
#define WORLD_START_X 1688u
#define WORLD_START_Y 304u
#define WORLD_ACTION_NONE 0u
#define WORLD_ACTION_MAP 8u
#define WORLD_ACTION_DUNGEON 10u
#define WORLD_ACTION_INTERACTION 12u
/* A source special tile requiring the event/terrain system, NOT a generic event. */
#define WORLD_ACTION_SPECIAL 128u
typedef struct {
    uint8_t mode, target, a, b, metatile, flags;
} WorldAction;
extern uint8_t world_map_id, world_group_id;
extern uint8_t world_ice_changed;
uint8_t world_select(uint8_t map_id) WORLD_BANKED;
void world_load_graphics(void) WORLD_BANKED;
void world_draw(uint16_t camera_x, uint16_t camera_y, uint8_t force) WORLD_BANKED;
void world_tile_at(uint16_t tile_x, uint16_t tile_y, uint8_t *tile, uint8_t *attribute) WORLD_BANKED;
uint8_t world_meta_at(uint16_t pixel_x, uint16_t pixel_y) WORLD_BANKED;
uint8_t world_flags_at(uint16_t pixel_x, uint16_t pixel_y) WORLD_BANKED;
uint8_t world_can_stand(uint16_t x, uint16_t y) WORLD_BANKED;
/* Source LABEL_74E4: call at grid-aligned centre/feet coordinates before a step.
 * Native facing 0=down,1=up,2=left,3=right. IceDigger clears both leading
 * D8..DF cells before checking their replacementD7 collision, even if blocked. */
uint8_t world_step_allowed(uint16_t x, uint16_t y, uint8_t facing, uint8_t vehicle) WORLD_BANKED;
/* Source7656/76C1/7732 and22B7. Requested4/8/12; returns0 blocked,1 entered,
 * 2 exited. Entry needs source interaction nonzero, group<4, Ice only group2.
 * Same-vehicle exit deliberately bypasses those gates. Updates native coords.
 * A success requires caller full map reload and vehicle footprint setup. */
uint8_t world_vehicle_use(uint16_t *x,uint16_t *y,uint8_t facing,uint8_t interaction,
    uint8_t requested,uint8_t *vehicle) WORLD_BANKED;
/* Source723D reloads all four chunks on a camera-origin chunk change, losing
 * their temporary ice modifications. Call after position changes, before draw. */
void world_terrain_sync(uint16_t x,uint16_t y) WORLD_BANKED;
/* Source7602: after full map reload, clear ice under the four vehicle cells.
 * Both this and step_allowed reset/update world_ice_changed for soundB7. */
void world_vehicle_footprint(uint16_t x,uint16_t y,uint8_t vehicle) WORLD_BANKED;
/* Call after a completed grid step; caller suppresses repeats until next step.
 * Unknown story specials return SPECIAL, preserving source metatile/flags. */
uint8_t world_check_trigger(uint16_t x, uint16_t y, uint8_t vehicle, WorldAction *action) WORLD_BANKED;
uint8_t world_decode_y(uint8_t packed) WORLD_BANKED;
void world_decode_destination(const WorldAction *action, uint16_t *x, uint16_t *y) WORLD_BANKED;
/* Endpoint decode only. Original road movement/scene animation is separate. */
uint8_t world_road_destination(uint8_t index, WorldAction *action) WORLD_BANKED;
#endif
