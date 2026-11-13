;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module opening
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl _set_bkg_palette
	.globl _set_bkg_tiles
	.globl _opening_position
	.globl b_opening_begin
	.globl _opening_begin
	.globl b_opening_tick
	.globl _opening_tick
	.globl b_movie_scene_show
	.globl _movie_scene_show
	.globl b_movie_city_caption
	.globl _movie_city_caption
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_opening_position::
	.ds 2
_opening_head:
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
	.area _CODE_132
;src/opening.c:16: static void pan_row(uint8_t logical) __banked {
;	---------------------------------
; Function pan_row
; ---------------------------------
	b_pan_row	= 132
_pan_row:
	dec	sp
;src/opening.c:17: uint8_t row=logical%28u,planet=0;uint16_t offset;
	ldhl	sp,	#7
	ld	a, (hl)
	ld	e, #0x1c
	call	__moduchar
	ld	b, c
	ld	c, #0x00
;src/opening.c:18: if(row<12u&&opening_position>=(uint16_t)257u+(uint16_t)row*8u)planet=1;
	ld	a, b
	sub	a, #0x0c
	jr	NC, 00102$
	ld	l, b
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	inc	hl
	ld	e, l
	ld	d, h
	inc	d
	ld	hl, #_opening_position
	ld	a, (hl+)
	sub	a, e
	ld	a, (hl)
	sbc	a, d
	jr	C, 00102$
	ld	c, #0x01
00102$:
;src/opening.c:19: row%=12u;
	ld	a, b
	push	bc
	ld	e, #0x0c
	call	__moduchar
	ld	a, c
	pop	bc
	ldhl	sp,	#0
	ld	(hl), a
;src/opening.c:20: offset=1624u+(uint16_t)planet*768u+(uint16_t)row*32u+6u;
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #0x065e
	add	hl, de
	add	hl, bc
;src/opening.c:21: bank_copy(scene_shared_bytes,129,opening_pan+offset,20u);
	ld	bc, #_opening_pan
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	push	bc
	ld	hl, #0x0014
	push	hl
	push	de
	ld	a, #0x81
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	pop	bc
;src/opening.c:22: bank_copy(scene_shared_bytes+20,129,opening_pan+offset+384u,20u);
	ld	hl, #0x0180
	add	hl, bc
	ld	de, #0x0014
	push	de
	push	hl
	ld	a, #0x81
	ld	de, #(_scene_shared_bytes + 20)
	call	_bank_copy
;src/opening.c:23: VBK_REG=0;set_bkg_tiles(0,logical&31u,20,1,scene_shared_bytes);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	ldhl	sp,	#7
	ld	a, (hl)
	and	a, #0x1f
	ld	b, a
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
;src/opening.c:24: VBK_REG=1;set_bkg_tiles(0,logical&31u,20,1,scene_shared_bytes+20);VBK_REG=0;
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
	xor	a, a
	ldh	(_VBK_REG + 0), a
;src/opening.c:25: }
	inc	sp
	ret
;src/opening.c:26: void opening_begin(void) __banked {
;	---------------------------------
; Function opening_begin
; ---------------------------------
	b_opening_begin	= 132
_opening_begin::
;src/opening.c:27: uint8_t row;opening_position=128u;opening_head=19u;
	ld	hl, #_opening_position
	ld	a, #0x80
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	hl, #_opening_head
	ld	(hl), #0x13
;src/opening.c:28: HIDE_SPRITES;HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;src/opening.c:29: bank_bkg_data(129,0,98,opening_pan,0);
	xor	a, a
	push	af
	inc	sp
	ld	de, #_opening_pan
	push	de
	ld	a, #0x62
	push	af
	inc	sp
	ld	e, #0x00
	ld	a, #0x81
	call	_bank_bkg_data
;src/opening.c:30: bank_copy(scene_shared_colors,129,opening_pan+1568u,56u);set_bkg_palette(0,7,scene_shared_colors);
	ld	de, #0x0038
	push	de
	ld	de, #(_opening_pan + 1568)
	push	de
	ld	a, #0x81
	ld	de, #_scene_shared_colors
	call	_bank_copy
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/opening.c:31: for(row=0;row<19u;++row)pan_row(opening_head+row);
	ld	c, #0x00
00103$:
	ld	a, (#_opening_head)
	add	a, c
	push	bc
	push	af
	inc	sp
	ld	e, #b_pan_row
	ld	hl, #_pan_row
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
	inc	c
	ld	a, c
	sub	a, #0x13
	jr	C, 00103$
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	ld	a, #0x98
	ldh	(_SCY_REG + 0), a
;src/opening.c:32: move_bkg(0,152u);SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;src/opening.c:33: }
	ret
;src/opening.c:34: uint8_t opening_tick(uint8_t skip_pressed) __banked {
;	---------------------------------
; Function opening_tick
; ---------------------------------
	b_opening_tick	= 132
_opening_tick::
;src/opening.c:36: if(skip_pressed||opening_position>=352u)return 1;
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	NZ, 00101$
	ld	a, (_opening_position)
	ld	c, a
	ld	hl, #_opening_position + 1
	ld	b, (hl)
	ld	a, c
	sub	a, #0x60
	ld	a, b
	sbc	a, #0x01
	jr	C, 00102$
00101$:
	ld	a, #0x01
	ret
00102$:
;src/opening.c:37: ++opening_position;head=(uint8_t)((opening_position+24u)>>3);
	ld	hl, #_opening_position
	inc	(hl)
	jr	NZ, 00123$
	inc	hl
	inc	(hl)
00123$:
	ld	a, (_opening_position)
	ld	hl, #_opening_position + 1
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0018
	add	hl, de
	srl	h
	rr	l
	srl	h
	rr	l
	srl	h
	rr	l
;src/opening.c:38: if(head!=opening_head){opening_head=head;pan_row(head+18u);}
	ld	a, (_opening_head)
	sub	a, l
	jr	Z, 00105$
	ld	a, l
	ld	(_opening_head), a
	ld	a, l
	add	a, #0x12
	push	af
	inc	sp
	ld	e, #b_pan_row
	ld	hl, #_pan_row
	call	___sdcc_bcall_ehl
	inc	sp
00105$:
;src/opening.c:39: move_bkg(0,(uint8_t)(opening_position+24u));
	ld	a, (_opening_position)
	add	a, #0x18
	ld	c, a
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	ld	a, c
	ldh	(_SCY_REG + 0), a
;src/opening.c:40: return opening_position==352u;
	ld	a, (_opening_position)
	ld	c, a
	ld	hl, #_opening_position + 1
	ld	b, (hl)
	ld	a, c
	sub	a, #0x60
	jr	NZ, 00125$
	dec	b
	ld	a, #0x01
	ret	Z
00125$:
	xor	a, a
;src/opening.c:41: }
	ret
;src/opening.c:42: uint8_t movie_scene_show(uint8_t image) __banked {
;	---------------------------------
; Function movie_scene_show
; ---------------------------------
	b_movie_scene_show	= 132
_movie_scene_show::
	add	sp, #-9
;src/opening.c:44: if(!image||image>3u)return 0;p=movie_images+image-1u;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x03
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jp	00116$
00102$:
	ldhl	sp,	#15
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_movie_images
	add	hl, bc
	ld	bc, #0xfffb
	add	hl,bc
	ld	c, l
	ld	b, h
;src/opening.c:45: HIDE_SPRITES;HIDE_WIN;first=p->tiles>256u?256u:p->tiles;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ld	l, c
	ld	h, b
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
	jr	NC, 00118$
	xor	a, a
	ld	e, #0x01
	jr	00119$
00118$:
	ld	a, l
	ld	e, h
00119$:
	ldhl	sp,	#5
	ld	(hl+), a
	ld	(hl), e
;src/opening.c:46: bank_bkg_data(p->bank,0,(uint8_t)first,p->data,0);
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
;src/opening.c:47: if(p->tiles>256u)bank_bkg_data(p->bank,64,(uint8_t)(p->tiles-256u),p->data+4096u,1);
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
	jr	NC, 00105$
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
00105$:
;src/opening.c:48: offset=p->tiles*16u;bank_copy(scene_shared_colors,p->bank,p->data+offset+600u,56u);set_bkg_palette(0,7,scene_shared_colors);
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
;src/opening.c:49: for(row=0;row<15u;++row){
	ldhl	sp,	#8
	ld	(hl), #0x00
00110$:
;src/opening.c:50: bank_copy(scene_shared_bytes,p->bank,p->data+offset+(uint16_t)row*20u,20u);VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
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
;src/opening.c:51: bank_copy(scene_shared_bytes,p->bank,p->data+offset+300u+(uint16_t)row*20u,20u);VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
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
;src/opening.c:49: for(row=0;row<15u;++row){
	ldhl	sp,	#8
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0f
	jp	C, 00110$
;src/opening.c:53: for(col=0;col<20u;++col){scene_shared_bytes[col]=0;scene_shared_bytes[col+20u]=15;}
	ld	c, #0x00
00112$:
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
	jr	C, 00112$
;src/opening.c:54: for(row=15;row<18u;++row){VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes+20);}
	ld	b, #0x0f
00114$:
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
	inc	b
	ld	a, b
	sub	a, #0x12
	jr	C, 00114$
;src/opening.c:55: VBK_REG=0;move_bkg(0,0);SHOW_BKG;return 1;
	xor	a, a
	ldh	(_VBK_REG + 0), a
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/opening.c:55: VBK_REG=0;move_bkg(0,0);SHOW_BKG;return 1;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
	ld	a, #0x01
00116$:
;src/opening.c:56: }
	add	sp, #9
	ret
;src/opening.c:58: void movie_city_caption(void) __banked {
;	---------------------------------
; Function movie_city_caption
; ---------------------------------
	b_movie_city_caption	= 132
_movie_city_caption::
	add	sp, #-5
;src/opening.c:59: const MovieImage *p=movie_images;uint8_t row;uint16_t offset=p->tiles*16u+656u;
	ld	hl, #_movie_images + 1
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #0x90
	ld	c, a
	ld	a, h
	adc	a, #0x02
	ldhl	sp,	#0
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/opening.c:62: for(row=1;row<5u;++row){
	ldhl	sp,	#4
	ld	(hl), #0x01
00102$:
;src/opening.c:63: bank_copy(scene_shared_bytes,p->bank,p->data+offset+(uint16_t)row*20u+1u,14u);
	ld	hl, #(_movie_images + 3)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	hl
	push	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
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
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	ld	c, l
	ld	b, h
	ld	a, (#_movie_images + 0)
	ld	de, #0x000e
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/opening.c:64: VBK_REG=0;set_bkg_tiles(1,row,14,1,scene_shared_bytes);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x10e
	push	hl
	ldhl	sp,	#8
	ld	h, (hl)
	ld	l, #0x01
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/opening.c:65: bank_copy(scene_shared_bytes,p->bank,p->data+offset+300u+(uint16_t)row*20u+1u,14u);
	ld	hl, #(_movie_images + 3)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	hl
	push	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x012d
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, e
	add	a, c
	ld	c, a
	ld	a, d
	adc	a, b
	ld	b, a
	ld	a, (#_movie_images + 0)
	ld	de, #0x000e
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/opening.c:66: VBK_REG=1;set_bkg_tiles(1,row,14,1,scene_shared_bytes);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x10e
	push	hl
	ldhl	sp,	#8
	ld	h, (hl)
	ld	l, #0x01
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/opening.c:62: for(row=1;row<5u;++row){
	ldhl	sp,	#4
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x05
	jp	C, 00102$
;src/opening.c:68: VBK_REG=0;
	xor	a, a
	ldh	(_VBK_REG + 0), a
;src/opening.c:69: }
	add	sp, #5
	ret
	.area _CODE_132
	.area _INITIALIZER
	.area _CABS (ABS)
