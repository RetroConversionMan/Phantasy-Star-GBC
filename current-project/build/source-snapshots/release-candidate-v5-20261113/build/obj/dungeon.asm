;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl _bank_copy
	.globl _bank_read8
	.globl b_dungeon_refresh_light
	.globl _dungeon_refresh_light
	.globl b_dungeon_load_floor
	.globl _dungeon_load_floor
	.globl b_dungeon_enter
	.globl _dungeon_enter
	.globl b_dungeon_sample_position
	.globl _dungeon_sample_position
	.globl b_dungeon_sample
	.globl _dungeon_sample
	.globl b_dungeon_find_object
	.globl _dungeon_find_object
	.globl b_dungeon_active_object
	.globl _dungeon_active_object
	.globl b_dungeon_transition
	.globl _dungeon_transition
	.globl b_dungeon_step
	.globl _dungeon_step
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
;src/dungeon.c:5: static uint8_t object_record(uint8_t floor,uint8_t position,DungeonObject *object) {
;	---------------------------------
; Function object_record
; ---------------------------------
_object_record:
	add	sp, #-11
	ldhl	sp,	#10
	ld	(hl-), a
	ld	(hl), e
;src/dungeon.c:7: for(i=0;i<DUNGEON_OBJECT_COUNT;++i) {
	ld	c, #0x00
00105$:
;src/dungeon.c:8: bank_copy(row,DUNGEON_DATA_BANK,dungeon_objects+(uint16_t)i*7u,7u);
	ld	l, c
	ld	h, #0x00
	ld	e, l
	ld	d, h
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, de
	ld	de, #_dungeon_objects
	add	hl, de
	push	bc
	ld	de, #0x0007
	push	de
	push	hl
	ld	a, #0x10
	ld	hl, #6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
	pop	bc
;src/dungeon.c:9: if(row[0]==floor && row[1]==position) {
	ldhl	sp,	#0
	ld	b, (hl)
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, b
	jr	NZ, 00106$
	ldhl	sp,	#1
	ld	b, (hl)
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, b
	jr	NZ, 00106$
;src/dungeon.c:10: object->flag_address=(uint16_t)row[2]|((uint16_t)row[3]<<8);
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	ld	hl,#0x2
	add	hl,sp
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl+), a
	ld	(hl), #0x00
	ld	hl,#0x3
	add	hl,sp
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	ldhl	sp,	#9
	ld	a, (hl)
	pop	hl
	ld	(de), a
	inc	de
	ld	a, h
	ld	(de), a
;src/dungeon.c:11: object->type=row[4];object->a=row[5];object->b=row[6];object->position=position;
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	hl, #4
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	hl, #5
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
	ld	hl, #0x0004
	add	hl, bc
	ld	e, l
	ld	d, h
	ld	hl, #6
	add	hl, sp
	ld	a, (hl)
	ld	(de), a
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ldhl	sp,	#9
	ld	a, (hl)
	ld	(bc), a
;src/dungeon.c:12: return 1;
	ld	a, #0x01
	jr	00107$
00106$:
;src/dungeon.c:7: for(i=0;i<DUNGEON_OBJECT_COUNT;++i) {
	inc	c
	ld	a, c
	sub	a, #0xba
	jp	C, 00105$
;src/dungeon.c:15: return 0;
	xor	a, a
00107$:
;src/dungeon.c:16: }
	add	sp, #11
	pop	hl
	pop	bc
	jp	(hl)
;src/dungeon.c:17: void dungeon_refresh_light(DungeonState *state) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_refresh_light
; ---------------------------------
	b_dungeon_refresh_light	= 17
_dungeon_refresh_light::
	add	sp, #-13
;src/dungeon.c:18: uint8_t info[4],lit[6],i,natural=0;
	ldhl	sp,	#10
	ld	(hl), #0x00
;src/dungeon.c:19: bank_copy(info,DUNGEON_DATA_BANK,dungeon_floor_info+(uint16_t)state->floor*4u,4u);
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ld	de, #_dungeon_floor_info
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x0004
	push	de
	push	bc
	ld	a, #0x10
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/dungeon.c:20: state->encounter_rate=info[0];state->encounter_pool=info[1];state->music=info[3];
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#1
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#3
	ld	a, (hl)
	ld	(bc), a
;src/dungeon.c:21: bank_copy(lit,DUNGEON_DATA_BANK,dungeon_naturally_lit,6u);
	ld	de, #0x0006
	push	de
	ld	de, #_dungeon_naturally_lit
	push	de
	ld	a, #0x10
	ld	hl, #8
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/dungeon.c:22: for(i=0;i<6u;++i) if(lit[i]==state->floor) natural=1;
	ld	c, #0x00
00104$:
	ld	e, c
	ld	d, #0x00
	ld	hl, #4
	add	hl, sp
	add	hl, de
	ld	b, (hl)
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, b
	jr	NZ, 00105$
	dec	hl
	dec	hl
	ld	(hl), #0x01
00105$:
	inc	c
	ld	a, c
	sub	a, #0x06
	jr	C, 00104$
;src/dungeon.c:23: state->light=(state->light || natural)?info[2]+1u:0u;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	or	a, a
	jr	NZ, 00111$
	ldhl	sp,	#10
	ld	a, (hl)
	or	a, a
	jr	Z, 00108$
00111$:
	ldhl	sp,	#2
	ld	a, (hl)
	inc	a
	jr	00109$
00108$:
	xor	a, a
00109$:
	ld	e, a
	ld	(bc), a
;src/dungeon.c:24: state->palette_index=state->light;
	push	de
	ldhl	sp,#21
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, e
	ld	(bc), a
;src/dungeon.c:25: }
	add	sp, #13
	ret
;src/dungeon.c:26: uint8_t dungeon_load_floor(DungeonState *state,uint8_t floor) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_load_floor
; ---------------------------------
	b_dungeon_load_floor	= 17
_dungeon_load_floor::
	add	sp, #-128
	add	sp, #-9
;src/dungeon.c:28: if(floor>=DUNGEON_FLOOR_COUNT) return 0;
	ld	hl, #145
	add	hl, sp
	ld	a, (hl)
	sub	a, #0x3d
	jr	C, 00102$
	xor	a, a
	jp	00106$
00102$:
;src/dungeon.c:29: bank_copy(raw,DUNGEON_DATA_BANK,dungeon_layouts+(uint16_t)floor*128u,128u);
	ld	hl, #145
	add	hl, sp
	ld	b, (hl)
	xor	a, a
	ld	c, a
	srl	b
	rr	c
	ld	hl, #_dungeon_layouts
	add	hl, bc
	ld	c, l
	ld	b, h
	xor	a, a
	push	af
	push	bc
	ld	a, #0x10
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/dungeon.c:30: for(i=0;i<128u;++i) {
	ld	hl, #143
	add	hl, sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0008
	add	hl, bc
	push	hl
	ld	a, l
	ld	hl, #130
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #129
	add	hl, sp
	ld	(hl), a
	ld	hl, #136
	add	hl, sp
	ld	(hl), #0x00
00104$:
;src/dungeon.c:31: state->layout[(uint16_t)i*2u]=raw[i]>>4;
	ld	hl, #136
	add	hl, sp
	ld	e, (hl)
	xor	a, a
	sla	e
	adc	a, a
	ld	hl, #130
	add	hl, sp
	ld	(hl), e
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #128
	add	hl, sp
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #134
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #133
	add	hl, sp
	ld	(hl), a
	push	hl
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ld	hl, #136
	add	hl, sp
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #136
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #135
	add	hl, sp
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	swap	a
	and	a, #0x0f
	ld	hl, #132
	add	hl, sp
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/dungeon.c:32: state->layout[(uint16_t)i*2u+1u]=raw[i]&15u;
	ld	hl, #130
	add	hl, sp
	ld	a, (hl-)
	ld	e, a
	ld	d, #0x00
	inc	de
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ld	hl, #134
	add	hl, sp
	ld	(hl), a
	pop	hl
	ld	a, h
	ld	hl, #133
	add	hl, sp
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	and	a, #0x0f
	ld	hl, #132
	add	hl, sp
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/dungeon.c:30: for(i=0;i<128u;++i) {
	ld	hl, #136
	add	hl, sp
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x80
	jp	C, 00104$
;src/dungeon.c:34: state->floor=floor;dungeon_refresh_light(state);return 1;
	ld	hl, #145
	add	hl, sp
	ld	a, (hl)
	ld	(bc), a
	push	bc
	ld	e, #b_dungeon_refresh_light
	ld	hl, #_dungeon_refresh_light
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, #0x01
00106$:
;src/dungeon.c:35: }
	add	sp, #127
	add	sp, #10
	ret
;src/dungeon.c:36: uint8_t dungeon_enter(DungeonState *state,uint8_t floor,uint8_t position,uint8_t direction) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_enter
; ---------------------------------
	b_dungeon_enter	= 17
_dungeon_enter::
;src/dungeon.c:37: if(floor>=DUNGEON_FLOOR_COUNT || direction>3u) return 0;
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x3d
	jr	NC, 00101$
	inc	hl
	inc	hl
	ld	a, #0x03
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	xor	a, a
	ret
00102$:
;src/dungeon.c:38: memset(state,0,sizeof(*state));state->position=position;state->direction=direction;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0108
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	inc	hl
	ld	b, a
	ld	e, c
	ld	d, b
	inc	de
	ld	a, (hl+)
	ld	(de), a
	ld	e, c
	ld	d, b
	inc	de
	inc	de
;src/dungeon.c:39: return dungeon_load_floor(state,floor);
	ld	a, (hl-)
	dec	hl
	ld	(de), a
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_load_floor
	ld	hl, #_dungeon_load_floor
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon.c:40: }
	ret
;src/dungeon.c:41: uint8_t dungeon_sample_position(const DungeonState *state,uint8_t view) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_sample_position
; ---------------------------------
	b_dungeon_sample_position	= 17
_dungeon_sample_position::
;src/dungeon.c:43: if(view>15u) return state->position;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	ld	e, c
	ld	d, b
	inc	de
	ld	a, #0x0f
	sub	a, (hl)
	jr	NC, 00102$
	ld	a, (de)
	ret
00102$:
;src/dungeon.c:44: offset=bank_read8(DUNGEON_DATA_BANK,dungeon_view_offsets+(state->direction&3u)*16u+view);
	inc	bc
	inc	bc
	ld	a, (bc)
	and	a, #0x03
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #<(_dungeon_view_offsets)
	ld	c, a
	ld	a, h
	adc	a, #>(_dungeon_view_offsets)
	ld	b, a
	ldhl	sp,	#8
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	push	de
	ld	e, c
	ld	d, b
	ld	a, #0x10
	call	_bank_read8
	ld	c, a
	pop	de
;src/dungeon.c:45: return state->position+offset;
	ld	a, (de)
	add	a, c
;src/dungeon.c:46: }
	ret
;src/dungeon.c:47: uint8_t dungeon_sample(const DungeonState *state,uint8_t view) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_sample
; ---------------------------------
	b_dungeon_sample	= 17
_dungeon_sample::
;src/dungeon.c:48: return state->layout[dungeon_sample_position(state,view)]&127u;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0008
	add	hl, bc
	push	hl
	ldhl	sp,	#10
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	res	7, a
;src/dungeon.c:49: }
	ret
;src/dungeon.c:50: uint8_t dungeon_find_object(const DungeonState *state,uint8_t view,DungeonObject *object) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_find_object
; ---------------------------------
	b_dungeon_find_object	= 17
_dungeon_find_object::
;src/dungeon.c:51: uint8_t position=dungeon_sample_position(state,view);
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	c, a
;src/dungeon.c:52: memset(object,0,sizeof(*object));
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	push	hl
	ld	l, h
	push	hl
	push	de
	call	_memset
	add	sp, #6
;src/dungeon.c:53: if((state->layout[position]&127u)!=8u) return 0;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	a, c
	add	a, l
	ld	l, a
	ld	a, #0x00
	adc	a, h
	ld	h, a
	ld	a, (hl)
	res	7, a
	sub	a, #0x08
	jr	Z, 00102$
	xor	a, a
	ret
00102$:
;src/dungeon.c:54: if(!object_record(state->floor,position,object)) return 0;
	ld	a, (de)
	ldhl	sp,	#9
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, c
	call	_object_record
	or	a,a
	ret	Z
;src/dungeon.c:55: object->view=view;return 1;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0006
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(bc), a
	ld	a, #0x01
;src/dungeon.c:56: }
	ret
;src/dungeon.c:57: uint8_t dungeon_active_object(const DungeonState *state,uint8_t view,
;	---------------------------------
; Function dungeon_active_object
; ---------------------------------
	b_dungeon_active_object	= 17
_dungeon_active_object::
;src/dungeon.c:60: if(!dungeon_find_object(state,view,object)) return 0;
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#10
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_find_object
	ld	hl, #_dungeon_find_object
	call	___sdcc_bcall_ehl
	add	sp, #5
	or	a,a
	ret	Z
;src/dungeon.c:61: if((object->flag_address>>8)==0xc5u) value=story_flags[(uint8_t)object->flag_address];
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ld	e, c
	sub	a, #0xc5
	jr	NZ, 00104$
	ld	d, a
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	jr	00105$
00104$:
;src/dungeon.c:62: else value=object_flags[(uint8_t)object->flag_address];
	ld	d, #0x00
	ldhl	sp,	#11
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
00105$:
;src/dungeon.c:63: return value!=255u;
	inc	a
	ld	a, #0x01
	jr	Z, 00125$
	xor	a, a
00125$:
	xor	a, #0x01
;src/dungeon.c:64: }
	ret
;src/dungeon.c:65: uint8_t dungeon_transition(const DungeonState *state,DungeonAction *action) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_transition
; ---------------------------------
	b_dungeon_transition	= 17
_dungeon_transition::
	add	sp, #-13
;src/dungeon.c:66: uint8_t position=dungeon_sample_position(state,1u),i,row[5];
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#20
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#7
	ld	(hl), a
;src/dungeon.c:67: memset(action,0,sizeof(*action));
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0008
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/dungeon.c:68: if(!(state->layout[position]&8u)) return 0;
	ldhl	sp,	#19
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	bit	3, (hl)
	jr	NZ, 00127$
	xor	a, a
	jp	00112$
;src/dungeon.c:69: for(i=0;i<DUNGEON_TRANSITION_COUNT;++i) {
00127$:
	ldhl	sp,	#12
	ld	(hl), #0x00
00110$:
;src/dungeon.c:70: bank_copy(row,DUNGEON_DATA_BANK,dungeon_transitions+(uint16_t)i*5u,5u);
	ldhl	sp,	#12
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	de, #_dungeon_transitions
	pop	hl
	push	hl
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	de, #0x0005
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, #0x10
	ld	hl, #6
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_bank_copy
;src/dungeon.c:71: if(row[0]==state->floor && row[1]==position) {
	ldhl	sp,	#2
	ld	c, (hl)
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, c
	jp	NZ, 00111$
	ldhl	sp,	#3
	ld	c, (hl)
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00111$
;src/dungeon.c:72: action->target=row[2];action->a=row[3];action->b=row[4];
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	ldhl	sp,	#5
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ldhl	sp,	#6
;src/dungeon.c:73: if(row[2]<128u) action->mode=DUNGEON_MAP;
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	ld	a, (hl)
	ldhl	sp,	#9
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	sub	a, #0x80
	jr	NC, 00104$
	ld	a, #0x08
	ld	(bc), a
	jr	00105$
00104$:
;src/dungeon.c:75: action->mode=DUNGEON_INTERACTION;
	ld	a, #0x0c
	ld	(bc), a
;src/dungeon.c:77: action->interaction=row[2]==255u?15u:row[2]==254u?13u:row[2]==253u?30u:255u;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#4
	ld	a, (hl)
	cp	a, #0xff
	jr	NZ, 00114$
	ld	a, #0x0f
	jr	00115$
00114$:
	cp	a, #0xfe
	jr	NZ, 00116$
	ld	a, #0x0d
	jr	00117$
00116$:
	sub	a, #0xfd
	ld	a, #0x1e
	jr	Z, 00119$
	ld	a, #0xff
00119$:
00117$:
00115$:
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00105$:
;src/dungeon.c:79: return action->mode;
	ld	a, (bc)
	jr	00112$
00111$:
;src/dungeon.c:69: for(i=0;i<DUNGEON_TRANSITION_COUNT;++i) {
	ldhl	sp,	#12
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x41
	jp	C, 00110$
;src/dungeon.c:82: action->mode=DUNGEON_EXIT_SAVED;return action->mode;
	ldhl	sp,	#21
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x0d
	ld	(hl),a
00112$:
;src/dungeon.c:83: }
	add	sp, #13
	ret
;src/dungeon.c:84: uint8_t dungeon_step(DungeonState *state,uint8_t command,DungeonAction *action) DUNGEON_BANKED {
;	---------------------------------
; Function dungeon_step
; ---------------------------------
	b_dungeon_step	= 17
_dungeon_step::
	add	sp, #-31
;src/dungeon.c:85: uint8_t position,type,cell,delta,new_floor,count=1;
	ldhl	sp,	#7
	ld	(hl), #0x01
;src/dungeon.c:87: memset(action,0,sizeof(*action));
	ldhl	sp,	#40
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0008
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/dungeon.c:88: if(state->floor>=DUNGEON_FLOOR_COUNT || state->direction>3u || command>DUNGEON_CMD_ACTION) {
	ldhl	sp,	#37
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ldhl	sp,	#38
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#30
	ld	(hl), a
;src/dungeon.c:89: action->mode=DUNGEON_INVALID;return action->mode;
	ldhl	sp,	#40
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#41
	ld	a, (hl)
	ldhl	sp,	#11
	ld	(hl), a
;src/dungeon.c:88: if(state->floor>=DUNGEON_FLOOR_COUNT || state->direction>3u || command>DUNGEON_CMD_ACTION) {
	ldhl	sp,	#30
	ld	a, (hl)
	sub	a, #0x3d
	jr	NC, 00101$
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#30
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#29
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	cp	a, #0x04
	jr	NC, 00101$
	ld	a, #0x05
	ldhl	sp,	#39
	sub	a, (hl)
	jr	NC, 00102$
00101$:
;src/dungeon.c:89: action->mode=DUNGEON_INVALID;return action->mode;
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0xff
	ld	(hl),a
	jp	00148$
00102$:
;src/dungeon.c:92: if(state->layout[state->position]==8u && !object_record(state->floor,state->position,&object)) {
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#26
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ld	e, c
	ld	d, #0x00
	ldhl	sp,	#24
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	b, a
;src/dungeon.c:94: dungeon_load_floor(state,new_floor);action->mode=DUNGEON_FELL;
	ldhl	sp,	#40
	ld	a, (hl)
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#41
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
;src/dungeon.c:95: action->target=new_floor;return action->mode;
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#20
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#19
	ld	(hl), a
;src/dungeon.c:92: if(state->layout[state->position]==8u && !object_record(state->floor,state->position,&object)) {
	ld	a, b
	sub	a, #0x08
	jr	NZ, 00106$
	ldhl	sp,	#0
	push	hl
	ld	e, c
	ldhl	sp,	#32
	ld	a, (hl)
	call	_object_record
	or	a, a
	jr	NZ, 00106$
;src/dungeon.c:93: new_floor=state->floor?state->floor-1u:0u;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00150$
	dec	a
	ld	e, a
	jr	00151$
00150$:
	ld	e, #0x00
00151$:
	ld	b, e
;src/dungeon.c:94: dungeon_load_floor(state,new_floor);action->mode=DUNGEON_FELL;
	push	bc
	push	bc
	inc	sp
	ldhl	sp,	#40
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_load_floor
	ld	hl, #_dungeon_load_floor
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x05
;src/dungeon.c:95: action->target=new_floor;return action->mode;
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), b
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jp	00148$
00106$:
;src/dungeon.c:97: if(command==DUNGEON_CMD_LEFT || command==DUNGEON_CMD_RIGHT) {
	ldhl	sp,	#39
	ld	a, (hl)
	sub	a, #0x03
	ld	a, #0x01
	jr	Z, 00343$
	xor	a, a
00343$:
	ldhl	sp,	#30
	ld	(hl), a
	or	a, a
	jr	NZ, 00108$
	ldhl	sp,	#39
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00109$
00108$:
;src/dungeon.c:98: state->direction=(state->direction+(command==DUNGEON_CMD_LEFT?3u:1u))&3u;
	ldhl	sp,	#28
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#29
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(hl+), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00152$
	ld	(hl), #0x03
	jr	00153$
00152$:
	ldhl	sp,	#30
	ld	(hl), #0x01
00153$:
	ldhl	sp,	#30
	ld	a, (hl-)
	add	a, (hl)
	and	a, #0x03
	ldhl	sp,	#26
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/dungeon.c:99: action->mode=DUNGEON_TURNED;return action->mode;
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x02
	ld	(hl),a
	jp	00148$
00109$:
;src/dungeon.c:101: if(command==DUNGEON_CMD_NONE) return 0;
	ldhl	sp,	#39
	ld	a, (hl)
	or	a,a
	jp	Z, 00148$
;src/dungeon.c:102: position=dungeon_sample_position(state,command==DUNGEON_CMD_BACK?11u:1u);
	ldhl	sp,	#39
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00347$
	xor	a, a
00347$:
	ldhl	sp,	#29
	ld	(hl), a
	or	a, a
	ld	a, #0x0b
	jr	NZ, 00155$
	ld	a, #0x01
00155$:
	push	af
	inc	sp
	ldhl	sp,	#38
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon.c:103: cell=state->layout[position];type=cell&7u;
	ldhl	sp,#20
	ld	(hl), a
	ldhl	sp,	#30
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#24
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#28
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#27
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	and	a, #0x07
	ldhl	sp,	#21
	ld	(hl), a
;src/dungeon.c:105: if(type==4u && !(cell&128u)) {
	ldhl	sp,	#30
	ld	a, (hl)
	and	a, #0x80
	ldhl	sp,	#22
	ld	(hl+), a
	ld	(hl), #0x00
;src/dungeon.c:104: if(command==DUNGEON_CMD_ACTION) {
	ldhl	sp,	#39
	ld	a, (hl)
	sub	a, #0x05
	jr	NZ, 00118$
;src/dungeon.c:105: if(type==4u && !(cell&128u)) {
	ldhl	sp,	#21
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00114$
	xor	a, a
	ldhl	sp,	#22
	or	a, (hl)
	jr	NZ, 00114$
;src/dungeon.c:106: state->layout[position]|=128u;action->mode=DUNGEON_OPENED;
	ldhl	sp,	#28
	ld	a, (hl-)
	dec	hl
	set	7, a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
	jr	00115$
00114$:
;src/dungeon.c:107: } else action->mode=DUNGEON_MENU;
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x0e
00115$:
;src/dungeon.c:108: return action->mode;
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jp	00148$
00118$:
;src/dungeon.c:113: action->step_count=1u;action->positions[0]=position;return action->mode;
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#26
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#28
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#27
;src/dungeon.c:110: if(command==DUNGEON_CMD_BACK) {
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00122$
;src/dungeon.c:111: if(type) return 0;
	ldhl	sp,	#21
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
	xor	a, a
	jp	00148$
00120$:
;src/dungeon.c:112: state->position=position;action->mode=DUNGEON_MOVED;
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;src/dungeon.c:113: action->step_count=1u;action->positions[0]=position;return action->mode;
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jp	00148$
00122$:
;src/dungeon.c:115: if(type==1u) return 0;
	ldhl	sp,	#21
	ld	a, (hl)
	dec	a
	jp	Z, 00148$
;src/dungeon.c:116: if(type==2u || type==3u) {
	ldhl	sp,	#21
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00355$
	xor	a, a
00355$:
	ldhl	sp,	#28
;src/dungeon.c:117: if(cell&8u) return dungeon_transition(state,action);
	ld	(hl+), a
	inc	hl
	ld	a, (hl-)
	and	a, #0x08
	ld	(hl+), a
;src/dungeon.c:116: if(type==2u || type==3u) {
	xor	a, a
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00139$
	ldhl	sp,	#21
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00140$
00139$:
;src/dungeon.c:117: if(cell&8u) return dungeon_transition(state,action);
	xor	a, a
	ldhl	sp,	#29
	or	a, (hl)
	jr	Z, 00126$
	ldhl	sp,	#40
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#39
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_transition
	ld	hl, #_dungeon_transition
	call	___sdcc_bcall_ehl
	add	sp, #4
	jp	00148$
00126$:
;src/dungeon.c:118: new_floor=state->floor+(type==2u?1u:255u);
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#30
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00157$
	ld	a, #0xff
00157$:
	ldhl	sp,	#28
	ld	(hl), a
	ld	a, (hl+)
	inc	hl
	add	a, (hl)
;src/dungeon.c:119: if(!dungeon_load_floor(state,new_floor)) {action->mode=DUNGEON_INVALID;return action->mode;}
	ld	(hl), a
	push	af
	inc	sp
	ldhl	sp,	#38
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_load_floor
	ld	hl, #_dungeon_load_floor
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	NZ, 00128$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0xff
	ld	(hl),a
	jp	00148$
00128$:
;src/dungeon.c:120: action->mode=DUNGEON_CHANGED_FLOOR;action->target=new_floor;count=2;
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x04
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#30
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#7
	ld	(hl), #0x02
	jr	00141$
00140$:
;src/dungeon.c:121: } else if(type>=4u && type<=6u) {
	ldhl	sp,	#21
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00136$
	ld	a, #0x06
	sub	a, (hl)
	jr	C, 00136$
;src/dungeon.c:122: if(!(cell&128u)) return 0;
	inc	hl
	xor	a, a
	or	a,(hl)
	jp	Z, 00148$
;src/dungeon.c:123: if(cell&8u) return dungeon_transition(state,action);
	xor	a, a
	ldhl	sp,	#29
	or	a, (hl)
	jr	Z, 00132$
	ldhl	sp,	#40
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#39
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_transition
	ld	hl, #_dungeon_transition
	call	___sdcc_bcall_ehl
	add	sp, #4
	jp	00148$
00132$:
;src/dungeon.c:124: count=2;
	ldhl	sp,	#7
	ld	(hl), #0x02
	jr	00141$
00136$:
;src/dungeon.c:125: } else if(type==7u) count=2;
	ldhl	sp,	#21
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00141$
	ldhl	sp,	#7
	ld	(hl), #0x02
00141$:
;src/dungeon.c:126: if(!action->mode) action->mode=DUNGEON_MOVED;
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#30
	ld	(hl), a
	or	a, a
	jr	NZ, 00144$
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
00144$:
;src/dungeon.c:127: delta=position-state->position;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#20
	ld	a, (hl)
	sub	a, c
	ldhl	sp,	#30
	ld	(hl), a
;src/dungeon.c:128: action->positions[0]=position;action->step_count=count;
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(de), a
;src/dungeon.c:129: if(count==2u) {
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00146$
;src/dungeon.c:130: action->positions[1]=position+delta;state->position=action->positions[1];
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#30
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#29
	ld	(hl+), a
	ld	a, (hl)
	ldhl	sp,	#20
	add	a, (hl)
	ldhl	sp,	#30
	ld	(hl-), a
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#30
	ld	a, (hl)
	ld	(de), a
	jr	00147$
00146$:
;src/dungeon.c:131: } else state->position=position;
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#20
	ld	a, (hl)
	ld	(de), a
00147$:
;src/dungeon.c:132: return action->mode;
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
00148$:
;src/dungeon.c:133: }
	add	sp, #31
	ret
	.area _CODE_17
	.area _INITIALIZER
	.area _CABS (ABS)
