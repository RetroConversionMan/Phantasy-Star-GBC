;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module presentation_credits_stub
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_ending_walk_begin
	.globl _ending_walk_begin
	.globl b_ending_walk_tick
	.globl _ending_walk_tick
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
	.area _CODE_121
;tests/presentation_credits_stub.c:6: void ending_walk_begin(uint8_t light) WORLD_BANKED {(void)light;}
;	---------------------------------
; Function ending_walk_begin
; ---------------------------------
	b_ending_walk_begin	= 121
_ending_walk_begin::
	ret
;tests/presentation_credits_stub.c:7: uint8_t ending_walk_tick(void) WORLD_BANKED {return 0;}
;	---------------------------------
; Function ending_walk_tick
; ---------------------------------
	b_ending_walk_tick	= 121
_ending_walk_tick::
	xor	a, a
	ret
	.area _CODE_121
	.area _INITIALIZER
	.area _CABS (ABS)
