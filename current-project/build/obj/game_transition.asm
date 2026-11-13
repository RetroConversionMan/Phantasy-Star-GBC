;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module game_transition
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_scene_fade_step
	.globl _scene_fade_step
	.globl b_scene_fade_begin
	.globl _scene_fade_begin
	.globl b_audio_command
	.globl _audio_command
	.globl _vsync
	.globl _joypad
	.globl _game_map_music
	.globl _game_fade_clock
	.globl b_game_transition_vint16
	.globl _game_transition_vint16
	.globl b_game_transition_map_music
	.globl _game_transition_map_music
	.globl b_game_transition_interaction_music
	.globl _game_transition_interaction_music
	.globl b_game_transition_wait
	.globl _game_transition_wait
	.globl b_game_transition_close
	.globl _game_transition_close
	.globl b_game_transition_fade_out
	.globl _game_transition_fade_out
	.globl b_game_transition_fade_in
	.globl _game_transition_fade_in
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_game_fade_clock::
	.ds 1
_game_map_music::
	.ds 1
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
	.area _CODE_29
;src/game_transition.c:10: uint8_t game_transition_vint16(void) RPG_BANKED {
;	---------------------------------
; Function game_transition_vint16
; ---------------------------------
	b_game_transition_vint16	= 29
_game_transition_vint16::
;src/game_transition.c:12: --game_fade_clock;if(!(game_fade_clock&128u))return 0;
	ld	hl, #_game_fade_clock
	dec	(hl)
	ld	a, (hl)
	rlca
	jr	C, 00102$
	xor	a, a
	ret
00102$:
;src/game_transition.c:13: game_fade_clock=3u;return 1;
	ld	hl, #_game_fade_clock
	ld	(hl), #0x03
	ld	a, #0x01
;src/game_transition.c:14: }
	ret
;src/game_transition.c:15: void game_transition_map_music(uint8_t command) RPG_BANKED {
;	---------------------------------
; Function game_transition_map_music
; ---------------------------------
	b_game_transition_map_music	= 29
_game_transition_map_music::
;src/game_transition.c:16: if(command!=game_map_music){game_map_music=command;audio_command(command);}
	ldhl	sp,	#6
	ld	a, (hl)
	ld	hl, #_game_map_music
	sub	a, (hl)
	ret	Z
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_game_map_music),a
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_transition.c:17: }
	ret
;src/game_transition.c:18: uint8_t game_transition_interaction_music(uint8_t type) RPG_BANKED {
;	---------------------------------
; Function game_transition_interaction_music
; ---------------------------------
	b_game_transition_interaction_music	= 29
_game_transition_interaction_music::
;src/game_transition.c:20: return tracks[(type>=15u?type-15u:0u)&15u];
	ldhl	sp,	#6
	ld	a,(hl)
	cp	a,#0x0f
	jr	C, 00103$
	add	a, #0xf1
	jr	00104$
00103$:
	xor	a, a
00104$:
	and	a, #0x0f
	ld	l, a
	ld	h, #0x00
	ld	de, #_game_transition_interaction_music_tracks_10000_201
	add	hl, de
	ld	a, (hl)
;src/game_transition.c:21: }
	ret
_game_transition_interaction_music_tracks_10000_201:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x8d	; 141
	.db #0x8d	; 141
	.db #0x8e	; 142
	.db #0x8e	; 142
	.db #0x8e	; 142
	.db #0x8e	; 142
	.db #0x8e	; 142
	.db #0x8e	; 142
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
;src/game_transition.c:22: void game_transition_wait(uint8_t frames,uint8_t sample_input) RPG_BANKED {
;	---------------------------------
; Function game_transition_wait
; ---------------------------------
	b_game_transition_wait	= 29
_game_transition_wait::
;src/game_transition.c:23: while(frames--){
	ldhl	sp,	#6
	ld	c, (hl)
00103$:
	ld	a, c
	dec	c
	or	a, a
	ret	Z
;src/game_transition.c:25: vsync();if(sample_input)last_keys=joypad();
	call	_vsync
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	call	_joypad
	ld	(#_last_keys),a
;src/game_transition.c:30: }
	jr	00103$
;src/game_transition.c:31: void game_transition_close(void) RPG_BANKED {
;	---------------------------------
; Function game_transition_close
; ---------------------------------
	b_game_transition_close	= 29
_game_transition_close::
;src/game_transition.c:33: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;src/game_transition.c:37: game_transition_wait(6u,0u);
	ld	hl, #0x06
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_transition.c:38: }
	ret
;src/game_transition.c:39: static void fade_wait(uint8_t in) {
;	---------------------------------
; Function fade_wait
; ---------------------------------
_fade_wait:
	ld	c, a
;src/game_transition.c:41: while(step<(in?10u:9u)){
	ld	b, #0x00
00107$:
	ld	a, c
	or	a, a
	ld	e, #0x0a
	jr	NZ, 00113$
	ld	e, #0x09
00113$:
	ld	a, b
	sub	a, e
	ret	NC
;src/game_transition.c:42: if(game_transition_vint16()){
	push	bc
	ld	e, #b_game_transition_vint16
	ld	hl, #_game_transition_vint16
	call	___sdcc_bcall_ehl
	pop	bc
	or	a, a
	jr	Z, 00105$
;src/game_transition.c:43: ++step;
	inc	b
;src/game_transition.c:45: if(step<=9u)scene_fade_step(step,in);
	ld	a, #0x09
	sub	a, b
	jr	C, 00102$
	push	bc
	ld	a, c
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	e, #b_scene_fade_step
	ld	hl, #_scene_fade_step
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	jr	00107$
00102$:
;src/game_transition.c:46: else game_transition_wait(1u,0u);
	push	bc
	ld	hl, #0x01
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	jr	00107$
00105$:
;src/game_transition.c:48: } else game_transition_wait(1u,0u);
	push	bc
	ld	hl, #0x01
	push	hl
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
;src/game_transition.c:50: }
	jr	00107$
;src/game_transition.c:51: void game_transition_fade_out(void) RPG_BANKED {
;	---------------------------------
; Function game_transition_fade_out
; ---------------------------------
	b_game_transition_fade_out	= 29
_game_transition_fade_out::
;src/game_transition.c:53: scene_fade_begin(0u);
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_scene_fade_begin
	ld	hl, #_scene_fade_begin
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_transition.c:55: fade_wait(0u);
	xor	a, a
;src/game_transition.c:56: }
	jp	_fade_wait
;src/game_transition.c:57: void game_transition_fade_in(void) RPG_BANKED {fade_wait(1u);}
;	---------------------------------
; Function game_transition_fade_in
; ---------------------------------
	b_game_transition_fade_in	= 29
_game_transition_fade_in::
	ld	a, #0x01
	jp	_fade_wait
	.area _CODE_29
	.area _INITIALIZER
	.area _CABS (ABS)
