;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_present
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_game_transition_fade_in
	.globl _game_transition_fade_in
	.globl b_game_transition_fade_out
	.globl _game_transition_fade_out
	.globl b_game_transition_vint16
	.globl _game_transition_vint16
	.globl b_scene_fade_begin
	.globl _scene_fade_begin
	.globl b_audio_command
	.globl _audio_command
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_scene_palette_capture
	.globl _scene_palette_capture
	.globl b_scene_palette_commit
	.globl _scene_palette_commit
	.globl b_dungeon_motion_turn_sequence
	.globl _dungeon_motion_turn_sequence
	.globl b_dungeon_motion_sequence_frame
	.globl _dungeon_motion_sequence_frame
	.globl _dungeon_motion_external_view
	.globl _dungeon_motion_home
	.globl b_dungeon_motion_render_image
	.globl _dungeon_motion_render_image
	.globl b_dungeon_motion_render
	.globl _dungeon_motion_render
	.globl b_dungeon_motion_door_image
	.globl _dungeon_motion_door_image
	.globl b_dungeon_motion_scene
	.globl _dungeon_motion_scene
	.globl _dungeon_motion_invalidate
	.globl _set_bkg_palette
	.globl _vmemset
	.globl _set_bkg_data
	.globl _display_off
	.globl _vsync
	.globl b_dungeon_present_prepare
	.globl _dungeon_present_prepare
	.globl b_dungeon_present_frame
	.globl _dungeon_present_frame
	.globl b_dungeon_present_sequence
	.globl _dungeon_present_sequence
	.globl b_dungeon_present_turn
	.globl _dungeon_present_turn
	.globl b_dungeon_present_door
	.globl _dungeon_present_door
	.globl b_dungeon_present_transition
	.globl _dungeon_present_transition
	.globl b_dungeon_present_fall
	.globl _dungeon_present_fall
	.globl b_dungeon_present_scene_fall
	.globl _dungeon_present_scene_fall
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
	.area _CODE_17
;src/dungeon_present.c:13: static void wait_frames(uint8_t count) {while(count--)vsync();}
;	---------------------------------
; Function wait_frames
; ---------------------------------
_wait_frames:
	ld	c, a
00101$:
	ld	a, c
	dec	c
	or	a, a
	ret	Z
	call	_vsync
	jr	00101$
;src/dungeon_present.c:14: void dungeon_present_prepare(const DungeonState *s) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_present_prepare
; ---------------------------------
	b_dungeon_present_prepare	= 17
_dungeon_present_prepare::
;src/dungeon_present.c:15: HIDE_WIN;HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/dungeon_present.c:16: if(scene_actor_active){dungeon_motion_invalidate();scene_actor_hide();}
	ld	a, (#_scene_actor_active)
	or	a, a
	jr	Z, 00102$
	call	_dungeon_motion_invalidate
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
00102$:
;src/dungeon_present.c:17: if(background_changed||!dungeon_motion_active) {
	ld	a, (#_background_changed)
	or	a, a
	jr	NZ, 00103$
	ld	a, (#_dungeon_motion_active)
	or	a, a
	ret	NZ
00103$:
;src/dungeon_present.c:18: dungeon_motion_invalidate();background_changed=0;dungeon_motion_render(s,0);
	call	_dungeon_motion_invalidate
	xor	a, a
	ld	(#_background_changed), a
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_motion_render
	ld	hl, #_dungeon_motion_render
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_present.c:20: }
	ret
;src/dungeon_present.c:21: void dungeon_present_frame(const DungeonState *s,uint8_t frame) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_present_frame
; ---------------------------------
	b_dungeon_present_frame	= 17
_dungeon_present_frame::
;src/dungeon_present.c:22: dungeon_motion_render(s,frame);
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_motion_render
	ld	hl, #_dungeon_motion_render
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_present.c:26: if(!frame)vsync();
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jp	Z, _vsync
;src/dungeon_present.c:27: }
	ret
;src/dungeon_present.c:28: void dungeon_present_sequence(const DungeonState *s,uint8_t sequence) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_present_sequence
; ---------------------------------
	b_dungeon_present_sequence	= 17
_dungeon_present_sequence::
;src/dungeon_present.c:30: for(i=0;i<9u;++i) {
	ld	b, #0x00
00104$:
;src/dungeon_present.c:31: frame=dungeon_motion_sequence_frame(sequence,i);if(frame==255u)break;
	push	bc
	push	bc
	inc	sp
	ldhl	sp,	#11
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_dungeon_motion_sequence_frame
	ld	hl, #_dungeon_motion_sequence_frame
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	cp	a, #0xff
	ret	Z
;src/dungeon_present.c:32: dungeon_present_frame(s,frame);
	push	bc
	push	af
	inc	sp
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_frame
	ld	hl, #_dungeon_present_frame
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
;src/dungeon_present.c:30: for(i=0;i<9u;++i) {
	inc	b
	ld	a, b
	sub	a, #0x09
	jr	C, 00104$
;src/dungeon_present.c:34: }
	ret
;src/dungeon_present.c:35: void dungeon_present_turn(const DungeonState *s,uint8_t right) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_present_turn
; ---------------------------------
	b_dungeon_present_turn	= 17
_dungeon_present_turn::
;src/dungeon_present.c:36: dungeon_present_sequence(s,dungeon_motion_turn_sequence(s,right));
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_motion_turn_sequence
	ld	hl, #_dungeon_motion_turn_sequence
	call	___sdcc_bcall_ehl
	add	sp, #3
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_sequence
	ld	hl, #_dungeon_present_sequence
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_present.c:37: }
	ret
;src/dungeon_present.c:38: void dungeon_present_door(const DungeonState *s,uint8_t style) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_present_door
; ---------------------------------
	b_dungeon_present_door	= 17
_dungeon_present_door::
	dec	sp
	dec	sp
;src/dungeon_present.c:39: uint8_t i;if(style<2u||style>4u)return;
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00107$
	ld	a, #0x04
	sub	a, (hl)
	jr	C, 00107$
;src/dungeon_present.c:40: audio_command(0xbd);
	ld	a, #0xbd
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/dungeon_present.c:41: for(i=0;i<3u;++i) {
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0006
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	c, #0x00
00105$:
;src/dungeon_present.c:42: dungeon_motion_render_image(dungeon_motion_door_image(style+i*3u),s->palette_index);
	pop	de
	push	de
	ld	a, (de)
	ld	b, a
	ld	a, c
	add	a, a
	add	a, c
	ldhl	sp,	#10
	add	a, (hl)
	push	bc
	push	af
	inc	sp
	ld	e, #b_dungeon_motion_door_image
	ld	hl, #_dungeon_motion_door_image
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, c
	ld	d, b
	pop	bc
	push	bc
	push	bc
	inc	sp
	push	de
	ld	e, #b_dungeon_motion_render_image
	ld	hl, #_dungeon_motion_render_image
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_present.c:43: wait_frames(4u);
	ld	a, #0x04
	call	_wait_frames
	pop	bc
;src/dungeon_present.c:41: for(i=0;i<3u;++i) {
	inc	c
	ld	a, c
	sub	a, #0x03
	jr	C, 00105$
;src/dungeon_present.c:45: dungeon_motion_home();
	inc	sp
	inc	sp
	jp	_dungeon_motion_home
00107$:
;src/dungeon_present.c:46: }
	inc	sp
	inc	sp
	ret
;src/dungeon_present.c:47: void dungeon_present_transition(const DungeonState *s,uint8_t stairs) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_present_transition
; ---------------------------------
	b_dungeon_present_transition	= 17
_dungeon_present_transition::
;src/dungeon_present.c:48: if(stairs)audio_command(0xc3);
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	ld	a, #0xc3
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00102$:
;src/dungeon_present.c:49: game_transition_fade_out();
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
;src/dungeon_present.c:50: dungeon_motion_palette_muted=1;dungeon_motion_render(s,0);dungeon_motion_palette_muted=0;
	ld	hl, #_dungeon_motion_palette_muted
	ld	(hl), #0x01
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_motion_render
	ld	hl, #_dungeon_motion_render
	call	___sdcc_bcall_ehl
	add	sp, #3
	xor	a, a
	ld	(#_dungeon_motion_palette_muted),a
;src/dungeon_present.c:51: DISPLAY_OFF;set_bkg_palette(0u,7u,(const uint16_t *)dungeon_render_palette);
	call	_display_off
	ld	de, #_dungeon_render_palette
	push	de
	ld	hl, #0x700
	push	hl
	call	_set_bkg_palette
	add	sp, #4
;src/dungeon_present.c:52: scene_fade_begin(1u);DISPLAY_ON;
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_scene_fade_begin
	ld	hl, #_scene_fade_begin
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/dungeon_present.c:53: game_transition_fade_in();
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
;src/dungeon_present.c:54: }
	jp  ___sdcc_bcall_ehl
;src/dungeon_present.c:55: static void fill_map(uint16_t base,uint8_t first,uint8_t rows,uint8_t tile,uint8_t attr) {
;	---------------------------------
; Function fill_map
; ---------------------------------
_fill_map:
;src/dungeon_present.c:56: uint16_t address=base+(uint16_t)first*32u,count=(uint16_t)rows*32u;
	ld	l, a
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	d, h
;src/dungeon_present.c:57: VBK_REG=0;vmemset((void *)address,tile,count);VBK_REG=1;vmemset((void *)address,attr,count);VBK_REG=0;
	xor	a, a
	ldh	(_VBK_REG + 0), a
	push	de
	push	de
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	call	_vmemset
	add	sp, #5
	pop	de
	ld	a, #0x01
	ldh	(_VBK_REG + 0), a
	push	de
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	call	_vmemset
	add	sp, #5
	ld	a, #0x00
	ldh	(_VBK_REG + 0), a
;src/dungeon_present.c:58: }
	pop	hl
	add	sp, #3
	jp	(hl)
;src/dungeon_present.c:59: static uint8_t black_tile(uint8_t tile,uint8_t bank) {
;	---------------------------------
; Function black_tile
; ---------------------------------
_black_tile:
	add	sp, #-8
	ldhl	sp,	#6
	ld	(hl-), a
;src/dungeon_present.c:60: uint8_t i,code;uint8_t *bytes=(uint8_t *)scene_shared_colors;
;src/dungeon_present.c:61: for(i=0;i<28u;++i)if(!((uint16_t *)dungeon_render_palette)[i])break;
	ld	a, e
	ld	(hl+), a
	inc	hl
	ld	(hl), #0x00
00105$:
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#3
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
	ld	hl, #_dungeon_render_palette
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
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl-)
	or	a, (hl)
	jr	Z, 00122$
	ldhl	sp,	#7
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x1c
	jr	C, 00105$
00122$:
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
;src/dungeon_present.c:62: code=i&3u;
	ldhl	sp,	#7
	ld	a, (hl)
	and	a, #0x03
;src/dungeon_present.c:63: for(uint8_t row=0;row<8u;++row){bytes[row*2u]=(code&1u)?255u:0u;bytes[row*2u+1u]=(code&2u)?255u:0u;}
	push	af
	and	a, #0x01
	ldhl	sp,	#3
	ld	(hl+), a
	pop	af
	and	a, #0x02
	ld	(hl), a
	ldhl	sp,	#7
	ld	(hl), #0x00
00108$:
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x08
	jr	NC, 00104$
	ld	c, (hl)
	xor	a, a
	ld	b, a
	sla	c
	rl	b
	ld	hl, #_scene_shared_colors
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	ld	a, #0xff
	jr	NZ, 00113$
	xor	a, a
00113$:
	ld	(de), a
	inc	bc
	ld	hl, #_scene_shared_colors
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, a
	ld	a, #0xff
	jr	NZ, 00115$
	xor	a, a
00115$:
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#7
	inc	(hl)
	jr	00108$
00104$:
;src/dungeon_present.c:64: VBK_REG=bank;set_bkg_data(tile,1u,bytes);VBK_REG=0;return (i>>2)|(bank<<3);
	ldhl	sp,	#5
	ld	a, (hl+)
	ldh	(_VBK_REG + 0), a
	ld	de, #_scene_shared_colors
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	call	_set_bkg_data
	add	sp, #4
	xor	a, a
	ldh	(_VBK_REG + 0), a
	ldhl	sp,	#0
	ld	c, (hl)
	srl	c
	srl	c
	ldhl	sp,	#5
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	or	a, c
;src/dungeon_present.c:65: }
	add	sp, #8
	ret
;src/dungeon_present.c:66: static void fall(const DungeonState *s,uint8_t room) {
;	---------------------------------
; Function fall
; ---------------------------------
_fall:
	add	sp, #-8
	ldhl	sp,	#5
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
	ld	(hl), a
;src/dungeon_present.c:67: uint8_t i,old_black,new_black,old_tile=room?127u:242u;
	ld	a, (hl)
	or	a, a
	ld	a, #0x7f
	jr	NZ, 00133$
	ld	a, #0xf2
00133$:
	ldhl	sp,	#2
;src/dungeon_present.c:70: if(room) {
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
;src/dungeon_present.c:71: HIDE_WIN;HIDE_SPRITES;vsync();
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	call	_vsync
;src/dungeon_present.c:72: scene_palette_capture();
	ld	e, #b_scene_palette_capture
	ld	hl, #_scene_palette_capture
	call	___sdcc_bcall_ehl
;src/dungeon_present.c:73: for(i=0;i<28u;++i)((uint16_t *)dungeon_render_palette)[i]=scene_palette_background[i];
	ldhl	sp,	#7
	ld	(hl), #0x00
00120$:
	ldhl	sp,	#7
	ld	c, (hl)
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	ld	a, l
	add	a, #<(_dungeon_render_palette)
	ld	c, a
	ld	a, h
	adc	a, #>(_dungeon_render_palette)
	ld	b, a
	ld	de, #_scene_palette_background
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,	#7
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x1c
	jr	C, 00120$
;src/dungeon_present.c:74: dungeon_motion_external_view();
	call	_dungeon_motion_external_view
;src/dungeon_present.c:75: LCDC_REG&=(uint8_t)~LCDCF_BG9C00;move_bkg(0,0);
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xf7
	ldh	(_LCDC_REG + 0), a
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/dungeon_present.c:75: LCDC_REG&=(uint8_t)~LCDCF_BG9C00;move_bkg(0,0);
	jr	00104$
00103$:
;src/dungeon_present.c:76: } else dungeon_motion_home();
	call	_dungeon_motion_home
00104$:
;src/dungeon_present.c:81: old_black=black_tile(old_tile,room);
	ldhl	sp,	#4
	ld	a, (hl-)
	dec	hl
	ld	e, a
	ld	a, (hl)
	call	_black_tile
;src/dungeon_present.c:82: fill_map(0x9800u,15u,17u,old_tile,old_black);fill_map(0x9c00u,0u,18u,0u,15u);
	ldhl	sp,#3
	ld	(hl), a
	ld	a, (hl-)
	push	af
	inc	sp
	ld	h, (hl)
	ld	l, #0x11
	push	hl
	ld	a, #0x0f
	ld	de, #0x9800
	call	_fill_map
	ld	a, #0x0f
	push	af
	inc	sp
	ld	hl, #0x12
	push	hl
	xor	a, a
	ld	de, #0x9c00
	call	_fill_map
;src/dungeon_present.c:83: LCDC_REG|=LCDCF_WIN9C00;move_win(7u,120u);SHOW_WIN;audio_command(0xc0);
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x40
	ldh	(_LCDC_REG + 0), a
;../../../.tools/gbdk/include/gb/gb.h:1739: WX_REG=x, WY_REG=y;
	ld	a, #0x07
	ldh	(_WX_REG + 0), a
	ld	a, #0x78
	ldh	(_WY_REG + 0), a
;src/dungeon_present.c:83: LCDC_REG|=LCDCF_WIN9C00;move_win(7u,120u);SHOW_WIN;audio_command(0xc0);
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
	ld	a, #0xc0
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/dungeon_present.c:84: for(i=1u;i<=12u;++i){vsync();move_bkg(0,i*10u);}
	ldhl	sp,	#7
	ld	(hl), #0x01
00122$:
	call	_vsync
	ldhl	sp,	#7
	ld	l, (hl)
	ld	c, l
	add	hl, hl
	add	hl, hl
	add	hl, bc
	add	hl, hl
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	ld	a, l
	ldh	(_SCY_REG + 0), a
;src/dungeon_present.c:84: for(i=1u;i<=12u;++i){vsync();move_bkg(0,i*10u);}
	ldhl	sp,	#7
	inc	(hl)
	ld	a, #0x0c
	sub	a, (hl)
	jr	NC, 00122$
;src/dungeon_present.c:85: vsync();game_transition_vint16();
	call	_vsync
	ld	e, #b_game_transition_vint16
	ld	hl, #_game_transition_vint16
	call	___sdcc_bcall_ehl
;src/dungeon_present.c:88: if(room){
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
;src/dungeon_present.c:89: old_black=black_tile(242u,0u);black_tile(242u,1u);
	ld	e, #0x00
	ld	a, #0xf2
	call	_black_tile
	ldhl	sp,	#3
	ld	(hl), a
	ld	e, #0x01
	ld	a, #0xf2
	call	_black_tile
00107$:
;src/dungeon_present.c:94: fill_map(0x9800u,0u,32u,242u,old_black);LCDC_REG&=(uint8_t)~LCDCF_WIN9C00;move_win(7u,0u);
	ldhl	sp,	#3
	ld	h, (hl)
	ld	l, #0xf2
	push	hl
	ld	a, #0x20
	push	af
	inc	sp
	xor	a, a
	ld	de, #0x9800
	call	_fill_map
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xbf
	ldh	(_LCDC_REG + 0), a
;../../../.tools/gbdk/include/gb/gb.h:1739: WX_REG=x, WY_REG=y;
	ld	a, #0x07
	ldh	(_WX_REG + 0), a
	xor	a, a
	ldh	(_WY_REG + 0), a
;src/dungeon_present.c:95: dungeon_motion_palette_muted=1;
	ld	hl, #_dungeon_motion_palette_muted
	ld	(hl), #0x01
;src/dungeon_present.c:96: dungeon_motion_render_image(dungeon_motion_scene(s,0),s->palette_index);
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	d, a
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#8
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	e, #b_dungeon_motion_scene
	ld	hl, #_dungeon_motion_scene
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	push	de
	inc	sp
	push	bc
	ld	e, #b_dungeon_motion_render_image
	ld	hl, #_dungeon_motion_render_image
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_present.c:97: dungeon_motion_palette_muted=0;
	xor	a, a
	ld	(#_dungeon_motion_palette_muted),a
;src/dungeon_present.c:98: new_black=black_tile(243u,0u);fill_map(0x9c00u,15u,17u,243u,new_black);
	ld	e, #0x00
	ld	a, #0xf3
	call	_black_tile
	ld	h, a
	ld	l, #0xf3
	push	hl
	ld	a, #0x11
	push	af
	inc	sp
	ld	a, #0x0f
	ld	de, #0x9c00
	call	_fill_map
;src/dungeon_present.c:102: scene_palette_capture();
	ld	e, #b_scene_palette_capture
	ld	hl, #_scene_palette_capture
	call	___sdcc_bcall_ehl
;src/dungeon_present.c:103: for(i=0;i<28u;++i)scene_palette_background[i]=((uint16_t *)dungeon_render_palette)[i];
	ldhl	sp,	#7
	ld	(hl), #0x00
00124$:
	ldhl	sp,	#7
	ld	c, (hl)
	xor	a, a
	ld	b, a
	sla	c
	rl	b
	ld	hl, #_scene_palette_background
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	hl, #_dungeon_render_palette
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#7
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x1c
	jr	C, 00124$
;src/dungeon_present.c:104: scene_palette_commit();move_bkg(0,136u);HIDE_WIN;
	ld	e, #b_scene_palette_commit
	ld	hl, #_scene_palette_commit
	call	___sdcc_bcall_ehl
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	ld	a, #0x88
	ldh	(_SCY_REG + 0), a
;src/dungeon_present.c:104: scene_palette_commit();move_bkg(0,136u);HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;src/dungeon_present.c:105: fill_map(0x9800u,0u,18u,0u,15u);
	ld	a, #0x0f
	push	af
	inc	sp
	ld	hl, #0x12
	push	hl
	xor	a, a
	ld	de, #0x9800
	call	_fill_map
;src/dungeon_present.c:106: vsync();move_win(7u,120u);SHOW_WIN;
	call	_vsync
;../../../.tools/gbdk/include/gb/gb.h:1739: WX_REG=x, WY_REG=y;
	ld	a, #0x07
	ldh	(_WX_REG + 0), a
	ld	a, #0x78
	ldh	(_WY_REG + 0), a
;src/dungeon_present.c:106: vsync();move_win(7u,120u);SHOW_WIN;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x20
	ldh	(_LCDC_REG + 0), a
;src/dungeon_present.c:107: for(i=0u;i<12u;++i){vsync();move_bkg(0,136u+i*10u);}
	ld	c, #0x00
00126$:
	call	_vsync
	ld	a, c
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	add	a, #0x88
	ld	b, a
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	ld	a, b
	ldh	(_SCY_REG + 0), a
;src/dungeon_present.c:107: for(i=0u;i<12u;++i){vsync();move_bkg(0,136u+i*10u);}
	inc	c
	ld	a, c
	sub	a, #0x0c
	jr	C, 00126$
;src/dungeon_present.c:108: for(i=0u;i<5u;++i){vsync();move_bkg(0,(i&1u)?251u:0u);}
	ld	c, #0x00
00128$:
	call	_vsync
	bit	0, c
	jr	Z, 00134$
	ld	b, #0xfb
	jr	00135$
00134$:
	ld	b, #0x00
00135$:
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	ld	a, b
	ldh	(_SCY_REG + 0), a
;src/dungeon_present.c:108: for(i=0u;i<5u;++i){vsync();move_bkg(0,(i&1u)?251u:0u);}
	inc	c
	ld	a, c
	sub	a, #0x05
	jr	C, 00128$
;src/dungeon_present.c:109: vsync();
	call	_vsync
;src/dungeon_present.c:110: fill_map(0x9c00u,15u,3u,0u,15u);HIDE_WIN;
	ld	a, #0x0f
	push	af
	inc	sp
	ld	hl, #0x03
	push	hl
	ld	a, #0x0f
	ld	de, #0x9c00
	call	_fill_map
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;src/dungeon_present.c:113: LCDC_REG|=LCDCF_WIN9C00;dungeon_motion_home();move_bkg(0,0);
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x40
	ldh	(_LCDC_REG + 0), a
	call	_dungeon_motion_home
;../../../.tools/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/dungeon_present.c:113: LCDC_REG|=LCDCF_WIN9C00;dungeon_motion_home();move_bkg(0,0);
;src/dungeon_present.c:114: }
	add	sp, #8
	ret
;src/dungeon_present.c:115: void dungeon_present_fall(const DungeonState *s) DUNGEON_BANKED {fall(s,0u);}
;	---------------------------------
; Function dungeon_present_fall
; ---------------------------------
	b_dungeon_present_fall	= 17
_dungeon_present_fall::
	xor	a, a
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	jp	_fall
;src/dungeon_present.c:116: void dungeon_present_scene_fall(const DungeonState *s) DUNGEON_BANKED {fall(s,1u);}
;	---------------------------------
; Function dungeon_present_scene_fall
; ---------------------------------
	b_dungeon_present_scene_fall	= 17
_dungeon_present_scene_fall::
	ld	a, #0x01
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	jp	_fall
	.area _CODE_17
	.area _INITIALIZER
	.area _CABS (ABS)
