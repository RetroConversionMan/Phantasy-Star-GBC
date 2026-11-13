;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module audio
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_read8
	.globl _memset
	.globl _audio_clock
	.globl _audio_music
	.globl _audio_fault
	.globl _audio_noise
	.globl _audio_volume
	.globl _audio_frames
	.globl _audio_tone
	.globl _audio_ram
	.globl b_audio_gb_period
	.globl _audio_gb_period
	.globl b_audio_gb_volume
	.globl _audio_gb_volume
	.globl b_audio_gb_noise
	.globl _audio_gb_noise
	.globl b_audio_init
	.globl _audio_init
	.globl b_audio_command
	.globl _audio_command
	.globl b_audio_stop
	.globl _audio_stop
	.globl b_audio_map_track
	.globl _audio_map_track
	.globl b_audio_battle_track
	.globl _audio_battle_track
	.globl b_audio_enemy_effect
	.globl _audio_enemy_effect
	.globl b_audio_tick
	.globl _audio_tick
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_audio_ram::
	.ds 512
_audio_tone::
	.ds 6
_audio_frames::
	.ds 2
_audio_volume::
	.ds 4
_audio_noise::
	.ds 1
_audio_fault::
	.ds 1
_audio_music::
	.ds 1
_audio_clock::
	.ds 1
_latch:
	.ds 1
_noise_written:
	.ds 1
_previous_volume:
	.ds 4
_previous_noise:
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
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE_15
;src/audio.c:24: static uint8_t rd(uint16_t addr){
;	---------------------------------
; Function rd
; ---------------------------------
_rd:
;src/audio.c:25: if(addr<0x4000u)return bank_read8(62,audio_low0+addr);
	ld	c,e
	ld	a,d
	ld	b,a
	sub	a, #0x40
	jr	NC, 00102$
	ld	hl, #_audio_low0
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, #0x3e
	jp	_bank_read8
00102$:
;src/audio.c:26: if(addr<0x8000u)return bank_read8(63,audio_low1+(addr&0x3fffu));
	ld	c, e
	ld	a, d
	and	a, #0x3f
	ld	b, a
	ld	a, d
	sub	a, #0x80
	jr	NC, 00104$
	ld	hl, #_audio_low1
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, #0x3f
	jp	_bank_read8
00104$:
;src/audio.c:27: if(addr<0xc000u)return bank_read8(AUDIO_DATA_BANK,audio_data+(addr&0x3fffu));
	ld	a, d
	sub	a, #0xc0
	jr	NC, 00106$
	ld	hl, #_audio_data
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, #0x3d
	jp	_bank_read8
00106$:
;src/audio.c:28: if((addr&0x1fffu)<AUDIO_RAM_SIZE)return R[addr&0x1fffu];
	ld	a, d
	and	a, #0x1f
	ld	d, a
	sub	a, #0x02
	jr	NC, 00108$
	ld	hl, #_audio_ram
	add	hl, de
	ld	a, (hl)
	ret
00108$:
;src/audio.c:29: audio_fault=10;return 0;
	ld	hl, #_audio_fault
	ld	(hl), #0x0a
	xor	a, a
;src/audio.c:30: }
	ret
;src/audio.c:31: static uint16_t rw(uint16_t addr){uint8_t low=rd(addr);return low|((uint16_t)rd(addr+1u)<<8);}
;	---------------------------------
; Function rw
; ---------------------------------
_rw:
	push	de
	call	_rd
	ld	c, a
	pop	de
	inc	de
	push	bc
	call	_rd
	pop	bc
	ld	e, a
	ld	d, #0x00
	ld	b, e
	ret
;src/audio.c:32: static uint16_t cw(const uint8_t *c,uint8_t offset){return c[offset]|((uint16_t)c[offset+1u]<<8);}
;	---------------------------------
; Function cw
; ---------------------------------
_cw:
	ld	b, a
	ld	l, b
	ld	h, #0x00
	add	hl, de
	ld	c, (hl)
	ld	l, b
	xor	a, a
	ld	h, a
	inc	hl
	add	hl, de
	ld	b, (hl)
	ret
;src/audio.c:33: static void sw(uint8_t *c,uint8_t offset,uint16_t v){c[offset]=(uint8_t)v;c[offset+1u]=(uint8_t)(v>>8);}
;	---------------------------------
; Function sw
; ---------------------------------
_sw:
	dec	sp
	ld	c, e
	ld	b, d
	ldhl	sp,	#0
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#0
	ld	l, (hl)
	xor	a, a
	ld	h, a
	inc	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(bc), a
	inc	sp
	pop	hl
	pop	af
	jp	(hl)
;src/audio.c:34: static void psg(uint8_t value){
;	---------------------------------
; Function psg
; ---------------------------------
_psg:
	add	sp, #-3
	ldhl	sp,	#2
;src/audio.c:39: if(value&128u)latch=(value>>4)&7u;
	ld	(hl), a
	and	a, #0x80
	ld	b, a
	ld	e, #0x00
	ld	a, e
	or	a, b
	jr	Z, 00102$
	ld	a, (hl)
	swap	a
	and	a, #0x7
	ld	(#_latch),a
00102$:
;src/audio.c:40: channel=latch>>1;
	ld	hl, #_latch
	ld	d, (hl)
	srl	d
;src/audio.c:41: if(latch&1u)audio_volume[channel]=value&15u;
	ld	a, (hl)
	rrca
	jr	NC, 00110$
	ld	a, #<(_audio_volume)
	add	a, d
	ld	c, a
	ld	a, #>(_audio_volume)
	adc	a, #0x00
	ld	b, a
	ldhl	sp,	#2
	ld	a, (hl)
	and	a, #0x0f
	ld	(bc), a
	jr	00112$
00110$:
;src/audio.c:42: else if(channel==3u){audio_noise=value&7u;noise_written=1;}
	ld	a, d
	sub	a, #0x03
	jr	NZ, 00107$
	ldhl	sp,	#2
	ld	a, (hl)
	and	a, #0x07
	ld	(#_audio_noise),a
	ld	hl, #_noise_written
	ld	(hl), #0x01
	jr	00112$
00107$:
;src/audio.c:43: else if(value&128u)audio_tone[channel]=(audio_tone[channel]&0x3f0u)|(value&15u);
	xor	a, a
	sla	d
	adc	a, a
	ldhl	sp,	#0
	ld	(hl), d
	inc	hl
	ld	(hl), a
	ld	a, e
	or	a, b
	jr	Z, 00104$
	ld	bc, #_audio_tone+0
	pop	hl
	push	hl
	add	hl, bc
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	and	a, #0xf0
	ld	e, a
	ld	a, h
	and	a, #0x03
	ld	d, a
	ldhl	sp,	#2
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	and	a, #0x0f
	or	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	jr	00112$
00104$:
;src/audio.c:44: else audio_tone[channel]=(audio_tone[channel]&15u)|((uint16_t)(value&63u)<<4);
	ld	bc, #_audio_tone+0
	pop	hl
	push	hl
	add	hl, bc
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	and	a, #0x0f
	ld	e, a
	ldhl	sp,	#2
	ld	a, (hl)
	and	a, #0x3f
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	or	a, e
	ld	(bc), a
	inc	bc
	ld	a, h
	ld	(bc), a
00112$:
;src/audio.c:45: }
	add	sp, #3
	ret
;src/audio.c:46: static void silence(void){uint8_t i;for(i=0;i<8u;++i)psg(rd(0x803bu+i));}
;	---------------------------------
; Function silence
; ---------------------------------
_silence:
	ld	c, #0x00
00102$:
	ld	e, c
	ld	d, #0x00
	ld	hl, #0x803b
	add	hl, de
	ld	e, l
	ld	d, h
	push	bc
	call	_rd
	call	_psg
	pop	bc
	inc	c
	ld	a, c
	sub	a, #0x08
	jr	C, 00102$
	ret
;src/audio.c:47: static void clear_control(void){memset(R+3,0,11);}
;	---------------------------------
; Function clear_control
; ---------------------------------
_clear_control:
	ld	de, #0x000b
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #(_audio_ram + 3)
	push	de
	call	_memset
	add	sp, #6
	ret
;src/audio.c:48: static void reset_driver(void){uint8_t i;clear_control();for(i=0;i<15u;++i){CH(i)[0]=0;CH(i)[24]=CH(i)[25]=CH(i)[26]=0;}silence();}
;	---------------------------------
; Function reset_driver
; ---------------------------------
_reset_driver:
	dec	sp
	call	_clear_control
	ldhl	sp,	#0
	ld	(hl), #0x00
00102$:
	ldhl	sp,	#0
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #<((_audio_ram + 14))
	ld	e, a
	ld	a, h
	adc	a, #>((_audio_ram + 14))
	ld	d, a
	xor	a, a
	ld	(de), a
	ld	hl, #0x0018
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #0x0019
	add	hl, de
	ld	a, e
	add	a, #0x1a
	ld	e, a
	jr	NC, 00121$
	inc	d
00121$:
	xor	a, a
	ld	(de), a
	ld	(hl), #0x00
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#0
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x0f
	jr	C, 00102$
	inc	sp
	jp	_silence
	inc	sp
	ret
;src/audio.c:49: static void volume(uint8_t *c){psg((uint8_t)(((c[8]&15u)|c[1])+16u));}
;	---------------------------------
; Function volume
; ---------------------------------
_volume:
	ld	hl, #0x0008
	add	hl, de
	ld	a, (hl)
	and	a, #0x0f
	ld	c, a
	inc	de
	ld	a, (de)
	or	a, c
	add	a, #0x10
	jp	_psg
;src/audio.c:50: static void tone(uint8_t control,uint16_t frequency){
;	---------------------------------
; Function tone
; ---------------------------------
_tone:
	ld	c, a
;src/audio.c:52: uint8_t v=(uint8_t)((frequency&0xf0u)|(frequency>>8));
	ld	l, e
	ld	a, l
	and	a, #0xf0
	or	a, d
	ld	e, a
;src/audio.c:53: psg((uint8_t)((frequency&15u)|control));psg((uint8_t)((v>>4)|(v<<4)));
	ld	a, l
	and	a, #0x0f
	or	a, c
	push	de
	call	_psg
	pop	de
	ld	a, e
	swap	a
;src/audio.c:54: }
	jp	_psg
;src/audio.c:55: static void acknowledge(void){R[4]=0x80;}
;	---------------------------------
; Function acknowledge
; ---------------------------------
_acknowledge:
	ld	hl, #(_audio_ram + 4)
	ld	(hl), #0x80
	ret
;src/audio.c:56: static void resume(void){
;	---------------------------------
; Function resume
; ---------------------------------
_resume:
;src/audio.c:57: uint8_t i;silence();R[2]=R[5];R[10]=0x80;R[11]=10;CH(6)[0]|=4;
	call	_silence
	ld	a, (#(_audio_ram + 5) + 0)
	ld	(#(_audio_ram + 2)),a
	ld	hl, #_audio_ram + 10
	ld	(hl), #0x80
	ld	hl, #_audio_ram + 11
	ld	(hl), #0x0a
	ld	hl, #_audio_ram + 206
	set	2, (hl)
;src/audio.c:58: for(i=0;i<6u;++i){CH(i)[23]=CH(i)[8];CH(i)[8]=9;}acknowledge();
	ld	c, #0x00
00102$:
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #(_audio_ram + 14)
	add	hl, de
	ld	a, l
	add	a, #0x17
	ld	e, a
	ld	a, h
	adc	a, #0x00
	ld	d, a
	push	de
	ld	de, #0x0008
	add	hl, de
	pop	de
	ld	a, (hl)
	ld	(de), a
	ld	(hl), #0x09
	inc	c
	ld	a, c
	sub	a, #0x06
	jr	C, 00102$
;src/audio.c:59: }
	jp	_acknowledge
;src/audio.c:60: static void fade_begin(void){R[10]=3;if(!(R[2]&128u))CH(6)[0]=0;psg(0xff);CH(14)[0]=0;acknowledge();}
;	---------------------------------
; Function fade_begin
; ---------------------------------
_fade_begin:
	ld	hl, #_audio_ram + 10
	ld	(hl), #0x03
	ld	a, (#(_audio_ram + 2) + 0)
	rlca
	jr	C, 00102$
	ld	hl, #_audio_ram + 206
	ld	(hl), #0x00
00102$:
	ld	a, #0xff
	call	_psg
	ld	hl, #_audio_ram + 462
	ld	(hl), #0x00
	jp	_acknowledge
;src/audio.c:61: static void command(uint8_t cmd){
;	---------------------------------
; Function command
; ---------------------------------
_command:
	add	sp, #-10
	ldhl	sp,	#5
	ld	(hl), a
;src/audio.c:63: if(!(cmd&128u)||cmd>=0xdau){reset_driver();return;}
	push	hl
	bit	7, (hl)
	pop	hl
	jr	Z, 00101$
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0xda
	jr	C, 00102$
00101$:
	call	_reset_driver
	jp	00164$
00102$:
;src/audio.c:64: if(cmd<0xa0u){
	ldhl	sp,	#5
;src/audio.c:65: if(cmd>=0x95u){acknowledge();return;}if(cmd==0x80u)return;
	ld	a,(hl)
	cp	a,#0xa0
	jp	NC,00147$
	sub	a, #0x95
	jr	C, 00105$
	call	_acknowledge
	jp	00164$
00105$:
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x80
	jp	Z, 00164$
;src/audio.c:66: index=cmd-0x81u;flags=rd(0x823fu+index);R[5]=R[2]&127u;R[1]=R[2]=flags;
	ldhl	sp,	#5
	ld	a, (hl+)
	inc	hl
	add	a, #0x7f
	ld	(hl), a
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #0x823f
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_rd
	ldhl	sp,	#8
	ld	(hl), a
	ld	bc, #_audio_ram + 2
	ld	a, (bc)
	res	7, a
	ld	(#(_audio_ram + 5)),a
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(bc), a
	ld	de, #(_audio_ram + 1)
	ld	a, (hl)
	ld	(de), a
;src/audio.c:67: if(R[10]&128u)for(i=0;i<6u;++i)CH(i)[8]=CH(i)[23];
	ld	a, (#(_audio_ram + 10) + 0)
	rlca
	jr	NC, 00110$
	ldhl	sp,	#9
	ld	(hl), #0x00
00153$:
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x05
00385$:
	ldhl	sp,	#3
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00385$
	ld	de, #(_audio_ram + 14)
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #0x0017
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,	#9
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x06
	jr	C, 00153$
00110$:
;src/audio.c:68: clear_control();silence();first=10;
	call	_clear_control
	call	_silence
	ldhl	sp,	#9
	ld	(hl), #0x0a
;src/audio.c:69: if(!(flags&128u)){reset_driver();first=3;}
	push	hl
	dec	hl
	bit	7, (hl)
	pop	hl
	jr	NZ, 00112$
	call	_reset_driver
	ldhl	sp,	#9
	ld	(hl), #0x03
00112$:
;src/audio.c:70: address=rw(0x8253u+index*2u);audio_music=cmd;
	ldhl	sp,	#7
	ld	c, (hl)
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	ld	bc, #0x8253
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_rw
	ldhl	sp,	#7
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(#_audio_music),a
	jp	00148$
00147$:
;src/audio.c:72: address=rw(0x827bu+(cmd-0xa0u)*2u);flags=rd(address+2u);
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl+), a
	ld	(hl), #0x00
;src/audio.c:71: }else if(cmd<0xd0u){
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0xd0
	jp	NC, 00144$
;src/audio.c:72: address=rw(0x827bu+(cmd-0xa0u)*2u);flags=rd(address+2u);
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00a0
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	l, e
	ld	h, a
	add	hl, hl
	ld	bc, #0x827b
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_rw
	ldhl	sp,	#7
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	call	_rd
;src/audio.c:73: if(flags!=0xc0u&&flags!=0xe0u&&flags!=0xa0u){reset_driver();first=3;}
	ld	c, a
	sub	a, #0xe0
	ld	a, #0x01
	jr	Z, 00389$
	xor	a, a
00389$:
	ld	d, a
	ld	a, c
	sub	a, #0xa0
	ld	a, #0x01
	jr	Z, 00391$
	xor	a, a
00391$:
	ld	e, a
	ld	a, c
	sub	a, #0xc0
	jr	Z, 00120$
	bit	0, d
	jr	NZ, 00120$
	bit	0, e
	jr	NZ, 00120$
	call	_reset_driver
	ldhl	sp,	#9
	ld	(hl), #0x03
	jp	00148$
00120$:
;src/audio.c:75: if(flags==0xe0u){psg(0xdf);CH(6)[0]|=4;psg(0xe7);}
	ld	a, d
	or	a, a
	jr	Z, 00114$
	push	de
	ld	a, #0xdf
	call	_psg
	pop	de
	ld	bc, #_audio_ram+206
	ld	a, (bc)
	set	2, a
	ld	(bc), a
	push	de
	ld	a, #0xe7
	call	_psg
	pop	de
00114$:
;src/audio.c:76: first=8;
	ldhl	sp,	#9
	ld	(hl), #0x08
;src/audio.c:77: if(flags==0xa0u){
	ld	a, e
	or	a, a
	jr	Z, 00118$
;src/audio.c:78: if(rd(address+11u)==0xe0u){psg(0xe7);CH(6)[0]|=4;CH(14)[0]|=4;psg(0xdf);}
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	e, l
	ld	d, h
	call	_rd
	sub	a, #0xe0
	jr	NZ, 00116$
	ld	a, #0xe7
	call	_psg
	ld	hl, #_audio_ram + 206
	set	2, (hl)
	ld	hl, #_audio_ram + 462
	set	2, (hl)
	ld	a, #0xdf
	call	_psg
00116$:
;src/audio.c:79: first=7;CH(4)[0]|=4;CH(12)[0]|=4;
	ldhl	sp,	#9
	ld	(hl), #0x07
	ld	hl, #_audio_ram + 142
	set	2, (hl)
	ld	hl, #_audio_ram + 398
	set	2, (hl)
00118$:
;src/audio.c:81: psg(0xff);CH(5)[0]|=4;CH(13)[0]|=4;
	ld	a, #0xff
	call	_psg
	ld	hl, #_audio_ram + 174
	set	2, (hl)
	ld	hl, #_audio_ram + 430
	set	2, (hl)
	jp	00148$
00144$:
;src/audio.c:83: }else if(cmd<0xd5u){address=rw(0x82dbu+(cmd-0xd0u)*2u);first=9;psg(0xff);psg(0xdf);}
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0xd5
	jr	NC, 00141$
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x00d0
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ld	l, e
	ld	h, a
	add	hl, hl
	ld	bc, #0x82db
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_rw
	ldhl	sp,	#7
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#9
	ld	(hl), #0x09
	ld	a, #0xff
	call	_psg
	ld	a, #0xdf
	call	_psg
	jp	00148$
00141$:
;src/audio.c:85: if(cmd==0xd5u){CH(8)[0]=CH(7)[0]=0;for(i=4;i<=6u;++i)CH(i)[0]&=0xfbu;for(i=13;i<=15u;++i)CH(i)[0]&=0xfbu;silence();acknowledge();}
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0xd5
	jr	NZ, 00138$
	ld	hl, #_audio_ram + 238
	ld	(hl), #0x00
	ld	hl, #(_audio_ram + 270)
	ld	(hl), #0x00
	ld	bc, #_audio_ram + 14
	ld	e, #0x04
00155$:
	ld	l, e
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	res	2, (hl)
	inc	e
	ld	a, #0x06
	sub	a, e
	jr	NC, 00155$
	ld	e, #0x0d
00157$:
	ld	l, e
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	res	2, (hl)
	inc	e
	ld	a, #0x0f
	sub	a, e
	jr	NC, 00157$
	call	_silence
	call	_acknowledge
	jp	00164$
00138$:
;src/audio.c:86: else if(cmd==0xd6u){if(CH(9)[0]&128u){CH(9)[0]=0;psg(0xdf);psg(0xff);}acknowledge();}
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0xd6
	jr	NZ, 00135$
	ld	bc, #_audio_ram+302
	ld	a, (bc)
	rlca
	jr	NC, 00127$
	xor	a, a
	ld	(bc), a
	ld	a, #0xdf
	call	_psg
	ld	a, #0xff
	call	_psg
00127$:
	call	_acknowledge
	jp	00164$
00135$:
;src/audio.c:87: else if(cmd==0xd9u)resume();
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0xd9
	jr	NZ, 00132$
	call	_resume
	jp	00164$
00132$:
;src/audio.c:88: else {if(cmd==0xd8u&&R[2]!=0x7fu)R[6]=128;R[11]=R[9]=10;fade_begin();}
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0xd8
	jr	NZ, 00129$
	ld	a, (#(_audio_ram + 2) + 0)
	sub	a, #0x7f
	jr	Z, 00129$
	ld	hl, #_audio_ram + 6
	ld	(hl), #0x80
00129$:
	ld	hl, #_audio_ram + 9
	ld	(hl), #0x0a
	ld	hl, #(_audio_ram + 11)
	ld	(hl), #0x0a
	call	_fade_begin
;src/audio.c:89: return;
	jp	00164$
00148$:
;src/audio.c:91: count=rd(address++);
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl), a
	ld	e, c
	ld	d, b
	call	_rd
	ldhl	sp,	#0
	ld	(hl), a
;src/audio.c:92: if(first+count>15u){audio_fault=2;return;}
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, #0x00
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, #0x0f
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00195$
	ld	hl, #_audio_fault
	ld	(hl), #0x02
	jp	00164$
;src/audio.c:93: for(i=0;i<count;++i){
00195$:
	ldhl	sp,	#6
	ld	(hl), #0x00
00162$:
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#0
	sub	a, (hl)
	jp	NC, 00152$
;src/audio.c:94: uint8_t *c=CH(first+i);for(j=0;j<9u;++j)c[j]=rd(address++);
	ldhl	sp,	#6
	ld	c, (hl)
	ld	b, #0x00
	ldhl	sp,	#1
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #(_audio_ram + 14)
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl+), a
	ld	(hl), #0x00
00159$:
	ldhl	sp,	#9
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#7
	inc	(hl)
	jr	NZ, 00405$
	inc	hl
	inc	(hl)
00405$:
	push	bc
	push	de
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_rd
	pop	de
	pop	bc
	ld	(de), a
	ldhl	sp,	#9
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x09
	jr	C, 00159$
;src/audio.c:95: c[9]=32;c[10]=1;c[11]=c[12]=c[13]=0;volume(c);
	dec	hl
	dec	hl
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ld	hl, #0x0009
	add	hl, bc
	ld	(hl), #0x20
	ld	hl, #0x000a
	add	hl, bc
	ld	(hl), #0x01
	ld	hl, #0x000b
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ld	hl, #0x000c
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, #0x000d
	add	hl, bc
	ld	(hl), #0x00
	xor	a, a
	ld	(de), a
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	e, c
	ld	d, b
	call	_volume
;src/audio.c:93: for(i=0;i<count;++i){
	ldhl	sp,	#6
	inc	(hl)
	jp	00162$
00152$:
;src/audio.c:97: acknowledge();
	call	_acknowledge
00164$:
;src/audio.c:98: }
	add	sp, #10
	ret
;src/audio.c:99: static void tempo(void){
;	---------------------------------
; Function tempo
; ---------------------------------
_tempo:
	dec	sp
;src/audio.c:101: if(!R[1]||--R[1])return;
	ld	a, (#(_audio_ram + 1) + 0)
	or	a, a
	jr	Z, 00108$
	dec	a
	ld	(#(_audio_ram + 1)),a
	or	a, a
	jr	NZ, 00108$
;src/audio.c:102: R[1]=R[2]&127u;first=(R[2]&128u)?0:10;count=(R[2]&128u)?7:5;
	ld	bc, #_audio_ram + 2
	ld	a, (bc)
	res	7, a
	ld	(#(_audio_ram + 1)),a
	ld	a, (bc)
	and	a, #0x80
	ld	e, a
	ld	d, #0x00
	ld	a, d
	or	a, e
	jr	Z, 00110$
	xor	a, a
	jr	00111$
00110$:
	ld	a, #0x0a
00111$:
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, d
	or	a, e
	ld	c, #0x07
	jr	NZ, 00113$
	ld	c, #0x05
00113$:
;src/audio.c:103: for(i=0;i<count;++i)++CH(first+i)[10];
	ld	b, #0x00
00106$:
	ld	a, b
	sub	a, c
	jr	NC, 00108$
	ldhl	sp,	#0
	ld	e, (hl)
	ld	d, #0x00
	ld	l, b
	ld	h, #0x00
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #(_audio_ram + 14)
	add	hl, de
	ld	de, #0x000a
	add	hl, de
	inc	(hl)
	inc	b
	jr	00106$
00108$:
;src/audio.c:104: }
	inc	sp
	ret
;src/audio.c:105: static void fade(void){
;	---------------------------------
; Function fade
; ---------------------------------
_fade:
	add	sp, #-6
;src/audio.c:107: if(!R[10]||--R[11])return;
	ld	a, (#(_audio_ram + 10) + 0)
	or	a, a
	jp	Z, 00130$
	ld	a, (#(_audio_ram + 11) + 0)
	dec	a
	ld	(#(_audio_ram + 11)),a
	or	a, a
	jp	NZ, 00130$
;src/audio.c:108: if(R[10]&128u){
	ld	hl, #(_audio_ram + 10)
	ld	h, (hl)
;src/audio.c:110: for(i=0;i<6u;++i){v=CH(i)[8]-1u;if(!(v&128u)&&v>=CH(i)[23])CH(i)[8]=v;}return;
	ld	bc, #_audio_ram + 14
;src/audio.c:108: if(R[10]&128u){
	add	hl, hl
	jr	NC, 00111$
;src/audio.c:109: R[11]=10;if(++R[10]==0x8bu){R[10]=0;CH(6)[0]&=0xfb;return;}
	ld	hl, #(_audio_ram + 11)
	ld	a, #0x0a
	ld	(hl-), a
	ld	a, (#(_audio_ram + 10) + 0)
	inc	a
	ld	(hl), a
	sub	a, #0x8b
	jr	NZ, 00141$
	ld	(hl), a
	ld	hl, #_audio_ram + 206
	res	2, (hl)
	ld	a, (hl)
	jp	00130$
;src/audio.c:110: for(i=0;i<6u;++i){v=CH(i)[8]-1u;if(!(v&128u)&&v>=CH(i)[23])CH(i)[8]=v;}return;
00141$:
	ldhl	sp,	#5
	ld	(hl), #0x00
00125$:
	ldhl	sp,	#5
	ld	e, (hl)
	ld	d, #0x00
	ld	a, e
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	l, a
	ld	h, d
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #0x0008
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
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	dec	a
	ld	(hl), a
	push	hl
	bit	7, (hl)
	pop	hl
	jr	NZ, 00126$
	pop	de
	push	de
	ld	hl, #0x0017
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, e
	jr	C, 00126$
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl)
	ld	(de), a
00126$:
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x06
	jr	C, 00125$
	jp	00130$
00111$:
;src/audio.c:112: R[11]=R[9];
	ld	a, (#(_audio_ram + 9) + 0)
	ld	hl, #(_audio_ram + 11)
;src/audio.c:113: if(++R[10]==12u){R[10]=0;if(R[2]==0x7fu)command(0x85);else if(!(R[2]&128u))reset_driver();else if(R[6])resume();return;}
	ld	(hl-), a
	ld	a, (#(_audio_ram + 10) + 0)
	inc	a
	ld	(hl), a
	ld	hl, #_audio_ram + 2
	sub	a, #0x0c
	jr	NZ, 00121$
	push	hl
	ld	hl, #(_audio_ram + 10)
	ld	(hl), #0x00
	pop	hl
	ld	a, (hl)
	cp	a, #0x7f
	jr	NZ, 00118$
	ld	a, #0x85
	call	_command
	jr	00130$
00118$:
	rlca
	jr	C, 00115$
	call	_reset_driver
	jr	00130$
00115$:
	ld	a, (#(_audio_ram + 6) + 0)
	or	a, a
	jr	Z, 00130$
	call	_resume
	jr	00130$
00121$:
;src/audio.c:114: first=(R[2]&128u)?10:0;count=(R[2]&128u)?4:6;
	ld	a, (hl)
	and	a, #0x80
	ld	e, a
	ld	d, #0x00
	ld	a, d
	or	a, e
	ld	a, #0x0a
	jr	NZ, 00133$
	xor	a, a
00133$:
	ldhl	sp,	#4
	ld	(hl), a
	ld	a, d
	or	a, e
	ld	a, #0x04
	jr	NZ, 00135$
	ld	a, #0x06
00135$:
	ldhl	sp,	#5
	ld	(hl), a
;src/audio.c:115: for(i=0;i<count;++i){v=CH(first+i)[8]+1u;if(v!=16u)CH(first+i)[8]=v;}
	ld	c, #0x00
00128$:
	ld	a, c
	ldhl	sp,	#5
	sub	a, (hl)
	jr	NC, 00130$
	dec	hl
	ld	e, (hl)
	ld	d, #0x00
	ld	l, c
	ld	h, #0x00
	add	hl, de
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #(_audio_ram + 14)
	add	hl, de
	ld	de, #0x8
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	inc	a
	cp	a, #0x10
	jr	Z, 00129$
	ld	(de), a
00129$:
	inc	c
	jr	00128$
00130$:
;src/audio.c:116: }
	add	sp, #6
	ret
;src/audio.c:117: static void priority(void){
;	---------------------------------
; Function priority
; ---------------------------------
_priority:
;src/audio.c:118: if(!(CH(9)[0]&128u))return;
	ld	hl, #(_audio_ram + 302)
	ld	c, (hl)
	bit	7, c
	ret	Z
;src/audio.c:119: if(CH(8)[0]&128u){CH(9)[0]|=4;return;}
	ld	a, (#(_audio_ram + 270) + 0)
	rlca
	jr	NC, 00104$
	set	2, c
	ld	hl, #(_audio_ram + 302)
	ld	(hl), c
	ret
00104$:
;src/audio.c:120: if((CH(9)[0]&64u)&&CH(9)[1]==0xe0u)CH(3)[0]|=4;
	bit	6, c
	jr	Z, 00106$
	ld	a, (#(_audio_ram + 303) + 0)
	sub	a, #0xe0
	jr	NZ, 00106$
	ld	hl, #_audio_ram + 110
	set	2, (hl)
00106$:
;src/audio.c:121: CH(5)[0]|=4;
	ld	hl, #_audio_ram + 174
	set	2, (hl)
;src/audio.c:122: }
	ret
;src/audio.c:123: static void finish_channel(uint8_t *c){
;	---------------------------------
; Function finish_channel
; ---------------------------------
_finish_channel:
;src/audio.c:124: CH(9)[0]&=0xfb;R[8]=0;c[0]=0;psg(c[1]+31u);psg(0xe5);
	ld	hl, #_audio_ram + 302
	res	2, (hl)
	ld	hl, #_audio_ram + 8
	ld	(hl), #0x00
	xor	a, a
	ld	(de), a
	inc	de
	ld	a, (de)
	add	a, #0x1f
	call	_psg
	ld	a, #0xe5
	call	_psg
;src/audio.c:125: if(CH(4)[0]&128u){tone(CH(4)[1],cw(CH(4),14));CH(4)[0]&=0xfb;}
	ld	a, (#(_audio_ram + 142) + 0)
	rlca
	jr	NC, 00102$
	ld	a, #0x0e
	ld	de, #(_audio_ram + 142)
	call	_cw
	ld	a, (#(_audio_ram + 143) + 0)
	ld	e, c
	ld	d, b
	call	_tone
	ld	a, (#(_audio_ram + 142) + 0)
	res	2, a
	ld	(#(_audio_ram + 142)),a
00102$:
;src/audio.c:126: CH(12)[0]&=0xfb;CH(14)[0]&=0xfb;CH(6)[0]&=0xfb;
	ld	hl, #_audio_ram + 398
	res	2, (hl)
	ld	hl, #_audio_ram + 462
	res	2, (hl)
	ld	hl, #_audio_ram + 206
	res	2, (hl)
;src/audio.c:127: if(CH(5)[0]&128u){tone(CH(5)[1],cw(CH(5),14));CH(5)[0]&=0xfb;}
	ld	a, (#(_audio_ram + 174) + 0)
	rlca
	jr	NC, 00104$
	ld	a, #0x0e
	ld	de, #(_audio_ram + 174)
	call	_cw
	ld	a, (#(_audio_ram + 175) + 0)
	ld	e, c
	ld	d, b
	call	_tone
	ld	a, (#(_audio_ram + 174) + 0)
	res	2, a
	ld	(#(_audio_ram + 174)),a
00104$:
;src/audio.c:128: CH(13)[0]&=0xfb;
	ld	hl, #_audio_ram + 430
	res	2, (hl)
	ld	a, (hl)
;src/audio.c:129: }
	ret
;src/audio.c:131: static uint8_t score_command(uint8_t *c,uint8_t op,uint16_t *pointer){
;	---------------------------------
; Function score_command
; ---------------------------------
_score_command:
	add	sp, #-7
	ld	c, e
	ld	b, d
	ldhl	sp,	#4
	ld	(hl), a
;src/audio.c:132: uint16_t p=*pointer,target;uint8_t v=rd(p),slot;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#5
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	push	bc
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_rd
	ldhl	sp,	#5
	ld	(hl), a
	pop	bc
;src/audio.c:133: switch(op){
	ldhl	sp,	#4
	ld	a,(hl)
	cp	a,#0xee
	jp	C,00152$
	add	a, #0x12
	ld	e, a
	ld	d, #0x00
	ld	hl, #00254$
	add	hl, de
	add	hl, de
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	jp	(hl)
00254$:
	.dw	00101$
	.dw	00104$
	.dw	00108$
	.dw	00112$
	.dw	00113$
	.dw	00114$
	.dw	00118$
	.dw	00119$
	.dw	00122$
	.dw	00123$
	.dw	00131$
	.dw	00135$
	.dw	00138$
	.dw	00139$
	.dw	00140$
	.dw	00148$
	.dw	00104$
	.dw	00104$
;src/audio.c:134: case 0xee:c[2]+=v;break;
00101$:
	inc	bc
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#3
	add	a, (hl)
	ld	(bc), a
	jp	00153$
;src/audio.c:135: case 0xef:case 0xfe:case 0xff:
00104$:
;src/audio.c:136: if(R[10]&128u)c[23]=(c[23]+v)&15u;else {c[8]=(c[8]+v)&15u;volume(c);}break;
	ld	a, (#(_audio_ram + 10) + 0)
	rlca
	jr	NC, 00106$
	ld	hl, #0x0017
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#3
	add	a, (hl)
	and	a, #0x0f
	ld	(bc), a
	jp	00153$
00106$:
	ld	hl, #0x0008
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#3
	add	a, (hl)
	and	a, #0x0f
	ld	(de), a
	ld	e, c
	ld	d, b
	call	_volume
	jp	00153$
;src/audio.c:137: case 0xf0:if(v==1)c[7]|=3;else c[7]&=0xfc;break;
00108$:
	ldhl	sp,	#3
	ld	a, (hl)
	dec	a
	jr	NZ, 00110$
	ld	hl, #0x0007
	add	hl, bc
	ld	a, (hl)
	or	a, #0x03
	ld	(hl), a
	jp	00153$
00110$:
	ld	hl, #0x0007
	add	hl, bc
	ld	a, (hl)
	and	a, #0xfc
	ld	(hl), a
	jp	00153$
;src/audio.c:138: case 0xf1:R[9]=R[11]=v;fade_begin();break;
00112$:
	ld	de, #(_audio_ram + 11)
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(de), a
	ld	de, #(_audio_ram + 9)
	ld	a, (hl)
	ld	(de), a
	call	_fade_begin
	jp	00153$
;src/audio.c:139: case 0xf2:finish_channel(c);return 0;
00113$:
	ld	e, c
	ld	d, b
	call	_finish_channel
	xor	a, a
	jp	00154$
;src/audio.c:140: case 0xf3:psg(v|0xe0u);if((v&3u)==3u)c[0]&=0xbf;else c[0]|=64;break;
00114$:
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, #0xe0
	push	bc
	call	_psg
	pop	bc
	ldhl	sp,	#3
	ld	a, (hl)
	and	a, #0x03
	sub	a, #0x03
	jr	NZ, 00116$
	ld	a, (bc)
	res	6, a
	ld	(bc), a
	jp	00153$
00116$:
	ld	a, (bc)
	set	6, a
	ld	(bc), a
	jp	00153$
;src/audio.c:141: case 0xf4:c[6]=v;break;
00118$:
	ld	hl, #0x0006
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(bc), a
	jp	00153$
;src/audio.c:142: case 0xf5:if(v!=0x80u)c[7]=v;++p;break;
00119$:
	ldhl	sp,	#3
	ld	a, (hl)
	sub	a, #0x80
	jr	Z, 00121$
	ld	hl, #0x0007
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(bc), a
00121$:
	ldhl	sp,	#5
	inc	(hl)
	jp	NZ, 00153$
	inc	hl
	inc	(hl)
	jp	00153$
;src/audio.c:143: case 0xf6:p=rw(p)-1u;break;
00122$:
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_rw
	dec	bc
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	jp	00153$
;src/audio.c:144: case 0xf7:
00123$:
;src/audio.c:145: slot=24u+v;if(slot>=32u){audio_fault=3;return 0;}
	ldhl	sp,	#3
	ld	a, (hl)
	add	a, #0x18
	cp	a, #0x20
	jr	C, 00125$
	ld	hl, #_audio_fault
	ld	(hl), #0x03
	xor	a, a
	jp	00154$
00125$:
;src/audio.c:146: ++p;if(!c[slot])c[slot]=rd(p);++p;if(--c[slot])p=rw(p)-1u;else ++p;break;
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	de
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	NZ, 00127$
	push	hl
	push	de
	call	_rd
	pop	de
	pop	hl
	ld	(hl), a
00127$:
	inc	de
	dec	(hl)
	jr	Z, 00129$
	call	_rw
	dec	bc
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	jp	00153$
00129$:
	inc	de
	ldhl	sp,	#5
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	jp	00153$
;src/audio.c:147: case 0xf8:
00131$:
;src/audio.c:148: target=rw(p);++p;--c[9];slot=c[9];--c[9];
	push	bc
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_rw
	ldhl	sp,	#2
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	bc
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ld	hl, #0x0009
	add	hl, bc
	dec	(hl)
	ld	a, (hl)
	ld	e, a
	dec	a
	ld	(hl), a
;src/audio.c:149: if(!slot||slot>=32u){audio_fault=4;return 0;}c[slot]=(uint8_t)(p>>8);c[slot-1]=(uint8_t)p;p=target-1u;break;
	ld	a, e
	or	a, a
	jr	Z, 00132$
	ld	a, e
	sub	a, #0x20
	jr	C, 00133$
00132$:
	ld	hl, #_audio_fault
	ld	(hl), #0x04
	xor	a, a
	jp	00154$
00133$:
	ld	l, e
	ld	h, #0x00
	add	hl, bc
	push	hl
	ldhl	sp,	#5
	ld	a, (hl)
	pop	hl
	ld	(hl), a
	xor	a, a
	ld	l, e
	ld	h, a
	dec	hl
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(bc), a
	pop	bc
	push	bc
	dec	bc
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	jp	00153$
;src/audio.c:150: case 0xf9:if(c[9]>30u){audio_fault=5;return 0;}p=cw(c,c[9]);c[9]+=2;break;
00135$:
	ld	hl, #0x0009
	add	hl, bc
	ld	a, (hl)
	cp	a, #0x1f
	jr	C, 00137$
	ld	hl, #_audio_fault
	ld	(hl), #0x05
	xor	a, a
	jp	00154$
00137$:
	push	bc
	ld	e, c
	ld	d, b
	call	_cw
	ldhl	sp,	#7
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	bc
	ld	hl, #0x0009
	add	hl, bc
	ld	a, (hl)
	add	a, #0x02
	ld	(hl), a
	jr	00153$
;src/audio.c:151: case 0xfa:c[2]=v;break;
00138$:
	inc	bc
	inc	bc
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(bc), a
	jr	00153$
;src/audio.c:152: case 0xfb:c[5]+=v;++p;break;
00139$:
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#3
	add	a, (hl)
	inc	hl
	inc	hl
	ld	(bc), a
	inc	(hl)
	jr	NZ, 00153$
	inc	hl
	inc	(hl)
	jr	00153$
;src/audio.c:153: case 0xfc:if(v==1){c[0]|=32;if(c[8])c[8]-=2;}else {c[0]&=0xdf;if(c[8])c[8]+=2;}break;
00140$:
	ldhl	sp,	#3
	ld	a, (hl)
	dec	a
	jr	NZ, 00146$
	ld	a, (bc)
	set	5, a
	ld	(bc), a
	ld	hl, #0x0008
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00153$
	dec	a
	dec	a
	ld	(hl), a
	jr	00153$
00146$:
	ld	a, (bc)
	res	5, a
	ld	(bc), a
	ld	hl, #0x0008
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00153$
	add	a, #0x02
	ld	(hl), a
	jr	00153$
;src/audio.c:154: case 0xfd:if(v==1)c[0]|=8;else c[0]&=0xf7;break;
00148$:
	ldhl	sp,	#3
	ld	a, (hl)
	dec	a
	jr	NZ, 00150$
	ld	a, (bc)
	set	3, a
	ld	(bc), a
	jr	00153$
00150$:
	ld	a, (bc)
	res	3, a
	ld	(bc), a
	jr	00153$
;src/audio.c:155: default:audio_fault=6;return 0;
00152$:
	ld	hl, #_audio_fault
	ld	(hl), #0x06
	xor	a, a
	jr	00154$
;src/audio.c:156: }
00153$:
;src/audio.c:157: *pointer=p+1u;return 1;
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	a, #0x01
00154$:
;src/audio.c:158: }
	add	sp, #7
	pop	hl
	pop	bc
	jp	(hl)
;src/audio.c:159: static void new_duration(uint8_t *c,uint8_t value,uint16_t pointer){
;	---------------------------------
; Function new_duration
; ---------------------------------
_new_duration:
	add	sp, #-7
	ld	c, e
	ld	b, d
	ldhl	sp,	#6
	ld	(hl), a
;src/audio.c:161: c[10]=c[21]=(uint8_t)(value*c[2]);
	ld	hl, #0x000a
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ld	hl, #0x0015
	add	hl, bc
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	a, (de)
	push	hl
	push	bc
	ld	e, a
	push	hl
	ldhl	sp,	#12
	ld	a, (hl)
	pop	hl
	call	__muluchar
	ld	a, c
	pop	bc
	pop	hl
	ld	(hl), a
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/audio.c:162: c[12]=c[13]=c[11]=c[19]=c[20]=0;sw(c,3,pointer);
	ld	hl, #0x000c
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	hl, #0x000d
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ld	hl, #0x000b
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ld	hl, #0x0013
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, #0x0014
	add	hl, bc
	ld	(hl), #0x00
	xor	a, a
	ld	(de), a
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	pop	hl
	ld	(hl), #0x00
	push	hl
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, #0x03
	ld	e, c
	ld	d, b
	call	_sw
;src/audio.c:163: }
	add	sp, #7
	pop	hl
	pop	af
	jp	(hl)
;src/audio.c:164: static void drum(uint8_t *c,uint8_t v){
;	---------------------------------
; Function drum
; ---------------------------------
_drum:
	dec	sp
	dec	sp
	ld	c, e
	ld	b, d
	ld	e, a
;src/audio.c:169: else {c[7]=0;psg(0xff);return;}
	ld	hl, #0x0007
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
;src/audio.c:166: if(v&8u){instrument=2;attenuation=4;}
	bit	3, e
	jr	Z, 00108$
	ld	a, #0x02
	ld	l, #0x04
	jr	00109$
00108$:
;src/audio.c:167: else if(v&34u){instrument=(v&1u)?4:3;attenuation=5;}
	ld	a, e
	and	a, #0x22
	jr	Z, 00105$
	bit	0, e
	ld	a, #0x04
	jr	NZ, 00115$
	ld	a, #0x03
00115$:
	ld	l, #0x05
	jr	00109$
00105$:
;src/audio.c:168: else if(v&5u){instrument=1;attenuation=6;}
	ld	a, e
	and	a, #0x05
	jr	Z, 00102$
	ld	a, #0x01
	ld	l, #0x06
	jr	00109$
00102$:
;src/audio.c:169: else {c[7]=0;psg(0xff);return;}
	pop	hl
	ld	(hl), #0x00
	push	hl
	ld	a, #0xff
	inc	sp
	inc	sp
	jp	_psg
	jr	00112$
00109$:
;src/audio.c:170: if(v&4u)attenuation-=2;c[7]=instrument;c[8]=attenuation;
	bit	2, e
	jr	Z, 00111$
	dec	l
	dec	l
00111$:
	push	hl
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	pop	hl
	ld	a, c
	add	a, #0x08
	ld	c, a
	jr	NC, 00156$
	inc	b
00156$:
	ld	a, l
	ld	(bc), a
00112$:
;src/audio.c:171: }
	inc	sp
	inc	sp
	ret
;src/audio.c:172: static uint8_t next_note(uint8_t *c,uint8_t rhythm){
;	---------------------------------
; Function next_note
; ---------------------------------
_next_note:
	add	sp, #-21
	ldhl	sp,	#17
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
;src/audio.c:173: uint16_t p=cw(c,3),frequency;uint8_t v,n,guard=0;
	ld	(hl+), a
	ld	a, #0x03
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_cw
	ldhl	sp,	#19
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	e, #0x00
;src/audio.c:174: while(++guard){
00126$:
	ld	c, e
	inc	c
	ld	a,c
	ld	e,a
	or	a, a
	jp	Z, 00128$
;src/audio.c:175: v=rd(p++);
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl), a
	push	de
	ld	e, c
	ld	d, b
	call	_rd
	ld	c, a
	pop	de
;src/audio.c:176: if(v>=0xe0u){if(!score_command(c,v,&p))return 0;continue;}
	ld	a, c
	sub	a, #0xe0
	jr	C, 00104$
	push	de
	ld	hl, #21
	add	hl, sp
	push	hl
	ld	a, c
	ldhl	sp,	#21
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_score_command
	pop	de
	or	a,a
	jr	NZ, 00126$
	jp	00129$
00104$:
;src/audio.c:178: if(v&128u){drum(c,v);v=rd(p++);if(v&128u){--p;v=c[21];c[12]=c[13]=c[11]=c[19]=c[20]=0;c[10]=v;sw(c,3,p);return 1;}}
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0015
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#17
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
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl), a
;src/audio.c:177: if(rhythm){
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jp	Z, 00110$
;src/audio.c:178: if(v&128u){drum(c,v);v=rd(p++);if(v&128u){--p;v=c[21];c[12]=c[13]=c[11]=c[19]=c[20]=0;c[10]=v;sw(c,3,p);return 1;}}
	bit	7, c
	jr	Z, 00108$
	ld	a, c
	ldhl	sp,	#17
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_drum
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl), a
	ld	e, c
	ld	d, b
	call	_rd
	ld	c, a
	bit	7, c
	jr	Z, 00108$
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	dec	de
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), #0x00
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), #0x00
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), #0x00
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), #0x00
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), #0x00
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, #0x03
	ldhl	sp,	#19
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_sw
	ld	a, #0x01
	jp	00129$
00108$:
;src/audio.c:179: new_duration(c,v,p);return 1;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, c
	ldhl	sp,	#19
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_new_duration
	ld	a, #0x01
	jp	00129$
00110$:
;src/audio.c:181: if(c[0]&8u){frequency=((uint16_t)v<<8)|rd(p++);frequency+=(int8_t)c[5];sw(c,14,frequency);}
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	e, l
	ld	d, h
	bit	3, b
	jr	Z, 00117$
	ldhl	sp,	#15
	ld	a, c
	ld	(hl-), a
	ld	(hl), #0x00
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl), a
	push	de
	ld	e, c
	ld	d, b
	call	_rd
	pop	de
	ld	c, a
	ldhl	sp,	#15
	ld	b, (hl)
	ld	a, (de)
	ld	l, a
	rlca
	sbc	a, a
	ld	h, a
	add	hl, bc
	push	hl
	ld	a, #0x0e
	ldhl	sp,	#19
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_sw
	jr	00118$
00117$:
;src/audio.c:182: else if(v>=128u){n=v-128u;if(n)n+=c[5];sw(c,14,rw(0x8874u+(uint16_t)n*2u));}
	ld	a,c
	cp	a,#0x80
	jr	C, 00114$
	add	a, #0x80
	ld	l, a
	or	a, a
	jr	Z, 00112$
	ld	a, (de)
	add	a, l
	ld	l, a
00112$:
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	bc, #0x8874
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_rw
	push	bc
	ld	a, #0x0e
	ldhl	sp,	#19
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_sw
	jr	00118$
00114$:
;src/audio.c:183: else {new_duration(c,v,p);return 1;}
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, c
	ldhl	sp,	#19
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_new_duration
	ld	a, #0x01
	jp	00129$
00118$:
;src/audio.c:184: if(c[0]&32u){c[18]=c[17]=rd(p++);if(!(c[0]&8u))c[17]=rd(p++);v=rd(p++);}
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	bit	5, a
	jp	Z, 00124$
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0012
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0011
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	l, e
	ld	h, d
	inc	hl
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl), a
	push	bc
	call	_rd
	pop	bc
	ld	(bc), a
	ldhl	sp,	#14
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	bit	3, a
	jr	NZ, 00120$
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	l, e
	ld	h, d
	inc	hl
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl), a
	push	bc
	call	_rd
	pop	bc
	ld	(bc), a
00120$:
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl), a
	ld	e, c
	ld	d, b
	call	_rd
	ld	c, a
	jr	00125$
00124$:
;src/audio.c:185: else {v=rd(p);if(v&128u){c[10]=c[21];c[12]=c[13]=c[11]=c[19]=c[20]=0;sw(c,3,p);return 1;}++p;}
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_rd
	ld	c, a
	bit	7, c
	jr	Z, 00122$
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
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
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, #0x03
	ldhl	sp,	#19
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_sw
	ld	a, #0x01
	jr	00129$
00122$:
	ldhl	sp,	#19
	inc	(hl)
	jr	NZ, 00229$
	inc	hl
	inc	(hl)
00229$:
00125$:
;src/audio.c:186: new_duration(c,v,p);return 1;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, c
	ldhl	sp,	#19
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_new_duration
	ld	a, #0x01
	jr	00129$
00128$:
;src/audio.c:188: audio_fault=7;return 0;
	ld	hl, #_audio_fault
	ld	(hl), #0x07
	xor	a, a
00129$:
;src/audio.c:189: }
	add	sp, #21
	ret
;src/audio.c:190: static uint8_t envelope(uint8_t *c,uint8_t *value){
;	---------------------------------
; Function envelope
; ---------------------------------
_envelope:
	add	sp, #-12
	ldhl	sp,	#10
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ldhl	sp,	#8
	ld	a, c
	ld	(hl+), a
;src/audio.c:191: uint16_t base=rw(0xa877u+(uint16_t)(c[7]-1u)*2u);uint8_t v,guard=0;
	ld	a, b
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	l, a
	xor	a, a
	ld	h, a
	dec	hl
	add	hl, hl
	ld	bc, #0xa877
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_rw
	pop	hl
	push	bc
	ldhl	sp,	#2
	ld	(hl), #0x00
;src/audio.c:192: while(++guard){v=rd(base+c[12]);
00107$:
	ldhl	sp,	#2
	ld	c, (hl)
	inc	c
	ld	a,c
	ld	(hl),a
	or	a, a
	jp	Z, 00109$
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ld	b, #0x00
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, bc
	ld	e, l
	ld	d, h
	call	_rd
	ldhl	sp,	#7
	ld	(hl), a
;src/audio.c:193: if(!(v&128u)){++c[12];v+=c[8];*value=(v&16u)?15:v;return 1;}
	push	hl
	ldhl	sp,	#9
	bit	7, (hl)
	pop	hl
	jr	NZ, 00102$
	ldhl	sp,#3
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
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#7
	add	a, (hl)
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	push	hl
	inc	hl
	bit	4, (hl)
	pop	hl
	jr	Z, 00112$
	ldhl	sp,	#7
	ld	(hl), #0x0f
	jr	00113$
00112$:
	ldhl	sp,	#7
00113$:
	ldhl	sp,	#7
	ld	a, (hl-)
	dec	hl
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ld	a, #0x01
	jr	00110$
00102$:
;src/audio.c:194: if(v==0x82u){c[19]=31;psg(c[1]+31u);return 0;}
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x82
	jr	NZ, 00104$
	ld	a, #0x1f
	ld	(bc), a
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ld	a, (bc)
	add	a, #0x1f
	call	_psg
	xor	a, a
	jr	00110$
00104$:
;src/audio.c:195: if(v==0x81u){c[19]=255;return 0;}
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x81
	jr	NZ, 00106$
	ld	a, #0xff
	ld	(bc), a
	xor	a, a
	jr	00110$
00106$:
;src/audio.c:196: c[12]=(v==0x80u)?0:rd(base+c[12]+1u);
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x80
	jr	NZ, 00114$
	xor	a, a
	jr	00115$
00114$:
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	d, #0x00
	ld	e, a
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	ld	e, l
	ld	d, h
	push	bc
	call	_rd
	pop	bc
00115$:
	ld	(bc), a
	jp	00107$
00109$:
;src/audio.c:198: audio_fault=8;return 0;
	ld	hl, #_audio_fault
	ld	(hl), #0x08
	xor	a, a
00110$:
;src/audio.c:199: }
	add	sp, #12
	ret
;src/audio.c:200: static uint8_t modulation(uint8_t *c,uint16_t *frequency){
;	---------------------------------
; Function modulation
; ---------------------------------
_modulation:
	add	sp, #-11
	ldhl	sp,	#9
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/audio.c:201: uint16_t base=rw(0xa916u+(uint16_t)(c[6]-1u)*2u);uint8_t v,guard=0;
	ld	hl, #0x0006
	add	hl, de
	ld	l, (hl)
	xor	a, a
	ld	h, a
	dec	hl
	add	hl, hl
	ld	bc, #0xa916
	add	hl, bc
	push	de
	ld	e, l
	ld	d, h
	call	_rw
	ldhl	sp,	#2
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	pop	de
	ldhl	sp,	#2
	ld	(hl), #0x00
;src/audio.c:202: while(++guard){v=rd(base+c[13]);
00109$:
	ldhl	sp,	#2
	ld	c, (hl)
	inc	c
	ld	a,c
	ld	(hl),a
	or	a, a
	jp	Z, 00111$
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	af
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl+), a
	pop	af
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	push	bc
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_rd
	ldhl	sp,	#12
	ld	(hl), a
	pop	de
	pop	bc
;src/audio.c:203: if(!(v&128u)){++c[13];c[16]=v;*frequency+=v;return 1;}
	push	hl
	ldhl	sp,	#10
	bit	7, (hl)
	pop	hl
	jr	NZ, 00102$
	ld	a, (bc)
	inc	a
	ld	(bc), a
	ld	hl, #0x0010
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	l, (hl)
	ld	b, a
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	a, #0x01
	jr	00112$
00102$:
;src/audio.c:204: if(v==0x83u)c[13]=rd(base+c[13]+1u);
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x83
	jr	NZ, 00107$
	ld	a, (bc)
	ldhl	sp,	#5
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	push	bc
	push	de
	ld	e, l
	ld	d, h
	call	_rd
	pop	de
	pop	bc
	ld	(bc), a
	jp	00109$
00107$:
;src/audio.c:205: else if(v==0x80u)c[13]=0;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x80
	jr	NZ, 00104$
	xor	a, a
	ld	(bc), a
	jp	00109$
00104$:
;src/audio.c:206: else {c[20]=255;return 0;}
	ld	hl, #0x0014
	add	hl, de
	ld	(hl), #0xff
	xor	a, a
	jr	00112$
00111$:
;src/audio.c:208: audio_fault=9;return 0;
	ld	hl, #_audio_fault
	ld	(hl), #0x09
	xor	a, a
00112$:
;src/audio.c:209: }
	add	sp, #11
	ret
;src/audio.c:210: static void update_channel(uint8_t *c,uint8_t rhythm){
;	---------------------------------
; Function update_channel
; ---------------------------------
_update_channel:
	add	sp, #-10
	ldhl	sp,	#8
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
;src/audio.c:212: ++c[11];delta=c[10]-c[11];
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	inc	a
	ld	c, a
	ld	(de), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
;src/audio.c:213: if(!delta){if(!next_note(c,rhythm))return;delta=128;}
	sub	a, c
	ld	c, a
	jr	NZ, 00104$
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_next_note
	or	a, a
	jp	Z, 00135$
	ld	c, #0x80
00104$:
;src/audio.c:215: if((c[0]&4u)||(c[19]&16u)||((uint8_t)(c[7]-1u)&128u))return;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0013
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl), a
;src/audio.c:214: if(rhythm){
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00112$
;src/audio.c:215: if((c[0]&4u)||(c[19]&16u)||((uint8_t)(c[7]-1u)&128u))return;
	inc	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	bit	2, a
	jp	NZ, 00135$
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	bit	4, a
	jp	NZ, 00135$
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	dec	a
	rlca
	jp	C, 00135$
;src/audio.c:216: if(envelope(c,&v))psg(v|0xf0u);return;
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_envelope
	or	a, a
	jp	Z, 00135$
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, #0xf0
	call	_psg
	jp	00135$
00112$:
;src/audio.c:218: R[12]=delta;
	ld	hl, #(_audio_ram + 12)
;src/audio.c:219: if(delta!=128u&&(c[0]&32u)){R[12]=128;sw(c,14,cw(c,14)+(int8_t)c[18]);}
	ld	a,c
	ld	(hl),a
	sub	a, #0x80
	jr	Z, 00114$
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	bit	5, a
	jr	Z, 00114$
	ld	hl, #(_audio_ram + 12)
	ld	(hl), #0x80
	ld	a, #0x0e
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_cw
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0012
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	l, a
	rlca
	sbc	a, a
	ld	h, a
	add	hl, bc
	push	hl
	ld	a, #0x0e
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_sw
00114$:
;src/audio.c:220: if((c[0]&4u)||c[19]==31u)return;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	bit	2, a
	jp	NZ, 00135$
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	sub	a, #0x1f
	jp	Z, 00135$
;src/audio.c:222: if(!envelope(c,&v))return;psg((uint8_t)((v|c[1])+16u));
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl), a
;src/audio.c:221: if(c[19]!=255u&&!((uint8_t)(c[7]-1u)&128u)){
	inc	c
	jr	Z, 00122$
	dec	hl
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	dec	a
	rlca
	jr	C, 00122$
;src/audio.c:222: if(!envelope(c,&v))return;psg((uint8_t)((v|c[1])+16u));
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_envelope
	or	a, a
	jp	Z, 00135$
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, c
	add	a, #0x10
	call	_psg
00122$:
;src/audio.c:224: if(!(R[12]&128u)&&(c[20]&128u))return;
	ld	a, (#(_audio_ram + 12) + 0)
	and	a, #0x80
	ld	c, a
	ld	b, #0x00
	ld	a, b
	or	a, c
	jr	NZ, 00125$
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0014
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	rlca
	jr	C, 00135$
00125$:
;src/audio.c:225: if(!(R[12]&128u)&&((uint8_t)(c[6]-1u)&128u))return;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, b
	or	a, c
	jr	NZ, 00128$
	ld	a, (de)
	dec	a
	rlca
	jr	C, 00135$
00128$:
;src/audio.c:226: frequency=cw(c,14);
	push	de
	ld	a, #0x0e
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_cw
	pop	de
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/audio.c:227: if(!((uint8_t)(c[6]-1u)&128u)&&!modulation(c,&frequency))return;
	ld	a, (de)
	dec	a
	rlca
	jr	C, 00131$
	ldhl	sp,	#1
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_modulation
	or	a, a
	jr	Z, 00135$
00131$:
;src/audio.c:228: if(!(c[0]&64u))tone(c[1]==0xe0u?0xc0u:c[1],frequency);
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	bit	6, a
	jr	NZ, 00135$
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	cp	a, #0xe0
	jr	NZ, 00137$
	ld	a, #0xc0
00137$:
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_tone
00135$:
;src/audio.c:229: }
	add	sp, #10
	ret
;src/audio.c:233: uint16_t audio_gb_period(uint16_t divider,uint8_t wave) AUDIO_BANKED {
;	---------------------------------
; Function audio_gb_period
; ---------------------------------
	b_audio_gb_period	= 15
_audio_gb_period::
;src/audio.c:234: return audio_apu_period[wave?1:0][divider&1023u];
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00104$
	xor	a, a
00104$:
	add	a, a
	add	a, a
	add	a, a
	ld	e, #<(_audio_apu_period)
	add	a, #>(_audio_apu_period)
	ld	d, a
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	and	a, #0x03
	ld	l, c
	ld	h, a
	add	hl, hl
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/audio.c:235: }
	ret
;src/audio.c:236: uint8_t audio_gb_volume(uint8_t attenuation) AUDIO_BANKED {
;	---------------------------------
; Function audio_gb_volume
; ---------------------------------
	b_audio_gb_volume	= 15
_audio_gb_volume::
;src/audio.c:238: return levels[attenuation&15u];
	ldhl	sp,	#6
	ld	a, (hl)
	and	a, #0x0f
	ld	l, a
	ld	h, #0x00
	ld	de, #_audio_gb_volume_levels_10000_378
	add	hl, de
	ld	a, (hl)
;src/audio.c:239: }
	ret
_audio_gb_volume_levels_10000_378:
	.db #0x0f	; 15
	.db #0x0c	; 12
	.db #0x09	; 9
	.db #0x08	; 8
	.db #0x06	; 6
	.db #0x05	; 5
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x00	; 0
;src/audio.c:240: uint8_t audio_gb_noise(uint8_t control,uint16_t tone2) AUDIO_BANKED {
;	---------------------------------
; Function audio_gb_noise
; ---------------------------------
	b_audio_gb_noise	= 15
_audio_gb_noise::
	dec	sp
;src/audio.c:241: uint8_t period=control&3u;
	ldhl	sp,	#7
	ld	c, (hl)
	ld	a, c
	and	a, #0x03
	ldhl	sp,	#0
;src/audio.c:242: return ((period==3u)?audio_apu_noise[tone2&1023u]:audio_apu_fixed_noise[period])|((control&4u)?0u:8u);
	ld	(hl), a
	sub	a, #0x03
	jr	NZ, 00103$
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl)
	and	a, #0x03
	ld	d, a
	ld	hl, #_audio_apu_noise
	add	hl, de
	ld	e, (hl)
	jr	00104$
00103$:
	ld	de, #_audio_apu_fixed_noise
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
00104$:
	bit	2, c
	jr	Z, 00105$
	xor	a, a
	jr	00106$
00105$:
	ld	a, #0x08
00106$:
	or	a, e
;src/audio.c:243: }
	inc	sp
	ret
;src/audio.c:246: static void apu(void){
;	---------------------------------
; Function apu
; ---------------------------------
_apu:
	add	sp, #-8
;src/audio.c:248: for(i=0;i<3u;++i){
	ldhl	sp,	#6
	ld	(hl), #0x00
00119$:
;src/audio.c:249: v=audio_tone[i]?audio_gb_volume(audio_volume[i]):0;frequency=audio_gb_period(audio_tone[i],i==2u);changed=(v!=previous_volume[i]);
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
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
	ld	hl, #_audio_tone
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
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00123$
	ld	de, #_audio_volume
	ldhl	sp,	#6
	ld	l, (hl)
	ld	h, #0x00
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
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_audio_gb_volume
	ld	hl, #_audio_gb_volume
	call	___sdcc_bcall_ehl
	inc	sp
	ldhl	sp,	#7
	ld	(hl), a
	jr	00124$
00123$:
	ldhl	sp,	#7
	ld	(hl), #0x00
00124$:
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00278$
	xor	a, a
00278$:
	ld	b, a
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	push	bc
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_audio_gb_period
	ld	hl, #_audio_gb_period
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#1
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	de, #_previous_volume
	ldhl	sp,	#6
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, c
	ld	a, #0x01
	jr	Z, 00280$
	xor	a, a
00280$:
	xor	a, #0x01
	ldhl	sp,	#3
	ld	(hl), a
;src/audio.c:250: if(i==0){if(changed)NR12_REG=v<<4;NR13_REG=(uint8_t)frequency;NR14_REG=(frequency>>8)|(changed?128u:0u);}
	ldhl	sp,	#0
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	jr	NZ, 00112$
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	inc	hl
	inc	hl
	ld	a, (hl)
	ldh	(_NR12_REG + 0), a
00102$:
	ldhl	sp,	#7
	ld	a, (hl)
	ldh	(_NR13_REG + 0), a
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00125$
	inc	hl
	inc	hl
	ld	(hl), #0x80
	jr	00126$
00125$:
	ldhl	sp,	#5
	ld	(hl), #0x00
00126$:
	ldhl	sp,	#5
	ld	a, (hl+)
	inc	hl
	or	a, (hl)
	ldh	(_NR14_REG + 0), a
	jp	00113$
00112$:
;src/audio.c:251: else if(i==1){if(changed)NR22_REG=v<<4;NR23_REG=(uint8_t)frequency;NR24_REG=(frequency>>8)|(changed?128u:0u);}
	ldhl	sp,	#6
	ld	a, (hl)
	dec	a
	jr	NZ, 00109$
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	inc	hl
	inc	hl
	ld	a, (hl)
	ldh	(_NR22_REG + 0), a
00104$:
	ldhl	sp,	#7
	ld	a, (hl)
	ldh	(_NR23_REG + 0), a
	ldhl	sp,	#2
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00127$
	inc	hl
	inc	hl
	ld	(hl), #0x80
	jr	00128$
00127$:
	ldhl	sp,	#5
	ld	(hl), #0x00
00128$:
	ldhl	sp,	#5
	ld	a, (hl+)
	inc	hl
	or	a, (hl)
	ldh	(_NR24_REG + 0), a
	jp	00113$
00109$:
;src/audio.c:253: if(changed){NR30_REG=0;for(n=0;n<16u;++n)_AUD3WAVERAM[n]=n<8u?((8u+v/2u)*17u):((8u-(v+1u)/2u)*17u);NR30_REG=128;NR32_REG=v?32:0;}
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	xor	a, a
	ldh	(_NR30_REG + 0), a
	ldhl	sp,	#7
	ld	(hl), #0x00
00117$:
	ld	de, #__AUD3WAVERAM
	ldhl	sp,	#7
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	sub	a, #0x08
	jr	NC, 00129$
	ldhl	sp,	#0
	ld	c, (hl)
	ld	b, #0x00
	srl	b
	rr	c
	ld	a, c
	add	a, #0x08
	ld	c, a
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
	jr	00130$
00129$:
	ldhl	sp,	#0
	ld	c, (hl)
	xor	a, a
	ld	b, a
	inc	bc
	srl	b
	rr	c
	ld	a, #0x08
	sub	a, c
	ld	c, a
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, bc
00130$:
	ld	a, l
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#7
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x10
	jr	C, 00117$
	ld	a, #0x80
	ldh	(_NR30_REG + 0), a
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	ld	a, #0x20
	jr	NZ, 00132$
	xor	a, a
00132$:
	ldh	(_NR32_REG + 0), a
00107$:
;src/audio.c:254: NR33_REG=(uint8_t)frequency;NR34_REG=(frequency>>8)|(changed?128u:0u);
	ldhl	sp,	#1
	ld	a, (hl+)
	ldh	(_NR33_REG + 0), a
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	Z, 00133$
	inc	hl
	inc	hl
	ld	(hl), #0x80
	jr	00134$
00133$:
	ldhl	sp,	#5
	ld	(hl), #0x00
00134$:
	ldhl	sp,	#5
	ld	a, (hl+)
	inc	hl
	or	a, (hl)
	ldh	(_NR34_REG + 0), a
00113$:
;src/audio.c:256: previous_volume[i]=v;
	ld	de, #_previous_volume
	ldhl	sp,	#6
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(bc), a
;src/audio.c:248: for(i=0;i<3u;++i){
	ldhl	sp,	#6
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jp	C, 00119$
;src/audio.c:258: v=audio_gb_volume(audio_volume[3]);n=audio_gb_noise(audio_noise,audio_tone[2]);
	ld	a, (#(_audio_volume + 3) + 0)
	push	af
	inc	sp
	ld	e, #b_audio_gb_volume
	ld	hl, #_audio_gb_volume
	call	___sdcc_bcall_ehl
	inc	sp
	ld	b, a
	ld	hl, #(_audio_tone + 4)
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	push	hl
	ld	a, (_audio_noise)
	push	af
	inc	sp
	ld	e, #b_audio_gb_noise
	ld	hl, #_audio_gb_noise
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	c, a
	pop	af
	ld	b, a
;src/audio.c:259: changed=(v!=previous_volume[3]||n!=previous_noise||noise_written);if(changed){NR42_REG=v<<4;NR43_REG=n;NR44_REG=128;}
	ld	de, #_previous_volume + 3
	ld	a, (de)
	sub	a, b
	jr	NZ, 00136$
	ld	a, (#_previous_noise)
	sub	a, c
	jr	NZ, 00136$
	ld	a, (#_noise_written)
	or	a,a
	jr	Z, 00137$
00136$:
	ld	a, #0x01
00137$:
	or	a, a
	jr	Z, 00116$
	ld	a, b
	swap	a
	and	a, #0xf0
	ldh	(_NR42_REG + 0), a
	ld	a, c
	ldh	(_NR43_REG + 0), a
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
00116$:
;src/audio.c:260: previous_volume[3]=v;previous_noise=n;noise_written=0;
	ld	a, b
	ld	(de), a
	ld	hl, #_previous_noise
	ld	(hl), c
	xor	a, a
	ld	(#_noise_written),a
;src/audio.c:261: }
	add	sp, #8
	ret
;src/audio.c:265: void audio_init(void) AUDIO_BANKED {
;	---------------------------------
; Function audio_init
; ---------------------------------
	b_audio_init	= 15
_audio_init::
;src/audio.c:266: memset(R,0,sizeof(audio_ram));memset(audio_tone,0,sizeof(audio_tone));memset(audio_volume,15,sizeof(audio_volume));audio_fault=audio_music=0;audio_frames=0;audio_clock=0;latch=0;reset_driver();acknowledge();
	ld	de, #0x0200
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_audio_ram
	push	de
	call	_memset
	add	sp, #6
	ld	de, #0x0006
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_audio_tone
	push	de
	call	_memset
	add	sp, #6
	ld	de, #0x0004
	push	de
	ld	de, #0x000f
	push	de
	ld	de, #_audio_volume
	push	de
	call	_memset
	add	sp, #6
	xor	a, a
	ld	(#_audio_music), a
	ld	(#_audio_fault),a
	xor	a, a
	ld	hl, #_audio_frames
	ld	(hl+), a
	ld	(hl), a
	xor	a, a
	ld	(#_audio_clock), a
	ld	(#_latch),a
	call	_reset_driver
	call	_acknowledge
;src/audio.c:268: NR52_REG=128;NR50_REG=0x77;NR51_REG=0xff;NR10_REG=0;NR11_REG=NR21_REG=0x80;NR12_REG=NR22_REG=NR42_REG=0;NR30_REG=0;memset(previous_volume,255,4);previous_noise=255;
	ld	a, #0x80
	ldh	(_NR52_REG + 0), a
	ld	a, #0x77
	ldh	(_NR50_REG + 0), a
	ld	a, #0xff
	ldh	(_NR51_REG + 0), a
	xor	a, a
	ldh	(_NR10_REG + 0), a
	ld	a, #0x80
	ldh	(_NR21_REG + 0), a
	ld	a, #0x80
	ldh	(_NR11_REG + 0), a
	xor	a, a
	ldh	(_NR42_REG + 0), a
	xor	a, a
	ldh	(_NR22_REG + 0), a
	xor	a, a
	ldh	(_NR12_REG + 0), a
	xor	a, a
	ldh	(_NR30_REG + 0), a
	ld	de, #0x0004
	push	de
	ld	de, #0x00ff
	push	de
	ld	de, #_previous_volume
	push	de
	call	_memset
	add	sp, #6
	ld	hl, #_previous_noise
	ld	(hl), #0xff
;src/audio.c:270: apu();
;src/audio.c:271: }
	jp	_apu
;src/audio.c:272: void audio_command(uint8_t cmd) AUDIO_BANKED {R[4]=cmd;}
;	---------------------------------
; Function audio_command
; ---------------------------------
	b_audio_command	= 15
_audio_command::
	ld	de, #(_audio_ram + 4)
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(de), a
	ret
;src/audio.c:273: void audio_stop(void) AUDIO_BANKED {
;	---------------------------------
; Function audio_stop
; ---------------------------------
	b_audio_stop	= 15
_audio_stop::
;src/audio.c:279: }
	di
;src/audio.c:277: reset_driver();acknowledge();audio_music=0;apu();
	call	_reset_driver
	call	_acknowledge
	xor	a, a
	ld	(#_audio_music),a
	call	_apu
	ei
;src/audio.c:281: }
	ret
;src/audio.c:282: uint8_t audio_map_track(uint8_t map) AUDIO_BANKED {
;	---------------------------------
; Function audio_map_track
; ---------------------------------
	b_audio_map_track	= 15
_audio_map_track::
;src/audio.c:285: return map<24u?tracks[map]:0;
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x18
	jr	NC, 00103$
	ld	bc, #_audio_map_track_tracks_10000_405+0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ret
00103$:
	xor	a, a
;src/audio.c:286: }
	ret
_audio_map_track_tracks_10000_405:
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
;src/audio.c:287: uint8_t audio_battle_track(uint8_t enemy) AUDIO_BANKED {return enemy==73u?0u:(enemy==72u?0x92u:0x89u);}
;	---------------------------------
; Function audio_battle_track
; ---------------------------------
	b_audio_battle_track	= 15
_audio_battle_track::
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x49
	jr	NZ, 00103$
	xor	a, a
	ret
00103$:
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x48
	ld	a, #0x92
	ret	Z
	ld	a, #0x89
	ret
;src/audio.c:288: uint8_t audio_enemy_effect(uint8_t enemy) AUDIO_BANKED {return enemy&&enemy<75u?audio_enemy_sfx[enemy-1u]:0;}
;	---------------------------------
; Function audio_enemy_effect
; ---------------------------------
	b_audio_enemy_effect	= 15
_audio_enemy_effect::
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	ld	a,(hl)
	cp	a,#0x4b
	jr	NC, 00103$
	dec	a
	ld	l, a
	ld	h, #0x00
	ld	de, #_audio_enemy_sfx
	add	hl, de
	ld	a, (hl)
	ret
00103$:
	xor	a, a
	ret
;src/audio.c:289: void audio_tick(void) AUDIO_BANKED {
;	---------------------------------
; Function audio_tick
; ---------------------------------
	b_audio_tick	= 15
_audio_tick::
;src/audio.c:294: ++audio_frames;++audio_clock;tempo();fade();command(R[4]);priority();first=(R[2]&128u)?7:3;count=(R[2]&128u)?8:7;rhythm=(R[2]&128u)?14:6;
	ld	hl, #_audio_frames
	inc	(hl)
	jr	NZ, 00158$
	inc	hl
	inc	(hl)
00158$:
	ld	hl, #_audio_clock
	inc	(hl)
	call	_tempo
	call	_fade
	ld	a, (#(_audio_ram + 4) + 0)
	call	_command
	call	_priority
	ld	a, (#(_audio_ram + 2) + 0)
	and	a, #0x80
	ld	l, a
	ld	h, #0x00
	ld	a, h
	or	a, l
	ld	e, #0x07
	jr	NZ, 00110$
	ld	e, #0x03
00110$:
	ld	a, h
	or	a, l
	jr	Z, 00111$
	ld	b, #0x08
	jr	00112$
00111$:
	ld	b, #0x07
00112$:
	ld	a, h
	or	a, l
	ld	c, #0x0e
	jr	NZ, 00114$
	ld	c, #0x06
00114$:
;src/audio.c:295: for(i=first;i<first+count;++i)if(CH(i)[0]&128u)update_channel(CH(i),i==rhythm);
	ld	d, e
00105$:
	ld	a, e
	ld	l, b
	add	a, l
	ld	l, a
	ld	a, d
	sub	a, l
	jp	NC, _apu
	ld	l, d
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	push	de
	ld	de, #(_audio_ram + 14)
	add	hl, de
	pop	de
	ld	a, (hl)
	rlca
	jr	NC, 00106$
	ld	a, d
	sub	a, c
	ld	a, #0x01
	jr	Z, 00161$
	xor	a, a
00161$:
	push	bc
	push	de
	ld	e, l
	ld	d, h
	call	_update_channel
	pop	de
	pop	bc
00106$:
	inc	d
;src/audio.c:296: apu();
;src/audio.c:297: }
	jr	00105$
	.area _CODE_15
	.area _INITIALIZER
	.area _CABS (ABS)
