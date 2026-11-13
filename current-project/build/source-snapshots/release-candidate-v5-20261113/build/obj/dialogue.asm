;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dialogue
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_read8
	.globl _memset
	.globl _memcpy
	.globl b_dialogue_open
	.globl _dialogue_open
	.globl b_dialogue_item_name
	.globl _dialogue_item_name
	.globl b_dialogue_next_page
	.globl _dialogue_next_page
	.globl b_dialogue_next_story_page
	.globl _dialogue_next_story_page
	.globl b_dialogue_stream_begin
	.globl _dialogue_stream_begin
	.globl b_dialogue_stream_next
	.globl _dialogue_stream_next
	.globl b_dialogue_wait_frames
	.globl _dialogue_wait_frames
	.globl b_dialogue_wait_tick
	.globl _dialogue_wait_tick
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
	.area _CODE_8
;src/dialogue.c:12: static void clear_lines(DialogueCursor *c) {
;	---------------------------------
; Function clear_lines
; ---------------------------------
_clear_lines:
	ld	c, e
	ld	b, d
;src/dialogue.c:13: memset(c->lines[0],' ',18); memset(c->lines[1],' ',18);
	ld	hl, #0x0032
	add	hl, bc
	ld	de, #0x0012
	push	de
	ld	de, #0x0020
	push	de
	push	hl
	call	_memset
	add	sp, #6
	ld	hl, #0x0045
	add	hl, bc
	ld	de, #0x0012
	push	de
	ld	de, #0x0020
	push	de
	push	hl
	call	_memset
	add	sp, #6
;src/dialogue.c:14: c->lines[0][18]=0; c->lines[1][18]=0; c->row=0;c->column=0;
	ld	hl, #0x0044
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x0057
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x000e
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x000f
	add	hl, bc
	ld	(hl), #0x00
;src/dialogue.c:15: }
	ret
;src/dialogue.c:16: static void newline(DialogueCursor *c) {
;	---------------------------------
; Function newline
; ---------------------------------
_newline:
	add	sp, #-4
	ldhl	sp,	#2
	ld	a, e
	ld	(hl+), a
;src/dialogue.c:17: if(c->row) { memcpy(c->lines[0],c->lines[1],19); memset(c->lines[1],' ',18); }
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000e
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	or	a, a
	jr	Z, 00102$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0045
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0032
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #0x0013
	push	hl
	call	_memcpy
	pop	bc
	ld	de, #0x0012
	push	de
	ld	de, #0x0020
	push	de
	push	bc
	call	_memset
	add	sp, #6
00102$:
;src/dialogue.c:18: c->row=1;c->column=0;
	pop	hl
	ld	(hl), #0x01
	push	hl
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000f
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/dialogue.c:19: }
	add	sp, #4
	ret
;src/dialogue.c:20: static void put_char(DialogueCursor *c,char ch) {
;	---------------------------------
; Function put_char
; ---------------------------------
_put_char:
	add	sp, #-3
	ldhl	sp,	#2
	ld	(hl), a
;src/dialogue.c:21: if(c->column==18) newline(c);
	ld	hl, #0x000f
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x12
	jr	NZ, 00102$
	push	bc
	push	de
	call	_newline
	pop	de
	pop	bc
00102$:
;src/dialogue.c:22: c->lines[c->row][c->column++]=ch=='@'?'\'':ch;
	push	de
	ld	hl, #0x0032
	add	hl, de
	pop	de
	inc	sp
	inc	sp
	push	hl
	ld	hl, #0x000e
	add	hl, de
	ld	a, (hl)
	ld	e, a
	add	a, a
	add	a, a
	add	a, e
	add	a, a
	add	a, a
	sub	a, e
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	ld	l, a
	inc	a
	ld	(bc), a
	ld	a, l
	add	a, e
	ld	c, a
	ld	a, #0x00
	adc	a, d
	ld	b, a
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00105$
	ld	e, #0x27
	jr	00106$
00105$:
	ldhl	sp,	#2
	ld	e, (hl)
00106$:
	ld	a, e
	ld	(bc), a
;src/dialogue.c:23: }
	add	sp, #3
	ret
;src/dialogue.c:24: uint8_t dialogue_open(DialogueCursor *c,uint16_t id) DIALOGUE_BANKED {
;	---------------------------------
; Function dialogue_open
; ---------------------------------
	b_dialogue_open	= 8
_dialogue_open::
	add	sp, #-8
;src/dialogue.c:26: memset(c,0,sizeof(*c));c->done=1;
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0059
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#14
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#15
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x000c
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
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;src/dialogue.c:27: for(i=0;i<dialogue_ref_count;i++) if(dialogue_refs[i].id==id) {
	ld	bc, #0x0000
00105$:
	ld	a, (_dialogue_ref_count)
	ld	e, a
	ld	hl, #_dialogue_ref_count + 1
	ld	d, (hl)
	ld	a, c
	sub	a, e
	ld	a, b
	sbc	a, d
	jr	NC, 00103$
	ld	a, c
	ld	d, b
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ld	hl, #_dialogue_refs
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
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl)
	ldhl	sp,	#6
	sub	a, (hl)
	jr	NZ, 00106$
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#7
	sub	a, (hl)
	jr	NZ, 00106$
;src/dialogue.c:28: c->ref=dialogue_refs[i]; c->done=0;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	de
	push	de
	ld	hl, #0x0008
	push	hl
	call	___memcpy
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/dialogue.c:29: memcpy(c->character,"ALIS",5); clear_lines(c); return 1;
	pop	de
	push	de
	ld	hl, #0x0012
	add	hl, de
	ld	e, l
	ld	d, h
	ld	bc, #0x0005
	push	bc
	ld	bc, #___str_0
	call	_memcpy
	pop	de
	push	de
	call	_clear_lines
	ld	a, #0x01
	jr	00107$
00106$:
;src/dialogue.c:27: for(i=0;i<dialogue_ref_count;i++) if(dialogue_refs[i].id==id) {
	inc	bc
	jr	00105$
00103$:
;src/dialogue.c:31: return 0;
	xor	a, a
00107$:
;src/dialogue.c:32: }
	add	sp, #8
	ret
___str_0:
	.ascii "ALIS"
	.db 0x00
;src/dialogue.c:33: void dialogue_item_name(uint8_t item,char out[9]) DIALOGUE_BANKED {
;	---------------------------------
; Function dialogue_item_name
; ---------------------------------
	b_dialogue_item_name	= 8
_dialogue_item_name::
;src/dialogue.c:34: if(item<=64) memcpy(out,dialogue_items[item],9); else out[0]=0;
	ld	a, #0x40
	ldhl	sp,	#6
	sub	a, (hl)
	jr	C, 00102$
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_dialogue_items
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
	ret
00102$:
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	xor	a, a
	ld	(bc), a
;src/dialogue.c:35: }
	ret
;src/dialogue.c:36: static void number_token(DialogueCursor *c) {
;	---------------------------------
; Function number_token
; ---------------------------------
_number_token:
	add	sp, #-7
	ld	c, e
	ld	b, d
;src/dialogue.c:37: uint16_t n=c->number, place=10000;
	ld	hl, #0x000a
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	de, #0x2710
;src/dialogue.c:38: uint8_t pos=0,digit,started=0;
	ldhl	sp,	#2
	ld	(hl), #0x00
;src/dialogue.c:39: while(place) {
	ld	hl, #0x0029
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl+), a
	inc	hl
	ld	(hl), #0x00
00105$:
	ld	a, d
	or	a, e
	jr	Z, 00107$
;src/dialogue.c:40: digit=(uint8_t)(n/place);n%=place;
	push	de
	ld	c, e
	ld	b, d
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__divuint
	pop	de
	ldhl	sp,	#5
	ld	(hl), c
	push	de
	ld	c, e
	ld	b, d
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
;src/dialogue.c:41: if(digit||started||place==1) {c->token[pos++]=(char)('0'+digit);started=1;}
	call	__moduint
	ldhl	sp,	#2
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	de
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	NZ, 00101$
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	NZ, 00101$
	ld	a, e
	dec	a
	or	a, d
	jr	NZ, 00102$
00101$:
	ldhl	sp,	#6
	ld	a, (hl)
	inc	(hl)
	push	de
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, #0x30
	ld	(bc), a
	ldhl	sp,	#2
	ld	(hl), #0x01
00102$:
;src/dialogue.c:42: place/=10;
	ld	bc, #0x000a
	call	__divuint
	ld	e, c
	ld	d, b
	jr	00105$
00107$:
;src/dialogue.c:44: c->token[pos]=0;
	ldhl	sp,	#6
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#3
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/dialogue.c:45: }
	add	sp, #7
	ret
;src/dialogue.c:46: uint8_t dialogue_next_page(DialogueCursor *c) DIALOGUE_BANKED {
;	---------------------------------
; Function dialogue_next_page
; ---------------------------------
	b_dialogue_next_page	= 8
_dialogue_next_page::
	add	sp, #-22
;src/dialogue.c:48: if(c->done) return 0;
	ldhl	sp,#28
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#21
	ld	(hl), a
	or	a, a
	jr	Z, 00102$
	xor	a, a
	jp	00134$
00102$:
;src/dialogue.c:49: if(c->resume_line) {newline(c);c->resume_line=0;}
	ldhl	sp,#28
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00143$
	push	bc
	ldhl	sp,	#30
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_newline
	pop	bc
	xor	a, a
	ld	(bc), a
;src/dialogue.c:50: while(c->offset<c->ref.length) {
00143$:
	ldhl	sp,#28
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#28
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#28
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#28
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#28
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#28
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,#28
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl), a
00127$:
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#20
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
;src/dialogue.c:52: if(b>=0x62 && b<=0x65) {c->done=1;c->terminator=b;return 1;}
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
;src/dialogue.c:50: while(c->offset<c->ref.length) {
	ldhl	sp,	#20
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	jp	NC, 00129$
;src/dialogue.c:51: b=bank_read8(c->ref.bank,c->ref.text+c->offset++);
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#18
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
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
	ldhl	sp,	#20
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	inc	de
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#18
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	call	_bank_read8
;src/dialogue.c:52: if(b>=0x62 && b<=0x65) {c->done=1;c->terminator=b;return 1;}
	ld	c, a
	sub	a, #0x62
	jr	C, 00106$
	ld	a, #0x65
	sub	a, c
	jr	C, 00106$
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
	ld	a, #0x01
	jp	00134$
00106$:
;src/dialogue.c:53: if(b==0x61) {c->resume_line=1;return 1;}
	ld	a, c
	sub	a, #0x61
	jr	NZ, 00109$
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a,#0x01
	ld	(hl),a
	jp	00134$
00109$:
;src/dialogue.c:54: if(b==0x60) {newline(c);continue;}
	ld	a, c
	sub	a, #0x60
	jr	NZ, 00111$
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_newline
	jp	00127$
00111$:
;src/dialogue.c:55: if(b==0x5f) {clear_lines(c);continue;}
	ld	a, c
	sub	a, #0x5f
	jr	NZ, 00113$
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_clear_lines
	jp	00127$
00113$:
;src/dialogue.c:56: if(b>=0x5b && b<=0x5e) {
	ld	a, c
	sub	a, #0x5b
	jp	C, 00125$
	ld	a, #0x5e
	sub	a, c
	jp	C, 00125$
;src/dialogue.c:57: if(b==0x5b) {memcpy(c->token,c->character,5);}
	ld	a, c
	sub	a, #0x5b
	jr	NZ, 00121$
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0012
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0005
	push	hl
	call	_memcpy
	jr	00122$
00121$:
;src/dialogue.c:58: else if(b==0x5c) memcpy(c->token,c->enemy,9);
	ld	a, c
	sub	a, #0x5c
	jr	NZ, 00118$
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0017
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0009
	push	hl
	call	_memcpy
	jr	00122$
00118$:
;src/dialogue.c:59: else if(b==0x5d) memcpy(c->token,c->item,9);
	ld	a, c
	sub	a, #0x5d
	jr	NZ, 00115$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0020
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0009
	push	hl
	call	_memcpy
	jr	00122$
00115$:
;src/dialogue.c:60: else number_token(c);
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_number_token
00122$:
;src/dialogue.c:61: for(c->token_pos=0;c->token_pos<8 && c->token[c->token_pos];c->token_pos++) put_char(c,c->token[c->token_pos]);
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0011
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
00132$:
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	sub	a, #0x08
	jp	NC, 00127$
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#12
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#21
	ld	(hl),a
	or	a,a
	jp	Z,00127$
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_put_char
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0011
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	ld	(bc), a
	jr	00132$
;src/dialogue.c:62: continue;
00125$:
;src/dialogue.c:64: put_char(c,(char)b);
	ld	a, c
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_put_char
	jp	00127$
00129$:
;src/dialogue.c:66: c->done=1; return 1;
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x01
	ld	(hl),a
00134$:
;src/dialogue.c:67: }
	add	sp, #22
	ret
;src/dialogue.c:68: static void story_clear(DialogueCursor *c,char lower[2][19]) DIALOGUE_BANKED {
;	---------------------------------
; Function story_clear
; ---------------------------------
	b_story_clear	= 8
_story_clear:
;src/dialogue.c:69: clear_lines(c);memset(lower[0],' ',18);memset(lower[1],' ',18);
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_clear_lines
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	ld	hl, #0x0012
	push	hl
	ld	l, #0x20
	push	hl
	push	de
	call	_memset
	add	sp, #6
	ld	hl, #0x0013
	add	hl, bc
	ld	de, #0x0012
	push	de
	ld	de, #0x0020
	push	de
	push	hl
	call	_memset
	add	sp, #6
;src/dialogue.c:70: lower[0][18]=0;lower[1][18]=0;
	ld	hl, #0x0012
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x0025
	add	hl, bc
	ld	(hl), #0x00
;src/dialogue.c:71: }
	ret
;src/dialogue.c:72: static void story_char(DialogueCursor *c,char lower[2][19],char ch) DIALOGUE_BANKED {
;	---------------------------------
; Function story_char
; ---------------------------------
	b_story_char	= 8
_story_char:
	add	sp, #-11
;src/dialogue.c:73: if(c->column>=18u){if(c->row<3u)++c->row;c->column=0;}
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000f
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
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000e
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00104$
	ld	a, (bc)
	cp	a, #0x03
	jr	NC, 00102$
	inc	a
	ld	(bc), a
00102$:
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
00104$:
;src/dialogue.c:74: if(c->row<2u)c->lines[c->row][c->column++]=ch=='@'?'\'':ch;
	ld	a, (bc)
	ldhl	sp,	#10
	ld	(hl), a
;src/dialogue.c:73: if(c->column>=18u){if(c->row<3u)++c->row;c->column=0;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
;src/dialogue.c:74: if(c->row<2u)c->lines[c->row][c->column++]=ch=='@'?'\'':ch;
	ldhl	sp,	#21
	ld	a, (hl)
	sub	a, #0x40
	ld	a, #0x01
	jr	Z, 00150$
	xor	a, a
00150$:
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl+), a
	rlca
	sbc	a, a
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl)
	inc	a
	ldhl	sp,	#8
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00106$
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0032
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#10
	ld	a, (hl)
	ld	c, a
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	add	a, a
	sub	a, c
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00110$
	dec	hl
	dec	hl
	ld	a, #0x27
	ld	(hl+), a
	xor	a, a
	ld	(hl), a
	jr	00111$
00110$:
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
00111$:
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#9
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jr	00108$
00106$:
;src/dialogue.c:75: else lower[c->row-2u][c->column++]=ch=='@'?'\'':ch;
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	pop	de
	push	de
	ld	hl, #0x0002
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, e
	ld	(hl+), a
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00112$
	ld	a, #0x27
	jr	00113$
00112$:
	ldhl	sp,	#6
	ld	a, (hl+)
00113$:
	ld	(bc), a
00108$:
;src/dialogue.c:76: }
	add	sp, #11
	ret
;src/dialogue.c:77: uint8_t dialogue_next_story_page(DialogueCursor *c,char lower[2][19]) DIALOGUE_BANKED {
;	---------------------------------
; Function dialogue_next_story_page
; ---------------------------------
	b_dialogue_next_story_page	= 8
_dialogue_next_story_page::
	add	sp, #-25
;src/dialogue.c:79: if(c->done)return 0;
	ldhl	sp,	#31
	ld	a, (hl)
	ldhl	sp,	#23
	ld	(hl), a
	ldhl	sp,	#32
	ld	a, (hl)
	ldhl	sp,	#24
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
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
	jr	Z, 00102$
	xor	a, a
	jp	00135$
00102$:
;src/dialogue.c:80: story_clear(c,lower);c->resume_line=0;
	ldhl	sp,	#33
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#25
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_story_clear
	ld	hl, #_story_clear
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/dialogue.c:81: while(c->offset<c->ref.length) {
	ldhl	sp,#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#13
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#18
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#22
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#21
	ld	(hl), a
00128$:
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
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#23
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ldhl	sp,	#23
	ld	a, (de)
	inc	de
	sub	a, (hl)
	inc	hl
	ld	a, (de)
	sbc	a, (hl)
	jp	NC, 00130$
;src/dialogue.c:82: b=bank_read8(c->ref.bank,c->ref.text+c->offset++);
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#23
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	inc	de
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	pop	de
	push	de
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	e, c
	ld	d, b
	call	_bank_read8
;src/dialogue.c:83: if(b>=0x62u&&b<=0x65u){c->done=1;c->terminator=b;return 1;}
	ldhl	sp,#24
	ld	(hl), a
	sub	a, #0x62
	jr	C, 00104$
	ld	a, #0x65
	sub	a, (hl)
	jr	C, 00104$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	(hl), #0x01
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#24
	ld	a, (hl)
	ld	(bc), a
	ld	a, #0x01
	jp	00135$
00104$:
;src/dialogue.c:84: if(b==0x61u)return 1;
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, #0x61
	jr	NZ, 00107$
	ld	a, #0x01
	jp	00135$
00107$:
;src/dialogue.c:85: if(b==0x60u){if(c->row<3u)++c->row;c->column=0;continue;}
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, #0x60
	jr	NZ, 00111$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000e
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#25
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#24
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	cp	a, #0x03
	jr	NC, 00109$
	dec	hl
	inc	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00109$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000f
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	jp	00128$
00111$:
;src/dialogue.c:86: if(b==0x5fu){story_clear(c,lower);continue;}
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, #0x5f
	jr	NZ, 00113$
	ldhl	sp,	#33
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_story_clear
	ld	hl, #_story_clear
	call	___sdcc_bcall_ehl
	add	sp, #4
	jp	00128$
00113$:
;src/dialogue.c:87: if(b>=0x5bu&&b<=0x5eu) {
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, #0x5b
	jp	C, 00125$
	ld	a, #0x5e
	sub	a, (hl)
	jp	C, 00125$
;src/dialogue.c:88: if(b==0x5bu)memcpy(c->token,c->character,5);
	ld	a, (hl)
	sub	a, #0x5b
	jr	NZ, 00121$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0012
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0005
	push	hl
	call	_memcpy
	jr	00122$
00121$:
;src/dialogue.c:89: else if(b==0x5cu)memcpy(c->token,c->enemy,9);
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, #0x5c
	jr	NZ, 00118$
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0017
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0009
	push	hl
	call	_memcpy
	jr	00122$
00118$:
;src/dialogue.c:90: else if(b==0x5du)memcpy(c->token,c->item,9);
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, #0x5d
	jr	NZ, 00115$
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0020
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0009
	push	hl
	call	_memcpy
	jr	00122$
00115$:
;src/dialogue.c:91: else number_token(c);
	ldhl	sp,	#31
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_number_token
00122$:
;src/dialogue.c:92: for(c->token_pos=0;c->token_pos<8u&&c->token[c->token_pos];++c->token_pos)
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0011
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#24
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
00133$:
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	sub	a, #0x08
	jp	NC, 00128$
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#20
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#24
;src/dialogue.c:93: story_char(c,lower,c->token[c->token_pos]);
	ld	(hl),a
	or	a,a
	jp	Z,00128$
	push	af
	inc	sp
	ldhl	sp,	#34
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#19
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_story_char
	ld	hl, #_story_char
	call	___sdcc_bcall_ehl
	add	sp, #5
;src/dialogue.c:92: for(c->token_pos=0;c->token_pos<8u&&c->token[c->token_pos];++c->token_pos)
	ldhl	sp,#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0011
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	inc	a
	ld	(bc), a
	jr	00133$
00125$:
;src/dialogue.c:94: } else story_char(c,lower,(char)b);
	ldhl	sp,	#24
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#34
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#34
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_story_char
	ld	hl, #_story_char
	call	___sdcc_bcall_ehl
	add	sp, #5
	jp	00128$
00130$:
;src/dialogue.c:96: c->done=1;return 1;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x01
	ld	(hl),a
00135$:
;src/dialogue.c:97: }
	add	sp, #25
	ret
;src/dialogue.c:99: void dialogue_stream_begin(DialogueCursor *c,char lower[2][19]) DIALOGUE_BANKED {
;	---------------------------------
; Function dialogue_stream_begin
; ---------------------------------
	b_dialogue_stream_begin	= 8
_dialogue_stream_begin::
;src/dialogue.c:100: if(lower)story_clear(c,lower);else clear_lines(c);
	ldhl	sp,	#9
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00102$
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_story_clear
	ld	hl, #_story_clear
	call	___sdcc_bcall_ehl
	add	sp, #4
	jr	00103$
00102$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_clear_lines
00103$:
;src/dialogue.c:101: c->resume_line=0;c->token_pos=255;c->stream_delay=0;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0010
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x0011
	add	hl, bc
	ld	(hl), #0xff
	ld	hl, #0x0058
	add	hl, bc
	ld	(hl), #0x00
;src/dialogue.c:102: }
	ret
;src/dialogue.c:103: static uint8_t stream_newline(DialogueCursor *c) {
;	---------------------------------
; Function stream_newline
; ---------------------------------
_stream_newline:
;src/dialogue.c:104: uint8_t scroll=c->row;
	ld	hl, #0x000e
	add	hl, de
	ld	c, (hl)
;src/dialogue.c:105: newline(c);
	push	bc
	push	de
	call	_newline
	pop	de
	pop	bc
;src/dialogue.c:106: if(scroll)c->stream_delay=7u;
	ld	a, c
	or	a, a
	jr	Z, 00102$
	ld	hl, #0x0058
	add	hl, de
	ld	(hl), #0x07
00102$:
;src/dialogue.c:107: return scroll;
	ld	a, c
;src/dialogue.c:108: }
	ret
;src/dialogue.c:109: uint8_t dialogue_stream_next(DialogueCursor *c,char lower[2][19]) DIALOGUE_BANKED {
;	---------------------------------
; Function dialogue_stream_next
; ---------------------------------
	b_dialogue_stream_next	= 8
_dialogue_stream_next::
	add	sp, #-20
;src/dialogue.c:111: if(c->done)return DIALOGUE_STREAM_WAIT;
	ldhl	sp,	#26
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#27
	ld	a, (hl)
	ldhl	sp,	#3
;src/dialogue.c:126: if(c->offset>=c->ref.length){c->done=1;return DIALOGUE_STREAM_WAIT;}
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
;src/dialogue.c:111: if(c->done)return DIALOGUE_STREAM_WAIT;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#19
	ld	(hl), a
	or	a, a
	jr	Z, 00102$
	xor	a, a
	jp	00166$
00102$:
;src/dialogue.c:112: if(c->stream_delay){--c->stream_delay;return DIALOGUE_STREAM_DELAY;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0058
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
	ld	a, (de)
	or	a, a
	jr	Z, 00104$
	dec	hl
	dec	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, #0x03
	jp	00166$
00104$:
;src/dialogue.c:113: if(c->resume_line) {
	ldhl	sp,#2
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
	or	a, a
	jr	Z, 00186$
;src/dialogue.c:114: c->resume_line=0;
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), #0x00
;src/dialogue.c:115: if(lower)story_clear(c,lower);
	ldhl	sp,	#29
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00108$
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_story_clear
	ld	hl, #_story_clear
	call	___sdcc_bcall_ehl
	add	sp, #4
	jr	00186$
00108$:
;src/dialogue.c:116: else if(stream_newline(c))return DIALOGUE_STREAM_SCROLL;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_stream_newline
	or	a, a
	jr	Z, 00186$
	ld	a, #0x02
	jp	00166$
;src/dialogue.c:118: while(1) {
00186$:
	ldhl	sp,#2
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
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#13
	ld	(hl), a
00164$:
;src/dialogue.c:119: if(c->token_pos<8u && c->token[c->token_pos]) {
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#19
	ld	(hl), a
;src/dialogue.c:120: if(!lower&&c->column==18u&&stream_newline(c))return DIALOGUE_STREAM_SCROLL;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000f
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
;src/dialogue.c:119: if(c->token_pos<8u && c->token[c->token_pos]) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x08
	jp	NC, 00120$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#19
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#16
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
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
	ld	a, (de)
	or	a, a
	jp	Z, 00120$
;src/dialogue.c:120: if(!lower&&c->column==18u&&stream_newline(c))return DIALOGUE_STREAM_SCROLL;
	ldhl	sp,	#29
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00113$
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x12
	jr	NZ, 00113$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_stream_newline
	or	a, a
	jr	Z, 00113$
	ld	a, #0x02
	jp	00166$
00113$:
;src/dialogue.c:121: b=(uint8_t)c->token[c->token_pos++];
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#18
	ld	(hl+), a
	inc	a
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#19
	ld	a, (hl-)
	ld	(de), a
	ld	a, (hl-)
	ld	e, a
	ld	d, #0x00
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
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
;src/dialogue.c:122: if(lower)story_char(c,lower,(char)b);else put_char(c,(char)b);
	ldhl	sp,	#19
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00117$
	ldhl	sp,	#19
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#29
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#29
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_story_char
	ld	hl, #_story_char
	call	___sdcc_bcall_ehl
	add	sp, #5
	jr	00118$
00117$:
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#26
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_put_char
00118$:
;src/dialogue.c:123: return DIALOGUE_STREAM_CHAR;
	ld	a, #0x01
	jp	00166$
00120$:
;src/dialogue.c:125: c->token_pos=255;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0xff
;src/dialogue.c:126: if(c->offset>=c->ref.length){c->done=1;return DIALOGUE_STREAM_WAIT;}
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
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
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#0
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	jr	C, 00123$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	xor	a, a
	jp	00166$
00123$:
;src/dialogue.c:127: b=bank_read8(c->ref.bank,c->ref.text+c->offset);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	pop	hl
	push	hl
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	call	_bank_read8
;src/dialogue.c:128: if(b>=0x61u&&b<=0x65u) {
	ldhl	sp,#19
	ld	(hl), a
	sub	a, #0x61
	jr	C, 00128$
	ld	a, #0x65
	sub	a, (hl)
	jr	C, 00128$
;src/dialogue.c:129: ++c->offset;c->terminator=b;
	dec	hl
	dec	hl
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
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#19
	ld	a, (hl)
	ld	(bc), a
;src/dialogue.c:130: if(b==0x61u)c->resume_line=1;else c->done=1;
	ld	a, (hl)
	sub	a, #0x61
	jr	NZ, 00125$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	jr	00126$
00125$:
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
00126$:
;src/dialogue.c:131: return DIALOGUE_STREAM_WAIT;
	xor	a, a
	jp	00166$
00128$:
;src/dialogue.c:133: if(b==0x60u) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x60
	jr	NZ, 00138$
;src/dialogue.c:134: ++c->offset;
	ldhl	sp,#17
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
;src/dialogue.c:135: if(lower){if(c->row<3u)++c->row;c->column=0;}
	ldhl	sp,	#29
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00135$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000e
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	cp	a, #0x03
	jr	NC, 00131$
	inc	a
	ld	(bc), a
00131$:
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	jp	00164$
00135$:
;src/dialogue.c:136: else if(stream_newline(c))return DIALOGUE_STREAM_SCROLL;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_stream_newline
	ldhl	sp,#19
	ld	(hl), a
	or	a, a
	jp	Z, 00164$
	ld	a, #0x02
	jp	00166$
;src/dialogue.c:137: continue;
00138$:
;src/dialogue.c:139: if(b==0x5fu) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x5f
	jr	NZ, 00143$
;src/dialogue.c:140: ++c->offset;if(lower)story_clear(c,lower);else clear_lines(c);continue;
	ldhl	sp,#17
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
	ldhl	sp,	#29
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00140$
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#28
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_story_clear
	ld	hl, #_story_clear
	call	___sdcc_bcall_ehl
	add	sp, #4
	jp	00164$
00140$:
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_clear_lines
	jp	00164$
00143$:
;src/dialogue.c:142: if(b>=0x5bu&&b<=0x5eu) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x5b
	jp	C, 00154$
	ld	a, #0x5e
	sub	a, (hl)
	jp	C, 00154$
;src/dialogue.c:143: ++c->offset;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	ld	a, l
	ld	(bc), a
	inc	bc
	ld	a, h
	ld	(bc), a
;src/dialogue.c:144: if(b==0x5bu)memcpy(c->token,c->character,5);
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0029
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x5b
	jr	NZ, 00151$
	push	de
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0012
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	hl, #0x0005
	push	hl
	call	_memcpy
	jr	00152$
00151$:
;src/dialogue.c:145: else if(b==0x5cu)memcpy(c->token,c->enemy,9);
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x5c
	jr	NZ, 00148$
	push	de
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0017
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	hl, #0x0009
	push	hl
	call	_memcpy
	jr	00152$
00148$:
;src/dialogue.c:146: else if(b==0x5du)memcpy(c->token,c->item,9);
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x5d
	jr	NZ, 00145$
	push	de
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0020
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	hl, #0x0009
	push	hl
	call	_memcpy
	jr	00152$
00145$:
;src/dialogue.c:147: else number_token(c);
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_number_token
00152$:
;src/dialogue.c:148: c->token_pos=0;continue;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0011
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	jp	00164$
00154$:
;src/dialogue.c:150: if(!lower&&c->column==18u&&stream_newline(c))return DIALOGUE_STREAM_SCROLL;
	ldhl	sp,	#29
	ld	a, (hl-)
	or	a, (hl)
	jr	NZ, 00157$
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x12
	jr	NZ, 00157$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_stream_newline
	or	a, a
	jr	Z, 00157$
	ld	a, #0x02
	jr	00166$
00157$:
;src/dialogue.c:151: ++c->offset;
	ldhl	sp,#17
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
;src/dialogue.c:122: if(lower)story_char(c,lower,(char)b);else put_char(c,(char)b);
	ldhl	sp,	#19
	ld	b, (hl)
;src/dialogue.c:152: if(lower)story_char(c,lower,(char)b);else put_char(c,(char)b);
	ldhl	sp,	#29
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00161$
	push	bc
	inc	sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_story_char
	ld	hl, #_story_char
	call	___sdcc_bcall_ehl
	add	sp, #5
	jr	00162$
00161$:
	ld	a, b
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_put_char
00162$:
;src/dialogue.c:153: return DIALOGUE_STREAM_CHAR;
	ld	a, #0x01
00166$:
;src/dialogue.c:155: }
	add	sp, #20
	ret
;src/dialogue.c:157: uint16_t dialogue_wait_frames(uint8_t terminator,uint8_t narrative) DIALOGUE_BANKED {
;	---------------------------------
; Function dialogue_wait_frames
; ---------------------------------
	b_dialogue_wait_frames	= 8
_dialogue_wait_frames::
;src/dialogue.c:158: if(narrative)return terminator==0x63u?208u:65535u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x63
	ld	a, #0x01
	jr	Z, 00149$
	xor	a, a
00149$:
	ld	c, a
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	ld	a, c
	or	a, a
	jr	Z, 00111$
	ld	bc, #0x00d0
	ret
00111$:
	ld	bc, #0xffff
	ret
00102$:
;src/dialogue.c:159: if(terminator==0x62u)return 0;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x62
	jr	NZ, 00104$
	ld	bc, #0x0000
	ret
00104$:
;src/dialogue.c:160: if(terminator==0x63u)return 30u;
	ld	a, c
	or	a, a
	jr	Z, 00106$
	ld	bc, #0x001e
	ret
00106$:
;src/dialogue.c:161: if(terminator==0x64u)return 208u;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x64
	jr	NZ, 00108$
	ld	bc, #0x00d0
	ret
00108$:
;src/dialogue.c:162: return 65535u;
	ld	bc, #0xffff
;src/dialogue.c:163: }
	ret
;src/dialogue.c:164: uint8_t dialogue_wait_tick(uint16_t *remaining,uint8_t terminator,uint8_t narrative,uint8_t pressed) DIALOGUE_BANKED {
;	---------------------------------
; Function dialogue_wait_tick
; ---------------------------------
	b_dialogue_wait_tick	= 8
_dialogue_wait_tick::
;src/dialogue.c:165: if(!*remaining)return 1;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	or	a, c
	jr	NZ, 00102$
	ld	a, #0x01
	ret
00102$:
;src/dialogue.c:166: if(*remaining==65535u)return !!pressed;
	ld	e, c
	ld	d, b
	ld	a, e
	and	a, d
	inc	a
	jr	NZ, 00104$
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ret
00104$:
;src/dialogue.c:167: if(!narrative&&terminator==0x63u&&pressed){*remaining=0;return 1;}
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	NZ, 00106$
	dec	hl
	ld	a, (hl)
	sub	a, #0x63
	jr	NZ, 00106$
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
	ld	a, #0x01
	ret
00106$:
;src/dialogue.c:168: --*remaining;return !*remaining;
	dec	bc
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	a,b
	ld	(hl),a
	or	a, c
	sub	a, #0x01
	ld	a, #0x00
	rla
;src/dialogue.c:169: }
	ret
	.area _CODE_8
	.area _INITIALIZER
	.area _CABS (ABS)
