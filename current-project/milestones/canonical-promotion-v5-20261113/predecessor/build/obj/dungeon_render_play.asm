;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_render_play
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_dungeon_motion_render
	.globl _dungeon_motion_render
	.globl _dungeon_render_phase
	.globl _dungeon_render_scratch
	.globl _dungeon_render_palette
	.globl _dungeon_render_map
	.globl b_dungeon_render
	.globl _dungeon_render
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_dungeon_render_map::
	.ds 600
_dungeon_render_palette::
	.ds 56
_dungeon_render_scratch::
	.ds 1540
_dungeon_render_phase::
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
	.area _CODE_17
;src/dungeon_render_play.c:15: uint8_t dungeon_render(const DungeonState *state,uint8_t frame) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_render
; ---------------------------------
	b_dungeon_render	= 17
_dungeon_render::
;src/dungeon_render_play.c:17: return dungeon_motion_render(state,frame);
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_motion_render
	ld	hl, #_dungeon_motion_render
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_render_play.c:22: }
	ret
	.area _CODE_17
	.area _INITIALIZER
	.area _CABS (ABS)
