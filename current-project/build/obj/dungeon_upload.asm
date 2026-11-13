;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_upload
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _dungeon_motion_invalidate
	.globl _dungeon_uploaded_patterns
	.globl _dungeon_invalidate_view_cache
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_dungeon_uploaded_patterns::
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
;src/dungeon_upload.c:10: void dungeon_invalidate_view_cache(void) BANK_IO_FIXED {dungeon_motion_invalidate();}
;	---------------------------------
; Function dungeon_invalidate_view_cache
; ---------------------------------
_dungeon_invalidate_view_cache::
	jp	_dungeon_motion_invalidate
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE_0
	.area _CODE_0
	.area _INITIALIZER
	.area _CABS (ABS)
