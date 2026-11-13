;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_motion_upload
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _bank_copy
	.globl _memset
	.globl _memcpy
	.globl _set_bkg_palette
	.globl _display_off
	.globl _dungeon_motion_uploaded
	.globl _dungeon_motion_palette_muted
	.globl _dungeon_motion_fault
	.globl _dungeon_motion_buffer
	.globl _dungeon_motion_active
	.globl _dungeon_motion_invalidate
	.globl _dungeon_motion_external_view
	.globl _dungeon_motion_upload_begin
	.globl _dungeon_motion_expand_map
	.globl _dungeon_motion_prepare_variant
	.globl _dungeon_motion_upload_end
	.globl _dungeon_motion_home
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_dungeon_motion_active::
	.ds 1
_dungeon_motion_buffer::
	.ds 1
_dungeon_motion_fault::
	.ds 1
_dungeon_motion_palette_muted::
	.ds 1
_dungeon_motion_uploaded::
	.ds 2
_target_pattern:
	.ds 1
_target_map:
	.ds 1
_buffer_patterns:
	.ds 868
_map_work:
	.ds 2
_block_sources:
	.ds 6
_pack_row:
	.ds 1
_pack_col:
	.ds 1
_variant_base:
	.ds 2
_upload_slot:
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
;src/dungeon_motion_upload.c:25: void dungeon_motion_invalidate(void) BANK_IO_FIXED {
;	---------------------------------
; Function dungeon_motion_invalidate
; ---------------------------------
_dungeon_motion_invalidate::
;src/dungeon_motion_upload.c:26: dungeon_motion_active=0;
	xor	a, a
	ld	(#_dungeon_motion_active),a
;src/dungeon_motion_upload.c:30: }
	ret
;src/dungeon_motion_upload.c:31: void dungeon_motion_external_view(void) BANK_IO_FIXED {
;	---------------------------------
; Function dungeon_motion_external_view
; ---------------------------------
_dungeon_motion_external_view::
;src/dungeon_motion_upload.c:32: memset(buffer_patterns,255,sizeof(buffer_patterns));
	ld	de, #0x0364
	push	de
	ld	de, #0x00ff
	push	de
	ld	de, #_buffer_patterns
	push	de
	call	_memset
	add	sp, #6
;src/dungeon_motion_upload.c:33: dungeon_motion_buffer=0;dungeon_motion_active=1;
	xor	a, a
	ld	(#_dungeon_motion_buffer),a
	ld	hl, #_dungeon_motion_active
	ld	(hl), #0x01
;src/dungeon_motion_upload.c:34: }
	ret
;src/dungeon_motion_upload.c:35: void dungeon_motion_upload_begin(void) BANK_IO_FIXED {
;	---------------------------------
; Function dungeon_motion_upload_begin
; ---------------------------------
_dungeon_motion_upload_begin::
;src/dungeon_motion_upload.c:39: dungeon_motion_fault=0;dungeon_motion_uploaded=0;
	xor	a, a
	ld	(#_dungeon_motion_fault), a
	ld	hl, #_dungeon_motion_uploaded
	ld	(hl+), a
	ld	(hl), a
;src/dungeon_motion_upload.c:40: if(!dungeon_motion_active){DISPLAY_OFF;target_pattern=target_map=0;memset(buffer_patterns,255,sizeof(buffer_patterns));}
	ld	a, (#_dungeon_motion_active)
	or	a, a
	jr	NZ, 00102$
	call	_display_off
	xor	a, a
	ld	(#_target_map), a
	ld	(#_target_pattern),a
	ld	de, #0x0364
	push	de
	ld	de, #0x00ff
	push	de
	ld	de, #_buffer_patterns
	push	de
	call	_memset
	add	sp, #6
	ret
00102$:
;src/dungeon_motion_upload.c:41: else {target_pattern=dungeon_motion_buffer^1u;target_map=(LCDC_REG&LCDCF_BG9C00)?0u:1u;}
	ld	a, (#_dungeon_motion_buffer)
	xor	a, #0x01
	ld	(#_target_pattern),a
	ldh	a, (_LCDC_REG + 0)
	bit	3, a
	jr	Z, 00106$
	xor	a, a
	jr	00107$
00106$:
	ld	a, #0x01
00107$:
	ld	(#_target_map),a
;src/dungeon_motion_upload.c:42: }
	ret
;src/dungeon_motion_upload.c:47: static void expand_blocks(void) __nonbanked __naked {
;	---------------------------------
; Function expand_blocks
; ---------------------------------
_expand_blocks:
;src/dungeon_motion_upload.c:139: __endasm;
	ld	hl,#_dungeon_render_scratch
	ld	de,#_dungeon_render_map
	ld	b,#8
001$:
	ld	c,#10
002$:
	push	bc
	ld	a,(hl+)
	ld	c,a
	ld	a,(hl+)
	ld	b,a
	push	hl
	push	de
	ld	hl,#_block_sources
	bit	3,b
	jr	z,003$
	inc	hl
	inc	hl
	inc	hl
003$:
	ld	a,(hl+)
	ldh	(__current_bank),a
	ld	(#0x2000),a
	ld	a,(hl+)
	ld	e,a
	ld	d,(hl)
	ld	a,b
	and	#7
	ld	b,a
	sla	c
	rl	b
	sla	c
	rl	b
	sla	c
	rl	b
	ld	h,b
	ld	l,c
	add	hl,de
	pop	de
	ld	a,(hl+)
	ld	(de),a
	inc	de
	ld	a,(hl+)
	ld	(de),a
	inc	de
	ld	a,(hl+)
	ld	(de),a
	inc	de
	ld	a,(hl+)
	ld	(de),a
	inc	de
	push	de
	push	hl
	ldhl	sp,#7
	ld	a,(hl)
	pop	hl
	cp	#1
	jr	z,005$
	ld	a,e
	add	#36
	ld	e,a
	jr	nc,004$
	inc	d
004$:
	ld	a,(hl+)
	ld	(de),a
	inc	de
	ld	a,(hl+)
	ld	(de),a
	inc	de
	ld	a,(hl+)
	ld	(de),a
	inc	de
	ld	a,(hl+)
	ld	(de),a
005$:
	pop	de
	pop	hl
	pop	bc
	dec	c
	jp	nz,002$
	ld	a,e
	add	#40
	ld	e,a
	jr	nc,006$
	inc	d
006$:
	dec	b
	jp	nz,001$
	ret
;src/dungeon_motion_upload.c:140: }
;src/dungeon_motion_upload.c:141: void dungeon_motion_expand_map(const DungeonGraphicAsset *map) BANK_IO_FIXED {
;	---------------------------------
; Function dungeon_motion_expand_map
; ---------------------------------
_dungeon_motion_expand_map::
	dec	sp
	ld	c, e
	ld	b, d
;src/dungeon_motion_upload.c:142: uint8_t saved=CURRENT_BANK;
	ldh	a, (__current_bank + 0)
	ldhl	sp,	#0
	ld	(hl), a
;src/dungeon_motion_upload.c:143: bank_copy(&dungeon_render_scratch,map->bank,map->data,160u);
	ld	l, c
	ld	h, b
	inc	hl
	ld	a, (hl+)
	ld	l, (hl)
	ld	e, a
	ld	d, l
	ld	a, (bc)
	ld	c, a
	xor	a, a
	and	a
	push	af
	push	de
	ld	a, c
	ld	de, #_dungeon_render_scratch
	call	_bank_copy
;src/dungeon_motion_upload.c:144: memcpy(block_sources,motion_blocks,6u);expand_blocks();SWITCH_ROM_MBC5(saved);
	ld	de, #0x0006
	push	de
	ld	bc, #_motion_blocks
	ld	de, #_block_sources
	call	_memcpy
	call	_expand_blocks
	ldhl	sp,	#0
	ld	a, (hl)
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(#_rROMB0),a
;src/dungeon_motion_upload.c:145: }
	inc	sp
	ret
_pattern_banks:
	.db #0xd1	; 209
	.db #0xd2	; 210
	.db #0xd3	; 211
	.db #0xd4	; 212
	.db #0xd6	; 214
	.db #0xd7	; 215
	.db #0xd8	; 216
	.db #0xd9	; 217
	.db #0xda	; 218
	.db #0xdb	; 219
	.db #0xdc	; 220
	.db #0xdd	; 221
	.db #0xde	; 222
	.db #0xdf	; 223
	.db #0xe0	; 224
;src/dungeon_motion_upload.c:146: static void convert_map(void) __nonbanked __naked {
;	---------------------------------
; Function convert_map
; ---------------------------------
_convert_map:
;src/dungeon_motion_upload.c:198: __endasm;
	ld	hl,#_dungeon_render_map
	ld	bc,#300
007$:
	push	bc
	ld	a,(hl+)
	ld	c,a
	ld	b,(hl)
	dec	hl
	push	hl
	sla	c
	rl	b
	sla	c
	rl	b
	ld	a,(#_variant_base)
	ld	e,a
	ld	a,(#_variant_base+1)
	ld	d,a
	ld	h,b
	ld	l,c
	add	hl,de
	ld	a,(hl+)
	ld	e,a
	ld	a,(hl+)
	ld	d,a
	ld	a,(hl+)
	ld	b,a
	ld	c,(hl)
	push	bc
	ld	a,c
	add	a
	ld	l,a
	ld	h,#0
	rl	h
	ld	bc,#_dungeon_render_scratch
	add	hl,bc
	ld	(hl),e
	inc	hl
	ld	(hl),d
	pop	bc
	pop	hl
	ld	(hl),c
	inc	hl
	ld	(hl),b
	inc	hl
	pop	bc
	dec	bc
	ld	a,b
	or	c
	jp	nz,007$
	ret
;src/dungeon_motion_upload.c:199: }
;src/dungeon_motion_upload.c:200: void dungeon_motion_prepare_variant(const DungeonGraphicAsset *variant) BANK_IO_FIXED {
;	---------------------------------
; Function dungeon_motion_prepare_variant
; ---------------------------------
_dungeon_motion_prepare_variant::
;src/dungeon_motion_upload.c:201: uint8_t saved=CURRENT_BANK,bank=variant->bank;
	ldh	a, (__current_bank + 0)
	ld	c, a
	ld	a, (de)
	ld	b, a
;src/dungeon_motion_upload.c:202: memset(&dungeon_render_scratch,255,MOTION_CACHE_SLOTS*2u);
	push	de
	ld	hl, #0x01b2
	push	hl
	ld	hl, #0x00ff
	push	hl
	ld	hl, #_dungeon_render_scratch
	push	hl
	call	_memset
	add	sp, #6
;src/dungeon_motion_upload.c:203: variant_base=(uint16_t)variant->data;SWITCH_ROM_MBC5(bank);convert_map();SWITCH_ROM_MBC5(saved);
	pop	hl
	inc	hl
	ld	a,	(hl+)
	ld	h, (hl)
	ld	e, a
	ld	d, h
	ld	hl, #_variant_base
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ld	a, b
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), b
	push	bc
	call	_convert_map
	pop	bc
	ld	a, c
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), c
;src/dungeon_motion_upload.c:204: }
	ret
;src/dungeon_motion_upload.c:207: static void upload_patterns(void) __nonbanked __naked {
;	---------------------------------
; Function upload_patterns
; ---------------------------------
_upload_patterns:
;src/dungeon_motion_upload.c:334: __endasm;
	ldh	a,(__current_bank)
	push	af
	xor	a
	ld	(#_upload_slot),a
	ld	hl,#_dungeon_render_scratch
	ld	de,#_buffer_patterns
	ld	a,(#_target_pattern)
	or	a
	jr	z,020$
	ld	de,#(_buffer_patterns+217*2)
020$:
	ld	a,(hl+)
	ld	c,a
	ld	a,(hl+)
	ld	b,a
	cp	#255
	jr	z,022$
	ld	a,(de)
	cp	c
	jr	nz,023$
	inc	de
	ld	a,(de)
	cp	b
	jr	nz,021$
	inc	de
	jp	028$
021$:
	dec	de
	jr	023$
022$:
	inc	de
	inc	de
	jp	028$
023$:
	ld	a,c
	ld	(de),a
	inc	de
	ld	a,b
	ld	(de),a
	inc	de
	push	hl
	push	de
	ld	a,b
	srl	a
	srl	a
	ld	l,a
	ld	h,#0
	ld	de,#_pattern_banks
	add	hl,de
	ld	a,(hl)
	di
	ldh	(__current_bank),a
	ld	(#0x2000),a
	ld	a,c
	swap	a
	and	#240
	ldh	(#0x52),a
	ld	a,b
	and	#3
	swap	a
	ld	b,a
	ld	a,c
	swap	a
	and	#15
	or	b
	or	#64
	ldh	(#0x51),a
	ld	b,#0
	ld	a,(#_target_pattern)
	or	a
	ld	a,(#_upload_slot)
	jr	z,025$
	cp	#192
	jr	nc,024$
	add	#64
	inc	b
	jr	025$
024$:
	add	#(217 -192)
025$:
	ld	c,a
	ld	a,b
	ldh	(#0x4f),a
	ld	a,c
	swap	a
	and	#240
	ldh	(#0x54),a
	ld	a,c
	swap	a
	and	#15
	bit	7,c
	jr	nz,026$
	or	#16
026$:
	or	#128
	ldh	(#0x53),a
	ldh	a,(#0x40)
	and	#128
	ldh	(#0x55),a
027$:
	ldh	a,(#0x55)
	bit	7,a
	jr	z,027$
	cp	#255
	jr	z,029$
	ld	a,#1
	ld	(#_dungeon_motion_fault),a
029$:
	ei
	ld	hl,#_dungeon_motion_uploaded
	inc	(hl)
	pop	de
	pop	hl
028$:
	ld	a,(#_upload_slot)
	inc	a
	ld	(#_upload_slot),a
	cp	#217
	jp	nz,020$
	pop	af
	ldh	(__current_bank),a
	ld	(#0x2000),a
	xor	a
	ldh	(#0x4f),a
	ret
;src/dungeon_motion_upload.c:335: }
;src/dungeon_motion_upload.c:340: static void pack_map(void) __nonbanked __naked {
;	---------------------------------
; Function pack_map
; ---------------------------------
_pack_map:
;src/dungeon_motion_upload.c:404: __endasm;
	ld	a,(#_map_work)
	ld	e,a
	ld	a,(#_map_work+1)
	ld	d,a
	ld	h,d
	ld	l,e
	ld	bc,#576
	add	hl,bc
	ld	b,h
	ld	c,l
	ld	hl,#_dungeon_render_map
	ld	a,#15
	ld	(#_pack_row),a
008$:
	ld	a,#20
	ld	(#_pack_col),a
009$:
	ld	a,(#_target_pattern)
	or	a
	jr	z,011$
	ld	a,(hl+)
	cp	#192
	jr	nc,010$
	add	#64
	ld	(de),a
	inc	de
	ld	a,(hl+)
	or	#8
	jr	012$
010$:
	add	#(217 -192)
	jr	013$
011$:
	ld	a,(hl+)
013$:
	ld	(de),a
	inc	de
	ld	a,(hl+)
012$:
	ld	(bc),a
	inc	bc
	ld	a,(#_pack_col)
	dec	a
	ld	(#_pack_col),a
	jr	nz,009$
	ld	a,#12
	ld	(#_pack_col),a
014$:
	xor	a
	ld	(de),a
	inc	de
	ld	(bc),a
	inc	bc
	ld	a,(#_pack_col)
	dec	a
	ld	(#_pack_col),a
	jr	nz,014$
	ld	a,(#_pack_row)
	dec	a
	ld	(#_pack_row),a
	jr	nz,008$
	ret
;src/dungeon_motion_upload.c:405: }
;src/dungeon_motion_upload.c:406: void dungeon_motion_upload_end(void) BANK_IO_FIXED {
;	---------------------------------
; Function dungeon_motion_upload_end
; ---------------------------------
_dungeon_motion_upload_end::
;src/dungeon_motion_upload.c:407: upload_patterns();map_work=(uint8_t *)(((uint16_t)&dungeon_render_scratch+15u)&0xfff0u);
	call	_upload_patterns
	ld	bc, #_dungeon_render_scratch+0
	ld	hl, #0x000f
	add	hl, bc
	ld	c, h
	ld	a, l
	and	a, #0xf0
	ld	hl, #_map_work
	ld	(hl+), a
	ld	(hl), c
;src/dungeon_motion_upload.c:408: pack_map();memset(map_work+480u,0,96u);memset(map_work+1056u,15,96u);
	call	_pack_map
	ld	hl, #_map_work
	ld	a, (hl+)
	add	a, #0xe0
	ld	c, a
	ld	a, (hl)
	adc	a, #0x01
	ld	b, a
	ld	de, #0x0060
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ld	hl, #_map_work
	ld	a, (hl+)
	add	a, #0x20
	ld	c, a
	ld	a, (hl)
	adc	a, #0x04
	ld	b, a
	ld	de, #0x0060
	push	de
	ld	de, #0x000f
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/dungeon_motion_upload.c:409: maps(target_map?0x9c00u:0x9800u);
	ld	a, (#_target_map)
	or	a, a
	jr	Z, 00114$
	ld	de, #0x9c00
	jr	00115$
00114$:
	ld	de, #0x9800
00115$:
	call	_maps
;src/dungeon_motion_upload.c:410: if(LCDC_REG&LCDCF_ON)while(LY_REG<144u);
	ldh	a, (_LCDC_REG + 0)
	rlca
	jr	NC, 00105$
00101$:
	ldh	a, (_LY_REG + 0)
	sub	a, #0x90
	jr	C, 00101$
00105$:
;src/dungeon_motion_upload.c:411: if(target_map)LCDC_REG|=LCDCF_BG9C00;else LCDC_REG&=(uint8_t)~LCDCF_BG9C00;
	ld	a, (#_target_map)
	or	a, a
	jr	Z, 00107$
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x08
	ldh	(_LCDC_REG + 0), a
	jr	00108$
00107$:
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xf7
	ldh	(_LCDC_REG + 0), a
00108$:
;src/dungeon_motion_upload.c:412: if(!dungeon_motion_palette_muted)set_bkg_palette(0,7,(uint16_t *)dungeon_render_palette);
	ld	a, (#_dungeon_motion_palette_muted)
	or	a, a
	jr	NZ, 00110$
	ld	de, #_dungeon_render_palette
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
00110$:
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/dungeon_motion_upload.c:415: dungeon_uploaded_patterns=dungeon_motion_uploaded;
	ld	a, (#_dungeon_motion_uploaded)
	ld	(#_dungeon_uploaded_patterns),a
	ld	a, (#_dungeon_motion_uploaded + 1)
	ld	(#_dungeon_uploaded_patterns + 1),a
;src/dungeon_motion_upload.c:417: dungeon_motion_buffer=target_pattern;dungeon_motion_active=1;SHOW_BKG;DISPLAY_ON;
	ld	a, (#_target_pattern)
	ld	(#_dungeon_motion_buffer),a
	ld	hl, #_dungeon_motion_active
	ld	(hl), #0x01
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/dungeon_motion_upload.c:418: }
	ret
;src/dungeon_motion_upload.c:419: void dungeon_motion_home(void) BANK_IO_FIXED {
;	---------------------------------
; Function dungeon_motion_home
; ---------------------------------
_dungeon_motion_home::
;src/dungeon_motion_upload.c:420: if(LCDC_REG&LCDCF_BG9C00){maps(0x9800u);while(LY_REG<144u);LCDC_REG&=(uint8_t)~LCDCF_BG9C00;}
	ldh	a, (_LCDC_REG + 0)
	bit	3, a
	ret	Z
	ld	de, #0x9800
	call	_maps
00101$:
	ldh	a, (_LY_REG + 0)
	sub	a, #0x90
	jr	C, 00101$
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xf7
	ldh	(_LCDC_REG + 0), a
;src/dungeon_motion_upload.c:421: }
	ret
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE_0
;src/dungeon_motion_upload.c:15: static void dma(uint8_t bank,uint16_t source,uint16_t dest,uint8_t vram,uint8_t tiles) __critical {
;	---------------------------------
; Function dma
; ---------------------------------
_dma:
	di
	ld	b, a
;src/dungeon_motion_upload.c:16: uint8_t saved=CURRENT_BANK;
	ldh	a, (__current_bank + 0)
	ld	c, a
;src/dungeon_motion_upload.c:17: SWITCH_ROM_MBC5(bank);VBK_REG=vram;
	ld	a, b
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), b
	ldhl	sp,	#4
;src/dungeon_motion_upload.c:18: HDMA1_REG=source>>8;HDMA2_REG=(uint8_t)source;
;src/dungeon_motion_upload.c:19: HDMA3_REG=dest>>8;HDMA4_REG=(uint8_t)dest;
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
;src/dungeon_motion_upload.c:20: HDMA5_REG=tiles-1u|((LCDC_REG&LCDCF_ON)?0x80u:0u);
	ldhl	sp,	#5
	ld	b, (hl)
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
;src/dungeon_motion_upload.c:21: while(!(HDMA5_REG&0x80u));
00101$:
	ldh	a, (_HDMA5_REG + 0)
	rlca
	jr	NC, 00101$
;src/dungeon_motion_upload.c:22: if(HDMA5_REG!=255u)dungeon_motion_fault=1;
	ldh	a, (_HDMA5_REG + 0)
	inc	a
	jr	Z, 00105$
	ld	hl, #_dungeon_motion_fault
	ld	(hl), #0x01
00105$:
;src/dungeon_motion_upload.c:23: VBK_REG=0;SWITCH_ROM_MBC5(saved);
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ld	a, c
	ldh	(__current_bank + 0), a
	xor	a, a
	ld	(#_rROMB1),a
	ld	hl, #_rROMB0
	ld	(hl), c
;src/dungeon_motion_upload.c:24: }
	ei
	pop	hl
	add	sp, #4
	jp	(hl)
;src/dungeon_motion_upload.c:336: static void maps(uint16_t dest) {
;	---------------------------------
; Function maps
; ---------------------------------
_maps:
	ld	c, e
	ld	b, d
;src/dungeon_motion_upload.c:337: dma(CURRENT_BANK,(uint16_t)map_work,dest,0u,36u);
	ld	a, (_map_work)
	ld	e, a
	ld	hl, #_map_work + 1
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
;src/dungeon_motion_upload.c:338: dma(CURRENT_BANK,(uint16_t)(map_work+576u),dest,1u,36u);
	ld	hl, #_map_work
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
;src/dungeon_motion_upload.c:339: }
	ret
	.area _CODE_0
	.area _INITIALIZER
	.area _CABS (ABS)
