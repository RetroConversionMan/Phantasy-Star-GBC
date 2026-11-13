#ifdef __SDCC
#pragma bank 12
#endif
#include "cutscene.h"
#include "story_text_ids.h"
static const uint8_t starts[7]={0,0,5,10,12,15,17};
static const uint8_t lengths[7]={0,5,5,2,3,2,6};
static const uint8_t portraits[23]={3,4,3,4,3,5,3,5,3,5,255,6,0,1,2,7,8,3,5,6,4,3,3};
static const uint16_t texts[23]={
 STORY_TEXT_B617,STORY_TEXT_B646,STORY_TEXT_B64D,STORY_TEXT_B66E,STORY_TEXT_B6C1,
 STORY_TEXT_B6F3,STORY_TEXT_B746,STORY_TEXT_B786,STORY_TEXT_B7B9,STORY_TEXT_B7D1,
 STORY_TEXT_B85C,STORY_TEXT_B884,STORY_TEXT_B49B,STORY_TEXT_B4FC,STORY_TEXT_B5D5,
 STORY_TEXT_B929,STORY_TEXT_B97C,STORY_TEXT_B9E8,STORY_TEXT_B9F0,STORY_TEXT_B9FB,
 STORY_TEXT_BA06,STORY_TEXT_BA12,STORY_TEXT_BA54
};
const CutsceneAction *cutscene_advance(CutsceneState *s) RPG_BANKED {
 uint8_t index;
 if(!s->sequence||s->sequence>6u||s->step>=lengths[s->sequence]){
  s->action.kind=CUTSCENE_DONE;s->action.dialogue_id=0;return &s->action;
 }
 index=starts[s->sequence]+s->step++;
 s->action.kind=CUTSCENE_TEXT;s->action.portrait=portraits[index];
 if(s->action.portrait==255u)s->action.portrait=s->first_speaker;
 s->action.dialogue_id=texts[index];return &s->action;
}
const CutsceneAction *cutscene_begin(CutsceneState *s,uint8_t sequence,const RPGState *rpg) RPG_BANKED {
 s->sequence=sequence;s->step=0;
 s->first_speaker=(rpg->party[0].status&1u)?3u:(rpg->party[2].status&1u)?5u:4u;
 return cutscene_advance(s);
}
