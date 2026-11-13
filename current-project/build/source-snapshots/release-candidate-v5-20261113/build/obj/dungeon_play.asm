;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_play
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl b_dungeon_present_scene_fall
	.globl _dungeon_present_scene_fall
	.globl b_dungeon_present_fall
	.globl _dungeon_present_fall
	.globl b_dungeon_present_transition
	.globl _dungeon_present_transition
	.globl b_dungeon_present_door
	.globl _dungeon_present_door
	.globl b_dungeon_present_turn
	.globl _dungeon_present_turn
	.globl b_dungeon_present_sequence
	.globl _dungeon_present_sequence
	.globl b_dungeon_present_frame
	.globl _dungeon_present_frame
	.globl b_dungeon_present_prepare
	.globl _dungeon_present_prepare
	.globl b_rpg_dungeon_encounter
	.globl _rpg_dungeon_encounter
	.globl b_rpg_find_item
	.globl _rpg_find_item
	.globl b_rpg_random
	.globl _rpg_random
	.globl b_dungeon_active_object
	.globl _dungeon_active_object
	.globl b_dungeon_step
	.globl _dungeon_step
	.globl b_dungeon_sample_position
	.globl _dungeon_sample_position
	.globl b_dungeon_sample
	.globl _dungeon_sample
	.globl b_dungeon_refresh_light
	.globl _dungeon_refresh_light
	.globl b_dungeon_load_floor
	.globl _dungeon_load_floor
	.globl b_dungeon_enter
	.globl _dungeon_enter
	.globl b_dplay_mark_object
	.globl _dplay_mark_object
	.globl b_dplay_escape_blocked
	.globl _dplay_escape_blocked
	.globl b_dplay_resume
	.globl _dplay_resume
	.globl b_dplay_enter
	.globl _dplay_enter
	.globl b_dplay_scene_fall
	.globl _dplay_scene_fall
	.globl b_dplay_step
	.globl _dplay_step
	.globl b_dplay_escape
	.globl _dplay_escape
	.globl b_dplay_show_opening
	.globl _dplay_show_opening
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
	.area _CODE_11
;src/dungeon_play.c:10: static void queue(DungeonPlay *p,uint8_t position,uint8_t view) RPG_BANKED {
;	---------------------------------
; Function queue
; ---------------------------------
	b_queue	= 11
_queue:
;src/dungeon_play.c:11: p->positions[p->check_count]=position;p->views[p->check_count++]=view;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010b
	add	hl, de
	ld	a, e
	add	a, #0x09
	ld	c, a
	ld	a, d
	adc	a, #0x01
	ld	b, a
	ld	a, (bc)
	add	a, l
	ld	l, a
	ld	a, #0x00
	adc	a, h
	ld	h, a
	push	hl
	ldhl	sp,	#10
	ld	a, (hl)
	pop	hl
	ld	(hl), a
	ld	hl, #0x010d
	add	hl, de
	ld	a, (bc)
	ld	e, a
	inc	a
	ld	(bc), a
	ld	d, #0x00
	add	hl, de
	push	hl
	ldhl	sp,	#11
	ld	a, (hl)
	pop	hl
	ld	(hl), a
;src/dungeon_play.c:12: }
	ret
;src/dungeon_play.c:13: void dplay_mark_object(EventState *e,uint16_t address) RPG_BANKED {
;	---------------------------------
; Function dplay_mark_object
; ---------------------------------
	b_dplay_mark_object	= 11
_dplay_mark_object::
;src/dungeon_play.c:14: if((address>>8)==0xc5u)e->flags[(uint8_t)address]=255;
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	inc	hl
	ld	c, (hl)
	cp	a, #0xc5
	jr	NZ, 00104$
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	(hl), #0xff
	ret
00104$:
;src/dungeon_play.c:15: else if((address>>8)==0xc6u)e->object_flags[(uint8_t)address]=255;
	sub	a, #0xc6
	ret	NZ
	ld	hl, #0x0125
	add	hl, de
	ld	e, c
	ld	d, #0x00
	add	hl, de
	ld	(hl), #0xff
;src/dungeon_play.c:16: }
	ret
;src/dungeon_play.c:17: uint8_t dplay_escape_blocked(const DungeonPlay *p) RPG_BANKED {
;	---------------------------------
; Function dplay_escape_blocked
; ---------------------------------
	b_dplay_escape_blocked	= 11
_dplay_escape_blocked::
;src/dungeon_play.c:18: return (dungeon_sample(&p->dungeon,11)&7u)&&
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	a, #0x0b
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	and	a, #0x07
	jr	Z, 00103$
;src/dungeon_play.c:19: (dungeon_sample(&p->dungeon,12)&7u)&&(dungeon_sample(&p->dungeon,13)&7u);
	push	bc
	ld	a, #0x0c
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	and	a, #0x07
	jr	Z, 00103$
	ld	a, #0x0d
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	and	a, #0x07
	jr	NZ, 00104$
00103$:
	xor	a, a
	ret
00104$:
	ld	a, #0x01
;src/dungeon_play.c:20: }
	ret
;src/dungeon_play.c:21: uint8_t dplay_resume(DungeonPlay *p,RPGState *r,EventState *e) RPG_BANKED {
;	---------------------------------
; Function dplay_resume
; ---------------------------------
	b_dplay_resume	= 11
_dplay_resume::
	add	sp, #-31
;src/dungeon_play.c:23: dungeon_present_prepare(&p->dungeon);
	ldhl	sp,	#37
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#38
	ld	a, (hl)
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_prepare
	ld	hl, #_dungeon_present_prepare
	call	___sdcc_bcall_ehl
	pop	hl
;src/dungeon_play.c:24: memset(&p->action,0,sizeof(p->action));
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0113
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x0009
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/dungeon_play.c:25: while(p->check_cursor<p->check_count) {
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010b
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010d
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl), a
	ldhl	sp,	#41
	ld	a, (hl)
	ldhl	sp,	#15
	ld	(hl), a
	ldhl	sp,	#42
	ld	a, (hl)
	ldhl	sp,	#16
	ld	(hl), a
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0109
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#19
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#18
	ld	(hl), a
00128$:
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010a
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#30
	ld	(hl), a
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
;src/dungeon_play.c:32: p->advance_second=0;p->encounter_latch=1;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010f
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#28
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#27
	ld	(hl), a
;src/dungeon_play.c:36: p->encounter_latch=1;p->action.flag_address=o.flag_address;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0118
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#30
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#29
	ld	(hl), a
;src/dungeon_play.c:42: p->action.kind=DPLAY_CHEST;p->action.a=p->retained_trap;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0113
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#21
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#20
	ld	(hl), a
;src/dungeon_play.c:43: if(o.type==0u)p->action.target=o.a;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0114
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#23
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#22
	ld	(hl), a
;src/dungeon_play.c:25: while(p->check_cursor<p->check_count) {
	ldhl	sp,	#30
	ld	a, (hl)
	sub	a, c
	jp	NC, 00130$
;src/dungeon_play.c:26: if(p->advance_second && p->check_cursor==1u) {
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0111
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#26
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#25
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
;src/dungeon_play.c:30: p->dungeon.position=dungeon_sample_position(&p->dungeon,1u);
	ldhl	sp,	#37
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	inc	bc
;src/dungeon_play.c:26: if(p->advance_second && p->check_cursor==1u) {
	or	a, a
	jr	Z, 00102$
	ldhl	sp,	#30
	ld	a, (hl)
	dec	a
	jr	NZ, 00102$
;src/dungeon_play.c:29: dungeon_present_sequence(&p->dungeon,0u);
	push	bc
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_sequence
	ld	hl, #_dungeon_present_sequence
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_play.c:30: p->dungeon.position=dungeon_sample_position(&p->dungeon,1u);
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	ld	(bc), a
;src/dungeon_play.c:31: dungeon_present_frame(&p->dungeon,0u);
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_frame
	ld	hl, #_dungeon_present_frame
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_play.c:32: p->advance_second=0;p->encounter_latch=1;
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	jr	00103$
00102$:
;src/dungeon_play.c:33: } else p->dungeon.position=p->positions[p->check_cursor];
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#30
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
00103$:
;src/dungeon_play.c:34: view=p->views[p->check_cursor++];
	pop	de
	push	de
	ld	a, (de)
	ld	c, a
	inc	c
	pop	hl
	push	hl
	ld	(hl), c
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#13
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#30
	ld	(hl), a
;src/dungeon_play.c:35: if(!dungeon_active_object(&p->dungeon,view,e->flags,e->object_flags,&o))continue;
	ldhl	sp,#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0125
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #2
	add	hl, sp
	push	hl
	push	de
	push	bc
	ldhl	sp,	#36
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_active_object
	ld	hl, #_dungeon_active_object
	call	___sdcc_bcall_ehl
	add	sp, #9
	or	a, a
	jp	Z, 00128$
;src/dungeon_play.c:36: p->encounter_latch=1;p->action.flag_address=o.flag_address;
	ldhl	sp,	#26
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#28
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/dungeon_play.c:37: if(o.type<2u) {
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#23
	ld	(hl), a
;src/dungeon_play.c:40: if(o.type==0u)p->retained_trap=o.b;
;src/dungeon_play.c:41: if(view!=1u)continue;
	ldhl	sp,	#30
	ld	a, (hl)
	dec	a
	ld	a, #0x01
	jr	Z, 00309$
	xor	a, a
00309$:
	ldhl	sp,	#24
	ld	(hl), a
;src/dungeon_play.c:42: p->action.kind=DPLAY_CHEST;p->action.a=p->retained_trap;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0115
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#27
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#26
	ld	(hl), a
;src/dungeon_play.c:43: if(o.type==0u)p->action.target=o.a;
;src/dungeon_play.c:45: p->action.type=o.type;return p->action.kind;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0117
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#29
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#28
	ld	(hl), a
;src/dungeon_play.c:37: if(o.type<2u) {
	ldhl	sp,	#23
	ld	a, (hl)
	sub	a, #0x02
	jr	NC, 00115$
;src/dungeon_play.c:40: if(o.type==0u)p->retained_trap=o.b;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0112
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#23
	ld	a, (hl)
	or	a, a
	jr	NZ, 00108$
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(bc), a
00108$:
;src/dungeon_play.c:41: if(view!=1u)continue;
	ldhl	sp,	#24
	bit	0, (hl)
	jp	Z, 00128$
;src/dungeon_play.c:42: p->action.kind=DPLAY_CHEST;p->action.a=p->retained_trap;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
	ld	a, (bc)
	ldhl	sp,	#25
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/dungeon_play.c:43: if(o.type==0u)p->action.target=o.a;
	ldhl	sp,	#4
;src/dungeon_play.c:52: if(!o.a)continue;
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	ldhl	sp,	#30
	ld	(hl), a
;src/dungeon_play.c:43: if(o.type==0u)p->action.target=o.a;
	ld	a, c
	or	a, a
	jr	NZ, 00112$
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#30
	ld	a, (hl)
	ld	(de), a
	jr	00113$
00112$:
;src/dungeon_play.c:44: else p->action.money=(uint16_t)o.a|((uint16_t)o.b<<8);
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#30
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#6
	ld	d, (hl)
	ldhl	sp,	#29
	ld	a, (hl)
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
00113$:
;src/dungeon_play.c:45: p->action.type=o.type;return p->action.kind;
	ldhl	sp,	#4
	ld	a, (hl)
	ldhl	sp,	#27
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jp	00148$
00115$:
;src/dungeon_play.c:49: p->dungeon.direction=(p->dungeon.direction+3u)&3u;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#31
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#30
	ld	(hl), a
;src/dungeon_play.c:47: if(o.type==2u) {
	ldhl	sp,	#23
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00122$
;src/dungeon_play.c:48: if(view!=1u)for(i=0;i<2u;++i){
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00118$
	ld	c, #0x00
00144$:
;src/dungeon_play.c:49: p->dungeon.direction=(p->dungeon.direction+3u)&3u;
	ldhl	sp,#29
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	add	a, #0x03
	and	a, #0x03
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/dungeon_play.c:50: dungeon_present_turn(&p->dungeon,0u);
	push	bc
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_turn
	ld	hl, #_dungeon_present_turn
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
;src/dungeon_play.c:48: if(view!=1u)for(i=0;i<2u;++i){
	inc	c
	ld	a, c
	sub	a, #0x02
	jr	C, 00144$
00118$:
;src/dungeon_play.c:52: if(!o.a)continue;
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jp	Z, 00128$
;src/dungeon_play.c:53: p->action.kind=DPLAY_BATTLE;p->action.target=o.a;p->action.a=o.b;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x02
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#21
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#25
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/dungeon_play.c:54: p->action.type=1;return p->action.kind;
	ldhl	sp,	#27
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jp	00148$
00122$:
;src/dungeon_play.c:56: if(o.type==3u) {
	ldhl	sp,	#23
	ld	a, (hl)
	sub	a, #0x03
	jp	NZ, 00128$
;src/dungeon_play.c:57: if(view!=1u)for(i=0;i<2u;++i){
	ldhl	sp,	#24
	bit	0, (hl)
	jr	NZ, 00125$
	ld	(hl), #0x00
00146$:
;src/dungeon_play.c:58: p->dungeon.direction=(p->dungeon.direction+1u)&3u;
	ldhl	sp,#29
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#23
	ld	(hl), a
	inc	a
	and	a, #0x03
	ldhl	sp,	#29
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/dungeon_play.c:59: dungeon_present_turn(&p->dungeon,1u);
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_turn
	ld	hl, #_dungeon_present_turn
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_play.c:57: if(view!=1u)for(i=0;i<2u;++i){
	ldhl	sp,	#24
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00146$
00125$:
;src/dungeon_play.c:61: p->action.kind=DPLAY_EVENT;p->action.target=o.a;p->action.a=o.b;
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x04
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#21
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#25
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/dungeon_play.c:62: p->action.type=0;return p->action.kind;
	ldhl	sp,	#27
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jp	00148$
00130$:
;src/dungeon_play.c:65: if(p->initial_dark==2u) {
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0110
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	e, a
;src/dungeon_play.c:67: if(!p->dungeon.light){p->action.kind=DPLAY_EXIT;return p->action.kind;}
	ldhl	sp,	#37
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	inc	hl
;src/dungeon_play.c:65: if(p->initial_dark==2u) {
	ld	a, e
	sub	a, #0x02
	jr	NZ, 00138$
;src/dungeon_play.c:66: p->initial_dark=0;
	xor	a, a
	ld	(bc), a
;src/dungeon_play.c:67: if(!p->dungeon.light){p->action.kind=DPLAY_EXIT;return p->action.kind;}
	ld	a, (hl)
	or	a, a
	jr	NZ, 00132$
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x06
	ld	(hl),a
	jp	00148$
00132$:
;src/dungeon_play.c:68: p->dungeon.light=255u;dungeon_refresh_light(&p->dungeon);
	ld	(hl), #0xff
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_refresh_light
	ld	hl, #_dungeon_refresh_light
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00139$
00138$:
;src/dungeon_play.c:69: } else if(p->initial_dark) {
	ld	a, e
	or	a, a
	jr	Z, 00139$
;src/dungeon_play.c:70: p->initial_dark=0;
	xor	a, a
	ld	(bc), a
;src/dungeon_play.c:71: if(!p->dungeon.light){p->initial_dark=2u;p->action.kind=DPLAY_DARK;return p->action.kind;}
	ld	a, (hl)
	or	a, a
	jr	NZ, 00139$
	ld	a, #0x02
	ld	(bc), a
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a,#0x07
	ld	(hl),a
	jr	00148$
00139$:
;src/dungeon_play.c:73: if(p->encounter_latch) {
	ldhl	sp,#26
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00143$
;src/dungeon_play.c:74: p->encounter_latch=0;
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), #0x00
;src/dungeon_play.c:75: enemy=rpg_dungeon_encounter(r,p->dungeon.floor,dungeon_sample(&p->dungeon,1));
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	b, a
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_dungeon_encounter
	ld	hl, #_rpg_dungeon_encounter
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	c, a
;src/dungeon_play.c:76: if(enemy){p->action.kind=DPLAY_BATTLE;p->action.target=enemy;p->action.flag_address=0xc500;}
	or	a, a
	jr	Z, 00143$
	ldhl	sp,	#19
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x02
	ldhl	sp,	#21
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	ldhl	sp,	#28
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	xor	a, a
	ld	(hl+), a
	ld	(hl), #0xc5
00143$:
;src/dungeon_play.c:78: return p->action.kind;
	ldhl	sp,#19
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
00148$:
;src/dungeon_play.c:79: }
	add	sp, #31
	ret
;src/dungeon_play.c:80: uint8_t dplay_enter(DungeonPlay *p,RPGState *r,EventState *e,uint8_t floor,uint8_t position,uint8_t direction,uint8_t trap) RPG_BANKED {
;	---------------------------------
; Function dplay_enter
; ---------------------------------
	b_dplay_enter	= 11
_dplay_enter::
;src/dungeon_play.c:81: memset(p,0,sizeof(*p));
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x011c
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/dungeon_play.c:82: if(!dungeon_enter(&p->dungeon,floor,position,direction)){p->action.kind=DPLAY_INVALID;return DPLAY_INVALID;}
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	push	bc
	push	de
	ldhl	sp,	#18
	ld	a, (hl-)
	ld	b, a
	ld	a, (hl-)
	ld	c, a
	push	bc
	ld	a, (hl)
	push	af
	inc	sp
	push	de
	ld	e, #b_dungeon_enter
	ld	hl, #_dungeon_enter
	call	___sdcc_bcall_ehl
	add	sp, #5
	pop	de
	pop	bc
	or	a, a
	jr	NZ, 00102$
	ld	hl, #0x0113
	add	hl, bc
	ld	a,#0xff
	ld	(hl),a
	ret
00102$:
;src/dungeon_play.c:83: p->active=1;p->retained_trap=trap;
	ld	hl, #0x0108
	add	hl, bc
	ld	(hl), #0x01
	ld	hl, #0x0112
	add	hl, bc
	push	hl
	ldhl	sp,	#17
	ld	a, (hl)
	pop	hl
	ld	(hl), a
;src/dungeon_play.c:84: if(rpg_find_item(r,ItemID_MagicLamp)!=RPG_NO_SLOT){p->dungeon.light=255;dungeon_refresh_light(&p->dungeon);}
	push	bc
	push	de
	ld	a, #0x39
	push	af
	inc	sp
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	pop	bc
	inc	a
	jr	Z, 00104$
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0xff
	push	bc
	push	de
	ld	e, #b_dungeon_refresh_light
	ld	hl, #_dungeon_refresh_light
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
00104$:
;src/dungeon_play.c:85: p->initial_dark=1;queue(p,position,1);
	ld	hl, #0x0110
	add	hl, bc
	ld	a,#0x01
	ld	(hl),a
	push	af
	inc	sp
	ldhl	sp,	#14
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_queue
	ld	hl, #_queue
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/dungeon_play.c:86: return dplay_resume(p,r,e);
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dplay_resume
	ld	hl, #_dplay_resume
	call	___sdcc_bcall_ehl
	add	sp, #6
;src/dungeon_play.c:87: }
	ret
;src/dungeon_play.c:88: uint8_t dplay_scene_fall(DungeonPlay *p,RPGState *r,EventState *e,uint8_t floor,uint8_t position,uint8_t direction,uint8_t trap) RPG_BANKED {
;	---------------------------------
; Function dplay_scene_fall
; ---------------------------------
	b_dplay_scene_fall	= 11
_dplay_scene_fall::
	add	sp, #-3
;src/dungeon_play.c:89: uint8_t light=p->dungeon.light;
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl), a
;src/dungeon_play.c:90: memset(p,0,sizeof(*p));
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	push	de
	ld	hl, #0x011c
	push	hl
	ld	hl, #0x0000
	push	hl
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	push	hl
	call	_memset
	add	sp, #6
	pop	de
;src/dungeon_play.c:91: if(floor>=DUNGEON_FLOOR_COUNT||direction>3u){p->action.kind=DPLAY_INVALID;return DPLAY_INVALID;}
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x3d
	jr	NC, 00101$
	inc	hl
	inc	hl
	ld	a, #0x03
	sub	a, (hl)
	jr	NC, 00102$
00101$:
	ld	hl, #0x0113
	add	hl, bc
	ld	a,#0xff
	ld	(hl),a
	jp	00104$
00102$:
;src/dungeon_play.c:92: p->dungeon.position=position;p->dungeon.direction=direction;p->dungeon.light=light;
	ld	l, c
	ld	h, b
	inc	hl
	push	hl
	ldhl	sp,	#18
	ld	a, (hl)
	pop	hl
	ld	(hl), a
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	push	hl
	ldhl	sp,	#19
	ld	a, (hl)
	pop	hl
	ld	(hl), a
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(de), a
;src/dungeon_play.c:93: dungeon_load_floor(&p->dungeon,floor?floor-1u:0u);p->active=1;p->retained_trap=trap;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
	ld	a, (hl)
	dec	a
	jr	00107$
00106$:
	xor	a, a
00107$:
	ld	e, c
	ld	d, b
	push	bc
	push	de
	push	af
	inc	sp
	push	de
	ld	e, #b_dungeon_load_floor
	ld	hl, #_dungeon_load_floor
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	pop	bc
	ld	hl, #0x0108
	add	hl, bc
	ld	(hl), #0x01
	ld	hl, #0x0112
	add	hl, bc
	push	hl
	ldhl	sp,	#20
	ld	a, (hl)
	pop	hl
	ld	(hl), a
;src/dungeon_play.c:94: dungeon_present_scene_fall(&p->dungeon);
	push	bc
	push	de
	ld	e, #b_dungeon_present_scene_fall
	ld	hl, #_dungeon_present_scene_fall
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
;src/dungeon_play.c:95: queue(p,position,1u);return dplay_resume(p,r,e);
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#17
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_queue
	ld	hl, #_queue
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dplay_resume
	ld	hl, #_dplay_resume
	call	___sdcc_bcall_ehl
	add	sp, #6
00104$:
;src/dungeon_play.c:96: }
	add	sp, #3
	ret
;src/dungeon_play.c:97: uint8_t dplay_step(DungeonPlay *p,RPGState *r,EventState *e,uint8_t command) RPG_BANKED {
;	---------------------------------
; Function dplay_step
; ---------------------------------
	b_dplay_step	= 11
_dplay_step::
	add	sp, #-29
;src/dungeon_play.c:98: DungeonAction a;uint8_t front=dungeon_sample(&p->dungeon,1)&7u,mode,old_position=p->dungeon.position;
	ldhl	sp,	#35
	ld	a, (hl)
	ldhl	sp,	#12
	ld	(hl), a
	ldhl	sp,	#36
	ld	a, (hl)
	ldhl	sp,	#13
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	and	a, #0x07
	ldhl	sp,	#16
	ld	(hl), a
;src/dungeon_play.c:123: queue(p,p->advance_second?a.positions[1]:p->dungeon.position,1);
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#19
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#18
;src/dungeon_play.c:98: DungeonAction a;uint8_t front=dungeon_sample(&p->dungeon,1)&7u,mode,old_position=p->dungeon.position;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
;src/dungeon_play.c:99: dungeon_present_prepare(&p->dungeon);
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_prepare
	ld	hl, #_dungeon_present_prepare
	call	___sdcc_bcall_ehl
	pop	hl
;src/dungeon_play.c:100: p->check_count=p->check_cursor=p->encounter_latch=p->advance_second=0;
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0109
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#29
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#28
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010f
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#22
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#21
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0111
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#24
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#23
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#20
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#27
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/dungeon_play.c:101: memset(&p->action,0,sizeof(p->action));
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0113
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x0009
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/dungeon_play.c:102: mode=dungeon_step(&p->dungeon,command,&a);
	ld	hl, #4
	add	hl, sp
	push	hl
	ldhl	sp,	#43
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_step
	ld	hl, #_dungeon_step
	call	___sdcc_bcall_ehl
	add	sp, #5
	ldhl	sp,	#28
	ld	(hl), a
;src/dungeon_play.c:103: if(mode==DUNGEON_MAP){p->action.kind=DPLAY_MAP;p->action.target=a.target;p->action.a=a.a;p->action.b=a.b;}
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0113
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#26
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#25
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0114
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0115
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
	ld	hl, #0x0116
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#28
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#27
	ld	(hl+), a
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00143$
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x05
	ldhl	sp,	#5
	ld	a, (hl)
	pop	hl
	push	hl
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#26
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jp	00144$
00143$:
;src/dungeon_play.c:104: else if(mode==DUNGEON_EXIT_SAVED)p->action.kind=DPLAY_EXIT;
	ldhl	sp,	#28
	ld	a, (hl)
	sub	a, #0x0d
	jr	NZ, 00140$
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x06
	jp	00144$
00140$:
;src/dungeon_play.c:105: else if(mode==DUNGEON_INTERACTION){p->action.kind=DPLAY_EVENT;p->action.target=a.a;p->action.a=a.b;p->action.type=a.interaction;p->action.b=a.target;}
	ldhl	sp,	#28
	ld	a, (hl)
	sub	a, #0x0c
	jr	NZ, 00137$
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x04
	ldhl	sp,	#6
	ld	a, (hl)
	pop	hl
	push	hl
	ld	(hl), a
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0117
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#26
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jp	00144$
00137$:
;src/dungeon_play.c:106: else if(mode==DUNGEON_MENU)p->action.kind=DPLAY_MENU;
	ldhl	sp,	#28
	ld	a, (hl)
	sub	a, #0x0e
	jr	NZ, 00134$
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	jp	00144$
00134$:
;src/dungeon_play.c:107: else if(mode==DUNGEON_INVALID)p->action.kind=DPLAY_INVALID;
	ldhl	sp,	#28
	ld	a, (hl)
	inc	a
	jr	NZ, 00131$
	ldhl	sp,	#24
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0xff
	jp	00144$
00131$:
;src/dungeon_play.c:108: else if(mode==DUNGEON_OPENED)dungeon_present_door(&p->dungeon,2u);
	ldhl	sp,	#28
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00128$
	ld	a, #0x02
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_door
	ld	hl, #_dungeon_present_door
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00144$
00128$:
;src/dungeon_play.c:109: else if(mode==DUNGEON_MOVED||mode==DUNGEON_TURNED||mode==DUNGEON_CHANGED_FLOOR||mode==DUNGEON_FELL) {
	ldhl	sp,	#28
	ld	a, (hl)
	dec	a
	ld	a, #0x01
	jr	Z, 00343$
	xor	a, a
00343$:
	ldhl	sp,	#26
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00345$
	xor	a, a
00345$:
	ld	c, a
	ldhl	sp,	#28
	ld	a, (hl)
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 00347$
	xor	a, a
00347$:
	ldhl	sp,	#27
	ld	(hl+), a
	ld	a, (hl)
	sub	a, #0x05
	ld	a, #0x01
	jr	Z, 00349$
	xor	a, a
00349$:
	ldhl	sp,	#28
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00122$
	or	a, c
	jr	NZ, 00122$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00122$
	inc	hl
	ld	a, (hl)
	or	a, a
	jp	Z, 00144$
00122$:
;src/dungeon_play.c:112: p->encounter_latch=mode==DUNGEON_TURNED || (mode==DUNGEON_MOVED &&
	ldhl	sp,	#20
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
;src/dungeon_play.c:113: (command==DUNGEON_CMD_BACK||front==0u||front==7u));
	ldhl	sp,	#41
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00351$
	xor	a, a
00351$:
	ldhl	sp,	#24
	ld	(hl), a
	ldhl	sp,	#16
	ld	a, (hl)
	sub	a, #0x07
	ld	a, #0x01
	jr	Z, 00353$
	xor	a, a
00353$:
	ldhl	sp,	#25
	ld	(hl), a
;src/dungeon_play.c:112: p->encounter_latch=mode==DUNGEON_TURNED || (mode==DUNGEON_MOVED &&
	ld	b, c
	bit	0, b
	jr	NZ, 00148$
	inc	hl
	bit	0, (hl)
	jr	Z, 00147$
;src/dungeon_play.c:113: (command==DUNGEON_CMD_BACK||front==0u||front==7u));
	dec	hl
	dec	hl
	bit	0, (hl)
	jr	NZ, 00148$
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	Z, 00148$
	ldhl	sp,	#25
	bit	0, (hl)
	jr	NZ, 00148$
00147$:
	xor	a, a
	jr	00149$
00148$:
	ld	a, #0x01
00149$:
	ld	(de), a
;src/dungeon_play.c:114: if(mode==DUNGEON_MOVED&&command==DUNGEON_CMD_FORWARD&&(front==0u||front==7u)) {
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
	ldhl	sp,	#41
	ld	a, (hl)
	dec	a
	jr	NZ, 00114$
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	Z, 00113$
	ldhl	sp,	#25
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
00113$:
;src/dungeon_play.c:115: p->dungeon.position=old_position;dungeon_present_sequence(&p->dungeon,0u);
	ldhl	sp,	#17
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl)
	ld	(de), a
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_sequence
	ld	hl, #_dungeon_present_sequence
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_play.c:116: p->dungeon.position=a.positions[0];dungeon_present_frame(&p->dungeon,0u);
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#17
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_frame
	ld	hl, #_dungeon_present_frame
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_play.c:117: if(front==7u){queue(p,a.positions[0],1);p->advance_second=1;}
	ldhl	sp,	#25
	ld	a, (hl)
	or	a, a
	jp	Z, 00115$
	ldhl	sp,	#10
	ld	a, (hl)
	ld	h, #0x01
	push	hl
	inc	sp
	push	af
	inc	sp
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_queue
	ld	hl, #_queue
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	jr	00115$
00114$:
;src/dungeon_play.c:119: else if(mode==DUNGEON_MOVED&&command==DUNGEON_CMD_BACK)dungeon_present_sequence(&p->dungeon,1u);
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00110$
	dec	hl
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00110$
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_sequence
	ld	hl, #_dungeon_present_sequence
	call	___sdcc_bcall_ehl
	add	sp, #3
	jr	00115$
00110$:
;src/dungeon_play.c:120: else if(mode==DUNGEON_TURNED)dungeon_present_turn(&p->dungeon,command==DUNGEON_CMD_RIGHT);
	ld	a, c
	or	a, a
	jr	Z, 00107$
	ldhl	sp,	#41
	ld	a, (hl)
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 00357$
	xor	a, a
00357$:
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_turn
	ld	hl, #_dungeon_present_turn
	call	___sdcc_bcall_ehl
	add	sp, #3
	jr	00115$
00107$:
;src/dungeon_play.c:121: else if(mode==DUNGEON_FELL)dungeon_present_fall(&p->dungeon);
	ldhl	sp,	#28
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_fall
	ld	hl, #_dungeon_present_fall
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00115$
00104$:
;src/dungeon_play.c:122: else dungeon_present_transition(&p->dungeon,mode==DUNGEON_CHANGED_FLOOR);
	ldhl	sp,	#27
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#15
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dungeon_present_transition
	ld	hl, #_dungeon_present_transition
	call	___sdcc_bcall_ehl
	add	sp, #3
00115$:
;src/dungeon_play.c:123: queue(p,p->advance_second?a.positions[1]:p->dungeon.position,1);
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#28
	ld	(hl), a
	or	a, a
	jr	Z, 00159$
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#28
	ld	(hl), a
	jr	00160$
00159$:
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#28
	ld	(hl), a
00160$:
	ld	a, #0x01
	push	af
	inc	sp
	ldhl	sp,	#29
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_queue
	ld	hl, #_queue
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/dungeon_play.c:124: if(mode==DUNGEON_MOVED&&command==DUNGEON_CMD_BACK)queue(p,p->dungeon.position,11);
	ldhl	sp,	#26
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
	dec	hl
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00120$
	ldhl	sp,#17
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	h, #0x0b
	push	hl
	inc	sp
	push	af
	inc	sp
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_queue
	ld	hl, #_queue
	call	___sdcc_bcall_ehl
	add	sp, #4
00120$:
;src/dungeon_play.c:125: return dplay_resume(p,r,e);
	ldhl	sp,	#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dplay_resume
	ld	hl, #_dplay_resume
	call	___sdcc_bcall_ehl
	add	sp, #6
	jr	00145$
00144$:
;src/dungeon_play.c:127: return p->action.kind;
	ldhl	sp,#24
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
00145$:
;src/dungeon_play.c:128: }
	add	sp, #29
	ret
;src/dungeon_play.c:129: uint8_t dplay_escape(DungeonPlay *p,RPGState *r,EventState *e) RPG_BANKED {
;	---------------------------------
; Function dplay_escape
; ---------------------------------
	b_dplay_escape	= 11
_dplay_escape::
	add	sp, #-6
;src/dungeon_play.c:132: dungeon_present_prepare(&p->dungeon);
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	bc
	push	bc
	push	bc
	push	bc
	ld	e, #b_dungeon_present_prepare
	ld	hl, #_dungeon_present_prepare
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
;src/dungeon_play.c:133: if(dungeon_sample(&p->dungeon,11)&7u) {
	push	bc
	ld	a, #0x0b
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	and	a, #0x07
	jr	Z, 00102$
;src/dungeon_play.c:134: uint8_t left=dungeon_sample(&p->dungeon,12)&7u,right=dungeon_sample(&p->dungeon,13)&7u;
	push	bc
	ld	a, #0x0c
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	and	a, #0x07
	ld	e, a
	push	bc
	push	de
	ld	a, #0x0d
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample
	ld	hl, #_dungeon_sample
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	pop	bc
	and	a, #0x07
;src/dungeon_play.c:135: uint8_t turn_right=!left&&(right||(rpg_random(r)&1u));
	inc	e
	dec	e
	jr	NZ, 00105$
	or	a, a
	jr	NZ, 00106$
	push	bc
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_random
	ld	hl, #_rpg_random
	call	___sdcc_bcall_ehl
	pop	hl
	ld	e, a
	pop	bc
	ld	a, e
	and	a, #0x01
	jr	NZ, 00106$
00105$:
	xor	a, a
	jr	00107$
00106$:
	ld	a, #0x01
00107$:
	ldhl	sp,	#4
;src/dungeon_play.c:136: p->dungeon.direction=(p->dungeon.direction+(turn_right?1u:3u))&3u;
	ld	(hl+), a
	pop	de
	push	de
	inc	de
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00112$
	ld	a, #0x03
00112$:
	ldhl	sp,	#5
	add	a, (hl)
;src/dungeon_play.c:137: dungeon_present_turn(&p->dungeon,turn_right);
	dec	hl
	and	a, #0x03
	ld	(de), a
	push	bc
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_present_turn
	ld	hl, #_dungeon_present_turn
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
00102$:
;src/dungeon_play.c:139: p->check_count=p->check_cursor=p->advance_second=0;p->encounter_latch=1;
	pop	de
	push	de
	ld	hl, #0x0109
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x010a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0111
	add	hl, de
	ld	e, l
	ld	d, h
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
	pop	de
	push	de
	ld	hl, #0x010f
	add	hl, de
	ld	(hl), #0x01
;src/dungeon_play.c:140: p->dungeon.position=dungeon_sample_position(&p->dungeon,11u);
	pop	de
	push	de
	inc	de
	push	bc
	push	de
	ld	a, #0x0b
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	pop	bc
	ld	(de), a
;src/dungeon_play.c:141: dungeon_present_sequence(&p->dungeon,1u);
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_present_sequence
	ld	hl, #_dungeon_present_sequence
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
;src/dungeon_play.c:142: queue(p,p->dungeon.position,1u);queue(p,p->dungeon.position,11u);
	ld	a, (de)
	push	de
	ld	h, #0x01
	push	hl
	inc	sp
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_queue
	ld	hl, #_queue
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	ld	a, (de)
	ld	h, #0x0b
	push	hl
	inc	sp
	push	af
	inc	sp
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_queue
	ld	hl, #_queue
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/dungeon_play.c:143: return dplay_resume(p,r,e);
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_dplay_resume
	ld	hl, #_dplay_resume
	call	___sdcc_bcall_ehl
;src/dungeon_play.c:144: }
	add	sp, #12
	ret
;src/dungeon_play.c:145: void dplay_show_opening(DungeonPlay *p,uint8_t style) RPG_BANKED {
;	---------------------------------
; Function dplay_show_opening
; ---------------------------------
	b_dplay_show_opening	= 11
_dplay_show_opening::
;src/dungeon_play.c:146: uint8_t pos=dungeon_sample_position(&p->dungeon,1u),cell=p->dungeon.layout[pos];
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	c, e
	ld	b, d
	push	bc
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_sample_position
	ld	hl, #_dungeon_sample_position
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	l, a
	pop	de
	pop	bc
	ld	a, e
	add	a, #0x08
	ld	e, a
	jr	NC, 00103$
	inc	d
00103$:
	ld	h, #0x00
	add	hl, de
	ld	e, (hl)
;src/dungeon_play.c:149: p->dungeon.layout[pos]=cell&127u;dungeon_present_prepare(&p->dungeon);
	ld	a, e
	and	a, #0x7f
	ld	(hl), a
	push	hl
	push	bc
	push	de
	push	bc
	ld	e, #b_dungeon_present_prepare
	ld	hl, #_dungeon_present_prepare
	call	___sdcc_bcall_ehl
	pop	hl
	pop	de
	pop	bc
	pop	hl
;src/dungeon_play.c:150: p->dungeon.layout[pos]=cell;dungeon_present_door(&p->dungeon,style);
	ld	(hl), e
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_dungeon_present_door
	ld	hl, #_dungeon_present_door
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/dungeon_play.c:151: }
	ret
	.area _CODE_11
	.area _INITIALIZER
	.area _CABS (ABS)
