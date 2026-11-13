#pragma bank 31
#include <gb/gb.h>
#include <gb/cgb.h>
#include "battle_scene.h"
#include "battle_scene_data.h"
#include "scene.h"
#include "game_transition.h"
#include "bank_io.h"
#include "battle_motion.h"
#include "battle_animation_data.h"
#include "dungeon_graphics.h"
#include "battle_weapon.h"
#include "weapon_data.h"
#include "enemy_magic.h"
#include "enemy_magic_data.h"
#include "boss_motion.h"
#include "boss_effects_data.h"
#include "gold_scene.h"
extern uint8_t scene_shared_bytes[40];
extern uint16_t scene_shared_colors[32];
uint8_t battle_scene_type,battle_scene_palette,battle_scene_enemy;
static uint8_t current_clip,current_animated;
static uint16_t current_asset;
uint8_t battle_scene_world_type(uint8_t group,uint8_t flags) __banked {
    uint8_t type=flags>>4;
    if(!group && type==5u)type=4u;
    else if((group==1u||group==7u)&&type==1u)type=5u;
    else if(group==8u)type=6u;
    else if(group==10u&&type==9u)type=8u;
    return type?type:1u;
}
void battle_scene_configure(uint8_t type,uint8_t palette) __banked {
    battle_scene_type=type;battle_scene_palette=palette<12u?palette:0u;
}
void battle_scene_hide(void) __banked {
    scene_actor_hide();SPRITES_8x8;battle_scene_enemy=0;current_asset=65535u;current_clip=255u;current_animated=0;
}
static uint8_t background(uint8_t enemy) {
    if(!battle_scene_type)return !enemy;
    if(battle_scene_type>=64u && battle_scene_type<76u)return scene_show_room(battle_scene_type-64u,0,enemy);
    return scene_show(battle_scene_type,0,enemy);
}
void battle_scene_clear(void) __banked {
    uint8_t composed=battle_scene_enemy==72u||battle_scene_enemy==73u;
    battle_scene_hide();if(composed)background(0);
}
static void current_descriptor(BattleSceneAsset *asset) {
    if(current_animated==3u)bank_copy(asset,BOSS_DATA_BANK,boss_assets+current_asset,sizeof *asset);
    else if(current_animated==2u)bank_copy(asset,ENEMY_MAGIC_BANK,enemy_magic_assets+current_asset,sizeof *asset);
    else if(current_animated)bank_copy(asset,BATTLE_ANIMATION_DESCRIPTOR_BANK,battle_animation_assets+current_asset,sizeof *asset);
    else *asset=battle_scene_assets[current_asset];
}
static void current_pool(uint16_t pair,BattleScenePool *pool) {
    if(current_animated==3u)bank_copy(pool,BOSS_DATA_BANK,boss_pools+(pair>>8),sizeof *pool);
    else if(current_animated==2u)bank_copy(pool,ENEMY_MAGIC_BANK,enemy_magic_pools+(pair>>8),sizeof *pool);
    else *pool=(current_animated?battle_animation_pools:battle_scene_pools)[pair>>8];
}
void battle_scene_clip(uint8_t window_y) __banked {
    BattleSceneAsset local;const BattleSceneAsset *asset;BattleScenePool pool;
    uint8_t i,x,y,prop,line;uint16_t pair;
    if(!battle_scene_enemy)return;
    if(current_asset==65535u){current_clip=window_y;return;}
    if(!window_y){HIDE_SPRITES;current_clip=0;return;}
    if(window_y==current_clip){SHOW_SPRITES;return;}
    current_descriptor(&local);asset=&local;
    for(i=0;i<asset->sprites;++i) {
        bank_copy(scene_shared_bytes,asset->bank,asset->data+(uint16_t)i*5u,5u);
        x=scene_shared_bytes[0];y=scene_shared_bytes[1];prop=scene_shared_bytes[4];
        pair=scene_shared_bytes[2]|((uint16_t)scene_shared_bytes[3]<<8);
        if(y-16u>=window_y){move_sprite(i,0,0);continue;}
        current_pool(pair,&pool);
        bank_copy(scene_shared_bytes,pool.bank,pool.data+((pair&255u)<<5),32u);
        if(y>window_y)for(line=window_y-(y-16u);line<16u;++line){scene_shared_bytes[line*2u]=0;scene_shared_bytes[line*2u+1u]=0;}
        VBK_REG=1;set_sprite_data(84u+i*2u,2,scene_shared_bytes);VBK_REG=0;
        set_sprite_tile(i,84u+i*2u);set_sprite_prop(i,prop);move_sprite(i,x,y);
    }
    for(;i<40u;++i)move_sprite(i,0,0);
    SPRITES_8x16;current_clip=window_y;SHOW_SPRITES;
}
uint8_t battle_scene_begin(uint8_t enemy) __banked {
    const BattleSceneAsset *asset;
    if(!enemy||enemy>74u)return 0;
    battle_scene_hide();battle_scene_enemy=enemy;
    if(enemy==72u||enemy==73u){current_asset=65535u;current_clip=120u;return background(enemy);}
    if(enemy==70u&&battle_scene_type==14u)gold_scene_show(2u);
    else if(battle_scene_type&&!background(0)){battle_scene_enemy=0;return 0;}
    current_asset=battle_scene_lookup[enemy-1u][battle_scene_type==0u?battle_scene_palette:0u];
    asset=battle_scene_assets+current_asset;
    bank_copy(scene_shared_colors,asset->bank,asset->data+(uint16_t)asset->sprites*5u,64u);
    set_sprite_palette(0,8,scene_shared_colors);scene_actor_active=1;
    battle_scene_clip(120u);return 1;
}

uint8_t battle_scene_animation_frame(uint8_t frame) __banked {
    BattleSceneAsset asset;uint8_t clip=current_clip,kind=1;uint16_t index;
    index=battle_motion_asset(battle_scene_enemy,frame,battle_scene_type==0u?battle_scene_palette:0u);
    if(index==65535u){index=enemy_magic_pose(battle_scene_enemy,frame,battle_scene_type==0u?battle_scene_palette:0u);if(index==65535u)return 0;kind=2;}
    current_asset=index;current_animated=kind;current_descriptor(&asset);
    bank_copy(scene_shared_colors,asset.bank,asset.data+(uint16_t)asset.sprites*5u,64u);
    set_sprite_palette(0,8,scene_shared_colors);current_clip=255u;battle_scene_clip(clip);return 1;
}

static void overlay_prepare(uint8_t group,uint8_t white) {
    BattleSceneAsset local;const BattleSceneAsset *asset;uint8_t p,c;
    if(!battle_scene_enemy||current_asset==65535u)return;
    current_descriptor(&local);asset=&local;
    bank_copy(scene_shared_colors,asset->bank,asset->data+(uint16_t)asset->sprites*5u,64u);
    if(white){
        bank_copy(scene_shared_bytes,asset->bank,asset->data+(uint16_t)asset->sprites*5u+64u+(uint16_t)group*8u,8u);
        for(p=0;p<8u;++p)for(c=1;c<4u;++c)if(scene_shared_bytes[p]&(1u<<c))scene_shared_colors[p*4u+c]=RGB(31,31,31);
    }
}
static void overlay_flash(uint8_t group,uint8_t white) {
    overlay_prepare(group,white);set_sprite_palette(0,8,scene_shared_colors);
}

void battle_scene_flash_enemy(uint8_t white) __banked {
    game_transition_vint16();
    scene_palette_capture();
    if(battle_scene_enemy==72u||battle_scene_enemy==73u)scene_palette_prepare(4u,white);
    else if(battle_scene_enemy==70u&&battle_scene_type==14u)gold_scene_prepare(2u,4u,white);
    overlay_prepare(0u,white);scene_palette_commit();
}
void battle_scene_flash_party(uint8_t white,uint8_t extra) __banked {
    const DungeonGraphicAsset *palette;uint8_t i;
    game_transition_vint16();scene_palette_capture();
    if(battle_scene_enemy==70u&&battle_scene_type==14u)gold_scene_prepare(2u,extra?3u:1u,white);
    else if(battle_scene_type)scene_palette_prepare(extra?3u:1u,white);
    else {
        palette=dungeon_graphic_palettes+battle_scene_palette;
        bank_copy(scene_palette_background,palette->bank,palette->data+312u,56u);
        if(white){
            bank_copy(scene_shared_bytes,palette->bank,palette->data+376u,28u);
            for(i=0;i<28u;++i)if(scene_shared_bytes[i])scene_palette_background[i]=RGB(31,31,31);
        }
    }
    if(extra)overlay_prepare(1u,white);
    scene_palette_commit();
}

static uint8_t effect_frame(uint16_t index,uint8_t bank,const BattleSceneAsset *assets,const BattleScenePool *pools,uint8_t shift) {
    BattleSceneAsset effect,base;BattleScenePool pool;
    uint16_t pair;uint8_t i,base_count=0,x,y,prop,line,slot;
    if(index==65535u)return 0;
    bank_copy(&effect,bank,assets+index,sizeof effect);
    if(current_asset!=65535u){
        current_descriptor(&base);base_count=base.sprites;
    }
    if(base_count+effect.sprites>40u)return 0;
    /* Enemy patterns stay fixed. Shift their OAM records behind the effect;
     * source higher-priority enemy pixels were removed from effect alpha. */
    for(i=0;i<base_count;++i){
        bank_copy(scene_shared_bytes,base.bank,base.data+(uint16_t)i*5u,5u);
        x=scene_shared_bytes[0];y=scene_shared_bytes[1];slot=i+effect.sprites;
        set_sprite_tile(slot,84u+i*2u);set_sprite_prop(slot,scene_shared_bytes[4]);
        if(!current_clip||y-16u>=current_clip)move_sprite(slot,0,0);else move_sprite(slot,x,y);
    }
    for(i=0;i<effect.sprites;++i){
        bank_copy(scene_shared_bytes,effect.bank,effect.data+(uint16_t)i*5u,5u);
        x=scene_shared_bytes[0];y=scene_shared_bytes[1];prop=scene_shared_bytes[4];
        pair=scene_shared_bytes[2]|((uint16_t)scene_shared_bytes[3]<<8);
        bank_copy(&pool,bank,pools+(pair>>shift),sizeof pool);
        bank_copy(scene_shared_bytes,pool.bank,pool.data+((pair&(shift==7u?127u:255u))<<5),32u);
        if(y>current_clip)for(line=current_clip>y-16u?current_clip-(y-16u):0u;line<16u;++line){scene_shared_bytes[line*2u]=0;scene_shared_bytes[line*2u+1u]=0;}
        VBK_REG=1;set_sprite_data(84u+(base_count+i)*2u,2u,scene_shared_bytes);VBK_REG=0;
        set_sprite_tile(i,84u+(base_count+i)*2u);set_sprite_prop(i,prop);
        if(!current_clip||y-16u>=current_clip)move_sprite(i,0,0);else move_sprite(i,x,y);
    }
    for(i=base_count+effect.sprites;i<40u;++i)move_sprite(i,0,0);
    bank_copy(scene_shared_colors,effect.bank,effect.data+(uint16_t)effect.sprites*5u,16u);
    set_sprite_palette(6,2,scene_shared_colors);SPRITES_8x16;scene_actor_active=1;
    if(current_clip)SHOW_SPRITES;return 1;
}
uint8_t battle_scene_weapon_frame(uint8_t frame) __banked {
    return effect_frame(battle_weapon_asset(battle_scene_enemy,frame),WEAPON_DATA_BANK,weapon_assets,weapon_pools,WEAPON_POOL_SHIFT);
}
uint8_t battle_scene_magic_frame(uint8_t frame) __banked {
    return effect_frame(enemy_magic_asset(battle_scene_enemy,frame),ENEMY_MAGIC_BANK,enemy_magic_assets,enemy_magic_pools,8u);
}
void battle_scene_weapon_clear(void) __banked {
    uint8_t clip=current_clip,i;
    if(current_asset!=65535u){current_clip=255u;battle_scene_clip(clip);overlay_flash(0u,0u);}
    else{for(i=0;i<40u;++i)move_sprite(i,0,0);SPRITES_8x8;}
}

uint8_t battle_scene_boss_frame(uint8_t frame,uint8_t y) __banked {
 BattleSceneAsset asset;uint8_t i,clip=current_clip;uint16_t index;
 if(!frame){for(i=0;i<40u;++i)move_sprite(i,0,0);current_asset=65535u;current_animated=0;return 1;}
 index=boss_motion_asset(battle_scene_enemy,frame,y);if(index==65535u)return 0;
 current_asset=index;current_animated=3;current_descriptor(&asset);
 bank_copy(scene_shared_colors,asset.bank,asset.data+(uint16_t)asset.sprites*5u,64u);set_sprite_palette(0,8,scene_shared_colors);
 current_clip=255u;scene_actor_active=1;battle_scene_clip(clip);return 1;
}
void battle_scene_boss_patch(uint8_t patch) __banked {
 const uint8_t *data;uint8_t i,cell,attr;
 if(battle_scene_enemy!=73u||patch>2u)return;
 bank_copy(&data,BOSS_DATA_BANK,boss_patches+patch,sizeof data);
 for(i=0;i<BOSS_PATCH_CELLS;++i){
  cell=bank_read8(BOSS_DATA_BANK,boss_patch_cells+i);attr=bank_read8(255u,data+16u);
  bank_bkg_data(255u,cell,1u,data,0u);VBK_REG=1;set_bkg_tiles(cell%20u,cell/20u,1u,1u,&attr);data+=17u;
 }VBK_REG=0;
}
