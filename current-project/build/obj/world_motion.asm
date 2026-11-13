;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module world_motion
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_bkg_phase
	.globl _world_motion_road
	.globl _world_motion_phase
	.globl _world_motion_countdown
	.globl b_world_motion_reset
	.globl _world_motion_reset
	.globl b_world_motion_step
	.globl _world_motion_step
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_world_motion_countdown::
	.ds 6
_world_motion_phase::
	.ds 6
_world_motion_road::
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
	.area _CODE_21
;src/world_motion.c:9: void world_motion_reset(uint8_t road) WORLD_MOTION_BANKED {
;	---------------------------------
; Function world_motion_reset
; ---------------------------------
	b_world_motion_reset	= 21
_world_motion_reset::
;src/world_motion.c:11: world_motion_road=road;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_world_motion_road),a
;src/world_motion.c:12: for(i=0;i<6u;++i)world_motion_countdown[i]=world_motion_phase[i]=0;
	ld	c, #0x00
00102$:
	ld	a, #<(_world_motion_countdown)
	add	a, c
	ld	e, a
	ld	a, #>(_world_motion_countdown)
	adc	a, #0x00
	ld	d, a
	ld	hl, #_world_motion_phase
	ld	b, #0x00
	add	hl, bc
	ld	(hl), #0x00
	xor	a, a
	ld	(de), a
	inc	c
	ld	a, c
	sub	a, #0x06
	jr	C, 00102$
;src/world_motion.c:13: }
	ret
;src/world_motion.c:14: uint8_t world_motion_step(void) WORLD_MOTION_BANKED {
;	---------------------------------
; Function world_motion_step
; ---------------------------------
	b_world_motion_step	= 21
_world_motion_step::
	add	sp, #-7
;src/world_motion.c:17: if(world_group_id>=11u)return 255u;
	ld	a, (#_world_group_id)
	sub	a, #0x0b
	jr	C, 00102$
	ld	a, #0xff
	jp	00117$
00102$:
;src/world_motion.c:18: for(i=0;i<6u;++i) {
	ldhl	sp,	#0
	ld	(hl), #0x00
	ldhl	sp,	#6
	ld	(hl), #0x00
00116$:
;src/world_motion.c:19: if(world_motion_road ? i!=3u : !world_motion_enables[world_group_id][i])continue;
	ld	a, (#_world_motion_road)
	or	a, a
	jr	Z, 00119$
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x03
	ld	a, #0x01
	jr	Z, 00194$
	xor	a, a
00194$:
	xor	a, #0x01
	jr	00120$
00119$:
	ld	hl, #_world_group_id
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc, #_world_motion_enables
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x01
	ld	a, #0x00
	rla
00120$:
	or	a, a
	jp	NZ, 00114$
;src/world_motion.c:21: --world_motion_countdown[i];
	ld	bc, #_world_motion_countdown+0
	ldhl	sp,	#6
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	dec	a
	ld	(bc), a
;src/world_motion.c:22: if(!(world_motion_countdown[i]&128u))continue;
	rlca
	jp	NC, 00114$
;src/world_motion.c:23: world_motion_countdown[i]=world_motion_road?0u:world_motion_reloads[i];
	ld	a, (#_world_motion_road)
	or	a, a
	jr	Z, 00121$
	xor	a, a
	jr	00122$
00121$:
	ld	de, #_world_motion_reloads+0
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
00122$:
	ld	(bc), a
;src/world_motion.c:24: if(world_motion_road>=4u)--world_motion_phase[i];
	ld	a, (#_world_motion_road)
	sub	a, #0x04
	jr	C, 00108$
	ld	bc, #_world_motion_phase+0
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	dec	a
	ld	(bc), a
	jr	00109$
00108$:
;src/world_motion.c:25: else ++world_motion_phase[i];
	ld	bc, #_world_motion_phase+0
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	ld	(bc), a
00109$:
;src/world_motion.c:26: phase=world_motion_phase[i]&7u;
	ld	bc, #_world_motion_phase+0
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	and	a, #0x07
	ld	c, a
;src/world_motion.c:27: if(world_group_id<2u) {
	ld	hl, #_world_group_id
	ld	a, (hl)
	sub	a, #0x02
	jp	NC, 00113$
;src/world_motion.c:28: slot=&world_motion_slots[world_group_id][i];
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_world_motion_slots
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	ld	e, a
	add	a, a
	add	a, e
	add	a, a
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	b, l
	ld	a, h
	ldhl	sp,	#1
	ld	(hl), b
	inc	hl
;src/world_motion.c:29: if(slot->count)bank_bkg_phase(slot->bank,slot->tile,slot->count,
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	inc	de
	inc	de
	ld	a, (de)
	ld	(hl), a
	or	a, a
	jr	Z, 00113$
;src/world_motion.c:30: slot->frames+(uint16_t)phase*slot->count*16u,slot->vram_bank);
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	inc	de
	inc	de
	inc	de
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	e, c
	xor	a, a
	ldhl	sp,	#3
	ld	c, (hl)
	ld	b, #0x00
	ld	d, a
	call	__mulint
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
;src/world_motion.c:29: if(slot->count)bank_bkg_phase(slot->bank,slot->tile,slot->count,
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	a, (de)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	h, (hl)
	push	hl
	inc	sp
	push	bc
	ldhl	sp,	#6
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#10
	ld	e, (hl)
	call	_bank_bkg_phase
00113$:
;src/world_motion.c:32: return i;
	ldhl	sp,	#0
	ld	a, (hl)
	jr	00117$
00114$:
;src/world_motion.c:18: for(i=0;i<6u;++i) {
	ldhl	sp,	#6
	inc	(hl)
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x06
	jp	C, 00116$
;src/world_motion.c:34: return 255u;
	ld	a, #0xff
00117$:
;src/world_motion.c:35: }
	add	sp, #7
	ret
	.area _CODE_21
	.area _INITIALIZER
	.area _CABS (ABS)
