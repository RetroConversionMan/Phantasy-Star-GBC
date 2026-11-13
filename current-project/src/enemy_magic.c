#ifdef __SDCC
#pragma bank 31
#endif
#include "enemy_magic.h"
#include "enemy_magic_data.h"
#include "bank_io.h"
static uint8_t index_for(uint8_t enemy){
 uint8_t i;for(i=0;i<7u;++i)if(bank_read8(ENEMY_MAGIC_BANK,enemy_magic_enemies+i)==enemy)return i;return 255u;
}
static uint16_t read_word(const uint16_t *address){uint16_t result;bank_copy(&result,ENEMY_MAGIC_BANK,address,2u);return result;}
uint8_t enemy_magic_animation(uint8_t enemy,BattleAnimation *result) BATTLE_SCENE_BANKED {
 uint8_t i=index_for(enemy);if(i==255u)return 0;bank_copy(result,ENEMY_MAGIC_BANK,enemy_magic_animations+i,sizeof *result);return 1;
}
uint8_t enemy_magic_begin(EnemyMagicEffect *m,uint8_t enemy) BATTLE_SCENE_BANKED {
 uint8_t i=index_for(enemy);m->active=0;if(i==255u)return 0;
 m->kind=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_kinds+i);
 m->speed=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[m->kind]+1u);
 m->frame=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[m->kind]+2u);
 m->end=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[m->kind]+3u);
 m->timer=m->phase=0;m->active=1;return 1;
}
uint8_t enemy_magic_tick(EnemyMagicEffect *m) BATTLE_SCENE_BANKED {
 if(!m->active)return 0;
 if(!m->phase){m->phase=1;return ENEMY_MAGIC_SOUND;}
 if(m->timer){--m->timer;return 0;}
 m->timer=m->speed;
 if(m->frame+1u>=m->end){m->active=0;return ENEMY_MAGIC_IMPACT;}
 ++m->frame;return ENEMY_MAGIC_FRAME;
}
uint8_t enemy_magic_sound(const EnemyMagicEffect *m) BATTLE_SCENE_BANKED {return bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[m->kind]);}
uint16_t enemy_magic_pose(uint8_t enemy,uint8_t frame,uint8_t palette) BATTLE_SCENE_BANKED {
 uint8_t i;if(palette>=12u)return 65535u;
 for(i=0;i<ENEMY_MAGIC_POSES;++i)if(bank_read8(ENEMY_MAGIC_BANK,enemy_magic_pose_keys[i])==enemy&&bank_read8(ENEMY_MAGIC_BANK,enemy_magic_pose_keys[i]+1u)==frame)return read_word(enemy_magic_pose_lookup[i]+palette);
 return 65535u;
}
uint16_t enemy_magic_asset(uint8_t enemy,uint8_t frame) BATTLE_SCENE_BANKED {
 uint8_t i=index_for(enemy),kind,first;if(i==255u)return 65535u;
 kind=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_kinds+i);first=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[kind]+2u)+1u;
 if(frame<first||frame-first>=8u)return 65535u;
 return read_word(enemy_magic_effect_lookup[i]+frame-first);
}
