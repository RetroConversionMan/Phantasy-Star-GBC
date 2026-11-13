/* Dungeon traversal kernel. Rendering and object effects are separate systems. */
#ifndef PS_DUNGEON_H
#define PS_DUNGEON_H
#include <stdint.h>
#include "dungeon_data.h"
#ifdef __SDCC
#define DUNGEON_BANKED __banked
#else
#define DUNGEON_BANKED
#endif
#define DUNGEON_CMD_NONE 0u
#define DUNGEON_CMD_FORWARD 1u
#define DUNGEON_CMD_BACK 2u
#define DUNGEON_CMD_LEFT 3u
#define DUNGEON_CMD_RIGHT 4u
#define DUNGEON_CMD_ACTION 5u
#define DUNGEON_NONE 0u
#define DUNGEON_MOVED 1u
#define DUNGEON_TURNED 2u
#define DUNGEON_OPENED 3u
#define DUNGEON_CHANGED_FLOOR 4u
#define DUNGEON_FELL 5u
#define DUNGEON_MAP 8u
#define DUNGEON_INTERACTION 12u
#define DUNGEON_EXIT_SAVED 13u
#define DUNGEON_MENU 14u
#define DUNGEON_INVALID 255u
typedef struct {
    uint8_t floor,position,direction,light;
    uint8_t encounter_rate,encounter_pool,palette_index,music;
    uint8_t layout[256];
} DungeonState;
typedef struct {
    uint8_t mode,target,a,b,interaction,step_count,positions[2];
} DungeonAction;
typedef struct {
    uint16_t flag_address;
    uint8_t type,a,b,position,view;
} DungeonObject;
uint8_t dungeon_enter(DungeonState *state,uint8_t floor,uint8_t position,uint8_t direction) DUNGEON_BANKED;
/* Reloading a floor clears opened-door runtime bits, as in LABEL_6D56. */
uint8_t dungeon_load_floor(DungeonState *state,uint8_t floor) DUNGEON_BANKED;
void dungeon_refresh_light(DungeonState *state) DUNGEON_BANKED;
uint8_t dungeon_sample(const DungeonState *state,uint8_t view) DUNGEON_BANKED;
uint8_t dungeon_sample_position(const DungeonState *state,uint8_t view) DUNGEON_BANKED;
/* Outputs exact movement checkpoints for two-cell movement, leaving object,
 * battle and encounter effects for the caller. Does not implement animations. */
uint8_t dungeon_step(DungeonState *state,uint8_t command,DungeonAction *action) DUNGEON_BANKED;
uint8_t dungeon_transition(const DungeonState *state,DungeonAction *action) DUNGEON_BANKED;
/* Raw, unsuppressed object record, only when the sampled cell is type08. */
uint8_t dungeon_find_object(const DungeonState *state,uint8_t view,DungeonObject *object) DUNGEON_BANKED;
/* Zero means absent/suppressed. Only FF suppresses a flag, not other nonzero values. */
uint8_t dungeon_active_object(const DungeonState *state,uint8_t view,
    const uint8_t *story_flags,const uint8_t *object_flags,DungeonObject *object) DUNGEON_BANKED;
#endif
