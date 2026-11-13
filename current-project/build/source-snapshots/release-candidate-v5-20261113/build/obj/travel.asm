;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module travel
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl b_travel_begin
	.globl _travel_begin
	.globl b_travel_step
	.globl _travel_step
	.globl b_travel_space_row
	.globl _travel_space_row
	.globl b_travel_fade_color
	.globl _travel_fade_color
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
	.area _CODE_119
;src/travel.c:24: static void destination(TravelState *s,const uint8_t *p) {
;	---------------------------------
; Function destination
; ---------------------------------
_destination:
	add	sp, #-3
	ldhl	sp,	#1
	ld	a, e
	ld	(hl+), a
;src/travel.c:25: uint8_t row=((p[1]>>4)*12u+(p[1]&15u))%96u;
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	e, c
	ld	d, b
	inc	de
	ld	a, (de)
	ld	(hl), a
	swap	a
	and	a, #0x0f
	ld	e, a
	add	a, a
	add	a, e
	add	a, a
	add	a, a
	ld	e, (hl)
	push	af
	ld	a, e
	and	a, #0x0f
	ld	e, a
	pop	af
	add	a, e
	push	bc
	ld	e, #0x60
	call	__moduchar
	ld	a, c
	pop	bc
	ldhl	sp,	#0
;src/travel.c:26: s->map=p[0];s->x=((uint16_t)p[2]*16u+8u)&2047u;
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	ld	(de), a
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	l, a
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #0x0008
	add	hl, bc
	ld	a, h
	and	a, #0x07
	ld	c, a
	ld	a, l
	ld	(de), a
	inc	de
	ld	a, c
	ld	(de), a
;src/travel.c:27: s->y=((uint16_t)row*16u+16u)%1536u;
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	inc	de
	inc	de
	ld	c, (hl)
	xor	a, a
	ld	l, c
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
;src/travel.c:28: s->scroll=(s->y+1536u-112u)%192u;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0590
	add	hl, bc
	push	de
	ld	bc, #0x00c0
	ld	e, l
	ld	d, h
	call	__moduint
	pop	de
	ld	a, c
	ld	(de), a
;src/travel.c:29: }
	add	sp, #3
	ret
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
_routes:
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
_map_music:
	.db #0x82	; 130
	.db #0x83	; 131
	.db #0x84	; 132
	.db #0x84	; 132
	.db #0x87	; 135
	.db #0x87	; 135
	.db #0x87	; 135
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x87	; 135
	.db #0x87	; 135
	.db #0x87	; 135
	.db #0x88	; 136
	.db #0x87	; 135
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x84	; 132
	.db #0x84	; 132
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x85	; 133
;src/travel.c:30: static void fade_in(TravelState *s,uint8_t next) {
;	---------------------------------
; Function fade_in
; ---------------------------------
_fade_in:
	ld	c, a
;src/travel.c:31: s->stage=TRAVEL_FADE_IN;s->next_stage=next;s->fade_step=0;
	ld	hl, #0x0011
	add	hl, de
	ld	(hl), #0x01
	ld	hl, #0x0012
	add	hl, de
	ld	(hl), c
	ld	hl, #0x001f
	add	hl, de
	ld	(hl), #0x00
;src/travel.c:32: s->fade_clock=3;s->fade_in=1;s->phase_frames=0;
	ld	hl, #0x0020
	add	hl, de
	ld	(hl), #0x03
	ld	hl, #0x0021
	add	hl, de
	ld	(hl), #0x01
	ld	hl, #0x0006
	add	hl, de
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/travel.c:33: }
	ret
;src/travel.c:34: static uint8_t finish(TravelState *s) {
;	---------------------------------
; Function finish
; ---------------------------------
_finish:
;src/travel.c:35: s->stage=TRAVEL_EXIT_FADE;s->phase_frames=0;s->fade_step=0;
	ld	hl, #0x0011
	add	hl, de
	ld	(hl), #0x07
	ld	hl, #0x0006
	add	hl, de
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
	ld	hl, #0x001f
	add	hl, de
	ld	(hl), #0x00
;src/travel.c:36: s->fade_clock=3;s->fade_in=0;return TRAVEL_DRAW;
	ld	hl, #0x0020
	add	hl, de
	ld	(hl), #0x03
	ld	hl, #0x0021
	add	hl, de
	ld	(hl), #0x00
	ld	a, #0x20
;src/travel.c:37: }
	ret
;src/travel.c:38: uint8_t travel_begin(TravelState *s,uint8_t tag) TRAVEL_BANKED {
;	---------------------------------
; Function travel_begin
; ---------------------------------
	b_travel_begin	= 119
_travel_begin::
	add	sp, #-12
;src/travel.c:40: if(!((tag>=1u&&tag<=6u)||(tag>=0x81u&&tag<=0x88u)))return 0;
	ldhl	sp,	#20
	ld	a, (hl)
	sub	a, #0x01
	jr	C, 00105$
	ld	a, #0x06
	sub	a, (hl)
	jr	NC, 00102$
00105$:
	ldhl	sp,	#20
	ld	a, (hl)
	sub	a, #0x81
	jr	C, 00101$
	ld	a, #0x88
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	jp	00109$
00102$:
;src/travel.c:41: memset(s,0,sizeof(*s));s->tag=tag;
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0022
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0010
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#20
	ld	a, (hl)
	ld	(bc), a
;src/travel.c:44: direction=r[0];s->facing=direction==1u?1u:direction==2u?0u:direction==4u?2u:3u;
	pop	de
	push	de
	ld	hl, #0x0014
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
;src/travel.c:45: s->music=map_music[s->map];fade_in(s,TRAVEL_ROAD);
	pop	de
	push	de
	ld	hl, #0x0016
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0013
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
;src/travel.c:42: if(tag<0x80u) {
	ldhl	sp,	#20
;src/travel.c:43: const uint8_t *r=roads[tag-1u];destination(s,r+2);s->road_steps=r[1];
	ld	a,(hl)
	cp	a,#0x80
	jp	NC,00107$
	dec	a
	ldhl	sp,	#11
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x03
00168$:
	ldhl	sp,	#8
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00168$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_roads
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
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
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	call	_destination
	pop	de
	push	de
	ld	hl, #0x0017
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
;src/travel.c:44: direction=r[0];s->facing=direction==1u?1u:direction==2u?0u:direction==4u?2u:3u;
	ld	a, (hl-)
	ld	d, a
	inc	de
	ld	a, (de)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	cp	a, #0x01
	jr	NZ, 00111$
	ld	e, #0x01
	jr	00112$
00111$:
	cp	a, #0x02
	jr	NZ, 00113$
	ld	e, #0x00
	jr	00114$
00113$:
	sub	a, #0x04
	ld	e, #0x02
	jr	Z, 00116$
	ld	e, #0x03
00116$:
00114$:
00112$:
	ld	a, e
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/travel.c:45: s->music=map_music[s->map];fade_in(s,TRAVEL_ROAD);
	ld	bc, #_map_music+0
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, #0x02
	pop	de
	push	de
	call	_fade_in
	jr	00108$
00107$:
;src/travel.c:47: const uint8_t *r=routes[tag-0x81u];destination(s,r);s->facing=1;
	ld	bc, #_routes+0
	ldhl	sp,	#20
	ld	a, (hl)
	add	a, #0x7f
	ld	e, a
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), c
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	call	_destination
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;src/travel.c:48: s->ship_mode=tag<0x83u?16u:17u;s->planet=s->map;s->arrival_planet=r[3];
	pop	de
	push	de
	ld	hl, #0x0015
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#20
	ld	a, (hl)
	sub	a, #0x83
	jr	NC, 00117$
	ld	a, #0x10
	jr	00118$
00117$:
	ld	a, #0x11
00118$:
	ld	(bc), a
	pop	de
	push	de
	ld	hl, #0x001c
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(bc), a
	pop	de
	push	de
	ld	hl, #0x001d
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	inc	de
	ld	a, (de)
	ld	(bc), a
;src/travel.c:49: s->music=0xb8u;fade_in(s,TRAVEL_ASCEND);
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0xb8
	ld	a, #0x03
	pop	de
	push	de
	call	_fade_in
00108$:
;src/travel.c:51: return TRAVEL_WORLD|TRAVEL_AUDIO|TRAVEL_DRAW|TRAVEL_PALETTE;
	ld	a, #0x2d
00109$:
;src/travel.c:52: }
	add	sp, #12
	ret
;src/travel.c:53: static uint8_t space_begin(TravelState *s) {
;	---------------------------------
; Function space_begin
; ---------------------------------
_space_begin:
;src/travel.c:54: s->space_visible=1;s->scroll=s->fraction=0;s->turns=8;
	ld	hl, #0x001e
	add	hl, de
	ld	(hl), #0x01
	ld	hl, #0x001a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #0x0019
	add	hl, de
	ld	(hl), #0x00
	xor	a, a
	ld	(bc), a
	ld	hl, #0x001b
	add	hl, de
	ld	(hl), #0x08
;src/travel.c:55: s->updated_rows=s->arrival_rows=0;s->music=0x8fu;
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #0x000c
	add	hl, de
	xor	a, a
	ld	(hl+), a
	ld	(hl+), a
	ld	(hl+), a
	ld	(hl), a
	xor	a, a
	ld	(bc), a
	inc	bc
	ld	(bc), a
	inc	bc
	ld	(bc), a
	inc	bc
	ld	(bc), a
	ld	hl, #0x0016
	add	hl, de
	ld	(hl), #0x8f
;src/travel.c:56: fade_in(s,TRAVEL_SPACE_RUN);
	ld	a, #0x05
	call	_fade_in
;src/travel.c:57: return TRAVEL_SPACE|TRAVEL_AUDIO|TRAVEL_DRAW|TRAVEL_PALETTE;
	ld	a, #0x2e
;src/travel.c:58: }
	ret
;src/travel.c:59: static uint8_t arrive_begin(TravelState *s) {
;	---------------------------------
; Function arrive_begin
; ---------------------------------
_arrive_begin:
	push	de
;src/travel.c:60: destination(s,routes[s->tag-0x81u]+3);s->space_visible=0;s->music=0xb8u;
	ld	bc, #_routes+0
	pop	de
	push	de
	ld	hl, #0x0010
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	add	a, #0x7f
	ld	e, a
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	c, l
	ld	b, h
	pop	de
	push	de
	call	_destination
	pop	de
	push	de
	ld	hl, #0x001e
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	pop	de
	push	de
	ld	hl, #0x0016
	add	hl, de
	ld	b, h
	ld	(hl), #0xb8
;src/travel.c:63: s->fraction=s->turns;s->speed=0x800u;fade_in(s,TRAVEL_ARRIVE);
	pop	de
	push	de
	ld	hl, #0x0019
	add	hl, de
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	hl, #0x001b
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	pop	de
	push	de
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	inc	bc
	ld	a, #0x08
	ld	(bc), a
	ld	a, #0x06
	pop	de
	push	de
	call	_fade_in
;src/travel.c:64: return TRAVEL_WORLD|TRAVEL_AUDIO|TRAVEL_DRAW|TRAVEL_PALETTE;
	ld	a, #0x2d
;src/travel.c:65: }
	inc	sp
	inc	sp
	ret
;src/travel.c:66: static void move_ship(TravelState *s) {
;	---------------------------------
; Function move_ship
; ---------------------------------
_move_ship:
	add	sp, #-11
	ldhl	sp,	#9
	ld	a, e
	ld	(hl+), a
;src/travel.c:67: uint16_t fixed=((uint16_t)s->scroll<<8)|s->fraction;
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl-), a
	ld	(hl), #0x00
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0019
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	e, a
	ldhl	sp,	#2
	ld	(hl), e
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
;src/travel.c:68: uint8_t previous=s->scroll,delta;
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
;src/travel.c:69: fixed-=s->speed;s->fraction=(uint8_t)fixed;s->scroll=fixed>>8;
	ldhl	sp,#9
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
	ldhl	sp,	#5
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
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
	ld	a, (hl)
	pop	hl
	push	hl
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(bc), a
;src/travel.c:70: if(s->scroll>=224u)s->scroll-=32u;
	sub	a, #0xe0
	jr	C, 00102$
	ld	a, (bc)
	add	a, #0xe0
	ld	(bc), a
00102$:
;src/travel.c:71: delta=(previous-s->scroll)&15u;
	ld	a, (bc)
	ld	c, a
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, c
	and	a, #0x0f
	ld	c, a
;src/travel.c:72: s->y=(s->y+1536u-delta)%1536u;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
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
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	de, #0x0600
	add	hl, de
	ld	b, #0x00
	ld	a, l
	sub	a, c
	ld	e, a
	ld	a, h
	sbc	a, b
	ld	bc, #0x0600
	ld	d, a
	call	__moduint
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/travel.c:73: }
	add	sp, #11
	ret
;src/travel.c:74: static uint8_t fade_tick(TravelState *s) {
;	---------------------------------
; Function fade_tick
; ---------------------------------
_fade_tick:
;src/travel.c:75: if(s->fade_clock){--s->fade_clock;return 0;}
	ld	hl, #0x0020
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	dec	a
	ld	(hl), a
	xor	a, a
	ret
00102$:
;src/travel.c:76: s->fade_clock=3;++s->fade_step;return 1;
	ld	(hl), #0x03
	ld	hl, #0x001f
	add	hl, de
	inc	(hl)
	ld	a, #0x01
;src/travel.c:77: }
	ret
;src/travel.c:78: uint8_t travel_step(TravelState *s,uint8_t skip_pressed) TRAVEL_BANKED {
;	---------------------------------
; Function travel_step
; ---------------------------------
	b_travel_step	= 119
_travel_step::
	add	sp, #-18
;src/travel.c:79: uint8_t flags=TRAVEL_DRAW;
	ldhl	sp,	#17
	ld	(hl), #0x20
;src/travel.c:80: if(!s->tag||s->stage==TRAVEL_FINISHED)return 0;
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
	ld	hl, #0x0010
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
	ldhl	sp,	#16
	ld	(hl), a
	or	a, a
	jr	Z, 00101$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0011
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
	ld	a, (de)
	sub	a, #0x08
	jr	NZ, 00102$
00101$:
	xor	a, a
	jp	00171$
00102$:
;src/travel.c:81: ++s->phase_frames;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
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
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	inc	bc
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/travel.c:82: if(s->stage==TRAVEL_FADE_IN) {
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#12
	ld	(hl), a
;src/travel.c:84: if(s->fade_step==10u) {
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001f
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
;src/travel.c:82: if(s->stage==TRAVEL_FADE_IN) {
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	dec	a
	jp	NZ, 00113$
;src/travel.c:83: if(fade_tick(s))flags|=TRAVEL_PALETTE;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_fade_tick
	or	a, a
	jr	Z, 00105$
	ldhl	sp,	#17
	ld	(hl), #0x24
00105$:
;src/travel.c:84: if(s->fade_step==10u) {
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x0a
	jr	NZ, 00111$
;src/travel.c:85: s->fade_step=9;s->stage=s->next_stage;s->phase_frames=0;
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), #0x09
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0012
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
	ld	a, (de)
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/travel.c:86: if(s->stage==TRAVEL_ASCEND){s->fade_in=0;s->fade_step=0;s->fade_clock=3;}
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x03
	jr	NZ, 00107$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0021
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
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0020
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x03
00107$:
;src/travel.c:87: if(s->stage==TRAVEL_FINISHED)flags|=TRAVEL_DONE;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x08
	jr	NZ, 00111$
	ldhl	sp,	#17
	set	4, (hl)
00111$:
;src/travel.c:89: return flags;
	ldhl	sp,	#17
	ld	a, (hl)
	jp	00171$
00113$:
;src/travel.c:91: if(s->stage==TRAVEL_ROAD) {
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x02
	jp	NZ, 00130$
;src/travel.c:92: if(skip_pressed)return finish(s);
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00115$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00171$
00115$:
;src/travel.c:93: if(s->facing==0)s->y=(s->y+1u)%1536u;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl), a
	ldhl	sp,	#17
	ld	a, (hl)
	or	a, a
	jr	NZ, 00123$
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	e, c
	ld	d, a
	inc	de
	ld	bc, #0x0600
	call	__moduint
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	jr	00124$
00123$:
;src/travel.c:94: else if(s->facing==1)s->y=(s->y+1535u)%1536u;
	ldhl	sp,	#17
	ld	a, (hl)
	dec	a
	jr	NZ, 00120$
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#16
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#17
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x05ff
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl-), a
	ld	bc, #0x0600
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__moduint
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	jr	00124$
00120$:
;src/travel.c:95: else if(s->facing==2)s->x=(s->x-1u)&2047u;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	ld	a,	(hl+)
	ld	h, (hl)
	ld	e, a
	ld	d, h
	ldhl	sp,	#17
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00117$
	dec	de
	ld	a, d
	and	a, #0x07
	ld	d, a
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	jr	00124$
00117$:
;src/travel.c:96: else s->x=(s->x+1u)&2047u;
	inc	de
	ld	a, d
	and	a, #0x07
	ld	d, a
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
00124$:
;src/travel.c:97: if(++s->step_pixels==16u){s->step_pixels=0;if(!--s->road_steps)return finish(s);}
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0018
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	ld	(bc), a
	sub	a, #0x10
	jr	NZ, 00128$
	xor	a, a
	ld	(bc), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0017
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	dec	a
	ld	(bc), a
	or	a, a
	jr	NZ, 00128$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00171$
00128$:
;src/travel.c:98: return flags;
	ld	a, #0x20
	jp	00171$
00130$:
;src/travel.c:103: if((s->speed>>8)==7u&&fade_tick(s))flags|=TRAVEL_PALETTE;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl), a
;src/travel.c:100: if(s->stage==TRAVEL_ASCEND) {
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00139$
;src/travel.c:101: if(skip_pressed){s->stage=TRAVEL_ASCEND_FADE;s->phase_frames=0;return flags;}
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00132$
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x04
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
	ld	a, #0x20
	jp	00171$
00132$:
;src/travel.c:102: move_ship(s);
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_move_ship
;src/travel.c:103: if((s->speed>>8)==7u&&fade_tick(s))flags|=TRAVEL_PALETTE;
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	a, (de)
	sub	a, #0x07
	jr	NZ, 00134$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_fade_tick
	or	a, a
	jr	Z, 00134$
	ldhl	sp,	#17
	ld	(hl), #0x24
00134$:
;src/travel.c:104: s->speed+=8u;
	ldhl	sp,#15
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
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/travel.c:105: if(s->speed==0x800u){s->stage=TRAVEL_ASCEND_FADE;s->phase_frames=0;}
	ld	a, c
	or	a, a
	jr	NZ, 00137$
	ld	a, b
	sub	a, #0x08
	jr	NZ, 00137$
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x04
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00137$:
;src/travel.c:106: return flags;
	ldhl	sp,	#17
	ld	a, (hl)
	jp	00171$
00139$:
;src/travel.c:108: if(s->stage==TRAVEL_ASCEND_FADE) {
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00145$
;src/travel.c:109: if(fade_tick(s))flags|=TRAVEL_PALETTE;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_fade_tick
	ld	c, a
	or	a, a
	jr	Z, 00141$
	ldhl	sp,	#17
	ld	(hl), #0x24
00141$:
;src/travel.c:110: if(s->fade_step>=9u)return space_begin(s);
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x09
	jr	C, 00143$
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_space_begin
	jp	00171$
00143$:
;src/travel.c:111: return flags;
	ldhl	sp,	#17
	ld	a, (hl)
	jp	00171$
00145$:
;src/travel.c:113: if(s->stage==TRAVEL_SPACE_RUN) {
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x05
	jp	NZ, 00158$
;src/travel.c:114: uint8_t row=s->scroll>>3;uint32_t bit=(uint32_t)1u<<row;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001a
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
	ld	a, (de)
	ldhl	sp,	#16
	ld	(hl), a
	swap	a
	rlca
	and	a, #0x1f
	ld	(hl), a
	push	af
	ldhl	sp,	#2
	ld	a, #0x01
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl+), a
	ld	(hl), a
	pop	af
	inc	a
	jr	00442$
00441$:
	ldhl	sp,	#0
	sla	(hl)
	inc	hl
	rl	(hl)
	inc	hl
	rl	(hl)
	inc	hl
	rl	(hl)
00442$:
	dec	a
	jr	NZ,00441$
;src/travel.c:116: s->updated_rows|=bit;if(s->turns<=1u)s->arrival_rows|=bit;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#0
	or	a, (hl)
	ld	e, a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#1
	or	a, (hl)
	ld	d, a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#2
	or	a, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#5
	or	a, (hl)
	pop	hl
	ld	h, a
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	inc	bc
	ld	a, l
	ld	(bc), a
	inc	bc
	ld	a, h
	ld	(bc), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001b
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
	cp	a, #0x02
	jr	NC, 00147$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#0
	or	a, (hl)
	ld	e, a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#1
	or	a, (hl)
	ld	d, a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#2
	or	a, (hl)
	ld	l, a
	push	hl
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#5
	or	a, (hl)
	pop	hl
	ld	h, a
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	inc	bc
	ld	a, l
	ld	(bc), a
	inc	bc
	ld	a, h
	ld	(bc), a
00147$:
;src/travel.c:117: if(skip_pressed)return arrive_begin(s);
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00149$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_arrive_begin
	jp	00171$
00149$:
;src/travel.c:118: if(s->scroll<2u){s->scroll+=222u;--s->turns;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#16
	ld	(hl), a
	sub	a, #0x02
	jr	NC, 00153$
	ld	a, (hl)
	add	a, #0xde
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#16
	ld	a, (hl-)
	dec	hl
	ld	(de), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	dec	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/travel.c:119: if(s->turns==1u){s->planet=s->arrival_planet;flags|=TRAVEL_PALETTE|TRAVEL_SPACE;}
	dec	a
	jr	NZ, 00154$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001c
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001d
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#17
	ld	(hl), #0x26
	jr	00154$
00153$:
;src/travel.c:120: } else s->scroll-=2u;
	ldhl	sp,	#16
	ld	a, (hl)
	dec	a
	dec	a
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00154$:
;src/travel.c:121: if(!s->turns)return arrive_begin(s);
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00156$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_arrive_begin
	jp	00171$
00156$:
;src/travel.c:122: return flags;
	ldhl	sp,	#17
	ld	a, (hl)
	jp	00171$
00158$:
;src/travel.c:124: if(s->stage==TRAVEL_ARRIVE) {
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00164$
;src/travel.c:125: if(skip_pressed)return finish(s);
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00160$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00171$
00160$:
;src/travel.c:126: move_ship(s);
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_move_ship
;src/travel.c:127: if(s->speed<8u)return finish(s);
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ldhl	sp,	#13
	ld	(hl), c
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0x08
	ld	a, (hl)
	sbc	a, #0x00
	jr	NC, 00162$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00171$
00162$:
;src/travel.c:128: s->speed-=8u;return flags;
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#12
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
	ld	a, #0x20
	jp	00171$
00164$:
;src/travel.c:130: if(s->stage==TRAVEL_EXIT_FADE) {
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x07
	jp	NZ, 00170$
;src/travel.c:131: if(fade_tick(s))flags|=TRAVEL_PALETTE;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_fade_tick
	or	a, a
	jr	Z, 00166$
	ldhl	sp,	#17
	ld	(hl), #0x24
00166$:
;src/travel.c:132: if(s->fade_step>=9u) {
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x09
	jp	C, 00170$
;src/travel.c:133: destination(s,s->tag<0x80u?roads[s->tag-1u]+5:routes[s->tag-0x81u]+6);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#17
	ld	(hl), a
	sub	a, #0x80
	jr	NC, 00173$
	dec	(hl)
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x03
00449$:
	ldhl	sp,	#16
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00449$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_roads
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
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl), a
	jr	00174$
00173$:
	ld	bc, #_routes+0
	ldhl	sp,	#17
	ld	a, (hl)
	add	a, #0x7f
	ld	e, a
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	bc, #0x0006
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl), a
00174$:
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_destination
;src/travel.c:134: s->space_visible=s->ship_mode=0;s->music=map_music[s->map];
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x001e
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0015
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	(de), a
	ld	(bc), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0016
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ld	de, #_map_music
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (hl)
	ld	(de), a
;src/travel.c:135: fade_in(s,TRAVEL_FINISHED);
	ld	a, #0x08
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_fade_in
;src/travel.c:136: return TRAVEL_WORLD|TRAVEL_AUDIO|TRAVEL_DRAW|TRAVEL_PALETTE;
	ld	a, #0x2d
	jr	00171$
00170$:
;src/travel.c:139: return flags;
	ldhl	sp,	#17
	ld	a, (hl)
00171$:
;src/travel.c:140: }
	add	sp, #18
	ret
;src/travel.c:141: uint8_t travel_space_row(const TravelState *s,uint8_t row,uint8_t *source_row) TRAVEL_BANKED {
;	---------------------------------
; Function travel_space_row
; ---------------------------------
	b_travel_space_row	= 119
_travel_space_row::
	add	sp, #-8
;src/travel.c:142: uint32_t bit;row%=28u;bit=(uint32_t)1u<<row;
	ldhl	sp,	#16
	ld	a, (hl)
	ld	e, #0x1c
	call	__moduchar
	ldhl	sp,	#16
	ld	(hl), c
	ld	a, (hl)
	push	af
	ldhl	sp,	#2
	ld	a, #0x01
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl+), a
	ld	(hl), a
	pop	af
	inc	a
	jr	00140$
00139$:
	ldhl	sp,	#0
	sla	(hl)
	inc	hl
	rl	(hl)
	inc	hl
	rl	(hl)
	inc	hl
	rl	(hl)
00140$:
	dec	a
	jr	NZ,00139$
;src/travel.c:143: if(row<12u){*source_row=row;return(s->arrival_rows&bit)?2u:0u;}
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl)
	sub	a, #0x0c
	jr	NC, 00102$
	inc	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl,#0xe
	add	hl,de
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	a, l
	push	hl
	ldhl	sp,	#2
	and	a, (hl)
	pop	hl
	push	af
	ld	a, h
	push	hl
	ldhl	sp,	#5
	and	a, (hl)
	pop	hl
	ld	d, a
	ld	a, c
	ldhl	sp,	#4
	and	a, (hl)
	inc	hl
	ld	e, a
	ld	a, b
	and	a, (hl)
	ld	c, a
	pop	af
	or	a, c
	or	a, e
	or	a, d
	jr	Z, 00107$
	ld	a, #0x02
	jr	00105$
00107$:
	xor	a, a
	jr	00105$
00102$:
;src/travel.c:144: if(row<24u){*source_row=row-12u;return(s->updated_rows&bit)?0u:1u;}
	ldhl	sp,	#16
	ld	a,(hl)
	cp	a,#0x18
	jr	NC, 00104$
	inc	hl
	add	a, #0xf4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl,#0xa
	add	hl,de
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	a, l
	push	hl
	ldhl	sp,	#2
	and	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	push	hl
	ldhl	sp,	#3
	and	a, (hl)
	pop	hl
	ldhl	sp,	#5
	ld	(hl), a
	ld	a, c
	ldhl	sp,	#2
	and	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, b
	ldhl	sp,	#3
	and	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (hl-)
	or	a, (hl)
	dec	hl
	or	a, (hl)
	dec	hl
	or	a, (hl)
	jr	Z, 00109$
	ldhl	sp,	#7
	ld	(hl), #0x00
	jr	00110$
00109$:
	ldhl	sp,	#7
	ld	(hl), #0x01
00110$:
	ldhl	sp,	#7
	ld	a, (hl)
	jr	00105$
00104$:
;src/travel.c:145: *source_row=row-24u;return 1u;
	ldhl	sp,	#16
	ld	a, (hl+)
	add	a, #0xe8
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, #0x01
00105$:
;src/travel.c:146: }
	add	sp, #8
	ret
;src/travel.c:147: uint8_t travel_fade_color(uint8_t color,uint8_t step,uint8_t in) TRAVEL_BANKED {
;	---------------------------------
; Function travel_fade_color
; ---------------------------------
	b_travel_fade_color	= 119
_travel_fade_color::
	add	sp, #-4
;src/travel.c:148: uint8_t value=in?0u:color;
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	jr	Z, 00125$
	ld	c, #0x00
	jr	00126$
00125$:
	ldhl	sp,	#10
	ld	c, (hl)
00126$:
;src/travel.c:149: while(step--) {
	ldhl	sp,	#11
	ld	b, (hl)
00120$:
	ld	a, b
	dec	b
	or	a, a
	jr	Z, 00122$
;src/travel.c:150: if(in) {
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	jr	Z, 00118$
;src/travel.c:151: if(value==color)continue;
	dec	hl
	dec	hl
	ld	a, (hl)
	sub	a, c
	jr	Z, 00120$
;src/travel.c:152: if(value+16u<=color)value+=16u;
	ld	a, c
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	pop	de
	push	de
	ld	hl, #0x0010
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, e
	ld	a, (hl)
	sbc	a, d
	jr	C, 00107$
	ld	a, c
	add	a, #0x10
	ld	c, a
	jr	00120$
00107$:
;src/travel.c:153: else if(value+4u<=color)value+=4u;
	pop	de
	push	de
	ld	hl, #0x0004
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#2
	ld	a, (hl+)
	sub	a, e
	ld	a, (hl)
	sbc	a, d
	jr	C, 00104$
	inc	c
	inc	c
	inc	c
	inc	c
	jr	00120$
00104$:
;src/travel.c:154: else ++value;
	inc	c
	jr	00120$
00118$:
;src/travel.c:155: } else if(value&3u)--value;
	ld	a, c
	and	a, #0x03
	jr	Z, 00115$
	dec	c
	jr	00120$
00115$:
;src/travel.c:156: else if(value&12u)value-=4u;
	ld	a, c
	and	a, #0x0c
	jr	Z, 00112$
	ld	a, c
	add	a, #0xfc
	ld	c, a
	jr	00120$
00112$:
;src/travel.c:157: else if(value&48u)value-=16u;
	ld	a, c
	and	a, #0x30
	jr	Z, 00120$
	ld	a, c
	add	a, #0xf0
	ld	c, a
	jr	00120$
00122$:
;src/travel.c:159: return value;
	ld	a, c
;src/travel.c:160: }
	add	sp, #4
	ret
	.area _CODE_119
	.area _INITIALIZER
	.area _CABS (ABS)
