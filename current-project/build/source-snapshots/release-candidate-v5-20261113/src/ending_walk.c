/* Native playback of the original Z80 ending dungeon/credit VDP trace. */
#pragma bank 136
#include <gb/gb.h>
#include <gb/cgb.h>
#include "ending_walk.h"
#include "ending_walk_data.h"
#include "ending_upload.h"
#include "dungeon_upload.h"
#include "audio.h"
#include "game_transition.h"
#include "ending_waits.h"
uint16_t ending_walk_frame;
uint8_t ending_walk_busy;
static uint16_t run_index,current_image;
static uint8_t run_left,lighting,sound_index,current_palette,active,pending_palette;
static void commit(void) {
    ending_upload_commit();set_bkg_palette(0,7,ending_palettes[pending_palette]);
    current_image=ending_runs[run_index].image;current_palette=pending_palette;
    ending_walk_busy=0;
}
static void present(void) {
    const EndingRun *run=ending_runs+run_index;
    const EndingAsset *image=ending_images+run->image;
    uint8_t palette=lighting?run->light:run->dark;
    if(run->image!=current_image) {
        pending_palette=palette;ending_walk_busy=1;
        ending_upload_begin(image->bank,image->data,current_image==65535u?0u:ending_upload_buffer^1u);
    } else if(palette!=current_palette) {
        set_bkg_palette(0,7,ending_palettes[palette]);current_palette=palette;
    }
    run_left=run->duration;
}
static void sound(void) {
    if(ending_wait16[ending_walk_frame>>3]&(1u<<(ending_walk_frame&7u)))game_transition_vint16();
    if(sound_index<ENDING_SOUND_COUNT&&ending_sounds[sound_index].frame==ending_walk_frame)
        audio_command(ending_sounds[sound_index++].command);
}
void ending_walk_begin(uint8_t light) __banked {
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;dungeon_invalidate_view_cache();
    ending_walk_frame=0;run_index=0;current_image=65535u;lighting=light!=0u;
    sound_index=0;current_palette=255u;active=1;ending_walk_busy=0;
    ending_upload_fault=0;sound();present();while(!ending_upload_step());commit();SHOW_BKG;DISPLAY_ON;
}
uint8_t ending_walk_tick(void) __banked {
    if(!active)return 1;
    if(ending_walk_busy){if(ending_upload_step())commit();return 0;}
    if(++ending_walk_frame==ENDING_WALK_FRAMES) {
        ending_upload_home();active=0;dungeon_invalidate_view_cache();return 1;
    }
    sound();
    if(!--run_left){
        ++run_index;present();
        /* Begin work at the source image boundary, without an extra idle
         * native frame. The previous complete image stays visible until commit. */
        if(ending_walk_busy&&ending_upload_step())commit();
    }
    return 0;
}
