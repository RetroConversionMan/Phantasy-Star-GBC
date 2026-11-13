#include "events.h"
#include "dialogue.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static unsigned checks;
#define CHECK(x) do{assert(x);checks++;}while(0)
static RPGState rpg;
static EventState events;
static const EventAction *a;
static void fresh(void){rpg_new_game(&rpg);event_init(&events,&rpg);}
static void begin(uint8_t id){a=event_begin(&events,0x0c,id,0,4);}
static void next(void){a=event_advance(&events);}
static void answer(uint8_t yes){a=event_respond(&events,yes);}
int main(void){
    unsigned i,pages,total_pages=0,simple=0;
    DialogueCursor cursor;
    fresh();rpg.party[0].hp=1;
    begin(1);CHECK(a->dialogue_id==2 && events.flags[1]==1);CHECK(rpg.party[0].hp==1);
    next();CHECK(a->dialogue_id==6);next();
    /* Source48DF emits C1 before the living-party rest continuation. */
    CHECK(a->kind==EVENT_PRESENTATION && a->target==EVENT_PRESENT_SUEL_HEAL && a->sound==0xc1 && rpg.party[0].hp==1);
    next();CHECK(a->kind==EVENT_DONE && rpg.party[0].hp==16);
    begin(1);CHECK(a->dialogue_id==6);rpg.party[0].status=0;rpg.party[0].hp=0;next();CHECK(rpg.party[0].hp==0);
    CHECK(a->kind==EVENT_PRESENTATION && a->sound==0xc1);next();CHECK(a->kind==EVENT_DONE && rpg.party[0].hp==0);
    fresh();begin(2);CHECK(a->dialogue_id==8);next();CHECK(a->dialogue_id==0x10 && events.flags[2]==1);CHECK(rpg.inventory[0]==ItemID_LaconiaPot);
    next();begin(2);CHECK(a->dialogue_id==0x10 && rpg.inventory_count==1);
    /* Full inventory: decline replacement, confirm leaving item. Flag must remain clear. */
    fresh();for(i=0;i<24;i++)rpg_add_item(&rpg,ItemID_Cola);
    begin(2);next();CHECK(a->kind==EVENT_YES_NO && a->dialogue_id==0xb671);
    next();CHECK(a->kind==EVENT_YES_NO);answer(0);CHECK(a->dialogue_id==0xb6c1);
    answer(1);CHECK(a->dialogue_id==0xb6d0);next();CHECK(a->dialogue_id==0x10 && events.flags[2]==0);CHECK(rpg.inventory_count==24);
    /* Full inventory with preexisting pot still sets Nekise flag after declined addition. */
    rpg.inventory[0]=ItemID_LaconiaPot;begin(2);next();answer(0);answer(1);next();CHECK(events.flags[2]==1);
    /* Cancel selection loops; protected items reject and reselect; overwrite keeps slot order. */
    fresh();for(i=0;i<24;i++)rpg_add_item(&rpg,ItemID_Cola);
    rpg.inventory[0]=ItemID_LaconiaPot;
    begin(2);next();answer(1);CHECK(a->kind==EVENT_REPLACE_ITEM);
    a=event_replace_item(&events,255);CHECK(a->dialogue_id==0xb671);
    answer(1);a=event_replace_item(&events,0);CHECK(a->dialogue_id==0xb6de);
    next();CHECK(a->kind==EVENT_REPLACE_ITEM);
    a=event_replace_item(&events,3);CHECK(a->dialogue_id==0xb69e && rpg.inventory[3]==ItemID_Cola);
    next();CHECK(a->dialogue_id==0xb6ad && rpg.inventory[3]==ItemID_LaconiaPot);
    next();CHECK(events.flags[2]==1 && rpg.inventory_count==24 && rpg.inventory[4]==ItemID_Cola);
    fresh();begin(11);CHECK(a->dialogue_id==0x20);begin(12);CHECK(a->dialogue_id==0x22);
    rpg_add_item(&rpg,ItemID_RoadPass);begin(11);next();CHECK(a->kind==EVENT_TRANSITION && a->target==1);
    a=event_begin(&events,12,11,0,5);next();CHECK(a->target==1);
    begin(27);next();CHECK(a->target==4);begin(28);next();CHECK(a->target==5);
    begin(19);CHECK(a->kind==EVENT_YES_NO && a->dialogue_id==0x70);answer(0);CHECK(a->dialogue_id==0x20);
    begin(19);answer(1);CHECK(a->dialogue_id==0xce);
    rpg_add_item(&rpg,ItemID_Passport);begin(20);answer(1);CHECK(a->dialogue_id==0x24);next();CHECK(a->kind==EVENT_TRANSITION && a->target==6);
    events.packed_y=0x60;begin(26);answer(1);next();CHECK(a->kind==EVENT_MAP_TRANSITION && a->target==5 && a->a==0x21 && a->b==0x15);
    events.packed_y=0x40;begin(26);answer(1);next();CHECK(a->a==0x20 && a->b==0x17);
    events.flags[4]=7;begin(19);CHECK(a->dialogue_id==0x19e);next();CHECK(a->dialogue_id==0x1a0 && rpg_find_item(&rpg,ItemID_Passport)==255);
    begin(20);next();CHECK(a->kind==EVENT_DONE);
    /* Passport questionnaire preserves disqualifying answers and charges before item award. */
    fresh();begin(29);answer(0);CHECK(a->dialogue_id==0x7c);
    begin(29);answer(1);answer(1);CHECK(a->dialogue_id==0x7e);
    begin(29);answer(1);answer(0);answer(1);CHECK(a->dialogue_id==0x7e);
    begin(29);answer(1);answer(0);answer(0);CHECK(a->number==100);answer(1);CHECK(a->dialogue_id==0xbd57);
    rpg.money=100;begin(29);answer(1);answer(0);answer(0);answer(1);CHECK(a->dialogue_id==0x7a && rpg.money==0);next();CHECK(rpg_find_item(&rpg,ItemID_Passport)!=255);
    rpg.money=100;begin(29);answer(1);answer(0);answer(0);answer(1);next();CHECK(rpg.inventory_count==1 && rpg.money==0);
    /* Myau joins only after accepted pot exchange; recovery item enters shared inventory. */
    fresh();begin(54);answer(1);CHECK(a->dialogue_id==0x94 && rpg.joined_mask==1);
    begin(54);answer(0);CHECK(a->dialogue_id==0x7c);
    rpg_add_item(&rpg,ItemID_LaconiaPot);begin(54);answer(0);CHECK(a->dialogue_id==0x96);answer(0);CHECK(rpg_find_item(&rpg,ItemID_LaconiaPot)!=255);
    begin(54);answer(0);answer(1);CHECK(a->dialogue_id==0x9a && rpg_find_item(&rpg,ItemID_LaconiaPot)==255);next();CHECK(rpg.joined_mask==3 && rpg_find_item(&rpg,ItemID_Alsulin)!=255);
    begin(54);CHECK(a->dialogue_id==0x28a);
    /* Secrets: full/funds checks precede counters, refusals do not charge, third request buys pass. */
    fresh();a=event_buy_secret(&events,8,2);CHECK(a->dialogue_id==0xbd57 && events.secrets_requests==0);
    rpg.money=200;a=event_buy_secret(&events,8,2);CHECK(a->dialogue_id==0x142 && rpg.money==200 && events.secrets_requests==1);
    a=event_buy_secret(&events,8,2);CHECK(a->dialogue_id==0x144 && rpg.money==200 && events.secrets_requests==2);
    a=event_buy_secret(&events,8,2);CHECK(a->dialogue_id==0x146 && rpg.money==0 && events.secrets_requests==0 && rpg_find_item(&rpg,ItemID_RoadPass)!=255);
    rpg.money=200;for(i=0;i<3;i++)a=event_buy_secret(&events,8,2);CHECK(a->dialogue_id==0x142 && events.secrets_requests==1 && rpg.inventory_count==1 && rpg.money==200);
    while(rpg.inventory_count<24)rpg_add_item(&rpg,ItemID_Cola);
    a=event_buy_secret(&events,8,2);CHECK(a->dialogue_id==0xb813 && events.secrets_requests==1);
    fresh();begin(183);CHECK(a->kind==EVENT_UNIMPLEMENTED);
    for(i=1;i<=182;i++){begin((uint8_t)i);if(a->kind==EVENT_DIALOGUE && events.stage==0)simple++;}
    CHECK(simple>=111);
    /* Every extracted record must render to a genuine source terminator in bounded pages. */
    for(i=0;i<dialogue_ref_count;i++){
        CHECK(dialogue_open(&cursor,dialogue_refs[i].id));
        memcpy(cursor.character,"NOAH",5);memcpy(cursor.enemy,"SWORM",6);dialogue_item_name(ItemID_RoadPass,cursor.item);cursor.number=65535;
        pages=0;
        while(dialogue_next_page(&cursor)){
            CHECK(strlen(cursor.lines[0])==18 && strlen(cursor.lines[1])==18);
            CHECK(++pages<100);total_pages++;
        }
        CHECK(cursor.done && cursor.terminator==dialogue_refs[i].terminator);
    }
    CHECK(!dialogue_open(&cursor,3));CHECK(!dialogue_next_page(&cursor));
    CHECK(dialogue_open(&cursor,2));CHECK(dialogue_next_page(&cursor));
    CHECK(!strncmp(cursor.lines[0],"I'M SUELO. I KNOW",16));
    CHECK(!strncmp(cursor.lines[1],"HOW YOU MUST FEEL,",18));
    CHECK(dialogue_open(&cursor,0x1e));CHECK(dialogue_next_page(&cursor));
    CHECK(!strncmp(cursor.lines[0],"UNLESS YOU HOPE TO",17));
    CHECK(!strncmp(cursor.lines[1],"DIE, YOU HAD BEST",16));
    printf("{\"checks\":%u,\"dialogue_records\":%u,\"rendered_pages\":%u,\"passed\":true}\n",checks,dialogue_ref_count,total_pages);
    return 0;
}
