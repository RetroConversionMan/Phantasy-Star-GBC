;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module scene_actor
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_copy
	.globl _set_sprite_palette
	.globl _set_sprite_data
	.globl _scene_actor_active
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_scene_actor_show_data
	.globl _scene_actor_show_data
	.globl b_scene_portrait_show
	.globl _scene_portrait_show
	.globl b_scene_enemy_show
	.globl _scene_enemy_show
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_scene_actor_active::
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
	.area _CODE_13
;src/scene_actor.c:11: static void clear_actors(void) {
;	---------------------------------
; Function clear_actors
; ---------------------------------
_clear_actors:
;src/scene_actor.c:12: uint8_t i;HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/scene_actor.c:13: for(i=0;i<40u;++i)move_sprite(i,0,0);
	ld	c, #0x00
00103$:
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM+0
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, de
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/scene_actor.c:13: for(i=0;i<40u;++i)move_sprite(i,0,0);
	inc	c
	ld	a, c
	sub	a, #0x28
	jr	C, 00103$
;src/scene_actor.c:14: scene_actor_active=0;
	xor	a, a
	ld	(#_scene_actor_active),a
;src/scene_actor.c:15: }
	ret
;src/scene_actor.c:16: void scene_actor_hide(void) __banked {
;	---------------------------------
; Function scene_actor_hide
; ---------------------------------
	b_scene_actor_hide	= 13
_scene_actor_hide::
;src/scene_actor.c:17: clear_actors();
	call	_clear_actors
;src/scene_actor.c:18: bank_copy(scene_shared_colors,3u,alis_palettes,64u);
	ld	de, #0x0040
	push	de
	ld	de, #_alis_palettes
	push	de
	ld	a, #0x03
	ld	de, #_scene_shared_colors
	call	_bank_copy
;src/scene_actor.c:19: set_sprite_palette(0,8,scene_shared_colors);
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/scene_actor.c:20: }
	ret
;src/scene_actor.c:21: static uint8_t actor_show(uint8_t kind,uint8_t identity,uint8_t palette) __banked {
;	---------------------------------
; Function actor_show
; ---------------------------------
	b_actor_show	= 13
_actor_show:
	add	sp, #-4
;src/scene_actor.c:22: uint8_t i,found=0;
	ld	e, #0x00
;src/scene_actor.c:24: for(i=0;i<SCENE_ACTOR_COUNT;++i) {
	ldhl	sp,	#3
	ld	(hl), #0x00
00109$:
;src/scene_actor.c:25: asset=scene_actors+i;
	ldhl	sp,	#3
	ld	c, (hl)
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_scene_actors
	add	hl, bc
	ld	c, l
	ld	b, h
;src/scene_actor.c:26: if(asset->kind==kind && asset->id==identity &&
	ld	a, (bc)
	ld	d, a
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, d
	jr	NZ, 00110$
	ld	l, c
	ld	h, b
	inc	hl
	ld	d, (hl)
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, d
	jr	NZ, 00110$
;src/scene_actor.c:27: (asset->palette==255u || asset->palette==palette)){found=1;break;}
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	d, (hl)
	ld	a, d
	inc	a
	jr	Z, 00101$
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, d
	jr	NZ, 00110$
00101$:
	ld	e, #0x01
	jr	00106$
00110$:
;src/scene_actor.c:24: for(i=0;i<SCENE_ACTOR_COUNT;++i) {
	ldhl	sp,	#3
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x71
	jr	C, 00109$
00106$:
;src/scene_actor.c:29: if(!found)return 0;
	ld	a, e
	or	a,a
	jr	Z, 00111$
;src/scene_actor.c:30: return scene_actor_show_data(asset->bank,asset->data,asset->tiles,asset->sprites);
	ld	hl, #0x0005
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ld	hl, #0x0004
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ld	hl, #0x0006
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#0
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#2
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#4
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
00111$:
;src/scene_actor.c:31: }
	add	sp, #4
	ret
;src/scene_actor.c:32: uint8_t scene_actor_show_data(uint8_t bank,const uint8_t *data,uint8_t tiles,uint8_t sprites) __banked {
;	---------------------------------
; Function scene_actor_show_data
; ---------------------------------
	b_scene_actor_show_data	= 13
_scene_actor_show_data::
	add	sp, #-7
;src/scene_actor.c:34: if(!data || !tiles || tiles>172u || !sprites || sprites>40u)return 0;
	ldhl	sp,	#15
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00101$
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0xac
	sub	a, (hl)
	jr	C, 00101$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x28
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jp	00118$
00102$:
;src/scene_actor.c:35: clear_actors();
	call	_clear_actors
;src/scene_actor.c:36: for(i=0;i<tiles;++i) {
	ld	c, #0x00
00113$:
	ld	a, c
	ldhl	sp,	#16
	sub	a, (hl)
	jr	NC, 00107$
;src/scene_actor.c:37: bank_copy(scene_shared_bytes,bank,data+(uint16_t)i*16u,16u);
	dec	hl
	ld	e, c
	ld	d, #0x00
	sla	e
	rl	d
	sla	e
	rl	d
	sla	e
	rl	d
	sla	e
	rl	d
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #0x0010
	push	hl
	push	de
	ldhl	sp,	#19
	ld	a, (hl)
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	pop	bc
;src/scene_actor.c:38: VBK_REG=1;set_sprite_data(84u+i,1,scene_shared_bytes);
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_bytes
	ld	a, c
	add	a, #0x54
	push	de
	ld	h, #0x01
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
;src/scene_actor.c:36: for(i=0;i<tiles;++i) {
	inc	c
	jr	00113$
00107$:
;src/scene_actor.c:40: VBK_REG=0;offset=(uint16_t)tiles*16u;
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ldhl	sp,	#16
	ld	c, (hl)
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
;src/scene_actor.c:41: for(i=0;i<sprites;++i) {
	ldhl	sp,	#14
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#6
	ld	(hl), #0x00
00116$:
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#17
	sub	a, (hl)
	jp	NC, 00108$
;src/scene_actor.c:42: bank_copy(scene_shared_bytes,bank,data+offset+(uint16_t)i*4u,4u);
	ldhl	sp,	#6
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
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #0x0004
	push	hl
	push	de
	ldhl	sp,	#19
	ld	a, (hl)
	ld	de, #_scene_shared_bytes
	call	_bank_copy
	pop	bc
;src/scene_actor.c:43: set_sprite_tile(i,84u+scene_shared_bytes[2]);set_sprite_prop(i,scene_shared_bytes[3]);
	ld	a, (#(_scene_shared_bytes + 2) + 0)
	add	a, #0x54
	ldhl	sp,	#5
;../../../.tools/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	(hl+), a
	ld	e, (hl)
	xor	a, a
	sla	e
	adc	a, a
	sla	e
	adc	a, a
	ldhl	sp,	#2
	ld	(hl), e
	inc	hl
	ld	(hl), a
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(de), a
;src/scene_actor.c:43: set_sprite_tile(i,84u+scene_shared_bytes[2]);set_sprite_prop(i,scene_shared_bytes[3]);
	ld	a, (#(_scene_shared_bytes + 3) + 0)
	ldhl	sp,	#5
	ld	(hl), a
;../../../.tools/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	de, #_shadow_OAM
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(de), a
;src/scene_actor.c:44: move_sprite(i,scene_shared_bytes[0],scene_shared_bytes[1]);
	ld	a, (#(_scene_shared_bytes + 1) + 0)
	ldhl	sp,	#4
	ld	(hl), a
	ld	a, (#_scene_shared_bytes + 0)
	ldhl	sp,	#5
	ld	(hl), a
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	(de), a
	inc	de
;src/scene_actor.c:41: for(i=0;i<sprites;++i) {
	ld	a, (hl+)
	ld	(de), a
	inc	(hl)
	jp	00116$
00108$:
;src/scene_actor.c:46: offset+=(uint16_t)sprites*4u;
	ldhl	sp,	#17
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
;src/scene_actor.c:47: bank_copy(scene_shared_colors,bank,data+offset,64u);
	ldhl	sp,	#14
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	de, #0x0040
	push	de
	push	bc
	ldhl	sp,	#17
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
;src/scene_actor.c:48: set_sprite_palette(0,8,scene_shared_colors);SPRITES_8x8;
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;src/scene_actor.c:49: scene_actor_active=1;SHOW_SPRITES;return 1;
	ld	hl, #_scene_actor_active
	ld	(hl), #0x01
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
	ld	a, #0x01
00118$:
;src/scene_actor.c:50: }
	add	sp, #7
	ret
;src/scene_actor.c:52: uint8_t scene_portrait_show(uint8_t portrait) __banked {return actor_show(0,portrait,255u);}
;	---------------------------------
; Function scene_portrait_show
; ---------------------------------
	b_scene_portrait_show	= 13
_scene_portrait_show::
	ld	a, #0xff
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	ld	e, #b_actor_show
	ld	hl, #_actor_show
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
;src/scene_actor.c:53: uint8_t scene_enemy_show(uint8_t enemy,uint8_t palette_index) __banked {
;	---------------------------------
; Function scene_enemy_show
; ---------------------------------
	b_scene_enemy_show	= 13
_scene_enemy_show::
;src/scene_actor.c:54: if(palette_index>11u)return 0;
	ld	a, #0x0b
	ldhl	sp,	#7
	sub	a, (hl)
	jr	NC, 00102$
	xor	a, a
	ret
00102$:
;src/scene_actor.c:55: return actor_show(1,enemy,palette_index);
	ldhl	sp,	#7
	ld	a, (hl-)
	push	af
	inc	sp
	ld	h, (hl)
	ld	l, #0x01
	push	hl
	ld	e, #b_actor_show
	ld	hl, #_actor_show
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/scene_actor.c:56: }
	ret
	.area _CODE_13
	.area _INITIALIZER
	.area _CABS (ABS)
