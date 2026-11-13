#ifdef __SDCC
#pragma bank 22
#endif
#include "party_world.h"
#include <string.h>
/* Exact source CA6/CC0/CE3, 59A1 and 5A98..5B86. Native RPG indices differ
 * from the original actor order: Alis, Noah, Odin, Myau. */
static const uint8_t order[4]={0,3,2,1};
static const uint8_t standing[4][4]={{1,0,9,12},{5,0,8,11},{1,0,9,12},{1,0,14,15}};
static const uint8_t walking[4][16]={
 {5,6,7,6,2,3,4,3,8,9,10,9,11,12,13,12},
 {4,5,6,5,1,2,3,2,7,8,9,8,10,11,12,11},
 {5,6,7,6,2,3,4,3,8,9,10,9,11,12,13,12},
 {5,6,7,6,2,3,4,3,8,9,10,10,11,12,13,13}};
PartyWorld party_world;
static uint8_t direction(uint8_t mask) {
    uint8_t n=0;while(!(mask&1u)){mask>>=1;++n;}return n;
}
static void shift(PartyWorldActor *a,uint8_t dir) {
    if(dir==0u)--a->y;else if(dir==1u)++a->y;
    else if(dir==2u)--a->x;else ++a->x;
}
void party_reset(PartyWorld *s,const RPGState *r,uint8_t road) RPG_BANKED {
    uint8_t i;PartyWorldActor *a;
    memset(s,0,sizeof(*s));s->road=road;
    for(i=0;i<4u;++i)if(r->party[order[i]].status&1u) {
        a=&s->actors[s->count];a->identity=i;a->x=(road&3u)?132u:128u;
        a->y=96;a->flags=s->count?0u:3u;a->direction=1;a->loaded=255;
        ++s->count;
    }
}
void party_step(PartyWorld *s,uint8_t accepted,uint8_t remaining,uint8_t held) RPG_BANKED {
    uint8_t i,dir;PartyWorldActor *a,*prev;
    accepted&=15u;held&=15u;
    for(i=0;i<s->count;++i) {
        a=&s->actors[i];prev=i?a-1:a;
        if(remaining==15u) {
            if(!i) {a->previous=a->direction;if(accepted)a->direction=direction(accepted);}
            else {
                if(a->flags&1u)a->flags|=2u;
                if((a->x!=prev->x||a->y!=prev->y)&&(prev->flags&2u))a->flags|=1u;
                a->previous=a->direction;a->direction=prev->previous;
            }
        }
        if(accepted) {
            if(i) {
                if(a->flags&1u)shift(a,a->direction);
                shift(a,s->actors[0].direction^1u);
            }
            if(!s->road) {
                --a->clock;
                if(a->clock&128u) {
                    a->clock=7;a->phase=(a->phase+1u)&3u;
                    a->frame=walking[a->identity][a->direction*4u+a->phase];
                }
                continue;
            }
        }
        a->previous=a->direction;
        dir=i?prev->previous:(held?direction(held):a->direction);
        a->frame=standing[a->identity][dir];
    }
}
#ifdef __SDCC
#include <gb/gb.h>
#include <gb/cgb.h>
#include "party_world_data.h"
extern RPGState game_rpg;
static const uint16_t starts[4]={0,84,162,246};
static const uint8_t destinations[4]={0,84,90,96};
void party_world_reset(uint8_t road) RPG_BANKED {
    party_reset(&party_world,&game_rpg,road);
    VBK_REG=1;set_sprite_data(0,84,party_world_tiles);VBK_REG=0;
    set_sprite_palette(0,8,party_world_palettes);SPRITES_8x8;
}
void party_world_tick(uint8_t accepted,uint8_t remaining,uint8_t held) RPG_BANKED {
    party_step(&party_world,accepted,remaining,held);
}
void party_world_draw(void) RPG_BANKED {
    uint8_t i,j,n,selected,oam=0,width,tile,rank[4];uint16_t offset;
    PartyWorldActor *a;
    for(i=0;i<party_world.count;++i) {
        a=&party_world.actors[i];width=a->identity==3u?4u:6u;
        if(a->identity&&a->frame!=a->loaded) {
            offset=starts[a->identity]+(uint16_t)a->frame*width;
            VBK_REG=1;set_sprite_data(destinations[a->identity],width,party_world_tiles+offset*16u);VBK_REG=0;
        }
        a->loaded=a->frame;
    }
    /* Source57BE compares each slot with every following slot, swapping
     * only on strictly smaller Y. Reproduce those swaps, including ties
     * displaced by another actor; a stable sort is not equivalent. */
    for(i=0;i<party_world.count;++i)rank[i]=i;
    for(i=0;i+1u<party_world.count;++i)for(j=i+1u;j<party_world.count;++j)
        if(party_world.actors[rank[i]].y<party_world.actors[rank[j]].y) {
            selected=rank[i];rank[i]=rank[j];rank[j]=selected;
        }
    for(n=0;n<party_world.count;++n) {
        a=&party_world.actors[rank[n]];width=a->identity==3u?4u:6u;
        offset=starts[a->identity]+(uint16_t)a->frame*width;
        tile=a->identity?destinations[a->identity]:a->frame*6u;
        for(j=0;j<width;++j) {
            set_sprite_tile(oam,tile+j);set_sprite_prop(oam,8u|party_world_attrs[offset+j]);
            move_sprite(oam,a->x-48u+(j&1u)*8u,a->y-(width==4u?16u:24u)+(j>>1)*8u);++oam;
        }
    }
    for(;oam<40u;++oam)move_sprite(oam,0,0);
    SHOW_SPRITES;
}
#endif
