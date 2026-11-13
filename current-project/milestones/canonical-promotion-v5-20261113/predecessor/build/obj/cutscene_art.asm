;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module cutscene_art
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl _set_bkg_palette
	.globl _set_bkg_tiles
	.globl b_cutscene_portrait_show
	.globl _cutscene_portrait_show
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
	.area _CODE_12
;src/cutscene_art.c:10: uint8_t cutscene_portrait_show(uint8_t portrait) __banked {
;	---------------------------------
; Function cutscene_portrait_show
; ---------------------------------
	b_cutscene_portrait_show	= 12
_cutscene_portrait_show::
	add	sp, #-9
;src/cutscene_art.c:12: if(portrait>8u)return 0;p=cutscene_portraits+portrait;
	ld	a, #0x08
	ldhl	sp,	#15
	sub	a, (hl)
	jr	NC, 00102$
	xor	a, a
	jp	00115$
00102$:
	ldhl	sp,	#15
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_cutscene_portraits
	add	hl, bc
;src/cutscene_art.c:13: first=p->tiles>256u?256u:p->tiles;
	ld	c,l
	ld	b,h
	inc	hl
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
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	e, l
	ld	d, h
	xor	a, a
	cp	a, e
	ld	a, #0x01
	sbc	a, d
	jr	NC, 00117$
	xor	a, a
	ld	e, #0x01
	jr	00118$
00117$:
	ld	a, l
	ld	e, h
00118$:
	ldhl	sp,	#5
	ld	(hl+), a
	ld	(hl), e
;src/cutscene_art.c:14: bank_bkg_data(p->bank,0,(uint8_t)first,p->data,0);
	ld	hl, #0x0003
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#7
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl+)
	inc	hl
	ld	e, a
	ld	a, (bc)
	ld	d, a
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	a, e
	push	af
	inc	sp
	ld	e, #0x00
	ld	a, d
	call	_bank_bkg_data
	pop	bc
;src/cutscene_art.c:15: if(p->tiles>256u)bank_bkg_data(p->bank,64,(uint8_t)(p->tiles-256u),p->data+4096u,1);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#7
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	xor	a, a
	cp	a, e
	ld	a, #0x01
	sbc	a, d
	jr	NC, 00104$
	pop	de
	push	de
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	e, l
	add	a, #0x10
	ld	d, a
	ldhl	sp,	#7
	ld	h, (hl)
	ld	a, (bc)
	ld	l, a
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	push	de
	push	hl
	inc	sp
	ld	e, #0x40
	ld	a, l
	call	_bank_bkg_data
	pop	bc
00104$:
;src/cutscene_art.c:16: offset=p->tiles*16u;
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	ld	e, h
	ldhl	sp,	#2
	ld	(hl+), a
	ld	(hl), e
;src/cutscene_art.c:17: bank_copy(scene_shared_colors,p->bank,p->data+offset+600u,56u);set_bkg_palette(0,7,scene_shared_colors);
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#7
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#7
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0258
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
	push	bc
	ld	hl, #0x0038
	push	hl
	push	de
	ldhl	sp,	#14
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
	pop	bc
;src/cutscene_art.c:18: for(row=0;row<15u;++row){
	ldhl	sp,	#8
	ld	(hl), #0x00
00109$:
;src/cutscene_art.c:19: bank_copy(scene_shared_bytes,p->bank,p->data+offset+(uint16_t)row*20u,20u);
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#6
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	push	bc
	ld	hl, #0x0014
	push	hl
	push	de
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	pop	bc
;src/cutscene_art.c:20: VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#12
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/cutscene_art.c:21: bank_copy(scene_shared_bytes,p->bank,p->data+offset+300u+(uint16_t)row*20u,20u);
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x012c
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	push	bc
	ld	hl, #0x0014
	push	hl
	push	de
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	pop	bc
;src/cutscene_art.c:22: VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#12
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/cutscene_art.c:18: for(row=0;row<15u;++row){
	ldhl	sp,	#8
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0f
	jp	C, 00109$
;src/cutscene_art.c:24: for(col=0;col<20u;++col){scene_shared_bytes[col]=0;scene_shared_bytes[col+20u]=15;}
	ld	c, #0x00
00111$:
	ld	hl, #_scene_shared_bytes
	ld	b, #0x00
	add	hl, bc
	ld	(hl), #0x00
	ld	a, c
	add	a, #0x14
	ld	l, a
	ld	h, #0x00
	ld	de, #_scene_shared_bytes
	add	hl, de
	ld	(hl), #0x0f
	inc	c
	ld	a, c
	sub	a, #0x14
	jr	C, 00111$
;src/cutscene_art.c:25: for(row=15;row<18u;++row){
	ld	b, #0x0f
00113$:
;src/cutscene_art.c:26: VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x114
	push	hl
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/cutscene_art.c:27: VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes+20);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #(_scene_shared_bytes + 20)
	push	de
	ld	hl, #0x114
	push	hl
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/cutscene_art.c:25: for(row=15;row<18u;++row){
	inc	b
	ld	a, b
	sub	a, #0x12
	jr	C, 00113$
;src/cutscene_art.c:29: VBK_REG=0;move_bkg(0,0);return 1;
	xor	a, a
	ldh	(_VBK_REG + 0), a
;.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/cutscene_art.c:29: VBK_REG=0;move_bkg(0,0);return 1;
	ld	a, #0x01
00115$:
;src/cutscene_art.c:30: }
	add	sp, #9
	ret
	.area _CODE_12
	.area _INITIALIZER
	.area _CABS (ABS)
