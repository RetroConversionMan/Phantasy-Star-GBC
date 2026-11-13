;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module enemy_art
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl _set_bkg_palette
	.globl _set_bkg_tiles
	.globl b_enemy_art_draw
	.globl _enemy_art_draw
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_line:
	.ds 20
_colors:
	.ds 56
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
;src/enemy_art.c:8: uint8_t enemy_art_draw(uint8_t enemy) __banked {
;	---------------------------------
; Function enemy_art_draw
; ---------------------------------
	b_enemy_art_draw	= 31
_enemy_art_draw::
	add	sp, #-11
;src/enemy_art.c:10: if(!enemy||enemy>74u)return 0;
	ldhl	sp,	#17
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x4a
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jp	00108$
00102$:
;src/enemy_art.c:11: a=&enemy_art[enemy-1u];
	ldhl	sp,	#17
	ld	c, (hl)
	xor	a, a
	ld	b, a
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	a, #<(_enemy_art)
	add	a, l
	ld	c, a
	ld	a, #>(_enemy_art)
	adc	a, h
	ldhl	sp,	#9
	ld	(hl), c
	inc	hl
;src/enemy_art.c:12: bank_bkg_data(a->bank,0,a->tile_count,a->tiles,0);
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	a, (de)
	ld	h, #0x00
	push	hl
	inc	sp
	push	bc
	ldhl	sp,	#11
	ld	h, (hl)
	push	hl
	inc	sp
	ld	e, #0x00
	call	_bank_bkg_data
;src/enemy_art.c:13: bank_copy(colors,a->bank,a->palettes,56);set_bkg_palette(0,7,colors);
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl), a
	ld	de, #0x0038
	push	de
	push	bc
	ld	a, (hl)
	ld	de, #_colors
	call	_bank_copy
	ld	de, #_colors
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/enemy_art.c:14: for(y=0;y<14u;++y) {
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,#9
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
	ldhl	sp,	#10
	ld	(hl), #0x00
00106$:
;src/enemy_art.c:15: bank_copy(line,a->bank,a->map+(uint16_t)y*20u,20);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#6
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#10
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	pop	de
	push	de
	ld	a, (de)
	push	bc
	ld	de, #0x0014
	push	de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	de, #_line
	call	_bank_copy
	pop	bc
;src/enemy_art.c:16: VBK_REG=0;set_bkg_tiles(0,y,20,1,line);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_line
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#14
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/enemy_art.c:17: bank_copy(line,a->bank,a->attrs+(uint16_t)y*20u,20);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	add	hl, bc
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	a, (de)
	ld	de, #0x0014
	push	de
	push	bc
	ld	de, #_line
	call	_bank_copy
;src/enemy_art.c:18: VBK_REG=1;set_bkg_tiles(0,y,20,1,line);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_line
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#14
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/enemy_art.c:14: for(y=0;y<14u;++y) {
	ldhl	sp,	#10
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0e
	jp	C, 00106$
;src/enemy_art.c:20: VBK_REG=0;move_bkg(0,0);return 1;
	xor	a, a
	ldh	(_VBK_REG + 0), a
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/enemy_art.c:20: VBK_REG=0;move_bkg(0,0);return 1;
	ld	a, #0x01
00108$:
;src/enemy_art.c:21: }
	add	sp, #11
	ret
	.area _CODE_31
	.area _INITIALIZER
	.area _CABS (ABS)
