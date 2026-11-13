#include "cutscene.h"
#include "dialogue.h"
#include "events.h"
#include "story_text_ids.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static RPGState r;static EventState e;static CutsceneState s;static DialogueCursor d;
static char lower[2][19];static unsigned checks;
#define CHECK(x) do{assert(x);++checks;}while(0)
int main(void){
 static const uint8_t portrait[5]={3,4,3,4,3};
 static const uint16_t text[5]={STORY_TEXT_B617,STORY_TEXT_B646,STORY_TEXT_B64D,STORY_TEXT_B66E,STORY_TEXT_B6C1};
 const CutsceneAction *c;const EventAction *a;unsigned i,pages=0;
 rpg_new_game(&r);event_init(&e,&r);
 c=cutscene_begin(&s,CUTSCENE_MYAU,&r);
 for(i=0;i<5;i++){CHECK(c->kind==CUTSCENE_TEXT && c->portrait==portrait[i] && c->dialogue_id==text[i]);c=cutscene_advance(&s);}
 CHECK(c->kind==CUTSCENE_DONE);
 c=cutscene_begin(&s,CUTSCENE_NOAH,&r);CHECK(c->portrait==3);r.party[0].status=0;r.party[2].status=1;
 c=cutscene_begin(&s,CUTSCENE_NOAH,&r);CHECK(c->portrait==5);r.party[2].status=0;
 c=cutscene_begin(&s,CUTSCENE_NOAH,&r);CHECK(c->portrait==4);c=cutscene_advance(&s);CHECK(c->portrait==6 && c->dialogue_id==STORY_TEXT_B884);
 for(i=0;i<dialogue_ref_count;i++)if(dialogue_refs[i].id>=0xc000u){
  CHECK(dialogue_open(&d,dialogue_refs[i].id));
  while(dialogue_next_story_page(&d,lower)){CHECK(strlen(d.lines[0])==18 && strlen(d.lines[1])==18 && strlen(lower[0])==18 && strlen(lower[1])==18);pages++;}
  CHECK(d.done && d.terminator==dialogue_refs[i].terminator);
 }
 CHECK(dialogue_open(&d,STORY_TEXT_B617));CHECK(dialogue_next_story_page(&d,lower));
 CHECK(!strncmp(d.lines[0],"WE WILL BE FELLOW",16));CHECK(!strncmp(d.lines[1],"TRAVELERS.",10));
 CHECK(!strncmp(lower[0],"I'M ALIS; WHAT'S",15));CHECK(!strncmp(lower[1],"YOUR NAME?",10));
 CHECK(dialogue_open(&d,STORY_TEXT_B66E));CHECK(dialogue_next_story_page(&d,lower));CHECK(!d.done);
 CHECK(dialogue_next_story_page(&d,lower));CHECK(d.done && !strncmp(d.lines[0],"O.K., BUT I CANNOT",17));CHECK(!strncmp(lower[0],"                  ",18));
 rpg_new_game(&r);event_init(&e,&r);rpg_add_item(&r,ItemID_LaconiaPot);
 event_begin(&e,16,54,18,14);event_respond(&e,0);event_respond(&e,1);a=event_advance(&e);
 CHECK(a->kind==EVENT_CUTSCENE && a->target==CUTSCENE_MYAU && r.joined_mask==3 && r.inventory[0]==ItemID_Alsulin);
 a=event_advance(&e);CHECK(a->kind==EVENT_DONE);
 event_begin(&e,0,163,58,4);a=event_use_story_item(&e,0,0);event_advance(&e);a=event_advance(&e);
 CHECK(a->kind==EVENT_CUTSCENE && a->target==CUTSCENE_ODIN && (r.joined_mask&4u));
 rpg_add_item(&r,ItemID_Letter);event_begin(&e,15,126,0,14);a=event_advance(&e);
 CHECK(a->kind==EVENT_CUTSCENE && a->target==CUTSCENE_NOAH && (r.joined_mask&8u));
 printf("{\"checks\":%u,\"narrative_pages\":%u,\"passed\":true}\n",checks,pages);return 0;
}
