#include "services.h"
#include <assert.h>
#include <stdio.h>
static RPGState r;
static EventState e;
static ServiceState s;
static const ServiceAction *a;
static unsigned checks;
#define CHECK(x) do{assert(x);++checks;}while(0)
static void fresh(void){rpg_new_game(&r);event_init(&e,&r);}
static void begin(uint8_t type,uint8_t shop){a=service_begin(&s,&e,type,shop);}
static void effects(void){while(a->kind==SERVICE_EFFECT||a->kind==SERVICE_WAIT)a=service_advance(&s);}
static void next(void){a=service_advance(&s);effects();}
static void yes(void){a=service_respond(&s,1);effects();}
static void no(void){a=service_respond(&s,0);}
static void select_(uint8_t v){a=service_select(&s,v);}
int main(void){
 unsigned i;
 fresh();begin(0x12,3);CHECK(a->kind==SERVICE_YES_NO && a->dialogue_id==0xb8c8);
 next();CHECK(a->kind==SERVICE_YES_NO);no();CHECK(a->dialogue_id==0xb951);next();CHECK(a->kind==SERVICE_DONE);
 begin(0x12,3);yes();CHECK(a->dialogue_id==0xb96b && a->character==0);next();CHECK(a->dialogue_id==0xb964);next();CHECK(a->kind==SERVICE_DONE);
 r.party[0].hp=1;begin(0x12,3);yes();CHECK(a->dialogue_id==0xb8e0 && a->number==15);CHECK(r.party[0].hp==1);no();CHECK(a->dialogue_id==0xb951);
 begin(0x12,3);yes();yes();CHECK(a->dialogue_id==0xbd57 && r.party[0].hp==1);next();CHECK(a->kind==SERVICE_DONE);
 r.money=15;begin(0x12,3);yes();yes();CHECK(a->dialogue_id==0xb938 && r.money==0 && r.party[0].hp==16);next();CHECK(a->kind==SERVICE_DONE);
 r.party[0].status=0;r.party[0].hp=0;begin(0x12,3);yes();CHECK(a->dialogue_id==0xb730);next();CHECK(a->dialogue_id==0xb951);
 /* Hospital arithmetic uses original8-bit sum, even when total deficits exceed255. */
 fresh();r.party[0].max_hp=255;r.party[0].hp=1;r.party[0].max_mp=10;r.party[0].mp=0;r.money=8;
 begin(0x12,3);yes();CHECK(a->number==8);yes();CHECK(r.money==0 && r.party[0].hp==255 && r.party[0].mp==10);
 /* Multiple-party hospital loops after refusal/dead/full; successful healing asks another. */
 fresh();rpg_recruit(&r,1);begin(0x13,3);yes();CHECK(a->kind==SERVICE_PARTY && a->dialogue_id==0xb925);
 select_(1);CHECK(a->dialogue_id==0xb96b);next();CHECK(a->kind==SERVICE_PARTY);
 select_(255);CHECK(a->dialogue_id==0xb951);
 r.party[1].hp=1;r.money=100;begin(0x12,3);yes();select_(1);CHECK(a->number==21 && a->character==1);no();CHECK(a->kind==SERVICE_PARTY);
 select_(1);yes();CHECK(r.party[1].hp==22 && r.money==79);next();CHECK(a->dialogue_id==0xb90a);yes();CHECK(a->kind==SERVICE_PARTY);select_(255);next();CHECK(a->kind==SERVICE_DONE);
 /* Church stores originalC317 on entry; declining still gives source EXP guidance. */
 fresh();begin(0x14,0x67);CHECK(e.last_church==0x67 && a->dialogue_id==0xb97f);no();CHECK(a->dialogue_id==0xba3c);next();CHECK(a->dialogue_id==0xba04);next();CHECK(a->dialogue_id==0xba1f && a->number==20 && a->character==0);next();CHECK(a->kind==SERVICE_DONE);
 begin(0x15,2);yes();CHECK(a->dialogue_id==0xba56);next();CHECK(a->dialogue_id==0xba3c);
 fresh();rpg_recruit(&r,1);r.party[1].status=0;r.party[1].hp=0;r.party[1].level=2;r.money=39;
 begin(0x14,2);yes();CHECK(a->kind==SERVICE_PARTY && a->dialogue_id==0xb9d3);select_(1);CHECK(a->dialogue_id==0xb9ee && a->number==40);no();CHECK(a->dialogue_id==0xb9e5);yes();select_(1);yes();CHECK(a->dialogue_id==0xb9b0 && r.money==39 && r.party[1].status==0);next();CHECK(a->dialogue_id==0xbd9f && r.money==39);next();CHECK(a->dialogue_id==0xb9e5);
 r.money=40;yes();select_(1);yes();next();CHECK(a->dialogue_id==0xb9c4 && r.money==0 && r.party[1].status==1 && r.party[1].hp==22);next();CHECK(a->dialogue_id==0xb9e5);no();CHECK(a->dialogue_id==0xba3c);next();next();CHECK(a->character==0);next();CHECK(a->character==1 && a->number==120);next();CHECK(a->kind==SERVICE_DONE);
 r.party[0].level=30;r.party[1].status=0;begin(0x14,2);no();next();next();CHECK(a->dialogue_id==0xbdff && a->character==0);next();CHECK(a->kind==SERVICE_DONE);
 /* Shop option selection is the original confirmation. Failures close, success asks another. */
 fresh();begin(0x16,1);CHECK(a->dialogue_id==0xb7c7);no();CHECK(a->dialogue_id==0xb7e3);
 begin(0x17,1);yes();CHECK(a->kind==SERVICE_GOODS && a->dialogue_id==0xb7f5);select_(255);CHECK(a->dialogue_id==0xb7e3);
 begin(0x16,1);yes();select_(0);CHECK(a->dialogue_id==0xbd57 && !r.inventory_count);next();CHECK(a->kind==SERVICE_DONE);
 r.money=30;begin(0x16,1);yes();select_(0);CHECK(a->dialogue_id==0xb807 && r.money==0 && r.inventory[0]==ItemID_LeatherShield);yes();CHECK(a->kind==SERVICE_GOODS);select_(255);next();CHECK(a->kind==SERVICE_DONE);
 begin(0x18,3);CHECK(a->dialogue_id==0xb832);yes();select_(0);CHECK(a->dialogue_id==0xbd57);
 r.money=500;while(r.inventory_count<24)rpg_add_item(&r,ItemID_Cola);begin(0x16,1);yes();select_(0);CHECK(a->dialogue_id==0xb813 && r.money==500);next();CHECK(a->kind==SERVICE_DONE);
 fresh();r.money=200;
 for(i=0;i<3;i++){begin(0x16,8);yes();select_(2);CHECK(a->dialogue_id==(i==0?0x142:i==1?0x144:0x146));next();CHECK(a->kind==SERVICE_DONE);}
 CHECK(r.money==0 && r.inventory[0]==ItemID_RoadPass && e.secrets_requests==0);
 /* Secondhand BUY/SELL routes and protected/declined sales retain inventory and funds. */
 fresh();rpg_add_item(&r,ItemID_LaconiaPot);rpg_add_item(&r,ItemID_ShortSword);begin(0x1a,7);CHECK(a->dialogue_id==0xb85d);next();CHECK(a->kind==SERVICE_BUY_SELL);select_(0);CHECK(a->kind==SERVICE_GOODS);
 begin(0x1b,7);next();select_(1);CHECK(a->kind==SERVICE_ITEMS && a->dialogue_id==0xb882);select_(0);CHECK(a->dialogue_id==0xbd7e);next();CHECK(a->kind==SERVICE_ITEMS);
 select_(1);CHECK(a->dialogue_id==0xb89a && a->item==ItemID_ShortSword && a->number==15);no();CHECK(a->kind==SERVICE_ITEMS && r.inventory_count==2 && r.money==0);select_(1);yes();CHECK(a->dialogue_id==0xb8bc && r.inventory_count==1 && r.money==15);yes();CHECK(a->kind==SERVICE_ITEMS);select_(255);CHECK(a->dialogue_id==0xb7e3);next();CHECK(a->kind==SERVICE_DONE);
 printf("{\"checks\":%u,\"passed\":true}\n",checks);return 0;
}
