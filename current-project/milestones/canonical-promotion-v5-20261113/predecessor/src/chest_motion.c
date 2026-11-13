#ifdef __SDCC
#pragma bank 31
#endif
#include "chest_motion.h"
void chest_motion_begin(ChestMotion *m,uint8_t visual) BATTLE_SCENE_BANKED {
    m->frame=0x3a;m->timer=7;m->visual=visual;m->phase=0;m->active=1;m->hold=0;m->deferred=0;
}
uint8_t chest_motion_tick(ChestMotion *m) BATTLE_SCENE_BANKED {
    if(!m->active)return 0;
    if(m->hold){if(--m->hold)return 0;m->frame=m->deferred;return CHEST_MOTION_FRAME;}
    if(m->phase==3u){m->active=0;return CHEST_MOTION_DONE;}
    if(m->timer){--m->timer;return 0;}
    if(!m->phase){++m->frame;m->timer=7;if(m->frame==0x3du){m->phase=1;m->timer=23;}return CHEST_MOTION_FRAME;}
    m->timer=3;
    if(m->phase==1u){m->frame=m->visual;m->phase=m->visual==0x3du?3u:2u;return CHEST_MOTION_FRAME|(m->phase==2u?CHEST_MOTION_SOUND:0u);}
    if((m->visual==0x3eu&&m->frame==0x41u)||(m->visual==0x43u&&m->frame==0x46u)){
        m->hold=10;m->deferred=m->visual==0x3eu?0x42u:0x3du;
        if(m->visual==0x43u)m->phase=3;return CHEST_MOTION_FLASH;
    }
    ++m->frame;if(m->frame==0x43u){m->frame=0x3d;m->phase=3;}return CHEST_MOTION_FRAME;
}
