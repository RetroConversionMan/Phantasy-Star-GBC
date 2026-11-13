;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module cutscene
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_cutscene_advance
	.globl _cutscene_advance
	.globl b_cutscene_begin
	.globl _cutscene_begin
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
;src/cutscene.c:16: const CutsceneAction *cutscene_advance(CutsceneState *s) RPG_BANKED {
;	---------------------------------
; Function cutscene_advance
; ---------------------------------
	b_cutscene_advance	= 12
_cutscene_advance::
	add	sp, #-6
;src/cutscene.c:18: if(!s->sequence||s->sequence>6u||s->step>=lengths[s->sequence]){
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
;src/cutscene.c:19: s->action.kind=CUTSCENE_DONE;s->action.dialogue_id=0;return &s->action;
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#12
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
	ldhl	sp,#12
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
	ld	(hl), a
;src/cutscene.c:18: if(!s->sequence||s->sequence>6u||s->step>=lengths[s->sequence]){
	ld	a, c
	or	a, a
	jr	Z, 00101$
	ld	a, #0x06
	sub	a, c
	jr	C, 00101$
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	a, (de)
	ld	b, a
	ld	a, #<(_lengths)
	add	a, c
	ld	l, a
	ld	a, #>(_lengths)
	adc	a, #0x00
	ld	h, a
	ld	a, b
	sub	a, (hl)
	jr	C, 00102$
00101$:
;src/cutscene.c:19: s->action.kind=CUTSCENE_DONE;s->action.dialogue_id=0;return &s->action;
	pop	hl
	ld	(hl), #0x00
	push	hl
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	jr	00107$
00102$:
;src/cutscene.c:21: index=starts[s->sequence]+s->step++;
	ld	a, #<(_starts)
	add	a, c
	ld	l, a
	ld	a, #>(_starts)
	adc	a, #0x00
	ld	h, a
	ld	c, (hl)
	ld	a, b
	inc	a
	ld	(de), a
	ld	a, c
	add	a, b
	ld	c, a
;src/cutscene.c:22: s->action.kind=CUTSCENE_TEXT;s->action.portrait=portraits[index];
	pop	hl
	ld	(hl), #0x01
	push	hl
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #_portraits
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
;src/cutscene.c:23: if(s->action.portrait==255u)s->action.portrait=s->first_speaker;
	inc	a
	jr	NZ, 00106$
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	ld	a, (hl)
	ld	(de), a
00106$:
;src/cutscene.c:24: s->action.dialogue_id=texts[index];return &s->action;
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	ld	de, #_texts
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00107$:
;src/cutscene.c:25: }
	add	sp, #6
	ret
_starts:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x0a	; 10
	.db #0x0c	; 12
	.db #0x0f	; 15
	.db #0x11	; 17
_lengths:
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x06	; 6
_portraits:
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0xff	; 255
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x03	; 3
_texts:
	.dw #0xf617
	.dw #0xf646
	.dw #0xf64d
	.dw #0xf66e
	.dw #0xf6c1
	.dw #0xf6f3
	.dw #0xf746
	.dw #0xf786
	.dw #0xf7b9
	.dw #0xf7d1
	.dw #0xf85c
	.dw #0xf884
	.dw #0xf49b
	.dw #0xf4fc
	.dw #0xf5d5
	.dw #0xf929
	.dw #0xf97c
	.dw #0xf9e8
	.dw #0xf9f0
	.dw #0xf9fb
	.dw #0xfa06
	.dw #0xfa12
	.dw #0xfa54
;src/cutscene.c:26: const CutsceneAction *cutscene_begin(CutsceneState *s,uint8_t sequence,const RPGState *rpg) RPG_BANKED {
;	---------------------------------
; Function cutscene_begin
; ---------------------------------
	b_cutscene_begin	= 12
_cutscene_begin::
	dec	sp
	dec	sp
;src/cutscene.c:27: s->sequence=sequence;s->step=0;
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	a, (hl)
	ld	(bc), a
	ld	l, c
	ld	h, b
	inc	hl
	ld	(hl), #0x00
;src/cutscene.c:28: s->first_speaker=(rpg->party[0].status&1u)?3u:(rpg->party[2].status&1u)?5u:4u;
	ld	hl, #0x0002
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	rrca
	jr	NC, 00103$
	ld	a, #0x03
	jr	00104$
00103$:
	ld	hl, #0x0020
	add	hl, de
	ld	a, (hl)
	rrca
	jr	NC, 00105$
	ld	a, #0x05
	jr	00106$
00105$:
	ld	a, #0x04
00106$:
00104$:
	pop	hl
	push	hl
	ld	(hl), a
;src/cutscene.c:29: return cutscene_advance(s);
	push	bc
	ld	e, #b_cutscene_advance
	ld	hl, #_cutscene_advance
	call	___sdcc_bcall_ehl
	pop	hl
;src/cutscene.c:30: }
	inc	sp
	inc	sp
	ret
	.area _CODE_12
	.area _INITIALIZER
	.area _CABS (ABS)
