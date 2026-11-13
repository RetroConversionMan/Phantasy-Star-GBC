/* Native branches of ps1.asm LABEL_474B dispatch. Never substitute generic story effects. */
#ifdef __SDCC
#pragma bank 7
#endif
#include "events.h"
#include <string.h>
extern const uint16_t event_simple_dialogue[183];
enum {
    DR_KILL=70,DR_FIGHT,GOV_GIVE,GOV_CHECK,GOV_SLEEP,GOV_NIGHTMARE,GOV_WAKE,GOV_REST,
    TARZ_CHECK=80,TARZ_FIGHT,TARZ_REWARD,SHADOW_FIGHT,LASSIC_FIGHT,
    ROBOT_FIGHT=90,ROBOT_WARP,GUARD_RETREAT,SPECIAL_FIGHT,GOTHIC_TRANS,
    DARK_SCENE,DARK_FIGHT,ENDING_PROMPT,ENDING_RUN,DEATH_NEXT,TRAVEL_AGAIN,TRAVEL_QUESTION,
    SUEL_HEAL=190,GUEST_HEAL,GUEST_DONE,NIGHTMARE_BATTLE
};

static const EventAction *emit(EventState *s,uint8_t kind,uint16_t dialogue,uint8_t stage) {
    s->stage=stage;s->action.kind=kind;s->action.dialogue_id=dialogue;s->action.sound=0;
    return &s->action;
}
static const EventAction *finish(EventState *s) {return emit(s,EVENT_DONE,0,0);}
/* Keep the stack-based banked ABI: GBDK4.5.0 emitted an incorrect high-byte
 * pointer load for the register-argument version, caught by native Nekise tests. */
static uint8_t has(EventState *s,uint8_t item) RPG_BANKED {return rpg_find_item(s->rpg,item)!=255;}
static const EventAction *say(EventState *s,uint16_t id,uint8_t next) {return emit(s,EVENT_DIALOGUE,id,next);}
static const EventAction *ask(EventState *s,uint16_t id,uint8_t next) {return emit(s,EVENT_YES_NO,id,next);}
static const EventAction *gate(EventState *s,uint8_t index) {
    s->action.target=index;
    return index?emit(s,EVENT_TRANSITION,0,0):finish(s);
}
static const EventAction *resume(EventState *s) {
    s->stage=s->resume_stage;s->action.kind=EVENT_DIALOGUE;
    return event_advance(s);
}
static const EventAction *give(EventState *s,uint8_t item,uint8_t next) {
    s->pending_item=item;s->action.item=item;s->resume_stage=next;
    if(rpg_add_item(s->rpg,item)==RPG_OK) {resume(s);s->action.sound=0xb3;return &s->action;}
    return ask(s,0xb671,200);
}
static const EventAction *select_replacement(EventState *s) {
    s->action.item=s->pending_item;
    return emit(s,EVENT_REPLACE_ITEM,0xb68c,202);
}
static const EventAction *luveno_ready(EventState *s) {
    if(!has(s,ItemID_Hapsby))return say(s,0x104,0);
    s->flags[4]=7;return say(s,0x294,0);
}
static const EventAction *battle(EventState *s,uint8_t enemy) {
    s->prepared_enemy=enemy;s->action.target=enemy;return emit(s,EVENT_BATTLE,0,0);
}
static void remember_status(EventState *s) {
    uint8_t i;for(i=0;i<3u;++i)s->battle.status_snapshot[i]=s->rpg->party[i].status;
}
static void restore_status(EventState *s) {
    uint8_t i;for(i=0;i<3u;++i)s->rpg->party[i].status=s->battle.status_snapshot[i];
}
static const EventAction *scene(EventState *s,uint8_t id,uint8_t next) {
    s->action.target=id;return emit(s,EVENT_SCENE,0,next);
}
static const EventAction *present(EventState *s,uint8_t effect,uint8_t next) {
    s->action.target=effect;return emit(s,EVENT_PRESENTATION,0,next);
}
static const EventAction *death_next(EventState *s) {
    uint8_t i;
    while(s->death_cursor<4u){i=s->death_cursor++;if(s->death_mask&(1u<<i)){s->action.character=i;return say(s,0xb728,DEATH_NEXT);}}
    for(i=0;i<4u;++i)if(s->rpg->party[i].status&1u)return finish(s);
    return emit(s,EVENT_GAME_OVER,0,0);
}
void event_init(EventState *s,RPGState *rpg) RPG_BANKED {
    memset(s,0,sizeof(*s));s->rpg=rpg;
    s->object_flags[0]=255;s->object_flags[4]=255; /* LABEL_5E8. */
}
const EventAction *event_begin(EventState *s,uint8_t type,uint8_t id,uint8_t portrait,uint8_t map_id) RPG_BANKED {
    s->event=id;s->type=type;s->portrait=portrait;s->map_id=map_id;s->stage=0;
    memset(&s->action,0,sizeof(s->action));
    memset(&s->battle,0,sizeof(s->battle));s->prepared_enemy=0;
    if(type>=0x12 && type<=0x1b) {
        s->action.target=id&31;
        if(type<=0x13) return emit(s,EVENT_HOSPITAL,0xb8c8,0);
        if(type<=0x15) return emit(s,EVENT_CHURCH,0,0);
        if(type<=0x19) return emit(s,EVENT_SHOP,0xb7c7,0);
        return emit(s,EVENT_SELL,0,0);
    }
    if(!id) return emit(s,EVENT_MENU,0,0);
    if(id>182) return emit(s,EVENT_UNIMPLEMENTED,0,0);
    if(event_simple_dialogue[id]) return say(s,event_simple_dialogue[id],0);
    switch(id) {
    case 1: /* Suelo marks introduction before speaking, then heals living members only. */
        if(!s->flags[1]) {s->flags[1]=1;return say(s,2,1);}
        return say(s,6,2);
    case 2: return s->flags[2]?say(s,0x10,0):say(s,8,3);
    case 8: return ask(s,0x62,8);
    case 11:case 12:
        if(!has(s,ItemID_RoadPass)) return say(s,id==11?0x20:0x22,0);
        return say(s,0x24,10);
    case 19:case 20:case 26:
        if(s->flags[4]>=7) return say(s,0x19e,21);
        return ask(s,0x70,20);
    case 22:
        s->prepared_enemy=EnemyID_DrMad;
        return s->rpg->party[1].status?ask(s,0x296,22):say(s,0x29a,DR_FIGHT);
    case 27:case 28:
        if(!has(s,ItemID_RoadPass)) return say(s,id==27?0x20:0x22,0);
        return say(s,0x24,10);
    case 29: return ask(s,0x72,30); /* Passport application, LABEL_4AD3. */
    case 30: return say(s,(s->rpg->joined_mask&14)?0x3a:0x34,0);
    case 31: return say(s,(s->rpg->joined_mask&14)?0x40:0x3c,0);
    case 42:return ask(s,0x56,42);
    case 43: return ask(s,0x5c,43);
    case 54: /* Myau exchange: original Party_curr_num test, price question is dialogue only. */
        if(s->rpg->joined_mask&14) return say(s,0x28a,0);
        s->action.number=10;return ask(s,0x92,50);
    case 55:
        if(s->flags[22])return say(s,0x2a6,55);
        s->portrait=0x35;
        if((s->rpg->joined_mask&8u)||has(s,ItemID_Letter))return say(s,0x29e,56);
        return say(s,0xa4,GOV_GIVE);
    case 57: return say(s,0xb6,57);
    case 60:case 61: return ask(s,0xba,60);
    case 62:
        if(!s->flags[4])return finish(s);
        s->portrait=0x34;
        if(s->flags[4]>=7)return say(s,0xd8,0);
        if(s->flags[4]==1)return say(s,0xca,0);
        if(s->flags[4]==2){s->action.number=1200;return ask(s,0x28c,62);}
        if(s->flags[4]<5){++s->flags[4];return say(s,0x292,0);}
        if(s->flags[4]==5){s->flags[4]=6;return say(s,0xd2,62);}
        return luveno_ready(s);
    case 63:if(s->flags[4]<2)return finish(s);s->portrait=0x10;return say(s,0xdc,0);
    case 67: return ask(s,0x114,67);
    case 78:return ask(s,0x13a,78);
    case 85:return ask(s,0x172,85);
    case 93:case 146:s->action.number=1000;return ask(s,0x194,93);
    case 108:return ask(s,0x1d6,108);
    case 111:s->action.number=10;return say(s,0x1e0,0);
    case 116:s->action.number=400;return ask(s,0x1ea,116);
    case 117:return ask(s,0x1fa,117);
    case 120:return ask(s,0x204,120);
    case 121:case 131:return ask(s,0xba,60);
    case 124:s->action.number=280;return ask(s,0x24a,124);
    case 125:s->prepared_enemy=8;return say(s,(s->rpg->joined_mask&8u)?0xb2:0xac,0);
    case 126:if(s->rpg->joined_mask&8u)return finish(s);s->portrait=0x3b;return say(s,0xae,126);
    case 127:
        if(s->flags[4]>=2)return finish(s);
        s->portrait=0x10;
        if(s->flags[4]==1){s->flags[4]=2;return say(s,0xf6,0);}
        return say(s,0xdc,0);
    case 129:
        if(s->flags[4])return finish(s);
        s->portrait=0x34;
        if(s->flags[3]<2)return say(s,s->flags[3]++?0xe0:0xde,0);
        return ask(s,0xe2,129);
    case 130:s->prepared_enemy=46;return ask(s,0xe6,130);
    case 132:return ask(s,0xec,132);
    case 135:return ask(s,0xf2,135);
    case 136:s->prepared_enemy=22;return say(s,0xf4,0);
    case 142:return ask(s,0x148,142);
    case 143:return ask(s,0x160,148);
    case 147:s->prepared_enemy=46;return ask(s,0x21c,147);
    case 155:s->prepared_enemy=46;return ask(s,0x9c,155);
    case 156:return ask(s,0x23e,156);
    case 157:
        s->prepared_enemy=EnemyID_Tarzimal;
        if(s->rpg->party[3].armor==ItemID_FradeMantle||has(s,ItemID_FradeMantle))return say(s,0x258,0);
        if(!(s->rpg->joined_mask&8u))return ask(s,0x25a,157);
        return say(s,0x24c,TARZ_CHECK);
    case 158:s->prepared_enemy=EnemyID_Shadow;return say(s,0x262,SHADOW_FIGHT);
    case 159:
        if(s->flags[22])return finish(s);
        s->prepared_enemy=EnemyID_Lassic;return ask(s,0x26c,159);
    case 160:return say(s,0xb7aa,0);
    case 161:case 162:case 163:case 175:case 176:case 182:return emit(s,EVENT_MENU,0,0);
    case 164:s->prepared_enemy=43;return say(s,0x234,0);
    case 166:s->prepared_enemy=27;s->action.target=0xc3;s->action.a=0;return emit(s,EVENT_DUNGEON_CELL,0,166);
    case 167:s->battle.options=EVENT_BATTLE_ZERO_MONEY;return battle(s,38);
    case 168:return ask(s,0x228,168);
    case 169:s->prepared_enemy=8;return say(s,0x212,0);
    case 170:return s->flags[4]<7?say(s,0x282,0):say(s,0x284,GOTHIC_TRANS);
    case 171:s->prepared_enemy=EnemyID_DarkFalz;return emit(s,EVENT_DARK_FALZ_REVEAL,0,DARK_FIGHT);
    case 172:return emit(s,EVENT_GOVERNOR_ROOM,0,ENDING_PROMPT);
    case 174:s->death_cursor=0;return death_next(s);
    case 179:return ask(s,0xbdce,179);
    case 180:return ask(s,0xbde6,180);
    case 181:return emit(s,EVENT_TRAVEL_MENU,0xb754,0);
    default: return emit(s,EVENT_UNIMPLEMENTED,0,0);
    }
}
const EventAction *event_advance(EventState *s) RPG_BANKED {
    uint8_t slot;
    /* Await explicit responses/selections; accidental advance cannot approve a purchase. */
    if(s->action.kind==EVENT_YES_NO || s->action.kind==EVENT_REPLACE_ITEM) return &s->action;
    switch(s->stage) {
    case 0:return finish(s);
    case 1:return say(s,6,2);
    case 2:
        present(s,EVENT_PRESENT_SUEL_HEAL,SUEL_HEAL);s->action.sound=0xc1;return &s->action;
    case SUEL_HEAL:rpg_rest(s->rpg);return finish(s);
    case 3:return give(s,ItemID_LaconiaPot,4);
    case 4:
        if(has(s,ItemID_LaconiaPot)) s->flags[2]=1;
        return say(s,0x10,0);
    case 10:
        if(s->event==27) return gate(s,4);
        if(s->event==28) return gate(s,5);
        return gate(s,(uint8_t)(((s->map_id>>1)-1)&3));
    case 21:
        slot=rpg_find_item(s->rpg,ItemID_Passport);
        if(slot==255) return finish(s);
        rpg_remove_item(s->rpg,slot);return say(s,0x1a0,0);
    case 22:return gate(s,6);
    case 26:
        s->action.target=5;s->action.a=s->packed_y==0x60?0x21:0x20;
        s->action.b=s->packed_y==0x60?0x15:0x17;
        return emit(s,EVENT_MAP_TRANSITION,0,0);
    case 34:
        if(has(s,ItemID_Passport)) return finish(s);
        return give(s,ItemID_Passport,0);
    case 52:
        rpg_recruit(s->rpg,1);
        return give(s,ItemID_Alsulin,64);
    case 53:return emit(s,EVENT_GOVERNOR_ROOM,0,ENDING_PROMPT);
    case 55:
        s->action.target=0x22;s->action.a=0xe6;s->action.b=0;return emit(s,EVENT_DUNGEON_FALL,0,0);
    case 56:return say(s,0xaa,0);
    case 57:return present(s,EVENT_PRESENT_GUEST_SLEEP,GUEST_HEAL);
    case GUEST_HEAL:
        rpg_rest(s->rpg);present(s,EVENT_PRESENT_GUEST_WAKE,GUEST_DONE);s->action.sound=0xc1;return &s->action;
    case GUEST_DONE:return say(s,0xb8,0);
    case 58:return emit(s,EVENT_GOVERNOR_ROOM,0,59);
    case 59:s->portrait=0x35;return say(s,0xaa,0);
    case 64:s->action.target=1;return emit(s,EVENT_CUTSCENE,0,0);
    case 62:
        if(has(s,ItemID_Hapsby))return luveno_ready(s);
        return say(s,0xd6,63);
    case 63:return luveno_ready(s);
    case DR_KILL:s->rpg->party[1].status=0;s->rpg->party[1].hp=0;return say(s,0x298,DR_FIGHT);
    case DR_FIGHT:
        if((s->rpg->joined_mask&14u)&&!has(s,ItemID_LaconiaPot)) {
            s->battle.options|=EVENT_BATTLE_OVERRIDE_ITEM;s->battle.item_reward=ItemID_LaconiaPot;s->battle.flag_index=24;
        }
        return battle(s,EnemyID_DrMad);
    case GOV_GIVE:return give(s,ItemID_Letter,GOV_CHECK);
    case GOV_CHECK:return has(s,ItemID_Letter)?say(s,0x29c,GOV_SLEEP):finish(s);
    case GOV_SLEEP:return present(s,EVENT_PRESENT_NIGHTMARE_SCENE,GOV_NIGHTMARE);
    case GOV_NIGHTMARE:return say(s,0x2a0,GOV_WAKE);
    case GOV_WAKE:return present(s,EVENT_PRESENT_NIGHTMARE_HOLD,NIGHTMARE_BATTLE);
    case NIGHTMARE_BATTLE:remember_status(s);return battle(s,EnemyID_Saccubus);
    case GOV_REST:return say(s,0x2a2,58);
    case TARZ_CHECK:return s->rpg->party[3].status?say(s,0x24e,TARZ_FIGHT):say(s,0x2a8,0);
    case TARZ_FIGHT:
        remember_status(s);s->battle.noah_hp=s->rpg->party[3].hp;
        s->rpg->party[0].status=0;s->rpg->party[1].status=0;s->rpg->party[2].status=0;
        return battle(s,EnemyID_Tarzimal);
    case TARZ_REWARD:return give(s,ItemID_FradeMantle,0);
    case SHADOW_FIGHT:return battle(s,EnemyID_Shadow);
    case LASSIC_FIGHT:return battle(s,EnemyID_Lassic);
    case ROBOT_FIGHT:return battle(s,46);
    case ROBOT_WARP:s->action.target=0x15;s->action.a=0x9c;s->action.b=1;return emit(s,EVENT_DUNGEON,0,0);
    case GUARD_RETREAT:return emit(s,EVENT_DUNGEON_BACK,0,0);
    case GOTHIC_TRANS:
        s->action.target=7;s->action.a=0x1b;s->action.b=s->camera_x_low>=0x40?0x1b:0x1d;
        return emit(s,EVENT_MAP_TRANSITION,0,0);
    case DARK_SCENE:return scene(s,0x20,DARK_FIGHT);
    case DARK_FIGHT:return battle(s,EnemyID_DarkFalz);
    case ENDING_PROMPT:s->portrait=0x35;return ask(s,0x272,172);
    case ENDING_RUN:return emit(s,EVENT_ENDING,0,0);
    case DEATH_NEXT:return death_next(s);
    case TRAVEL_AGAIN:return emit(s,EVENT_TRAVEL_MENU,0xb754,0);
    case 93:
        return has(s,ItemID_GasShield)?finish(s):give(s,ItemID_GasShield,0);
    case 124:return has(s,ItemID_Cake)?finish(s):give(s,ItemID_Cake,0);
    case 126:
        slot=rpg_find_item(s->rpg,ItemID_Letter);
        if(slot==255)return finish(s);
        rpg_remove_item(s->rpg,slot);s->flags[6]=1;rpg_recruit(s->rpg,3);s->action.target=3;return emit(s,EVENT_CUTSCENE,0,0);
    case 142:return ask(s,0x150,143);
    case 143:return ask(s,0x154,144);
    case 144:return ask(s,0x156,145);
    case 146:return has(s,ItemID_Crystal)?finish(s):give(s,ItemID_Crystal,0);
    case 156:return say(s,0x244,0);
    case 166:return say(s,0x238,0);
    case 170: /* ItemUse_Alsulin: Myau alone cannot open the bottle. */
        if(s->item_in_battle)return say(s,0xb35c,0);
        if(!(s->rpg->party[0].status|s->rpg->party[2].status|s->rpg->party[3].status))return say(s,0xb3e3,0);
        if(s->event!=0xa3)return say(s,0xb569,0);
        return say(s,0xb3b1,171);
    case 171:
        rpg_remove_item(s->rpg,s->selected_slot);rpg_recruit(s->rpg,2);
        s->object_flags[0]=0;s->flags[10]=255;s->action.target=2;return emit(s,EVENT_CUTSCENE,0,0);
    case 172: /* ItemUse_Polymaterial. */
        if(s->item_in_battle)return say(s,0xb35c,0);
        if(!(s->rpg->party[0].status|s->rpg->party[2].status|s->rpg->party[3].status))return say(s,0xb3e3,0);
        if(s->event!=0xa1)return say(s,0xb3f9,0);
        return say(s,0xb3b1,173);
    case 173:
        rpg_remove_item(s->rpg,s->selected_slot);
        if(has(s,ItemID_Hapsby))return say(s,0xb569,0);
        return say(s,0x12c,174);
    case 174:return give(s,ItemID_Hapsby,0);
    case 177:return give(s,s->pending_item,0);
    case 178:return give(s,ItemID_Hovercraft,0);
    case 203:return resume(s);
    case 204:return select_replacement(s);
    case 205:
        /* Original overwrite follows the discarded-item message; count/order remain unchanged. */
        if(rpg_replace_item(s->rpg,s->selected_slot,s->pending_item)!=RPG_OK) return select_replacement(s);
        s->action.item=s->pending_item;say(s,0xb6ad,203);s->action.sound=0xb3;return &s->action;
    default:return emit(s,EVENT_UNIMPLEMENTED,0,0);
    }
}
const EventAction *event_respond(EventState *s,uint8_t yes) RPG_BANKED {
    uint8_t slot;
    if(s->action.kind!=EVENT_YES_NO) return &s->action;
    switch(s->stage) {
    case 8:s->action.number=3;return say(s,yes?0x60:0x64,0);
    case 20:
        if(!yes) return say(s,0x20,0);
        if(!has(s,ItemID_Passport)) return say(s,0xce,0);
        return say(s,0x24,s->event==26?26:22);
    case 22:
        if(!yes)return say(s,0x29a,DR_FIGHT);
        s->action.character=1;say(s,0xb728,DR_KILL);s->action.sound=0xae;return &s->action;
    case 30:return yes?ask(s,0x74,31):say(s,0x7c,0);
    case 31:return yes?say(s,0x7e,0):ask(s,0x76,32);
    case 32:
        if(yes) return say(s,0x7e,0);
        s->action.number=100;return ask(s,0x78,33);
    case 33:
        if(!yes) return say(s,0x7c,0);
        if(s->rpg->money<100) return say(s,0xbd57,0);
        s->rpg->money-=100;return say(s,0x7a,34);
    case 42:
        if(!yes)return say(s,0x60,0);
        if(!has(s,ItemID_DungeonKey))s->object_flags[4]=0;
        return say(s,0x58,0);
    case 43:return say(s,yes?0x60:0x5e,0);
    case 50:
        if(yes) return say(s,0x94,0);
        return has(s,ItemID_LaconiaPot)?ask(s,0x96,51):say(s,0x7c,0);
    case 51:
        if(!yes) return say(s,0x7c,0);
        slot=rpg_find_item(s->rpg,ItemID_LaconiaPot);
        if(slot==255) return say(s,0x7c,0);
        rpg_remove_item(s->rpg,slot);return say(s,0x9a,52);
    case 60:
        if(!yes) return say(s,s->event==121?0x20c:0xc2,0);
        slot=rpg_find_item(s->rpg,ItemID_Cola);
        if(slot==255) return say(s,s->event==131?0xce:0x20e,0);
        rpg_remove_item(s->rpg,slot);return say(s,s->event==60?0xbc:s->event==61?0xc4:s->event==121?0x20a:0xea,0);
    case 62:
        if(!yes)return say(s,0xda,0);
        if(s->rpg->money<1200)return say(s,0xd0,0);
        s->rpg->money-=1200;s->flags[4]=3;return say(s,0x290,0);
    case 67:return say(s,yes?0x13c:0x116,0);
    case 78:
        if(yes)return say(s,0x13c,0);
        if(!s->flags[7])s->flags[7]=1;
        return say(s,0x13e,0);
    case 85:if(yes)s->flags[8]=1;return say(s,yes?0x174:0x17c,0);
    case 93:
        if(!yes)return say(s,0x19c,0);
        if(s->rpg->money<1000)return say(s,0x19a,0);
        s->rpg->money-=1000;return say(s,0x198,93);
    case 108:return say(s,yes?0x1da:0x1d8,0);
    case 116:
        if(!yes)return say(s,0x1f0,0);
        if(s->rpg->money<400)return say(s,0x1f2,0);
        s->rpg->money-=400;s->flags[9]=1;return say(s,0x1f4,0);
    case 117:return say(s,yes?0x1fc:0x1fe,0);
    case 120:return say(s,yes?0x206:0x208,0);
    case 124:
        if(!yes)return say(s,0xb7e3,0);
        if(s->rpg->money<280)return say(s,0xbd57,0);
        if(s->rpg->inventory_count>=24)return say(s,0xb813,0);
        s->rpg->money-=280;return say(s,0x20a,124);
    case 129:if(yes)s->flags[4]=1;return say(s,yes?0xe4:0xd4,0);
    case 130:return say(s,yes&&has(s,ItemID_RoadPass)?0x24:0xe8,yes&&has(s,ItemID_RoadPass)?0:ROBOT_FIGHT);
    case 132:return say(s,yes?0x13c:0x124,0);
    case 135:return say(s,yes?0x14c:0x13c,0);
    case 142:return say(s,yes?0x14e:0x152,yes?142:0);
    case 143:return say(s,yes?0x14e:0x152,yes?143:0);
    case 144:return say(s,yes?0x14e:0x152,yes?144:0);
    case 145:return yes?say(s,0x158,0):ask(s,0x15a,146);
    case 146:return say(s,yes?0x152:0x15c,yes?0:146);
    case 148:return say(s,yes?0x162:0x164,0);
    case 147:
        if(yes&&has(s,ItemID_RoadPass))return say(s,0x21e,ROBOT_WARP);
        return say(s,0xe8,ROBOT_FIGHT);
    case 155:
        if(!yes)return say(s,0xa2,GUARD_RETREAT);
        slot=rpg_find_item(s->rpg,ItemID_Cake);
        if(slot==255)return say(s,0xa0,GUARD_RETREAT);
        rpg_remove_item(s->rpg,slot);s->flags[17]=255;return say(s,0x9e,0);
    case 156:
        if(!yes)return say(s,0x246,0);
        slot=rpg_find_item(s->rpg,ItemID_AmberEye);
        if(slot==255)return say(s,0x248,0);
        rpg_remove_item(s->rpg,slot);return give(s,ItemID_EclipseTorch,156);
    case 157:return say(s,yes?0x25e:0x260,0);
    case 159:return say(s,yes?0x26e:0x270,LASSIC_FIGHT);
    case 168:return say(s,yes?0x22c:0x22a,0);
    case 172:return say(s,yes?0x212:0x230,ENDING_RUN);
    case 179:case 180:
        if(!yes)return finish(s);
        s->action.target=s->stage==179?0x81:0x82;return emit(s,EVENT_TRAVEL,0,0);
    case TRAVEL_QUESTION:
        if(!yes)return emit(s,EVENT_TRAVEL_MENU,0xb754,0);
        {
            static const uint8_t routes[8]={0x81,0x83,0x84,0x85,0x82,0x86,0x87,0x88};
            slot=(uint8_t)(((s->map_id>>3)&3u)*3u+s->travel_destination);
            if(slot>=8u)return emit(s,EVENT_UNIMPLEMENTED,0,0);
            s->action.target=routes[slot];return emit(s,EVENT_TRAVEL,0,0);
        }
    case 200:return yes?select_replacement(s):ask(s,0xb6c1,201);
    case 201:return yes?say(s,0xb6d0,203):select_replacement(s);
    default:return emit(s,EVENT_UNIMPLEMENTED,0,0);
    }
}
const EventAction *event_replace_item(EventState *s,uint8_t slot) RPG_BANKED {
    uint8_t result;
    if(s->action.kind!=EVENT_REPLACE_ITEM) return &s->action;
    if(slot==255) return ask(s,0xb671,200);
    if(slot>=s->rpg->inventory_count) return &s->action;
    /* Test protection without mutation, using the same rule as voluntary discard. */
    result=rpg_item_discardable(s->rpg->inventory[slot]);
    if(!result) return say(s,0xb6de,204);
    s->selected_slot=slot;s->action.item=s->rpg->inventory[slot];
    return say(s,0xb69e,205);
}
const EventAction *event_buy_secret(EventState *s,uint8_t shop,uint8_t option) RPG_BANKED {
    uint8_t item;
    uint16_t price;
    if(rpg_shop_option(shop,option,&item,&price)!=RPG_OK || item!=ItemID_Secrets)
        return emit(s,EVENT_UNIMPLEMENTED,0,0);
    /* LABEL_2BDC checks full inventory and funds before LABEL_2C46, including refusals. */
    if(s->rpg->inventory_count>=RPG_INVENTORY_SIZE) return say(s,0xb813,0);
    if(s->rpg->money<price) return say(s,0xbd57,0);
    if(s->secrets_requests>=2) {
        s->secrets_requests=0;
        if(!has(s,ItemID_RoadPass)) {
            s->rpg->money-=price;rpg_add_item(s->rpg,ItemID_RoadPass);
            s->action.item=ItemID_RoadPass;say(s,0x146,0);s->action.sound=0xb3;return &s->action;
        }
        /* Having the pass restarts the refusal sequence, without charging or duplicating. */
    }
    s->secrets_requests++;
    return say(s,s->secrets_requests==1?0x142:0x144,0);
}
const EventAction *event_battle_result(EventState *s,uint8_t outcome,uint8_t chest_opened) RPG_BANKED {
    if(s->action.kind!=EVENT_BATTLE || outcome==RPG_ONGOING)return &s->action;
    if(chest_opened)s->flags[s->battle.flag_index]=255;
    if(s->event==55) {restore_status(s);return present(s,EVENT_PRESENT_NIGHTMARE_WAKE,GOV_REST);}
    if(s->event==157) {
        restore_status(s);
        if(!s->rpg->party[3].hp) {
            s->rpg->party[3].hp=s->battle.noah_hp;s->rpg->party[3].status=1;
            return say(s,0x256,0);
        }
        return say(s,0x250,TARZ_REWARD);
    }
    if(outcome==RPG_DEFEAT)return emit(s,EVENT_GAME_OVER,0,0);
    if(s->event==158) {s->flags[23]=255;return say(s,0x266,0);}
    if(s->event==159) {s->flags[22]=1;return say(s,0x2aa,0);}
    if(s->event==171) {
        if(!s->rpg->party[0].status)return say(s,0xbf64,53);
        return emit(s,EVENT_GOVERNOR_ROOM,0,ENDING_PROMPT);
    }
    if((s->event==22||s->event==130||s->event==147)&&outcome!=RPG_VICTORY)return emit(s,EVENT_MENU,0,0);
    return finish(s);
}
void event_governor_room_loaded(EventState *s) RPG_BANKED {
    if(s->action.kind==EVENT_GOVERNOR_ROOM&&s->stage==59u)rpg_rest(s->rpg);
}
const EventAction *event_choose_destination(EventState *s,uint8_t destination) RPG_BANKED {
    uint8_t current;
    if(s->action.kind!=EVENT_TRAVEL_MENU)return &s->action;
    if(destination==255u)return finish(s);
    if(destination>2u)return &s->action;
    current=(s->map_id>>3)&3u;s->travel_destination=destination;
    if(current==destination)return say(s,destination==0u?0xb799:destination==1u?0xb790:0xb785,TRAVEL_AGAIN);
    return ask(s,destination==0u?0xb77b:destination==1u?0xb76f:0xb761,TRAVEL_QUESTION);
}
const EventAction *event_use_story_item(EventState *s,uint8_t slot,uint8_t in_battle) RPG_BANKED {
    uint8_t item;
    if(slot>=s->rpg->inventory_count)return emit(s,EVENT_UNIMPLEMENTED,0,0);
    item=s->rpg->inventory[slot];s->action.item=item;s->selected_slot=slot;s->item_in_battle=in_battle;
    if(item==ItemID_Alsulin)return say(s,0xb366,170);
    if(item==ItemID_Polymaterial)return say(s,0xb366,172);
    return emit(s,EVENT_UNIMPLEMENTED,0,0);
}
const EventAction *event_search(EventState *s,uint8_t map_id,uint8_t x,uint8_t y) RPG_BANKED {
    uint8_t item=0;
    if(map_id==7u && x==0x1eu && y==32u && s->flags[7] && s->flags[7]!=255u) {
        /* Source marks the discovery before attempting addition, even if declined when full. */
        s->flags[7]=255;item=ItemID_Flute;
    } else if(map_id==1u && x==0x48u && y==36u && s->flags[9] && s->rpg->party[2].shield!=ItemID_MirrorShield) {
        item=ItemID_MirrorShield;
    }
    if(item && !has(s,item)) {s->action.item=item;s->pending_item=item;return say(s,0xb592,177);}
    if(s->event==0xa2 && s->flags[8] && has(s,ItemID_Hapsby) && !has(s,ItemID_Hovercraft))return say(s,0x178,178);
    if(s->event==0xa3)return say(s,0xfa,0);
    return say(s,0xb569,0);
}
