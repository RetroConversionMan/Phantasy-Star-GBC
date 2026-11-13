;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module game_sequence
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _enter_map_ready
	.globl _start_cutscene
	.globl b_world_motion_step
	.globl _world_motion_step
	.globl b_game_transition_map_music
	.globl _game_transition_map_music
	.globl b_game_transition_vint16
	.globl _game_transition_vint16
	.globl b_party_world_tick
	.globl _party_world_tick
	.globl b_game_field_scene_done
	.globl _game_field_scene_done
	.globl b_start_myau_flight
	.globl _start_myau_flight
	.globl b_audio_command
	.globl _audio_command
	.globl b_scene_fade_step
	.globl _scene_fade_step
	.globl b_scene_fade_begin
	.globl _scene_fade_begin
	.globl b_travel_present
	.globl _travel_present
	.globl b_travel_step
	.globl _travel_step
	.globl b_travel_begin
	.globl _travel_begin
	.globl b_presentation_tick
	.globl _presentation_tick
	.globl b_presentation_begin
	.globl _presentation_begin
	.globl b_notice
	.globl _notice
	.globl b_menu_screen
	.globl _menu_screen
	.globl _display_off
	.globl _joypad
	.globl b_start_recruitment
	.globl _start_recruitment
	.globl b_start_field_scene
	.globl _start_field_scene
	.globl b_start_travel
	.globl _start_travel
	.globl b_game_sequence_tick
	.globl _game_sequence_tick
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_effect_kind:
	.ds 1
_travel_tag:
	.ds 1
_travel_fade_clock:
	.ds 1
_travel_fade_step:
	.ds 1
_travel_keys:
	.ds 1
_game_travel:
	.ds 34
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
	.area _CODE_14
;src/game_sequence.c:21: static void begin_effect(uint8_t effect) {
;	---------------------------------
; Function begin_effect
; ---------------------------------
_begin_effect:
	ld	b, a
;src/game_sequence.c:22: DISPLAY_OFF;if(effect!=PRESENT_TORCH)HIDE_WIN;
	call	_display_off
	ld	a, b
	sub	a, #0x02
	jr	Z, 00102$
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
00102$:
;src/game_sequence.c:23: presentation_begin(effect);effect_kind=effect;background_changed=1;
	push	bc
	push	bc
	inc	sp
	ld	e, #b_presentation_begin
	ld	hl, #_presentation_begin
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
	ld	hl, #_effect_kind
	ld	(hl), b
	ld	hl, #_background_changed
	ld	(hl), #0x01
;src/game_sequence.c:24: SHOW_BKG;DISPLAY_ON;screen_state=STATE_PRESENTATION;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_screen_state
	ld	(hl), #0x14
;src/game_sequence.c:25: }
	ret
;src/game_sequence.c:26: void start_recruitment(uint8_t sequence) RPG_BANKED {
;	---------------------------------
; Function start_recruitment
; ---------------------------------
	b_start_recruitment	= 14
_start_recruitment::
;src/game_sequence.c:27: if(sequence==CUTSCENE_ODIN)begin_effect(PRESENT_ODIN);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00102$
	ld	a, #0x01
	jp	_begin_effect
00102$:
;src/game_sequence.c:28: else start_cutscene(sequence);
	ldhl	sp,	#6
	ld	a, (hl)
;src/game_sequence.c:29: }
	jp	_start_cutscene
;src/game_sequence.c:30: void start_field_scene(uint8_t kind) RPG_BANKED {
;	---------------------------------
; Function start_field_scene
; ---------------------------------
	b_start_field_scene	= 14
_start_field_scene::
	add	sp, #-21
;src/game_sequence.c:31: if(kind==FIELD_PRISM)begin_effect(PRESENT_PRISM);
	ldhl	sp,	#27
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00108$
	ld	a, #0x03
	call	_begin_effect
	jr	00110$
00108$:
;src/game_sequence.c:32: else if(kind==FIELD_TORCH_SCENE)begin_effect(PRESENT_TORCH);
	ldhl	sp,	#27
	ld	a, (hl)
	sub	a, #0x09
	jr	NZ, 00105$
	ld	a, #0x02
	call	_begin_effect
	jr	00110$
00105$:
;src/game_sequence.c:33: else if(kind==FIELD_MYAU_FLY)start_myau_flight();
	ldhl	sp,	#27
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00102$
	ld	e, #b_start_myau_flight
	ld	hl, #_start_myau_flight
	call	___sdcc_bcall_ehl
	jr	00110$
00102$:
;src/game_sequence.c:34: else {char message[]="SCENE NOT YET PORTED";notice(message,2);}
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	ld	(hl), #0x53
	ldhl	sp,	#1
	ld	a, #0x43
	ld	(hl+), a
	ld	a, #0x45
	ld	(hl+), a
	ld	a, #0x4e
	ld	(hl+), a
	ld	a, #0x45
	ld	(hl+), a
	ld	a, #0x20
	ld	(hl+), a
	ld	a, #0x4e
	ld	(hl+), a
	ld	a, #0x4f
	ld	(hl+), a
	ld	a, #0x54
	ld	(hl+), a
	ld	a, #0x20
	ld	(hl+), a
	ld	a, #0x59
	ld	(hl+), a
	ld	a, #0x45
	ld	(hl+), a
	ld	a, #0x54
	ld	(hl+), a
	ld	a, #0x20
	ld	(hl+), a
	ld	a, #0x50
	ld	(hl+), a
	ld	a, #0x4f
	ld	(hl+), a
	ld	a, #0x52
	ld	(hl+), a
	ld	a, #0x54
	ld	(hl+), a
	ld	a, #0x45
	ld	(hl+), a
	ld	a, #0x44
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
	push	af
	inc	sp
	push	bc
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
00110$:
;src/game_sequence.c:35: }
	add	sp, #21
	ret
;src/game_sequence.c:36: void start_travel(uint8_t tag) RPG_BANKED {
;	---------------------------------
; Function start_travel
; ---------------------------------
	b_start_travel	= 14
_start_travel::
;src/game_sequence.c:37: travel_tag=tag;travel_fade_clock=audio_clock;travel_fade_step=0;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_travel_tag),a
	ld	a, (#_audio_clock)
	ld	(#_travel_fade_clock),a
;src/game_sequence.c:38: scene_fade_begin(0u);
	xor	a, a
	ld	(#_travel_fade_step), a
	push	af
	inc	sp
	ld	e, #b_scene_fade_begin
	ld	hl, #_scene_fade_begin
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_sequence.c:39: travel_keys=joypad();HIDE_WIN;screen_state=STATE_TRAVEL;
	call	_joypad
	ld	(#_travel_keys),a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_screen_state
	ld	(hl), #0x15
;src/game_sequence.c:40: }
	ret
;src/game_sequence.c:41: void game_sequence_tick(uint8_t keys,uint8_t pressed) RPG_BANKED {
;	---------------------------------
; Function game_sequence_tick
; ---------------------------------
	b_game_sequence_tick	= 14
_game_sequence_tick::
	dec	sp
;src/game_sequence.c:42: uint8_t flags,skip=0;
	ldhl	sp,	#0
	ld	(hl), #0x00
;src/game_sequence.c:43: if(screen_state==STATE_PRESENTATION) {
	ld	a, (#_screen_state)
	sub	a, #0x14
	jr	NZ, 00143$
;src/game_sequence.c:44: if(!presentation_tick())return;
	ld	e, #b_presentation_tick
	ld	hl, #_presentation_tick
	call	___sdcc_bcall_ehl
	or	a, a
	jp	Z, 00145$
;src/game_sequence.c:45: if(effect_kind==PRESENT_ODIN)screen_state=STATE_ODIN_WAIT;
	ld	a, (#_effect_kind)
	dec	a
	jr	NZ, 00107$
	ld	hl, #_screen_state
	ld	(hl), #0x16
	jp	00145$
00107$:
;src/game_sequence.c:46: else if(effect_kind==PRESENT_TORCH)game_field_scene_done();
	ld	a, (#_effect_kind)
	sub	a, #0x02
	jr	NZ, 00104$
	ld	e, #b_game_field_scene_done
	ld	hl, #_game_field_scene_done
	call	___sdcc_bcall_ehl
	jp	00145$
00104$:
;src/game_sequence.c:47: else menu_screen();
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00145$
00143$:
;src/game_sequence.c:48: } else if(screen_state==STATE_ODIN_WAIT) {
	ld	a, (#_screen_state)
	sub	a, #0x16
	jr	NZ, 00140$
;src/game_sequence.c:49: if(pressed&(J_A|J_B))start_cutscene(CUTSCENE_ODIN);
	ldhl	sp,	#8
	ld	a, (hl)
	and	a, #0x30
	jp	Z, 00145$
	ld	a, #0x02
	inc	sp
	jp	_start_cutscene
	jp	00145$
00140$:
;src/game_sequence.c:50: } else if(screen_state==STATE_TRAVEL) {
	ld	a, (#_screen_state)
	sub	a, #0x15
	jp	NZ, 00145$
;src/game_sequence.c:51: if(travel_tag) {
	ld	a, (#_travel_tag)
	or	a, a
	jr	Z, 00126$
;src/game_sequence.c:52: if(!game_transition_vint16())return;
	ld	e, #b_game_transition_vint16
	ld	hl, #_game_transition_vint16
	call	___sdcc_bcall_ehl
	or	a, a
	jp	Z, 00145$
;src/game_sequence.c:53: scene_fade_step(travel_fade_step+1u,0u);
	ld	hl, #_travel_fade_step
	ld	b, (hl)
	inc	b
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	e, #b_scene_fade_step
	ld	hl, #_scene_fade_step
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_sequence.c:54: if(++travel_fade_step<9u)return;
	ld	hl, #_travel_fade_step
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x09
	jp	C, 00145$
;src/game_sequence.c:55: flags=travel_begin(&game_travel,travel_tag);game_travel.fade_clock=game_fade_clock;travel_tag=0;game_vehicle=0;
	ld	a, (_travel_tag)
	push	af
	inc	sp
	ld	de, #_game_travel
	push	de
	ld	e, #b_travel_begin
	ld	hl, #_travel_begin
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	c, a
	ld	de, #(_game_travel + 32)
	ld	a, (_game_fade_clock)
	ld	(de), a
	xor	a, a
	ld	(#_travel_tag), a
	ld	(#_game_vehicle),a
	jp	00127$
00126$:
;src/game_sequence.c:57: if(game_travel.stage==TRAVEL_ROAD||game_travel.stage==TRAVEL_ASCEND||
	ld	bc, #_game_travel + 17
	ld	a, (bc)
	cp	a, #0x02
	jr	Z, 00115$
	cp	a, #0x03
	jr	Z, 00115$
;src/game_sequence.c:58: game_travel.stage==TRAVEL_SPACE_RUN||game_travel.stage==TRAVEL_ARRIVE) {
	cp	a, #0x05
	jr	Z, 00115$
	sub	a, #0x06
	jr	NZ, 00116$
00115$:
;src/game_sequence.c:59: skip=(keys&~travel_keys)&(J_A|J_B);travel_keys=keys;
	ld	a, (#_travel_keys)
	cpl
	ldhl	sp,	#7
	and	a, (hl)
	and	a, #0x30
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(#_travel_keys),a
00116$:
;src/game_sequence.c:61: if(game_travel.stage==TRAVEL_ROAD)world_motion_step();
	ld	a, (bc)
	sub	a, #0x02
	jr	NZ, 00121$
	push	bc
	ld	e, #b_world_motion_step
	ld	hl, #_world_motion_step
	call	___sdcc_bcall_ehl
	pop	bc
00121$:
;src/game_sequence.c:64: if(game_travel.stage==TRAVEL_ROAD&&!skip) {
	ld	a, (bc)
	sub	a, #0x02
	jr	NZ, 00123$
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	NZ, 00123$
;src/game_sequence.c:65: uint8_t mask=1u<<(game_travel.facing<2u?game_travel.facing^1u:game_travel.facing);
	ld	a, (#(_game_travel + 20) + 0)
	cp	a, #0x02
	jr	NC, 00147$
	xor	a, #0x01
	ld	b, a
	jr	00148$
00147$:
	ld	b, a
00148$:
	ld	c, #0x01
	inc	b
	jr	00317$
00316$:
	sla	c
00317$:
	dec	b
	jr	NZ,00316$
;src/game_sequence.c:66: party_world_tick(mask,15u-game_travel.step_pixels,mask);
	ld	hl, #_game_travel + 24
	ld	a, #0x0f
	sub	a, (hl)
	ld	h, c
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	ld	e, #b_party_world_tick
	ld	hl, #_party_world_tick
	call	___sdcc_bcall_ehl
	add	sp, #3
00123$:
;src/game_sequence.c:68: game_travel.fade_clock=game_fade_clock;
	ld	de, #_game_travel + 32
	ld	a, (_game_fade_clock)
	ld	(de), a
;src/game_sequence.c:69: flags=travel_step(&game_travel,skip);game_fade_clock=game_travel.fade_clock;
	push	de
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	ld	bc, #_game_travel
	push	bc
	ld	e, #b_travel_step
	ld	hl, #_travel_step
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	c, a
	pop	de
	ld	a, (de)
	ld	(#_game_fade_clock),a
00127$:
;src/game_sequence.c:71: if(flags&TRAVEL_AUDIO){
	bit	3, c
	jr	Z, 00132$
;src/game_sequence.c:72: if(flags&TRAVEL_WORLD)game_transition_map_music(game_travel.music);
	bit	0, c
	jr	Z, 00129$
	ld	a, (#(_game_travel + 22) + 0)
	push	bc
	push	af
	inc	sp
	ld	e, #b_game_transition_map_music
	ld	hl, #_game_transition_map_music
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
	jr	00132$
00129$:
;src/game_sequence.c:73: else audio_command(game_travel.music);
	ld	a, (#(_game_travel + 22) + 0)
	push	bc
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
00132$:
;src/game_sequence.c:75: if(flags)travel_present(&game_travel,flags);
	ld	a, c
	or	a, a
	jr	Z, 00134$
	push	bc
	ld	a, c
	push	af
	inc	sp
	ld	de, #_game_travel
	push	de
	ld	e, #b_travel_present
	ld	hl, #_travel_present
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
00134$:
;src/game_sequence.c:76: if(flags&TRAVEL_DONE) {
	bit	4, c
	jr	Z, 00145$
;src/game_sequence.c:77: facing=game_travel.facing;enter_map_ready(game_travel.map,game_travel.x,game_travel.y);
	ld	a, (#(_game_travel + 20) + 0)
	ld	(#_facing),a
	ld	hl, #(_game_travel + 2)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #_game_travel
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	de, #_game_travel + 19
	ld	a, (de)
	push	bc
	ld	e, l
	ld	d, h
	call	_enter_map_ready
00145$:
;src/game_sequence.c:80: }
	inc	sp
	ret
	.area _CODE_14
	.area _INITIALIZER
	.area _CABS (ABS)
