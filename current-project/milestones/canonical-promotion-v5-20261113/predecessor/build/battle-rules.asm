;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module battle
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl _memcpy
	.globl b_rpg_physical_damage
	.globl _rpg_physical_damage
	.globl b_rpg_magic_cost
	.globl _rpg_magic_cost
	.globl b_rpg_enemy_record
	.globl _rpg_enemy_record
	.globl b_rpg_cast_heal
	.globl _rpg_cast_heal
	.globl b_rpg_knows_spell
	.globl _rpg_knows_spell
	.globl b_rpg_award_exp
	.globl _rpg_award_exp
	.globl b_rpg_add_money
	.globl _rpg_add_money
	.globl b_rpg_use_item
	.globl _rpg_use_item
	.globl b_rpg_replace_item
	.globl _rpg_replace_item
	.globl b_rpg_find_item
	.globl _rpg_find_item
	.globl b_rpg_remove_item
	.globl _rpg_remove_item
	.globl b_rpg_add_item
	.globl _rpg_add_item
	.globl b_rpg_refresh_stats
	.globl _rpg_refresh_stats
	.globl b_rpg_random
	.globl _rpg_random
	.globl b_rpg_battle_begin
	.globl _rpg_battle_begin
	.globl b_rpg_try_run
	.globl _rpg_try_run
	.globl b_rpg_battle_talk
	.globl _rpg_battle_talk
	.globl b_rpg_battle_prepare
	.globl _rpg_battle_prepare
	.globl b_rpg_battle_step
	.globl _rpg_battle_step
	.globl b_rpg_battle_round
	.globl _rpg_battle_round
	.globl b_rpg_claim_rewards
	.globl _rpg_claim_rewards
	.globl b_rpg_battle_open_chest
	.globl _rpg_battle_open_chest
	.globl b_rpg_battle_replace_reward
	.globl _rpg_battle_replace_reward
	.globl b_rpg_battle_decline_chest
	.globl _rpg_battle_decline_chest
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
	.area _CODE_18
;src/battle.c:8: static uint8_t alive(const RPGCharacter *p) { return p->status & 1u; }
;	---------------------------------
; Function alive
; ---------------------------------
_alive:
	ld	a, (de)
	and	a, #0x01
	ret
;src/battle.c:9: static uint8_t party_alive(const RPGState *s, uint8_t c) {
;	---------------------------------
; Function party_alive
; ---------------------------------
_party_alive:
	ld	c, a
;src/battle.c:10: return (s->joined_mask & (1u << c)) && alive(&s->party[c]);
	ld	hl, #0x0059
	add	hl, de
	ld	a, (hl)
	ld	b, c
	ld	hl, #0x0001
	inc	b
	jr	00114$
00113$:
	add	hl, hl
00114$:
	dec	b
	jr	NZ,00113$
	and	a, l
	jr	Z, 00103$
	ld	a, c
	swap	a
	and	a, #0xf0
	add	a, e
	ld	e, a
	ld	a, #0x00
	adc	a, d
	ld	d, a
	call	_alive
	or	a, a
	jr	NZ, 00104$
00103$:
	xor	a, a
	ret
00104$:
	ld	a, #0x01
;src/battle.c:11: }
	ret
;src/battle.c:12: static uint8_t party_count(const RPGState *s) {
;	---------------------------------
; Function party_count
; ---------------------------------
_party_count:
	dec	sp
;src/battle.c:14: for (c = 0; c != 4; ++c) if (s->joined_mask & (1u << c)) ++n;
	ld	hl, #0x0059
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#0
	ld	(hl), #0x00
	ld	c, #0x00
00104$:
	ld	a, (de)
	ld	b, c
	ld	hl, #0x0001
	inc	b
	jr	00131$
00130$:
	add	hl, hl
00131$:
	dec	b
	jr	NZ,00130$
	and	a, l
	ld	b, #0x00
	or	a, b
	jr	Z, 00105$
	ldhl	sp,	#0
	inc	(hl)
00105$:
	inc	c
	ld	a, c
	sub	a, #0x04
	jr	NZ, 00104$
;src/battle.c:15: return n;
	ldhl	sp,	#0
	ld	a, (hl)
;src/battle.c:16: }
	inc	sp
	ret
;src/battle.c:17: static uint8_t living_party(const RPGState *s) {
;	---------------------------------
; Function living_party
; ---------------------------------
_living_party:
;src/battle.c:19: for (c = 0; c != 4; ++c) if (party_alive(s, c)) return 1;
	ld	c, #0x00
00104$:
	push	bc
	push	de
	ld	a, c
	call	_party_alive
	pop	de
	pop	bc
	or	a, a
	jr	Z, 00105$
	ld	a, #0x01
	ret
00105$:
	inc	c
	ld	a, c
	sub	a, #0x04
	jr	NZ, 00104$
;src/battle.c:20: return 0;
	xor	a, a
;src/battle.c:21: }
	ret
;src/battle.c:22: static uint8_t living_enemies(const RPGBattle *b) {
;	---------------------------------
; Function living_enemies
; ---------------------------------
_living_enemies:
	ld	c, e
	ld	b, d
;src/battle.c:24: for (c = 0; c != 8; ++c) if (alive(&b->enemies[c])) return 1;
	ld	d, #0x00
00104$:
	ld	a, d
	swap	a
	and	a, #0xf0
	add	a, c
	ld	e, a
	ld	a, #0x00
	adc	a, b
	push	bc
	push	de
	ld	d, a
	call	_alive
	pop	de
	pop	bc
	or	a, a
	jr	Z, 00105$
	ld	a, #0x01
	ret
00105$:
	inc	d
	ld	a, d
	sub	a, #0x08
	jr	NZ, 00104$
;src/battle.c:25: return 0;
	xor	a, a
;src/battle.c:26: }
	ret
;src/battle.c:27: static uint8_t choose_party(RPGState *s) {
;	---------------------------------
; Function choose_party
; ---------------------------------
_choose_party:
;src/battle.c:29: if (!living_party(s)) return RPG_NO_SLOT;
	push	de
	call	_living_party
	pop	de
	or	a, a
	jr	NZ, 00103$
	ld	a, #0xff
	ret
;src/battle.c:30: do { c = rpg_random(s) & 3u; } while (!party_alive(s, c));
00103$:
	push	de
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	de
	and	a, #0x03
	ld	c, a
	push	bc
	push	de
	ld	a, c
	call	_party_alive
	pop	de
	pop	bc
	or	a, a
	jr	Z, 00103$
;src/battle.c:31: return c;
	ld	a, c
;src/battle.c:32: }
	ret
;src/battle.c:33: static uint8_t choose_enemy(RPGState *s, const RPGBattle *b) {
;	---------------------------------
; Function choose_enemy
; ---------------------------------
_choose_enemy:
	push	de
;src/battle.c:35: if (!living_enemies(b)) return RPG_NO_SLOT;
	push	bc
	ld	e, c
	ld	d, b
	call	_living_enemies
	pop	bc
	or	a, a
	jr	NZ, 00109$
	ld	a, #0xff
	jr	00106$
;src/battle.c:36: do { c = rpg_random(s) & 7u; } while (!alive(&b->enemies[c]));
00109$:
00103$:
	push	bc
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	de
	pop	bc
	and	a, #0x07
	ld	l, a
	swap	a
	and	a, #0xf0
	add	a, c
	ld	e, a
	ld	a, #0x00
	adc	a, b
	push	hl
	push	bc
	ld	d, a
	call	_alive
	pop	bc
	pop	hl
	or	a, a
	jr	Z, 00103$
;src/battle.c:37: return c;
	ld	a, l
00106$:
;src/battle.c:38: }
	inc	sp
	inc	sp
	ret
;src/battle.c:39: static uint8_t boost(const RPGCharacter *p, uint8_t enemy) {
;	---------------------------------
; Function boost
; ---------------------------------
_boost:
	dec	sp
	ldhl	sp,	#0
	ld	(hl), a
;src/battle.c:40: uint16_t a = p->attack;
	ld	hl, #0x0008
	add	hl, de
	ld	c, (hl)
	ld	b, #0x00
;src/battle.c:41: if (p->status & 0x80u) { a += a >> 1; if (a > 255u) a = 255u; }
	ld	a, (de)
	ld	e, a
	bit	7, e
	jr	Z, 00104$
	ld	l, c
	ld	h, b
	srl	h
	rr	l
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	d, c
	ld	l, b
	ld	a, #0xff
	cp	a, d
	ld	a, #0x00
	sbc	a, l
	jr	NC, 00104$
	ld	bc, #0x00ff
00104$:
;src/battle.c:42: if (enemy && (p->status & 0x40u)) a -= a >> 2;
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	bit	6, e
	jr	Z, 00106$
	ld	e, c
	ld	d, b
	srl	d
	rr	e
	srl	d
	rr	e
	ld	a, c
	sub	a, e
	ld	c, a
00106$:
;src/battle.c:43: return (uint8_t)a;
	ld	a, c
;src/battle.c:44: }
	inc	sp
	ret
;src/battle.c:45: static void record_damage(RPGBattle *b, uint8_t target, uint8_t damage) {
;	---------------------------------
; Function record_damage
; ---------------------------------
_record_damage:
	add	sp, #-3
	ldhl	sp,	#1
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
;src/battle.c:46: uint16_t n = (uint16_t)b->last_damage + damage;
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0092
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#5
	ld	c, (hl)
	ld	l, a
	ld	h, #0x00
	ld	b, h
	add	hl, bc
;src/battle.c:47: b->last_damage = n > 255u ? 255u : (uint8_t)n;
	ld	c, l
	ld	b, h
	ld	a, #0xff
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00103$
	ld	a, #0xff
	jr	00104$
00103$:
	ld	a, l
00104$:
	ld	(de), a
;src/battle.c:48: b->last_target = target;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0091
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(bc), a
;src/battle.c:49: }
	add	sp, #3
	pop	hl
	inc	sp
	jp	(hl)
;src/battle.c:50: static void damage(RPGBattle *b, RPGCharacter *p, uint8_t target, uint8_t amount) {
;	---------------------------------
; Function damage
; ---------------------------------
_damage:
	add	sp, #-4
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	inc	sp
	inc	sp
;src/battle.c:51: uint8_t lost = amount < p->hp ? amount : p->hp;
	ld	e, c
	ld	d, b
	push	de
	inc	de
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, c
	jr	NC, 00105$
	ld	b, (hl)
	jr	00106$
00105$:
	ld	b, c
00106$:
;src/battle.c:52: p->hp -= lost;
	ld	a, c
;src/battle.c:53: if (!p->hp) { p->status = 0; p->bound = 0; }
	sub	a, b
	ld	(de), a
	jr	NZ, 00102$
	pop	hl
	ld	(hl), #0x00
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #0x000d
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	(de), a
00102$:
;src/battle.c:54: record_damage(b, target, lost);
	push	bc
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_record_damage
;src/battle.c:55: }
	add	sp, #4
	pop	hl
	pop	af
	jp	(hl)
;src/battle.c:56: static void signed_damage(RPGBattle *b, RPGCharacter *p, uint8_t target, uint8_t delta) {
;	---------------------------------
; Function signed_damage
; ---------------------------------
_signed_damage:
	add	sp, #-7
	ldhl	sp,	#5
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#3
	ld	a, c
	ld	(hl+), a
;src/battle.c:59: uint8_t old = p->hp;
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#0
	ld	(hl), a
;src/battle.c:60: uint16_t sum = (uint16_t)old + delta;
	ldhl	sp,	#10
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
;src/battle.c:61: p->hp = sum > 255u ? (uint8_t)sum : 0u;
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	l, e
	ld	h, d
	ld	a, #0xff
	cp	a, l
	ld	a, #0x00
	sbc	a, h
	jr	NC, 00105$
	ld	a, e
	jr	00106$
00105$:
	xor	a, a
00106$:
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/battle.c:62: if (!p->hp) { p->status = 0; p->bound = 0; }
	ld	a, (bc)
	or	a, a
	jr	NZ, 00102$
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	(de), a
00102$:
;src/battle.c:63: record_damage(b, target, old - p->hp);
	ld	a, (bc)
	ld	c, a
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, c
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_record_damage
;src/battle.c:64: }
	add	sp, #7
	pop	hl
	pop	af
	jp	(hl)
;src/battle.c:65: static uint8_t decay_binding(RPGState *s, RPGBattle *b, RPGCharacter *p) {
;	---------------------------------
; Function decay_binding
; ---------------------------------
_decay_binding:
	add	sp, #-8
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#4
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle.c:67: if (!p->bound) return 0;
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x000d
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	or	a, a
	jr	NZ, 00102$
	xor	a, a
	jr	00103$
00102$:
;src/battle.c:68: d = (rpg_random(s) & 1u) + 1u;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x01
	inc	a
	ldhl	sp,	#2
;src/battle.c:69: p->bound = p->bound > d ? p->bound - d : 0u;
	ld	(hl+), a
	pop	bc
	push	bc
	pop	de
	push	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, (hl)
	jr	NC, 00105$
	ld	a, (hl-)
	sub	a, (hl)
	jr	00106$
00105$:
	xor	a, a
00106$:
	ld	(bc), a
;src/battle.c:70: b->last_effect = p->bound ? BATTLE_EFFECT_BOUND : BATTLE_EFFECT_RECOVERED;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	a, (de)
	or	a, a
	ld	a, #0x04
	jr	NZ, 00108$
	ld	a, #0x05
00108$:
	ld	(bc), a
;src/battle.c:71: return 1; /* Recovery consumes this turn too. */
	ld	a, #0x01
00103$:
;src/battle.c:72: }
	add	sp, #8
	pop	hl
	pop	bc
	jp	(hl)
;src/battle.c:73: static void decay_barrier(RPGState *s, RPGBattle *b) {
;	---------------------------------
; Function decay_barrier
; ---------------------------------
_decay_barrier:
;src/battle.c:75: if (!(b->enemy_flags & 0x10u)) { b->barrier = 0; return; }
	ld	hl, #0x009b
	add	hl, bc
	ld	l, (hl)
	ld	a, c
	add	a, #0x83
	ld	c, a
	jr	NC, 00130$
	inc	b
00130$:
	bit	4, l
	jr	NZ, 00102$
	xor	a, a
	ld	(bc), a
	ret
00102$:
;src/battle.c:76: d = rpg_random(s) & 3u;
	push	bc
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	and	a, #0x03
	ld	e, a
;src/battle.c:77: n = b->barrier & 0x7fu;
	ld	a, (bc)
	ld	l, a
	and	a, #0x7f
	ld	d, a
;src/battle.c:78: n = n > d ? n - d : 0u;
	ld	a, e
	sub	a, d
	jr	NC, 00105$
	ld	a, d
	sub	a, e
	jr	00106$
00105$:
	xor	a, a
00106$:
;src/battle.c:79: b->barrier = n ? (b->barrier & 0x80u) | n : 0u;
	ld	e, a
	or	a, a
	jr	Z, 00107$
	ld	a, l
	and	a, #0x80
	or	a, e
	jr	00108$
00107$:
	xor	a, a
00108$:
	ld	(bc), a
;src/battle.c:80: }
	ret
;src/battle.c:81: static void check_outcome(RPGState *s, RPGBattle *b) {
;	---------------------------------
; Function check_outcome
; ---------------------------------
_check_outcome:
	add	sp, #-14
	ldhl	sp,	#10
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#8
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle.c:82: uint8_t c, hp = 0, status = 0;
	ld	b, #0x00
	ldhl	sp,	#12
	ld	(hl), #0x00
;src/battle.c:83: if (b->outcome != RPG_ONGOING) return;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0082
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	or	a, a
;src/battle.c:85: for (c = 0; c != 8; ++c) hp |= b->enemies[c].hp;
	jp	NZ, 00115$
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	c, #0x00
00111$:
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, de
	inc	hl
	ld	a, (hl)
	or	a, b
	ld	b, a
	inc	c
	ld	a, c
;src/battle.c:86: if (!hp) { b->outcome = RPG_VICTORY; return; }
	sub	a, #0x08
	jr	NZ, 00111$
	or	a, b
	jr	NZ, 00122$
	pop	hl
	ld	(hl), #0x01
	push	hl
	jr	00115$
;src/battle.c:87: for (c = 0; c != 4; ++c) if (s->joined_mask & (1u << c)) status |= s->party[c].status;
00122$:
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0059
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#13
	ld	(hl), #0x00
00113$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#13
	ld	b, (hl)
	ld	de, #0x0001
	inc	b
	jr	00178$
00177$:
	sla	e
	rl	d
00178$:
	dec	b
	jr	NZ,00177$
	and	a, e
	ld	c, #0x00
	or	a, c
	jr	Z, 00114$
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#7
	ld	l, (hl)
	ld	h, #0x00
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
	ld	c, a
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, c
	ld	(hl), a
00114$:
	ldhl	sp,	#13
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00113$
;src/battle.c:88: if (!status) b->outcome = RPG_DEFEAT;
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	jr	NZ, 00115$
	pop	hl
	ld	(hl), #0x02
	push	hl
00115$:
;src/battle.c:89: }
	add	sp, #14
	ret
;src/battle.c:90: static void physical(RPGState *s, RPGBattle *b, RPGCharacter *a, RPGCharacter *d, uint8_t target, uint8_t enemy) {
;	---------------------------------
; Function physical
; ---------------------------------
_physical:
	add	sp, #-5
	ldhl	sp,	#3
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle.c:91: uint8_t hit = rpg_physical_damage(s, boost(a, enemy), d->defense, enemy ? d->level : a->level, enemy);
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	inc	hl
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	ld	hl, #0x0005
	add	hl, bc
	ld	d, (hl)
	jr	00104$
00103$:
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	d, (hl)
00104$:
	ld	hl, #0x0009
	add	hl, bc
	ld	e, (hl)
	push	bc
	push	de
	ldhl	sp,	#16
	ld	a, (hl)
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_boost
	pop	de
	pop	bc
	push	bc
	ldhl	sp,	#14
	ld	h, (hl)
	push	hl
	inc	sp
	push	de
	inc	sp
	ld	h, e
	push	hl
	inc	sp
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_physical_damage
	ld	hl, #_rpg_physical_damage
	call	___sdcc_bcall_ehl
	add	sp, #6
	ldhl	sp,	#2
	ld	(hl), a
	pop	bc
;src/battle.c:92: b->last_effect = hit ? BATTLE_EFFECT_ATTACK : BATTLE_EFFECT_MISS;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00106$
	ld	a, #0x02
00106$:
	ld	(de), a
;src/battle.c:93: damage(b, d, target, hit);
	ldhl	sp,	#0
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#12
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_damage
;src/battle.c:94: }
	add	sp, #5
	pop	hl
	add	sp, #6
	jp	(hl)
;src/battle.c:95: uint8_t rpg_battle_begin(RPGState *s, RPGBattle *b, uint8_t enemy) RPG_BANKED {
;	---------------------------------
; Function rpg_battle_begin
; ---------------------------------
	b_rpg_battle_begin	= 18
_rpg_battle_begin::
	add	sp, #-42
;src/battle.c:97: if (!party_count(s) || rpg_enemy_record(enemy & 0x7fu, data)) return RPG_INVALID;
	ldhl	sp,	#48
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_party_count
	ld	c, a
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#52
	ld	c, (hl)
	ld	a, c
	and	a, #0x7f
	ld	d, a
	push	bc
	ld	hl, #2
	add	hl, sp
	push	hl
	push	de
	inc	sp
	ld	e, #b_rpg_enemy_record
	ld	hl, #_rpg_enemy_record
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	or	a, a
	jr	Z, 00102$
00101$:
	ld	a, #0x01
	jp	00126$
00102$:
;src/battle.c:98: memset(b, 0, sizeof(*b));
	ldhl	sp,	#50
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00b3
	push	hl
	ld	l, h
	push	hl
	push	de
	call	_memset
	add	sp, #6
;src/battle.c:99: b->enemy_id = enemy;
	ldhl	sp,	#50
	ld	a, (hl)
	ldhl	sp,	#32
	ld	(hl), a
	ldhl	sp,	#51
	ld	a, (hl)
	ldhl	sp,	#33
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0080
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
;src/battle.c:100: b->enemy_flags = data[30]; b->run_chance = data[31];
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009b
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#30
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009c
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#31
	ld	a, (hl)
	ld	(bc), a
;src/battle.c:101: n = data[20];
	ldhl	sp,	#20
	ld	c, (hl)
;src/battle.c:102: if (!(n & 0x80u)) {
	bit	7, c
	jr	NZ, 00112$
;src/battle.c:103: max_count = party_count(s) * 2u;
	push	bc
	ldhl	sp,	#50
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_party_count
	pop	bc
	add	a, a
	ld	e, a
;src/battle.c:104: if ((n & 15u) < max_count) max_count = n & 15u;
	ld	a, c
	and	a, #0x0f
	ld	b, e
	sub	a, b
	jr	NC, 00105$
	ld	a, c
	and	a, #0x0f
	ld	e, a
00105$:
;src/battle.c:105: if (!max_count) return RPG_INVALID;
	ld	a, e
	or	a, a
	jr	NZ, 00108$
	ld	a, #0x01
	jp	00126$
;src/battle.c:106: do { n = rpg_random(s) & 7u; } while (n >= max_count);
00108$:
	push	de
	ldhl	sp,	#50
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	de
	and	a, #0x07
	cp	a, e
	jr	NC, 00108$
;src/battle.c:107: ++n;
	ld	c, a
	inc	c
00112$:
;src/battle.c:109: n &= 15u;
	ld	a, c
	and	a, #0x0f
;src/battle.c:110: if (!n || n > 8u) return RPG_INVALID;
	ld	c, a
	or	a, a
	jr	Z, 00113$
	ld	a, #0x08
	sub	a, c
	jr	NC, 00114$
00113$:
	ld	a, #0x01
	jp	00126$
00114$:
;src/battle.c:111: b->count = n;
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0081
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
;src/battle.c:112: for (c = 0; c < n; ++c) {
	ldhl	sp,	#32
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#41
	ld	(hl), #0x00
00122$:
	ldhl	sp,	#41
;src/battle.c:113: b->enemies[c].status = 1;
	ld	a,(hl)
	cp	a,c
	jp	NC,00116$
	swap	a
	and	a, #0xf0
	ld	b, a
	ldhl	sp,#34
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, b
	ld	h, #0x00
	add	hl, de
	ld	(hl), #0x01
;src/battle.c:114: b->enemies[c].hp = b->enemies[c].max_hp = data[21];
	ld	e, b
	ld	d, #0x00
	ldhl	sp,	#32
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#38
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#37
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#40
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#39
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	b, l
	push	hl
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#42
	ld	(hl), a
	pop	af
	ld	e, b
	ld	d, a
	ld	a, (hl-)
	dec	hl
	ld	(de), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl)
	ld	(de), a
;src/battle.c:115: b->enemies[c].attack = data[22]; b->enemies[c].defense = data[23];
	ldhl	sp,#36
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	b, l
	push	hl
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#42
	ld	(hl), a
	pop	af
	ld	e, b
	ld	d, a
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#36
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	b, l
	push	hl
	ldhl	sp,	#25
	ld	a, (hl)
	ldhl	sp,	#42
	ld	(hl), a
	pop	af
	ld	e, b
	ld	d, a
;src/battle.c:112: for (c = 0; c < n; ++c) {
	ld	a, (hl+)
	ld	(de), a
	inc	(hl)
	jp	00122$
00116$:
;src/battle.c:117: b->item_reward = data[24]; b->trap_chance = data[27];
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0098
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #24
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0099
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #27
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
;src/battle.c:118: b->money_reward = ((uint16_t)data[25] | ((uint16_t)data[26] << 8)) * n;
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0096
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #25
	add	hl, sp
	ld	a, (hl)
	ldhl	sp,	#40
	ld	(hl+), a
	ld	(hl), #0x00
	ld	hl, #26
	add	hl, sp
	ld	a, (hl)
	ldhl	sp,	#40
	ld	l, (hl)
	ld	h, a
	ld	b, #0x00
	push	bc
	push	de
	ld	e, l
	ld	d, h
	call	__mulint
	ld	l, c
	ld	h, b
	pop	de
	pop	bc
	ld	a, l
	ld	(de), a
	inc	de
	ld	a, h
	ld	(de), a
;src/battle.c:119: b->exp_reward = ((uint16_t)data[28] | ((uint16_t)data[29] << 8)) * n;
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0094
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#42
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#41
	ld	(hl), a
	ldhl	sp,	#28
	ld	e, (hl)
	ld	hl, #29
	add	hl, sp
	ld	d, (hl)
	call	__mulint
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle.c:120: for (c = 0; c != 12; ++c) b->turn_order[c] = c;
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0084
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#41
	ld	(hl), #0x00
00124$:
	ldhl	sp,	#41
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#41
	ld	a, (hl)
	ld	(de), a
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0c
	jr	NZ, 00124$
;src/battle.c:121: b->turn_cursor = 12;
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009f
	add	hl, de
	ld	c, l
	ld	(hl), #0x0c
;src/battle.c:122: b->last_actor = b->last_target = RPG_NO_SLOT;
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0090
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0091
	add	hl, de
	ld	a,#0xff
	ld	(hl),a
	ld	(bc), a
;src/battle.c:125: if (!living_party(s) || !(s->party[0].hp | s->party[1].hp | s->party[2].hp | s->party[3].hp)) b->outcome = RPG_VICTORY;
	ldhl	sp,	#48
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_living_party
	or	a, a
	jr	Z, 00118$
	ldhl	sp,	#48
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	ld	c, (hl)
	ld	hl, #0x0011
	add	hl, de
	ld	a, (hl)
	or	a, c
	ld	c, a
	ld	hl, #0x0021
	add	hl, de
	ld	a, (hl)
	or	a, c
	ld	c, a
	ld	hl, #0x0031
	add	hl, de
	ld	a, (hl)
	or	a, c
	or	a, a
	jr	NZ, 00119$
00118$:
	ldhl	sp,#32
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0082
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x01
00119$:
;src/battle.c:126: return RPG_OK;
	xor	a, a
00126$:
;src/battle.c:127: }
	add	sp, #42
	ret
;src/battle.c:128: uint8_t rpg_try_run(RPGState *s, RPGBattle *b) RPG_BANKED {
;	---------------------------------
; Function rpg_try_run
; ---------------------------------
	b_rpg_try_run	= 18
_rpg_try_run::
	dec	sp
	dec	sp
;src/battle.c:129: if (b->outcome != RPG_ONGOING) return RPG_INVALID;
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0082
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	or	a, a
	jr	Z, 00102$
	ld	a, #0x01
	jr	00106$
00102$:
;src/battle.c:130: if (rpg_random(s) < b->run_chance && !b->escape_blocked) {
	push	bc
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, a
	pop	bc
	ld	hl, #0x009c
	add	hl, bc
	ld	d, (hl)
;src/battle.c:131: b->outcome = RPG_ESCAPED; b->last_effect = BATTLE_EFFECT_ESCAPE;
	ld	hl, #0x00a0
	add	hl, bc
;src/battle.c:130: if (rpg_random(s) < b->run_chance && !b->escape_blocked) {
	ld	a, e
	sub	a, d
	jr	NC, 00104$
	ld	a, c
	add	a, #0x9d
	ld	e, a
	ld	a, b
	adc	a, #0x00
	ld	d, a
	ld	a, (de)
	or	a, a
	jr	NZ, 00104$
;src/battle.c:131: b->outcome = RPG_ESCAPED; b->last_effect = BATTLE_EFFECT_ESCAPE;
	push	hl
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
	pop	hl
	ld	(hl), #0x0f
;src/battle.c:132: rpg_refresh_stats(s);
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
;src/battle.c:133: return RPG_OK;
	xor	a, a
	jr	00106$
00104$:
;src/battle.c:135: b->suppress_party = 1;
	ld	a, c
	add	a, #0x9e
	ld	c, a
	jr	NC, 00129$
	inc	b
00129$:
	ld	a, #0x01
	ld	(bc), a
;src/battle.c:136: b->last_effect = BATTLE_EFFECT_NO_EFFECT;
	ld	(hl), #0x11
;src/battle.c:137: return RPG_ACTION_FAILED;
	ld	a, #0x0a
00106$:
;src/battle.c:138: }
	inc	sp
	inc	sp
	ret
;src/battle.c:139: uint8_t rpg_battle_talk(RPGState *s, RPGBattle *b, uint8_t mode) RPG_BANKED {
;	---------------------------------
; Function rpg_battle_talk
; ---------------------------------
	b_rpg_battle_talk	= 18
_rpg_battle_talk::
	add	sp, #-12
;src/battle.c:140: uint8_t monster = 0, n;
	ldhl	sp,	#0
	ld	(hl), #0x00
;src/battle.c:141: if (b->outcome != RPG_ONGOING || mode > 2u) return RPG_INVALID;
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0082
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#11
	ld	(hl), a
	or	a, a
	jr	NZ, 00101$
	ld	a, #0x02
	ldhl	sp,	#22
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	ld	a, #0x01
	jp	00121$
00102$:
;src/battle.c:143: if (!(b->enemy_flags & 0x80u) || s->party[0].attack < b->enemies[0].attack) goto failed;
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009b
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl), a
;src/battle.c:153: b->outcome = RPG_TALKED; b->last_effect = BATTLE_EFFECT_TALK;
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl), a
;src/battle.c:143: if (!(b->enemy_flags & 0x80u) || s->party[0].attack < b->enemies[0].attack) goto failed;
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
;src/battle.c:142: if (!mode) {
	ldhl	sp,	#22
	ld	a, (hl)
	or	a, a
	jr	NZ, 00115$
;src/battle.c:143: if (!(b->enemy_flags & 0x80u) || s->party[0].attack < b->enemies[0].attack) goto failed;
	push	hl
	ldhl	sp,	#11
	bit	7, (hl)
	pop	hl
	jp	Z, 00120$
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b, a
	ld	a, c
	sub	a, b
	jr	NC, 00117$
	jp	00120$
00115$:
;src/battle.c:145: if (!(b->enemy_flags & 0xc0u)) goto failed;
	ldhl	sp,	#9
	ld	a, (hl)
	and	a, #0xc0
	jp	Z, 00120$
;src/battle.c:146: if (b->enemy_flags & 0x40u) {
	push	hl
	ldhl	sp,	#11
	bit	6, (hl)
	pop	hl
	jr	Z, 00117$
;src/battle.c:147: if (mode == 1u && s->party[0].attack < b->enemies[0].attack) goto failed;
	ldhl	sp,	#22
	ld	a, (hl)
	dec	a
	jr	NZ, 00110$
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b, a
	ld	a, c
	sub	a, b
	jr	C, 00120$
00110$:
;src/battle.c:148: monster = 1;
	ldhl	sp,	#0
	ld	(hl), #0x01
;src/battle.c:151: do { n = rpg_random(s) & 15u; } while (n >= (monster ? 10u : 9u));
00117$:
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x0f
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	ld	c, #0x0a
	jr	NZ, 00124$
	ld	c, #0x09
00124$:
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, c
	jr	NC, 00117$
;src/battle.c:152: b->talk_index = n + (monster ? 9u : 0u);
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a1
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	ld	a, #0x09
	jr	NZ, 00126$
	xor	a, a
00126$:
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#9
	add	a, (hl)
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (hl)
	ld	(de), a
;src/battle.c:153: b->outcome = RPG_TALKED; b->last_effect = BATTLE_EFFECT_TALK;
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x04
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x10
;src/battle.c:154: rpg_refresh_stats(s);
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
;src/battle.c:155: return RPG_OK;
	xor	a, a
	jr	00121$
;src/battle.c:156: failed:
00120$:
;src/battle.c:157: b->suppress_party = 1;
	ldhl	sp,#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009e
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;src/battle.c:158: b->last_effect = BATTLE_EFFECT_NO_EFFECT;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x11
;src/battle.c:159: return RPG_ACTION_FAILED;
	ld	a, #0x0a
00121$:
;src/battle.c:160: }
	add	sp, #12
	ret
;src/battle.c:161: static uint8_t validate_action(const RPGState *s, uint8_t c, const RPGAction *a) {
;	---------------------------------
; Function validate_action
; ---------------------------------
_validate_action:
	add	sp, #-5
	ld	c, e
	ld	b, d
	ldhl	sp,	#4
	ld	(hl), a
;src/battle.c:162: if (!party_alive(s, c) || !s->party[c].hp || s->party[c].bound) return RPG_OK;
	push	bc
	ld	a, (hl)
	ld	e, c
	ld	d, b
	call	_party_alive
	pop	bc
	or	a, a
	jr	Z, 00101$
	ldhl	sp,	#4
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
	inc	de
	ld	a, (de)
	or	a, a
	jr	Z, 00101$
	pop	de
	push	de
	ld	hl, #0x000d
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	Z, 00102$
00101$:
	xor	a, a
	jp	00133$
00102$:
;src/battle.c:163: if (a->kind == RPG_ACT_MAGIC) {
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
;src/battle.c:164: if (!rpg_knows_spell(s, c, a->id, 1)) return RPG_NOT_LEARNED;
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	de
;src/battle.c:163: if (a->kind == RPG_ACT_MAGIC) {
	cp	a, #0x03
	jr	NZ, 00131$
;src/battle.c:164: if (!rpg_knows_spell(s, c, a->id, 1)) return RPG_NOT_LEARNED;
	ld	a, (de)
	push	bc
	push	de
	ld	h, #0x01
	push	hl
	inc	sp
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_knows_spell
	ld	hl, #_rpg_knows_spell
	call	___sdcc_bcall_ehl
	add	sp, #5
	pop	de
	pop	bc
	or	a, a
	jr	NZ, 00106$
	ld	a, #0x07
	jp	00133$
00106$:
;src/battle.c:165: if (s->party[c].mp < rpg_magic_cost(a->id)) return RPG_NO_MP;
	pop	hl
	push	hl
	inc	hl
	inc	hl
	ld	h, (hl)
	ld	a, (de)
	push	hl
	push	bc
	push	de
	push	af
	inc	sp
	ld	e, #b_rpg_magic_cost
	ld	hl, #_rpg_magic_cost
	call	___sdcc_bcall_ehl
	inc	sp
	ld	l, a
	pop	de
	pop	bc
	pop	af
	sub	a, l
	jr	NC, 00108$
	ld	a, #0x06
	jr	00133$
00108$:
;src/battle.c:166: if (a->id == MagicID_Heal || a->id == MagicID_Cure || a->id == MagicID_Help)
	ld	a, (de)
	cp	a, #0x01
	jr	Z, 00112$
	cp	a, #0x02
	jr	Z, 00112$
	sub	a, #0x0a
	jr	NZ, 00132$
00112$:
;src/battle.c:167: if (a->target >= 4u || !party_alive(s, a->target)) return RPG_DEAD;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	ld	a, (de)
	cp	a, #0x04
	jr	NC, 00109$
	ld	e, c
	ld	d, b
	call	_party_alive
	or	a, a
	jr	NZ, 00132$
00109$:
	ld	a, #0x05
	jr	00133$
00131$:
;src/battle.c:168: } else if (a->kind == RPG_ACT_ITEM) {
	cp	a, #0x04
	jr	NZ, 00128$
;src/battle.c:169: if (rpg_find_item(s, a->id) == RPG_NO_SLOT) return RPG_INVALID;
	ld	a, (de)
	push	de
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	inc	a
	jr	NZ, 00117$
	ld	a, #0x01
	jr	00133$
00117$:
;src/battle.c:172: if ((a->id >= ItemID_Landrover && a->id <= ItemID_IceDigger) ||
	ld	a, (de)
	cp	a, #0x21
	jr	C, 00121$
	cp	a, #0x24
	jr	C, 00118$
00121$:
;src/battle.c:173: a->id == ItemID_DungeonKey || a->id == ItemID_MiracleKey || a->id == ItemID_Nuts) return RPG_NOT_IMPLEMENTED;
	cp	a, #0x2d
	jr	Z, 00118$
	cp	a, #0x3e
	jr	Z, 00118$
	sub	a, #0x31
	jr	NZ, 00132$
00118$:
	ld	a, #0x08
	jr	00133$
00128$:
;src/battle.c:174: } else if (a->kind > RPG_ACT_RUN || a->kind == 2u) return RPG_INVALID;
	cp	a, #0x07
	jr	NC, 00124$
	sub	a, #0x02
	jr	NZ, 00132$
00124$:
	ld	a, #0x01
	jr	00133$
00132$:
;src/battle.c:175: return RPG_OK;
	xor	a, a
00133$:
;src/battle.c:176: }
	add	sp, #5
	pop	hl
	pop	bc
	jp	(hl)
;src/battle.c:177: uint8_t rpg_battle_prepare(RPGState *s, RPGBattle *b, const RPGAction actions[4]) RPG_BANKED {
;	---------------------------------
; Function rpg_battle_prepare
; ---------------------------------
	b_rpg_battle_prepare	= 18
_rpg_battle_prepare::
	add	sp, #-16
;src/battle.c:179: if (b->outcome != RPG_ONGOING || b->turn_cursor != 12u) return RPG_INVALID;
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0082
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
	or	a, a
	jr	NZ, 00101$
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009f
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x0c
	jr	Z, 00102$
00101$:
	ld	a, #0x01
	jp	00132$
00102$:
;src/battle.c:180: b->suppress_party = 0; b->last_error = RPG_OK; b->last_effect = BATTLE_EFFECT_NONE;
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009e
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0093
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
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/battle.c:181: for (c = 0; c != 4; ++c) {
	ldhl	sp,	#8
	ld	(hl), #0x00
	ldhl	sp,	#15
	ld	(hl), #0x00
00129$:
;src/battle.c:182: error = validate_action(s, c, &actions[c]);
	ldhl	sp,	#15
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#26
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
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
	push	de
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#24
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_validate_action
;src/battle.c:183: if (error) { b->last_error = error; return error; }
	or	a, a
	jr	Z, 00105$
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jp	00132$
00105$:
;src/battle.c:184: if (!party_alive(s, c) || !s->party[c].hp || s->party[c].bound) continue;
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#22
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_party_alive
	or	a, a
	jp	Z, 00121$
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#11
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
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	or	a, a
	jp	Z, 00121$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jp	NZ, 00121$
;src/battle.c:185: if (actions[c].kind == RPG_ACT_RUN || actions[c].kind == RPG_ACT_TALK ||
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	cp	a, #0x06
	jr	Z, 00115$
	cp	a, #0x05
	jr	Z, 00115$
;src/battle.c:186: (actions[c].kind == RPG_ACT_MAGIC && (actions[c].id == MagicID_Chat || actions[c].id == MagicID_Tele))) {
	sub	a, #0x03
	jp	NZ, 00121$
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	cp	a, #0x10
	jr	Z, 00115$
	sub	a, #0x11
	jp	NZ, 00121$
00115$:
;src/battle.c:187: b->last_actor = c;
	pop	de
	push	de
	ld	hl, #0x0090
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(bc), a
;src/battle.c:188: if (actions[c].kind == RPG_ACT_RUN) error = rpg_try_run(s, b);
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#26
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	sub	a, #0x06
	jr	NZ, 00113$
	pop	de
	push	de
	push	de
	ldhl	sp,	#13
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_try_run
	ld	hl, #_rpg_try_run
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#15
	ld	(hl), a
	jp	00114$
00113$:
;src/battle.c:190: t = 0;
	ldhl	sp,	#15
	ld	(hl), #0x00
;src/battle.c:191: if (actions[c].kind == RPG_ACT_MAGIC) {
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00111$
;src/battle.c:192: s->party[c].mp -= rpg_magic_cost(actions[c].id);
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
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
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#13
	ld	(hl), a
	ldhl	sp,#7
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
	push	af
	inc	sp
	ld	e, #b_rpg_magic_cost
	ld	hl, #_rpg_magic_cost
	call	___sdcc_bcall_ehl
	inc	sp
	ld	c, a
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, c
	ldhl	sp,	#9
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/battle.c:193: t = actions[c].id == MagicID_Chat ? 1u : 2u;
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x10
	jr	NZ, 00134$
	ld	(hl), #0x01
	jr	00135$
00134$:
	ldhl	sp,	#15
	ld	(hl), #0x02
00135$:
00111$:
;src/battle.c:195: error = rpg_battle_talk(s, b, t);
	ldhl	sp,	#15
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#14
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_talk
	ld	hl, #_rpg_battle_talk
	call	___sdcc_bcall_ehl
	add	sp, #5
	ldhl	sp,	#15
	ld	(hl), a
00114$:
;src/battle.c:197: b->last_error = error;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#15
	ld	a, (hl)
	ld	(de), a
;src/battle.c:198: break; /* Source skips the remaining party selections. */
	jr	00122$
00121$:
;src/battle.c:181: for (c = 0; c != 4; ++c) {
	ldhl	sp,	#15
	inc	(hl)
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x04
	jp	NZ, 00129$
00122$:
;src/battle.c:201: if (b->outcome != RPG_ONGOING) return RPG_OK;
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#13
	ld	(hl), a
	ldhl	sp,	#25
	ld	a, (hl)
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00124$
	xor	a, a
	jr	00132$
00124$:
;src/battle.c:202: memcpy(b->actions, actions, sizeof(b->actions));
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a7
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x000c
	push	hl
	call	_memcpy
;src/battle.c:206: do { j = rpg_random(s) & 15u; } while (j >= 12u);
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0084
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#15
	ld	(hl), #0x00
00125$:
	ldhl	sp,	#22
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x0f
	ld	e, a
	sub	a, #0x0c
	jr	NC, 00125$
;src/battle.c:207: t = b->turn_order[c]; b->turn_order[c] = b->turn_order[j]; b->turn_order[j] = t;
	push	de
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#17
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#12
	ld	(hl-), a
	ld	d, #0x00
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,	#12
	ld	a, (hl)
	ld	(de), a
;src/battle.c:205: for (c = 0; c != 12; ++c) {
	ldhl	sp,	#15
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0c
	jr	NZ, 00125$
;src/battle.c:209: b->turn_cursor = 0;
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009f
	add	hl, de
	ld	c, l
	ld	b, h
;src/battle.c:210: return RPG_OK;
	xor	a, a
	ld	(bc), a
00132$:
;src/battle.c:211: }
	add	sp, #16
	ret
;src/battle.c:212: static void enemy_physical(RPGState *s, RPGBattle *b, RPGCharacter *enemy) {
;	---------------------------------
; Function enemy_physical
; ---------------------------------
_enemy_physical:
	add	sp, #-5
	ldhl	sp,	#3
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;src/battle.c:214: if (b->barrier) decay_barrier(s, b);
	ld	hl, #0x0083
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	or	a, a
	jr	Z, 00102$
	push	bc
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_decay_barrier
	pop	bc
00102$:
;src/battle.c:215: c = choose_party(s); if (c == RPG_NO_SLOT) return;
	push	bc
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_choose_party
	ldhl	sp,	#4
	ld	(hl), a
	pop	bc
	ldhl	sp,	#2
	ld	a, (hl)
	inc	a
	jr	Z, 00114$
;src/battle.c:216: b->last_target = c;
	ld	hl, #0x0091
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(de), a
;src/battle.c:217: if (b->barrier) { b->last_effect = BATTLE_EFFECT_BLOCKED; return; }
	pop	de
	push	de
	ld	a, (de)
	or	a, a
	jr	Z, 00106$
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x03
	jr	00114$
00106$:
;src/battle.c:218: physical(s, b, enemy, &s->party[c], c, 1);
	ldhl	sp,	#2
	ld	a, (hl+)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	push	de
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_physical
	pop	de
;src/battle.c:220: if (!alive(&s->party[c]) && b->enemy_id == EnemyID_GdDragn && c == 1u)
	call	_alive
	pop	bc
	or	a, a
	jr	NZ, 00114$
	ld	hl, #0x0080
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x46
	jr	NZ, 00114$
	ldhl	sp,	#2
	ld	a, (hl)
	dec	a
	jr	NZ, 00114$
;src/battle.c:221: for (c = 0; c != 4; ++c) s->party[c].status = 0;
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, #0x00
00112$:
	ld	a, e
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	(hl), #0x00
	inc	e
	ld	a, e
	sub	a, #0x04
	jr	NZ, 00112$
00114$:
;src/battle.c:222: }
	add	sp, #5
	pop	hl
	pop	af
	jp	(hl)
;src/battle.c:223: static void enemy_fire(RPGState *s, RPGBattle *b) {
;	---------------------------------
; Function enemy_fire
; ---------------------------------
_enemy_fire:
	add	sp, #-8
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#4
	ld	a, c
	ld	(hl+), a
;src/battle.c:225: if (b->barrier & 0x80u) decay_barrier(s, b);
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0083
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	rlca
	jr	NC, 00102$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_decay_barrier
00102$:
;src/battle.c:226: c = choose_party(s); if (c == RPG_NO_SLOT) return;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_choose_party
	ldhl	sp,#2
	ld	(hl), a
	inc	a
	jr	Z, 00108$
;src/battle.c:227: d = 10u - (rpg_random(s) & 3u);
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x03
	ld	c, a
	ld	a, #0x0a
	sub	a, c
	ldhl	sp,	#3
;src/battle.c:228: b->last_target = c; b->last_effect = BATTLE_EFFECT_FIRE;
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0091
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x08
;src/battle.c:229: if (!(b->barrier & 0x80u)) damage(b, &s->party[c], c, d);
	pop	de
	push	de
	ld	a, (de)
	rlca
	jr	C, 00106$
	ldhl	sp,	#2
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl-)
	ld	d, a
	ld	a, (hl+)
	inc	hl
	ld	e, a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_damage
	jr	00108$
00106$:
;src/battle.c:230: else b->last_effect = BATTLE_EFFECT_BLOCKED;
	ld	a, #0x03
	ld	(bc), a
00108$:
;src/battle.c:231: }
	add	sp, #8
	ret
;src/battle.c:232: static void enemy_group(RPGState *s, RPGBattle *b, RPGCharacter *enemy, uint8_t base) {
;	---------------------------------
; Function enemy_group
; ---------------------------------
_enemy_group:
	add	sp, #-14
	ldhl	sp,	#11
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#9
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle.c:234: for (c = 0; c != 4; ++c) {
	ldhl	sp,	#18
	ld	a, (hl)
	inc	a
	ld	a, #0x01
	jr	Z, 00153$
	xor	a, a
00153$:
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0083
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#13
	ld	(hl), #0x00
00113$:
;src/battle.c:235: if (b->barrier & 0x80u) decay_barrier(s, b);
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	rlca
	jr	NC, 00102$
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_decay_barrier
00102$:
;src/battle.c:236: if (!party_alive(s, c)) continue;
	ldhl	sp,	#13
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_party_alive
	or	a, a
	jp	Z, 00111$
;src/battle.c:237: if (base == 255u) physical(s, b, enemy, &s->party[c], c, 1);
	ldhl	sp,	#13
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	c, a
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00109$
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#14
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ldhl	sp,	#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_physical
	jr	00111$
00109$:
;src/battle.c:238: else if (!(b->barrier & 0x80u)) signed_damage(b, &s->party[c], c, base + (rpg_random(s) & 15u));
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	rlca
	jr	C, 00106$
	push	bc
	ldhl	sp,	#13
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	and	a, #0x0f
	ldhl	sp,	#18
	add	a, (hl)
	ld	b, a
	ld	e, c
	ld	d, #0x00
	ldhl	sp,	#3
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	inc	sp
	ldhl	sp,	#14
	ld	a, (hl)
	push	af
	inc	sp
	ld	c, e
	ld	b, d
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_signed_damage
	jr	00111$
00106$:
;src/battle.c:239: else b->last_effect = BATTLE_EFFECT_BLOCKED;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x03
00111$:
;src/battle.c:234: for (c = 0; c != 4; ++c) {
	ldhl	sp,	#13
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jp	NZ, 00113$
;src/battle.c:241: }
	add	sp, #14
	pop	hl
	add	sp, #3
	jp	(hl)
;src/battle.c:242: static void enemy_turn(RPGState *s, RPGBattle *b, uint8_t index) {
;	---------------------------------
; Function enemy_turn
; ---------------------------------
_enemy_turn:
	add	sp, #-13
	ldhl	sp,	#11
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#9
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle.c:243: RPGCharacter *p = &b->enemies[index];
	ldhl	sp,	#15
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	sp
	inc	sp
;src/battle.c:246: if (!alive(p) || decay_binding(s, b, p)) return;
	ld	e, l
	ld	d, h
	push	de
	call	_alive
	ldhl	sp,#8
	ld	(hl), a
	or	a, a
	jp	Z, 00140$
	inc	hl
	pop	de
	push	de
	push	de
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_decay_binding
	or	a, a
	jp	NZ, 00140$
;src/battle.c:247: switch (b->enemy_flags & 7u) {
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009b
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#5
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	and	a, #0x07
	ld	(hl+), a
	ld	(hl), #0x00
	dec	hl
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #00260$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00260$:
	.dw	00139$
	.dw	00104$
	.dw	00115$
	.dw	00119$
	.dw	00123$
	.dw	00126$
	.dw	00129$
	.dw	00137$
;src/battle.c:248: case 1: /* One-quarter chance to bind; already-bound random target => attack. */
00104$:
;src/battle.c:249: if (rpg_random(s) & 3u) break;
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x03
	jp	NZ, 00139$
;src/battle.c:250: if (b->barrier & 0x80u) decay_barrier(s, b);
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0083
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	rlca
	jr	NC, 00108$
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_decay_barrier
00108$:
;src/battle.c:251: if (b->barrier & 0x80u) { b->last_effect = BATTLE_EFFECT_BLOCKED; return; }
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0083
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	rlca
	jr	NC, 00110$
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, #0x03
	ld	(hl), a
	jp	00140$
00110$:
;src/battle.c:252: c = choose_party(s); if (c == RPG_NO_SLOT) return;
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_choose_party
	ld	c, a
	inc	a
	jp	Z, 00140$
;src/battle.c:253: if (s->party[c].bound) break;
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#11
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x000d
	add	hl, de
	ld	a, (hl)
	or	a, a
	jp	NZ, 00139$
;src/battle.c:254: s->party[c].bound = 3; b->last_target = c; b->last_effect = BATTLE_EFFECT_ROPE; return;
	ld	(hl), #0x03
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0091
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, #0x0c
	ld	(hl), a
	jp	00140$
;src/battle.c:255: case 2:
00115$:
;src/battle.c:256: if (p->hp >= 30u && (rpg_random(s) & 7u)) break;
	pop	de
	push	de
	ld	l, e
	ld	h, d
	inc	hl
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
	sub	a, #0x1e
	jr	C, 00117$
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x07
	jp	NZ, 00139$
00117$:
;src/battle.c:257: hp = (uint16_t)p->hp + 80u;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#5
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0050
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
;src/battle.c:258: p->hp = hp > p->max_hp ? p->max_hp : (uint8_t)hp;
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#4
	ld	a, c
	sub	a, (hl)
	inc	hl
	ld	a, b
	sbc	a, (hl)
	jr	C, 00143$
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
00143$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
;src/battle.c:259: b->last_effect = BATTLE_EFFECT_HEAL; b->last_target = index + 4u; return;
	ld	a, (hl+)
	ld	(de), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	(hl), #0x06
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0091
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#15
	ld	a, (hl)
	inc	a
	inc	a
	inc	a
	inc	a
	ld	(bc), a
	jp	00140$
;src/battle.c:260: case 3:
00119$:
;src/battle.c:261: if ((rpg_random(s) & 15u) || (p->status & 0x80u)) break;
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x0f
	jp	NZ, 00139$
	pop	bc
	push	bc
	ld	a, (bc)
	bit	7, a
	jp	NZ, 00139$
;src/battle.c:262: p->status |= 0x80u; b->last_effect = BATTLE_EFFECT_BOOST; return;
	set	7, a
	ld	(bc), a
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, #0x07
	ld	(hl), a
	jp	00140$
;src/battle.c:263: case 4:
00123$:
;src/battle.c:264: if (rpg_random(s) & 3u) break;
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x03
	jp	NZ, 00139$
;src/battle.c:265: enemy_fire(s, b); enemy_fire(s, b); return; /* call, then fall-through */
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_enemy_fire
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_enemy_fire
	jp	00140$
;src/battle.c:266: case 5:
00126$:
;src/battle.c:267: if (rpg_random(s) & 3u) break;
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x03
	jp	NZ, 00139$
;src/battle.c:268: b->last_effect = BATTLE_EFFECT_THUNDER;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	(hl), #0x09
;src/battle.c:269: enemy_group(s, b, p, 216u); return;
	ld	a, #0xd8
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_enemy_group
	jp	00140$
;src/battle.c:270: case 6:
00129$:
;src/battle.c:271: if (s->party[2].status && s->party[2].shield == ItemID_MirrorShield) break;
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0020
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00131$
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x002c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x1f
	jp	Z, 00139$
00131$:
;src/battle.c:272: if (b->barrier) decay_barrier(s, b);
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0083
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00134$
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_decay_barrier
00134$:
;src/battle.c:273: c = choose_party(s); if (c == RPG_NO_SLOT) return;
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_choose_party
	ld	d, a
	inc	a
	jp	Z, 00140$
;src/battle.c:274: s->party[c].status = 0; record_damage(b, c, s->party[c].hp); s->party[c].hp = 0;
	ld	a, d
	swap	a
	and	a, #0xf0
	ld	e, a
	push	de
	ld	d, #0x00
	ldhl	sp,	#13
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	push	de
	ld	d, #0x00
	ldhl	sp,	#13
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	bc
	push	af
	inc	sp
	ld	a, d
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_record_damage
	pop	bc
	xor	a, a
	ld	(bc), a
;src/battle.c:275: b->last_effect = BATTLE_EFFECT_PETRIFY; return;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, #0x0a
	ld	(hl), a
	jr	00140$
;src/battle.c:276: case 7:
00137$:
;src/battle.c:277: b->last_effect = BATTLE_EFFECT_THUNDER;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x09
;src/battle.c:278: enemy_group(s, b, p, rpg_find_item(s, ItemID_Crystal) == RPG_NO_SLOT ? 1u : 255u); return;
	ld	a, #0x3c
	push	af
	inc	sp
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	inc	a
	ld	a, #0x01
	jr	Z, 00145$
	ld	a, #0xff
00145$:
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_enemy_group
	jr	00140$
;src/battle.c:280: }
00139$:
;src/battle.c:281: enemy_physical(s, b, p);
	pop	de
	push	de
	push	de
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_enemy_physical
00140$:
;src/battle.c:282: }
	add	sp, #13
	pop	hl
	inc	sp
	jp	(hl)
;src/battle.c:283: static void player_random_spell(RPGState *s, RPGBattle *b, uint8_t amount) {
;	---------------------------------
; Function player_random_spell
; ---------------------------------
_player_random_spell:
	add	sp, #-3
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
;src/battle.c:284: uint8_t c = choose_enemy(s, b);
	ld	a, b
	ld	(hl-), a
	push	de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	call	_choose_enemy
	ld	c, a
	pop	de
;src/battle.c:285: if (c == RPG_NO_SLOT) return;
	ld	a, c
	inc	a
	jr	Z, 00103$
;src/battle.c:286: damage(b, &b->enemies[c], c + 4u, amount - (rpg_random(s) & 3u));
	push	bc
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	and	a, #0x03
	ld	e, a
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, e
	ld	e, a
	ld	a, c
	add	a, #0x04
	ldhl	sp,	#0
	ld	(hl+), a
	ld	a, c
	swap	a
	and	a, #0xf0
	push	de
	ld	e, a
	ld	d, #0x00
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, e
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	a, (hl+)
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_damage
00103$:
;src/battle.c:287: }
	add	sp, #3
	pop	hl
	inc	sp
	jp	(hl)
;src/battle.c:288: static void player_group(RPGState *s, RPGBattle *b, uint8_t amount) {
;	---------------------------------
; Function player_group
; ---------------------------------
_player_group:
	add	sp, #-14
	ldhl	sp,	#11
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#9
	ld	a, c
	ld	(hl+), a
;src/battle.c:290: for (c = 0; c != 8; ++c) if (alive(&b->enemies[c])) {
	ld	a, b
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0080
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#13
	ld	(hl), #0x00
00108$:
	ldhl	sp,	#13
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ldhl	sp,	#6
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_alive
	or	a, a
	jr	Z, 00109$
;src/battle.c:291: d = amount;
	ldhl	sp,	#16
	ld	c, (hl)
;src/battle.c:292: if (amount == 40u) d -= rpg_random(s) & 15u;
	ld	a, c
	sub	a, #0x28
	jr	NZ, 00102$
	push	bc
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	and	a, #0x0f
	ld	b, a
	ld	a, c
	sub	a, b
	ld	c, a
00102$:
;src/battle.c:293: damage(b, &b->enemies[c], c + 4u, d);
	ldhl	sp,	#13
	ld	b, (hl)
	inc	b
	inc	b
	inc	b
	inc	b
	pop	de
	push	de
	ldhl	sp,	#6
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	a, h
	ld	h, c
	ld	l, b
	push	hl
	ld	c, e
	ld	b, a
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_damage
;src/battle.c:294: if (b->enemy_id == EnemyID_DarkFalz) return;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x49
	jr	Z, 00110$
00109$:
;src/battle.c:290: for (c = 0; c != 8; ++c) if (alive(&b->enemies[c])) {
	ldhl	sp,	#13
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00108$
00110$:
;src/battle.c:296: }
	add	sp, #14
	pop	hl
	inc	sp
	jp	(hl)
;src/battle.c:297: static void player_magic(RPGState *s, RPGBattle *b, uint8_t c, const RPGAction *a) {
;	---------------------------------
; Function player_magic
; ---------------------------------
_player_magic:
	add	sp, #-7
	ldhl	sp,	#4
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;src/battle.c:299: if (a->id == MagicID_Heal || a->id == MagicID_Cure) {
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
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
	ldhl	sp,	#6
	ld	(hl), a
	dec	a
	jr	Z, 00101$
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00102$
00101$:
;src/battle.c:300: b->last_error = rpg_cast_heal(s, c, a->target, a->id, 1);
	ld	hl, #0x0093
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
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
	push	bc
	ld	h, #0x01
	push	hl
	inc	sp
	ldhl	sp,	#9
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ldhl	sp,	#14
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_cast_heal
	ld	hl, #_rpg_cast_heal
	call	___sdcc_bcall_ehl
	add	sp, #6
	pop	bc
	pop	hl
	push	hl
	ld	(hl), a
;src/battle.c:301: b->last_effect = BATTLE_EFFECT_HEAL; b->last_target = a->target; return;
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x06
	ld	hl, #0x0091
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(bc), a
	jp	00149$
00102$:
;src/battle.c:303: cost = rpg_magic_cost(a->id);
	push	bc
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_rpg_magic_cost
	ld	hl, #_rpg_magic_cost
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, a
	pop	bc
;src/battle.c:304: if (s->party[c].mp < cost) { b->last_error = RPG_NO_MP; return; }
	ldhl	sp,	#9
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	push	de
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	d, l
	inc	hl
	inc	hl
	ld	a, (hl)
	cp	a, e
	jr	NC, 00105$
	ld	hl, #0x0093
	add	hl, bc
	ld	(hl), #0x06
	jp	00149$
00105$:
;src/battle.c:305: s->party[c].mp -= cost;
	sub	a, e
	ld	(hl), a
;src/battle.c:306: switch (a->id) {
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, #0x0b
	sub	a, (hl)
	jp	C, 00141$
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #00302$
	add	hl, de
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	jp	(hl)
00302$:
	.dw	00141$
	.dw	00141$
	.dw	00141$
	.dw	00106$
	.dw	00107$
	.dw	00108$
	.dw	00109$
	.dw	00110$
	.dw	00112$
	.dw	00136$
	.dw	00131$
	.dw	00123$
;src/battle.c:307: case MagicID_Wall: b->barrier = 6u; b->last_effect = BATTLE_EFFECT_BARRIER; break;
00106$:
	ld	hl, #0x0083
	add	hl, bc
	ld	(hl), #0x06
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x0e
	jp	00149$
;src/battle.c:308: case MagicID_Prot: b->barrier = 0x86u; b->last_effect = BATTLE_EFFECT_BARRIER; break;
00107$:
	ld	hl, #0x0083
	add	hl, bc
	ld	(hl), #0x86
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x0e
	jp	00149$
;src/battle.c:309: case MagicID_Fire:
00108$:
;src/battle.c:310: b->last_effect = BATTLE_EFFECT_FIRE;
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x08
;src/battle.c:311: player_random_spell(s, b, 10u); player_random_spell(s, b, 10u); break;
	push	bc
	ld	a, #0x0a
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_random_spell
	pop	bc
	ld	a, #0x0a
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_random_spell
	jp	00149$
;src/battle.c:312: case MagicID_Thun:
00109$:
;src/battle.c:313: b->last_effect = BATTLE_EFFECT_THUNDER; player_group(s, b, 40u); break;
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x09
	ld	a, #0x28
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_group
	jp	00149$
;src/battle.c:314: case MagicID_Wind:
00110$:
;src/battle.c:315: b->last_effect = BATTLE_EFFECT_WIND;
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x0b
;src/battle.c:316: for (i = 0; i != 3; ++i) player_random_spell(s, b, 12u);
	ld	e, #0x00
00143$:
	push	bc
	push	de
	ld	a, #0x0c
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_random_spell
	pop	de
	pop	bc
	inc	e
	ld	a, e
	sub	a, #0x03
	jp	Z, 00149$
;src/battle.c:317: break;
	jr	00143$
;src/battle.c:318: case MagicID_Rope:
00112$:
;src/battle.c:319: b->last_effect = BATTLE_EFFECT_NO_EFFECT;
	ld	hl, #0x00a0
	add	hl, bc
	inc	sp
	inc	sp
	ld	(hl), #0x11
	push	hl
;src/battle.c:320: if (!(b->enemy_flags & 0x20u)) break;
	ld	hl, #0x009b
	add	hl, bc
	ld	a, (hl)
	bit	5, a
	jp	Z, 00149$
;src/battle.c:321: n = 3;
	ldhl	sp,	#2
	ld	(hl), #0x03
;src/battle.c:322: if (s->party[0].attack < b->enemies[0].attack) { n = rpg_random(s) & 3u; if (!n) break; }
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ld	hl, #0x0008
	add	hl, bc
	ld	a, e
	sub	a, (hl)
	jr	NC, 00118$
	push	bc
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	and	a, #0x03
	ldhl	sp,	#2
	ld	(hl), a
	or	a, a
	jp	Z, 00149$
00118$:
;src/battle.c:323: for (i = 0; i != 8; ++i) if (alive(&b->enemies[i]) && !b->enemies[i].bound) {
	ldhl	sp,	#3
	ld	(hl), #0x00
	ld	e, c
	ld	d, b
	ldhl	sp,	#6
	ld	(hl), #0x00
00145$:
	ldhl	sp,	#6
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	l, a
	add	a,e
	ld	h, a
	ld	a, d
	adc	a, #0x00
	push	hl
	push	bc
	push	de
	ld	e, h
	ld	d, a
	call	_alive
	pop	de
	pop	bc
	pop	hl
	or	a, a
	jr	Z, 00146$
	ld	h, #0x00
	add	hl, bc
	push	de
	ld	de, #0x000d
	add	hl, de
	pop	de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00146$
;src/battle.c:324: b->enemies[i].bound = n; b->last_target = i + 4u; b->last_effect = BATTLE_EFFECT_ROPE; break;
	push	hl
	ldhl	sp,	#4
	ld	a, (hl)
	pop	hl
	ld	(hl), a
	ld	hl, #0x0091
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl)
	inc	a
	inc	a
	inc	a
	inc	a
	ld	(bc), a
	pop	hl
	ld	(hl), #0x0c
	push	hl
	jp	00149$
00146$:
;src/battle.c:323: for (i = 0; i != 8; ++i) if (alive(&b->enemies[i]) && !b->enemies[i].bound) {
	ldhl	sp,	#6
	inc	(hl)
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x08
	jp	Z, 00149$
;src/battle.c:326: break;
	jr	00145$
;src/battle.c:327: case MagicID_Terr:
00123$:
;src/battle.c:328: b->last_effect = BATTLE_EFFECT_NO_EFFECT;
	ld	hl, #0x00a0
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x11
;src/battle.c:329: if (s->party[0].attack < b->enemies[0].attack || rpg_random(s) >= 178u) break;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ld	hl, #0x0008
	add	hl, bc
	ld	d, (hl)
	ld	a, e
	sub	a, d
	jp	C, 00149$
	push	bc
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	sub	a, #0xb2
	jp	NC, 00149$
;src/battle.c:330: for (i = 0; i != 8; ++i) if (alive(&b->enemies[i]) && !(b->enemies[i].status & 0x40u)) {
	ldhl	sp,	#3
	ld	(hl), #0x00
	ld	e, c
	ld	d, b
	ldhl	sp,	#6
	ld	(hl), #0x00
00147$:
	ldhl	sp,	#6
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	l, a
	add	a,e
	ld	h, a
	ld	a, d
	adc	a, #0x00
	push	hl
	push	bc
	push	de
	ld	e, h
	ld	d, a
	call	_alive
	pop	de
	pop	bc
	pop	hl
	or	a, a
	jr	Z, 00148$
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	bit	6, a
	jr	NZ, 00148$
;src/battle.c:331: b->enemies[i].status |= 0x40u; b->last_target = i + 4u; b->last_effect = BATTLE_EFFECT_WEAKEN; break;
	set	6, a
	ld	(hl), a
	ld	hl, #0x0091
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl-)
	dec	hl
	inc	a
	inc	a
	inc	a
	inc	a
	ld	(bc), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x0d
	jp	00149$
00148$:
;src/battle.c:330: for (i = 0; i != 8; ++i) if (alive(&b->enemies[i]) && !(b->enemies[i].status & 0x40u)) {
	ldhl	sp,	#6
	inc	(hl)
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x08
	jp	Z, 00149$
;src/battle.c:333: break;
	jr	00147$
;src/battle.c:334: case MagicID_Help:
00131$:
;src/battle.c:335: if (a->target < 4u && party_alive(s, a->target)) {
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	cp	a, #0x04
	jr	NC, 00133$
	push	bc
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_party_alive
	pop	bc
	or	a, a
	jr	Z, 00133$
;src/battle.c:336: s->party[a->target].status |= 0x80u; b->last_target = a->target; b->last_effect = BATTLE_EFFECT_BOOST;
	pop	de
	push	de
	ld	a, (de)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	set	7, a
	ld	(de), a
	ld	hl, #0x0091
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	pop	de
	push	de
	ld	a, (de)
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x07
	jr	00149$
00133$:
;src/battle.c:337: } else b->last_error = RPG_DEAD;
	ld	hl, #0x0093
	add	hl, bc
	ld	(hl), #0x05
;src/battle.c:338: break;
	jr	00149$
;src/battle.c:339: case MagicID_Bye:
00136$:
;src/battle.c:340: if (b->run_chance && !b->escape_blocked) {
	ld	hl, #0x009c
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00138$
	ld	hl, #0x009d
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	NZ, 00138$
;src/battle.c:341: b->outcome = RPG_ESCAPED; b->last_effect = BATTLE_EFFECT_ESCAPE; rpg_refresh_stats(s);
	ld	hl, #0x0082
	add	hl, bc
	ld	(hl), #0x03
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x0f
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00149$
00138$:
;src/battle.c:342: } else b->last_effect = BATTLE_EFFECT_NO_EFFECT;
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x11
;src/battle.c:343: break;
	jr	00149$
;src/battle.c:344: default: b->last_error = RPG_NOT_IMPLEMENTED; break;
00141$:
	ld	hl, #0x0093
	add	hl, bc
	ld	(hl), #0x08
;src/battle.c:345: }
00149$:
;src/battle.c:346: }
	add	sp, #7
	pop	hl
	add	sp, #3
	jp	(hl)
;src/battle.c:347: static void player_item(RPGState *s, RPGBattle *b, uint8_t c, uint8_t item) {
;	---------------------------------
; Function player_item
; ---------------------------------
_player_item:
	add	sp, #-10
	ldhl	sp,	#8
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#6
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle.c:348: uint8_t slot = rpg_find_item(s, item);
	ldhl	sp,	#13
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#0
	ld	(hl), a
;src/battle.c:349: if (slot == RPG_NO_SLOT) { b->last_error = RPG_INVALID; return; }
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0093
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	inc	a
	jr	NZ, 00102$
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	jp	00119$
00102$:
;src/battle.c:350: b->last_effect = BATTLE_EFFECT_NO_EFFECT;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x11
;src/battle.c:351: if (item == ItemID_Cola || item == ItemID_Burger) {
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x24
	jr	Z, 00115$
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x25
	jr	NZ, 00116$
00115$:
;src/battle.c:352: b->last_error = rpg_use_item(s, slot, c); b->last_target = c; b->last_effect = BATTLE_EFFECT_HEAL;
	ldhl	sp,	#12
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_use_item
	ld	hl, #_rpg_use_item
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0091
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#12
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x06
	jp	00119$
00116$:
;src/battle.c:353: } else if (item == ItemID_Escaper || item == ItemID_Wand) {
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x28
	ld	a, #0x01
	jr	Z, 00185$
	xor	a, a
00185$:
	ldhl	sp,	#5
	ld	(hl), a
	or	a, a
	jr	NZ, 00111$
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00112$
00111$:
;src/battle.c:354: if (item == ItemID_Escaper) rpg_remove_item(s, slot);
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	ldhl	sp,	#0
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
00104$:
;src/battle.c:355: if (b->run_chance && !b->escape_blocked) {
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jp	Z, 00119$
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00119$
;src/battle.c:356: b->outcome = RPG_ESCAPED; b->last_effect = BATTLE_EFFECT_ESCAPE; rpg_refresh_stats(s);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0082
	add	hl, de
	ld	(hl), #0x03
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x0f
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00119$
00112$:
;src/battle.c:358: } else if (item == ItemID_MagicHat || item == ItemID_Sphere) {
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x2a
	ld	a, #0x01
	jr	Z, 00189$
	xor	a, a
00189$:
	ld	c, a
	or	a, a
	jr	NZ, 00108$
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x2e
	jr	NZ, 00119$
00108$:
;src/battle.c:359: rpg_remove_item(s, slot);
	push	bc
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
;src/battle.c:360: b->last_error = rpg_battle_talk(s, b, item == ItemID_MagicHat ? 1u : 2u);
	ld	a, c
	or	a, a
	ld	a, #0x01
	jr	NZ, 00122$
	ld	a, #0x02
00122$:
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_talk
	ld	hl, #_rpg_battle_talk
	call	___sdcc_bcall_ehl
	add	sp, #5
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00119$:
;src/battle.c:363: }
	add	sp, #10
	pop	hl
	pop	af
	jp	(hl)
;src/battle.c:364: static void player_turn(RPGState *s, RPGBattle *b, uint8_t c) {
;	---------------------------------
; Function player_turn
; ---------------------------------
_player_turn:
	add	sp, #-4
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;src/battle.c:365: const RPGAction *a = &b->actions[c];
	ld	hl, #0x00a7
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#6
	ld	a, (hl)
	ld	e, a
	add	a, a
	add	a, e
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
;src/battle.c:366: RPGCharacter *p = &s->party[c];
	ldhl	sp,	#6
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	push	de
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	inc	sp
	inc	sp
	push	hl
;src/battle.c:368: if (!party_alive(s, c) || b->suppress_party || !p->hp || decay_binding(s, b, p)) return;
	push	bc
	push	de
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_party_alive
	pop	de
	pop	bc
	or	a, a
	jp	Z, 00125$
	ld	hl, #0x009e
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jp	NZ, 00125$
	pop	hl
	push	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jp	Z, 00125$
	push	bc
	push	de
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_decay_binding
	pop	de
	pop	bc
	or	a, a
	jp	NZ, 00125$
;src/battle.c:369: if (a->kind == RPG_ACT_ATTACK) {
	ld	a, (de)
	cp	a, #0x01
	jr	NZ, 00123$
;src/battle.c:370: b->last_effect = BATTLE_EFFECT_ATTACK;
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x01
;src/battle.c:371: if (p->weapon == ItemID_NeedleGun) player_group(s, b, 5u);
	pop	de
	push	de
	ld	hl, #0x000a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	cp	a, #0x09
	jr	NZ, 00115$
	ld	a, #0x05
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_group
	jp	00125$
00115$:
;src/battle.c:372: else if (p->weapon == ItemID_HeatGun) player_group(s, b, 10u);
	cp	a, #0x0b
	jr	NZ, 00112$
	ld	a, #0x0a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_group
	jr	00125$
00112$:
;src/battle.c:373: else if (p->weapon == ItemID_LaserGun) player_group(s, b, 20u);
	sub	a, #0x0d
	jr	NZ, 00109$
	ld	a, #0x14
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_group
	jr	00125$
00109$:
;src/battle.c:375: target = choose_enemy(s, b);
	push	bc
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_choose_enemy
	ld	e, a
	pop	bc
;src/battle.c:376: if (target != RPG_NO_SLOT) physical(s, b, p, &b->enemies[target], target + 4u, 0);
	ld	a, e
	inc	a
	jr	Z, 00125$
	ld	d, e
	inc	d
	inc	d
	inc	d
	inc	d
	ld	a, e
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	xor	a, a
	push	af
	inc	sp
	push	de
	inc	sp
	push	hl
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_physical
	jr	00125$
00123$:
;src/battle.c:378: } else if (a->kind == RPG_ACT_MAGIC) player_magic(s, b, c, a);
	cp	a, #0x03
	jr	NZ, 00120$
	push	de
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_magic
	jr	00125$
00120$:
;src/battle.c:379: else if (a->kind == RPG_ACT_ITEM) player_item(s, b, c, a->id);
	sub	a, #0x04
	jr	NZ, 00125$
	inc	de
	ld	a, (de)
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_item
00125$:
;src/battle.c:380: }
	add	sp, #4
	pop	hl
	inc	sp
	jp	(hl)
;src/battle.c:381: uint8_t rpg_battle_step(RPGState *s, RPGBattle *b) RPG_BANKED {
;	---------------------------------
; Function rpg_battle_step
; ---------------------------------
	b_rpg_battle_step	= 18
_rpg_battle_step::
	add	sp, #-4
;src/battle.c:383: if (b->outcome != RPG_ONGOING || b->turn_cursor >= 12u) return b->outcome;
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0082
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	l, a
	or	a, a
	jr	NZ, 00101$
	ld	a, c
	add	a, #0x9f
	ld	e, a
	ld	a, b
	adc	a, #0x00
	ld	d, a
	ld	a, (de)
	sub	a, #0x0c
	jr	C, 00102$
00101$:
	ld	a, l
	jr	00109$
00102$:
;src/battle.c:384: b->last_damage = 0; b->last_target = RPG_NO_SLOT; b->last_error = RPG_OK; b->last_effect = BATTLE_EFFECT_NONE;
	ld	hl, #0x0092
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x0091
	add	hl, bc
	ld	(hl), #0xff
	ld	hl, #0x0093
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x00a0
	add	hl, bc
	ld	(hl), #0x00
;src/battle.c:385: actor = b->turn_order[b->turn_cursor++]; b->last_actor = actor;
	ld	hl, #0x0084
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ld	a, (de)
	ld	l, a
	inc	l
	push	af
	ld	a, l
	ld	(de), a
	pop	af
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	d, a
	ld	hl, #0x0090
	add	hl, bc
;src/battle.c:386: if (actor < 4u) player_turn(s, b, actor);
	ld	a,d
	ld	(hl),a
	sub	a, #0x04
	jr	NC, 00107$
	push	bc
	push	de
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_player_turn
	pop	bc
	jr	00108$
00107$:
;src/battle.c:387: else if (actor < 12u) enemy_turn(s, b, actor - 4u);
	ld	a,d
	cp	a,#0x0c
	jr	NC, 00108$
	add	a, #0xfc
	push	bc
	push	af
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_enemy_turn
	pop	bc
00108$:
;src/battle.c:388: check_outcome(s, b);
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_check_outcome
;src/battle.c:389: return b->outcome;
	pop	de
	push	de
	ld	a, (de)
00109$:
;src/battle.c:390: }
	add	sp, #4
	ret
;src/battle.c:391: uint8_t rpg_battle_round(RPGState *s, RPGBattle *b, const RPGAction actions[4]) RPG_BANKED {
;	---------------------------------
; Function rpg_battle_round
; ---------------------------------
	b_rpg_battle_round	= 18
_rpg_battle_round::
	add	sp, #-3
;src/battle.c:392: if (rpg_battle_prepare(s, b, actions)) return b->outcome;
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_prepare
	ld	hl, #_rpg_battle_prepare
	call	___sdcc_bcall_ehl
	add	sp, #6
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	or	a, a
	jr	Z, 00112$
	ld	hl, #0x0082
	add	hl, de
	ld	a, (hl)
	jr	00107$
;src/battle.c:393: while (b->turn_cursor < 12u && b->outcome == RPG_ONGOING) rpg_battle_step(s, b);
00112$:
	ld	c, e
	ld	b, d
	ld	hl, #0x009f
	add	hl, de
	inc	sp
	inc	sp
	push	hl
00104$:
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl), a
	ld	hl, #0x0082
	add	hl, bc
	ld	e, (hl)
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x0c
	jr	NC, 00106$
	ld	a, e
	or	a, a
	jr	NZ, 00106$
	push	bc
	push	bc
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_step
	ld	hl, #_rpg_battle_step
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	jr	00104$
00106$:
;src/battle.c:394: return b->outcome;
	ld	a, e
00107$:
;src/battle.c:395: }
	add	sp, #3
	ret
;src/battle.c:396: uint8_t rpg_claim_rewards(RPGState *s, RPGBattle *b) RPG_BANKED {
;	---------------------------------
; Function rpg_claim_rewards
; ---------------------------------
	b_rpg_claim_rewards	= 18
_rpg_claim_rewards::
	add	sp, #-4
;src/battle.c:398: if (b->outcome != RPG_VICTORY) return RPG_INVALID;
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0082
	add	hl, bc
	ld	a, (hl)
	dec	a
	jr	Z, 00102$
	ld	a, #0x01
	jp	00114$
00102$:
;src/battle.c:399: if (b->exp_claimed) return RPG_OK;
	ld	hl, #0x00a5
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	xor	a, a
	jp	00114$
00104$:
;src/battle.c:400: b->exp_claimed = 1;
	ld	(hl), #0x01
;src/battle.c:401: if (b->enemy_id == EnemyID_Tarzimal) { b->rewards_claimed = 1; return RPG_OK; }
	ld	hl, #0x0080
	add	hl, bc
	ld	e, (hl)
	ld	hl, #0x009a
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	a, e
	sub	a, #0x31
	jr	NZ, 00106$
	pop	hl
	ld	(hl), #0x01
	push	hl
	xor	a, a
	jp	00114$
00106$:
;src/battle.c:402: b->leveled_mask = rpg_award_exp(s, b->exp_reward);
	ld	hl, #0x00a6
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ld	hl, #0x0094
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	push	hl
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_award_exp
	ld	hl, #_rpg_award_exp
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/battle.c:403: rpg_refresh_stats(s);
	push	bc
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
;src/battle.c:404: if (!b->money_reward && !b->item_reward) { b->rewards_claimed = 1; return RPG_OK; }
	ld	hl, #0x0096
	add	hl, bc
	ld	a, (hl+)
	ld	l, (hl)
	or	a, l
	jr	NZ, 00108$
	ld	hl, #0x0098
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	NZ, 00108$
	pop	hl
	ld	(hl), #0x01
	push	hl
	xor	a, a
	jr	00114$
00108$:
;src/battle.c:405: random = rpg_random(s); /* The original chest consumes this even at chance 0. */
	push	bc
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,	#4
	ld	(hl), a
	pop	bc
;src/battle.c:406: b->trap_kind = BATTLE_TRAP_NONE;
	ld	hl, #0x00a3
	add	hl, bc
	ld	e, l
	ld	d, h
	xor	a, a
	ld	(de), a
;src/battle.c:407: if (b->trap_chance && (b->trap_chance >= 240u || b->trap_chance >= random))
	ld	hl, #0x0099
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,#3
	ld	(hl),a
	or	a,a
	jr	Z, 00111$
	sub	a, #0xf0
	jr	NC, 00110$
	ld	a, (hl-)
	sub	a, (hl)
	jr	C, 00111$
00110$:
;src/battle.c:408: b->trap_kind = (b->trap_chance & 1u) ? BATTLE_TRAP_SINGLE : BATTLE_TRAP_PARTY;
	push	hl
	ldhl	sp,	#5
	bit	0, (hl)
	pop	hl
	ld	a, #0x02
	jr	NZ, 00117$
	ld	a, #0x01
00117$:
	ld	(de), a
00111$:
;src/battle.c:409: b->chest_state = BATTLE_CHEST_PENDING;
	ld	hl, #0x00a2
	add	hl, bc
	ld	(hl), #0x01
;src/battle.c:410: return RPG_OK;
	xor	a, a
00114$:
;src/battle.c:411: }
	add	sp, #4
	ret
;src/battle.c:412: static void chest_damage(RPGState *s, uint8_t c) {
;	---------------------------------
; Function chest_damage
; ---------------------------------
_chest_damage:
	ld	c, a
;src/battle.c:413: if (party_alive(s, c)) s->party[c].hp -= s->party[c].hp / 3u;
	push	bc
	push	de
	ld	a, c
	call	_party_alive
	pop	de
	pop	bc
	or	a, a
	ret	Z
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, de
	inc	hl
	ld	d, (hl)
	ld	a, d
	push	hl
	push	de
	ld	e, #0x03
	call	__divuchar
	pop	de
	pop	hl
	ld	a, d
	sub	a, c
	ld	(hl), a
;src/battle.c:414: }
	ret
;src/battle.c:415: uint8_t rpg_battle_open_chest(RPGState *s, RPGBattle *b) RPG_BANKED {
;	---------------------------------
; Function rpg_battle_open_chest
; ---------------------------------
	b_rpg_battle_open_chest	= 18
_rpg_battle_open_chest::
	add	sp, #-4
;src/battle.c:417: if (b->chest_state != BATTLE_CHEST_PENDING && !(b->chest_state == BATTLE_CHEST_OPEN && b->item_pending)) return RPG_INVALID;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a2
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	c, a
	dec	a
	ld	a, #0x01
	jr	Z, 00186$
	xor	a, a
00186$:
	ld	b, a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a4
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	bit	0, b
	jr	NZ, 00102$
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00101$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00102$
00101$:
	ld	a, #0x01
	jp	00119$
00102$:
;src/battle.c:418: if (b->chest_state == BATTLE_CHEST_PENDING) {
	ld	a, b
	or	a, a
	jr	Z, 00112$
;src/battle.c:419: b->chest_state = BATTLE_CHEST_OPEN;
	pop	hl
	ld	(hl), #0x02
	push	hl
;src/battle.c:420: if (b->trap_kind == BATTLE_TRAP_PARTY) for (c = 0; c != 4; ++c) chest_damage(s, c);
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a3
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	cp	a, #0x01
	jr	NZ, 00109$
	ld	c, #0x00
00117$:
	push	bc
	ld	a, c
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_chest_damage
	pop	bc
	inc	c
	ld	a, c
	sub	a, #0x04
	jr	Z, 00110$
	jr	00117$
00109$:
;src/battle.c:421: else if (b->trap_kind == BATTLE_TRAP_SINGLE) chest_damage(s, rpg_random(s) & 3u);
	sub	a, #0x02
	jr	NZ, 00110$
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	and	a, #0x03
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_chest_damage
00110$:
;src/battle.c:422: rpg_add_money(s, b->money_reward);
	ldhl	sp,#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x0096
	add	hl, de
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_add_money
	ld	hl, #_rpg_add_money
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle.c:423: b->item_pending = b->item_reward;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0098
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00112$:
;src/battle.c:425: if (b->item_pending) {
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00116$
;src/battle.c:426: result = rpg_add_item(s, b->item_pending);
	push	af
	inc	sp
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_add_item
	ld	hl, #_rpg_add_item
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/battle.c:427: if (result) return result;
	or	a,a
	jr	NZ, 00119$
;src/battle.c:428: b->item_pending = 0;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
00116$:
;src/battle.c:430: b->rewards_claimed = 1;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x009a
	add	hl, de
	ld	(hl), #0x01
;src/battle.c:431: return RPG_OK;
	xor	a, a
00119$:
;src/battle.c:432: }
	add	sp, #4
	ret
;src/battle.c:433: uint8_t rpg_battle_replace_reward(RPGState *s, RPGBattle *b, uint8_t slot) RPG_BANKED {
;	---------------------------------
; Function rpg_battle_replace_reward
; ---------------------------------
	b_rpg_battle_replace_reward	= 18
_rpg_battle_replace_reward::
	dec	sp
;src/battle.c:435: if (b->chest_state != BATTLE_CHEST_OPEN || !b->item_pending) return RPG_INVALID;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x00a2
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00101$
	ld	hl, #0x00a4
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	NZ, 00102$
00101$:
	ld	a, #0x01
	jr	00106$
00102$:
;src/battle.c:436: result = rpg_replace_item(s, slot, b->item_pending);
	push	bc
	push	de
	push	af
	inc	sp
	ldhl	sp,	#16
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	e, #b_rpg_replace_item
	ld	hl, #_rpg_replace_item
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	pop	bc
	ldhl	sp,	#0
	ld	(hl), a
;src/battle.c:437: if (!result) { b->item_pending = 0; b->rewards_claimed = 1; }
	or	a,a
	jr	NZ, 00105$
	ld	(de), a
	ld	hl, #0x009a
	add	hl, bc
	ld	(hl), #0x01
00105$:
;src/battle.c:438: return result;
	ldhl	sp,	#0
	ld	a, (hl)
00106$:
;src/battle.c:439: }
	inc	sp
	ret
;src/battle.c:440: void rpg_battle_decline_chest(RPGBattle *b) RPG_BANKED {
;	---------------------------------
; Function rpg_battle_decline_chest
; ---------------------------------
	b_rpg_battle_decline_chest	= 18
_rpg_battle_decline_chest::
;src/battle.c:441: if (b->chest_state == BATTLE_CHEST_PENDING) b->chest_state = BATTLE_CHEST_DECLINED;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x00a2
	add	hl, bc
	ld	a, (hl)
	dec	a
	jr	NZ, 00102$
	ld	(hl), #0x03
00102$:
;src/battle.c:442: b->item_pending = 0;
	ld	hl, #0x00a4
	add	hl, bc
	ld	(hl), #0x00
;src/battle.c:443: b->rewards_claimed = 1;
	ld	hl, #0x009a
	add	hl, bc
	ld	(hl), #0x01
;src/battle.c:444: }
	ret
	.area _CODE_18
	.area _INITIALIZER
	.area _CABS (ABS)
