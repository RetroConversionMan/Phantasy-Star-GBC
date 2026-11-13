;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module vehicle_cycle
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _audio_command_before_tick
	.globl b_vehicle_palette_cycle
	.globl _vehicle_palette_cycle
	.globl _vehicle_cycle
	.globl b_vehicle_cycle_step
	.globl _vehicle_cycle_step
	.globl b_vehicle_cycle_world_tick
	.globl _vehicle_cycle_world_tick
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_vehicle_cycle::
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
	.area _CODE_118
;src/vehicle_cycle.c:6: uint8_t vehicle_cycle_step(VehicleCycle *s,uint8_t mode,uint8_t remaining) RPG_BANKED {
;	---------------------------------
; Function vehicle_cycle_step
; ---------------------------------
	b_vehicle_cycle_step	= 118
_vehicle_cycle_step::
;src/vehicle_cycle.c:7: if(!mode||mode>=14u)return 0;
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, (hl)
	sub	a, #0x0e
	jr	C, 00102$
00101$:
	xor	a, a
	ret
00102$:
;src/vehicle_cycle.c:8: if(mode!=8u&&!remaining)return 0;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x08
	ld	a, #0x01
	jr	Z, 00158$
	xor	a, a
00158$:
	ld	c, a
	bit	0, c
	jr	NZ, 00105$
	ldhl	sp,	#9
	ld	a, (hl)
	or	a,a
	ret	Z
00105$:
;src/vehicle_cycle.c:9: --s->clock;if(!(s->clock&128u))return 0;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	dec	(hl)
	ld	a, (hl)
	rlca
	jr	C, 00108$
	xor	a, a
	ret
00108$:
;src/vehicle_cycle.c:10: s->clock=3;if(++s->phase>=3u)s->phase=0;
	ld	(hl), #0x03
	ld	a, (de)
	inc	a
	ld	(de), a
	sub	a, #0x03
	jr	C, 00110$
	xor	a, a
	ld	(de), a
00110$:
;src/vehicle_cycle.c:11: return mode==8u?0xd1u:0xd0u;
	ld	a, c
	or	a, a
	ld	a, #0xd1
	ret	NZ
	ld	a, #0xd0
;src/vehicle_cycle.c:12: }
	ret
;src/vehicle_cycle.c:16: void vehicle_cycle_world_tick(uint8_t mode,uint8_t remaining) RPG_BANKED {
;	---------------------------------
; Function vehicle_cycle_world_tick
; ---------------------------------
	b_vehicle_cycle_world_tick	= 118
_vehicle_cycle_world_tick::
;src/vehicle_cycle.c:17: uint8_t command=vehicle_cycle_step(&vehicle_cycle,mode,remaining);
	ldhl	sp,	#7
	ld	a, (hl-)
	ld	d, a
	ld	a, (hl)
	ld	e, a
	push	de
	ld	de, #_vehicle_cycle
	push	de
	ld	e, #b_vehicle_cycle_step
	ld	hl, #_vehicle_cycle_step
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/vehicle_cycle.c:18: if(command) {
;src/vehicle_cycle.c:19: audio_command_before_tick(command);
	or	a,a
	ret	Z
	call	_audio_command_before_tick
;src/vehicle_cycle.c:20: vehicle_palette_cycle(mode,vehicle_cycle.phase);
	ld	a, (#_vehicle_cycle + 0)
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_vehicle_palette_cycle
	ld	hl, #_vehicle_palette_cycle
	call	___sdcc_bcall_ehl
	pop	hl
;src/vehicle_cycle.c:22: }
	ret
	.area _CODE_118
	.area _INITIALIZER
	.area _CABS (ABS)
