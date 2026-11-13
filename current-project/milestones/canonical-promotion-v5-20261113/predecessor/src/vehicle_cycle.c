#ifdef __SDCC
#pragma bank 118
#endif
#include "vehicle_cycle.h"
VehicleCycle vehicle_cycle;
uint8_t vehicle_cycle_step(VehicleCycle *s,uint8_t mode,uint8_t remaining) RPG_BANKED {
    if(!mode||mode>=14u)return 0;
    if(mode!=8u&&!remaining)return 0;
    --s->clock;if(!(s->clock&128u))return 0;
    s->clock=3;if(++s->phase>=3u)s->phase=0;
    return mode==8u?0xd1u:0xd0u;
}
#ifdef __SDCC
#include "vehicle_art.h"
#include "audio.h"
void vehicle_cycle_world_tick(uint8_t mode,uint8_t remaining) RPG_BANKED {
    uint8_t command=vehicle_cycle_step(&vehicle_cycle,mode,remaining);
    if(command) {
        audio_command_before_tick(command);
        vehicle_palette_cycle(mode,vehicle_cycle.phase);
    }
}
#endif
