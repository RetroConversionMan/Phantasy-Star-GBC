;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module world_motion_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _world_motion_slots
	.globl _world_motion_reloads
	.globl _world_motion_enables
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
	.area _CODE_21
	.area _CODE_21
_world_motion_enables:
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_world_motion_reloads:
	.db #0x1f	; 31
	.db #0x0f	; 15
	.db #0x0f	; 15
	.db #0x03	; 3
	.db #0x0f	; 15
	.db #0x07	; 7
_world_motion_slots:
	.db #0x18	; 24
	.db #0x03	; 3
	.db #0x0c	; 12
	.db #0x00	; 0
	.dw _world_motion_g0_s0
	.db #0x18	; 24
	.db #0x0f	; 15
	.db #0x03	; 3
	.db #0x00	; 0
	.dw _world_motion_g0_s1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.dw #0x0000
	.db #0x18	; 24
	.db #0x12	; 18
	.db #0x06	; 6
	.db #0x00	; 0
	.dw _world_motion_g0_s3
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x08	; 8
	.db #0x00	; 0
	.dw _world_motion_g0_s4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.dw #0x0000
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.dw #0x0000
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.dw #0x0000
	.db #0x19	; 25
	.db #0x0f	; 15
	.db #0x04	; 4
	.db #0x00	; 0
	.dw _world_motion_g1_s2
	.db #0x19	; 25
	.db #0x13	; 19
	.db #0x03	; 3
	.db #0x00	; 0
	.dw _world_motion_g1_s3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.dw #0x0000
	.db #0x19	; 25
	.db #0x16	; 22
	.db #0x10	; 16
	.db #0x00	; 0
	.dw _world_motion_g1_s5
	.area _INITIALIZER
	.area _CABS (ABS)
