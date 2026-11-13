;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module audio_irq
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_audio_tick
	.globl _audio_tick
	.globl b_audio_init
	.globl _audio_init
	.globl _add_LCD
	.globl _audio_command_before_tick
	.globl _audio_install
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_audio_before_tick:
	.ds 1
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
;src/audio_irq.c:12: void audio_command_before_tick(uint8_t command) AUDIO_FIXED {
;	---------------------------------
; Function audio_command_before_tick
; ---------------------------------
_audio_command_before_tick::
	ld	c, a
;src/audio_irq.c:21: }
	di
;src/audio_irq.c:18: audio_ram[4]=0x80u;
	ld	hl, #(_audio_ram + 4)
	ld	(hl), #0x80
;src/audio_irq.c:19: audio_before_tick=command;
	ld	hl, #_audio_before_tick
	ld	(hl), c
	ei
;src/audio_irq.c:23: }
	ret
;src/audio_irq.c:25: static void audio_scanline(void) AUDIO_FIXED {
;	---------------------------------
; Function audio_scanline
; ---------------------------------
_audio_scanline:
;src/audio_irq.c:26: uint8_t command=audio_before_tick,later;
	ld	a, (_audio_before_tick)
;src/audio_irq.c:27: if(command) {
	ld	c, a
	or	a, a
	jr	Z, 00104$
;src/audio_irq.c:28: audio_before_tick=0;
	xor	a, a
	ld	(#_audio_before_tick),a
;src/audio_irq.c:29: later=audio_ram[4];
	ld	de, #_audio_ram+4
	ld	a, (de)
	ld	b, a
;src/audio_irq.c:30: audio_ram[4]=command;
	ld	a, c
	ld	(de), a
;src/audio_irq.c:31: audio_tick();
	push	bc
	push	de
	ld	e, #b_audio_tick
	ld	hl, #_audio_tick
	call	___sdcc_bcall_ehl
	pop	de
	pop	bc
;src/audio_irq.c:32: if(later!=0x80u)audio_ram[4]=later;
	ld	a,b
	cp	a,#0x80
	ret	Z
	ld	(de), a
	ret
00104$:
;src/audio_irq.c:33: } else audio_tick();
	ld	e, #b_audio_tick
	ld	hl, #_audio_tick
;src/audio_irq.c:34: }
	jp  ___sdcc_bcall_ehl
;src/audio_irq.c:35: void audio_install(void) AUDIO_FIXED {
;	---------------------------------
; Function audio_install
; ---------------------------------
_audio_install::
;src/audio_irq.c:36: CRITICAL {audio_before_tick=0;audio_init();LYC_REG=0;STAT_REG|=0x40;add_LCD(audio_scanline);IE_REG|=LCD_IFLAG;}
	di
	xor	a, a
	ld	(#_audio_before_tick),a
	ld	e, #b_audio_init
	ld	hl, #_audio_init
	call	___sdcc_bcall_ehl
	xor	a, a
	ldh	(_LYC_REG + 0), a
	ldh	a, (_STAT_REG + 0)
	or	a, #0x40
	ldh	(_STAT_REG + 0), a
	ld	de, #_audio_scanline
	call	_add_LCD
	ldh	a, (_IE_REG + 0)
	or	a, #0x02
	ldh	(_IE_REG + 0), a
	ei
;src/audio_irq.c:37: }
	ret
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE_0
	.area _CODE_0
	.area _INITIALIZER
	.area _CABS (ABS)
