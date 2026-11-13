#ifndef PS_VEHICLE_CYCLE_H
#define PS_VEHICLE_CYCLE_H
#include "rpg.h"
/* Original C30F/C310 persist through map loads, boarding and battery saves. */
typedef struct {uint8_t phase,clock;} VehicleCycle;
extern VehicleCycle vehicle_cycle;
uint8_t vehicle_cycle_step(VehicleCycle *,uint8_t mode,uint8_t remaining) RPG_BANKED;
void vehicle_cycle_world_tick(uint8_t mode,uint8_t remaining) RPG_BANKED;
#endif
