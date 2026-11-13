#ifdef __SDCC
#pragma bank 31
#endif
#include <string.h>
#include "boss_motion.h"
#include "boss_effects_data.h"
#include "bank_io.h"
uint8_t boss_motion_begin(BossMotion *m,uint8_t enemy,uint8_t target) BATTLE_SCENE_BANKED {
 BattleAnimation a;memset(m,0,sizeof *m);if((enemy!=72u&&enemy!=73u)||target>3u)return 0;
 m->variant=enemy==72u?target:4u;m->y=enemy==72u?255u:79u;
 bank_copy(&a,BOSS_DATA_BANK,boss_animations+m->variant,sizeof a);
 m->timer=a.speed;m->cursor=1;m->active=1;return 1;
}
uint8_t boss_motion_tick(BossMotion *m) BATTLE_SCENE_BANKED {
 BattleAnimation a;uint8_t frame,flags=0;
 if(!m->active)return 0;
 if(m->stage==5u){m->active=0;return BOSS_MOTION_DONE;}
 if(m->variant==4u&&m->stage!=2u){
  if(m->stage_timer){--m->stage_timer;return 0;}
  m->stage_timer=7;++m->stage;
  m->patch=m->stage==2u?2u:m->stage==5u?0u:1u;return BOSS_MOTION_PATCH;
 }
 if(m->timer){--m->timer;return 0;}
 bank_copy(&a,BOSS_DATA_BANK,boss_animations+m->variant,sizeof a);m->timer=a.speed;
 frame=bank_read8(a.bank,a.data+m->cursor);
 if(frame){++m->cursor;m->frame=frame;flags=BOSS_MOTION_FRAME;}
 else if(!m->phase){m->phase=1;++m->cursor;flags=BOSS_MOTION_IMPACT;}
 else{m->phase=0;m->cursor=1;m->frame=bank_read8(a.bank,a.data);m->stage=m->variant==4u?3u:5u;flags=BOSS_MOTION_FRAME;}
 if(m->variant==4u){if(m->cursor==19u)m->y=71u;if(m->stage==3u)m->y=79u;}
 return flags;
}
uint16_t boss_motion_asset(uint8_t enemy,uint8_t frame,uint8_t y) BATTLE_SCENE_BANKED {
 uint8_t i;uint16_t value;
 for(i=0;i<BOSS_POSES;++i)if(bank_read8(BOSS_DATA_BANK,boss_pose_keys[i])==enemy&&bank_read8(BOSS_DATA_BANK,boss_pose_keys[i]+1u)==frame&&bank_read8(BOSS_DATA_BANK,boss_pose_keys[i]+2u)==y){bank_copy(&value,BOSS_DATA_BANK,boss_pose_lookup+i,2u);return value;}
 return 65535u;
}
