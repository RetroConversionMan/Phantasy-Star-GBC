;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module game_movie
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _begin_battle
	.globl _enter_map
	.globl _start_movie_text
	.globl _start_cutscene
	.globl b_game_transition_vint16
	.globl _game_transition_vint16
	.globl b_apply_event
	.globl _apply_event
	.globl b_event_governor_room_loaded
	.globl _event_governor_room_loaded
	.globl b_event_advance
	.globl _event_advance
	.globl b_audio_command
	.globl _audio_command
	.globl b_gold_scene_show
	.globl _gold_scene_show
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_scene_portrait_show
	.globl _scene_portrait_show
	.globl b_scene_show
	.globl _scene_show
	.globl b_presentation_tick
	.globl _presentation_tick
	.globl b_presentation_begin
	.globl _presentation_begin
	.globl b_scene_fade_step
	.globl _scene_fade_step
	.globl b_scene_fade_begin
	.globl _scene_fade_begin
	.globl b_ending_walk_tick
	.globl _ending_walk_tick
	.globl b_ending_walk_begin
	.globl _ending_walk_begin
	.globl b_myau_battle_palette
	.globl _myau_battle_palette
	.globl b_myau_flight_tick
	.globl _myau_flight_tick
	.globl b_myau_flight_begin
	.globl _myau_flight_begin
	.globl b_movie_city_caption
	.globl _movie_city_caption
	.globl b_movie_scene_show
	.globl _movie_scene_show
	.globl b_opening_tick
	.globl _opening_tick
	.globl b_opening_begin
	.globl _opening_begin
	.globl b_title_screen
	.globl _title_screen
	.globl _display_off
	.globl _joypad
	.globl _game_movie_stage
	.globl _game_movie_mode
	.globl b_start_opening
	.globl _start_opening
	.globl b_start_ending
	.globl _start_ending
	.globl b_start_myau_flight
	.globl _start_myau_flight
	.globl b_start_dark_falz_reveal
	.globl _start_dark_falz_reveal
	.globl b_start_governor_room
	.globl _start_governor_room
	.globl b_game_movie_story_done
	.globl _game_movie_story_done
	.globl b_game_movie_text_done
	.globl _game_movie_text_done
	.globl b_game_movie_battle_done
	.globl _game_movie_battle_done
	.globl b_game_movie_tick
	.globl _game_movie_tick
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_game_movie_mode::
	.ds 1
_game_movie_stage::
	.ds 1
_movie_keys:
	.ds 1
_fade_in:
	.ds 1
_fade_step:
	.ds 1
_fade_clock:
	.ds 1
_returning:
	.ds 1
_text_index:
	.ds 1
_hold_frames:
	.ds 2
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
	.area _CODE_121
;src/game_movie.c:33: static void fade(uint8_t stage,uint8_t in) {
;	---------------------------------
; Function fade
; ---------------------------------
_fade:
	ld	(#_game_movie_stage),a
	ld	l, e
;src/game_movie.c:34: game_movie_stage=stage;screen_state=STATE_MOVIE;fade_in=in;fade_step=0;fade_clock=audio_clock;
	ld	a, #0x17
	ld	(_screen_state), a
	ld	a, l
	ld	(_fade_in), a
	xor	a, a
	ld	(_fade_step), a
	ld	a, (_audio_clock)
	ld	(_fade_clock), a
;src/game_movie.c:35: HIDE_WIN;if(!in)scene_fade_begin(0);
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ld	a, l
	or	a, a
	ret	NZ
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_scene_fade_begin
	ld	hl, #_scene_fade_begin
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_movie.c:36: }
	ret
_ending_texts:
	.dw #0xbeb6
	.dw #0xbed0
	.dw #0xbee8
	.dw #0xbefd
	.dw #0xbf09
	.dw #0xbf21
;src/game_movie.c:37: static uint8_t fade_done(void) {
;	---------------------------------
; Function fade_done
; ---------------------------------
_fade_done:
;src/game_movie.c:38: uint8_t elapsed=audio_clock-fade_clock;fade_clock=audio_clock;
	ld	a, (#_audio_clock)
	ld	hl, #_fade_clock
	sub	a, (hl)
	ld	c, a
	ld	a, (#_audio_clock)
	ld	(#_fade_clock),a
;src/game_movie.c:39: while(elapsed--){
00107$:
	ld	a, c
	dec	c
	or	a, a
	jr	Z, 00109$
;src/game_movie.c:40: if(!game_transition_vint16())continue;
	push	bc
	ld	e, #b_game_transition_vint16
	ld	hl, #_game_transition_vint16
	call	___sdcc_bcall_ehl
	pop	bc
	or	a, a
	jr	Z, 00107$
;src/game_movie.c:41: ++fade_step;if(fade_step<=9u)scene_fade_step(fade_step,fade_in);
	ld	hl, #_fade_step
	inc	(hl)
	ld	a, #0x09
	sub	a, (hl)
	jr	C, 00104$
	push	bc
	ld	a, (_fade_in)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_scene_fade_step
	ld	hl, #_scene_fade_step
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
00104$:
;src/game_movie.c:42: if(fade_step>=(fade_in?10u:9u))return 1;
	ld	a, (#_fade_in)
	or	a, a
	jr	Z, 00112$
	ld	b, #0x0a
	jr	00113$
00112$:
	ld	b, #0x09
00113$:
	ld	a, (_fade_step)
	sub	a, b
	jr	C, 00107$
	ld	a, #0x01
	ret
00109$:
;src/game_movie.c:44: return 0;
	xor	a, a
;src/game_movie.c:45: }
	ret
;src/game_movie.c:46: static uint8_t action_edge(uint8_t keys) {
;	---------------------------------
; Function action_edge
; ---------------------------------
_action_edge:
	ld	c, a
;src/game_movie.c:47: uint8_t pressed=(keys&~movie_keys)&(J_A|J_B);movie_keys=keys;return pressed;
	ld	hl, #_movie_keys
	ld	a, (hl)
	cpl
	and	a, c
	and	a, #0x30
	ld	(hl), c
;src/game_movie.c:48: }
	ret
;src/game_movie.c:49: static void movie_begin(uint8_t mode) {
;	---------------------------------
; Function movie_begin
; ---------------------------------
_movie_begin:
	ld	(#_game_movie_mode),a
;src/game_movie.c:50: game_movie_mode=mode;movie_keys=joypad();background_changed=1;HIDE_WIN;
	call	_joypad
	ld	(#_movie_keys),a
	ld	hl, #_background_changed
	ld	(hl), #0x01
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;src/game_movie.c:51: }
	ret
;src/game_movie.c:52: void start_opening(void) RPG_BANKED {
;	---------------------------------
; Function start_opening
; ---------------------------------
	b_start_opening	= 121
_start_opening::
;src/game_movie.c:53: movie_begin(1);audio_command(0xd7);fade(INTRO_OUT,0);
	ld	a, #0x01
	call	_movie_begin
	ld	a, #0xd7
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, #0x00
	ld	a, #0x01
;src/game_movie.c:54: }
	jp	_fade
;src/game_movie.c:55: void start_ending(void) RPG_BANKED {
;	---------------------------------
; Function start_ending
; ---------------------------------
	b_start_ending	= 121
_start_ending::
;src/game_movie.c:56: movie_begin(3);fade(END_OUT,0);
	ld	a, #0x03
	call	_movie_begin
	ld	e, #0x00
	ld	a, #0x28
;src/game_movie.c:57: }
	jp	_fade
;src/game_movie.c:58: void start_myau_flight(void) RPG_BANKED {
;	---------------------------------
; Function start_myau_flight
; ---------------------------------
	b_start_myau_flight	= 121
_start_myau_flight::
;src/game_movie.c:59: movie_begin(2);returning=world_map_id==23u;
	ld	a, #0x02
	call	_movie_begin
	ld	a, (#_world_map_id)
	sub	a, #0x17
	ld	a, #0x01
	jr	Z, 00113$
	xor	a, a
00113$:
;src/game_movie.c:60: fade(returning?FLIGHT_OUT:MYAU_TEXT_OUT,0);
	ld	(#_returning),a
	or	a, a
	ld	a, #0x16
	jr	NZ, 00104$
	ld	a, #0x14
00104$:
	ld	e, #0x00
;src/game_movie.c:61: }
	jp	_fade
;src/game_movie.c:62: void start_dark_falz_reveal(void) RPG_BANKED {
;	---------------------------------
; Function start_dark_falz_reveal
; ---------------------------------
	b_start_dark_falz_reveal	= 121
_start_dark_falz_reveal::
;src/game_movie.c:63: movie_begin(4);audio_command(0x93);hold_frames=208u;fade_clock=audio_clock;
	ld	a, #0x04
	call	_movie_begin
	ld	a, #0x93
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_hold_frames
	ld	a, #0xd0
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	a, (#_audio_clock)
	ld	(#_fade_clock),a
;src/game_movie.c:64: game_movie_stage=DARK_HOLD;screen_state=STATE_MOVIE;
	ld	hl, #_game_movie_stage
	ld	(hl), #0x3c
	ld	hl, #_screen_state
	ld	(hl), #0x17
;src/game_movie.c:65: }
	ret
;src/game_movie.c:66: void start_governor_room(void) RPG_BANKED {
;	---------------------------------
; Function start_governor_room
; ---------------------------------
	b_start_governor_room	= 121
_start_governor_room::
;src/game_movie.c:67: movie_begin(5);fade(GOV_OUT,0);
	ld	a, #0x05
	call	_movie_begin
	ld	e, #0x00
	ld	a, #0x41
;src/game_movie.c:68: }
	jp	_fade
;src/game_movie.c:69: uint8_t game_movie_story_done(void) RPG_BANKED {
;	---------------------------------
; Function game_movie_story_done
; ---------------------------------
	b_game_movie_story_done	= 121
_game_movie_story_done::
;src/game_movie.c:70: if(game_movie_mode==1u&&game_movie_stage==INTRO_TEXT) {
	ld	a, (#_game_movie_mode)
	dec	a
	jr	NZ, 00102$
	ld	a, (#_game_movie_stage)
	sub	a, #0x0a
	jr	NZ, 00102$
;src/game_movie.c:71: game_movie_mode=0;audio_command(0xd7);enter_map(WORLD_START_MAP,WORLD_START_X,WORLD_START_Y);return 1;
	xor	a, a
	ld	(#_game_movie_mode),a
	ld	a, #0xd7
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	de, #0x0130
	push	de
	ld	de, #0x0698
	ld	a, #0x04
	call	_enter_map
	ld	a, #0x01
	ret
00102$:
;src/game_movie.c:73: if(game_movie_mode==2u&&game_movie_stage==MYAU_TEXT){fade(FLIGHT_OUT,0);return 1;}
	ld	a, (#_game_movie_mode)
	sub	a, #0x02
	jr	NZ, 00105$
	ld	a, (#_game_movie_stage)
	sub	a, #0x15
	jr	NZ, 00105$
	ld	e, a
	ld	a, #0x16
	call	_fade
	ld	a, #0x01
	ret
00105$:
;src/game_movie.c:74: if(game_movie_mode==3u&&game_movie_stage==END_STORY){fade(END_IMAGE_OUT,0);return 1;}
	ld	a, (#_game_movie_mode)
	sub	a, #0x03
	jr	NZ, 00108$
	ld	a, (#_game_movie_stage)
	sub	a, #0x2f
	jr	NZ, 00108$
	ld	e, a
	ld	a, #0x30
	call	_fade
	ld	a, #0x01
	ret
00108$:
;src/game_movie.c:75: return 0;
	xor	a, a
;src/game_movie.c:76: }
	ret
;src/game_movie.c:77: void game_movie_text_done(void) RPG_BANKED {
;	---------------------------------
; Function game_movie_text_done
; ---------------------------------
	b_game_movie_text_done	= 121
_game_movie_text_done::
;src/game_movie.c:78: if(game_movie_mode!=3u||game_movie_stage!=END_TEXT)return;
	ld	a, (#_game_movie_mode)
	sub	a, #0x03
	ret	NZ
	ld	a, (#_game_movie_stage)
	sub	a, #0x2d
	ret	NZ
;src/game_movie.c:79: if(++text_index<6u)start_movie_text(ending_texts[text_index]);
	ld	hl, #_text_index
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x06
	jr	NC, 00105$
	ld	bc, #_ending_texts+0
	ld	a, (hl)
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, bc
	ld	a, (hl+)
	ld	c, (hl)
	ld	e, a
	ld	d, c
	jp	_start_movie_text
00105$:
;src/game_movie.c:80: else fade(END_STORY_OUT,0);
	ld	e, #0x00
	ld	a, #0x2e
;src/game_movie.c:81: }
	jp	_fade
;src/game_movie.c:82: void game_movie_battle_done(uint8_t outcome) RPG_BANKED {
;	---------------------------------
; Function game_movie_battle_done
; ---------------------------------
	b_game_movie_battle_done	= 121
_game_movie_battle_done::
;src/game_movie.c:83: game_movie_mode=0;
	xor	a, a
	ld	(#_game_movie_mode),a
;src/game_movie.c:84: if(outcome==RPG_DEFEAT){title_choice=saved_position_valid?1u:0u;title_screen();}
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00102$
	ld	a, (#_saved_position_valid)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00107$
	xor	a, a
00107$:
	ld	(#_title_choice),a
	ld	e, #b_title_screen
	ld	hl, #_title_screen
	call	___sdcc_bcall_ehl
	ret
00102$:
;src/game_movie.c:85: else enter_map(23u,504u,528u); /* Original4511:17,28,1F. */
	ld	de, #0x0210
	push	de
	ld	de, #0x01f8
	ld	a, #0x17
	call	_enter_map
;src/game_movie.c:86: }
	ret
;src/game_movie.c:87: void game_movie_tick(uint8_t keys) RPG_BANKED {
;	---------------------------------
; Function game_movie_tick
; ---------------------------------
	b_game_movie_tick	= 121
_game_movie_tick::
;src/game_movie.c:89: switch(game_movie_stage) {
	ld	a, #0x44
	ld	hl, #_game_movie_stage
	sub	a, (hl)
	ret	C
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #00461$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00461$:
	.dw	00212$
	.dw	00101$
	.dw	00104$
	.dw	00107$
	.dw	00113$
	.dw	00117$
	.dw	00120$
	.dw	00121$
	.dw	00124$
	.dw	00128$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00131$
	.dw	00212$
	.dw	00134$
	.dw	00137$
	.dw	00138$
	.dw	00141$
	.dw	00146$
	.dw	00151$
	.dw	00152$
	.dw	00155$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00159$
	.dw	00162$
	.dw	00163$
	.dw	00166$
	.dw	00169$
	.dw	00212$
	.dw	00172$
	.dw	00212$
	.dw	00175$
	.dw	00178$
	.dw	00179$
	.dw	00182$
	.dw	00185$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00212$
	.dw	00188$
	.dw	00194$
	.dw	00195$
	.dw	00198$
	.dw	00199$
	.dw	00203$
	.dw	00206$
	.dw	00207$
	.dw	00210$
;src/game_movie.c:90: case INTRO_OUT:
00101$:
;src/game_movie.c:91: if(!fade_done())break;
	call	_fade_done
	or	a, a
	ret	Z
;src/game_movie.c:92: DISPLAY_OFF;opening_begin();audio_command(0x8c);scene_fade_begin(1);DISPLAY_ON;
	call	_display_off
	ld	e, #b_opening_begin
	ld	hl, #_opening_begin
	call	___sdcc_bcall_ehl
	ld	a, #0x8c
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
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
;src/game_movie.c:93: fade(INTRO_IN,1);break;
	ld	e, #0x01
	ld	a, #0x02
	jp	_fade
;src/game_movie.c:94: case INTRO_IN:if(fade_done())game_movie_stage=INTRO_PAN;break;
00104$:
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_game_movie_stage
	ld	(hl), #0x03
	ret
;src/game_movie.c:95: case INTRO_PAN:
00107$:
;src/game_movie.c:96: pressed=action_edge(keys);if(!opening_tick(pressed))break;
	ldhl	sp,	#6
	ld	a, (hl)
	call	_action_edge
	ld	b, a
	push	bc
	push	bc
	inc	sp
	ld	e, #b_opening_tick
	ld	hl, #_opening_tick
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
	or	a, a
	ret	Z
;src/game_movie.c:97: if(pressed)fade(CITY_OUT,0);else{hold_frames=180;game_movie_stage=INTRO_HOLD;}break;
	ld	a, b
	or	a, a
	jr	Z, 00111$
	ld	e, #0x00
	ld	a, #0x05
	jp	_fade
00111$:
	ld	hl, #_hold_frames
	ld	a, #0xb4
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x04
	ret
;src/game_movie.c:98: case INTRO_HOLD:
00113$:
;src/game_movie.c:99: if(action_edge(keys)||!--hold_frames)fade(CITY_OUT,0);break;
	ldhl	sp,	#6
	ld	a, (hl)
	call	_action_edge
	or	a, a
	jr	NZ, 00114$
	ld	hl, #_hold_frames
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	or	a, d
	ret	NZ
00114$:
	ld	e, #0x00
	ld	a, #0x05
	jp	_fade
;src/game_movie.c:100: case CITY_OUT:
00117$:
;src/game_movie.c:101: if(!fade_done())break;
	call	_fade_done
	or	a, a
	ret	Z
;src/game_movie.c:102: DISPLAY_OFF;movie_scene_show(MOVIE_OPENING_CITY);scene_fade_begin(1);DISPLAY_ON;
	call	_display_off
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_movie_scene_show
	ld	hl, #_movie_scene_show
	call	___sdcc_bcall_ehl
	inc	sp
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
;src/game_movie.c:103: game_movie_stage=CITY_WAIT;break;
	ld	hl, #_game_movie_stage
	ld	(hl), #0x06
	ret
;src/game_movie.c:104: case CITY_WAIT:fade(CITY_IN,1);break;
00120$:
	ld	e, #0x01
	ld	a, #0x07
	jp	_fade
;src/game_movie.c:105: case CITY_IN:
00121$:
;src/game_movie.c:106: if(fade_done()){movie_city_caption();hold_frames=180;game_movie_stage=CITY_HOLD;}break;
	call	_fade_done
	or	a, a
	ret	Z
	ld	e, #b_movie_city_caption
	ld	hl, #_movie_city_caption
	call	___sdcc_bcall_ehl
	ld	hl, #_hold_frames
	ld	a, #0xb4
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x08
	ret
;src/game_movie.c:107: case CITY_HOLD:if(action_edge(keys)||!--hold_frames)fade(INTRO_TEXT_OUT,0);break;
00124$:
	ldhl	sp,	#6
	ld	a, (hl)
	call	_action_edge
	or	a, a
	jr	NZ, 00125$
	ld	hl, #_hold_frames
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	or	a, d
	ret	NZ
00125$:
	ld	e, #0x00
	ld	a, #0x09
	jp	_fade
;src/game_movie.c:108: case INTRO_TEXT_OUT:
00128$:
;src/game_movie.c:109: if(fade_done()){game_movie_stage=INTRO_TEXT;start_cutscene(CUTSCENE_INTRO_DIALOGUE);}break;
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_game_movie_stage
	ld	(hl), #0x0a
	ld	a, #0x04
	jp	_start_cutscene
;src/game_movie.c:110: case MYAU_TEXT_OUT:
00131$:
;src/game_movie.c:111: if(fade_done()){game_movie_stage=MYAU_TEXT;start_cutscene(CUTSCENE_LAERMA);}break;
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_game_movie_stage
	ld	(hl), #0x15
	ld	a, #0x05
	jp	_start_cutscene
;src/game_movie.c:112: case FLIGHT_OUT:
00134$:
;src/game_movie.c:113: if(!fade_done())break;
	call	_fade_done
	or	a, a
	ret	Z
;src/game_movie.c:114: DISPLAY_OFF;myau_flight_begin(returning);scene_fade_begin(1);DISPLAY_ON;game_movie_stage=FLIGHT_WAIT;break;
	call	_display_off
	ld	a, (_returning)
	push	af
	inc	sp
	ld	e, #b_myau_flight_begin
	ld	hl, #_myau_flight_begin
	call	___sdcc_bcall_ehl
	inc	sp
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
	ld	hl, #_game_movie_stage
	ld	(hl), #0x17
	ret
;src/game_movie.c:115: case FLIGHT_WAIT:fade(FLIGHT_IN,1);break;
00137$:
	ld	e, #0x01
	ld	a, #0x18
	jp	_fade
;src/game_movie.c:116: case FLIGHT_IN:if(fade_done())game_movie_stage=FLIGHT_MOVE;break;
00138$:
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_game_movie_stage
	ld	(hl), #0x19
	ret
;src/game_movie.c:117: case FLIGHT_MOVE:
00141$:
;src/game_movie.c:118: movie_keys=keys; /* Source A8 handler samples input throughout flight. */
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_movie_keys),a
;src/game_movie.c:119: if(!myau_flight_frame)audio_command(0xb9);
	ld	hl, #_myau_flight_frame + 1
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00143$
	ld	a, #0xb9
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00143$:
;src/game_movie.c:120: if(myau_flight_tick())fade(FLIGHT_END,0);break;
	ld	e, #b_myau_flight_tick
	ld	hl, #_myau_flight_tick
	call	___sdcc_bcall_ehl
	or	a, a
	ret	Z
	ld	e, #0x00
	ld	a, #0x1a
	jp	_fade
;src/game_movie.c:121: case FLIGHT_END:
00146$:
;src/game_movie.c:122: if(!fade_done())break;
	call	_fade_done
	or	a, a
	ret	Z
;src/game_movie.c:123: if(returning){game_movie_mode=0;enter_map(0u,1224u,784u);break;} /*4514:00,40,4C.*/
	ld	a, (#_returning)
	or	a, a
	jr	Z, 00150$
	xor	a, a
	ld	(#_game_movie_mode),a
	ld	de, #0x0310
	push	de
	ld	de, #0x04c8
	xor	a, a
	call	_enter_map
	ret
00150$:
;src/game_movie.c:124: DISPLAY_OFF;gold_scene_show(0u);scene_context_type=14;
	call	_display_off
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_gold_scene_show
	ld	hl, #_gold_scene_show
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_scene_context_type
	ld	(hl), #0x0e
;src/game_movie.c:125: myau_battle_palette(0);scene_fade_begin(1);DISPLAY_ON;game_movie_stage=GOLD_WAIT;break;
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_myau_battle_palette
	ld	hl, #_myau_battle_palette
	call	___sdcc_bcall_ehl
	inc	sp
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
	ld	hl, #_game_movie_stage
	ld	(hl), #0x1b
	ret
;src/game_movie.c:126: case GOLD_WAIT:fade(GOLD_IN,1);break;
00151$:
	ld	e, #0x01
	ld	a, #0x1c
	jp	_fade
;src/game_movie.c:127: case GOLD_IN:if(fade_done()){hold_frames=30;game_movie_stage=GOLD_HOLD;}break;
00152$:
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_hold_frames
	ld	a, #0x1e
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x1d
	ret
;src/game_movie.c:128: case GOLD_HOLD:
00155$:
;src/game_movie.c:129: if(action_edge(keys)||!--hold_frames){game_movie_stage=GOLD_BATTLE;begin_battle(70,3);}break;
	ldhl	sp,	#6
	ld	a, (hl)
	call	_action_edge
	or	a, a
	jr	NZ, 00156$
	ld	hl, #_hold_frames
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	or	a, d
	ret	NZ
00156$:
	ld	hl, #_game_movie_stage
	ld	(hl), #0x1e
	ld	e, #0x03
	ld	a, #0x46
	jp	_begin_battle
;src/game_movie.c:130: case END_OUT:
00159$:
;src/game_movie.c:131: if(!fade_done())break;
	call	_fade_done
	or	a, a
	ret	Z
;src/game_movie.c:132: audio_command(0x8b);DISPLAY_OFF;scene_actor_hide();scene_show(13,0,0);
	ld	a, #0x8b
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	call	_display_off
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	xor	a, a
	rrca
	push	af
	xor	a, a
	ld	a, #0x0d
	push	af
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/game_movie.c:133: scene_fade_begin(1);DISPLAY_ON;game_movie_stage=END_WAIT;break;
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
	ld	hl, #_game_movie_stage
	ld	(hl), #0x29
	ret
;src/game_movie.c:134: case END_WAIT:fade(END_IN,1);break;
00162$:
	ld	e, #0x01
	ld	a, #0x2a
	jp	_fade
;src/game_movie.c:135: case END_IN:if(fade_done()){hold_frames=128;game_movie_stage=END_HOLD;}break;
00163$:
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_hold_frames
	ld	a, #0x80
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x2b
	ret
;src/game_movie.c:136: case END_HOLD:
00166$:
;src/game_movie.c:137: if(!--hold_frames){DISPLAY_OFF;presentation_begin(PRESENT_ENDING_SKY);DISPLAY_ON;game_movie_stage=END_SKY;}break;
	ld	hl, #_hold_frames
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	or	a, d
	ret	NZ
	call	_display_off
	ld	a, #0x04
	push	af
	inc	sp
	ld	e, #b_presentation_begin
	ld	hl, #_presentation_begin
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x2c
	ret
;src/game_movie.c:138: case END_SKY:
00169$:
;src/game_movie.c:139: if(presentation_tick()){text_index=0;game_movie_stage=END_TEXT;start_movie_text(ending_texts[0]);}break;
	ld	e, #b_presentation_tick
	ld	hl, #_presentation_tick
	call	___sdcc_bcall_ehl
	or	a, a
	ret	Z
	xor	a, a
	ld	(#_text_index),a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x2d
	ld	hl, #_ending_texts
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ld	e, c
	ld	d, a
	jp	_start_movie_text
;src/game_movie.c:140: case END_STORY_OUT:
00172$:
;src/game_movie.c:141: if(fade_done()){game_movie_stage=END_STORY;start_cutscene(CUTSCENE_ENDING_DIALOGUE);}break;
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_game_movie_stage
	ld	(hl), #0x2f
	ld	a, #0x06
	jp	_start_cutscene
;src/game_movie.c:142: case END_IMAGE_OUT:
00175$:
;src/game_movie.c:143: if(!fade_done())break;
	call	_fade_done
	or	a, a
	ret	Z
;src/game_movie.c:144: DISPLAY_OFF;scene_actor_hide();movie_scene_show(MOVIE_ENDING_BITMAP);scene_fade_begin(1);DISPLAY_ON;
	call	_display_off
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	ld	a, #0x02
	push	af
	inc	sp
	ld	e, #b_movie_scene_show
	ld	hl, #_movie_scene_show
	call	___sdcc_bcall_ehl
	inc	sp
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
;src/game_movie.c:145: game_movie_stage=END_IMAGE_WAIT;break;
	ld	hl, #_game_movie_stage
	ld	(hl), #0x31
	ret
;src/game_movie.c:146: case END_IMAGE_WAIT:fade(END_IMAGE_IN,1);break;
00178$:
	ld	e, #0x01
	ld	a, #0x32
	jp	_fade
;src/game_movie.c:147: case END_IMAGE_IN:if(fade_done()){hold_frames=208;game_movie_stage=END_IMAGE_HOLD;}break;
00179$:
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_hold_frames
	ld	a, #0xd0
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x33
	ret
;src/game_movie.c:148: case END_IMAGE_HOLD:
00182$:
;src/game_movie.c:149: if(!--hold_frames){DISPLAY_OFF;ending_walk_begin(game_dungeon.dungeon.light);DISPLAY_ON;game_movie_stage=END_WALK;}break;
	ld	hl, #_hold_frames
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	or	a, d
	ret	NZ
	call	_display_off
	ld	a, (#(_game_dungeon + 3) + 0)
	push	af
	inc	sp
	ld	e, #b_ending_walk_begin
	ld	hl, #_ending_walk_begin
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x34
	ret
;src/game_movie.c:150: case END_WALK:
00185$:
;src/game_movie.c:151: if(ending_walk_tick()){game_movie_mode=0;title_choice=saved_position_valid?1u:0u;title_screen();}break;
	ld	e, #b_ending_walk_tick
	ld	hl, #_ending_walk_tick
	call	___sdcc_bcall_ehl
	or	a, a
	ret	Z
	xor	a, a
	ld	(#_game_movie_mode),a
	ld	a, (#_saved_position_valid)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00215$
	xor	a, a
00215$:
	ld	(#_title_choice),a
	ld	e, #b_title_screen
	ld	hl, #_title_screen
	call	___sdcc_bcall_ehl
	ret
;src/game_movie.c:152: case DARK_HOLD:
00188$:
;src/game_movie.c:153: movie_keys=keys;elapsed=audio_clock-fade_clock;fade_clock=audio_clock;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_movie_keys),a
	ld	a, (#_audio_clock)
	ld	hl, #_fade_clock
	sub	a, (hl)
	ld	e, a
	ld	a, (#_audio_clock)
	ld	(#_fade_clock),a
;src/game_movie.c:154: if(hold_frames>elapsed){hold_frames-=elapsed;break;}
	ld	c, e
	ld	b, #0x00
	ld	hl, #_hold_frames
	ld	a, c
	sub	a, (hl)
	inc	hl
	ld	a, b
	sbc	a, (hl)
	jr	NC, 00190$
	ld	a, (_hold_frames)
	ld	hl, #_hold_frames + 1
	ld	b, (hl)
	dec	hl
	ld	d, #0x00
	sub	a, e
	ld	c, a
	ld	a, b
	sbc	a, d
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ret
00190$:
;src/game_movie.c:155: hold_frames=0;
	xor	a, a
	ld	hl, #_hold_frames
	ld	(hl+), a
	ld	(hl), a
;src/game_movie.c:161: if(LY_REG>=144u)LCDC_REG&=(uint8_t)~LCDCF_ON;else DISPLAY_OFF;
	ldh	a, (_LY_REG + 0)
	sub	a, #0x90
	jr	C, 00192$
	ldh	a, (_LCDC_REG + 0)
	and	a, #0x7f
	ldh	(_LCDC_REG + 0), a
	jr	00193$
00192$:
	call	_display_off
00193$:
;src/game_movie.c:162: scene_actor_hide();scene_show(31u,0u,73u);scene_context_type=31u;
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	ld	a, #0x49
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x1f
	push	af
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	hl, #_scene_context_type
	ld	(hl), #0x1f
;src/game_movie.c:163: scene_fade_begin(1);DISPLAY_ON;game_movie_stage=DARK_WAIT;break;
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
	ld	hl, #_game_movie_stage
	ld	(hl), #0x3d
	ret
;src/game_movie.c:164: case DARK_WAIT:
00194$:
;src/game_movie.c:165: movie_keys=keys;fade(DARK_IN,1);break;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_movie_keys),a
	ld	e, #0x01
	ld	a, #0x3e
	jp	_fade
;src/game_movie.c:166: case DARK_IN:
00195$:
;src/game_movie.c:167: movie_keys=keys;if(fade_done())game_movie_stage=DARK_UPLOAD;break;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_movie_keys),a
	call	_fade_done
	or	a, a
	ret	Z
	ld	hl, #_game_movie_stage
	ld	(hl), #0x3f
	ret
;src/game_movie.c:168: case DARK_UPLOAD:
00198$:
;src/game_movie.c:171: movie_keys=keys;hold_frames=30u;game_movie_stage=DARK_REVEAL;break;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_movie_keys),a
	ld	hl, #_hold_frames
	ld	a, #0x1e
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x40
	ret
;src/game_movie.c:172: case DARK_REVEAL:
00199$:
;src/game_movie.c:173: if(action_edge(keys)||!--hold_frames){
	ldhl	sp,	#6
	ld	a, (hl)
	call	_action_edge
	or	a, a
	jr	NZ, 00200$
	ld	hl, #_hold_frames
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	or	a, d
	ret	NZ
00200$:
;src/game_movie.c:176: scene_context_type=32u;game_movie_mode=0;event_advance(&game_events);apply_event();
	ld	hl, #_scene_context_type
	ld	(hl), #0x20
	xor	a, a
	ld	(#_game_movie_mode),a
	ld	de, #_game_events
	push	de
	ld	e, #b_event_advance
	ld	hl, #_event_advance
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
;src/game_movie.c:177: }break;
	ret
;src/game_movie.c:178: case GOV_OUT:
00203$:
;src/game_movie.c:179: if(!fade_done())break;
	call	_fade_done
	or	a, a
	ret	Z
;src/game_movie.c:180: DISPLAY_OFF;scene_actor_hide();scene_show(29u,0u,0u);scene_context_type=29u;
	call	_display_off
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	xor	a, a
	rrca
	push	af
	xor	a, a
	ld	a, #0x1d
	push	af
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	hl, #_scene_context_type
	ld	(hl), #0x1d
;src/game_movie.c:181: event_governor_room_loaded(&game_events);scene_fade_begin(1);DISPLAY_ON;
	ld	de, #_game_events
	push	de
	ld	e, #b_event_governor_room_loaded
	ld	hl, #_event_governor_room_loaded
	call	___sdcc_bcall_ehl
	pop	hl
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
;src/game_movie.c:182: game_movie_stage=GOV_WAIT;break;
	ld	hl, #_game_movie_stage
	ld	(hl), #0x42
	ret
;src/game_movie.c:183: case GOV_WAIT:fade(GOV_IN,1);break;
00206$:
	ld	e, #0x01
	ld	a, #0x43
	jp	_fade
;src/game_movie.c:184: case GOV_IN:
00207$:
;src/game_movie.c:185: if(!fade_done())break;
	call	_fade_done
	or	a, a
	ret	Z
;src/game_movie.c:186: DISPLAY_OFF;scene_portrait_show(53u);DISPLAY_ON;game_movie_stage=GOV_ACTOR;break;
	call	_display_off
	ld	a, #0x35
	push	af
	inc	sp
	ld	e, #b_scene_portrait_show
	ld	hl, #_scene_portrait_show
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_game_movie_stage
	ld	(hl), #0x44
	ret
;src/game_movie.c:187: case GOV_ACTOR:
00210$:
;src/game_movie.c:188: game_movie_mode=0;event_advance(&game_events);apply_event();break;
	xor	a, a
	ld	(#_game_movie_mode),a
	ld	de, #_game_events
	push	de
	ld	e, #b_event_advance
	ld	hl, #_event_advance
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
;src/game_movie.c:189: }
00212$:
;src/game_movie.c:190: }
	ret
	.area _CODE_121
	.area _INITIALIZER
	.area _CABS (ABS)
