;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module gold_scene
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl b_scene_palette_commit
	.globl _scene_palette_commit
	.globl _set_bkg_palette
	.globl _set_bkg_tiles
	.globl b_gold_scene_prepare
	.globl _gold_scene_prepare
	.globl b_gold_scene_show
	.globl _gold_scene_show
	.globl b_gold_scene_blue
	.globl _gold_scene_blue
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
;src/gold_scene.c:9: void gold_scene_prepare(uint8_t phase,uint8_t effect,uint8_t white) __banked {
;	---------------------------------
; Function gold_scene_prepare
; ---------------------------------
	b_gold_scene_prepare	= 31
_gold_scene_prepare::
	add	sp, #-7
;src/gold_scene.c:10: uint8_t i,p,c,mask;if(phase>2u)return;
	ld	a, #0x02
	ldhl	sp,	#13
	sub	a, (hl)
	jp	C, 00118$
;src/gold_scene.c:11: bank_copy(scene_palette_background,GOLD_SCENE_BANK,gold_scene_data+GOLD_SCENE_PALETTE+(uint16_t)phase*56u,56u);
	ldhl	sp,	#13
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #(_gold_scene_data + 2472)
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x0038
	push	de
	push	bc
	ld	a, #0x7b
	ld	de, #_scene_palette_background
	call	_bank_copy
;src/gold_scene.c:12: if(!white)return;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	jp	Z, 00118$
;src/gold_scene.c:13: bank_copy(scene_shared_bytes,GOLD_SCENE_BANK,gold_scene_data+GOLD_SCENE_MASKS,21u);
	ld	bc, #_scene_shared_bytes+0
	ld	e, c
	ld	d, b
	push	bc
	ld	hl, #0x0015
	push	hl
	ld	hl, #(_gold_scene_data + 2640)
	push	hl
	ld	a, #0x7b
	call	_bank_copy
	pop	bc
;src/gold_scene.c:14: for(p=0;p<7u;++p){mask=0;for(i=0;i<3u;++i)if(effect&(1u<<i))mask|=scene_shared_bytes[i*7u+p];
	ldhl	sp,	#5
	ld	(hl), #0x00
00116$:
	ldhl	sp,	#6
	xor	a, a
	ld	(hl-), a
	dec	hl
	ld	(hl), #0x00
00112$:
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	ld	de, #0x0001
	pop	af
	inc	a
	jr	00187$
00186$:
	sla	e
	rl	d
00187$:
	dec	a
	jr	NZ,00186$
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	and	a, e
	ld	e, #0x00
	or	a, e
	jr	Z, 00113$
	inc	hl
	inc	hl
	ld	a, (hl-)
	ld	e, a
	add	a, a
	add	a, a
	add	a, a
	sub	a, e
	ld	(hl), a
	ld	a, (hl+)
	inc	hl
	add	a, (hl)
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	e, (hl)
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, e
	ld	(hl), a
00113$:
	ldhl	sp,	#4
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jr	C, 00112$
;src/gold_scene.c:15: for(c=0;c<4u;++c)if(mask&(1u<<c))scene_palette_background[p*4u+c]=RGB(31,31,31);
	inc	hl
	ld	a, (hl)
	add	a, a
	add	a, a
	ldhl	sp,	#0
	ld	(hl), a
	ld	d, #0x00
00114$:
	push	de
	ldhl	sp,	#3
	ld	a, #0x01
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	pop	af
	inc	a
	jr	00189$
00188$:
	ldhl	sp,	#1
	sla	(hl)
	inc	hl
	rl	(hl)
00189$:
	dec	a
	jr	NZ,00188$
	ldhl	sp,	#6
	ld	a, (hl)
	ld	e, #0x00
	ldhl	sp,	#1
	and	a, (hl)
	inc	hl
	inc	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	or	a, (hl)
	jr	Z, 00115$
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, d
	ld	e, #0x00
	add	a, a
	rl	e
	add	a, #<(_scene_palette_background)
	ld	l, a
	ld	a, e
	adc	a, #>(_scene_palette_background)
	ld	h, a
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0x7f
00115$:
	inc	d
	ld	a, d
	sub	a, #0x04
	jr	C, 00114$
;src/gold_scene.c:14: for(p=0;p<7u;++p){mask=0;for(i=0;i<3u;++i)if(effect&(1u<<i))mask|=scene_shared_bytes[i*7u+p];
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x07
	jp	C, 00116$
00118$:
;src/gold_scene.c:17: }
	add	sp, #7
	ret
;src/gold_scene.c:18: void gold_scene_show(uint8_t phase) __banked {
;	---------------------------------
; Function gold_scene_show
; ---------------------------------
	b_gold_scene_show	= 31
_gold_scene_show::
	dec	sp
;src/gold_scene.c:20: bank_bkg_data(GOLD_SCENE_BANK,0u,GOLD_SCENE_TILES,gold_scene_data,0u);
	xor	a, a
	push	af
	inc	sp
	ld	de, #_gold_scene_data
	push	de
	ld	a, #0x75
	push	af
	inc	sp
	ld	e, #0x00
	ld	a, #0x7b
	call	_bank_bkg_data
;src/gold_scene.c:21: for(row=0;row<15u;++row){
	ldhl	sp,	#0
	ld	(hl), #0x00
00105$:
;src/gold_scene.c:22: bank_copy(scene_shared_bytes,GOLD_SCENE_BANK,gold_scene_data+GOLD_SCENE_MAP+(uint16_t)row*20u,20u);
	ldhl	sp,	#0
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
	ld	hl, #(_gold_scene_data + 1872)
	add	hl, bc
	push	bc
	ld	de, #0x0014
	push	de
	push	hl
	ld	a, #0x7b
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	pop	bc
;src/gold_scene.c:23: bank_copy(scene_shared_bytes+20u,GOLD_SCENE_BANK,gold_scene_data+GOLD_SCENE_MAP+300u+(uint16_t)row*20u,20u);
	ld	hl, #(_gold_scene_data + 2172)
	add	hl, bc
	ld	de, #0x0014
	push	de
	push	hl
	ld	a, #0x7b
	ld	de, #(_scene_shared_bytes + 20)
	call	_bank_copy
;src/gold_scene.c:24: VBK_REG=0;set_bkg_tiles(0u,row,20u,1u,scene_shared_bytes);VBK_REG=1;set_bkg_tiles(0u,row,20u,1u,scene_shared_bytes+20u);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #(_scene_shared_bytes + 20)
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/gold_scene.c:21: for(row=0;row<15u;++row){
	ldhl	sp,	#0
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0f
	jr	C, 00105$
;src/gold_scene.c:26: for(i=0;i<20u;++i){scene_shared_bytes[i]=0;scene_shared_bytes[i+20u]=15u;}
	ld	c, #0x00
00107$:
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
	jr	C, 00107$
;src/gold_scene.c:27: for(row=15u;row<18u;++row){VBK_REG=0;set_bkg_tiles(0u,row,20u,1u,scene_shared_bytes);VBK_REG=1;set_bkg_tiles(0u,row,20u,1u,scene_shared_bytes+20u);}
	ld	b, #0x0f
00109$:
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
	jr	C, 00109$
;src/gold_scene.c:28: VBK_REG=0;move_bkg(0,0);gold_scene_prepare(phase,0u,0u);set_bkg_palette(0u,7u,scene_palette_background);
	xor	a, a
	ldh	(_VBK_REG + 0), a
;.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/gold_scene.c:28: VBK_REG=0;move_bkg(0,0);gold_scene_prepare(phase,0u,0u);set_bkg_palette(0u,7u,scene_palette_background);
	xor	a, a
	rrca
	push	af
	ldhl	sp,	#9
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_gold_scene_prepare
	ld	hl, #_gold_scene_prepare
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	de, #_scene_palette_background
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
;src/gold_scene.c:29: }
	add	sp, #5
	ret
;src/gold_scene.c:30: void gold_scene_blue(void) __banked {
;	---------------------------------
; Function gold_scene_blue
; ---------------------------------
	b_gold_scene_blue	= 31
_gold_scene_blue::
;src/gold_scene.c:31: uint8_t i;gold_scene_prepare(0u,0u,0u);for(i=0;i<32u;++i)scene_shared_colors[i]=RGB(0,0,31);
	xor	a, a
	rrca
	push	af
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_gold_scene_prepare
	ld	hl, #_gold_scene_prepare
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	bc, #_scene_shared_colors+0
	ld	e, #0x00
00102$:
	ld	l, e
	ld	h, #0x00
	add	hl, hl
	add	hl, bc
	xor	a, a
	ld	(hl+), a
	ld	(hl), #0x7c
	inc	e
	ld	a, e
	sub	a, #0x20
	jr	C, 00102$
;src/gold_scene.c:32: scene_palette_commit();
	ld	e, #b_scene_palette_commit
	ld	hl, #_scene_palette_commit
;src/gold_scene.c:33: }
	jp  ___sdcc_bcall_ehl
	.area _CODE_31
	.area _INITIALIZER
	.area _CABS (ABS)
