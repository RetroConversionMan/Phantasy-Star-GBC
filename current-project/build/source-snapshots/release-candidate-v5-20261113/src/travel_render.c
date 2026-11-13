#pragma bank 119
#include <gb/gb.h>
#include <gb/cgb.h>
#include "travel.h"
#include "travel_art.h"
#include "world.h"
#include "world_motion.h"
#include "bank_io.h"
#include "scene.h"
#include "assets.h"
#include "party_world.h"
#include "party_world_data.h"
extern uint16_t scene_shared_colors[32];
extern uint8_t scene_shared_bytes[40];
static uint8_t last_space_scroll=255u;
static uint8_t fade_target[64];
static const uint16_t scene_ui_colors[4]={RGB(2,3,8),RGB(6,10,19),RGB(30,22,8),RGB(30,30,27)};
static const uint8_t *planet_data(uint8_t planet) {
    return planet==0u?travel_planet_0:planet==1u?travel_planet_1:travel_planet_2;
}
static const uint8_t *ship_data(const TravelState *s) {
    return s->ship_mode==16u?travel_ship_0:travel_ship_1;
}
static uint8_t sms_color(uint16_t color) {
    uint8_t r=((color&31u)*3u+15u)/31u,g=(((color>>5)&31u)*3u+15u)/31u;
    uint8_t b=(((color>>10)&31u)*3u+15u)/31u;
    return r|(g<<2)|(b<<4);
}
static uint16_t native_color(uint8_t sms) {
    uint8_t r=sms&3u,g=(sms>>2)&3u,b=sms>>4;
    return (uint16_t)(r*10u+(r>=2u))|((uint16_t)(g*10u+(g>=2u))<<5)|((uint16_t)(b*10u+(b>=2u))<<10);
}
static uint16_t faded(uint16_t color,uint8_t step,uint8_t fade_in) {
    return native_color(travel_fade_color(sms_color(color),step,fade_in));
}
void travel_fade_current(void) __banked {
    uint8_t i;
    scene_palette_capture();
    for(i=0;i<32u;++i)scene_palette_background[i]=faded(scene_palette_background[i],1u,0u);
    for(i=0;i<32u;++i)scene_shared_colors[i]=faded(scene_shared_colors[i],1u,0u);
    scene_palette_commit();
}
void scene_fade_begin(uint8_t fade_in) __banked {
    uint8_t i;
    scene_palette_capture();
    if(fade_in)for(i=0;i<4u;++i)scene_palette_background[28u+i]=scene_ui_colors[i];
    for(i=0;i<32u;++i)fade_target[i]=sms_color(scene_palette_background[i]);
    for(i=0;i<32u;++i)fade_target[i+32u]=sms_color(scene_shared_colors[i]);
    if(fade_in)scene_fade_step(0u,1u);
}
void scene_fade_step(uint8_t step,uint8_t fade_in) __banked {
    uint8_t i;
    for(i=0;i<32u;++i)scene_palette_background[i]=native_color(travel_fade_color(fade_target[i],step,fade_in));
    for(i=0;i<32u;++i)scene_shared_colors[i]=native_color(travel_fade_color(fade_target[i+32u],step,fade_in));
    /* UI colors are a native layout adaptation; restore their exact target
     * after the source fade, instead of retaining the SMS rounding. */
    if(fade_in&&step>=9u)for(i=0;i<4u;++i)scene_palette_background[28u+i]=scene_ui_colors[i];
    scene_palette_commit();
}
static void palettes(const TravelState *s) {
    uint8_t i,bank;const uint8_t *data;
    if(s->space_visible){bank=TRAVEL_ART_BANK;data=planet_data(s->planet)+TRAVEL_GRAPHICS_BYTES;}
    else {const WorldScene *scene=&world_scenes[world_group_id];bank=scene->asset_bank;data=(const uint8_t *)scene->palettes;}
    bank_copy(scene_palette_background,bank,data,56u);
    for(i=0;i<28u;++i)scene_palette_background[i]=faded(scene_palette_background[i],s->fade_step,s->fade_in);
    for(i=0;i<4u;++i)scene_palette_background[28u+i]=(s->fade_in&&s->fade_step>=9u)?scene_ui_colors[i]:faded(scene_ui_colors[i],s->fade_step,s->fade_in);
    if(s->ship_mode){bank=TRAVEL_ART_BANK;data=ship_data(s)+320u;}
    else {bank=PARTY_WORLD_BANK;data=(const uint8_t *)party_world_palettes;}
    bank_copy(scene_shared_colors,bank,data,64u);
    for(i=0;i<32u;++i)scene_shared_colors[i]=faded(scene_shared_colors[i],s->fade_step,s->fade_in);
    scene_palette_commit();
}
static void space_row(const TravelState *s,uint8_t logical) {
    uint8_t row,kind=travel_space_row(s,logical%28u,&row);
    const uint8_t *p=planet_data(s->planet)+TRAVEL_MAP_OFFSET+(uint16_t)kind*768u+(uint16_t)row*32u+7u;
    bank_copy(scene_shared_bytes,TRAVEL_ART_BANK,p,20u);
    bank_copy(scene_shared_bytes+20,TRAVEL_ART_BANK,p+384u,20u);
    VBK_REG=0;set_bkg_tiles(0,logical&31u,20,1,scene_shared_bytes);
    VBK_REG=1;set_bkg_tiles(0,logical&31u,20,1,scene_shared_bytes+20);VBK_REG=0;
}
static void draw_space(const TravelState *s,uint8_t force) {
    uint8_t row,head=(s->scroll+32u)>>3;
    if(force||last_space_scroll==255u||s->scroll>last_space_scroll)
        for(row=0;row<19u;++row)space_row(s,head+row);
    else if(head!=((last_space_scroll+32u)>>3))space_row(s,head);
    move_bkg(0,s->scroll+32u);last_space_scroll=s->scroll;
}
void travel_present(const TravelState *s,uint8_t flags) __banked {
    uint8_t full=flags&(TRAVEL_WORLD|TRAVEL_SPACE);
    if(full) {
        DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;last_space_scroll=255u;
        if(flags&TRAVEL_WORLD) {
            world_select(s->map);world_load_graphics();world_terrain_sync(s->x,s->y);
            if(s->tag<0x80u)world_motion_reset(s->tag);
        } else bank_bkg_data(TRAVEL_ART_BANK,0,98,planet_data(s->planet),0);
        if(s->ship_mode){scene_actor_show_data(TRAVEL_ART_BANK,ship_data(s),16,16);scene_actor_active=0;}
        else {
            scene_actor_hide();
            party_world_reset(s->next_stage==TRAVEL_ROAD?(1u<<(s->facing<2u?s->facing^1u:s->facing)):0u);
        }
    }
    if(s->space_visible)draw_space(s,full);
    else world_draw((s->x+2048u-80u)&2047u,(s->y+1536u-80u)%1536u,full);
    if(!s->ship_mode)party_world_draw();
    if(flags&TRAVEL_PALETTE)palettes(s);
    SHOW_BKG;SHOW_SPRITES;
    if(full)DISPLAY_ON;
}
