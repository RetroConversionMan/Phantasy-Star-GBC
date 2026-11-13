#ifndef PS_SAVE_H
#define PS_SAVE_H
#include "rpg.h"
#define SAVE_VERSION 5u
#define SAVE_BYTES 628u
/* Explicit little-endian format; never serialize a compiler struct. */
typedef struct {
    uint8_t map, facing;
    uint16_t x, y;
    RPGState rpg;
    uint8_t flags[256];
    uint8_t secrets_requests;
    uint8_t last_church;
    uint8_t object_flags[256];
    /* Source saves C300..C6FF, not CB00: floor layout/open doors reload. */
    uint8_t dungeon_active,dungeon_floor,dungeon_position,dungeon_direction,dungeon_light;
    uint8_t vehicle;
    uint8_t vehicle_phase,vehicle_clock; /* Source persistent C30F/C310. */
} GameSave;
uint8_t save_encode(uint8_t *out, const GameSave *game) RPG_BANKED;
uint8_t save_decode(GameSave *game, const uint8_t *data) RPG_BANKED;
#endif
