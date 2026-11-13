#include "battle.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stddef.h>
static unsigned checks;
#define CHECK(x) do { ++checks; if (!(x)) { fprintf(stderr,"FAIL %d: %s\n",__LINE__,#x); assert(x); } } while(0)
static uint8_t rnd(uint16_t *seed) {
    uint16_t s = *seed;
    unsigned bit = ((s >> 15) ^ (s >> 13) ^ (s >> 4) ^ s) & 1u;
    s = (uint16_t)((s << 1) | bit); if (!s) s = 0x733c;
    *seed = s; return (uint8_t)s;
}
static uint8_t random_living(uint16_t *seed, const uint8_t *hp, uint8_t mask) {
    uint8_t c; do { c = rnd(seed) & mask; } while (!hp[c]); return c;
}
static uint8_t scaled(uint16_t *seed, unsigned v) {
    unsigned half = v / 2u, quarter = half / 2u;
    return (uint8_t)(half + quarter + ((unsigned)rnd(seed) * quarter) / 256u);
}
static uint8_t physical_ref(uint16_t *seed, unsigned attack, unsigned defense, unsigned level, unsigned enemy) {
    unsigned a = scaled(seed, attack), d = scaled(seed, defense), r;
    if (a > d) return (uint8_t)(a-d);
    d -= a;
    if (d >= 16u && d % 2u == 0) return 0;
    do { r = rnd(seed) & 31u; } while (r > level);
    return (uint8_t)((enemy ? r/2 : r)+1);
}
static void setup(RPGState *s, RPGBattle *b) {
    uint8_t i;
    rpg_new_game(s); for (i=1;i<4;++i) rpg_recruit(s,i);
    for (i=0;i<4;++i) s->party[i].level=30;
    rpg_refresh_stats(s); rpg_rest(s);
    CHECK(rpg_battle_begin(s,b,EnemyID_DarkFalz)==RPG_OK);
}
static void one_turn(RPGState *s, RPGBattle *b, uint8_t actor, uint8_t kind, uint8_t id, uint8_t target) {
    b->turn_order[0]=actor; b->turn_cursor=0;
    if(actor<4) { b->actions[actor].kind=kind; b->actions[actor].id=id; b->actions[actor].target=target; }
    rpg_battle_step(s,b);
}
static void encounters_and_setup(void) {
    RPGState s; RPGBattle b; uint16_t ref; uint8_t rec[32],name[9],i,n,bound; unsigned seed;
    rpg_new_game(&s); CHECK(rpg_encounter_from_pool(&s,0)==0); CHECK(rpg_encounter_from_pool(&s,95)==0);
    for(i=1;i<=94;++i) {
        rpg_seed_rng(&s,93u+i); ref=s.rng;
        CHECK(rpg_encounter_from_pool(&s,i)==rpg_encounter_pools[i-1u][rnd(&ref)&7u]);
        CHECK(s.rng==ref);
    }
    CHECK(rpg_enemy_record(0,rec)==RPG_INVALID && rpg_enemy_record(75,rec)==RPG_INVALID);
    CHECK(rpg_enemy_name(1,(char*)name)==RPG_OK && !strcmp((char*)name,"SWORM"));
    for(i=1;i<75;++i) for(seed=1;seed<=32;++seed) {
        rpg_new_game(&s); rpg_seed_rng(&s,(uint16_t)seed); ref=s.rng;
        CHECK(rpg_enemy_record(i,rec)==RPG_OK);
        if(rec[20]&128u) n=rec[20]&15u;
        else { bound=(rec[20]&15u)<2u?(rec[20]&15u):2u; do{n=rnd(&ref)&7u;}while(n>=bound); ++n; }
        CHECK(rpg_battle_begin(&s,&b,i)==RPG_OK);
        CHECK(b.count==n && s.rng==ref);
        CHECK(b.enemies[0].hp==rec[21] && b.enemies[0].max_hp==rec[21]);
        CHECK(b.enemies[0].attack==rec[22] && b.enemies[0].defense==rec[23]);
        CHECK(b.money_reward==n*(rec[25]+256u*rec[26]) && b.exp_reward==n*(rec[28]+256u*rec[29]));
    }
}
static uint8_t world_ref(uint16_t *seed, uint8_t group, uint16_t x, uint16_t y, uint8_t tile, uint8_t vehicle) {
    /* SMS stores scroll X in 256px chunks and Y in 192px chunks. Reproduce its
       add/ADC/CCF region selection rather than the native coordinate formula. */
    unsigned sx=(x+2048u-136u)%2048u, sy=(y+1536u-112u)%1536u;
    unsigned row=sy/192u, col=sx/256u, low=sy%192u, region,chance,pool,terrain;
    if(group>=3)return 0;
    if(low+96u>=192u)++row;
    if(sx%256u+128u>=256u)++col;
    region=(row%8u)*8u+col%8u;
    chance=rpg_world_regions[group][region][0];if(vehicle)chance/=4;
    if(rnd(seed)>=chance)return 0;
    terrain=rpg_terrain_lookup[tile]+(group?10u:0u);
    pool=rpg_map_encounter_window[terrain][rpg_world_regions[group][region][1]];
    if(!pool || pool>94)return 0;
    return rpg_encounter_pools[pool-1u][rnd(seed)&7u];
}
static void map_and_dungeon_encounters(void) {
    RPGState s; unsigned group,i,vehicle,seed,floor,cell; uint8_t map[12288],expected,settings[4];
    uint16_t ref; FILE *f; char path[64];
    rpg_new_game(&s);
    for(group=0;group<3;++group){
        snprintf(path,sizeof path,"assets/world/world_g%02u.map",group);
        f=fopen(path,"rb");CHECK(f!=NULL);CHECK(fread(map,1,sizeof map,f)==sizeof map);fclose(f);
        for(i=0;i<12288;++i)for(vehicle=0;vehicle<2;++vehicle)for(seed=1;seed<=4;++seed){
            uint16_t x=(uint16_t)((i%128u)*16u+8u), y=(uint16_t)(((i/128u)*16u+16u)%1536u);
            rpg_seed_rng(&s,(uint16_t)(seed*713u+i));ref=s.rng;
            expected=world_ref(&ref,(uint8_t)group,x,y,map[i],(uint8_t)vehicle);
            CHECK(rpg_world_encounter(&s,(uint8_t)group,x,y,map[i],(uint8_t)vehicle)==expected && s.rng==ref);
        }
    }
    for(floor=0;floor<61;++floor)for(cell=0;cell<16;++cell)for(seed=1;seed<=32;++seed){
        uint8_t pool=rpg_dungeon_settings[floor][1];
        rpg_seed_rng(&s,(uint16_t)(seed*37u));ref=s.rng;expected=0;
        if(rnd(&ref)<rpg_dungeon_settings[floor][0] && !(cell&7u) && pool)
            expected=rpg_encounter_pools[pool-1u][rnd(&ref)&7u];
        CHECK(rpg_dungeon_encounter(&s,(uint8_t)floor,(uint8_t)cell)==expected && s.rng==ref);
    }
    CHECK(rpg_dungeon_settings_get(60,settings)==RPG_OK && !memcmp(settings,rpg_dungeon_settings[60],4));
    ref=s.rng;CHECK(rpg_dungeon_encounter(&s,61,0)==0 && s.rng==ref);
    CHECK(rpg_world_encounter(&s,3,0,0,0,0)==0 && s.rng==ref);
}
static void initiative(void) {
    RPGState s; RPGBattle b; RPGAction actions[4]={{0}}; uint16_t ref; uint8_t order[12],i,j,t; unsigned k;
    setup(&s,&b); rpg_seed_rng(&s,0xa62c); ref=s.rng;
    for(i=0;i<12;++i)order[i]=i;
    for(k=0;k<100;++k){
        for(i=0;i<12;++i){do{j=rnd(&ref)&15u;}while(j>=12);t=order[i];order[i]=order[j];order[j]=t;}
        CHECK(rpg_battle_prepare(&s,&b,actions)==RPG_OK);
        CHECK(!memcmp(order,b.turn_order,12) && ref==s.rng);
        b.turn_cursor=12; /* isolate permutation from actor execution */
    }
}
static void spell_damage(void) {
    RPGState s; RPGBattle b; unsigned seed,spell; uint16_t ref; uint8_t hp[8],i,c,d,hits,amount;RPGHit expected[8];
    for(spell=0;spell<3;++spell)for(seed=1;seed<=128;++seed){
        setup(&s,&b); b.enemy_id=EnemyID_Sworm; rpg_seed_rng(&s,(uint16_t)seed); ref=s.rng;
        memset(hp,0,sizeof hp);hp[0]=hp[1]=255;
        hits=spell==0?2:spell==1?3:2; amount=spell==1?12:spell==2?40:10;
        for(i=0;i<hits;++i){ c=spell==2?i:random_living(&ref,hp,7); d=amount-(rnd(&ref)&(spell==2?15:3)); hp[c]-=d;expected[i].target=c+4u;expected[i].damage=d;expected[i].hp=hp[c]; }
        one_turn(&s,&b,3,RPG_ACT_MAGIC,spell==0?MagicID_Fire:spell==1?MagicID_Wind:MagicID_Thun,0);
        CHECK(b.enemies[0].hp==hp[0] && b.enemies[1].hp==hp[1] && s.rng==ref);
        CHECK(b.hit_count==hits&&!memcmp(b.hits,expected,(size_t)hits*sizeof(RPGHit)));
        CHECK(s.party[3].mp==83u-(spell==0?4u:spell==1?12u:16u));
    }
    setup(&s,&b);one_turn(&s,&b,3,RPG_ACT_MAGIC,MagicID_Thun,0);
    CHECK(b.enemies[0].hp>=215 && b.enemies[0].hp<=230 && b.enemies[1].hp==255);
    CHECK(b.hit_count==1&&b.hits[0].target==4&&b.hits[0].hp==b.enemies[0].hp);
    for(i=0;i<3;++i){
        setup(&s,&b);s.party[2].weapon=i==0?ItemID_NeedleGun:i==1?ItemID_HeatGun:ItemID_LaserGun;
        one_turn(&s,&b,2,RPG_ACT_ATTACK,0,0);
        CHECK(b.enemies[0].hp==255u-(i==0?5u:i==1?10u:20u) && b.enemies[1].hp==255);
        b.enemy_id=EnemyID_Sworm;one_turn(&s,&b,2,RPG_ACT_ATTACK,0,0);
        CHECK(b.enemies[1].hp==255u-(i==0?5u:i==1?10u:20u));
        CHECK(b.hit_count==2&&b.hits[0].target==4&&b.hits[1].target==5);
    }
    setup(&s,&b);b.enemy_id=EnemyID_Sworm;s.party[2].weapon=ItemID_NeedleGun;
    for(i=0;i<8u;++i){b.enemies[i].status=1;b.enemies[i].hp=20;}ref=s.rng;
    one_turn(&s,&b,2,RPG_ACT_ATTACK,0,0);CHECK(b.hit_count==8&&s.rng==ref);
    for(i=0;i<8u;++i)CHECK(b.hits[i].target==i+4u&&b.hits[i].damage==5&&b.hits[i].hp==15);
    setup(&s,&b);b.enemy_id=EnemyID_Sworm;b.enemies[0].hp=1;b.enemies[1].hp=0;b.enemies[1].status=0;
    one_turn(&s,&b,3,RPG_ACT_MAGIC,MagicID_Fire,0);
    CHECK(b.hit_count==1&&b.hits[0].target==4&&b.hits[0].damage==1&&!b.hits[0].hp);
}
static void physical_and_fire(void) {
    RPGState s; RPGBattle b; unsigned seed; uint16_t ref; uint8_t hp[4],c,d,i; unsigned attack;
    for(seed=1;seed<=256;++seed){
        setup(&s,&b);b.enemy_flags=0;s.party[0].status|=128;s.party[0].attack=200;
        rpg_seed_rng(&s,(uint16_t)seed);ref=s.rng;
        { uint8_t ehp[8]={255,255,0,0,0,0,0,0}; c=random_living(&ref,ehp,7); }
        d=physical_ref(&ref,255,150,30,0);
        one_turn(&s,&b,0,RPG_ACT_ATTACK,0,0);
        CHECK(b.enemies[c].hp==255u-d && s.rng==ref);
        setup(&s,&b); b.enemy_flags=0; b.enemies[0].status=193; /* boost, then weak */
        b.enemies[0].attack=200; rpg_seed_rng(&s,(uint16_t)seed);ref=s.rng;
        for(i=0;i<4;++i) hp[i]=s.party[i].hp;
        c=random_living(&ref,hp,3);attack=255u-255u/4u;
        d=physical_ref(&ref,attack,s.party[c].defense,30,1);
        one_turn(&s,&b,4,0,0,0);
        CHECK(s.party[c].hp==(d<hp[c]?hp[c]-d:0) && s.rng==ref);
        setup(&s,&b); b.enemy_flags=4; rpg_seed_rng(&s,(uint16_t)seed);ref=s.rng;
        if(rnd(&ref)&3u) continue;
        for(i=0;i<4;++i)hp[i]=s.party[i].hp;
        for(i=0;i<2;++i){c=random_living(&ref,hp,3);d=10u-(rnd(&ref)&3u);hp[c]-=d;}
        one_turn(&s,&b,4,0,0,0);
        for(i=0;i<4;++i)CHECK(s.party[i].hp==hp[i]);
        CHECK(s.rng==ref);
    }
}
static void statuses_and_bosses(void) {
    RPGState s; RPGBattle b; uint16_t ref; uint8_t i,old,hp[4],c,n; unsigned seed;
    setup(&s,&b);s.party[0].bound=1;one_turn(&s,&b,0,RPG_ACT_ATTACK,0,0);
    CHECK(s.party[0].bound==0 && b.enemies[0].hp==255 && b.enemies[1].hp==255);
    setup(&s,&b);b.enemies[0].bound=1;one_turn(&s,&b,4,0,0,0);
    CHECK(b.enemies[0].bound==0 && b.last_effect==BATTLE_EFFECT_RECOVERED);
    setup(&s,&b);b.enemy_flags=2;b.enemies[0].hp=20;ref=s.rng;one_turn(&s,&b,4,0,0,0);
    CHECK(b.enemies[0].hp==100 && s.rng==ref);
    setup(&s,&b);b.enemy_flags=0x10;b.barrier=0x86;one_turn(&s,&b,4,0,0,0);
    CHECK(b.last_damage==0 && b.barrier>=0x83 && b.barrier<=0x86);
    setup(&s,&b);b.enemy_flags=0;b.barrier=0x86;one_turn(&s,&b,4,0,0,0);
    CHECK(b.barrier==0); /* enemies lacking bit4 shatter protection before attacking */
    setup(&s,&b);b.enemy_flags=6;b.barrier=6;one_turn(&s,&b,4,0,0,0);
    CHECK(b.last_effect==BATTLE_EFFECT_PETRIFY && s.party[b.last_target].hp==0 && s.party[b.last_target].status==0);
    setup(&s,&b);b.enemy_flags=6;s.party[2].shield=ItemID_MirrorShield;one_turn(&s,&b,4,0,0,0);
    CHECK(b.last_effect!=BATTLE_EFFECT_PETRIFY);
    setup(&s,&b);b.enemy_flags=7;b.enemy_id=EnemyID_Lassic;for(i=0;i<4;++i)s.party[i].hp=100;
    one_turn(&s,&b,4,0,0,0);CHECK(b.outcome==RPG_DEFEAT);
    setup(&s,&b);b.enemy_flags=7;b.enemy_id=EnemyID_Lassic;for(i=0;i<4;++i)s.party[i].hp=255;
    rpg_seed_rng(&s,1);ref=s.rng;
    for(i=0;i<4;++i){n=(rnd(&ref)&15u)+1u;hp[i]=(uint8_t)(255u+n);}
    one_turn(&s,&b,4,0,0,0);
    for(i=0;i<4;++i)CHECK(s.party[i].hp==hp[i]);CHECK(s.rng==ref);
    setup(&s,&b);b.enemy_flags=7;b.enemy_id=EnemyID_Lassic;rpg_add_item(&s,ItemID_Crystal);
    one_turn(&s,&b,4,0,0,0);CHECK(b.outcome==RPG_ONGOING);
    setup(&s,&b);b.enemy_flags=0;b.enemy_id=EnemyID_GdDragn;s.party[1].hp=1;
    for(seed=1;seed<65535;++seed){ref=(uint16_t)seed;if((rnd(&ref)&3u)==1u)break;}
    rpg_seed_rng(&s,(uint16_t)seed);one_turn(&s,&b,4,0,0,0);CHECK(b.outcome==RPG_DEFEAT);
    setup(&s,&b);b.enemy_flags=0x20;b.enemies[0].attack=1;
    one_turn(&s,&b,0,RPG_ACT_MAGIC,MagicID_Rope,0);CHECK(b.enemies[0].bound==3 && b.enemies[1].bound==0);
    one_turn(&s,&b,0,RPG_ACT_MAGIC,MagicID_Rope,0);CHECK(b.enemies[1].bound==3);
    setup(&s,&b);old=s.party[0].hp;s.party[0].status=0;s.party[0].hp=0;
    one_turn(&s,&b,1,RPG_ACT_MAGIC,MagicID_Help,0);CHECK(s.party[0].hp==0 && s.party[0].status==0 && b.last_error==RPG_DEAD);
    (void)old;(void)c;
}
static void remaining_enemy_modes(void) {
    RPGState s; RPGBattle b; unsigned seed; uint16_t ref; uint8_t hp[4],i,c,d,oldmp;
    for(seed=1;seed<=256;++seed){
        setup(&s,&b);b.enemy_flags=1;rpg_seed_rng(&s,(uint16_t)seed);ref=s.rng;
        if(!(rnd(&ref)&3u)){
            for(i=0;i<4;++i)hp[i]=s.party[i].hp;
            c=random_living(&ref,hp,3);one_turn(&s,&b,4,0,0,0);
            CHECK(s.party[c].bound==3 && s.rng==ref);
        }
        setup(&s,&b);b.enemy_flags=3;rpg_seed_rng(&s,(uint16_t)seed);ref=s.rng;
        if(!(rnd(&ref)&15u)){one_turn(&s,&b,4,0,0,0);CHECK(b.enemies[0].status==129 && s.rng==ref);}
        setup(&s,&b);b.enemy_flags=5;rpg_seed_rng(&s,(uint16_t)seed);ref=s.rng;
        if(!(rnd(&ref)&3u)){
            for(i=0;i<4;++i){hp[i]=s.party[i].hp;d=40u-(rnd(&ref)&15u);hp[i]-=d;}
            one_turn(&s,&b,4,0,0,0);
            for(i=0;i<4;++i)CHECK(s.party[i].hp==hp[i]);CHECK(s.rng==ref);
        }
    }
    setup(&s,&b);b.enemy_flags=0x10;b.enemies[0].attack=1;oldmp=s.party[1].mp;
    one_turn(&s,&b,1,RPG_ACT_MAGIC,MagicID_Wall,0);
    CHECK(b.barrier==6 && s.party[1].mp==oldmp-6u);
    oldmp=s.party[3].mp;one_turn(&s,&b,3,RPG_ACT_MAGIC,MagicID_Prot,0);
    CHECK(b.barrier==134 && s.party[3].mp==oldmp-10u);
    setup(&s,&b);b.enemies[0].attack=1;rpg_seed_rng(&s,1);
    one_turn(&s,&b,1,RPG_ACT_MAGIC,MagicID_Terr,0);CHECK((b.enemies[0].status&64u)!=0);
    setup(&s,&b);b.enemy_flags=0x15;b.barrier=0x86;
    /* Protection decays for every party slot, including dead/unjoined slots. */
    s.party[1].status=s.party[2].status=s.party[3].status=0;
    for(seed=1;seed<65535;++seed){ref=(uint16_t)seed;if(!(rnd(&ref)&3u))break;}
    rpg_seed_rng(&s,(uint16_t)seed);one_turn(&s,&b,4,0,0,0);CHECK(b.barrier<=0x86);
}
static void enemy_magic_trace(void){
 RPGState s;RPGBattle b;RPGHit expected[4];uint16_t ref;unsigned seed;uint8_t mode,strength,i,c,d,n,mask,hp[4],breaking;
 CHECK(offsetof(RPGBattle,barrier_break_before)==223u&&sizeof(RPGBattle)==224u);
 for(mode=4;mode<=5;mode++)for(strength=0;strength<=6;strength++)for(seed=1;seed<=128;seed++){
  setup(&s,&b);b.enemy_flags=0x10u|mode;b.barrier=strength?128u|strength:0;rpg_seed_rng(&s,(uint16_t)seed);ref=s.rng;
  if(rnd(&ref)&3u)continue;
  for(i=0;i<4;i++)s.party[i].hp=hp[i]=200;
  n=b.barrier;mask=breaking=0;
  for(i=0;i<(mode==4?2:4);i++){
   if(n&128u){d=rnd(&ref)&3u;c=n&127u;n=c>d?(128u|(c-d)):0;if(!n)breaking=i+1u;}
   c=mode==4?random_living(&ref,hp,3):i;
   d=mode==4?10u-(rnd(&ref)&3u):(n&128u)?0:40u-(rnd(&ref)&15u);
   if(n&128u){mask|=1u<<i;d=0;}
   hp[c]-=d;expected[i].target=c;expected[i].damage=d;expected[i].hp=hp[c];
  }
  one_turn(&s,&b,4,0,0,0);
  CHECK(b.last_magic_mode==(mode==4?0x80:0xc0)&&b.hit_count==(mode==4?2:4)&&b.hit_blocked==mask);
  CHECK(b.barrier==n&&s.rng==ref&&b.barrier_break_before==breaking);
  for(i=0;i<b.hit_count;i++)CHECK(!memcmp(b.hits+i,expected+i,sizeof(RPGHit)));
  for(i=0;i<4;i++)CHECK(s.party[i].hp==hp[i]);
 }
}
static void talking_running_items(void) {
    RPGState s; RPGBattle b; RPGAction a[4]={{0}}; uint8_t item,old; uint16_t ref;
    setup(&s,&b);b.enemy_flags=128;b.enemies[0].attack=255;s.party[0].attack=1;
    CHECK(rpg_battle_talk(&s,&b,0)==RPG_ACTION_FAILED && b.suppress_party);
    CHECK(rpg_battle_talk(&s,&b,1)==RPG_OK && b.outcome==RPG_TALKED && b.talk_index<9);
    setup(&s,&b);b.enemy_flags=64;b.enemies[0].attack=255;s.party[0].attack=1;
    CHECK(rpg_battle_talk(&s,&b,1)==RPG_ACTION_FAILED);
    CHECK(rpg_battle_talk(&s,&b,2)==RPG_OK && b.talk_index>=9 && b.talk_index<19);
    setup(&s,&b);b.run_chance=255;b.escape_blocked=1;CHECK(rpg_try_run(&s,&b)==RPG_ACTION_FAILED);
    b.escape_blocked=0;rpg_seed_rng(&s,1);CHECK(rpg_try_run(&s,&b)==RPG_OK && b.outcome==RPG_ESCAPED);
    setup(&s,&b);b.enemy_flags=0;a[0].kind=RPG_ACT_TALK;a[1].kind=RPG_ACT_MAGIC;a[1].id=255;
    CHECK(rpg_battle_prepare(&s,&b,a)==RPG_OK && b.suppress_party && b.turn_cursor==0);
    setup(&s,&b);b.enemy_flags=0;a[0].kind=RPG_ACT_MAGIC;a[0].id=MagicID_Chat;
    old=s.party[0].mp;CHECK(rpg_battle_prepare(&s,&b,a)==RPG_OK && s.party[0].mp==old-2u && b.suppress_party);
    setup(&s,&b);rpg_add_item(&s,ItemID_Escaper);b.run_chance=0;
    one_turn(&s,&b,0,RPG_ACT_ITEM,ItemID_Escaper,0);CHECK(s.inventory_count==0 && b.outcome==RPG_ONGOING);
    setup(&s,&b);rpg_add_item(&s,ItemID_Cola);s.party[0].hp=1;
    one_turn(&s,&b,0,RPG_ACT_ITEM,ItemID_Cola,3);CHECK(s.party[0].hp==11 && s.inventory_count==0);
    setup(&s,&b);rpg_add_item(&s,ItemID_Sphere);b.enemy_flags=64;
    one_turn(&s,&b,0,RPG_ACT_ITEM,ItemID_Sphere,0);CHECK(s.inventory_count==0 && b.outcome==RPG_TALKED);
    setup(&s,&b);rpg_add_item(&s,ItemID_Wand);b.run_chance=1;
    ref=s.rng;one_turn(&s,&b,0,RPG_ACT_ITEM,ItemID_Wand,0);CHECK(b.outcome==RPG_ESCAPED && s.inventory_count==1 && s.rng==ref);
    item=ItemID_Landrover;setup(&s,&b);rpg_add_item(&s,item);memset(a,0,sizeof a);a[0].kind=RPG_ACT_ITEM;a[0].id=item;
    CHECK(rpg_battle_prepare(&s,&b,a)==RPG_OK && b.turn_cursor==0);
    b.turn_order[0]=0;rpg_battle_step(&s,&b);CHECK(b.last_effect==BATTLE_EFFECT_FIELD_ITEM&&s.inventory_count==1);
}
static void rewards(void) {
    RPGState s; RPGBattle b; uint8_t i; uint16_t exp,money;
    setup(&s,&b);b.enemy_id=EnemyID_Sworm;b.outcome=RPG_VICTORY;b.exp_reward=100;b.money_reward=75;b.item_reward=ItemID_Cola;b.trap_chance=240;
    for(i=0;i<4;++i)s.party[i].hp=10;
    CHECK(rpg_claim_rewards(&s,&b)==RPG_OK && b.chest_state==BATTLE_CHEST_PENDING && b.chest_visual==0);
    CHECK(s.money==0 && s.party[0].exp==100);
    CHECK(rpg_battle_prepare_chest(&s,&b)==RPG_OK && b.chest_visual==0x3e && b.trap_kind==BATTLE_TRAP_PARTY);
    CHECK(rpg_claim_rewards(&s,&b)==RPG_OK && s.party[0].exp==100);
    CHECK(rpg_battle_open_chest(&s,&b)==RPG_OK && s.money==75 && s.inventory[0]==ItemID_Cola);
    for(i=0;i<4;++i)CHECK(s.party[i].hp==7);
    CHECK(rpg_battle_open_chest(&s,&b)==RPG_INVALID && s.money==75);
    setup(&s,&b);b.outcome=RPG_VICTORY;b.exp_reward=10;b.money_reward=8;b.item_reward=ItemID_Flash;
    while(s.inventory_count<24)rpg_add_item(&s,ItemID_LaconiaPot);
    CHECK(rpg_claim_rewards(&s,&b)==RPG_OK);
    CHECK(rpg_battle_open_chest(&s,&b)==RPG_FULL && b.item_pending==ItemID_Flash && s.money==8);
    CHECK(rpg_battle_replace_reward(&s,&b,0)==RPG_PROTECTED_ITEM && s.money==8);
    rpg_remove_item(&s,0);CHECK(rpg_battle_open_chest(&s,&b)==RPG_OK && s.money==8 && s.inventory_count==24);
    exp=s.party[0].exp;money=s.money;CHECK(rpg_claim_rewards(&s,&b)==RPG_OK && s.party[0].exp==exp && s.money==money);
    setup(&s,&b);b.enemy_id=EnemyID_Tarzimal;b.outcome=RPG_VICTORY;b.exp_reward=200;
    CHECK(rpg_claim_rewards(&s,&b)==RPG_OK && s.party[0].exp==0 && b.rewards_claimed);
    setup(&s,&b);b.outcome=RPG_VICTORY;b.money_reward=20;CHECK(rpg_claim_rewards(&s,&b)==RPG_OK);
    rpg_battle_decline_chest(&b);CHECK(b.chest_state==BATTLE_CHEST_DECLINED && s.money==0);
}
static void chest_preparation(void) {
 RPGState s;RPGBattle b;uint16_t seed,ref;unsigned chance;uint8_t roll,expected;
 rpg_new_game(&s);
 for(chance=0;chance<256;++chance)for(seed=1;seed<32;++seed){
  memset(&b,0,sizeof b);b.chest_state=BATTLE_CHEST_PENDING;b.trap_chance=chance;s.rng=seed;ref=seed;roll=rnd(&ref);
  expected=chance&&(chance>=240||chance>=roll)?(chance&1?0x43:0x3e):0x3d;
  CHECK(rpg_battle_prepare_chest(&s,&b)==RPG_OK && b.chest_visual==expected && s.rng==ref);
  CHECK(rpg_battle_prepare_chest(&s,&b)==RPG_OK && s.rng==ref);
  rpg_battle_decline_chest(&b);CHECK(s.rng==ref);
 }
 memset(&b,0,sizeof b);b.chest_state=BATTLE_CHEST_PENDING;b.trap_chance=255;s.rng=17;
 rpg_battle_prepare_chest(&s,&b);ref=s.rng;b.chest_visual=0x3d;
 CHECK(rpg_battle_open_chest(&s,&b)==RPG_OK && s.rng==ref && b.trap_kind==BATTLE_TRAP_NONE);
}
static void campaign_loop(void) {
    RPGState s; RPGBattle b; RPGAction a[4]={{1,0,0},{0,0,0},{0,0,0},{0,0,0}}; unsigned round;
    rpg_new_game(&s);rpg_seed_rng(&s,1234);CHECK(rpg_battle_begin(&s,&b,EnemyID_Sworm)==RPG_OK);
    for(round=0;round<1000 && b.outcome==RPG_ONGOING;++round)rpg_battle_round(&s,&b,a);
    CHECK(b.outcome==RPG_VICTORY || b.outcome==RPG_DEFEAT);
    if(b.outcome==RPG_VICTORY){CHECK(rpg_claim_rewards(&s,&b)==RPG_OK);if(b.chest_state==BATTLE_CHEST_PENDING)CHECK(rpg_battle_open_chest(&s,&b)==RPG_OK);}
}
static void all_enemy_battle_smoke(void) {
    RPGState s;RPGBattle b;RPGAction a[4]={{1,0,0},{1,0,0},{1,0,0},{1,0,0}};
    unsigned enemy,seed,round;uint8_t c;
    for(enemy=1;enemy<75;++enemy)for(seed=1;seed<=16;++seed){
        rpg_new_game(&s);for(c=1;c<4;++c)rpg_recruit(&s,c);
        for(c=0;c<4;++c)s.party[c].level=30;
        rpg_refresh_stats(&s);rpg_rest(&s);rpg_add_item(&s,ItemID_Crystal);
        rpg_seed_rng(&s,(uint16_t)(seed*1871u));CHECK(rpg_battle_begin(&s,&b,(uint8_t)enemy)==RPG_OK);
        for(round=0;round<1000 && b.outcome==RPG_ONGOING;++round){
            rpg_battle_round(&s,&b,a);CHECK(b.last_error==RPG_OK);
        }
        CHECK(b.outcome==RPG_VICTORY || b.outcome==RPG_DEFEAT);
    }
}
int main(void){chest_preparation();encounters_and_setup();map_and_dungeon_encounters();initiative();spell_damage();physical_and_fire();statuses_and_bosses();remaining_enemy_modes();enemy_magic_trace();talking_running_items();rewards();campaign_loop();all_enemy_battle_smoke();printf("Battle logic checks passed: %u\n",checks);return 0;}
