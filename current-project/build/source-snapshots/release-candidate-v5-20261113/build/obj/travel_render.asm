;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module travel_render
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_party_world_draw
	.globl _party_world_draw
	.globl b_party_world_reset
	.globl _party_world_reset
	.globl b_scene_actor_show_data
	.globl _scene_actor_show_data
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_scene_palette_capture
	.globl _scene_palette_capture
	.globl b_scene_palette_commit
	.globl _scene_palette_commit
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl b_world_motion_reset
	.globl _world_motion_reset
	.globl b_world_terrain_sync
	.globl _world_terrain_sync
	.globl b_world_draw
	.globl _world_draw
	.globl b_world_load_graphics
	.globl _world_load_graphics
	.globl b_world_select
	.globl _world_select
	.globl b_travel_fade_color
	.globl _travel_fade_color
	.globl b_travel_space_row
	.globl _travel_space_row
	.globl _set_bkg_tiles
	.globl _display_off
	.globl b_travel_fade_current
	.globl _travel_fade_current
	.globl b_scene_fade_begin
	.globl _scene_fade_begin
	.globl b_scene_fade_step
	.globl _scene_fade_step
	.globl b_travel_present
	.globl _travel_present
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_fade_target:
	.ds 64
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_last_space_scroll:
	.ds 1
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
	.area _CODE_119
;src/travel_render.c:18: static const uint8_t *planet_data(uint8_t planet) {
;	---------------------------------
; Function planet_data
; ---------------------------------
_planet_data:
;src/travel_render.c:19: return planet==0u?travel_planet_0:planet==1u?travel_planet_1:travel_planet_2;
	or	a, a
	jr	NZ, 00103$
	ld	bc, #_travel_planet_0+0
	ret
00103$:
	dec	a
	jr	NZ, 00105$
	ld	bc, #_travel_planet_1+0
	ret
00105$:
	ld	bc, #_travel_planet_2+0
;src/travel_render.c:20: }
	ret
_scene_ui_colors:
	.dw #0x2062
	.dw #0x4d46
	.dw #0x22de
	.dw #0x6fde
;src/travel_render.c:21: static const uint8_t *ship_data(const TravelState *s) {
;	---------------------------------
; Function ship_data
; ---------------------------------
_ship_data:
;src/travel_render.c:22: return s->ship_mode==16u?travel_ship_0:travel_ship_1;
	ld	hl, #0x0015
	add	hl, de
	ld	a, (hl)
	sub	a, #0x10
	jr	NZ, 00103$
	ld	bc, #_travel_ship_0+0
	ret
00103$:
	ld	bc, #_travel_ship_1+0
;src/travel_render.c:23: }
	ret
;src/travel_render.c:24: static uint8_t sms_color(uint16_t color) {
;	---------------------------------
; Function sms_color
; ---------------------------------
_sms_color:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
;src/travel_render.c:25: uint8_t r=((color&31u)*3u+15u)/31u,g=(((color>>5)&31u)*3u+15u)/31u;
	ld	a, c
	and	a, #0x1f
	ld	e, a
	add	a, a
	add	a, e
	add	a, #0x0f
	push	bc
	ld	e, #0x1f
	call	__divuchar
	ld	a, c
	pop	bc
	ldhl	sp,	#0
	ld	(hl), a
	ld	e, c
	ld	d, b
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ld	a, e
	and	a, #0x1f
	ld	e, a
	add	a, a
	add	a, e
	add	a, #0x0f
	push	bc
	ld	e, #0x1f
	call	__divuchar
	ld	a, c
	pop	bc
	ldhl	sp,	#1
	ld	(hl), a
;src/travel_render.c:26: uint8_t b=(((color>>10)&31u)*3u+15u)/31u;
	ld	a, b
	rrca
	rrca
	and	a, #0x1f
	ld	c, a
	add	a, a
	add	a, c
	add	a, #0x0f
	ld	e, #0x1f
	call	__divuchar
;src/travel_render.c:27: return r|(g<<2)|(b<<4);
	ldhl	sp,	#1
	ld	a, (hl-)
	add	a, a
	add	a, a
	ld	e, a
	or	a, (hl)
	ld	l, a
	ld	a, c
	swap	a
	and	a, #0xf0
	or	a, l
;src/travel_render.c:28: }
	inc	sp
	inc	sp
	ret
;src/travel_render.c:29: static uint16_t native_color(uint8_t sms) {
;	---------------------------------
; Function native_color
; ---------------------------------
_native_color:
	add	sp, #-5
;src/travel_render.c:30: uint8_t r=sms&3u,g=(sms>>2)&3u,b=sms>>4;
	ld	e, a
	and	a, #0x03
	ld	c, a
	ld	a, e
	rrca
	rrca
	and	a, #0x3
	ldhl	sp,	#4
	ld	(hl), a
	ld	a, e
	swap	a
	and	a, #0x0f
	ldhl	sp,	#0
	ld	(hl), a
;src/travel_render.c:31: return (uint16_t)(r*10u+(r>=2u))|((uint16_t)(g*10u+(g>=2u))<<5)|((uint16_t)(b*10u+(b>=2u))<<10);
	ld	l, c
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	a, c
	sub	a, #0x02
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	c, a
	ld	b, #0x00
	add	hl, bc
	ld	c, l
	ld	a, h
	ldhl	sp,	#1
	ld	(hl), c
	inc	hl
	ld	(hl+), a
	inc	hl
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	h, #0x00
	ld	l, a
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#1
	ld	a, (hl+)
	inc	hl
	or	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#0
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	h, #0x00
	ld	l, a
	add	hl, bc
	ld	a, l
	add	a, a
	add	a, a
	ld	d, a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	or	a, d
	ld	b, a
;src/travel_render.c:32: }
	add	sp, #5
	ret
;src/travel_render.c:33: static uint16_t faded(uint16_t color,uint8_t step,uint8_t fade_in) {
;	---------------------------------
; Function faded
; ---------------------------------
_faded:
	ld	b, a
;src/travel_render.c:34: return native_color(travel_fade_color(sms_color(color),step,fade_in));
	push	bc
	call	_sms_color
	pop	bc
	ldhl	sp,	#2
	ld	h, (hl)
	ld	l, b
	push	hl
	push	af
	inc	sp
	ld	e, #b_travel_fade_color
	ld	hl, #_travel_fade_color
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_native_color
;src/travel_render.c:35: }
	pop	hl
	inc	sp
	jp	(hl)
;src/travel_render.c:36: void travel_fade_current(void) __banked {
;	---------------------------------
; Function travel_fade_current
; ---------------------------------
	b_travel_fade_current	= 119
_travel_fade_current::
	dec	sp
;src/travel_render.c:38: scene_palette_capture();
	ld	e, #b_scene_palette_capture
	ld	hl, #_scene_palette_capture
	call	___sdcc_bcall_ehl
;src/travel_render.c:39: for(i=0;i<32u;++i)scene_palette_background[i]=faded(scene_palette_background[i],1u,0u);
	ldhl	sp,	#0
	ld	(hl), #0x00
00103$:
	ldhl	sp,	#0
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	ld	hl, #_scene_palette_background
	add	hl, bc
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x01
	ld	e, l
	ld	d, h
	call	_faded
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ldhl	sp,	#0
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x20
	jr	C, 00103$
;src/travel_render.c:40: for(i=0;i<32u;++i)scene_shared_colors[i]=faded(scene_shared_colors[i],1u,0u);
	ld	(hl), #0x00
00105$:
	ldhl	sp,	#0
	ld	c, (hl)
	ld	b, #0x00
	sla	c
	rl	b
	ld	hl, #_scene_shared_colors
	add	hl, bc
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x01
	ld	e, l
	ld	d, h
	call	_faded
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ldhl	sp,	#0
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x20
	jr	C, 00105$
;src/travel_render.c:41: scene_palette_commit();
	ld	e, #b_scene_palette_commit
	ld	hl, #_scene_palette_commit
	call	___sdcc_bcall_ehl
;src/travel_render.c:42: }
	inc	sp
	ret
;src/travel_render.c:43: void scene_fade_begin(uint8_t fade_in) __banked {
;	---------------------------------
; Function scene_fade_begin
; ---------------------------------
	b_scene_fade_begin	= 119
_scene_fade_begin::
	dec	sp
	dec	sp
;src/travel_render.c:45: scene_palette_capture();
	ld	e, #b_scene_palette_capture
	ld	hl, #_scene_palette_capture
	call	___sdcc_bcall_ehl
;src/travel_render.c:46: if(fade_in)for(i=0;i<4u;++i)scene_palette_background[28u+i]=scene_ui_colors[i];
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	ldhl	sp,	#1
	ld	(hl), #0x00
00108$:
	ldhl	sp,	#1
	ld	a, (hl)
	add	a, #0x1c
	ld	b, #0x00
	add	a, a
	rl	b
	add	a, #<(_scene_palette_background)
	ld	c, a
	ld	a, b
	adc	a, #>(_scene_palette_background)
	ld	b, a
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	ld	de, #_scene_ui_colors
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
	ld	(bc), a
	inc	bc
	ld	a, h
	ld	(bc), a
	ldhl	sp,	#1
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00108$
;src/travel_render.c:47: for(i=0;i<32u;++i)fade_target[i]=sms_color(scene_palette_background[i]);
00118$:
	ldhl	sp,	#1
	ld	(hl), #0x00
00110$:
	ld	de, #_fade_target
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#1
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	ld	de, #_scene_palette_background
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	ld	e, l
	ld	d, h
	call	_sms_color
	pop	bc
	ld	(bc), a
	ldhl	sp,	#1
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x20
	jr	C, 00110$
;src/travel_render.c:48: for(i=0;i<32u;++i)fade_target[i+32u]=sms_color(scene_shared_colors[i]);
	ld	c, #0x00
00112$:
	ld	a, c
	add	a, #0x20
	ld	e, a
	ld	d, #0x00
	ld	hl, #_fade_target
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	de, #_scene_shared_colors
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	ld	e, l
	ld	d, h
	call	_sms_color
	pop	bc
	pop	hl
	push	hl
	ld	(hl), a
	inc	c
	ld	a, c
	sub	a, #0x20
	jr	C, 00112$
;src/travel_render.c:49: if(fade_in)scene_fade_step(0u,1u);
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
	xor	a, a
	inc	a
	push	af
	ld	e, #b_scene_fade_step
	ld	hl, #_scene_fade_step
	call	___sdcc_bcall_ehl
	pop	hl
00114$:
;src/travel_render.c:50: }
	inc	sp
	inc	sp
	ret
;src/travel_render.c:51: void scene_fade_step(uint8_t step,uint8_t fade_in) __banked {
;	---------------------------------
; Function scene_fade_step
; ---------------------------------
	b_scene_fade_step	= 119
_scene_fade_step::
	dec	sp
;src/travel_render.c:53: for(i=0;i<32u;++i)scene_palette_background[i]=native_color(travel_fade_color(fade_target[i],step,fade_in));
	ld	c, #0x00
00107$:
	ld	l, c
	ld	h, #0x00
	add	hl, hl
	ld	a, l
	add	a, #<(_scene_palette_background)
	ld	e, a
	ld	a, h
	adc	a, #>(_scene_palette_background)
	ld	d, a
	ld	hl, #_fade_target
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	push	bc
	push	de
	ldhl	sp,	#12
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#12
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_travel_fade_color
	ld	hl, #_travel_fade_color
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_native_color
	ld	l, c
	ld	h, b
	pop	de
	pop	bc
	ld	a, l
	ld	(de), a
	inc	de
	ld	a, h
	ld	(de), a
	inc	c
	ld	a, c
	sub	a, #0x20
	jr	C, 00107$
;src/travel_render.c:54: for(i=0;i<32u;++i)scene_shared_colors[i]=native_color(travel_fade_color(fade_target[i+32u],step,fade_in));
	ld	c, #0x00
00109$:
	ld	l, c
	ld	h, #0x00
	add	hl, hl
	ld	a, l
	add	a, #<(_scene_shared_colors)
	ld	e, a
	ld	a, h
	adc	a, #>(_scene_shared_colors)
	ld	d, a
	ld	a, c
	add	a, #0x20
	add	a, #<(_fade_target)
	ld	l, a
	ld	a, #0x00
	adc	a, #>(_fade_target)
	ld	h, a
	ld	a, (hl)
	push	bc
	push	de
	ldhl	sp,	#12
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#12
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_travel_fade_color
	ld	hl, #_travel_fade_color
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_native_color
	ld	l, c
	ld	h, b
	pop	de
	pop	bc
	ld	a, l
	ld	(de), a
	inc	de
	ld	a, h
	ld	(de), a
	inc	c
	ld	a, c
	sub	a, #0x20
	jr	C, 00109$
;src/travel_render.c:57: if(fade_in&&step>=9u)for(i=0;i<4u;++i)scene_palette_background[28u+i]=scene_ui_colors[i];
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00105$
	dec	hl
	ld	a, (hl)
	sub	a, #0x09
	jr	C, 00105$
	ldhl	sp,	#0
	ld	(hl), #0x00
00111$:
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, #0x1c
	ld	b, #0x00
	add	a, a
	rl	b
	add	a, #<(_scene_palette_background)
	ld	c, a
	ld	a, b
	adc	a, #>(_scene_palette_background)
	ld	b, a
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	ld	de, #_scene_ui_colors
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
	ld	(bc), a
	inc	bc
	ld	a, h
	ld	(bc), a
	ldhl	sp,	#0
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00111$
00105$:
;src/travel_render.c:58: scene_palette_commit();
	ld	e, #b_scene_palette_commit
	ld	hl, #_scene_palette_commit
	call	___sdcc_bcall_ehl
;src/travel_render.c:59: }
	inc	sp
	ret
;src/travel_render.c:60: static void palettes(const TravelState *s) {
;	---------------------------------
; Function palettes
; ---------------------------------
_palettes:
	add	sp, #-15
	ldhl	sp,	#12
	ld	a, e
	ld	(hl+), a
;src/travel_render.c:62: if(s->space_visible){bank=TRAVEL_ART_BANK;data=planet_data(s->planet)+TRAVEL_GRAPHICS_BYTES;}
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001e
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00102$
	ldhl	sp,	#14
	ld	a, #0x78
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	call	_planet_data
	ld	hl, #0x0620
	add	hl, bc
	ld	c, l
	ld	b, h
	jr	00103$
00102$:
;src/travel_render.c:63: else {const WorldScene *scene=&world_scenes[world_group_id];bank=scene->asset_bank;data=(const uint8_t *)scene->palettes;}
	ld	hl, #_world_group_id
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_world_scenes
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	inc	de
	ld	a, (de)
	ldhl	sp,	#14
	ld	(hl), a
	ld	hl, #0x000c
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00103$:
;src/travel_render.c:64: bank_copy(scene_palette_background,bank,data,56u);
	ld	de, #0x0038
	push	de
	push	bc
	ldhl	sp,	#18
	ld	a, (hl)
	ld	de, #_scene_palette_background
	call	_bank_copy
;src/travel_render.c:65: for(i=0;i<28u;++i)scene_palette_background[i]=faded(scene_palette_background[i],s->fade_step,s->fade_in);
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0021
	add	hl, de
	ld	c, l
	ld	b, h
	inc	sp
	inc	sp
	push	bc
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001f
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
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#14
	ld	(hl), #0x00
00110$:
	ldhl	sp,	#14
	ld	e, (hl)
	ld	d, #0x00
	sla	e
	rl	d
	ld	hl, #_scene_palette_background
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl+), a
	pop	de
	push	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#9
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#10
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	push	bc
	ldhl	sp,	#10
	ld	a, (hl+)
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_faded
	ldhl	sp,	#12
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	bc
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#14
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x1c
	jr	C, 00110$
;src/travel_render.c:66: for(i=0;i<4u;++i)scene_palette_background[28u+i]=(s->fade_in&&s->fade_step>=9u)?scene_ui_colors[i]:faded(scene_ui_colors[i],s->fade_step,s->fade_in);
	ld	(hl), #0x00
00112$:
	ldhl	sp,	#14
	ld	a, (hl)
	add	a, #0x1c
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	ld	e, l
	ld	d, h
	ld	hl, #_scene_palette_background
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
;src/travel_render.c:65: for(i=0;i<28u;++i)scene_palette_background[i]=faded(scene_palette_background[i],s->fade_step,s->fade_in);
	ld	(hl+), a
	pop	de
	push	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#9
	ld	(hl), a
;src/travel_render.c:66: for(i=0;i<4u;++i)scene_palette_background[28u+i]=(s->fade_in&&s->fade_step>=9u)?scene_ui_colors[i]:faded(scene_ui_colors[i],s->fade_step,s->fade_in);
	ldhl	sp,	#14
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sla	e
	rl	d
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	inc	hl
	ld	a, (hl)
	sub	a, #0x09
	jr	C, 00118$
	ld	hl, #_scene_ui_colors
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#10
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	jr	00119$
00118$:
	ld	hl, #_scene_ui_colors
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#10
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	push	bc
	ldhl	sp,	#10
	ld	a, (hl+)
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_faded
	ldhl	sp,	#12
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	bc
00119$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#14
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00112$
;src/travel_render.c:67: if(s->ship_mode){bank=TRAVEL_ART_BANK;data=ship_data(s)+320u;}
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0015
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	Z, 00107$
	ldhl	sp,	#14
	ld	a, #0x78
	ld	(hl-), a
	dec	hl
	push	bc
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ship_data
	ld	e, c
	ld	d, b
	pop	bc
	ld	hl, #0x0140
	add	hl, de
	ld	e, l
	ld	d, h
	jr	00108$
00107$:
;src/travel_render.c:68: else {bank=PARTY_WORLD_BANK;data=(const uint8_t *)party_world_palettes;}
	ldhl	sp,	#14
	ld	(hl), #0x16
	ld	de, #_party_world_palettes
00108$:
;src/travel_render.c:69: bank_copy(scene_shared_colors,bank,data,64u);
	push	bc
	ld	hl, #0x0040
	push	hl
	push	de
	ldhl	sp,	#20
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
	pop	bc
;src/travel_render.c:70: for(i=0;i<32u;++i)scene_shared_colors[i]=faded(scene_shared_colors[i],s->fade_step,s->fade_in);
	ldhl	sp,	#8
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#14
	ld	(hl), #0x00
00114$:
	ldhl	sp,	#14
	ld	c, (hl)
	xor	a, a
	ld	b, a
	sla	c
	rl	b
	ld	hl, #_scene_shared_colors
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	push	bc
	inc	sp
	ld	a, c
	ld	e, l
	ld	d, h
	call	_faded
	ldhl	sp,	#6
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#14
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x20
	jr	C, 00114$
;src/travel_render.c:71: scene_palette_commit();
	ld	e, #b_scene_palette_commit
	ld	hl, #_scene_palette_commit
	call	___sdcc_bcall_ehl
;src/travel_render.c:72: }
	add	sp, #15
	ret
;src/travel_render.c:73: static void space_row(const TravelState *s,uint8_t logical) {
;	---------------------------------
; Function space_row
; ---------------------------------
_space_row:
	add	sp, #-4
	ld	c, e
	ld	b, d
	ldhl	sp,	#3
	ld	(hl), a
;src/travel_render.c:74: uint8_t row,kind=travel_space_row(s,logical%28u,&row);
	ld	a, (hl)
	push	bc
	ld	e, #0x1c
	call	__moduchar
	ld	d, c
	pop	bc
	push	bc
	ld	hl, #2
	add	hl, sp
	push	hl
	push	de
	inc	sp
	push	bc
	ld	e, #b_travel_space_row
	ld	hl, #_travel_space_row
	call	___sdcc_bcall_ehl
	add	sp, #5
	ld	e, a
	pop	bc
;src/travel_render.c:75: const uint8_t *p=planet_data(s->planet)+TRAVEL_MAP_OFFSET+(uint16_t)kind*768u+(uint16_t)row*32u+7u;
	ld	hl, #0x001c
	add	hl, bc
	ld	a, (hl)
	push	de
	call	_planet_data
	ldhl	sp,	#3
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	de
	ld	c, e
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
	ld	bc, #0x65f
	add	hl,bc
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
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#1
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
;src/travel_render.c:76: bank_copy(scene_shared_bytes,TRAVEL_ART_BANK,p,20u);
	ld	e, c
	ld	d, b
	push	bc
	ld	hl, #0x0014
	push	hl
	push	de
	ld	a, #0x78
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	pop	bc
;src/travel_render.c:77: bank_copy(scene_shared_bytes+20,TRAVEL_ART_BANK,p+384u,20u);
	ld	hl, #0x0180
	add	hl, bc
	ld	de, #0x0014
	push	de
	push	hl
	ld	a, #0x78
	ld	de, #(_scene_shared_bytes + 20)
	call	_bank_copy
;src/travel_render.c:78: VBK_REG=0;set_bkg_tiles(0,logical&31u,20,1,scene_shared_bytes);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x1f
	ld	c, a
	ld	de, #_scene_shared_bytes
	push	de
	ld	hl, #0x114
	push	hl
	ld	h, c
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
;src/travel_render.c:79: VBK_REG=1;set_bkg_tiles(0,logical&31u,20,1,scene_shared_bytes+20);VBK_REG=0;
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #(_scene_shared_bytes + 20)
	push	de
	ld	hl, #0x114
	push	hl
	ld	h, c
	ld	l, #0x00
	push	hl
	call	_set_bkg_tiles
	add	sp, #6
	xor	a, a
	ldh	(_VBK_REG + 0), a
;src/travel_render.c:80: }
	add	sp, #4
	ret
;src/travel_render.c:81: static void draw_space(const TravelState *s,uint8_t force) {
;	---------------------------------
; Function draw_space
; ---------------------------------
_draw_space:
	add	sp, #-6
	ldhl	sp,	#4
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
;src/travel_render.c:82: uint8_t row,head=(s->scroll+32u)>>3;
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	e, a
	ld	l, e
	ld	h, #0x00
	push	de
	ld	de, #0x0020
	add	hl, de
	pop	de
	ld	d, h
	srl	d
	rr	l
	srl	d
	rr	l
	srl	d
	rr	l
	ld	a, l
	ldhl	sp,	#0
	ld	(hl), a
;src/travel_render.c:83: if(force||last_space_scroll==255u||s->scroll>last_space_scroll)
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	NZ, 00116$
	ld	a, (#_last_space_scroll)
	inc	a
	jr	Z, 00116$
	ld	a, (#_last_space_scroll)
	sub	a, e
	jr	NC, 00105$
;src/travel_render.c:84: for(row=0;row<19u;++row)space_row(s,head+row);
00116$:
	ld	e, #0x00
00110$:
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, e
	push	bc
	push	de
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_space_row
	pop	de
	pop	bc
	inc	e
	ld	a, e
	sub	a, #0x13
	jr	C, 00110$
	jr	00106$
00105$:
;src/travel_render.c:85: else if(head!=((last_space_scroll+32u)>>3))space_row(s,head);
	ld	a, (_last_space_scroll)
	ld	e, #0x00
	add	a, #0x20
	ld	d, a
	jr	NC, 00151$
	inc	e
00151$:
	srl	e
	rr	d
	srl	e
	rr	d
	srl	e
	rr	d
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, d
	sub	a, (hl)
	jr	NZ, 00152$
	inc	hl
	ld	a, e
	sub	a, (hl)
	jr	Z, 00106$
00152$:
	push	bc
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_space_row
	pop	bc
00106$:
;src/travel_render.c:86: move_bkg(0,s->scroll+32u);last_space_scroll=s->scroll;
	ld	a, (bc)
	add	a, #0x20
	ld	e, a
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	ld	a, e
	ldh	(_SCY_REG + 0), a
;src/travel_render.c:86: move_bkg(0,s->scroll+32u);last_space_scroll=s->scroll;
	ld	a, (bc)
	ld	(#_last_space_scroll),a
;src/travel_render.c:87: }
	add	sp, #6
	ret
;src/travel_render.c:88: void travel_present(const TravelState *s,uint8_t flags) __banked {
;	---------------------------------
; Function travel_present
; ---------------------------------
	b_travel_present	= 119
_travel_present::
	add	sp, #-7
;src/travel_render.c:89: uint8_t full=flags&(TRAVEL_WORLD|TRAVEL_SPACE);
	ldhl	sp,	#15
	ld	a, (hl)
	and	a, #0x03
	ldhl	sp,	#0
	ld	(hl), a
;src/travel_render.c:90: if(full) {
	ld	a, (hl)
	or	a, a
	jp	Z, 00110$
;src/travel_render.c:91: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;last_space_scroll=255u;
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_last_space_scroll
	ld	(hl), #0xff
;src/travel_render.c:93: world_select(s->map);world_load_graphics();world_terrain_sync(s->x,s->y);
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
;src/travel_render.c:92: if(flags&TRAVEL_WORLD) {
	push	hl
	ldhl	sp,	#17
	bit	0, (hl)
	pop	hl
	jr	Z, 00104$
;src/travel_render.c:93: world_select(s->map);world_load_graphics();world_terrain_sync(s->x,s->y);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	af
	inc	sp
	ld	e, #b_world_select
	ld	hl, #_world_select
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, #b_world_load_graphics
	ld	hl, #_world_load_graphics
	call	___sdcc_bcall_ehl
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	push	bc
	push	hl
	ld	e, #b_world_terrain_sync
	ld	hl, #_world_terrain_sync
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/travel_render.c:94: if(s->tag<0x80u)world_motion_reset(s->tag);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	cp	a, #0x80
	jr	NC, 00105$
	push	af
	inc	sp
	ld	e, #b_world_motion_reset
	ld	hl, #_world_motion_reset
	call	___sdcc_bcall_ehl
	inc	sp
	jr	00105$
00104$:
;src/travel_render.c:95: } else bank_bkg_data(TRAVEL_ART_BANK,0,98,planet_data(s->planet),0);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (hl)
	call	_planet_data
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, #0x62
	push	af
	inc	sp
	ld	e, #0x00
	ld	a, #0x78
	call	_bank_bkg_data
00105$:
;src/travel_render.c:96: if(s->ship_mode){scene_actor_show_data(TRAVEL_ART_BANK,ship_data(s),16,16);scene_actor_active=0;}
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0015
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00107$
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ship_data
	ld	hl, #0x1010
	push	hl
	push	bc
	ld	a, #0x78
	push	af
	inc	sp
	ld	e, #b_scene_actor_show_data
	ld	hl, #_scene_actor_show_data
	call	___sdcc_bcall_ehl
	add	sp, #5
	xor	a, a
	ld	(#_scene_actor_active),a
	jr	00110$
00107$:
;src/travel_render.c:98: scene_actor_hide();
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
;src/travel_render.c:99: party_world_reset(s->next_stage==TRAVEL_ROAD?(1u<<(s->facing<2u?s->facing^1u:s->facing)):0u);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0012
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x02
	jr	NZ, 00122$
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	cp	a, #0x02
	jr	NC, 00124$
	xor	a, #0x01
00124$:
	ld	b, a
	ld	a, #0x01
	inc	b
	jr	00200$
00199$:
	add	a, a
00200$:
	dec	b
	jr	NZ,00199$
	jr	00123$
00122$:
	xor	a, a
00123$:
	push	af
	inc	sp
	ld	e, #b_party_world_reset
	ld	hl, #_party_world_reset
	call	___sdcc_bcall_ehl
	inc	sp
00110$:
;src/travel_render.c:93: world_select(s->map);world_load_graphics();world_terrain_sync(s->x,s->y);
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#2
;src/travel_render.c:102: if(s->space_visible)draw_space(s,full);
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001e
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00112$
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_draw_space
	jr	00113$
00112$:
;src/travel_render.c:103: else world_draw((s->x+2048u-80u)&2047u,(s->y+1536u-80u)%1536u,full);
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
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
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x05b0
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	bc, #0x0600
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__moduint
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	de, #0x07b0
	add	hl, de
	ld	e, l
	ld	a, h
	and	a, #0x07
	ldhl	sp,	#0
	ld	h, (hl)
	push	hl
	inc	sp
	push	bc
	ld	d, a
	push	de
	ld	e, #b_world_draw
	ld	hl, #_world_draw
	call	___sdcc_bcall_ehl
	add	sp, #5
00113$:
;src/travel_render.c:104: if(!s->ship_mode)party_world_draw();
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0015
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00115$
	ld	e, #b_party_world_draw
	ld	hl, #_party_world_draw
	call	___sdcc_bcall_ehl
00115$:
;src/travel_render.c:105: if(flags&TRAVEL_PALETTE)palettes(s);
	push	hl
	ldhl	sp,	#17
	bit	2, (hl)
	pop	hl
	jr	Z, 00117$
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_palettes
00117$:
;src/travel_render.c:106: SHOW_BKG;SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;src/travel_render.c:107: if(full)DISPLAY_ON;
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
00120$:
;src/travel_render.c:108: }
	add	sp, #7
	ret
	.area _CODE_119
	.area _INITIALIZER
__xinit__last_space_scroll:
	.db #0xff	; 255
	.area _CABS (ABS)
