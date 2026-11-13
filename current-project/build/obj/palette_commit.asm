;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module palette_commit
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _vsync
	.globl _scene_palette_background
	.globl b_scene_palette_commit
	.globl _scene_palette_commit
	.globl b_scene_palette_capture
	.globl _scene_palette_capture
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_scene_palette_background::
	.ds 64
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
;src/palette_commit.c:6: static uint16_t palette_color(uint8_t sprites,uint8_t index) {
;	---------------------------------
; Function palette_color
; ---------------------------------
_palette_color:
	ld	b, a
;src/palette_commit.c:8: while(STAT_REG&2u);
00101$:
	ldh	a, (_STAT_REG + 0)
	bit	1, a
	jr	NZ, 00101$
;src/palette_commit.c:9: if(sprites){OCPS_REG=index*2u;lo=OCPD_REG;}else{BCPS_REG=index*2u;lo=BCPD_REG;}
	ld	a, e
	add	a, a
	inc	b
	dec	b
	jr	Z, 00105$
	ldh	(_OCPS_REG + 0), a
	ldh	a, (_OCPD_REG + 0)
	ld	c, a
	jr	00107$
00105$:
	ldh	(_BCPS_REG + 0), a
	ldh	a, (_BCPD_REG + 0)
	ld	c, a
;src/palette_commit.c:10: while(STAT_REG&2u);
00107$:
	ldh	a, (_STAT_REG + 0)
	bit	1, a
	jr	NZ, 00107$
;src/palette_commit.c:9: if(sprites){OCPS_REG=index*2u;lo=OCPD_REG;}else{BCPS_REG=index*2u;lo=BCPD_REG;}
	ld	a, e
	add	a, a
;src/palette_commit.c:11: if(sprites){OCPS_REG=index*2u+1u;hi=OCPD_REG;}else{BCPS_REG=index*2u+1u;hi=BCPD_REG;}
	inc	a
	inc	b
	dec	b
	jr	Z, 00111$
	ldh	(_OCPS_REG + 0), a
	ldh	a, (_OCPD_REG + 0)
	jr	00112$
00111$:
	ldh	(_BCPS_REG + 0), a
	ldh	a, (_BCPD_REG + 0)
00112$:
;src/palette_commit.c:12: return (uint16_t)lo|((uint16_t)hi<<8);
	ld	b, a
;src/palette_commit.c:13: }
	ret
;src/palette_commit.c:14: static void commit_palette_bytes(void) __naked {
;	---------------------------------
; Function commit_palette_bytes
; ---------------------------------
_commit_palette_bytes:
;src/palette_commit.c:37: __endasm;
	ld	hl,#_scene_palette_background
	ld	a,#0x80
	ldh	(#0x68),a
	ld	c,#0x69
	ld	b,#64
001$:
	ld	a,(hl+)
	ldh	(c),a
	dec	b
	jr	nz,001$
	ld	hl,#_scene_shared_colors
	ld	a,#0x80
	ldh	(#0x6a),a
	ld	c,#0x6b
	ld	b,#64
002$:
	ld	a,(hl+)
	ldh	(c),a
	dec	b
	jr	nz,002$
	ret
;src/palette_commit.c:38: }
;src/palette_commit.c:39: void scene_palette_commit(void) __banked {
;	---------------------------------
; Function scene_palette_commit
; ---------------------------------
	b_scene_palette_commit	= 119
_scene_palette_commit::
;src/palette_commit.c:42: if(LCDC_REG&LCDCF_ON)vsync();
	ldh	a, (_LCDC_REG + 0)
	rlca
	jr	NC, 00102$
	call	_vsync
00102$:
;src/palette_commit.c:45: CRITICAL {commit_palette_bytes();}
	di
	call	_commit_palette_bytes
	ei
;src/palette_commit.c:46: }
	ret
;src/palette_commit.c:48: void scene_palette_capture(void) __banked {
;	---------------------------------
; Function scene_palette_capture
; ---------------------------------
	b_scene_palette_capture	= 119
_scene_palette_capture::
;src/palette_commit.c:50: for(i=0;i<32u;++i)scene_palette_background[i]=palette_color(0u,i);
	ld	e, #0x00
00103$:
	ld	l, e
	ld	h, #0x00
	add	hl, hl
	ld	bc, #_scene_palette_background
	add	hl, bc
	push	hl
	push	de
	xor	a, a
	call	_palette_color
	pop	de
	pop	hl
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	inc	e
	ld	a, e
	sub	a, #0x20
	jr	C, 00103$
;src/palette_commit.c:51: for(i=0;i<32u;++i)scene_shared_colors[i]=palette_color(1u,i);
	ld	e, #0x00
00105$:
	ld	l, e
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	bc, #_scene_shared_colors
	add	hl, bc
	push	hl
	push	de
	ld	a, #0x01
	call	_palette_color
	pop	de
	pop	hl
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	inc	e
	ld	a, e
	sub	a, #0x20
	jr	C, 00105$
;src/palette_commit.c:52: }
	ret
	.area _CODE_119
	.area _INITIALIZER
	.area _CABS (ABS)
