#ifdef __SDCC
#pragma bank 31
#endif
#include "battle_motion.h"
#include "battle_animation_data.h"
#include "bank_io.h"
#include "enemy_magic.h"
uint8_t battle_motion_begin(BattleMotion *m,uint8_t enemy) BATTLE_SCENE_BANKED {
    const BattleAnimation *a;
    m->active=0;
    if(!enemy||enemy>74u)return 0;
    a=battle_animations+enemy-1u;if(!a->length)return 0;
    m->enemy=enemy;m->frame=a->first_frame;m->timer=a->speed;m->cursor=1;m->phase=0;m->active=1;return 1;
}
uint8_t battle_motion_begin_magic(BattleMotion *m,uint8_t enemy) BATTLE_SCENE_BANKED {
    BattleAnimation a;m->active=0;if(!enemy_magic_animation(enemy,&a))return 0;
    m->enemy=enemy|128u;m->frame=a.first_frame;m->timer=a.speed;m->cursor=1;m->phase=0;m->active=1;return 1;
}
uint8_t battle_motion_tick(BattleMotion *m) BATTLE_SCENE_BANKED {
    BattleAnimation local;const BattleAnimation *a;uint8_t frame;
    if(!m->active)return 0;
    if(m->phase==2u){m->active=0;return BATTLE_MOTION_DONE;}
    if(m->timer){--m->timer;return 0;}
    if(m->enemy&128u){enemy_magic_animation(m->enemy&127u,&local);a=&local;}
    else a=battle_animations+m->enemy-1u;
    m->timer=a->speed;
    frame=bank_read8(a->bank,a->data+m->cursor++);
    if(frame){m->frame=frame;return BATTLE_MOTION_FRAME;}
    if(!m->phase){m->phase=1;return BATTLE_MOTION_IMPACT;}
    m->frame=bank_read8(a->bank,a->data);m->cursor=1;m->phase=2;return BATTLE_MOTION_FRAME;
}
uint16_t battle_motion_asset(uint8_t enemy,uint8_t frame,uint8_t palette) BATTLE_SCENE_BANKED {
    const BattleAnimation *a;const uint8_t *p;uint8_t i,lo,hi;
    if(!enemy||enemy>74u||palette>11u)return 65535u;
    a=battle_animations+enemy-1u;p=a->data+a->length;
    for(i=0;i<a->frames;++i,p+=25u)if(bank_read8(a->bank,p)==frame){
        p+=1u+(uint16_t)palette*2u;lo=bank_read8(a->bank,p);hi=bank_read8(a->bank,p+1u);return lo|((uint16_t)hi<<8);
    }
    return 65535u;
}
