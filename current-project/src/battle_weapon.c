#ifdef __SDCC
#pragma bank 31
#endif
#include "battle_weapon.h"
#include "weapon_data.h"
#include "bank_io.h"
uint8_t battle_weapon_begin(WeaponMotion *m,uint8_t effect) BATTLE_SCENE_BANKED {
    uint8_t row[4];m->active=0;if(effect>18u)return 0;
    bank_copy(row,WEAPON_DATA_BANK,weapon_effects[effect],4u);
    m->effect=effect;m->frame=row[2];m->timer=0;m->speed=row[1];m->end=row[3];m->phase=0;m->active=1;return 1;
}
uint8_t battle_weapon_tick(WeaponMotion *m) BATTLE_SCENE_BANKED {
    if(!m->active)return 0;
    /* Actor11 clears its timer and returns0, so its initial frame is hidden.
     * Actor12 then increments the frame before its first visible upload. */
    if(!m->phase){m->phase=1;return WEAPON_MOTION_SOUND;}
    if(m->phase==2u){m->active=0;return WEAPON_MOTION_DONE;}
    if(m->timer){--m->timer;return 0;}
    m->timer=m->speed;
    if(m->frame+1u>=m->end){m->phase=2;return WEAPON_MOTION_CLEAR;}
    ++m->frame;return WEAPON_MOTION_FRAME;
}
uint8_t battle_weapon_sound(uint8_t effect) BATTLE_SCENE_BANKED {
    uint8_t value=0;if(effect<19u)bank_copy(&value,WEAPON_DATA_BANK,weapon_effects[effect],1u);return value;
}
uint16_t battle_weapon_asset(uint8_t enemy,uint8_t frame) BATTLE_SCENE_BANKED {
    uint8_t group,index,value[2];
    if(!enemy||enemy>74u)return 65535u;
    bank_copy(&group,WEAPON_DATA_BANK,weapon_enemy_groups+enemy-1u,1u);
    bank_copy(&index,WEAPON_DATA_BANK,weapon_frame_indices+frame,1u);
    if(index==255u)return 65535u;
    bank_copy(value,WEAPON_DATA_BANK,&weapon_lookup[group][index],2u);
    return value[0]|((uint16_t)value[1]<<8);
}
