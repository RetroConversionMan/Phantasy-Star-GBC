;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_production_tables
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _dungeon_graphic_palettes
	.globl _dungeon_view_front
	.globl _dungeon_view_index
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
	.area _CODE_0
	.area _CODE_0
_dungeon_view_index:
	.db #0x14	; 20
	.dw _dungeon_production_data
_dungeon_view_front:
	.db #0x14	; 20
	.dw (_dungeon_production_data + 8192)
_dungeon_graphic_palettes:
	.db #0x14	; 20
	.dw (_dungeon_production_data + 8224)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 8628)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 9032)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 9436)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 9840)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 10244)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 10648)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 11052)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 11456)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 11860)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 12264)
	.db #0x14	; 20
	.dw (_dungeon_production_data + 12668)
	.area _INITIALIZER
	.area _CABS (ABS)
