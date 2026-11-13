#include "dungeon_play.h"
#include "battle.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static unsigned checks;
#define CHECK(x) do{++checks;if(!(x)){fprintf(stderr,"FAIL %d: %s\n",__LINE__,#x);assert(x);}}while(0)
static uint8_t rnd(uint16_t *s) {
    unsigned bit=((*s>>15)^(*s>>13)^(*s>>4)^*s)&1u;
    *s=(uint16_t)((*s<<1)|bit);if(!*s)*s=0x733c;
    return (uint8_t)*s;
}
static void setup(DungeonPlay *p,RPGState *r,EventState *e,uint8_t floor,uint8_t pos,uint8_t dir) {
    memset(p,0,sizeof(*p));memset(e,0,sizeof(*e));rpg_new_game(r);rpg_seed_rng(r,1000);
    e->rpg=r;CHECK(dungeon_enter(&p->dungeon,floor,pos,dir));p->active=1;
}
static void single_check(DungeonPlay *p,uint8_t pos,uint8_t view) {
    p->check_count=1;p->check_cursor=p->advance_second=p->encounter_latch=0;
    p->positions[0]=pos;p->views[0]=view;
}
static void entry_and_dark(void) {
    DungeonPlay p;RPGState r;EventState e;uint16_t seed;
    setup(&p,&r,&e,1,0xd2,0);seed=r.rng;
    CHECK(dplay_enter(&p,&r,&e,1,0xd2,0,137)==DPLAY_VIEW);
    CHECK(p.retained_trap==137&&p.dungeon.light&&r.rng==seed);
    CHECK(dplay_enter(&p,&r,&e,0,0xde,0,137)==DPLAY_DARK);
    CHECK(p.initial_dark==2&&!p.dungeon.light&&p.retained_trap==137);
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_EXIT&&p.initial_dark==0&&r.rng==seed);
    CHECK(dplay_enter(&p,&r,&e,0,0xde,0,137)==DPLAY_DARK);
    p.dungeon.light=1;
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_VIEW&&p.dungeon.light==4);
    CHECK(rpg_add_item(&r,ItemID_MagicLamp)==RPG_OK);
    CHECK(dplay_enter(&p,&r,&e,0,0xde,0,83)==DPLAY_VIEW&&p.dungeon.light==4);
    CHECK(p.retained_trap==83);rpg_remove_item(&r,0);
    /* Initial event callbacks precede the source light check. */
    CHECK(dplay_enter(&p,&r,&e,0,0xf3,0,1)==DPLAY_EVENT);
    CHECK(p.action.target==163&&p.initial_dark==1);
    p.dungeon.light=1;dungeon_refresh_light(&p.dungeon);
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_VIEW&&p.initial_dark==0);
    CHECK(dplay_enter(&p,&r,&e,1,0xc2,0,1)==DPLAY_EVENT);
    p.dungeon.light=0;
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_DARK);
    CHECK(dplay_enter(&p,&r,&e,61,0,0,0)==DPLAY_INVALID&&!p.active);
}
static void every_object(void) {
    unsigned i,j,view,flagvalue;uint8_t row[7],duplicate;uint16_t flag,seed;RPGState r,ref;EventState e;DungeonPlay p;
    const uint8_t values[]={0,1,127,254,255};
    for(i=0;i<DUNGEON_OBJECT_COUNT;++i) {
        memcpy(row,dungeon_objects+i*7u,7);duplicate=0;
        for(j=0;j<i;++j)if(dungeon_objects[j*7]==row[0]&&dungeon_objects[j*7+1]==row[1])duplicate=1;
        if(duplicate)continue;
        setup(&p,&r,&e,row[0],0,0);if(p.dungeon.layout[row[1]]!=8)continue;
        flag=(uint16_t)row[2]|((uint16_t)row[3]<<8);
        for(view=1;view<=11;view+=10)for(flagvalue=0;flagvalue<5;++flagvalue) {
            uint8_t pos=row[1]+(view==1?16u:240u),kind,expected_dir=0;
            setup(&p,&r,&e,row[0],pos,0);p.retained_trap=73;single_check(&p,pos,(uint8_t)view);
            ((flag>>8)==0xc5?e.flags:e.object_flags)[(uint8_t)flag]=values[flagvalue];seed=r.rng;ref=r;
            kind=dplay_resume(&p,&r,&e);
            if(values[flagvalue]==255) {CHECK(kind==DPLAY_VIEW&&r.rng==seed&&p.retained_trap==73);continue;}
            if(view==11&&(row[4]==2||row[4]==3))expected_dir=2;
            CHECK(p.dungeon.direction==expected_dir);
            if(row[4]<2&&view==11) {
                rpg_dungeon_encounter(&ref,row[0],dungeon_sample(&p.dungeon,1));
                CHECK(kind==DPLAY_VIEW&&r.rng==ref.rng);
                CHECK(p.retained_trap==(row[4]==0?row[6]:73));continue;
            }
            CHECK(r.rng==seed&&p.encounter_latch==1&&p.action.flag_address==flag);
            if(row[4]<2) {
                CHECK(kind==DPLAY_CHEST&&p.action.type==row[4]);
                CHECK(p.action.a==(row[4]==0?row[6]:73));
                CHECK(p.action.target==(row[4]==0?row[5]:0));
                CHECK(p.action.money==(row[4]==1?((uint16_t)row[5]|((uint16_t)row[6]<<8)):0));
            } else {
                CHECK(kind==(row[4]==2?DPLAY_BATTLE:DPLAY_EVENT));
                CHECK(p.action.target==row[5]&&p.action.a==row[6]);
                CHECK(p.action.type==(row[4]==2?1:0));
            }
        }
    }
}
static void fakewall_and_backward(void) {
    DungeonPlay p;RPGState r;EventState e;uint16_t expected;
    setup(&p,&r,&e,1,0x37,0);memset(p.dungeon.layout,0,256);
    p.dungeon.layout[0x27]=7;p.dungeon.layout[0x17]=8;expected=r.rng;
    CHECK(dplay_step(&p,&r,&e,DUNGEON_CMD_FORWARD)==DPLAY_CHEST);
    CHECK(p.dungeon.position==0x27&&p.check_cursor==1&&p.check_count==2&&r.rng==expected);
    CHECK(p.action.target==0&&p.action.a==252&&p.retained_trap==252);
    dplay_mark_object(&e,p.action.flag_address);
    /* The paused source call resumes using the callback's position/direction. */
    p.dungeon.position=0x70;p.dungeon.direction=1;rnd(&expected);
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_VIEW);
    CHECK(p.dungeon.position==0x71&&r.rng==expected&&!p.advance_second);
    setup(&p,&r,&e,1,0x37,0);memset(p.dungeon.layout,0,256);p.dungeon.layout[0x27]=7;
    expected=r.rng;rnd(&expected);
    CHECK(dplay_step(&p,&r,&e,DUNGEON_CMD_FORWARD)==DPLAY_VIEW&&p.dungeon.position==0x17);
    CHECK(r.rng==expected);
    /* Source floor42 has fixed enemy44 at53 and73. Backward checks front,
     * then rear; the second battle faces the party around. */
    setup(&p,&r,&e,42,0x53,0);p.dungeon.layout[0x63]=0;expected=r.rng;
    CHECK(dplay_step(&p,&r,&e,DUNGEON_CMD_BACK)==DPLAY_BATTLE);
    CHECK(p.dungeon.position==0x63&&p.dungeon.direction==0&&p.action.flag_address==0xc6d4);
    CHECK(p.action.target==44&&p.action.a==0&&r.rng==expected);
    dplay_mark_object(&e,p.action.flag_address);
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_BATTLE);
    CHECK(p.dungeon.direction==2&&p.action.flag_address==0xc6d5&&p.action.target==44&&r.rng==expected);
    dplay_mark_object(&e,p.action.flag_address);rnd(&expected);
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_VIEW&&r.rng==expected);
}
static void retained_money_trap(void) {
    DungeonPlay p;RPGState r;EventState e;uint16_t expected;
    setup(&p,&r,&e,1,0xf7,0);memset(p.dungeon.layout,0,256);p.dungeon.layout[0x17]=8;
    p.retained_trap=37;expected=r.rng;rnd(&expected);
    CHECK(dplay_step(&p,&r,&e,DUNGEON_CMD_BACK)==DPLAY_VIEW);
    CHECK(p.dungeon.position==7&&p.retained_trap==252&&r.rng==expected);
    CHECK(dungeon_load_floor(&p.dungeon,0));p.dungeon.position=0xf8;p.dungeon.direction=0;
    single_check(&p,0xf8,1);
    CHECK(dplay_resume(&p,&r,&e)==DPLAY_CHEST);
    CHECK(p.action.type==1&&p.action.money==20&&p.action.target==0&&p.action.a==252);
    /* Source entrance scan also receives retained C2E0 before first chest. */
    CHECK(dplay_enter(&p,&r,&e,0,0xf8,0,239)==DPLAY_CHEST&&p.action.a==239);
    /* Suppression is exactly FF and only the two source flag pages are writable. */
    dplay_mark_object(&e,0xc501);dplay_mark_object(&e,0xc6d4);dplay_mark_object(&e,0xcb01);
    CHECK(e.flags[1]==255&&e.object_flags[212]==255&&e.flags[0]==0);
}
static void latch_and_escape(void) {
    DungeonPlay p;RPGState r;EventState e;uint16_t expected;unsigned bits,seed,dir;uint8_t command;
    for(command=0;command<=5;++command) {
        setup(&p,&r,&e,1,0x88,0);memset(p.dungeon.layout,0,256);expected=r.rng;
        if(command>=1&&command<=4)rnd(&expected);
        CHECK(dplay_step(&p,&r,&e,command)==(command==5?DPLAY_MENU:DPLAY_VIEW));
        CHECK(r.rng==expected);CHECK(dplay_resume(&p,&r,&e)==DPLAY_VIEW&&r.rng==expected);
    }
    setup(&p,&r,&e,1,0x88,0);memset(p.dungeon.layout,0,256);p.dungeon.layout[0x78]=4;expected=r.rng;
    CHECK(dplay_step(&p,&r,&e,5)==DPLAY_VIEW&&p.dungeon.layout[0x78]==132&&r.rng==expected);
    for(bits=0;bits<8;++bits)for(seed=1;seed<=32;++seed)for(dir=0;dir<4;++dir) {
        uint8_t newdir=(uint8_t)dir,newpos;
        setup(&p,&r,&e,1,0x88,(uint8_t)dir);memset(p.dungeon.layout,0,256);
        p.dungeon.layout[0x88]=8; /* No record: escape must not run65EE's fall check. */
        p.dungeon.layout[dungeon_sample_position(&p.dungeon,11)]=(bits&1)?1:0;
        p.dungeon.layout[dungeon_sample_position(&p.dungeon,12)]=(bits&2)?1:0;
        p.dungeon.layout[dungeon_sample_position(&p.dungeon,13)]=(bits&4)?1:0;
        CHECK(dplay_escape_blocked(&p)==(bits==7));
        rpg_seed_rng(&r,(uint16_t)(seed*73u));expected=r.rng;
        if(bits&1) {
            if(!(bits&2)&&((bits&4)||(rnd(&expected)&1)))newdir=(newdir+1)&3;
            else newdir=(newdir+3)&3;
        }
        newpos=(uint8_t)(0x88+dungeon_view_offsets[newdir*16+11]);rnd(&expected);
        CHECK(dplay_escape(&p,&r,&e)==DPLAY_VIEW);
        CHECK(p.dungeon.floor==1&&p.dungeon.direction==newdir&&p.dungeon.position==newpos);
        CHECK(r.rng==expected&&p.check_count==2&&p.check_cursor==2);
    }
}
static void transitions_and_fall(void) {
    DungeonPlay p;RPGState r;EventState e;unsigned i;uint8_t row[5],cell,kind;uint16_t seed;
    for(i=0;i<DUNGEON_TRANSITION_COUNT;++i) {
        memcpy(row,dungeon_transitions+i*5,5);setup(&p,&r,&e,row[0],row[1]+16u,0);
        cell=p.dungeon.layout[row[1]];if(!(cell&8)||((cell&7)<2)||((cell&7)>6))continue;
        p.dungeon.layout[p.dungeon.position]=0;
        if((cell&7)>=4)p.dungeon.layout[row[1]]|=128;
        seed=r.rng;kind=dplay_step(&p,&r,&e,1);
        if(row[2]<128)CHECK(kind==DPLAY_MAP&&p.action.target==row[2]&&p.action.a==row[3]&&p.action.b==row[4]);
        else CHECK(kind==DPLAY_EVENT&&p.action.target==row[3]&&p.action.a==row[4]&&p.action.b==row[2]&&p.action.type==(row[2]==255?15:row[2]==254?13:row[2]==253?30:255));
        CHECK(r.rng==seed);
    }
    setup(&p,&r,&e,3,0x11,0);p.dungeon.layout[0x11]=8;seed=r.rng;
    CHECK(dplay_step(&p,&r,&e,0)==DPLAY_VIEW&&p.dungeon.floor==2&&p.dungeon.position==0x11);
    CHECK(r.rng==seed);
}
static void governor_scene_fall(void) {
    DungeonPlay p;RPGState r,before;EventState e;unsigned light,trap;
    for(light=0;light<256;light+=light?254:1)for(trap=0;trap<256;trap+=85) {
        setup(&p,&r,&e,7,0x77,3);p.dungeon.light=(uint8_t)light;before=r;
        CHECK(dplay_scene_fall(&p,&r,&e,34,0xe6,0,(uint8_t)trap)==DPLAY_VIEW);
        CHECK(p.active&&p.dungeon.floor==33&&p.dungeon.position==0xe6&&!p.dungeon.direction);
        CHECK(p.dungeon.light==6&&p.dungeon.palette_index==6&&p.retained_trap==trap);
        CHECK(!p.initial_dark&&!p.encounter_latch&&p.check_count==1&&p.check_cursor==1);
        CHECK(!memcmp(&r,&before,sizeof(r)));
    }
}
int main(void) {
    entry_and_dark();every_object();fakewall_and_backward();retained_money_trap();latch_and_escape();transitions_and_fall();governor_scene_fall();
    printf("Dungeon controller checks passed: %u\n",checks);return 0;
}
