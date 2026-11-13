;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module scene
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl b_scene_palette_capture
	.globl _scene_palette_capture
	.globl b_scene_palette_commit
	.globl _scene_palette_commit
	.globl _set_bkg_palette
	.globl _set_bkg_tiles
	.globl _scene_shared_colors
	.globl _scene_shared_bytes
	.globl b_scene_show
	.globl _scene_show
	.globl b_scene_show_room
	.globl _scene_show_room
	.globl b_scene_palette_prepare
	.globl _scene_palette_prepare
	.globl b_scene_palette_flash
	.globl _scene_palette_flash
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_scene_shared_bytes::
	.ds 40
_scene_shared_colors::
	.ds 64
_map_row:
	.ds 20
_attribute_row:
	.ds 20
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_active_scene:
	.ds 2
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
	.area _CODE_13
;src/scene.c:11: uint8_t scene_show(uint8_t type,uint8_t portrait,uint8_t enemy) __banked {
;	---------------------------------
; Function scene_show
; ---------------------------------
	b_scene_show	= 13
_scene_show::
	add	sp, #-16
;src/scene.c:14: uint8_t row,col,index,vram_bank,found=0;
	ldhl	sp,	#5
	ld	(hl), #0x00
;src/scene.c:15: uint16_t n,word,pattern,cell=0;
	xor	a, a
	ldhl	sp,	#14
	ld	(hl+), a
	ld	(hl), a
;src/scene.c:16: for(n=0;n<SCENE_ASSET_COUNT;++n) {
	xor	a, a
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), a
	xor	a, a
	ldhl	sp,	#10
	ld	(hl+), a
	ld	(hl), a
00113$:
;src/scene.c:17: asset=scene_assets+n;
	ldhl	sp,#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
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
	ld	d, (hl)
	ld	hl, #_scene_assets
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
;src/scene.c:18: if(asset->type==type && asset->portrait==portrait && asset->enemy==enemy) {found=1;break;}
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#22
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00114$
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
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
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#23
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00114$
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	ld	c, (hl)
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00114$
	ldhl	sp,	#5
	ld	(hl), #0x01
	jr	00105$
00114$:
;src/scene.c:16: for(n=0;n<SCENE_ASSET_COUNT;++n) {
	ldhl	sp,	#10
	inc	(hl)
	jr	NZ, 00244$
	inc	hl
	inc	(hl)
00244$:
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	sub	a, #0xa9
	ld	a, b
	sbc	a, #0x00
	jp	C, 00113$
00105$:
;src/scene.c:20: if(!found)return 0;
	ldhl	sp,	#5
	ld	a, (hl)
	or	a,a
	jp	Z, 00123$
;src/scene.c:21: active_scene=n;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_active_scene),a
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(#_active_scene + 1),a
;src/scene.c:22: bank_copy(scene_shared_colors,asset->bank,asset->map+600u,56u);
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0258
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
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
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#13
	ld	(hl), a
	ld	de, #0x0038
	push	de
	push	bc
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
;src/scene.c:23: set_bkg_palette(0,7,scene_shared_colors);
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/scene.c:24: for(row=0;row<15u;++row) {
	ldhl	sp,	#12
	ld	(hl), #0x00
00117$:
;src/scene.c:25: bank_copy(scene_shared_bytes,asset->bank,asset->map+(uint16_t)row*40u,40u);
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
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
	ld	c, l
	ld	b, h
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	de, #0x0028
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/scene.c:26: for(col=0;col<20u;++col,++cell) {
	ldhl	sp,	#13
	ld	(hl), #0x00
00115$:
;src/scene.c:27: word=scene_shared_bytes[col*2u]|((uint16_t)scene_shared_bytes[col*2u+1u]<<8);
	ldhl	sp,	#13
	ld	c, (hl)
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	ld	de, #_scene_shared_bytes
	add	hl, de
	ld	e, (hl)
	ldhl	sp,	#13
	ld	a, (hl)
	add	a, a
	inc	a
	ld	l, a
	ld	h, #0x00
	ld	bc, #_scene_shared_bytes
	add	hl, bc
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, e
	ld	(hl+), a
;src/scene.c:28: pattern=word&8191u;pool=scene_pattern_pools+(pattern>>9);
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	and	a, #0x1f
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ld	a, (hl)
	srl	a
	ld	c, a
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	a, l
	add	a, #<(_scene_pattern_pools)
	ld	c, a
	ld	a, h
	adc	a, #>(_scene_pattern_pools)
	ldhl	sp,	#8
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/scene.c:29: vram_bank=cell>=256u;
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	a, (hl)
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ldhl	sp,	#10
	ld	(hl), a
;src/scene.c:30: index=vram_bank?(uint8_t)(cell-256u+64u):(uint8_t)cell;
	ldhl	sp,	#14
	ld	c, (hl)
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00125$
	ld	a, c
	add	a, #0x40
	jr	00126$
00125$:
	ld	a, c
00126$:
	ldhl	sp,	#11
	ld	(hl), a
;src/scene.c:31: bank_bkg_data(pool->bank,index,1u,pool->data+((pattern&511u)<<4),vram_bank);
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl)
	ld	l, e
	and	a, #0x01
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	h, (hl)
	push	hl
	inc	sp
	push	bc
	ld	h, #0x01
	push	hl
	inc	sp
	ldhl	sp,	#15
	ld	e, (hl)
	call	_bank_bkg_data
;src/scene.c:32: map_row[col]=index;attribute_row[col]=(uint8_t)(word>>13)|(vram_bank?8u:0u);
	ld	de, #_map_row
	ldhl	sp,	#13
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#11
	ld	a, (hl+)
	inc	hl
	ld	(bc), a
	ld	de, #_attribute_row
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl)
	swap	a
	rrca
	and	a, #0x07
	ld	c, a
	ldhl	sp,	#11
	ld	a, c
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	ld	c, #0x08
	jr	NZ, 00128$
	ld	c, #0x00
00128$:
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, c
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/scene.c:26: for(col=0;col<20u;++col,++cell) {
	ldhl	sp,	#13
	inc	(hl)
	inc	hl
	inc	(hl)
	jr	NZ, 00245$
	inc	hl
	inc	(hl)
00245$:
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x14
	jp	C, 00115$
;src/scene.c:34: VBK_REG=0;set_bkg_tiles(0,row,20,1,map_row);
	dec	hl
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_map_row
	push	de
	ld	de, #0x114
	push	de
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/scene.c:35: VBK_REG=1;set_bkg_tiles(0,row,20,1,attribute_row);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_attribute_row
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#16
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/scene.c:24: for(row=0;row<15u;++row) {
	ldhl	sp,	#12
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0f
	jp	C, 00117$
;src/scene.c:38: for(col=0;col<20u;++col){map_row[col]=0;attribute_row[col]=15;}
	ld	c, #0x00
00119$:
	ld	hl, #_map_row
	ld	b, #0x00
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #_attribute_row
	ld	b, #0x00
	add	hl, bc
	ld	(hl), #0x0f
	inc	c
	ld	a, c
	sub	a, #0x14
	jr	C, 00119$
;src/scene.c:39: for(row=15;row<18u;++row){
	ld	b, #0x0f
00121$:
;src/scene.c:40: VBK_REG=0;set_bkg_tiles(0,row,20,1,map_row);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_map_row
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
;src/scene.c:41: VBK_REG=1;set_bkg_tiles(0,row,20,1,attribute_row);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_attribute_row
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
;src/scene.c:39: for(row=15;row<18u;++row){
	inc	b
	ld	a, b
	sub	a, #0x12
	jr	C, 00121$
;src/scene.c:43: VBK_REG=0;move_bkg(0,0);return 1;
	xor	a, a
	ldh	(_VBK_REG + 0), a
;.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/scene.c:43: VBK_REG=0;move_bkg(0,0);return 1;
	ld	a, #0x01
00123$:
;src/scene.c:44: }
	add	sp, #16
	ret
;src/scene.c:46: uint8_t scene_show_room(uint8_t palette_index,uint8_t portrait,uint8_t enemy) __banked {
;	---------------------------------
; Function scene_show_room
; ---------------------------------
	b_scene_show_room	= 13
_scene_show_room::
;src/scene.c:47: if(palette_index>11u)return 0;
	ld	a, #0x0b
	ldhl	sp,	#6
	sub	a, (hl)
	jr	NC, 00102$
	xor	a, a
	ret
00102$:
;src/scene.c:48: return scene_show(64u+palette_index,portrait,enemy);
	ldhl	sp,	#6
	ld	a, (hl+)
	inc	hl
	add	a, #0x40
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#8
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/scene.c:49: }
	ret
;src/scene.c:54: void scene_palette_prepare(uint8_t effect,uint8_t white) __banked {
;	---------------------------------
; Function scene_palette_prepare
; ---------------------------------
	b_scene_palette_prepare	= 13
_scene_palette_prepare::
	add	sp, #-6
;src/scene.c:56: if(active_scene==65535u)return;
	ld	a, (_active_scene)
	ld	c, a
	ld	hl, #_active_scene + 1
	ld	a, c
	and	a, (hl)
	inc	a
	jp	Z, 00119$
;src/scene.c:57: asset=scene_assets+active_scene;
	ld	hl, #_active_scene
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc, #_scene_assets
	add	hl, bc
	ld	c, l
	ld	b, h
;src/scene.c:58: bank_copy(scene_palette_background,asset->bank,asset->map+600u,56u);
	ld	hl, #0x0004
	add	hl, bc
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
	ld	de, #0x258
	add	hl, de
	ld	e, l
	ld	d, h
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#5
	ld	(hl), a
	push	bc
	ld	hl, #0x0038
	push	hl
	push	de
	ldhl	sp,	#11
	ld	a, (hl)
	ld	de, #_scene_palette_background
	call	_bank_copy
	pop	bc
;src/scene.c:59: if(white){
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jp	Z, 00119$
;src/scene.c:60: bank_copy(scene_shared_bytes,asset->bank,asset->map+656u,21u);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	de, #0x290
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	ld	c, a
	ld	hl, #0x0015
	push	hl
	push	de
	ld	a, c
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/scene.c:61: for(p=0;p<7u;++p){
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	and	a, #0x01
	ld	(hl), a
	ldhl	sp,	#4
	ld	(hl), #0x00
00117$:
;src/scene.c:62: mask=0;if(effect&1u)mask|=scene_shared_bytes[p];
	ldhl	sp,	#5
	ld	(hl), #0x00
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	ld	de, #_scene_shared_bytes
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
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
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
00104$:
;src/scene.c:63: if(effect&2u)mask|=scene_shared_bytes[p+7u];
	push	hl
	ldhl	sp,	#2
	bit	1, (hl)
	pop	hl
	jr	Z, 00106$
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, #0x07
	ld	l, a
	ld	h, #0x00
	ld	de, #_scene_shared_bytes
	add	hl, de
	ld	c, (hl)
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, c
	ld	(hl), a
00106$:
;src/scene.c:64: if(effect&4u)mask|=scene_shared_bytes[p+14u];
	push	hl
	ldhl	sp,	#2
	bit	2, (hl)
	pop	hl
	jr	Z, 00127$
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, #0x0e
	ld	l, a
	ld	h, #0x00
	ld	de, #_scene_shared_bytes
	add	hl, de
	ld	c, (hl)
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, c
	ld	(hl), a
;src/scene.c:65: for(c=0;c<4u;++c)if(mask&(1u<<c))scene_palette_background[p*4u+c]=RGB(31,31,31);
00127$:
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, a
	add	a, a
	ld	c, a
	ld	b, #0x00
00115$:
	push	bc
	ld	de, #0x0001
	pop	af
	inc	a
	jr	00191$
00190$:
	sla	e
	rl	d
00191$:
	dec	a
	jr	NZ,00190$
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, e
	and	a, (hl)
	ld	e, a
	ld	d, #0x00
	ld	a, d
	or	a, e
	jr	Z, 00116$
	ld	a, c
	add	a, b
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	ld	de, #_scene_palette_background
	add	hl, de
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0x7f
00116$:
	inc	b
	ld	a, b
	sub	a, #0x04
	jr	C, 00115$
;src/scene.c:61: for(p=0;p<7u;++p){
	ldhl	sp,	#4
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x07
	jp	C, 00117$
00119$:
;src/scene.c:68: }
	add	sp, #6
	ret
;src/scene.c:70: void scene_palette_flash(uint8_t effect,uint8_t white) __banked {
;	---------------------------------
; Function scene_palette_flash
; ---------------------------------
	b_scene_palette_flash	= 13
_scene_palette_flash::
;src/scene.c:71: scene_palette_capture();scene_palette_prepare(effect,white);scene_palette_commit();
	ld	e, #b_scene_palette_capture
	ld	hl, #_scene_palette_capture
	call	___sdcc_bcall_ehl
	ldhl	sp,	#7
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	ld	e, #b_scene_palette_prepare
	ld	hl, #_scene_palette_prepare
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, #b_scene_palette_commit
	ld	hl, #_scene_palette_commit
;src/scene.c:72: }
	jp  ___sdcc_bcall_ehl
	.area _CODE_13
	.area _INITIALIZER
__xinit__active_scene:
	.dw #0xffff
	.area _CABS (ABS)
