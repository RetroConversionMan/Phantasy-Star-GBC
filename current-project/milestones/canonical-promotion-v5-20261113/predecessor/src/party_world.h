#ifndef PS_PARTY_WORLD_H
#define PS_PARTY_WORLD_H
#include "rpg.h"
/* Packed source actors C800..C87F. Runtime rendering cache is separate from
 * RPG state and never saved. No dungeon/scene memory is aliased. */
typedef struct {
    uint8_t identity,x,y,flags,phase,clock,frame,loaded,direction,previous;
} PartyWorldActor;
typedef struct {PartyWorldActor actors[4];uint8_t count,road;} PartyWorld;
extern PartyWorld party_world;
void party_reset(PartyWorld *,const RPGState *,uint8_t road) RPG_BANKED;
/* Original C264 accepted direction, C265 remaining pixel count, held low4. */
void party_step(PartyWorld *,uint8_t accepted,uint8_t remaining,uint8_t held) RPG_BANKED;
void party_world_reset(uint8_t road) RPG_BANKED;
void party_world_tick(uint8_t accepted,uint8_t remaining,uint8_t held) RPG_BANKED;
void party_world_draw(void) RPG_BANKED;
#endif
