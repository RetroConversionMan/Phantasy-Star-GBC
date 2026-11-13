#pragma bank 6
#include "world.h"
#include "world_motion.h"
#include "bank_io.h"
#include <string.h>
#ifdef __SDCC
#include <gb/gb.h>
#include <gb/cgb.h>
#endif
uint8_t world_map_id, world_group_id;
uint8_t world_ice_changed;
/* Original CC00..CFFF holds four192-byte chunks; a compact replacement bit
 * covers each loaded cell. Original723D discards ALL changes on chunk reload. */
static uint8_t broken_ice[96],ice_origin_x=255u,ice_origin_y,ice_dirty;
static const WorldScene *scene;
static uint8_t collisions[256];
static uint16_t previous_tile_x, previous_tile_y;
static uint8_t drawn;
#ifdef __SDCC
static uint8_t tiles_buffer[21], attrs_buffer[21];
#endif
/* Source LABEL_7AC0+1, indexed by original map ID minus four. */
static const uint8_t town_exits[20][3] = {
    {0,0x39,0x55},{0,0x39,0x55},{0,0x48,0x49},{0,0x47,0x38},
    {0,0x66,0x55},{0,0x25,0x42},{0,0x14,0x0f},{0,0x41,0x1a},
    {0,0x66,0x75},{0,0x38,0x66},{1,0x27,0x64},{1,0x53,0x73},
    {1,0x27,0x64},{1,0x71,0x5a},{1,0x26,0x29},{2,0x5b,0x2c},
    {2,0x38,0x49},{2,0x5b,0x2c},{2,0x38,0x49},{0,0x16,0x6a}
};
/* LABEL_F0C road records, all eight bytes retained for eventual scene playback. */
static const uint8_t roads[6][8] = {
    {4,12,0,0x38,0x51,5,0x21,0x2c},
    {1,11,0,0x46,0x46,5,0x27,0x21},
    {1,4,1,0x33,0x64,14,0x2a,0x20},
    {8,12,0,0x38,0x48,4,0x21,0x53},
    {2,11,0,0x3a,0x46,6,0x54,0x20},
    {2,4,1,0x2b,0x64,16,0x43,0x1e}
};
static uint16_t wrap_y(int16_t y) {
    if(y < 0) return (uint16_t)(y + WORLD_PIXEL_HEIGHT);
    if(y >= WORLD_PIXEL_HEIGHT) return (uint16_t)(y - WORLD_PIXEL_HEIGHT);
    return (uint16_t)y;
}
static uint16_t ice_index(uint8_t mx,uint8_t my) {
    uint8_t dx=(mx-ice_origin_x*16u)&127u;
    uint8_t dy=(my+96u-ice_origin_y*12u)%96u;
    if(ice_origin_x==255u||dx>=32u||dy>=24u)return 65535u;
    return (uint16_t)dy*32u+dx;
}
void world_terrain_sync(uint16_t x,uint16_t y) WORLD_BANKED {
    uint8_t cx=((x-136u)&2047u)>>8;
    uint8_t cy=wrap_y((int16_t)y-112)/192u;
    if(cx!=ice_origin_x||cy!=ice_origin_y) {
        memset(broken_ice,0,sizeof(broken_ice));ice_origin_x=cx;ice_origin_y=cy;
        if(ice_dirty)drawn=0;
        ice_dirty=0;
    }
}
uint8_t world_select(uint8_t map_id) WORLD_BANKED {
    if(map_id >= WORLD_MAP_COUNT) return 0;
    world_map_id = map_id;
    world_group_id = world_map_group[map_id];
    scene = &world_scenes[world_group_id];
    bank_copy(collisions, scene->asset_bank, scene->collision, 256u);
    memset(broken_ice,0,sizeof(broken_ice));ice_origin_x=255u;ice_dirty=world_ice_changed=0;
    drawn = 0;
    return 1;
}
void world_load_graphics(void) WORLD_BANKED {
#ifdef __SDCC
    uint16_t palette[28];
    uint16_t first_count = scene->tile_count > 256u ? 256u : scene->tile_count;
    bank_bkg_data(scene->asset_bank, 0, (uint8_t)first_count, scene->tiles, 0);
    if(scene->tile_count > 256u)
        bank_bkg_data(scene->asset_bank, 64, (uint8_t)(scene->tile_count - 256u), scene->tiles + 4096u, 1);
    bank_copy(palette, scene->asset_bank, scene->palettes, sizeof(palette));
    set_bkg_palette(0, 7, palette);
#endif
    world_motion_reset(0);
    drawn = 0;
}
uint8_t world_meta_at(uint16_t pixel_x, uint16_t pixel_y) WORLD_BANKED {
    uint16_t index = ((pixel_y % WORLD_PIXEL_HEIGHT) >> 4) * 128u + ((pixel_x & 2047u) >> 4);
    if(ice_dirty) {
        uint16_t bit=ice_index((pixel_x&2047u)>>4,(pixel_y%WORLD_PIXEL_HEIGHT)>>4);
        if(bit!=65535u&&(broken_ice[bit>>3]&(1u<<(bit&7u))))return 0xd7u;
    }
    return bank_read8(scene->map_bank, scene->map + index);
}
uint8_t world_flags_at(uint16_t pixel_x, uint16_t pixel_y) WORLD_BANKED {
    return collisions[world_meta_at(pixel_x, pixel_y)];
}
void world_tile_at(uint16_t tile_x, uint16_t tile_y, uint8_t *tile, uint8_t *attribute) WORLD_BANKED {
    uint8_t pair[2], meta;
    uint16_t offset;
    tile_x &= 255u;
    tile_y %= WORLD_TILE_HEIGHT;
    meta = world_meta_at(tile_x*8u,tile_y*8u);
    offset = (uint16_t)meta * 8u + (tile_y & 1u) * 4u + (tile_x & 1u) * 2u;
    bank_copy(pair, scene->asset_bank, scene->metatiles + offset, 2u);
    *tile = pair[0]; *attribute = pair[1];
}
#ifdef __SDCC
static void draw_row(uint16_t x, uint16_t y) {
    uint8_t i, first = 32u - (x & 31u);
    if(first > 21u) first = 21u;
    for(i=0;i<21u;++i) world_tile_at(x+i,y,&tiles_buffer[i],&attrs_buffer[i]);
    VBK_REG=0; set_bkg_tiles(x&31u,y&31u,first,1,tiles_buffer);
    if(first<21u) set_bkg_tiles(0,y&31u,21u-first,1,tiles_buffer+first);
    VBK_REG=1; set_bkg_tiles(x&31u,y&31u,first,1,attrs_buffer);
    if(first<21u) set_bkg_tiles(0,y&31u,21u-first,1,attrs_buffer+first);
    VBK_REG=0;
}
static void draw_column(uint16_t x, uint16_t y) {
    uint8_t i, first=32u-(y&31u);
    if(first>19u) first=19u;
    for(i=0;i<19u;++i) world_tile_at(x,y+i,&tiles_buffer[i],&attrs_buffer[i]);
    VBK_REG=0; set_bkg_tiles(x&31u,y&31u,1,first,tiles_buffer);
    if(first<19u) set_bkg_tiles(x&31u,0,1,19u-first,tiles_buffer+first);
    VBK_REG=1; set_bkg_tiles(x&31u,y&31u,1,first,attrs_buffer);
    if(first<19u) set_bkg_tiles(x&31u,0,1,19u-first,attrs_buffer+first);
    VBK_REG=0;
}
#endif
void world_draw(uint16_t camera_x, uint16_t camera_y, uint8_t force) WORLD_BANKED {
    uint16_t x=(camera_x & 2047u)>>3, y=(camera_y % WORLD_PIXEL_HEIGHT)>>3;
#ifdef __SDCC
    uint8_t row;
    uint16_t dx=(x-previous_tile_x)&255u;
    uint16_t dy=(y+WORLD_TILE_HEIGHT-previous_tile_y)%WORLD_TILE_HEIGHT;
    if(!drawn || force || (dx!=0u && dx!=1u && dx!=255u) ||
       (dy!=0u && dy!=1u && dy!=191u)) {
        for(row=0;row<19u;++row) draw_row(x,y+row);
    } else {
        if(dx) draw_column(dx==1u?x+20u:x,y);
        if(dy) draw_row(x,dy==1u?y+18u:y);
    }
    move_bkg((uint8_t)camera_x,(uint8_t)camera_y);
#else
    (void)force;
#endif
    previous_tile_x=x; previous_tile_y=y; drawn=1;
}
uint8_t world_can_stand(uint16_t x, uint16_t y) WORLD_BANKED {
    uint16_t left=(x-5u)&2047u, right=(x+4u)&2047u;
    uint16_t top=wrap_y((int16_t)y-7), bottom=wrap_y((int16_t)y-2);
    if(x>=WORLD_PIXEL_WIDTH || y>=WORLD_PIXEL_HEIGHT) return 0;
    return !((world_flags_at(left,top)|world_flags_at(right,top)|
              world_flags_at(left,bottom)|world_flags_at(right,bottom))&1u);
}
static uint8_t break_ice(uint16_t x,uint16_t y) {
    uint8_t meta=world_meta_at(x,y);uint16_t bit;
    if(meta>=0xd8u&&meta<0xe0u) {
        bit=ice_index((x&2047u)>>4,(y%WORLD_PIXEL_HEIGHT)>>4);
        if(bit!=65535u) {
            broken_ice[bit>>3]|=1u<<(bit&7u);meta=0xd7u;
            ice_dirty=world_ice_changed=1;drawn=0;
        }
    }
    return collisions[meta];
}
void world_vehicle_footprint(uint16_t x,uint16_t y,uint8_t vehicle) WORLD_BANKED {
    uint8_t n;world_terrain_sync(x,y);world_ice_changed=0;
    if(world_group_id!=2u||vehicle!=12u)return;
    for(n=0;n<4u;++n)break_ice((x-8u-((n&1u)?0u:16u))&2047u,
        wrap_y((int16_t)y-16-((n&2u)?0:16)));
}
uint8_t world_step_allowed(uint16_t x, uint16_t y, uint8_t facing, uint8_t vehicle) WORLD_BANKED {
    int16_t px=(int16_t)x-8, py=(int16_t)y-16;
    uint16_t x1,x2,y1,y2;
    uint8_t mask=vehicle==8u?10u:1u;
    world_terrain_sync(x,y);world_ice_changed=0;
    if(facing>3u) return 0;
    if(facing==0u) py+=16; else if(facing==1u) py-=16;
    else if(facing==2u) px-=16; else px+=16;
    /* Primary14 is the lower-right cell of a vehicle. Up/left must reach
     * beyond its existing upper/left half (source02/04 and08/10). */
    if(vehicle) {if(facing==1u)py-=16;else if(facing==2u)px-=16;}
    x1=(uint16_t)px&2047u; y1=wrap_y(py);
    if(!vehicle) return !(world_flags_at(x1,y1)&1u);
    /* Source vehicle footprint's second leading sample is left/up of first. */
    x2=x1; y2=y1;
    if(facing<2u) x2=(x1-16u)&2047u; else y2=wrap_y((int16_t)y1-16);
    if(vehicle==12u) {
        uint8_t a=break_ice(x1,y1),b=break_ice(x2,y2);
        return !((a|b)&1u);
    }
    return !((world_flags_at(x1,y1)|world_flags_at(x2,y2))&mask);
}
/* Verified original7A35,7A45,7A75,7A8D bytes. Sample offsets are relative
 * to the SMS camera; native primary coordinates are(cameraX+80,cameraY+60). */
static const uint8_t land_checks[4][4]={
 {10,12,18,20},{12,14,20,22},{18,20,26,28},{20,22,28,30}};
static const uint8_t hover_checks[8][6]={
 {2,4,10,12,240,0},{4,6,12,14,240,16},{14,38,22,40,0,32},
 {22,40,30,42,16,32},{28,30,34,36,32,16},{26,28,32,34,32,0},
 {16,18,24,26,16,240},{8,10,16,18,0,240}};
static const uint8_t hover_exits[8][3]={
 {2,224,240},{4,224,0},{14,240,16},{22,0,16},
 {28,16,0},{26,16,240},{16,0,224},{8,240,224}};
static const uint8_t sample_offsets[44]={
 64,96,64,112,64,128,64,144,80,96,80,112,80,128,80,144,
 96,96,96,112,96,128,96,144,112,96,112,112,112,128,112,144,
 128,112,128,128,128,144,80,160,96,160,112,160};
static uint8_t vehicle_sample(uint16_t x,uint16_t y,uint8_t index) {
    return world_flags_at((x-136u+sample_offsets[index+1u])&2047u,
        wrap_y((int16_t)y-112+sample_offsets[index]));
}
uint8_t world_vehicle_use(uint16_t *x,uint16_t *y,uint8_t facing,uint8_t interaction,
    uint8_t requested,uint8_t *vehicle) WORLD_BANKED {
    uint8_t i,n,found=0,exit=*vehicle==requested;
    int8_t dx=0,dy=0;
    static const uint8_t direction[4]={2,0,3,1};
    if((requested!=4u&&requested!=8u&&requested!=12u)||facing>3u)return 0;
    if(!exit&&(world_group_id>=4u||!interaction||(requested==12u&&world_group_id!=2u)))return 0;
    world_terrain_sync(*x,*y);
    if(requested!=8u) {
        for(i=0;i<4u;++i) {
            for(n=0;n<4u;++n)if(vehicle_sample(*x,*y,land_checks[i][n])&13u)break;
            if(n==4u){found=1;dx=(i&1u)?16:0;dy=(i&2u)?16:0;break;}
        }
    } else if(!exit) {
        for(i=0;i<8u;++i) {
            for(n=0;n<4u;++n)if(vehicle_sample(*x,*y,hover_checks[i][n])&10u)break;
            if(n==4u){found=1;dy=(int8_t)hover_checks[i][4];dx=(int8_t)hover_checks[i][5];break;}
        }
    } else {
        i=direction[facing]*2u;
        for(n=0;n<8u;++n,i=(i+1u)&7u)if(!(vehicle_sample(*x,*y,hover_exits[i][0])&13u)) {
            found=1;dy=(int8_t)hover_exits[i][1];dx=(int8_t)hover_exits[i][2];break;
        }
    }
    if(!found)return 0;
    *x=(*x+dx)&2047u;*y=wrap_y((int16_t)*y+dy);*vehicle=exit?0u:requested;
    return exit?2u:1u;
}
uint8_t world_decode_y(uint8_t packed) WORLD_BANKED {
    return (uint8_t)(((uint16_t)(packed>>4)*12u+(packed&15u))%96u);
}
void world_decode_destination(const WorldAction *action, uint16_t *x, uint16_t *y) WORLD_BANKED {
    *x=((uint16_t)action->b*16u+8u)&2047u;
    *y=((uint16_t)world_decode_y(action->a)*16u+16u)%WORLD_PIXEL_HEIGHT;
}
uint8_t world_road_destination(uint8_t index, WorldAction *action) WORLD_BANKED {
    memset(action,0,sizeof(*action));
    if(index<1u || index>6u) return 0;
    action->mode=WORLD_ACTION_MAP;
    action->target=roads[index-1u][5]; action->a=roads[index-1u][6]; action->b=roads[index-1u][7];
    return 1;
}
uint8_t world_check_trigger(uint16_t x, uint16_t y, uint8_t vehicle, WorldAction *action) WORLD_BANKED {
    uint8_t sample, samples=vehicle?4u:1u, mx=0,my=0,meta=0,flags=0,i;
    uint16_t sx,sy;
    WorldExit entry;
    memset(action,0,sizeof(*action));
    for(sample=0;sample<samples;++sample) {
        /* LABEL_77AC sample order 14,12,0A,0C, relative to feet/centre. */
        sx=(x-8u-((sample==1u||sample==2u)?16u:0u))&2047u;
        sy=wrap_y((int16_t)y-16-((sample>=2u)?16:0));
        meta=world_meta_at(sx,sy);flags=collisions[meta];
        if(flags&8u) {mx=sx>>4;my=sy>>4;break;}
        if(sample==0u && (flags&4u)) {
            action->metatile=meta;action->flags=flags;
            if(meta==0xadu && world_map_id>=4u) {
                action->mode=WORLD_ACTION_MAP;
                action->target=town_exits[world_map_id-4u][0];
                action->a=town_exits[world_map_id-4u][1];action->b=town_exits[world_map_id-4u][2];
            } else if((meta==0x4cu && world_map_id==5u) ||
                      (meta==0x5eu && !vehicle) ||
                      (meta>=0x5fu && meta<0x64u && vehicle!=8u) ||
                      (meta>=0xc3u && meta<0xc7u && !vehicle) ||
                      (meta>=0xc7u && meta<0xd2u)) {
                action->mode=WORLD_ACTION_SPECIAL;
                action->target=flags>>4;action->a=meta;action->b=vehicle;
            }
            return action->mode;
        }
    }
    if(!(flags&8u)) return 0;
    for(i=0;i<scene->exit_count;++i) {
        bank_copy(&entry,scene->asset_bank,scene->exits+i,sizeof(entry));
        /* Source X compares entry and entry+1 without wrapping the latter.
         * Y wraps across 12-row chunks and at the world's last chunk. */
        if((mx==entry.x || (uint16_t)mx==(uint16_t)entry.x+1u) &&
           (my==entry.y || my==(entry.y+1u)%96u)) {
            action->mode=entry.mode;action->target=entry.target;
            action->a=entry.a;action->b=entry.b;action->metatile=meta;action->flags=flags;
            return action->mode;
        }
    }
    return 0;
}
