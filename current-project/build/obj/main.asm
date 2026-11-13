;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module main
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _start_movie_text
	.globl _inventory_dialogue_overlay
	.globl _show_dialogue
	.globl _start_game
	.globl _enter_map_ready
	.globl _enter_map
	.globl _reload_world_mode
	.globl _begin_battle
	.globl _draw_dungeon_faded
	.globl _draw_dungeon
	.globl _start_cutscene
	.globl b_scene_fade_begin
	.globl _scene_fade_begin
	.globl b_game_transition_interaction_music
	.globl _game_transition_interaction_music
	.globl b_game_transition_map_music
	.globl _game_transition_map_music
	.globl b_game_transition_wait
	.globl _game_transition_wait
	.globl b_game_transition_fade_in
	.globl _game_transition_fade_in
	.globl b_game_transition_fade_out
	.globl _game_transition_fade_out
	.globl b_vehicle_cycle_world_tick
	.globl _vehicle_cycle_world_tick
	.globl b_party_world_draw
	.globl _party_world_draw
	.globl b_party_world_tick
	.globl _party_world_tick
	.globl b_party_world_reset
	.globl _party_world_reset
	.globl b_inventory_equipment_done
	.globl _inventory_equipment_done
	.globl b_inventory_action_advance
	.globl _inventory_action_advance
	.globl b_inventory_drop_begin
	.globl _inventory_drop_begin
	.globl b_inventory_equip_select
	.globl _inventory_equip_select
	.globl b_inventory_equip_begin
	.globl _inventory_equip_begin
	.globl b_save_ui_tick
	.globl _save_ui_tick
	.globl b_save_ui_open
	.globl _save_ui_open
	.globl b_save_ui_scan
	.globl _save_ui_scan
	.globl b_save_slot_offset
	.globl _save_slot_offset
	.globl b_game_movie_battle_done
	.globl _game_movie_battle_done
	.globl b_game_movie_story_done
	.globl _game_movie_story_done
	.globl b_game_movie_text_done
	.globl _game_movie_text_done
	.globl b_game_movie_tick
	.globl _game_movie_tick
	.globl b_start_opening
	.globl _start_opening
	.globl b_game_sequence_tick
	.globl _game_sequence_tick
	.globl b_battle_scene_configure
	.globl _battle_scene_configure
	.globl b_battle_scene_world_type
	.globl _battle_scene_world_type
	.globl b_game_field_advance
	.globl _game_field_advance
	.globl b_game_field_spell
	.globl _game_field_spell
	.globl b_game_field_item
	.globl _game_field_item
	.globl b_vehicle_palette_reset
	.globl _vehicle_palette_reset
	.globl b_vehicle_sprite_draw
	.globl _vehicle_sprite_draw
	.globl b_vehicle_sprite_load
	.globl _vehicle_sprite_load
	.globl b_enter_dungeon
	.globl _enter_dungeon
	.globl b_show_interaction_scene
	.globl _show_interaction_scene
	.globl b_apply_dungeon
	.globl _apply_dungeon
	.globl b_apply_event
	.globl _apply_event
	.globl b_cutscene_portrait_show
	.globl _cutscene_portrait_show
	.globl b_cutscene_advance
	.globl _cutscene_advance
	.globl b_cutscene_begin
	.globl _cutscene_begin
	.globl b_audio_map_track
	.globl _audio_map_track
	.globl _audio_install
	.globl b_audio_command
	.globl _audio_command
	.globl b_map_magic_screen
	.globl _map_magic_screen
	.globl b_travel_menu
	.globl _travel_menu
	.globl b_status_screen
	.globl _status_screen
	.globl b_party_screen
	.globl _party_screen
	.globl b_item_screen
	.globl _item_screen
	.globl b_inventory_screen
	.globl _inventory_screen
	.globl b_shop_screen
	.globl _shop_screen
	.globl b_prompt_screen
	.globl _prompt_screen
	.globl b_result
	.globl _result
	.globl b_notice
	.globl _notice
	.globl b_help_screen
	.globl _help_screen
	.globl b_menu_screen
	.globl _menu_screen
	.globl b_title_screen
	.globl _title_screen
	.globl b_ui_text
	.globl _ui_text
	.globl b_ui_panel
	.globl _ui_panel
	.globl b_save_decode
	.globl _save_decode
	.globl b_save_encode
	.globl _save_encode
	.globl b_dialogue_wait_tick
	.globl _dialogue_wait_tick
	.globl b_dialogue_wait_frames
	.globl _dialogue_wait_frames
	.globl b_dialogue_item_name
	.globl _dialogue_item_name
	.globl b_dialogue_stream_next
	.globl _dialogue_stream_next
	.globl b_dialogue_stream_begin
	.globl _dialogue_stream_begin
	.globl b_dialogue_open
	.globl _dialogue_open
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_scene_enemy_show
	.globl _scene_enemy_show
	.globl b_dungeon_render
	.globl _dungeon_render
	.globl _dungeon_invalidate_view_cache
	.globl b_dplay_show_opening
	.globl _dplay_show_opening
	.globl b_dplay_mark_object
	.globl _dplay_mark_object
	.globl b_dplay_escape_blocked
	.globl _dplay_escape_blocked
	.globl b_dplay_escape
	.globl _dplay_escape
	.globl b_dplay_resume
	.globl _dplay_resume
	.globl b_dplay_step
	.globl _dplay_step
	.globl b_dungeon_sample_position
	.globl _dungeon_sample_position
	.globl b_dungeon_refresh_light
	.globl _dungeon_refresh_light
	.globl b_dungeon_enter
	.globl _dungeon_enter
	.globl b_battle_view_tick
	.globl _battle_view_tick
	.globl b_battle_view_chest_abandon
	.globl _battle_view_chest_abandon
	.globl b_battle_view_chest_leave
	.globl _battle_view_chest_leave
	.globl b_battle_view_chest_prompt
	.globl _battle_view_chest_prompt
	.globl b_battle_view_begin
	.globl _battle_view_begin
	.globl b_rpg_world_encounter
	.globl _rpg_world_encounter
	.globl b_service_select
	.globl _service_select
	.globl b_service_respond
	.globl _service_respond
	.globl b_service_advance
	.globl _service_advance
	.globl b_event_choose_destination
	.globl _event_choose_destination
	.globl b_event_battle_result
	.globl _event_battle_result
	.globl b_event_search
	.globl _event_search
	.globl b_event_use_story_item
	.globl _event_use_story_item
	.globl b_event_buy_secret
	.globl _event_buy_secret
	.globl b_event_replace_item
	.globl _event_replace_item
	.globl b_event_respond
	.globl _event_respond
	.globl b_event_advance
	.globl _event_advance
	.globl b_event_begin
	.globl _event_begin
	.globl b_event_init
	.globl _event_init
	.globl b_world_interaction_type
	.globl _world_interaction_type
	.globl b_world_special
	.globl _world_special
	.globl b_rpg_spell_option
	.globl _rpg_spell_option
	.globl b_rpg_revive
	.globl _rpg_revive
	.globl b_rpg_hospital
	.globl _rpg_hospital
	.globl b_rpg_sell
	.globl _rpg_sell
	.globl b_rpg_use_item
	.globl _rpg_use_item
	.globl b_rpg_buy
	.globl _rpg_buy
	.globl b_rpg_equip
	.globl _rpg_equip
	.globl b_rpg_find_item
	.globl _rpg_find_item
	.globl b_rpg_remove_item
	.globl _rpg_remove_item
	.globl b_rpg_seed_rng
	.globl _rpg_seed_rng
	.globl b_rpg_new_game
	.globl _rpg_new_game
	.globl b_world_motion_step
	.globl _world_motion_step
	.globl b_world_decode_destination
	.globl _world_decode_destination
	.globl b_world_check_trigger
	.globl _world_check_trigger
	.globl b_world_vehicle_footprint
	.globl _world_vehicle_footprint
	.globl b_world_terrain_sync
	.globl _world_terrain_sync
	.globl b_world_step_allowed
	.globl _world_step_allowed
	.globl b_world_flags_at
	.globl _world_flags_at
	.globl b_world_meta_at
	.globl _world_meta_at
	.globl b_world_draw
	.globl _world_draw
	.globl b_world_load_graphics
	.globl _world_load_graphics
	.globl b_world_select
	.globl _world_select
	.globl _memset
	.globl _memcpy
	.globl _strcpy
	.globl _cpu_fast
	.globl _set_sprite_palette
	.globl _set_bkg_palette
	.globl _set_sprite_data
	.globl _set_bkg_data
	.globl _display_off
	.globl _vsync
	.globl _joypad
	.globl _dungeon_keys_delay
	.globl _dark_menu_pending
	.globl _background_changed
	.globl _retained_trap
	.globl _battle_object_flag
	.globl _battle_from_event
	.globl _service_selector
	.globl _service_active
	.globl _replace_source
	.globl _notice_return
	.globl _magic_choice
	.globl _magic_caster
	.globl _party_choice
	.globl _item_action
	.globl _item_slot
	.globl _shop_count
	.globl _shop_id
	.globl _choice
	.globl _title_choice
	.globl _menu_choice
	.globl _last_keys
	.globl _ship_exit
	.globl _ship_arrival
	.globl _ship_departure
	.globl _world_action
	.globl _dialogue_revealing
	.globl _game_dungeon
	.globl _game_service
	.globl _game_events
	.globl _game_rpg
	.globl _frame_counter
	.globl _scene_context_type
	.globl _game_vehicle
	.globl _step_remaining
	.globl _saved_position_valid
	.globl _walk_frame
	.globl _facing
	.globl _screen_state
	.globl _camera_y
	.globl _camera_x
	.globl _player_y
	.globl _player_x
	.globl _resume_walk
	.globl _game_read_slot
	.globl _game_write_slot
	.globl _apply_service
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_player_x::
	.ds 2
_player_y::
	.ds 2
_camera_x::
	.ds 2
_camera_y::
	.ds 2
_screen_state::
	.ds 1
_facing::
	.ds 1
_walk_frame::
	.ds 1
_saved_position_valid::
	.ds 1
_step_remaining::
	.ds 1
_game_vehicle::
	.ds 1
_scene_context_type::
	.ds 1
_frame_counter::
	.ds 2
_game_rpg::
	.ds 94
_game_events::
	.ds 549
_game_service::
	.ds 17
_game_dungeon::
	.ds 284
_save_storage:
	.ds 628
_dialogue:
	.ds 89
_dialogue_wait:
	.ds 2
_dialogue_revealing::
	.ds 1
_dialogue_clock:
	.ds 1
_game_cutscene:
	.ds 7
_story_lower:
	.ds 38
_world_action::
	.ds 6
_ship_departure::
	.ds 6
_ship_arrival::
	.ds 6
_ship_exit::
	.ds 6
_terrain_action:
	.ds 6
_last_keys::
	.ds 1
_deferred_buttons:
	.ds 1
_menu_choice::
	.ds 1
_title_choice::
	.ds 1
_choice::
	.ds 1
_shop_id::
	.ds 1
_shop_count::
	.ds 1
_item_slot::
	.ds 1
_item_action::
	.ds 1
_party_choice::
	.ds 1
_magic_caster::
	.ds 1
_magic_choice::
	.ds 1
_selected_field_spell:
	.ds 1
_party_purpose:
	.ds 1
_notice_return::
	.ds 1
_replace_source::
	.ds 1
_service_active::
	.ds 1
_service_selector::
	.ds 1
_battle_from_event::
	.ds 1
_battle_object_flag::
	.ds 2
_retained_trap::
	.ds 1
_background_changed::
	.ds 1
_dark_menu_pending::
	.ds 1
_dungeon_keys_delay::
	.ds 1
_step_dx:
	.ds 1
_step_dy:
	.ds 1
_return_x:
	.ds 2
_return_y:
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_vehicle_loaded_facing:
	.ds 1
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/main.c:109: static void dialogue_draw(uint8_t narrative) {
;	---------------------------------
; Function dialogue_draw
; ---------------------------------
_dialogue_draw:
	dec	sp
	ldhl	sp,	#0
	ld	(hl), a
;src/main.c:110: ui_text(1,1,dialogue.lines[0]);ui_text(1,2,dialogue.lines[1]);
	ld	de, #(_dialogue + 50)
	push	de
	ld	hl, #0x101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #(_dialogue + 69)
	push	de
	ld	hl, #0x201
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:111: if(narrative){ui_text(1,3,story_lower[0]);ui_text(1,4,story_lower[1]);}
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	ld	de, #_story_lower
	push	de
	ld	hl, #0x301
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #(_story_lower + 19)
	push	de
	ld	hl, #0x401
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
00103$:
;src/main.c:112: }
	inc	sp
	ret
_ui_palette:
	.dw #0x2062
	.dw #0x4d46
	.dw #0x22de
	.dw #0x6fde
_names:
	.dw __str_0
	.dw __str_1
	.dw __str_2
	.dw __str_3
__str_0:
	.ascii "ALIS"
	.db 0x00
__str_1:
	.ascii "MYAU"
	.db 0x00
__str_2:
	.ascii "ODIN"
	.db 0x00
__str_3:
	.ascii "NOAH"
	.db 0x00
;src/main.c:113: static void dialogue_glyph(void) {
;	---------------------------------
; Function dialogue_glyph
; ---------------------------------
_dialogue_glyph:
	add	sp, #-3
;src/main.c:114: char glyph[2];uint8_t row=dialogue.row,column=dialogue.column;
	ld	hl, #_dialogue + 14
	ld	c, (hl)
	ld	a, (#(_dialogue + 15) + 0)
;src/main.c:115: glyph[0]=row<2u?dialogue.lines[row][column-1u]:story_lower[row-2u][column-1u];glyph[1]=0;
	ldhl	sp,#2
	ld	(hl), a
	ld	b, (hl)
	dec	b
	ld	a, c
	sub	a, #0x02
	jr	NC, 00103$
	ld	l, c
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	h, #0x00
	ld	de, #(_dialogue + 50)
	add	hl, de
	ld	e, b
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	jr	00104$
00103$:
	ld	a, c
	dec	a
	dec	a
	ld	e, a
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	ld	de, #_story_lower
	add	hl, de
	ld	e, b
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
00104$:
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
;src/main.c:116: ui_text(column,row+1u,glyph);
	ld	hl, #0
	add	hl, sp
	ld	a, c
	inc	a
	push	hl
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
;src/main.c:117: }
	add	sp, #7
	ret
;src/main.c:118: static uint8_t dialogue_tick(uint8_t narrative,uint8_t pressed) {
;	---------------------------------
; Function dialogue_tick
; ---------------------------------
_dialogue_tick:
	dec	sp
	dec	sp
	ldhl	sp,	#1
	ld	(hl-), a
	ld	(hl), e
;src/main.c:120: if(dialogue_revealing) {
	ld	a, (#_dialogue_revealing)
	or	a, a
	jp	Z, 00115$
;src/main.c:121: if(dialogue_clock==audio_clock)return 0;
	ld	a, (#_dialogue_clock)
	ld	hl, #_audio_clock
	sub	a, (hl)
	jr	NZ, 00102$
	xor	a, a
	jp	00116$
00102$:
;src/main.c:122: dialogue_clock=audio_clock;
	ld	a, (#_audio_clock)
	ld	(#_dialogue_clock),a
;src/main.c:123: result=dialogue_stream_next(&dialogue,narrative?story_lower:0);
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	ld	bc, #_story_lower+0
	jr	00119$
00118$:
	ld	bc, #0x0000
00119$:
	push	bc
	ld	de, #_dialogue
	push	de
	ld	e, #b_dialogue_stream_next
	ld	hl, #_dialogue_stream_next
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:124: if(result==DIALOGUE_STREAM_CHAR)dialogue_glyph();
	ld	l, a
	dec	a
	jr	NZ, 00106$
	push	hl
	call	_dialogue_glyph
	pop	hl
	jr	00107$
00106$:
;src/main.c:125: else if(result==DIALOGUE_STREAM_SCROLL)dialogue_draw(narrative);
	ld	a, l
	sub	a, #0x02
	jr	NZ, 00107$
	push	hl
	push	hl
	ldhl	sp,	#5
	ld	a, (hl)
	pop	hl
	call	_dialogue_draw
	pop	hl
00107$:
;src/main.c:126: dialogue_clock=audio_clock;
	ld	a, (_audio_clock)
	ld	(_dialogue_clock), a
;src/main.c:127: if(result!=DIALOGUE_STREAM_WAIT)return 0;
	ld	a, l
	or	a, a
	jr	Z, 00109$
	xor	a, a
	jp	00116$
00109$:
;src/main.c:128: dialogue_revealing=0;
	xor	a, a
	ld	(#_dialogue_revealing),a
;src/main.c:129: dialogue_wait=dialogue_wait_frames(dialogue.done?dialogue.terminator:0x61u,narrative);
	ld	a, (#_dialogue + 12)
	or	a, a
	jr	Z, 00120$
	ld	a, (#(_dialogue + 13) + 0)
	jr	00121$
00120$:
	ld	a, #0x61
00121$:
	ldhl	sp,	#1
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_dialogue_wait_frames
	ld	hl, #_dialogue_wait_frames
	call	___sdcc_bcall_ehl
	pop	hl
	ld	hl, #_dialogue_wait
	ld	a, c
;src/main.c:130: if(!dialogue_wait)return 1;
	ld	(hl+), a
	ld	(hl), b
	or	a, b
	jr	NZ, 00111$
	ld	a, #0x01
	jr	00116$
00111$:
;src/main.c:131: if(dialogue_wait==65535u)ui_text(17,narrative?7u:4u,">");
	ld	a, (_dialogue_wait)
	ld	c, a
	ld	hl, #_dialogue_wait + 1
	ld	a, c
	and	a, (hl)
	inc	a
	jr	NZ, 00113$
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	ld	a, #0x07
	jr	NZ, 00123$
	ld	a, #0x04
00123$:
	ld	de, #___str_4
	push	de
	push	af
	inc	sp
	ld	a, #0x11
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
00113$:
;src/main.c:132: return 0;
	xor	a, a
	jr	00116$
00115$:
;src/main.c:134: return dialogue_wait_tick(&dialogue_wait,dialogue.done?dialogue.terminator:0x61u,narrative,pressed);
	ld	a, (#(_dialogue + 12) + 0)
	or	a, a
	jr	Z, 00124$
	ld	a, (#(_dialogue + 13) + 0)
	jr	00125$
00124$:
	ld	a, #0x61
00125$:
	ld	b, a
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl)
	ld	e, a
	push	de
	push	bc
	inc	sp
	ld	de, #_dialogue_wait
	push	de
	ld	e, #b_dialogue_wait_tick
	ld	hl, #_dialogue_wait_tick
	call	___sdcc_bcall_ehl
	add	sp, #5
00116$:
;src/main.c:135: }
	inc	sp
	inc	sp
	ret
___str_4:
	.ascii ">"
	.db 0x00
;src/main.c:136: static void story_page(void) {
;	---------------------------------
; Function story_page
; ---------------------------------
_story_page:
;src/main.c:137: dialogue_revealing=1;screen_state=STATE_CUTSCENE;
	ld	hl, #_dialogue_revealing
	ld	(hl), #0x01
	ld	hl, #_screen_state
	ld	(hl), #0x12
;src/main.c:138: ui_panel(80,8);dialogue_clock=audio_clock;
	ld	hl, #0x850
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, (#_audio_clock)
	ld	(#_dialogue_clock),a
;src/main.c:139: }
	ret
;src/main.c:140: static void show_cutscene_record(void) {
;	---------------------------------
; Function show_cutscene_record
; ---------------------------------
_show_cutscene_record:
;src/main.c:141: if(game_cutscene.action.kind==CUTSCENE_DONE) {
	ld	a, (#(_game_cutscene + 3) + 0)
	or	a, a
	jr	NZ, 00104$
;src/main.c:142: if(game_movie_story_done())return;
	ld	e, #b_game_movie_story_done
	ld	hl, #_game_movie_story_done
	call	___sdcc_bcall_ehl
	or	a, a
	ret	NZ
;src/main.c:143: audio_command(0xd8);event_advance(&game_events);apply_event();return;
	ld	a, #0xd8
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_advance
	ld	hl, #_event_advance
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	jp  ___sdcc_bcall_ehl
00104$:
;src/main.c:145: if(scene_actor_active)scene_actor_hide();
	ld	a, (#_scene_actor_active)
	or	a, a
	jr	Z, 00106$
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
00106$:
;src/main.c:146: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/main.c:147: cutscene_portrait_show(game_cutscene.action.portrait);
	ld	a, (#(_game_cutscene + 4) + 0)
	push	af
	inc	sp
	ld	e, #b_cutscene_portrait_show
	ld	hl, #_cutscene_portrait_show
	call	___sdcc_bcall_ehl
	inc	sp
;src/main.c:150: set_bkg_palette(7,1,ui_palette);background_changed=1;DISPLAY_ON;
	ld	de, #_ui_palette
	push	de
	ld	hl, #0x107
	push	hl
	call	_set_bkg_palette
	add	sp, #4
	ld	hl, #_background_changed
	ld	(hl), #0x01
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/main.c:151: dialogue_open(&dialogue,game_cutscene.action.dialogue_id);
	ld	hl, #_game_cutscene + 5
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #_dialogue+0
	push	de
	push	bc
	push	de
	ld	e, #b_dialogue_open
	ld	hl, #_dialogue_open
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
;src/main.c:152: dialogue_stream_begin(&dialogue,story_lower);story_page();
	ld	bc, #_story_lower
	push	bc
	push	de
	ld	e, #b_dialogue_stream_begin
	ld	hl, #_dialogue_stream_begin
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:153: }
	jp	_story_page
;src/main.c:154: void start_cutscene(uint8_t sequence) {
;	---------------------------------
; Function start_cutscene
; ---------------------------------
_start_cutscene::
	ld	b, a
;src/main.c:155: if(sequence<=CUTSCENE_NOAH||sequence==CUTSCENE_LAERMA)audio_command(0x8a);
	ld	a, #0x03
	sub	a, b
	jr	NC, 00101$
	ld	a, b
	sub	a, #0x05
	jr	NZ, 00102$
00101$:
	push	bc
	ld	a, #0x8a
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
00102$:
;src/main.c:156: cutscene_begin(&game_cutscene,sequence,&game_rpg);show_cutscene_record();
	ld	de, #_game_rpg
	push	de
	push	bc
	inc	sp
	ld	de, #_game_cutscene
	push	de
	ld	e, #b_cutscene_begin
	ld	hl, #_cutscene_begin
	call	___sdcc_bcall_ehl
	add	sp, #5
;src/main.c:157: }
	jp	_show_cutscene_record
;src/main.c:158: void draw_dungeon(void) {
;	---------------------------------
; Function draw_dungeon
; ---------------------------------
_draw_dungeon::
;src/main.c:159: scene_context_type=0;
	xor	a, a
	ld	(#_scene_context_type),a
;src/main.c:160: if(scene_actor_active)scene_actor_hide();
	ld	a, (#_scene_actor_active)
	or	a, a
	jr	Z, 00102$
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
00102$:
;src/main.c:161: HIDE_WIN;HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/main.c:162: if(background_changed){dungeon_invalidate_view_cache();background_changed=0;}
	ld	a, (#_background_changed)
	or	a, a
	jr	Z, 00104$
	call	_dungeon_invalidate_view_cache
	xor	a, a
	ld	(#_background_changed),a
00104$:
;src/main.c:163: dungeon_render(&game_dungeon.dungeon,0);
	xor	a, a
	push	af
	inc	sp
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dungeon_render
	ld	hl, #_dungeon_render
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/main.c:164: }
	ret
;src/main.c:165: void draw_dungeon_faded(void) {
;	---------------------------------
; Function draw_dungeon_faded
; ---------------------------------
_draw_dungeon_faded::
;src/main.c:168: dungeon_motion_palette_muted=1;draw_dungeon();dungeon_motion_palette_muted=0;
	ld	hl, #_dungeon_motion_palette_muted
	ld	(hl), #0x01
	call	_draw_dungeon
	xor	a, a
	ld	(#_dungeon_motion_palette_muted),a
;src/main.c:169: DISPLAY_OFF;set_bkg_palette(0u,7u,(const uint16_t *)dungeon_render_palette);
	call	_display_off
	ld	de, #_dungeon_render_palette
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/main.c:170: scene_fade_begin(1u);DISPLAY_ON;
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_scene_fade_begin
	ld	hl, #_scene_fade_begin
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/main.c:171: }
	ret
;src/main.c:172: void begin_battle(uint8_t enemy,uint8_t from_event) {
;	---------------------------------
; Function begin_battle
; ---------------------------------
_begin_battle::
	dec	sp
	dec	sp
	ldhl	sp,	#1
	ld	(hl-), a
	ld	(hl), e
;src/main.c:173: if(from_event==0u||from_event==2u) {
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00105$
00104$:
;src/main.c:174: if(game_dungeon.active)draw_dungeon();
	ld	a, (#(_game_dungeon + 264) + 0)
	or	a, a
	jr	Z, 00102$
	call	_draw_dungeon
	jr	00105$
00102$:
;src/main.c:176: world_flags_at((player_x-8u)&2047u,(player_y+1536u-16u)%1536u));
	ld	a, (_player_y)
	ld	hl, #_player_y + 1
	ld	c, (hl)
	add	a, #0xf0
	ld	e, a
	ld	a, c
	adc	a, #0x05
	ld	bc, #0x0600
	ld	d, a
	call	__moduint
	ld	a, (_player_x)
	ld	hl, #_player_x + 1
	ld	d, (hl)
	add	a, #0xf8
	ld	e, a
	ld	a, d
	adc	a, #0xff
	and	a, #0x07
	push	bc
	ld	d, a
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:175: else scene_context_type=battle_scene_world_type(world_group_id,
	push	af
	inc	sp
	ld	a, (_world_group_id)
	push	af
	inc	sp
	ld	e, #b_battle_scene_world_type
	ld	hl, #_battle_scene_world_type
	call	___sdcc_bcall_ehl
	pop	hl
	ld	(#_scene_context_type),a
00105$:
;src/main.c:178: battle_scene_configure(scene_context_type,game_dungeon.active?game_dungeon.dungeon.palette_index:0);
	ld	a, (#(_game_dungeon + 264) + 0)
	or	a, a
	jr	Z, 00120$
	ld	a, (#(_game_dungeon + 6) + 0)
	jr	00121$
00120$:
	xor	a, a
00121$:
	push	af
	inc	sp
	ld	a, (_scene_context_type)
	push	af
	inc	sp
	ld	e, #b_battle_scene_configure
	ld	hl, #_battle_scene_configure
	call	___sdcc_bcall_ehl
	pop	hl
;src/main.c:179: if(scene_actor_active)scene_actor_hide();
	ld	a, (#_scene_actor_active)
	or	a, a
	jr	Z, 00108$
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
00108$:
;src/main.c:180: battle_from_event=from_event;
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(#_battle_from_event),a
;src/main.c:181: if(battle_view_begin(&game_rpg,enemy)==RPG_OK) {
	ldhl	sp,	#1
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_battle_view_begin
	ld	hl, #_battle_view_begin
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	c, a
	or	a, a
	jr	NZ, 00118$
;src/main.c:182: if(from_event==1u)battle_view_menu_allowed=game_events.event==22u||game_events.event==130u||game_events.event==147u;
	ldhl	sp,	#0
	ld	a, (hl)
	dec	a
	jr	NZ, 00112$
	ld	a, (#(_game_events + 260) + 0)
	cp	a, #0x16
	jr	Z, 00123$
	cp	a, #0x82
	jr	Z, 00123$
	sub	a, #0x93
	jr	Z, 00123$
	xor	a, a
	jr	00124$
00123$:
	ld	a, #0x01
00124$:
	ld	(#_battle_view_menu_allowed),a
	jr	00113$
00112$:
;src/main.c:183: else if(from_event==3u)battle_view_menu_allowed=0;
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00113$
	xor	a, a
	ld	(#_battle_view_menu_allowed),a
00113$:
;src/main.c:184: retained_trap=battle_view_battle.trap_chance;background_changed=1;screen_state=STATE_BATTLE;
	ld	a, (#(_battle_view_battle + 153) + 0)
	ld	(#_retained_trap),a
	ld	hl, #_background_changed
	ld	(hl), #0x01
	ld	hl, #_screen_state
	ld	(hl), #0x0f
;src/main.c:185: if(game_dungeon.active)battle_view_battle.escape_blocked=dplay_escape_blocked(&game_dungeon);
	ld	a, (#(_game_dungeon + 264) + 0)
	or	a, a
	jr	Z, 00118$
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_escape_blocked
	ld	hl, #_dplay_escape_blocked
	call	___sdcc_bcall_ehl
	pop	hl
	ld	(#(_battle_view_battle + 157)),a
00118$:
;src/main.c:187: }
	inc	sp
	inc	sp
	ret
;src/main.c:189: static void compute_camera(void) {
;	---------------------------------
; Function compute_camera
; ---------------------------------
_compute_camera:
;src/main.c:190: camera_x=(player_x+WORLD_PIXEL_WIDTH-80u)&2047u;
	ld	a, (_player_x)
	ld	hl, #_player_x + 1
	ld	b, (hl)
	add	a, #0xb0
	ld	c, a
	ld	a, b
	adc	a, #0x07
	and	a, #0x07
	ld	hl, #_camera_x
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/main.c:191: camera_y=(player_y+WORLD_PIXEL_HEIGHT-80u)%WORLD_PIXEL_HEIGHT;
	ld	a, (_player_y)
	ld	hl, #_player_y + 1
	ld	c, (hl)
	add	a, #0xb0
	ld	e, a
	ld	a, c
	adc	a, #0x05
	ld	bc, #0x0600
	ld	d, a
	call	__moduint
	ld	hl, #_camera_y
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/main.c:192: }
	ret
;src/main.c:193: static void draw_player(void) {
;	---------------------------------
; Function draw_player
; ---------------------------------
_draw_player:
	dec	sp
;src/main.c:194: uint8_t sx=(uint8_t)((player_x+WORLD_PIXEL_WIDTH-camera_x)&2047u);
	ld	a, (_player_x)
	ld	hl, #_camera_x
	ld	c, (hl)
	sub	a, c
	ldhl	sp,	#0
	ld	(hl), a
;src/main.c:195: uint8_t sy=(uint8_t)((player_y+WORLD_PIXEL_HEIGHT-camera_y)%WORLD_PIXEL_HEIGHT);
	ld	a, (_player_y)
	ld	hl, #_player_y + 1
	ld	d, (hl)
	ld	c, a
	ld	a, d
	add	a, #0x06
	ld	b, a
	ld	a, c
	ld	hl, #_camera_y
	sub	a, (hl)
	inc	hl
	ld	e, a
	ld	a, b
	sbc	a, (hl)
	ld	d, a
	ld	bc, #0x0600
	call	__moduint
;src/main.c:196: if(game_vehicle) {
	ld	a, (#_game_vehicle)
	or	a, a
	jr	Z, 00104$
;src/main.c:197: if(vehicle_loaded_facing!=facing) {
	ld	a, (#_vehicle_loaded_facing)
	ld	hl, #_facing
	sub	a, (hl)
	jr	Z, 00102$
;src/main.c:198: DISPLAY_OFF;vehicle_sprite_load(game_vehicle,facing);DISPLAY_ON;vehicle_loaded_facing=facing;
	call	_display_off
	push	bc
	ld	a, (_facing)
	ld	h, a
	ld	a, (_game_vehicle)
	ld	l, a
	push	hl
	ld	e, #b_vehicle_sprite_load
	ld	hl, #_vehicle_sprite_load
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
	ld	a, (#_facing)
	ld	(#_vehicle_loaded_facing),a
00102$:
;src/main.c:200: vehicle_sprite_draw(sx,sy);return;
	ld	a, c
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_vehicle_sprite_draw
	ld	hl, #_vehicle_sprite_draw
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00105$
00104$:
;src/main.c:202: party_world_draw();
	ld	e, #b_party_world_draw
	ld	hl, #_party_world_draw
	call	___sdcc_bcall_ehl
00105$:
;src/main.c:203: }
	inc	sp
	ret
;src/main.c:204: static void redraw_world(uint8_t force) {
;	---------------------------------
; Function redraw_world
; ---------------------------------
_redraw_world:
	ld	b, a
;src/main.c:205: world_terrain_sync(player_x,player_y);
	push	bc
	ld	a, (_player_y)
	ld	e, a
	ld	hl, #_player_y + 1
	ld	d, (hl)
	push	de
	ld	a, (_player_x)
	ld	e, a
	ld	hl, #_player_x + 1
	ld	d, (hl)
	push	de
	ld	e, #b_world_terrain_sync
	ld	hl, #_world_terrain_sync
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:206: compute_camera();world_draw(camera_x,camera_y,force);draw_player();
	call	_compute_camera
	inc	sp
	ld	a, (_camera_y)
	ld	e, a
	ld	hl, #_camera_y + 1
	ld	d, (hl)
	push	de
	ld	a, (_camera_x)
	ld	e, a
	ld	hl, #_camera_x + 1
	ld	d, (hl)
	push	de
	ld	e, #b_world_draw
	ld	hl, #_world_draw
	call	___sdcc_bcall_ehl
	add	sp, #5
;src/main.c:207: }
	jp	_draw_player
;src/main.c:210: void reload_world_mode(void) {
;	---------------------------------
; Function reload_world_mode
; ---------------------------------
_reload_world_mode::
;src/main.c:211: game_transition_fade_out();
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
;src/main.c:212: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;scene_actor_hide();
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
;src/main.c:213: world_select(world_map_id);world_load_graphics();
	ld	a, (_world_map_id)
	push	af
	inc	sp
	ld	e, #b_world_select
	ld	hl, #_world_select
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, #b_world_load_graphics
	ld	hl, #_world_load_graphics
	call	___sdcc_bcall_ehl
;src/main.c:214: world_vehicle_footprint(player_x,player_y,game_vehicle);vehicle_loaded_facing=255;vehicle_palette_reset();
	ld	a, (_game_vehicle)
	push	af
	inc	sp
	ld	a, (_player_y)
	ld	e, a
	ld	hl, #_player_y + 1
	ld	d, (hl)
	push	de
	ld	a, (_player_x)
	ld	e, a
	ld	hl, #_player_x + 1
	ld	d, (hl)
	push	de
	ld	e, #b_world_vehicle_footprint
	ld	hl, #_world_vehicle_footprint
	call	___sdcc_bcall_ehl
	add	sp, #5
	ld	hl, #_vehicle_loaded_facing
	ld	(hl), #0xff
	ld	e, #b_vehicle_palette_reset
	ld	hl, #_vehicle_palette_reset
	call	___sdcc_bcall_ehl
;src/main.c:215: return_x=player_x;return_y=player_y;step_remaining=0;walk_frame=0;
	ld	a, (#_player_x)
	ld	(#_return_x),a
	ld	a, (#_player_x + 1)
	ld	(#_return_x + 1),a
	ld	a, (#_player_y)
	ld	(#_return_y),a
	ld	a, (#_player_y + 1)
	ld	(#_return_y + 1),a
	xor	a, a
	ld	(#_step_remaining), a
	ld	(#_walk_frame),a
;src/main.c:216: if(!game_vehicle)party_world_reset(0);
	ld	a, (#_game_vehicle)
	or	a, a
	jr	NZ, 00102$
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_party_world_reset
	ld	hl, #_party_world_reset
	call	___sdcc_bcall_ehl
	inc	sp
00102$:
;src/main.c:217: redraw_world(1);scene_fade_begin(1u);DISPLAY_ON;
	ld	a, #0x01
	call	_redraw_world
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_scene_fade_begin
	ld	hl, #_scene_fade_begin
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/main.c:218: game_transition_wait(5u,0u); /* Four0A actor uploads, then744B map12 upload. */
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x05
	push	af
	inc	sp
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
;src/main.c:219: game_transition_map_music(game_vehicle?0x8f:audio_map_track(world_map_id));
	ld	a, (#_game_vehicle)
	or	a, a
	jr	Z, 00105$
	ld	a, #0x8f
	jr	00106$
00105$:
	ld	a, (_world_map_id)
	push	af
	inc	sp
	ld	e, #b_audio_map_track
	ld	hl, #_audio_map_track
	call	___sdcc_bcall_ehl
	inc	sp
00106$:
	push	af
	inc	sp
	ld	e, #b_game_transition_map_music
	ld	hl, #_game_transition_map_music
	call	___sdcc_bcall_ehl
	inc	sp
;src/main.c:220: game_transition_wait(1u,0u); /* Original2FD's14 upload. */
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
;src/main.c:221: game_transition_fade_in();
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
	call	___sdcc_bcall_ehl
;src/main.c:222: scene_context_type=0;background_changed=0;HIDE_WIN;SHOW_SPRITES;screen_state=STATE_WALK;
	xor	a, a
	ld	(#_scene_context_type), a
	ld	(#_background_changed),a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_screen_state
	ld	(hl), #0x01
;src/main.c:223: }
	ret
;src/main.c:224: void enter_map(uint8_t id,uint16_t x,uint16_t y) {
;	---------------------------------
; Function enter_map
; ---------------------------------
_enter_map::
	dec	sp
	ldhl	sp,	#0
	ld	(hl), a
;src/main.c:225: battle_view_chest_abandon();
	push	de
	ld	e, #b_battle_view_chest_abandon
	ld	hl, #_battle_view_chest_abandon
	call	___sdcc_bcall_ehl
	pop	de
;src/main.c:226: game_vehicle=0;game_dungeon.active=0;dark_menu_pending=0;
	xor	a, a
	ld	(#_game_vehicle),a
	ld	bc, #_game_dungeon+264
	xor	a, a
	ld	(bc), a
	ld	(#_dark_menu_pending),a
;src/main.c:227: game_events.event=0;game_events.type=0;
	ld	hl, #_game_events + 260
	ld	(hl), #0x00
	ld	hl, #_game_events + 261
	ld	(hl), #0x00
;src/main.c:228: world_select(id);player_x=x;player_y=y;reload_world_mode();
	push	de
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_world_select
	ld	hl, #_world_select
	call	___sdcc_bcall_ehl
	inc	sp
	pop	de
	ld	hl, #_player_x
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(#_player_y),a
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(#_player_y + 1),a
	call	_reload_world_mode
;src/main.c:229: }
	inc	sp
	pop	hl
	pop	af
	jp	(hl)
;src/main.c:232: void enter_map_ready(uint8_t id,uint16_t x,uint16_t y) {
;	---------------------------------
; Function enter_map_ready
; ---------------------------------
_enter_map_ready::
	ld	b, a
;src/main.c:233: battle_view_chest_abandon();world_select(id);player_x=x;player_y=y;
	push	bc
	push	de
	ld	e, #b_battle_view_chest_abandon
	ld	hl, #_battle_view_chest_abandon
	call	___sdcc_bcall_ehl
	pop	de
	pop	bc
	push	de
	push	bc
	inc	sp
	ld	e, #b_world_select
	ld	hl, #_world_select
	call	___sdcc_bcall_ehl
	inc	sp
	pop	de
	ld	hl, #_player_x
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(#_player_y),a
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(#_player_y + 1),a
;src/main.c:234: game_vehicle=0;vehicle_loaded_facing=255;game_dungeon.active=0;dark_menu_pending=0;
	xor	a, a
	ld	(#_game_vehicle),a
	ld	hl, #_vehicle_loaded_facing
	ld	(hl), #0xff
	ld	bc, #_game_dungeon+264
	xor	a, a
	ld	(bc), a
	ld	(#_dark_menu_pending),a
;src/main.c:235: game_events.event=0;game_events.type=0;scene_context_type=0;background_changed=0;
	ld	hl, #_game_events + 260
	ld	(hl), #0x00
	ld	hl, #_game_events + 261
	ld	(hl), #0x00
	xor	a, a
	ld	(#_scene_context_type), a
	ld	(#_background_changed),a
;src/main.c:236: return_x=x;return_y=y;step_remaining=0;walk_frame=0;
	ld	hl, #_return_x
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(#_return_y),a
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(#_return_y + 1),a
	xor	a, a
	ld	(#_step_remaining), a
	ld	(#_walk_frame),a
;src/main.c:237: HIDE_WIN;SHOW_SPRITES;screen_state=STATE_WALK;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_screen_state
	ld	(hl), #0x01
;src/main.c:238: }
	pop	hl
	pop	af
	jp	(hl)
;src/main.c:239: void resume_walk(void) {
;	---------------------------------
; Function resume_walk
; ---------------------------------
_resume_walk::
;src/main.c:240: if(battle_view_field_menu_pending){battle_view_chest_leave();screen_state=STATE_BATTLE;return;}
	ld	a, (#_battle_view_field_menu_pending)
	or	a, a
	jr	Z, 00102$
	ld	e, #b_battle_view_chest_leave
	ld	hl, #_battle_view_chest_leave
	call	___sdcc_bcall_ehl
	ld	hl, #_screen_state
	ld	(hl), #0x0f
	ret
00102$:
;src/main.c:241: if(game_transition_interaction_music(game_events.type))audio_command(0xd8);
	ld	a, (#(_game_events + 261) + 0)
	push	af
	inc	sp
	ld	e, #b_game_transition_interaction_music
	ld	hl, #_game_transition_interaction_music
	call	___sdcc_bcall_ehl
	inc	sp
	or	a, a
	jr	Z, 00104$
	ld	a, #0xd8
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00104$:
;src/main.c:242: game_events.event=0;game_events.type=0;
	ld	hl, #_game_events + 260
	ld	(hl), #0x00
	ld	hl, #(_game_events + 261)
	ld	(hl), #0x00
;src/main.c:243: if(game_dungeon.active) {
	ld	a, (#(_game_dungeon + 264) + 0)
	or	a, a
	jp	Z, _reload_world_mode
;src/main.c:244: if(dark_menu_pending) {
	ld	hl, #_dark_menu_pending
	ld	a, (hl)
	or	a, a
	jr	Z, 00108$
;src/main.c:245: dark_menu_pending=0;
	ld	(hl), #0x00
;src/main.c:246: if(!game_dungeon.dungeon.light){enter_map(world_map_id,player_x,player_y);return;}
	ld	a, (#(_game_dungeon + 3) + 0)
	or	a, a
	jr	NZ, 00106$
	ld	a, (_player_y)
	ld	e, a
	ld	hl, #_player_y + 1
	ld	d, (hl)
	push	de
	ld	a, (_player_x)
	ld	e, a
	ld	hl, #_player_x + 1
	ld	d, (hl)
	ld	a, (_world_map_id)
	call	_enter_map
	ret
00106$:
;src/main.c:247: dungeon_refresh_light(&game_dungeon.dungeon);
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dungeon_refresh_light
	ld	hl, #_dungeon_refresh_light
	call	___sdcc_bcall_ehl
	pop	hl
00108$:
;src/main.c:249: if(background_changed){
	ld	a, (#_background_changed)
	or	a, a
	jr	Z, 00110$
;src/main.c:250: game_transition_fade_out();draw_dungeon_faded();
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
	call	_draw_dungeon_faded
;src/main.c:251: game_transition_map_music(game_dungeon.dungeon.music);game_transition_fade_in();
	ld	a, (#(_game_dungeon + 7) + 0)
	push	af
	inc	sp
	ld	e, #b_game_transition_map_music
	ld	hl, #_game_transition_map_music
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
	call	___sdcc_bcall_ehl
00110$:
;src/main.c:253: dplay_resume(&game_dungeon,&game_rpg,&game_events);apply_dungeon();return;
	ld	de, #_game_events
	push	de
	ld	de, #_game_rpg
	push	de
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_resume
	ld	hl, #_dplay_resume
	call	___sdcc_bcall_ehl
	add	sp, #6
	ld	e, #b_apply_dungeon
	ld	hl, #_apply_dungeon
	call	___sdcc_bcall_ehl
;src/main.c:255: reload_world_mode();
;src/main.c:256: }
	ret
;src/main.c:261: uint8_t game_read_slot(uint8_t slot) {
;	---------------------------------
; Function game_read_slot
; ---------------------------------
_game_read_slot::
	add	sp, #-4
;src/main.c:262: uint16_t i,offset=save_slot_offset(slot);
	push	af
	inc	sp
	ld	e, #b_save_slot_offset
	ld	hl, #_save_slot_offset
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/main.c:263: if(offset==65535u){saved_position_valid=0;return 0;}
	push	bc
	ld	a, c
	and	a, b
	inc	a
	jr	NZ, 00102$
	ld	(#_saved_position_valid), a
	jr	00106$
00102$:
;src/main.c:264: ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);
	ld	hl, #_rRAMG
	ld	(hl), #0x0a
	xor	a, a
	ld	(#_rRAMB),a
;src/main.c:265: for(i=0;i<SAVE_BYTES;++i) save_data[i]=SAVE_BASE[offset+i];
	ld	bc, #0x0000
00104$:
	ld	hl, #_save_storage
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	push	hl
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, #0xa000
	add	hl, de
	ld	a, (hl)
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	inc	bc
	ld	e, c
	ld	d, b
	ld	a, e
	sub	a, #0x74
	ld	a, d
	sbc	a, #0x02
	jr	C, 00104$
;src/main.c:266: DISABLE_RAM_MBC5;saved_position_valid=save_decode(&save_state,save_data);
	xor	a, a
	ld	(#_rRAMG),a
	ld	de, #_save_storage
	push	de
	push	de
	ld	e, #b_save_decode
	ld	hl, #_save_decode
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	hl, #_saved_position_valid
	ld	(hl), a
;src/main.c:267: return saved_position_valid;
	ld	a, (hl)
00106$:
;src/main.c:268: }
	add	sp, #4
	ret
;src/main.c:269: static void read_save(void) {game_read_slot(save_active_slot);}
;	---------------------------------
; Function read_save
; ---------------------------------
_read_save:
	ld	a, (_save_active_slot)
	jp	_game_read_slot
;src/main.c:270: uint8_t game_write_slot(uint8_t slot) {
;	---------------------------------
; Function game_write_slot
; ---------------------------------
_game_write_slot::
	add	sp, #-5
	ldhl	sp,	#4
	ld	(hl), a
;src/main.c:271: uint16_t i,offset=save_slot_offset(slot);
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_save_slot_offset
	ld	hl, #_save_slot_offset
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/main.c:272: if(offset==65535u)return 0;
	push	bc
	ld	a, c
	and	a, b
	inc	a
	jp	Z, 00108$
;src/main.c:273: save_state.map=world_map_id;save_state.facing=facing;save_state.x=player_x;save_state.y=player_y;
	ld	de, #_save_storage
	ld	a, (_world_map_id)
	ld	(de), a
	ld	de, #(_save_storage + 1)
	ld	a, (_facing)
	ld	(de), a
	ld	de, #(_save_storage + 2)
	ld	a, (_player_x)
	ld	(de), a
	inc	de
	ld	a, (_player_x + 1)
	ld	(de), a
	ld	de, #(_save_storage + 4)
	ld	a, (_player_y)
	ld	(de), a
	inc	de
	ld	a, (_player_y + 1)
	ld	(de), a
;src/main.c:274: memcpy(&save_state.rpg,&game_rpg,sizeof(game_rpg));memcpy(save_state.flags,game_events.flags,256);
	ld	de, #0x005e
	push	de
	ld	bc, #_game_rpg
	ld	de, #(_save_storage + 6)
	call	_memcpy
	xor	a, a
	inc	a
	push	af
	ld	bc, #_game_events
	ld	de, #(_save_storage + 100)
	call	_memcpy
;src/main.c:275: save_state.secrets_requests=game_events.secrets_requests;
	ld	a, (#(_game_events + 258) + 0)
	ld	hl, #(_save_storage + 356)
;src/main.c:276: save_state.last_church=game_events.last_church;
	ld	(hl+), a
	ld	a, (#(_game_events + 259) + 0)
	ld	(hl), a
;src/main.c:277: memcpy(save_state.object_flags,game_events.object_flags,256);
	xor	a, a
	inc	a
	push	af
	ld	bc, #(_game_events + 293)
	ld	de, #(_save_storage + 358)
	call	_memcpy
;src/main.c:278: save_state.dungeon_active=game_dungeon.active;save_state.dungeon_floor=game_dungeon.dungeon.floor;
	ld	a, (#(_game_dungeon + 264) + 0)
	ld	hl, #(_save_storage + 614)
	ld	(hl+), a
	ld	a, (#_game_dungeon + 0)
;src/main.c:279: save_state.dungeon_position=game_dungeon.dungeon.position;save_state.dungeon_direction=game_dungeon.dungeon.direction;
	ld	(hl+), a
	ld	a, (#(_game_dungeon + 1) + 0)
	ld	(hl+), a
	ld	a, (#(_game_dungeon + 2) + 0)
;src/main.c:280: save_state.dungeon_light=game_dungeon.dungeon.light;
	ld	(hl+), a
	ld	a, (#(_game_dungeon + 3) + 0)
;src/main.c:281: save_state.vehicle=game_vehicle;
;src/main.c:282: save_state.vehicle_phase=vehicle_cycle.phase;save_state.vehicle_clock=vehicle_cycle.clock;
	ld	(hl+), a
	inc	hl
	ld	de, #(_save_storage + 619)
	ld	a, (_game_vehicle)
	ld	(de), a
	ld	a, (#_vehicle_cycle + 0)
	ld	(hl+), a
	ld	a, (#(_vehicle_cycle + 1) + 0)
	ld	(hl), a
;src/main.c:283: if(!save_encode(save_data,&save_state)) return 0;
	ld	de, #_save_storage
	push	de
	push	de
	ld	e, #b_save_encode
	ld	hl, #_save_encode
	call	___sdcc_bcall_ehl
	add	sp, #4
	or	a,a
	jr	Z, 00108$
;src/main.c:284: ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);SAVE_BASE[offset]=0;
	ld	hl, #_rRAMG
	ld	(hl), #0x0a
	xor	a, a
	ld	(#_rRAMB),a
	pop	de
	push	de
	ld	hl, #0xa000
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
;src/main.c:285: for(i=1;i<SAVE_BYTES;++i) SAVE_BASE[offset+i]=save_data[i];
	ld	de, #0x0001
	ld	(hl), d
00106$:
	push	de
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	bc, #0xa000
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #_save_storage
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
	inc	de
	ld	c, e
	ld	b, d
	ld	a, c
	sub	a, #0x74
	ld	a, b
	sbc	a, #0x02
	jr	C, 00106$
;src/main.c:286: SAVE_BASE[offset]=save_data[0];DISABLE_RAM_MBC5;
	ld	a, (#_save_storage + 0)
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	xor	a, a
	ld	(#_rRAMG),a
;src/main.c:287: save_active_slot=slot;save_valid_mask|=1u<<slot;saved_position_valid=1;return 1;
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(#_save_active_slot),a
	ldhl	sp,	#4
	ld	b, (hl)
	ld	a, #0x01
	inc	b
	jr	00142$
00141$:
	add	a, a
00142$:
	dec	b
	jr	NZ,00141$
	ld	hl, #_save_valid_mask
	or	a, (hl)
	ld	(hl), a
	ld	hl, #_saved_position_valid
	ld	(hl), #0x01
	ld	a, #0x01
00108$:
;src/main.c:288: }
	add	sp, #5
	ret
;src/main.c:289: static uint8_t write_save(void) {return game_write_slot(save_active_slot);}
;	---------------------------------
; Function write_save
; ---------------------------------
_write_save:
	ld	a, (_save_active_slot)
	jp	_game_write_slot
;src/main.c:290: void start_game(uint8_t continued) {
;	---------------------------------
; Function start_game
; ---------------------------------
_start_game::
	ld	c, a
;src/main.c:291: field_active=0;battle_view_chest_abandon();
	xor	a, a
	ld	(#_field_active),a
	push	bc
	ld	e, #b_battle_view_chest_abandon
	ld	hl, #_battle_view_chest_abandon
	call	___sdcc_bcall_ehl
	pop	bc
;src/main.c:292: if(continued) {
	ld	a, c
	or	a, a
	jp	Z, 00109$
;src/main.c:293: read_save();
	call	_read_save
;src/main.c:294: if(!saved_position_valid) {title_choice=0;title_screen();return;}
	ld	a, (#_saved_position_valid)
	or	a,a
	jr	NZ, 00102$
	ld	(#_title_choice),a
	ld	e, #b_title_screen
	ld	hl, #_title_screen
	call	___sdcc_bcall_ehl
	ret
00102$:
;src/main.c:295: vehicle_cycle.phase=save_state.vehicle_phase;vehicle_cycle.clock=save_state.vehicle_clock;
	ld	a, (#(_save_storage + 620) + 0)
	ld	hl, #_vehicle_cycle
	ld	(hl+), a
	ld	a, (#(_save_storage + 621) + 0)
	ld	(hl), a
;src/main.c:296: memcpy(&game_rpg,&save_state.rpg,sizeof(game_rpg));event_init(&game_events,&game_rpg);
	ld	de, #0x005e
	push	de
	ld	bc, #(_save_storage + 6)
	ld	de, #_game_rpg
	call	_memcpy
	ld	de, #_game_rpg
	push	de
	ld	de, #_game_events
	push	de
	ld	e, #b_event_init
	ld	hl, #_event_init
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:297: memcpy(game_events.flags,save_state.flags,256);facing=save_state.facing;
	xor	a, a
	inc	a
	push	af
	ld	bc, #(_save_storage + 100)
	ld	de, #_game_events
	call	_memcpy
	ld	a, (#(_save_storage + 1) + 0)
	ld	(#_facing),a
;src/main.c:298: game_events.secrets_requests=save_state.secrets_requests;
	ld	a, (#(_save_storage + 356) + 0)
	ld	hl, #(_game_events + 258)
;src/main.c:299: game_events.last_church=save_state.last_church;
	ld	(hl+), a
	ld	a, (#(_save_storage + 357) + 0)
	ld	(hl), a
;src/main.c:300: memcpy(game_events.object_flags,save_state.object_flags,256);
	xor	a, a
	inc	a
	push	af
	ld	bc, #(_save_storage + 358)
	ld	de, #(_game_events + 293)
	call	_memcpy
;src/main.c:303: world_select(save_state.map);player_x=save_state.x;player_y=save_state.y;
	ld	a, (#_save_storage + 0)
	push	af
	inc	sp
	ld	e, #b_world_select
	ld	hl, #_world_select
	call	___sdcc_bcall_ehl
	inc	sp
	ld	de, #(_save_storage + 2)
	ld	a, (de)
	ld	hl, #_player_x
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	de, #(_save_storage + 4)
	ld	a, (de)
	ld	hl, #_player_y
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;src/main.c:304: return_x=player_x;return_y=player_y;game_vehicle=save_state.vehicle;
	ld	a, (#_player_x)
	ld	(#_return_x),a
	ld	a, (#_player_x + 1)
	ld	(#_return_x + 1),a
	ld	a, (#_player_y)
	ld	(#_return_y),a
	ld	a, (#_player_y + 1)
	ld	(#_return_y + 1),a
	ld	a, (#(_save_storage + 619) + 0)
	ld	(#_game_vehicle),a
;src/main.c:305: game_dungeon.active=0;dark_menu_pending=0;step_remaining=0;
	ld	hl, #(_game_dungeon + 264)
	ld	(hl), #0x00
	xor	a, a
	ld	(#_dark_menu_pending), a
	ld	(#_step_remaining),a
;src/main.c:306: if(save_state.dungeon_active) {
	ld	hl, #_save_storage + 614
	ld	c, (hl)
	ld	a, c
	or	a, a
	jp	Z, 00106$
;src/main.c:307: game_transition_fade_out();game_vehicle=0;
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
	xor	a, a
	ld	(#_game_vehicle),a
;src/main.c:308: memset(&game_dungeon,0,sizeof(game_dungeon));
	ld	de, #0x011c
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_game_dungeon
	push	de
	call	_memset
	add	sp, #6
;src/main.c:309: dungeon_enter(&game_dungeon.dungeon,save_state.dungeon_floor,save_state.dungeon_position,save_state.dungeon_direction);
	ld	hl, #_save_storage + 617
	ld	b, (hl)
	ld	hl, #(_save_storage + 616)
	ld	c, (hl)
	ld	a, (#(_save_storage + 615) + 0)
	push	bc
	inc	sp
	ld	h, c
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dungeon_enter
	ld	hl, #_dungeon_enter
	call	___sdcc_bcall_ehl
	add	sp, #5
;src/main.c:310: game_dungeon.dungeon.light=save_state.dungeon_light;
	ld	a, (#(_save_storage + 618) + 0)
	ld	(#(_game_dungeon + 3)),a
;src/main.c:311: if(rpg_find_item(&game_rpg,ItemID_MagicLamp)!=RPG_NO_SLOT)game_dungeon.dungeon.light=255u;
	ld	a, #0x39
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	inc	a
	jr	Z, 00104$
	ld	hl, #(_game_dungeon + 3)
	ld	(hl), #0xff
00104$:
;src/main.c:312: dungeon_refresh_light(&game_dungeon.dungeon);game_transition_map_music(game_dungeon.dungeon.music);
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dungeon_refresh_light
	ld	hl, #_dungeon_refresh_light
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, (#(_game_dungeon + 7) + 0)
	push	af
	inc	sp
	ld	e, #b_game_transition_map_music
	ld	hl, #_game_transition_map_music
	call	___sdcc_bcall_ehl
	inc	sp
;src/main.c:313: game_dungeon.active=1;game_dungeon.initial_dark=1;game_dungeon.check_count=1;
	ld	hl, #(_game_dungeon + 264)
	ld	(hl), #0x01
	ld	hl, #_game_dungeon + 272
	ld	(hl), #0x01
	ld	hl, #_game_dungeon + 265
	ld	(hl), #0x01
;src/main.c:314: game_dungeon.positions[0]=save_state.dungeon_position;game_dungeon.views[0]=1;
	ld	bc, #_game_dungeon + 267
	ld	a, (#(_save_storage + 616) + 0)
	ld	(bc), a
	ld	hl, #_game_dungeon + 269
	ld	(hl), #0x01
;src/main.c:315: background_changed=1;draw_dungeon_faded();game_transition_wait(2u,0u);game_transition_fade_in();
	ld	hl, #_background_changed
	ld	(hl), #0x01
	call	_draw_dungeon_faded
	ld	hl, #0x02
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
	call	___sdcc_bcall_ehl
;src/main.c:316: dplay_resume(&game_dungeon,&game_rpg,&game_events);apply_dungeon();
	ld	de, #_game_events
	push	de
	ld	de, #_game_rpg
	push	de
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_resume
	ld	hl, #_dplay_resume
	call	___sdcc_bcall_ehl
	add	sp, #6
	ld	e, #b_apply_dungeon
	ld	hl, #_apply_dungeon
	call	___sdcc_bcall_ehl
	jr	00110$
00106$:
;src/main.c:317: } else reload_world_mode();
	call	_reload_world_mode
	jr	00110$
00109$:
;src/main.c:319: memset(&game_dungeon,0,sizeof(game_dungeon));retained_trap=0;
	ld	de, #0x011c
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_game_dungeon
	push	de
	call	_memset
	add	sp, #6
	xor	a, a
	ld	(#_retained_trap),a
;src/main.c:320: vehicle_cycle.phase=vehicle_cycle.clock=0;
	ld	hl, #_vehicle_cycle + 1
	ld	(hl), #0x00
	ld	hl, #_vehicle_cycle
	ld	(hl), #0x00
;src/main.c:321: rpg_new_game(&game_rpg);rpg_seed_rng(&game_rpg,frame_counter^DIV_REG);
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_new_game
	ld	hl, #_rpg_new_game
	call	___sdcc_bcall_ehl
	pop	hl
	ldh	a, (_DIV_REG + 0)
	ld	c, a
	ld	hl, #_frame_counter
	ld	a, (hl+)
	xor	a, c
	ld	d, (hl)
	ld	bc, #_game_rpg
	push	bc
	ld	e, a
	push	de
	push	bc
	ld	e, #b_rpg_seed_rng
	ld	hl, #_rpg_seed_rng
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
;src/main.c:322: event_init(&game_events,&game_rpg);facing=0;
	push	bc
	ld	de, #_game_events
	push	de
	ld	e, #b_event_init
	ld	hl, #_event_init
	call	___sdcc_bcall_ehl
	add	sp, #4
	xor	a, a
	ld	(#_facing),a
;src/main.c:323: start_opening();
	ld	e, #b_start_opening
	ld	hl, #_start_opening
	call	___sdcc_bcall_ehl
00110$:
;src/main.c:325: deferred_buttons=0;service_active=0;service_selector=0;
	xor	a, a
	ld	(#_deferred_buttons), a
	ld	(#_service_active),a
	xor	a, a
	ld	(#_service_selector),a
;src/main.c:326: }
	ret
;src/main.c:327: static void dialogue_page(void) {
;	---------------------------------
; Function dialogue_page
; ---------------------------------
_dialogue_page:
;src/main.c:328: dialogue_revealing=1;screen_state=STATE_DIALOGUE;
	ld	hl, #_dialogue_revealing
	ld	(hl), #0x01
	ld	hl, #_screen_state
	ld	(hl), #0x04
;src/main.c:329: if(scene_actor_active)SHOW_SPRITES;else HIDE_SPRITES;
	ld	a, (#_scene_actor_active)
	or	a, a
	jr	Z, 00102$
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
	jr	00103$
00102$:
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
00103$:
;src/main.c:330: ui_panel(104,5);
	ld	a, #0x05
	push	af
	inc	sp
	ld	a, #0x68
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
;src/main.c:331: dialogue_draw(0);dialogue_clock=audio_clock;
	xor	a, a
	call	_dialogue_draw
	ld	a, (#_audio_clock)
	ld	(#_dialogue_clock),a
;src/main.c:332: }
	ret
;src/main.c:333: void show_dialogue(uint16_t id) {
;	---------------------------------
; Function show_dialogue
; ---------------------------------
_show_dialogue::
	dec	sp
;src/main.c:334: if(!dialogue_open(&dialogue,id)) {notice("TEXT NOT AVAILABLE",STATE_WALK);return;}
	push	de
	ld	de, #_dialogue
	push	de
	ld	e, #b_dialogue_open
	ld	hl, #_dialogue_open
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,#0
	ld	(hl), a
	or	a, a
	jr	NZ, 00102$
	ld	a, #0x01
	push	af
	inc	sp
	ld	de, #___str_5
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00115$
00102$:
;src/main.c:336: dialogue_item_name(field_action.item,dialogue.item);
;src/main.c:337: if(field_action.character<4u)strcpy(dialogue.character,names[field_action.character]);
;src/main.c:336: dialogue_item_name(field_action.item,dialogue.item);
;src/main.c:337: if(field_action.character<4u)strcpy(dialogue.character,names[field_action.character]);
;src/main.c:335: if(field_active) {
	ld	a, (#_field_active)
	or	a, a
	jr	Z, 00113$
;src/main.c:336: dialogue_item_name(field_action.item,dialogue.item);
	ld	a, (#(_field_action + 3) + 0)
	ld	de, #(_dialogue + 32)
	push	de
	push	af
	inc	sp
	ld	e, #b_dialogue_item_name
	ld	hl, #_dialogue_item_name
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/main.c:337: if(field_action.character<4u)strcpy(dialogue.character,names[field_action.character]);
	ld	hl, #_field_action + 4
	ld	e, (hl)
	ld	a, e
	sub	a, #0x04
	jp	NC, 00114$
	ld	bc, #_names+0
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	de, #(_dialogue + 18)
	push	de
	call	_strcpy
	add	sp, #4
	jp	00114$
00113$:
;src/main.c:339: dialogue.number=game_service.action.number;
;src/main.c:338: } else if(service_active) {
	ld	a, (#_service_active)
	or	a, a
	jr	Z, 00110$
;src/main.c:339: dialogue.number=game_service.action.number;
	ld	hl, #(_game_service + 11)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #(_dialogue + 10)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/main.c:340: dialogue_item_name(game_service.action.item,dialogue.item);
	ld	a, (#(_game_service + 13) + 0)
	ld	de, #(_dialogue + 32)
	push	de
	push	af
	inc	sp
	ld	e, #b_dialogue_item_name
	ld	hl, #_dialogue_item_name
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/main.c:341: if(game_service.action.character<4u) strcpy(dialogue.character,names[game_service.action.character]);
	ld	hl, #(_game_service + 14)
	ld	c, (hl)
	ld	a, c
	sub	a, #0x04
	jr	NC, 00114$
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	ld	de, #_names
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	de, #(_dialogue + 18)
	push	de
	call	_strcpy
	add	sp, #4
	jr	00114$
00110$:
;src/main.c:343: dialogue.number=game_events.action.number;
	ld	hl, #(_game_events + 285)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #(_dialogue + 10)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/main.c:344: dialogue_item_name(game_events.action.item,dialogue.item);
	ld	a, (#(_game_events + 287) + 0)
	ld	de, #(_dialogue + 32)
	push	de
	push	af
	inc	sp
	ld	e, #b_dialogue_item_name
	ld	hl, #_dialogue_item_name
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/main.c:345: if(game_events.action.character<4u) strcpy(dialogue.character,names[game_events.action.character]);
	ld	hl, #(_game_events + 291)
	ld	c, (hl)
	ld	a, c
	sub	a, #0x04
	jr	NC, 00114$
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	ld	de, #_names
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	de, #(_dialogue + 18)
	push	de
	call	_strcpy
	add	sp, #4
00114$:
;src/main.c:347: dialogue_stream_begin(&dialogue,0);dialogue_page();
	ld	de, #0x0000
	push	de
	ld	de, #_dialogue
	push	de
	ld	e, #b_dialogue_stream_begin
	ld	hl, #_dialogue_stream_begin
	call	___sdcc_bcall_ehl
	add	sp, #5
	jp	_dialogue_page
00115$:
;src/main.c:348: }
	inc	sp
	ret
___str_5:
	.ascii "TEXT NOT AVAILABLE"
	.db 0x00
;src/main.c:349: void inventory_dialogue_overlay(void) {
;	---------------------------------
; Function inventory_dialogue_overlay
; ---------------------------------
_inventory_dialogue_overlay::
;src/main.c:350: ui_text(1,9,dialogue.lines[0]);ui_text(1,10,dialogue.lines[1]);
	ld	de, #(_dialogue + 50)
	push	de
	ld	hl, #0x901
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #(_dialogue + 69)
	push	de
	ld	hl, #0xa01
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:351: }
	ret
;src/main.c:352: void start_movie_text(uint16_t id) {
;	---------------------------------
; Function start_movie_text
; ---------------------------------
_start_movie_text::
;src/main.c:353: dialogue_open(&dialogue,id);dialogue_stream_begin(&dialogue,0);dialogue_page();screen_state=STATE_MOVIE_TEXT;
	ld	bc, #_dialogue+0
	push	bc
	push	de
	push	bc
	ld	e, #b_dialogue_open
	ld	hl, #_dialogue_open
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	ld	de, #0x0000
	push	de
	push	bc
	ld	e, #b_dialogue_stream_begin
	ld	hl, #_dialogue_stream_begin
	call	___sdcc_bcall_ehl
	add	sp, #4
	call	_dialogue_page
	ld	hl, #_screen_state
	ld	(hl), #0x18
;src/main.c:354: }
	ret
;src/main.c:361: static void service_selection(void) {
;	---------------------------------
; Function service_selection
; ---------------------------------
_service_selection:
;src/main.c:362: service_selector=0;
	xor	a, a
	ld	(#_service_selector),a
;src/main.c:363: if(game_service.action.kind==SERVICE_PARTY) {party_choice=0;party_screen();}
	ld	a, (#(_game_service + 8) + 0)
	cp	a, #0x03
	jr	NZ, 00108$
	xor	a, a
	ld	(#_party_choice),a
	ld	e, #b_party_screen
	ld	hl, #_party_screen
	jp  ___sdcc_bcall_ehl
00108$:
;src/main.c:364: else if(game_service.action.kind==SERVICE_GOODS) {shop_id=game_service.shop;choice=0;shop_screen();}
	cp	a, #0x04
	jr	NZ, 00105$
	ld	a, (#(_game_service + 3) + 0)
	ld	(#_shop_id),a
	xor	a, a
	ld	(#_choice),a
	ld	e, #b_shop_screen
	ld	hl, #_shop_screen
	jp  ___sdcc_bcall_ehl
00105$:
;src/main.c:365: else if(game_service.action.kind==SERVICE_ITEMS) {item_slot=0;replace_source=0;inventory_screen();}
	sub	a, #0x05
	jr	NZ, 00102$
	xor	a, a
	ld	(#_item_slot), a
	ld	(#_replace_source),a
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	jp  ___sdcc_bcall_ehl
00102$:
;src/main.c:367: screen_state=STATE_BUY_SELL;ui_panel(80,8);ui_text(4,1,"BUY");ui_text(12,1,"SELL");
	ld	hl, #_screen_state
	ld	(hl), #0x0e
	ld	hl, #0x850
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	de, #___str_6
	push	de
	ld	hl, #0x104
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_7
	push	de
	ld	hl, #0x10c
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:368: ui_text(choice?10:2,1,">");ui_text(1,6,"A:CHOOSE  B:LEAVE");
	ld	bc, #___str_8+0
	ld	hl, #_choice
	ld	a, (hl)
	or	a, a
	ld	a, #0x0a
	jr	NZ, 00113$
	ld	a, #0x02
00113$:
	push	bc
	ld	h, #0x01
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_9
	push	de
	ld	hl, #0x601
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:370: }
	ret
___str_6:
	.ascii "BUY"
	.db 0x00
___str_7:
	.ascii "SELL"
	.db 0x00
___str_8:
	.ascii ">"
	.db 0x00
___str_9:
	.ascii "A:CHOOSE  B:LEAVE"
	.db 0x00
;src/main.c:371: void apply_service(void) {
;	---------------------------------
; Function apply_service
; ---------------------------------
_apply_service::
	add	sp, #-4
;src/main.c:372: ServiceAction *a=&game_service.action;
;src/main.c:374: service_selector=0;
	xor	a, a
	ld	(#_service_selector),a
;src/main.c:375: while(a->kind==SERVICE_EFFECT||a->kind==SERVICE_WAIT){
	ld	bc, #(_game_service + 8) + 7
00112$:
	ld	hl, #(_game_service + 8)
	ld	l, (hl)
;src/main.c:376: if(a->sound){audio_command(a->sound);a->sound=0;}
	ld	de, #(_game_service + 8) + 8
	ld	a, (de)
	ld	h, a
;src/main.c:375: while(a->kind==SERVICE_EFFECT||a->kind==SERVICE_WAIT){
	ld	a,l
	cp	a,#0x07
	jr	Z, 00113$
	sub	a, #0x08
	jr	NZ, 00114$
00113$:
;src/main.c:376: if(a->sound){audio_command(a->sound);a->sound=0;}
	ld	a, h
	or	a, a
	jr	Z, 00102$
	push	bc
	push	de
	push	hl
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	de
	pop	bc
	xor	a, a
	ld	(de), a
00102$:
;src/main.c:377: if(a->kind==SERVICE_WAIT){
	ld	a, (#(_game_service + 8) + 0)
	sub	a, #0x08
	jr	NZ, 00110$
;src/main.c:378: remaining=a->target;previous=joypad();
	ld	a, (bc)
	ld	l, a
	call	_joypad
	ld	e, a
;src/main.c:379: do {vsync();keys=joypad();if((keys&~previous)&(J_A|J_B))break;previous=keys;}while(!a->target||--remaining);
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
00106$:
	call	_vsync
	push	de
	call	_joypad
	ldhl	sp,	#2
	ld	(hl), a
	pop	de
	ld	a, e
	ld	d, #0x00
	cpl
	ld	e, a
	ld	a, d
	cpl
	ld	d, a
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	and	a, e
	and	a, #0x30
	jr	NZ, 00108$
	ldhl	sp,	#0
	ld	e, (hl)
	ld	a, (bc)
	or	a, a
	jr	Z, 00106$
	ldhl	sp,	#3
	dec	(hl)
	jr	NZ, 00106$
00108$:
;src/main.c:380: last_keys=keys;
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(#_last_keys),a
00110$:
;src/main.c:382: service_advance(&game_service);
	push	bc
	ld	de, #_game_service
	push	de
	ld	e, #b_service_advance
	ld	hl, #_service_advance
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	jr	00112$
00114$:
;src/main.c:384: if(a->sound){audio_command(a->sound);a->sound=0;}
	ld	a, h
	or	a, a
	jr	Z, 00116$
	push	de
	push	hl
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	de
	xor	a, a
	ld	(de), a
00116$:
;src/main.c:385: if(a->kind==SERVICE_DONE) {service_active=0;resume_walk();}
	ld	hl, #(_game_service + 8)
	ld	c, (hl)
	ld	a, c
	or	a,a
	jr	NZ, 00128$
	ld	(#_service_active),a
	call	_resume_walk
	jr	00130$
00128$:
;src/main.c:386: else if(a->kind==SERVICE_INVALID) {service_active=0;notice("SERVICE NOT PORTED",STATE_WALK);}
	ld	a, c
	inc	a
	jr	NZ, 00125$
	xor	a, a
	ld	(#_service_active),a
	ld	a, #0x01
	push	af
	inc	sp
	ld	de, #___str_10
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	jr	00130$
00125$:
;src/main.c:387: else if(a->kind==SERVICE_DIALOGUE||a->kind==SERVICE_YES_NO) show_dialogue(a->dialogue_id);
;src/main.c:388: else if(a->dialogue_id) {service_selector=a->kind;show_dialogue(a->dialogue_id);}
	ld	hl, #(_game_service + 9)
	ld	a, (hl+)
	ld	b, a
	ld	l, (hl)
;src/main.c:387: else if(a->kind==SERVICE_DIALOGUE||a->kind==SERVICE_YES_NO) show_dialogue(a->dialogue_id);
	ld	a, c
	dec	a
	jr	Z, 00120$
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00121$
00120$:
	ld	e, b
	ld	d, l
	call	_show_dialogue
	jr	00130$
00121$:
;src/main.c:388: else if(a->dialogue_id) {service_selector=a->kind;show_dialogue(a->dialogue_id);}
	ld	a, l
	or	a, b
	jr	Z, 00118$
	ld	hl, #_service_selector
	ld	(hl), c
	ld	hl, #(_game_service + 9)
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ld	e, c
	ld	d, a
	call	_show_dialogue
	jr	00130$
00118$:
;src/main.c:389: else {choice=0;service_selection();}
	xor	a, a
	ld	(#_choice),a
	call	_service_selection
00130$:
;src/main.c:390: }
	add	sp, #4
	ret
___str_10:
	.ascii "SERVICE NOT PORTED"
	.db 0x00
;src/main.c:396: static uint8_t check_trigger(void) {
;	---------------------------------
; Function check_trigger
; ---------------------------------
_check_trigger:
	add	sp, #-9
;src/main.c:398: if(!world_check_trigger(player_x,player_y,game_vehicle,&world_action)) {
	ld	de, #_world_action
	push	de
	ld	a, (_game_vehicle)
	push	af
	inc	sp
	ld	a, (_player_y)
	ld	e, a
	ld	hl, #_player_y + 1
	ld	d, (hl)
	push	de
	ld	a, (_player_x)
	ld	e, a
	ld	hl, #_player_x + 1
	ld	d, (hl)
	push	de
	ld	e, #b_world_check_trigger
	ld	hl, #_world_check_trigger
	call	___sdcc_bcall_ehl
	add	sp, #7
	ld	c, a
	or	a, a
	jr	NZ, 00102$
;src/main.c:399: return_x=player_x;return_y=player_y;return 0;
	ld	a, (#_player_x)
	ld	(#_return_x),a
	ld	a, (#_player_x + 1)
	ld	(#_return_x + 1),a
	ld	a, (#_player_y)
	ld	(#_return_y),a
	ld	a, (#_player_y + 1)
	ld	(#_return_y + 1),a
	xor	a, a
	jp	00127$
00102$:
;src/main.c:401: if(world_action.mode==WORLD_ACTION_MAP) {
	ld	a, (#_world_action + 0)
;src/main.c:402: world_decode_destination(&world_action,&x,&y);enter_map(world_action.target,x,y);
;src/main.c:401: if(world_action.mode==WORLD_ACTION_MAP) {
	ldhl	sp,#4
	ld	(hl), a
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00125$
;src/main.c:402: world_decode_destination(&world_action,&x,&y);enter_map(world_action.target,x,y);
	ldhl	sp,	#2
	ld	e, l
	ld	d, h
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	push	de
	push	bc
	ld	de, #_world_action
	push	de
	ld	e, #b_world_decode_destination
	ld	hl, #_world_decode_destination
	call	___sdcc_bcall_ehl
	add	sp, #6
	ld	a, (#(_world_action + 1) + 0)
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_enter_map
	jp	00126$
00125$:
;src/main.c:404: player_x=return_x;player_y=return_y;redraw_world(1);
	ld	a, (#_return_x)
	ldhl	sp,	#5
	ld	(hl), a
	ld	a, (#_return_x + 1)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (#_return_y)
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (#_return_y + 1)
	ldhl	sp,	#8
	ld	(hl), a
;src/main.c:409: show_interaction_scene(scene_context_type,world_action.b,0u);
;src/main.c:411: event_begin(&game_events,scene_context_type,world_action.a,world_action.b,world_map_id);
;src/main.c:403: } else if(world_action.mode==WORLD_ACTION_INTERACTION) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0c
	jp	NZ, 00122$
;src/main.c:404: player_x=return_x;player_y=return_y;redraw_world(1);
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#_player_x),a
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_player_x + 1),a
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(#_player_y),a
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(#_player_y + 1),a
	ld	a, #0x01
	call	_redraw_world
;src/main.c:406: game_events.packed_y=(player_y+WORLD_PIXEL_HEIGHT-112u)%192u;
	ld	a, (_player_y)
	ld	hl, #_player_y + 1
	ld	c, (hl)
	add	a, #0x90
	ld	e, a
	ld	a, c
	adc	a, #0x05
	ld	bc, #0x00c0
	ld	d, a
	call	__moduint
	ld	hl, #(_game_events + 264)
	ld	(hl), c
;src/main.c:407: game_events.camera_x_low=(uint8_t)(player_x-136u);
	ld	a, (_player_x)
	add	a, #0x78
	ld	(#(_game_events + 273)),a
;src/main.c:408: scene_context_type=world_interaction_type(world_group_id,world_action.target);
	ld	a, (#(_world_action + 1) + 0)
	push	af
	inc	sp
	ld	a, (_world_group_id)
	push	af
	inc	sp
	ld	e, #b_world_interaction_type
	ld	hl, #_world_interaction_type
	call	___sdcc_bcall_ehl
	pop	hl
	ld	(#_scene_context_type),a
;src/main.c:409: show_interaction_scene(scene_context_type,world_action.b,0u);
	ld	hl, #(_world_action + 3)
	ld	b, (hl)
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, (_scene_context_type)
	push	af
	inc	sp
	ld	e, #b_show_interaction_scene
	ld	hl, #_show_interaction_scene
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/main.c:411: event_begin(&game_events,scene_context_type,world_action.a,world_action.b,world_map_id);
	ld	hl, #(_world_action + 3)
	ld	b, (hl)
	ld	a, (#(_world_action + 2) + 0)
	ld	hl, #_world_map_id
	ld	h, (hl)
	ld	l, b
	push	hl
	push	af
	inc	sp
	ld	a, (_scene_context_type)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_begin
	ld	hl, #_event_begin
	call	___sdcc_bcall_ehl
	add	sp, #6
;src/main.c:412: if(game_events.prepared_enemy){DISPLAY_OFF;scene_enemy_show(game_events.prepared_enemy,0u);DISPLAY_ON;}
	ld	a, (#(_game_events + 270) + 0)
	ldhl	sp,#8
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	call	_display_off
	ld	hl, #(_game_events + 270)
	ld	b, (hl)
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	e, #b_scene_enemy_show
	ld	hl, #_scene_enemy_show
	call	___sdcc_bcall_ehl
	pop	hl
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
00104$:
;src/main.c:413: apply_event();
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00126$
00122$:
;src/main.c:414: } else if(world_action.mode==WORLD_ACTION_SPECIAL) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x80
	jp	NZ, 00119$
;src/main.c:415: world_special(&game_rpg,world_map_id,world_action.metatile,game_vehicle,game_events.flags[6],&terrain_action);
	ld	hl, #_game_events + 6
	ld	b, (hl)
	ld	hl, #_world_action + 4
	ld	c, (hl)
	ld	de, #_terrain_action
	push	de
	push	bc
	inc	sp
	ld	a, (_game_vehicle)
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	ld	a, (_world_map_id)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_world_special
	ld	hl, #_world_special
	call	___sdcc_bcall_ehl
	add	sp, #8
;src/main.c:416: if(!terrain_action.kind)return 0;
	ld	hl, #_terrain_action
	ld	a, (hl)
	or	a,a
	jp	Z, 00127$
;src/main.c:417: if(terrain_action.rollback) {player_x=return_x;player_y=return_y;redraw_world(1);}
	ld	bc, #_terrain_action + 4
	ld	a, (bc)
	or	a, a
	jr	Z, 00108$
	ld	a, (_return_x)
	ld	(_player_x), a
	ld	a, (_return_x + 1)
	ld	(_player_x + 1), a
	ld	a, (_return_y)
	ld	(_player_y), a
	ld	a, (_return_y + 1)
	ld	(_player_y + 1), a
	push	hl
	ld	a, #0x01
	call	_redraw_world
	pop	hl
00108$:
;src/main.c:418: if(terrain_action.kind==WORLD_RULE_EVENT) {
	ld	c, (hl)
;src/main.c:420: event_begin(&game_events,world_action.flags>>4,terrain_action.target,0,world_map_id);apply_event();
;src/main.c:418: if(terrain_action.kind==WORLD_RULE_EVENT) {
	ld	a, c
	sub	a, #0x0c
	jr	NZ, 00113$
;src/main.c:419: game_events.death_mask=terrain_action.death_mask;
	ld	a, (#(_terrain_action + 5) + 0)
	ld	(#(_game_events + 271)),a
;src/main.c:420: event_begin(&game_events,world_action.flags>>4,terrain_action.target,0,world_map_id);apply_event();
	ld	hl, #(_terrain_action + 1)
	ld	c, (hl)
	ld	a, (#(_world_action + 5) + 0)
	swap	a
	and	a, #0x0f
	ld	b, a
	ld	a, (_world_map_id)
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_begin
	ld	hl, #_event_begin
	call	___sdcc_bcall_ehl
	add	sp, #6
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00126$
00113$:
	ld	hl, #(_terrain_action + 1)
	ld	l, (hl)
;src/main.c:421: } else if(terrain_action.kind==WORLD_RULE_BATTLE) begin_battle(terrain_action.target,0);
	ld	a, c
	sub	a, #0x0e
	jr	NZ, 00110$
	ld	e, a
	ld	a, l
	call	_begin_battle
	jr	00126$
00110$:
;src/main.c:422: else enter_dungeon(terrain_action.target,terrain_action.a,terrain_action.b);
	ld	bc, #_terrain_action + 3
	ld	a, (bc)
	ld	bc, #_terrain_action + 2
	push	af
	ld	a, (bc)
	ld	c, a
	pop	af
	push	af
	inc	sp
	ld	a, c
	push	af
	ld	a, l
	inc	sp
	push	af
	inc	sp
	ld	e, #b_enter_dungeon
	ld	hl, #_enter_dungeon
	call	___sdcc_bcall_ehl
	add	sp, #3
	jr	00126$
00119$:
;src/main.c:424: player_x=return_x;player_y=return_y;redraw_world(1);
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#_player_x),a
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_player_x + 1),a
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(#_player_y),a
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(#_player_y + 1),a
	ld	a, #0x01
	call	_redraw_world
;src/main.c:425: if(world_action.mode==WORLD_ACTION_DUNGEON)enter_dungeon(world_action.target,world_action.a,world_action.b);
	ld	a, (#_world_action + 0)
	sub	a, #0x0a
	jr	NZ, 00116$
	ld	a, (#(_world_action + 3) + 0)
	ld	hl, #(_world_action + 2)
	ld	b, (hl)
	ld	hl, #(_world_action + 1)
	ld	h, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	push	hl
	inc	sp
	ld	e, #b_enter_dungeon
	ld	hl, #_enter_dungeon
	call	___sdcc_bcall_ehl
	add	sp, #3
	jr	00126$
00116$:
;src/main.c:426: else notice("TERRAIN NOT PORTED",STATE_WALK);
	ld	a, #0x01
	push	af
	inc	sp
	ld	de, #___str_11
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
00126$:
;src/main.c:428: return 1;
	ld	a, #0x01
00127$:
;src/main.c:429: }
	add	sp, #9
	ret
___str_11:
	.ascii "TERRAIN NOT PORTED"
	.db 0x00
;src/main.c:430: static void move_player(uint8_t keys) {
;	---------------------------------
; Function move_player
; ---------------------------------
_move_player:
	add	sp, #-7
	ld	c, a
;src/main.c:431: uint8_t enemy,n=game_vehicle?2u:1u,dir,face,mask,held=0;
	ld	a, (#_game_vehicle)
	or	a, a
	ld	a, #0x02
	jr	NZ, 00148$
	ld	a, #0x01
00148$:
	ldhl	sp,	#6
	ld	(hl-), a
	ld	(hl), #0x00
;src/main.c:432: if(keys&J_UP)held|=1u;if(keys&J_DOWN)held|=2u;
	bit	2, c
	jr	Z, 00102$
	ldhl	sp,	#5
	ld	(hl), #0x01
00102$:
	bit	3, c
	jr	Z, 00104$
	ldhl	sp,	#5
	set	1, (hl)
00104$:
;src/main.c:433: if(keys&J_LEFT)held|=4u;if(keys&J_RIGHT)held|=8u;
	bit	1, c
	jr	Z, 00106$
	ldhl	sp,	#5
	set	2, (hl)
00106$:
	bit	0, c
	jr	Z, 00108$
	ldhl	sp,	#5
	set	3, (hl)
00108$:
;src/main.c:434: if(!step_remaining) {
	ld	a, (#_step_remaining)
	or	a, a
	jp	NZ, 00120$
;src/main.c:435: step_dx=0;step_dy=0;
	xor	a, a
	ld	(#_step_dx), a
	ld	(#_step_dy),a
;src/main.c:438: for(dir=0;dir<4u;++dir)if(held&(1u<<dir)) {facing=dir<2u?dir^1u:dir;break;}
	ld	c, #0x00
	ld	e, c
00141$:
	ld	a, e
	push	af
	ld	b, #0x01
	ld	d, #0x00
	pop	af
	inc	a
	jr	00381$
00380$:
	sla	b
	rl	d
00381$:
	dec	a
	jr	NZ,00380$
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	and	a, b
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	or	a, (hl)
	jr	Z, 00142$
	ld	a,c
	cp	a,#0x02
	jr	NC, 00149$
	xor	a, #0x01
	jr	00150$
00149$:
	ld	a, c
00150$:
	ld	(#_facing),a
	jr	00111$
00142$:
	inc	e
	ld	a,e
	ld	c,a
	sub	a, #0x04
	jr	C, 00141$
00111$:
;src/main.c:439: for(dir=0;dir<4u;++dir)if(held&(1u<<dir)) {
	ld	c, #0x00
	ldhl	sp,	#4
	ld	(hl), #0x00
00143$:
	ldhl	sp,	#4
	ld	b, (hl)
	ld	a, #0x01
	ld	d, #0x00
	inc	b
	jr	00383$
00382$:
	add	a, a
	rl	d
00383$:
	dec	b
	jr	NZ,00382$
	dec	hl
	dec	hl
	and	a, (hl)
	ld	e, a
	ld	d, #0x00
	ld	a, d
	or	a, e
	jr	Z, 00144$
;src/main.c:440: face=dir<2u?dir^1u:dir;
	inc	hl
	inc	hl
	ld	a,(hl)
	cp	a,#0x02
	jr	NC, 00151$
	xor	a, #0x01
	ld	b, a
	jr	00152$
00151$:
	ldhl	sp,	#4
	ld	b, (hl)
00152$:
;src/main.c:441: if(world_step_allowed(player_x,player_y,face,game_vehicle)) {
	push	bc
	ld	a, (_game_vehicle)
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, (_player_y)
	ld	e, a
	ld	hl, #_player_y + 1
	ld	d, (hl)
	push	de
	ld	a, (_player_x)
	ld	e, a
	ld	hl, #_player_x + 1
	ld	d, (hl)
	push	de
	ld	e, #b_world_step_allowed
	ld	hl, #_world_step_allowed
	call	___sdcc_bcall_ehl
	add	sp, #6
	pop	bc
	or	a, a
	jr	Z, 00144$
;src/main.c:442: facing=face;step_dx=dir==2u?-1:dir==3u?1:0;
	ld	hl, #_facing
	ld	(hl), b
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00153$
	ld	a, #0xff
	jr	00154$
00153$:
	ld	a, c
	sub	a, #0x03
	ld	a, #0x01
	jr	Z, 00156$
	xor	a, a
00156$:
00154$:
	ld	(#_step_dx),a
;src/main.c:443: step_dy=dir==0u?-1:dir==1u?1:0;step_remaining=16;break;
	ld	a, c
	or	a, a
	jr	NZ, 00157$
	ld	a, #0xff
	jr	00158$
00157$:
	dec	c
	ld	a, #0x01
	jr	Z, 00160$
	xor	a, a
00160$:
00158$:
	ld	(#_step_dy),a
	ld	hl, #_step_remaining
	ld	(hl), #0x10
	jr	00116$
00144$:
;src/main.c:439: for(dir=0;dir<4u;++dir)if(held&(1u<<dir)) {
	ldhl	sp,	#4
	inc	(hl)
	ld	a,(hl)
	ld	c,a
	sub	a, #0x04
	jp	C, 00143$
00116$:
;src/main.c:446: if(world_ice_changed){audio_command(0xb7);redraw_world(1);}
	ld	a, (#_world_ice_changed)
	or	a, a
	jr	Z, 00120$
	ld	a, #0xb7
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x01
	call	_redraw_world
00120$:
;src/main.c:448: if(step_remaining) {
	ld	a, (#_step_remaining)
	or	a, a
	jp	Z, 00139$
;src/main.c:449: mask=1u<<(facing<2u?facing^1u:facing);
	ld	a, (#_facing)
	cp	a,#0x02
	jr	NC, 00161$
	xor	a, #0x01
	ld	c, a
	jr	00162$
00161$:
	ld	a, (_facing)
	ld	c, a
00162$:
	ldhl	sp,	#4
	ld	(hl), #0x01
	inc	c
	jr	00391$
00390$:
	ldhl	sp,	#4
	sla	(hl)
00391$:
	dec	c
	jr	NZ,00390$
;src/main.c:450: while(n--) {
00126$:
	ldhl	sp,	#6
	ld	c, (hl)
	dec	(hl)
	ld	a, c
	or	a, a
	jr	Z, 00128$
;src/main.c:451: player_x=(player_x+step_dx)&2047u;
	ld	a, (_step_dx)
	ld	c, a
	rlca
	sbc	a, a
	ld	b, a
	ld	a, (_player_x)
	ld	l, a
	ld	a, (_player_x + 1)
	ld	h, a
	add	hl, bc
	ld	c, l
	ld	a, h
	and	a, #0x07
	ld	hl, #_player_x
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/main.c:452: if(step_dy<0) player_y=player_y?player_y-1u:WORLD_PIXEL_HEIGHT-1u;
	ld	a, (_player_y)
	ld	c, a
	ld	hl, #_player_y + 1
	ld	b, (hl)
	ld	a, (#_step_dy)
	bit	7, a
	jr	Z, 00124$
	ld	hl, #_player_y + 1
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00163$
	ld	e, c
	ld	d, b
	dec	de
	jr	00164$
00163$:
	ld	de, #0x05ff
00164$:
	ld	hl, #_player_y
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	jr	00125$
00124$:
;src/main.c:453: else if(step_dy>0) player_y=(player_y+1u)%WORLD_PIXEL_HEIGHT;
	ld	hl, #_step_dy
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00392$
	bit	7, d
	jr	NZ, 00393$
	cp	a, a
	jr	00393$
00392$:
	bit	7, d
	jr	Z, 00393$
	scf
00393$:
	jr	NC, 00125$
	ld	e, c
	ld	d, b
	inc	de
	ld	bc, #0x0600
	call	__moduint
	ld	hl, #_player_y
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00125$:
;src/main.c:454: --step_remaining;
	ld	hl, #_step_remaining
	dec	(hl)
	jr	00126$
00128$:
;src/main.c:456: if(!game_vehicle)party_world_tick(mask,step_remaining,held);
	ld	a, (#_game_vehicle)
	or	a, a
	jr	NZ, 00130$
	ldhl	sp,	#5
	ld	a, (hl-)
	push	af
	inc	sp
	ld	a, (_step_remaining)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_party_world_tick
	ld	hl, #_party_world_tick
	call	___sdcc_bcall_ehl
	add	sp, #3
00130$:
;src/main.c:457: redraw_world(0);
	xor	a, a
	call	_redraw_world
;src/main.c:458: if(!step_remaining && !check_trigger()) {
	ld	a, (#_step_remaining)
	or	a, a
	jp	NZ, 00145$
	call	_check_trigger
	or	a, a
	jp	NZ, 00145$
;src/main.c:460: world_meta_at((player_x-8u)&2047u,(player_y+1536u-16u)%1536u),game_vehicle);
	ld	a, (_player_y)
	ld	hl, #_player_y + 1
	ld	c, (hl)
	add	a, #0xf0
	ld	e, a
	ld	a, c
	adc	a, #0x05
	ld	bc, #0x0600
	ld	d, a
	call	__moduint
	ld	a, (_player_x)
	ld	hl, #_player_x + 1
	ld	e, (hl)
	add	a, #0xf8
	ld	l, a
	ld	a, e
	adc	a, #0xff
	and	a, #0x07
	ld	h, a
	push	bc
	push	hl
	ld	e, #b_world_meta_at
	ld	hl, #_world_meta_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	b, a
;src/main.c:459: enemy=rpg_world_encounter(&game_rpg,world_group_id,player_x,player_y,
	ld	a, (_game_vehicle)
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, (_player_y)
	ld	e, a
	ld	hl, #_player_y + 1
	ld	d, (hl)
	push	de
	ld	a, (_player_x)
	ld	e, a
	ld	hl, #_player_x + 1
	ld	d, (hl)
	push	de
	ld	a, (_world_group_id)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_world_encounter
	ld	hl, #_rpg_world_encounter
	call	___sdcc_bcall_ehl
	add	sp, #9
	ld	c, a
;src/main.c:461: if(enemy) begin_battle(enemy,0);
	or	a, a
	jr	Z, 00145$
	ld	e, #0x00
	ld	a, c
	call	_begin_battle
	jr	00145$
00139$:
;src/main.c:465: audio_command(0xd6);
	ld	a, #0xd6
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/main.c:466: if(!game_vehicle)party_world_tick(0,0,held);
	ld	a, (#_game_vehicle)
	or	a, a
	jr	NZ, 00137$
	ldhl	sp,	#5
	ld	a, (hl)
	push	af
	inc	sp
	xor	a, a
	rrca
	push	af
	xor	a, a
	ld	e, #b_party_world_tick
	ld	hl, #_party_world_tick
	call	___sdcc_bcall_ehl
	add	sp, #3
00137$:
;src/main.c:467: draw_player();
	call	_draw_player
00145$:
;src/main.c:469: }
	add	sp, #7
	ret
;src/main.c:470: static void return_from_notice(void) {
;	---------------------------------
; Function return_from_notice
; ---------------------------------
_return_from_notice:
;src/main.c:471: if(notice_return==STATE_SHOP) shop_screen();
	ld	a, (#_notice_return)
	sub	a, #0x06
	jr	NZ, 00114$
	ld	e, #b_shop_screen
	ld	hl, #_shop_screen
	jp  ___sdcc_bcall_ehl
00114$:
;src/main.c:472: else if(notice_return==STATE_INVENTORY) inventory_screen();
	ld	a, (#_notice_return)
	sub	a, #0x09
	jr	NZ, 00111$
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	jp  ___sdcc_bcall_ehl
00111$:
;src/main.c:473: else if(notice_return==STATE_MENU) menu_screen();
	ld	a, (#_notice_return)
	sub	a, #0x02
	jr	NZ, 00108$
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	jp  ___sdcc_bcall_ehl
00108$:
;src/main.c:474: else if(notice_return==STATE_PARTY) party_screen();
	ld	a, (#_notice_return)
	sub	a, #0x0b
	jr	NZ, 00105$
	ld	e, #b_party_screen
	ld	hl, #_party_screen
	jp  ___sdcc_bcall_ehl
00105$:
;src/main.c:475: else if(notice_return==STATE_TITLE) title_screen();
	ld	a, (#_notice_return)
	or	a, a
	jp	NZ, _resume_walk
	ld	e, #b_title_screen
	ld	hl, #_title_screen
;src/main.c:476: else resume_walk();
;src/main.c:477: }
	jp  ___sdcc_bcall_ehl
;src/main.c:478: void main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	add	sp, #-28
;src/main.c:480: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/main.c:481: cpu_fast(); /* CGB-only cartridge: VBlank-driven gameplay keeps its timing. */
	call	_cpu_fast
;src/main.c:482: audio_install();
	call	_audio_install
;src/main.c:483: VBK_REG=1;set_bkg_data(0,64,ui_font);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_ui_font
	push	de
	ld	hl, #0x4000
	push	hl
	call	_set_bkg_data
	add	sp, #4
;src/main.c:484: SWITCH_ROM(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);set_sprite_palette(0,ALIS_PALETTE_COUNT,alis_palettes);
	ld	a, #0x03
	ldh	(__current_bank + 0), a
	ld	hl, #_rROMB0
	ld	(hl), #0x03
	ld	de, #_alis_tiles
	push	de
	ld	hl, #0x5400
	push	hl
	call	_set_sprite_data
	add	sp, #4
	ld	de, #_alis_palettes
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/main.c:485: SWITCH_ROM(1);VBK_REG=0;SPRITES_8x8;set_bkg_palette(7,1,ui_palette);
	ld	a, #0x01
	ldh	(__current_bank + 0), a
	ld	hl, #_rROMB0
	ld	(hl), #0x01
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
	ld	de, #_ui_palette
	push	de
	ld	hl, #0x107
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/main.c:486: rpg_new_game(&game_rpg);event_init(&game_events,&game_rpg);
	ld	bc, #_game_rpg
	push	bc
	push	bc
	ld	e, #b_rpg_new_game
	ld	hl, #_rpg_new_game
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	push	bc
	ld	de, #_game_events
	push	de
	ld	e, #b_event_init
	ld	hl, #_event_init
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:487: world_select(WORLD_START_MAP);world_load_graphics();
	ld	a, #0x04
	push	af
	inc	sp
	ld	e, #b_world_select
	ld	hl, #_world_select
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, #b_world_load_graphics
	ld	hl, #_world_load_graphics
	call	___sdcc_bcall_ehl
;src/main.c:488: player_x=WORLD_START_X;player_y=WORLD_START_Y;party_world_reset(0);redraw_world(1);save_ui_scan();
	ld	hl, #_player_x
	ld	a, #0x98
	ld	(hl+), a
	ld	(hl), #0x06
	ld	hl, #_player_y
	ld	a, #0x30
	ld	(hl+), a
	ld	(hl), #0x01
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_party_world_reset
	ld	hl, #_party_world_reset
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x01
	call	_redraw_world
	ld	e, #b_save_ui_scan
	ld	hl, #_save_ui_scan
	call	___sdcc_bcall_ehl
;src/main.c:489: title_choice=saved_position_valid?1u:0u;SHOW_BKG;title_screen();DISPLAY_ON;
	ld	a, (#_saved_position_valid)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00536$
	xor	a, a
00536$:
	ld	(#_title_choice),a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
	ld	e, #b_title_screen
	ld	hl, #_title_screen
	call	___sdcc_bcall_ehl
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/main.c:490: while(1) {
00527$:
;src/main.c:491: vsync();++frame_counter;keys=joypad();pressed=keys&~last_keys;
	call	_vsync
	ld	hl, #_frame_counter
	inc	(hl)
	jr	NZ, 01890$
	inc	hl
	inc	(hl)
01890$:
	call	_joypad
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (#_last_keys)
	cpl
	ld	c, a
	ldhl	sp,	#0
	ld	a, (hl+)
	and	a, c
	ld	(hl), a
;src/main.c:493: if(!(screen_state==STATE_BATTLE&&battle_view_text_revealing)&&
	ld	a, (#_screen_state)
	sub	a, #0x0f
	ld	a, #0x01
	jr	Z, 01892$
	xor	a, a
01892$:
	ldhl	sp,	#2
	ld	(hl), a
;src/main.c:494: (!dialogue_revealing||(screen_state!=STATE_DIALOGUE&&screen_state!=STATE_CUTSCENE&&screen_state!=STATE_MOVIE_TEXT)))last_keys=keys;
	ld	a, (#_screen_state)
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 01894$
	xor	a, a
01894$:
	ldhl	sp,	#27
	ld	(hl), a
	ld	a, (#_screen_state)
	sub	a, #0x12
	ld	a, #0x01
	jr	Z, 01896$
	xor	a, a
01896$:
	ldhl	sp,	#3
	ld	(hl), a
	ld	a, (#_screen_state)
	sub	a, #0x18
	ld	a, #0x01
	jr	Z, 01898$
	xor	a, a
01898$:
	ldhl	sp,	#4
;src/main.c:493: if(!(screen_state==STATE_BATTLE&&battle_view_text_revealing)&&
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	ld	a, (#_battle_view_text_revealing)
	or	a, a
	jr	NZ, 00102$
00107$:
;src/main.c:494: (!dialogue_revealing||(screen_state!=STATE_DIALOGUE&&screen_state!=STATE_CUTSCENE&&screen_state!=STATE_MOVIE_TEXT)))last_keys=keys;
	ld	a, (#_dialogue_revealing)
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#27
	bit	0, (hl)
	jr	NZ, 00102$
	ldhl	sp,	#3
	bit	0, (hl)
	jr	NZ, 00102$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00102$
00101$:
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(#_last_keys),a
00102$:
;src/main.c:496: if((pressed&(J_UP|J_DOWN))&&saved_position_valid) {title_choice^=1;title_screen();}
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x0c
	ldhl	sp,	#5
	ld	(hl+), a
	ld	(hl), #0x00
;src/main.c:495: if(screen_state==STATE_TITLE) {
	ld	a, (#_screen_state)
;src/main.c:496: if((pressed&(J_UP|J_DOWN))&&saved_position_valid) {title_choice^=1;title_screen();}
	or	a, a
	jr	NZ, 00524$
	ldhl	sp,	#5
	or	a, (hl)
	jr	Z, 00109$
	ld	a, (#_saved_position_valid)
	or	a, a
	jr	Z, 00109$
	ld	hl, #_title_choice
	ld	a, (hl)
	xor	a, #0x01
	ld	(hl), a
	ld	e, #b_title_screen
	ld	hl, #_title_screen
	call	___sdcc_bcall_ehl
00109$:
;src/main.c:497: if(pressed&(J_START|J_A)) {
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x90
	jp	Z, 00527$
;src/main.c:498: if(title_choice&&saved_position_valid)save_ui_open(SAVE_UI_LOAD,STATE_TITLE);
	ld	a, (#_title_choice)
	or	a, a
	jr	Z, 00112$
	ld	a, (#_saved_position_valid)
	or	a, a
	jr	Z, 00112$
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x02
	push	af
	inc	sp
	ld	e, #b_save_ui_open
	ld	hl, #_save_ui_open
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00112$:
;src/main.c:499: else start_game(0);
	xor	a, a
	call	_start_game
	jp	00527$
00524$:
;src/main.c:501: } else if(screen_state==STATE_WALK) {
	ld	a, (#_screen_state)
	dec	a
	jp	NZ, 00521$
;src/main.c:502: deferred_buttons|=pressed&(J_START|J_SELECT);
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0xc0
	ldhl	sp,	#27
	ld	(hl), a
	ld	a, (#_deferred_buttons)
	ldhl	sp,	#26
	ld	(hl), a
	ld	a, (hl+)
	or	a, (hl)
	ld	(#_deferred_buttons),a
;src/main.c:503: vehicle_cycle_world_tick(game_vehicle,step_remaining);
	ld	a, (_step_remaining)
	ld	h, a
	ld	a, (_game_vehicle)
	ld	l, a
	push	hl
	ld	e, #b_vehicle_cycle_world_tick
	ld	hl, #_vehicle_cycle_world_tick
	call	___sdcc_bcall_ehl
	pop	hl
;src/main.c:504: world_motion_step();
	ld	e, #b_world_motion_step
	ld	hl, #_world_motion_step
	call	___sdcc_bcall_ehl
;src/main.c:505: move_player(keys);
	ldhl	sp,	#0
	ld	a, (hl)
	call	_move_player
;src/main.c:508: if(screen_state==STATE_WALK&&!step_remaining) {
	ld	a, (#_screen_state)
	dec	a
	jp	NZ, 00527$
	ld	a, (#_step_remaining)
	or	a, a
	jp	NZ, 00527$
;src/main.c:509: if(deferred_buttons&J_SELECT) {deferred_buttons=0;notice(write_save()?"GAME SAVED":"SAVE FAILED",STATE_WALK);}
	ld	a, (_deferred_buttons)
	bit	6, a
	jr	Z, 00120$
	xor	a, a
	ld	(#_deferred_buttons),a
	call	_write_save
	or	a, a
	jr	Z, 00537$
	ld	de, #___str_12+0
	jr	00538$
00537$:
	ld	de, #___str_13+0
00538$:
	ld	a, #0x01
	push	af
	inc	sp
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00527$
00120$:
;src/main.c:510: else if((keys|deferred_buttons)&(J_A|J_B|J_START)) {
	ldhl	sp,	#0
	ld	a, (hl)
	ld	hl, #_deferred_buttons
	or	a, (hl)
	and	a, #0xb0
	jp	Z, 00527$
;src/main.c:511: deferred_buttons=0;
	xor	a, a
	ld	(#_deferred_buttons),a
;src/main.c:514: game_events.type=battle_scene_world_type(world_group_id,
;src/main.c:515: world_flags_at((player_x-8u)&2047u,(player_y+1536u-16u)%1536u));
	ld	a, (_player_y)
	ld	hl, #_player_y + 1
	ld	c, (hl)
	add	a, #0xf0
	ld	e, a
	ld	a, c
	adc	a, #0x05
	ld	d, a
	ld	bc, #0x0600
	call	__moduint
	ld	a, (_player_x)
	ld	hl, #_player_x + 1
	ld	d, (hl)
	add	a, #0xf8
	ld	e, a
	ld	a, d
	adc	a, #0xff
	and	a, #0x07
	push	bc
	ld	d, a
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:514: game_events.type=battle_scene_world_type(world_group_id,
	push	af
	inc	sp
	ld	a, (_world_group_id)
	push	af
	inc	sp
	ld	e, #b_battle_scene_world_type
	ld	hl, #_battle_scene_world_type
	call	___sdcc_bcall_ehl
	pop	hl
	ld	b, a
	ld	hl, #(_game_events + 261)
	ld	(hl), b
;src/main.c:516: show_interaction_scene(game_events.type,0u,0u);menu_choice=0;menu_screen();
	xor	a, a
	rrca
	push	af
	xor	a, a
	push	bc
	inc	sp
	ld	e, #b_show_interaction_scene
	ld	hl, #_show_interaction_scene
	call	___sdcc_bcall_ehl
	add	sp, #3
	xor	a, a
	ld	(#_menu_choice),a
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00521$:
;src/main.c:486: rpg_new_game(&game_rpg);event_init(&game_events,&game_rpg);
;src/main.c:521: else if(pressed&J_UP) {menu_choice=menu_choice?menu_choice-1u:7u;menu_screen();}
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x04
	ldhl	sp,	#7
	ld	(hl+), a
	ld	(hl), #0x00
;src/main.c:522: else if(pressed&J_DOWN) {menu_choice=menu_choice<7u?menu_choice+1u:0u;menu_screen();}
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x08
	ldhl	sp,	#9
	ld	(hl+), a
	ld	(hl), #0x00
;src/main.c:523: else if(pressed&J_A) {
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x10
	ldhl	sp,	#11
	ld	(hl+), a
	ld	(hl), #0x00
;src/main.c:519: } else if(screen_state==STATE_MENU) {
	ld	a, (#_screen_state)
	sub	a, #0x02
	jp	NZ, 00518$
;src/main.c:520: if(pressed&(J_B|J_START)) resume_walk();
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0xa0
	jr	Z, 00158$
	call	_resume_walk
	jp	00527$
00158$:
;src/main.c:521: else if(pressed&J_UP) {menu_choice=menu_choice?menu_choice-1u:7u;menu_screen();}
	xor	a, a
	ldhl	sp,	#7
	or	a, (hl)
	jr	Z, 00155$
	ld	hl, #_menu_choice
	ld	a, (hl)
	or	a, a
	jr	Z, 00539$
	ld	a, (hl)
	dec	a
	jr	00540$
00539$:
	ld	a, #0x07
00540$:
	ld	(#_menu_choice),a
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00155$:
;src/main.c:522: else if(pressed&J_DOWN) {menu_choice=menu_choice<7u?menu_choice+1u:0u;menu_screen();}
	xor	a, a
	ldhl	sp,	#9
	or	a, (hl)
	jr	Z, 00152$
	ld	hl, #_menu_choice
	ld	a, (hl)
	sub	a, #0x07
	jr	NC, 00541$
	ld	a, (hl)
	inc	a
	jr	00542$
00541$:
	xor	a, a
00542$:
	ld	(#_menu_choice),a
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00152$:
;src/main.c:523: else if(pressed&J_A) {
	xor	a, a
	ldhl	sp,	#11
	or	a, (hl)
	jp	Z, 00527$
;src/main.c:524: if(menu_choice==0) resume_walk();else if(menu_choice==1) status_screen();
	ld	a, (#_menu_choice)
	or	a, a
	jr	NZ, 00147$
	call	_resume_walk
	jp	00527$
00147$:
	ld	a, (#_menu_choice)
	dec	a
	jr	NZ, 00144$
	ld	e, #b_status_screen
	ld	hl, #_status_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00144$:
;src/main.c:525: else if(menu_choice==2) {item_slot=0;replace_source=0;party_purpose=0;inventory_screen();}
	ld	a, (#_menu_choice)
	sub	a, #0x02
	jr	NZ, 00141$
	xor	a, a
	ld	(#_item_slot), a
	ld	(#_replace_source),a
	xor	a, a
	ld	(#_party_purpose),a
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00141$:
;src/main.c:526: else if(menu_choice==3) {
	ld	a, (#_menu_choice)
	sub	a, #0x03
	jr	NZ, 00138$
;src/main.c:527: if(battle_view_chest_pending){battle_view_chest_prompt(1);screen_state=STATE_BATTLE;}
	ld	a, (#_battle_view_chest_pending)
	or	a, a
	jr	Z, 00126$
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_battle_view_chest_prompt
	ld	hl, #_battle_view_chest_prompt
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_screen_state
	ld	(hl), #0x0f
	jp	00527$
00126$:
;src/main.c:528: else {event_search(&game_events,world_map_id,((player_x-8u)&2047u)>>4,((player_y+1536u-16u)%1536u)>>4);apply_event();}
	ld	a, (_player_y)
	ld	hl, #_player_y + 1
	ld	c, (hl)
	add	a, #0xf0
	ld	e, a
	ld	a, c
	adc	a, #0x05
	ld	bc, #0x0600
	ld	d, a
	call	__moduint
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, h
	ld	a, (_player_x)
	ld	hl, #_player_x + 1
	ld	b, (hl)
	add	a, #0xf8
	ld	l, a
	ld	a, b
	adc	a, #0xff
	and	a, #0x07
	ld	h, a
	xor	a, a
	add	hl, hl
	rla
	add	hl, hl
	rla
	add	hl, hl
	rla
	add	hl, hl
	rla
	ld	b, a
	ld	a, c
	push	af
	inc	sp
	push	hl
	inc	sp
	ld	a, (_world_map_id)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_search
	ld	hl, #_event_search
	call	___sdcc_bcall_ehl
	add	sp, #5
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00138$:
;src/main.c:529: } else if(menu_choice==4) save_ui_open(SAVE_UI_SAVE,STATE_MENU);
	ld	a, (#_menu_choice)
	sub	a, #0x04
	jr	NZ, 00135$
	ld	a, #0x02
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_save_ui_open
	ld	hl, #_save_ui_open
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00135$:
;src/main.c:530: else if(menu_choice==5) {title_choice=saved_position_valid?1u:0u;title_screen();}
	ld	a, (#_menu_choice)
	sub	a, #0x05
	jr	NZ, 00132$
	ld	a, (#_saved_position_valid)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00544$
	xor	a, a
00544$:
	ld	(#_title_choice),a
	ld	e, #b_title_screen
	ld	hl, #_title_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00132$:
;src/main.c:531: else if(menu_choice==6u)help_screen();
	ld	a, (#_menu_choice)
	sub	a, #0x06
	jr	NZ, 00129$
	ld	e, #b_help_screen
	ld	hl, #_help_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00129$:
;src/main.c:532: else {party_choice=0;party_purpose=PARTY_MAGIC_CASTER;party_screen();}
	xor	a, a
	ld	(#_party_choice),a
	ld	hl, #_party_purpose
	ld	(hl), #0x80
	ld	e, #b_party_screen
	ld	hl, #_party_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00518$:
;src/main.c:535: if(pressed&(J_A|J_B))inventory_equipment_done();
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x30
	ldhl	sp,	#13
	ld	(hl+), a
	ld	(hl), #0x00
;src/main.c:534: } else if(screen_state==STATE_EQUIPMENT_PANEL) {
	ld	a, (#_screen_state)
	sub	a, #0x1e
	jr	NZ, 00515$
;src/main.c:535: if(pressed&(J_A|J_B))inventory_equipment_done();
	xor	a, a
	ldhl	sp,	#13
	or	a, (hl)
	jp	Z, 00527$
	ld	e, #b_inventory_equipment_done
	ld	hl, #_inventory_equipment_done
	call	___sdcc_bcall_ehl
	jp	00527$
00515$:
;src/main.c:536: } else if(screen_state==STATE_HELP||screen_state==STATE_STATUS) {
	ld	a, (#_screen_state)
	sub	a, #0x03
	jr	Z, 00510$
	ld	a, (#_screen_state)
	sub	a, #0x0d
	jr	NZ, 00511$
00510$:
;src/main.c:537: if(pressed&(J_A|J_B|J_START)) menu_screen();
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0xb0
	jp	Z, 00527$
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00511$:
;src/main.c:538: } else if(screen_state==STATE_NOTICE) {
	ld	a, (#_screen_state)
	sub	a, #0x08
	jr	NZ, 00508$
;src/main.c:539: if(pressed&(J_A|J_B)) return_from_notice();
	xor	a, a
	ldhl	sp,	#13
	or	a, (hl)
	jp	Z, 00527$
	call	_return_from_notice
	jp	00527$
00508$:
;src/main.c:541: if(dialogue_tick(0,pressed&(J_A|J_B))) {
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x30
	ldhl	sp,	#15
	ld	(hl), a
;src/main.c:540: } else if(screen_state==STATE_DIALOGUE) {
	ldhl	sp,	#27
	ld	a, (hl)
	or	a, a
	jp	Z, 00505$
;src/main.c:541: if(dialogue_tick(0,pressed&(J_A|J_B))) {
	ldhl	sp,	#15
	ld	e, (hl)
	xor	a, a
	call	_dialogue_tick
	ld	c, a
	or	a, a
	jp	Z, 00527$
;src/main.c:542: if(!dialogue.done) dialogue_page();
	ld	a, (#(_dialogue + 12) + 0)
	or	a, a
	jr	NZ, 00189$
	call	_dialogue_page
	jp	00527$
00189$:
;src/main.c:543: else if(field_active==2u)inventory_action_advance();
	ld	a, (#_field_active)
	sub	a, #0x02
	jr	NZ, 00186$
	ld	e, #b_inventory_action_advance
	ld	hl, #_inventory_action_advance
	call	___sdcc_bcall_ehl
	jp	00527$
00186$:
;src/main.c:544: else if(field_active)game_field_advance();
	ld	a, (#_field_active)
	or	a, a
	jr	Z, 00183$
	ld	e, #b_game_field_advance
	ld	hl, #_game_field_advance
	call	___sdcc_bcall_ehl
	jp	00527$
00183$:
;src/main.c:545: else if(service_active) {
	ld	a, (#_service_active)
	or	a, a
	jr	Z, 00180$
;src/main.c:546: if(service_selector) service_selection();
	ld	a, (#_service_selector)
	or	a, a
	jr	Z, 00170$
	call	_service_selection
	jp	00527$
00170$:
;src/main.c:547: else if(game_service.action.kind==SERVICE_YES_NO) {choice=0;prompt_screen();}
	ld	a, (#(_game_service + 8) + 0)
	sub	a, #0x02
	jr	NZ, 00167$
	xor	a, a
	ld	(#_choice),a
	ld	e, #b_prompt_screen
	ld	hl, #_prompt_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00167$:
;src/main.c:548: else {service_advance(&game_service);apply_service();}
	ld	de, #_game_service
	push	de
	ld	e, #b_service_advance
	ld	hl, #_service_advance
	call	___sdcc_bcall_ehl
	pop	hl
	call	_apply_service
	jp	00527$
00180$:
;src/main.c:550: else if(dark_menu_pending&&game_events.action.kind==EVENT_MENU) {menu_choice=0;menu_screen();}
	ld	hl, #_game_events + 282
	ld	c, (hl)
	ld	a, (#_dark_menu_pending)
	or	a, a
	jr	Z, 00176$
	ld	a, c
	sub	a, #0x0a
	jr	NZ, 00176$
	xor	a, a
	ld	(#_menu_choice),a
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00176$:
;src/main.c:551: else if(game_events.action.kind==EVENT_YES_NO) {choice=0;prompt_screen();}
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00173$
	xor	a, a
	ld	(#_choice),a
	ld	e, #b_prompt_screen
	ld	hl, #_prompt_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00173$:
;src/main.c:552: else {event_advance(&game_events);apply_event();}
	ld	de, #_game_events
	push	de
	ld	e, #b_event_advance
	ld	hl, #_event_advance
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00505$:
;src/main.c:555: if(pressed&(J_LEFT|J_UP))choice^=1;
	ld	a, (#_choice)
	xor	a, #0x01
	ldhl	sp,	#16
	ld	(hl), a
;src/main.c:557: if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN))prompt_screen();
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x0f
	ldhl	sp,	#17
	ld	(hl+), a
	ld	(hl), #0x00
;src/main.c:554: } else if(screen_state==STATE_PROMPT) {
	ld	a, (#_screen_state)
	sub	a, #0x05
	jr	NZ, 00502$
;src/main.c:555: if(pressed&(J_LEFT|J_UP))choice^=1;
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x06
	jr	Z, 00194$
	ldhl	sp,	#16
	ld	a, (hl)
	ld	(#_choice),a
00194$:
;src/main.c:556: if(pressed&(J_RIGHT|J_DOWN))choice^=1;
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x09
	jr	Z, 00196$
	ld	hl, #_choice
	ld	a, (hl)
	xor	a, #0x01
	ld	(hl), a
00196$:
;src/main.c:557: if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN))prompt_screen();
	xor	a, a
	ldhl	sp,	#17
	or	a, (hl)
	jr	Z, 00198$
	ld	e, #b_prompt_screen
	ld	hl, #_prompt_screen
	call	___sdcc_bcall_ehl
00198$:
;src/main.c:560: if(pressed&(J_A|J_B)) {
	xor	a, a
	ldhl	sp,	#13
	or	a, (hl)
	jp	Z, 00527$
;src/main.c:561: if(service_active) {service_respond(&game_service,!choice);apply_service();}
	ld	a, (#_choice)
	sub	a, #0x01
	ld	a, #0x00
	rla
	ldhl	sp,	#27
	ld	(hl), a
	ld	a, (#_service_active)
	or	a, a
	jr	Z, 00200$
	ldhl	sp,	#27
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_service
	push	de
	ld	e, #b_service_respond
	ld	hl, #_service_respond
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_apply_service
	jp	00527$
00200$:
;src/main.c:562: else {event_respond(&game_events,!choice);apply_event();}
	ldhl	sp,	#27
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_respond
	ld	hl, #_event_respond
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00502$:
;src/main.c:565: if(pressed&J_B) {service_select(&game_service,255);apply_service();}
	ldhl	sp,	#1
	ld	a, (hl)
	and	a, #0x20
	ldhl	sp,	#19
	ld	(hl+), a
	ld	(hl), #0x00
;src/main.c:566: else if(pressed&J_UP) {choice=choice?choice-1u:shop_count-1u;shop_screen();}
	ld	a, (#_choice)
	dec	a
	ldhl	sp,	#21
	ld	(hl), a
;src/main.c:567: else if(pressed&J_DOWN) {choice=(choice+1u)%shop_count;shop_screen();}
	ld	a, (#_choice)
	ldhl	sp,	#22
	ld	(hl), a
	ld	a, (hl+)
	ld	c, a
	ld	b, #0x00
	inc	bc
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/main.c:564: } else if(screen_state==STATE_SHOP) {
	ld	a, (#_screen_state)
	sub	a, #0x06
	jp	NZ, 00499$
;src/main.c:565: if(pressed&J_B) {service_select(&game_service,255);apply_service();}
	xor	a, a
	ldhl	sp,	#19
	or	a, (hl)
	jr	Z, 00213$
	ld	a, #0xff
	push	af
	inc	sp
	ld	de, #_game_service
	push	de
	ld	e, #b_service_select
	ld	hl, #_service_select
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_apply_service
	jp	00527$
00213$:
;src/main.c:566: else if(pressed&J_UP) {choice=choice?choice-1u:shop_count-1u;shop_screen();}
	xor	a, a
	ldhl	sp,	#7
	or	a, (hl)
	jr	Z, 00210$
	ld	a, (#_choice)
	or	a, a
	jr	Z, 00545$
	ldhl	sp,	#21
	ld	a, (hl)
	jr	00546$
00545$:
	ld	a, (#_shop_count)
	dec	a
00546$:
	ld	(#_choice),a
	ld	e, #b_shop_screen
	ld	hl, #_shop_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00210$:
;src/main.c:567: else if(pressed&J_DOWN) {choice=(choice+1u)%shop_count;shop_screen();}
	xor	a, a
	ldhl	sp,	#9
	or	a, (hl)
	jr	Z, 00207$
	ld	a, (_shop_count)
	ld	b, #0x00
	ld	c, a
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__moduint
	ld	hl, #_choice
	ld	(hl), c
	ld	e, #b_shop_screen
	ld	hl, #_shop_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00207$:
;src/main.c:568: else if(pressed&J_A) {service_select(&game_service,choice);apply_service();}
	xor	a, a
	ldhl	sp,	#11
	or	a, (hl)
	jp	Z, 00527$
	ld	a, (_choice)
	push	af
	inc	sp
	ld	de, #_game_service
	push	de
	ld	e, #b_service_select
	ld	hl, #_service_select
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_apply_service
	jp	00527$
00499$:
;src/main.c:486: rpg_new_game(&game_rpg);event_init(&game_events,&game_rpg);
;src/main.c:569: } else if(screen_state==STATE_BUY) {
	ld	a, (#_screen_state)
	sub	a, #0x0c
	jr	NZ, 00496$
;src/main.c:570: if(pressed&J_B) shop_screen();
	xor	a, a
	ldhl	sp,	#19
	or	a, (hl)
	jr	Z, 00222$
	ld	e, #b_shop_screen
	ld	hl, #_shop_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00222$:
;src/main.c:571: else if(pressed&J_A) {
	xor	a, a
	ldhl	sp,	#11
	or	a, (hl)
	jp	Z, 00527$
;src/main.c:572: if(shop_id==8u&&choice==2u) {event_buy_secret(&game_events,shop_id,choice);apply_event();}
	ld	a, (#_shop_id)
	sub	a, #0x08
	jr	NZ, 00216$
	ld	a, (#_choice)
	sub	a, #0x02
	jr	NZ, 00216$
	ld	a, (_choice)
	ld	h, a
	ld	a, (_shop_id)
	ld	l, a
	push	hl
	ld	de, #_game_events
	push	de
	ld	e, #b_event_buy_secret
	ld	hl, #_event_buy_secret
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00216$:
;src/main.c:573: else {code=rpg_buy(&game_rpg,shop_id,choice);result(code,code==RPG_FULL?STATE_WALK:STATE_SHOP);}
	ld	a, (_choice)
	ld	h, a
	ld	a, (_shop_id)
	ld	l, a
	push	hl
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_buy
	ld	hl, #_rpg_buy
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	c, a
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00548$
	ld	a, #0x06
00548$:
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	ld	e, #b_result
	ld	hl, #_result
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00496$:
;src/main.c:582: else if(pressed&J_DOWN) {item_slot=(item_slot+1u)%game_rpg.inventory_count;inventory_screen();}
	ld	a, (_item_slot)
	ld	c, a
;src/main.c:587: else if(game_vehicle&&game_rpg.inventory[item_slot]==32u+game_vehicle/4u)game_field_item(item_slot,0);
	ld	de, #(_game_rpg + 64)
	ld	l, c
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#27
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#26
	ld	(hl), a
;src/main.c:575: } else if(screen_state==STATE_INVENTORY||screen_state==STATE_REPLACE) {
	ld	a, (#_screen_state)
	sub	a, #0x09
	jr	Z, 00491$
	ld	a, (#_screen_state)
	sub	a, #0x07
	jp	NZ, 00492$
00491$:
;src/main.c:579: else if(party_purpose==EVENT_SELL) resume_walk();else menu_screen();
	ld	a, (#_party_purpose)
	sub	a, #0x06
	ld	a, #0x01
	jr	Z, 01955$
	xor	a, a
01955$:
	ld	b, a
;src/main.c:576: if(pressed&J_B) {
	xor	a, a
	ldhl	sp,	#19
	or	a, (hl)
	jr	Z, 00257$
;src/main.c:577: if(service_active) {service_select(&game_service,255);apply_service();}
	ld	a, (#_service_active)
	or	a, a
	jr	Z, 00231$
	ld	a, #0xff
	push	af
	inc	sp
	ld	de, #_game_service
	push	de
	ld	e, #b_service_select
	ld	hl, #_service_select
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_apply_service
	jp	00527$
00231$:
;src/main.c:578: else if(replace_source) {replace_source=0;event_replace_item(&game_events,255);apply_event();}
	ld	hl, #_replace_source
	ld	a, (hl)
	or	a, a
	jr	Z, 00228$
	ld	(hl), #0x00
	ld	a, #0xff
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_replace_item
	ld	hl, #_event_replace_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00228$:
;src/main.c:579: else if(party_purpose==EVENT_SELL) resume_walk();else menu_screen();
	ld	a, b
	or	a, a
	jr	Z, 00225$
	call	_resume_walk
	jp	00527$
00225$:
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00257$:
;src/main.c:580: } else if(game_rpg.inventory_count) {
	ld	a, (#(_game_rpg + 88) + 0)
	ldhl	sp,#27
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jp	Z, 00527$
;src/main.c:581: if(pressed&J_UP) {item_slot=item_slot?item_slot-1u:game_rpg.inventory_count-1u;inventory_screen();}
	xor	a, a
	ldhl	sp,	#7
	or	a, (hl)
	jr	Z, 00252$
	ld	hl, #_item_slot
	ld	a, (hl)
	or	a, a
	jr	Z, 00549$
	ld	a, (hl)
	dec	a
	jr	00550$
00549$:
	ldhl	sp,	#27
	ld	a, (hl)
	dec	a
00550$:
	ld	(#_item_slot),a
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00252$:
;src/main.c:582: else if(pressed&J_DOWN) {item_slot=(item_slot+1u)%game_rpg.inventory_count;inventory_screen();}
	xor	a, a
	ldhl	sp,	#9
	or	a, (hl)
	jr	Z, 00249$
	xor	a, a
	ld	e, c
	ld	d, a
	inc	de
	ldhl	sp,	#27
	ld	c, (hl)
	xor	a, a
	ld	b, a
	call	__moduint
	ld	hl, #_item_slot
	ld	(hl), c
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00249$:
;src/main.c:583: else if(pressed&J_A) {
	xor	a, a
	ldhl	sp,	#11
	or	a, (hl)
	jp	Z, 00527$
;src/main.c:584: if(service_active) {service_select(&game_service,item_slot);apply_service();}
	ld	a, (#_service_active)
	or	a, a
	jr	Z, 00244$
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	de, #_game_service
	push	de
	ld	e, #b_service_select
	ld	hl, #_service_select
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_apply_service
	jp	00527$
00244$:
;src/main.c:585: else if(replace_source) {replace_source=0;event_replace_item(&game_events,item_slot);apply_event();}
	ld	hl, #_replace_source
	ld	a, (hl)
	or	a, a
	jr	Z, 00241$
	ld	(hl), #0x00
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_replace_item
	ld	hl, #_event_replace_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00241$:
;src/main.c:586: else if(party_purpose==EVENT_SELL) result(rpg_sell(&game_rpg,item_slot),STATE_INVENTORY);
	ld	a, b
	or	a, a
	jr	Z, 00238$
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_sell
	ld	hl, #_rpg_sell
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	h, #0x09
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_result
	ld	hl, #_result
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00238$:
;src/main.c:587: else if(game_vehicle&&game_rpg.inventory[item_slot]==32u+game_vehicle/4u)game_field_item(item_slot,0);
	ld	hl, #_game_vehicle
	ld	a, (hl)
	or	a, a
	jr	Z, 00234$
	ld	c, (hl)
	ld	b, #0x00
	srl	b
	rr	c
	srl	b
	rr	c
	ld	hl, #0x0020
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#25
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	e, a
	ld	d, #0x00
	ld	a, e
	sub	a, c
	jr	NZ, 00234$
	ld	a, d
	sub	a, b
	jr	NZ, 00234$
	xor	a, a
	push	af
	inc	sp
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	e, #b_game_field_item
	ld	hl, #_game_field_item
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00234$:
;src/main.c:588: else {item_action=0;item_screen();}
	xor	a, a
	ld	(#_item_action),a
	ld	e, #b_item_screen
	ld	hl, #_item_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00492$:
;src/main.c:597: else if(item_action==1u){party_purpose=0;inventory_equip_begin(item_slot);}
	ld	a, (#_item_action)
	dec	a
	ld	a, #0x01
	jr	Z, 01959$
	xor	a, a
01959$:
	ldhl	sp,	#27
	ld	(hl), a
;src/main.c:591: } else if(screen_state==STATE_ITEM) {
	ld	a, (#_screen_state)
	sub	a, #0x0a
	jp	NZ, 00489$
;src/main.c:592: if(pressed&J_B) inventory_screen();
	xor	a, a
	ldhl	sp,	#19
	or	a, (hl)
	jr	Z, 00281$
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00281$:
;src/main.c:593: else if(pressed&J_UP) {item_action=item_action?item_action-1u:2u;item_screen();}
	xor	a, a
	ldhl	sp,	#7
	or	a, (hl)
	jr	Z, 00278$
	ld	hl, #_item_action
	ld	a, (hl)
	or	a, a
	jr	Z, 00551$
	ld	a, (hl)
	dec	a
	jr	00552$
00551$:
	ld	a, #0x02
00552$:
	ld	(#_item_action),a
	ld	e, #b_item_screen
	ld	hl, #_item_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00278$:
;src/main.c:594: else if(pressed&J_DOWN) {item_action=(item_action+1u)%3u;item_screen();}
	xor	a, a
	ldhl	sp,	#9
	or	a, (hl)
	jr	Z, 00275$
	ld	a, (_item_action)
	ld	d, #0x00
	ld	e, a
	inc	de
	ld	bc, #0x0003
	call	__moduint
	ld	hl, #_item_action
	ld	(hl), c
	ld	e, #b_item_screen
	ld	hl, #_item_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00275$:
;src/main.c:595: else if(pressed&J_A) {
	xor	a, a
	ldhl	sp,	#11
	or	a, (hl)
	jp	Z, 00527$
;src/main.c:596: if(item_action==2u) inventory_drop_begin(item_slot);
	ld	a, (#_item_action)
	sub	a, #0x02
	jr	NZ, 00270$
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	e, #b_inventory_drop_begin
	ld	hl, #_inventory_drop_begin
	call	___sdcc_bcall_ehl
	inc	sp
	jp	00527$
00270$:
;src/main.c:597: else if(item_action==1u){party_purpose=0;inventory_equip_begin(item_slot);}
	ldhl	sp,	#27
	ld	a, (hl)
	or	a, a
	jr	Z, 00267$
	xor	a, a
	ld	(#_party_purpose),a
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	e, #b_inventory_equip_begin
	ld	hl, #_inventory_equip_begin
	call	___sdcc_bcall_ehl
	inc	sp
	jp	00527$
00267$:
;src/main.c:587: else if(game_vehicle&&game_rpg.inventory[item_slot]==32u+game_vehicle/4u)game_field_item(item_slot,0);
	ldhl	sp,#25
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
;src/main.c:598: else if(game_rpg.inventory[item_slot]==ItemID_Cola||game_rpg.inventory[item_slot]==ItemID_Burger) {
	cp	a, #0x24
	jr	Z, 00262$
	sub	a, #0x25
	jr	NZ, 00665$
00262$:
;src/main.c:599: party_choice=0;party_purpose=PARTY_FIELD_ITEM;party_screen();
	xor	a, a
	ld	(#_party_choice),a
	ld	hl, #_party_purpose
	ld	(hl), #0x82
	ld	e, #b_party_screen
	ld	hl, #_party_screen
	call	___sdcc_bcall_ehl
	jp	00527$
;src/main.c:601: for(i=0;i<4u;++i)if(game_rpg.party[i].status&1u)break;
00665$:
	ldhl	sp,	#27
	ld	(hl), #0x00
00529$:
	ldhl	sp,	#27
	ld	a, (hl-)
	swap	a
	and	a, #0xf0
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #_game_rpg
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#27
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#26
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	rrca
	jr	C, 00261$
	ldhl	sp,	#27
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00529$
00261$:
;src/main.c:602: game_field_item(item_slot,i);
	ldhl	sp,	#27
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	e, #b_game_field_item
	ld	hl, #_game_field_item
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00489$:
;src/main.c:605: } else if(screen_state==STATE_PARTY) {
	ld	a, (#_screen_state)
	sub	a, #0x0b
	jp	NZ, 00486$
;src/main.c:543: else if(field_active==2u)inventory_action_advance();
	ld	a, (#_field_active)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 01972$
	xor	a, a
01972$:
	ldhl	sp,	#23
	ld	(hl), a
;src/main.c:609: else if(party_purpose==PARTY_MAGIC_TARGET)game_field_spell(magic_caster,selected_field_spell,255);
	ld	a, (#_party_purpose)
	sub	a, #0x81
	ld	a, #0x01
	jr	Z, 01974$
	xor	a, a
01974$:
	ldhl	sp,	#24
	ld	(hl), a
;src/main.c:610: else if(party_purpose==PARTY_MAGIC_CASTER)menu_screen();
	ld	a, (#_party_purpose)
	sub	a, #0x80
	ld	a, #0x01
	jr	Z, 01976$
	xor	a, a
01976$:
	ldhl	sp,	#25
	ld	(hl), a
;src/main.c:611: else if(party_purpose==PARTY_FIELD_ITEM)game_field_item(item_slot,255);
	ld	a, (#_party_purpose)
	sub	a, #0x82
	ld	a, #0x01
	jr	Z, 01978$
	xor	a, a
01978$:
	ldhl	sp,	#26
	ld	(hl), a
;src/main.c:606: if(pressed&J_B) {
	xor	a, a
	ldhl	sp,	#19
	or	a, (hl)
	jp	Z, 00348$
;src/main.c:607: if(service_active) {service_select(&game_service,255);apply_service();}
	ld	a, (#_service_active)
	or	a, a
	jr	Z, 00299$
	ld	a, #0xff
	push	af
	inc	sp
	ld	de, #_game_service
	push	de
	ld	e, #b_service_select
	ld	hl, #_service_select
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_apply_service
	jp	00527$
00299$:
;src/main.c:608: else if(field_active==2u)inventory_equip_select(255u);
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00296$
	ld	a, #0xff
	push	af
	inc	sp
	ld	e, #b_inventory_equip_select
	ld	hl, #_inventory_equip_select
	call	___sdcc_bcall_ehl
	inc	sp
	jp	00527$
00296$:
;src/main.c:609: else if(party_purpose==PARTY_MAGIC_TARGET)game_field_spell(magic_caster,selected_field_spell,255);
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	Z, 00293$
	ld	a, #0xff
	push	af
	inc	sp
	ld	a, (_selected_field_spell)
	ld	h, a
	ld	a, (_magic_caster)
	ld	l, a
	push	hl
	ld	e, #b_game_field_spell
	ld	hl, #_game_field_spell
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00527$
00293$:
;src/main.c:610: else if(party_purpose==PARTY_MAGIC_CASTER)menu_screen();
	ldhl	sp,	#25
	ld	a, (hl)
	or	a, a
	jr	Z, 00290$
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00290$:
;src/main.c:611: else if(party_purpose==PARTY_FIELD_ITEM)game_field_item(item_slot,255);
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00287$
	ld	a, #0xff
	push	af
	inc	sp
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	e, #b_game_field_item
	ld	hl, #_game_field_item
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00287$:
;src/main.c:612: else if(party_purpose) resume_walk();else inventory_screen();
	ld	a, (#_party_purpose)
	or	a, a
	jr	Z, 00284$
	call	_resume_walk
	jp	00527$
00284$:
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00348$:
;src/main.c:614: else if(pressed&(J_UP|J_DOWN)) {
	xor	a, a
	ldhl	sp,	#5
	or	a, (hl)
	jr	Z, 00345$
;src/main.c:615: for(i=0;i<4u;++i) {party_choice=(party_choice+((pressed&J_UP)?3u:1u))&3u;if(game_rpg.joined_mask&(1u<<party_choice)) break;}
	inc	hl
	inc	hl
	ld	c, (hl)
	ldhl	sp,	#27
	ld	(hl), #0x00
00531$:
	ld	a, c
	or	a, a
	ld	a, #0x03
	jr	NZ, 00554$
	ld	a, #0x01
00554$:
	ld	hl, #_party_choice
	add	a, (hl)
	and	a, #0x03
	ld	(hl), a
	ld	a, (#(_game_rpg + 89) + 0)
	ld	b, (hl)
	ld	de, #0x0001
	inc	b
	jr	01980$
01979$:
	sla	e
	rl	d
01980$:
	dec	b
	jr	NZ,01979$
	and	a, e
	ld	b, #0x00
	or	a, b
	jr	NZ, 00303$
	ldhl	sp,	#27
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00531$
00303$:
;src/main.c:616: party_screen();
	ld	e, #b_party_screen
	ld	hl, #_party_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00345$:
;src/main.c:617: } else if(pressed&J_A) {
	xor	a, a
	ldhl	sp,	#11
	or	a, (hl)
	jp	Z, 00527$
;src/main.c:618: if(service_active) {service_select(&game_service,party_choice);apply_service();continue;}
	ld	a, (#_service_active)
	or	a, a
	jr	Z, 00305$
	ld	a, (_party_choice)
	push	af
	inc	sp
	ld	de, #_game_service
	push	de
	ld	e, #b_service_select
	ld	hl, #_service_select
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_apply_service
	jp	00527$
00305$:
;src/main.c:619: if(field_active==2u){inventory_equip_select(party_choice);continue;}
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	Z, 00307$
	ld	a, (_party_choice)
	push	af
	inc	sp
	ld	e, #b_inventory_equip_select
	ld	hl, #_inventory_equip_select
	call	___sdcc_bcall_ehl
	inc	sp
	jp	00527$
00307$:
;src/main.c:620: if(party_purpose==PARTY_MAGIC_CASTER) {
	ldhl	sp,	#25
	ld	a, (hl)
	or	a, a
	jr	Z, 00313$
;src/main.c:621: magic_caster=party_choice;magic_choice=0;
	ld	a, (#_party_choice)
	ld	(#_magic_caster),a
	xor	a, a
	ld	(#_magic_choice),a
;src/main.c:622: if(!(game_rpg.party[magic_caster].status&1u)||!rpg_spell_option(&game_rpg,magic_caster,0,0))
	ld	a, (#_magic_caster)
	swap	a
	and	a, #0xf0
	ldhl	sp,	#27
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #_game_rpg
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#28
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#27
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	rrca
	jr	NC, 00308$
	xor	a, a
	rrca
	push	af
	xor	a, a
	ld	a, (_magic_caster)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_spell_option
	ld	hl, #_rpg_spell_option
	call	___sdcc_bcall_ehl
	add	sp, #5
	or	a, a
	jr	NZ, 00309$
00308$:
;src/main.c:623: game_field_spell(magic_caster,0,255);
	ld	a, #0xff
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, (_magic_caster)
	push	af
	inc	sp
	ld	e, #b_game_field_spell
	ld	hl, #_game_field_spell
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00527$
00309$:
;src/main.c:624: else map_magic_screen();
	ld	e, #b_map_magic_screen
	ld	hl, #_map_magic_screen
	call	___sdcc_bcall_ehl
;src/main.c:625: continue;
	jp	00527$
00313$:
;src/main.c:627: if(party_purpose==PARTY_MAGIC_TARGET){game_field_spell(magic_caster,selected_field_spell,party_choice);continue;}
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	Z, 00315$
	ld	a, (_party_choice)
	ld	h, a
	ld	a, (_selected_field_spell)
	ld	l, a
	push	hl
	ld	a, (_magic_caster)
	push	af
	inc	sp
	ld	e, #b_game_field_spell
	ld	hl, #_game_field_spell
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00527$
00315$:
;src/main.c:628: if(party_purpose==PARTY_FIELD_ITEM){game_field_item(item_slot,party_choice);continue;}
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00317$
	ld	a, (_party_choice)
	ld	h, a
	ld	a, (_item_slot)
	ld	l, a
	push	hl
	ld	e, #b_game_field_item
	ld	hl, #_game_field_item
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00317$:
;src/main.c:629: if(party_purpose==EVENT_HOSPITAL) code=rpg_hospital(&game_rpg,party_choice);
	ld	a, (#_party_purpose)
	sub	a, #0x04
	jr	NZ, 00340$
	ld	a, (_party_choice)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_hospital
	ld	hl, #_rpg_hospital
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#26
	ld	(hl), a
	jp	00341$
00340$:
;src/main.c:630: else if(party_purpose==EVENT_CHURCH) code=rpg_revive(&game_rpg,party_choice);
	ld	a, (#_party_purpose)
	sub	a, #0x05
	jr	NZ, 00337$
	ld	a, (_party_choice)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_revive
	ld	hl, #_rpg_revive
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#26
	ld	(hl), a
	jp	00341$
00337$:
;src/main.c:631: else if(item_action==1u) code=rpg_equip(&game_rpg,item_slot,party_choice);
	ldhl	sp,	#27
	ld	a, (hl)
	or	a, a
	jr	Z, 00334$
	ld	a, (_party_choice)
	ld	h, a
	ld	a, (_item_slot)
	ld	l, a
	push	hl
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_equip
	ld	hl, #_rpg_equip
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#26
	ld	(hl), a
	jp	00341$
00334$:
;src/main.c:633: code=rpg_use_item(&game_rpg,item_slot,party_choice);
	ld	a, (_party_choice)
	ld	h, a
	ld	a, (_item_slot)
	ld	l, a
	push	hl
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_use_item
	ld	hl, #_rpg_use_item
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/main.c:634: if(code==RPG_NOT_IMPLEMENTED) {
	ldhl	sp,#26
	ld	(hl), a
	ld	a, (hl)
	sub	a, #0x08
	jp	NZ, 00341$
;src/main.c:635: uint8_t item=game_rpg.inventory[item_slot];
	ld	a, (#_item_slot)
	ldhl	sp,	#27
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #(_game_rpg + 64)
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#28
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#27
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
;src/main.c:636: if(game_dungeon.active&&item==ItemID_Flash&&!game_dungeon.dungeon.light) {
	ld	a, (#(_game_dungeon + 264) + 0)
;src/main.c:638: dungeon_refresh_light(&game_dungeon.dungeon);resume_walk();continue;
;src/main.c:636: if(game_dungeon.active&&item==ItemID_Flash&&!game_dungeon.dungeon.light) {
	ldhl	sp,#26
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00319$
	inc	hl
	ld	a, (hl)
	sub	a, #0x27
	jr	NZ, 00319$
	ld	a, (#(_game_dungeon + 3) + 0)
	or	a, a
	jr	NZ, 00319$
;src/main.c:637: rpg_remove_item(&game_rpg,item_slot);game_dungeon.dungeon.light=255;
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	hl, #(_game_dungeon + 3)
	ld	(hl), #0xff
;src/main.c:638: dungeon_refresh_light(&game_dungeon.dungeon);resume_walk();continue;
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dungeon_refresh_light
	ld	hl, #_dungeon_refresh_light
	call	___sdcc_bcall_ehl
	pop	hl
	call	_resume_walk
	jp	00527$
00319$:
;src/main.c:640: if(game_dungeon.active&&(item==ItemID_DungeonKey||item==ItemID_MiracleKey)) {
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00328$
	inc	hl
	ld	a, (hl)
	sub	a, #0x3e
	ld	a, #0x01
	jr	Z, 01991$
	xor	a, a
01991$:
	ldhl	sp,	#25
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	sub	a, #0x2d
	jr	Z, 00327$
	ldhl	sp,	#25
	ld	a, (hl)
	or	a, a
	jr	Z, 00328$
00327$:
;src/main.c:641: uint8_t pos=dungeon_sample_position(&game_dungeon.dungeon,1);
	ld	a, #0x01
	push	af
	inc	sp
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/main.c:642: uint8_t door=game_dungeon.dungeon.layout[pos]&7u;
	ldhl	sp,#27
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #(_game_dungeon + 8)
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#28
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#27
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b, a
	and	a, #0x07
;src/main.c:643: if((door==5u||(item==ItemID_MiracleKey&&door==6u))&&!(game_dungeon.dungeon.layout[pos]&128u)) {
	ld	c, a
	sub	a, #0x05
	jr	Z, 00326$
	dec	hl
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00328$
	ld	a, c
	sub	a, #0x06
	jr	NZ, 00328$
00326$:
	bit	7, b
	jr	NZ, 00328$
;src/main.c:644: game_dungeon.dungeon.layout[pos]|=128u;dplay_show_opening(&game_dungeon,door-2u);resume_walk();continue;
	set	7, b
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), b
	dec	c
	dec	c
	ld	a, c
	push	af
	inc	sp
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_show_opening
	ld	hl, #_dplay_show_opening
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_resume_walk
	jp	00527$
00328$:
;src/main.c:647: event_use_story_item(&game_events,item_slot,0);apply_event();continue;
	xor	a, a
	push	af
	inc	sp
	ld	a, (_item_slot)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_use_story_item
	ld	hl, #_event_use_story_item
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00341$:
;src/main.c:650: result(code,party_purpose?STATE_PARTY:STATE_INVENTORY);
	ld	a, (#_party_purpose)
	or	a, a
	jr	Z, 00555$
	ldhl	sp,	#27
	ld	(hl), #0x0b
	jr	00556$
00555$:
	ldhl	sp,	#27
	ld	(hl), #0x09
00556$:
	ldhl	sp,	#27
	ld	a, (hl-)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_result
	ld	hl, #_result
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00486$:
;src/main.c:654: else if(pressed&(J_A|J_B)) {service_select(&game_service,(pressed&J_B)?255u:choice);apply_service();}
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#27
	ld	(hl), a
;src/main.c:652: } else if(screen_state==STATE_BUY_SELL) {
	ld	a, (#_screen_state)
	sub	a, #0x0e
	jr	NZ, 00483$
;src/main.c:653: if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN)) {choice^=1;service_selection();}
	xor	a, a
	ldhl	sp,	#17
	or	a, (hl)
	jr	Z, 00353$
	dec	hl
	ld	a, (hl)
	ld	(#_choice),a
	call	_service_selection
	jp	00527$
00353$:
;src/main.c:654: else if(pressed&(J_A|J_B)) {service_select(&game_service,(pressed&J_B)?255u:choice);apply_service();}
	xor	a, a
	ldhl	sp,	#13
	or	a, (hl)
	jp	Z, 00527$
	xor	a, a
	ldhl	sp,	#19
	or	a, (hl)
	jr	Z, 00557$
	ldhl	sp,	#27
	ld	(hl), #0xff
00557$:
	ldhl	sp,	#27
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_service
	push	de
	ld	e, #b_service_select
	ld	hl, #_service_select
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_apply_service
	jp	00527$
00483$:
;src/main.c:655: } else if(screen_state==STATE_BATTLE) {
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jp	Z, 00480$
;src/main.c:656: code=battle_view_tick(keys,pressed);
	dec	hl
	ld	a, (hl-)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_battle_view_tick
	ld	hl, #_battle_view_tick
	call	___sdcc_bcall_ehl
	pop	hl
;src/main.c:657: if(code) {
	ldhl	sp,#26
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jp	Z, 00527$
;src/main.c:662: else if(!battle_from_event)game_events.flags[0]=255;
;src/main.c:658: if(code==BATTLE_VIEW_MENU){
	ld	a, (hl)
	sub	a, #0xfe
	jr	NZ, 00366$
;src/main.c:659: if(battle_view_battle.chest_state==BATTLE_CHEST_OPEN) {
	ld	a, (#(_battle_view_battle + 162) + 0)
	sub	a, #0x02
	jr	NZ, 00364$
;src/main.c:660: if(battle_from_event==1u)game_events.flags[game_events.battle.flag_index]=255;
	ld	a, (#_battle_from_event)
	dec	a
	jr	NZ, 00361$
	ld	a, (#(_game_events + 277) + 0)
	ld	l, a
	ld	h, #0x00
	ld	de, #_game_events
	add	hl, de
	ld	(hl), #0xff
	jr	00364$
00361$:
;src/main.c:661: else if(battle_from_event==2u)dplay_mark_object(&game_events,battle_object_flag);
	ld	a, (#_battle_from_event)
	sub	a, #0x02
	jr	NZ, 00358$
	ld	a, (_battle_object_flag)
	ld	e, a
	ld	hl, #_battle_object_flag + 1
	ld	d, (hl)
	push	de
	ld	de, #_game_events
	push	de
	ld	e, #b_dplay_mark_object
	ld	hl, #_dplay_mark_object
	call	___sdcc_bcall_ehl
	add	sp, #4
	jr	00364$
00358$:
;src/main.c:662: else if(!battle_from_event)game_events.flags[0]=255;
	ld	a, (#_battle_from_event)
	or	a, a
	jr	NZ, 00364$
	ld	hl, #_game_events
	ld	(hl), #0xff
00364$:
;src/main.c:664: menu_choice=0;menu_screen();continue;
	xor	a, a
	ld	(#_menu_choice),a
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00366$:
;src/main.c:666: game_dungeon.retained_trap=retained_trap;
	ld	de, #(_game_dungeon + 274)
	ld	a, (_retained_trap)
	ld	(de), a
;src/main.c:667: if(battle_from_event==3u)game_movie_battle_done(code);
	ld	a, (#_battle_from_event)
	sub	a, #0x03
	jr	NZ, 00386$
	ldhl	sp,	#26
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_game_movie_battle_done
	ld	hl, #_game_movie_battle_done
	call	___sdcc_bcall_ehl
	inc	sp
	jp	00527$
00386$:
;src/main.c:668: else if(battle_from_event==1u) {
	ld	a, (#_battle_from_event)
	dec	a
	jr	NZ, 00383$
;src/main.c:669: event_battle_result(&game_events,code,battle_view_battle.chest_state==BATTLE_CHEST_OPEN);apply_event();
	ld	a, (#(_battle_view_battle + 162) + 0)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 02013$
	xor	a, a
02013$:
	push	af
	inc	sp
	ldhl	sp,	#27
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_battle_result
	ld	hl, #_event_battle_result
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00383$:
;src/main.c:573: else {code=rpg_buy(&game_rpg,shop_id,choice);result(code,code==RPG_FULL?STATE_WALK:STATE_SHOP);}
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 02015$
	xor	a, a
02015$:
	ldhl	sp,	#27
	ld	(hl), a
;src/main.c:670: } else if(battle_from_event==2u) {
	ld	a, (#_battle_from_event)
	sub	a, #0x02
	jp	NZ, 00380$
;src/main.c:671: if(battle_view_battle.chest_state==BATTLE_CHEST_OPEN)dplay_mark_object(&game_events,battle_object_flag);
	ld	a, (#(_battle_view_battle + 162) + 0)
	sub	a, #0x02
	jr	NZ, 00368$
	ld	a, (_battle_object_flag)
	ld	e, a
	ld	hl, #_battle_object_flag + 1
	ld	d, (hl)
	push	de
	ld	de, #_game_events
	push	de
	ld	e, #b_dplay_mark_object
	ld	hl, #_dplay_mark_object
	call	___sdcc_bcall_ehl
	add	sp, #4
00368$:
;src/main.c:672: if(code==RPG_DEFEAT){title_choice=saved_position_valid?1u:0u;notice("GAME OVER",STATE_TITLE);}
	ldhl	sp,	#27
	ld	a, (hl)
	or	a, a
	jr	Z, 00373$
	ld	a, (#_saved_position_valid)
	or	a, a
	jr	Z, 00559$
	ldhl	sp,	#27
	ld	(hl), #0x01
	jr	00560$
00559$:
	ldhl	sp,	#27
	ld	(hl), #0x00
00560$:
	ldhl	sp,	#27
	ld	a, (hl)
	ld	(#_title_choice),a
	xor	a, a
	push	af
	inc	sp
	ld	de, #___str_14
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00527$
00373$:
;src/main.c:673: else if(code==RPG_ESCAPED){dplay_escape(&game_dungeon,&game_rpg,&game_events);apply_dungeon();}
	ld	bc, #_game_dungeon
	ldhl	sp,	#26
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00370$
	ld	de, #_game_events
	push	de
	ld	de, #_game_rpg
	push	de
	push	bc
	ld	e, #b_dplay_escape
	ld	hl, #_dplay_escape
	call	___sdcc_bcall_ehl
	add	sp, #6
	ld	e, #b_apply_dungeon
	ld	hl, #_apply_dungeon
	call	___sdcc_bcall_ehl
	jp	00527$
00370$:
;src/main.c:674: else {dplay_resume(&game_dungeon,&game_rpg,&game_events);apply_dungeon();}
	ld	de, #_game_events
	push	de
	ld	de, #_game_rpg
	push	de
	push	bc
	ld	e, #b_dplay_resume
	ld	hl, #_dplay_resume
	call	___sdcc_bcall_ehl
	add	sp, #6
	ld	e, #b_apply_dungeon
	ld	hl, #_apply_dungeon
	call	___sdcc_bcall_ehl
	jp	00527$
00380$:
;src/main.c:676: if(battle_view_battle.chest_state==BATTLE_CHEST_OPEN)game_events.flags[0]=255;
	ld	a, (#(_battle_view_battle + 162) + 0)
	sub	a, #0x02
	jr	NZ, 00376$
	ld	hl, #_game_events
	ld	(hl), #0xff
00376$:
;src/main.c:677: resume_walk();
	call	_resume_walk
;src/main.c:678: if(code==RPG_DEFEAT) {title_choice=saved_position_valid?1u:0u;notice("GAME OVER",STATE_TITLE);}
	ldhl	sp,	#27
	ld	a, (hl)
	or	a, a
	jp	Z, 00527$
	ld	a, (#_saved_position_valid)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00562$
	xor	a, a
00562$:
	ld	(#_title_choice),a
	xor	a, a
	push	af
	inc	sp
	ld	de, #___str_14
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00527$
00480$:
;src/main.c:681: } else if(screen_state==STATE_TRAVEL_MENU) {
	ld	a, (#_screen_state)
	sub	a, #0x10
	jr	NZ, 00477$
;src/main.c:682: if(pressed&J_UP){choice=choice?choice-1u:2u;travel_menu();}
	xor	a, a
	ldhl	sp,	#7
	or	a, (hl)
	jr	Z, 00396$
	ld	a, (#_choice)
	or	a, a
	jr	Z, 00563$
	ldhl	sp,	#21
	ld	a, (hl)
	jr	00564$
00563$:
	ld	a, #0x02
00564$:
	ld	(#_choice),a
	ld	e, #b_travel_menu
	ld	hl, #_travel_menu
	call	___sdcc_bcall_ehl
	jp	00527$
00396$:
;src/main.c:683: else if(pressed&J_DOWN){choice=(choice+1u)%3u;travel_menu();}
	xor	a, a
	ldhl	sp,	#9
	or	a, (hl)
	jr	Z, 00393$
	ld	bc, #0x0003
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__moduint
	ld	hl, #_choice
	ld	(hl), c
	ld	e, #b_travel_menu
	ld	hl, #_travel_menu
	call	___sdcc_bcall_ehl
	jp	00527$
00393$:
;src/main.c:684: else if(pressed&(J_A|J_B)){event_choose_destination(&game_events,(pressed&J_B)?255u:choice);apply_event();}
	xor	a, a
	ldhl	sp,	#13
	or	a, (hl)
	jp	Z, 00527$
	xor	a, a
	ldhl	sp,	#19
	or	a, (hl)
	jr	Z, 00565$
	ld	b, #0xff
	jr	00566$
00565$:
	ldhl	sp,	#27
	ld	b, (hl)
00566$:
	push	bc
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_choose_destination
	ld	hl, #_event_choose_destination
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00527$
00477$:
;src/main.c:685: } else if(screen_state==STATE_CUTSCENE) {
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00474$
;src/main.c:686: if(dialogue_tick(1,pressed&(J_A|J_B))) {
	ldhl	sp,	#15
	ld	e, (hl)
	ld	a, #0x01
	call	_dialogue_tick
	or	a, a
	jp	Z, 00527$
;src/main.c:687: if(!dialogue.done)story_page();
	ld	a, (#(_dialogue + 12) + 0)
	or	a, a
	jr	NZ, 00399$
	call	_story_page
	jp	00527$
00399$:
;src/main.c:688: else {cutscene_advance(&game_cutscene);show_cutscene_record();}
	ld	de, #_game_cutscene
	push	de
	ld	e, #b_cutscene_advance
	ld	hl, #_cutscene_advance
	call	___sdcc_bcall_ehl
	pop	hl
	call	_show_cutscene_record
	jp	00527$
00474$:
;src/main.c:690: } else if(screen_state==STATE_MOVIE) {
	ld	a, (#_screen_state)
	sub	a, #0x17
	jr	NZ, 00471$
;src/main.c:691: game_movie_tick(keys);
	ldhl	sp,	#0
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_game_movie_tick
	ld	hl, #_game_movie_tick
	call	___sdcc_bcall_ehl
	inc	sp
	jp	00527$
00471$:
;src/main.c:692: } else if(screen_state==STATE_MOVIE_TEXT) {
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00468$
;src/main.c:693: if(dialogue_tick(0,pressed&(J_A|J_B))) {
	ldhl	sp,	#15
	ld	e, (hl)
	xor	a, a
	call	_dialogue_tick
	ld	c, a
	or	a, a
	jp	Z, 00527$
;src/main.c:694: if(!dialogue.done){dialogue_page();screen_state=STATE_MOVIE_TEXT;}
	ld	a, (#(_dialogue + 12) + 0)
	ldhl	sp,#27
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	NZ, 00404$
	call	_dialogue_page
	ld	hl, #_screen_state
	ld	(hl), #0x18
	jp	00527$
00404$:
;src/main.c:695: else game_movie_text_done();
	ld	e, #b_game_movie_text_done
	ld	hl, #_game_movie_text_done
	call	___sdcc_bcall_ehl
	jp	00527$
00468$:
;src/main.c:697: } else if(screen_state==STATE_MAP_MAGIC) {
	ld	a, (#_screen_state)
	sub	a, #0x13
	jp	NZ, 00465$
;src/main.c:698: code=0;while(code<5u&&rpg_spell_option(&game_rpg,magic_caster,code,0))++code;
	ldhl	sp,	#27
	ld	(hl), #0x00
00409$:
	ldhl	sp,	#27
	ld	a, (hl)
	sub	a, #0x05
	jr	NC, 00411$
	xor	a, a
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, (_magic_caster)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_spell_option
	ld	hl, #_rpg_spell_option
	call	___sdcc_bcall_ehl
	add	sp, #5
	or	a, a
	jr	Z, 00411$
	ldhl	sp,	#27
	inc	(hl)
	jr	00409$
00411$:
;src/main.c:699: if(pressed&J_B){party_purpose=PARTY_MAGIC_CASTER;party_choice=magic_caster;party_screen();}
	xor	a, a
	ldhl	sp,	#19
	or	a, (hl)
	jr	Z, 00426$
	ld	hl, #_party_purpose
	ld	(hl), #0x80
	ld	a, (#_magic_caster)
	ld	(#_party_choice),a
	ld	e, #b_party_screen
	ld	hl, #_party_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00426$:
;src/main.c:700: else if(pressed&J_UP){magic_choice=magic_choice?magic_choice-1u:code-1u;map_magic_screen();}
	xor	a, a
	ldhl	sp,	#7
	or	a, (hl)
	jr	Z, 00423$
	ld	hl, #_magic_choice
	ld	a, (hl)
	or	a, a
	jr	Z, 00567$
	ld	a, (hl)
	dec	a
	jr	00568$
00567$:
	ldhl	sp,	#27
	ld	a, (hl)
	dec	a
00568$:
	ld	(#_magic_choice),a
	ld	e, #b_map_magic_screen
	ld	hl, #_map_magic_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00423$:
;src/main.c:701: else if(pressed&J_DOWN){magic_choice=(magic_choice+1u)%code;map_magic_screen();}
	xor	a, a
	ldhl	sp,	#9
	or	a, (hl)
	jr	Z, 00420$
	ld	a, (_magic_choice)
	ld	d, #0x00
	ld	e, a
	inc	de
	ldhl	sp,	#27
	ld	c, (hl)
	xor	a, a
	ld	b, a
	call	__moduint
	ld	hl, #_magic_choice
	ld	(hl), c
	ld	e, #b_map_magic_screen
	ld	hl, #_map_magic_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00420$:
;src/main.c:702: else if(pressed&J_A) {
	xor	a, a
	ldhl	sp,	#11
	or	a, (hl)
	jp	Z, 00527$
;src/main.c:703: selected_field_spell=rpg_spell_option(&game_rpg,magic_caster,magic_choice,0);
	xor	a, a
	push	af
	inc	sp
	ld	a, (_magic_choice)
	ld	h, a
	ld	a, (_magic_caster)
	ld	l, a
	push	hl
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_spell_option
	ld	hl, #_rpg_spell_option
	call	___sdcc_bcall_ehl
	add	sp, #5
	ld	hl, #_selected_field_spell
	ld	(hl), a
;src/main.c:704: if(selected_field_spell==MagicID_Heal||selected_field_spell==MagicID_Cure||selected_field_spell==MagicID_Rise) {
	ld	a, (hl)
	dec	a
	jr	Z, 00412$
	ld	a, (#_selected_field_spell)
	sub	a, #0x02
	jr	Z, 00412$
	ld	a, (#_selected_field_spell)
	sub	a, #0x0f
	jr	NZ, 00413$
00412$:
;src/main.c:705: party_choice=magic_caster;party_purpose=PARTY_MAGIC_TARGET;party_screen();
	ld	a, (#_magic_caster)
	ld	(#_party_choice),a
	ld	hl, #_party_purpose
	ld	(hl), #0x81
	ld	e, #b_party_screen
	ld	hl, #_party_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00413$:
;src/main.c:706: } else game_field_spell(magic_caster,selected_field_spell,255);
	ld	a, #0xff
	push	af
	inc	sp
	ld	a, (_selected_field_spell)
	ld	h, a
	ld	a, (_magic_caster)
	ld	l, a
	push	hl
	ld	e, #b_game_field_spell
	ld	hl, #_game_field_spell
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00527$
00465$:
;src/main.c:708: } else if(screen_state>=STATE_SAVE_ACTION&&screen_state<=STATE_SAVE_NAME) {
	ld	hl, #_screen_state
	ld	a, (hl)
	sub	a, #0x19
	jr	C, 00461$
	ld	a, #0x1c
	sub	a, (hl)
	jr	C, 00461$
;src/main.c:709: save_ui_tick(keys,pressed);
	ldhl	sp,	#1
	ld	a, (hl-)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_save_ui_tick
	ld	hl, #_save_ui_tick
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00461$:
;src/main.c:710: } else if(screen_state==STATE_PRESENTATION||screen_state==STATE_TRAVEL||screen_state==STATE_ODIN_WAIT) {
	ld	a, (#_screen_state)
	sub	a, #0x14
	jr	Z, 00455$
	ld	a, (#_screen_state)
	sub	a, #0x15
	jr	Z, 00455$
	ld	a, (#_screen_state)
	sub	a, #0x16
	jr	NZ, 00456$
00455$:
;src/main.c:711: game_sequence_tick(keys,pressed);
	ldhl	sp,	#1
	ld	a, (hl-)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_game_sequence_tick
	ld	hl, #_game_sequence_tick
	call	___sdcc_bcall_ehl
	pop	hl
	jp	00527$
00456$:
;src/main.c:712: } else if(screen_state==STATE_DUNGEON) {
	ld	a, (#_screen_state)
	sub	a, #0x11
	jp	NZ, 00527$
;src/main.c:713: if(dungeon_keys_delay)--dungeon_keys_delay;
	ld	hl, #_dungeon_keys_delay
	ld	a, (hl)
	or	a, a
	jr	Z, 00451$
	dec	(hl)
	jp	00527$
00451$:
;src/main.c:715: code=DUNGEON_CMD_NONE;
	ldhl	sp,	#27
	ld	(hl), #0x00
;src/main.c:716: if(pressed&J_START){menu_choice=0;menu_screen();continue;}
	push	hl
	ldhl	sp,	#3
	bit	7, (hl)
	pop	hl
	jr	Z, 00429$
	xor	a, a
	ld	(#_menu_choice),a
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00527$
00429$:
;src/main.c:717: if(pressed&J_SELECT){notice(write_save()?"GAME SAVED":"SAVE FAILED",STATE_WALK);continue;}
	push	hl
	ldhl	sp,	#3
	bit	6, (hl)
	pop	hl
	jr	Z, 00431$
	call	_write_save
	ldhl	sp,#27
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00569$
	dec	hl
	ld	de, #___str_12+0
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	jr	00570$
00569$:
	ld	de, #___str_13+0
	ldhl	sp,	#26
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
00570$:
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#27
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00527$
00431$:
;src/main.c:718: if(keys&J_UP)code=DUNGEON_CMD_FORWARD;else if(keys&J_DOWN)code=DUNGEON_CMD_BACK;
	push	hl
	ldhl	sp,	#2
	bit	2, (hl)
	pop	hl
	jr	Z, 00444$
	ldhl	sp,	#27
	ld	(hl), #0x01
	jr	00445$
00444$:
	push	hl
	ldhl	sp,	#2
	bit	3, (hl)
	pop	hl
	jr	Z, 00441$
	ldhl	sp,	#27
	ld	(hl), #0x02
	jr	00445$
00441$:
;src/main.c:719: else if(keys&J_LEFT)code=DUNGEON_CMD_LEFT;else if(keys&J_RIGHT)code=DUNGEON_CMD_RIGHT;
	push	hl
	ldhl	sp,	#2
	bit	1, (hl)
	pop	hl
	jr	Z, 00438$
	ldhl	sp,	#27
	ld	(hl), #0x03
	jr	00445$
00438$:
	push	hl
	ldhl	sp,	#2
	bit	0, (hl)
	pop	hl
	jr	Z, 00435$
	ldhl	sp,	#27
	ld	(hl), #0x04
	jr	00445$
00435$:
;src/main.c:720: else if(pressed&(J_A|J_B))code=DUNGEON_CMD_ACTION;
	xor	a, a
	ldhl	sp,	#13
	or	a, (hl)
	jr	Z, 00445$
	ldhl	sp,	#27
	ld	(hl), #0x05
00445$:
;src/main.c:722: i=game_dungeon.dungeon.floor;
	ld	a, (#_game_dungeon + 0)
	ldhl	sp,	#26
	ld	(hl), a
;src/main.c:723: dplay_step(&game_dungeon,&game_rpg,&game_events,code);
	ldhl	sp,	#27
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	de, #_game_rpg
	push	de
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_step
	ld	hl, #_dplay_step
	call	___sdcc_bcall_ehl
	add	sp, #7
;src/main.c:724: if(code||i!=game_dungeon.dungeon.floor||game_dungeon.action.kind)apply_dungeon();
	ldhl	sp,	#27
	ld	a, (hl)
	or	a, a
	jr	NZ, 00446$
	ld	a, (#_game_dungeon + 0)
	ldhl	sp,	#27
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl+)
	sub	a, (hl)
	jr	NZ, 00446$
	ld	a, (#(_game_dungeon + 275) + 0)
	or	a, a
	jp	Z, 00527$
00446$:
	ld	e, #b_apply_dungeon
	ld	hl, #_apply_dungeon
	call	___sdcc_bcall_ehl
	jp	00527$
;src/main.c:728: }
	add	sp, #28
	ret
___str_12:
	.ascii "GAME SAVED"
	.db 0x00
___str_13:
	.ascii "SAVE FAILED"
	.db 0x00
___str_14:
	.ascii "GAME OVER"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
__xinit__vehicle_loaded_facing:
	.db #0xff	; 255
	.area _CABS (ABS)
