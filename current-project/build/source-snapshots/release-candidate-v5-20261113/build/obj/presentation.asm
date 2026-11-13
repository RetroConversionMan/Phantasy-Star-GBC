;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module presentation
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_game_transition_vint16
	.globl _game_transition_vint16
	.globl b_scene_actor_show_data
	.globl _scene_actor_show_data
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl _set_sprite_palette
	.globl _set_bkg_palette
	.globl _set_bkg_tiles
	.globl _presentation_frame
	.globl _presentation_active
	.globl b_presentation_begin
	.globl _presentation_begin
	.globl b_presentation_tick
	.globl _presentation_tick
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_presentation_active::
	.ds 1
_presentation_frame::
	.ds 2
_palette_index:
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
	.area _CODE_12
;src/presentation.c:14: static void effect_palette(uint8_t index) __banked {
;	---------------------------------
; Function effect_palette
; ---------------------------------
	b_effect_palette	= 12
_effect_palette:
	add	sp, #-7
;src/presentation.c:15: const PresentationAsset *a=presentation_assets+presentation_active-1u;
	ld	hl, #_presentation_active
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	bc, #_presentation_assets
	add	hl, bc
	ld	bc, #0xfff9
	add	hl,bc
;src/presentation.c:16: uint16_t offset=a->tiles*16u;
	ld	c,l
	ld	b,h
	inc	hl
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	d, h
;src/presentation.c:17: if(a->sprites){offset+=(uint16_t)a->sprites*4u+(uint16_t)index*64u;bank_copy(scene_shared_colors,a->bank,a->data+offset,64u);set_sprite_palette(0,8,scene_shared_colors);}
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ld	hl, #0x0005
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#5
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	a, (bc)
	ld	c, a
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	ld	a, (hl+)
	ld	e, a
	xor	a, a
	ld	d, a
	sla	e
	rl	d
	sla	e
	rl	d
	ld	a, (hl+)
	inc	hl
	ld	b, #0x00
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, e
	ld	e, a
	ld	a, b
	adc	a, d
	ld	d, a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0040
	push	hl
	push	de
	ld	a, c
	ld	de, #_scene_shared_colors
	call	_bank_copy
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
	jr	00103$
00102$:
;src/presentation.c:18: else {offset+=600u+(uint16_t)index*56u;bank_copy(scene_shared_colors,a->bank,a->data+offset,56u);set_bkg_palette(0,7,scene_shared_colors);}
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #0x258
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#3
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0038
	push	hl
	push	de
	ld	a, c
	ld	de, #_scene_shared_colors
	call	_bank_copy
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
00103$:
;src/presentation.c:19: palette_index=index;
	ldhl	sp,	#13
	ld	a, (hl)
	ld	(#_palette_index),a
;src/presentation.c:20: }
	add	sp, #7
	ret
;src/presentation.c:21: uint8_t presentation_begin(uint8_t effect) __banked {
;	---------------------------------
; Function presentation_begin
; ---------------------------------
	b_presentation_begin	= 12
_presentation_begin::
	add	sp, #-11
;src/presentation.c:23: if(!effect||effect>4u)return 0;
	ldhl	sp,	#17
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x04
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jp	00119$
00102$:
;src/presentation.c:24: a=presentation_assets+effect-1u;presentation_active=effect;presentation_frame=0;
	ldhl	sp,	#17
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	ld	bc, #_presentation_assets
	add	hl, bc
	ld	a, l
	add	a, #0xf9
	ld	c, a
	ld	a, h
	adc	a, #0xff
	ldhl	sp,	#7
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ldhl	sp,	#17
	ld	a, (hl)
	ld	(#_presentation_active),a
	xor	a, a
	ld	hl, #_presentation_frame
	ld	(hl+), a
	ld	(hl), a
;src/presentation.c:25: if(a->sprites){scene_actor_show_data(a->bank,a->data,(uint8_t)a->tiles,a->sprites);}
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#5
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00110$
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#6
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#5
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#7
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	push	af
	inc	sp
	ld	e, #b_scene_actor_show_data
	ld	hl, #_scene_actor_show_data
	call	___sdcc_bcall_ehl
	add	sp, #5
	jp	00111$
00110$:
;src/presentation.c:27: scene_actor_hide();HIDE_SPRITES;
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/presentation.c:28: first=a->tiles>256u?256u:a->tiles;
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#9
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	xor	a, a
	cp	a, c
	ld	a, #0x01
	sbc	a, b
	jr	NC, 00121$
	dec	hl
	xor	a, a
	ld	(hl+), a
	ld	(hl), #0x01
00121$:
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
;src/presentation.c:29: bank_bkg_data(a->bank,0,(uint8_t)first,a->data,0);
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
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
	ldhl	sp,	#9
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	h, #0x00
	push	hl
	inc	sp
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	h, c
	push	hl
	inc	sp
	ld	e, #0x00
	call	_bank_bkg_data
;src/presentation.c:30: if(a->tiles>256u)bank_bkg_data(a->bank,64,(uint8_t)(a->tiles-256u),a->data+4096u,1);
	pop	de
	push	de
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	e, c
	ld	d, b
	xor	a, a
	cp	a, e
	ld	a, #0x01
	sbc	a, d
	jr	NC, 00105$
	ldhl	sp,#2
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
	ld	hl, #0x1000
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	h, #0x01
	push	hl
	inc	sp
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	h, c
	push	hl
	inc	sp
	ld	e, #0x40
	call	_bank_bkg_data
00105$:
;src/presentation.c:31: offset=a->tiles*16u;
	pop	de
	push	de
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/presentation.c:32: for(row=0;row<15u;++row){
	ldhl	sp,	#10
	ld	(hl), #0x00
00113$:
;src/presentation.c:33: bank_copy(scene_shared_bytes,a->bank,a->data+offset+(uint16_t)row*20u,20u);VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#10
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
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	de, #0x0014
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#14
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/presentation.c:34: bank_copy(scene_shared_bytes,a->bank,a->data+offset+300u+(uint16_t)row*20u,20u);VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	bc, #0x012c
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	de, #0x0014
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x114
	push	hl
	ldhl	sp,	#14
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/presentation.c:32: for(row=0;row<15u;++row){
	ldhl	sp,	#10
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0f
	jp	C, 00113$
;src/presentation.c:36: for(col=0;col<20u;++col){scene_shared_bytes[col]=0;scene_shared_bytes[col+20u]=15;}
	ld	(hl), #0x00
00115$:
	ld	de, #_scene_shared_bytes
	ldhl	sp,	#10
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#10
	ld	a, (hl)
	add	a, #0x14
	ld	l, a
	ld	h, #0x00
	ld	de, #_scene_shared_bytes
	add	hl, de
	ld	(hl), #0x0f
	ldhl	sp,	#10
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00115$
;src/presentation.c:37: for(row=15;row<18u;++row){VBK_REG=0;set_bkg_tiles(0,row,20,1,scene_shared_bytes);VBK_REG=1;set_bkg_tiles(0,row,20,1,scene_shared_bytes+20);}
	ld	b, #0x0f
00117$:
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
	jr	C, 00117$
;src/presentation.c:38: VBK_REG=0;move_bkg(0,0);
	xor	a, a
	ldh	(_VBK_REG + 0), a
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/presentation.c:38: VBK_REG=0;move_bkg(0,0);
00111$:
;src/presentation.c:40: effect_palette(effect==PRESENT_ODIN?0u:1u);return 1;
	ldhl	sp,	#17
	ld	a, (hl)
	dec	a
	jr	NZ, 00123$
	xor	a, a
	jr	00124$
00123$:
	ld	a, #0x01
00124$:
	push	af
	inc	sp
	ld	e, #b_effect_palette
	ld	hl, #_effect_palette
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x01
00119$:
;src/presentation.c:41: }
	add	sp, #11
	ret
;src/presentation.c:42: uint8_t presentation_tick(void) __banked {
;	---------------------------------
; Function presentation_tick
; ---------------------------------
	b_presentation_tick	= 12
_presentation_tick::
	add	sp, #-4
;src/presentation.c:43: uint8_t index=0;uint16_t duration;
	ld	c, #0x00
;src/presentation.c:44: if(!presentation_active)return 1;
	ld	a, (#_presentation_active)
	or	a, a
	jr	NZ, 00102$
	ld	a, #0x01
	jp	00120$
00102$:
;src/presentation.c:45: game_transition_vint16();++presentation_frame;
	push	bc
	ld	e, #b_game_transition_vint16
	ld	hl, #_game_transition_vint16
	call	___sdcc_bcall_ehl
	pop	bc
	ld	hl, #_presentation_frame
	inc	(hl)
	jr	NZ, 00187$
	inc	hl
	inc	(hl)
00187$:
;src/presentation.c:47: duration=111u;if(presentation_frame>=15u){index=(uint8_t)((presentation_frame-15u)/16u)+1u;if(index>6u)index=6u;}
	ld	a, (#_presentation_frame)
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (#_presentation_frame + 1)
	ldhl	sp,	#1
	ld	(hl), a
;src/presentation.c:46: if(presentation_active==PRESENT_ODIN){
	ld	a, (#_presentation_active)
	dec	a
	jr	NZ, 00114$
;src/presentation.c:47: duration=111u;if(presentation_frame>=15u){index=(uint8_t)((presentation_frame-15u)/16u)+1u;if(index>6u)index=6u;}
	ldhl	sp,	#2
	ld	a, #0x6f
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl+)
	sub	a, #0x0f
	ld	a, (hl)
	sbc	a, #0x00
	jp	C, 00115$
	pop	de
	push	de
	ld	hl, #0x000f
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	inc	c
	ld	a, #0x06
	sub	a, c
	jr	NC, 00115$
	ld	c, #0x06
	jr	00115$
00114$:
;src/presentation.c:48: } else if(presentation_active==PRESENT_TORCH){duration=1u;index=1;}
	ld	a, (#_presentation_active)
	sub	a, #0x02
	jr	NZ, 00111$
	ldhl	sp,	#2
	ld	a, #0x01
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	c, #0x01
	jr	00115$
00111$:
;src/presentation.c:49: else if(presentation_active==PRESENT_PRISM){
	ld	a, (#_presentation_active)
	sub	a, #0x03
	jr	NZ, 00108$
;src/presentation.c:50: duration=320u;index=presentation_frame<216u?(uint8_t)((presentation_frame/3u)%24u)+1u:(uint8_t)((presentation_frame-216u)/8u)+25u;
	ldhl	sp,	#2
	ld	a, #0x40
	ld	(hl+), a
	ld	(hl), #0x01
	ldhl	sp,	#0
	ld	a, (hl+)
	sub	a, #0xd8
	ld	a, (hl)
	sbc	a, #0x00
	jr	NC, 00122$
	dec	hl
	ld	a, (hl)
	ld	e, #0x03
	call	__divuchar
	ld	a, c
	ld	e, #0x18
	call	__moduchar
	inc	c
	jr	00115$
00122$:
	pop	de
	push	de
	ld	hl, #0x00d8
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	ld	a, c
	add	a, #0x19
	ld	c, a
	jr	00115$
00108$:
;src/presentation.c:51: } else {duration=216u;index=(uint8_t)(presentation_frame/24u)+1u;}
	ldhl	sp,	#2
	ld	a, #0xd8
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ld	bc, #0x0018
	pop	de
	push	de
	call	__divuint
	inc	c
00115$:
;src/presentation.c:52: if(presentation_frame>=duration){presentation_active=0;return 1;}
	ld	de, #_presentation_frame
	ldhl	sp,	#2
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00117$
	xor	a, a
	ld	(#_presentation_active),a
	ld	a, #0x01
	jr	00120$
00117$:
;src/presentation.c:53: if(index!=palette_index)effect_palette(index);
	ld	a, (#_palette_index)
	sub	a, c
	jr	Z, 00119$
	ld	a, c
	push	af
	inc	sp
	ld	e, #b_effect_palette
	ld	hl, #_effect_palette
	call	___sdcc_bcall_ehl
	inc	sp
00119$:
;src/presentation.c:54: return 0;
	xor	a, a
00120$:
;src/presentation.c:55: }
	add	sp, #4
	ret
	.area _CODE_12
	.area _INITIALIZER
	.area _CABS (ABS)
