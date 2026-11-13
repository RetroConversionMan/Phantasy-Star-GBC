;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_motion
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_dungeon_view_scene_id
	.globl _dungeon_view_scene_id
	.globl _dungeon_motion_upload_end
	.globl _dungeon_motion_prepare_variant
	.globl _dungeon_motion_expand_map
	.globl _dungeon_motion_upload_begin
	.globl _dungeon_motion_home
	.globl _bank_copy
	.globl b_dungeon_sample_position
	.globl _dungeon_sample_position
	.globl b_dungeon_sample
	.globl _dungeon_sample
	.globl b_dungeon_motion_scene
	.globl _dungeon_motion_scene
	.globl b_dungeon_motion_render_image
	.globl _dungeon_motion_render_image
	.globl b_dungeon_motion_door_image
	.globl _dungeon_motion_door_image
	.globl b_dungeon_motion_render
	.globl _dungeon_motion_render
	.globl b_dungeon_motion_sequence_frame
	.globl _dungeon_motion_sequence_frame
	.globl b_dungeon_motion_turn_sequence
	.globl _dungeon_motion_turn_sequence
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_last_image:
	.ds 2
_last_palette:
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
	.area _CODE_77
;src/dungeon_motion.c:11: static uint16_t word(const DungeonGraphicAsset *a,uint16_t offset) {
;	---------------------------------
; Function word
; ---------------------------------
_word:
	add	sp, #-5
	ldhl	sp,	#3
	ld	a, e
	ld	(hl+), a
;src/dungeon_motion.c:12: uint8_t bytes[2];bank_copy(bytes,a->bank,a->data+offset,2u);return(uint16_t)bytes[0]|((uint16_t)bytes[1]<<8);
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
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	xor	a, a
;src/dungeon_motion.c:13: }
	add	sp, #5
	ret
;src/dungeon_motion.c:14: uint16_t dungeon_motion_scene(const DungeonState *s,uint8_t frame) __banked {
;	---------------------------------
; Function dungeon_motion_scene
; ---------------------------------
	b_dungeon_motion_scene	= 77
_dungeon_motion_scene::
	add	sp, #-8
;src/dungeon_motion.c:15: uint16_t key=0,view;uint8_t depth,front,kind,nibble;
	xor	a, a
	ldhl	sp,	#5
	ld	(hl+), a
	ld	(hl), a
;src/dungeon_motion.c:16: if(frame>=38u)return 65535u;
	ldhl	sp,	#16
	ld	a, (hl)
	sub	a, #0x26
	jr	C, 00102$
	ld	bc, #0xffff
	jp	00118$
00102$:
;src/dungeon_motion.c:17: if(frame>6u)return motion_fixed[frame];
	ld	a, #0x06
	ldhl	sp,	#16
	sub	a, (hl)
	jr	NC, 00104$
	ld	bc, #_motion_fixed+0
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	jp	00118$
00104$:
;src/dungeon_motion.c:18: if(frame==0u)return motion_lookup[0][dungeon_view_scene_id(s)];
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	NZ, 00106$
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_view_scene_id
	ld	hl, #_dungeon_view_scene_id
	call	___sdcc_bcall_ehl
	pop	hl
	ld	l, c
	ld	h, b
	add	hl, hl
	ld	de, #_motion_lookup
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	jp	00118$
00106$:
;src/dungeon_motion.c:19: if(frame==6u){front=s->layout[dungeon_sample_position(s,1u)];kind=(front&7u)|((front&128u)?8u:0u);if(!(kind&7u))kind=1u;
	ldhl	sp,	#16
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00145$
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0008
	add	hl, bc
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	hl
	ld	e, a
	ld	d, #0x00
	add	hl, de
	ld	h, (hl)
	ld	a, h
	and	a, #0x07
	add	hl, hl
	jr	NC, 00120$
	ld	c, #0x08
	jr	00121$
00120$:
	ld	c, #0x00
00121$:
	or	a, c
	ld	l, a
	and	a, #0x07
	jr	NZ, 00108$
	ld	l, #0x01
00108$:
;src/dungeon_motion.c:20: view=word(&dungeon_view_front,(uint16_t)kind*2u);return motion_lookup[0][view];}
	ld	h, #0x00
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	de, #_dungeon_view_front
	call	_word
	ld	de, #_motion_lookup+0
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	jp	00118$
;src/dungeon_motion.c:21: for(depth=0;depth<3u;++depth) {
00145$:
	ldhl	sp,	#7
	ld	(hl), #0x00
00116$:
;src/dungeon_motion.c:22: front=dungeon_sample(s,depth*3u+4u)&7u;kind=!front?0u:(front==1u||front==7u)?1u:2u;
	ldhl	sp,	#7
	ld	a, (hl)
	ld	c, a
	add	a, a
	add	a, c
	ldhl	sp,	#3
	ld	(hl), a
	inc	a
	inc	a
	inc	a
	inc	a
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	and	a, #0x07
	ldhl	sp,	#4
	ld	(hl), a
	or	a, a
	jr	NZ, 00122$
	ld	(hl), a
	jr	00123$
00122$:
	ldhl	sp,	#4
	ld	a, (hl)
	dec	a
	jr	Z, 00127$
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00124$
00127$:
	ldhl	sp,	#4
	ld	(hl), #0x01
	jr	00125$
00124$:
	ldhl	sp,	#4
	ld	(hl), #0x02
00125$:
00123$:
	ldhl	sp,	#4
	ld	a, (hl-)
	dec	hl
;src/dungeon_motion.c:23: nibble=(dungeon_sample(s,depth*3u+2u)&7u)?1u:0u;
	ld	(hl+), a
	ld	a, (hl)
	inc	a
	inc	a
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	and	a, #0x07
	ld	a, #0x01
	jr	NZ, 00130$
	xor	a, a
00130$:
	ldhl	sp,	#4
;src/dungeon_motion.c:24: if(dungeon_sample(s,depth*3u+3u)&7u)nibble|=2u;nibble|=kind<<2;key|=(uint16_t)nibble<<(depth*4u);
	ld	(hl-), a
	ld	a, (hl)
	inc	a
	inc	a
	inc	a
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	and	a, #0x07
	jr	Z, 00112$
	ldhl	sp,	#4
	set	1, (hl)
00112$:
	ldhl	sp,	#2
	ld	a, (hl-)
	add	a, a
	add	a, a
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#1
	or	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#7
	ld	a, (hl)
	add	a, a
	add	a, a
	ldhl	sp,	#4
	ld	(hl), a
	push	af
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl+), a
	ld	(hl), #0x00
	pop	af
	inc	a
	jr	00237$
00236$:
	ldhl	sp,	#3
	sla	(hl)
	inc	hl
	rl	(hl)
00237$:
	dec	a
	jr	NZ,00236$
	ldhl	sp,	#5
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	inc	hl
	inc	hl
	ld	(hl+), a
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	inc	hl
	inc	hl
	ld	(hl), a
;src/dungeon_motion.c:25: if(kind)break;
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	NZ, 00115$
;src/dungeon_motion.c:21: for(depth=0;depth<3u;++depth) {
	ldhl	sp,	#7
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jp	C, 00116$
00115$:
;src/dungeon_motion.c:27: view=word(&dungeon_view_index,key*2u);return view<232u?motion_lookup[frame][view]:65535u;
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	sla	c
	rl	b
	ld	de, #_dungeon_view_index
	call	_word
	ld	e, c
	ld	d, b
	ld	a, e
	sub	a, #0xe8
	ld	a, d
	sbc	a, #0x00
	jr	NC, 00131$
	ldhl	sp,	#16
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
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
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	a, l
	add	a, #<(_motion_lookup)
	ld	e, a
	ld	a, h
	adc	a, #>(_motion_lookup)
	ld	d, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	jr	00132$
00131$:
	ld	bc, #0xffff
00132$:
00118$:
;src/dungeon_motion.c:28: }
	add	sp, #8
	ret
;src/dungeon_motion.c:29: uint8_t dungeon_motion_render_image(uint16_t image,uint8_t palette) __banked {
;	---------------------------------
; Function dungeon_motion_render_image
; ---------------------------------
	b_dungeon_motion_render_image	= 77
_dungeon_motion_render_image::
	dec	sp
	dec	sp
;src/dungeon_motion.c:31: if(image>=MOTION_IMAGE_COUNT||palette>=12u)return 0;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	sub	a, #0x96
	ld	a, b
	sbc	a, #0x05
	jr	NC, 00101$
	inc	hl
	ld	a, (hl)
	sub	a, #0x0c
	jr	C, 00102$
00101$:
	xor	a, a
	jr	00104$
00102$:
;src/dungeon_motion.c:32: asset=dungeon_graphic_palettes+palette;bank_copy(dungeon_render_palette,asset->bank,asset->data+312u,56u);
	ldhl	sp,	#10
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	de, #_dungeon_graphic_palettes
	pop	hl
	push	hl
	add	hl, de
	ld	c,l
	ld	b,h
	inc	hl
	ld	a, (hl+)
	ld	l, (hl)
	add	a, #0x38
	ld	e, a
	ld	a, l
	adc	a, #0x01
	ld	d, a
	ld	a, (bc)
	ld	c, a
	ld	hl, #0x0038
	push	hl
	push	de
	ld	a, c
	ld	de, #_dungeon_render_palette
	call	_bank_copy
;src/dungeon_motion.c:33: variant=motion_variants+palette;dungeon_motion_upload_begin();dungeon_motion_expand_map(motion_maps+image);
	ld	de, #_motion_variants
	pop	hl
	push	hl
	add	hl, de
	ld	c, l
	ld	b, h
	inc	sp
	inc	sp
	push	bc
	call	_dungeon_motion_upload_begin
	ldhl	sp,#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #_motion_maps
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_dungeon_motion_expand_map
;src/dungeon_motion.c:34: dungeon_motion_prepare_variant(variant);dungeon_motion_upload_end();
	pop	de
	push	de
	call	_dungeon_motion_prepare_variant
	call	_dungeon_motion_upload_end
;src/dungeon_motion.c:35: last_image=image;last_palette=palette;return dungeon_motion_fault?0u:1u;
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(#_last_image),a
	ldhl	sp,	#9
	ld	a, (hl)
	ld	(#_last_image + 1),a
	ldhl	sp,	#10
	ld	a, (hl)
	ld	(#_last_palette),a
	ld	a, (#_dungeon_motion_fault)
	or	a, a
	jr	Z, 00106$
	xor	a, a
	jr	00107$
00106$:
	ld	a, #0x01
00107$:
00104$:
;src/dungeon_motion.c:36: }
	inc	sp
	inc	sp
	ret
;src/dungeon_motion.c:37: uint16_t dungeon_motion_door_image(uint8_t index) __banked {
;	---------------------------------
; Function dungeon_motion_door_image
; ---------------------------------
	b_dungeon_motion_door_image	= 77
_dungeon_motion_door_image::
;src/dungeon_motion.c:39: if(index>10u)return 65535u;
	ld	a, #0x0a
	ldhl	sp,	#6
	sub	a, (hl)
	jr	NC, 00102$
	ld	bc, #0xffff
	ret
00102$:
;src/dungeon_motion.c:40: kind=index<5u?index+2u:index==5u?10u:index+4u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x05
	jr	NC, 00105$
	ld	c, (hl)
	inc	c
	inc	c
	jr	00106$
00105$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x05
	jr	NZ, 00107$
	ld	c, #0x0a
	jr	00108$
00107$:
	ldhl	sp,	#6
	ld	c, (hl)
	inc	c
	inc	c
	inc	c
	inc	c
00108$:
00106$:
;src/dungeon_motion.c:41: return motion_lookup[0][word(&dungeon_view_front,(uint16_t)kind*2u)];
	xor	a, a
	ld	b, a
	sla	c
	rl	b
	ld	de, #_dungeon_view_front
	call	_word
	ld	l, c
	ld	h, b
	add	hl, hl
	ld	de, #_motion_lookup
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/dungeon_motion.c:42: }
	ret
;src/dungeon_motion.c:43: uint8_t dungeon_motion_render(const DungeonState *s,uint8_t frame) __banked {
;	---------------------------------
; Function dungeon_motion_render
; ---------------------------------
	b_dungeon_motion_render	= 77
_dungeon_motion_render::
	dec	sp
;src/dungeon_motion.c:44: uint16_t image=dungeon_motion_scene(s,frame);uint8_t result;
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_motion_scene
	ld	hl, #_dungeon_motion_scene
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_motion.c:47: if(frame==0u&&dungeon_motion_active&&!dungeon_motion_buffer&&last_image==image&&last_palette==s->palette_index) {
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
;src/dungeon_motion.c:50: result=dungeon_motion_render_image(image,s->palette_index);
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl), a
;src/dungeon_motion.c:47: if(frame==0u&&dungeon_motion_active&&!dungeon_motion_buffer&&last_image==image&&last_palette==s->palette_index) {
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	NZ, 00102$
	ld	a, (#_dungeon_motion_active)
	or	a, a
	jr	Z, 00102$
	ld	a, (#_dungeon_motion_buffer)
	or	a, a
	jr	NZ, 00102$
	ld	hl, #_last_image
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00102$
	inc	hl
	ld	a, (hl)
	sub	a, b
	jr	NZ, 00102$
	ld	a, (#_last_palette)
	ldhl	sp,	#0
	sub	a, (hl)
	jr	NZ, 00102$
;src/dungeon_motion.c:48: dungeon_motion_home();return 1u;
	call	_dungeon_motion_home
	ld	a, #0x01
	jr	00112$
00102$:
;src/dungeon_motion.c:50: result=dungeon_motion_render_image(image,s->palette_index);
	push	bc
	push	de
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_motion_render_image
	ld	hl, #_dungeon_motion_render_image
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	pop	bc
	ldhl	sp,	#0
	ld	(hl), a
;src/dungeon_motion.c:51: if(result&&frame==0u) {
	or	a, a
	jr	Z, 00110$
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	NZ, 00110$
;src/dungeon_motion.c:52: if(dungeon_motion_buffer)result=dungeon_motion_render_image(image,s->palette_index);
	ld	a, (#_dungeon_motion_buffer)
	or	a, a
	jr	Z, 00108$
	ld	a, (de)
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_motion_render_image
	ld	hl, #_dungeon_motion_render_image
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#0
	ld	(hl), a
00108$:
;src/dungeon_motion.c:53: dungeon_motion_home();
	call	_dungeon_motion_home
00110$:
;src/dungeon_motion.c:55: return result;
	ldhl	sp,	#0
	ld	a, (hl)
00112$:
;src/dungeon_motion.c:56: }
	inc	sp
	ret
;src/dungeon_motion.c:57: uint8_t dungeon_motion_sequence_frame(uint8_t sequence,uint8_t ordinal) __banked {
;	---------------------------------
; Function dungeon_motion_sequence_frame
; ---------------------------------
	b_dungeon_motion_sequence_frame	= 77
_dungeon_motion_sequence_frame::
;src/dungeon_motion.c:58: return sequence<10u&&ordinal<9u?motion_sequences[sequence][ordinal]:255u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00103$
	inc	hl
	ld	a, (hl)
	sub	a, #0x09
	jr	NC, 00103$
	dec	hl
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_motion_sequences
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	ret
00103$:
	ld	a, #0xff
;src/dungeon_motion.c:59: }
	ret
;src/dungeon_motion.c:60: uint8_t dungeon_motion_turn_sequence(const DungeonState *s,uint8_t right) __banked {
;	---------------------------------
; Function dungeon_motion_turn_sequence
; ---------------------------------
	b_dungeon_motion_turn_sequence	= 77
_dungeon_motion_turn_sequence::
;src/dungeon_motion.c:61: uint8_t sequence=right?6u:2u;
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	ld	c, #0x06
	jr	NZ, 00108$
	ld	c, #0x02
00108$:
;src/dungeon_motion.c:62: if(dungeon_sample(s,right?12u:13u)&7u)sequence+=2u;
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	ld	a, #0x0c
	jr	NZ, 00110$
	ld	a, #0x0d
00110$:
	push	bc
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	and	a, #0x07
	jr	Z, 00102$
	inc	c
	inc	c
00102$:
;src/dungeon_motion.c:63: if(dungeon_sample(s,1u)&7u)++sequence;return sequence;
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	and	a, #0x07
	jr	Z, 00104$
	inc	c
00104$:
	ld	a, c
;src/dungeon_motion.c:64: }
	ret
	.area _CODE_77
	.area _INITIALIZER
	.area _CABS (ABS)
