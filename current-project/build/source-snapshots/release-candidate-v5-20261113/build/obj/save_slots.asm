;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module save_slots
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl _memcpy
	.globl b_save_slot_offset
	.globl _save_slot_offset
	.globl b_save_label_encode
	.globl _save_label_encode
	.globl b_save_label_decode
	.globl _save_label_decode
	.globl b_save_name_character
	.globl _save_name_character
	.globl b_save_name_begin
	.globl _save_name_begin
	.globl b_save_name_move
	.globl _save_name_move
	.globl b_save_name_input
	.globl _save_name_input
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
	.area _CODE_122
;src/save_slots.c:7: static uint16_t checksum(const uint8_t *data) RPG_BANKED {
;	---------------------------------
; Function checksum
; ---------------------------------
	b_checksum	= 122
_checksum:
	dec	sp
	dec	sp
;src/save_slots.c:8: uint16_t crc=65535u;uint8_t i,j;
	ld	bc, #0xffff
;src/save_slots.c:9: for(i=0;i<6u;++i){crc^=(uint16_t)data[i]<<8;for(j=0;j<8u;++j)crc=(crc&0x8000u)?(crc<<1)^0x1021u:crc<<1;}
	ldhl	sp,	#0
	ld	(hl), #0x00
00106$:
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	xor	a, b
	ld	b, a
	ldhl	sp,	#1
	ld	(hl), #0x08
00105$:
	ld	e, c
	ld	d, b
	sla	e
	rl	d
	bit	7, b
	jr	Z, 00110$
	ld	a, e
	xor	a, #0x21
	ld	c, a
	ld	a, d
	xor	a, #0x10
	ld	b, a
	jr	00111$
00110$:
	ld	c, e
	ld	b, d
00111$:
	ldhl	sp,	#1
	dec	(hl)
	jr	NZ, 00105$
	dec	hl
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x06
	jr	C, 00106$
;src/save_slots.c:10: return crc;
;src/save_slots.c:11: }
	inc	sp
	inc	sp
	ret
_characters:
	.ascii "ABCDEFGHIJKLMNOPQRSTUVWXYZ,;.!?-"
	.db 0x22
	.db 0x5c
	.ascii "]^"
	.db 0x00
;src/save_slots.c:12: static uint8_t valid_name(const char *name) RPG_BANKED {
;	---------------------------------
; Function valid_name
; ---------------------------------
	b_valid_name	= 122
_valid_name:
	dec	sp
	dec	sp
;src/save_slots.c:14: for(i=0;i<5u;++i){
	ld	c, #0x00
00112$:
;src/save_slots.c:15: if(name[i]==' ')continue;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	sub	a, #0x20
	jr	Z, 00108$
;src/save_slots.c:16: for(j=0;j<33u;++j)if(name[i]==characters[j])break;
	inc	sp
	inc	sp
	push	de
	ld	b, #0x00
00110$:
	pop	de
	push	de
	ld	a, (de)
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	a, #<(_characters)
	add	a, b
	ld	l, a
	ld	a, #>(_characters)
	adc	a, #0x00
	ld	h, a
	ld	l, (hl)
	ld	h, #0x00
	ld	a, l
	sub	a, e
	jr	NZ, 00159$
	ld	a, h
	sub	a, d
	jr	Z, 00105$
00159$:
	inc	b
	ld	a, b
	sub	a, #0x21
	jr	C, 00110$
00105$:
;src/save_slots.c:17: if(j==33u)return 0;
	ld	a, b
	sub	a, #0x21
	jr	NZ, 00108$
	xor	a, a
	jr	00113$
00108$:
;src/save_slots.c:14: for(i=0;i<5u;++i){
	inc	c
	ld	a, c
	sub	a, #0x05
	jr	C, 00112$
;src/save_slots.c:19: return 1;
	ld	a, #0x01
00113$:
;src/save_slots.c:20: }
	inc	sp
	inc	sp
	ret
;src/save_slots.c:21: uint16_t save_slot_offset(uint8_t slot) RPG_BANKED {return slot<5u?(uint16_t)slot*1024u:65535u;}
;	---------------------------------
; Function save_slot_offset
; ---------------------------------
	b_save_slot_offset	= 122
_save_slot_offset::
	ldhl	sp,	#6
	ld	a,(hl)
	cp	a,#0x05
	jr	NC, 00103$
	add	a, a
	add	a, a
	ld	b, a
	ld	c, #0x00
	ret
00103$:
	ld	bc, #0xffff
	ret
;src/save_slots.c:22: uint8_t save_label_encode(uint8_t data[8],const char name[5]) RPG_BANKED {
;	---------------------------------
; Function save_label_encode
; ---------------------------------
	b_save_label_encode	= 122
_save_label_encode::
;src/save_slots.c:23: uint16_t crc;if(!valid_name(name))return 0;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_valid_name
	ld	hl, #_valid_name
	call	___sdcc_bcall_ehl
	pop	hl
	or	a,a
	ret	Z
;src/save_slots.c:24: memcpy(data,name,5u);data[5]=0xa5u;crc=checksum(data);data[6]=(uint8_t)crc;data[7]=crc>>8;return 1;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	push	hl
	call	_memcpy
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0xa5
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_checksum
	ld	hl, #_checksum
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, b
	ld	(de), a
	ld	a, #0x01
;src/save_slots.c:25: }
	ret
;src/save_slots.c:26: uint8_t save_label_decode(char name[5],const uint8_t data[8]) RPG_BANKED {
;	---------------------------------
; Function save_label_decode
; ---------------------------------
	b_save_label_decode	= 122
_save_label_decode::
	dec	sp
	dec	sp
;src/save_slots.c:27: uint16_t crc=checksum(data);
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_checksum
	ld	hl, #_checksum
	call	___sdcc_bcall_ehl
	pop	hl
;src/save_slots.c:28: if(data[5]!=0xa5u||data[6]!=(uint8_t)crc||data[7]!=(crc>>8)||!valid_name((const char *)data)){
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
;src/save_slots.c:29: memset(name,' ',5u);return 0;
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
;src/save_slots.c:28: if(data[5]!=0xa5u||data[6]!=(uint8_t)crc||data[7]!=(crc>>8)||!valid_name((const char *)data)){
	ld	a, e
	sub	a, #0xa5
	jr	NZ, 00101$
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, c
	sub	a, e
	jr	NZ, 00101$
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ld	c, #0x00
	ld	d, c
	ld	a, b
	sub	a, e
	jr	NZ, 00101$
	ld	a, c
	sub	a, d
	jr	NZ, 00101$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_valid_name
	ld	hl, #_valid_name
	call	___sdcc_bcall_ehl
	pop	hl
	or	a, a
	jr	NZ, 00102$
00101$:
;src/save_slots.c:29: memset(name,' ',5u);return 0;
	ld	de, #0x0005
	push	de
	ld	de, #0x0020
	push	de
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	call	_memset
	add	sp, #6
	xor	a, a
	jr	00106$
00102$:
;src/save_slots.c:31: memcpy(name,data,5u);return 1;
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0005
	push	de
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_memcpy
	ld	a, #0x01
00106$:
;src/save_slots.c:32: }
	inc	sp
	inc	sp
	ret
;src/save_slots.c:33: uint8_t save_name_character(uint8_t option) RPG_BANKED {return option<36u?characters[option]:0;}
;	---------------------------------
; Function save_name_character
; ---------------------------------
	b_save_name_character	= 122
_save_name_character::
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x24
	jr	NC, 00103$
	ld	bc, #_characters+0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ret
00103$:
	xor	a, a
	ret
;src/save_slots.c:34: void save_name_begin(SaveName *e) RPG_BANKED {memset(e->name,' ',5u);e->cursor=e->option=0;}
;	---------------------------------
; Function save_name_begin
; ---------------------------------
	b_save_name_begin	= 122
_save_name_begin::
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	ld	hl, #0x0005
	push	hl
	ld	l, #0x20
	push	hl
	push	de
	call	_memset
	add	sp, #6
	ld	hl, #0x0005
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, #0x0006
	add	hl, bc
	ld	(hl), #0x00
	xor	a, a
	ld	(de), a
	ret
;src/save_slots.c:35: void save_name_move(SaveName *e,int8_t dx,int8_t dy) RPG_BANKED {
;	---------------------------------
; Function save_name_move
; ---------------------------------
	b_save_name_move	= 122
_save_name_move::
	dec	sp
	dec	sp
;src/save_slots.c:36: uint8_t x=e->option%6u,y=e->option/6u;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0006
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	d, a
	push	de
	ld	e, #0x06
	ld	a, d
	call	__moduchar
	pop	de
	ld	b, c
	push	bc
	ld	e, #0x06
	ld	a, d
	call	__divuchar
	pop	af
	ld	b, a
;src/save_slots.c:37: if(dx<0&&x)--x;else if(dx>0&&x<5u)++x;
	ldhl	sp,	#10
	bit	7, (hl)
	jr	Z, 00105$
	ld	a, b
	or	a, a
	jr	Z, 00105$
	dec	b
	jr	00106$
00105$:
	ldhl	sp,	#10
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00173$
	bit	7, d
	jr	NZ, 00174$
	cp	a, a
	jr	00174$
00173$:
	bit	7, d
	jr	Z, 00174$
	scf
00174$:
	jr	NC, 00106$
	ld	a, b
	sub	a, #0x05
	jr	NC, 00106$
	inc	b
00106$:
;src/save_slots.c:38: if(dy<0&&y)--y;else if(dy>0&&y<5u)++y;
	ldhl	sp,	#11
	bit	7, (hl)
	jr	Z, 00112$
	ld	a, c
	or	a, a
	jr	Z, 00112$
	dec	c
	jr	00113$
00112$:
	ldhl	sp,	#11
	ld	e, (hl)
	xor	a, a
	ld	d, a
	sub	a, (hl)
	bit	7, e
	jr	Z, 00175$
	bit	7, d
	jr	NZ, 00176$
	cp	a, a
	jr	00176$
00175$:
	bit	7, d
	jr	Z, 00176$
	scf
00176$:
	jr	NC, 00113$
	ld	a, c
	sub	a, #0x05
	jr	NC, 00113$
	inc	c
00113$:
;src/save_slots.c:39: e->option=y*6u+x;
	ld	a, c
	add	a, a
	add	a, c
	add	a, a
	add	a, b
	pop	hl
	push	hl
	ld	(hl), a
;src/save_slots.c:40: }
	inc	sp
	inc	sp
	ret
;src/save_slots.c:41: uint8_t save_name_input(SaveName *e,uint8_t erase) RPG_BANKED {
;	---------------------------------
; Function save_name_input
; ---------------------------------
	b_save_name_input	= 122
_save_name_input::
	dec	sp
;src/save_slots.c:42: uint8_t c=save_name_character(e->option);
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	a, (hl)
	push	de
	push	af
	inc	sp
	ld	e, #b_save_name_character
	ld	hl, #_save_name_character
	call	___sdcc_bcall_ehl
	inc	sp
	ldhl	sp,	#2
	ld	(hl), a
	pop	de
;src/save_slots.c:43: if(erase){e->name[e->cursor]=' ';if(e->cursor)--e->cursor;return 0;}
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	ld	a, (bc)
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	(hl), #0x20
	ld	a, (bc)
	or	a, a
	jr	Z, 00102$
	dec	a
	ld	(bc), a
00102$:
	xor	a, a
	jr	00122$
00104$:
;src/save_slots.c:44: if(c<0x5cu){e->name[e->cursor]=c;if(e->cursor<4u)++e->cursor;}
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x5c
	jr	NC, 00120$
	ld	a, (bc)
	add	a, e
	ld	e, a
	ld	a, #0x00
	adc	a, d
	ld	d, a
	ld	a, (hl)
	ld	(de), a
	ld	a, (bc)
	cp	a, #0x04
	jr	NC, 00121$
	inc	a
	ld	(bc), a
	jr	00121$
00120$:
;src/save_slots.c:45: else if(c==0x5cu){if(e->cursor<4u)++e->cursor;}
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x5c
	jr	NZ, 00117$
	ld	a, (bc)
	cp	a, #0x04
	jr	NC, 00121$
	inc	a
	ld	(bc), a
	jr	00121$
00117$:
;src/save_slots.c:46: else if(c==0x5du){if(e->cursor)--e->cursor;}
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x5d
	jr	NZ, 00114$
	ld	a, (bc)
	or	a, a
	jr	Z, 00121$
	dec	a
	ld	(bc), a
	jr	00121$
00114$:
;src/save_slots.c:47: else if(c==0x5eu)return 1;
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x5e
;src/save_slots.c:48: return 0;
	ld	a, #0x01
	jr	Z, 00122$
00121$:
	xor	a, a
00122$:
;src/save_slots.c:49: }
	inc	sp
	ret
	.area _CODE_122
	.area _INITIALIZER
	.area _CABS (ABS)
