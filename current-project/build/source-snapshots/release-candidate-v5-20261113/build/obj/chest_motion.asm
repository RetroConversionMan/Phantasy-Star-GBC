;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module chest_motion
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_chest_motion_begin
	.globl _chest_motion_begin
	.globl b_chest_motion_tick
	.globl _chest_motion_tick
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
	.area _CODE_31
;src/chest_motion.c:5: void chest_motion_begin(ChestMotion *m,uint8_t visual) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function chest_motion_begin
; ---------------------------------
	b_chest_motion_begin	= 31
_chest_motion_begin::
;src/chest_motion.c:6: m->frame=0x3a;m->timer=7;m->visual=visual;m->phase=0;m->active=1;m->hold=0;m->deferred=0;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x3a
	ld	(bc), a
	ld	l, c
	ld	h, b
	inc	hl
	ld	(hl), #0x07
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(de), a
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x00
	ld	hl, #0x0004
	add	hl, bc
	ld	(hl), #0x01
	ld	hl, #0x0005
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x0006
	add	hl, bc
	ld	(hl), #0x00
;src/chest_motion.c:7: }
	ret
;src/chest_motion.c:8: uint8_t chest_motion_tick(ChestMotion *m) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function chest_motion_tick
; ---------------------------------
	b_chest_motion_tick	= 31
_chest_motion_tick::
	add	sp, #-12
;src/chest_motion.c:9: if(!m->active)return 0;
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a,a
	jp	Z, 00126$
;src/chest_motion.c:10: if(m->hold){if(--m->hold)return 0;m->frame=m->deferred;return CHEST_MOTION_FRAME;}
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ld	a, c
	or	a, a
	jr	Z, 00106$
	ld	a, c
	dec	a
	pop	hl
	push	hl
	ld	(hl), a
	or	a, a
	jr	Z, 00104$
	xor	a, a
	jp	00126$
00104$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, #0x01
	jp	00126$
00106$:
;src/chest_motion.c:11: if(m->phase==3u){m->active=0;return CHEST_MOTION_DONE;}
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	cp	a, #0x03
	jr	NZ, 00108$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	a, #0x08
	jp	00126$
00108$:
;src/chest_motion.c:12: if(m->timer){--m->timer;return 0;}
	ldhl	sp,	#18
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	bc
	push	af
	ld	a, (bc)
	ld	e, a
	pop	af
	inc	e
	dec	e
	jr	Z, 00110$
	ld	a, e
	dec	a
	ld	(bc), a
	xor	a, a
	jp	00126$
00110$:
;src/chest_motion.c:13: if(!m->phase){++m->frame;m->timer=7;if(m->frame==0x3du){m->phase=1;m->timer=23;}return CHEST_MOTION_FRAME;}
	or	a, a
	jr	NZ, 00114$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	inc	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, #0x07
	ld	(bc), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x3d
	jr	NZ, 00112$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ld	a, #0x17
	ld	(bc), a
00112$:
	ld	a, #0x01
	jp	00126$
00114$:
;src/chest_motion.c:14: m->timer=3;
	ld	a, #0x03
	ld	(bc), a
;src/chest_motion.c:15: if(m->phase==1u){m->frame=m->visual;m->phase=m->visual==0x3du?3u:2u;return CHEST_MOTION_FRAME|(m->phase==2u?CHEST_MOTION_SOUND:0u);}
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	dec	c
	jr	NZ, 00116$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#10
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x3d
	jr	NZ, 00128$
	ld	(hl), #0x03
	jr	00129$
00128$:
	ldhl	sp,	#9
	ld	(hl), #0x02
00129$:
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x02
	ld	a, #0x02
	jr	Z, 00131$
	xor	a, a
00131$:
	set	0, a
	jr	00126$
00116$:
;src/chest_motion.c:13: if(!m->phase){++m->frame;m->timer=7;if(m->frame==0x3du){m->phase=1;m->timer=23;}return CHEST_MOTION_FRAME;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#11
;src/chest_motion.c:16: if((m->visual==0x3eu&&m->frame==0x41u)||(m->visual==0x43u&&m->frame==0x46u)){
	ld	(hl-), a
	ld	a, (hl)
	sub	a, #0x3e
	jr	NZ, 00123$
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, #0x41
	jr	Z, 00119$
00123$:
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x43
	jr	NZ, 00120$
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, #0x46
	jr	NZ, 00120$
00119$:
;src/chest_motion.c:17: m->hold=10;m->deferred=m->visual==0x3eu?0x42u:0x3du;
	pop	hl
	ld	(hl), #0x0a
	push	hl
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x3e
	ld	a, #0x42
	jr	Z, 00133$
	ld	a, #0x3d
00133$:
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/chest_motion.c:18: if(m->visual==0x43u)m->phase=3;return CHEST_MOTION_FLASH;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x43
	jr	NZ, 00118$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
00118$:
	ld	a, #0x04
	jr	00126$
00120$:
;src/chest_motion.c:20: ++m->frame;if(m->frame==0x43u){m->frame=0x3d;m->phase=3;}return CHEST_MOTION_FRAME;
	ldhl	sp,	#11
	ld	a, (hl)
	inc	a
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	sub	a, #0x43
	jr	NZ, 00125$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x3d
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
00125$:
	ld	a, #0x01
00126$:
;src/chest_motion.c:21: }
	add	sp, #12
	ret
	.area _CODE_31
	.area _INITIALIZER
	.area _CABS (ABS)
