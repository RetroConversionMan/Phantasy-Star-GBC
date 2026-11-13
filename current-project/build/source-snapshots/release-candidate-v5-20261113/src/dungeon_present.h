#ifndef PS_DUNGEON_PRESENT_H
#define PS_DUNGEON_PRESENT_H
#include "dungeon.h"
#ifdef PS_DUNGEON_MOTION
/* Synchronous source presentation; callers keep geometry/callback ownership. */
void dungeon_present_prepare(const DungeonState *) DUNGEON_BANKED;
void dungeon_present_frame(const DungeonState *,uint8_t) DUNGEON_BANKED;
void dungeon_present_sequence(const DungeonState *,uint8_t) DUNGEON_BANKED;
void dungeon_present_turn(const DungeonState *,uint8_t) DUNGEON_BANKED;
void dungeon_present_door(const DungeonState *,uint8_t) DUNGEON_BANKED;
void dungeon_present_transition(const DungeonState *,uint8_t) DUNGEON_BANKED;
void dungeon_present_fall(const DungeonState *) DUNGEON_BANKED;
/* Preserve a precomposed room instead of restoring a cached dungeon image. */
void dungeon_present_scene_fall(const DungeonState *) DUNGEON_BANKED;
#else
#define dungeon_present_prepare(s) ((void)(s))
#define dungeon_present_frame(s,f) ((void)(s),(void)(f))
#define dungeon_present_sequence(s,q) ((void)(s),(void)(q))
#define dungeon_present_turn(s,r) ((void)(s),(void)(r))
#define dungeon_present_door(s,d) ((void)(s),(void)(d))
#define dungeon_present_transition(s,t) ((void)(s),(void)(t))
#define dungeon_present_fall(s) ((void)(s))
#define dungeon_present_scene_fall(s) ((void)(s))
#endif
#endif
