#ifndef PS_CUTSCENE_ART_DATA_H
#define PS_CUTSCENE_ART_DATA_H
#include <stdint.h>
typedef struct {uint8_t bank;uint16_t tiles;const uint8_t *data;} CutscenePortrait;
extern const CutscenePortrait cutscene_portraits[9];
#endif
