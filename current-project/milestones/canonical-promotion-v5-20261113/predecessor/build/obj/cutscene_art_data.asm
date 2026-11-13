;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module cutscene_art_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _cutscene_portraits
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
	.area _CODE_12
_cutscene_portraits:
	.db #0x74	; 116	't'
	.dw #0x0068
	.dw _cutscene_portrait_0
	.db #0x74	; 116	't'
	.dw #0x005f
	.dw _cutscene_portrait_1
	.db #0x74	; 116	't'
	.dw #0x0051
	.dw _cutscene_portrait_2
	.db #0x74	; 116	't'
	.dw #0x0063
	.dw _cutscene_portrait_3
	.db #0x74	; 116	't'
	.dw #0x005b
	.dw _cutscene_portrait_4
	.db #0x74	; 116	't'
	.dw #0x0050
	.dw _cutscene_portrait_5
	.db #0x74	; 116	't'
	.dw #0x0065
	.dw _cutscene_portrait_6
	.db #0x75	; 117	'u'
	.dw #0x0072
	.dw _cutscene_portrait_7
	.db #0x75	; 117	'u'
	.dw #0x005d
	.dw _cutscene_portrait_8
	.area _INITIALIZER
	.area _CABS (ABS)
