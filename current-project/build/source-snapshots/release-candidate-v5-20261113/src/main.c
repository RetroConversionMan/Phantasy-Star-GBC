/* Native Phantasy Star world, RPG, story, battle, dungeon and audio integration.
 * See PROJECT_STATE.json for current verification and platform limitations.
 * The frozen baseline remains a separate, unchanged artifact. */
#include <gb/gb.h>
#include <gb/cgb.h>
#include <stdint.h>
#include <string.h>
#include "assets.h"
#include "font.h"
#include "bank_io.h"
#include "world.h"
#include "world_motion.h"
#include "world_rules.h"
#include "rpg.h"
#include "events.h"
#include "services.h"
#include "battle_view.h"
#include "dungeon_play.h"
#include "dungeon_render.h"
#include "dungeon_motion.h"
#include "scene.h"
#include "dialogue.h"
#include "save.h"
#include "ui.h"
#include "game_ui.h"
#include "audio.h"
#include "cutscene.h"
#include "game_flow.h"
#include "vehicle_art.h"
#include "game_field.h"
#include "battle_scene.h"
#include "game_sequence.h"
#include "game_movie.h"
#include "save_ui.h"
#include "inventory_menu.h"
#include "party_world.h"
#include "vehicle_cycle.h"
#include "game_transition.h"
#include "travel.h"

#define STATE_TITLE 0u
#define STATE_WALK 1u
#define STATE_MENU 2u
#define STATE_HELP 3u
#define STATE_DIALOGUE 4u
#define STATE_PROMPT 5u
#define STATE_SHOP 6u
#define STATE_REPLACE 7u
#define STATE_NOTICE 8u
#define STATE_INVENTORY 9u
#define STATE_ITEM 10u
#define STATE_PARTY 11u
#define STATE_BUY 12u
#define STATE_STATUS 13u
#define STATE_BUY_SELL 14u
#define STATE_BATTLE 15u
#define STATE_TRAVEL_MENU 16u
#define STATE_DUNGEON 17u
#define STATE_CUTSCENE 18u
#define STATE_MAP_MAGIC 19u
#define PARTY_MAGIC_CASTER 128u
#define PARTY_MAGIC_TARGET 129u
#define PARTY_FIELD_ITEM 130u
#define SAVE_BASE ((volatile uint8_t *)0xa000)

/* Exported for emulator assertions. Never initialize game state through tests
 * in release code; test harnesses may inject fixtures in WRAM separately. */
uint16_t player_x, player_y, camera_x, camera_y;
uint8_t screen_state, facing, walk_frame, saved_position_valid, step_remaining;
uint8_t game_vehicle;
uint8_t scene_context_type;
static uint8_t vehicle_loaded_facing=255;
uint16_t frame_counter;
RPGState game_rpg;
EventState game_events;
ServiceState game_service;
DungeonPlay game_dungeon;
static union {GameSave state;uint8_t data[SAVE_BYTES];} save_storage;
#define save_state save_storage.state
#define save_data save_storage.data
static DialogueCursor dialogue;
static uint16_t dialogue_wait;
uint8_t dialogue_revealing;
static uint8_t dialogue_clock;
static CutsceneState game_cutscene;
static char story_lower[2][19];
WorldAction world_action;
WorldAction ship_departure,ship_arrival,ship_exit;
static WorldRuleAction terrain_action;
uint8_t last_keys;
static uint8_t deferred_buttons;
uint8_t menu_choice,title_choice;
uint8_t choice,shop_id,shop_count,item_slot,item_action,party_choice;
uint8_t magic_caster,magic_choice;
static uint8_t selected_field_spell;
static uint8_t party_purpose;
uint8_t notice_return,replace_source;
uint8_t service_active,service_selector;
uint8_t battle_from_event;
uint16_t battle_object_flag;
uint8_t retained_trap,background_changed,dark_menu_pending,dungeon_keys_delay;
static int8_t step_dx,step_dy;
static uint16_t return_x,return_y; /* Original last safe map position C313/C311. */
static const uint16_t ui_palette[]={RGB(2,3,8),RGB(6,10,19),RGB(30,22,8),RGB(30,30,27)};
static const char *const names[]={"ALIS","MYAU","ODIN","NOAH"};
void apply_service(void);
static void service_selection(void);
void resume_walk(void);
static void dialogue_draw(uint8_t narrative) {
    ui_text(1,1,dialogue.lines[0]);ui_text(1,2,dialogue.lines[1]);
    if(narrative){ui_text(1,3,story_lower[0]);ui_text(1,4,story_lower[1]);}
}
static void dialogue_glyph(void) {
    char glyph[2];uint8_t row=dialogue.row,column=dialogue.column;
    glyph[0]=row<2u?dialogue.lines[row][column-1u]:story_lower[row-2u][column-1u];glyph[1]=0;
    ui_text(column,row+1u,glyph);
}
static uint8_t dialogue_tick(uint8_t narrative,uint8_t pressed) {
    uint8_t result;
    if(dialogue_revealing) {
        if(dialogue_clock==audio_clock)return 0;
        dialogue_clock=audio_clock;
        result=dialogue_stream_next(&dialogue,narrative?story_lower:0);
        if(result==DIALOGUE_STREAM_CHAR)dialogue_glyph();
        else if(result==DIALOGUE_STREAM_SCROLL)dialogue_draw(narrative);
        dialogue_clock=audio_clock;
        if(result!=DIALOGUE_STREAM_WAIT)return 0;
        dialogue_revealing=0;
        dialogue_wait=dialogue_wait_frames(dialogue.done?dialogue.terminator:0x61u,narrative);
        if(!dialogue_wait)return 1;
        if(dialogue_wait==65535u)ui_text(17,narrative?7u:4u,">");
        return 0;
    }
    return dialogue_wait_tick(&dialogue_wait,dialogue.done?dialogue.terminator:0x61u,narrative,pressed);
}
static void story_page(void) {
    dialogue_revealing=1;screen_state=STATE_CUTSCENE;
    ui_panel(80,8);dialogue_clock=audio_clock;
}
static void show_cutscene_record(void) {
    if(game_cutscene.action.kind==CUTSCENE_DONE) {
        if(game_movie_story_done())return;
        audio_command(0xd8);event_advance(&game_events);apply_event();return;
    }
    if(scene_actor_active)scene_actor_hide();
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
    cutscene_portrait_show(game_cutscene.action.portrait);background_changed=1;DISPLAY_ON;
    dialogue_open(&dialogue,game_cutscene.action.dialogue_id);
    dialogue_stream_begin(&dialogue,story_lower);story_page();
}
void start_cutscene(uint8_t sequence) {
    if(sequence<=CUTSCENE_NOAH||sequence==CUTSCENE_LAERMA)audio_command(0x8a);
    cutscene_begin(&game_cutscene,sequence,&game_rpg);show_cutscene_record();
}
void draw_dungeon(void) {
    scene_context_type=0;
    if(scene_actor_active)scene_actor_hide();
    HIDE_WIN;HIDE_SPRITES;
    if(background_changed){dungeon_invalidate_view_cache();background_changed=0;}
    dungeon_render(&game_dungeon.dungeon,0);
}
void draw_dungeon_faded(void) {
    /* The native uploader enables LCD after committing its picture. Keep
     * that upload black, then capture incoming target colors while off. */
    dungeon_motion_palette_muted=1;draw_dungeon();dungeon_motion_palette_muted=0;
    DISPLAY_OFF;set_bkg_palette(0u,7u,(const uint16_t *)dungeon_render_palette);
    scene_fade_begin(1u);DISPLAY_ON;
}
void begin_battle(uint8_t enemy,uint8_t from_event) {
    if(from_event==0u||from_event==2u) {
        if(game_dungeon.active)draw_dungeon();
        else scene_context_type=battle_scene_world_type(world_group_id,
            world_flags_at((player_x-8u)&2047u,(player_y+1536u-16u)%1536u));
    }
    battle_scene_configure(scene_context_type,game_dungeon.active?game_dungeon.dungeon.palette_index:0);
    if(scene_actor_active)scene_actor_hide();
    battle_from_event=from_event;
    if(battle_view_begin(&game_rpg,enemy)==RPG_OK) {
        if(from_event==1u)battle_view_menu_allowed=game_events.event==22u||game_events.event==130u||game_events.event==147u;
        else if(from_event==3u)battle_view_menu_allowed=0;
        retained_trap=battle_view_battle.trap_chance;background_changed=1;screen_state=STATE_BATTLE;
        if(game_dungeon.active)battle_view_battle.escape_blocked=dplay_escape_blocked(&game_dungeon);
    }
}

static void compute_camera(void) {
    camera_x=(player_x+WORLD_PIXEL_WIDTH-80u)&2047u;
    camera_y=(player_y+WORLD_PIXEL_HEIGHT-80u)%WORLD_PIXEL_HEIGHT;
}
static void draw_player(void) {
    uint8_t sx=(uint8_t)((player_x+WORLD_PIXEL_WIDTH-camera_x)&2047u);
    uint8_t sy=(uint8_t)((player_y+WORLD_PIXEL_HEIGHT-camera_y)%WORLD_PIXEL_HEIGHT);
    if(game_vehicle) {
        if(vehicle_loaded_facing!=facing) {
            DISPLAY_OFF;vehicle_sprite_load(game_vehicle,facing);DISPLAY_ON;vehicle_loaded_facing=facing;
        }
        vehicle_sprite_draw(sx,sy);return;
    }
    party_world_draw();
}
static void redraw_world(uint8_t force) {
    world_terrain_sync(player_x,player_y);
    compute_camera();world_draw(camera_x,camera_y,force);draw_player();
}
/* Source GameMode_LoadMap always repacks actors and reloads the map, even
 * when returning from the field menu. C2F4 suppresses only unchanged music. */
void reload_world_mode(void) {
    game_transition_fade_out();
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;scene_actor_hide();
    world_select(world_map_id);world_load_graphics();
    world_vehicle_footprint(player_x,player_y,game_vehicle);vehicle_loaded_facing=255;vehicle_palette_reset();
    return_x=player_x;return_y=player_y;step_remaining=0;walk_frame=0;
    if(!game_vehicle)party_world_reset(0);
    redraw_world(1);scene_fade_begin(1u);DISPLAY_ON;
    game_transition_wait(5u,0u); /* Four0A actor uploads, then744B map12 upload. */
    game_transition_map_music(game_vehicle?0x8f:audio_map_track(world_map_id));
    game_transition_wait(1u,0u); /* Original2FD's14 upload. */
    game_transition_fade_in();
    scene_context_type=0;background_changed=0;HIDE_WIN;SHOW_SPRITES;screen_state=STATE_WALK;
}
void enter_map(uint8_t id,uint16_t x,uint16_t y) {
    battle_view_chest_abandon();
    game_vehicle=0;game_dungeon.active=0;dark_menu_pending=0;
    game_events.event=0;game_events.type=0;
    world_select(id);player_x=x;player_y=y;reload_world_mode();
}
/* Travel already performed the source final map reload and fade. Adopt that
 * complete picture without restarting its actors, animation phase or music. */
void enter_map_ready(uint8_t id,uint16_t x,uint16_t y) {
    battle_view_chest_abandon();world_select(id);player_x=x;player_y=y;
    game_vehicle=0;vehicle_loaded_facing=255;game_dungeon.active=0;dark_menu_pending=0;
    game_events.event=0;game_events.type=0;scene_context_type=0;background_changed=0;
    return_x=x;return_y=y;step_remaining=0;walk_frame=0;
    HIDE_WIN;SHOW_SPRITES;screen_state=STATE_WALK;
}
void resume_walk(void) {
    if(battle_view_field_menu_pending){battle_view_chest_leave();screen_state=STATE_BATTLE;return;}
    if(game_transition_interaction_music(game_events.type))audio_command(0xd8);
    game_events.event=0;game_events.type=0;
    if(game_dungeon.active) {
        if(dark_menu_pending) {
            dark_menu_pending=0;
            if(!game_dungeon.dungeon.light){enter_map(world_map_id,player_x,player_y);return;}
            dungeon_refresh_light(&game_dungeon.dungeon);
        }
        if(background_changed){
            game_transition_fade_out();draw_dungeon_faded();
            game_transition_map_music(game_dungeon.dungeon.music);game_transition_fade_in();
        }
        dplay_resume(&game_dungeon,&game_rpg,&game_events);apply_dungeon();return;
    }
    reload_world_mode();
}




uint8_t game_read_slot(uint8_t slot) {
    uint16_t i,offset=save_slot_offset(slot);
    if(offset==65535u){saved_position_valid=0;return 0;}
    ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);
    for(i=0;i<SAVE_BYTES;++i) save_data[i]=SAVE_BASE[offset+i];
    DISABLE_RAM_MBC5;saved_position_valid=save_decode(&save_state,save_data);
    return saved_position_valid;
}
static void read_save(void) {game_read_slot(save_active_slot);}
uint8_t game_write_slot(uint8_t slot) {
    uint16_t i,offset=save_slot_offset(slot);
    if(offset==65535u)return 0;
    save_state.map=world_map_id;save_state.facing=facing;save_state.x=player_x;save_state.y=player_y;
    memcpy(&save_state.rpg,&game_rpg,sizeof(game_rpg));memcpy(save_state.flags,game_events.flags,256);
    save_state.secrets_requests=game_events.secrets_requests;
    save_state.last_church=game_events.last_church;
    memcpy(save_state.object_flags,game_events.object_flags,256);
    save_state.dungeon_active=game_dungeon.active;save_state.dungeon_floor=game_dungeon.dungeon.floor;
    save_state.dungeon_position=game_dungeon.dungeon.position;save_state.dungeon_direction=game_dungeon.dungeon.direction;
    save_state.dungeon_light=game_dungeon.dungeon.light;
    save_state.vehicle=game_vehicle;
    save_state.vehicle_phase=vehicle_cycle.phase;save_state.vehicle_clock=vehicle_cycle.clock;
    if(!save_encode(save_data,&save_state)) return 0;
    ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);SAVE_BASE[offset]=0;
    for(i=1;i<SAVE_BYTES;++i) SAVE_BASE[offset+i]=save_data[i];
    SAVE_BASE[offset]=save_data[0];DISABLE_RAM_MBC5;
    save_active_slot=slot;save_valid_mask|=1u<<slot;saved_position_valid=1;return 1;
}
static uint8_t write_save(void) {return game_write_slot(save_active_slot);}
void start_game(uint8_t continued) {
    field_active=0;battle_view_chest_abandon();
    if(continued) {
        read_save();
        if(!saved_position_valid) {title_choice=0;title_screen();return;}
        vehicle_cycle.phase=save_state.vehicle_phase;vehicle_cycle.clock=save_state.vehicle_clock;
        memcpy(&game_rpg,&save_state.rpg,sizeof(game_rpg));event_init(&game_events,&game_rpg);
        memcpy(game_events.flags,save_state.flags,256);facing=save_state.facing;
        game_events.secrets_requests=save_state.secrets_requests;
        game_events.last_church=save_state.last_church;
        memcpy(game_events.object_flags,save_state.object_flags,256);
        /* Source634 restores C300..C6FF before one LoadMap/LoadDungeon.
         * Never expose an intermediate on-foot map for vehicle/dungeon saves. */
        world_select(save_state.map);player_x=save_state.x;player_y=save_state.y;
        return_x=player_x;return_y=player_y;game_vehicle=save_state.vehicle;
        game_dungeon.active=0;dark_menu_pending=0;step_remaining=0;
        if(save_state.dungeon_active) {
            game_transition_fade_out();game_vehicle=0;
            memset(&game_dungeon,0,sizeof(game_dungeon));
            dungeon_enter(&game_dungeon.dungeon,save_state.dungeon_floor,save_state.dungeon_position,save_state.dungeon_direction);
            game_dungeon.dungeon.light=save_state.dungeon_light;
            if(rpg_find_item(&game_rpg,ItemID_MagicLamp)!=RPG_NO_SLOT)game_dungeon.dungeon.light=255u;
            dungeon_refresh_light(&game_dungeon.dungeon);game_transition_map_music(game_dungeon.dungeon.music);
            game_dungeon.active=1;game_dungeon.initial_dark=1;game_dungeon.check_count=1;
            game_dungeon.positions[0]=save_state.dungeon_position;game_dungeon.views[0]=1;
            background_changed=1;draw_dungeon_faded();game_transition_wait(2u,0u);game_transition_fade_in();
            dplay_resume(&game_dungeon,&game_rpg,&game_events);apply_dungeon();
        } else reload_world_mode();
    } else {
        memset(&game_dungeon,0,sizeof(game_dungeon));retained_trap=0;
        vehicle_cycle.phase=vehicle_cycle.clock=0;
        rpg_new_game(&game_rpg);rpg_seed_rng(&game_rpg,frame_counter^DIV_REG);
        event_init(&game_events,&game_rpg);facing=0;
        start_opening();
    }
    deferred_buttons=0;service_active=0;service_selector=0;
}
static void dialogue_page(void) {
    dialogue_revealing=1;screen_state=STATE_DIALOGUE;
    if(scene_actor_active)SHOW_SPRITES;else HIDE_SPRITES;
    ui_panel(104,5);
    dialogue_draw(0);dialogue_clock=audio_clock;
}
void show_dialogue(uint16_t id) {
    if(!dialogue_open(&dialogue,id)) {notice("TEXT NOT AVAILABLE",STATE_WALK);return;}
    if(field_active) {
        dialogue_item_name(field_action.item,dialogue.item);
        if(field_action.character<4u)strcpy(dialogue.character,names[field_action.character]);
    } else if(service_active) {
        dialogue.number=game_service.action.number;
        dialogue_item_name(game_service.action.item,dialogue.item);
        if(game_service.action.character<4u) strcpy(dialogue.character,names[game_service.action.character]);
    } else {
        dialogue.number=game_events.action.number;
        dialogue_item_name(game_events.action.item,dialogue.item);
        if(game_events.action.character<4u) strcpy(dialogue.character,names[game_events.action.character]);
    }
    dialogue_stream_begin(&dialogue,0);dialogue_page();
}
void inventory_dialogue_overlay(void) {
    ui_text(1,9,dialogue.lines[0]);ui_text(1,10,dialogue.lines[1]);
}
void start_movie_text(uint16_t id) {
    dialogue_open(&dialogue,id);dialogue_stream_begin(&dialogue,0);dialogue_page();screen_state=STATE_MOVIE_TEXT;
}






static void service_selection(void) {
    service_selector=0;
    if(game_service.action.kind==SERVICE_PARTY) {party_choice=0;party_screen();}
    else if(game_service.action.kind==SERVICE_GOODS) {shop_id=game_service.shop;choice=0;shop_screen();}
    else if(game_service.action.kind==SERVICE_ITEMS) {item_slot=0;replace_source=0;inventory_screen();}
    else {
        screen_state=STATE_BUY_SELL;ui_panel(80,8);ui_text(4,1,"BUY");ui_text(12,1,"SELL");
        ui_text(choice?10:2,1,">");ui_text(1,6,"A:CHOOSE  B:LEAVE");
    }
}
void apply_service(void) {
    ServiceAction *a=&game_service.action;
    uint8_t remaining,previous,keys;
    service_selector=0;
    while(a->kind==SERVICE_EFFECT||a->kind==SERVICE_WAIT){
        if(a->sound){audio_command(a->sound);a->sound=0;}
        if(a->kind==SERVICE_WAIT){
            remaining=a->target;previous=joypad();
            do {vsync();keys=joypad();if((keys&~previous)&(J_A|J_B))break;previous=keys;}while(!a->target||--remaining);
            last_keys=keys;
        }
        service_advance(&game_service);
    }
    if(a->sound){audio_command(a->sound);a->sound=0;}
    if(a->kind==SERVICE_DONE) {service_active=0;resume_walk();}
    else if(a->kind==SERVICE_INVALID) {service_active=0;notice("SERVICE NOT PORTED",STATE_WALK);}
    else if(a->kind==SERVICE_DIALOGUE||a->kind==SERVICE_YES_NO) show_dialogue(a->dialogue_id);
    else if(a->dialogue_id) {service_selector=a->kind;show_dialogue(a->dialogue_id);}
    else {choice=0;service_selection();}
}





static uint8_t check_trigger(void) {
    uint16_t x,y;
    if(!world_check_trigger(player_x,player_y,game_vehicle,&world_action)) {
        return_x=player_x;return_y=player_y;return 0;
    }
    if(world_action.mode==WORLD_ACTION_MAP) {
        world_decode_destination(&world_action,&x,&y);enter_map(world_action.target,x,y);
    } else if(world_action.mode==WORLD_ACTION_INTERACTION) {
        player_x=return_x;player_y=return_y;redraw_world(1);
        /* Original C305 low byte is camera Y within a 192-pixel chunk. */
        game_events.packed_y=(player_y+WORLD_PIXEL_HEIGHT-112u)%192u;
        game_events.camera_x_low=(uint8_t)(player_x-136u);
        scene_context_type=world_interaction_type(world_group_id,world_action.target);
        show_interaction_scene(scene_context_type,world_action.b,0u);
        /* Original event/flag mutations begin after the room fade and08. */
        event_begin(&game_events,scene_context_type,world_action.a,world_action.b,world_map_id);
        if(game_events.prepared_enemy){DISPLAY_OFF;scene_enemy_show(game_events.prepared_enemy,0u);DISPLAY_ON;}
        apply_event();
    } else if(world_action.mode==WORLD_ACTION_SPECIAL) {
        world_special(&game_rpg,world_map_id,world_action.metatile,game_vehicle,game_events.flags[6],&terrain_action);
        if(!terrain_action.kind)return 0;
        if(terrain_action.rollback) {player_x=return_x;player_y=return_y;redraw_world(1);}
        if(terrain_action.kind==WORLD_RULE_EVENT) {
            game_events.death_mask=terrain_action.death_mask;
            event_begin(&game_events,world_action.flags>>4,terrain_action.target,0,world_map_id);apply_event();
        } else if(terrain_action.kind==WORLD_RULE_BATTLE) begin_battle(terrain_action.target,0);
        else enter_dungeon(terrain_action.target,terrain_action.a,terrain_action.b);
    } else {
        player_x=return_x;player_y=return_y;redraw_world(1);
        if(world_action.mode==WORLD_ACTION_DUNGEON)enter_dungeon(world_action.target,world_action.a,world_action.b);
        else notice("TERRAIN NOT PORTED",STATE_WALK);
    }
    return 1;
}
static void move_player(uint8_t keys) {
    uint8_t enemy,n=game_vehicle?2u:1u,dir,face,mask,held=0;
    if(keys&J_UP)held|=1u;if(keys&J_DOWN)held|=2u;
    if(keys&J_LEFT)held|=4u;if(keys&J_RIGHT)held|=8u;
    if(!step_remaining) {
        step_dx=0;step_dy=0;
        /*7143 tries held directions in source order, including a lower
         * priority direction when the preceding requested direction blocks. */
        for(dir=0;dir<4u;++dir)if(held&(1u<<dir)) {facing=dir<2u?dir^1u:dir;break;}
        for(dir=0;dir<4u;++dir)if(held&(1u<<dir)) {
            face=dir<2u?dir^1u:dir;
            if(world_step_allowed(player_x,player_y,face,game_vehicle)) {
                facing=face;step_dx=dir==2u?-1:dir==3u?1:0;
                step_dy=dir==0u?-1:dir==1u?1:0;step_remaining=16;break;
            }
        }
        if(world_ice_changed){audio_command(0xb7);redraw_world(1);}
    }
    if(step_remaining) {
        mask=1u<<(facing<2u?facing^1u:facing);
        while(n--) {
            player_x=(player_x+step_dx)&2047u;
            if(step_dy<0) player_y=player_y?player_y-1u:WORLD_PIXEL_HEIGHT-1u;
            else if(step_dy>0) player_y=(player_y+1u)%WORLD_PIXEL_HEIGHT;
            --step_remaining;
        }
        if(!game_vehicle)party_world_tick(mask,step_remaining,held);
        redraw_world(0);
        if(!step_remaining && !check_trigger()) {
            enemy=rpg_world_encounter(&game_rpg,world_group_id,player_x,player_y,
                world_meta_at((player_x-8u)&2047u,(player_y+1536u-16u)%1536u),game_vehicle);
            if(enemy) begin_battle(enemy,0);
        }
    } else {
        /* Original7143 writes D6 at every idle/blocked logical boundary. */
        audio_command(0xd6);
        if(!game_vehicle)party_world_tick(0,0,held);
        draw_player();
    }
}
static void return_from_notice(void) {
    if(notice_return==STATE_SHOP) shop_screen();
    else if(notice_return==STATE_INVENTORY) inventory_screen();
    else if(notice_return==STATE_MENU) menu_screen();
    else if(notice_return==STATE_PARTY) party_screen();
    else if(notice_return==STATE_TITLE) title_screen();
    else resume_walk();
}
void main(void) {
    uint8_t keys,pressed,i,code;
    DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
    cpu_fast(); /* CGB-only cartridge: VBlank-driven gameplay keeps its timing. */
    audio_install();
    VBK_REG=1;set_bkg_data(0,64,ui_font);
    SWITCH_ROM(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);set_sprite_palette(0,ALIS_PALETTE_COUNT,alis_palettes);
    SWITCH_ROM(1);VBK_REG=0;SPRITES_8x8;set_bkg_palette(7,1,ui_palette);
    rpg_new_game(&game_rpg);event_init(&game_events,&game_rpg);
    world_select(WORLD_START_MAP);world_load_graphics();
    player_x=WORLD_START_X;player_y=WORLD_START_Y;party_world_reset(0);redraw_world(1);save_ui_scan();
    title_choice=saved_position_valid?1u:0u;SHOW_BKG;title_screen();DISPLAY_ON;
    while(1) {
        vsync();++frame_counter;keys=joypad();pressed=keys&~last_keys;
        /* Source WaitForVInt0A during glyphs/scrolls does not read controls. */
        if(!(screen_state==STATE_BATTLE&&battle_view_text_revealing)&&
           (!dialogue_revealing||(screen_state!=STATE_DIALOGUE&&screen_state!=STATE_CUTSCENE&&screen_state!=STATE_MOVIE_TEXT)))last_keys=keys;
        if(screen_state==STATE_TITLE) {
            if((pressed&(J_UP|J_DOWN))&&saved_position_valid) {title_choice^=1;title_screen();}
            if(pressed&(J_START|J_A)) {
                if(title_choice&&saved_position_valid)save_ui_open(SAVE_UI_LOAD,STATE_TITLE);
                else start_game(0);
            }
        } else if(screen_state==STATE_WALK) {
            deferred_buttons|=pressed&(J_START|J_SELECT);
            vehicle_cycle_world_tick(game_vehicle,step_remaining);
            world_motion_step();
            move_player(keys);
            /* Map B07 tests held source buttons only after actor movement,
             * triggers and encounters, at the completed movement boundary. */
            if(screen_state==STATE_WALK&&!step_remaining) {
                if(deferred_buttons&J_SELECT) {deferred_buttons=0;notice(write_save()?"GAME SAVED":"SAVE FAILED",STATE_WALK);}
                else if((keys|deferred_buttons)&(J_A|J_B|J_START)) {
                    deferred_buttons=0;
                    /* Source77AC already checked the completed step; its
                     * C2D5 latch prevents rechecking a map-arrival tile. */
                    game_events.type=battle_scene_world_type(world_group_id,
                        world_flags_at((player_x-8u)&2047u,(player_y+1536u-16u)%1536u));
                    show_interaction_scene(game_events.type,0u,0u);menu_choice=0;menu_screen();
                }
            }
        } else if(screen_state==STATE_MENU) {
            if(pressed&(J_B|J_START)) resume_walk();
            else if(pressed&J_UP) {menu_choice=menu_choice?menu_choice-1u:7u;menu_screen();}
            else if(pressed&J_DOWN) {menu_choice=menu_choice<7u?menu_choice+1u:0u;menu_screen();}
            else if(pressed&J_A) {
                if(menu_choice==0) resume_walk();else if(menu_choice==1) status_screen();
                else if(menu_choice==2) {item_slot=0;replace_source=0;party_purpose=0;inventory_screen();}
                else if(menu_choice==3) {
                    if(battle_view_chest_pending){battle_view_chest_prompt(1);screen_state=STATE_BATTLE;}
                    else {event_search(&game_events,world_map_id,((player_x-8u)&2047u)>>4,((player_y+1536u-16u)%1536u)>>4);apply_event();}
                } else if(menu_choice==4) save_ui_open(SAVE_UI_SAVE,STATE_MENU);
                else if(menu_choice==5) {title_choice=saved_position_valid?1u:0u;title_screen();}
                else if(menu_choice==6u)help_screen();
                else {party_choice=0;party_purpose=PARTY_MAGIC_CASTER;party_screen();}
            }
        } else if(screen_state==STATE_EQUIPMENT_PANEL) {
            if(pressed&(J_A|J_B))inventory_equipment_done();
        } else if(screen_state==STATE_HELP||screen_state==STATE_STATUS) {
            if(pressed&(J_A|J_B|J_START)) menu_screen();
        } else if(screen_state==STATE_NOTICE) {
            if(pressed&(J_A|J_B)) return_from_notice();
        } else if(screen_state==STATE_DIALOGUE) {
            if(dialogue_tick(0,pressed&(J_A|J_B))) {
                if(!dialogue.done) dialogue_page();
                else if(field_active==2u)inventory_action_advance();
                else if(field_active)game_field_advance();
                else if(service_active) {
                    if(service_selector) service_selection();
                    else if(game_service.action.kind==SERVICE_YES_NO) {choice=0;prompt_screen();}
                    else {service_advance(&game_service);apply_service();}
                }
                else if(dark_menu_pending&&game_events.action.kind==EVENT_MENU) {menu_choice=0;menu_screen();}
                else if(game_events.action.kind==EVENT_YES_NO) {choice=0;prompt_screen();}
                else {event_advance(&game_events);apply_event();}
            }
        } else if(screen_state==STATE_PROMPT) {
            if(pressed&(J_LEFT|J_UP))choice^=1;
            if(pressed&(J_RIGHT|J_DOWN))choice^=1;
            if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN))prompt_screen();
            /* Original CheckOptionSelect confirms the selected answer with
             * either action button, including a direction+button edge. */
            if(pressed&(J_A|J_B)) {
                if(service_active) {service_respond(&game_service,!choice);apply_service();}
                else {event_respond(&game_events,!choice);apply_event();}
            }
        } else if(screen_state==STATE_SHOP) {
            if(pressed&J_B) {service_select(&game_service,255);apply_service();}
            else if(pressed&J_UP) {choice=choice?choice-1u:shop_count-1u;shop_screen();}
            else if(pressed&J_DOWN) {choice=(choice+1u)%shop_count;shop_screen();}
            else if(pressed&J_A) {service_select(&game_service,choice);apply_service();}
        } else if(screen_state==STATE_BUY) {
            if(pressed&J_B) shop_screen();
            else if(pressed&J_A) {
                if(shop_id==8u&&choice==2u) {event_buy_secret(&game_events,shop_id,choice);apply_event();}
                else {code=rpg_buy(&game_rpg,shop_id,choice);result(code,code==RPG_FULL?STATE_WALK:STATE_SHOP);}
            }
        } else if(screen_state==STATE_INVENTORY||screen_state==STATE_REPLACE) {
            if(pressed&J_B) {
                if(service_active) {service_select(&game_service,255);apply_service();}
                else if(replace_source) {replace_source=0;event_replace_item(&game_events,255);apply_event();}
                else if(party_purpose==EVENT_SELL) resume_walk();else menu_screen();
            } else if(game_rpg.inventory_count) {
                if(pressed&J_UP) {item_slot=item_slot?item_slot-1u:game_rpg.inventory_count-1u;inventory_screen();}
                else if(pressed&J_DOWN) {item_slot=(item_slot+1u)%game_rpg.inventory_count;inventory_screen();}
                else if(pressed&J_A) {
                    if(service_active) {service_select(&game_service,item_slot);apply_service();}
                    else if(replace_source) {replace_source=0;event_replace_item(&game_events,item_slot);apply_event();}
                    else if(party_purpose==EVENT_SELL) result(rpg_sell(&game_rpg,item_slot),STATE_INVENTORY);
                    else if(game_vehicle&&game_rpg.inventory[item_slot]==32u+game_vehicle/4u)game_field_item(item_slot,0);
                    else {item_action=0;item_screen();}
                }
            }
        } else if(screen_state==STATE_ITEM) {
            if(pressed&J_B) inventory_screen();
            else if(pressed&J_UP) {item_action=item_action?item_action-1u:2u;item_screen();}
            else if(pressed&J_DOWN) {item_action=(item_action+1u)%3u;item_screen();}
            else if(pressed&J_A) {
                if(item_action==2u) inventory_drop_begin(item_slot);
                else if(item_action==1u){party_purpose=0;inventory_equip_begin(item_slot);}
                else if(game_rpg.inventory[item_slot]==ItemID_Cola||game_rpg.inventory[item_slot]==ItemID_Burger) {
                    party_choice=0;party_purpose=PARTY_FIELD_ITEM;party_screen();
                } else {
                    for(i=0;i<4u;++i)if(game_rpg.party[i].status&1u)break;
                    game_field_item(item_slot,i);
                }
            }
        } else if(screen_state==STATE_PARTY) {
            if(pressed&J_B) {
                if(service_active) {service_select(&game_service,255);apply_service();}
                else if(field_active==2u)inventory_equip_select(255u);
                else if(party_purpose==PARTY_MAGIC_TARGET)game_field_spell(magic_caster,selected_field_spell,255);
                else if(party_purpose==PARTY_MAGIC_CASTER)menu_screen();
                else if(party_purpose==PARTY_FIELD_ITEM)game_field_item(item_slot,255);
                else if(party_purpose) resume_walk();else inventory_screen();
            }
            else if(pressed&(J_UP|J_DOWN)) {
                for(i=0;i<4u;++i) {party_choice=(party_choice+((pressed&J_UP)?3u:1u))&3u;if(game_rpg.joined_mask&(1u<<party_choice)) break;}
                party_screen();
            } else if(pressed&J_A) {
                if(service_active) {service_select(&game_service,party_choice);apply_service();continue;}
                if(field_active==2u){inventory_equip_select(party_choice);continue;}
                if(party_purpose==PARTY_MAGIC_CASTER) {
                    magic_caster=party_choice;magic_choice=0;
                    if(!(game_rpg.party[magic_caster].status&1u)||!rpg_spell_option(&game_rpg,magic_caster,0,0))
                        game_field_spell(magic_caster,0,255);
                    else map_magic_screen();
                    continue;
                }
                if(party_purpose==PARTY_MAGIC_TARGET){game_field_spell(magic_caster,selected_field_spell,party_choice);continue;}
                if(party_purpose==PARTY_FIELD_ITEM){game_field_item(item_slot,party_choice);continue;}
                if(party_purpose==EVENT_HOSPITAL) code=rpg_hospital(&game_rpg,party_choice);
                else if(party_purpose==EVENT_CHURCH) code=rpg_revive(&game_rpg,party_choice);
                else if(item_action==1u) code=rpg_equip(&game_rpg,item_slot,party_choice);
                else {
                    code=rpg_use_item(&game_rpg,item_slot,party_choice);
                    if(code==RPG_NOT_IMPLEMENTED) {
                        uint8_t item=game_rpg.inventory[item_slot];
                        if(game_dungeon.active&&item==ItemID_Flash&&!game_dungeon.dungeon.light) {
                            rpg_remove_item(&game_rpg,item_slot);game_dungeon.dungeon.light=255;
                            dungeon_refresh_light(&game_dungeon.dungeon);resume_walk();continue;
                        }
                        if(game_dungeon.active&&(item==ItemID_DungeonKey||item==ItemID_MiracleKey)) {
                            uint8_t pos=dungeon_sample_position(&game_dungeon.dungeon,1);
                            uint8_t door=game_dungeon.dungeon.layout[pos]&7u;
                            if((door==5u||(item==ItemID_MiracleKey&&door==6u))&&!(game_dungeon.dungeon.layout[pos]&128u)) {
                                game_dungeon.dungeon.layout[pos]|=128u;dplay_show_opening(&game_dungeon,door-2u);resume_walk();continue;
                            }
                        }
                        event_use_story_item(&game_events,item_slot,0);apply_event();continue;
                    }
                }
                result(code,party_purpose?STATE_PARTY:STATE_INVENTORY);
            }
        } else if(screen_state==STATE_BUY_SELL) {
            if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN)) {choice^=1;service_selection();}
            else if(pressed&(J_A|J_B)) {service_select(&game_service,(pressed&J_B)?255u:choice);apply_service();}
        } else if(screen_state==STATE_BATTLE) {
            code=battle_view_tick(keys,pressed);
            if(code) {
                if(code==BATTLE_VIEW_MENU){
                    if(battle_view_battle.chest_state==BATTLE_CHEST_OPEN) {
                        if(battle_from_event==1u)game_events.flags[game_events.battle.flag_index]=255;
                        else if(battle_from_event==2u)dplay_mark_object(&game_events,battle_object_flag);
                        else if(!battle_from_event)game_events.flags[0]=255;
                    }
                    menu_choice=0;menu_screen();continue;
                }
                game_dungeon.retained_trap=retained_trap;
                if(battle_from_event==3u)game_movie_battle_done(code);
                else if(battle_from_event==1u) {
                    event_battle_result(&game_events,code,battle_view_battle.chest_state==BATTLE_CHEST_OPEN);apply_event();
                } else if(battle_from_event==2u) {
                    if(battle_view_battle.chest_state==BATTLE_CHEST_OPEN)dplay_mark_object(&game_events,battle_object_flag);
                    if(code==RPG_DEFEAT){title_choice=saved_position_valid?1u:0u;notice("GAME OVER",STATE_TITLE);}
                    else if(code==RPG_ESCAPED){dplay_escape(&game_dungeon,&game_rpg,&game_events);apply_dungeon();}
                    else {dplay_resume(&game_dungeon,&game_rpg,&game_events);apply_dungeon();}
                } else {
                    if(battle_view_battle.chest_state==BATTLE_CHEST_OPEN)game_events.flags[0]=255;
                    resume_walk();
                    if(code==RPG_DEFEAT) {title_choice=saved_position_valid?1u:0u;notice("GAME OVER",STATE_TITLE);}
                }
            }
        } else if(screen_state==STATE_TRAVEL_MENU) {
            if(pressed&J_UP){choice=choice?choice-1u:2u;travel_menu();}
            else if(pressed&J_DOWN){choice=(choice+1u)%3u;travel_menu();}
            else if(pressed&(J_A|J_B)){event_choose_destination(&game_events,(pressed&J_B)?255u:choice);apply_event();}
        } else if(screen_state==STATE_CUTSCENE) {
            if(dialogue_tick(1,pressed&(J_A|J_B))) {
                if(!dialogue.done)story_page();
                else {cutscene_advance(&game_cutscene);show_cutscene_record();}
            }
        } else if(screen_state==STATE_MOVIE) {
            game_movie_tick(keys);
        } else if(screen_state==STATE_MOVIE_TEXT) {
            if(dialogue_tick(0,pressed&(J_A|J_B))) {
                if(!dialogue.done){dialogue_page();screen_state=STATE_MOVIE_TEXT;}
                else game_movie_text_done();
            }
        } else if(screen_state==STATE_MAP_MAGIC) {
            code=0;while(code<5u&&rpg_spell_option(&game_rpg,magic_caster,code,0))++code;
            if(pressed&J_B){party_purpose=PARTY_MAGIC_CASTER;party_choice=magic_caster;party_screen();}
            else if(pressed&J_UP){magic_choice=magic_choice?magic_choice-1u:code-1u;map_magic_screen();}
            else if(pressed&J_DOWN){magic_choice=(magic_choice+1u)%code;map_magic_screen();}
            else if(pressed&J_A) {
                selected_field_spell=rpg_spell_option(&game_rpg,magic_caster,magic_choice,0);
                if(selected_field_spell==MagicID_Heal||selected_field_spell==MagicID_Cure||selected_field_spell==MagicID_Rise) {
                    party_choice=magic_caster;party_purpose=PARTY_MAGIC_TARGET;party_screen();
                } else game_field_spell(magic_caster,selected_field_spell,255);
            }
        } else if(screen_state>=STATE_SAVE_ACTION&&screen_state<=STATE_SAVE_NAME) {
            save_ui_tick(keys,pressed);
        } else if(screen_state==STATE_PRESENTATION||screen_state==STATE_TRAVEL||screen_state==STATE_ODIN_WAIT) {
            game_sequence_tick(keys,pressed);
        } else if(screen_state==STATE_DUNGEON) {
            if(dungeon_keys_delay)--dungeon_keys_delay;
            else {
                code=DUNGEON_CMD_NONE;
                if(pressed&J_START){menu_choice=0;menu_screen();continue;}
                if(pressed&J_SELECT){notice(write_save()?"GAME SAVED":"SAVE FAILED",STATE_WALK);continue;}
                if(keys&J_UP)code=DUNGEON_CMD_FORWARD;else if(keys&J_DOWN)code=DUNGEON_CMD_BACK;
                else if(keys&J_LEFT)code=DUNGEON_CMD_LEFT;else if(keys&J_RIGHT)code=DUNGEON_CMD_RIGHT;
                else if(pressed&(J_A|J_B))code=DUNGEON_CMD_ACTION;
                /* Trap floors are checked even without a new command. */
                i=game_dungeon.dungeon.floor;
                dplay_step(&game_dungeon,&game_rpg,&game_events,code);
                if(code||i!=game_dungeon.dungeon.floor||game_dungeon.action.kind)apply_dungeon();
            }
        }
    }
}
