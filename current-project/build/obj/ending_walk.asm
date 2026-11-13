;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module ending_walk
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_game_transition_vint16
	.globl _game_transition_vint16
	.globl b_audio_command
	.globl _audio_command
	.globl _dungeon_invalidate_view_cache
	.globl _ending_upload_home
	.globl _ending_upload_commit
	.globl _ending_upload_step
	.globl _ending_upload_begin
	.globl _set_bkg_palette
	.globl _display_off
	.globl _ending_walk_busy
	.globl _ending_walk_frame
	.globl b_ending_walk_begin
	.globl _ending_walk_begin
	.globl b_ending_walk_tick
	.globl _ending_walk_tick
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_ending_walk_frame::
	.ds 2
_ending_walk_busy::
	.ds 1
_run_index:
	.ds 2
_current_image:
	.ds 2
_run_left:
	.ds 1
_lighting:
	.ds 1
_sound_index:
	.ds 1
_current_palette:
	.ds 1
_active:
	.ds 1
_pending_palette:
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
	.area _CODE_136
;src/ending_walk.c:16: static void commit(void) {
;	---------------------------------
; Function commit
; ---------------------------------
_commit:
;src/ending_walk.c:17: ending_upload_commit();set_bkg_palette(0,7,ending_palettes[pending_palette]);
	call	_ending_upload_commit
	ld	hl, #_pending_palette
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_ending_palettes
	add	hl, bc
	push	hl
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/ending_walk.c:18: current_image=ending_runs[run_index].image;current_palette=pending_palette;
	ld	hl, #_run_index
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_ending_runs
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	hl, #_current_image
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	a, (#_pending_palette)
	ld	(#_current_palette),a
;src/ending_walk.c:19: ending_walk_busy=0;
	xor	a, a
	ld	(#_ending_walk_busy),a
;src/ending_walk.c:20: }
	ret
_ending_wait16:
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc0	; 192
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xbf	; 191
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x7f	; 127
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
;src/ending_walk.c:21: static void present(void) {
;	---------------------------------
; Function present
; ---------------------------------
_present:
	add	sp, #-7
;src/ending_walk.c:22: const EndingRun *run=ending_runs+run_index;
	ld	hl, #_run_index
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	ld	bc, #_ending_runs
	add	hl, bc
	ld	c, l
	ld	a, h
	ldhl	sp,	#2
	ld	(hl), c
	inc	hl
;src/ending_walk.c:23: const EndingAsset *image=ending_images+run->image;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	a, #<(_ending_images)
	add	a, l
	ld	e, a
	ld	a, #>(_ending_images)
	adc	a, h
	ldhl	sp,	#5
	ld	(hl), e
	inc	hl
	ld	(hl), a
;src/ending_walk.c:24: uint8_t palette=lighting?run->light:run->dark;
	ld	a, (#_lighting)
	or	a, a
	jr	Z, 00108$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	ld	a, (de)
	jr	00109$
00108$:
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	inc	de
	ld	a, (de)
00109$:
	ldhl	sp,	#4
	ld	(hl), a
;src/ending_walk.c:25: if(run->image!=current_image) {
	ld	hl, #_current_image
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00140$
	inc	hl
	ld	a, (hl)
	sub	a, b
	jr	Z, 00104$
00140$:
;src/ending_walk.c:26: pending_palette=palette;ending_walk_busy=1;
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(#_pending_palette),a
	ld	hl, #_ending_walk_busy
	ld	(hl), #0x01
;src/ending_walk.c:27: ending_upload_begin(image->bank,image->data,current_image==65535u?0u:ending_upload_buffer^1u);
	ld	a, (_current_image)
	ld	c, a
	ld	hl, #_current_image + 1
	ld	a, c
	and	a, (hl)
	inc	a
	jr	Z, 00111$
	ld	a, (#_ending_upload_buffer)
	xor	a, #0x01
00111$:
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	inc	hl
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ldhl	sp,#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	af
	ld	a, (de)
	ld	l, a
	inc	sp
	ld	e, c
	ld	d, b
	ld	a, l
	call	_ending_upload_begin
	jr	00105$
00104$:
;src/ending_walk.c:28: } else if(palette!=current_palette) {
	ld	a, (#_current_palette)
	ldhl	sp,	#4
	sub	a, (hl)
	jr	Z, 00105$
;src/ending_walk.c:29: set_bkg_palette(0,7,ending_palettes[palette]);current_palette=palette;
	ldhl	sp,	#4
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	add	hl, hl
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #_ending_palettes
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(#_current_palette),a
00105$:
;src/ending_walk.c:31: run_left=run->duration;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	(#_run_left),a
;src/ending_walk.c:32: }
	add	sp, #7
	ret
;src/ending_walk.c:33: static void sound(void) {
;	---------------------------------
; Function sound
; ---------------------------------
_sound:
;src/ending_walk.c:34: if(ending_wait16[ending_walk_frame>>3]&(1u<<(ending_walk_frame&7u)))game_transition_vint16();
	ld	bc, #_ending_wait16+0
	ld	hl, #_ending_walk_frame
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	srl	d
	rr	e
	srl	d
	rr	e
	srl	d
	rr	e
	ld	l, e
	ld	h, d
	add	hl, bc
	ld	c, (hl)
	ld	a, (_ending_walk_frame)
	and	a, #0x07
	ld	b, a
	ld	hl, #0x0001
	inc	b
	jr	00130$
00129$:
	add	hl, hl
00130$:
	dec	b
	jr	NZ,00129$
	ld	a, c
	and	a, l
	ld	c, #0x00
	or	a, c
	jr	Z, 00102$
	ld	e, #b_game_transition_vint16
	ld	hl, #_game_transition_vint16
	call	___sdcc_bcall_ehl
00102$:
;src/ending_walk.c:35: if(sound_index<ENDING_SOUND_COUNT&&ending_sounds[sound_index].frame==ending_walk_frame)
	ld	hl, #_sound_index
	ld	a, (hl)
	sub	a, #0x07
	ret	NC
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #_ending_sounds
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #_ending_walk_frame
	ld	a, (hl)
	sub	a, c
	ret	NZ
	inc	hl
	ld	a, (hl)
	sub	a, b
	ret	NZ
;src/ending_walk.c:36: audio_command(ending_sounds[sound_index++].command);
	ld	a, (_sound_index)
	ld	c, a
	ld	hl, #_sound_index
	inc	(hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	de, #_ending_sounds
	add	hl, de
	inc	hl
	inc	hl
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/ending_walk.c:37: }
	ret
;src/ending_walk.c:38: void ending_walk_begin(uint8_t light) __banked {
;	---------------------------------
; Function ending_walk_begin
; ---------------------------------
	b_ending_walk_begin	= 136
_ending_walk_begin::
;src/ending_walk.c:39: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;dungeon_invalidate_view_cache();
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	call	_dungeon_invalidate_view_cache
;src/ending_walk.c:40: ending_walk_frame=0;run_index=0;current_image=65535u;lighting=light!=0u;
	xor	a, a
	ld	hl, #_ending_walk_frame
	ld	(hl+), a
	ld	(hl), a
	xor	a, a
	ld	hl, #_run_index
	ld	(hl+), a
	ld	(hl), a
	ld	hl, #_current_image
	ld	a, #0xff
	ld	(hl+), a
	ld	(hl), #0xff
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	(#_lighting),a
;src/ending_walk.c:41: sound_index=0;current_palette=255u;active=1;ending_walk_busy=0;
	xor	a, a
	ld	(#_sound_index),a
	ld	hl, #_current_palette
	ld	(hl), #0xff
	ld	hl, #_active
	ld	(hl), #0x01
;src/ending_walk.c:42: ending_upload_fault=0;sound();present();while(!ending_upload_step());commit();SHOW_BKG;DISPLAY_ON;
	xor	a, a
	ld	(#_ending_walk_busy), a
	ld	(#_ending_upload_fault),a
	call	_sound
	call	_present
00101$:
	call	_ending_upload_step
	or	a, a
	jr	Z, 00101$
	call	_commit
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/ending_walk.c:43: }
	ret
;src/ending_walk.c:44: uint8_t ending_walk_tick(void) __banked {
;	---------------------------------
; Function ending_walk_tick
; ---------------------------------
	b_ending_walk_tick	= 136
_ending_walk_tick::
;src/ending_walk.c:45: if(!active)return 1;
	ld	a, (#_active)
	or	a, a
	jr	NZ, 00102$
	ld	a, #0x01
	ret
00102$:
;src/ending_walk.c:46: if(ending_walk_busy){if(ending_upload_step())commit();return 0;}
	ld	a, (#_ending_walk_busy)
	or	a, a
	jr	Z, 00106$
	call	_ending_upload_step
	or	a, a
	jr	Z, 00104$
	call	_commit
00104$:
	xor	a, a
	ret
00106$:
;src/ending_walk.c:47: if(++ending_walk_frame==ENDING_WALK_FRAMES) {
	ld	hl, #_ending_walk_frame
	inc	(hl)
	jr	NZ, 00165$
	inc	hl
	inc	(hl)
00165$:
	ld	a, (_ending_walk_frame)
	ld	c, a
	ld	hl, #_ending_walk_frame + 1
	ld	b, (hl)
	ld	a, c
	sub	a, #0xab
	jr	NZ, 00108$
	ld	a, b
	sub	a, #0x0d
	jr	NZ, 00108$
;src/ending_walk.c:48: ending_upload_home();active=0;dungeon_invalidate_view_cache();return 1;
	call	_ending_upload_home
	xor	a, a
	ld	(#_active),a
	call	_dungeon_invalidate_view_cache
	ld	a, #0x01
	ret
00108$:
;src/ending_walk.c:50: sound();
	call	_sound
;src/ending_walk.c:51: if(!--run_left){
	ld	hl, #_run_left
	dec	(hl)
	jr	NZ, 00113$
;src/ending_walk.c:52: ++run_index;present();
	ld	hl, #_run_index
	inc	(hl)
	jr	NZ, 00168$
	inc	hl
	inc	(hl)
00168$:
	call	_present
;src/ending_walk.c:55: if(ending_walk_busy&&ending_upload_step())commit();
	ld	a, (#_ending_walk_busy)
	or	a, a
	jr	Z, 00113$
	call	_ending_upload_step
	or	a, a
	jr	Z, 00113$
	call	_commit
00113$:
;src/ending_walk.c:57: return 0;
	xor	a, a
;src/ending_walk.c:58: }
	ret
	.area _CODE_136
	.area _INITIALIZER
	.area _CABS (ABS)
