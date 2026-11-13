#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "world_rules.h"
static unsigned checks;
#define CHECK(x) do{++checks;assert(x);}while(0)
int main(void){
 RPGState s;WorldRuleAction a;WorldAction departure,arrival,exit;unsigned i,h,v;
 rpg_new_game(&s);
 CHECK(world_special(&s,5,0x4c,0,0,&a)==0);
 CHECK(world_special(&s,4,0x4c,0,1,&a)==0);
 CHECK(world_special(&s,5,0x4c,0,1,&a)==10&&a.target==0&&a.a==0xde&&a.rollback);
 CHECK(world_special(&s,0,0x5e,0,0,&a)==12&&a.target==160&&a.rollback);
 CHECK(world_special(&s,0,0x5e,4,0,&a)==0);
 rpg_add_item(&s,ItemID_Compass);CHECK(world_special(&s,0,0x5e,0,0,&a)==0);
 for(h=0;h<256;++h)for(v=0;v<4;++v){
  rpg_new_game(&s);s.party[0].hp=h;s.party[0].status=0x81;s.party[0].bound=9;
  s.party[1].hp=3;s.party[1].status=0;
  world_special(&s,1,0x60,v*4,0,&a);
  CHECK(s.party[0].hp==(v==2?h:(h>2?h-2:0)));
  CHECK(s.party[0].status==(v==2||h>2?0x81:0));
  CHECK(s.party[1].hp==3&&s.party[1].status==0&&s.party[0].bound==9);
  CHECK(a.death_mask==((v!=2&&h<=2)?1:0));
 }
 for(i=0xc3;i<0xc7;++i){rpg_new_game(&s);CHECK(world_special(&s,1,i,0,0,&a)==14&&a.target==25);CHECK(world_special(&s,1,i,4,0,&a)==0);}
 rpg_new_game(&s);for(i=0;i<4;++i){s.party[i].status=1;s.party[i].hp=i*15;}
 CHECK(world_special(&s,2,0xc7,0,0,&a)==12&&a.target==174&&a.death_mask==7&&!a.rollback);
 CHECK(s.party[3].hp==15&&s.party[3].status==1);
 rpg_new_game(&s);rpg_add_item(&s,ItemID_GasShield);CHECK(world_special(&s,2,0xd1,0,0,&a)==0&&s.party[0].hp==16);
 for(i=0;i<256;++i)CHECK(travel_route(i,&departure,&arrival,&exit)==(i>=0x81&&i<=0x88));
 CHECK(travel_route(0x81,&departure,&arrival,&exit)&&exit.target==16&&exit.a==0x53&&exit.b==0x17);
 printf("%u world-rule assertions passed\n",checks);return 0;
}
