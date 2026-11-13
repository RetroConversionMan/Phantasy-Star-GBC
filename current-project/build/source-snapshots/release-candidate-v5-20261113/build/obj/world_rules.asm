;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module world_rules
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl b_rpg_find_item
	.globl _rpg_find_item
	.globl b_world_interaction_type
	.globl _world_interaction_type
	.globl b_travel_route
	.globl _travel_route
	.globl b_world_special
	.globl _world_special
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
	.area _CODE_12
;src/world_rules.c:6: uint8_t world_interaction_type(uint8_t group,uint8_t type) RPG_BANKED {
;	---------------------------------
; Function world_interaction_type
; ---------------------------------
	b_world_interaction_type	= 12
_world_interaction_type::
;src/world_rules.c:8: if(!group&&type==5u)type=4u;
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	NZ, 00113$
	inc	hl
	ld	a, (hl)
	sub	a, #0x05
	jr	NZ, 00113$
	ldhl	sp,	#7
	ld	(hl), #0x04
	jr	00114$
00113$:
;src/world_rules.c:9: else if((group==1u||group==7u)&&type==1u)type=5u;
	ldhl	sp,	#6
	ld	a, (hl)
	dec	a
	jr	Z, 00111$
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00108$
00111$:
	ldhl	sp,	#7
	ld	a, (hl)
	dec	a
	jr	NZ, 00108$
	ldhl	sp,	#7
	ld	(hl), #0x05
	jr	00114$
00108$:
;src/world_rules.c:10: else if(group==8u)type=6u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00105$
	ldhl	sp,	#7
	ld	(hl), #0x06
	jr	00114$
00105$:
;src/world_rules.c:11: else if(group==10u&&type==9u)type=8u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x0a
	jr	NZ, 00114$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x09
	jr	NZ, 00114$
	ldhl	sp,	#7
	ld	(hl), #0x08
00114$:
;src/world_rules.c:12: return type?type:1u;
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
	ld	a, (hl)
	ret
00118$:
	ld	a, #0x01
;src/world_rules.c:13: }
	ret
;src/world_rules.c:25: uint8_t travel_route(uint8_t tag,WorldAction *departure,WorldAction *arrival,WorldAction *exit) RPG_BANKED {
;	---------------------------------
; Function travel_route
; ---------------------------------
	b_travel_route	= 12
_travel_route::
	add	sp, #-8
;src/world_rules.c:26: uint8_t i,index=(tag&127u)-1u;
	ldhl	sp,	#14
	ld	a, (hl)
	push	af
	and	a, #0x7f
	ld	c, a
	pop	af
	dec	c
;src/world_rules.c:28: if(tag<0x81u||tag>0x88u)return 0;
	cp	a, #0x81
	jr	C, 00101$
	cp	a, #0x89
	jr	C, 00116$
00101$:
	xor	a, a
	jp	00107$
;src/world_rules.c:29: for(i=0;i<3u;++i) {
00116$:
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_ship_routes
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#7
	ld	(hl), #0x00
00105$:
;src/world_rules.c:30: out=i==0?departure:i==1?arrival:exit;memset(out,0,sizeof(*out));
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	NZ, 00109$
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, (hl)
	jr	00110$
00109$:
	ldhl	sp,	#7
	ld	a, (hl)
	dec	a
	jr	NZ, 00111$
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	c, (hl)
	jr	00112$
00111$:
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, (hl)
00112$:
00110$:
	ldhl	sp,	#4
	ld	(hl+), a
	ld	a, c
	ld	(hl-), a
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
;src/world_rules.c:31: out->mode=WORLD_ACTION_MAP;out->target=ship_routes[index][i*3u];
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x08
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#7
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	pop	hl
	push	hl
	ld	(hl), a
;src/world_rules.c:32: out->a=ship_routes[index][i*3u+1u];out->b=ship_routes[index][i*3u+2u];
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	inc	hl
	ld	b, a
	inc	bc
	inc	bc
	ld	a, (hl-)
	ld	e, a
	add	a, a
	add	a, e
	ld	(hl), a
	ld	e, (hl)
	inc	e
	ld	d, #0x00
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	inc	bc
	inc	bc
	ld	e, (hl)
	inc	e
	inc	e
	ld	d, #0x00
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/world_rules.c:29: for(i=0;i<3u;++i) {
	ldhl	sp,	#7
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jp	C, 00105$
;src/world_rules.c:34: return 1;
	ld	a, #0x01
00107$:
;src/world_rules.c:35: }
	add	sp, #8
	ret
_ship_routes:
	.db #0x00	; 0
	.db #0x39	; 57	'9'
	.db #0x43	; 67	'C'
	.db #0x01	; 1
	.db #0x8b	; 139
	.db #0x69	; 105	'i'
	.db #0x10	; 16
	.db #0x53	; 83	'S'
	.db #0x17	; 23
	.db #0x01	; 1
	.db #0x37	; 55	'7'
	.db #0x69	; 105	'i'
	.db #0x00	; 0
	.db #0x91	; 145
	.db #0x43	; 67	'C'
	.db #0x05	; 5
	.db #0x17	; 23
	.db #0x17	; 23
	.db #0x00	; 0
	.db #0x47	; 71	'G'
	.db #0x35	; 53	'5'
	.db #0x01	; 1
	.db #0x27	; 39
	.db #0x74	; 116	't'
	.db #0x0f	; 15
	.db #0x20	; 32
	.db #0x58	; 88	'X'
	.db #0x00	; 0
	.db #0x47	; 71	'G'
	.db #0x35	; 53	'5'
	.db #0x02	; 2
	.db #0x33	; 51	'3'
	.db #0x2d	; 45
	.db #0x13	; 19
	.db #0x18	; 24
	.db #0x1b	; 27
	.db #0x01	; 1
	.db #0x53	; 83	'S'
	.db #0x74	; 116	't'
	.db #0x00	; 0
	.db #0x1b	; 27
	.db #0x35	; 53	'5'
	.db #0x07	; 7
	.db #0x25	; 37
	.db #0x13	; 19
	.db #0x01	; 1
	.db #0x53	; 83	'S'
	.db #0x74	; 116	't'
	.db #0x02	; 2
	.db #0x33	; 51	'3'
	.db #0x2d	; 45
	.db #0x13	; 19
	.db #0x18	; 24
	.db #0x1b	; 27
	.db #0x02	; 2
	.db #0x5b	; 91
	.db #0x2d	; 45
	.db #0x00	; 0
	.db #0x1b	; 27
	.db #0x35	; 53	'5'
	.db #0x07	; 7
	.db #0x25	; 37
	.db #0x13	; 19
	.db #0x02	; 2
	.db #0x5b	; 91
	.db #0x2d	; 45
	.db #0x01	; 1
	.db #0x27	; 39
	.db #0x74	; 116	't'
	.db #0x0f	; 15
	.db #0x20	; 32
	.db #0x58	; 88	'X'
;src/world_rules.c:36: uint8_t world_special(RPGState *s,uint8_t map,uint8_t meta,uint8_t vehicle,
;	---------------------------------
; Function world_special
; ---------------------------------
	b_world_special	= 12
_world_special::
	add	sp, #-10
;src/world_rules.c:38: uint8_t damage=0,i;
	ldhl	sp,	#0
	ld	(hl), #0x00
;src/world_rules.c:39: memset(a,0,sizeof(*a));
	ldhl	sp,	#22
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
;src/world_rules.c:41: if(map==5u&&noah_flag) {a->kind=WORLD_RULE_DUNGEON;a->target=0;a->a=0xde;a->b=0;a->rollback=1;}
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	l, c
	ld	h, b
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ld	hl, #0x0004
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
;src/world_rules.c:40: if(meta==0x4cu) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x4c
	jr	NZ, 00128$
;src/world_rules.c:41: if(map==5u&&noah_flag) {a->kind=WORLD_RULE_DUNGEON;a->target=0;a->a=0xde;a->b=0;a->rollback=1;}
	ldhl	sp,	#18
	ld	a, (hl)
	sub	a, #0x05
	jp	NZ, 00129$
	ldhl	sp,	#21
	ld	a, (hl)
	or	a, a
	jp	Z, 00129$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x0a
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	(hl), #0xde
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x00
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	jp	00129$
00128$:
;src/world_rules.c:42: } else if(meta==0x5eu) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x5e
	jr	NZ, 00125$
;src/world_rules.c:43: if(!vehicle&&rpg_find_item(s,ItemID_Compass)==RPG_NO_SLOT) {a->kind=WORLD_RULE_EVENT;a->target=160;a->rollback=1;}
	ldhl	sp,	#20
	ld	a, (hl)
	or	a, a
	jp	NZ, 00129$
	push	bc
	ld	a, #0x35
	push	af
	inc	sp
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	inc	a
	jp	NZ, 00129$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x0c
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0xa0
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	jr	00129$
00125$:
;src/world_rules.c:44: } else if(meta>=0x5fu&&meta<0x64u) {
	ldhl	sp,	#19
	ld	a,(hl)
	cp	a,#0x5f
	jr	C, 00121$
	sub	a, #0x64
	jr	NC, 00121$
;src/world_rules.c:45: if(vehicle!=8u)damage=2;
	inc	hl
	ld	a, (hl)
	sub	a, #0x08
	jr	Z, 00129$
	ldhl	sp,	#0
	ld	(hl), #0x02
	jr	00129$
00121$:
;src/world_rules.c:46: } else if(meta>=0xc3u&&meta<0xc7u) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0xc7
	ld	a, #0x00
	rla
	ld	e, a
	ld	a, (hl)
	sub	a, #0xc3
	jr	C, 00117$
	ld	a, e
	or	a, a
	jr	Z, 00117$
;src/world_rules.c:47: if(!vehicle){a->kind=WORLD_RULE_BATTLE;a->target=EnemyID_AntLion;a->rollback=1;}
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00129$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x0e
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x19
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	jr	00129$
00117$:
;src/world_rules.c:48: } else if(meta>=0xc7u&&meta<0xd2u) {
	bit	0, e
	jr	NZ, 00129$
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0xd2
	jr	NC, 00129$
;src/world_rules.c:49: if(rpg_find_item(s,ItemID_GasShield)==RPG_NO_SLOT)damage=30;
	push	bc
	ld	a, #0x3b
	push	af
	inc	sp
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	inc	a
	jr	NZ, 00129$
	ldhl	sp,	#0
	ld	(hl), #0x1e
00129$:
;src/world_rules.c:51: if(damage) {
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jp	Z, 00138$
;src/world_rules.c:52: for(i=0;i<4u;++i) if(s->party[i].status&1u) {
	ldhl	sp,	#16
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	(hl), #0x00
00139$:
	ldhl	sp,	#9
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ldhl	sp,	#5
	ld	(hl-), a
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
	ld	e, a
;src/world_rules.c:54: if(!s->party[i].hp){s->party[i].status=0;a->death_mask|=1u<<i;}
	ld	hl, #0x0005
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
;src/world_rules.c:52: for(i=0;i<4u;++i) if(s->party[i].status&1u) {
	bit	0, e
	jr	Z, 00140$
;src/world_rules.c:53: s->party[i].hp=s->party[i].hp>damage?s->party[i].hp-damage:0u;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#5
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	inc	hl
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#8
	sub	a, (hl)
	jr	NC, 00143$
	ld	a, (hl)
	ldhl	sp,	#0
	sub	a, (hl)
	jr	00144$
00143$:
	xor	a, a
00144$:
;src/world_rules.c:54: if(!s->party[i].hp){s->party[i].status=0;a->death_mask|=1u<<i;}
	ld	(de), a
	or	a, a
	jr	NZ, 00140$
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#5
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	(de), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	ld	a, (hl)
	push	af
	ld	e, #0x01
	pop	af
	inc	a
	jr	00313$
00312$:
	sla	e
00313$:
	dec	a
	jr	NZ,00312$
	dec	hl
	ld	a, (hl-)
	dec	hl
	or	a, e
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00140$:
;src/world_rules.c:52: for(i=0;i<4u;++i) if(s->party[i].status&1u) {
	ldhl	sp,	#9
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jp	C, 00139$
;src/world_rules.c:56: if(a->death_mask){a->kind=WORLD_RULE_EVENT;a->target=174;}
	dec	hl
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00138$
	inc	hl
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x0c
	inc	bc
	ld	a, #0xae
	ld	(bc), a
00138$:
;src/world_rules.c:58: return a->kind;
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
;src/world_rules.c:59: }
	add	sp, #10
	ret
	.area _CODE_12
	.area _INITIALIZER
	.area _CABS (ABS)
