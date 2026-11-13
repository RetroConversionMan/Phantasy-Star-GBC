;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module myau_flight
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_copy
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_scene_show
	.globl _scene_show
	.globl _set_sprite_palette
	.globl _set_sprite_data
	.globl _myau_flight_frame
	.globl b_myau_flight_begin
	.globl _myau_flight_begin
	.globl b_myau_flight_tick
	.globl _myau_flight_tick
	.globl b_myau_battle_palette
	.globl _myau_battle_palette
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_myau_flight_frame::
	.ds 2
_returning:
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
;src/myau_flight.c:12: static void draw_flight(uint8_t pose,uint8_t x,uint8_t y) __banked {
;	---------------------------------
; Function draw_flight
; ---------------------------------
	b_draw_flight	= 132
_draw_flight:
	add	sp, #-7
;src/myau_flight.c:13: const MyauFlightFrame *f=myau_flight_frames+pose;uint8_t i;
	ldhl	sp,	#13
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #_myau_flight_frames
	add	hl, bc
	ld	c, l
	ld	a, h
	ldhl	sp,	#2
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/myau_flight.c:14: x=(uint8_t)(((uint16_t)x*5u)>>3);y=(uint8_t)(((uint16_t)y*5u)>>3);
	ldhl	sp,	#14
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	ldhl	sp,	#14
	ld	a, c
	ld	(hl+), a
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	ldhl	sp,	#15
	ld	(hl), c
;src/myau_flight.c:15: for(i=0;i<f->sprites;++i){
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl+), a
	ld	(hl), #0x00
00108$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl)
	sub	a, c
	jr	NC, 00118$
;src/myau_flight.c:16: bank_copy(scene_shared_bytes,131,myau_flight_data+f->offset+(uint16_t)i*4u,4u);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #_myau_flight_data
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	de, #0x0004
	push	de
	push	hl
	ld	a, #0x83
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/myau_flight.c:17: set_sprite_tile(i,84u+scene_shared_bytes[2]);set_sprite_prop(i,scene_shared_bytes[3]);
	ld	a, (#(_scene_shared_bytes + 2) + 0)
	add	a, #0x54
	ld	e, a
;../../../.tools/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#6
	ld	c, (hl)
	xor	a, a
	ld	b, a
	sla	c
	rl	b
	sla	c
	rl	b
	ld	hl,#_shadow_OAM + 1
	add	hl,bc
	inc	hl
	ld	(hl), e
;src/myau_flight.c:17: set_sprite_tile(i,84u+scene_shared_bytes[2]);set_sprite_prop(i,scene_shared_bytes[3]);
	ld	a, (#(_scene_shared_bytes + 3) + 0)
	ldhl	sp,	#1
	ld	(hl), a
;../../../.tools/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	hl,#_shadow_OAM + 1
	add	hl,bc
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ldhl	sp,	#1
	ld	a, (hl)
	ld	(de), a
;src/myau_flight.c:18: move_sprite(i,x+scene_shared_bytes[0],y+scene_shared_bytes[1]);
	ld	a, (#(_scene_shared_bytes + 1) + 0)
	ldhl	sp,	#15
	add	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ld	a, (#_scene_shared_bytes + 0)
	ldhl	sp,	#14
	add	a, (hl)
	ld	e, a
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
	add	hl, bc
	ld	c, l
	ld	b, h
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#1
	ld	a, (hl)
	ld	(bc), a
	inc	bc
	ld	a, e
	ld	(bc), a
;src/myau_flight.c:15: for(i=0;i<f->sprites;++i){
	ldhl	sp,	#6
	inc	(hl)
	jp	00108$
00118$:
00111$:
;src/myau_flight.c:20: for(;i<40u;++i)move_sprite(i,0,0);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x28
	jr	NC, 00102$
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ld	c, #0x00
	add	a, a
	rl	c
	add	a, a
	rl	c
	ld	l, a
	ld	h, c
	ld	de, #_shadow_OAM
	add	hl, de
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/myau_flight.c:20: for(;i<40u;++i)move_sprite(i,0,0);
	ldhl	sp,	#6
	inc	(hl)
	jr	00111$
00102$:
;src/myau_flight.c:21: bank_copy(scene_shared_colors,131,myau_flight_data+f->offset+(uint16_t)f->sprites*4u,64u);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	de, #_myau_flight_data
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl)
	ld	d, #0x00
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	pop	hl
	push	hl
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x0040
	push	de
	push	bc
	ld	a, #0x83
	ld	de, #_scene_shared_colors
	call	_bank_copy
;src/myau_flight.c:22: set_sprite_palette(0,8,scene_shared_colors);scene_actor_active=1;SHOW_SPRITES;
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
	ld	hl, #_scene_actor_active
	ld	(hl), #0x01
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;src/myau_flight.c:23: }
	add	sp, #7
	ret
;src/myau_flight.c:24: uint8_t myau_flight_begin(uint8_t return_trip) __banked {
;	---------------------------------
; Function myau_flight_begin
; ---------------------------------
	b_myau_flight_begin	= 132
_myau_flight_begin::
;src/myau_flight.c:25: uint8_t i;if(!scene_show(15,0,0))return 0;
	xor	a, a
	rrca
	push	af
	xor	a, a
	ld	a, #0x0f
	push	af
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a,a
	ret	Z
;src/myau_flight.c:26: scene_actor_hide();HIDE_WIN;returning=!!return_trip;myau_flight_frame=0;
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	(#_returning),a
	xor	a, a
	ld	hl, #_myau_flight_frame
	ld	(hl+), a
	ld	(hl), a
;src/myau_flight.c:27: for(i=0;i<MYAU_FLIGHT_TILES;++i){bank_copy(scene_shared_bytes,131,myau_flight_data+(uint16_t)i*16u,16u);VBK_REG=1;set_sprite_data(84u+i,1,scene_shared_bytes);}
	ld	c, #0x00
00104$:
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_myau_flight_data
	add	hl, de
	push	bc
	ld	de, #0x0010
	push	de
	push	hl
	ld	a, #0x83
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	pop	bc
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	a, c
	add	a, #0x54
	ld	de, #_scene_shared_bytes
	push	de
	ld	h, #0x01
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
	inc	c
	ld	a, c
	sub	a, #0x16
	jr	C, 00104$
;src/myau_flight.c:28: VBK_REG=0;SPRITES_8x8;return 1;
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
	ld	a, #0x01
;src/myau_flight.c:29: }
	ret
;src/myau_flight.c:30: uint8_t myau_flight_tick(void) __banked {
;	---------------------------------
; Function myau_flight_tick
; ---------------------------------
	b_myau_flight_tick	= 132
_myau_flight_tick::
;src/myau_flight.c:31: uint8_t updates,pose,x,y;uint16_t last=returning?571u:507u;
	ld	a, (#_returning)
	or	a, a
	jr	Z, 00114$
	ld	bc, #0x023b
	jr	00115$
00114$:
	ld	bc, #0x01fb
00115$:
;src/myau_flight.c:32: if(myau_flight_frame>=last)return 1;
	ld	hl, #_myau_flight_frame
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	jr	C, 00102$
	ld	a, #0x01
	ret
00102$:
;src/myau_flight.c:33: ++myau_flight_frame;
	ld	hl, #_myau_flight_frame
	inc	(hl)
	jr	NZ, 00194$
	inc	hl
	inc	(hl)
00194$:
;src/myau_flight.c:34: if(myau_flight_frame==last)return 1;
	ld	hl, #_myau_flight_frame
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00104$
	inc	hl
	ld	a, (hl)
	sub	a, b
	jr	NZ, 00104$
	ld	a, #0x01
	ret
00104$:
;src/myau_flight.c:35: if(myau_flight_frame==1u){draw_flight(returning?4u:0u,returning?80u:208u,returning?48u:136u);return 0;}
	ld	a, (_myau_flight_frame)
	ld	c, a
	ld	hl, #_myau_flight_frame + 1
	ld	b, (hl)
	ld	a, c
	dec	a
	or	a, b
	jr	NZ, 00106$
	ld	a, (#_returning)
	or	a, a
	jr	Z, 00116$
	ld	d, #0x30
	jr	00117$
00116$:
	ld	d, #0x88
00117$:
	ld	a, (#_returning)
	or	a, a
	jr	Z, 00118$
	ld	b, #0x50
	jr	00119$
00118$:
	ld	b, #0xd0
00119$:
	ld	a, (#_returning)
	or	a, a
	ld	a, #0x04
	jr	NZ, 00121$
	xor	a, a
00121$:
	ld	e, b
	push	de
	push	af
	inc	sp
	ld	e, #b_draw_flight
	ld	hl, #_draw_flight
	call	___sdcc_bcall_ehl
	add	sp, #3
	xor	a, a
	ret
00106$:
;src/myau_flight.c:36: if((myau_flight_frame-2u)&7u)return 0;
	dec	bc
	dec	bc
	ld	a, c
	and	a, #0x07
	jr	Z, 00108$
	xor	a, a
	ret
00108$:
;src/myau_flight.c:37: updates=(uint8_t)((myau_flight_frame-2u)>>3)+1u;pose=(updates-1u)&3u;
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	inc	c
	ld	a, c
	dec	a
	and	a, #0x03
	ld	b, a
;src/myau_flight.c:38: if(returning){pose+=4u;y=48u+updates;x=80u-(updates==72u?8u:updates>>3);}
	ld	a, (#_returning)
	or	a, a
	jr	Z, 00110$
	inc	b
	inc	b
	inc	b
	inc	b
	ld	a, c
	add	a, #0x30
	ld	d, a
	ld	a, c
	sub	a, #0x48
	jr	NZ, 00122$
	ld	c, #0x08
	jr	00123$
00122$:
	srl	c
	srl	c
	srl	c
00123$:
	ld	a, #0x50
	sub	a, c
	ld	h, a
	jr	00111$
00110$:
;src/myau_flight.c:39: else{x=208u-updates;y=136u-updates;}
	ld	a, #0xd0
	sub	a, c
	ld	h, a
	ld	a, #0x88
	sub	a, c
	ld	d, a
00111$:
;src/myau_flight.c:40: draw_flight(pose,x,y);return 0;
	ld	e, h
	push	de
	push	bc
	inc	sp
	ld	e, #b_draw_flight
	ld	hl, #_draw_flight
	call	___sdcc_bcall_ehl
	add	sp, #3
	xor	a, a
;src/myau_flight.c:41: }
	ret
;src/myau_flight.c:43: void myau_battle_palette(uint8_t restore) __banked {
;	---------------------------------
; Function myau_battle_palette
; ---------------------------------
	b_myau_battle_palette	= 132
_myau_battle_palette::
;src/myau_flight.c:45: if(restore)bank_copy(scene_shared_colors,131,myau_flight_data+MYAU_BATTLE_PALETTE_OFFSET,64u);
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00110$
	ld	de, #0x0040
	push	de
	ld	de, #(_myau_flight_data + 992)
	push	de
	ld	a, #0x83
	ld	de, #_scene_shared_colors
	call	_bank_copy
	jr	00104$
;src/myau_flight.c:46: else for(i=0;i<32u;++i)scene_shared_colors[i]=0x7c00u;
00110$:
	ld	bc, #_scene_shared_colors+0
	ld	e, #0x00
00105$:
	ld	l, e
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, bc
	xor	a, a
	ld	(hl+), a
	ld	(hl), #0x7c
	inc	e
	ld	a, e
	sub	a, #0x20
	jr	C, 00105$
00104$:
;src/myau_flight.c:47: set_sprite_palette(0,8,scene_shared_colors);
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/myau_flight.c:48: }
	ret
	.area _CODE_132
	.area _INITIALIZER
	.area _CABS (ABS)
