;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module battle_scene
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_gold_scene_prepare
	.globl _gold_scene_prepare
	.globl b_gold_scene_show
	.globl _gold_scene_show
	.globl b_boss_motion_asset
	.globl _boss_motion_asset
	.globl b_enemy_magic_asset
	.globl _enemy_magic_asset
	.globl b_enemy_magic_pose
	.globl _enemy_magic_pose
	.globl b_battle_weapon_asset
	.globl _battle_weapon_asset
	.globl b_battle_motion_asset
	.globl _battle_motion_asset
	.globl _bank_bkg_data
	.globl _bank_copy
	.globl _bank_read8
	.globl b_game_transition_vint16
	.globl _game_transition_vint16
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_scene_palette_prepare
	.globl _scene_palette_prepare
	.globl b_scene_palette_capture
	.globl _scene_palette_capture
	.globl b_scene_palette_commit
	.globl _scene_palette_commit
	.globl b_scene_show_room
	.globl _scene_show_room
	.globl b_scene_show
	.globl _scene_show
	.globl _set_sprite_palette
	.globl _set_sprite_data
	.globl _set_bkg_tiles
	.globl _battle_scene_enemy
	.globl _battle_scene_palette
	.globl _battle_scene_type
	.globl b_battle_scene_world_type
	.globl _battle_scene_world_type
	.globl b_battle_scene_configure
	.globl _battle_scene_configure
	.globl b_battle_scene_hide
	.globl _battle_scene_hide
	.globl b_battle_scene_clear
	.globl _battle_scene_clear
	.globl b_battle_scene_clip
	.globl _battle_scene_clip
	.globl b_battle_scene_begin
	.globl _battle_scene_begin
	.globl b_battle_scene_animation_frame
	.globl _battle_scene_animation_frame
	.globl b_battle_scene_flash_enemy
	.globl _battle_scene_flash_enemy
	.globl b_battle_scene_flash_party
	.globl _battle_scene_flash_party
	.globl b_battle_scene_weapon_frame
	.globl _battle_scene_weapon_frame
	.globl b_battle_scene_magic_frame
	.globl _battle_scene_magic_frame
	.globl b_battle_scene_weapon_clear
	.globl _battle_scene_weapon_clear
	.globl b_battle_scene_boss_frame
	.globl _battle_scene_boss_frame
	.globl b_battle_scene_boss_patch
	.globl _battle_scene_boss_patch
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_battle_scene_type::
	.ds 1
_battle_scene_palette::
	.ds 1
_battle_scene_enemy::
	.ds 1
_current_clip:
	.ds 1
_current_animated:
	.ds 1
_current_asset:
	.ds 2
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
;src/battle_scene.c:24: uint8_t battle_scene_world_type(uint8_t group,uint8_t flags) __banked {
;	---------------------------------
; Function battle_scene_world_type
; ---------------------------------
	b_battle_scene_world_type	= 31
_battle_scene_world_type::
;src/battle_scene.c:25: uint8_t type=flags>>4;
	ldhl	sp,	#7
;src/battle_scene.c:26: if(!group && type==5u)type=4u;
	ld	a, (hl-)
	ld	c, a
	srl	c
	srl	c
	srl	c
	srl	c
	ld	a, (hl)
	or	a, a
	jr	NZ, 00113$
	ld	a, c
	sub	a, #0x05
	jr	NZ, 00113$
	ld	c, #0x04
	jr	00114$
00113$:
;src/battle_scene.c:27: else if((group==1u||group==7u)&&type==1u)type=5u;
	ldhl	sp,	#6
	ld	a, (hl)
	dec	a
	jr	Z, 00111$
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00108$
00111$:
	ld	a, c
	dec	a
	jr	NZ, 00108$
	ld	c, #0x05
	jr	00114$
00108$:
;src/battle_scene.c:28: else if(group==8u)type=6u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00105$
	ld	c, #0x06
	jr	00114$
00105$:
;src/battle_scene.c:29: else if(group==10u&&type==9u)type=8u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x0a
	jr	NZ, 00114$
	ld	a, c
	sub	a, #0x09
	jr	NZ, 00114$
	ld	c, #0x08
00114$:
;src/battle_scene.c:30: return type?type:1u;
	ld	a, c
	or	a, a
	jr	Z, 00118$
	ld	a, c
	ret
00118$:
	ld	a, #0x01
;src/battle_scene.c:31: }
	ret
;src/battle_scene.c:32: void battle_scene_configure(uint8_t type,uint8_t palette) __banked {
;	---------------------------------
; Function battle_scene_configure
; ---------------------------------
	b_battle_scene_configure	= 31
_battle_scene_configure::
;src/battle_scene.c:33: battle_scene_type=type;battle_scene_palette=palette<12u?palette:0u;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_battle_scene_type),a
	ldhl	sp,	#7
	ld	a,(hl)
	cp	a,#0x0c
	jr	C, 00104$
	xor	a, a
00104$:
	ld	(#_battle_scene_palette),a
;src/battle_scene.c:34: }
	ret
;src/battle_scene.c:35: void battle_scene_hide(void) __banked {
;	---------------------------------
; Function battle_scene_hide
; ---------------------------------
	b_battle_scene_hide	= 31
_battle_scene_hide::
;src/battle_scene.c:36: scene_actor_hide();SPRITES_8x8;battle_scene_enemy=0;current_asset=65535u;current_clip=255u;current_animated=0;
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
	xor	a, a
	ld	(#_battle_scene_enemy),a
	ld	hl, #_current_asset
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0xff
	ld	hl, #_current_clip
	ld	(hl), #0xff
	xor	a, a
	ld	(#_current_animated),a
;src/battle_scene.c:37: }
	ret
;src/battle_scene.c:38: static uint8_t background(uint8_t enemy) {
;	---------------------------------
; Function background
; ---------------------------------
_background:
	ld	b, a
;src/battle_scene.c:39: if(!battle_scene_type)return !enemy;
	ld	a, (#_battle_scene_type)
	or	a, a
	jr	NZ, 00102$
	ld	a, b
	sub	a, #0x01
	ld	a, #0x00
	rla
	ret
00102$:
;src/battle_scene.c:40: if(battle_scene_type>=64u && battle_scene_type<76u)return scene_show_room(battle_scene_type-64u,0,enemy);
	ld	hl, #_battle_scene_type
	ld	a,(hl)
	cp	a,#0x40
	jr	C, 00104$
	cp	a,#0x4c
	jr	NC, 00104$
	add	a, #0xc0
	push	bc
	inc	sp
	ld	h, #0x00
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_scene_show_room
	ld	hl, #_scene_show_room
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00104$:
;src/battle_scene.c:41: return scene_show(battle_scene_type,0,enemy);
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_scene_type)
	push	af
	inc	sp
	ld	e, #b_scene_show
	ld	hl, #_scene_show
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/battle_scene.c:42: }
	ret
;src/battle_scene.c:43: void battle_scene_clear(void) __banked {
;	---------------------------------
; Function battle_scene_clear
; ---------------------------------
	b_battle_scene_clear	= 31
_battle_scene_clear::
;src/battle_scene.c:44: uint8_t composed=battle_scene_enemy==72u||battle_scene_enemy==73u;
	ld	a, (#_battle_scene_enemy)
	sub	a, #0x48
	jr	Z, 00106$
	ld	a, (#_battle_scene_enemy)
	sub	a, #0x49
	ld	c, #0x00
	jr	NZ, 00107$
00106$:
	ld	c, #0x01
00107$:
;src/battle_scene.c:45: battle_scene_hide();if(composed)background(0);
	push	bc
	ld	e, #b_battle_scene_hide
	ld	hl, #_battle_scene_hide
	call	___sdcc_bcall_ehl
	pop	bc
	ld	a, c
	or	a, a
	ret	Z
	xor	a, a
;src/battle_scene.c:46: }
	jp	_background
;src/battle_scene.c:47: static void current_descriptor(BattleSceneAsset *asset) {
;	---------------------------------
; Function current_descriptor
; ---------------------------------
_current_descriptor:
;src/battle_scene.c:48: if(current_animated==3u)bank_copy(asset,BOSS_DATA_BANK,boss_assets+current_asset,sizeof *asset);
	ld	a, (_current_asset)
	ld	c, a
	ld	hl, #_current_asset + 1
	ld	b, (hl)
	sla	c
	rl	b
	sla	c
	rl	b
	ld	a, (#_current_animated)
	sub	a, #0x03
	jr	NZ, 00108$
	ld	hl, #_boss_assets
	add	hl, bc
	ld	bc, #0x0004
	push	bc
	push	hl
	ld	a, #0xfe
	call	_bank_copy
	ret
00108$:
;src/battle_scene.c:49: else if(current_animated==2u)bank_copy(asset,ENEMY_MAGIC_BANK,enemy_magic_assets+current_asset,sizeof *asset);
	ld	a, (#_current_animated)
	sub	a, #0x02
	jr	NZ, 00105$
	ld	hl, #_enemy_magic_assets
	add	hl, bc
	ld	bc, #0x0004
	push	bc
	push	hl
	ld	a, #0xfc
	call	_bank_copy
	ret
00105$:
;src/battle_scene.c:50: else if(current_animated)bank_copy(asset,BATTLE_ANIMATION_DESCRIPTOR_BANK,battle_animation_assets+current_asset,sizeof *asset);
	ld	a, (#_current_animated)
	or	a, a
	jr	Z, 00102$
	ld	hl, #_battle_animation_assets
	add	hl, bc
	ld	bc, #0x0004
	push	bc
	push	hl
	ld	a, #0x94
	call	_bank_copy
	ret
00102$:
;src/battle_scene.c:51: else *asset=battle_scene_assets[current_asset];
	ld	hl, #_battle_scene_assets
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	hl, #0x0004
	push	hl
	call	___memcpy
;src/battle_scene.c:52: }
	ret
;src/battle_scene.c:53: static void current_pool(uint16_t pair,BattleScenePool *pool) {
;	---------------------------------
; Function current_pool
; ---------------------------------
_current_pool:
	add	sp, #-8
	ldhl	sp,	#6
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle_scene.c:54: if(current_animated==3u)bank_copy(pool,BOSS_DATA_BANK,boss_pools+(pair>>8),sizeof *pool);
	ldhl	sp,	#4
	ld	a, d
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ld	a, (#_current_animated)
	sub	a, #0x03
	jr	NZ, 00105$
	ld	bc, #_boss_pools+0
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	de, #0x0003
	push	de
	push	bc
	ld	a, #0xfe
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_bank_copy
	jr	00107$
00105$:
;src/battle_scene.c:55: else if(current_animated==2u)bank_copy(pool,ENEMY_MAGIC_BANK,enemy_magic_pools+(pair>>8),sizeof *pool);
	ld	a, (#_current_animated)
	sub	a, #0x02
	jr	NZ, 00102$
	ld	bc, #_enemy_magic_pools+0
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	de, #0x0003
	push	de
	push	bc
	ld	a, #0xfc
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_bank_copy
	jr	00107$
00102$:
;src/battle_scene.c:56: else *pool=(current_animated?battle_animation_pools:battle_scene_pools)[pair>>8];
	ld	a, (#_current_animated)
	or	a, a
	jr	Z, 00109$
	ld	de, #_battle_animation_pools+0
	ldhl	sp,	#4
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	jr	00110$
00109$:
	ld	de, #_battle_scene_pools+0
	ldhl	sp,	#4
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
00110$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x0003
	push	de
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	___memcpy
00107$:
;src/battle_scene.c:57: }
	add	sp, #8
	ret
;src/battle_scene.c:58: void battle_scene_clip(uint8_t window_y) __banked {
;	---------------------------------
; Function battle_scene_clip
; ---------------------------------
	b_battle_scene_clip	= 31
_battle_scene_clip::
	add	sp, #-18
;src/battle_scene.c:61: if(!battle_scene_enemy)return;
	ld	a, (#_battle_scene_enemy)
	or	a, a
	jp	Z, 00130$
;src/battle_scene.c:62: if(current_asset==65535u){current_clip=window_y;return;}
	ld	a, (_current_asset)
	ld	c, a
	ld	hl, #_current_asset + 1
	ld	b, (hl)
	ld	a, c
	and	a, b
	inc	a
	jr	NZ, 00104$
	ldhl	sp,	#24
	ld	a, (hl)
	ld	(#_current_clip),a
	jp	00130$
00104$:
;src/battle_scene.c:63: if(!window_y){HIDE_SPRITES;current_clip=0;return;}
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	NZ, 00106$
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	xor	a, a
	ld	(#_current_clip),a
	jp	00130$
00106$:
;src/battle_scene.c:64: if(window_y==current_clip){SHOW_SPRITES;return;}
	ldhl	sp,	#24
	ld	a, (hl)
	ld	hl, #_current_clip
	sub	a, (hl)
	jr	NZ, 00108$
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
	jp	00130$
00108$:
;src/battle_scene.c:65: current_descriptor(&local);asset=&local;
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_current_descriptor
;src/battle_scene.c:66: for(i=0;i<asset->sprites;++i) {
	ldhl	sp,	#17
	ld	(hl), #0x00
00126$:
	ldhl	sp,	#1
	ld	c, (hl)
	ldhl	sp,	#17
	ld	a, (hl)
	sub	a, c
	jp	NC, 00143$
;src/battle_scene.c:67: bank_copy(scene_shared_bytes,asset->bank,asset->data+(uint16_t)i*5u,5u);
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#13
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#17
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
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
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
	ldhl	sp,	#0
	ld	a, (hl)
	ld	de, #0x0005
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/battle_scene.c:68: x=scene_shared_bytes[0];y=scene_shared_bytes[1];prop=scene_shared_bytes[4];
	ld	a, (#_scene_shared_bytes + 0)
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (#(_scene_shared_bytes + 1) + 0)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (#(_scene_shared_bytes + 4) + 0)
	ldhl	sp,	#9
	ld	(hl), a
;src/battle_scene.c:69: pair=scene_shared_bytes[2]|((uint16_t)scene_shared_bytes[3]<<8);
	ld	a, (#(_scene_shared_bytes + 2) + 0)
	ldhl	sp,	#16
	ld	(hl), a
	ld	a, (#(_scene_shared_bytes + 3) + 0)
	ldhl	sp,#15
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	(hl), #0x00
	ldhl	sp,	#16
	ld	a, (hl)
	ldhl	sp,	#13
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#16
	ld	(hl), a
;src/battle_scene.c:70: if(y-16u>=window_y){move_sprite(i,0,0);continue;}
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#14
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#13
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#11
	ld	e, l
	ld	d, h
	ldhl	sp,	#13
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	C, 00110$
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ldhl	sp,	#17
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00223$:
	ldhl	sp,	#13
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00223$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	xor	a, a
	ld	(bc), a
;src/battle_scene.c:70: if(y-16u>=window_y){move_sprite(i,0,0);continue;}
	jp	00114$
00110$:
;src/battle_scene.c:71: current_pool(pair,&pool);
	ld	hl, #4
	add	hl, sp
	ld	c, l
	ld	b, h
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_current_pool
;src/battle_scene.c:72: bank_copy(scene_shared_bytes,pool.bank,pool.data+((pair&255u)<<5),32u);
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x05
00224$:
	ldhl	sp,	#13
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00224$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#11
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#14
	ld	(hl+), a
	ld	de, #0x0020
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	push	de
	ld	a, (hl)
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/battle_scene.c:73: if(y>window_y)for(line=window_y-(y-16u);line<16u;++line){scene_shared_bytes[line*2u]=0;scene_shared_bytes[line*2u+1u]=0;}
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#8
	sub	a, (hl)
	jr	NC, 00113$
	ld	a, (hl)
	add	a, #0xf0
	ld	c, a
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, c
	ldhl	sp,	#16
	ld	(hl), a
00123$:
	ldhl	sp,	#16
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00113$
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_scene_shared_bytes
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
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#16
	ld	a, (hl-)
	add	a, a
	ld	(hl), a
	inc	(hl)
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #_scene_shared_bytes
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
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#16
	inc	(hl)
	jr	00123$
00113$:
;src/battle_scene.c:74: VBK_REG=1;set_sprite_data(84u+i*2u,2,scene_shared_bytes);VBK_REG=0;
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ldhl	sp,	#17
	ld	a, (hl)
	add	a, a
	add	a, #0x54
	ld	b, a
	ld	de, #_scene_shared_bytes
	push	de
	ld	a, #0x02
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
	xor	a, a
	ldh	(_VBK_REG + 0), a
;src/battle_scene.c:75: set_sprite_tile(i,84u+i*2u);set_sprite_prop(i,prop);move_sprite(i,x,y);
	ldhl	sp,	#10
	ld	(hl), b
;../../../.tools/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#17
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00226$:
	ldhl	sp,	#11
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00226$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#10
;../../../.tools/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	a, (hl+)
	ld	(de), a
	ld	de, #_shadow_OAM
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#9
	ld	a, (hl)
	ld	(de), a
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(bc), a
;src/battle_scene.c:75: set_sprite_tile(i,84u+i*2u);set_sprite_prop(i,prop);move_sprite(i,x,y);
00114$:
;src/battle_scene.c:66: for(i=0;i<asset->sprites;++i) {
	ldhl	sp,	#17
	inc	(hl)
	jp	00126$
00143$:
	ldhl	sp,	#17
	ld	c, (hl)
00128$:
;src/battle_scene.c:77: for(;i<40u;++i)move_sprite(i,0,0);
	ld	a, c
	sub	a, #0x28
	jr	NC, 00116$
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
;src/battle_scene.c:77: for(;i<40u;++i)move_sprite(i,0,0);
	inc	c
	jr	00128$
00116$:
;src/battle_scene.c:78: SPRITES_8x16;current_clip=window_y;SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x04
	ldh	(_LCDC_REG + 0), a
	ldhl	sp,	#24
	ld	a, (hl)
	ld	(#_current_clip),a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
00130$:
;src/battle_scene.c:79: }
	add	sp, #18
	ret
;src/battle_scene.c:80: uint8_t battle_scene_begin(uint8_t enemy) __banked {
;	---------------------------------
; Function battle_scene_begin
; ---------------------------------
	b_battle_scene_begin	= 31
_battle_scene_begin::
	dec	sp
	dec	sp
;src/battle_scene.c:82: if(!enemy||enemy>74u)return 0;
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x4a
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jp	00114$
00102$:
;src/battle_scene.c:83: battle_scene_hide();battle_scene_enemy=enemy;
	ld	e, #b_battle_scene_hide
	ld	hl, #_battle_scene_hide
	call	___sdcc_bcall_ehl
	ldhl	sp,	#8
	ld	e, (hl)
	ld	hl, #_battle_scene_enemy
;src/battle_scene.c:84: if(enemy==72u||enemy==73u){current_asset=65535u;current_clip=120u;return background(enemy);}
	ld	a,e
	ld	(hl),a
	sub	a, #0x48
	jr	Z, 00104$
	ld	a, e
	sub	a, #0x49
	jr	NZ, 00105$
00104$:
	ld	hl, #_current_asset
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0xff
	ld	hl, #_current_clip
	ld	(hl), #0x78
	ld	a, e
	inc	sp
	inc	sp
	jp	_background
	jp	00114$
00105$:
;src/battle_scene.c:85: if(enemy==70u&&battle_scene_type==14u)gold_scene_show(2u);
	ld	a, e
	sub	a, #0x46
	jr	NZ, 00111$
	ld	a, (#_battle_scene_type)
	sub	a, #0x0e
	jr	NZ, 00111$
	push	de
	ld	a, #0x02
	push	af
	inc	sp
	ld	e, #b_gold_scene_show
	ld	hl, #_gold_scene_show
	call	___sdcc_bcall_ehl
	inc	sp
	pop	de
	jr	00112$
00111$:
;src/battle_scene.c:86: else if(battle_scene_type&&!background(0)){battle_scene_enemy=0;return 0;}
	ld	a, (#_battle_scene_type)
	or	a, a
	jr	Z, 00112$
	push	de
	xor	a, a
	call	_background
	pop	de
	or	a,a
	jr	NZ, 00112$
	ld	(#_battle_scene_enemy), a
	jp	00114$
00112$:
;src/battle_scene.c:87: current_asset=battle_scene_lookup[enemy-1u][battle_scene_type==0u?battle_scene_palette:0u];
	ld	bc, #_battle_scene_lookup+0
	ld	l, e
	ld	h, #0x00
	dec	hl
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (#_battle_scene_type)
	or	a, a
	jr	NZ, 00116$
	ld	a, (_battle_scene_palette)
	ld	h, #0x00
	jr	00117$
00116$:
	xor	a, a
	ld	h, a
00117$:
	ld	l, a
	add	hl, hl
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	hl, #_current_asset
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;src/battle_scene.c:88: asset=battle_scene_assets+current_asset;
	ld	a, (_current_asset)
	ld	hl, #_current_asset + 1
	ld	c, (hl)
	add	a, a
	rl	c
	add	a, a
	rl	c
	add	a, #<(_battle_scene_assets)
	ld	e, a
	ld	a, c
	adc	a, #>(_battle_scene_assets)
	ld	d, a
	inc	sp
	inc	sp
;src/battle_scene.c:89: bank_copy(scene_shared_colors,asset->bank,asset->data+(uint16_t)asset->sprites*5u,64u);
	ld	l, e
	ld	h, d
	push	hl
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	hl
	push	hl
	inc	hl
	ld	l, (hl)
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#1
	ld	(hl), a
	ld	de, #0x0040
	push	de
	push	bc
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
;src/battle_scene.c:90: set_sprite_palette(0,8,scene_shared_colors);scene_actor_active=1;
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
	ld	hl, #_scene_actor_active
	ld	(hl), #0x01
;src/battle_scene.c:91: battle_scene_clip(120u);return 1;
	ld	a, #0x78
	push	af
	inc	sp
	ld	e, #b_battle_scene_clip
	ld	hl, #_battle_scene_clip
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x01
00114$:
;src/battle_scene.c:92: }
	inc	sp
	inc	sp
	ret
;src/battle_scene.c:94: uint8_t battle_scene_animation_frame(uint8_t frame) __banked {
;	---------------------------------
; Function battle_scene_animation_frame
; ---------------------------------
	b_battle_scene_animation_frame	= 31
_battle_scene_animation_frame::
	add	sp, #-6
;src/battle_scene.c:95: BattleSceneAsset asset;uint8_t clip=current_clip,kind=1;uint16_t index;
	ld	a, (#_current_clip)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x01
;src/battle_scene.c:96: index=battle_motion_asset(battle_scene_enemy,frame,battle_scene_type==0u?battle_scene_palette:0u);
	ld	a, (#_battle_scene_type)
	or	a, a
	jr	NZ, 00107$
	ld	a, (_battle_scene_palette)
	jr	00108$
00107$:
	xor	a, a
00108$:
	push	af
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, (_battle_scene_enemy)
	push	af
	inc	sp
	ld	e, #b_battle_motion_asset
	ld	hl, #_battle_motion_asset
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/battle_scene.c:97: if(index==65535u){index=enemy_magic_pose(battle_scene_enemy,frame,battle_scene_type==0u?battle_scene_palette:0u);if(index==65535u)return 0;kind=2;}
	ld	e, c
	ld	d, b
	ld	a, e
	and	a, d
	inc	a
	jr	NZ, 00104$
	ld	a, (#_battle_scene_type)
	or	a, a
	jr	NZ, 00109$
	ld	a, (_battle_scene_palette)
	jr	00110$
00109$:
	xor	a, a
00110$:
	push	af
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, (_battle_scene_enemy)
	push	af
	inc	sp
	ld	e, #b_enemy_magic_pose
	ld	hl, #_enemy_magic_pose
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	e, c
	ld	d, b
	ld	a, e
	and	a, d
	inc	a
	jr	Z, 00105$
	ldhl	sp,	#5
	ld	(hl), #0x02
00104$:
;src/battle_scene.c:98: current_asset=index;current_animated=kind;current_descriptor(&asset);
	ld	hl, #_current_asset
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#_current_animated),a
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_current_descriptor
;src/battle_scene.c:99: bank_copy(scene_shared_colors,asset.bank,asset.data+(uint16_t)asset.sprites*5u,64u);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	ld	l, (hl)
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ld	de, #0x0040
	push	de
	push	bc
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
;src/battle_scene.c:100: set_sprite_palette(0,8,scene_shared_colors);current_clip=255u;battle_scene_clip(clip);return 1;
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
	ld	hl, #_current_clip
	ld	(hl), #0xff
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_battle_scene_clip
	ld	hl, #_battle_scene_clip
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x01
00105$:
;src/battle_scene.c:101: }
	add	sp, #6
	ret
;src/battle_scene.c:103: static void overlay_prepare(uint8_t group,uint8_t white) {
;	---------------------------------
; Function overlay_prepare
; ---------------------------------
_overlay_prepare:
	add	sp, #-9
	ldhl	sp,	#8
	ld	(hl-), a
	ld	(hl), e
;src/battle_scene.c:105: if(!battle_scene_enemy||current_asset==65535u)return;
	ld	a, (#_battle_scene_enemy)
	or	a, a
	jp	Z, 00114$
	ld	a, (_current_asset)
	ld	c, a
	ld	hl, #_current_asset + 1
	ld	a, c
	and	a, (hl)
	inc	a
	jp	Z, 00114$
;src/battle_scene.c:106: current_descriptor(&local);asset=&local;
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_current_descriptor
;src/battle_scene.c:107: bank_copy(scene_shared_colors,asset->bank,asset->data+(uint16_t)asset->sprites*5u,64u);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	ld	l, (hl)
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ld	de, #0x0040
	push	de
	push	bc
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
;src/battle_scene.c:108: if(white){
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jp	Z, 00114$
;src/battle_scene.c:109: bank_copy(scene_shared_bytes,asset->bank,asset->data+(uint16_t)asset->sprites*5u+64u+(uint16_t)group*8u,8u);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	ld	l, (hl)
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	bc, #0x40
	add	hl,bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ld	de, #0x0008
	push	de
	push	bc
	ld	a, (hl)
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/battle_scene.c:110: for(p=0;p<8u;++p)for(c=1;c<4u;++c)if(scene_shared_bytes[p]&(1u<<c))scene_shared_colors[p*4u+c]=RGB(31,31,31);
	ld	c, #0x00
00119$:
	ld	a, c
	add	a, a
	add	a, a
	ldhl	sp,	#4
	ld	(hl), a
	ld	de, #_scene_shared_bytes
	ld	l, c
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl), a
	ld	b, #0x01
00110$:
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	push	bc
	ld	de, #0x0001
	pop	af
00162$:
	sla	e
	rl	d
	dec	a
	jr	NZ,00162$
	ld	a, l
	and	a, e
	ld	e, #0x00
	or	a, e
	jr	Z, 00111$
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, b
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	ld	de, #_scene_shared_colors
	add	hl, de
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0x7f
00111$:
	inc	b
	ld	a, b
	sub	a, #0x04
	jr	C, 00110$
	inc	c
	ld	a, c
	sub	a, #0x08
	jr	C, 00119$
00114$:
;src/battle_scene.c:112: }
	add	sp, #9
	ret
;src/battle_scene.c:113: static void overlay_flash(uint8_t group,uint8_t white) {
;	---------------------------------
; Function overlay_flash
; ---------------------------------
_overlay_flash:
;src/battle_scene.c:114: overlay_prepare(group,white);set_sprite_palette(0,8,scene_shared_colors);
	call	_overlay_prepare
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/battle_scene.c:115: }
	ret
;src/battle_scene.c:117: void battle_scene_flash_enemy(uint8_t white) __banked {
;	---------------------------------
; Function battle_scene_flash_enemy
; ---------------------------------
	b_battle_scene_flash_enemy	= 31
_battle_scene_flash_enemy::
;src/battle_scene.c:118: game_transition_vint16();
	ld	e, #b_game_transition_vint16
	ld	hl, #_game_transition_vint16
	call	___sdcc_bcall_ehl
;src/battle_scene.c:119: scene_palette_capture();
	ld	e, #b_scene_palette_capture
	ld	hl, #_scene_palette_capture
	call	___sdcc_bcall_ehl
;src/battle_scene.c:120: if(battle_scene_enemy==72u||battle_scene_enemy==73u)scene_palette_prepare(4u,white);
	ld	a,(#_battle_scene_enemy)
	cp	a,#0x48
	jr	Z, 00104$
	sub	a, #0x49
	jr	NZ, 00105$
00104$:
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x04
	push	af
	inc	sp
	ld	e, #b_scene_palette_prepare
	ld	hl, #_scene_palette_prepare
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00106$
00105$:
;src/battle_scene.c:121: else if(battle_scene_enemy==70u&&battle_scene_type==14u)gold_scene_prepare(2u,4u,white);
	ld	a, (#_battle_scene_enemy)
	sub	a, #0x46
	jr	NZ, 00106$
	ld	a, (#_battle_scene_type)
	sub	a, #0x0e
	jr	NZ, 00106$
	ldhl	sp,	#6
	ld	h, (hl)
	ld	l, #0x04
	push	hl
	ld	a, #0x02
	push	af
	inc	sp
	ld	e, #b_gold_scene_prepare
	ld	hl, #_gold_scene_prepare
	call	___sdcc_bcall_ehl
	add	sp, #3
00106$:
;src/battle_scene.c:122: overlay_prepare(0u,white);scene_palette_commit();
	ldhl	sp,	#6
	ld	e, (hl)
	xor	a, a
	call	_overlay_prepare
	ld	e, #b_scene_palette_commit
	ld	hl, #_scene_palette_commit
;src/battle_scene.c:123: }
	jp  ___sdcc_bcall_ehl
;src/battle_scene.c:124: void battle_scene_flash_party(uint8_t white,uint8_t extra) __banked {
;	---------------------------------
; Function battle_scene_flash_party
; ---------------------------------
	b_battle_scene_flash_party	= 31
_battle_scene_flash_party::
	add	sp, #-3
;src/battle_scene.c:126: game_transition_vint16();scene_palette_capture();
	ld	e, #b_game_transition_vint16
	ld	hl, #_game_transition_vint16
	call	___sdcc_bcall_ehl
	ld	e, #b_scene_palette_capture
	ld	hl, #_scene_palette_capture
	call	___sdcc_bcall_ehl
;src/battle_scene.c:127: if(battle_scene_enemy==70u&&battle_scene_type==14u)gold_scene_prepare(2u,extra?3u:1u,white);
	ld	a, (#_battle_scene_enemy)
	sub	a, #0x46
	jr	NZ, 00110$
	ld	a, (#_battle_scene_type)
	sub	a, #0x0e
	jr	NZ, 00110$
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	ld	a, #0x03
	jr	NZ, 00120$
	ld	a, #0x01
00120$:
	ldhl	sp,	#9
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	a, #0x02
	push	af
	inc	sp
	ld	e, #b_gold_scene_prepare
	ld	hl, #_gold_scene_prepare
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00111$
00110$:
;src/battle_scene.c:128: else if(battle_scene_type)scene_palette_prepare(extra?3u:1u,white);
	ld	a, (#_battle_scene_type)
	or	a, a
	jr	Z, 00107$
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	ld	a, #0x03
	jr	NZ, 00122$
	ld	a, #0x01
00122$:
	ldhl	sp,	#9
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_scene_palette_prepare
	ld	hl, #_scene_palette_prepare
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00111$
00107$:
;src/battle_scene.c:130: palette=dungeon_graphic_palettes+battle_scene_palette;
	ld	hl, #_battle_scene_palette
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #_dungeon_graphic_palettes
	add	hl, bc
;src/battle_scene.c:131: bank_copy(scene_palette_background,palette->bank,palette->data+312u,56u);
	ld	c,l
	ld	b,h
	inc	hl
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	de, #0x138
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	ldhl	sp,	#2
	ld	(hl), a
	push	bc
	ld	hl, #0x0038
	push	hl
	push	de
	ldhl	sp,	#8
	ld	a, (hl)
	ld	de, #_scene_palette_background
	call	_bank_copy
	pop	bc
;src/battle_scene.c:132: if(white){
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	Z, 00111$
;src/battle_scene.c:133: bank_copy(scene_shared_bytes,palette->bank,palette->data+376u,28u);
	pop	de
	push	de
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	de, #0x178
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	ld	c, a
	ld	hl, #0x001c
	push	hl
	push	de
	ld	a, c
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/battle_scene.c:134: for(i=0;i<28u;++i)if(scene_shared_bytes[i])scene_palette_background[i]=RGB(31,31,31);
	ld	c, #0x00
00115$:
	ld	hl, #_scene_shared_bytes
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00116$
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	de, #_scene_palette_background
	add	hl, de
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0x7f
00116$:
	inc	c
	ld	a, c
	sub	a, #0x1c
	jr	C, 00115$
00111$:
;src/battle_scene.c:137: if(extra)overlay_prepare(1u,white);
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
	dec	hl
	ld	e, (hl)
	ld	a, #0x01
	call	_overlay_prepare
00114$:
;src/battle_scene.c:138: scene_palette_commit();
	ld	e, #b_scene_palette_commit
	ld	hl, #_scene_palette_commit
	call	___sdcc_bcall_ehl
;src/battle_scene.c:139: }
	add	sp, #3
	ret
;src/battle_scene.c:141: static uint8_t effect_frame(uint16_t index,uint8_t bank,const BattleSceneAsset *assets,const BattleScenePool *pools,uint8_t shift) {
;	---------------------------------
; Function effect_frame
; ---------------------------------
_effect_frame:
	add	sp, #-24
	ldhl	sp,	#21
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
	ld	(hl), a
;src/battle_scene.c:143: uint16_t pair;uint8_t i,base_count=0,x,y,prop,line,slot;
	ldhl	sp,	#11
	ld	(hl), #0x00
;src/battle_scene.c:144: if(index==65535u)return 0;
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, c
	and	a, b
	inc	a
	jr	NZ, 00102$
	xor	a, a
	jp	00144$
00102$:
;src/battle_scene.c:145: bank_copy(&effect,bank,assets+index,sizeof effect);
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	d, (hl)
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ldhl	sp,	#26
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x0004
	push	de
	push	bc
	ldhl	sp,	#24
	ld	a, (hl)
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/battle_scene.c:146: if(current_asset!=65535u){
	ld	a, (_current_asset)
	ld	c, a
	ld	hl, #_current_asset + 1
	ld	a, c
	and	a, (hl)
	inc	a
	jr	Z, 00104$
;src/battle_scene.c:147: current_descriptor(&base);base_count=base.sprites;
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_current_descriptor
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
00104$:
;src/battle_scene.c:149: if(base_count+effect.sprites>40u)return 0;
	ldhl	sp,	#11
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	a, #0x28
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jr	NC, 00155$
	xor	a, a
	jp	00144$
;src/battle_scene.c:152: for(i=0;i<base_count;++i){
00155$:
	ldhl	sp,	#23
	ld	(hl), #0x00
00133$:
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#11
	sub	a, (hl)
	jp	NC, 00111$
;src/battle_scene.c:153: bank_copy(scene_shared_bytes,base.bank,base.data+(uint16_t)i*5u,5u);
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#18
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
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a, (hl)
	ld	de, #0x0005
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/battle_scene.c:154: x=scene_shared_bytes[0];y=scene_shared_bytes[1];slot=i+effect.sprites;
	ld	a, (#_scene_shared_bytes + 0)
	ldhl	sp,	#13
	ld	(hl), a
	ld	a, (#(_scene_shared_bytes + 1) + 0)
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#23
	add	a, (hl)
	ldhl	sp,	#15
	ld	(hl), a
;src/battle_scene.c:155: set_sprite_tile(slot,84u+i*2u);set_sprite_prop(slot,scene_shared_bytes[4]);
	ldhl	sp,	#23
	ld	a, (hl)
	add	a, a
	add	a, #0x54
	ld	c, a
;../../../.tools/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	b, a
	xor	a, a
	sla	b
	adc	a, a
	sla	b
	adc	a, a
	ld	(hl), b
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
	ld	a, c
	ld	(de), a
;src/battle_scene.c:155: set_sprite_tile(slot,84u+i*2u);set_sprite_prop(slot,scene_shared_bytes[4]);
	ld	hl, #(_scene_shared_bytes + 4)
	ld	c, (hl)
;../../../.tools/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	de, #_shadow_OAM+0
	ldhl	sp,	#16
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
;src/battle_scene.c:156: if(!current_clip||y-16u>=current_clip)move_sprite(slot,0,0);else move_sprite(slot,x,y);
	ld	a, (#_current_clip)
	or	a, a
	jr	Z, 00107$
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#19
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	ld	a, (_current_clip)
	ld	e, a
	ld	d, #0x00
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jr	C, 00108$
00107$:
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ldhl	sp,	#15
	ld	c, (hl)
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/battle_scene.c:156: if(!current_clip||y-16u>=current_clip)move_sprite(slot,0,0);else move_sprite(slot,x,y);
	jr	00134$
00108$:
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#16
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#14
	ld	a, (hl-)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/battle_scene.c:156: if(!current_clip||y-16u>=current_clip)move_sprite(slot,0,0);else move_sprite(slot,x,y);
00134$:
;src/battle_scene.c:152: for(i=0;i<base_count;++i){
	ldhl	sp,	#23
	inc	(hl)
	jp	00133$
00111$:
;src/battle_scene.c:158: for(i=0;i<effect.sprites;++i){
	ldhl	sp,	#30
	ld	a, (hl)
	sub	a, #0x07
	ld	a, #0x01
	jr	Z, 00279$
	xor	a, a
00279$:
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#23
	ld	(hl), #0x00
00139$:
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#19
	sub	a, (hl)
	jp	NC, 00119$
;src/battle_scene.c:159: bank_copy(scene_shared_bytes,effect.bank,effect.data+(uint16_t)i*5u,5u);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#18
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
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ld	de, #0x0005
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/battle_scene.c:160: x=scene_shared_bytes[0];y=scene_shared_bytes[1];prop=scene_shared_bytes[4];
	ld	a, (#_scene_shared_bytes + 0)
	ldhl	sp,	#13
	ld	(hl), a
	ld	a, (#(_scene_shared_bytes + 1) + 0)
	ldhl	sp,	#14
	ld	(hl), a
	ld	a, (#(_scene_shared_bytes + 4) + 0)
	ldhl	sp,	#15
	ld	(hl), a
;src/battle_scene.c:161: pair=scene_shared_bytes[2]|((uint16_t)scene_shared_bytes[3]<<8);
	ld	hl, #(_scene_shared_bytes + 2)
	ld	c, (hl)
	ld	a, (#(_scene_shared_bytes + 3) + 0)
	ld	b, a
;src/battle_scene.c:162: bank_copy(&pool,bank,pools+(pair>>shift),sizeof pool);
	ldhl	sp,	#30
	ld	a, (hl)
	ldhl	sp,	#18
	ld	(hl), c
	inc	hl
	ld	(hl), b
	inc	a
	jr	00281$
00280$:
	ldhl	sp,	#19
	srl	(hl)
	dec	hl
	rr	(hl)
00281$:
	dec	a
	jr	NZ, 00280$
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#28
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #0x0003
	push	hl
	push	de
	ldhl	sp,	#26
	ld	a, (hl)
	ld	hl, #14
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
	pop	bc
;src/battle_scene.c:163: bank_copy(scene_shared_bytes,pool.bank,pool.data+((pair&(shift==7u?127u:255u))<<5),32u);
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#18
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	jr	Z, 00146$
	ld	de, #0x007f
	jr	00147$
00146$:
	ld	de, #0x00ff
00147$:
	ld	a, c
	and	a, e
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#18
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl)
	ld	de, #0x0020
	push	de
	push	bc
	ld	de, #_scene_shared_bytes
	call	_bank_copy
;src/battle_scene.c:164: if(y>current_clip)for(line=current_clip>y-16u?current_clip-(y-16u):0u;line<16u;++line){scene_shared_bytes[line*2u]=0;scene_shared_bytes[line*2u+1u]=0;}
	ld	a, (#_current_clip)
	ldhl	sp,	#14
	sub	a, (hl)
	jr	NC, 00114$
	ld	a, (hl)
	ldhl	sp,	#19
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#17
	ld	(hl-), a
	ld	(hl), e
	ld	a, (#_current_clip)
	ldhl	sp,	#18
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#16
	ld	e, l
	ld	d, h
	ldhl	sp,	#18
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	NC, 00148$
	ldhl	sp,	#14
	ld	a, (hl)
	add	a, #0xf0
	ldhl	sp,	#19
	ld	(hl), a
	ld	a, (#_current_clip)
	ldhl	sp,	#19
	sub	a, (hl)
	jr	00149$
00148$:
	xor	a, a
00149$:
	ld	c, a
00136$:
	ld	a, c
	sub	a, #0x10
	jr	NC, 00114$
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	de, #_scene_shared_bytes
	add	hl, de
	ld	(hl), #0x00
	ld	a, c
	add	a, a
	inc	a
	ld	l, a
	ld	h, #0x00
	ld	de, #_scene_shared_bytes
	add	hl, de
	ld	(hl), #0x00
	inc	c
	jr	00136$
00114$:
;src/battle_scene.c:165: VBK_REG=1;set_sprite_data(84u+(base_count+i)*2u,2u,scene_shared_bytes);VBK_REG=0;
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#23
	add	a, (hl)
	add	a, a
	add	a, #0x54
	ld	b, a
	ld	de, #_scene_shared_bytes
	push	de
	ld	a, #0x02
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_sprite_data
	add	sp, #4
	xor	a, a
	ldh	(_VBK_REG + 0), a
;src/battle_scene.c:166: set_sprite_tile(i,84u+(base_count+i)*2u);set_sprite_prop(i,prop);
;../../../.tools/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	de, #_shadow_OAM+0
	ldhl	sp,	#23
	ld	c, (hl)
	xor	a, a
	sla	c
	adc	a, a
	sla	c
	adc	a, a
	ldhl	sp,	#18
	ld	(hl), c
	inc	hl
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	inc	hl
	ld	e, l
	ld	d, h
	ld	a, b
	ld	(de), a
;../../../.tools/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#18
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#15
	ld	a, (hl)
	ld	(bc), a
;src/battle_scene.c:167: if(!current_clip||y-16u>=current_clip)move_sprite(i,0,0);else move_sprite(i,x,y);
	ld	a, (#_current_clip)
	or	a, a
	jr	Z, 00115$
	ldhl	sp,	#14
	ld	a, (hl)
	ld	b, #0x00
	add	a, #0xf0
	ld	c, a
	ld	a, b
	adc	a, #0xff
	ld	b, a
	ld	a, (_current_clip)
	ld	e, a
	ld	d, #0x00
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jr	C, 00116$
00115$:
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#23
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, bc
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/battle_scene.c:167: if(!current_clip||y-16u>=current_clip)move_sprite(i,0,0);else move_sprite(i,x,y);
	jr	00140$
00116$:
;../../../.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#18
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
;../../../.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#14
	ld	a, (hl-)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/battle_scene.c:167: if(!current_clip||y-16u>=current_clip)move_sprite(i,0,0);else move_sprite(i,x,y);
00140$:
;src/battle_scene.c:158: for(i=0;i<effect.sprites;++i){
	ldhl	sp,	#23
	inc	(hl)
	jp	00139$
00119$:
;src/battle_scene.c:169: for(i=base_count+effect.sprites;i<40u;++i)move_sprite(i,0,0);
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#11
	add	a, (hl)
	ld	c, a
00142$:
	ld	a, c
	sub	a, #0x28
	jr	NC, 00120$
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
;src/battle_scene.c:169: for(i=base_count+effect.sprites;i<40u;++i)move_sprite(i,0,0);
	inc	c
	jr	00142$
00120$:
;src/battle_scene.c:170: bank_copy(scene_shared_colors,effect.bank,effect.data+(uint16_t)effect.sprites*5u,16u);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	ld	l, (hl)
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#23
	ld	(hl), a
	ld	de, #0x0010
	push	de
	push	bc
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
;src/battle_scene.c:171: set_sprite_palette(6,2,scene_shared_colors);SPRITES_8x16;scene_actor_active=1;
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x206
	push	hl
	call	_set_sprite_palette
	add	sp, #4
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x04
	ldh	(_LCDC_REG + 0), a
	ld	hl, #_scene_actor_active
	ld	(hl), #0x01
;src/battle_scene.c:172: if(current_clip)SHOW_SPRITES;return 1;
	ld	a, (#_current_clip)
	or	a, a
	jr	Z, 00122$
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
00122$:
	ld	a, #0x01
00144$:
;src/battle_scene.c:173: }
	add	sp, #24
	pop	hl
	add	sp, #5
	jp	(hl)
;src/battle_scene.c:174: uint8_t battle_scene_weapon_frame(uint8_t frame) __banked {
;	---------------------------------
; Function battle_scene_weapon_frame
; ---------------------------------
	b_battle_scene_weapon_frame	= 31
_battle_scene_weapon_frame::
;src/battle_scene.c:175: return effect_frame(battle_weapon_asset(battle_scene_enemy,frame),WEAPON_DATA_BANK,weapon_assets,weapon_pools,WEAPON_POOL_SHIFT);
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, (_battle_scene_enemy)
	push	af
	inc	sp
	ld	e, #b_battle_weapon_asset
	ld	hl, #_battle_weapon_asset
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, #0x07
	push	af
	inc	sp
	ld	de, #_weapon_pools
	push	de
	ld	de, #_weapon_assets
	push	de
	ld	a, #0xb6
	ld	e, c
	ld	d, b
	call	_effect_frame
;src/battle_scene.c:176: }
	ret
;src/battle_scene.c:177: uint8_t battle_scene_magic_frame(uint8_t frame) __banked {
;	---------------------------------
; Function battle_scene_magic_frame
; ---------------------------------
	b_battle_scene_magic_frame	= 31
_battle_scene_magic_frame::
;src/battle_scene.c:178: return effect_frame(enemy_magic_asset(battle_scene_enemy,frame),ENEMY_MAGIC_BANK,enemy_magic_assets,enemy_magic_pools,8u);
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, (_battle_scene_enemy)
	push	af
	inc	sp
	ld	e, #b_enemy_magic_asset
	ld	hl, #_enemy_magic_asset
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, #0x08
	push	af
	inc	sp
	ld	de, #_enemy_magic_pools
	push	de
	ld	de, #_enemy_magic_assets
	push	de
	ld	a, #0xfc
	ld	e, c
	ld	d, b
	call	_effect_frame
;src/battle_scene.c:179: }
	ret
;src/battle_scene.c:180: void battle_scene_weapon_clear(void) __banked {
;	---------------------------------
; Function battle_scene_weapon_clear
; ---------------------------------
	b_battle_scene_weapon_clear	= 31
_battle_scene_weapon_clear::
;src/battle_scene.c:181: uint8_t clip=current_clip,i;
	ld	a, (_current_clip)
	ld	b, a
;src/battle_scene.c:182: if(current_asset!=65535u){current_clip=255u;battle_scene_clip(clip);overlay_flash(0u,0u);}
	ld	a, (_current_asset)
	ld	c, a
	ld	hl, #_current_asset + 1
	ld	a, c
	and	a, (hl)
	inc	a
	jr	Z, 00111$
	ld	hl, #_current_clip
	ld	(hl), #0xff
	push	bc
	inc	sp
	ld	e, #b_battle_scene_clip
	ld	hl, #_battle_scene_clip
	call	___sdcc_bcall_ehl
	inc	sp
	xor	a, a
	ld	e, a
	jp	_overlay_flash
;src/battle_scene.c:183: else{for(i=0;i<40u;++i)move_sprite(i,0,0);SPRITES_8x8;}
00111$:
	ld	c, #0x00
00106$:
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
;src/battle_scene.c:183: else{for(i=0;i<40u;++i)move_sprite(i,0,0);SPRITES_8x8;}
	inc	c
	ld	a, c
	sub	a, #0x28
	jr	C, 00106$
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;src/battle_scene.c:184: }
	ret
;src/battle_scene.c:186: uint8_t battle_scene_boss_frame(uint8_t frame,uint8_t y) __banked {
;	---------------------------------
; Function battle_scene_boss_frame
; ---------------------------------
	b_battle_scene_boss_frame	= 31
_battle_scene_boss_frame::
	add	sp, #-6
;src/battle_scene.c:187: BattleSceneAsset asset;uint8_t i,clip=current_clip;uint16_t index;
	ld	a, (#_current_clip)
	ldhl	sp,	#4
	ld	(hl), a
;src/battle_scene.c:188: if(!frame){for(i=0;i<40u;++i)move_sprite(i,0,0);current_asset=65535u;current_animated=0;return 1;}
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	jr	NZ, 00103$
	ld	c, a
00107$:
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
;src/battle_scene.c:188: if(!frame){for(i=0;i<40u;++i)move_sprite(i,0,0);current_asset=65535u;current_animated=0;return 1;}
	inc	c
	ld	a, c
	sub	a, #0x28
	jr	C, 00107$
	ld	hl, #_current_asset
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0xff
	xor	a, a
	ld	(#_current_animated),a
	ld	a, #0x01
	jr	00109$
00103$:
;src/battle_scene.c:189: index=boss_motion_asset(battle_scene_enemy,frame,y);if(index==65535u)return 0;
	ldhl	sp,	#13
	ld	a, (hl-)
	ld	b, a
	ld	c, (hl)
	push	bc
	ld	a, (_battle_scene_enemy)
	push	af
	inc	sp
	ld	e, #b_boss_motion_asset
	ld	hl, #_boss_motion_asset
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	e, c
	ld	d, b
	ld	a, e
	and	a, d
	inc	a
	jr	Z, 00109$
;src/battle_scene.c:190: current_asset=index;current_animated=3;current_descriptor(&asset);
	ld	hl, #_current_asset
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	hl, #_current_animated
	ld	(hl), #0x03
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_current_descriptor
;src/battle_scene.c:191: bank_copy(scene_shared_colors,asset.bank,asset.data+(uint16_t)asset.sprites*5u,64u);set_sprite_palette(0,8,scene_shared_colors);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	ld	l, (hl)
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ld	de, #0x0040
	push	de
	push	bc
	ld	a, (hl)
	ld	de, #_scene_shared_colors
	call	_bank_copy
	ld	de, #_scene_shared_colors
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
;src/battle_scene.c:192: current_clip=255u;scene_actor_active=1;battle_scene_clip(clip);return 1;
	ld	hl, #_current_clip
	ld	(hl), #0xff
	ld	hl, #_scene_actor_active
	ld	(hl), #0x01
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_battle_scene_clip
	ld	hl, #_battle_scene_clip
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x01
00109$:
;src/battle_scene.c:193: }
	add	sp, #6
	ret
;src/battle_scene.c:194: void battle_scene_boss_patch(uint8_t patch) __banked {
;	---------------------------------
; Function battle_scene_boss_patch
; ---------------------------------
	b_battle_scene_boss_patch	= 31
_battle_scene_boss_patch::
	add	sp, #-5
;src/battle_scene.c:196: if(battle_scene_enemy!=73u||patch>2u)return;
	ld	a, (#_battle_scene_enemy)
	sub	a, #0x49
	jp	NZ, 00107$
	ld	a, #0x02
	ldhl	sp,	#11
	sub	a, (hl)
	jp	C, 00107$
;src/battle_scene.c:197: bank_copy(&data,BOSS_DATA_BANK,boss_patches+patch,sizeof data);
	ld	bc, #_boss_patches+0
	ldhl	sp,	#11
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ld	hl, #0x0002
	push	hl
	push	bc
	ld	a, #0xfe
	call	_bank_copy
;src/battle_scene.c:198: for(i=0;i<BOSS_PATCH_CELLS;++i){
	pop	bc
	push	bc
	ldhl	sp,	#4
	ld	(hl), #0x00
00105$:
;src/battle_scene.c:199: cell=bank_read8(BOSS_DATA_BANK,boss_patch_cells+i);attr=bank_read8(255u,data+16u);
	ld	de, #_boss_patch_cells
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	ld	a, #0xfe
	call	_bank_read8
	ldhl	sp,	#5
	ld	(hl), a
	pop	bc
	ld	hl, #0x0010
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
	ld	a, #0xff
	call	_bank_read8
	pop	bc
	ldhl	sp,	#2
;src/battle_scene.c:200: bank_bkg_data(255u,cell,1u,data,0u);VBK_REG=1;set_bkg_tiles(cell%20u,cell/20u,1u,1u,&attr);data+=17u;
	ld	(hl+), a
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, (hl)
	ld	a, #0xff
	call	_bank_bkg_data
	pop	bc
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ldhl	sp,	#3
	ld	l, (hl)
	push	hl
	push	bc
	ld	e, #0x14
	ld	a, l
	call	__divuchar
	ld	d, c
	pop	bc
	pop	hl
	push	bc
	push	de
	ld	e, #0x14
	ld	a, l
	call	__moduchar
	ld	a, c
	pop	de
	pop	bc
	ld	hl, #2
	add	hl, sp
	push	hl
	ld	h, #0x01
	push	hl
	inc	sp
	ld	h, #0x01
	ld	l, d
	push	hl
	push	af
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
	ld	hl, #0x0011
	add	hl, bc
	ld	c, l
	ld	b, h
	inc	sp
	inc	sp
	push	bc
;src/battle_scene.c:198: for(i=0;i<BOSS_PATCH_CELLS;++i){
	ldhl	sp,	#4
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0a
	jr	C, 00105$
;src/battle_scene.c:201: }VBK_REG=0;
	inc	sp
	inc	sp
	push	bc
	xor	a, a
	ldh	(_VBK_REG + 0), a
00107$:
;src/battle_scene.c:202: }
	add	sp, #5
	ret
	.area _CODE_31
	.area _INITIALIZER
	.area _CABS (ABS)
