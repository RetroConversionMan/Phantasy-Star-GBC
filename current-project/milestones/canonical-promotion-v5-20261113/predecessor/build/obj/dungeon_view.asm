;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_view
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_dungeon_motion_render
	.globl _dungeon_motion_render
	.globl _bank_copy
	.globl b_dungeon_sample_position
	.globl _dungeon_sample_position
	.globl b_dungeon_sample
	.globl _dungeon_sample
	.globl b_dungeon_view_scene_id
	.globl _dungeon_view_scene_id
	.globl b_dungeon_draw_view
	.globl _dungeon_draw_view
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
	.area _CODE_17
;src/dungeon_view.c:14: static uint16_t asset_word(const DungeonGraphicAsset *asset,uint16_t offset) {
;	---------------------------------
; Function asset_word
; ---------------------------------
_asset_word:
	add	sp, #-5
	ldhl	sp,	#3
	ld	a, e
	ld	(hl+), a
;src/dungeon_view.c:15: uint8_t value[2];bank_copy(value,asset->bank,asset->data+offset,2u);
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ld	de, #0x0002
	push	de
	push	bc
	ld	a, (hl)
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/dungeon_view.c:16: return (uint16_t)value[0]|((uint16_t)value[1]<<8);
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	xor	a, a
;src/dungeon_view.c:17: }
	add	sp, #5
	ret
;src/dungeon_view.c:18: uint16_t dungeon_view_scene_id(const DungeonState *state) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_view_scene_id
; ---------------------------------
	b_dungeon_view_scene_id	= 17
_dungeon_view_scene_id::
	add	sp, #-6
;src/dungeon_view.c:20: uint16_t key=0;
	xor	a, a
	ldhl	sp,	#3
	ld	(hl+), a
	ld	(hl), a
;src/dungeon_view.c:21: pos=dungeon_sample_position(state,1u);front=state->layout[pos];
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	c, a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	c, (hl)
;src/dungeon_view.c:22: if(front&7u) {
	ld	a, c
	and	a, #0x07
	jr	Z, 00131$
;src/dungeon_view.c:23: kind=(front&7u)|((front&128u)?8u:0u);
	ld	a, c
	and	a, #0x07
	bit	7, c
	ld	c, #0x08
	jr	NZ, 00113$
	ld	c, #0x00
00113$:
	or	a, c
;src/dungeon_view.c:24: return asset_word(&dungeon_view_front,(uint16_t)kind*2u);
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	de, #_dungeon_view_front
	call	_asset_word
	jp	00110$
;src/dungeon_view.c:26: for(depth=0;depth<3u;++depth) {
00131$:
	ldhl	sp,	#5
	ld	(hl), #0x00
00108$:
;src/dungeon_view.c:27: front=dungeon_sample(state,depth*3u+4u)&7u;
	ldhl	sp,	#5
	ld	a, (hl)
	ld	c, a
	add	a, a
	add	a, c
	ldhl	sp,	#2
	ld	(hl-), a
	dec	hl
	inc	a
	inc	a
	inc	a
	inc	a
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_view.c:28: kind=!front?0u:(front==1u||front==7u)?1u:2u;
	and	a, #0x07
	jr	NZ, 00114$
	ld	e, a
	jr	00115$
00114$:
	cp	a, #0x01
	jr	Z, 00119$
	sub	a, #0x07
	jr	NZ, 00116$
00119$:
	ld	e, #0x01
	jr	00117$
00116$:
	ld	e, #0x02
00117$:
00115$:
;src/dungeon_view.c:29: nibble=(dungeon_sample(state,depth*3u+2u)&7u)?1u:0u;
	ldhl	sp,	#2
	ld	a, (hl)
	inc	a
	inc	a
	push	de
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	and	a, #0x07
	jr	Z, 00121$
	ld	d, #0x01
	jr	00122$
00121$:
	ld	d, #0x00
00122$:
;src/dungeon_view.c:30: if(dungeon_sample(state,depth*3u+3u)&7u)nibble|=2u;
	ldhl	sp,	#2
	ld	a, (hl)
	inc	a
	inc	a
	inc	a
	push	de
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	and	a, #0x07
	jr	Z, 00104$
	set	1, d
00104$:
;src/dungeon_view.c:31: nibble|=kind<<2;
	ld	a, e
	add	a, a
	add	a, a
	or	a, d
;src/dungeon_view.c:32: key|=(uint16_t)nibble<<(depth*4u);
	ld	c, a
	ld	b, #0x00
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, a
	add	a, a
	ld	d, a
	inc	d
	jr	00189$
00188$:
	sla	c
	rl	b
00189$:
	dec	d
	jr	NZ,00188$
	dec	hl
	dec	hl
	ld	a, (hl)
	or	a, c
	ld	(hl+), a
	ld	a, (hl)
	or	a, b
	ld	(hl), a
;src/dungeon_view.c:33: if(kind)break;
	ld	a, e
	or	a, a
	jr	NZ, 00107$
;src/dungeon_view.c:26: for(depth=0;depth<3u;++depth) {
	inc	hl
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jp	C, 00108$
00107$:
;src/dungeon_view.c:35: return asset_word(&dungeon_view_index,key*2u);
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	b, (hl)
	add	a, a
	rl	b
	ld	c, a
	ld	de, #_dungeon_view_index
	call	_asset_word
00110$:
;src/dungeon_view.c:36: }
	add	sp, #6
	ret
;src/dungeon_view.c:37: uint8_t dungeon_draw_view(const DungeonState *state) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_draw_view
; ---------------------------------
	b_dungeon_draw_view	= 17
_dungeon_draw_view::
;src/dungeon_view.c:39: return dungeon_motion_render(state,0);
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_motion_render
	ld	hl, #_dungeon_motion_render
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_view.c:62: }
	ret
	.area _CODE_17
	.area _INITIALIZER
	.area _CABS (ABS)
