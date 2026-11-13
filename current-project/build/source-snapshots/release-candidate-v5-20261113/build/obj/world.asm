;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module world
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_bkg_palette
	.globl _set_bkg_tiles
	.globl _memset
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl _bank_read8
	.globl b_world_motion_reset
	.globl _world_motion_reset
	.globl _world_ice_changed
	.globl _world_group_id
	.globl _world_map_id
	.globl b_world_terrain_sync
	.globl _world_terrain_sync
	.globl b_world_select
	.globl _world_select
	.globl b_world_load_graphics
	.globl _world_load_graphics
	.globl b_world_meta_at
	.globl _world_meta_at
	.globl b_world_flags_at
	.globl _world_flags_at
	.globl b_world_tile_at
	.globl _world_tile_at
	.globl b_world_draw
	.globl _world_draw
	.globl b_world_can_stand
	.globl _world_can_stand
	.globl b_world_vehicle_footprint
	.globl _world_vehicle_footprint
	.globl b_world_step_allowed
	.globl _world_step_allowed
	.globl b_world_vehicle_use
	.globl _world_vehicle_use
	.globl b_world_decode_y
	.globl _world_decode_y
	.globl b_world_decode_destination
	.globl _world_decode_destination
	.globl b_world_road_destination
	.globl _world_road_destination
	.globl b_world_check_trigger
	.globl _world_check_trigger
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_world_map_id::
	.ds 1
_world_group_id::
	.ds 1
_world_ice_changed::
	.ds 1
_broken_ice:
	.ds 96
_ice_origin_y:
	.ds 1
_ice_dirty:
	.ds 1
_scene:
	.ds 2
_collisions:
	.ds 256
_previous_tile_x:
	.ds 2
_previous_tile_y:
	.ds 2
_drawn:
	.ds 1
_tiles_buffer:
	.ds 21
_attrs_buffer:
	.ds 21
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_ice_origin_x:
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
	.area _CODE_6
;src/world.c:39: static uint16_t wrap_y(int16_t y) {
;	---------------------------------
; Function wrap_y
; ---------------------------------
_wrap_y:
	add	sp, #-4
	ld	c, e
	ld	b, d
;src/world.c:40: if(y < 0) return (uint16_t)(y + WORLD_PIXEL_HEIGHT);
	inc	sp
	inc	sp
	push	bc
	ldhl	sp,	#2
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl-), a
	dec	hl
	bit	7, (hl)
	jr	Z, 00102$
	inc	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0600
	add	hl, de
	ld	c, l
	ld	b, h
	jr	00105$
00102$:
;src/world.c:41: if(y >= WORLD_PIXEL_HEIGHT) return (uint16_t)(y - WORLD_PIXEL_HEIGHT);
	ldhl	sp,	#2
	ld	a, (hl+)
	sub	a, #0x00
	ld	a, (hl)
	sbc	a, #0x06
	jr	C, 00104$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0600
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	ldhl	sp,	#2
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/world.c:42: return (uint16_t)y;
00104$:
00105$:
;src/world.c:43: }
	add	sp, #4
	ret
_town_exits:
	.db #0x00	; 0
	.db #0x39	; 57	'9'
	.db #0x55	; 85	'U'
	.db #0x00	; 0
	.db #0x39	; 57	'9'
	.db #0x55	; 85	'U'
	.db #0x00	; 0
	.db #0x48	; 72	'H'
	.db #0x49	; 73	'I'
	.db #0x00	; 0
	.db #0x47	; 71	'G'
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.db #0x55	; 85	'U'
	.db #0x00	; 0
	.db #0x25	; 37
	.db #0x42	; 66	'B'
	.db #0x00	; 0
	.db #0x14	; 20
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x41	; 65	'A'
	.db #0x1a	; 26
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.db #0x75	; 117	'u'
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x66	; 102	'f'
	.db #0x01	; 1
	.db #0x27	; 39
	.db #0x64	; 100	'd'
	.db #0x01	; 1
	.db #0x53	; 83	'S'
	.db #0x73	; 115	's'
	.db #0x01	; 1
	.db #0x27	; 39
	.db #0x64	; 100	'd'
	.db #0x01	; 1
	.db #0x71	; 113	'q'
	.db #0x5a	; 90	'Z'
	.db #0x01	; 1
	.db #0x26	; 38
	.db #0x29	; 41
	.db #0x02	; 2
	.db #0x5b	; 91
	.db #0x2c	; 44
	.db #0x02	; 2
	.db #0x38	; 56	'8'
	.db #0x49	; 73	'I'
	.db #0x02	; 2
	.db #0x5b	; 91
	.db #0x2c	; 44
	.db #0x02	; 2
	.db #0x38	; 56	'8'
	.db #0x49	; 73	'I'
	.db #0x00	; 0
	.db #0x16	; 22
	.db #0x6a	; 106	'j'
_roads:
	.db #0x04	; 4
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x51	; 81	'Q'
	.db #0x05	; 5
	.db #0x21	; 33
	.db #0x2c	; 44
	.db #0x01	; 1
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x46	; 70	'F'
	.db #0x46	; 70	'F'
	.db #0x05	; 5
	.db #0x27	; 39
	.db #0x21	; 33
	.db #0x01	; 1
	.db #0x04	; 4
	.db #0x01	; 1
	.db #0x33	; 51	'3'
	.db #0x64	; 100	'd'
	.db #0x0e	; 14
	.db #0x2a	; 42
	.db #0x20	; 32
	.db #0x08	; 8
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0x48	; 72	'H'
	.db #0x04	; 4
	.db #0x21	; 33
	.db #0x53	; 83	'S'
	.db #0x02	; 2
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x3a	; 58
	.db #0x46	; 70	'F'
	.db #0x06	; 6
	.db #0x54	; 84	'T'
	.db #0x20	; 32
	.db #0x02	; 2
	.db #0x04	; 4
	.db #0x01	; 1
	.db #0x2b	; 43
	.db #0x64	; 100	'd'
	.db #0x10	; 16
	.db #0x43	; 67	'C'
	.db #0x1e	; 30
;src/world.c:44: static uint16_t ice_index(uint8_t mx,uint8_t my) {
;	---------------------------------
; Function ice_index
; ---------------------------------
_ice_index:
	dec	sp
	ld	c, a
;src/world.c:45: uint8_t dx=(mx-ice_origin_x*16u)&127u;
	ld	a, (_ice_origin_x)
	swap	a
	and	a, #0xf0
	ld	b, a
	ld	a, c
	sub	a, b
	and	a, #0x7f
	ldhl	sp,	#0
	ld	(hl), a
;src/world.c:46: uint8_t dy=(my+96u-ice_origin_y*12u)%96u;
	ld	d, #0x00
	ld	hl, #0x0060
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (_ice_origin_y)
	ld	l, a
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	ld	a, c
	sub	a, l
	ld	e, a
	ld	a, b
	sbc	a, h
	ld	bc, #0x0060
	ld	d, a
	call	__moduint
;src/world.c:47: if(ice_origin_x==255u||dx>=32u||dy>=24u)return 65535u;
	ld	a, (#_ice_origin_x)
	inc	a
	jr	Z, 00101$
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x20
	jr	NC, 00101$
	ld	a, c
	sub	a, #0x18
	jr	C, 00102$
00101$:
	ld	bc, #0xffff
	jr	00105$
00102$:
;src/world.c:48: return (uint16_t)dy*32u+dx;
	ld	l, c
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
00105$:
;src/world.c:49: }
	inc	sp
	ret
;src/world.c:50: void world_terrain_sync(uint16_t x,uint16_t y) WORLD_BANKED {
;	---------------------------------
; Function world_terrain_sync
; ---------------------------------
	b_world_terrain_sync	= 6
_world_terrain_sync::
	dec	sp
;src/world.c:51: uint8_t cx=((x-136u)&2047u)>>8;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	b, (hl)
	add	a, #0x78
	ld	a, b
	adc	a, #0xff
	and	a, #0x07
	ldhl	sp,	#0
	ld	(hl), a
;src/world.c:52: uint8_t cy=wrap_y((int16_t)y-112)/192u;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, (hl)
	add	a, #0x90
	ld	e, a
	ld	a, c
	adc	a, #0xff
	ld	d, a
	call	_wrap_y
	ld	e, c
	ld	d, b
	ld	bc, #0x00c0
	call	__divuint
;src/world.c:53: if(cx!=ice_origin_x||cy!=ice_origin_y) {
	ldhl	sp,	#0
	ld	a, (hl)
	ld	hl, #_ice_origin_x
	sub	a, (hl)
	jr	NZ, 00103$
	ld	a, (#_ice_origin_y)
	sub	a, c
	jr	Z, 00106$
00103$:
;src/world.c:54: memset(broken_ice,0,sizeof(broken_ice));ice_origin_x=cx;ice_origin_y=cy;
	ld	de, #0x0060
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_broken_ice
	push	de
	call	_memset
	add	sp, #6
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(#_ice_origin_x),a
	ld	hl, #_ice_origin_y
	ld	(hl), c
;src/world.c:55: if(ice_dirty)drawn=0;
	ld	a, (#_ice_dirty)
	or	a, a
	jr	Z, 00102$
	xor	a, a
	ld	(#_drawn),a
00102$:
;src/world.c:56: ice_dirty=0;
	xor	a, a
	ld	(#_ice_dirty),a
00106$:
;src/world.c:58: }
	inc	sp
	ret
;src/world.c:59: uint8_t world_select(uint8_t map_id) WORLD_BANKED {
;	---------------------------------
; Function world_select
; ---------------------------------
	b_world_select	= 6
_world_select::
;src/world.c:60: if(map_id >= WORLD_MAP_COUNT) return 0;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x18
	jr	C, 00102$
	xor	a, a
	ret
00102$:
;src/world.c:61: world_map_id = map_id;
	ldhl	sp,	#6
	ld	c, (hl)
	ld	hl, #_world_map_id
	ld	(hl), c
;src/world.c:62: world_group_id = world_map_group[map_id];
	ld	hl, #_world_map_group
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	(#_world_group_id),a
;src/world.c:63: scene = &world_scenes[world_group_id];
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
	ld	a, h
	ld	hl, #_scene
	ld	(hl), c
	inc	hl
;src/world.c:64: bank_copy(collisions, scene->asset_bank, scene->collision, 256u);
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0008
	add	hl, bc
	ld	a, (hl+)
	ld	l, (hl)
	ld	e, a
	ld	d, l
	inc	bc
	ld	a, (bc)
	ld	c, a
	xor	a, a
	inc	a
	push	af
	push	de
	ld	a, c
	ld	de, #_collisions
	call	_bank_copy
;src/world.c:65: memset(broken_ice,0,sizeof(broken_ice));ice_origin_x=255u;ice_dirty=world_ice_changed=0;
	ld	de, #0x0060
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_broken_ice
	push	de
	call	_memset
	add	sp, #6
	ld	hl, #_ice_origin_x
	ld	(hl), #0xff
	xor	a, a
	ld	(#_world_ice_changed), a
	ld	(#_ice_dirty),a
;src/world.c:66: drawn = 0;
	xor	a, a
	ld	(#_drawn),a
;src/world.c:67: return 1;
	ld	a, #0x01
;src/world.c:68: }
	ret
;src/world.c:69: void world_load_graphics(void) WORLD_BANKED {
;	---------------------------------
; Function world_load_graphics
; ---------------------------------
	b_world_load_graphics	= 6
_world_load_graphics::
	add	sp, #-60
;src/world.c:72: uint16_t first_count = scene->tile_count > 256u ? 256u : scene->tile_count;
	ld	a, (#_scene)
	ldhl	sp,	#56
	ld	(hl), a
	ld	a, (#_scene + 1)
	ldhl	sp,	#57
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	xor	a, a
	cp	a, e
	ld	a, #0x01
	sbc	a, d
	jr	NC, 00105$
	ld	bc, #0x0100
00105$:
	ldhl	sp,	#58
	ld	a, c
	ld	(hl+), a
;src/world.c:73: bank_bkg_data(scene->asset_bank, 0, (uint8_t)first_count, scene->tiles, 0);
	ld	a, b
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#58
	ld	a, (hl-)
	ld	d, a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	inc	hl
	ld	a, (hl)
	ld	h, #0x00
	push	hl
	inc	sp
	push	bc
	push	de
	inc	sp
	ld	e, #0x00
	call	_bank_bkg_data
;src/world.c:72: uint16_t first_count = scene->tile_count > 256u ? 256u : scene->tile_count;
	ld	a, (_scene)
	ld	c, a
	ld	hl, #_scene + 1
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#58
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;src/world.c:74: if(scene->tile_count > 256u)
	ldhl	sp,	#58
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	xor	a, a
	cp	a, e
	ld	a, #0x01
	sbc	a, d
	jr	NC, 00102$
;src/world.c:75: bank_bkg_data(scene->asset_bank, 64, (uint8_t)(scene->tile_count - 256u), scene->tiles + 4096u, 1);
	ld	hl, #0x000a
	add	hl, bc
	ld	a, (hl+)
	ld	l, (hl)
	ld	e, a
	ld	a, l
	add	a, #0x10
	ld	d, a
	ldhl	sp,	#58
	ld	a, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	ld	c, (hl)
	ld	h, #0x01
	push	hl
	inc	sp
	push	de
	push	af
	inc	sp
	ld	e, #0x40
	ld	a, c
	call	_bank_bkg_data
00102$:
;src/world.c:72: uint16_t first_count = scene->tile_count > 256u ? 256u : scene->tile_count;
	ld	a, (_scene)
	ld	c, a
	ld	hl, #_scene + 1
	ld	b, (hl)
;src/world.c:76: bank_copy(palette, scene->asset_bank, scene->palettes, sizeof(palette));
	ld	hl, #0x000c
	add	hl, bc
	ld	a, (hl+)
	ld	l, (hl)
	ld	e, a
	ld	d, l
	inc	bc
	ld	a, (bc)
	ld	c, a
	ld	hl, #0x0038
	push	hl
	push	de
	ld	a, c
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/world.c:77: set_bkg_palette(0, 7, palette);
	ld	hl, #0
	add	hl, sp
	push	hl
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/world.c:79: world_motion_reset(0);
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_world_motion_reset
	ld	hl, #_world_motion_reset
	call	___sdcc_bcall_ehl
	inc	sp
;src/world.c:80: drawn = 0;
	xor	a, a
	ld	(#_drawn),a
;src/world.c:81: }
	add	sp, #60
	ret
;src/world.c:82: uint8_t world_meta_at(uint16_t pixel_x, uint16_t pixel_y) WORLD_BANKED {
;	---------------------------------
; Function world_meta_at
; ---------------------------------
	b_world_meta_at	= 6
_world_meta_at::
	add	sp, #-4
;src/world.c:83: uint16_t index = ((pixel_y % WORLD_PIXEL_HEIGHT) >> 4) * 128u + ((pixel_x & 2047u) >> 4);
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	bc, #0x0600
	call	__moduint
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
	inc	sp
	inc	sp
	push	de
	ld	a, #0x07
00129$:
	ldhl	sp,	#0
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00129$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	and	a, #0x07
	ld	b, a
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	pop	hl
	push	hl
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
;src/world.c:84: if(ice_dirty) {
	ld	a, (#_ice_dirty)
	or	a, a
	jr	Z, 00105$
;src/world.c:85: uint16_t bit=ice_index((pixel_x&2047u)>>4,(pixel_y%WORLD_PIXEL_HEIGHT)>>4);
	ld	a, c
	call	_ice_index
;src/world.c:86: if(bit!=65535u&&(broken_ice[bit>>3]&(1u<<(bit&7u))))return 0xd7u;
	ld	e, c
	ld	d, b
	ld	a, e
	and	a, d
	inc	a
	jr	Z, 00105$
	ld	de, #_broken_ice+0
	ld	l, c
	ld	h, b
	srl	h
	rr	l
	srl	h
	rr	l
	srl	h
	rr	l
	add	hl, de
	ld	e, (hl)
	ld	a, c
	and	a, #0x07
	ld	c, a
	ld	hl, #0x0001
	inc	c
	jr	00132$
00131$:
	add	hl, hl
00132$:
	dec	c
	jr	NZ,00131$
	ld	a, e
	and	a, l
	ld	c, #0x00
	or	a, c
	jr	Z, 00105$
	ld	a, #0xd7
	jr	00106$
00105$:
;src/world.c:88: return bank_read8(scene->map_bank, scene->map + index);
	ld	a, (_scene)
	ld	hl, #_scene + 1
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0004
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #_scene
	push	af
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	pop	af
	ld	a, (hl)
	ld	e, c
	ld	d, b
	call	_bank_read8
00106$:
;src/world.c:89: }
	add	sp, #4
	ret
;src/world.c:90: uint8_t world_flags_at(uint16_t pixel_x, uint16_t pixel_y) WORLD_BANKED {
;	---------------------------------
; Function world_flags_at
; ---------------------------------
	b_world_flags_at	= 6
_world_flags_at::
;src/world.c:91: return collisions[world_meta_at(pixel_x, pixel_y)];
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_world_meta_at
	ld	hl, #_world_meta_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	l, a
	ld	h, #0x00
	ld	de, #_collisions
	add	hl, de
	ld	a, (hl)
;src/world.c:92: }
	ret
;src/world.c:93: void world_tile_at(uint16_t tile_x, uint16_t tile_y, uint8_t *tile, uint8_t *attribute) WORLD_BANKED {
;	---------------------------------
; Function world_tile_at
; ---------------------------------
	b_world_tile_at	= 6
_world_tile_at::
	add	sp, #-6
;src/world.c:96: tile_x &= 255u;
	ldhl	sp,	#12
	ld	a, (hl+)
	dec	hl
	ld	c, a
	xor	a, a
	ld	(hl), c
	inc	hl
;src/world.c:97: tile_y %= WORLD_TILE_HEIGHT;
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	bc, #0x00c0
	call	__moduint
	ldhl	sp,	#14
	ld	a, c
	ld	(hl+), a
;src/world.c:98: meta = world_meta_at(tile_x*8u,tile_y*8u);
	ld	a, b
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	b, (hl)
	add	a, a
	rl	b
	add	a, a
	rl	b
	add	a, a
	rl	b
	ld	c, a
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	de
	push	bc
	push	hl
	ld	e, #b_world_meta_at
	ld	hl, #_world_meta_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
;src/world.c:99: offset = (uint16_t)meta * 8u + (tile_y & 1u) * 4u + (tile_x & 1u) * 2u;
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a, (hl)
	and	a, #0x01
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, e
	and	a, #0x01
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	a, h
	ldhl	sp,	#2
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/world.c:100: bank_copy(pair, scene->asset_bank, scene->metatiles + offset, 2u);
	ld	a, (_scene)
	ld	c, a
	ld	hl, #_scene + 1
	ld	b, (hl)
	ld	hl, #0x0006
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#4
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
	inc	bc
	ld	a, (bc)
	ld	c, a
	ld	hl, #0x0002
	push	hl
	push	de
	ld	a, c
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/world.c:101: *tile = pair[0]; *attribute = pair[1];
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#1
	ld	a, (hl)
	ld	(bc), a
;src/world.c:102: }
	add	sp, #6
	ret
;src/world.c:104: static void draw_row(uint16_t x, uint16_t y) {
;	---------------------------------
; Function draw_row
; ---------------------------------
_draw_row:
	add	sp, #-9
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#4
	ld	a, c
	ld	(hl+), a
;src/world.c:105: uint8_t i, first = 32u - (x & 31u);
	ld	a, b
	ld	(hl+), a
	ld	a, (hl)
	and	a, #0x1f
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, #0x20
	sub	a, (hl)
	inc	hl
	ld	(hl), a
;src/world.c:106: if(first > 21u) first = 21u;
	ld	a, #0x15
	sub	a, (hl)
	jr	NC, 00113$
	ld	(hl), #0x15
;src/world.c:107: for(i=0;i<21u;++i) world_tile_at(x+i,y,&tiles_buffer[i],&attrs_buffer[i]);
00113$:
	ldhl	sp,	#8
	ld	(hl), #0x00
00108$:
	ld	de, #_attrs_buffer
	ldhl	sp,	#8
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
	ld	(hl), a
	ld	de, #_tiles_buffer
	ldhl	sp,	#8
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	push	bc
	ld	e, #b_world_tile_at
	ld	hl, #_world_tile_at
	call	___sdcc_bcall_ehl
	add	sp, #8
	ldhl	sp,	#8
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x15
	jr	C, 00108$
;src/world.c:108: VBK_REG=0; set_bkg_tiles(x&31u,y&31u,first,1,tiles_buffer);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_tiles_buffer
	ldhl	sp,	#4
	ld	a, (hl)
	and	a, #0x1f
	ld	b, a
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl-)
	push	af
	inc	sp
	ld	c, (hl)
	push	bc
	call	_set_bkg_tiles
	add	sp, #6
;src/world.c:109: if(first<21u) set_bkg_tiles(0,y&31u,21u-first,1,tiles_buffer+first);
	ldhl	sp,	#1
	ld	a, (hl)
	sub	a, #0x15
	ld	a, #0x00
	rla
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, #0x15
	ldhl	sp,	#1
	sub	a, (hl)
	ld	c, a
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00105$
	ld	de, #_tiles_buffer
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
00105$:
;src/world.c:110: VBK_REG=1; set_bkg_tiles(x&31u,y&31u,first,1,attrs_buffer);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_attrs_buffer
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl-)
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/world.c:111: if(first<21u) set_bkg_tiles(0,y&31u,21u-first,1,attrs_buffer+first);
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	ld	de, #_attrs_buffer
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
00107$:
;src/world.c:112: VBK_REG=0;
	xor	a, a
	ldh	(_VBK_REG + 0), a
;src/world.c:113: }
	add	sp, #9
	ret
;src/world.c:114: static void draw_column(uint16_t x, uint16_t y) {
;	---------------------------------
; Function draw_column
; ---------------------------------
_draw_column:
	add	sp, #-9
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#4
	ld	a, c
	ld	(hl+), a
;src/world.c:115: uint8_t i, first=32u-(y&31u);
	ld	a, b
	ld	(hl-), a
	ld	a, (hl)
	and	a, #0x1f
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, #0x20
	sub	a, (hl)
	inc	hl
	ld	(hl), a
;src/world.c:116: if(first>19u) first=19u;
	ld	a, #0x13
	sub	a, (hl)
	jr	NC, 00113$
	ld	(hl), #0x13
;src/world.c:117: for(i=0;i<19u;++i) world_tile_at(x,y+i,&tiles_buffer[i],&attrs_buffer[i]);
00113$:
	ldhl	sp,	#8
	ld	(hl), #0x00
00108$:
	ld	de, #_attrs_buffer
	ldhl	sp,	#8
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
	ld	(hl), a
	ld	de, #_tiles_buffer
	ldhl	sp,	#8
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	push	de
	push	bc
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_world_tile_at
	ld	hl, #_world_tile_at
	call	___sdcc_bcall_ehl
	add	sp, #8
	ldhl	sp,	#8
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x13
	jr	C, 00108$
;src/world.c:118: VBK_REG=0; set_bkg_tiles(x&31u,y&31u,1,first,tiles_buffer);
	dec	hl
	dec	hl
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	de, #_tiles_buffer
	ld	a, (hl)
	and	a, #0x1f
	ld	b, a
	push	de
	ldhl	sp,	#3
	ld	a, (hl-)
	ld	d, a
	ld	e, #0x01
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/world.c:119: if(first<19u) set_bkg_tiles(x&31u,0,1,19u-first,tiles_buffer+first);
	ldhl	sp,	#1
	ld	a, (hl)
	sub	a, #0x13
	ld	a, #0x00
	rla
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, #0x13
	ldhl	sp,	#1
	sub	a, (hl)
	ld	c, a
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00105$
	ld	de, #_tiles_buffer
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	h, c
	ld	l, #0x01
	push	hl
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
00105$:
;src/world.c:120: VBK_REG=1; set_bkg_tiles(x&31u,y&31u,1,first,attrs_buffer);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_attrs_buffer
	push	de
	ldhl	sp,	#3
	ld	a, (hl-)
	ld	d, a
	ld	e, #0x01
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/world.c:121: if(first<19u) set_bkg_tiles(x&31u,0,1,19u-first,attrs_buffer+first);
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	ld	de, #_attrs_buffer
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	h, c
	ld	l, #0x01
	push	hl
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
00107$:
;src/world.c:122: VBK_REG=0;
	xor	a, a
	ldh	(_VBK_REG + 0), a
;src/world.c:123: }
	add	sp, #9
	ret
;src/world.c:125: void world_draw(uint16_t camera_x, uint16_t camera_y, uint8_t force) WORLD_BANKED {
;	---------------------------------
; Function world_draw
; ---------------------------------
	b_world_draw	= 6
_world_draw::
	add	sp, #-11
;src/world.c:126: uint16_t x=(camera_x & 2047u)>>3, y=(camera_y % WORLD_PIXEL_HEIGHT)>>3;
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	and	a, #0x07
	ld	b, a
	ldhl	sp,	#9
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl-), a
	ld	bc, #0x0600
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__moduint
	ldhl	sp,	#9
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#10
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
;src/world.c:129: uint16_t dx=(x-previous_tile_x)&255u;
	ldhl	sp,	#0
	ld	a, (hl)
	ld	hl, #_previous_tile_x
	ld	c, (hl)
	sub	a, c
	ldhl	sp,	#8
	ld	(hl), a
;src/world.c:130: uint16_t dy=(y+WORLD_TILE_HEIGHT-previous_tile_y)%WORLD_TILE_HEIGHT;
	ldhl	sp,	#2
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00c0
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_previous_tile_y
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	bc, #0x00c0
	call	__moduint
	ld	e, c
;src/world.c:131: if(!drawn || force || (dx!=0u && dx!=1u && dx!=255u) ||
	ld	a, (#_drawn)
	or	a, a
	jr	Z, 00131$
	ldhl	sp,	#21
	ld	a, (hl)
	or	a, a
	jr	NZ, 00131$
	ldhl	sp,	#8
	ld	c, (hl)
	ld	a, c
	dec	a
	ld	a, #0x01
	jr	Z, 00211$
	xor	a, a
00211$:
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00115$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00115$
	inc	c
	jr	NZ, 00131$
00115$:
;src/world.c:132: (dy!=0u && dy!=1u && dy!=191u)) {
	ld	c, e
	ld	a, c
	dec	a
	ld	a, #0x01
	jr	Z, 00215$
	xor	a, a
00215$:
	ldhl	sp,	#10
	ld	(hl), a
	ld	a, e
	or	a, a
	jr	Z, 00107$
	bit	0, (hl)
	jr	NZ, 00107$
	ld	a, c
	sub	a, #0xbf
	jr	Z, 00107$
;src/world.c:133: for(row=0;row<19u;++row) draw_row(x,y+row);
00131$:
	ldhl	sp,	#10
	ld	(hl), #0x00
00117$:
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	call	_draw_row
	ldhl	sp,	#10
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x13
	jr	C, 00117$
	jr	00108$
00107$:
;src/world.c:135: if(dx) draw_column(dx==1u?x+20u:x,y);
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00121$
	pop	bc
	push	bc
	ld	hl, #0x0014
	add	hl, bc
	ld	a, l
	ld	d, h
	jr	00122$
00121$:
	ldhl	sp,	#0
	ld	a, (hl)
	ld	d, #0x00
00122$:
	push	de
	ldhl	sp,	#4
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	e, a
	call	_draw_column
	pop	de
00103$:
;src/world.c:136: if(dy) draw_row(x,dy==1u?y+18u:y);
	ld	a, e
	or	a, a
	jr	Z, 00108$
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00123$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0012
	add	hl, de
	ld	e, l
	ld	d, h
	jr	00124$
00123$:
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
00124$:
	ld	c, e
	ld	b, d
	pop	de
	push	de
	call	_draw_row
00108$:
;src/world.c:138: move_bkg((uint8_t)camera_x,(uint8_t)camera_y);
	ldhl	sp,	#19
	ld	a, (hl-)
	dec	hl
	ld	c, a
	ld	a, (hl)
	ldh	(_SCX_REG + 0), a
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	ld	a, c
	ldh	(_SCY_REG + 0), a
;src/world.c:142: previous_tile_x=x; previous_tile_y=y; drawn=1;
	ldhl	sp,	#0
	ld	a, (hl)
	ld	hl, #_previous_tile_x
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(#_previous_tile_y),a
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(#_previous_tile_y + 1),a
	ld	hl, #_drawn
	ld	(hl), #0x01
;src/world.c:143: }
	add	sp, #11
	ret
;src/world.c:144: uint8_t world_can_stand(uint16_t x, uint16_t y) WORLD_BANKED {
;	---------------------------------
; Function world_can_stand
; ---------------------------------
	b_world_can_stand	= 6
_world_can_stand::
	add	sp, #-6
;src/world.c:145: uint16_t left=(x-5u)&2047u, right=(x+4u)&2047u;
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	add	a, #0xfb
	ld	c, a
	ld	a, d
	adc	a, #0xff
	and	a, #0x07
	ldhl	sp,	#0
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	a, h
	and	a, #0x07
	ldhl	sp,	#2
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/world.c:146: uint16_t top=wrap_y((int16_t)y-7), bottom=wrap_y((int16_t)y-2);
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	c, (hl)
	ld	l, a
	ld	h, c
	ld	a, l
	add	a, #0xf9
	ld	c, a
	ld	a, h
	adc	a, #0xff
	push	hl
	push	de
	ld	e, c
	ld	d, a
	call	_wrap_y
	pop	de
	pop	hl
	dec	hl
	dec	hl
	push	bc
	push	de
	ld	e, l
	ld	d, h
	call	_wrap_y
	ldhl	sp,	#8
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	de
	pop	bc
;src/world.c:147: if(x>=WORLD_PIXEL_WIDTH || y>=WORLD_PIXEL_HEIGHT) return 0;
	ld	a, d
	sub	a, #0x08
	jr	NC, 00101$
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, d
	sub	a, #0x06
	jr	C, 00102$
00101$:
	xor	a, a
	jr	00104$
00102$:
;src/world.c:148: return !((world_flags_at(left,top)|world_flags_at(right,top)|
	push	bc
	push	bc
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	e, a
	pop	bc
	push	de
	push	bc
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	or	a, e
	ld	c, a
;src/world.c:149: world_flags_at(left,bottom)|world_flags_at(right,bottom))&1u);
	push	bc
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	or	a, c
	ld	c, a
	push	bc
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	or	a, c
	and	a, #0x01
	sub	a, #0x01
	ld	a, #0x00
	rla
00104$:
;src/world.c:150: }
	add	sp, #6
	ret
;src/world.c:151: static uint8_t break_ice(uint16_t x,uint16_t y) {
;	---------------------------------
; Function break_ice
; ---------------------------------
_break_ice:
	add	sp, #-11
	ldhl	sp,	#9
	ld	(hl), e
	inc	hl
	ld	(hl), d
	ldhl	sp,	#7
	ld	(hl), c
	inc	hl
	ld	(hl), b
;src/world.c:152: uint8_t meta=world_meta_at(x,y);uint16_t bit;
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	push	de
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_world_meta_at
	ld	hl, #_world_meta_at
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/world.c:153: if(meta>=0xd8u&&meta<0xe0u) {
	ldhl	sp,#4
	ld	(hl), a
	sub	a, #0xd8
	jp	C, 00104$
	ld	a, (hl)
	sub	a, #0xe0
	jp	NC, 00104$
;src/world.c:154: bit=ice_index((x&2047u)>>4,(y%WORLD_PIXEL_HEIGHT)>>4);
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	bc, #0x0600
	call	__moduint
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#6
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#2
	ld	a, (hl)
	and	a, #0x07
	ldhl	sp,	#6
	ld	(hl), a
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl+)
	ld	(hl), a
	ldhl	sp,	#3
	ld	e, (hl)
	ldhl	sp,	#6
	ld	a, (hl)
	call	_ice_index
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/world.c:155: if(bit!=65535u) {
	ldhl	sp,	#5
	ld	a, (hl+)
	and	a, (hl)
	inc	a
	jr	Z, 00104$
;src/world.c:156: broken_ice[bit>>3]|=1u<<(bit&7u);meta=0xd7u;
	dec	hl
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	pop	de
	push	de
	ld	hl, #_broken_ice
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
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	ld	a, (hl+)
	ld	(hl), a
	and	a, #0x07
	ld	(hl), a
	push	af
	ld	(hl), #0x01
	pop	af
	inc	a
	jr	00131$
00130$:
	ldhl	sp,	#6
	sla	(hl)
00131$:
	dec	a
	jr	NZ,00130$
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	or	a, (hl)
	inc	hl
	inc	hl
	ld	(hl), a
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	ld	(de), a
	ld	(hl), #0xd7
;src/world.c:157: ice_dirty=world_ice_changed=1;drawn=0;
	ld	hl, #_world_ice_changed
	ld	(hl), #0x01
	ld	hl, #_ice_dirty
	ld	(hl), #0x01
	xor	a, a
	ld	(#_drawn),a
00104$:
;src/world.c:160: return collisions[meta];
	ld	de, #_collisions
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
;src/world.c:161: }
	add	sp, #11
	ret
;src/world.c:162: void world_vehicle_footprint(uint16_t x,uint16_t y,uint8_t vehicle) WORLD_BANKED {
;	---------------------------------
; Function world_vehicle_footprint
; ---------------------------------
	b_world_vehicle_footprint	= 6
_world_vehicle_footprint::
	add	sp, #-9
;src/world.c:163: uint8_t n;world_terrain_sync(x,y);world_ice_changed=0;
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_world_terrain_sync
	ld	hl, #_world_terrain_sync
	call	___sdcc_bcall_ehl
	add	sp, #4
	xor	a, a
	ld	(#_world_ice_changed),a
;src/world.c:164: if(world_group_id!=2u||vehicle!=12u)return;
	ld	a, (#_world_group_id)
	sub	a, #0x02
	jp	NZ, 00107$
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x0c
;src/world.c:165: for(n=0;n<4u;++n)break_ice((x-8u-((n&1u)?0u:16u))&2047u,
	jp	NZ, 00107$
	ldhl	sp,	#8
	ld	(hl), #0x00
00105$:
;src/world.c:166: wrap_y((int16_t)y-16-((n&2u)?0:16)));
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0010
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), e
	push	hl
	inc	hl
	inc	hl
	bit	1, (hl)
	pop	hl
	jr	Z, 00109$
	ld	bc, #0x0000
	jr	00110$
00109$:
	ld	bc, #0x0010
00110$:
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	d, a
	call	_wrap_y
	pop	hl
	push	bc
;src/world.c:165: for(n=0;n<4u;++n)break_ice((x-8u-((n&1u)?0u:16u))&2047u,
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0008
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ldhl	sp,	#3
	ld	(hl-), a
	ld	(hl), e
	push	hl
	ldhl	sp,	#10
	bit	0, (hl)
	pop	hl
	jr	Z, 00111$
	xor	a, a
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), a
	jr	00112$
00111$:
	ldhl	sp,	#4
	ld	a, #0x10
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
00112$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl-)
	dec	hl
	and	a, #0x07
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	pop	bc
	push	bc
	call	_break_ice
	ldhl	sp,	#8
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jp	C, 00105$
00107$:
;src/world.c:167: }
	add	sp, #9
	ret
;src/world.c:168: uint8_t world_step_allowed(uint16_t x, uint16_t y, uint8_t facing, uint8_t vehicle) WORLD_BANKED {
;	---------------------------------
; Function world_step_allowed
; ---------------------------------
	b_world_step_allowed	= 6
_world_step_allowed::
	add	sp, #-5
;src/world.c:169: int16_t px=(int16_t)x-8, py=(int16_t)y-16;
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	b, (hl)
	add	a, #0xf8
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ldhl	sp,	#1
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	b, (hl)
;src/world.c:171: uint8_t mask=vehicle==8u?10u:1u;
	inc	hl
	inc	hl
	add	a, #0xf0
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	b, a
	ld	a, (hl)
	sub	a, #0x08
	ld	a, #0x0a
	jr	Z, 00129$
	ld	a, #0x01
00129$:
	ldhl	sp,	#0
	ld	(hl), a
;src/world.c:172: world_terrain_sync(x,y);world_ice_changed=0;
	push	bc
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_world_terrain_sync
	ld	hl, #_world_terrain_sync
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	xor	a, a
	ld	(#_world_ice_changed),a
;src/world.c:173: if(facing>3u) return 0;
	ld	a, #0x03
	ldhl	sp,	#15
	sub	a, (hl)
	jr	NC, 00102$
	xor	a, a
	jp	00126$
00102$:
;src/world.c:174: if(facing==0u) py+=16; else if(facing==1u) py-=16;
	ld	e, c
	ld	d, b
	ldhl	sp,	#15
	ld	a, (hl)
	dec	a
	ld	a, #0x01
	jr	Z, 00210$
	xor	a, a
00210$:
	ldhl	sp,	#3
	ld	(hl), a
;src/world.c:175: else if(facing==2u) px-=16; else px+=16;
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00212$
	xor	a, a
00212$:
	ldhl	sp,	#4
	ld	(hl), a
;src/world.c:174: if(facing==0u) py+=16; else if(facing==1u) py-=16;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	jr	NZ, 00110$
	ld	hl, #0x0010
	add	hl, de
	ld	c, l
	ld	b, h
	jr	00111$
00110$:
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	ld	a, e
	add	a, #0xf0
	ld	c, a
	ld	a, d
	adc	a, #0xff
	ld	b, a
	jr	00111$
00107$:
;src/world.c:175: else if(facing==2u) px-=16; else px+=16;
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	ld	a, e
	add	a, #0xf0
	ld	e, a
	ld	a, d
	adc	a, #0xff
	ldhl	sp,	#1
	ld	(hl), e
	inc	hl
	ld	(hl), a
	jr	00111$
00104$:
	ld	hl, #0x0010
	add	hl, de
	ld	e, l
	ld	a, h
	ldhl	sp,	#1
	ld	(hl), e
	inc	hl
	ld	(hl), a
00111$:
;src/world.c:178: if(vehicle) {if(facing==1u)py-=16;else if(facing==2u)px-=16;}
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00115$
	ld	a, c
	add	a, #0xf0
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	b, a
	jr	00118$
00115$:
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	d, (hl)
	dec	hl
	add	a, #0xf0
	ld	e, a
	ld	a, d
	adc	a, #0xff
	ld	(hl), e
	inc	hl
	ld	(hl), a
00118$:
;src/world.c:179: x1=(uint16_t)px&2047u; y1=wrap_y(py);
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl)
	and	a, #0x07
	ld	d, a
	push	de
	ld	e, c
	ld	d, b
	call	_wrap_y
	pop	de
;src/world.c:180: if(!vehicle) return !(world_flags_at(x1,y1)&1u);
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	NZ, 00120$
	push	bc
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	and	a, #0x01
	ld	c, a
	sub	a, #0x01
	ld	a, #0x00
	rla
	jp	00126$
00120$:
;src/world.c:182: x2=x1; y2=y1;
	ldhl	sp,	#3
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/world.c:183: if(facing<2u) x2=(x1-16u)&2047u; else y2=wrap_y((int16_t)y1-16);
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00122$
	ld	a, e
	ld	l, d
	add	a, #0xf0
	ld	h, a
	ld	a, l
	adc	a, #0xff
	ld	l, a
	push	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, l
	and	a, #0x07
	ldhl	sp,	#4
	ld	(hl), a
	jr	00123$
00122$:
	ld	a, c
	ld	h, b
	add	a, #0xf0
	ld	l, a
	ld	a, h
	adc	a, #0xff
	push	bc
	push	de
	ld	e, l
	ld	d, a
	call	_wrap_y
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	de
	pop	bc
00123$:
;src/world.c:184: if(vehicle==12u) {
	ldhl	sp,	#16
	ld	a, (hl)
	sub	a, #0x0c
	jr	NZ, 00125$
;src/world.c:185: uint8_t a=break_ice(x1,y1),b=break_ice(x2,y2);
	call	_break_ice
	ld	e, a
	push	de
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_break_ice
	pop	de
;src/world.c:186: return !((a|b)&1u);
	or	a, e
	and	a, #0x01
	ld	c, a
	sub	a, #0x01
	ld	a, #0x00
	rla
	jr	00126$
00125$:
;src/world.c:188: return !((world_flags_at(x1,y1)|world_flags_at(x2,y2))&mask);
	push	bc
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	c, a
	push	bc
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	or	a, c
	ldhl	sp,	#0
	and	a, (hl)
	sub	a, #0x01
	ld	a, #0x00
	rla
00126$:
;src/world.c:189: }
	add	sp, #5
	ret
;src/world.c:205: static uint8_t vehicle_sample(uint16_t x,uint16_t y,uint8_t index) {
;	---------------------------------
; Function vehicle_sample
; ---------------------------------
_vehicle_sample:
	push	de
	ld	a, c
;src/world.c:207: wrap_y((int16_t)y-112+sample_offsets[index]));
	add	a, #0x90
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	b, a
	ld	de, #_sample_offsets
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_wrap_y
;src/world.c:206: return world_flags_at((x-136u+sample_offsets[index+1u])&2047u,
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	d, (hl)
	add	a, #0x78
	ld	e, a
	ld	a, d
	adc	a, #0xff
	ld	d, a
	ldhl	sp,	#4
	ld	a, (hl)
	inc	a
	add	a, #<(_sample_offsets)
	ld	l, a
	ld	a, #0x00
	adc	a, #>(_sample_offsets)
	ld	h, a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	a, h
	and	a, #0x07
	ld	h, a
	push	bc
	push	hl
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/world.c:208: }
	inc	sp
	inc	sp
	pop	hl
	inc	sp
	jp	(hl)
_land_checks:
	.db #0x0a	; 10
	.db #0x0c	; 12
	.db #0x12	; 18
	.db #0x14	; 20
	.db #0x0c	; 12
	.db #0x0e	; 14
	.db #0x14	; 20
	.db #0x16	; 22
	.db #0x12	; 18
	.db #0x14	; 20
	.db #0x1a	; 26
	.db #0x1c	; 28
	.db #0x14	; 20
	.db #0x16	; 22
	.db #0x1c	; 28
	.db #0x1e	; 30
_hover_checks:
	.db #0x02	; 2
	.db #0x04	; 4
	.db #0x0a	; 10
	.db #0x0c	; 12
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0x06	; 6
	.db #0x0c	; 12
	.db #0x0e	; 14
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0x0e	; 14
	.db #0x26	; 38
	.db #0x16	; 22
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x16	; 22
	.db #0x28	; 40
	.db #0x1e	; 30
	.db #0x2a	; 42
	.db #0x10	; 16
	.db #0x20	; 32
	.db #0x1c	; 28
	.db #0x1e	; 30
	.db #0x22	; 34
	.db #0x24	; 36
	.db #0x20	; 32
	.db #0x10	; 16
	.db #0x1a	; 26
	.db #0x1c	; 28
	.db #0x20	; 32
	.db #0x22	; 34
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x12	; 18
	.db #0x18	; 24
	.db #0x1a	; 26
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0x08	; 8
	.db #0x0a	; 10
	.db #0x10	; 16
	.db #0x12	; 18
	.db #0x00	; 0
	.db #0xf0	; 240
_hover_exits:
	.db #0x02	; 2
	.db #0xe0	; 224
	.db #0xf0	; 240
	.db #0x04	; 4
	.db #0xe0	; 224
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0x16	; 22
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x1c	; 28
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x1a	; 26
	.db #0x10	; 16
	.db #0xf0	; 240
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0xe0	; 224
	.db #0x08	; 8
	.db #0xf0	; 240
	.db #0xe0	; 224
_sample_offsets:
	.db #0x40	; 64
	.db #0x60	; 96
	.db #0x40	; 64
	.db #0x70	; 112	'p'
	.db #0x40	; 64
	.db #0x80	; 128
	.db #0x40	; 64
	.db #0x90	; 144
	.db #0x50	; 80	'P'
	.db #0x60	; 96
	.db #0x50	; 80	'P'
	.db #0x70	; 112	'p'
	.db #0x50	; 80	'P'
	.db #0x80	; 128
	.db #0x50	; 80	'P'
	.db #0x90	; 144
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x60	; 96
	.db #0x70	; 112	'p'
	.db #0x60	; 96
	.db #0x80	; 128
	.db #0x60	; 96
	.db #0x90	; 144
	.db #0x70	; 112	'p'
	.db #0x60	; 96
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x70	; 112	'p'
	.db #0x80	; 128
	.db #0x70	; 112	'p'
	.db #0x90	; 144
	.db #0x80	; 128
	.db #0x70	; 112	'p'
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x80	; 128
	.db #0x90	; 144
	.db #0x50	; 80	'P'
	.db #0xa0	; 160
	.db #0x60	; 96
	.db #0xa0	; 160
	.db #0x70	; 112	'p'
	.db #0xa0	; 160
;src/world.c:209: uint8_t world_vehicle_use(uint16_t *x,uint16_t *y,uint8_t facing,uint8_t interaction,
;	---------------------------------
; Function world_vehicle_use
; ---------------------------------
	b_world_vehicle_use	= 6
_world_vehicle_use::
	add	sp, #-16
;src/world.c:211: uint8_t i,n,found=0,exit=*vehicle==requested;
	ldhl	sp,	#0
	ld	(hl), #0x00
	ldhl	sp,#29
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl)
	sub	a, c
	ld	a, #0x01
	jr	Z, 00333$
	xor	a, a
00333$:
	ldhl	sp,	#1
;src/world.c:212: int8_t dx=0,dy=0;
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/world.c:214: if((requested!=4u&&requested!=8u&&requested!=12u)||facing>3u)return 0;
	ldhl	sp,	#28
	ld	a, (hl)
	sub	a, #0x08
	ld	a, #0x01
	jr	Z, 00335$
	xor	a, a
00335$:
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#28
	ld	a, (hl)
	sub	a, #0x0c
	ld	a, #0x01
	jr	Z, 00337$
	xor	a, a
00337$:
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#28
	ld	a, (hl)
	sub	a, #0x04
	jr	Z, 00105$
	ldhl	sp,	#15
	bit	0, (hl)
	jr	NZ, 00105$
	dec	hl
	bit	0, (hl)
	jr	Z, 00101$
00105$:
	ld	a, #0x03
	ldhl	sp,	#26
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jp	00145$
00102$:
;src/world.c:215: if(!exit&&(world_group_id>=4u||!interaction||(requested==12u&&world_group_id!=2u)))return 0;
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	NZ, 00107$
	ld	a, (#_world_group_id)
	sub	a, #0x04
	jr	NC, 00106$
	ldhl	sp,	#27
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	ld	a, (#_world_group_id)
	sub	a, #0x02
	jr	Z, 00107$
00106$:
	xor	a, a
	jp	00145$
00107$:
;src/world.c:216: world_terrain_sync(*x,*y);
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
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
;src/world.c:217: if(requested!=8u) {
	ldhl	sp,	#15
	bit	0, (hl)
	jp	NZ, 00131$
;src/world.c:218: for(i=0;i<4u;++i) {
	ldhl	sp,	#10
	ld	(hl), #0x00
	ldhl	sp,	#14
	ld	(hl), #0x00
;src/world.c:219: for(n=0;n<4u;++n)if(vehicle_sample(*x,*y,land_checks[i][n])&13u)break;
00163$:
	ldhl	sp,	#15
	ld	(hl), #0x00
00135$:
	ldhl	sp,	#14
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00340$:
	ldhl	sp,	#12
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00340$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_land_checks
	add	hl, de
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
	ldhl	sp,	#15
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#12
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_vehicle_sample
	and	a, #0x0d
	jr	NZ, 00114$
	ldhl	sp,	#15
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00135$
00114$:
;src/world.c:220: if(n==4u){found=1;dx=(i&1u)?16:0;dy=(i&2u)?16:0;break;}
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00138$
	ldhl	sp,	#0
	ld	(hl), #0x01
	push	hl
	ldhl	sp,	#12
	bit	0, (hl)
	pop	hl
	ld	a, #0x10
	jr	NZ, 00148$
	xor	a, a
00148$:
	ldhl	sp,	#2
	ld	(hl), a
	push	hl
	ldhl	sp,	#12
	bit	1, (hl)
	pop	hl
	ld	a, #0x10
	jr	NZ, 00150$
	xor	a, a
00150$:
	ldhl	sp,	#3
	ld	(hl), a
	jp	00132$
00138$:
;src/world.c:218: for(i=0;i<4u;++i) {
	ldhl	sp,	#14
	inc	(hl)
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl)
	sub	a, #0x04
	jp	C, 00163$
	jp	00132$
00131$:
;src/world.c:222: } else if(!exit) {
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jp	NZ, 00128$
;src/world.c:223: for(i=0;i<8u;++i) {
	ldhl	sp,	#8
	ld	(hl), #0x00
	ldhl	sp,	#14
	ld	(hl), #0x00
;src/world.c:224: for(n=0;n<4u;++n)if(vehicle_sample(*x,*y,hover_checks[i][n])&10u)break;
00171$:
	ldhl	sp,	#14
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl), a
	ld	de, #_hover_checks
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#15
	ld	(hl), #0x00
00139$:
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#15
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#12
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_vehicle_sample
	and	a, #0x0a
	jr	NZ, 00120$
	ldhl	sp,	#15
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00139$
00120$:
;src/world.c:225: if(n==4u){found=1;dy=(int8_t)hover_checks[i][4];dx=(int8_t)hover_checks[i][5];break;}
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00142$
	ldhl	sp,	#0
	ld	(hl), #0x01
	ldhl	sp,	#8
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_hover_checks
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#2
	ld	(hl), a
	jp	00132$
00142$:
;src/world.c:223: for(i=0;i<8u;++i) {
	ldhl	sp,	#14
	inc	(hl)
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl)
	sub	a, #0x08
	jp	C, 00171$
	jp	00132$
00128$:
;src/world.c:228: i=direction[facing]*2u;
	ld	de, #_world_vehicle_use_direction_10000_247
	ldhl	sp,	#26
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	add	a, a
	ldhl	sp,	#8
	ld	(hl), a
;src/world.c:229: for(n=0;n<8u;++n,i=(i+1u)&7u)if(!(vehicle_sample(*x,*y,hover_exits[i][0])&13u)) {
	ldhl	sp,	#15
	ld	(hl), #0x00
00143$:
	ldhl	sp,	#8
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #_hover_exits
	add	hl, bc
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
	ld	b, a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#11
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#13
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	push	bc
	inc	sp
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_vehicle_sample
	and	a, #0x0d
	jr	NZ, 00144$
;src/world.c:230: found=1;dy=(int8_t)hover_exits[i][1];dx=(int8_t)hover_exits[i][2];break;
	ldhl	sp,	#0
	ld	(hl), #0x01
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#2
	ld	(hl), a
	jr	00132$
00144$:
;src/world.c:229: for(n=0;n<8u;++n,i=(i+1u)&7u)if(!(vehicle_sample(*x,*y,hover_exits[i][0])&13u)) {
	ldhl	sp,	#15
	inc	(hl)
	ldhl	sp,	#8
	ld	a, (hl)
	inc	a
	and	a, #0x07
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x08
	jp	C, 00143$
00132$:
;src/world.c:233: if(!found)return 0;
	ldhl	sp,	#0
	ld	a, (hl)
	or	a,a
	jr	Z, 00145$
;src/world.c:234: *x=(*x+dx)&2047u;*y=wrap_y((int16_t)*y+dy);*vehicle=exit?0u:requested;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#2
	ld	a, (hl)
	ld	e, a
	rlca
	sbc	a, a
	ld	l, e
	ld	h, a
	add	hl, bc
	ld	c, l
	ld	a, h
	and	a, #0x07
	ld	b, a
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	a, (hl)
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	l, c
	ld	h, b
	add	hl, de
	ld	e, l
	ld	d, h
	call	_wrap_y
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#29
	ld	a, (hl+)
	ld	b, a
	ld	c, (hl)
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	Z, 00151$
	xor	a, a
	jr	00152$
00151$:
	ldhl	sp,	#28
	ld	a, (hl)
00152$:
	ld	l, b
	ld	h, c
	ld	(hl), a
;src/world.c:235: return exit?2u:1u;
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	ld	a, #0x02
	jr	NZ, 00154$
	ld	a, #0x01
00154$:
00145$:
;src/world.c:236: }
	add	sp, #16
	ret
_world_vehicle_use_direction_10000_247:
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x01	; 1
;src/world.c:237: uint8_t world_decode_y(uint8_t packed) WORLD_BANKED {
;	---------------------------------
; Function world_decode_y
; ---------------------------------
	b_world_decode_y	= 6
_world_decode_y::
;src/world.c:238: return (uint8_t)(((uint16_t)(packed>>4)*12u+(packed&15u))%96u);
	ldhl	sp,	#6
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ld	c, a
	add	a, a
	add	a, c
	add	a, a
	add	a, a
	ld	c, a
	ld	a, (hl)
	and	a, #0x0f
	add	a, c
	ld	e, #0x60
	call	__moduchar
	ld	a, c
;src/world.c:239: }
	ret
;src/world.c:240: void world_decode_destination(const WorldAction *action, uint16_t *x, uint16_t *y) WORLD_BANKED {
;	---------------------------------
; Function world_decode_destination
; ---------------------------------
	b_world_decode_destination	= 6
_world_decode_destination::
;src/world.c:241: *x=((uint16_t)action->b*16u+8u)&2047u;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	l, (hl)
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #0x08
	ld	l, a
	ld	a, h
	adc	a, #0x00
	and	a, #0x07
	ld	h, a
	ld	a, l
	ld	(de), a
	inc	de
	ld	a, h
	ld	(de), a
;src/world.c:242: *y=((uint16_t)world_decode_y(action->a)*16u+16u)%WORLD_PIXEL_HEIGHT;
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	push	de
	push	af
	inc	sp
	ld	e, #b_world_decode_y
	ld	hl, #_world_decode_y
	call	___sdcc_bcall_ehl
	inc	sp
	pop	de
	ld	l, a
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #0x0010
	add	hl, bc
	push	de
	ld	bc, #0x0600
	ld	e, l
	ld	d, h
	call	__moduint
	pop	de
	ld	a, c
	ld	(de), a
	inc	de
	ld	a, b
	ld	(de), a
;src/world.c:243: }
	ret
;src/world.c:244: uint8_t world_road_destination(uint8_t index, WorldAction *action) WORLD_BANKED {
;	---------------------------------
; Function world_road_destination
; ---------------------------------
	b_world_road_destination	= 6
_world_road_destination::
	dec	sp
	dec	sp
;src/world.c:245: memset(action,0,sizeof(*action));
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0006
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/world.c:246: if(index<1u || index>6u) return 0;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x01
	jr	C, 00101$
	ld	a, #0x06
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jr	00104$
00102$:
;src/world.c:247: action->mode=WORLD_ACTION_MAP;
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	hl
	ld	(hl), #0x08
;src/world.c:248: action->target=roads[index-1u][5]; action->a=roads[index-1u][6]; action->b=roads[index-1u][7];
	ld	c, l
	ld	b, h
	push	bc
	inc	bc
	ld	de, #_roads+0
	ldhl	sp,	#8
	ld	a, (hl)
	dec	a
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0005
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
	pop	bc
	push	bc
	inc	bc
	inc	bc
	ld	hl, #0x0006
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	bc
	ld	hl, #0x0007
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/world.c:249: return 1;
	ld	a, #0x01
00104$:
;src/world.c:250: }
	inc	sp
	inc	sp
	ret
;src/world.c:251: uint8_t world_check_trigger(uint16_t x, uint16_t y, uint8_t vehicle, WorldAction *action) WORLD_BANKED {
;	---------------------------------
; Function world_check_trigger
; ---------------------------------
	b_world_check_trigger	= 6
_world_check_trigger::
	add	sp, #-30
;src/world.c:252: uint8_t sample, samples=vehicle?4u:1u, mx=0,my=0,meta=0,flags=0,i;
	ldhl	sp,	#40
	ld	a, (hl)
	or	a, a
	ld	a, #0x04
	jr	NZ, 00141$
	ld	a, #0x01
00141$:
	ldhl	sp,	#6
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
	ldhl	sp,	#27
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/world.c:255: memset(action,0,sizeof(*action));
	ldhl	sp,	#41
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0006
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/world.c:256: for(sample=0;sample<samples;++sample) {
	ldhl	sp,	#29
	ld	(hl), #0x00
00133$:
;src/world.c:263: action->metatile=meta;action->flags=flags;
	ldhl	sp,	#41
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/world.c:265: action->mode=WORLD_ACTION_MAP;
	ldhl	sp,	#9
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/world.c:266: action->target=town_exits[world_map_id-4u][0];
	ld	l, c
	ld	h, b
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
;src/world.c:267: action->a=town_exits[world_map_id-4u][1];action->b=town_exits[world_map_id-4u][2];
	ld	hl, #0x0002
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl), a
	ld	hl, #0x0003
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl), a
;src/world.c:263: action->metatile=meta;action->flags=flags;
	ld	hl, #0x0004
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#19
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#18
	ld	(hl), a
	ld	hl, #0x0005
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl), a
;src/world.c:256: for(sample=0;sample<samples;++sample) {
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#6
	sub	a, (hl)
	jp	NC, 00123$
;src/world.c:258: sx=(x-8u-((sample==1u||sample==2u)?16u:0u))&2047u;
	ldhl	sp,	#36
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0008
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ldhl	sp,	#28
	ld	(hl-), a
	ld	a, e
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	dec	a
	jr	Z, 00145$
	ldhl	sp,	#29
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00142$
00145$:
	ld	bc, #0x0010
	jr	00143$
00142$:
	ld	bc, #0x0000
00143$:
	ldhl	sp,#27
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	c, e
	and	a, #0x07
	ld	b, a
	ldhl	sp,	#21
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/world.c:259: sy=wrap_y((int16_t)y-16-((sample>=2u)?16:0));
	ldhl	sp,	#38
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0010
	ld	a, c
	sub	a, e
	ld	e, a
	ld	a, b
	sbc	a, d
	ldhl	sp,	#24
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#29
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00147$
	ldhl	sp,	#25
	ld	a, #0x10
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	jr	00148$
00147$:
	xor	a, a
	ldhl	sp,	#25
	ld	(hl+), a
	ld	(hl), a
00148$:
	ldhl	sp,#23
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#28
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_wrap_y
;src/world.c:260: meta=world_meta_at(sx,sy);flags=collisions[meta];
	push	bc
	push	bc
	ldhl	sp,	#25
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_world_meta_at
	ld	hl, #_world_meta_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#29
	ld	(hl), a
	pop	bc
	ld	de, #_collisions
	ldhl	sp,	#27
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#28
	ld	(hl), a
;src/world.c:261: if(flags&8u) {mx=sx>>4;my=sy>>4;break;}
	push	hl
	bit	3, (hl)
	pop	hl
	jr	Z, 00102$
	ldhl	sp,#21
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ldhl	sp,	#7
	ld	a, e
	ld	(hl+), a
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	ld	(hl), c
	jp	00123$
00102$:
;src/world.c:262: if(sample==0u && (flags&4u)) {
	ldhl	sp,	#29
	ld	a, (hl)
	or	a, a
	jp	NZ, 00134$
	push	hl
	dec	hl
	bit	2, (hl)
	pop	hl
	jp	Z, 00134$
;src/world.c:263: action->metatile=meta;action->flags=flags;
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#27
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#28
;src/world.c:264: if(meta==0xadu && world_map_id>=4u) {
	ld	a, (hl-)
	ld	(de), a
	ld	a, (hl)
	sub	a, #0xad
	jr	NZ, 00117$
	ld	a, (#_world_map_id)
	sub	a, #0x04
	jr	C, 00117$
;src/world.c:265: action->mode=WORLD_ACTION_MAP;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x08
;src/world.c:266: action->target=town_exits[world_map_id-4u][0];
	ld	bc, #_town_exits+0
	ld	a, (#_world_map_id)
	add	a, #0xfc
	ld	e, a
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/world.c:267: action->a=town_exits[world_map_id-4u][1];action->b=town_exits[world_map_id-4u][2];
	ld	a, (#_world_map_id)
	add	a, #0xfc
	ld	e, a
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, bc
	inc	hl
	ld	a, (hl)
	ldhl	sp,	#13
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, (#_world_map_id)
	add	a, #0xfc
	ld	e, a
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, bc
	inc	hl
	inc	hl
	ld	a, (hl)
	ldhl	sp,	#15
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jr	00118$
00117$:
;src/world.c:268: } else if((meta==0x4cu && world_map_id==5u) ||
	ldhl	sp,	#27
	ld	a, (hl)
	sub	a, #0x4c
	jr	NZ, 00107$
	ld	a, (#_world_map_id)
	sub	a, #0x05
	jr	Z, 00103$
00107$:
;src/world.c:269: (meta==0x5eu && !vehicle) ||
	ldhl	sp,	#27
	ld	a, (hl)
	sub	a, #0x5e
	jr	NZ, 00110$
	ldhl	sp,	#40
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
00110$:
;src/world.c:270: (meta>=0x5fu && meta<0x64u && vehicle!=8u) ||
	ldhl	sp,	#27
	ld	a,(hl)
	cp	a,#0x5f
	jr	C, 00113$
	sub	a, #0x64
	jr	NC, 00113$
	ldhl	sp,	#40
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00103$
00113$:
;src/world.c:271: (meta>=0xc3u && meta<0xc7u && !vehicle) ||
	ldhl	sp,	#27
	ld	a, (hl)
	sub	a, #0xc7
	ld	a, #0x00
	rla
	ld	c, a
	ld	a, (hl)
	sub	a, #0xc3
	jr	C, 00115$
	ld	a, c
	or	a, a
	jr	Z, 00115$
	ldhl	sp,	#40
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
00115$:
;src/world.c:272: (meta>=0xc7u && meta<0xd2u)) {
	bit	0, c
	jr	NZ, 00118$
	ldhl	sp,	#27
	ld	a, (hl)
	sub	a, #0xd2
	jr	NC, 00118$
00103$:
;src/world.c:273: action->mode=WORLD_ACTION_SPECIAL;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x80
;src/world.c:274: action->target=flags>>4;action->a=meta;action->b=vehicle;
	ldhl	sp,	#28
	ld	a, (hl)
	swap	a
	and	a, #0x0f
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#27
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#40
	ld	a, (hl)
	ld	(de), a
00118$:
;src/world.c:276: return action->mode;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jp	00138$
00134$:
;src/world.c:256: for(sample=0;sample<samples;++sample) {
	ldhl	sp,	#29
	inc	(hl)
	jp	00133$
00123$:
;src/world.c:279: if(!(flags&8u)) return 0;
	push	hl
	ldhl	sp,	#30
	bit	3, (hl)
	pop	hl
	jr	NZ, 00171$
	xor	a, a
	jp	00138$
;src/world.c:280: for(i=0;i<scene->exit_count;++i) {
00171$:
	ldhl	sp,	#29
	ld	(hl), #0x00
00136$:
	ld	a, (_scene)
	ld	c, a
	ld	hl, #_scene + 1
	ld	b, (hl)
	ld	hl, #0x0010
	add	hl, bc
	ld	e, (hl)
	ldhl	sp,	#29
	ld	a, (hl)
	sub	a, e
	jp	NC, 00131$
;src/world.c:281: bank_copy(&entry,scene->asset_bank,scene->exits+i,sizeof(entry));
	ld	hl, #0x000e
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#23
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#29
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#27
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#26
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#23
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	inc	bc
	ld	a, (bc)
	ld	c, a
	ld	hl, #0x0006
	push	hl
	push	de
	ld	a, c
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/world.c:284: if((mx==entry.x || (uint16_t)mx==(uint16_t)entry.x+1u) &&
	ldhl	sp,	#0
	ld	c, (hl)
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, c
	jr	Z, 00130$
	xor	a, a
	ld	b, a
	inc	bc
	ldhl	sp,	#7
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	sub	a, c
	jr	NZ, 00137$
	ld	a, d
	sub	a, b
	jr	NZ, 00137$
00130$:
;src/world.c:285: (my==entry.y || my==(entry.y+1u)%96u)) {
	ldhl	sp,	#1
	ld	c, (hl)
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, c
	jr	Z, 00126$
	xor	a, a
	ld	e, c
	ld	d, a
	inc	de
	ld	bc, #0x0060
	call	__moduint
	ldhl	sp,	#8
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	sub	a, c
	jr	NZ, 00137$
	ld	a, d
	sub	a, b
	jr	NZ, 00137$
00126$:
;src/world.c:286: action->mode=entry.mode;action->target=entry.target;
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#9
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/world.c:287: action->a=entry.a;action->b=entry.b;action->metatile=meta;action->flags=flags;
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#13
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#29
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#29
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#27
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#28
	ld	a, (hl)
	ld	(de), a
;src/world.c:288: return action->mode;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jr	00138$
00137$:
;src/world.c:280: for(i=0;i<scene->exit_count;++i) {
	ldhl	sp,	#29
	inc	(hl)
	jp	00136$
00131$:
;src/world.c:291: return 0;
	xor	a, a
00138$:
;src/world.c:292: }
	add	sp, #30
	ret
	.area _CODE_6
	.area _INITIALIZER
__xinit__ice_origin_x:
	.db #0xff	; 255
	.area _CABS (ABS)
