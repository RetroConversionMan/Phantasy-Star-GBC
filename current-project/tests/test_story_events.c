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
int main(void){unsigned i;
 for(i=1;i<=255;i+=254){fresh();e.flags[22]=i;begin(55);CHECK(a->kind==EVENT_DIALOGUE&&a->dialogue_id==0x2a6);next();CHECK(a->kind==EVENT_DUNGEON_FALL&&a->target==34&&a->a==0xe6&&!a->b);}
 fresh();CHECK(e.object_flags[0]==255 && e.object_flags[4]==255);begin(42);no();CHECK(e.object_flags[4]==255);begin(42);yes();CHECK(e.object_flags[4]==0 && a->dialogue_id==0x58);e.object_flags[4]=255;rpg_add_item(&r,ItemID_DungeonKey);begin(42);yes();CHECK(e.object_flags[4]==255);
 fresh();begin(129);CHECK(a->dialogue_id==0xde && e.flags[3]==1);begin(129);CHECK(a->dialogue_id==0xe0 && e.flags[3]==2);
 begin(129);CHECK(a->dialogue_id==0xe2);no();CHECK(a->dialogue_id==0xd4 && e.flags[4]==0);begin(129);yes();CHECK(a->dialogue_id==0xe4 && e.flags[4]==1);
 begin(62);CHECK(a->dialogue_id==0xca);begin(127);CHECK(a->dialogue_id==0xf6 && e.flags[4]==2);begin(127);CHECK(a->kind==EVENT_DONE);
 begin(62);CHECK(a->number==1200);no();CHECK(a->dialogue_id==0xda);begin(62);yes();CHECK(a->dialogue_id==0xd0 && e.flags[4]==2);
 r.money=1200;begin(62);yes();CHECK(a->dialogue_id==0x290 && r.money==0 && e.flags[4]==3);
 begin(62);CHECK(a->dialogue_id==0x292 && e.flags[4]==4);begin(62);CHECK(a->dialogue_id==0x292 && e.flags[4]==5);
 begin(62);CHECK(a->dialogue_id==0xd2 && e.flags[4]==6);next();CHECK(a->dialogue_id==0xd6);next();CHECK(a->dialogue_id==0x104);
 rpg_add_item(&r,ItemID_Hapsby);begin(62);CHECK(a->dialogue_id==0x294 && e.flags[4]==7);begin(62);CHECK(a->dialogue_id==0xd8);
 fresh();begin(126);next();CHECK(!(r.joined_mask&8u));rpg_recruit(&r,1);rpg_recruit(&r,2);rpg_add_item(&r,ItemID_Letter);begin(126);CHECK(a->dialogue_id==0xae);next();CHECK(r.joined_mask==15 && e.flags[6]==1 && rpg_find_item(&r,ItemID_Letter)==255);CHECK(r.party[3].weapon==ItemID_WoodCane && r.party[3].armor==ItemID_WhiteMantle);begin(126);CHECK(a->kind==EVENT_DONE);
 fresh();begin(78);yes();CHECK(e.flags[7]==0 && a->dialogue_id==0x13c);begin(78);no();CHECK(e.flags[7]==1 && a->dialogue_id==0x13e);e.flags[7]=255;begin(78);no();CHECK(e.flags[7]==255);
 begin(85);no();CHECK(!e.flags[8]);begin(85);yes();CHECK(e.flags[8]==1);
 begin(116);yes();CHECK(a->dialogue_id==0x1f2 && !e.flags[9]);r.money=400;begin(116);yes();CHECK(e.flags[9]==1 && r.money==0);
 fresh();r.money=1000;begin(93);yes();CHECK(a->dialogue_id==0x198 && r.money==0);next();CHECK(rpg_find_item(&r,ItemID_GasShield)!=255);
 r.money=1000;begin(146);yes();next();CHECK(r.inventory_count==1 && r.money==0);
 fresh();for(i=0;i<24;i++)rpg_add_item(&r,ItemID_Cola);r.money=1000;begin(93);yes();next();CHECK(a->dialogue_id==0xb671 && r.money==0);no();yes();next();CHECK(rpg_find_item(&r,ItemID_GasShield)==255);
 begin(124);yes();CHECK(a->dialogue_id==0xbd57);r.money=280;begin(124);yes();CHECK(a->dialogue_id==0xb813 && r.money==280);
 rpg_remove_item(&r,0);begin(124);yes();CHECK(a->dialogue_id==0x20a && r.money==0);next();CHECK(rpg_find_item(&r,ItemID_Cake)!=255);
 fresh();begin(142);no();CHECK(a->dialogue_id==0x152);
 begin(142);yes();CHECK(a->dialogue_id==0x14e);next();CHECK(a->dialogue_id==0x150);yes();next();CHECK(a->dialogue_id==0x154);yes();next();CHECK(a->dialogue_id==0x156);no();CHECK(a->dialogue_id==0x15a);no();CHECK(a->dialogue_id==0x15c);next();CHECK(rpg_find_item(&r,ItemID_Crystal)!=255);
 begin(143);yes();CHECK(a->dialogue_id==0x162);begin(143);no();CHECK(a->dialogue_id==0x164);
 fresh();begin(156);yes();CHECK(a->dialogue_id==0x248);rpg_add_item(&r,ItemID_AmberEye);begin(156);no();CHECK(r.inventory[0]==ItemID_AmberEye);begin(156);yes();CHECK(a->dialogue_id==0x244 && r.inventory[0]==ItemID_EclipseTorch);
 fresh();begin(163);CHECK(a->kind==EVENT_MENU);rpg_add_item(&r,ItemID_Alsulin);a=event_use_story_item(&e,0,1);next();CHECK(a->dialogue_id==0xb35c && r.inventory_count==1);
 r.party[0].status=0;a=event_use_story_item(&e,0,0);next();CHECK(a->dialogue_id==0xb3e3 && r.inventory_count==1);
 r.party[0].status=1;begin(1);a=event_use_story_item(&e,0,0);next();CHECK(a->dialogue_id==0xb569);
 begin(163);a=event_use_story_item(&e,0,0);next();CHECK(a->dialogue_id==0xb3b1 && r.inventory_count==1);next();CHECK((r.joined_mask&4u) && e.flags[10]==255 && e.object_flags[0]==0 && r.inventory_count==0);CHECK(r.party[2].weapon==ItemID_IronAxe && r.party[2].armor==ItemID_IronArmor);
 fresh();begin(161);rpg_add_item(&r,ItemID_Polymaterial);a=event_use_story_item(&e,0,0);next();next();CHECK(a->dialogue_id==0x12c && r.inventory_count==0);next();CHECK(r.inventory[0]==ItemID_Hapsby);
 rpg_add_item(&r,ItemID_Polymaterial);a=event_use_story_item(&e,1,0);next();next();CHECK(a->dialogue_id==0xb569 && r.inventory_count==1);
 e.flags[8]=1;begin(162);a=event_search(&e,0,0,0);CHECK(a->dialogue_id==0x178);next();CHECK(rpg_find_item(&r,ItemID_Hovercraft)!=255);a=event_search(&e,0,0,0);CHECK(a->dialogue_id==0xb569);
 fresh();e.flags[7]=1;a=event_search(&e,7,30,32);CHECK(a->dialogue_id==0xb592 && e.flags[7]==255);next();CHECK(r.inventory[0]==ItemID_Flute);
 fresh();e.flags[7]=1;for(i=0;i<24;i++)rpg_add_item(&r,ItemID_Cola);a=event_search(&e,7,30,32);next();no();yes();next();CHECK(e.flags[7]==255 && rpg_find_item(&r,ItemID_Flute)==255);a=event_search(&e,7,30,32);CHECK(a->dialogue_id==0xb569);
 fresh();e.flags[9]=1;a=event_search(&e,1,72,36);next();CHECK(r.inventory[0]==ItemID_MirrorShield);a=event_search(&e,1,72,36);CHECK(a->dialogue_id==0xb569);
 printf("{\"checks\":%u,\"passed\":true}\n",checks);return 0;
}
