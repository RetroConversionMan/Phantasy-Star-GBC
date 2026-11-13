#ifdef __SDCC
#pragma bank 21
#endif
#include "world_motion.h"
#include "world_motion_data.h"
#include "world.h"
#include "bank_io.h"
uint8_t world_motion_countdown[6],world_motion_phase[6],world_motion_road;
void world_motion_reset(uint8_t road) WORLD_MOTION_BANKED {
    uint8_t i;
    world_motion_road=road;
    for(i=0;i<6u;++i)world_motion_countdown[i]=world_motion_phase[i]=0;
}
uint8_t world_motion_step(void) WORLD_MOTION_BANKED {
    uint8_t i,phase;
    const WorldMotionSlot *slot;
    if(world_group_id>=11u)return 255u;
    for(i=0;i<6u;++i) {
        if(world_motion_road ? i!=3u : !world_motion_enables[world_group_id][i])continue;
        /* Z80 DEC / RET P: retain the source's full byte/sign behavior. */
        --world_motion_countdown[i];
        if(!(world_motion_countdown[i]&128u))continue;
        world_motion_countdown[i]=world_motion_road?0u:world_motion_reloads[i];
        if(world_motion_road>=4u)--world_motion_phase[i];
        else ++world_motion_phase[i];
        phase=world_motion_phase[i]&7u;
        if(world_group_id<2u) {
            slot=&world_motion_slots[world_group_id][i];
            if(slot->count)bank_bkg_phase(slot->bank,slot->tile,slot->count,
                slot->frames+(uint16_t)phase*slot->count*16u,slot->vram_bank);
        }
        return i;
    }
    return 255u;
}
