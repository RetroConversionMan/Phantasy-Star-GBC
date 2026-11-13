;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module ui
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl _set_win_tiles
	.globl b_ui_text
	.globl _ui_text
	.globl b_ui_panel
	.globl _ui_panel
	.globl b_ui_number
	.globl _ui_number
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_tiles:
	.ds 20
_attrs:
	.ds 20
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
	.area _CODE_1
;src/ui.c:7: void ui_text(uint8_t x,uint8_t y,const char *s) __banked {
;	---------------------------------
; Function ui_text
; ---------------------------------
	b_ui_text	= 1
_ui_text::
	add	sp, #-4
;src/ui.c:9: while(*s && n<20u-x) {c=(uint8_t)*s++;tiles[n++]=(c>=32u&&c<=95u)?c-32u:0u;}
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#3
	ld	(hl), #0x00
00102$:
	ld	a, (bc)
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	ldhl	sp,	#10
	ld	e, (hl)
	ld	d, #0x00
	ld	a, #0x14
	sub	a, e
	ld	e, a
	sbc	a, a
	sub	a, d
	ld	d, a
	ldhl	sp,	#3
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, e
	ld	a, (hl)
	sbc	a, d
	jr	NC, 00104$
	dec	hl
	dec	hl
	ld	a, (hl+)
	inc	hl
	inc	bc
	ld	(hl+), a
	ld	de, #_tiles
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#3
	inc	(hl)
	dec	hl
	ld	a, (hl)
	sub	a, #0x20
	jr	C, 00107$
	ld	a, #0x5f
	sub	a, (hl)
	jr	C, 00107$
	ld	a, (hl)
	add	a, #0xe0
	jr	00108$
00107$:
	xor	a, a
00108$:
	ld	(de), a
	jr	00102$
00104$:
;src/ui.c:10: VBK_REG=0;set_win_tiles(x,y,n,1,tiles);
	ld	a, #0x00
	ldh	(_VBK_REG + 0), a
	ld	de, #_tiles
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_set_win_tiles
;src/ui.c:11: }
	add	sp, #10
	ret
;src/ui.c:12: void ui_panel(uint8_t y,uint8_t rows) __banked {
;	---------------------------------
; Function ui_panel
; ---------------------------------
	b_ui_panel	= 1
_ui_panel::
;src/ui.c:14: memset(tiles,0,20);memset(attrs,15,20);
	ld	de, #0x0014
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_tiles
	push	de
	call	_memset
	add	sp, #6
	ld	de, #0x0014
	push	de
	ld	de, #0x000f
	push	de
	ld	de, #_attrs
	push	de
	call	_memset
	add	sp, #6
;src/ui.c:15: for(row=0;row<rows;++row) {
	ld	b, #0x00
00104$:
	ld	a, b
	ldhl	sp,	#7
	sub	a, (hl)
	jr	NC, 00101$
;src/ui.c:16: VBK_REG=0;set_win_tiles(0,row,20,1,tiles);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_tiles
	push	de
	ld	hl, #0x114
	push	hl
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_set_win_tiles
	add	sp, #6
;src/ui.c:17: VBK_REG=1;set_win_tiles(0,row,20,1,attrs);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_attrs
	push	de
	ld	hl, #0x114
	push	hl
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_set_win_tiles
	add	sp, #6
;src/ui.c:15: for(row=0;row<rows;++row) {
	inc	b
	jr	00104$
00101$:
;src/ui.c:19: VBK_REG=0;move_win(7,y);SHOW_WIN;
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ldhl	sp,	#6
	ld	c, (hl)
;.tools/gbdk/include/gb/gb.h:1739: WX_REG=x, WY_REG=y;
	ld	a, #0x07
	ldh	(_WX_REG + 0), a
	ld	a, c
	ldh	(_WY_REG + 0), a
;src/ui.c:19: VBK_REG=0;move_win(7,y);SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;src/ui.c:20: }
	ret
;src/ui.c:21: void ui_number(uint8_t x,uint8_t y,uint16_t value) __banked {
;	---------------------------------
; Function ui_number
; ---------------------------------
	b_ui_number	= 1
_ui_number::
	add	sp, #-9
;src/ui.c:23: digits[i]=0;
	ldhl	sp,	#5
	ld	(hl), #0x00
;src/ui.c:24: do {digits[--i]='0'+value%10u;value/=10u;} while(value&&i);
	ldhl	sp,	#8
	ld	(hl), #0x05
00102$:
	ldhl	sp,	#8
	dec	(hl)
	push	hl
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#8
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	push	de
	ld	bc, #0x000a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__moduint
	pop	de
	ld	a, c
	add	a, #0x30
	ld	(de), a
	push	de
	ld	bc, #0x000a
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__divuint
	pop	de
	ldhl	sp,	#17
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	or	a, b
	jr	Z, 00104$
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	NZ, 00102$
00104$:
;src/ui.c:25: ui_text(x,y,digits+i);
	push	de
	ldhl	sp,	#18
	ld	a, (hl-)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
;src/ui.c:26: }
	add	sp, #13
	ret
	.area _CODE_1
	.area _INITIALIZER
	.area _CABS (ABS)
