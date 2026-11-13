;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module party_world
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_sprite_palette
	.globl _set_sprite_data
	.globl _memset
	.globl _party_world
	.globl b_party_reset
	.globl _party_reset
	.globl b_party_step
	.globl _party_step
	.globl b_party_world_reset
	.globl _party_world_reset
	.globl b_party_world_tick
	.globl _party_world_tick
	.globl b_party_world_draw
	.globl _party_world_draw
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_party_world::
	.ds 42
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
	.area _CODE_22
;src/party_world.c:16: static uint8_t direction(uint8_t mask) {
;	---------------------------------
; Function direction
; ---------------------------------
_direction:
	ld	c, a
;src/party_world.c:17: uint8_t n=0;while(!(mask&1u)){mask>>=1;++n;}return n;
	xor	a, a
00101$:
	bit	0, c
	ret	NZ
	srl	c
	inc	a
;src/party_world.c:18: }
	jr	00101$
_order:
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x01	; 1
_standing:
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x09	; 9
	.db #0x0c	; 12
	.db #0x05	; 5
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0x0b	; 11
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x09	; 9
	.db #0x0c	; 12
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0x0f	; 15
_walking:
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x06	; 6
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x0a	; 10
	.db #0x09	; 9
	.db #0x0b	; 11
	.db #0x0c	; 12
	.db #0x0d	; 13
	.db #0x0c	; 12
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x05	; 5
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x08	; 8
	.db #0x0a	; 10
	.db #0x0b	; 11
	.db #0x0c	; 12
	.db #0x0b	; 11
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x06	; 6
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x0a	; 10
	.db #0x09	; 9
	.db #0x0b	; 11
	.db #0x0c	; 12
	.db #0x0d	; 13
	.db #0x0c	; 12
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x06	; 6
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x0a	; 10
	.db #0x0a	; 10
	.db #0x0b	; 11
	.db #0x0c	; 12
	.db #0x0d	; 13
	.db #0x0d	; 13
;src/party_world.c:19: static void shift(PartyWorldActor *a,uint8_t dir) {
;	---------------------------------
; Function shift
; ---------------------------------
_shift:
;src/party_world.c:20: if(dir==0u)--a->y;else if(dir==1u)++a->y;
	ld	l,e
	ld	h,d
	inc	de
	inc	de
	or	a, a
	jr	NZ, 00108$
	ld	a, (de)
	dec	a
	ld	(de), a
	ret
00108$:
	cp	a, #0x01
	jr	NZ, 00105$
	ld	a, (de)
	inc	a
	ld	(de), a
	ret
00105$:
;src/party_world.c:21: else if(dir==2u)--a->x;else ++a->x;
	inc	hl
	ld	c, (hl)
	sub	a, #0x02
	jr	NZ, 00102$
	dec	c
	ld	(hl), c
	ret
00102$:
	inc	c
	ld	(hl), c
;src/party_world.c:22: }
	ret
;src/party_world.c:23: void party_reset(PartyWorld *s,const RPGState *r,uint8_t road) RPG_BANKED {
;	---------------------------------
; Function party_reset
; ---------------------------------
	b_party_reset	= 22
_party_reset::
	add	sp, #-12
;src/party_world.c:25: memset(s,0,sizeof(*s));s->road=road;
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x002a
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
	ld	hl, #0x0029
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#22
	ld	a, (hl)
	ld	(bc), a
;src/party_world.c:26: for(i=0;i<4u;++i)if(r->party[order[i]].status&1u) {
	ldhl	sp,	#0
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#22
	ld	a, (hl)
	and	a, #0x03
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#11
	ld	(hl), #0x00
00104$:
	ld	de, #_order
	ldhl	sp,	#11
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#20
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	rrca
	jp	NC, 00105$
;src/party_world.c:27: a=&s->actors[s->count];a->identity=i;a->x=(road&3u)?132u:128u;
	pop	de
	push	de
	ld	hl, #0x0028
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
	ld	c, a
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
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
	ldhl	sp,	#11
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	ld	a, #0x84
	jr	NZ, 00109$
	ld	a, #0x80
00109$:
	ldhl	sp,	#9
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/party_world.c:28: a->y=96;a->flags=s->count?0u:3u;a->direction=1;a->loaded=255;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	ld	(hl), #0x60
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	inc	bc
	inc	bc
	inc	bc
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00110$
	xor	a, a
	jr	00111$
00110$:
	ld	a, #0x03
00111$:
	ld	(bc), a
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	(hl), #0x01
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	(hl), #0xff
;src/party_world.c:29: ++s->count;
	ldhl	sp,#5
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
00105$:
;src/party_world.c:26: for(i=0;i<4u;++i)if(r->party[order[i]].status&1u) {
	ldhl	sp,	#11
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jp	C, 00104$
;src/party_world.c:31: }
	add	sp, #12
	ret
;src/party_world.c:32: void party_step(PartyWorld *s,uint8_t accepted,uint8_t remaining,uint8_t held) RPG_BANKED {
;	---------------------------------
; Function party_step
; ---------------------------------
	b_party_step	= 22
_party_step::
	add	sp, #-18
;src/party_world.c:34: accepted&=15u;held&=15u;
	ldhl	sp,	#26
	ld	a, (hl)
	and	a, #0x0f
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	and	a, #0x0f
;src/party_world.c:35: for(i=0;i<s->count;++i) {
	ld	(hl-), a
	ld	a, (hl)
	sub	a, #0x0f
	ld	a, #0x01
	jr	Z, 00250$
	xor	a, a
00250$:
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0028
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#17
	ld	(hl), #0x00
00127$:
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#17
	ld	a, (hl)
	sub	a, c
	jp	NC, 00128$
;src/party_world.c:36: a=&s->actors[i];prev=i?a-1:a;
	ld	a, (hl)
	ld	c, a
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#24
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#17
	ld	a, (hl)
	or	a, a
	jr	Z, 00130$
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	b, a
	ld	c, e
	jr	00131$
00130$:
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00131$:
;src/party_world.c:38: if(!i) {a->previous=a->direction;if(accepted)a->direction=direction(accepted);}
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl), a
;src/party_world.c:40: if(a->flags&1u)a->flags|=2u;
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
;src/party_world.c:42: a->previous=a->direction;a->direction=prev->previous;
	ld	hl, #0x0009
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
;src/party_world.c:37: if(remaining==15u) {
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jp	Z, 00113$
;src/party_world.c:38: if(!i) {a->previous=a->direction;if(accepted)a->direction=direction(accepted);}
	ldhl	sp,	#17
	ld	a, (hl)
	or	a, a
	jr	NZ, 00110$
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00113$
	ld	a, (hl)
	call	_direction
	ldhl	sp,	#7
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jr	00113$
00110$:
;src/party_world.c:40: if(a->flags&1u)a->flags|=2u;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	bit	0, a
	jr	Z, 00104$
	set	1, a
	ldhl	sp,	#9
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00104$:
;src/party_world.c:41: if((a->x!=prev->x||a->y!=prev->y)&&(prev->flags&2u))a->flags|=1u;
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	a, (de)
	ld	l, c
	ld	h, b
	inc	hl
	ld	e, (hl)
	sub	a, e
	jr	NZ, 00108$
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	ld	a, (de)
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	e, (hl)
	sub	a, e
	jr	Z, 00106$
00108$:
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	bit	1, a
	jr	Z, 00106$
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	set	0, a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00106$:
;src/party_world.c:42: a->previous=a->direction;a->direction=prev->previous;
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#7
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00113$:
;src/party_world.c:54: a->frame=walking[a->identity][a->direction*4u+a->phase];
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#16
	ld	(hl), a
;src/party_world.c:45: if(accepted) {
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jp	Z, 00123$
;src/party_world.c:46: if(i) {
	ldhl	sp,	#17
	ld	a, (hl)
	or	a, a
	jr	Z, 00117$
;src/party_world.c:47: if(a->flags&1u)shift(a,a->direction);
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	rrca
	jr	NC, 00115$
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_shift
00115$:
;src/party_world.c:48: shift(a,s->actors[0].direction^1u);
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	xor	a, #0x01
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_shift
00117$:
;src/party_world.c:50: if(!s->road) {
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jp	NZ, 00123$
;src/party_world.c:51: --a->clock;
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	dec	a
	ld	(bc), a
;src/party_world.c:52: if(a->clock&128u) {
	rlca
	jp	NC, 00124$
;src/party_world.c:53: a->clock=7;a->phase=(a->phase+1u)&3u;
	ld	a, #0x07
	ld	(bc), a
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	and	a, #0x03
	ldhl	sp,	#12
	ld	(hl), a
	ld	(bc), a
;src/party_world.c:54: a->frame=walking[a->identity][a->direction*4u+a->phase];
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x04
00258$:
	ldhl	sp,	#15
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00258$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_walking
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, a
	add	a, a
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,	#12
	add	a, (hl)
	ldhl	sp,	#16
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#10
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
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#13
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/party_world.c:56: continue;
	jr	00124$
00123$:
;src/party_world.c:59: a->previous=a->direction;
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/party_world.c:60: dir=i?prev->previous:(held?direction(held):a->direction);
	ldhl	sp,	#17
	ld	a, (hl)
	or	a, a
	jr	Z, 00132$
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	jr	00133$
00132$:
	ldhl	sp,	#28
	ld	a, (hl)
	or	a, a
	jr	Z, 00134$
	ld	a, (hl)
	call	_direction
	jr	00135$
00134$:
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
00135$:
	ld	c, a
00133$:
;src/party_world.c:61: a->frame=standing[a->identity][dir];
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_standing
	add	hl, de
	ld	e, c
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	ldhl	sp,	#13
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00124$:
;src/party_world.c:35: for(i=0;i<s->count;++i) {
	ldhl	sp,	#17
	inc	(hl)
	jp	00127$
00128$:
;src/party_world.c:63: }
	add	sp, #18
	ret
;src/party_world.c:71: void party_world_reset(uint8_t road) RPG_BANKED {
;	---------------------------------
; Function party_world_reset
; ---------------------------------
	b_party_world_reset	= 22
_party_world_reset::
;src/party_world.c:72: party_reset(&party_world,&game_rpg,road);
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	de, #_party_world
	push	de
	ld	e, #b_party_reset
	ld	hl, #_party_reset
	call	___sdcc_bcall_ehl
	add	sp, #5
;src/party_world.c:73: VBK_REG=1;set_sprite_data(0,84,party_world_tiles);VBK_REG=0;
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	de, #_party_world_tiles
	push	de
	ld	hl, #0x5400
	push	hl
	call	_set_sprite_data
	add	sp, #4
	xor	a, a
	ldh	(_VBK_REG + 0), a
;src/party_world.c:74: set_sprite_palette(0,8,party_world_palettes);SPRITES_8x8;
	ld	de, #_party_world_palettes
	push	de
	ld	hl, #0x800
	push	hl
	call	_set_sprite_palette
	add	sp, #4
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfb
	ldh	(_LCDC_REG + 0), a
;src/party_world.c:75: }
	ret
_starts:
	.dw #0x0000
	.dw #0x0054
	.dw #0x00a2
	.dw #0x00f6
_destinations:
	.db #0x00	; 0
	.db #0x54	; 84	'T'
	.db #0x5a	; 90	'Z'
	.db #0x60	; 96
;src/party_world.c:76: void party_world_tick(uint8_t accepted,uint8_t remaining,uint8_t held) RPG_BANKED {
;	---------------------------------
; Function party_world_tick
; ---------------------------------
	b_party_world_tick	= 22
_party_world_tick::
;src/party_world.c:77: party_step(&party_world,accepted,remaining,held);
	ldhl	sp,	#8
	ld	a, (hl-)
	ld	d, a
	ld	a, (hl-)
	ld	e, a
	push	de
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_party_world
	push	de
	ld	e, #b_party_step
	ld	hl, #_party_step
	call	___sdcc_bcall_ehl
	add	sp, #5
;src/party_world.c:78: }
	ret
;src/party_world.c:79: void party_world_draw(void) RPG_BANKED {
;	---------------------------------
; Function party_world_draw
; ---------------------------------
	b_party_world_draw	= 22
_party_world_draw::
	add	sp, #-22
;src/party_world.c:80: uint8_t i,j,n,selected,oam=0,width,tile,rank[4];uint16_t offset;
	ldhl	sp,	#21
;src/party_world.c:82: for(i=0;i<party_world.count;++i) {
	xor	a, a
	ld	(hl-), a
	ld	(hl), a
00118$:
	ld	hl, #(_party_world + 40)
	ld	c, (hl)
	ldhl	sp,	#20
	ld	a, (hl)
	sub	a, c
	jp	NC, 00104$
;src/party_world.c:83: a=&party_world.actors[i];width=a->identity==3u?4u:6u;
	ld	a, (hl-)
	ld	c, a
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #_party_world
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	ldhl	sp,	#18
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#11
;src/party_world.c:84: if(a->identity&&a->frame!=a->loaded) {
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#19
	ld	(hl), a
;src/party_world.c:83: a=&party_world.actors[i];width=a->identity==3u?4u:6u;
	ld	a, (hl)
	sub	a, #0x03
	ld	a, #0x04
	jr	Z, 00141$
	ld	a, #0x06
00141$:
	ldhl	sp,	#12
	ld	(hl), a
;src/party_world.c:84: if(a->identity&&a->frame!=a->loaded) {
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#17
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl)
	or	a, a
	jp	Z, 00102$
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#17
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl)
	sub	a, c
	jr	Z, 00102$
;src/party_world.c:85: offset=starts[a->identity]+(uint16_t)a->frame*width;
	ldhl	sp,	#19
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#8
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
	ld	hl, #_starts
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
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	ld	e, (hl)
	xor	a, a
	ldhl	sp,	#12
	ld	c, (hl)
	ld	b, #0x00
	ld	d, a
	call	__mulint
	ldhl	sp,	#18
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
;src/party_world.c:86: VBK_REG=1;set_sprite_data(destinations[a->identity],width,party_world_tiles+offset*16u);VBK_REG=0;
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_party_world_tiles
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	ld	h, #0x00
	ld	de, #_destinations
	add	hl, de
	ld	a, (hl)
	push	bc
	ldhl	sp,	#14
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	call	_set_sprite_data
	add	sp, #4
	xor	a, a
	ldh	(_VBK_REG + 0), a
00102$:
;src/party_world.c:88: a->loaded=a->frame;
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/party_world.c:82: for(i=0;i<party_world.count;++i) {
	ldhl	sp,	#20
	inc	(hl)
	jp	00118$
00104$:
;src/party_world.c:93: for(i=0;i<party_world.count;++i)rank[i]=i;
	ld	c, #0x00
00121$:
;src/party_world.c:82: for(i=0;i<party_world.count;++i) {
	ld	a, (#(_party_world + 40) + 0)
	ldhl	sp,	#19
	ld	(hl), a
;src/party_world.c:93: for(i=0;i<party_world.count;++i)rank[i]=i;
	ld	a, c
	ldhl	sp,	#19
	sub	a, (hl)
	jr	NC, 00105$
	ld	e, c
	ld	d, #0x00
	ld	hl, #2
	add	hl, sp
	add	hl, de
	ld	(hl), c
	inc	c
	jr	00121$
00105$:
;src/party_world.c:94: for(i=0;i+1u<party_world.count;++i)for(j=i+1u;j<party_world.count;++j)
	ldhl	sp,	#13
	ld	(hl), #0x00
00127$:
	ldhl	sp,	#13
	ld	c, (hl)
	xor	a, a
	ld	b, a
	inc	bc
	ldhl	sp,	#19
	ld	e, (hl)
	ld	d, #0x00
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jp	NC, 00109$
	ldhl	sp,	#13
	ld	a, (hl+)
	inc	a
	ld	(hl), a
	ld	a, (hl)
	ldhl	sp,	#20
	ld	(hl), a
00124$:
;src/party_world.c:82: for(i=0;i<party_world.count;++i) {
	ld	a, (#(_party_world + 40) + 0)
	ldhl	sp,	#19
	ld	(hl), a
;src/party_world.c:94: for(i=0;i+1u<party_world.count;++i)for(j=i+1u;j<party_world.count;++j)
	ldhl	sp,	#20
	ld	a, (hl-)
	sub	a, (hl)
	jr	NC, 00128$
;src/party_world.c:95: if(party_world.actors[rank[i]].y<party_world.actors[rank[j]].y) {
	push	hl
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#13
	ld	l, (hl)
	ld	h, #0x00
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
	ld	c, a
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	ld	l, a
	ld	h, #0x00
	ld	de, #_party_world
	add	hl, de
	inc	hl
	inc	hl
	ld	b, (hl)
	push	hl
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#20
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#19
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#18
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl)
	ld	e, a
	add	a, a
	add	a, a
	add	a, e
	add	a, a
	ld	l, a
	ld	h, #0x00
	ld	de, #_party_world
	add	hl, de
	inc	hl
	inc	hl
	ld	a, b
	sub	a, (hl)
	jr	NC, 00125$
;src/party_world.c:96: selected=rank[i];rank[i]=rank[j];rank[j]=selected;
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#19
	ld	a, (hl-)
	ld	(de), a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
00125$:
;src/party_world.c:94: for(i=0;i+1u<party_world.count;++i)for(j=i+1u;j<party_world.count;++j)
	ldhl	sp,	#20
	inc	(hl)
	jr	00124$
00128$:
	ldhl	sp,	#14
	ld	a, (hl-)
	ld	(hl), a
	jp	00127$
00109$:
;src/party_world.c:98: for(n=0;n<party_world.count;++n) {
	ldhl	sp,	#19
	ld	(hl), #0x00
00133$:
	ld	hl, #(_party_world + 40)
	ld	c, (hl)
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, c
	jp	NC, 00168$
;src/party_world.c:99: a=&party_world.actors[rank[n]];width=a->identity==3u?4u:6u;
	push	hl
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#19
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	add	a, #<(_party_world)
	ld	c, a
	ld	a, #0x00
	adc	a, #>(_party_world)
	ldhl	sp,	#17
	ld	(hl), c
	inc	hl
;src/party_world.c:84: if(a->identity&&a->frame!=a->loaded) {
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#14
	ld	(hl), a
;src/party_world.c:99: a=&party_world.actors[rank[n]];width=a->identity==3u?4u:6u;
	ld	a, (hl)
	sub	a, #0x03
	ld	a, #0x04
	jr	Z, 00143$
	ld	a, #0x06
00143$:
	ldhl	sp,	#6
	ld	(hl), a
;src/party_world.c:100: offset=starts[a->identity]+(uint16_t)a->frame*width;
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#12
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
	ld	hl, #_starts
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
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#20
	ld	(hl), a
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	c, a
	ld	b, #0x00
	ld	e, (hl)
	ld	d, #0x00
	call	__mulint
	ldhl	sp,	#15
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
	ld	(hl), a
;src/party_world.c:101: tile=a->identity?destinations[a->identity]:a->frame*6u;
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00144$
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #_destinations
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ld	b, #0x00
	jr	00145$
00144$:
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
00145$:
	ldhl	sp,	#9
	ld	(hl), c
;src/party_world.c:102: for(j=0;j<width;++j) {
	ldhl	sp,#17
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
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 00310$
	xor	a, a
00310$:
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
00130$:
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#6
	sub	a, (hl)
	jp	NC, 00172$
;src/party_world.c:103: set_sprite_tile(oam,tile+j);set_sprite_prop(oam,8u|party_world_attrs[offset+j]);
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#21
	add	a, (hl)
;.tools/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	dec	hl
	ld	c, a
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sla	e
	rl	d
	sla	e
	rl	d
	ld	hl,#_shadow_OAM + 1
	add	hl,de
	inc	hl
	ld	(hl), c
;src/party_world.c:103: set_sprite_tile(oam,tile+j);set_sprite_prop(oam,8u|party_world_attrs[offset+j]);
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#7
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	h, #0x00
	ld	l, a
	add	hl, bc
	ld	bc, #_party_world_attrs
	add	hl, bc
	ld	c, (hl)
	set	3, c
;.tools/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	hl,#_shadow_OAM + 1
	add	hl,de
	inc	hl
	inc	hl
	ld	(hl), c
;src/party_world.c:104: move_sprite(oam,a->x-48u+(j&1u)*8u,a->y-(width==4u?16u:24u)+(j>>1)*8u);++oam;
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#18
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	ld	c, #0x10
	jr	NZ, 00147$
	ld	c, #0x18
00147$:
	ldhl	sp,	#18
	ld	a, (hl)
	sub	a, c
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl)
	srl	a
	ldhl	sp,	#17
	ld	(hl), a
	ld	a, (hl+)
	add	a, a
	add	a, a
	add	a, a
	add	a, (hl)
	ldhl	sp,	#15
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, #0xd0
	ld	c, a
	ldhl	sp,	#21
	ld	a, (hl)
	and	a, #0x01
	add	a, a
	add	a, a
	add	a, a
	add	a, c
	ldhl	sp,	#16
	ld	(hl), a
;.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00312$:
	ldhl	sp,	#0
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00312$
	pop	de
	push	de
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#19
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#18
;.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#15
	ld	a, (hl+)
	inc	hl
	ld	(de), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	ld	b, a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/party_world.c:104: move_sprite(oam,a->x-48u+(j&1u)*8u,a->y-(width==4u?16u:24u)+(j>>1)*8u);++oam;
	ldhl	sp,	#20
	inc	(hl)
;src/party_world.c:102: for(j=0;j<width;++j) {
	inc	hl
	inc	(hl)
	jp	00130$
00172$:
	ldhl	sp,	#20
	ld	a, (hl+)
;src/party_world.c:98: for(n=0;n<party_world.count;++n) {
	ld	(hl-), a
	dec	hl
	inc	(hl)
	jp	00133$
00168$:
	ldhl	sp,	#21
	ld	c, (hl)
00136$:
;src/party_world.c:107: for(;oam<40u;++oam)move_sprite(oam,0,0);
	ld	a, c
	sub	a, #0x28
	jr	NC, 00112$
;.tools/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM+0
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, de
;.tools/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/party_world.c:107: for(;oam<40u;++oam)move_sprite(oam,0,0);
	inc	c
	jr	00136$
00112$:
;src/party_world.c:108: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;src/party_world.c:109: }
	add	sp, #22
	ret
	.area _CODE_22
	.area _INITIALIZER
	.area _CABS (ABS)
