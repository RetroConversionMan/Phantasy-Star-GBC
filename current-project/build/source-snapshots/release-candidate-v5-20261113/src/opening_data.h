#ifndef PS_OPENING_DATA_H
#define PS_OPENING_DATA_H
#include <stdint.h>
extern const uint8_t opening_pan[];
typedef struct {uint8_t bank;uint16_t tiles;const uint8_t *data;} MovieImage;
extern const MovieImage movie_images[3];
#endif
