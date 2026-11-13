;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module save
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memmove
	.globl b_save_encode
	.globl _save_encode
	.globl b_save_decode
	.globl _save_decode
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
	.area _CODE_5
;src/save.c:12: static uint16_t checksum(const uint8_t *p,uint16_t bytes) {
;	---------------------------------
; Function checksum
; ---------------------------------
_checksum:
	add	sp, #-7
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
;src/save.c:13: uint16_t crc=0xffffu, i;
	ld	a, d
	ld	(hl+), a
	inc	sp
	inc	sp
	push	bc
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0xff
;src/save.c:15: for(i=0;i<bytes-2u;++i) {
	ld	bc, #0x0000
00107$:
	pop	de
	push	de
	dec	de
	dec	de
	ld	l, c
	ld	h, b
	ld	a, l
	sub	a, e
	ld	a, h
	sbc	a, d
	jr	NC, 00102$
;src/save.c:16: crc ^= (uint16_t)p[i] << 8;
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	d, a
	ldhl	sp,	#5
	ld	a, (hl)
	xor	a, d
;src/save.c:17: for(bit=0;bit<8;++bit) crc=(crc&0x8000u)?(crc<<1)^0x1021u:crc<<1;
	ld	(hl+), a
	ld	(hl), #0x08
00105$:
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	sla	e
	rl	d
	push	hl
	bit	7, (hl)
	pop	hl
	jr	Z, 00111$
	ld	a, e
	xor	a, #0x21
	ld	e, a
	ld	a, d
	xor	a, #0x10
	ldhl	sp,	#4
	ld	(hl), e
	inc	hl
	ld	(hl), a
	jr	00112$
00111$:
	ldhl	sp,	#4
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
00112$:
	ldhl	sp,	#6
	dec	(hl)
	jr	NZ, 00105$
;src/save.c:15: for(i=0;i<bytes-2u;++i) {
	inc	bc
	jr	00107$
00102$:
;src/save.c:19: return crc;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/save.c:20: }
	add	sp, #7
	ret
;src/save.c:21: static uint8_t valid(const GameSave *s) {
;	---------------------------------
; Function valid
; ---------------------------------
_valid:
	add	sp, #-6
	ld	c, e
	ld	b, d
;src/save.c:23: if(s->map>=24u || s->facing>3u || s->x>=2048u || s->y>=1536u ||
	ld	a, (bc)
	sub	a, #0x18
	jr	NC, 00101$
	ld	l, c
	ld	h, b
	inc	hl
	ld	a, (hl)
	cp	a, #0x04
	jr	NC, 00101$
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	a,	(hl+)
	ld	a, (hl)
	sub	a, #0x08
	jr	NC, 00101$
	ld	hl, #0x0004
	add	hl, bc
	ld	a,	(hl+)
	ld	a, (hl)
	sub	a, #0x06
	jr	NC, 00101$
;src/save.c:24: s->rpg.inventory_count>24u || !(s->rpg.joined_mask&1u) || (s->rpg.joined_mask&0xf0u)) return 0;
	ld	hl, #0x005e
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ld	a, #0x18
	ldhl	sp,	#2
	sub	a, (hl)
	jr	C, 00101$
	ld	hl, #0x005f
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	push	hl
	ldhl	sp,	#2
	bit	0, (hl)
	pop	hl
	jr	Z, 00101$
	ldhl	sp,	#0
	ld	a, (hl)
	and	a, #0xf0
	jr	Z, 00102$
00101$:
	xor	a, a
	jp	00143$
00102$:
;src/save.c:25: if(s->dungeon_active>1u||s->dungeon_floor>=61u||s->dungeon_direction>3u)return 0;
	ld	hl, #0x0266
	add	hl, bc
	ld	e, (hl)
	ld	a, #0x01
	sub	a, e
	jr	C, 00109$
	ld	hl, #0x0267
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x3d
	jr	NC, 00109$
	ld	hl, #0x0269
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x04
	jr	C, 00110$
00109$:
	xor	a, a
	jp	00143$
00110$:
;src/save.c:26: if((s->vehicle!=0u&&s->vehicle!=4u&&s->vehicle!=8u&&s->vehicle!=12u)||(s->dungeon_active&&s->vehicle))return 0;
	ld	hl, #0x026b
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00119$
	cp	a, #0x04
	jr	Z, 00119$
	cp	a, #0x08
	jr	Z, 00119$
	cp	a, #0x0c
	jr	NZ, 00113$
00119$:
	inc	e
	dec	e
	jr	Z, 00114$
	or	a, a
	jr	Z, 00114$
00113$:
	xor	a, a
	jp	00143$
00114$:
;src/save.c:27: if(s->vehicle_phase>2u||s->vehicle_clock>3u)return 0;
	ld	hl, #0x026c
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x03
	jr	NC, 00120$
	ld	hl, #0x026d
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x04
	jr	C, 00167$
00120$:
	xor	a, a
	jp	00143$
;src/save.c:28: for(i=0;i<24u;++i) {
00167$:
	ld	hl, #0x0046
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
00139$:
;src/save.c:29: uint8_t item=s->rpg.inventory[i];
	ldhl	sp,#3
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
;src/save.c:30: if(i<s->rpg.inventory_count ? (!item || item>63u) : item!=0) return 0;
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#2
	sub	a, (hl)
	jr	NC, 00145$
	ld	a, e
	or	a, a
	jr	Z, 00148$
	ld	a, #0x3f
	sub	a, e
	jr	C, 00148$
	xor	a, a
	jr	00146$
00148$:
	ld	a, #0x01
	jr	00146$
00145$:
	ld	a, e
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
00146$:
	or	a, a
	jr	Z, 00140$
	xor	a, a
	jp	00143$
00140$:
;src/save.c:28: for(i=0;i<24u;++i) {
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x18
	jr	C, 00139$
;src/save.c:32: for(i=0;i<4;++i) {
	ld	hl, #0x0006
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#5
	ld	(hl), #0x00
00141$:
;src/save.c:33: const RPGCharacter *c=&s->rpg.party[i];
	ldhl	sp,	#5
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#1
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
;src/save.c:34: if((s->rpg.joined_mask&(1u<<i)) && (!c->level || c->level>30u)) return 0;
	ldhl	sp,	#5
	ld	a, (hl)
	push	af
	ld	de, #0x0001
	pop	af
	inc	a
	jr	00360$
00359$:
	sla	e
	rl	d
00360$:
	dec	a
	jr	NZ,00359$
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	and	a, e
	ld	e, #0x00
	or	a, e
	jr	Z, 00127$
	ld	hl, #0x0005
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00126$
	cp	a, #0x1f
	jr	C, 00127$
00126$:
	xor	a, a
	jr	00143$
00127$:
;src/save.c:35: if(c->hp>c->max_hp || c->mp>c->max_mp || c->weapon>63u || c->armor>63u ||
	ld	l, c
	ld	h, b
	inc	hl
	ld	e, (hl)
	ld	hl, #0x0006
	add	hl, bc
	ld	a, (hl)
	sub	a, e
	jr	C, 00130$
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	e, (hl)
	ld	hl, #0x0007
	add	hl, bc
	ld	a, (hl)
	sub	a, e
	jr	C, 00130$
	ld	hl, #0x000a
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x40
	jr	NC, 00130$
	ld	hl, #0x000b
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x40
	jr	NC, 00130$
;src/save.c:36: c->shield>63u || c->battle_magic_count>5u || c->map_magic_count>5u) return 0;
	ld	hl, #0x000c
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x40
	jr	NC, 00130$
	ld	hl, #0x000e
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x06
	jr	NC, 00130$
	ld	hl, #0x000f
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x06
	jr	C, 00142$
00130$:
	xor	a, a
	jr	00143$
00142$:
;src/save.c:32: for(i=0;i<4;++i) {
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jp	C, 00141$
;src/save.c:38: return 1;
	ld	a, #0x01
00143$:
;src/save.c:39: }
	add	sp, #6
	ret
;src/save.c:40: static void put16_back(uint8_t **p,uint16_t v) { *--*p=(uint8_t)(v>>8); *--*p=(uint8_t)v; }
;	---------------------------------
; Function put16_back
; ---------------------------------
_put16_back:
	add	sp, #-4
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	inc	sp
	inc	sp
	push	bc
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	dec	bc
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	dec	bc
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(bc), a
	add	sp, #4
	ret
;src/save.c:41: static uint16_t get16(const uint8_t **p) {uint16_t v=*(*p)++;v|=(uint16_t)*(*p)++<<8;return v;}
;	---------------------------------
; Function get16
; ---------------------------------
_get16:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
	ld	l, c
	ld	h, b
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	e, l
	ld	d, h
	inc	de
	push	hl
	ld	l, c
	ld	h, b
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	pop	hl
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	ld	l, e
	ld	h, d
	inc	hl
	ld	a, l
	ld	(bc), a
	inc	bc
	ld	a, h
	ld	(bc), a
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#0
	ld	c, (hl)
	inc	sp
	inc	sp
	ret
;src/save.c:43: uint8_t save_encode(uint8_t *out,const GameSave *s) RPG_BANKED {
;	---------------------------------
; Function save_encode
; ---------------------------------
	b_save_encode	= 5
_save_encode::
	add	sp, #-12
;src/save.c:44: uint8_t *p=out+SAVE_BYTES-2u;
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0272
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
;src/save.c:46: if(!valid(s)) return 0;
	ldhl	sp,	#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_valid
	ld	c, a
	or	a,a
	jp	Z, 00115$
;src/save.c:49: *--p=s->vehicle_clock;*--p=s->vehicle_phase;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x026d
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x026c
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/save.c:50: *--p=s->vehicle;*--p=s->dungeon_light;*--p=s->dungeon_direction;*--p=s->dungeon_position;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x026b
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x026a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0269
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0268
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/save.c:51: *--p=s->dungeon_floor;*--p=s->dungeon_active;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0267
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0266
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/save.c:52: for(i=256u;i;) {*--p=s->object_flags[--i];}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0166
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl+), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	xor	a, a
	ld	(hl+), a
	ld	(hl), #0x01
00107$:
	dec	bc
	ldhl	sp,	#8
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#10
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,	#11
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00107$
;src/save.c:53: *--p=s->last_church;*--p=s->secrets_requests;
	dec	hl
	dec	hl
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl-), a
	dec	bc
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0165
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0164
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/save.c:54: for(i=256u;i;) {*--p=s->flags[--i];}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0064
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl+), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	bc, #0x0100
00109$:
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	dec	bc
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, b
	or	a, c
	jr	NZ, 00109$
;src/save.c:55: put16_back(&p,s->rpg.rng);put16_back(&p,s->rpg.money);
	ldhl	sp,	#10
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0062
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_put16_back
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0060
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_put16_back
;src/save.c:56: *--p=s->rpg.joined_mask;*--p=s->rpg.inventory_count;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x005f
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x005e
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/save.c:57: for(i=24u;i;) {*--p=s->rpg.inventory[--i];}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0046
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl+), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	bc, #0x0018
00111$:
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	dec	bc
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, b
	or	a, c
	jr	NZ, 00111$
;src/save.c:58: for(i=4u;i;) {
	ldhl	sp,	#10
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, #0x04
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
00113$:
;src/save.c:59: const RPGCharacter *c=&s->rpg.party[--i];
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	d, (hl)
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
;src/save.c:60: *--p=c->map_magic_count;*--p=c->battle_magic_count;*--p=c->bound;
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000f
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000e
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/save.c:61: *--p=c->shield;*--p=c->armor;*--p=c->weapon;*--p=c->defense;*--p=c->attack;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/save.c:62: *--p=c->max_mp;*--p=c->max_hp;*--p=c->level;put16_back(&p,c->exp);
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#8
	ld	e, l
	ld	d, h
	call	_put16_back
;src/save.c:63: *--p=c->mp;*--p=c->hp;*--p=c->status;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	inc	de
	inc	de
	ld	a, (de)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	inc	de
	ld	a, (de)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(bc), a
;src/save.c:58: for(i=4u;i;) {
	ldhl	sp,	#11
	ld	a, (hl-)
	or	a, (hl)
	jp	NZ, 00113$
;src/save.c:65: put16_back(&p,s->y);put16_back(&p,s->x);*--p=s->facing;*--p=s->map;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_put16_back
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_put16_back
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(bc), a
;src/save.c:66: out[0]='P';out[1]='S';out[2]='G';out[3]=SAVE_VERSION;
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, #0x50
	ld	(de), a
	ld	l, e
	ld	h, d
	inc	hl
	ld	(hl), #0x53
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	ld	(hl), #0x47
	ld	l, e
	ld	h, d
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x05
;src/save.c:67: crc=checksum(out,SAVE_BYTES);out[SAVE_BYTES-2u]=(uint8_t)crc;out[SAVE_BYTES-1u]=(uint8_t)(crc>>8);
	ld	bc, #0x0274
	call	_checksum
	ld	a, c
	pop	hl
	push	hl
	ld	(hl), a
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0273
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, b
	ld	(de), a
;src/save.c:68: return 1;
	ld	a, #0x01
00115$:
;src/save.c:69: }
	add	sp, #12
	ret
;src/save.c:70: uint8_t save_decode(GameSave *s,const uint8_t *data) RPG_BANKED {
;	---------------------------------
; Function save_decode
; ---------------------------------
	b_save_decode	= 5
_save_decode::
	add	sp, #-11
;src/save.c:71: const uint8_t *p=data+4;
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
;src/save.c:72: uint8_t i,version=data[3];
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#10
;src/save.c:73: uint16_t bytes=version==4u?626u:SAVE_BYTES,crc=checksum(data,bytes);
	ld	(hl), a
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 00184$
	xor	a, a
00184$:
	ldhl	sp,	#0
	ld	(hl), a
	or	a, a
	jr	Z, 00117$
	ld	bc, #0x0272
	jr	00118$
00117$:
	ld	bc, #0x0274
00118$:
	ldhl	sp,	#2
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_checksum
	ldhl	sp,	#4
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/save.c:74: if(data[0]!='P'||data[1]!='S'||data[2]!='G'||(version!=4u&&version!=SAVE_VERSION) ||
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x50
	jr	NZ, 00101$
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	sub	a, #0x53
	jr	NZ, 00101$
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	sub	a, #0x47
	jr	NZ, 00101$
	ldhl	sp,	#0
	ld	c, (hl)
	bit	0, c
	jr	NZ, 00107$
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x05
	jr	NZ, 00101$
00107$:
;src/save.c:75: data[bytes-2u]!=(uint8_t)crc || data[bytes-1u]!=(uint8_t)(crc>>8)) return 0;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	dec	de
	dec	de
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#4
	ld	e, (hl)
	sub	a, e
	jr	NZ, 00101$
	inc	hl
	inc	hl
	dec	bc
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
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
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#5
	ld	c, (hl)
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, c
	jr	Z, 00102$
00101$:
	xor	a, a
	jp	00115$
00102$:
;src/save.c:76: s->map=*p++;s->facing=*p++;s->x=get16(&p);s->y=get16(&p);
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	ldhl	sp,#1
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
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	ldhl	sp,#1
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
	ld	(hl), a
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_get16
	ldhl	sp,	#6
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_get16
	ldhl	sp,	#6
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/save.c:77: for(i=0;i<4;++i) {
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#10
	ld	(hl), #0x00
00113$:
;src/save.c:78: RPGCharacter *c=&s->rpg.party[i];
	ldhl	sp,	#10
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#3
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
;src/save.c:79: c->status=*p++;c->hp=*p++;c->mp=*p++;c->exp=get16(&p);
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	inc	hl
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	inc	hl
	ld	b, a
	inc	bc
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	inc	hl
	ld	b, a
	inc	bc
	inc	bc
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ldhl	sp,	#8
	ld	e, l
	ld	d, h
	push	bc
	call	_get16
	ld	e, c
	ld	d, b
	pop	bc
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;src/save.c:80: c->level=*p++;c->max_hp=*p++;c->max_mp=*p++;c->attack=*p++;c->defense=*p++;
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
;src/save.c:81: c->weapon=*p++;c->armor=*p++;c->shield=*p++;c->bound=*p++;
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
;src/save.c:82: c->battle_magic_count=*p++;c->map_magic_count=*p++;
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000e
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000f
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	ld	(bc), a
;src/save.c:77: for(i=0;i<4;++i) {
	ldhl	sp,	#10
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jp	C, 00113$
;src/save.c:84: memmove(s->rpg.inventory,p,24);p+=24;
	dec	hl
	dec	hl
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0046
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, #0x0018
	push	bc
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	call	_memmove
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0018
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
;src/save.c:85: s->rpg.inventory_count=*p++;s->rpg.joined_mask=*p++;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x005e
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x005f
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, (hl)
	ld	(bc), a
;src/save.c:86: s->rpg.money=get16(&p);s->rpg.rng=get16(&p);
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0060
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_get16
	ldhl	sp,	#6
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0062
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_get16
	ldhl	sp,	#6
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	(de), a
	inc	de
;src/save.c:87: memmove(s->flags,p,256);p+=256;
	ld	a, (hl+)
	ld	(de), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0064
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	inc	a
	push	af
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	call	_memmove
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
;src/save.c:88: s->secrets_requests=*p++;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0164
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, (hl)
	ld	(bc), a
;src/save.c:89: s->last_church=*p++;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0165
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
;src/save.c:90: memmove(s->object_flags,p,256);p+=256;
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0166
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	inc	a
	push	af
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	call	_memmove
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
;src/save.c:91: s->dungeon_active=*p++;s->dungeon_floor=*p++;s->dungeon_position=*p++;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0266
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0267
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0268
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, (hl)
	ld	(bc), a
;src/save.c:92: s->dungeon_direction=*p++;s->dungeon_light=*p++;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0269
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x026a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	ld	a, (hl)
	ld	(bc), a
;src/save.c:93: s->vehicle=*p++;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x026b
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#10
	ld	a, (hl)
	ld	(de), a
;src/save.c:94: if(version==4u)s->vehicle_phase=s->vehicle_clock=0;
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x026c
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x026d
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00111$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	jr	00112$
00111$:
;src/save.c:95: else {s->vehicle_phase=*p++;s->vehicle_clock=*p++;}
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
00112$:
;src/save.c:96: return valid(s);
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_valid
	ldhl	sp,#10
	ld	(hl), a
00115$:
;src/save.c:97: }
	add	sp, #11
	ret
	.area _CODE_5
	.area _INITIALIZER
	.area _CABS (ABS)
