;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module boss_motion
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_copy
	.globl _bank_read8
	.globl _memset
	.globl b_boss_motion_begin
	.globl _boss_motion_begin
	.globl b_boss_motion_tick
	.globl _boss_motion_tick
	.globl b_boss_motion_asset
	.globl _boss_motion_asset
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
;src/boss_motion.c:8: uint8_t boss_motion_begin(BossMotion *m,uint8_t enemy,uint8_t target) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function boss_motion_begin
; ---------------------------------
	b_boss_motion_begin	= 31
_boss_motion_begin::
	add	sp, #-10
;src/boss_motion.c:9: BattleAnimation a;memset(m,0,sizeof *m);if((enemy!=72u&&enemy!=73u)||target>3u)return 0;
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x000a
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#18
	ld	a, (hl)
	sub	a, #0x48
	ld	a, #0x01
	jr	Z, 00133$
	xor	a, a
00133$:
	ld	e, a
	bit	0, e
	jr	NZ, 00104$
	ldhl	sp,	#18
	ld	a, (hl)
	sub	a, #0x49
	jr	NZ, 00101$
00104$:
	ld	a, #0x03
	ldhl	sp,	#19
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jr	00105$
00102$:
;src/boss_motion.c:10: m->variant=enemy==72u?target:4u;m->y=enemy==72u?255u:79u;
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#7
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	a, e
	or	a, a
	jr	Z, 00107$
	ldhl	sp,	#19
	ld	e, (hl)
	jr	00108$
00107$:
	ld	e, #0x04
00108$:
	ldhl	sp,	#9
	ld	(hl), e
	dec	hl
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	push	af
	ld	a, (hl)
	ld	(de), a
	pop	af
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	or	a, a
	ld	a, #0xff
	jr	NZ, 00110$
	ld	a, #0x4f
00110$:
	ld	(de), a
;src/boss_motion.c:11: bank_copy(&a,BOSS_DATA_BANK,boss_animations+m->variant,sizeof a);
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	e, a
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	ld	de, #_boss_animations
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #0x0007
	push	hl
	push	de
	ld	a, #0xfe
	ld	hl, #6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
	pop	bc
;src/boss_motion.c:12: m->timer=a.speed;m->cursor=1;m->active=1;return 1;
	ld	hl, #0x0003
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	hl, #0x0004
	add	hl, bc
	ld	(hl), #0x01
	ld	hl, #0x0009
	add	hl, bc
	ld	a,#0x01
	ld	(hl),a
00105$:
;src/boss_motion.c:13: }
	add	sp, #10
	ret
;src/boss_motion.c:14: uint8_t boss_motion_tick(BossMotion *m) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function boss_motion_tick
; ---------------------------------
	b_boss_motion_tick	= 31
_boss_motion_tick::
	add	sp, #-16
;src/boss_motion.c:16: if(!m->active)return 0;
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a,a
	jp	Z, 00124$
;src/boss_motion.c:17: if(m->stage==5u){m->active=0;return BOSS_MOTION_DONE;}
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
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
	ld	a, (de)
	ld	c, a
	sub	a, #0x05
	jr	NZ, 00104$
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	a, #0x08
	jp	00124$
00104$:
;src/boss_motion.c:18: if(m->variant==4u&&m->stage!=2u){
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#15
	ld	(hl), a
	sub	a, #0x04
	jr	NZ, 00108$
	ld	a, c
	sub	a, #0x02
	jr	Z, 00108$
;src/boss_motion.c:19: if(m->stage_timer){--m->stage_timer;return 0;}
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00106$
	dec	a
	ld	(bc), a
	xor	a, a
	jp	00124$
00106$:
;src/boss_motion.c:20: m->stage_timer=7;++m->stage;
	ld	a, #0x07
	ld	(bc), a
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	c
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
;src/boss_motion.c:21: m->patch=m->stage==2u?2u:m->stage==5u?0u:1u;return BOSS_MOTION_PATCH;
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00126$
	dec	hl
	dec	hl
	ld	(hl), #0x02
	jr	00127$
00126$:
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x05
	jr	NZ, 00128$
	xor	a, a
	jr	00129$
00128$:
	ld	a, #0x01
00129$:
	ldhl	sp,	#13
	ld	(hl), a
00127$:
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, #0x04
	jp	00124$
00108$:
;src/boss_motion.c:23: if(m->timer){--m->timer;return 0;}
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	or	a, a
	jr	Z, 00111$
	dec	a
	ld	(bc), a
	xor	a, a
	jp	00124$
00111$:
;src/boss_motion.c:24: bank_copy(&a,BOSS_DATA_BANK,boss_animations+m->variant,sizeof a);m->timer=a.speed;
	ldhl	sp,	#15
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	ld	de, #_boss_animations
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #0x0007
	push	hl
	push	de
	ld	a, #0xfe
	ld	hl, #6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
	pop	bc
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(bc), a
;src/boss_motion.c:25: frame=bank_read8(a.bank,a.data+m->cursor);
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
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
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
	ldhl	sp,	#4
	ld	a, (hl)
	ld	e, c
	ld	d, b
	call	_bank_read8
	ld	c, a
	ldhl	sp,	#13
	ld	(hl), c
;src/boss_motion.c:26: if(frame){++m->cursor;m->frame=frame;flags=BOSS_MOTION_FRAME;}
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ld	a, c
	or	a, a
	jr	Z, 00116$
	ldhl	sp,#11
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
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (hl+)
	inc	hl
	ld	(de), a
	ld	(hl), #0x01
	jr	00117$
00116$:
;src/boss_motion.c:27: else if(!m->phase){m->phase=1;++m->cursor;flags=BOSS_MOTION_IMPACT;}
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00113$
	ld	a, #0x01
	ld	(bc), a
	ldhl	sp,#11
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
	ldhl	sp,	#15
	ld	(hl), #0x02
	jr	00117$
00113$:
;src/boss_motion.c:28: else{m->phase=0;m->cursor=1;m->frame=bank_read8(a.bank,a.data);m->stage=m->variant==4u?3u:5u;flags=BOSS_MOTION_FRAME;}
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	ld	a, (hl)
	ld	e, c
	ld	d, b
	call	_bank_read8
	ldhl	sp,	#14
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x04
	ld	e, #0x03
	jr	Z, 00131$
	ld	e, #0x05
00131$:
	ld	a, e
	ld	(bc), a
	ldhl	sp,	#15
	ld	(hl), #0x01
00117$:
;src/boss_motion.c:29: if(m->variant==4u){if(m->cursor==19u)m->y=71u;if(m->stage==3u)m->y=79u;}
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x04
	jr	NZ, 00123$
	inc	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#22
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	bc
	inc	bc
	sub	a, #0x13
	jr	NZ, 00119$
	ld	a, #0x47
	ld	(bc), a
00119$:
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x03
	jr	NZ, 00123$
	ld	a, #0x4f
	ld	(bc), a
00123$:
;src/boss_motion.c:30: return flags;
	ldhl	sp,	#15
	ld	a, (hl)
00124$:
;src/boss_motion.c:31: }
	add	sp, #16
	ret
;src/boss_motion.c:32: uint16_t boss_motion_asset(uint8_t enemy,uint8_t frame,uint8_t y) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function boss_motion_asset
; ---------------------------------
	b_boss_motion_asset	= 31
_boss_motion_asset::
	add	sp, #-4
;src/boss_motion.c:34: for(i=0;i<BOSS_POSES;++i)if(bank_read8(BOSS_DATA_BANK,boss_pose_keys[i])==enemy&&bank_read8(BOSS_DATA_BANK,boss_pose_keys[i]+1u)==frame&&bank_read8(BOSS_DATA_BANK,boss_pose_keys[i]+2u)==y){bank_copy(&value,BOSS_DATA_BANK,boss_pose_lookup+i,2u);return value;}
	ldhl	sp,	#2
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00106$:
	ldhl	sp,	#3
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #_boss_pose_keys
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
	ld	a, #0xfe
	call	_bank_read8
	ld	e, a
	pop	bc
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, e
	jr	NZ, 00107$
	ld	hl, #_boss_pose_keys
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	inc	de
	push	bc
	ld	a, #0xfe
	call	_bank_read8
	ld	e, a
	pop	bc
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, e
	jr	NZ, 00107$
	inc	bc
	inc	bc
	ld	e, c
	ld	d, b
	ld	a, #0xfe
	call	_bank_read8
	ld	c, a
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00107$
	ldhl	sp,	#2
	ld	c, (hl)
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	ld	de, #_boss_pose_lookup
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ld	hl, #0x0002
	push	hl
	push	bc
	ld	a, #0xfe
	call	_bank_copy
	pop	bc
	push	bc
	jr	00108$
00107$:
	ldhl	sp,	#3
	inc	(hl)
	ld	a, (hl-)
	ld	(hl+), a
	ld	a, (hl)
	sub	a, #0x27
	jr	C, 00106$
;src/boss_motion.c:35: return 65535u;
	ld	bc, #0xffff
00108$:
;src/boss_motion.c:36: }
	add	sp, #4
	ret
	.area _CODE_31
	.area _INITIALIZER
	.area _CABS (ABS)
