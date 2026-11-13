;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module ending_upload
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memcpy
	.globl _ending_dma_count
	.globl _ending_dma_after
	.globl _ending_dma_before
	.globl _ending_upload_fault
	.globl _ending_upload_buffer
	.globl _ending_uploaded_patterns
	.globl _ending_upload_begin
	.globl _ending_upload_step
	.globl _ending_upload_commit
	.globl _ending_upload_home
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_ending_uploaded_patterns::
	.ds 2
_ending_upload_buffer::
	.ds 1
_ending_upload_fault::
	.ds 1
_ending_dma_before::
	.ds 1
_ending_dma_after::
	.ds 1
_ending_dma_count::
	.ds 1
_work:
	.ds 2
_target_buffer:
	.ds 1
_groups_left:
	.ds 1
_group_index:
	.ds 1
_group_progress:
	.ds 1
_maps_done:
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
;src/ending_upload.c:19: static void pack_maps(void) __nonbanked __naked {
;	---------------------------------
; Function pack_maps
; ---------------------------------
_pack_maps:
;src/ending_upload.c:90: __endasm;
	ld	a,(#_target_buffer)
	or	a
	jr	z,010$
	ld	hl,#_dungeon_render_map
	ld	de,#(_dungeon_render_map+300)
	ld	bc,#300
001$:
	ld	a,(hl)
	cp	#192
	jr	nc,002$
	add	#64
	ld	(hl),a
	ld	a,(de)
	or	#8
	ld	(de),a
	jr	003$
002$:
	add	#17
	ld	(hl),a
003$:
	inc	hl
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,001$
010$:
	ld	hl,#_dungeon_render_map
	ld	a,(#_work)
	ld	e,a
	ld	a,(#_work+1)
	ld	d,a
	call	020$
	ld	b,#96
	xor	a
011$:
	ld	(de),a
	inc	de
	dec	b
	jr	nz,011$
	call	020$
	ld	b,#96
	ld	a,#15
012$:
	ld	(de),a
	inc	de
	dec	b
	jr	nz,012$
	ret
020$:
	ld	b,#15
021$:
	ld	c,#20
022$:
	ld	a,(hl+)
	ld	(de),a
	inc	de
	dec	c
	jr	nz,022$
	ld	c,#12
	xor	a
023$:
	ld	(de),a
	inc	de
	dec	c
	jr	nz,023$
	dec	b
	jr	nz,021$
	ret
;src/ending_upload.c:91: }
;src/ending_upload.c:108: void ending_upload_begin(uint8_t bank,const uint8_t *data,uint8_t target) BANK_IO_FIXED {
;	---------------------------------
; Function ending_upload_begin
; ---------------------------------
_ending_upload_begin::
	add	sp, #-8
	ld	c, a
;src/ending_upload.c:109: uint8_t saved=CURRENT_BANK,count,color;
	ldh	a, (__current_bank + 0)
	ldhl	sp,	#2
;src/ending_upload.c:110: uint16_t i=0;
	ld	(hl+), a
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/ending_upload.c:111: work=(uint8_t *)(((uint16_t)&dungeon_render_scratch+15u)&0xfff0u);
	ld	hl, #_dungeon_render_scratch
	push	de
	ld	de, #0x000f
	add	hl, de
	pop	de
	ld	a, l
	and	a, #0xf0
	ld	(_work), a
	ld	a, h
	ld	(_work + 1), a
;src/ending_upload.c:112: target_buffer=target;group_index=0;group_progress=0;maps_done=0;ending_uploaded_patterns=0;
	ldhl	sp,	#10
	ld	a, (hl)
	ld	(#_target_buffer),a
	xor	a, a
	ld	(#_group_index), a
	ld	(#_group_progress),a
	xor	a, a
	ld	(#_maps_done), a
	ld	hl, #_ending_uploaded_patterns
	ld	(hl+), a
	ld	(hl), a
;src/ending_upload.c:113: SWITCH_ROM_MBC5(bank);groups_left=*data++;
	ld	a, c
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), c
	ld	a, (de)
	ld	hl, #_groups_left
	ld	(hl), a
	inc	de
	inc	sp
	inc	sp
	push	de
;src/ending_upload.c:114: memcpy(work+COMMAND_OFFSET,data,(uint16_t)groups_left*6u);data+=(uint16_t)groups_left*6u;
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ld	hl, #_work
	ld	a, (hl+)
	add	a, #0x80
	ld	e, a
	ld	a, (hl)
	adc	a, #0x04
	ld	d, a
	push	bc
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	call	_memcpy
	ld	a, (_groups_left)
	ld	c, a
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	pop	hl
	push	hl
	add	hl, bc
	ld	e, l
	ld	d, h
;src/ending_upload.c:115: memcpy(dungeon_render_map,data,300u);data+=300u;
	ld	c, e
	ld	b, d
	push	de
	ld	hl, #0x012c
	push	hl
	ld	de, #_dungeon_render_map
	call	_memcpy
	pop	de
	ld	hl, #0x012c
	add	hl, de
	ld	c, l
	ld	b, h
;src/ending_upload.c:116: while(i<300u){count=*data++;color=*data++;while(count--)dungeon_render_map[300u+i++]=color;}
00104$:
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	sub	a, #0x2c
	ld	a, d
	sbc	a, #0x01
	jr	NC, 00106$
	inc	hl
	ld	a, (bc)
	ld	e, a
	inc	bc
	ld	a, (bc)
	ld	(hl-), a
	dec	hl
	inc	bc
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
00101$:
	ld	a, e
	dec	e
	or	a, a
	jr	Z, 00104$
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	d, (hl)
	dec	hl
	inc	(hl)
	jr	NZ, 00141$
	inc	hl
	inc	(hl)
00141$:
	push	af
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#5
	ld	(hl), a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	pop	af
	add	a, #0x2c
	ld	l, a
	ld	a, d
	adc	a, #0x01
	ld	h, a
	push	de
	ld	de, #_dungeon_render_map
	add	hl, de
	pop	de
	push	hl
	ldhl	sp,	#7
	ld	a, (hl)
	pop	hl
	ld	(hl), a
	jr	00101$
00106$:
;src/ending_upload.c:117: SWITCH_ROM_MBC5(saved);
	ldhl	sp,	#2
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(#_rROMB0),a
;src/ending_upload.c:118: pack_maps();
	call	_pack_maps
;src/ending_upload.c:119: }
	add	sp, #8
	pop	hl
	inc	sp
	jp	(hl)
;src/ending_upload.c:124: uint8_t ending_upload_step(void) BANK_IO_FIXED {
;	---------------------------------
; Function ending_upload_step
; ---------------------------------
_ending_upload_step::
	add	sp, #-12
;src/ending_upload.c:128: while(groups_left) {
00115$:
	ld	a, (#_groups_left)
	or	a, a
	jp	Z, 00117$
;src/ending_upload.c:129: command=work+COMMAND_OFFSET+(uint16_t)group_index*6u;
	ld	hl, #_work
	ld	a, (hl+)
	add	a, #0x80
	ld	c, a
	ld	a, (hl)
	adc	a, #0x04
	ld	b, a
	ld	a, (_group_index)
	ld	l, a
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#10
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
;src/ending_upload.c:130: source=((uint16_t)command[1]<<8)|command[2];source+=(uint16_t)group_progress*16u;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
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
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl-), a
	ld	(hl), #0x00
	ldhl	sp,#2
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
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#8
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
	ld	a, (#_group_progress)
	ldhl	sp,	#8
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x04
00194$:
	ldhl	sp,	#6
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00194$
	ldhl	sp,	#10
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
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#5
;src/ending_upload.c:131: dest=((uint16_t)command[3]<<8)|command[4];dest+=(uint16_t)group_progress*16u;
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
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
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl-), a
	ld	(hl), #0x00
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
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
	ld	(hl), a
	ldhl	sp,	#8
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
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
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#7
;src/ending_upload.c:132: slot=(uint8_t)((dest-0x9000u)>>4);vram=0;
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x9000
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, e
	ld	(hl+), a
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	inc	hl
	srl	(hl)
	dec	hl
	rr	(hl)
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
;src/ending_upload.c:133: count=command[5]+1u-group_progress;if(count>16u)count=16u;
	ldhl	sp,#2
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
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	inc	a
	ld	hl, #_group_progress
	sub	a, (hl)
	ld	c, a
	ld	a, #0x10
	sub	a, c
	jr	NC, 00102$
	ld	c, #0x10
00102$:
;src/ending_upload.c:134: if(target_buffer) {
	ld	a, (#_target_buffer)
	or	a, a
	jr	Z, 00112$
;src/ending_upload.c:135: if(slot<64u){dest=0x9400u+(uint16_t)slot*16u;vram=1u;limit=64u-slot;}
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x40
	jr	NC, 00107$
	ld	b, (hl)
	xor	a, a
	ld	l, b
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	b, l
	ld	a, h
	add	a, #0x94
	ldhl	sp,	#6
	ld	(hl), b
	inc	hl
	ld	(hl+), a
	inc	hl
	ld	a, #0x01
	ld	(hl-), a
	ld	a, #0x40
	sub	a, (hl)
	ld	b, a
	jr	00108$
00107$:
;src/ending_upload.c:136: else if(slot<192u){dest=0x8800u+(uint16_t)(slot-64u)*16u;vram=1u;limit=192u-slot;}
	ldhl	sp,	#8
	ld	e, (hl)
	ld	b, #0x00
	ld	a, (hl)
	sub	a, #0xc0
	jr	NC, 00104$
	ld	a, e
	add	a, #0xc0
	ld	l, a
	ld	a, b
	adc	a, #0xff
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	b, l
	ld	a, h
	add	a, #0x88
	ldhl	sp,	#6
	ld	(hl), b
	inc	hl
	ld	(hl+), a
	inc	hl
	ld	a, #0x01
	ld	(hl-), a
	ld	a, #0xc0
	sub	a, (hl)
	ld	b, a
	jr	00108$
00104$:
;src/ending_upload.c:137: else {dest=0x8d10u+(uint16_t)(slot-192u)*16u;limit=17u;}
	ld	a, e
	add	a, #0x40
	ld	l, a
	ld	a, b
	adc	a, #0xff
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #0x10
	ld	b, a
	ld	a, h
	adc	a, #0x8d
	ldhl	sp,	#6
	ld	(hl), b
	inc	hl
	ld	(hl), a
	ld	b, #0x11
00108$:
;src/ending_upload.c:138: if(count>limit)count=limit;
	ld	a, b
	sub	a, c
	jr	NC, 00112$
	ld	c, b
00112$:
;src/ending_upload.c:140: dma(command[0],source,dest,vram,count);ending_uploaded_patterns+=count;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	push	bc
	ld	h, c
	push	hl
	inc	sp
	ldhl	sp,	#12
	ld	h, (hl)
	push	hl
	inc	sp
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_dma
	pop	bc
	ld	e, c
	ld	a, (_ending_uploaded_patterns)
	ld	hl, #_ending_uploaded_patterns + 1
	ld	d, (hl)
	ld	l, #0x00
	add	a, e
	ld	b, a
	ld	a, d
	adc	a, l
	ld	hl, #_ending_uploaded_patterns
	ld	(hl), b
	inc	hl
	ld	(hl), a
;src/ending_upload.c:141: group_progress+=count;
	ld	a, c
	ld	hl, #_group_progress
	add	a, (hl)
	ld	(hl), a
;src/ending_upload.c:142: if(group_progress==command[5]+1u){group_progress=0;++group_index;--groups_left;}
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b, #0x00
	ld	c, a
	inc	bc
	ld	a, (_group_progress)
	ld	e, a
	ld	d, #0x00
	ld	a, e
	sub	a, c
	jp	NZ, 00115$
	ld	a, d
	sub	a, b
	jp	NZ, 00115$
	xor	a, a
	ld	(#_group_progress),a
	ld	hl, #_group_index
	inc	(hl)
	ld	hl, #_groups_left
	dec	(hl)
	jp	00115$
00117$:
;src/ending_upload.c:147: if(!maps_done){maps(target_buffer?0x9c00u:0x9800u);maps_done=1;}
	ld	a, (#_maps_done)
	or	a, a
	jr	NZ, 00119$
	ld	a, (#_target_buffer)
	or	a, a
	jr	Z, 00122$
	ld	de, #0x9c00
	jr	00123$
00122$:
	ld	de, #0x9800
00123$:
	call	_maps
	ld	hl, #_maps_done
	ld	(hl), #0x01
00119$:
;src/ending_upload.c:148: return 1;
	ld	a, #0x01
;src/ending_upload.c:149: }
	add	sp, #12
	ret
;src/ending_upload.c:150: void ending_upload_commit(void) BANK_IO_FIXED {
;	---------------------------------
; Function ending_upload_commit
; ---------------------------------
_ending_upload_commit::
;src/ending_upload.c:151: if(LCDC_REG&LCDCF_ON)while(LY_REG<144u);
	ldh	a, (_LCDC_REG + 0)
	rlca
	jr	NC, 00105$
00101$:
	ldh	a, (_LY_REG + 0)
	sub	a, #0x90
	jr	C, 00101$
00105$:
;src/ending_upload.c:152: ending_upload_buffer=target_buffer;
	ld	a, (#_target_buffer)
	ld	(#_ending_upload_buffer),a
;src/ending_upload.c:153: if(target_buffer)LCDC_REG|=LCDCF_BG9C00;
	ld	a, (#_target_buffer)
	or	a, a
	jr	Z, 00107$
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x08
	ldh	(_LCDC_REG + 0), a
	jr	00108$
00107$:
;src/ending_upload.c:154: else LCDC_REG&=(uint8_t)~LCDCF_BG9C00;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xf7
	ldh	(_LCDC_REG + 0), a
00108$:
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/ending_upload.c:155: move_bkg(0,0);
;src/ending_upload.c:156: }
	ret
;src/ending_upload.c:157: void ending_upload_home(void) BANK_IO_FIXED {
;	---------------------------------
; Function ending_upload_home
; ---------------------------------
_ending_upload_home::
;src/ending_upload.c:158: if(ending_upload_buffer){maps(0x9800u);while(LY_REG<144u);ending_upload_buffer=0;LCDC_REG&=(uint8_t)~LCDCF_BG9C00;}
	ld	a, (#_ending_upload_buffer)
	or	a, a
	ret	Z
	ld	de, #0x9800
	call	_maps
00101$:
	ldh	a, (_LY_REG + 0)
	sub	a, #0x90
	jr	C, 00101$
	xor	a, a
	ld	(#_ending_upload_buffer),a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xf7
	ldh	(_LCDC_REG + 0), a
;src/ending_upload.c:159: }
	ret
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE_0
;src/ending_upload.c:92: static void dma(uint8_t bank,uint16_t source,uint16_t dest,uint8_t vram,uint8_t tiles) __critical {
;	---------------------------------
; Function dma
; ---------------------------------
_dma:
	di
	ld	b, a
;src/ending_upload.c:93: uint8_t saved=CURRENT_BANK;
	ldh	a, (__current_bank + 0)
	ld	c, a
;src/ending_upload.c:98: SWITCH_ROM_MBC5(bank);VBK_REG=vram;
	ld	a, b
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), b
	ldhl	sp,	#4
;src/ending_upload.c:99: HDMA1_REG=(uint8_t)(source>>8);HDMA2_REG=(uint8_t)source;
;src/ending_upload.c:100: HDMA3_REG=(uint8_t)(dest>>8);HDMA4_REG=(uint8_t)dest;
	ld	a, (hl-)
	ldh	(_VBK_REG + 0), a
	ld	a, d
	ldh	(_HDMA1_REG + 0), a
	ld	a, e
	ldh	(_HDMA2_REG + 0), a
	ld	a, (hl-)
	ldh	(_HDMA3_REG + 0), a
	ld	a, (hl)
	ldh	(_HDMA4_REG + 0), a
;src/ending_upload.c:101: ending_dma_before=LY_REG;ending_dma_count=tiles;
	ldh	a, (_LY_REG + 0)
	ld	(#_ending_dma_before),a
	ldhl	sp,	#5
	ld	b, (hl)
	ld	hl, #_ending_dma_count
	ld	(hl), b
;src/ending_upload.c:102: HDMA5_REG=(tiles-1u)|((LCDC_REG&LCDCF_ON)?0x80u:0u);
	dec	b
	ldh	a, (_LCDC_REG + 0)
	rlca
	jr	NC, 00108$
	ld	a, #0x80
	jr	00109$
00108$:
	xor	a, a
00109$:
	or	a, b
	ldh	(_HDMA5_REG + 0), a
;src/ending_upload.c:103: while(!(HDMA5_REG&0x80u));
00101$:
	ldh	a, (_HDMA5_REG + 0)
	rlca
	jr	NC, 00101$
;src/ending_upload.c:104: ending_dma_after=LY_REG;
	ldh	a, (_LY_REG + 0)
	ld	(#_ending_dma_after),a
;src/ending_upload.c:105: if(HDMA5_REG!=255u)ending_upload_fault=1;
	ldh	a, (_HDMA5_REG + 0)
	inc	a
	jr	Z, 00105$
	ld	hl, #_ending_upload_fault
	ld	(hl), #0x01
00105$:
;src/ending_upload.c:106: VBK_REG=0;SWITCH_ROM_MBC5(saved);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	a, c
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), c
;src/ending_upload.c:107: }
	ei
	pop	hl
	add	sp, #4
	jp	(hl)
;src/ending_upload.c:120: static void maps(uint16_t dest) {
;	---------------------------------
; Function maps
; ---------------------------------
_maps:
	ld	c, e
	ld	b, d
;src/ending_upload.c:121: dma(CURRENT_BANK,(uint16_t)work,dest,0u,36u);
	ld	a, (_work)
	ld	e, a
	ld	hl, #_work + 1
	ld	d, (hl)
	push	bc
	ld	a, #0x24
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	push	bc
	ldh	a, (__current_bank + 0)
	call	_dma
	pop	bc
;src/ending_upload.c:122: dma(CURRENT_BANK,(uint16_t)(work+MAP_BYTES),dest,1u,36u);
	ld	hl, #_work
	ld	a, (hl+)
	add	a, #0x40
	ld	e, a
	ld	a, (hl)
	adc	a, #0x02
	ld	d, a
	ld	a, #0x24
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	ldh	a, (__current_bank + 0)
	call	_dma
;src/ending_upload.c:123: }
	ret
	.area _CODE_0
	.area _INITIALIZER
	.area _CABS (ABS)
