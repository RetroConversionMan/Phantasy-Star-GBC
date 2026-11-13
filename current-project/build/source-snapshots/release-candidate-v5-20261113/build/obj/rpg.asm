;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module rpg
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_rpg_dungeon_settings_get
	.globl _rpg_dungeon_settings_get
	.globl b_rpg_dungeon_encounter
	.globl _rpg_dungeon_encounter
	.globl b_rpg_world_encounter
	.globl _rpg_world_encounter
	.globl _memset
	.globl _memcpy
	.globl b_rpg_refresh_stats
	.globl _rpg_refresh_stats
	.globl b_rpg_new_game
	.globl _rpg_new_game
	.globl b_rpg_recruit
	.globl _rpg_recruit
	.globl b_rpg_seed_rng
	.globl _rpg_seed_rng
	.globl b_rpg_random
	.globl _rpg_random
	.globl b_rpg_find_item
	.globl _rpg_find_item
	.globl b_rpg_add_item
	.globl _rpg_add_item
	.globl b_rpg_remove_item
	.globl _rpg_remove_item
	.globl b_rpg_item_discardable
	.globl _rpg_item_discardable
	.globl b_rpg_drop_item
	.globl _rpg_drop_item
	.globl b_rpg_replace_item
	.globl _rpg_replace_item
	.globl b_rpg_item_equippers
	.globl _rpg_item_equippers
	.globl b_rpg_equip_stage
	.globl _rpg_equip_stage
	.globl b_rpg_equip_finish
	.globl _rpg_equip_finish
	.globl b_rpg_equip
	.globl _rpg_equip
	.globl b_rpg_shop_option
	.globl _rpg_shop_option
	.globl b_rpg_buy
	.globl _rpg_buy
	.globl b_rpg_add_money
	.globl _rpg_add_money
	.globl b_rpg_sell_price
	.globl _rpg_sell_price
	.globl b_rpg_sell
	.globl _rpg_sell
	.globl b_rpg_use_item
	.globl _rpg_use_item
	.globl b_rpg_rest
	.globl _rpg_rest
	.globl b_rpg_hospital_cost
	.globl _rpg_hospital_cost
	.globl b_rpg_hospital
	.globl _rpg_hospital
	.globl b_rpg_revival_cost
	.globl _rpg_revival_cost
	.globl b_rpg_revive
	.globl _rpg_revive
	.globl b_rpg_award_exp
	.globl _rpg_award_exp
	.globl b_rpg_knows_spell
	.globl _rpg_knows_spell
	.globl b_rpg_cast_heal
	.globl _rpg_cast_heal
	.globl b_rpg_physical_damage
	.globl _rpg_physical_damage
	.globl b_rpg_enemy_record
	.globl _rpg_enemy_record
	.globl b_rpg_enemy_name
	.globl _rpg_enemy_name
	.globl b_rpg_magic_cost
	.globl _rpg_magic_cost
	.globl b_rpg_encounter_from_pool
	.globl _rpg_encounter_from_pool
	.globl b_rpg_exp_to_next
	.globl _rpg_exp_to_next
	.globl b_rpg_spell_option
	.globl _rpg_spell_option
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
	.area _CODE_4
;src/rpg.c:8: static uint8_t joined(const RPGState *s, uint8_t c) {
;	---------------------------------
; Function joined
; ---------------------------------
_joined:
	dec	sp
	dec	sp
;src/rpg.c:9: return c < RPG_PARTY_SIZE && (s->joined_mask & (1u << c));
	ld	c, a
	sub	a, #0x04
	jr	NC, 00103$
	ld	hl, #0x0059
	add	hl, de
	ld	a, (hl)
	ld	de, #0x0001
	inc	c
	jr	00114$
00113$:
	sla	e
	rl	d
00114$:
	dec	c
	jr	NZ,00113$
	ldhl	sp,	#0
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	and	a, e
	jr	NZ, 00104$
00103$:
	xor	a, a
	jr	00105$
00104$:
	ld	a, #0x01
00105$:
;src/rpg.c:10: }
	inc	sp
	inc	sp
	ret
;src/rpg.c:11: static uint8_t living(const RPGState *s, uint8_t c) {
;	---------------------------------
; Function living
; ---------------------------------
_living:
	ld	c, e
	ld	b, d
	ld	e, a
;src/rpg.c:12: return joined(s, c) && (s->party[c].status & 1u);
	push	bc
	push	de
	ld	a, e
	ld	e, c
	ld	d, b
	call	_joined
	pop	de
	pop	bc
	or	a, a
	jr	Z, 00103$
	ld	a, e
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	and	a, #0x01
	jr	NZ, 00104$
00103$:
	xor	a, a
	ret
00104$:
	ld	a, #0x01
;src/rpg.c:13: }
	ret
;src/rpg.c:14: static uint16_t word(const uint8_t *p) {
;	---------------------------------
; Function word
; ---------------------------------
_word:
;src/rpg.c:15: return (uint16_t)p[0] | ((uint16_t)p[1] << 8);
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
;src/rpg.c:16: }
	ret
;src/rpg.c:17: static void refresh_character(RPGCharacter *p, uint8_t c) {
;	---------------------------------
; Function refresh_character
; ---------------------------------
_refresh_character:
	add	sp, #-10
	ldhl	sp,	#8
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
;src/rpg.c:19: if (!(p->status & 1u) || !p->level || p->level > 30u) return;
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	rrca
	jp	NC, 00105$
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	or	a, a
	jp	Z, 00105$
	ld	a, #0x1e
	sub	a, c
	jp	C, 00105$
;src/rpg.c:20: level = rpg_levels[c][p->level - 1u];
	ldhl	sp,	#7
	ld	e, (hl)
	ld	d, #0x00
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
	add	hl, hl
	ld	a, #<(_rpg_levels)
	add	a, l
	ld	e, a
	ld	a, #>(_rpg_levels)
	adc	a, h
	ld	d, a
	xor	a, a
	ld	l, c
	ld	h, a
	dec	hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	c, l
	ld	b, h
	inc	sp
	inc	sp
	push	bc
;src/rpg.c:22: p->status = 1u;
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;src/rpg.c:23: p->bound = 0u;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/rpg.c:24: p->max_hp = level[0];
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	a, (de)
	ld	(bc), a
;src/rpg.c:25: p->max_mp = level[3];
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	c, l
	ld	b, h
	pop	de
	push	de
	inc	de
	inc	de
	inc	de
	ld	a, (de)
	ld	(bc), a
;src/rpg.c:26: p->attack = (uint8_t)(level[1] + (p->weapon < 64u ? rpg_equip_boost[p->weapon] : 0u));
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl+), a
	pop	bc
	push	bc
	inc	bc
	ld	a, (bc)
	ld	(hl), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#6
	ld	(hl), a
	sub	a, #0x40
	jr	NC, 00107$
	ld	de, #_rpg_equip_boost
	ld	l, (hl)
	ld	h, #0x00
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
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	jr	00108$
00107$:
	ldhl	sp,	#6
	ld	(hl), #0x00
00108$:
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	add	a, (hl)
	dec	hl
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/rpg.c:27: p->defense = (uint8_t)(level[2] + (p->armor < 64u ? rpg_equip_boost[p->armor] : 0u)
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl+), a
	pop	bc
	push	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	(hl), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#6
	ld	(hl), a
	sub	a, #0x40
	jr	NC, 00109$
	ld	de, #_rpg_equip_boost
	ld	l, (hl)
	ld	h, #0x00
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
	ld	d, (hl)
	ld	a, (de)
	jr	00110$
00109$:
	xor	a, a
00110$:
	ldhl	sp,	#4
	add	a, (hl)
	ld	c, a
;src/rpg.c:28: + (p->shield < 64u ? rpg_equip_boost[p->shield] : 0u));
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	sub	a, #0x40
	jr	NC, 00111$
	ld	hl, #_rpg_equip_boost
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	jr	00112$
00111$:
	xor	a, a
00112$:
	add	a, c
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/rpg.c:29: p->battle_magic_count = level[6];
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000e
	add	hl, de
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/rpg.c:30: p->map_magic_count = level[7];
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000f
	add	hl, de
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	hl, #0x0007
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
00105$:
;src/rpg.c:31: }
	add	sp, #10
	ret
;src/rpg.c:32: void rpg_refresh_stats(RPGState *s) RPG_BANKED {
;	---------------------------------
; Function rpg_refresh_stats
; ---------------------------------
	b_rpg_refresh_stats	= 4
_rpg_refresh_stats::
;src/rpg.c:34: for (c = 0; c != RPG_PARTY_SIZE; ++c) if (joined(s, c)) refresh_character(&s->party[c], c);
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	c, #0x00
00104$:
	push	bc
	push	de
	ld	a, c
	call	_joined
	pop	de
	pop	bc
	or	a, a
	jr	Z, 00105$
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, de
	push	bc
	push	de
	ld	a, c
	ld	e, l
	ld	d, h
	call	_refresh_character
	pop	de
	pop	bc
00105$:
	inc	c
	ld	a, c
	sub	a, #0x04
	jr	NZ, 00104$
;src/rpg.c:35: }
	ret
;src/rpg.c:36: void rpg_new_game(RPGState *s) RPG_BANKED {
;	---------------------------------
; Function rpg_new_game
; ---------------------------------
	b_rpg_new_game	= 4
_rpg_new_game::
;src/rpg.c:37: memset(s, 0, sizeof(*s));
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x005e
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/rpg.c:38: s->rng = 0x733cu;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005c
	add	hl, bc
	ld	a, #0x3c
	ld	(hl+), a
	ld	(hl), #0x73
;src/rpg.c:39: s->joined_mask = 1u;
	ld	hl, #0x0059
	add	hl, bc
;src/rpg.c:40: s->party[0].status = 1u;
	ld	a,#0x01
	ld	(hl),a
	ld	(bc), a
;src/rpg.c:41: s->party[0].level = 1u;
	ld	hl, #0x0005
	add	hl, bc
	ld	(hl), #0x01
;src/rpg.c:42: s->party[0].weapon = ItemID_ShortSword;
	ld	hl, #0x000a
	add	hl, bc
	ld	(hl), #0x02
;src/rpg.c:43: s->party[0].armor = ItemID_LeatherArmor;
	ld	hl, #0x000b
	add	hl, bc
	ld	(hl), #0x10
;src/rpg.c:44: refresh_character(&s->party[0], 0u);
	ld	e, c
	ld	d, b
	push	bc
	xor	a, a
	call	_refresh_character
	pop	bc
;src/rpg.c:45: s->party[0].hp = s->party[0].max_hp;
	ld	e, c
	ld	d, b
	inc	de
	ld	hl, #0x0006
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
;src/rpg.c:46: s->party[0].mp = s->party[0].max_mp;
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	hl, #0x0007
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
;src/rpg.c:47: }
	ret
;src/rpg.c:48: uint8_t rpg_recruit(RPGState *s, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_recruit
; ---------------------------------
	b_rpg_recruit	= 4
_rpg_recruit::
	add	sp, #-4
;src/rpg.c:50: if (c >= RPG_PARTY_SIZE || joined(s, c)) return RPG_INVALID;
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00101$
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00102$
00101$:
	ld	a, #0x01
	jp	00108$
00102$:
;src/rpg.c:51: p = &s->party[c];
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
;src/rpg.c:52: memset(p, 0, sizeof(*p));
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0010
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/rpg.c:53: if (c == 2u) { p->weapon = ItemID_IronAxe; p->armor = ItemID_IronArmor; }
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00105$
	ld	a, #0x06
	ld	(bc), a
	ld	a, #0x13
	ld	(de), a
00105$:
;src/rpg.c:54: if (c == 3u) { p->weapon = ItemID_WoodCane; p->armor = ItemID_WhiteMantle; }
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00107$
	ld	a, #0x01
	ld	(bc), a
	ld	a, #0x11
	ld	(de), a
00107$:
;src/rpg.c:55: s->joined_mask |= (uint8_t)(1u << c);
	pop	de
	push	de
	ld	hl, #0x0059
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#12
	ld	b, (hl)
	ld	a, #0x01
	inc	b
	jr	00136$
00135$:
	add	a, a
00136$:
	dec	b
	jr	NZ,00135$
	or	a, c
	ld	(de), a
;src/rpg.c:56: p->status = p->level = 1u;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	a,#0x01
	ld	(hl),a
	ld	(bc), a
;src/rpg.c:57: rpg_refresh_stats(s);
	pop	de
	push	de
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
;src/rpg.c:58: p->hp = p->max_hp;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	ld	b, a
	inc	bc
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/rpg.c:59: p->mp = p->max_mp;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	ld	b, a
	inc	bc
	inc	bc
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/rpg.c:60: return RPG_OK;
	xor	a, a
00108$:
;src/rpg.c:61: }
	add	sp, #4
	ret
;src/rpg.c:62: void rpg_seed_rng(RPGState *s, uint16_t seed) RPG_BANKED {
;	---------------------------------
; Function rpg_seed_rng
; ---------------------------------
	b_rpg_seed_rng	= 4
_rpg_seed_rng::
;src/rpg.c:63: s->rng = seed ? seed : 0x733cu;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005c
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#9
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00103$
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	jr	00104$
00103$:
	ld	de, #0x733c
00104$:
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;src/rpg.c:64: }
	ret
;src/rpg.c:65: static uint8_t ror(uint8_t v) { return (uint8_t)((v >> 1) | (v << 7)); }
;	---------------------------------
; Function ror
; ---------------------------------
_ror:
	rrca
	ret
;src/rpg.c:66: uint8_t rpg_random(RPGState *s) RPG_BANKED {
;	---------------------------------
; Function rpg_random
; ---------------------------------
	b_rpg_random	= 4
_rpg_random::
	dec	sp
	dec	sp
;src/rpg.c:69: uint8_t h = (uint8_t)(s->rng >> 8), l = (uint8_t)s->rng;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005c
	add	hl, bc
	ld	c,l
	ld	b,h
	inc	hl
	ld	a,	(hl-)
	ld	l, (hl)
	ld	h, a
;src/rpg.c:70: uint8_t a = (uint8_t)(ror(ror(h)) ^ h);
	push	hl
	push	bc
	ld	a, h
	call	_ror
	call	_ror
	pop	bc
	pop	hl
	xor	a, h
;src/rpg.c:71: a = (uint8_t)(ror(a) ^ l);
	push	hl
	push	bc
	call	_ror
	pop	bc
	pop	hl
	xor	a, l
;src/rpg.c:72: a = (uint8_t)(ror(ror(ror(ror(a)))) ^ l);
	push	hl
	push	bc
	call	_ror
	call	_ror
	call	_ror
	call	_ror
	pop	bc
	pop	hl
	xor	a, l
	ldhl	sp,	#1
	ld	(hl), a
;src/rpg.c:73: s->rng = (uint16_t)((s->rng << 1) | (a & 1u));
	ld	l, c
	ld	h, b
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, hl
	ld	e, l
	ld	d, h
	ldhl	sp,	#1
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	and	a, #0x01
	or	a, e
	ld	e, a
	ld	l, c
	ld	h, b
	ld	a, e
	ld	(hl+), a
;src/rpg.c:74: if (!s->rng) s->rng = 0x733cu;
	ld	a,d
	ld	(hl),a
	or	a, e
	jr	NZ, 00102$
	ld	l, c
	ld	h, b
	ld	a, #0x3c
	ld	(hl+), a
	ld	(hl), #0x73
00102$:
;src/rpg.c:75: return (uint8_t)s->rng;
	ld	a, (bc)
;src/rpg.c:76: }
	inc	sp
	inc	sp
	ret
;src/rpg.c:77: uint8_t rpg_find_item(const RPGState *s, uint8_t item) RPG_BANKED {
;	---------------------------------
; Function rpg_find_item
; ---------------------------------
	b_rpg_find_item	= 4
_rpg_find_item::
	dec	sp
;src/rpg.c:79: if (!item || item >= 64u || s->inventory_count > RPG_INVENTORY_SIZE) return RPG_NO_SLOT;
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, (hl)
	sub	a, #0x40
	jr	NC, 00101$
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0058
	add	hl, de
	ld	c, (hl)
	ld	a, #0x18
	sub	a, c
	jr	NC, 00102$
00101$:
	ld	a, #0xff
	jr	00111$
00102$:
;src/rpg.c:80: for (i = 0; i < s->inventory_count; ++i) if (s->inventory[i] == item) return i;
	ldhl	sp,	#0
	ld	(hl), #0x00
	ld	hl, #0x0040
	add	hl, de
	ld	e, l
	ld	d, h
	ld	b, #0x00
00109$:
	ld	a, b
	sub	a, c
	jr	NC, 00107$
	ld	l, b
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	ldhl	sp,	#9
	sub	a, (hl)
	jr	NZ, 00110$
	ldhl	sp,	#0
	ld	a, (hl)
	jr	00111$
00110$:
	inc	b
	ldhl	sp,	#0
	ld	(hl), b
	jr	00109$
00107$:
;src/rpg.c:81: return RPG_NO_SLOT;
	ld	a, #0xff
00111$:
;src/rpg.c:82: }
	inc	sp
	ret
;src/rpg.c:83: uint8_t rpg_add_item(RPGState *s, uint8_t item) RPG_BANKED {
;	---------------------------------
; Function rpg_add_item
; ---------------------------------
	b_rpg_add_item	= 4
_rpg_add_item::
;src/rpg.c:84: if (!item || item >= 64u) return RPG_INVALID;
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, (hl)
	sub	a, #0x40
	jr	C, 00102$
00101$:
	ld	a, #0x01
	ret
00102$:
;src/rpg.c:85: if (s->inventory_count >= RPG_INVENTORY_SIZE) return RPG_FULL;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0058
	add	hl, de
	ld	c, (hl)
	ld	a, c
	sub	a, #0x18
	jr	C, 00105$
	ld	a, #0x02
	ret
00105$:
;src/rpg.c:86: s->inventory[s->inventory_count++] = item;
	ld	a, e
	add	a, #0x40
	ld	e, a
	jr	NC, 00122$
	inc	d
00122$:
	ld	a, c
	inc	a
	ld	(hl), a
	ld	l, c
	ld	h, #0x00
	add	hl, de
	push	hl
	ldhl	sp,	#10
	ld	a, (hl)
	pop	hl
	ld	(hl), a
;src/rpg.c:87: return RPG_OK;
	xor	a, a
;src/rpg.c:88: }
	ret
;src/rpg.c:89: uint8_t rpg_remove_item(RPGState *s, uint8_t slot) RPG_BANKED {
;	---------------------------------
; Function rpg_remove_item
; ---------------------------------
	b_rpg_remove_item	= 4
_rpg_remove_item::
	add	sp, #-5
;src/rpg.c:91: if (s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0058
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl), a
	ld	a, #0x18
	sub	a, (hl)
	jr	C, 00101$
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#4
	sub	a, (hl)
	jr	C, 00102$
00101$:
	ld	a, #0x01
	jr	00108$
00102$:
;src/rpg.c:92: --s->inventory_count;
	ldhl	sp,	#4
	ld	a, (hl)
	dec	a
	pop	hl
	push	hl
	ld	(hl), a
;src/rpg.c:93: for (i = slot; i < s->inventory_count; ++i) s->inventory[i] = s->inventory[i + 1u];
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0040
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
00106$:
;src/rpg.c:91: if (s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
	pop	de
	push	de
	ld	a, (de)
	ld	c, a
;src/rpg.c:93: for (i = slot; i < s->inventory_count; ++i) s->inventory[i] = s->inventory[i + 1u];
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, c
	jr	NC, 00104$
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	inc	(hl)
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	jr	00106$
00104$:
;src/rpg.c:94: s->inventory[s->inventory_count] = 0u;
	ld	e, c
	ld	d, #0x00
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	sp
	inc	sp
	ld	(hl), #0x00
	push	hl
;src/rpg.c:95: return RPG_OK;
	xor	a, a
00108$:
;src/rpg.c:96: }
	add	sp, #5
	ret
;src/rpg.c:97: uint8_t rpg_item_discardable(uint8_t item) RPG_BANKED {
;	---------------------------------
; Function rpg_item_discardable
; ---------------------------------
	b_rpg_item_discardable	= 4
_rpg_item_discardable::
;src/rpg.c:98: return item && item < 64u && !(rpg_item_flags[item] & 4u);
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	ld	a, (hl)
	sub	a, #0x40
	jr	NC, 00103$
	ld	de, #_rpg_item_flags
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	rrca
	rrca
	and	a, #0x01
	jr	Z, 00104$
00103$:
	xor	a, a
	ret
00104$:
	ld	a, #0x01
;src/rpg.c:99: }
	ret
;src/rpg.c:100: uint8_t rpg_drop_item(RPGState *s, uint8_t slot) RPG_BANKED {
;	---------------------------------
; Function rpg_drop_item
; ---------------------------------
	b_rpg_drop_item	= 4
_rpg_drop_item::
	dec	sp
;src/rpg.c:102: if (s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0058
	add	hl, bc
	ld	e, (hl)
	ld	a, #0x18
	sub	a, e
	jr	C, 00101$
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, e
	jr	C, 00102$
00101$:
	ld	a, #0x01
	jr	00109$
00102$:
;src/rpg.c:103: item = s->inventory[slot];
	ld	hl, #0x0040
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
;src/rpg.c:104: if (!item || item >= 64u) return RPG_INVALID;
	ld	e,a
	or	a,a
	jr	Z, 00104$
	sub	a, #0x40
	jr	C, 00105$
00104$:
	ld	a, #0x01
	jr	00109$
00105$:
;src/rpg.c:105: if (rpg_item_flags[item] & 4u) return RPG_PROTECTED_ITEM;
	ld	hl, #_rpg_item_flags
	ld	d, #0x00
	add	hl, de
	bit	2, (hl)
	jr	Z, 00108$
	ld	a, #0x09
	jr	00109$
00108$:
;src/rpg.c:106: return rpg_remove_item(s, slot);
	ldhl	sp,	#0
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
00109$:
;src/rpg.c:107: }
	inc	sp
	ret
;src/rpg.c:108: uint8_t rpg_replace_item(RPGState *s, uint8_t slot, uint8_t item) RPG_BANKED {
;	---------------------------------
; Function rpg_replace_item
; ---------------------------------
	b_rpg_replace_item	= 4
_rpg_replace_item::
;src/rpg.c:110: if (!item || item >= 64u || s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, (hl)
	sub	a, #0x40
	jr	NC, 00101$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0058
	add	hl, bc
	ld	e, (hl)
	ld	a, #0x18
	sub	a, e
	jr	C, 00101$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, e
	jr	C, 00102$
00101$:
	ld	a, #0x01
	ret
00102$:
;src/rpg.c:111: old = s->inventory[slot];
	ld	hl, #0x0040
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl)
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
	ld	a, (bc)
;src/rpg.c:112: if (!old || old >= 64u) return RPG_INVALID;
	ld	e,a
	or	a,a
	jr	Z, 00106$
	sub	a, #0x40
	jr	C, 00107$
00106$:
	ld	a, #0x01
	ret
00107$:
;src/rpg.c:113: if (rpg_item_flags[old] & 4u) return RPG_PROTECTED_ITEM;
	ld	hl, #_rpg_item_flags
	ld	d, #0x00
	add	hl, de
	bit	2, (hl)
	jr	Z, 00110$
	ld	a, #0x09
	ret
00110$:
;src/rpg.c:114: s->inventory[slot] = item;
	ldhl	sp,	#9
	ld	a, (hl)
	ld	(bc), a
;src/rpg.c:115: return RPG_OK;
	xor	a, a
;src/rpg.c:116: }
	ret
;src/rpg.c:117: uint8_t rpg_item_equippers(uint8_t item) RPG_BANKED {
;	---------------------------------
; Function rpg_item_equippers
; ---------------------------------
	b_rpg_item_equippers	= 4
_rpg_item_equippers::
;src/rpg.c:118: return item && item < 64u ? rpg_item_flags[item] >> 4 : 0u;
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	ld	a, (hl)
	sub	a, #0x40
	jr	NC, 00103$
	ld	de, #_rpg_item_flags
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	swap	a
	and	a, #0x0f
	ret
00103$:
	xor	a, a
;src/rpg.c:119: }
	ret
;src/rpg.c:120: uint8_t rpg_equip_stage(RPGState *s, uint8_t slot, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_equip_stage
; ---------------------------------
	b_rpg_equip_stage	= 4
_rpg_equip_stage::
	add	sp, #-11
;src/rpg.c:125: if (!joined(s, c) || s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#17
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0058
	add	hl, de
	ld	c, (hl)
	ld	a, #0x18
	sub	a, c
	jr	C, 00101$
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, c
	jr	C, 00102$
00101$:
	ld	a, #0x01
	jp	00119$
00102$:
;src/rpg.c:126: if (!living(s, c)) return RPG_DEAD;
	push	de
	ldhl	sp,	#22
	ld	a, (hl)
	call	_living
	pop	de
	or	a, a
	jr	NZ, 00106$
	ld	a, #0x05
	jp	00119$
00106$:
;src/rpg.c:127: item = s->inventory[slot];
	ld	hl, #0x0040
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#3
	ld	(hl), a
;src/rpg.c:128: if (!item || item >= 64u) return RPG_INVALID;
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	ld	a, (hl)
	sub	a, #0x40
	jr	C, 00108$
00107$:
	ld	a, #0x01
	jp	00119$
00108$:
;src/rpg.c:129: flags = rpg_item_flags[item];
	ld	bc, #_rpg_item_flags+0
	ldhl	sp,	#3
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#4
	ld	(hl), a
;src/rpg.c:130: if (!(flags & (0x10u << c)) || (flags & 3u) == 3u) return RPG_CANNOT_EQUIP;
	ldhl	sp,	#20
	ld	a, (hl)
	push	af
	ldhl	sp,	#11
	ld	a, #0x10
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	pop	af
	inc	a
	jr	00171$
00170$:
	ldhl	sp,	#9
	sla	(hl)
	inc	hl
	rl	(hl)
00171$:
	dec	a
	jr	NZ,00170$
	ldhl	sp,	#4
	ld	c, (hl)
	ld	a, c
	ldhl	sp,	#9
	and	a, (hl)
	ld	l, #0x00
	or	a, l
	jr	Z, 00110$
	ld	a, c
	and	a, #0x03
	ldhl	sp,	#5
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0x03
	or	a, (hl)
	jr	NZ, 00111$
00110$:
	ld	a, #0x04
	jp	00119$
00111$:
;src/rpg.c:131: p = &s->party[c];
	ldhl	sp,	#20
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	c, a
	push	de
	ld	l, c
	ld	h, #0x00
	add	hl, de
	pop	de
	inc	sp
	inc	sp
	push	hl
;src/rpg.c:132: if ((flags & 3u) == 0u) { old = p->weapon; p->weapon = item; }
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl)
	and	a, #0x03
	jr	NZ, 00117$
	push	de
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl+), a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(bc), a
	jr	00118$
00117$:
;src/rpg.c:133: else if ((flags & 3u) == 1u) { old = p->armor; p->armor = item; }
	ldhl	sp,	#5
	ld	a, (hl+)
	dec	a
	or	a, (hl)
	jr	NZ, 00114$
	push	de
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl+), a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(bc), a
	jr	00118$
00114$:
;src/rpg.c:134: else { old = p->shield; p->shield = item; }
	push	de
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl+), a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(bc), a
00118$:
;src/rpg.c:135: s->inventory[slot] = old;
	ld	hl, #0x0040
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(bc), a
;src/rpg.c:136: return RPG_OK;
	xor	a, a
00119$:
;src/rpg.c:137: }
	add	sp, #11
	ret
;src/rpg.c:138: void rpg_equip_finish(RPGState *s, uint8_t slot) RPG_BANKED {
;	---------------------------------
; Function rpg_equip_finish
; ---------------------------------
	b_rpg_equip_finish	= 4
_rpg_equip_finish::
	dec	sp
;src/rpg.c:139: if (slot < s->inventory_count && !s->inventory[slot]) rpg_remove_item(s, slot);
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0058
	add	hl, bc
	ld	e, (hl)
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, e
	jr	NC, 00102$
	ld	hl, #0x0040
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	NZ, 00102$
	push	bc
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
00102$:
;src/rpg.c:140: rpg_refresh_stats(s);
	push	bc
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
;src/rpg.c:141: }
	inc	sp
	ret
;src/rpg.c:142: uint8_t rpg_equip(RPGState *s, uint8_t slot, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_equip
; ---------------------------------
	b_rpg_equip	= 4
_rpg_equip::
;src/rpg.c:143: uint8_t result = rpg_equip_stage(s, slot, c);
	ldhl	sp,	#9
	ld	a, (hl-)
	ld	d, a
	ld	a, (hl-)
	dec	hl
	ld	e, a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_equip_stage
	ld	hl, #_rpg_equip_stage
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	c, a
;src/rpg.c:144: if (result == RPG_OK) rpg_equip_finish(s, slot);
	or	a, a
	jr	NZ, 00102$
	push	bc
	ldhl	sp,	#10
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_equip_finish
	ld	hl, #_rpg_equip_finish
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
00102$:
;src/rpg.c:145: return result;
	ld	a, c
;src/rpg.c:146: }
	ret
;src/rpg.c:147: uint8_t rpg_shop_option(uint8_t shop, uint8_t option, uint8_t *item, uint16_t *price) RPG_BANKED {
;	---------------------------------
; Function rpg_shop_option
; ---------------------------------
	b_rpg_shop_option	= 4
_rpg_shop_option::
	dec	sp
	dec	sp
;src/rpg.c:149: if (shop >= RPG_SHOP_COUNT || option > 2u || option > rpg_shops[shop][0]) return RPG_INVALID;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x1d
	jr	NC, 00101$
	inc	hl
	ld	a, #0x02
	sub	a, (hl)
	jr	C, 00101$
	dec	hl
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	bc, #_rpg_shops
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	e, a
	ldhl	sp,	#9
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	ld	a, #0x01
	jr	00105$
00102$:
;src/rpg.c:150: p = &rpg_shops[shop][1u + option * 3u];
	ldhl	sp,	#9
;src/rpg.c:151: *item = p[0];
	ld	a, (hl+)
	ld	e, a
	add	a, a
	add	a, e
	inc	a
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ld	a, (bc)
	pop	hl
	push	hl
	ld	(hl), a
;src/rpg.c:152: *price = word(p + 1);
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	bc
	push	de
	ld	e, c
	ld	d, b
	call	_word
	pop	de
	ld	a, c
	ld	(de), a
	inc	de
	ld	a, b
	ld	(de), a
;src/rpg.c:153: return *item ? RPG_OK : RPG_INVALID;
	pop	de
	push	de
	ld	a, (de)
	or	a, a
	jr	Z, 00107$
	xor	a, a
	jr	00108$
00107$:
	ld	a, #0x01
00108$:
00105$:
;src/rpg.c:154: }
	inc	sp
	inc	sp
	ret
;src/rpg.c:155: uint8_t rpg_buy(RPGState *s, uint8_t shop, uint8_t option) RPG_BANKED {
;	---------------------------------
; Function rpg_buy
; ---------------------------------
	b_rpg_buy	= 4
_rpg_buy::
	add	sp, #-9
;src/rpg.c:158: result = rpg_shop_option(shop, option, &item, &price);
	ldhl	sp,	#1
	ld	e, l
	ld	d, h
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	push	de
	push	bc
	ldhl	sp,	#22
	ld	a, (hl-)
	ld	d, a
	ld	e, (hl)
	push	de
	ld	e, #b_rpg_shop_option
	ld	hl, #_rpg_shop_option
	call	___sdcc_bcall_ehl
	add	sp, #6
;src/rpg.c:159: if (result) return result;
	or	a,a
	jp	NZ, 00113$
;src/rpg.c:160: if (s->inventory_count >= RPG_INVENTORY_SIZE) return RPG_FULL;
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0058
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x18
	jr	C, 00104$
	ld	a, #0x02
	jp	00113$
00104$:
;src/rpg.c:161: if (s->money < price) return RPG_NO_MONEY;
	ld	hl, #0x005a
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
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#5
	ld	e, l
	ld	d, h
	ldhl	sp,	#1
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	NC, 00106$
	ld	a, #0x03
	jr	00113$
00106$:
;src/rpg.c:163: if (item >= ItemID_Secrets) return RPG_NOT_IMPLEMENTED;
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x40
	jr	C, 00108$
	ld	a, #0x08
	jr	00113$
00108$:
;src/rpg.c:164: s->money -= price;
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#1
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	(hl), e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/rpg.c:166: if (item >= ItemID_Landrover && item <= ItemID_IceDigger && rpg_find_item(s, item) != RPG_NO_SLOT) return RPG_OK;
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x21
	jr	C, 00110$
	ld	a, #0x23
	sub	a, (hl)
	jr	C, 00110$
	push	bc
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	inc	a
	jr	Z, 00110$
	xor	a, a
	jr	00113$
00110$:
;src/rpg.c:167: return rpg_add_item(s, item);
	ldhl	sp,	#0
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_add_item
	ld	hl, #_rpg_add_item
	call	___sdcc_bcall_ehl
	add	sp, #3
00113$:
;src/rpg.c:168: }
	add	sp, #9
	ret
;src/rpg.c:169: void rpg_add_money(RPGState *s, uint16_t amount) RPG_BANKED {
;	---------------------------------
; Function rpg_add_money
; ---------------------------------
	b_rpg_add_money	= 4
_rpg_add_money::
	dec	sp
	dec	sp
;src/rpg.c:170: uint16_t sum = s->money + amount;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	ldhl	sp,	#10
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
;src/rpg.c:171: s->money = sum < s->money ? 65535u : sum;
	ldhl	sp,	#0
	ld	a, e
	sub	a, (hl)
	inc	hl
	ld	a, d
	sbc	a, (hl)
	jr	NC, 00103$
	ld	de, #0xffff
00103$:
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;src/rpg.c:172: }
	inc	sp
	inc	sp
	ret
;src/rpg.c:173: uint16_t rpg_sell_price(uint8_t item) RPG_BANKED {
;	---------------------------------
; Function rpg_sell_price
; ---------------------------------
	b_rpg_sell_price	= 4
_rpg_sell_price::
;src/rpg.c:174: return item && item < 64u ? word(rpg_sell_prices[item]) : 0u;
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	ld	a, (hl)
	sub	a, #0x40
	jr	NC, 00103$
	ld	bc, #_rpg_sell_prices+0
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, bc
	ld	e, l
	ld	d, h
	jp  _word
00103$:
	ld	bc, #0x0000
;src/rpg.c:175: }
	ret
;src/rpg.c:176: uint8_t rpg_sell(RPGState *s, uint8_t slot) RPG_BANKED {
;	---------------------------------
; Function rpg_sell
; ---------------------------------
	b_rpg_sell	= 4
_rpg_sell::
	dec	sp
;src/rpg.c:178: if (s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0058
	add	hl, bc
	ld	e, (hl)
	ld	a, #0x18
	sub	a, e
	jr	C, 00101$
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, e
	jr	C, 00102$
00101$:
	ld	a, #0x01
	jr	00106$
00102$:
;src/rpg.c:179: price = rpg_sell_price(s->inventory[slot]);
	ld	hl, #0x0040
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	push	bc
	push	af
	inc	sp
	ld	e, #b_rpg_sell_price
	ld	hl, #_rpg_sell_price
	call	___sdcc_bcall_ehl
	inc	sp
	ld	l, c
	ld	h, b
	pop	bc
	ld	e, l
;src/rpg.c:180: if (!price) return RPG_PROTECTED_ITEM;
	ld	a,h
	ld	d,a
	or	a, l
	jr	NZ, 00105$
	ld	a, #0x09
	jr	00106$
00105$:
;src/rpg.c:181: rpg_remove_item(s, slot);
	push	de
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/rpg.c:182: rpg_add_money(s, price);
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_add_money
	ld	hl, #_rpg_add_money
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/rpg.c:183: return RPG_OK;
	xor	a, a
00106$:
;src/rpg.c:184: }
	inc	sp
	ret
;src/rpg.c:185: static void heal(RPGCharacter *p, uint8_t amount) {
;	---------------------------------
; Function heal
; ---------------------------------
_heal:
	add	sp, #-4
	ldhl	sp,	#2
	ld	(hl), e
	inc	hl
	ld	(hl), d
;src/rpg.c:186: uint16_t sum = (uint16_t)p->hp + amount;
	dec	hl
	ld	c, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	a, (de)
	ld	l, a
	ld	h, #0x00
	ld	b, h
	add	hl, bc
	ld	c, l
	ld	b, h
;src/rpg.c:187: p->hp = sum > p->max_hp ? p->max_hp : (uint8_t)sum;
	inc	sp
	inc	sp
	push	de
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ld	l, #0x00
	sub	a, c
	ld	a, l
	sbc	a, b
	jr	NC, 00103$
	ld	c, e
00103$:
	pop	hl
	push	hl
	ld	(hl), c
;src/rpg.c:188: }
	add	sp, #4
	ret
;src/rpg.c:189: uint8_t rpg_use_item(RPGState *s, uint8_t slot, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_use_item
; ---------------------------------
	b_rpg_use_item	= 4
_rpg_use_item::
	dec	sp
;src/rpg.c:191: if (!joined(s, c) || s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#7
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0058
	add	hl, de
	ld	c, (hl)
	ld	a, #0x18
	sub	a, c
	jr	C, 00101$
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, c
	jr	C, 00102$
00101$:
	ld	a, #0x01
	jr	00110$
00102$:
;src/rpg.c:192: item = s->inventory[slot];
	ld	hl, #0x0040
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
;src/rpg.c:193: if (item != ItemID_Cola && item != ItemID_Burger) return RPG_NOT_IMPLEMENTED;
	ld	b, a
	sub	a, #0x24
	ld	a, #0x01
	jr	Z, 00157$
	xor	a, a
00157$:
	ld	c, a
	bit	0, c
	jr	NZ, 00106$
	ld	a, b
	sub	a, #0x25
	jr	Z, 00106$
	ld	a, #0x08
	jr	00110$
00106$:
;src/rpg.c:194: if (!living(s, c)) return RPG_DEAD;
	push	bc
	push	de
	ldhl	sp,	#14
	ld	a, (hl)
	call	_living
	pop	de
	pop	bc
	or	a, a
	jr	NZ, 00109$
	ld	a, #0x05
	jr	00110$
00109$:
;src/rpg.c:195: heal(&s->party[c], item == ItemID_Cola ? 10u : 40u);
	ld	a, c
	or	a, a
	ld	c, #0x0a
	jr	NZ, 00113$
	ld	c, #0x28
00113$:
	ldhl	sp,	#10
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, de
	push	de
	ld	a, c
	ld	e, l
	ld	d, h
	call	_heal
	pop	de
;src/rpg.c:196: return rpg_remove_item(s, slot);
	ldhl	sp,	#0
	ld	a, (hl)
	push	af
	inc	sp
	push	de
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
00110$:
;src/rpg.c:197: }
	inc	sp
	ret
;src/rpg.c:198: void rpg_rest(RPGState *s) RPG_BANKED {
;	---------------------------------
; Function rpg_rest
; ---------------------------------
	b_rpg_rest	= 4
_rpg_rest::
	add	sp, #-5
;src/rpg.c:200: for (c = 0; c != RPG_PARTY_SIZE; ++c) if (living(s, c)) {
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#4
	ld	(hl), #0x00
00104$:
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_living
	or	a, a
	jr	Z, 00105$
;src/rpg.c:201: s->party[c].hp = s->party[c].max_hp;
	ldhl	sp,	#4
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	push	de
	ld	d, #0x00
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	pop	de
	ld	c, l
	ld	b, h
	ld	d, #0x00
	ldhl	sp,	#11
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0006
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/rpg.c:202: s->party[c].mp = s->party[c].max_mp;
	ld	c, e
	ld	b, d
	inc	bc
	inc	bc
	ld	hl, #0x0007
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
	ld	(bc), a
00105$:
;src/rpg.c:200: for (c = 0; c != RPG_PARTY_SIZE; ++c) if (living(s, c)) {
	ldhl	sp,	#4
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00104$
;src/rpg.c:204: }
	add	sp, #5
	ret
;src/rpg.c:205: uint16_t rpg_hospital_cost(const RPGState *s, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_hospital_cost
; ---------------------------------
	b_rpg_hospital_cost	= 4
_rpg_hospital_cost::
;src/rpg.c:207: if (!living(s, c)) return 0u;
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_living
	or	a, a
	jr	NZ, 00102$
	ld	bc, #0x0000
	ret
00102$:
;src/rpg.c:208: p = &s->party[c];
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
;src/rpg.c:210: return (uint8_t)((p->max_hp - p->hp) + (p->max_mp - p->mp));
	ld	hl, #0x0006
	add	hl, bc
	ld	a, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	ld	e, (hl)
	sub	a, e
	ld	e, a
	ld	hl, #0x0007
	add	hl, bc
	ld	a, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	c, (hl)
	sub	a, c
	add	a, e
	ld	c, a
	ld	b, #0x00
;src/rpg.c:211: }
	ret
;src/rpg.c:212: uint8_t rpg_hospital(RPGState *s, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_hospital
; ---------------------------------
	b_rpg_hospital	= 4
_rpg_hospital::
	add	sp, #-4
;src/rpg.c:214: if (!joined(s, c)) return RPG_INVALID;
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	NZ, 00102$
	ld	a, #0x01
	jp	00107$
00102$:
;src/rpg.c:215: if (!living(s, c)) return RPG_DEAD;
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_living
	or	a, a
	jr	NZ, 00104$
	ld	a, #0x05
	jr	00107$
00104$:
;src/rpg.c:216: cost = rpg_hospital_cost(s, c);
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_hospital_cost
	ld	hl, #_rpg_hospital_cost
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/rpg.c:217: if (s->money < cost) return RPG_NO_MONEY;
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x005a
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
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	a, l
	sub	a, c
	ld	a, h
	sbc	a, b
	jr	NC, 00106$
	ld	a, #0x03
	jr	00107$
00106$:
;src/rpg.c:218: s->money -= cost;
	ld	a, l
	sub	a, c
	ld	c, a
	ld	a, h
	sbc	a, b
	ld	b, a
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/rpg.c:219: s->party[c].hp = s->party[c].max_hp;
	ldhl	sp,	#12
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
	ld	c, e
	ld	b, d
	inc	bc
	ld	hl, #0x0006
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/rpg.c:220: s->party[c].mp = s->party[c].max_mp;
	ld	c, e
	ld	b, d
	inc	bc
	inc	bc
	ld	hl, #0x0007
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/rpg.c:221: return RPG_OK;
	xor	a, a
00107$:
;src/rpg.c:222: }
	add	sp, #4
	ret
;src/rpg.c:223: uint16_t rpg_revival_cost(const RPGState *s, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_revival_cost
; ---------------------------------
	b_rpg_revival_cost	= 4
_rpg_revival_cost::
;src/rpg.c:224: return joined(s, c) ? (uint16_t)s->party[c].level * 20u : 0u;
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00103$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	bc, #0x0005
	add	hl, bc
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
	ret
00103$:
	ld	bc, #0x0000
;src/rpg.c:225: }
	ret
;src/rpg.c:226: uint8_t rpg_revive(RPGState *s, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_revive
; ---------------------------------
	b_rpg_revive	= 4
_rpg_revive::
	add	sp, #-4
;src/rpg.c:228: if (!joined(s, c) || living(s, c)) return RPG_INVALID;
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_living
	or	a, a
	jr	Z, 00102$
00101$:
	ld	a, #0x01
	jp	00106$
00102$:
;src/rpg.c:229: cost = rpg_revival_cost(s, c);
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_revival_cost
	ld	hl, #_rpg_revival_cost
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/rpg.c:230: if (s->money < cost) return RPG_NO_MONEY;
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x005a
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
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	a, l
	sub	a, c
	ld	a, h
	sbc	a, b
	jr	NC, 00105$
	ld	a, #0x03
	jr	00106$
00105$:
;src/rpg.c:231: s->money -= cost;
	ld	a, l
	sub	a, c
	ld	c, a
	ld	a, h
	sbc	a, b
	ld	b, a
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/rpg.c:232: s->party[c].status = 1u;
	ldhl	sp,	#12
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	push	de
	ld	d, #0x00
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	(hl), #0x01
;src/rpg.c:233: s->party[c].hp = s->party[c].max_hp;
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
	ld	c, e
	ld	b, d
	inc	bc
	ld	hl, #0x0006
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/rpg.c:234: s->party[c].mp = s->party[c].max_mp;
	ld	c, e
	ld	b, d
	inc	bc
	inc	bc
	ld	hl, #0x0007
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/rpg.c:235: return RPG_OK;
	xor	a, a
00106$:
;src/rpg.c:236: }
	add	sp, #4
	ret
;src/rpg.c:237: uint8_t rpg_award_exp(RPGState *s, uint16_t amount) RPG_BANKED {
;	---------------------------------
; Function rpg_award_exp
; ---------------------------------
	b_rpg_award_exp	= 4
_rpg_award_exp::
	add	sp, #-11
;src/rpg.c:238: uint8_t c, leveled = 0u;
	ldhl	sp,	#10
	ld	(hl), #0x00
;src/rpg.c:239: if (!amount) return 0u;
	ldhl	sp,	#20
	ld	a, (hl-)
	or	a,(hl)
;src/rpg.c:240: for (c = 0; c != RPG_PARTY_SIZE; ++c) if (living(s, c)) {
	jp	Z, 00114$
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ld	c, #0x00
00113$:
	push	bc
	ld	a, c
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_living
	pop	bc
	or	a, a
	jp	Z, 00111$
;src/rpg.c:241: RPGCharacter *p = &s->party[c];
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
;src/rpg.c:242: uint16_t sum = p->exp + amount;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#19
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
	ld	(hl), a
;src/rpg.c:243: if (sum < p->exp) { p->exp = 65535u; continue; }
	ldhl	sp,	#8
	ld	e, l
	ld	d, h
	ldhl	sp,	#6
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jr	NC, 00104$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0xff
	jr	00111$
00104$:
;src/rpg.c:244: p->exp = sum;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/rpg.c:245: if (p->level && p->level < 30u && sum >= word(&rpg_levels[c][p->level][4])) {
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b,a
	or	a,a
	jr	Z, 00111$
	sub	a, #0x1e
	jr	NC, 00111$
	ld	e, c
	ld	d, #0x00
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
	add	hl, hl
	ld	de, #_rpg_levels
	add	hl, de
	ld	a, b
	add	a, a
	add	a, a
	add	a, a
	add	a, l
	ld	e, a
	ld	a, #0x00
	adc	a, h
	ld	d, a
	inc	de
	inc	de
	inc	de
	inc	de
	push	bc
	call	_word
	ld	e, c
	ld	d, b
	pop	bc
	ldhl	sp,	#8
	ld	a, (hl+)
	sub	a, e
	ld	a, (hl)
	sbc	a, d
	jr	C, 00111$
;src/rpg.c:246: ++p->level;
	dec	hl
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	inc	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/rpg.c:247: leveled |= (uint8_t)(1u << c);
	ld	b, c
	ld	a, #0x01
	inc	b
	jr	00174$
00173$:
	add	a, a
00174$:
	dec	b
	jr	NZ,00173$
	ldhl	sp,	#10
	or	a, (hl)
	ld	(hl), a
00111$:
;src/rpg.c:240: for (c = 0; c != RPG_PARTY_SIZE; ++c) if (living(s, c)) {
	inc	c
	ld	a, c
	sub	a, #0x04
	jp	NZ, 00113$
;src/rpg.c:250: rpg_refresh_stats(s);
	pop	de
	push	de
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
;src/rpg.c:251: return leveled;
	ldhl	sp,	#10
	ld	a, (hl)
00114$:
;src/rpg.c:252: }
	add	sp, #11
	ret
;src/rpg.c:253: uint8_t rpg_knows_spell(const RPGState *s, uint8_t c, uint8_t spell, uint8_t in_battle) RPG_BANKED {
;	---------------------------------
; Function rpg_knows_spell
; ---------------------------------
	b_rpg_knows_spell	= 4
_rpg_knows_spell::
	dec	sp
;src/rpg.c:256: if (!joined(s, c) || c == 2u || !spell || spell >= 19u) return 0u;
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, #0x02
	jr	Z, 00101$
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, (hl)
	sub	a, #0x13
	jr	C, 00102$
00101$:
	xor	a, a
	jr	00114$
00102$:
;src/rpg.c:257: row = c == 3u ? 2u : c;
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00116$
	ld	c, #0x02
	jr	00117$
00116$:
	ldhl	sp,	#9
	ld	c, (hl)
00117$:
;src/rpg.c:258: spells = in_battle ? rpg_battle_spells[row] : rpg_map_spells[row];
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	ld	hl, #_rpg_battle_spells
	add	hl, bc
	jr	00119$
00118$:
	ld	hl, #_rpg_map_spells
	add	hl, bc
00119$:
	ld	c, l
	ld	b, h
;src/rpg.c:259: count = in_battle ? s->party[c].battle_magic_count : s->party[c].map_magic_count;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	inc	hl
	swap	a
	and	a, #0xf0
	add	a, e
	ld	e, a
	ld	a, #0x00
	adc	a, d
	ld	d, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
	ld	hl, #0x000e
	add	hl, de
	ld	e, (hl)
	jr	00121$
00120$:
	ld	hl, #0x000f
	add	hl, de
	ld	e, (hl)
00121$:
;src/rpg.c:260: if (count > 5u) count = 5u;
	ld	a, #0x05
	sub	a, e
	jr	NC, 00131$
	ld	e, #0x05
;src/rpg.c:261: for (i = 0u; i < count; ++i) if ((spells[i] & 31u) == spell) return 1u;
00131$:
	ld	d, #0x00
00112$:
	ld	a, d
	sub	a, e
	jr	NC, 00110$
	ld	l, d
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	and	a, #0x1f
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#0
	sub	a, (hl)
	jr	NZ, 00113$
	ld	a, #0x01
	jr	00114$
00113$:
	inc	d
	jr	00112$
00110$:
;src/rpg.c:262: return 0u;
	xor	a, a
00114$:
;src/rpg.c:263: }
	inc	sp
	ret
;src/rpg.c:264: uint8_t rpg_cast_heal(RPGState *s, uint8_t caster, uint8_t target, uint8_t spell, uint8_t in_battle) RPG_BANKED {
;	---------------------------------
; Function rpg_cast_heal
; ---------------------------------
	b_rpg_cast_heal	= 4
_rpg_cast_heal::
;src/rpg.c:266: if (!joined(s, caster) || !joined(s, target)) return RPG_INVALID;
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	NZ, 00102$
00101$:
	ld	a, #0x01
	ret
00102$:
;src/rpg.c:267: if (!living(s, caster) || !living(s, target)) return RPG_DEAD;
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_living
	or	a, a
	jr	Z, 00104$
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_living
	or	a, a
	jr	NZ, 00105$
00104$:
	ld	a, #0x05
	ret
00105$:
;src/rpg.c:268: if (spell != MagicID_Heal && spell != MagicID_Cure) return RPG_INVALID;
	ldhl	sp,	#10
	ld	a, (hl)
	dec	a
	ld	a, #0x01
	jr	Z, 00168$
	xor	a, a
00168$:
	ld	e, a
	bit	0, e
	jr	NZ, 00108$
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x02
	jr	Z, 00108$
	ld	a, #0x01
	ret
00108$:
;src/rpg.c:269: if (!rpg_knows_spell(s, caster, spell, in_battle)) return RPG_NOT_LEARNED;
	push	de
	ldhl	sp,	#13
	ld	a, (hl-)
	ld	b, a
	ld	a, (hl-)
	dec	hl
	ld	c, a
	push	bc
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	e, #b_rpg_knows_spell
	ld	hl, #_rpg_knows_spell
	call	___sdcc_bcall_ehl
	add	sp, #5
	pop	de
	or	a, a
	jr	NZ, 00111$
	ld	a, #0x07
	ret
00111$:
;src/rpg.c:270: cost = rpg_spell_cost[spell];
	ld	bc, #_rpg_spell_cost+0
	ldhl	sp,	#10
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	d, a
;src/rpg.c:271: if (s->party[caster].mp < cost) return RPG_NO_MP;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	inc	hl
	inc	hl
	ld	a, (hl)
	cp	a, d
	jr	NC, 00113$
	ld	a, #0x06
	ret
00113$:
;src/rpg.c:272: s->party[caster].mp -= cost;
	sub	a, d
	ld	(hl), a
;src/rpg.c:273: heal(&s->party[target], spell == MagicID_Heal ? 20u : 80u);
	ld	a, e
	or	a, a
	ld	e, #0x14
	jr	NZ, 00117$
	ld	e, #0x50
00117$:
	ldhl	sp,	#9
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, e
	ld	e, l
	ld	d, h
	call	_heal
;src/rpg.c:274: return RPG_OK;
	xor	a, a
;src/rpg.c:275: }
	ret
;src/rpg.c:276: static uint8_t scale(RPGState *s, uint8_t value) {
;	---------------------------------
; Function scale
; ---------------------------------
_scale:
	ld	l, a
;src/rpg.c:277: uint8_t quarter = value >> 2;
	ld	c, l
	srl	c
	srl	c
;src/rpg.c:278: return (uint8_t)((value >> 1) + quarter + (((uint16_t)rpg_random(s) * quarter) >> 8));
	srl	l
	add	hl, bc
	push	hl
	push	bc
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	pop	hl
	ld	d, #0x00
	ld	b, d
	push	hl
	ld	e, a
	call	__mulint
	pop	hl
	ld	a, b
	add	a, l
;src/rpg.c:279: }
	ret
;src/rpg.c:280: uint8_t rpg_physical_damage(RPGState *s, uint8_t attack, uint8_t defense, uint8_t fallback_level, uint8_t enemy_attack) RPG_BANKED {
;	---------------------------------
; Function rpg_physical_damage
; ---------------------------------
	b_rpg_physical_damage	= 4
_rpg_physical_damage::
;src/rpg.c:281: uint8_t a = scale(s, attack), d = scale(s, defense), r;
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_scale
	ld	c, a
	push	bc
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_scale
	ld	e, a
	pop	bc
;src/rpg.c:282: if (a > d) return a - d;
	ld	a, e
	sub	a, c
	jr	NC, 00102$
	ld	a, c
	sub	a, e
	ret
00102$:
;src/rpg.c:283: d -= a;
	ld	a, e
	sub	a, c
;src/rpg.c:284: if (d >= 16u && !(d & 1u)) return 0u;
	cp	a, #0x10
	jr	C, 00106$
	rrca
	jr	C, 00106$
	xor	a, a
	ret
;src/rpg.c:285: do { r = rpg_random(s) & 31u; } while (r > fallback_level);
00106$:
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x1f
	ld	c, a
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, c
	jr	C, 00106$
;src/rpg.c:286: return (enemy_attack ? (r >> 1) : r) + 1u;
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00111$
	srl	c
00111$:
	ld	a, c
	inc	a
;src/rpg.c:287: }
	ret
;src/rpg.c:289: uint8_t rpg_enemy_record(uint8_t enemy, uint8_t destination[32]) RPG_BANKED {
;	---------------------------------
; Function rpg_enemy_record
; ---------------------------------
	b_rpg_enemy_record	= 4
_rpg_enemy_record::
;src/rpg.c:290: if (!enemy || enemy >= RPG_ENEMY_COUNT) return RPG_INVALID;
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, (hl)
	sub	a, #0x4b
	jr	C, 00102$
00101$:
	ld	a, #0x01
	ret
00102$:
;src/rpg.c:291: memcpy(destination, rpg_enemies[enemy], 32u);
	ld	bc, #_rpg_enemies+0
	ldhl	sp,	#6
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
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0020
	push	hl
	call	_memcpy
;src/rpg.c:292: return RPG_OK;
	xor	a, a
;src/rpg.c:293: }
	ret
;src/rpg.c:294: uint8_t rpg_enemy_name(uint8_t enemy, char destination[9]) RPG_BANKED {
;	---------------------------------
; Function rpg_enemy_name
; ---------------------------------
	b_rpg_enemy_name	= 4
_rpg_enemy_name::
;src/rpg.c:295: if (enemy >= RPG_ENEMY_COUNT) return RPG_INVALID;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x4b
	jr	C, 00102$
	ld	a, #0x01
	ret
00102$:
;src/rpg.c:296: memcpy(destination, rpg_enemy_names[enemy], 9u);
	ldhl	sp,	#6
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_rpg_enemy_names
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	push	hl
	call	_memcpy
;src/rpg.c:297: return RPG_OK;
	xor	a, a
;src/rpg.c:298: }
	ret
;src/rpg.c:299: uint8_t rpg_magic_cost(uint8_t spell) RPG_BANKED {
;	---------------------------------
; Function rpg_magic_cost
; ---------------------------------
	b_rpg_magic_cost	= 4
_rpg_magic_cost::
;src/rpg.c:300: return spell < 19u ? rpg_spell_cost[spell] : 0u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x13
	jr	NC, 00103$
	ld	bc, #_rpg_spell_cost+0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ret
00103$:
	xor	a, a
;src/rpg.c:301: }
	ret
;src/rpg.c:302: uint8_t rpg_encounter_from_pool(RPGState *s, uint8_t pool) RPG_BANKED {
;	---------------------------------
; Function rpg_encounter_from_pool
; ---------------------------------
	b_rpg_encounter_from_pool	= 4
_rpg_encounter_from_pool::
;src/rpg.c:303: if (!pool || pool > RPG_ENCOUNTER_POOL_COUNT) return 0u;
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00101$
	ld	a, #0x5e
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	ret
00102$:
;src/rpg.c:304: return rpg_encounter_pools[pool - 1u][rpg_random(s) & 7u];
	ld	bc, #_rpg_encounter_pools+0
	ldhl	sp,	#8
	ld	a, (hl)
	ld	h, #0x00
	ld	l, a
	dec	hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	push	hl
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	and	a, #0x07
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
;src/rpg.c:305: }
	ret
;src/rpg.c:307: uint16_t rpg_exp_to_next(const RPGState *s, uint8_t c) RPG_BANKED {
;	---------------------------------
; Function rpg_exp_to_next
; ---------------------------------
	b_rpg_exp_to_next	= 4
_rpg_exp_to_next::
	add	sp, #-4
;src/rpg.c:308: if (!joined(s, c) || !s->party[c].level || s->party[c].level >= 30u) return 0u;
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c,a
	or	a,a
	jr	Z, 00101$
	sub	a, #0x1e
	jr	C, 00102$
00101$:
	ld	bc, #0x0000
	jr	00105$
00102$:
;src/rpg.c:309: return (uint16_t)(word(&rpg_levels[c][s->party[c].level][4]) - s->party[c].exp);
	ldhl	sp,	#12
	ld	e, (hl)
	ld	d, #0x00
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
	add	hl, hl
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
	ld	hl, #_rpg_levels
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	bc, #0x0004
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_word
	pop	hl
	push	hl
	inc	hl
	inc	hl
	inc	hl
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	sub	a, l
	ld	c, a
	ld	a, b
	sbc	a, h
	ld	b, a
00105$:
;src/rpg.c:310: }
	add	sp, #4
	ret
;src/rpg.c:311: uint8_t rpg_world_encounter(RPGState *s, uint8_t group, uint16_t x, uint16_t y, uint8_t metatile, uint8_t vehicle) RPG_BANKED {
;	---------------------------------
; Function rpg_world_encounter
; ---------------------------------
	b_rpg_world_encounter	= 4
_rpg_world_encounter::
	dec	sp
	dec	sp
;src/rpg.c:313: uint16_t top = (y + 1536u - 16u) % 1536u;
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x05f0
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	bc, #0x0600
	call	__moduint
	pop	hl
	push	bc
;src/rpg.c:314: if (group >= 3u) return 0u;
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x03
	jr	C, 00102$
	xor	a, a
	jp	00107$
00102$:
;src/rpg.c:315: region = (uint8_t)((top / 192u) * 8u + (((x - 8u) & 2047u) >> 8));
	pop	de
	push	de
	ld	bc, #0x00c0
	call	__divuint
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	ld	c, a
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	b, (hl)
;src/rpg.c:316: chance = rpg_world_regions[group][region][0];
	dec	hl
	dec	hl
	add	a, #0xf8
	ld	a, b
	adc	a, #0xff
	and	a, #0x07
	add	a, c
	ld	c, a
	ld	e, (hl)
	xor	a, a
	ld	h, e
	ld	l, a
	srl	h
	rr	l
	ld	de, #_rpg_world_regions
	add	hl, de
	ld	a, c
	add	a, a
	add	a, l
	ld	c, a
	ld	a, #0x00
	adc	a, h
	ld	b, a
	ld	a, (bc)
	ld	e, a
;src/rpg.c:317: if (vehicle) chance >>= 2;
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	srl	e
	srl	e
00104$:
;src/rpg.c:318: if (rpg_random(s) >= chance) return 0u;
	push	bc
	push	de
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	de
	pop	bc
	sub	a, e
	jr	C, 00106$
	xor	a, a
	jr	00107$
00106$:
;src/rpg.c:319: column = rpg_world_regions[group][region][1];
	inc	bc
	ld	a, (bc)
	ld	c, a
;src/rpg.c:320: row = rpg_terrain_lookup[metatile] + (group ? 10u : 0u);
	ld	de, #_rpg_terrain_lookup
	ldhl	sp,	#15
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	ld	a, #0x0a
	jr	NZ, 00110$
	xor	a, a
00110$:
	add	a, b
	ld	b, a
;src/rpg.c:323: pool = rpg_map_encounter_window[row][column];
	xor	a, a
	ld	l, b
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_rpg_map_encounter_window
	add	hl, de
	ld	e, c
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
;src/rpg.c:324: return rpg_encounter_from_pool(s, pool);
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_encounter_from_pool
	ld	hl, #_rpg_encounter_from_pool
	call	___sdcc_bcall_ehl
	add	sp, #3
00107$:
;src/rpg.c:325: }
	inc	sp
	inc	sp
	ret
;src/rpg.c:326: uint8_t rpg_dungeon_encounter(RPGState *s, uint8_t floor, uint8_t ahead_cell) RPG_BANKED {
;	---------------------------------
; Function rpg_dungeon_encounter
; ---------------------------------
	b_rpg_dungeon_encounter	= 4
_rpg_dungeon_encounter::
;src/rpg.c:327: if (floor >= 61u) return 0u;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x3d
	jr	C, 00102$
	xor	a, a
	ret
00102$:
;src/rpg.c:328: if (rpg_random(s) >= rpg_dungeon_settings[floor][0]) return 0u;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, a
	ldhl	sp,	#8
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #<(_rpg_dungeon_settings)
	ld	c, a
	ld	a, h
	adc	a, #>(_rpg_dungeon_settings)
	ld	b, a
	ld	a, (bc)
	ld	d, a
	ld	a, e
	sub	a, d
	jr	C, 00104$
	xor	a, a
	ret
00104$:
;src/rpg.c:329: if (ahead_cell & 7u) return 0u;
	ldhl	sp,	#9
	ld	a, (hl)
	and	a, #0x07
	jr	Z, 00106$
	xor	a, a
	ret
00106$:
;src/rpg.c:330: return rpg_encounter_from_pool(s, rpg_dungeon_settings[floor][1]);
	inc	bc
	ld	a, (bc)
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_encounter_from_pool
	ld	hl, #_rpg_encounter_from_pool
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/rpg.c:331: }
	ret
;src/rpg.c:332: uint8_t rpg_dungeon_settings_get(uint8_t floor, uint8_t destination[4]) RPG_BANKED {
;	---------------------------------
; Function rpg_dungeon_settings_get
; ---------------------------------
	b_rpg_dungeon_settings_get	= 4
_rpg_dungeon_settings_get::
;src/rpg.c:333: if (floor >= 61u) return RPG_INVALID;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x3d
	jr	C, 00102$
	ld	a, #0x01
	ret
00102$:
;src/rpg.c:334: memcpy(destination, rpg_dungeon_settings[floor], 4u);
	ld	bc, #_rpg_dungeon_settings+0
	ldhl	sp,	#6
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	push	hl
	call	_memcpy
;src/rpg.c:335: return RPG_OK;
	xor	a, a
;src/rpg.c:336: }
	ret
;src/rpg.c:338: uint8_t rpg_spell_option(const RPGState *s, uint8_t c, uint8_t option, uint8_t in_battle) RPG_BANKED {
;	---------------------------------
; Function rpg_spell_option
; ---------------------------------
	b_rpg_spell_option	= 4
_rpg_spell_option::
;src/rpg.c:340: if (!joined(s, c) || c == 2u || option >= 5u) return 0u;
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_joined
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x02
	jr	Z, 00101$
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, #0x05
	jr	C, 00102$
00101$:
	xor	a, a
	ret
00102$:
;src/rpg.c:341: count = in_battle ? s->party[c].battle_magic_count : s->party[c].map_magic_count;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	inc	hl
	swap	a
	and	a, #0xf0
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00109$
	ld	hl, #0x000e
	add	hl, bc
	ld	c, (hl)
	jr	00110$
00109$:
	ld	hl, #0x000f
	add	hl, bc
	ld	c, (hl)
00110$:
;src/rpg.c:342: if (option >= count) return 0u;
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, c
	jr	C, 00106$
	xor	a, a
	ret
00106$:
;src/rpg.c:343: row = c == 3u ? 2u : c;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00111$
	ld	c, #0x02
	jr	00112$
00111$:
	ldhl	sp,	#8
	ld	c, (hl)
00112$:
;src/rpg.c:344: return (in_battle ? rpg_battle_spells[row][option] : rpg_map_spells[row][option]) & 31u;
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00113$
	ld	hl, #_rpg_battle_spells
	add	hl, bc
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	jr	00114$
00113$:
	ld	hl, #_rpg_map_spells
	add	hl, bc
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
00114$:
	and	a, #0x1f
;src/rpg.c:345: }
	ret
	.area _CODE_4
	.area _INITIALIZER
	.area _CABS (ABS)
