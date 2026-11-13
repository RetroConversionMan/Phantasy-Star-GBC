;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module battle_weapon
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_copy
	.globl b_battle_weapon_begin
	.globl _battle_weapon_begin
	.globl b_battle_weapon_tick
	.globl _battle_weapon_tick
	.globl b_battle_weapon_sound
	.globl _battle_weapon_sound
	.globl b_battle_weapon_asset
	.globl _battle_weapon_asset
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
;src/battle_weapon.c:7: uint8_t battle_weapon_begin(WeaponMotion *m,uint8_t effect) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function battle_weapon_begin
; ---------------------------------
	b_battle_weapon_begin	= 31
_battle_weapon_begin::
	add	sp, #-6
;src/battle_weapon.c:8: uint8_t row[4];m->active=0;if(effect>18u)return 0;
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0006
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	a, #0x12
	ldhl	sp,	#14
	sub	a, (hl)
	jr	NC, 00102$
	xor	a, a
	jr	00103$
00102$:
;src/battle_weapon.c:9: bank_copy(row,WEAPON_DATA_BANK,weapon_effects[effect],4u);
	ldhl	sp,	#14
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_weapon_effects
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #0x0004
	push	hl
	push	de
	ld	a, #0xb6
	ld	hl, #6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
	pop	bc
;src/battle_weapon.c:10: m->effect=effect;m->frame=row[2];m->timer=0;m->speed=row[1];m->end=row[3];m->phase=0;m->active=1;return 1;
	ldhl	sp,	#14
	ld	a, (hl)
	ld	(bc), a
	ld	e, c
	ld	d, b
	inc	de
	ld	hl,#0x2
	add	hl,sp
	ld	a, (hl)
	ld	(de), a
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	(hl), #0x00
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	hl,#0x1
	add	hl,sp
	ld	a, (hl)
	ld	(de), a
	ld	hl, #0x0004
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl,#0x3
	add	hl,sp
	ld	a, (hl)
	ld	(de), a
	ld	hl, #0x0005
	add	hl, bc
	ld	(hl), #0x00
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x01
	ld	(hl),a
00103$:
;src/battle_weapon.c:11: }
	add	sp, #6
	ret
;src/battle_weapon.c:12: uint8_t battle_weapon_tick(WeaponMotion *m) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function battle_weapon_tick
; ---------------------------------
	b_battle_weapon_tick	= 31
_battle_weapon_tick::
	add	sp, #-9
;src/battle_weapon.c:13: if(!m->active)return 0;
	ldhl	sp,#15
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
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	or	a,a
	jp	Z, 00111$
;src/battle_weapon.c:16: if(!m->phase){m->phase=1;return WEAPON_MOTION_SOUND;}
	ldhl	sp,#15
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
	or	a, a
	jr	NZ, 00104$
	pop	hl
	ld	(hl), #0x01
	push	hl
	ld	a, #0x02
	jp	00111$
00104$:
;src/battle_weapon.c:17: if(m->phase==2u){m->active=0;return WEAPON_MOTION_DONE;}
	sub	a, #0x02
	jr	NZ, 00106$
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	a, #0x08
	jp	00111$
00106$:
;src/battle_weapon.c:18: if(m->timer){--m->timer;return 0;}
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	or	a, a
	jr	Z, 00108$
	dec	a
	ld	(bc), a
	xor	a, a
	jr	00111$
00108$:
;src/battle_weapon.c:19: m->timer=m->speed;
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
;src/battle_weapon.c:20: if(m->frame+1u>=m->end){m->phase=2;return WEAPON_MOTION_CLEAR;}
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
	jr	C, 00110$
	pop	hl
	ld	(hl), #0x02
	push	hl
	ld	a, #0x04
	jr	00111$
00110$:
;src/battle_weapon.c:21: ++m->frame;return WEAPON_MOTION_FRAME;
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
00111$:
;src/battle_weapon.c:22: }
	add	sp, #9
	ret
;src/battle_weapon.c:23: uint8_t battle_weapon_sound(uint8_t effect) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function battle_weapon_sound
; ---------------------------------
	b_battle_weapon_sound	= 31
_battle_weapon_sound::
	dec	sp
;src/battle_weapon.c:24: uint8_t value=0;if(effect<19u)bank_copy(&value,WEAPON_DATA_BANK,weapon_effects[effect],1u);return value;
	ldhl	sp,	#0
	ld	(hl), #0x00
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x13
	jr	NC, 00102$
	ld	bc, #_weapon_effects+0
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ld	hl, #0x0001
	push	hl
	push	bc
	ld	a, #0xb6
	call	_bank_copy
00102$:
	ldhl	sp,	#0
	ld	a, (hl)
;src/battle_weapon.c:25: }
	inc	sp
	ret
;src/battle_weapon.c:26: uint16_t battle_weapon_asset(uint8_t enemy,uint8_t frame) BATTLE_SCENE_BANKED {
;	---------------------------------
; Function battle_weapon_asset
; ---------------------------------
	b_battle_weapon_asset	= 31
_battle_weapon_asset::
	add	sp, #-4
;src/battle_weapon.c:28: if(!enemy||enemy>74u)return 65535u;
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x4a
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	ld	bc, #0xffff
	jr	00106$
00102$:
;src/battle_weapon.c:29: bank_copy(&group,WEAPON_DATA_BANK,weapon_enemy_groups+enemy-1u,1u);
	ld	bc, #_weapon_enemy_groups+0
	ldhl	sp,	#10
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	dec	bc
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ld	hl, #0x0001
	push	hl
	push	bc
	ld	a, #0xb6
	call	_bank_copy
;src/battle_weapon.c:30: bank_copy(&index,WEAPON_DATA_BANK,weapon_frame_indices+frame,1u);
	ld	bc, #_weapon_frame_indices+0
	ldhl	sp,	#11
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#1
	ld	e, l
	ld	d, h
	ld	hl, #0x0001
	push	hl
	push	bc
	ld	a, #0xb6
	call	_bank_copy
;src/battle_weapon.c:31: if(index==255u)return 65535u;
	ldhl	sp,	#1
	ld	a, (hl)
	inc	a
	jr	NZ, 00105$
	ld	bc, #0xffff
	jr	00106$
00105$:
;src/battle_weapon.c:32: bank_copy(value,WEAPON_DATA_BANK,&weapon_lookup[group][index],2u);
	ldhl	sp,	#0
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc, #_weapon_lookup
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#1
	ld	a, (hl)
	add	a, a
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
	ld	de, #0x0002
	push	de
	push	bc
	ld	a, #0xb6
	ld	hl, #6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/battle_weapon.c:33: return value[0]|((uint16_t)value[1]<<8);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	d, (hl)
	xor	a, a
	ld	e, a
	ld	b, d
00106$:
;src/battle_weapon.c:34: }
	add	sp, #4
	ret
	.area _CODE_31
	.area _INITIALIZER
	.area _CABS (ABS)
