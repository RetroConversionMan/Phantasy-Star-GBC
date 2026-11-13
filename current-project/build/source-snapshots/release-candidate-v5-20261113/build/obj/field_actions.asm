;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module field_actions
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl b_rpg_battle_prepare_chest
	.globl _rpg_battle_prepare_chest
	.globl b_dungeon_find_object
	.globl _dungeon_find_object
	.globl b_dungeon_sample_position
	.globl _dungeon_sample_position
	.globl b_dungeon_sample
	.globl _dungeon_sample
	.globl b_dungeon_refresh_light
	.globl _dungeon_refresh_light
	.globl b_rpg_magic_cost
	.globl _rpg_magic_cost
	.globl b_rpg_cast_heal
	.globl _rpg_cast_heal
	.globl b_rpg_knows_spell
	.globl _rpg_knows_spell
	.globl b_rpg_use_item
	.globl _rpg_use_item
	.globl b_rpg_find_item
	.globl _rpg_find_item
	.globl b_rpg_remove_item
	.globl _rpg_remove_item
	.globl b_rpg_add_item
	.globl _rpg_add_item
	.globl b_field_cast
	.globl _field_cast
	.globl b_field_use_item
	.globl _field_use_item
	.globl b_field_torch_reply
	.globl _field_torch_reply
	.globl b_field_torch_finish
	.globl _field_torch_finish
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
	.area _CODE_11
;src/field_actions.c:7: static void line(FieldAction *a,uint16_t id){if(a->line_count<3u)a->lines[a->line_count++].dialogue=id;}
;	---------------------------------
; Function line
; ---------------------------------
_line:
	push	bc
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	c, (hl)
	ld	a, c
	sub	a, #0x03
	jr	NC, 00103$
	ld	a, e
	add	a, #0x0a
	ld	e, a
	jr	NC, 00112$
	inc	d
00112$:
	ld	a, c
	inc	a
	ld	(hl), a
	ld	a, c
	add	a, a
	add	a, a
	add	a, e
	ld	c, a
	ld	a, #0x00
	adc	a, d
	ld	b, a
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
00103$:
	inc	sp
	inc	sp
	ret
;src/field_actions.c:8: static uint8_t fail(FieldAction *a,uint8_t error,uint16_t id){a->error=error;if(id)line(a,id);return a->kind;}
;	---------------------------------
; Function fail
; ---------------------------------
_fail:
	ld	c, e
	ld	b, d
	inc	bc
	ld	(bc), a
	ldhl	sp,	#3
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00102$
	push	de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	call	_line
	pop	de
00102$:
	ld	a, (de)
	pop	hl
	pop	bc
	jp	(hl)
;src/field_actions.c:9: static uint8_t alive(const RPGState *s,uint8_t c){return c<4u&&(s->joined_mask&(1u<<c))&&(s->party[c].status&1u);}
;	---------------------------------
; Function alive
; ---------------------------------
_alive:
	ld	c, a
	sub	a, #0x04
	jr	NC, 00103$
	ld	hl, #0x0059
	add	hl, de
	ld	a, (hl)
	ld	b, c
	ld	hl, #0x0001
	inc	b
	jr	00123$
00122$:
	add	hl, hl
00123$:
	dec	b
	jr	NZ,00122$
	and	a, l
	ld	b, #0x00
	or	a, b
	jr	Z, 00103$
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	and	a, #0x01
	jr	NZ, 00104$
00103$:
	xor	a, a
	ret
00104$:
	ld	a, #0x01
	ret
;src/field_actions.c:10: static uint8_t floor_trap(FieldContext *c){
;	---------------------------------
; Function floor_trap
; ---------------------------------
_floor_trap:
	add	sp, #-7
;src/field_actions.c:14: return c->dungeon && dungeon_sample(c->dungeon,1u)==8u && !dungeon_find_object(c->dungeon,1u,&object);
	ld	hl, #0x0004
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	or	a, h
	jr	Z, 00103$
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	push	hl
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	sub	a, #0x08
	jr	NZ, 00103$
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0
	add	hl, sp
	push	hl
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_find_object
	ld	hl, #_dungeon_find_object
	call	___sdcc_bcall_ehl
	add	sp, #5
	or	a, a
	jr	Z, 00104$
00103$:
	xor	a, a
	jr	00105$
00104$:
	ld	a, #0x01
00105$:
;src/field_actions.c:15: }
	add	sp, #7
	ret
;src/field_actions.c:16: static void transfer(FieldContext *c,FieldAction *a){
;	---------------------------------
; Function transfer
; ---------------------------------
_transfer:
	add	sp, #-3
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/field_actions.c:18: uint8_t index=c->events->last_church;
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0103
	add	hl, bc
	ld	a, (hl)
;src/field_actions.c:20: if(index>=9u){a->error=RPG_INVALID;return;}
	ldhl	sp,#0
	ld	(hl), a
	sub	a, #0x09
	jr	C, 00102$
	inc	hl
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	ld	(hl), #0x01
	jr	00103$
00102$:
;src/field_actions.c:21: a->kind=FIELD_TRANSFER;a->target=places[index][0];a->a=places[index][1];a->b=places[index][2];
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	ld	a, #<(_transfer_places_10000_98)
	add	a, l
	ld	e, a
	ld	a, #>(_transfer_places_10000_98)
	adc	a, h
	ld	d, a
	ld	a, (de)
	ld	(bc), a
	push	de
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	l, e
	ld	h, d
	inc	hl
	ld	a, (hl)
	ld	(bc), a
	push	de
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	inc	de
	inc	de
	ld	a, (de)
	ld	(bc), a
00103$:
;src/field_actions.c:22: }
	add	sp, #3
	ret
_transfer_places_10000_98:
	.db #0x04	; 4
	.db #0x16	; 22
	.db #0x69	; 105	'i'
	.db #0x04	; 4
	.db #0x27	; 39
	.db #0x6b	; 107	'k'
	.db #0x07	; 7
	.db #0x29	; 41
	.db #0x2a	; 42
	.db #0x09	; 9
	.db #0x19	; 25
	.db #0x66	; 102	'f'
	.db #0x0e	; 14
	.db #0x29	; 41
	.db #0x19	; 25
	.db #0x0f	; 15
	.db #0x15	; 21
	.db #0x43	; 67	'C'
	.db #0x11	; 17
	.db #0x53	; 83	'S'
	.db #0x52	; 82	'R'
	.db #0x16	; 22
	.db #0x15	; 21
	.db #0x2c	; 44
	.db #0x15	; 21
	.db #0x28	; 40
	.db #0x61	; 97	'a'
;src/field_actions.c:23: static void tele(FieldContext *c,FieldAction *a){
;	---------------------------------
; Function tele
; ---------------------------------
_tele:
	add	sp, #-8
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#4
	ld	a, c
	ld	(hl+), a
;src/field_actions.c:25: if(c->chest){rpg_battle_prepare_chest(c->rpg,c->chest);found=c->chest->chest_visual!=0x3du;a->kind=FIELD_CHEST_PROMPT;}
	ld	a, b
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00102$
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	b, a
	push	bc
	ld	e, #b_rpg_battle_prepare_chest
	ld	hl, #_rpg_battle_prepare_chest
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	push	de
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x00a7
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x3d
	ld	a, #0x01
	jr	Z, 00133$
	xor	a, a
00133$:
	xor	a, #0x01
	ldhl	sp,	#3
	ld	(hl+), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x06
	jr	00103$
00102$:
;src/field_actions.c:26: else found=!c->interaction&&floor_trap(c);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00106$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_floor_trap
	or	a, a
	jr	NZ, 00107$
00106$:
	xor	a, a
	jr	00108$
00107$:
	ld	a, #0x01
00108$:
	ldhl	sp,	#3
	ld	(hl), a
00103$:
;src/field_actions.c:27: line(a,found?0xb404:0xb424);a->lines[a->line_count-1u].sound_after=0xd5;
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00109$
	ld	bc, #0xb404
	jr	00110$
00109$:
	ld	bc, #0xb424
00110$:
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	ld	a, (de)
	dec	a
	add	a, a
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0xd5
;src/field_actions.c:28: }
	add	sp, #8
	ret
;src/field_actions.c:29: uint8_t field_cast(FieldContext *c,uint8_t caster,uint8_t spell,uint8_t target,FieldAction *a) RPG_BANKED {
;	---------------------------------
; Function field_cast
; ---------------------------------
	b_field_cast	= 11
_field_cast::
	add	sp, #-8
;src/field_actions.c:31: memset(a,0,sizeof(*a));a->character=target<4u?target:caster;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0016
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#18
	ld	a,(hl)
	cp	a,#0x04
	jr	C, 00153$
	ldhl	sp,	#16
	ld	a, (hl)
00153$:
	ld	(bc), a
;src/field_actions.c:32: if(!alive(c->rpg,caster))return fail(a,RPG_DEAD,0xb730);
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#16
	ld	a, (hl)
	ld	e, c
	ld	d, b
	call	_alive
	or	a, a
	jr	NZ, 00102$
	ld	de, #0xb730
	push	de
	ld	a, #0x05
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_fail
	jp	00150$
00102$:
;src/field_actions.c:33: if(!rpg_knows_spell(c->rpg,caster,spell,0))return fail(a,RPG_NOT_LEARNED,caster==2u?0xb5ba:0xb5c8);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#18
	ld	a, (hl-)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_knows_spell
	ld	hl, #_rpg_knows_spell
	call	___sdcc_bcall_ehl
	add	sp, #5
	or	a, a
	jr	NZ, 00104$
	ldhl	sp,	#16
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00154$
	ld	bc, #0xb5ba
	jr	00155$
00154$:
	ld	bc, #0xb5c8
00155$:
	push	bc
	ld	a, #0x07
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_fail
	jp	00150$
00104$:
;src/field_actions.c:34: cost=rpg_magic_cost(spell);p=&c->rpg->party[caster];
	ldhl	sp,	#17
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_rpg_magic_cost
	ld	hl, #_rpg_magic_cost
	call	___sdcc_bcall_ehl
	inc	sp
	ld	c, a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#16
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
	ld	e, l
	ld	d, h
;src/field_actions.c:35: if(p->mp<cost)return fail(a,RPG_NO_MP,0xb6f7);
	inc	de
	inc	de
	ld	a, (de)
	ld	l, a
	sub	a, c
	jr	NC, 00106$
	ld	de, #0xb6f7
	push	de
	ld	a, #0x06
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_fail
	jp	00150$
00106$:
;src/field_actions.c:36: if(spell==MagicID_Heal||spell==MagicID_Cure){
	push	hl
	ldhl	sp,	#19
	ld	a, (hl)
	dec	a
	pop	hl
	jr	Z, 00111$
	push	hl
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x02
	pop	hl
	jr	NZ, 00112$
00111$:
;src/field_actions.c:37: if(target==255u)return FIELD_DONE;
	ldhl	sp,	#18
	ld	a, (hl)
	inc	a
	jp	Z, 00150$
;src/field_actions.c:38: error=rpg_cast_heal(c->rpg,caster,target,spell,0);if(error)return fail(a,error,0xb730);
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl-)
	dec	hl
	ld	e, a
	push	de
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
	ld	c, a
	or	a, a
	jr	Z, 00110$
	ld	de, #0xb730
	push	de
	ld	a, c
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_fail
	jp	00150$
00110$:
;src/field_actions.c:39: a->sound_start=0xab;line(a,0xb1d0);a->lines[0].sound_after=0xc1;return FIELD_DONE;
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	b, h
	ld	(hl), #0xab
	ld	bc, #0xb1d0
	pop	de
	push	de
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x000d
	add	hl, bc
	ld	(hl), #0xc1
	xor	a, a
	jp	00150$
00112$:
;src/field_actions.c:41: p->mp-=cost;
	ld	a, l
	sub	a, c
	ld	(de), a
;src/field_actions.c:42: switch(spell){
	ldhl	sp,	#17
	ld	a, (hl)
	sub	a, #0x0c
	jp	C, 00148$
	ld	a, #0x12
	sub	a, (hl)
	jp	C, 00148$
	ld	a, (hl)
	add	a, #0xf4
	ld	c, a
	ld	b, #0x00
	ld	hl, #00312$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00312$:
	.dw	00114$
	.dw	00122$
	.dw	00126$
	.dw	00133$
	.dw	00143$
	.dw	00143$
	.dw	00144$
;src/field_actions.c:43: case MagicID_Trap:
00114$:
;src/field_actions.c:44: a->sound_start=0xab;
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	b, h
	ld	(hl), #0xab
;src/field_actions.c:45: if(c->chest){rpg_battle_prepare_chest(c->rpg,c->chest);line(a,c->chest->chest_visual==0x3du?0xb27f:0xb28e);c->chest->chest_visual=0x3d;c->chest->trap_kind=BATTLE_TRAP_NONE;a->kind=FIELD_CHEST_OPEN;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
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
	inc	de
	ld	a, (de)
	ld	b, a
	or	a, c
	jr	Z, 00120$
	dec	hl
	dec	hl
	dec	hl
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
	ld	e, #b_rpg_battle_prepare_chest
	ld	hl, #_rpg_battle_prepare_chest
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x00a7
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x3d
	jr	NZ, 00156$
	ld	bc, #0xb27f
	jr	00157$
00156$:
	ld	bc, #0xb28e
00157$:
	pop	de
	push	de
	call	_line
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x00a7
	add	hl, bc
	ld	(hl), #0x3d
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x00a3
	add	hl, bc
	ld	(hl), #0x00
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x05
	ld	(bc), a
	jp	00149$
00120$:
;src/field_actions.c:46: else if(!c->interaction&&floor_trap(c)){c->dungeon->layout[dungeon_sample_position(c->dungeon,1u)]=0;line(a,0xb28e);a->kind=FIELD_REDRAW;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00116$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_floor_trap
	or	a, a
	jr	Z, 00116$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0008
	add	hl, bc
	ld	e, l
	ld	d, h
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	l, a
	pop	de
	ld	h, #0x00
	add	hl, de
	ld	(hl), #0x00
	ld	bc, #0xb28e
	pop	de
	push	de
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x01
	ld	(bc), a
	jp	00149$
00116$:
;src/field_actions.c:47: else line(a,0xb569);break;
	ld	bc, #0xb569
	pop	de
	push	de
	call	_line
	jp	00149$
;src/field_actions.c:48: case MagicID_Exit:
00122$:
;src/field_actions.c:49: if(c->interaction)line(a,0xb172);else{a->sound_start=0xbf;line(a,0xb59c);a->kind=FIELD_EXIT_DUNGEON;}break;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00124$
	ld	bc, #0xb172
	pop	de
	push	de
	call	_line
	jp	00149$
00124$:
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	b, h
	ld	(hl), #0xbf
	ld	bc, #0xb59c
	pop	de
	push	de
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x02
	ld	(bc), a
	jp	00149$
;src/field_actions.c:50: case MagicID_Open:
00126$:
;src/field_actions.c:51: a->sound_start=0xab;
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	b, h
	ld	(hl), #0xab
;src/field_actions.c:52: if(c->interaction||!c->dungeon){line(a,0xb172);break;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00127$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	or	a, h
	jr	NZ, 00128$
00127$:
	ld	bc, #0xb172
	pop	de
	push	de
	call	_line
	jp	00149$
00128$:
;src/field_actions.c:53: position=dungeon_sample_position(c->dungeon,1u);cell=c->dungeon->layout[position];
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	push	hl
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0008
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, (hl)
	ld	b, c
;src/field_actions.c:54: if((cell&7u)!=6u||(cell&128u)){line(a,0xb172);break;}
	ld	a, b
	and	a, #0x07
	sub	a, #0x06
	jr	NZ, 00130$
	bit	7, b
	jr	Z, 00131$
00130$:
	ld	bc, #0xb172
	pop	de
	push	de
	call	_line
	jp	00149$
00131$:
;src/field_actions.c:55: c->dungeon->layout[position]|=128;a->kind=FIELD_OPEN_DOOR;a->target=position;a->a=4;a->sound_end=0xbd;break;
	set	7, c
	ld	(hl), c
	pop	hl
	ld	(hl), #0x04
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(bc), a
	pop	de
	push	de
	ld	hl, #0x0006
	add	hl, de
	ld	(hl), #0x04
	pop	de
	push	de
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0xbd
	jp	00149$
;src/field_actions.c:56: case MagicID_Rise:
00133$:
;src/field_actions.c:57: if(target==255u)break; /* MP was spent before source target selection. */
	ldhl	sp,	#18
	ld	a, (hl)
	inc	a
	jp	Z, 00149$
;src/field_actions.c:58: a->sound_start=0xab;
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	b, h
	ld	(hl), #0xab
;src/field_actions.c:59: if(target>=4u||!(c->rpg->joined_mask&(1u<<target)))return fail(a,RPG_INVALID,0);
	ldhl	sp,	#18
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00136$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0059
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	push	af
	ld	de, #0x0001
	pop	af
	inc	a
	jr	00320$
00319$:
	sla	e
	rl	d
00320$:
	dec	a
	jr	NZ,00319$
	ldhl	sp,	#7
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	and	a, e
	ld	e, #0x00
	or	a, e
	jr	NZ, 00137$
00136$:
	ld	de, #0x0000
	push	de
	ld	a, #0x01
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_fail
	jp	00150$
00137$:
;src/field_actions.c:60: p=&c->rpg->party[target];if(p->status&1u)line(a,0xb709);
	ldhl	sp,	#18
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	rrca
	jr	NC, 00140$
	ld	bc, #0xb709
	pop	de
	push	de
	call	_line
	jp	00149$
00140$:
;src/field_actions.c:61: else{p->status=1;p->hp=p->max_hp;p->mp=p->max_mp;line(a,0xb5b0);}break;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
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
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
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
	ld	bc, #0xb5b0
	pop	de
	push	de
	call	_line
	jr	00149$
;src/field_actions.c:62: case MagicID_Tele:case MagicID_Chat:a->sound_start=0xac;tele(c,a);break;
00143$:
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	(hl), #0xac
	pop	bc
	push	bc
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_tele
	jr	00149$
;src/field_actions.c:63: case MagicID_Fly:
00144$:
;src/field_actions.c:64: a->sound_start=0xab;if(!c->interaction)line(a,0xb172);else {line(a,0xb59c);a->sound_end=0xbf;transfer(c,a);}break;
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	b, h
	ld	(hl), #0xab
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00146$
	ld	bc, #0xb172
	pop	de
	push	de
	call	_line
	jr	00149$
00146$:
	ld	bc, #0xb59c
	pop	de
	push	de
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0009
	add	hl, bc
	ld	(hl), #0xbf
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_transfer
	jr	00149$
;src/field_actions.c:65: default:a->kind=FIELD_UNIMPLEMENTED;a->error=RPG_NOT_IMPLEMENTED;break;
00148$:
	pop	hl
	ld	(hl), #0xff
	push	hl
	inc	hl
	ld	(hl), #0x08
;src/field_actions.c:66: }
00149$:
;src/field_actions.c:67: return a->kind;
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
00150$:
;src/field_actions.c:68: }
	add	sp, #8
	ret
;src/field_actions.c:69: static uint8_t key(FieldContext *c,FieldAction *a,uint8_t miracle){
;	---------------------------------
; Function key
; ---------------------------------
_key:
	add	sp, #-9
	ldhl	sp,	#7
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
;src/field_actions.c:71: if(c->interaction||!c->dungeon){line(a,0xb366);line(a,0xb569);return FIELD_DONE;}
	ld	a, b
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00101$
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
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
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	or	a, c
	jr	NZ, 00102$
00101$:
	ld	bc, #0xb366
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	ld	bc, #0xb569
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	xor	a, a
	jp	00112$
00102$:
;src/field_actions.c:72: line(a,0xb2ac);position=dungeon_sample_position(c->dungeon,1u);cell=c->dungeon->layout[position];kind=cell&7u;
	ld	bc, #0xb2ac
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	h, #0x01
	push	hl
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0008
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl+)
	add	a, c
	ld	e, a
	ld	a, #0x00
	adc	a, b
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl+)
	ld	c, a
	and	a, #0x07
	ld	(hl), a
;src/field_actions.c:73: if(!(cell&128u)&&(kind==5u||(miracle&&kind==6u))){if(!c->in_battle)c->dungeon->layout[position]|=128;a->kind=FIELD_OPEN_DOOR;a->target=position;a->a=kind-2u;a->sound_end=0xbd;}
	ldhl	sp,	#5
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	bit	7, c
	jr	NZ, 00107$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x05
	jr	Z, 00106$
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00107$
00106$:
	push	de
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00105$
	ldhl	sp,	#1
	ld	a, (hl)
	set	7, a
	ld	(de), a
00105$:
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x04
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl)
	dec	a
	dec	a
	ld	(bc), a
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0xbd
	jr	00108$
00107$:
;src/field_actions.c:74: else line(a,0xb2cd);
	ld	bc, #0xb2cd
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
00108$:
;src/field_actions.c:75: return a->kind;
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
00112$:
;src/field_actions.c:76: }
	add	sp, #9
	pop	hl
	inc	sp
	jp	(hl)
;src/field_actions.c:77: uint8_t field_use_item(FieldContext *c,uint8_t slot,uint8_t target,FieldAction *a) RPG_BANKED {
;	---------------------------------
; Function field_use_item
; ---------------------------------
	b_field_use_item	= 11
_field_use_item::
	add	sp, #-9
;src/field_actions.c:79: memset(a,0,sizeof(*a));a->character=target<4u?target:0;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0016
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#18
	ld	a,(hl)
	cp	a,#0x04
	jr	C, 00187$
	xor	a, a
00187$:
	ld	(bc), a
;src/field_actions.c:80: if(slot>=c->rpg->inventory_count)return fail(a,RPG_INVALID,0);
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0058
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,	#17
	ld	a, (hl)
	sub	a, c
	jr	C, 00102$
	ld	de, #0x0000
	push	de
	ld	a, #0x01
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_fail
	jp	00184$
00102$:
;src/field_actions.c:81: item=c->rpg->inventory[slot];a->item=item;
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0040
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
	pop	bc
	push	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/field_actions.c:82: switch(item){
	ld	a, (hl)
	sub	a, #0x04
	jp	Z, 00179$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x21
	jp	Z, 00177$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x22
	jp	Z, 00177$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x23
	jp	Z, 00177$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x24
	jp	Z, 00104$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x25
	jr	Z, 00104$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x26
	jp	Z, 00109$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x27
	jp	Z, 00113$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x28
	jp	Z, 00179$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x29
	jp	Z, 00120$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x2a
	jp	Z, 00127$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x2b
	jp	Z, 00136$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x2c
	jp	Z, 00136$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x2d
	jp	Z, 00133$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x2e
	jp	Z, 00130$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x2f
	jp	Z, 00140$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x30
	jp	Z, 00147$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x31
	jp	Z, 00155$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x32
	jp	Z, 00165$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x35
	jp	Z, 00169$
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x3e
	jp	Z, 00134$
	jp	00182$
;src/field_actions.c:83: case ItemID_Cola:case ItemID_Burger:
00104$:
;src/field_actions.c:84: if(target==255u)break;
	ldhl	sp,	#18
	ld	a, (hl)
	inc	a
	jp	Z, 00183$
;src/field_actions.c:85: error=rpg_use_item(c->rpg,slot,target);if(error)return fail(a,error,0xb730);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ldhl	sp,	#18
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#7
	ld	h, (hl)
	push	hl
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_rpg_use_item
	ld	hl, #_rpg_use_item
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	c, a
	or	a, a
	jr	Z, 00108$
	ld	de, #0xb730
	push	de
	ld	a, c
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_fail
	jp	00184$
00108$:
;src/field_actions.c:86: line(a,0xb2ac);line(a,0xb1d0);a->lines[1].sound_after=0xc1;break;
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ld	bc, #0xb1d0
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0011
	add	hl, bc
	ld	(hl), #0xc1
	jp	00183$
;src/field_actions.c:87: case ItemID_Flute:
00109$:
;src/field_actions.c:88: line(a,0xb2ac);line(a,c->in_battle?0xb322:0xbfc4);a->lines[1].sound_before=0xc2;a->lines[1].sound_after=0xd5;
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00188$
	ld	de, #0xb322
	jr	00189$
00188$:
	ld	de, #0xbfc4
00189$:
	push	bc
	ld	c, e
	ld	b, d
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	pop	bc
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	add	hl, de
	ld	(hl), #0xc2
	ld	hl, #0x0011
	add	hl, de
	ld	(hl), #0xd5
;src/field_actions.c:89: if(!c->in_battle&&!c->interaction){line(a,0xb59c);a->lines[2].sound_before=0xbf;a->kind=FIELD_EXIT_DUNGEON;}break;
	ld	a, (bc)
	or	a, a
	jp	NZ, 00183$
	push	de
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jp	NZ, 00183$
	ld	bc, #0xb59c
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0014
	add	hl, bc
	ld	(hl), #0xbf
	ld	a, #0x02
	ld	(bc), a
	jp	00183$
;src/field_actions.c:90: case ItemID_Flash:
00113$:
;src/field_actions.c:91: if(c->in_battle){line(a,0xb366);line(a,0xb35c);break;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00115$
	ld	bc, #0xb366
	pop	de
	push	de
	call	_line
	ld	bc, #0xb35c
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00115$:
;src/field_actions.c:92: if(c->interaction||!c->dungeon||c->dungeon->light){line(a,0xb366);line(a,0xb375);break;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00116$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
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
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	or	a, c
	jr	Z, 00116$
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	or	a, a
	jr	Z, 00117$
00116$:
	ld	bc, #0xb366
	pop	de
	push	de
	call	_line
	ld	bc, #0xb375
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00117$:
;src/field_actions.c:93: line(a,0xb2ac);rpg_remove_item(c->rpg,slot);c->dungeon->light=255;dungeon_refresh_light(c->dungeon);a->kind=FIELD_REDRAW;break;
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	h, (hl)
	push	hl
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0xff
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	push	bc
	ld	e, #b_dungeon_refresh_light
	ld	hl, #_dungeon_refresh_light
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x01
	ld	(bc), a
	jp	00183$
;src/field_actions.c:94: case ItemID_Transfer:
00120$:
;src/field_actions.c:95: line(a,0xb2ac);if(c->in_battle)line(a,0xb2cd);else if(!c->interaction)line(a,0xb312);
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00125$
	ld	bc, #0xb2cd
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00125$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00122$
	ld	bc, #0xb312
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00122$:
;src/field_actions.c:96: else{rpg_remove_item(c->rpg,slot);line(a,0xb59c);a->sound_end=0xbf;transfer(c,a);}break;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	h, (hl)
	push	hl
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	bc, #0xb59c
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0009
	add	hl, bc
	ld	(hl), #0xbf
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_transfer
	jp	00183$
;src/field_actions.c:97: case ItemID_MagicHat:
00127$:
;src/field_actions.c:98: if(c->in_battle){a->kind=FIELD_UNIMPLEMENTED;a->error=RPG_NOT_IMPLEMENTED;break;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00129$
	pop	hl
	ld	(hl), #0xff
	push	hl
	inc	hl
	ld	(hl), #0x08
	jp	00183$
00129$:
;src/field_actions.c:99: rpg_remove_item(c->rpg,slot);line(a,0xb2ac);line(a,0xb2cd);break;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	h, (hl)
	push	hl
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ld	bc, #0xb2cd
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
;src/field_actions.c:100: case ItemID_Sphere:
00130$:
;src/field_actions.c:101: if(c->in_battle){a->kind=FIELD_UNIMPLEMENTED;a->error=RPG_NOT_IMPLEMENTED;break;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00132$
	pop	hl
	ld	(hl), #0xff
	push	hl
	inc	hl
	ld	(hl), #0x08
	jp	00183$
00132$:
;src/field_actions.c:102: rpg_remove_item(c->rpg,slot);line(a,0xb2ac);tele(c,a);break;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	h, (hl)
	push	hl
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_tele
	jp	00183$
;src/field_actions.c:103: case ItemID_DungeonKey:return key(c,a,0);
00133$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_key
	jp	00184$
;src/field_actions.c:104: case ItemID_MiracleKey:return key(c,a,1);
00134$:
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_key
	jp	00184$
;src/field_actions.c:105: case ItemID_Alsulin:case ItemID_Polymaterial:
00136$:
;src/field_actions.c:106: if(c->in_battle){line(a,0xb366);line(a,0xb35c);}else{a->kind=FIELD_STORY_ITEM;a->target=slot;}break;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
	or	a, a
	jr	Z, 00138$
	ld	bc, #0xb366
	pop	de
	push	de
	call	_line
	ld	bc, #0xb35c
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00138$:
	pop	hl
	ld	(hl), #0x0a
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(bc), a
	jp	00183$
;src/field_actions.c:107: case ItemID_EclipseTorch:
00140$:
;src/field_actions.c:108: line(a,0xb458);
	ld	bc, #0xb458
	pop	de
	push	de
	call	_line
;src/field_actions.c:109: if(c->in_battle)line(a,0xb431);else if(c->event_id!=0xafu)line(a,0xb312);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00145$
	ld	bc, #0xb431
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00145$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0xaf
	jr	Z, 00142$
	ld	bc, #0xb312
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00142$:
;src/field_actions.c:110: else {a->kind=FIELD_TORCH_SCENE;a->target=slot;}break;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x09
	ld	(bc), a
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(bc), a
	jp	00183$
;src/field_actions.c:111: case ItemID_AeroPrism:
00147$:
;src/field_actions.c:112: line(a,0xb458);if(c->in_battle)line(a,0xb35c);else if(c->event_id!=0xb0u||c->projection==255u)line(a,0xb312);
	ld	bc, #0xb458
	pop	de
	push	de
	call	_line
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00153$
	ld	bc, #0xb35c
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00153$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0xb0
	jr	NZ, 00148$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	jr	NZ, 00149$
00148$:
	ld	bc, #0xb312
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00149$:
;src/field_actions.c:113: else{line(a,0xb4d5);c->projection=255;a->kind=FIELD_PRISM;}break;
	push	bc
	ld	bc, #0xb4d5
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	pop	bc
	ld	a, #0xff
	ld	(bc), a
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x07
	ld	(bc), a
	jp	00183$
;src/field_actions.c:114: case ItemID_Nuts:
00155$:
;src/field_actions.c:115: if(c->rpg->party[1].status && ((c->map_id==23u&&c->interaction&&!c->in_battle)||(c->map_id!=23u&&c->event_id==0xb0u&&c->projection==255u))){line(a,0xb743);a->kind=FIELD_MYAU_FLY;}
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0010
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00157$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	sub	a, #0x17
	jr	NZ, 00163$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	Z, 00163$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	Z, 00156$
00163$:
	ld	a, c
	sub	a, #0x17
	jr	Z, 00157$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0xb0
	jr	NZ, 00157$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	jr	NZ, 00157$
00156$:
	ld	bc, #0xb743
	pop	de
	push	de
	call	_line
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x08
	ld	(bc), a
	jp	00183$
00157$:
;src/field_actions.c:116: else{line(a,0xb366);line(a,c->in_battle?0xb35c:0xb500);}break;
	ld	bc, #0xb366
	pop	de
	push	de
	call	_line
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00190$
	ld	bc, #0xb35c
	jr	00191$
00190$:
	ld	bc, #0xb500
00191$:
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
;src/field_actions.c:117: case ItemID_Hapsby:if(c->in_battle){line(a,0xb2ac);line(a,0xb52c);}else line(a,0xb544);break;
00165$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00167$
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ld	bc, #0xb52c
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00167$:
	ld	bc, #0xb544
	pop	de
	push	de
	call	_line
	jp	00183$
;src/field_actions.c:118: case ItemID_Compass:
00169$:
;src/field_actions.c:119: if(c->interaction||c->in_battle||!c->dungeon){line(a,0xb366);line(a,c->in_battle?0xb35c:0xb375);}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00170$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00170$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
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
	ld	c, a
	inc	de
	ld	a, (de)
	or	a, c
	jr	NZ, 00171$
00170$:
	ld	bc, #0xb366
	pop	de
	push	de
	call	_line
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
	or	a, a
	jr	Z, 00192$
	dec	hl
	ld	a, #0x5c
	ld	(hl+), a
	ld	(hl), #0xb3
	jr	00193$
00192$:
	ldhl	sp,	#7
	ld	a, #0x75
	ld	(hl+), a
	ld	(hl), #0xb3
00193$:
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jp	00183$
00171$:
;src/field_actions.c:120: else{line(a,0xb2ac);line(a,compass[c->dungeon->direction&3u]);}break;
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ld	bc, #_field_use_item_compass_10000_140+0
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	inc	hl
	inc	hl
	ld	a, (hl)
	and	a, #0x03
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jr	00183$
;src/field_actions.c:121: case ItemID_Landrover:case ItemID_Hovercraft:case ItemID_IceDigger:a->kind=FIELD_VEHICLE;a->target=slot;break;
00177$:
	pop	hl
	ld	(hl), #0x0b
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(bc), a
	jr	00183$
;src/field_actions.c:122: case ItemID_Wand:case ItemID_Escaper:
00179$:
;src/field_actions.c:123: if(c->in_battle){a->kind=FIELD_UNIMPLEMENTED;a->error=RPG_NOT_IMPLEMENTED;break;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00181$
	pop	hl
	ld	(hl), #0xff
	push	hl
	inc	hl
	ld	(hl), #0x08
	jr	00183$
00181$:
;src/field_actions.c:124: line(a,0xb2ac);line(a,0xb312);break;
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ld	bc, #0xb312
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
	jr	00183$
;src/field_actions.c:125: default:
00182$:
;src/field_actions.c:126: line(a,0xb2ac);line(a,item>=ItemID_RoadPass?(c->in_battle?0xb312:0xb555):0xb2cd);break;
	ld	bc, #0xb2ac
	pop	de
	push	de
	call	_line
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x33
	jr	C, 00194$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00196$
	ld	bc, #0xb312
	jr	00195$
00196$:
	ld	bc, #0xb555
	jr	00195$
00194$:
	ld	bc, #0xb2cd
00195$:
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_line
;src/field_actions.c:127: }
00183$:
;src/field_actions.c:128: return a->kind;
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
00184$:
;src/field_actions.c:129: }
	add	sp, #9
	ret
_field_use_item_compass_10000_140:
	.dw #0xbd01
	.dw #0xbced
	.dw #0xbd0c
	.dw #0xbcf7
;src/field_actions.c:132: void field_torch_reply(RPGState *r,FieldAction *a) RPG_BANKED {
;	---------------------------------
; Function field_torch_reply
; ---------------------------------
	b_field_torch_reply	= 11
_field_torch_reply::
;src/field_actions.c:133: if(a->kind!=FIELD_TORCH_SCENE||a->b)return;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x09
	ret	NZ
	ld	hl, #0x0007
	add	hl, de
	ld	a, (hl)
	or	a, a
	ret	NZ
;src/field_actions.c:134: a->b=1;
	ld	(hl), #0x01
;src/field_actions.c:135: if(rpg_find_item(r,ItemID_LaconiaPot)==RPG_NO_SLOT)line(a,0xb49a);
	push	de
	ld	a, #0x38
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	inc	a
	jr	NZ, 00105$
	ld	bc, #0xb49a
	jp	_line
00105$:
;src/field_actions.c:136: else {rpg_remove_item(r,a->target);a->a=1;line(a,0xb471);}
	ld	hl, #0x0005
	add	hl, de
	ld	a, (hl)
	push	de
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	ld	hl, #0x0006
	add	hl, de
	ld	(hl), #0x01
	ld	bc, #0xb471
;src/field_actions.c:137: }
	jp	_line
;src/field_actions.c:138: void field_torch_finish(RPGState *r,FieldAction *a) RPG_BANKED {
;	---------------------------------
; Function field_torch_finish
; ---------------------------------
	b_field_torch_finish	= 11
_field_torch_finish::
	dec	sp
	dec	sp
;src/field_actions.c:139: if(a->kind!=FIELD_TORCH_SCENE||a->b!=1u)return;
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	sp
	inc	sp
	push	bc
	pop	de
	push	de
	ld	a, (de)
	sub	a, #0x09
	jr	NZ, 00108$
	ld	hl, #0x0007
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	dec	a
	jr	NZ, 00108$
;src/field_actions.c:140: if(a->a&&rpg_find_item(r,ItemID_Nuts)==RPG_NO_SLOT&&rpg_add_item(r,ItemID_Nuts)==RPG_OK)a->sound_end=0xb3;
	ld	hl, #0x0006
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00105$
	push	bc
	push	de
	ld	a, #0x31
	push	af
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	pop	bc
	inc	a
	jr	NZ, 00105$
	push	bc
	push	de
	ld	a, #0x31
	push	af
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	e, #b_rpg_add_item
	ld	hl, #_rpg_add_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	pop	bc
	or	a, a
	jr	NZ, 00105$
	ld	hl, #0x0009
	add	hl, bc
	ld	(hl), #0xb3
00105$:
;src/field_actions.c:141: a->b=2;a->kind=FIELD_DONE;
	ld	a, #0x02
	ld	(de), a
	pop	hl
	ld	(hl), #0x00
	push	hl
00108$:
;src/field_actions.c:142: }
	inc	sp
	inc	sp
	ret
	.area _CODE_11
	.area _INITIALIZER
	.area _CABS (ABS)
