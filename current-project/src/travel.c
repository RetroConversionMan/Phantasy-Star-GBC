#ifdef __SDCC
#pragma bank 119
#endif
#include "travel.h"
#include <string.h>
/* Pinned original F0C roads and ABF ship routes. Each route keeps departure,
 * arrival and exit triples separately; none is an invented route shortcut. */
static const uint8_t roads[6][8]={
 {4,12,0,0x38,0x51,5,0x21,0x2c},{1,11,0,0x46,0x46,5,0x27,0x21},
 {1,4,1,0x33,0x64,14,0x2a,0x20},{8,12,0,0x38,0x48,4,0x21,0x53},
 {2,11,0,0x3a,0x46,6,0x54,0x20},{2,4,1,0x2b,0x64,16,0x43,0x1e}};
static const uint8_t routes[8][9]={
 {0,0x39,0x43,1,0x8b,0x69,16,0x53,0x17},
 {1,0x37,0x69,0,0x91,0x43,5,0x17,0x17},
 {0,0x47,0x35,1,0x27,0x74,15,0x20,0x58},
 {0,0x47,0x35,2,0x33,0x2d,19,0x18,0x1b},
 {1,0x53,0x74,0,0x1b,0x35,7,0x25,0x13},
 {1,0x53,0x74,2,0x33,0x2d,19,0x18,0x1b},
 {2,0x5b,0x2d,0,0x1b,0x35,7,0x25,0x13},
 {2,0x5b,0x2d,1,0x27,0x74,15,0x20,0x58}};
static const uint8_t map_music[24]={
 0x82,0x83,0x84,0x84,0x87,0x87,0x87,0x88,0x88,0x88,0x88,0x88,
 0x87,0x87,0x87,0x88,0x87,0x88,0x88,0x84,0x84,0x88,0x88,0x85};
static void destination(TravelState *s,const uint8_t *p) {
    uint8_t row=((p[1]>>4)*12u+(p[1]&15u))%96u;
    s->map=p[0];s->x=((uint16_t)p[2]*16u+8u)&2047u;
    s->y=((uint16_t)row*16u+16u)%1536u;
    s->scroll=(s->y+1536u-112u)%192u;
}
static void fade_in(TravelState *s,uint8_t next) {
    s->stage=TRAVEL_FADE_IN;s->next_stage=next;s->fade_step=0;
    s->fade_clock=3;s->fade_in=1;s->phase_frames=0;
}
static uint8_t finish(TravelState *s) {
    s->stage=TRAVEL_EXIT_FADE;s->phase_frames=0;s->fade_step=0;
    s->fade_clock=3;s->fade_in=0;return TRAVEL_DRAW;
}
uint8_t travel_begin(TravelState *s,uint8_t tag) TRAVEL_BANKED {
    uint8_t direction;
    if(!((tag>=1u&&tag<=6u)||(tag>=0x81u&&tag<=0x88u)))return 0;
    memset(s,0,sizeof(*s));s->tag=tag;
    if(tag<0x80u) {
        const uint8_t *r=roads[tag-1u];destination(s,r+2);s->road_steps=r[1];
        direction=r[0];s->facing=direction==1u?1u:direction==2u?0u:direction==4u?2u:3u;
        s->music=map_music[s->map];fade_in(s,TRAVEL_ROAD);
    } else {
        const uint8_t *r=routes[tag-0x81u];destination(s,r);s->facing=1;
        s->ship_mode=tag<0x83u?16u:17u;s->planet=s->map;s->arrival_planet=r[3];
        s->music=0xb8u;fade_in(s,TRAVEL_ASCEND);
    }
    return TRAVEL_WORLD|TRAVEL_AUDIO|TRAVEL_DRAW|TRAVEL_PALETTE;
}
static uint8_t space_begin(TravelState *s) {
    s->space_visible=1;s->scroll=s->fraction=0;s->turns=8;
    s->updated_rows=s->arrival_rows=0;s->music=0x8fu;
    fade_in(s,TRAVEL_SPACE_RUN);
    return TRAVEL_SPACE|TRAVEL_AUDIO|TRAVEL_DRAW|TRAVEL_PALETTE;
}
static uint8_t arrive_begin(TravelState *s) {
    destination(s,routes[s->tag-0x81u]+3);s->space_visible=0;s->music=0xb8u;
    /* Source A8C does not reset C307: a skipped space leg retains its counter
     * as the fractional byte of subsequent world scrolling. */
    s->fraction=s->turns;s->speed=0x800u;fade_in(s,TRAVEL_ARRIVE);
    return TRAVEL_WORLD|TRAVEL_AUDIO|TRAVEL_DRAW|TRAVEL_PALETTE;
}
static void move_ship(TravelState *s) {
    uint16_t fixed=((uint16_t)s->scroll<<8)|s->fraction;
    uint8_t previous=s->scroll,delta;
    fixed-=s->speed;s->fraction=(uint8_t)fixed;s->scroll=fixed>>8;
    if(s->scroll>=224u)s->scroll-=32u;
    delta=(previous-s->scroll)&15u;
    s->y=(s->y+1536u-delta)%1536u;
}
static uint8_t fade_tick(TravelState *s) {
    if(s->fade_clock){--s->fade_clock;return 0;}
    s->fade_clock=3;++s->fade_step;return 1;
}
uint8_t travel_step(TravelState *s,uint8_t skip_pressed) TRAVEL_BANKED {
    uint8_t flags=TRAVEL_DRAW;
    if(!s->tag||s->stage==TRAVEL_FINISHED)return 0;
    ++s->phase_frames;
    if(s->stage==TRAVEL_FADE_IN) {
        if(fade_tick(s))flags|=TRAVEL_PALETTE;
        if(s->fade_step==10u) {
            s->fade_step=9;s->stage=s->next_stage;s->phase_frames=0;
            if(s->stage==TRAVEL_ASCEND){s->fade_in=0;s->fade_step=0;s->fade_clock=3;}
            if(s->stage==TRAVEL_FINISHED)flags|=TRAVEL_DONE;
        }
        return flags;
    }
    if(s->stage==TRAVEL_ROAD) {
        if(skip_pressed)return finish(s);
        if(s->facing==0)s->y=(s->y+1u)%1536u;
        else if(s->facing==1)s->y=(s->y+1535u)%1536u;
        else if(s->facing==2)s->x=(s->x-1u)&2047u;
        else s->x=(s->x+1u)&2047u;
        if(++s->step_pixels==16u){s->step_pixels=0;if(!--s->road_steps)return finish(s);}
        return flags;
    }
    if(s->stage==TRAVEL_ASCEND) {
        if(skip_pressed){s->stage=TRAVEL_ASCEND_FADE;s->phase_frames=0;return flags;}
        move_ship(s);
        if((s->speed>>8)==7u&&fade_tick(s))flags|=TRAVEL_PALETTE;
        s->speed+=8u;
        if(s->speed==0x800u){s->stage=TRAVEL_ASCEND_FADE;s->phase_frames=0;}
        return flags;
    }
    if(s->stage==TRAVEL_ASCEND_FADE) {
        if(fade_tick(s))flags|=TRAVEL_PALETTE;
        if(s->fade_step>=9u)return space_begin(s);
        return flags;
    }
    if(s->stage==TRAVEL_SPACE_RUN) {
        uint8_t row=s->scroll>>3;uint32_t bit=(uint32_t)1u<<row;
        /* 73D0 runs during the VBlank even on the frame that skips this leg. */
        s->updated_rows|=bit;if(s->turns<=1u)s->arrival_rows|=bit;
        if(skip_pressed)return arrive_begin(s);
        if(s->scroll<2u){s->scroll+=222u;--s->turns;
            if(s->turns==1u){s->planet=s->arrival_planet;flags|=TRAVEL_PALETTE|TRAVEL_SPACE;}
        } else s->scroll-=2u;
        if(!s->turns)return arrive_begin(s);
        return flags;
    }
    if(s->stage==TRAVEL_ARRIVE) {
        if(skip_pressed)return finish(s);
        move_ship(s);
        if(s->speed<8u)return finish(s);
        s->speed-=8u;return flags;
    }
    if(s->stage==TRAVEL_EXIT_FADE) {
        if(fade_tick(s))flags|=TRAVEL_PALETTE;
        if(s->fade_step>=9u) {
            destination(s,s->tag<0x80u?roads[s->tag-1u]+5:routes[s->tag-0x81u]+6);
            s->space_visible=s->ship_mode=0;s->music=map_music[s->map];
            fade_in(s,TRAVEL_FINISHED);
            return TRAVEL_WORLD|TRAVEL_AUDIO|TRAVEL_DRAW|TRAVEL_PALETTE;
        }
    }
    return flags;
}
uint8_t travel_space_row(const TravelState *s,uint8_t row,uint8_t *source_row) TRAVEL_BANKED {
    uint32_t bit;row%=28u;bit=(uint32_t)1u<<row;
    if(row<12u){*source_row=row;return(s->arrival_rows&bit)?2u:0u;}
    if(row<24u){*source_row=row-12u;return(s->updated_rows&bit)?0u:1u;}
    *source_row=row-24u;return 1u;
}
uint8_t travel_fade_color(uint8_t color,uint8_t step,uint8_t in) TRAVEL_BANKED {
    uint8_t value=in?0u:color;
    while(step--) {
        if(in) {
            if(value==color)continue;
            if(value+16u<=color)value+=16u;
            else if(value+4u<=color)value+=4u;
            else ++value;
        } else if(value&3u)--value;
        else if(value&12u)value-=4u;
        else if(value&48u)value-=16u;
    }
    return value;
}
