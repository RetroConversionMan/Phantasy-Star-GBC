#ifdef __SDCC
#pragma bank 11
#endif
#include "dungeon_play.h"
#include "battle.h"
#include "dungeon_present.h"
#include <string.h>
/* LABEL_6963 and its call sites: object callbacks resume at the next geometry
 * checkpoint. This matters for fake walls and backward movement. */
static void queue(DungeonPlay *p,uint8_t position,uint8_t view) RPG_BANKED {
    p->positions[p->check_count]=position;p->views[p->check_count++]=view;
}
void dplay_mark_object(EventState *e,uint16_t address) RPG_BANKED {
    if((address>>8)==0xc5u)e->flags[(uint8_t)address]=255;
    else if((address>>8)==0xc6u)e->object_flags[(uint8_t)address]=255;
}
uint8_t dplay_escape_blocked(const DungeonPlay *p) RPG_BANKED {
    return (dungeon_sample(&p->dungeon,11)&7u)&&
        (dungeon_sample(&p->dungeon,12)&7u)&&(dungeon_sample(&p->dungeon,13)&7u);
}
uint8_t dplay_resume(DungeonPlay *p,RPGState *r,EventState *e) RPG_BANKED {
    DungeonObject o;uint8_t view,enemy,i;
    dungeon_present_prepare(&p->dungeon);
    memset(&p->action,0,sizeof(p->action));
    while(p->check_cursor<p->check_count) {
        if(p->advance_second && p->check_cursor==1u) {
            /* The second fake-wall call to6758 occurs after the first object
             * callback: it uses that callback's current position/direction. */
            dungeon_present_sequence(&p->dungeon,0u);
            p->dungeon.position=dungeon_sample_position(&p->dungeon,1u);
            dungeon_present_frame(&p->dungeon,0u);
            p->advance_second=0;p->encounter_latch=1;
        } else p->dungeon.position=p->positions[p->check_cursor];
        view=p->views[p->check_cursor++];
        if(!dungeon_active_object(&p->dungeon,view,e->flags,e->object_flags,&o))continue;
        p->encounter_latch=1;p->action.flag_address=o.flag_address;
        if(o.type<2u) {
            /* LABEL6963 updates C2E0 even when a rear item chest does not
             * open a prompt. Money-only records leave that byte unchanged. */
            if(o.type==0u)p->retained_trap=o.b;
            if(view!=1u)continue;
            p->action.kind=DPLAY_CHEST;p->action.a=p->retained_trap;
            if(o.type==0u)p->action.target=o.a;
            else p->action.money=(uint16_t)o.a|((uint16_t)o.b<<8);
            p->action.type=o.type;return p->action.kind;
        }
        if(o.type==2u) {
            if(view!=1u)for(i=0;i<2u;++i){
                p->dungeon.direction=(p->dungeon.direction+3u)&3u;
                dungeon_present_turn(&p->dungeon,0u);
            }
            if(!o.a)continue;
            p->action.kind=DPLAY_BATTLE;p->action.target=o.a;p->action.a=o.b;
            p->action.type=1;return p->action.kind;
        }
        if(o.type==3u) {
            if(view!=1u)for(i=0;i<2u;++i){
                p->dungeon.direction=(p->dungeon.direction+1u)&3u;
                dungeon_present_turn(&p->dungeon,1u);
            }
            p->action.kind=DPLAY_EVENT;p->action.target=o.a;p->action.a=o.b;
            p->action.type=0;return p->action.kind;
        }
    }
    if(p->initial_dark==2u) {
        p->initial_dark=0;
        if(!p->dungeon.light){p->action.kind=DPLAY_EXIT;return p->action.kind;}
        p->dungeon.light=255u;dungeon_refresh_light(&p->dungeon);
    } else if(p->initial_dark) {
        p->initial_dark=0;
        if(!p->dungeon.light){p->initial_dark=2u;p->action.kind=DPLAY_DARK;return p->action.kind;}
    }
    if(p->encounter_latch) {
        p->encounter_latch=0;
        enemy=rpg_dungeon_encounter(r,p->dungeon.floor,dungeon_sample(&p->dungeon,1));
        if(enemy){p->action.kind=DPLAY_BATTLE;p->action.target=enemy;p->action.flag_address=0xc500;}
    }
    return p->action.kind;
}
uint8_t dplay_enter(DungeonPlay *p,RPGState *r,EventState *e,uint8_t floor,uint8_t position,uint8_t direction,uint8_t trap) RPG_BANKED {
    memset(p,0,sizeof(*p));
    if(!dungeon_enter(&p->dungeon,floor,position,direction)){p->action.kind=DPLAY_INVALID;return DPLAY_INVALID;}
    p->active=1;p->retained_trap=trap;
    if(rpg_find_item(r,ItemID_MagicLamp)!=RPG_NO_SLOT){p->dungeon.light=255;dungeon_refresh_light(&p->dungeon);}
    p->initial_dark=1;queue(p,position,1);
    return dplay_resume(p,r,e);
}
uint8_t dplay_scene_fall(DungeonPlay *p,RPGState *r,EventState *e,uint8_t floor,uint8_t position,uint8_t direction,uint8_t trap) RPG_BANKED {
    uint8_t light=p->dungeon.light;
    memset(p,0,sizeof(*p));
    if(floor>=DUNGEON_FLOOR_COUNT||direction>3u){p->action.kind=DPLAY_INVALID;return DPLAY_INVALID;}
    p->dungeon.position=position;p->dungeon.direction=direction;p->dungeon.light=light;
    dungeon_load_floor(&p->dungeon,floor?floor-1u:0u);p->active=1;p->retained_trap=trap;
    dungeon_present_scene_fall(&p->dungeon);
    queue(p,position,1u);return dplay_resume(p,r,e);
}
uint8_t dplay_step(DungeonPlay *p,RPGState *r,EventState *e,uint8_t command) RPG_BANKED {
    DungeonAction a;uint8_t front=dungeon_sample(&p->dungeon,1)&7u,mode,old_position=p->dungeon.position;
    dungeon_present_prepare(&p->dungeon);
    p->check_count=p->check_cursor=p->encounter_latch=p->advance_second=0;
    memset(&p->action,0,sizeof(p->action));
    mode=dungeon_step(&p->dungeon,command,&a);
    if(mode==DUNGEON_MAP){p->action.kind=DPLAY_MAP;p->action.target=a.target;p->action.a=a.a;p->action.b=a.b;}
    else if(mode==DUNGEON_EXIT_SAVED)p->action.kind=DPLAY_EXIT;
    else if(mode==DUNGEON_INTERACTION){p->action.kind=DPLAY_EVENT;p->action.target=a.a;p->action.a=a.b;p->action.type=a.interaction;p->action.b=a.target;}
    else if(mode==DUNGEON_MENU)p->action.kind=DPLAY_MENU;
    else if(mode==DUNGEON_INVALID)p->action.kind=DPLAY_INVALID;
    else if(mode==DUNGEON_OPENED)dungeon_present_door(&p->dungeon,2u);
    else if(mode==DUNGEON_MOVED||mode==DUNGEON_TURNED||mode==DUNGEON_CHANGED_FLOOR||mode==DUNGEON_FELL) {
        /* Only6A58 sets the traversal encounter latch. The direct6731
         * fade/standing path through stairs or an opened door does not. */
        p->encounter_latch=mode==DUNGEON_TURNED || (mode==DUNGEON_MOVED &&
            (command==DUNGEON_CMD_BACK||front==0u||front==7u));
        if(mode==DUNGEON_MOVED&&command==DUNGEON_CMD_FORWARD&&(front==0u||front==7u)) {
            p->dungeon.position=old_position;dungeon_present_sequence(&p->dungeon,0u);
            p->dungeon.position=a.positions[0];dungeon_present_frame(&p->dungeon,0u);
            if(front==7u){queue(p,a.positions[0],1);p->advance_second=1;}
        }
        else if(mode==DUNGEON_MOVED&&command==DUNGEON_CMD_BACK)dungeon_present_sequence(&p->dungeon,1u);
        else if(mode==DUNGEON_TURNED)dungeon_present_turn(&p->dungeon,command==DUNGEON_CMD_RIGHT);
        else if(mode==DUNGEON_FELL)dungeon_present_fall(&p->dungeon);
        else dungeon_present_transition(&p->dungeon,mode==DUNGEON_CHANGED_FLOOR);
        queue(p,p->advance_second?a.positions[1]:p->dungeon.position,1);
        if(mode==DUNGEON_MOVED&&command==DUNGEON_CMD_BACK)queue(p,p->dungeon.position,11);
        return dplay_resume(p,r,e);
    }
    return p->action.kind;
}
uint8_t dplay_escape(DungeonPlay *p,RPGState *r,EventState *e) RPG_BANKED {
    /* LABEL688C directly calls6792, not65EE. It does not check a current trap
     * or re-test backward collision; the caller's687A gate is separate. */
    dungeon_present_prepare(&p->dungeon);
    if(dungeon_sample(&p->dungeon,11)&7u) {
        uint8_t left=dungeon_sample(&p->dungeon,12)&7u,right=dungeon_sample(&p->dungeon,13)&7u;
        uint8_t turn_right=!left&&(right||(rpg_random(r)&1u));
        p->dungeon.direction=(p->dungeon.direction+(turn_right?1u:3u))&3u;
        dungeon_present_turn(&p->dungeon,turn_right);
    }
    p->check_count=p->check_cursor=p->advance_second=0;p->encounter_latch=1;
    p->dungeon.position=dungeon_sample_position(&p->dungeon,11u);
    dungeon_present_sequence(&p->dungeon,1u);
    queue(p,p->dungeon.position,1u);queue(p,p->dungeon.position,11u);
    return dplay_resume(p,r,e);
}
void dplay_show_opening(DungeonPlay *p,uint8_t style) RPG_BANKED {
    uint8_t pos=dungeon_sample_position(&p->dungeon,1u),cell=p->dungeon.layout[pos];
    /* Item/spell logic already validated and set the flag; restore a closed
     * view first if an intervening screen replaced the dungeon background. */
    p->dungeon.layout[pos]=cell&127u;dungeon_present_prepare(&p->dungeon);
    p->dungeon.layout[pos]=cell;dungeon_present_door(&p->dungeon,style);
}
