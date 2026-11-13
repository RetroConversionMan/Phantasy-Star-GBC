#pragma bank 17
#include <gb/gb.h>
#include <gb/cgb.h>
#include "dungeon_present.h"
#include "dungeon_motion.h"
#include "dungeon_render.h"
#include "scene.h"
#include "audio.h"
#include "travel.h"
#include "game_transition.h"
extern uint8_t background_changed;
extern uint16_t scene_shared_colors[32];
static void wait_frames(uint8_t count) {while(count--)vsync();}
void dungeon_present_prepare(const DungeonState *s) DUNGEON_BANKED {
    HIDE_WIN;HIDE_SPRITES;
    if(scene_actor_active){dungeon_motion_invalidate();scene_actor_hide();}
    if(background_changed||!dungeon_motion_active) {
        dungeon_motion_invalidate();background_changed=0;dungeon_motion_render(s,0);
    }
}
void dungeon_present_frame(const DungeonState *s,uint8_t frame) DUNGEON_BANKED {
    dungeon_motion_render(s,frame);
    /* The uploader already commits each moving pose at VBlank (source6AE5).
     * Keep a complete visible standing frame before object/battle callbacks;
     * this also gives an immediately cached frame0 its required VBlank. */
    if(!frame)vsync();
}
void dungeon_present_sequence(const DungeonState *s,uint8_t sequence) DUNGEON_BANKED {
    uint8_t i,frame;
    for(i=0;i<9u;++i) {
        frame=dungeon_motion_sequence_frame(sequence,i);if(frame==255u)break;
        dungeon_present_frame(s,frame);
    }
}
void dungeon_present_turn(const DungeonState *s,uint8_t right) DUNGEON_BANKED {
    dungeon_present_sequence(s,dungeon_motion_turn_sequence(s,right));
}
void dungeon_present_door(const DungeonState *s,uint8_t style) DUNGEON_BANKED {
    uint8_t i;if(style<2u||style>4u)return;
    audio_command(0xbd);
    for(i=0;i<3u;++i) {
        dungeon_motion_render_image(dungeon_motion_door_image(style+i*3u),s->palette_index);
        wait_frames(4u);
    }
    dungeon_motion_home();
}
void dungeon_present_transition(const DungeonState *s,uint8_t stairs) DUNGEON_BANKED {
    if(stairs)audio_command(0xc3);
    game_transition_fade_out();
    dungeon_motion_palette_muted=1;dungeon_motion_render(s,0);dungeon_motion_palette_muted=0;
    DISPLAY_OFF;set_bkg_palette(0u,7u,(const uint16_t *)dungeon_render_palette);
    scene_fade_begin(1u);DISPLAY_ON;
    game_transition_fade_in();
}
static void fill_map(uint16_t base,uint8_t first,uint8_t rows,uint8_t tile,uint8_t attr) {
    uint16_t address=base+(uint16_t)first*32u,count=(uint16_t)rows*32u;
    VBK_REG=0;vmemset((void *)address,tile,count);VBK_REG=1;vmemset((void *)address,attr,count);VBK_REG=0;
}
static uint8_t black_tile(uint8_t tile,uint8_t bank) {
    uint8_t i,code;uint8_t *bytes=(uint8_t *)scene_shared_colors;
    for(i=0;i<28u;++i)if(!((uint16_t *)dungeon_render_palette)[i])break;
    code=i&3u;
    for(uint8_t row=0;row<8u;++row){bytes[row*2u]=(code&1u)?255u:0u;bytes[row*2u+1u]=(code&2u)?255u:0u;}
    VBK_REG=bank;set_bkg_data(tile,1u,bytes);VBK_REG=0;return (i>>2)|(bank<<3);
}
static void fall(const DungeonState *s,uint8_t room) {
    uint8_t i,old_black,new_black,old_tile=room?127u:242u;
    /* Original661C clears each retired source strip. Since all source scroll
     * increments are16 pixels,5/8 scaling is exactly a10-pixel translation. */
    if(room) {
        HIDE_WIN;HIDE_SPRITES;vsync();
        scene_palette_capture();
        for(i=0;i<28u;++i)((uint16_t *)dungeon_render_palette)[i]=scene_palette_background[i];
        dungeon_motion_external_view();
        LCDC_REG&=(uint8_t)~LCDCF_BG9C00;move_bkg(0,0);
    } else dungeon_motion_home();
    /* Original fontC0 is solid source color1 (black). UI palette7's native
     * background is blue, so use spare BGbank0 slots242/243 for exact black. */
    /* A room uses all256 primary tiles, so its outgoing black strip must
     * use the unused secondary tile127 until that room is fully offscreen. */
    old_black=black_tile(old_tile,room);
    fill_map(0x9800u,15u,17u,old_tile,old_black);fill_map(0x9c00u,0u,18u,0u,15u);
    LCDC_REG|=LCDCF_WIN9C00;move_win(7u,120u);SHOW_WIN;audio_command(0xc0);
    for(i=1u;i<=12u;++i){vsync();move_bkg(0,i*10u);}
    vsync();game_transition_vint16();
    /* The old picture is now entirely outside the native viewport. A blank
     * window on9800 hides the inactive9C00 upload, including its palette. */
    if(room){
        old_black=black_tile(242u,0u);black_tile(242u,1u);
        /* Tile and attribute maps are written separately while the retired
         * strip is still visible. Both banks must contain the same black
         * tile until its old secondary-bank attributes have been replaced. */
    }
    fill_map(0x9800u,0u,32u,242u,old_black);LCDC_REG&=(uint8_t)~LCDCF_WIN9C00;move_win(7u,0u);
    dungeon_motion_palette_muted=1;
    dungeon_motion_render_image(dungeon_motion_scene(s,0),s->palette_index);
    dungeon_motion_palette_muted=0;
    new_black=black_tile(243u,0u);fill_map(0x9c00u,15u,17u,243u,new_black);
    /* The room and dungeon can encode black with different palette slots.
     * Commit the incoming colors and remove the blank window in one VBlank;
     * GBDK's per-color setter can expose a colored strip during this switch. */
    scene_palette_capture();
    for(i=0;i<28u;++i)scene_palette_background[i]=((uint16_t *)dungeon_render_palette)[i];
    scene_palette_commit();move_bkg(0,136u);HIDE_WIN;
    fill_map(0x9800u,0u,18u,0u,15u);
    vsync();move_win(7u,120u);SHOW_WIN;
    for(i=0u;i<12u;++i){vsync();move_bkg(0,136u+i*10u);}
    for(i=0u;i<5u;++i){vsync();move_bkg(0,(i&1u)?251u:0u);}
    vsync();
    fill_map(0x9c00u,15u,3u,0u,15u);HIDE_WIN;
    /* The blank fall window temporarily used9800. Restore the UI window
     * map before any menu/dialogue/title can write over the home BG map. */
    LCDC_REG|=LCDCF_WIN9C00;dungeon_motion_home();move_bkg(0,0);
}
void dungeon_present_fall(const DungeonState *s) DUNGEON_BANKED {fall(s,0u);}
void dungeon_present_scene_fall(const DungeonState *s) DUNGEON_BANKED {fall(s,1u);}
