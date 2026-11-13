;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module enemy_magic
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_copy
	.globl _bank_read8
	.globl b_enemy_magic_animation
	.globl _enemy_magic_animation
	.globl b_enemy_magic_begin
	.globl _enemy_magic_begin
	.globl b_enemy_magic_tick
	.globl _enemy_magic_tick
	.globl b_enemy_magic_sound
	.globl _enemy_magic_sound
	.globl b_enemy_magic_pose
	.globl _enemy_magic_pose
	.globl b_enemy_magic_asset
	.globl _enemy_magic_asset
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
;src/enemy_magic.c:7: static uint8_t index_for(uint8_t enemy){
;	---------------------------------
; Function index_for
; ---------------------------------
_index_for:
	ld	c, a
;src/enemy_magic.c:8: uint8_t i;for(i=0;i<7u;++i)if(bank_read8(ENEMY_MAGIC_BANK,enemy_magic_enemies+i)==enemy)return i;return 255u;
	ld	b, #0x00
	ld	e, b
00104$:
	ld	hl, #_enemy_magic_enemies
	ld	d, #0x00
	add	hl, de
	ld	d, h
	push	bc
	push	de
	ld	e, l
	ld	a, #0xfc
	call	_bank_read8
	pop	de
	pop	bc
	sub	a, c
	jr	NZ, 00105$
	ld	a, b
	ret
00105$:
	inc	e
	ld	a,e
	ld	b,a
	sub	a, #0x07
	jr	C, 00104$
	ld	a, #0xff
;src/enemy_magic.c:9: }
	ret
;src/enemy_magic.c:10: static uint16_t read_word(const uint16_t *address){uint16_t result;bank_copy(&result,ENEMY_MAGIC_BANK,address,2u);return result;}
;	---------------------------------
; Function read_word
; ---------------------------------
_read_word:
	dec	sp
	dec	sp
	ld	bc, #0x0002
	push	bc
	push	de
	ld	a, #0xfc
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
	pop	bc
	ret
;src/enemy_magic.c:11: uint8_t enemy_magic_animation(uint8_t enemy,BattleAnimation *result) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function enemy_magic_animation
; ---------------------------------
	b_enemy_magic_animation	= 31
_enemy_magic_animation::
;src/enemy_magic.c:12: uint8_t i=index_for(enemy);if(i==255u)return 0;bank_copy(result,ENEMY_MAGIC_BANK,enemy_magic_animations+i,sizeof *result);return 1;
	ldhl	sp,	#6
	ld	a, (hl)
	call	_index_for
	ld	c, a
	inc	a
	ret	Z
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	de, #_enemy_magic_animations
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	push	hl
	push	bc
	ld	a, #0xfc
	call	_bank_copy
	ld	a, #0x01
;src/enemy_magic.c:13: }
	ret
;src/enemy_magic.c:14: uint8_t enemy_magic_begin(EnemyMagicEffect *m,uint8_t enemy) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function enemy_magic_begin
; ---------------------------------
	b_enemy_magic_begin	= 31
_enemy_magic_begin::
	add	sp, #-5
;src/enemy_magic.c:15: uint8_t i=index_for(enemy);m->active=0;if(i==255u)return 0;
	ldhl	sp,	#13
	ld	a, (hl)
	call	_index_for
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#0
	ld	a, (hl)
	inc	a
	jp	Z, 00103$
;src/enemy_magic.c:16: m->kind=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_kinds+i);
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ld	de, #_enemy_magic_kinds
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, #0xfc
	call	_bank_read8
	ld	c, a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;src/enemy_magic.c:17: m->speed=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[m->kind]+1u);
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	inc	de
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	bc, #_enemy_magic_effects
	add	hl, bc
	inc	hl
	push	de
	ld	e, l
	ld	d, h
	ld	a, #0xfc
	call	_bank_read8
	pop	de
	ld	(de), a
;src/enemy_magic.c:18: m->frame=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[m->kind]+2u);
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, hl
	ld	de, #_enemy_magic_effects
	add	hl, de
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	push	bc
	ld	a, #0xfc
	call	_bank_read8
	pop	bc
	ld	(bc), a
;src/enemy_magic.c:19: m->end=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[m->kind]+3u);
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #<(_enemy_magic_effects)
	ld	e, a
	ld	a, h
	adc	a, #>(_enemy_magic_effects)
	ld	d, a
	inc	de
	inc	de
	inc	de
	push	bc
	ld	a, #0xfc
	call	_bank_read8
	pop	bc
	ld	(bc), a
;src/enemy_magic.c:20: m->timer=m->phase=0;m->active=1;return 1;
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	ld	b, a
	inc	bc
	inc	bc
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	(de), a
	ld	(bc), a
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x01
	ld	(hl),a
00103$:
;src/enemy_magic.c:21: }
	add	sp, #5
	ret
;src/enemy_magic.c:22: uint8_t enemy_magic_tick(EnemyMagicEffect *m) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function enemy_magic_tick
; ---------------------------------
	b_enemy_magic_tick	= 31
_enemy_magic_tick::
	add	sp, #-9
;src/enemy_magic.c:23: if(!m->active)return 0;
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl), a
	or	a,a
	jp	Z, 00109$
;src/enemy_magic.c:24: if(!m->phase){m->phase=1;return ENEMY_MAGIC_SOUND;}
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00104$
	ld	a, #0x01
	ld	(bc), a
	ld	a, #0x02
	jp	00109$
00104$:
;src/enemy_magic.c:25: if(m->timer){--m->timer;return 0;}
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	or	a, a
	jr	Z, 00106$
	dec	a
	ld	(bc), a
	xor	a, a
	jr	00109$
00106$:
;src/enemy_magic.c:26: m->timer=m->speed;
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
;src/enemy_magic.c:27: if(m->frame+1u>=m->end){m->active=0;return ENEMY_MAGIC_IMPACT;}
	ld	a, (hl-)
	ld	d, a
	inc	de
	inc	de
	inc	de
	ld	a, (de)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl+)
	ld	c, a
	ld	b, #0x00
	inc	bc
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
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
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#5
	ld	e, l
	ld	d, h
	ldhl	sp,	#7
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00108$
	pop	hl
	ld	(hl), #0x00
	push	hl
	ld	a, #0x04
	jr	00109$
00108$:
;src/enemy_magic.c:28: ++m->frame;return ENEMY_MAGIC_FRAME;
	ldhl	sp,	#4
	ld	a, (hl)
	inc	a
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(de), a
	ld	a, #0x01
00109$:
;src/enemy_magic.c:29: }
	add	sp, #9
	ret
;src/enemy_magic.c:30: uint8_t enemy_magic_sound(const EnemyMagicEffect *m) BATTLE_SCENE_BANKED {return bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[m->kind]);}
;	---------------------------------
; Function enemy_magic_sound
; ---------------------------------
	b_enemy_magic_sound	= 31
_enemy_magic_sound::
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, hl
	ld	de, #_enemy_magic_effects
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, #0xfc
	jp	_bank_read8
;src/enemy_magic.c:31: uint16_t enemy_magic_pose(uint8_t enemy,uint8_t frame,uint8_t palette) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function enemy_magic_pose
; ---------------------------------
	b_enemy_magic_pose	= 31
_enemy_magic_pose::
;src/enemy_magic.c:32: uint8_t i;if(palette>=12u)return 65535u;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x0c
	jr	C, 00102$
	ld	bc, #0xffff
	ret
00102$:
;src/enemy_magic.c:33: for(i=0;i<ENEMY_MAGIC_POSES;++i)if(bank_read8(ENEMY_MAGIC_BANK,enemy_magic_pose_keys[i])==enemy&&bank_read8(ENEMY_MAGIC_BANK,enemy_magic_pose_keys[i]+1u)==frame)return read_word(enemy_magic_pose_lookup[i]+palette);
	ld	bc, #0x0
00107$:
	ld	e, b
	ld	d, #0x00
	sla	e
	rl	d
	ld	hl, #_enemy_magic_pose_keys
	add	hl, de
	push	bc
	push	de
	ld	e, l
	ld	d, h
	ld	a, #0xfc
	call	_bank_read8
	pop	de
	pop	bc
	ldhl	sp,	#6
	sub	a, (hl)
	jr	NZ, 00108$
	ld	hl,#_enemy_magic_pose_keys + 1
	add	hl,de
	ld	e, l
	ld	d, h
	push	bc
	ld	a, #0xfc
	call	_bank_read8
	ld	e, a
	pop	bc
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, e
	jr	NZ, 00108$
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, #<(_enemy_magic_pose_lookup)
	add	a, l
	ld	c, a
	ld	a, #>(_enemy_magic_pose_lookup)
	adc	a, h
	ld	b, a
	ldhl	sp,	#8
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, bc
	ld	e, l
	ld	d, h
	jp	_read_word
00108$:
	inc	b
	ld	c, b
	ld	a, b
	sub	a, #0x04
	jr	C, 00107$
;src/enemy_magic.c:34: return 65535u;
	ld	bc, #0xffff
;src/enemy_magic.c:35: }
	ret
;src/enemy_magic.c:36: uint16_t enemy_magic_asset(uint8_t enemy,uint8_t frame) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function enemy_magic_asset
; ---------------------------------
	b_enemy_magic_asset	= 31
_enemy_magic_asset::
	add	sp, #-4
;src/enemy_magic.c:37: uint8_t i=index_for(enemy),kind,first;if(i==255u)return 65535u;
	ldhl	sp,	#10
	ld	a, (hl)
	call	_index_for
	ld	c, a
	inc	a
	jr	NZ, 00102$
	ld	bc, #0xffff
	jr	00106$
00102$:
;src/enemy_magic.c:38: kind=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_kinds+i);first=bank_read8(ENEMY_MAGIC_BANK,enemy_magic_effects[kind]+2u)+1u;
	ld	hl, #_enemy_magic_kinds
	ld	b, #0x00
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
	ld	a, #0xfc
	call	_bank_read8
	ld	e, a
	pop	bc
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_enemy_magic_effects
	add	hl, de
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	push	bc
	ld	a, #0xfc
	call	_bank_read8
	pop	bc
	ld	b, a
	inc	b
;src/enemy_magic.c:39: if(frame<first||frame-first>=8u)return 65535u;
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, b
	jr	C, 00103$
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	a, b
	ld	(hl+), a
	ld	(hl), #0x00
	pop	de
	push	de
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, e
	ld	e, a
	ld	a, b
	sub	a, #0x08
	ld	a, e
	sbc	a, #0x00
	jr	C, 00104$
00103$:
	ld	bc, #0xffff
	jr	00106$
00104$:
;src/enemy_magic.c:40: return read_word(enemy_magic_effect_lookup[i]+frame-first);
	ld	de, #_enemy_magic_effect_lookup+0
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl+)
	inc	hl
	ld	e, #0x00
	add	a, a
	rl	e
	add	a, c
	ld	c, a
	ld	a, e
	adc	a, b
	ld	b, a
	ld	e, (hl)
	ld	d, #0x00
	sla	e
	rl	d
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ld	d, a
	call	_read_word
00106$:
;src/enemy_magic.c:41: }
	add	sp, #4
	ret
	.area _CODE_31
	.area _INITIALIZER
	.area _CABS (ABS)
