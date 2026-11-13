/* Exact native control flow of ps1.asm LABEL_298D..LABEL_2D0F. */
#ifdef __SDCC
#pragma bank 19
#endif
#include "services.h"
#include <string.h>
enum {
    DONE=0,H_ENTER,H_CHOOSE,H_FULL,H_RETURN,H_COST,H_HEALED,H_ANOTHER,
    C_ENTER,C_CHOOSE,C_COST,C_CAST,C_AGAIN,C_ALIVE,C_BLESS,C_GUIDE,C_EXP,
    B_ENTER,B_CHOOSE,B_AGAIN,S_CHOOSE,S_COST,S_AGAIN,BS_CHOOSE,
    H_FILL,C_REVIVED,C_ALONE_WAIT
};
static const ServiceAction *emit(ServiceState *s,uint8_t kind,uint16_t dialogue,uint8_t stage) {
    s->stage=stage;s->action.kind=kind;s->action.dialogue_id=dialogue;s->action.sound=0;
    s->action.target=s->shop;s->action.character=s->character;
    return &s->action;
}
static const ServiceAction *say(ServiceState *s,uint16_t id,uint8_t stage) {return emit(s,SERVICE_DIALOGUE,id,stage);}
static const ServiceAction *ask(ServiceState *s,uint16_t id,uint8_t stage) {return emit(s,SERVICE_YES_NO,id,stage);}
static const ServiceAction *done(ServiceState *s) {return emit(s,SERVICE_DONE,0,DONE);}
/* GBDK4.5.0 needs the banked stack ABI here for the nested pointer load. */
static uint8_t multiple(ServiceState *s) RPG_BANKED {return (s->events->rpg->joined_mask&14u)!=0;}
static const ServiceAction *hospital_choose(ServiceState *s) {
    if(multiple(s)) return emit(s,SERVICE_PARTY,0xb925,H_CHOOSE);
    emit(s,SERVICE_PARTY,0,H_CHOOSE);return service_select(s,0);
}
static const ServiceAction *hospital_return(ServiceState *s) {
    return multiple(s)?hospital_choose(s):say(s,0xb951,DONE);
}
static const ServiceAction *church_exit(ServiceState *s) {return say(s,0xba3c,C_BLESS);}
static const ServiceAction *church_choose(ServiceState *s) {
    if(multiple(s)) return emit(s,SERVICE_PARTY,0xb9d3,C_CHOOSE);
    s->character=0;return say(s,0xba56,C_ALIVE);
}
static const ServiceAction *goods(ServiceState *s) {return emit(s,SERVICE_GOODS,0xb7f5,B_CHOOSE);}
static const ServiceAction *items(ServiceState *s) {return emit(s,SERVICE_ITEMS,0xb882,S_CHOOSE);}
static const ServiceAction *church_experience(ServiceState *s) {
    RPGState *r=s->events->rpg;
    while(s->exp_character<4u) {
        s->character=s->exp_character++;
        if(!(r->party[s->character].status&1u)) continue;
        if(r->party[s->character].level>=30u) return say(s,0xbdff,C_EXP);
        s->action.number=rpg_exp_to_next(r,s->character);return say(s,0xba1f,C_EXP);
    }
    return done(s);
}
const ServiceAction *service_begin(ServiceState *s,EventState *events,uint8_t type,uint8_t shop) RPG_BANKED {
    memset(s,0,sizeof(*s));s->events=events;s->type=type;s->shop=shop&31u;
    if(type>=0x12u && type<=0x13u) return ask(s,0xb8c8,H_ENTER);
    if(type>=0x14u && type<=0x15u) {events->last_church=shop;return ask(s,0xb97f,C_ENTER);}
    if(type>=0x16u && type<=0x17u) return ask(s,0xb7c7,B_ENTER);
    if(type>=0x18u && type<=0x19u) return ask(s,0xb832,B_ENTER);
    if(type>=0x1au && type<=0x1bu) return say(s,0xb85d,BS_CHOOSE);
    return emit(s,SERVICE_INVALID,0,DONE);
}
const ServiceAction *service_advance(ServiceState *s) RPG_BANKED {
    uint8_t result;
    if(s->action.kind!=SERVICE_DIALOGUE && s->action.kind!=SERVICE_EFFECT && s->action.kind!=SERVICE_WAIT) return &s->action;
    switch(s->stage) {
    case DONE:return done(s);
    case H_RETURN:return hospital_return(s);
    case H_FULL:return multiple(s)?hospital_choose(s):say(s,0xb964,DONE);
    case H_FILL:
        s->events->rpg->party[s->character].hp=s->events->rpg->party[s->character].max_hp;
        s->events->rpg->party[s->character].mp=s->events->rpg->party[s->character].max_mp;
        return say(s,0xb938,H_HEALED);
    case H_HEALED:return multiple(s)?ask(s,0xb90a,H_ANOTHER):done(s);
    case C_CAST:
        result=rpg_revive(s->events->rpg,s->character);
        return say(s,result==RPG_OK?0xb9c4:0xbd9f,result==RPG_OK?C_REVIVED:C_AGAIN);
    case C_REVIVED:
        emit(s,SERVICE_WAIT,0,C_AGAIN);s->action.sound=0xc5;s->action.target=30;return &s->action;
    case C_AGAIN:return ask(s,0xb9e5,C_AGAIN);
    case C_ALIVE:
        if(multiple(s))return ask(s,0xb9e5,C_AGAIN);
        emit(s,SERVICE_WAIT,0,C_ALONE_WAIT);s->action.target=0;return &s->action;
    case C_ALONE_WAIT:return church_exit(s);
    case C_BLESS:return say(s,0xba04,C_GUIDE);
    case C_GUIDE:s->exp_character=0;return church_experience(s);
    case C_EXP:return church_experience(s);
    case S_CHOOSE:return items(s);
    case BS_CHOOSE:return emit(s,SERVICE_BUY_SELL,0,BS_CHOOSE);
    default:return emit(s,SERVICE_INVALID,0,DONE);
    }
}
const ServiceAction *service_respond(ServiceState *s,uint8_t yes) RPG_BANKED {
    /* Materialize before the second argument: GBDK4.5.0 otherwise miscompiles
     * the nested RPG pointer together with s->slot in the SELL call. */
    RPGState *r=s->events->rpg;
    uint8_t result;
    if(s->action.kind!=SERVICE_YES_NO) return &s->action;
    switch(s->stage) {
    case H_ENTER:return yes?hospital_choose(s):say(s,0xb951,DONE);
    case H_COST:
        if(!yes)return hospital_return(s);
        /*2999 commits the quoted (8-bit wrapped) fee before C1, then heals.
         * No target or quote can change while this confirmation is active. */
        if(r->money<s->action.number)return say(s,0xbd57,DONE);
        r->money-=s->action.number;
        emit(s,SERVICE_EFFECT,0,H_FILL);s->action.sound=0xc1;return &s->action;
    case H_ANOTHER:return yes?hospital_choose(s):say(s,0xb951,DONE);
    case C_ENTER:return yes?church_choose(s):church_exit(s);
    case C_COST:return yes?say(s,0xb9b0,C_CAST):ask(s,0xb9e5,C_AGAIN);
    case C_AGAIN:return yes?church_choose(s):church_exit(s);
    case B_ENTER:case B_AGAIN:return yes?goods(s):say(s,0xb7e3,DONE);
    case S_COST:
        if(!yes)return items(s);
        result=rpg_sell(r,s->slot);
        if(result!=RPG_OK)return say(s,0xbd7e,S_CHOOSE);
        return ask(s,0xb8bc,S_AGAIN);
    case S_AGAIN:return yes?items(s):say(s,0xb7e3,DONE);
    default:return emit(s,SERVICE_INVALID,0,DONE);
    }
}
const ServiceAction *service_select(ServiceState *s,uint8_t selection) RPG_BANKED {
    RPGState *r=s->events->rpg;
    RPGCharacter *p;
    const EventAction *event_action;
    uint8_t result,item,count;
    uint16_t price;
    if(s->action.kind==SERVICE_PARTY) {
        if(selection==255u)return s->stage==H_CHOOSE?say(s,0xb951,DONE):church_exit(s);
        if(selection>=4u || !(r->joined_mask&(1u<<selection)))return &s->action;
        s->character=selection;p=&r->party[selection];
        if(s->stage==H_CHOOSE) {
            if(!(p->status&1u))return say(s,0xb730,H_RETURN);
            if(p->hp==p->max_hp && p->mp==p->max_mp)return say(s,0xb96b,H_FULL);
            s->action.number=rpg_hospital_cost(r,selection);return ask(s,0xb8e0,H_COST);
        }
        if(s->stage==C_CHOOSE) {
            if(p->status&1u)return say(s,0xba56,C_ALIVE);
            s->action.number=rpg_revival_cost(r,selection);return ask(s,0xb9ee,C_COST);
        }
    } else if(s->action.kind==SERVICE_GOODS) {
        if(selection==255u)return say(s,0xb7e3,DONE);
        result=rpg_shop_option(s->shop,selection,&item,&price);
        if(result!=RPG_OK)return &s->action;
        s->action.item=item;s->action.number=price;
        if(item==ItemID_Secrets) {
            event_action=event_buy_secret(s->events,s->shop,selection);
            s->action.item=event_action->item;
            say(s,event_action->dialogue_id,DONE);s->action.sound=event_action->sound;return &s->action;
        }
        count=r->inventory_count;result=rpg_buy(r,s->shop,selection);
        if(result==RPG_FULL)return say(s,0xb813,DONE);
        if(result==RPG_NO_MONEY)return say(s,0xbd57,DONE);
        if(result!=RPG_OK)return emit(s,SERVICE_INVALID,0,DONE);
        ask(s,0xb807,B_AGAIN);if(r->inventory_count!=count)s->action.sound=0xb3;return &s->action;
    } else if(s->action.kind==SERVICE_ITEMS) {
        if(selection==255u)return say(s,0xb7e3,DONE);
        if(selection>=r->inventory_count)return &s->action;
        s->slot=selection;s->action.item=r->inventory[selection];
        s->action.number=rpg_sell_price(s->action.item);
        if(!s->action.number)return say(s,0xbd7e,S_CHOOSE);
        return ask(s,0xb89a,S_COST);
    } else if(s->action.kind==SERVICE_BUY_SELL) {
        if(selection==255u)return say(s,0xb7e3,DONE);
        if(selection==0u)return goods(s);
        if(selection==1u)return items(s);
    }
    return &s->action;
}
