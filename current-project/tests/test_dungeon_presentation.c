#include "dungeon_play.h"
#include "dungeon_present.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
typedef struct {uint8_t kind,value,floor,pos,dir;uint16_t rng;} Pose;
static Pose poses[64];static uint8_t count;static unsigned checks;static RPGState *rng_state;
#define CHECK(x) do{++checks;if(!(x)){fprintf(stderr,"FAIL %d: %s\n",__LINE__,#x);assert(x);}}while(0)
static void record(const DungeonState *s,uint8_t kind,uint8_t value) {
    CHECK(count<64u);poses[count++]=(Pose){kind,value,s->floor,s->position,s->direction,rng_state->rng};
}
void dungeon_present_prepare(const DungeonState *s){(void)s;}
void dungeon_present_frame(const DungeonState *s,uint8_t f){record(s,1,f);}
void dungeon_present_sequence(const DungeonState *s,uint8_t q){record(s,2,q);}
void dungeon_present_turn(const DungeonState *s,uint8_t r){record(s,3,r);}
void dungeon_present_door(const DungeonState *s,uint8_t d){record(s,4,d);}
void dungeon_present_transition(const DungeonState *s,uint8_t stairs){record(s,5,stairs);}
void dungeon_present_fall(const DungeonState *s){record(s,6,0);}
void dungeon_present_scene_fall(const DungeonState *s){record(s,7,0);}
static void setup(DungeonPlay *p,RPGState *r,EventState *e,uint8_t floor,uint8_t pos,uint8_t dir) {
    memset(p,0,sizeof(*p));memset(e,0,sizeof(*e));rpg_new_game(r);rpg_seed_rng(r,1000);rng_state=r;count=0;
    e->rpg=r;CHECK(dungeon_enter(&p->dungeon,floor,pos,dir));p->active=1;
}
static void pose(uint8_t n,uint8_t kind,uint8_t value,uint8_t pos,uint8_t dir,uint16_t rng) {
    CHECK(n<count);CHECK(poses[n].kind==kind&&poses[n].value==value&&poses[n].pos==pos&&poses[n].dir==dir&&poses[n].rng==rng);
}
int main(void) {
    DungeonPlay p;RPGState r;EventState e;uint8_t dir,command,old,dest,i;uint16_t seed;
    for(dir=0;dir<4;++dir)for(command=1;command<5;++command) {
        setup(&p,&r,&e,1,0x88,dir);memset(p.dungeon.layout,0,256);seed=r.rng;old=p.dungeon.position;
        dest=dungeon_sample_position(&p.dungeon,command==2?11u:1u);
        dplay_step(&p,&r,&e,command);
        if(command==1){CHECK(count==2);pose(0,2,0,old,dir,seed);pose(1,1,0,dest,dir,seed);}
        else if(command==2){CHECK(count==1);pose(0,2,1,dest,dir,seed);}
        else {CHECK(count==1);pose(0,3,command==4,old,(dir+(command==3?3u:1u))&3u,seed);}
    }
    setup(&p,&r,&e,1,0x37,0);memset(p.dungeon.layout,0,256);p.dungeon.layout[0x27]=7;p.dungeon.layout[0x17]=8;seed=r.rng;
    CHECK(dplay_step(&p,&r,&e,1)==DPLAY_CHEST&&count==2&&p.check_cursor==1);
    pose(0,2,0,0x37,0,seed);pose(1,1,0,0x27,0,seed);
    dplay_mark_object(&e,p.action.flag_address);p.dungeon.position=0x70;p.dungeon.direction=1;
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_VIEW&&count==4);
    pose(2,2,0,0x70,1,seed);pose(3,1,0,0x71,1,seed);
    setup(&p,&r,&e,42,0x53,0);p.dungeon.layout[0x63]=0;seed=r.rng;
    CHECK(dplay_step(&p,&r,&e,2)==DPLAY_BATTLE&&count==1);pose(0,2,1,0x63,0,seed);
    dplay_mark_object(&e,p.action.flag_address);
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_BATTLE&&count==3);
    pose(1,3,0,0x63,3,seed);pose(2,3,0,0x63,2,seed);
    /* Rear NPC events turn right twice; rear battles turn left twice. */
    for(i=0;i<DUNGEON_OBJECT_COUNT;++i)if(dungeon_objects[i*7u+4u]==3u){
        uint8_t floor=dungeon_objects[i*7u],object=dungeon_objects[i*7u+1u];
        setup(&p,&r,&e,floor,object-16u,0);if(p.dungeon.layout[object]!=8u)continue;
        p.check_count=1;p.positions[0]=p.dungeon.position;p.views[0]=11;seed=r.rng;
        if(dplay_resume(&p,&r,&e)!=DPLAY_EVENT)continue;
        CHECK(count==2);pose(0,3,1,object-16u,1,seed);pose(1,3,1,object-16u,2,seed);break;
    }
    CHECK(i<DUNGEON_OBJECT_COUNT);
    setup(&p,&r,&e,1,0x88,0);memset(p.dungeon.layout,0,256);p.dungeon.layout[0x78]=4;seed=r.rng;
    CHECK(dplay_step(&p,&r,&e,5)==DPLAY_VIEW&&r.rng==seed&&count==1&&p.dungeon.layout[0x78]==132);
    pose(0,4,2,0x88,0,seed);count=0;
    CHECK(dplay_step(&p,&r,&e,1)==DPLAY_VIEW&&r.rng==seed&&count==1);
    pose(0,5,0,0x68,0,seed);
    setup(&p,&r,&e,1,0x88,0);memset(p.dungeon.layout,0,256);p.dungeon.layout[0x78]=2;seed=r.rng;
    dplay_step(&p,&r,&e,1);CHECK(count==1&&poses[0].floor==2);pose(0,5,1,0x68,0,seed);
    setup(&p,&r,&e,3,0x11,0);p.dungeon.layout[0x11]=8;seed=r.rng;
    CHECK(dplay_step(&p,&r,&e,0)==DPLAY_VIEW&&count==1&&poses[0].floor==2);pose(0,6,0,0x11,0,seed);
    for(i=2;i<5;++i){
        setup(&p,&r,&e,1,0x88,0);p.dungeon.layout[0x78]=(i+2u)|128u;seed=r.rng;
        dplay_show_opening(&p,i);CHECK(count==1&&p.dungeon.layout[0x78]==((i+2u)|128u));pose(0,4,i,0x88,0,seed);
    }
    for(i=0;i<2u;++i) {
        setup(&p,&r,&e,1,0x88,3);p.dungeon.light=i?255u:0u;seed=r.rng;
        CHECK(dplay_scene_fall(&p,&r,&e,34,0xe6,0,7)==DPLAY_VIEW);
        CHECK(p.active&&p.dungeon.floor==33&&p.dungeon.light==3&&p.dungeon.palette_index==3);
        CHECK(!p.initial_dark&&!p.encounter_latch&&p.retained_trap==7&&r.rng==seed);
        CHECK(count==1);pose(0,7,0,0xe6,0,seed);
    }
    printf("Dungeon presentation order checks passed: %u\n",checks);return 0;
}
