;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module bank_io
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_bkg_data
	.globl _memcpy
	.globl _bank_read8
	.globl _bank_copy
	.globl _bank_bkg_data
	.globl _bank_bkg_phase
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
;src/bank_io.c:8: uint8_t bank_read8(uint8_t bank, const void *address) BANK_IO_FIXED {
;	---------------------------------
; Function bank_read8
; ---------------------------------
_bank_read8::
	ld	b, a
	ld	l, e
	ld	h, d
;src/bank_io.c:10: uint8_t saved = CURRENT_BANK;
	ldh	a, (__current_bank + 0)
	ld	c, a
;src/bank_io.c:12: SWITCH_ROM_MBC5(bank);
	ld	a, b
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(_rROMB1), a
	ld	a, b
	ld	(_rROMB0), a
;src/bank_io.c:13: value = *(const uint8_t *)address;
	ld	l, (hl)
;src/bank_io.c:14: SWITCH_ROM_MBC5(saved);
	ld	a, c
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(_rROMB1), a
	ld	a, c
	ld	(_rROMB0), a
;src/bank_io.c:15: return value;
	ld	a, l
;src/bank_io.c:20: }
	ret
;src/bank_io.c:21: void bank_copy(void *destination, uint8_t bank, const void *source, uint16_t length) BANK_IO_FIXED {
;	---------------------------------
; Function bank_copy
; ---------------------------------
_bank_copy::
	dec	sp
	ld	c, a
;src/bank_io.c:23: uint8_t saved = CURRENT_BANK;
	ldh	a, (__current_bank + 0)
	ldhl	sp,	#0
	ld	(hl), a
;src/bank_io.c:24: SWITCH_ROM_MBC5(bank);
	ld	a, c
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), c
;src/bank_io.c:25: memcpy(destination, source, length);
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	call	_memcpy
;src/bank_io.c:26: SWITCH_ROM_MBC5(saved);
	ldhl	sp,	#0
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(#_rROMB0),a
;src/bank_io.c:31: }
	inc	sp
	pop	hl
	add	sp, #4
	jp	(hl)
;src/bank_io.c:32: void bank_bkg_data(uint8_t bank, uint8_t first, uint8_t count, const uint8_t *source, uint8_t vram_bank) BANK_IO_FIXED {
;	---------------------------------
; Function bank_bkg_data
; ---------------------------------
_bank_bkg_data::
	ld	d, a
;src/bank_io.c:34: uint8_t saved = CURRENT_BANK, saved_vram = VBK_REG;
	ldh	a, (__current_bank + 0)
	ld	c, a
	ldh	a, (_VBK_REG + 0)
	ld	b, a
;src/bank_io.c:35: SWITCH_ROM_MBC5(bank);
	ld	a, d
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), d
;src/bank_io.c:36: VBK_REG = vram_bank;
	ldhl	sp,	#5
;src/bank_io.c:37: set_bkg_data(first, count, source);
	ld	a, (hl-)
	ldh	(_VBK_REG + 0), a
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	push	hl
	ldhl	sp,	#4
	ld	d, (hl)
	push	de
	call	_set_bkg_data
	add	sp, #4
;src/bank_io.c:38: VBK_REG = saved_vram;
	ld	a, b
	ldh	(_VBK_REG + 0), a
;src/bank_io.c:39: SWITCH_ROM_MBC5(saved);
	ld	a, c
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), c
;src/bank_io.c:43: }
	pop	hl
	add	sp, #4
	jp	(hl)
;src/bank_io.c:44: void bank_bkg_phase(uint8_t bank,uint8_t first,uint8_t count,const uint8_t *source,uint8_t vram_bank) BANK_IO_FIXED {
;	---------------------------------
; Function bank_bkg_phase
; ---------------------------------
_bank_bkg_phase::
	add	sp, #-3
	ld	c, a
;src/bank_io.c:46: uint16_t from=(uint16_t)source;
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
;src/bank_io.c:47: uint16_t destination=(LCDC_REG&LCDCF_BG8000)?0x8000u+(uint16_t)first*16u:
	ldh	a, (_LCDC_REG + 0)
	bit	4, a
	jr	Z, 00113$
	ld	l, e
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	a, h
	add	a, #0x80
	ld	d, a
	jr	00114$
00113$:
	ld	a, e
	ld	l, a
	rlca
	sbc	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	a, h
	add	a, #0x90
	ld	d, a
00114$:
;src/bank_io.c:49: uint8_t saved=CURRENT_BANK,saved_vram=VBK_REG;
	ldh	a, (__current_bank + 0)
	ld	b, a
	ldh	a, (_VBK_REG + 0)
	ldhl	sp,	#2
	ld	(hl), a
;src/bank_io.c:50: if(!count||count>16u||(from&15u))return;
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00111$
	ld	a, #0x10
	sub	a, (hl)
	jr	C, 00111$
	ldhl	sp,	#0
	ld	a, (hl)
	and	a, #0x0f
	jr	NZ, 00111$
;src/bank_io.c:53: if(LCDC_REG&LCDCF_ON)while(LY_REG<144u||LY_REG>149u){}
	ldh	a, (_LCDC_REG + 0)
	rlca
	jr	NC, 00110$
00106$:
	ldh	a, (_LY_REG + 0)
	sub	a, #0x90
	jr	C, 00106$
	push	bc
	ldh	a, (_LY_REG + 0)
	ld	c, a
	ld	a, #0x95
	sub	a, c
	pop	bc
	jr	C, 00106$
00110$:
;src/bank_io.c:60: }
	di
;src/bank_io.c:55: SWITCH_ROM_MBC5(bank);VBK_REG=vram_bank;
	ld	a, c
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), c
	ldhl	sp,	#8
	ld	a, (hl)
	ldh	(_VBK_REG + 0), a
;src/bank_io.c:56: HDMA1_REG=(uint8_t)(from>>8);HDMA2_REG=(uint8_t)from;
	ldhl	sp,	#1
	ld	a, (hl-)
	ldh	(_HDMA1_REG + 0), a
	ld	a, (hl)
	ldh	(_HDMA2_REG + 0), a
;src/bank_io.c:57: HDMA3_REG=(uint8_t)(destination>>8)&31u;HDMA4_REG=(uint8_t)destination;
	ld	a, d
	and	a, #0x1f
	ldh	(_HDMA3_REG + 0), a
	ld	a, e
	ldh	(_HDMA4_REG + 0), a
;src/bank_io.c:58: HDMA5_REG=count-1u;
	ldhl	sp,	#5
	ld	a, (hl)
	dec	a
	ldh	(_HDMA5_REG + 0), a
;src/bank_io.c:59: VBK_REG=saved_vram;SWITCH_ROM_MBC5(saved);
	ldhl	sp,	#2
	ld	a, (hl)
	ldh	(_VBK_REG + 0), a
	ld	a, b
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), b
	ei
00111$:
;src/bank_io.c:64: }
	add	sp, #3
	pop	hl
	add	sp, #4
	jp	(hl)
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE_0
	.area _CODE_0
	.area _INITIALIZER
	.area _CABS (ABS)
