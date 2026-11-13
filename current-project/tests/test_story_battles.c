#include "events.h"
#include <assert.h>
#include <stdio.h>
static RPGState r;static EventState e;static const EventAction *a;static unsigned checks;
#define CHECK(x) do{assert(x);++checks;}while(0)
static void fresh(void){rpg_new_game(&r);event_init(&e,&r);}
static void begin(uint8_t id){a=event_begin(&e,0x10,id,0,4);}
static void next(void){a=event_advance(&e);}
static void yes(void){a=event_respond(&e,1);}
static void no(void){a=event_respond(&e,0);}
static void result(uint8_t outcome,uint8_t opened){a=event_battle_result(&e,outcome,opened);}
int main(void){unsigned i,j;static const uint8_t routes[3][3]={{0,0x83,0x84},{0x85,0,0x86},{0x87,0x88,0}};
 fresh();for(i=1;i<=182;i++){begin((uint8_t)i);CHECK(a->kind!=EVENT_UNIMPLEMENTED);}
 fresh();begin(129);CHECK(e.portrait==52);begin(127);CHECK(e.portrait==16);begin(126);CHECK(e.portrait==59);e.flags[4]=2;begin(62);CHECK(e.portrait==52);begin(63);CHECK(e.portrait==16);
 fresh();rpg_recruit(&r,1);begin(22);CHECK(a->dialogue_id==0x296);yes();CHECK(a->dialogue_id==0xb728 && a->character==1 && r.party[1].status==1);next();CHECK(a->dialogue_id==0x298 && !r.party[1].status && !r.party[1].hp);next();CHECK(a->kind==EVENT_BATTLE && a->target==EnemyID_DrMad && e.battle.item_reward==ItemID_LaconiaPot && e.battle.flag_index==24);result(RPG_VICTORY,0);CHECK(e.flags[24]==0 && a->kind==EVENT_DONE);
 begin(22);next();result(RPG_VICTORY,1);CHECK(e.flags[24]==255);
 fresh();rpg_recruit(&r,1);rpg_add_item(&r,ItemID_LaconiaPot);begin(22);no();next();CHECK(!e.battle.options);result(RPG_ESCAPED,0);CHECK(a->kind==EVENT_MENU);
 fresh();begin(55);CHECK(a->dialogue_id==0xa4);next();CHECK(a->dialogue_id==0x29c && r.inventory[0]==ItemID_Letter);next();CHECK(a->kind==EVENT_SCENE && a->target==0x20);next();CHECK(a->dialogue_id==0x2a0);next();CHECK(a->kind==EVENT_BATTLE && a->target==EnemyID_Saccubus);
 r.party[0].status=0;r.party[0].hp=0;result(RPG_DEFEAT,0);CHECK(r.party[0].status==1 && a->kind==EVENT_SCENE);next();CHECK(a->dialogue_id==0x2a2);next();CHECK(a->kind==EVENT_GOVERNOR_ROOM);CHECK(r.party[0].hp==0);event_governor_room_loaded(&e);next();CHECK(a->dialogue_id==0xaa && r.party[0].hp==16);
 begin(55);CHECK(a->dialogue_id==0x29e);next();CHECK(a->dialogue_id==0xaa);
 e.flags[22]=1;begin(55);next();CHECK(a->kind==EVENT_DUNGEON_FALL && a->target==0x22 && a->a==0xe6 && !a->b);
 fresh();for(i=0;i<24;i++)rpg_add_item(&r,ItemID_Cola);begin(55);next();no();yes();next();CHECK(a->kind==EVENT_DONE && rpg_find_item(&r,ItemID_Letter)==255);
 fresh();begin(157);CHECK(a->dialogue_id==0x25a);yes();CHECK(a->dialogue_id==0x25e);begin(157);no();CHECK(a->dialogue_id==0x260);
 rpg_recruit(&r,1);rpg_recruit(&r,2);rpg_recruit(&r,3);r.party[3].status=0;r.party[3].hp=0;begin(157);next();CHECK(a->dialogue_id==0x2a8);
 r.party[3].status=1;r.party[3].hp=17;begin(157);next();CHECK(a->dialogue_id==0x24e);next();CHECK(a->kind==EVENT_BATTLE && a->target==EnemyID_Tarzimal && !r.party[0].status && !r.party[1].status && !r.party[2].status);
 r.party[3].hp=0;r.party[3].status=0;result(RPG_DEFEAT,0);CHECK(a->dialogue_id==0x256 && r.party[3].hp==17 && r.party[3].status==1 && r.party[0].status==1 && r.party[2].status==1);
 begin(157);next();next();result(RPG_VICTORY,0);CHECK(a->dialogue_id==0x250);next();CHECK(rpg_find_item(&r,ItemID_FradeMantle)!=255);begin(157);CHECK(a->dialogue_id==0x258);
 fresh();begin(130);yes();CHECK(a->dialogue_id==0xe8);next();CHECK(a->kind==EVENT_BATTLE && a->target==46);result(RPG_DEFEAT,0);CHECK(a->kind==EVENT_GAME_OVER);
 rpg_add_item(&r,ItemID_RoadPass);begin(130);yes();CHECK(a->dialogue_id==0x24);next();CHECK(a->kind==EVENT_DONE);begin(147);yes();next();CHECK(a->kind==EVENT_DUNGEON && a->target==0x15 && a->a==0x9c && a->b==1);
 fresh();begin(155);no();next();CHECK(a->kind==EVENT_DUNGEON_BACK);begin(155);yes();CHECK(a->dialogue_id==0xa0);next();CHECK(a->kind==EVENT_DUNGEON_BACK);rpg_add_item(&r,ItemID_Cake);begin(155);yes();CHECK(a->dialogue_id==0x9e && e.flags[17]==255 && !r.inventory_count);
 fresh();begin(158);next();CHECK(a->kind==EVENT_BATTLE && a->target==EnemyID_Shadow);result(RPG_DEFEAT,0);CHECK(!e.flags[23] && a->kind==EVENT_GAME_OVER);begin(158);next();result(RPG_VICTORY,1);CHECK(e.flags[23]==255 && e.flags[0]==255 && a->dialogue_id==0x266);
 begin(159);no();CHECK(a->dialogue_id==0x270);next();CHECK(a->target==EnemyID_Lassic);result(RPG_VICTORY,0);CHECK(e.flags[22]==1 && a->dialogue_id==0x2aa);begin(159);CHECK(a->kind==EVENT_DONE);
 fresh();begin(166);CHECK(a->kind==EVENT_DUNGEON_CELL && a->target==0xc3 && !a->a && e.prepared_enemy==27);next();CHECK(a->dialogue_id==0x238);next();CHECK(a->kind==EVENT_DONE);
 fresh();begin(167);CHECK(a->target==38 && (e.battle.options&EVENT_BATTLE_ZERO_MONEY));
 begin(170);CHECK(a->dialogue_id==0x282);e.flags[4]=7;e.camera_x_low=0x40;begin(170);next();CHECK(a->kind==EVENT_MAP_TRANSITION && a->target==7 && a->a==0x1b && a->b==0x1b);e.camera_x_low=0x3f;begin(170);next();CHECK(a->b==0x1d);
 fresh();begin(171);CHECK(a->kind==EVENT_DARK_FALZ_REVEAL);next();CHECK(a->kind==EVENT_BATTLE && a->target==EnemyID_DarkFalz);result(RPG_VICTORY,0);CHECK(a->kind==EVENT_GOVERNOR_ROOM);next();CHECK(a->dialogue_id==0x272);no();CHECK(a->dialogue_id==0x230);next();CHECK(a->kind==EVENT_ENDING);
 begin(172);next();yes();CHECK(a->dialogue_id==0x212);next();CHECK(a->kind==EVENT_ENDING);
 fresh();r.party[0].status=0;r.party[0].hp=0;begin(171);next();result(RPG_VICTORY,0);CHECK(a->kind==EVENT_DIALOGUE && a->dialogue_id==0xbf64);next();CHECK(a->kind==EVENT_GOVERNOR_ROOM);event_governor_room_loaded(&e);CHECK(!r.party[0].status && !r.party[0].hp);next();CHECK(a->kind==EVENT_YES_NO && a->dialogue_id==0x272 && e.portrait==53);yes();CHECK(a->dialogue_id==0x212);next();CHECK(a->kind==EVENT_ENDING);
 fresh();e.death_mask=5;begin(174);CHECK(a->dialogue_id==0xb728 && a->character==0);next();CHECK(a->character==2);next();CHECK(a->kind==EVENT_DONE);r.party[0].status=0;e.death_mask=1;begin(174);next();CHECK(a->kind==EVENT_GAME_OVER);
 fresh();begin(179);no();CHECK(a->kind==EVENT_DONE);begin(179);yes();CHECK(a->kind==EVENT_TRAVEL && a->target==0x81);begin(180);yes();CHECK(a->target==0x82);
 for(i=0;i<3;i++)for(j=0;j<3;j++){
   a=event_begin(&e,0x10,181,0,(uint8_t)(i*8+7));CHECK(a->kind==EVENT_TRAVEL_MENU);
   a=event_choose_destination(&e,(uint8_t)j);
   if(i==j){CHECK(a->kind==EVENT_DIALOGUE);next();CHECK(a->kind==EVENT_TRAVEL_MENU);}
   else {CHECK(a->kind==EVENT_YES_NO);no();CHECK(a->kind==EVENT_TRAVEL_MENU);a=event_choose_destination(&e,(uint8_t)j);yes();CHECK(a->kind==EVENT_TRAVEL && a->target==routes[i][j]);}
 }
 printf("{\"checks\":%u,\"passed\":true}\n",checks);return 0;
}
