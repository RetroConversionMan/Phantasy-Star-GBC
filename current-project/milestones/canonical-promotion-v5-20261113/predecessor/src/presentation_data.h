#ifndef PS_PRESENTATION_DATA_H
#define PS_PRESENTATION_DATA_H
#include <stdint.h>
typedef struct {uint8_t bank;uint16_t tiles;uint8_t sprites,palettes;const uint8_t *data;} PresentationAsset;
extern const PresentationAsset presentation_assets[4];
#endif
