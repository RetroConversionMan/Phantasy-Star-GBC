#ifndef PS_ENEMY_ART_H
#define PS_ENEMY_ART_H
#include <stdint.h>
typedef struct {
    uint8_t bank, tile_count;
    const uint8_t *tiles,*map,*attrs;
    const uint16_t *palettes;
} EnemyArt;
extern const EnemyArt enemy_art[74];
/* Original initial poses adapted to a centered160x112 bitmap. LCD must be off.
 * Static pose only: source animations/background scenes remain separate work. */
uint8_t enemy_art_draw(uint8_t enemy) __banked;
#endif
