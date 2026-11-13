;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module battle_motion
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_enemy_magic_animation
	.globl _enemy_magic_animation
	.globl _bank_read8
	.globl b_battle_motion_begin
	.globl _battle_motion_begin
	.globl b_battle_motion_begin_magic
	.globl _battle_motion_begin_magic
	.globl b_battle_motion_tick
	.globl _battle_motion_tick
	.globl b_battle_motion_asset
	.globl _battle_motion_asset
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
;src/battle_motion.c:8: uint8_t battle_motion_begin(BattleMotion *m,uint8_t enemy) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function battle_motion_begin
; ---------------------------------
	b_battle_motion_begin	= 31
_battle_motion_begin::
	dec	sp
	dec	sp
;src/battle_motion.c:10: m->active=0;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	inc	sp
	inc	sp
	ld	(hl), #0x00
	push	hl
;src/battle_motion.c:11: if(!enemy||enemy>74u)return 0;
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x4a
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jr	00106$
00102$:
;src/battle_motion.c:12: a=battle_animations+enemy-1u;if(!a->length)return 0;
	ldhl	sp,	#10
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	bc, #_battle_animations
	add	hl, bc
	ld	bc, #0xfff9
	add	hl,bc
	ld	c,l
	ld	b,h
	inc	hl
	ld	a, (hl)
	or	a,a
	jr	Z, 00106$
;src/battle_motion.c:13: m->enemy=enemy;m->frame=a->first_frame;m->timer=a->speed;m->cursor=1;m->phase=0;m->active=1;return 1;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl-)
	dec	hl
	ld	(de), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	ld	a, (bc)
	ld	(de), a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x01
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	pop	hl
	ld	a, #0x01
	ld	(hl), a
	push	hl
00106$:
;src/battle_motion.c:14: }
	inc	sp
	inc	sp
	ret
;src/battle_motion.c:15: uint8_t battle_motion_begin_magic(BattleMotion *m,uint8_t enemy) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function battle_motion_begin_magic
; ---------------------------------
	b_battle_motion_begin_magic	= 31
_battle_motion_begin_magic::
	add	sp, #-11
;src/battle_motion.c:16: BattleAnimation a;m->active=0;if(!enemy_magic_animation(enemy,&a))return 0;
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0005
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	hl, #0
	add	hl, sp
	push	bc
	push	hl
	ldhl	sp,	#23
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_enemy_magic_animation
	ld	hl, #_enemy_magic_animation
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	or	a,a
	jr	Z, 00103$
;src/battle_motion.c:17: m->enemy=enemy|128u;m->frame=a.first_frame;m->timer=a.speed;m->cursor=1;m->phase=0;m->active=1;return 1;
	ldhl	sp,	#19
	ld	a, (hl)
	set	7, a
	ld	(bc), a
	ld	e, c
	ld	d, b
	inc	de
	ld	hl,#0x3
	add	hl,sp
	ld	a, (hl)
	ld	(de), a
	ld	hl, #0x0002
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#9
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x01
	ld	hl, #0x0004
	add	hl, bc
	ld	(hl), #0x00
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x01
	ld	(hl),a
00103$:
;src/battle_motion.c:18: }
	add	sp, #11
	ret
;src/battle_motion.c:19: uint8_t battle_motion_tick(BattleMotion *m) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function battle_motion_tick
; ---------------------------------
	b_battle_motion_tick	= 31
_battle_motion_tick::
	add	sp, #-20
;src/battle_motion.c:21: if(!m->active)return 0;
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	or	a,a
	jp	Z, 00114$
;src/battle_motion.c:22: if(m->phase==2u){m->active=0;return BATTLE_MOTION_DONE;}
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x02
	jr	NZ, 00104$
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	a, #0x04
	jp	00114$
00104$:
;src/battle_motion.c:23: if(m->timer){--m->timer;return 0;}
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl),a
	or	a,a
	jr	Z, 00106$
	inc	hl
	dec	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	xor	a, a
	jp	00114$
00106$:
;src/battle_motion.c:24: if(m->enemy&128u){enemy_magic_animation(m->enemy&127u,&local);a=&local;}
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#17
	ld	(hl), a
	push	hl
	bit	7, (hl)
	pop	hl
	jr	Z, 00108$
	ldhl	sp,	#2
	ld	c, l
	ld	b, h
	ldhl	sp,	#17
	ld	a, (hl)
	and	a, #0x7f
	push	bc
	push	bc
	push	af
	inc	sp
	ld	e, #b_enemy_magic_animation
	ld	hl, #_enemy_magic_animation
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	ldhl	sp,	#16
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	jr	00109$
00108$:
;src/battle_motion.c:25: else a=battle_animations+m->enemy-1u;
	ldhl	sp,	#17
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	de, #_battle_animations
	add	hl, de
	ld	de, #0xfff9
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#16
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
00109$:
;src/battle_motion.c:26: m->timer=a->speed;
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/battle_motion.c:27: frame=bank_read8(a->bank,a->data+m->cursor++);
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	a
	push	hl
	ldhl	sp,	#13
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	pop	hl
	ld	a, l
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	e, c
	ld	d, b
	call	_bank_read8
	ld	c, a
	ld	b, c
;src/battle_motion.c:28: if(frame){m->frame=frame;return BATTLE_MOTION_FRAME;}
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl), a
	ld	a, c
	or	a, a
	jr	Z, 00111$
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), b
	ld	a, #0x01
	jr	00114$
00111$:
;src/battle_motion.c:29: if(!m->phase){m->phase=1;return BATTLE_MOTION_IMPACT;}
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00113$
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), #0x01
	ld	a, #0x02
	jr	00114$
00113$:
;src/battle_motion.c:30: m->frame=bank_read8(a->bank,a->data);m->cursor=1;m->phase=2;return BATTLE_MOTION_FRAME;
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#18
	ld	(hl), a
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#19
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl)
	call	_bank_read8
	ldhl	sp,	#15
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x02
	ld	a, #0x01
00114$:
;src/battle_motion.c:31: }
	add	sp, #20
	ret
;src/battle_motion.c:32: uint16_t battle_motion_asset(uint8_t enemy,uint8_t frame,uint8_t palette) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function battle_motion_asset
; ---------------------------------
	b_battle_motion_asset	= 31
_battle_motion_asset::
	add	sp, #-9
;src/battle_motion.c:34: if(!enemy||enemy>74u||palette>11u)return 65535u;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x4a
	sub	a, (hl)
	jr	C, 00101$
	inc	hl
	inc	hl
	ld	a, #0x0b
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	ld	bc, #0xffff
	jp	00111$
00102$:
;src/battle_motion.c:35: a=battle_animations+enemy-1u;p=a->data+a->length;
	ldhl	sp,	#15
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	bc, #_battle_animations
	add	hl, bc
	ld	a, l
	add	a, #0xf9
	ld	c, a
	ld	a, h
	adc	a, #0xff
	ldhl	sp,	#0
	ld	(hl), c
	inc	hl
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0005
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	inc	de
	ld	a, (de)
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
;src/battle_motion.c:36: for(i=0;i<a->frames;++i,p+=25u)if(bank_read8(a->bank,p)==frame){
	pop	de
	push	de
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
00109$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl)
	sub	a, c
	jr	NC, 00107$
	inc	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	bc
	call	_bank_read8
	ld	e, a
	pop	bc
	ldhl	sp,	#16
	ld	a, (hl)
	sub	a, e
	jr	NZ, 00110$
;src/battle_motion.c:37: p+=1u+(uint16_t)palette*2u;lo=bank_read8(a->bank,p);hi=bank_read8(a->bank,p+1u);return lo|((uint16_t)hi<<8);
	ldhl	sp,	#17
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sla	e
	rl	d
	inc	de
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (bc)
	push	bc
	call	_bank_read8
	ldhl	sp,	#8
	ld	(hl), a
	pop	bc
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	a, (bc)
	call	_bank_read8
	ld	b, a
	ldhl	sp,	#6
	ld	e, (hl)
	xor	a, a
	ld	c, e
	jr	00111$
00110$:
;src/battle_motion.c:36: for(i=0;i<a->frames;++i,p+=25u)if(bank_read8(a->bank,p)==frame){
	ldhl	sp,	#6
	inc	(hl)
	inc	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0019
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	jp	00109$
00107$:
;src/battle_motion.c:39: return 65535u;
	ld	bc, #0xffff
00111$:
;src/battle_motion.c:40: }
	add	sp, #9
	ret
	.area _CODE_31
	.area _INITIALIZER
	.area _CABS (ABS)
