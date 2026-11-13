;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module game_flow
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _apply_service
	.globl _show_dialogue
	.globl _enter_map
	.globl _draw_dungeon_faded
	.globl _draw_dungeon
	.globl _begin_battle
	.globl _resume_walk
	.globl b_scene_fade_begin
	.globl _scene_fade_begin
	.globl b_game_transition_interaction_music
	.globl _game_transition_interaction_music
	.globl b_game_transition_map_music
	.globl _game_transition_map_music
	.globl b_game_transition_close
	.globl _game_transition_close
	.globl b_game_transition_wait
	.globl _game_transition_wait
	.globl b_game_transition_fade_in
	.globl _game_transition_fade_in
	.globl b_game_transition_fade_out
	.globl _game_transition_fade_out
	.globl b_start_governor_room
	.globl _start_governor_room
	.globl b_start_dark_falz_reveal
	.globl _start_dark_falz_reveal
	.globl b_start_ending
	.globl _start_ending
	.globl b_start_travel
	.globl _start_travel
	.globl b_start_recruitment
	.globl _start_recruitment
	.globl b_audio_command
	.globl _audio_command
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_scene_enemy_show
	.globl _scene_enemy_show
	.globl b_scene_portrait_show
	.globl _scene_portrait_show
	.globl b_scene_show_room
	.globl _scene_show_room
	.globl b_scene_show
	.globl _scene_show
	.globl b_dplay_escape
	.globl _dplay_escape
	.globl b_dplay_scene_fall
	.globl _dplay_scene_fall
	.globl b_dplay_enter
	.globl _dplay_enter
	.globl b_battle_scene_configure
	.globl _battle_scene_configure
	.globl b_battle_view_chest_begin
	.globl _battle_view_chest_begin
	.globl b_service_begin
	.globl _service_begin
	.globl b_event_advance
	.globl _event_advance
	.globl b_event_begin
	.globl _event_begin
	.globl b_world_decode_destination
	.globl _world_decode_destination
	.globl b_travel_menu
	.globl _travel_menu
	.globl b_inventory_screen
	.globl _inventory_screen
	.globl b_notice
	.globl _notice
	.globl b_menu_screen
	.globl _menu_screen
	.globl _display_off
	.globl _vsync
	.globl b_apply_event
	.globl _apply_event
	.globl b_apply_dungeon
	.globl _apply_dungeon
	.globl b_show_interaction_scene
	.globl _show_interaction_scene
	.globl b_enter_dungeon
	.globl _enter_dungeon
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
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
	.area _CODE_12
;src/game_flow.c:37: static void flow_notice(const char *text,uint8_t state) {
;	---------------------------------
; Function flow_notice
; ---------------------------------
_flow_notice:
	add	sp, #-26
	ldhl	sp,	#24
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
	ld	(hl), a
;src/game_flow.c:38: char copy[21];uint8_t i=0;while(text[i]&&i<20u){copy[i]=text[i];++i;}copy[i]=0;notice(copy,state);
	ld	c, #0x00
00102$:
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	b, a
	push	hl
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	l, c
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#23
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#22
	ld	(hl), a
	ld	a, b
	or	a, a
	jr	Z, 00104$
	ld	a, c
	sub	a, #0x14
	jr	NC, 00104$
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), b
	inc	c
	jr	00102$
00104$:
	ld	hl, #0
	add	hl, sp
	ld	c, l
	ld	b, h
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#23
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
;src/game_flow.c:39: }
	add	sp, #29
	ret
;src/game_flow.c:60: static void event_presentation(uint8_t effect) {
;	---------------------------------
; Function event_presentation
; ---------------------------------
_event_presentation:
;src/game_flow.c:61: if(effect==EVENT_PRESENT_SUEL_HEAL)return;
;src/game_flow.c:62: if(effect==EVENT_PRESENT_GUEST_WAKE){game_transition_fade_in();return;}
	ld	c,a
	or	a,a
	ret	Z
	sub	a, #0x02
	jr	NZ, 00104$
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
	jp  ___sdcc_bcall_ehl
00104$:
;src/game_flow.c:63: if(effect==EVENT_PRESENT_GUEST_SLEEP) {
	ld	a, c
	dec	a
	jr	NZ, 00106$
;src/game_flow.c:64: game_transition_fade_out();game_transition_close();audio_command(0xa0);
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
	ld	e, #b_game_transition_close
	ld	hl, #_game_transition_close
	call	___sdcc_bcall_ehl
	ld	a, #0xa0
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_flow.c:65: game_transition_wait(208u,1u);
	ld	hl, #0x1d0
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_flow.c:68: return;
	ret
00106$:
;src/game_flow.c:70: if(effect==EVENT_PRESENT_NIGHTMARE_HOLD) {
	ld	a, c
	sub	a, #0x04
	jr	NZ, 00108$
;src/game_flow.c:71: game_transition_close();audio_command(0xa0);game_transition_wait(208u,1u);return;
	ld	e, #b_game_transition_close
	ld	hl, #_game_transition_close
	call	___sdcc_bcall_ehl
	ld	a, #0xa0
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #0x1d0
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
	ret
00108$:
;src/game_flow.c:73: game_transition_fade_out();
	push	bc
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
	pop	bc
;src/game_flow.c:74: if(effect==EVENT_PRESENT_NIGHTMARE_SCENE)game_transition_close();
	ld	a, c
	sub	a, #0x03
	jr	NZ, 00110$
	ld	e, #b_game_transition_close
	ld	hl, #_game_transition_close
	call	___sdcc_bcall_ehl
00110$:
;src/game_flow.c:75: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;scene_actor_hide();
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
;src/game_flow.c:76: scene_show(32u,0u,0u);scene_context_type=32u;background_changed=1;
	xor	a, a
	rrca
	push	af
	xor	a, a
	ld	a, #0x20
	push	af
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	hl, #_scene_context_type
	ld	(hl), #0x20
	ld	hl, #_background_changed
	ld	(hl), #0x01
;src/game_flow.c:77: scene_fade_begin(1u);DISPLAY_ON;
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
;src/game_flow.c:78: game_transition_wait(1u,0u);game_transition_fade_in();
	ld	hl, #0x01
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
;src/game_flow.c:79: }
	jp  ___sdcc_bcall_ehl
;src/game_flow.c:80: void apply_event(void) RPG_BANKED {
;	---------------------------------
; Function apply_event
; ---------------------------------
	b_apply_event	= 12
_apply_event::
	add	sp, #-5
;src/game_flow.c:81: EventAction *a=&game_events.action;
;src/game_flow.c:82: if(a->sound){audio_command(a->sound);a->sound=0;}
	ld	hl, #(_game_events + 282) + 10
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	push	hl
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	hl
	ld	(hl), #0x00
00102$:
;src/game_flow.c:83: if(a->kind==EVENT_PRESENTATION){event_presentation(a->target);event_advance(&game_events);apply_event();return;}
	ld	a, (#(_game_events + 282) + 0)
	ldhl	sp,#4
	ld	(hl), a
	ld	a, (hl)
	sub	a, #0x19
	jr	NZ, 00104$
	ld	a, (#(_game_events + 288) + 0)
	call	_event_presentation
	ld	de, #_game_events
	push	de
	ld	e, #b_event_advance
	ld	hl, #_event_advance
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00185$
00104$:
;src/game_flow.c:84: if(a->kind==EVENT_DONE) resume_walk();
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	NZ, 00180$
	call	_resume_walk
	jp	00185$
00180$:
;src/game_flow.c:85: else if(a->kind==EVENT_MENU) {menu_choice=0;menu_screen();}
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0a
	jr	NZ, 00177$
	xor	a, a
	ld	(#_menu_choice),a
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00185$
00177$:
;src/game_flow.c:86: else if(a->kind==EVENT_BATTLE) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0c
	jr	NZ, 00174$
;src/game_flow.c:87: begin_battle(a->target,1);
	ld	a, (#(_game_events + 288) + 0)
	ld	e, #0x01
	call	_begin_battle
;src/game_flow.c:88: if(game_events.battle.options&EVENT_BATTLE_OVERRIDE_ITEM) battle_view_battle.item_reward=game_events.battle.item_reward;
	ld	a, (#(_game_events + 275) + 0)
	rrca
	jr	NC, 00106$
	ld	a, (#(_game_events + 276) + 0)
	ld	(#(_battle_view_battle + 152)),a
00106$:
;src/game_flow.c:89: if(game_events.battle.options&EVENT_BATTLE_ZERO_MONEY) battle_view_battle.money_reward=0;
	ld	a, (#(_game_events + 275) + 0)
	bit	1, a
	jp	Z, 00185$
	ld	hl, #(_battle_view_battle + 150)
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
	jp	00185$
00174$:
;src/game_flow.c:91: else if(a->kind==EVENT_DUNGEON)enter_dungeon(a->target,a->a,a->b);
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0d
	jr	NZ, 00171$
	ld	hl, #(_game_events + 290)
	ld	b, (hl)
	ld	a, (#(_game_events + 289) + 0)
	ld	hl, #(_game_events + 288)
	ld	h, (hl)
	push	bc
	inc	sp
	push	af
	inc	sp
	push	hl
	inc	sp
	ld	e, #b_enter_dungeon
	ld	hl, #_enter_dungeon
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00185$
00171$:
;src/game_flow.c:92: else if(a->kind==EVENT_DARK_FALZ_REVEAL)start_dark_falz_reveal();
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x17
	jr	NZ, 00168$
	ld	e, #b_start_dark_falz_reveal
	ld	hl, #_start_dark_falz_reveal
	call	___sdcc_bcall_ehl
	jp	00185$
00168$:
;src/game_flow.c:93: else if(a->kind==EVENT_GOVERNOR_ROOM)start_governor_room();
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x18
	jr	NZ, 00165$
	ld	e, #b_start_governor_room
	ld	hl, #_start_governor_room
	call	___sdcc_bcall_ehl
	jp	00185$
00165$:
;src/game_flow.c:94: else if(a->kind==EVENT_DUNGEON_FALL) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x16
	jr	NZ, 00162$
;src/game_flow.c:98: HIDE_WIN;for(close_frames=0;close_frames<6u;++close_frames)vsync();
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ld	c, #0x06
00184$:
	call	_vsync
	dec	c
	jr	NZ, 00184$
;src/game_flow.c:99: if(scene_actor_active)scene_actor_hide();
	ld	a, (#_scene_actor_active)
	or	a, a
	jr	Z, 00111$
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
00111$:
;src/game_flow.c:100: game_vehicle=0;game_events.type=0;game_events.event=0;dark_menu_pending=0;background_changed=0;
	xor	a, a
	ld	(#_game_vehicle),a
	ld	hl, #_game_events + 261
	ld	(hl), #0x00
	ld	hl, #_game_events + 260
	ld	(hl), #0x00
	xor	a, a
	ld	(#_dark_menu_pending), a
	ld	(#_background_changed),a
;src/game_flow.c:101: dplay_scene_fall(&game_dungeon,&game_rpg,&game_events,a->target,a->a,a->b,retained_trap);
	ld	hl, #(_game_events + 282) + 8
	ld	e, (hl)
	ld	hl, #(_game_events + 282) + 7
	ld	b, (hl)
	ld	hl, #(_game_events + 282) + 6
	ld	c, (hl)
	ld	a, (_retained_trap)
	ld	d,a
	push	de
	push	bc
	inc	sp
	ld	a, c
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	de, #_game_rpg
	push	de
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_scene_fall
	ld	hl, #_dplay_scene_fall
	call	___sdcc_bcall_ehl
	add	sp, #10
;src/game_flow.c:102: game_transition_map_music(0x85);apply_dungeon();
	ld	a, #0x85
	push	af
	inc	sp
	ld	e, #b_game_transition_map_music
	ld	hl, #_game_transition_map_music
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, #b_apply_dungeon
	ld	hl, #_apply_dungeon
	call	___sdcc_bcall_ehl
	jp	00185$
00162$:
;src/game_flow.c:104: else if(a->kind==EVENT_DUNGEON_BACK) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0e
	jr	NZ, 00159$
;src/game_flow.c:105: dplay_escape(&game_dungeon,&game_rpg,&game_events);apply_dungeon();
	ld	de, #_game_events
	push	de
	ld	de, #_game_rpg
	push	de
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_escape
	ld	hl, #_dplay_escape
	call	___sdcc_bcall_ehl
	add	sp, #6
	ld	e, #b_apply_dungeon
	ld	hl, #_apply_dungeon
	call	___sdcc_bcall_ehl
	jp	00185$
00159$:
;src/game_flow.c:107: else if(a->kind==EVENT_DUNGEON_CELL) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x14
	jr	NZ, 00156$
;src/game_flow.c:108: if(game_dungeon.active)game_dungeon.dungeon.layout[a->target]=a->a;
	ld	a, (#_game_dungeon + 264)
	or	a, a
	jr	Z, 00113$
	ld	a, (#(_game_events + 288) + 0)
	add	a, #<((_game_dungeon + 8))
	ld	c, a
	ld	a, #0x00
	adc	a, #>((_game_dungeon + 8))
	ld	b, a
	ld	a, (#(_game_events + 289) + 0)
	ld	(bc), a
00113$:
;src/game_flow.c:109: event_advance(&game_events);apply_event();
	ld	de, #_game_events
	push	de
	ld	e, #b_event_advance
	ld	hl, #_event_advance
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00185$
00156$:
;src/game_flow.c:111: else if(a->kind==EVENT_SCENE) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x13
	jr	NZ, 00153$
;src/game_flow.c:112: if(scene_actor_active)scene_actor_hide();
	ld	a, (#_scene_actor_active)
	or	a, a
	jr	Z, 00115$
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
00115$:
;src/game_flow.c:113: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/game_flow.c:114: if(scene_show(a->target,0,0)){background_changed=1;scene_context_type=a->target;}
	ld	hl, #(_game_events + 288)
	ld	b, (hl)
	xor	a, a
	rrca
	push	af
	xor	a, a
	push	bc
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00117$
	ld	hl, #_background_changed
	ld	(hl), #0x01
	ld	a, (#(_game_events + 288) + 0)
	ld	(#_scene_context_type),a
00117$:
;src/game_flow.c:115: DISPLAY_ON;event_advance(&game_events);apply_event();
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
	ld	de, #_game_events
	push	de
	ld	e, #b_event_advance
	ld	hl, #_event_advance
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00185$
00153$:
;src/game_flow.c:117: else if(a->kind==EVENT_CUTSCENE)start_recruitment(a->target);
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x15
	jr	NZ, 00150$
	ld	a, (#(_game_events + 288) + 0)
	push	af
	inc	sp
	ld	e, #b_start_recruitment
	ld	hl, #_start_recruitment
	call	___sdcc_bcall_ehl
	inc	sp
	jp	00185$
00150$:
;src/game_flow.c:118: else if(a->kind==EVENT_ENDING)start_ending();
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x11
	jr	NZ, 00147$
	ld	e, #b_start_ending
	ld	hl, #_start_ending
	call	___sdcc_bcall_ehl
	jp	00185$
00147$:
;src/game_flow.c:119: else if(a->kind==EVENT_GAME_OVER) {title_choice=saved_position_valid?1u:0u;notice("GAME OVER",STATE_TITLE);}
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x12
	jr	NZ, 00144$
	ld	a, (#_saved_position_valid)
	or	a, a
	jr	Z, 00187$
	ldhl	sp,	#4
	ld	(hl), #0x01
	jr	00188$
00187$:
	ldhl	sp,	#4
	ld	(hl), #0x00
00188$:
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(#_title_choice),a
	xor	a, a
	ld	de, #___str_0
	call	_flow_notice
	jp	00185$
00144$:
;src/game_flow.c:120: else if(a->kind==EVENT_TRAVEL_MENU) {choice=0;travel_menu();}
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x10
	jr	NZ, 00141$
	xor	a, a
	ld	(#_choice),a
	ld	e, #b_travel_menu
	ld	hl, #_travel_menu
	call	___sdcc_bcall_ehl
	jp	00185$
00141$:
;src/game_flow.c:121: else if(a->kind==EVENT_TRAVEL) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0f
	jr	NZ, 00138$
;src/game_flow.c:122: start_travel(a->target);
	ld	a, (#(_game_events + 288) + 0)
	push	af
	inc	sp
	ld	e, #b_start_travel
	ld	hl, #_start_travel
	call	___sdcc_bcall_ehl
	inc	sp
	jp	00185$
00138$:
;src/game_flow.c:124: else if(a->kind==EVENT_DIALOGUE||a->kind==EVENT_YES_NO) show_dialogue(a->dialogue_id);
	ldhl	sp,	#4
	ld	a, (hl)
	dec	a
	jr	Z, 00133$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00134$
00133$:
	ld	hl, #(_game_events + 282) + 1
	ld	a, (hl+)
	ld	c, (hl)
	ld	e, a
	ld	d, c
	call	_show_dialogue
	jp	00185$
00134$:
;src/game_flow.c:125: else if(a->kind==EVENT_SHOP||a->kind==EVENT_HOSPITAL||a->kind==EVENT_CHURCH||a->kind==EVENT_SELL) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x03
	jr	Z, 00127$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x04
	jr	Z, 00127$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x05
	jr	Z, 00127$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00128$
00127$:
;src/game_flow.c:126: service_active=1;service_begin(&game_service,&game_events,game_events.type,game_events.event);apply_service();
	ld	hl, #_service_active
	ld	(hl), #0x01
	ld	hl, #_game_events + 260
	ld	d, (hl)
	ld	hl, #_game_events + 261
	ld	e, (hl)
	push	de
	ld	de, #_game_events
	push	de
	ld	de, #_game_service
	push	de
	ld	e, #b_service_begin
	ld	hl, #_service_begin
	call	___sdcc_bcall_ehl
	add	sp, #6
	call	_apply_service
	jp	00185$
00128$:
;src/game_flow.c:128: else if(a->kind==EVENT_REPLACE_ITEM) {replace_source=1;item_slot=0;inventory_screen();}
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00125$
	ld	hl, #_replace_source
	ld	(hl), #0x01
	xor	a, a
	ld	(#_item_slot),a
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	call	___sdcc_bcall_ehl
	jr	00185$
00125$:
;src/game_flow.c:129: else if(a->kind==EVENT_TRANSITION) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00122$
;src/game_flow.c:130: start_travel(a->target);
	ld	a, (#(_game_events + 288) + 0)
	push	af
	inc	sp
	ld	e, #b_start_travel
	ld	hl, #_start_travel
	call	___sdcc_bcall_ehl
	inc	sp
	jr	00185$
00122$:
;src/game_flow.c:131: } else if(a->kind==EVENT_MAP_TRANSITION) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x09
	jr	NZ, 00119$
;src/game_flow.c:132: uint16_t x,y;world_action.target=a->target;world_action.a=a->a;world_action.b=a->b;
	ld	bc, #_world_action + 1
	ld	a, (#(_game_events + 288) + 0)
	ld	(bc), a
	ld	a, (#(_game_events + 289) + 0)
	ld	hl, #(_world_action + 2)
	ld	(hl+), a
	ld	a, (#(_game_events + 290) + 0)
	ld	(hl), a
;src/game_flow.c:133: world_decode_destination(&world_action,&x,&y);enter_map(world_action.target,x,y);
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #4
	add	hl, sp
	push	hl
	push	de
	ld	de, #_world_action
	push	de
	ld	e, #b_world_decode_destination
	ld	hl, #_world_decode_destination
	call	___sdcc_bcall_ehl
	add	sp, #6
	pop	bc
	ld	a, (bc)
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
	jr	00185$
00119$:
;src/game_flow.c:134: } else notice("EVENT NOT YET PORTED",STATE_WALK);
	ld	a, #0x01
	ld	de, #___str_1
	call	_flow_notice
00185$:
;src/game_flow.c:135: }
	add	sp, #5
	ret
___str_0:
	.ascii "GAME OVER"
	.db 0x00
___str_1:
	.ascii "EVENT NOT YET PORTED"
	.db 0x00
;src/game_flow.c:137: void apply_dungeon(void) RPG_BANKED {
;	---------------------------------
; Function apply_dungeon
; ---------------------------------
	b_apply_dungeon	= 12
_apply_dungeon::
	add	sp, #-5
;src/game_flow.c:138: DungeonPlayAction *a=&game_dungeon.action;
;src/game_flow.c:140: retained_trap=game_dungeon.retained_trap;
	ld	a, (#(_game_dungeon + 274) + 0)
	ld	(#_retained_trap),a
;src/game_flow.c:141: if(a->kind==DPLAY_VIEW){draw_dungeon();screen_state=STATE_DUNGEON;dungeon_keys_delay=8;}
	ld	a, (#(_game_dungeon + 275) + 0)
	ldhl	sp,#4
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	NZ, 00135$
	call	_draw_dungeon
	ld	hl, #_screen_state
	ld	(hl), #0x11
	ld	hl, #_dungeon_keys_delay
	ld	(hl), #0x08
	jp	00137$
00135$:
;src/game_flow.c:142: else if(a->kind==DPLAY_MENU){menu_choice=0;menu_screen();}
	ldhl	sp,	#4
	ld	a, (hl)
	dec	a
	jr	NZ, 00132$
	ld	(#_menu_choice),a
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00137$
00132$:
;src/game_flow.c:144: battle_object_flag=a->flag_address;begin_battle(a->target,2);
;src/game_flow.c:145: if(a->type)battle_view_battle.item_reward=a->a;
;src/game_flow.c:143: else if(a->kind==DPLAY_BATTLE) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00129$
;src/game_flow.c:144: battle_object_flag=a->flag_address;begin_battle(a->target,2);
	ld	de, #(_game_dungeon + 280)
	ld	a, (de)
	ld	hl, #_battle_object_flag
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	a, (#(_game_dungeon + 276) + 0)
	ld	e, #0x02
	call	_begin_battle
;src/game_flow.c:145: if(a->type)battle_view_battle.item_reward=a->a;
	ld	a, (#(_game_dungeon + 279) + 0)
	or	a, a
	jp	Z, 00137$
	ld	a, (#(_game_dungeon + 277) + 0)
	ld	(#(_battle_view_battle + 152)),a
	jp	00137$
00129$:
;src/game_flow.c:147: else if(a->kind==DPLAY_CHEST) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00126$
;src/game_flow.c:148: draw_dungeon();battle_from_event=2;battle_object_flag=a->flag_address;
	call	_draw_dungeon
	ld	hl, #_battle_from_event
	ld	(hl), #0x02
	ld	de, #(_game_dungeon + 280)
	ld	a, (de)
	ld	hl, #_battle_object_flag
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;src/game_flow.c:149: retained_trap=a->a;
	ld	a, (#(_game_dungeon + 277) + 0)
	ld	(#_retained_trap),a
;src/game_flow.c:150: battle_scene_configure(scene_context_type,game_dungeon.dungeon.palette_index);
	ld	a, (#(_game_dungeon + 6) + 0)
	push	af
	inc	sp
	ld	a, (_scene_context_type)
	push	af
	inc	sp
	ld	e, #b_battle_scene_configure
	ld	hl, #_battle_scene_configure
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_flow.c:151: battle_view_chest_begin(&game_rpg,a->target,a->money,retained_trap);screen_state=STATE_BATTLE;
	ld	hl, #(_game_dungeon + 275) + 7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, (#(_game_dungeon + 276) + 0)
	ldhl	sp,	#4
	ld	(hl), a
	ld	a, (_retained_trap)
	push	af
	inc	sp
	push	bc
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_battle_view_chest_begin
	ld	hl, #_battle_view_chest_begin
	call	___sdcc_bcall_ehl
	add	sp, #6
	ld	hl, #_screen_state
	ld	(hl), #0x0f
	jp	00137$
00126$:
;src/game_flow.c:160: if(a->b>=253u) {
;src/game_flow.c:153: else if(a->kind==DPLAY_EVENT) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x04
	jp	NZ, 00123$
;src/game_flow.c:154: draw_dungeon();
	call	_draw_dungeon
;src/game_flow.c:155: type=a->type==255u?game_events.type:a->type;
	ld	hl, #(_game_dungeon + 279)
	ld	c, (hl)
	ld	a, c
	inc	a
	jr	NZ, 00139$
	ld	a, (#(_game_events + 261) + 0)
	jr	00140$
00139$:
	ld	a, c
00140$:
	ldhl	sp,	#4
	ld	(hl), a
;src/game_flow.c:156: if(a->type) {
	ld	a, c
	or	a, a
	jp	Z, 00109$
;src/game_flow.c:159: game_transition_fade_out();background_changed=1;
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
	ld	hl, #_background_changed
	ld	(hl), #0x01
;src/game_flow.c:160: if(a->b>=253u) {
	ld	a, (#(_game_dungeon + 278) + 0)
	sub	a, #0xfd
	jp	C, 00109$
;src/game_flow.c:161: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;scene_actor_hide();
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
;src/game_flow.c:162: if(a->b==255u) {
	ld	a, (#(_game_dungeon + 278) + 0)
	inc	a
	jr	NZ, 00104$
;src/game_flow.c:163: scene_show_room(game_dungeon.dungeon.palette_index,0u,0u);
	ld	hl, #(_game_dungeon + 6)
	ld	b, (hl)
	xor	a, a
	rrca
	push	af
	xor	a, a
	push	bc
	inc	sp
	ld	e, #b_scene_show_room
	ld	hl, #_scene_show_room
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/game_flow.c:164: scene_context_type=64u+game_dungeon.dungeon.palette_index;
	ld	a, (#(_game_dungeon + 6) + 0)
	add	a, #0x40
	ld	(#_scene_context_type),a
	jr	00105$
00104$:
;src/game_flow.c:165: } else {scene_show(type,0u,0u);scene_context_type=type;}
	xor	a, a
	rrca
	push	af
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(#_scene_context_type),a
00105$:
;src/game_flow.c:166: background_changed=1;scene_fade_begin(1u);DISPLAY_ON;
	ld	hl, #_background_changed
	ld	(hl), #0x01
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
;src/game_flow.c:167: game_transition_wait(1u,0u);game_transition_fade_in();
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
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
	call	___sdcc_bcall_ehl
00109$:
;src/game_flow.c:171: event_begin(&game_events,type,a->target,a->a,world_map_id);
	ld	hl, #(_game_dungeon + 277)
	ld	b, (hl)
	ld	hl, #(_game_dungeon + 275) + 1
	ld	d, (hl)
	ld	a, (_world_map_id)
	push	af
	inc	sp
	ld	c, d
	push	bc
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_begin
	ld	hl, #_event_begin
	call	___sdcc_bcall_ehl
	add	sp, #6
;src/game_flow.c:172: DISPLAY_OFF;
	call	_display_off
;src/game_flow.c:173: if(game_events.prepared_enemy)scene_enemy_show(game_events.prepared_enemy,game_dungeon.dungeon.palette_index);
	ld	a, (#(_game_events + 270) + 0)
	ldhl	sp,#4
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00111$
	ld	a, (#(_game_dungeon + 6) + 0)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_scene_enemy_show
	ld	hl, #_scene_enemy_show
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00112$
00111$:
;src/game_flow.c:174: else scene_portrait_show(game_events.portrait);
	ld	a, (#(_game_events + 262) + 0)
	push	af
	inc	sp
	ld	e, #b_scene_portrait_show
	ld	hl, #_scene_portrait_show
	call	___sdcc_bcall_ehl
	inc	sp
00112$:
;src/game_flow.c:175: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/game_flow.c:176: apply_event();
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jp	00137$
00123$:
;src/game_flow.c:178: else if(a->kind==DPLAY_MAP) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x05
	jr	NZ, 00120$
;src/game_flow.c:179: world_action.target=a->target;world_action.a=a->a;world_action.b=a->b;
	ld	a, (#(_game_dungeon + 276) + 0)
	ld	hl, #(_world_action + 1)
	ld	(hl+), a
	ld	a, (#(_game_dungeon + 277) + 0)
	ld	(hl), a
	ld	a, (#(_game_dungeon + 278) + 0)
	ldhl	sp,	#4
	ld	(hl), a
	ld	de, #(_world_action + 3)
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(de), a
;src/game_flow.c:180: world_decode_destination(&world_action,&x,&y);enter_map(world_action.target,x,y);
	ld	hl, #2
	add	hl, sp
	push	hl
	ld	hl, #2
	add	hl, sp
	push	hl
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
	jr	00137$
00120$:
;src/game_flow.c:182: else if(a->kind==DPLAY_EXIT)enter_map(world_map_id,player_x,player_y);
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00117$
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
	jr	00137$
00117$:
;src/game_flow.c:183: else if(a->kind==DPLAY_DARK) {
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00114$
;src/game_flow.c:184: draw_dungeon();dark_menu_pending=1;
	call	_draw_dungeon
	ld	hl, #_dark_menu_pending
	ld	(hl), #0x01
;src/game_flow.c:185: game_events.action.kind=EVENT_MENU;game_events.action.dialogue_id=0xb392;show_dialogue(0xb392);
	ld	hl, #(_game_events + 282)
	ld	a, #0x0a
	ld	(hl+), a
	ld	a, #0x92
	ld	(hl+), a
	ld	(hl), #0xb3
	ld	de, #0xb392
	call	_show_dialogue
	jr	00137$
00114$:
;src/game_flow.c:187: else notice("DUNGEON STATE ERROR",STATE_WALK);
	ld	a, #0x01
	ld	de, #___str_2
	call	_flow_notice
00137$:
;src/game_flow.c:188: }
	add	sp, #5
	ret
___str_2:
	.ascii "DUNGEON STATE ERROR"
	.db 0x00
;src/game_flow.c:190: void show_interaction_scene(uint8_t type,uint8_t portrait,uint8_t enemy) RPG_BANKED {
;	---------------------------------
; Function show_interaction_scene
; ---------------------------------
	b_show_interaction_scene	= 12
_show_interaction_scene::
;src/game_flow.c:192: audio_command(0xd6);game_transition_fade_out();
	ld	a, #0xd6
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
;src/game_flow.c:193: scene_context_type=type;
	ldhl	sp,	#6
	ld	b, (hl)
	ld	hl, #_scene_context_type
	ld	(hl), b
;src/game_flow.c:194: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;scene_actor_hide();
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	push	bc
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	pop	bc
;src/game_flow.c:195: if(scene_show(type,0u,0u))background_changed=1;
	push	bc
	xor	a, a
	rrca
	push	af
	push	bc
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	or	a, a
	jr	Z, 00102$
	ld	hl, #_background_changed
	ld	(hl), #0x01
00102$:
;src/game_flow.c:196: music=game_transition_interaction_music(type);if(music)audio_command(music);
	push	bc
	inc	sp
	ld	e, #b_game_transition_interaction_music
	ld	hl, #_game_transition_interaction_music
	call	___sdcc_bcall_ehl
	inc	sp
	ld	b, a
	or	a, a
	jr	Z, 00104$
	push	bc
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00104$:
;src/game_flow.c:197: scene_fade_begin(1u);DISPLAY_ON;
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
;src/game_flow.c:198: game_transition_wait(2u,0u); /* Original0C upload, then2FD's14 upload. */
	ld	hl, #0x02
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_flow.c:199: game_transition_fade_in();
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
	call	___sdcc_bcall_ehl
;src/game_flow.c:201: game_transition_wait(1u,1u);
	ld	hl, #0x101
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_flow.c:202: if(portrait||enemy){
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	NZ, 00108$
	inc	hl
	ld	a, (hl)
	or	a, a
	ret	Z
00108$:
;src/game_flow.c:203: DISPLAY_OFF;
	call	_display_off
;src/game_flow.c:204: if(enemy)scene_enemy_show(enemy,game_dungeon.active?game_dungeon.dungeon.palette_index:0u);
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	ld	a, (#(_game_dungeon + 264) + 0)
	or	a, a
	jr	Z, 00113$
	ld	a, (#(_game_dungeon + 6) + 0)
	jr	00114$
00113$:
	xor	a, a
00114$:
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_scene_enemy_show
	ld	hl, #_scene_enemy_show
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00107$
00106$:
;src/game_flow.c:205: else scene_portrait_show(portrait);
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_scene_portrait_show
	ld	hl, #_scene_portrait_show
	call	___sdcc_bcall_ehl
	inc	sp
00107$:
;src/game_flow.c:206: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/game_flow.c:208: }
	ret
;src/game_flow.c:210: void enter_dungeon(uint8_t floor,uint8_t position,uint8_t direction) RPG_BANKED {
;	---------------------------------
; Function enter_dungeon
; ---------------------------------
	b_enter_dungeon	= 12
_enter_dungeon::
;src/game_flow.c:211: game_transition_fade_out();
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
;src/game_flow.c:212: if(game_vehicle){scene_actor_hide();game_vehicle=0;}
	ld	a, (#_game_vehicle)
	or	a, a
	jr	Z, 00102$
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	xor	a, a
	ld	(#_game_vehicle),a
00102$:
;src/game_flow.c:213: game_events.type=0;game_events.event=0;background_changed=1;dark_menu_pending=0;
	ld	hl, #_game_events + 261
	ld	(hl), #0x00
	ld	hl, #_game_events + 260
	ld	(hl), #0x00
	ld	hl, #_background_changed
	ld	(hl), #0x01
	xor	a, a
	ld	(#_dark_menu_pending),a
;src/game_flow.c:214: dplay_enter(&game_dungeon,&game_rpg,&game_events,floor,position,direction,retained_trap);
	ld	a, (_retained_trap)
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl-)
	ld	d, a
	ld	a, (hl-)
	ld	e, a
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_events
	push	de
	ld	de, #_game_rpg
	push	de
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_enter
	ld	hl, #_dplay_enter
	call	___sdcc_bcall_ehl
	add	sp, #10
;src/game_flow.c:215: game_transition_map_music(game_dungeon.dungeon.music);
	ld	a, (#(_game_dungeon + 7) + 0)
	push	af
	inc	sp
	ld	e, #b_game_transition_map_music
	ld	hl, #_game_transition_map_music
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_flow.c:216: draw_dungeon_faded();
	call	_draw_dungeon_faded
;src/game_flow.c:217: game_transition_wait(2u,0u);game_transition_fade_in();apply_dungeon();
	ld	hl, #0x02
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
	call	___sdcc_bcall_ehl
	ld	e, #b_apply_dungeon
	ld	hl, #_apply_dungeon
;src/game_flow.c:218: }
	jp  ___sdcc_bcall_ehl
	.area _CODE_12
	.area _INITIALIZER
	.area _CABS (ABS)
