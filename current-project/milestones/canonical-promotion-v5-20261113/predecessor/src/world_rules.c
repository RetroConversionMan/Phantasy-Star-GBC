#ifdef __SDCC
#pragma bank 12
#endif
#include "world_rules.h"
#include <string.h>
uint8_t world_interaction_type(uint8_t group,uint8_t type) RPG_BANKED {
    /* Exact original3C52..3CB8, including group8's unconditional override. */
    if(!group&&type==5u)type=4u;
    else if((group==1u||group==7u)&&type==1u)type=5u;
    else if(group==8u)type=6u;
    else if(group==10u&&type==9u)type=8u;
    return type?type:1u;
}
/* Exact pinned-ROM bytes at LABEL_ABF, eight nine-byte route records. */
static const uint8_t ship_routes[8][9]={
 {0x00,0x39,0x43,0x01,0x8b,0x69,0x10,0x53,0x17},
 {0x01,0x37,0x69,0x00,0x91,0x43,0x05,0x17,0x17},
 {0x00,0x47,0x35,0x01,0x27,0x74,0x0f,0x20,0x58},
 {0x00,0x47,0x35,0x02,0x33,0x2d,0x13,0x18,0x1b},
 {0x01,0x53,0x74,0x00,0x1b,0x35,0x07,0x25,0x13},
 {0x01,0x53,0x74,0x02,0x33,0x2d,0x13,0x18,0x1b},
 {0x02,0x5b,0x2d,0x00,0x1b,0x35,0x07,0x25,0x13},
 {0x02,0x5b,0x2d,0x01,0x27,0x74,0x0f,0x20,0x58}
};
uint8_t travel_route(uint8_t tag,WorldAction *departure,WorldAction *arrival,WorldAction *exit) RPG_BANKED {
    uint8_t i,index=(tag&127u)-1u;
    WorldAction *out;
    if(tag<0x81u||tag>0x88u)return 0;
    for(i=0;i<3u;++i) {
        out=i==0?departure:i==1?arrival:exit;memset(out,0,sizeof(*out));
        out->mode=WORLD_ACTION_MAP;out->target=ship_routes[index][i*3u];
        out->a=ship_routes[index][i*3u+1u];out->b=ship_routes[index][i*3u+2u];
    }
    return 1;
}
uint8_t world_special(RPGState *s,uint8_t map,uint8_t meta,uint8_t vehicle,
    uint8_t noah_flag,WorldRuleAction *a) RPG_BANKED {
    uint8_t damage=0,i;
    memset(a,0,sizeof(*a));
    if(meta==0x4cu) {
        if(map==5u&&noah_flag) {a->kind=WORLD_RULE_DUNGEON;a->target=0;a->a=0xde;a->b=0;a->rollback=1;}
    } else if(meta==0x5eu) {
        if(!vehicle&&rpg_find_item(s,ItemID_Compass)==RPG_NO_SLOT) {a->kind=WORLD_RULE_EVENT;a->target=160;a->rollback=1;}
    } else if(meta>=0x5fu&&meta<0x64u) {
        if(vehicle!=8u)damage=2;
    } else if(meta>=0xc3u&&meta<0xc7u) {
        if(!vehicle){a->kind=WORLD_RULE_BATTLE;a->target=EnemyID_AntLion;a->rollback=1;}
    } else if(meta>=0xc7u&&meta<0xd2u) {
        if(rpg_find_item(s,ItemID_GasShield)==RPG_NO_SLOT)damage=30;
    }
    if(damage) {
        for(i=0;i<4u;++i) if(s->party[i].status&1u) {
            s->party[i].hp=s->party[i].hp>damage?s->party[i].hp-damage:0u;
            if(!s->party[i].hp){s->party[i].status=0;a->death_mask|=1u<<i;}
        }
        if(a->death_mask){a->kind=WORLD_RULE_EVENT;a->target=174;}
    }
    return a->kind;
}
