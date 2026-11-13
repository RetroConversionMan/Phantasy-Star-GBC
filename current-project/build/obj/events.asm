;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module events
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl b_rpg_rest
	.globl _rpg_rest
	.globl b_rpg_shop_option
	.globl _rpg_shop_option
	.globl b_rpg_replace_item
	.globl _rpg_replace_item
	.globl b_rpg_item_discardable
	.globl _rpg_item_discardable
	.globl b_rpg_find_item
	.globl _rpg_find_item
	.globl b_rpg_remove_item
	.globl _rpg_remove_item
	.globl b_rpg_add_item
	.globl _rpg_add_item
	.globl b_rpg_recruit
	.globl _rpg_recruit
	.globl b_event_init
	.globl _event_init
	.globl b_event_begin
	.globl _event_begin
	.globl b_event_advance
	.globl _event_advance
	.globl b_event_respond
	.globl _event_respond
	.globl b_event_replace_item
	.globl _event_replace_item
	.globl b_event_buy_secret
	.globl _event_buy_secret
	.globl b_event_battle_result
	.globl _event_battle_result
	.globl b_event_governor_room_loaded
	.globl _event_governor_room_loaded
	.globl b_event_choose_destination
	.globl _event_choose_destination
	.globl b_event_use_story_item
	.globl _event_use_story_item
	.globl b_event_search
	.globl _event_search
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
	.area _CODE_7
;src/events.c:16: static const EventAction *emit(EventState *s,uint8_t kind,uint16_t dialogue,uint8_t stage) {
;	---------------------------------
; Function emit
; ---------------------------------
_emit:
	ld	c, a
;src/events.c:17: s->stage=stage;s->action.kind=kind;s->action.dialogue_id=dialogue;s->action.sound=0;
	ld	hl, #0x0109
	add	hl, de
	push	hl
	ldhl	sp,	#6
	ld	a, (hl)
	pop	hl
	ld	(hl), a
	ld	hl, #0x011a
	add	hl, de
	ld	(hl), c
	ld	hl, #0x011b
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
	ld	hl, #0x0124
	add	hl, de
	ld	(hl), #0x00
;src/events.c:18: return &s->action;
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
;src/events.c:19: }
	pop	hl
	add	sp, #3
	jp	(hl)
;src/events.c:20: static const EventAction *finish(EventState *s) {return emit(s,EVENT_DONE,0,0);}
;	---------------------------------
; Function finish
; ---------------------------------
_finish:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0000
	push	bc
	xor	a, a
	call	_emit
	ret
;src/events.c:23: static uint8_t has(EventState *s,uint8_t item) RPG_BANKED {return rpg_find_item(s->rpg,item)!=255;}
;	---------------------------------
; Function has
; ---------------------------------
	b_has	= 7
_has:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	b
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	inc	a
	ld	a, #0x01
	jr	Z, 00104$
	xor	a, a
00104$:
	xor	a, #0x01
	ret
;src/events.c:24: static const EventAction *say(EventState *s,uint16_t id,uint8_t next) {return emit(s,EVENT_DIALOGUE,id,next);}
;	---------------------------------
; Function say
; ---------------------------------
_say:
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	a, #0x01
	call	_emit
	pop	hl
	inc	sp
	jp	(hl)
;src/events.c:25: static const EventAction *ask(EventState *s,uint16_t id,uint8_t next) {return emit(s,EVENT_YES_NO,id,next);}
;	---------------------------------
; Function ask
; ---------------------------------
_ask:
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	a, #0x02
	call	_emit
	pop	hl
	inc	sp
	jp	(hl)
;src/events.c:26: static const EventAction *gate(EventState *s,uint8_t index) {
;	---------------------------------
; Function gate
; ---------------------------------
_gate:
	ld	c, a
;src/events.c:27: s->action.target=index;
	ld	hl, #0x0120
	add	hl, de
;src/events.c:28: return index?emit(s,EVENT_TRANSITION,0,0):finish(s);
	ld	a,c
	ld	(hl),a
	or	a, a
	jp	Z, _finish
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0000
	push	bc
	ld	a, #0x08
	call	_emit
;src/events.c:29: }
	ret
;src/events.c:30: static const EventAction *resume(EventState *s) {
;	---------------------------------
; Function resume
; ---------------------------------
_resume:
;src/events.c:31: s->stage=s->resume_stage;s->action.kind=EVENT_DIALOGUE;
	ld	hl, #0x0109
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #0x010a
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
	ld	hl, #0x011a
	add	hl, de
	ld	(hl), #0x01
;src/events.c:32: return event_advance(s);
	push	de
	ld	e, #b_event_advance
	ld	hl, #_event_advance
	call	___sdcc_bcall_ehl
	pop	hl
;src/events.c:33: }
	ret
;src/events.c:34: static const EventAction *give(EventState *s,uint8_t item,uint8_t next) {
;	---------------------------------
; Function give
; ---------------------------------
_give:
	add	sp, #-5
	ldhl	sp,	#3
	ld	(hl), e
	inc	hl
	ld	(hl), d
	dec	hl
	dec	hl
;src/events.c:35: s->pending_item=item;s->action.item=item;s->resume_stage=next;
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010b
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011f
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(bc), a
;src/events.c:36: if(rpg_add_item(s->rpg,item)==RPG_OK) {resume(s);s->action.sound=0xb3;return &s->action;}
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl+), a
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_add_item
	ld	hl, #_rpg_add_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	NZ, 00102$
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_resume
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0124
	add	hl, de
	ld	a, #0xb3
	ld	(hl), a
	ldhl	sp,#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	jr	00103$
00102$:
;src/events.c:37: return ask(s,0xb671,200);
	ld	a, #0xc8
	push	af
	inc	sp
	ld	bc, #0xb671
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
00103$:
;src/events.c:38: }
	add	sp, #5
	pop	hl
	inc	sp
	jp	(hl)
;src/events.c:39: static const EventAction *select_replacement(EventState *s) {
;	---------------------------------
; Function select_replacement
; ---------------------------------
_select_replacement:
;src/events.c:40: s->action.item=s->pending_item;
	ld	hl, #0x011f
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #0x010b
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/events.c:41: return emit(s,EVENT_REPLACE_ITEM,0xb68c,202);
	ld	a, #0xca
	push	af
	inc	sp
	ld	bc, #0xb68c
	push	bc
	ld	a, #0x07
	call	_emit
;src/events.c:42: }
	ret
;src/events.c:43: static const EventAction *luveno_ready(EventState *s) {
;	---------------------------------
; Function luveno_ready
; ---------------------------------
_luveno_ready:
;src/events.c:44: if(!has(s,ItemID_Hapsby))return say(s,0x104,0);
	push	de
	ld	a, #0x32
	push	af
	inc	sp
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	or	a, a
	jr	NZ, 00102$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0104
	call	_say
	ret
00102$:
;src/events.c:45: s->flags[4]=7;return say(s,0x294,0);
	ld	hl, #0x0004
	add	hl, de
	ld	(hl), #0x07
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0294
	call	_say
;src/events.c:46: }
	ret
;src/events.c:47: static const EventAction *battle(EventState *s,uint8_t enemy) {
;	---------------------------------
; Function battle
; ---------------------------------
_battle:
	ld	c, a
;src/events.c:48: s->prepared_enemy=enemy;s->action.target=enemy;return emit(s,EVENT_BATTLE,0,0);
	ld	hl, #0x010e
	add	hl, de
	ld	(hl), c
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), c
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0000
	push	bc
	ld	a, #0x0c
	call	_emit
;src/events.c:49: }
	ret
;src/events.c:50: static void remember_status(EventState *s) {
;	---------------------------------
; Function remember_status
; ---------------------------------
_remember_status:
	add	sp, #-6
	ld	c, e
	ld	b, d
;src/events.c:51: uint8_t i;for(i=0;i<3u;++i)s->battle.status_snapshot[i]=s->rpg->party[i].status;
	ld	hl, #0x0116
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	hl, #0x0100
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl), a
	ld	c, #0x00
00102$:
	pop	de
	push	de
	ld	l, c
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	inc	c
	ld	a, c
	sub	a, #0x03
	jr	C, 00102$
;src/events.c:52: }
	add	sp, #6
	ret
;src/events.c:53: static void restore_status(EventState *s) {
;	---------------------------------
; Function restore_status
; ---------------------------------
_restore_status:
	add	sp, #-5
	ld	c, e
	ld	b, d
;src/events.c:54: uint8_t i;for(i=0;i<3u;++i)s->rpg->party[i].status=s->battle.status_snapshot[i];
	ld	hl, #0x0100
	add	hl, bc
	inc	sp
	inc	sp
	push	hl
	ld	hl, #0x0116
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl+), a
	ld	(hl), #0x00
00102$:
	pop	de
	push	de
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ldhl	sp,	#4
	ld	a, (hl-)
	dec	hl
	swap	a
	and	a, #0xf0
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,	#4
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x03
	jr	C, 00102$
;src/events.c:55: }
	add	sp, #5
	ret
;src/events.c:56: static const EventAction *scene(EventState *s,uint8_t id,uint8_t next) {
;	---------------------------------
; Function scene
; ---------------------------------
_scene:
	ld	c, a
;src/events.c:57: s->action.target=id;return emit(s,EVENT_SCENE,0,next);
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), c
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	ld	bc, #0x0000
	push	bc
	ld	a, #0x13
	call	_emit
;src/events.c:58: }
	pop	hl
	inc	sp
	jp	(hl)
;src/events.c:59: static const EventAction *present(EventState *s,uint8_t effect,uint8_t next) {
;	---------------------------------
; Function present
; ---------------------------------
_present:
	ld	c, a
;src/events.c:60: s->action.target=effect;return emit(s,EVENT_PRESENTATION,0,next);
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), c
	ldhl	sp,	#2
	ld	a, (hl)
	push	af
	inc	sp
	ld	bc, #0x0000
	push	bc
	ld	a, #0x19
	call	_emit
;src/events.c:61: }
	pop	hl
	inc	sp
	jp	(hl)
;src/events.c:62: static const EventAction *death_next(EventState *s) {
;	---------------------------------
; Function death_next
; ---------------------------------
_death_next:
	add	sp, #-7
	ldhl	sp,	#4
	ld	a, e
	ld	(hl+), a
;src/events.c:64: while(s->death_cursor<4u){i=s->death_cursor++;if(s->death_mask&(1u<<i)){s->action.character=i;return say(s,0xb728,DEATH_NEXT);}}
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010f
	add	hl, de
	inc	sp
	inc	sp
	push	hl
00103$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0110
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
	ldhl	sp,	#6
	ld	(hl), a
	sub	a, #0x04
	jr	NC, 00117$
	ld	a, (hl)
	inc	a
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#6
	ld	c, (hl)
	pop	de
	push	de
	ld	a, (de)
	ld	b, c
	ld	hl, #0x0001
	inc	b
	jr	00156$
00155$:
	add	hl, hl
00156$:
	dec	b
	jr	NZ,00155$
	and	a, l
	jr	Z, 00103$
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0123
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
	ld	a, #0x63
	push	af
	inc	sp
	ld	bc, #0xb728
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00111$
;src/events.c:65: for(i=0;i<4u;++i)if(s->rpg->party[i].status&1u)return finish(s);
00117$:
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#6
	ld	(hl), #0x00
00109$:
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#2
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	rrca
	jr	NC, 00110$
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jr	00111$
00110$:
	ldhl	sp,	#6
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00109$
;src/events.c:66: return emit(s,EVENT_GAME_OVER,0,0);
	dec	hl
	dec	hl
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
00111$:
;src/events.c:67: }
	add	sp, #7
	ret
;src/events.c:68: void event_init(EventState *s,RPGState *rpg) RPG_BANKED {
;	---------------------------------
; Function event_init
; ---------------------------------
	b_event_init	= 7
_event_init::
;src/events.c:69: memset(s,0,sizeof(*s));s->rpg=rpg;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0225
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0100
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/events.c:70: s->object_flags[0]=255;s->object_flags[4]=255; /* LABEL_5E8. */
	ld	hl, #0x0125
	add	hl, bc
	ld	(hl), #0xff
	ld	hl, #0x0129
	add	hl, bc
	ld	(hl), #0xff
;src/events.c:71: }
	ret
;src/events.c:72: const EventAction *event_begin(EventState *s,uint8_t type,uint8_t id,uint8_t portrait,uint8_t map_id) RPG_BANKED {
;	---------------------------------
; Function event_begin
; ---------------------------------
	b_event_begin	= 7
_event_begin::
	add	sp, #-11
;src/events.c:73: s->event=id;s->type=type;s->portrait=portrait;s->map_id=map_id;s->stage=0;
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#20
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0105
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#19
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0106
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
	ldhl	sp,	#21
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0107
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#22
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0109
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/events.c:74: memset(&s->action,0,sizeof(s->action));
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x000b
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
;src/events.c:75: memset(&s->battle,0,sizeof(s->battle));s->prepared_enemy=0;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0113
	add	hl, de
	ld	c, l
	ld	b, h
	ld	de, #0x0007
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010e
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/events.c:76: if(type>=0x12 && type<=0x1b) {
	ldhl	sp,	#19
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00108$
	ld	a, #0x1b
	sub	a, (hl)
	jr	C, 00108$
;src/events.c:77: s->action.target=id&31;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0120
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#20
;src/events.c:78: if(type<=0x13) return emit(s,EVENT_HOSPITAL,0xb8c8,0);
	ld	a, (hl-)
	and	a, #0x1f
	ld	(bc), a
	ld	a, #0x13
	sub	a, (hl)
	jr	C, 00102$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0xb8c8
	push	de
	ld	a, #0x04
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00235$
00102$:
;src/events.c:79: if(type<=0x15) return emit(s,EVENT_CHURCH,0,0);
	ld	a, #0x15
	ldhl	sp,	#19
	sub	a, (hl)
	jr	C, 00104$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x05
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00235$
00104$:
;src/events.c:80: if(type<=0x19) return emit(s,EVENT_SHOP,0xb7c7,0);
	ld	a, #0x19
	ldhl	sp,	#19
	sub	a, (hl)
	jr	C, 00106$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0xb7c7
	push	de
	ld	a, #0x03
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00235$
00106$:
;src/events.c:81: return emit(s,EVENT_SELL,0,0);
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x06
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00235$
00108$:
;src/events.c:83: if(!id) return emit(s,EVENT_MENU,0,0);
	ldhl	sp,	#20
	ld	a, (hl)
	or	a, a
	jr	NZ, 00111$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x0a
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00235$
00111$:
;src/events.c:84: if(id>182) return emit(s,EVENT_UNIMPLEMENTED,0,0);
	ld	a, #0xb6
	ldhl	sp,	#20
	sub	a, (hl)
	ld	a, #0x00
	rla
	ldhl	sp,	#8
	ld	(hl), a
	or	a, a
	jr	Z, 00113$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00235$
00113$:
;src/events.c:85: if(event_simple_dialogue[id]) return say(s,event_simple_dialogue[id],0);
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	sla	(hl)
	inc	hl
	rl	(hl)
	pop	de
	push	de
	ld	hl, #_event_simple_dialogue
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
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
	jr	Z, 00115$
	xor	a, a
	push	af
	inc	sp
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00115$:
;src/events.c:86: switch(id) {
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jp	NZ, 00233$
	ldhl	sp,	#20
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #00536$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00536$:
	.dw	00233$
	.dw	00116$
	.dw	00119$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00120$
	.dw	00233$
	.dw	00233$
	.dw	00122$
	.dw	00122$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00127$
	.dw	00127$
	.dw	00233$
	.dw	00130$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00127$
	.dw	00132$
	.dw	00132$
	.dw	00135$
	.dw	00136$
	.dw	00137$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00138$
	.dw	00139$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00140$
	.dw	00143$
	.dw	00233$
	.dw	00149$
	.dw	00233$
	.dw	00233$
	.dw	00151$
	.dw	00151$
	.dw	00152$
	.dw	00165$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00168$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00169$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00170$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00172$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00173$
	.dw	00233$
	.dw	00233$
	.dw	00174$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00175$
	.dw	00176$
	.dw	00233$
	.dw	00233$
	.dw	00177$
	.dw	00179$
	.dw	00233$
	.dw	00233$
	.dw	00180$
	.dw	00181$
	.dw	00182$
	.dw	00185$
	.dw	00233$
	.dw	00190$
	.dw	00195$
	.dw	00179$
	.dw	00196$
	.dw	00233$
	.dw	00233$
	.dw	00197$
	.dw	00198$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00199$
	.dw	00200$
	.dw	00233$
	.dw	00233$
	.dw	00172$
	.dw	00201$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00233$
	.dw	00202$
	.dw	00203$
	.dw	00204$
	.dw	00210$
	.dw	00211$
	.dw	00214$
	.dw	00220$
	.dw	00220$
	.dw	00220$
	.dw	00221$
	.dw	00233$
	.dw	00222$
	.dw	00223$
	.dw	00224$
	.dw	00225$
	.dw	00226$
	.dw	00227$
	.dw	00228$
	.dw	00233$
	.dw	00229$
	.dw	00220$
	.dw	00220$
	.dw	00233$
	.dw	00233$
	.dw	00230$
	.dw	00231$
	.dw	00232$
	.dw	00220$
;src/events.c:87: case 1: /* Suelo marks introduction before speaking, then heals living members only. */
00116$:
;src/events.c:88: if(!s->flags[1]) {s->flags[1]=1;return say(s,2,1);}
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00118$
	ld	a,#0x01
	ld	(hl),a
	push	af
	inc	sp
	ld	bc, #0x0002
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00118$:
;src/events.c:89: return say(s,6,2);
	ld	a, #0x02
	push	af
	inc	sp
	ld	bc, #0x0006
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:90: case 2: return s->flags[2]?say(s,0x10,0):say(s,8,3);
00119$:
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	or	a, a
	jr	Z, 00237$
	dec	hl
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0010
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00237$:
	ld	a, #0x03
	push	af
	inc	sp
	ld	bc, #0x0008
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:91: case 8: return ask(s,0x62,8);
00120$:
	ld	a, #0x08
	push	af
	inc	sp
	ld	bc, #0x0062
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:92: case 11:case 12:
00122$:
;src/events.c:93: if(!has(s,ItemID_RoadPass)) return say(s,id==11?0x20:0x22,0);
	ld	a, #0x33
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	NZ, 00124$
	ldhl	sp,	#20
	ld	a, (hl)
	sub	a, #0x0b
	ld	c, #0x20
	jr	Z, 00240$
	ld	c, #0x22
00240$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00124$:
;src/events.c:94: return say(s,0x24,10);
	ld	a, #0x0a
	push	af
	inc	sp
	ld	bc, #0x0024
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:95: case 19:case 20:case 26:
00127$:
;src/events.c:96: if(s->flags[4]>=7) return say(s,0x19e,21);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x07
	jr	C, 00129$
	ld	a, #0x15
	push	af
	inc	sp
	ld	bc, #0x019e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00129$:
;src/events.c:97: return ask(s,0x70,20);
	ld	a, #0x14
	push	af
	inc	sp
	ld	bc, #0x0070
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:98: case 22:
00130$:
;src/events.c:99: s->prepared_enemy=EnemyID_DrMad;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x47
;src/events.c:100: return s->rpg->party[1].status?ask(s,0x296,22):say(s,0x29a,DR_FIGHT);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0010
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00241$
	ld	a, #0x16
	push	af
	inc	sp
	ld	bc, #0x0296
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
00241$:
	ld	a, #0x47
	push	af
	inc	sp
	ld	bc, #0x029a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:101: case 27:case 28:
00132$:
;src/events.c:102: if(!has(s,ItemID_RoadPass)) return say(s,id==27?0x20:0x22,0);
	ld	a, #0x33
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	NZ, 00134$
	ldhl	sp,	#20
	ld	a, (hl)
	sub	a, #0x1b
	ld	c, #0x20
	jr	Z, 00244$
	ld	c, #0x22
00244$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00134$:
;src/events.c:103: return say(s,0x24,10);
	ld	a, #0x0a
	push	af
	inc	sp
	ld	bc, #0x0024
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:104: case 29: return ask(s,0x72,30); /* Passport application, LABEL_4AD3. */
00135$:
	ld	a, #0x1e
	push	af
	inc	sp
	ld	bc, #0x0072
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:105: case 30: return say(s,(s->rpg->joined_mask&14)?0x3a:0x34,0);
00136$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	ld	a, (hl)
	and	a, #0x0e
	ld	c, #0x3a
	jr	NZ, 00246$
	ld	c, #0x34
00246$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:106: case 31: return say(s,(s->rpg->joined_mask&14)?0x40:0x3c,0);
00137$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	ld	a, (hl)
	and	a, #0x0e
	ld	c, #0x40
	jr	NZ, 00248$
	ld	c, #0x3c
00248$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:107: case 42:return ask(s,0x56,42);
00138$:
	ld	a, #0x2a
	push	af
	inc	sp
	ld	bc, #0x0056
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:108: case 43: return ask(s,0x5c,43);
00139$:
	ld	a, #0x2b
	push	af
	inc	sp
	ld	bc, #0x005c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:109: case 54: /* Myau exchange: original Party_curr_num test, price question is dialogue only. */
00140$:
;src/events.c:110: if(s->rpg->joined_mask&14) return say(s,0x28a,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	ld	a, (hl)
	and	a, #0x0e
	jr	Z, 00142$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x028a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00142$:
;src/events.c:111: s->action.number=10;return ask(s,0x92,50);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x0a
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, #0x32
	push	af
	inc	sp
	ld	bc, #0x0092
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:112: case 55:
00143$:
;src/events.c:113: if(s->flags[22])return say(s,0x2a6,55);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0016
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00145$
	ld	a, #0x37
	push	af
	inc	sp
	ld	bc, #0x02a6
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00145$:
;src/events.c:114: s->portrait=0x35;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x35
;src/events.c:115: if((s->rpg->joined_mask&8u)||has(s,ItemID_Letter))return say(s,0x29e,56);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	bit	3, (hl)
	jr	NZ, 00146$
	ld	a, #0x37
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00147$
00146$:
	ld	a, #0x38
	push	af
	inc	sp
	ld	bc, #0x029e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00147$:
;src/events.c:116: return say(s,0xa4,GOV_GIVE);
	ld	a, #0x48
	push	af
	inc	sp
	ld	bc, #0x00a4
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:117: case 57: return say(s,0xb6,57);
00149$:
	ld	a, #0x39
	push	af
	inc	sp
	ld	bc, #0x00b6
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:118: case 60:case 61: return ask(s,0xba,60);
00151$:
	ld	a, #0x3c
	push	af
	inc	sp
	ld	bc, #0x00ba
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:119: case 62:
00152$:
;src/events.c:120: if(!s->flags[4])return finish(s);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00154$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00235$
00154$:
;src/events.c:121: s->portrait=0x34;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x34
;src/events.c:122: if(s->flags[4]>=7)return say(s,0xd8,0);
	ld	a, (bc)
	cp	a, #0x07
	jr	C, 00156$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00d8
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00156$:
;src/events.c:123: if(s->flags[4]==1)return say(s,0xca,0);
	cp	a, #0x01
	jr	NZ, 00158$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00ca
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00158$:
;src/events.c:124: if(s->flags[4]==2){s->action.number=1200;return ask(s,0x28c,62);}
	cp	a, #0x02
	jr	NZ, 00160$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011d
	add	hl, de
	ld	a, #0xb0
	ld	(hl+), a
	ld	(hl), #0x04
	ld	a, #0x3e
	push	af
	inc	sp
	ld	bc, #0x028c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
00160$:
;src/events.c:125: if(s->flags[4]<5){++s->flags[4];return say(s,0x292,0);}
	cp	a, #0x05
	jr	NC, 00162$
	inc	a
	ld	(bc), a
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0292
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00162$:
;src/events.c:126: if(s->flags[4]==5){s->flags[4]=6;return say(s,0xd2,62);}
	sub	a, #0x05
	jr	NZ, 00164$
	ld	a, #0x06
	ld	(bc), a
	ld	a, #0x3e
	push	af
	inc	sp
	ld	bc, #0x00d2
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00164$:
;src/events.c:127: return luveno_ready(s);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_luveno_ready
	jp	00235$
;src/events.c:128: case 63:if(s->flags[4]<2)return finish(s);s->portrait=0x10;return say(s,0xdc,0);
00165$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x02
	jr	NC, 00167$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00235$
00167$:
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x10
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00dc
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:129: case 67: return ask(s,0x114,67);
00168$:
	ld	a, #0x43
	push	af
	inc	sp
	ld	bc, #0x0114
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:130: case 78:return ask(s,0x13a,78);
00169$:
	ld	a, #0x4e
	push	af
	inc	sp
	ld	bc, #0x013a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:131: case 85:return ask(s,0x172,85);
00170$:
	ld	a, #0x55
	push	af
	inc	sp
	ld	bc, #0x0172
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:132: case 93:case 146:s->action.number=1000;return ask(s,0x194,93);
00172$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011d
	add	hl, de
	ld	a, #0xe8
	ld	(hl+), a
	ld	(hl), #0x03
	ld	a, #0x5d
	push	af
	inc	sp
	ld	bc, #0x0194
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:133: case 108:return ask(s,0x1d6,108);
00173$:
	ld	a, #0x6c
	push	af
	inc	sp
	ld	bc, #0x01d6
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:134: case 111:s->action.number=10;return say(s,0x1e0,0);
00174$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x0a
	inc	bc
	xor	a, a
	ld	(bc), a
	push	af
	inc	sp
	ld	bc, #0x01e0
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:135: case 116:s->action.number=400;return ask(s,0x1ea,116);
00175$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011d
	add	hl, de
	ld	a, #0x90
	ld	(hl+), a
	ld	(hl), #0x01
	ld	a, #0x74
	push	af
	inc	sp
	ld	bc, #0x01ea
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:136: case 117:return ask(s,0x1fa,117);
00176$:
	ld	a, #0x75
	push	af
	inc	sp
	ld	bc, #0x01fa
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:137: case 120:return ask(s,0x204,120);
00177$:
	ld	a, #0x78
	push	af
	inc	sp
	ld	bc, #0x0204
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:138: case 121:case 131:return ask(s,0xba,60);
00179$:
	ld	a, #0x3c
	push	af
	inc	sp
	ld	bc, #0x00ba
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:139: case 124:s->action.number=280;return ask(s,0x24a,124);
00180$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011d
	add	hl, de
	ld	a, #0x18
	ld	(hl+), a
	ld	(hl), #0x01
	ld	a, #0x7c
	push	af
	inc	sp
	ld	bc, #0x024a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:140: case 125:s->prepared_enemy=8;return say(s,(s->rpg->joined_mask&8u)?0xb2:0xac,0);
00181$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x08
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	bit	3, (hl)
	ld	c, #0xb2
	jr	NZ, 00250$
	ld	c, #0xac
00250$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:141: case 126:if(s->rpg->joined_mask&8u)return finish(s);s->portrait=0x3b;return say(s,0xae,126);
00182$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	bit	3, (hl)
	jr	Z, 00184$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00235$
00184$:
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x3b
	ld	a, #0x7e
	push	af
	inc	sp
	ld	bc, #0x00ae
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:142: case 127:
00185$:
;src/events.c:143: if(s->flags[4]>=2)return finish(s);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x02
	jr	C, 00187$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00235$
00187$:
;src/events.c:144: s->portrait=0x10;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x10
;src/events.c:145: if(s->flags[4]==1){s->flags[4]=2;return say(s,0xf6,0);}
	ld	a, (bc)
	dec	a
	jr	NZ, 00189$
	ld	a, #0x02
	ld	(bc), a
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00f6
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00189$:
;src/events.c:146: return say(s,0xdc,0);
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00dc
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:147: case 129:
00190$:
;src/events.c:148: if(s->flags[4])return finish(s);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00192$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00235$
00192$:
;src/events.c:149: s->portrait=0x34;
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x34
;src/events.c:150: if(s->flags[3]<2)return say(s,s->flags[3]++?0xe0:0xde,0);
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	cp	a, #0x02
	jr	NC, 00194$
	ld	c, a
	inc	c
	ld	(hl), c
	or	a, a
	ld	c, #0xe0
	jr	NZ, 00252$
	ld	c, #0xde
00252$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00194$:
;src/events.c:151: return ask(s,0xe2,129);
	ld	a, #0x81
	push	af
	inc	sp
	ld	bc, #0x00e2
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:152: case 130:s->prepared_enemy=46;return ask(s,0xe6,130);
00195$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x2e
	ld	a, #0x82
	push	af
	inc	sp
	ld	bc, #0x00e6
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:153: case 132:return ask(s,0xec,132);
00196$:
	ld	a, #0x84
	push	af
	inc	sp
	ld	bc, #0x00ec
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:154: case 135:return ask(s,0xf2,135);
00197$:
	ld	a, #0x87
	push	af
	inc	sp
	ld	bc, #0x00f2
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:155: case 136:s->prepared_enemy=22;return say(s,0xf4,0);
00198$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x16
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00f4
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:156: case 142:return ask(s,0x148,142);
00199$:
	ld	a, #0x8e
	push	af
	inc	sp
	ld	bc, #0x0148
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:157: case 143:return ask(s,0x160,148);
00200$:
	ld	a, #0x94
	push	af
	inc	sp
	ld	bc, #0x0160
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:158: case 147:s->prepared_enemy=46;return ask(s,0x21c,147);
00201$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x2e
	ld	a, #0x93
	push	af
	inc	sp
	ld	bc, #0x021c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:159: case 155:s->prepared_enemy=46;return ask(s,0x9c,155);
00202$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x2e
	ld	a, #0x9b
	push	af
	inc	sp
	ld	bc, #0x009c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:160: case 156:return ask(s,0x23e,156);
00203$:
	ld	a, #0x9c
	push	af
	inc	sp
	ld	bc, #0x023e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:161: case 157:
00204$:
;src/events.c:162: s->prepared_enemy=EnemyID_Tarzimal;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x31
;src/events.c:163: if(s->rpg->party[3].armor==ItemID_FradeMantle||has(s,ItemID_FradeMantle))return say(s,0x258,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	de, #0x003b
	add	hl, de
	ld	a, (hl)
	sub	a, #0x18
	jr	Z, 00205$
	push	bc
	ld	a, #0x18
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	or	a, a
	jr	Z, 00206$
00205$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0258
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00206$:
;src/events.c:164: if(!(s->rpg->joined_mask&8u))return ask(s,0x25a,157);
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	bit	3, (hl)
	jr	NZ, 00209$
	ld	a, #0x9d
	push	af
	inc	sp
	ld	bc, #0x025a
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
00209$:
;src/events.c:165: return say(s,0x24c,TARZ_CHECK);
	ld	a, #0x50
	push	af
	inc	sp
	ld	bc, #0x024c
	ldhl	sp,	#18
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:166: case 158:s->prepared_enemy=EnemyID_Shadow;return say(s,0x262,SHADOW_FIGHT);
00210$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x3e
	ld	a, #0x53
	push	af
	inc	sp
	ld	bc, #0x0262
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:167: case 159:
00211$:
;src/events.c:168: if(s->flags[22])return finish(s);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0016
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00213$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00235$
00213$:
;src/events.c:169: s->prepared_enemy=EnemyID_Lassic;return ask(s,0x26c,159);
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x48
	ld	a, #0x9f
	push	af
	inc	sp
	ld	bc, #0x026c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:170: case 160:return say(s,0xb7aa,0);
00214$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb7aa
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:171: case 161:case 162:case 163:case 175:case 176:case 182:return emit(s,EVENT_MENU,0,0);
00220$:
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x0a
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00235$
;src/events.c:172: case 164:s->prepared_enemy=43;return say(s,0x234,0);
00221$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x2b
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0234
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:173: case 166:s->prepared_enemy=27;s->action.target=0xc3;s->action.a=0;return emit(s,EVENT_DUNGEON_CELL,0,166);
00222$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x1b
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0120
	add	hl, de
	ld	c, l
	ld	(hl), #0xc3
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0121
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ld	a, #0xa6
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x14
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00235$
;src/events.c:174: case 167:s->battle.options=EVENT_BATTLE_ZERO_MONEY;return battle(s,38);
00223$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0113
	add	hl, de
	ld	(hl), #0x02
	ld	a, #0x26
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_battle
	jp	00235$
;src/events.c:175: case 168:return ask(s,0x228,168);
00224$:
	ld	a, #0xa8
	push	af
	inc	sp
	ld	bc, #0x0228
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00235$
;src/events.c:176: case 169:s->prepared_enemy=8;return say(s,0x212,0);
00225$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x08
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0212
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:177: case 170:return s->flags[4]<7?say(s,0x282,0):say(s,0x284,GOTHIC_TRANS);
00226$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x07
	jr	NC, 00253$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0282
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
00253$:
	ld	a, #0x5e
	push	af
	inc	sp
	ld	bc, #0x0284
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00235$
;src/events.c:178: case 171:s->prepared_enemy=EnemyID_DarkFalz;return emit(s,EVENT_DARK_FALZ_REVEAL,0,DARK_FIGHT);
00227$:
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x49
	ld	a, #0x60
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x17
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jr	00235$
;src/events.c:179: case 172:return emit(s,EVENT_GOVERNOR_ROOM,0,ENDING_PROMPT);
00228$:
	ld	a, #0x61
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x18
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jr	00235$
;src/events.c:180: case 174:s->death_cursor=0;return death_next(s);
00229$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0110
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_death_next
	jr	00235$
;src/events.c:181: case 179:return ask(s,0xbdce,179);
00230$:
	ld	a, #0xb3
	push	af
	inc	sp
	ld	bc, #0xbdce
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jr	00235$
;src/events.c:182: case 180:return ask(s,0xbde6,180);
00231$:
	ld	a, #0xb4
	push	af
	inc	sp
	ld	bc, #0xbde6
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jr	00235$
;src/events.c:183: case 181:return emit(s,EVENT_TRAVEL_MENU,0xb754,0);
00232$:
	xor	a, a
	push	af
	inc	sp
	ld	de, #0xb754
	push	de
	ld	a, #0x10
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jr	00235$
;src/events.c:184: default: return emit(s,EVENT_UNIMPLEMENTED,0,0);
00233$:
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
;src/events.c:185: }
00235$:
;src/events.c:186: }
	add	sp, #11
	ret
;src/events.c:187: const EventAction *event_advance(EventState *s) RPG_BANKED {
;	---------------------------------
; Function event_advance
; ---------------------------------
	b_event_advance	= 7
_event_advance::
	add	sp, #-6
;src/events.c:190: if(s->action.kind==EVENT_YES_NO || s->action.kind==EVENT_REPLACE_ITEM) return &s->action;
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#5
	ld	(hl), a
	sub	a, #0x02
	jr	Z, 00101$
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00102$
00101$:
	pop	de
	push	de
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	jp	00205$
00102$:
;src/events.c:191: switch(s->stage) {
	pop	de
	push	de
	ld	hl, #0x0109
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jp	Z, 00104$
	cp	a, #0x01
	jp	Z, 00105$
	cp	a, #0x02
	jp	Z, 00106$
	cp	a, #0x03
	jp	Z, 00108$
	cp	a, #0x04
	jp	Z, 00109$
	cp	a, #0x0a
	jp	Z, 00112$
	cp	a, #0x15
	jp	Z, 00117$
	cp	a, #0x16
	jp	Z, 00120$
	cp	a, #0x1a
	jp	Z, 00121$
	cp	a, #0x22
	jp	Z, 00122$
	cp	a, #0x34
	jp	Z, 00125$
	cp	a, #0x35
	jp	Z, 00126$
	cp	a, #0x37
	jp	Z, 00127$
	cp	a, #0x38
	jp	Z, 00128$
	cp	a, #0x39
	jp	Z, 00129$
	cp	a, #0x3a
	jp	Z, 00132$
	cp	a, #0x3b
	jp	Z, 00133$
	cp	a, #0x3e
	jp	Z, 00135$
	cp	a, #0x3f
	jp	Z, 00138$
	cp	a, #0x40
	jp	Z, 00134$
	cp	a, #0x46
	jp	Z, 00139$
	cp	a, #0x47
	jp	Z, 00140$
	cp	a, #0x48
	jp	Z, 00144$
	cp	a, #0x49
	jp	Z, 00145$
	cp	a, #0x4a
	jp	Z, 00146$
	cp	a, #0x4b
	jp	Z, 00147$
	cp	a, #0x4c
	jp	Z, 00148$
	cp	a, #0x4d
	jp	Z, 00150$
	cp	a, #0x50
	jp	Z, 00151$
	cp	a, #0x51
	jp	Z, 00152$
	cp	a, #0x52
	jp	Z, 00153$
	cp	a, #0x53
	jp	Z, 00154$
	cp	a, #0x54
	jp	Z, 00155$
	cp	a, #0x5a
	jp	Z, 00156$
	cp	a, #0x5b
	jp	Z, 00157$
	cp	a, #0x5c
	jp	Z, 00158$
	cp	a, #0x5d
	jp	Z, 00166$
	cp	a, #0x5e
	jp	Z, 00159$
	cp	a, #0x5f
	jp	Z, 00160$
	cp	a, #0x60
	jp	Z, 00161$
	cp	a, #0x61
	jp	Z, 00162$
	cp	a, #0x62
	jp	Z, 00163$
	cp	a, #0x63
	jp	Z, 00164$
	cp	a, #0x64
	jp	Z, 00165$
	cp	a, #0x7c
	jp	Z, 00167$
	cp	a, #0x7e
	jp	Z, 00168$
	cp	a, #0x8e
	jp	Z, 00171$
	cp	a, #0x8f
	jp	Z, 00172$
	cp	a, #0x90
	jp	Z, 00173$
	cp	a, #0x92
	jp	Z, 00174$
	cp	a, #0x9c
	jp	Z, 00175$
	cp	a, #0xa6
	jp	Z, 00176$
	cp	a, #0xaa
	jp	Z, 00177$
	cp	a, #0xab
	jp	Z, 00184$
	cp	a, #0xac
	jp	Z, 00185$
	cp	a, #0xad
	jp	Z, 00192$
	cp	a, #0xae
	jp	Z, 00195$
	cp	a, #0xb1
	jp	Z, 00196$
	cp	a, #0xb2
	jp	Z, 00197$
	cp	a, #0xbe
	jr	Z, 00107$
	cp	a, #0xbf
	jp	Z, 00130$
	cp	a, #0xc0
	jp	Z, 00131$
	cp	a, #0xc1
	jp	Z, 00149$
	cp	a, #0xcb
	jp	Z, 00198$
	cp	a, #0xcc
	jp	Z, 00199$
	sub	a, #0xcd
	jp	Z, 00200$
	jp	00203$
;src/events.c:192: case 0:return finish(s);
00104$:
	pop	de
	push	de
	call	_finish
	jp	00205$
;src/events.c:193: case 1:return say(s,6,2);
00105$:
	ld	a, #0x02
	push	af
	inc	sp
	ld	bc, #0x0006
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:194: case 2:
00106$:
;src/events.c:195: present(s,EVENT_PRESENT_SUEL_HEAL,SUEL_HEAL);s->action.sound=0xc1;return &s->action;
	ld	a, #0xbe
	push	af
	inc	sp
	xor	a, a
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_present
	ldhl	sp,	#12
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	hl, #0x0124
	add	hl, bc
	ld	(hl), #0xc1
	ld	hl, #0x011a
	add	hl, bc
	ld	c, l
	ld	b, h
	jp	00205$
;src/events.c:196: case SUEL_HEAL:rpg_rest(s->rpg);return finish(s);
00107$:
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	e, #b_rpg_rest
	ld	hl, #_rpg_rest
	call	___sdcc_bcall_ehl
	pop	hl
	pop	de
	push	de
	call	_finish
	jp	00205$
;src/events.c:197: case 3:return give(s,ItemID_LaconiaPot,4);
00108$:
	ld	a, #0x04
	push	af
	inc	sp
	ld	a, #0x38
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:198: case 4:
00109$:
;src/events.c:199: if(has(s,ItemID_LaconiaPot)) s->flags[2]=1;
	ld	a, #0x38
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00111$
	pop	hl
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0x01
00111$:
;src/events.c:200: return say(s,0x10,0);
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0010
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:201: case 10:
00112$:
;src/events.c:202: if(s->event==27) return gate(s,4);
	pop	de
	push	de
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	cp	a, #0x1b
	jr	NZ, 00114$
	ld	a, #0x04
	pop	de
	push	de
	call	_gate
	jp	00205$
00114$:
;src/events.c:203: if(s->event==28) return gate(s,5);
	sub	a, #0x1c
	jr	NZ, 00116$
	ld	a, #0x05
	pop	de
	push	de
	call	_gate
	jp	00205$
00116$:
;src/events.c:204: return gate(s,(uint8_t)(((s->map_id>>1)-1)&3));
	pop	de
	push	de
	ld	hl, #0x0107
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	srl	a
	dec	a
	and	a, #0x03
	pop	de
	push	de
	call	_gate
	jp	00205$
;src/events.c:205: case 21:
00117$:
;src/events.c:206: slot=rpg_find_item(s->rpg,ItemID_Passport);
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	ld	a, #0x34
	push	af
	inc	sp
	push	hl
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#7
	ld	(hl), a
	pop	bc
;src/events.c:207: if(slot==255) return finish(s);
	ldhl	sp,	#5
	ld	a, (hl)
	inc	a
	jr	NZ, 00119$
	pop	de
	push	de
	call	_finish
	jp	00205$
00119$:
;src/events.c:208: rpg_remove_item(s->rpg,slot);return say(s,0x1a0,0);
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#5
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x01a0
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:209: case 22:return gate(s,6);
00120$:
	ld	a, #0x06
	pop	de
	push	de
	call	_gate
	jp	00205$
;src/events.c:210: case 26:
00121$:
;src/events.c:211: s->action.target=5;s->action.a=s->packed_y==0x60?0x21:0x20;
	pop	de
	push	de
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), #0x05
	pop	de
	push	de
	ld	hl, #0x0121
	add	hl, de
	push	hl
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0108
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x60
	ld	a, #0x21
	jr	Z, 00208$
	ld	a, #0x20
00208$:
	ld	(de), a
;src/events.c:212: s->action.b=s->packed_y==0x60?0x15:0x17;
	pop	de
	push	de
	ld	hl, #0x0122
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (bc)
	sub	a, #0x60
	ld	a, #0x15
	jr	Z, 00210$
	ld	a, #0x17
00210$:
	ld	(de), a
;src/events.c:213: return emit(s,EVENT_MAP_TRANSITION,0,0);
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x09
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:214: case 34:
00122$:
;src/events.c:215: if(has(s,ItemID_Passport)) return finish(s);
	ld	a, #0x34
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00124$
	pop	de
	push	de
	call	_finish
	jp	00205$
00124$:
;src/events.c:216: return give(s,ItemID_Passport,0);
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x34
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:217: case 52:
00125$:
;src/events.c:218: rpg_recruit(s->rpg,1);
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_recruit
	ld	hl, #_rpg_recruit
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/events.c:219: return give(s,ItemID_Alsulin,64);
	ld	a, #0x40
	push	af
	inc	sp
	ld	a, #0x2b
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:220: case 53:return emit(s,EVENT_GOVERNOR_ROOM,0,ENDING_PROMPT);
00126$:
	ld	a, #0x61
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x18
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:221: case 55:
00127$:
;src/events.c:222: s->action.target=0x22;s->action.a=0xe6;s->action.b=0;return emit(s,EVENT_DUNGEON_FALL,0,0);
	pop	de
	push	de
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), #0x22
	pop	de
	push	de
	ld	hl, #0x0121
	add	hl, de
	ld	(hl), #0xe6
	pop	de
	push	de
	ld	hl, #0x0122
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x16
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:223: case 56:return say(s,0xaa,0);
00128$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00aa
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:224: case 57:return present(s,EVENT_PRESENT_GUEST_SLEEP,GUEST_HEAL);
00129$:
	ld	a, #0xbf
	push	af
	inc	sp
	ld	a, #0x01
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_present
	jp	00205$
;src/events.c:225: case GUEST_HEAL:
00130$:
;src/events.c:226: rpg_rest(s->rpg);present(s,EVENT_PRESENT_GUEST_WAKE,GUEST_DONE);s->action.sound=0xc1;return &s->action;
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	e, #b_rpg_rest
	ld	hl, #_rpg_rest
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, #0xc0
	push	af
	inc	sp
	ld	a, #0x02
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_present
	ldhl	sp,	#12
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	hl, #0x0124
	add	hl, bc
	ld	(hl), #0xc1
	ld	hl, #0x011a
	add	hl, bc
	ld	c, l
	ld	b, h
	jp	00205$
;src/events.c:227: case GUEST_DONE:return say(s,0xb8,0);
00131$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00b8
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:228: case 58:return emit(s,EVENT_GOVERNOR_ROOM,0,59);
00132$:
	ld	a, #0x3b
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x18
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:229: case 59:s->portrait=0x35;return say(s,0xaa,0);
00133$:
	pop	de
	push	de
	ld	hl, #0x0106
	add	hl, de
	ld	(hl), #0x35
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00aa
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:230: case 64:s->action.target=1;return emit(s,EVENT_CUTSCENE,0,0);
00134$:
	pop	de
	push	de
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), #0x01
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x15
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:231: case 62:
00135$:
;src/events.c:232: if(has(s,ItemID_Hapsby))return luveno_ready(s);
	ld	a, #0x32
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00137$
	pop	de
	push	de
	call	_luveno_ready
	jp	00205$
00137$:
;src/events.c:233: return say(s,0xd6,63);
	ld	a, #0x3f
	push	af
	inc	sp
	ld	bc, #0x00d6
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:234: case 63:return luveno_ready(s);
00138$:
	pop	de
	push	de
	call	_luveno_ready
	jp	00205$
;src/events.c:235: case DR_KILL:s->rpg->party[1].status=0;s->rpg->party[1].hp=0;return say(s,0x298,DR_FIGHT);
00139$:
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0010
	add	hl, de
	ld	(hl), #0x00
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0011
	add	hl, bc
	ld	(hl), #0x00
	ld	a, #0x47
	push	af
	inc	sp
	ld	bc, #0x0298
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:236: case DR_FIGHT:
00140$:
;src/events.c:237: if((s->rpg->joined_mask&14u)&&!has(s,ItemID_LaconiaPot)) {
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	ld	a, (hl)
	and	a, #0x0e
	jr	Z, 00142$
	ld	a, #0x38
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	NZ, 00142$
;src/events.c:238: s->battle.options|=EVENT_BATTLE_OVERRIDE_ITEM;s->battle.item_reward=ItemID_LaconiaPot;s->battle.flag_index=24;
	pop	de
	push	de
	ld	hl, #0x0113
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	set	0, a
	ld	(bc), a
	pop	de
	push	de
	ld	hl, #0x0114
	add	hl, de
	ld	(hl), #0x38
	pop	de
	push	de
	ld	hl, #0x0115
	add	hl, de
	ld	(hl), #0x18
00142$:
;src/events.c:240: return battle(s,EnemyID_DrMad);
	ld	a, #0x47
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_battle
	jp	00205$
;src/events.c:241: case GOV_GIVE:return give(s,ItemID_Letter,GOV_CHECK);
00144$:
	ld	a, #0x49
	push	af
	inc	sp
	ld	a, #0x37
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:242: case GOV_CHECK:return has(s,ItemID_Letter)?say(s,0x29c,GOV_SLEEP):finish(s);
00145$:
	ld	a, #0x37
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00211$
	ld	a, #0x4a
	push	af
	inc	sp
	ld	bc, #0x029c
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00211$:
	pop	de
	push	de
	call	_finish
	jp	00205$
;src/events.c:243: case GOV_SLEEP:return present(s,EVENT_PRESENT_NIGHTMARE_SCENE,GOV_NIGHTMARE);
00146$:
	ld	a, #0x4b
	push	af
	inc	sp
	ld	a, #0x03
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_present
	jp	00205$
;src/events.c:244: case GOV_NIGHTMARE:return say(s,0x2a0,GOV_WAKE);
00147$:
	ld	a, #0x4c
	push	af
	inc	sp
	ld	bc, #0x02a0
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:245: case GOV_WAKE:return present(s,EVENT_PRESENT_NIGHTMARE_HOLD,NIGHTMARE_BATTLE);
00148$:
	ld	a, #0xc1
	push	af
	inc	sp
	ld	a, #0x04
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_present
	jp	00205$
;src/events.c:246: case NIGHTMARE_BATTLE:remember_status(s);return battle(s,EnemyID_Saccubus);
00149$:
	pop	de
	push	de
	call	_remember_status
	ld	a, #0x4a
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_battle
	jp	00205$
;src/events.c:247: case GOV_REST:return say(s,0x2a2,58);
00150$:
	ld	a, #0x3a
	push	af
	inc	sp
	ld	bc, #0x02a2
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:248: case TARZ_CHECK:return s->rpg->party[3].status?say(s,0x24e,TARZ_FIGHT):say(s,0x2a8,0);
00151$:
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0030
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00213$
	ld	a, #0x51
	push	af
	inc	sp
	ld	bc, #0x024e
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00213$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x02a8
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:249: case TARZ_FIGHT:
00152$:
;src/events.c:250: remember_status(s);s->battle.noah_hp=s->rpg->party[3].hp;
	pop	de
	push	de
	call	_remember_status
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0119
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0031
	add	hl, de
	ld	a, (hl)
	ldhl	sp,	#4
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/events.c:251: s->rpg->party[0].status=0;s->rpg->party[1].status=0;s->rpg->party[2].status=0;
	ld	l, c
	ld	h, b
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	l, c
	ld	h, b
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0010
	add	hl, de
	ld	(hl), #0x00
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0020
	add	hl, bc
	ld	(hl), #0x00
;src/events.c:252: return battle(s,EnemyID_Tarzimal);
	ld	a, #0x31
	ldhl	sp,	#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_battle
	jp	00205$
;src/events.c:253: case TARZ_REWARD:return give(s,ItemID_FradeMantle,0);
00153$:
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x18
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:254: case SHADOW_FIGHT:return battle(s,EnemyID_Shadow);
00154$:
	ld	a, #0x3e
	pop	de
	push	de
	call	_battle
	jp	00205$
;src/events.c:255: case LASSIC_FIGHT:return battle(s,EnemyID_Lassic);
00155$:
	ld	a, #0x48
	pop	de
	push	de
	call	_battle
	jp	00205$
;src/events.c:256: case ROBOT_FIGHT:return battle(s,46);
00156$:
	ld	a, #0x2e
	pop	de
	push	de
	call	_battle
	jp	00205$
;src/events.c:257: case ROBOT_WARP:s->action.target=0x15;s->action.a=0x9c;s->action.b=1;return emit(s,EVENT_DUNGEON,0,0);
00157$:
	pop	de
	push	de
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), #0x15
	pop	de
	push	de
	ld	hl, #0x0121
	add	hl, de
	ld	c, l
	ld	(hl), #0x9c
	pop	de
	push	de
	ld	hl, #0x0122
	add	hl, de
	ld	(hl), #0x01
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x0d
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:258: case GUARD_RETREAT:return emit(s,EVENT_DUNGEON_BACK,0,0);
00158$:
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x0e
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:259: case GOTHIC_TRANS:
00159$:
;src/events.c:260: s->action.target=7;s->action.a=0x1b;s->action.b=s->camera_x_low>=0x40?0x1b:0x1d;
	pop	de
	push	de
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), #0x07
	pop	de
	push	de
	ld	hl, #0x0121
	add	hl, de
	ld	b, h
	ld	(hl), #0x1b
	pop	de
	push	de
	ld	hl, #0x0122
	add	hl, de
	ld	c, l
	ld	b, h
	pop	de
	push	de
	ld	hl, #0x0111
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	sub	a, #0x40
	jr	C, 00215$
	ld	a, #0x1b
	jr	00216$
00215$:
	ld	a, #0x1d
00216$:
	ld	(bc), a
;src/events.c:261: return emit(s,EVENT_MAP_TRANSITION,0,0);
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x09
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:262: case DARK_SCENE:return scene(s,0x20,DARK_FIGHT);
00160$:
	ld	a, #0x60
	push	af
	inc	sp
	ld	a, #0x20
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_scene
	jp	00205$
;src/events.c:263: case DARK_FIGHT:return battle(s,EnemyID_DarkFalz);
00161$:
	ld	a, #0x49
	pop	de
	push	de
	call	_battle
	jp	00205$
;src/events.c:264: case ENDING_PROMPT:s->portrait=0x35;return ask(s,0x272,172);
00162$:
	pop	de
	push	de
	ld	hl, #0x0106
	add	hl, de
	ld	(hl), #0x35
	ld	a, #0xac
	push	af
	inc	sp
	ld	bc, #0x0272
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00205$
;src/events.c:265: case ENDING_RUN:return emit(s,EVENT_ENDING,0,0);
00163$:
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x11
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:266: case DEATH_NEXT:return death_next(s);
00164$:
	pop	de
	push	de
	call	_death_next
	jp	00205$
;src/events.c:267: case TRAVEL_AGAIN:return emit(s,EVENT_TRAVEL_MENU,0xb754,0);
00165$:
	xor	a, a
	push	af
	inc	sp
	ld	de, #0xb754
	push	de
	ld	a, #0x10
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:268: case 93:
00166$:
;src/events.c:269: return has(s,ItemID_GasShield)?finish(s):give(s,ItemID_GasShield,0);
	ld	a, #0x3b
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00217$
	pop	de
	push	de
	call	_finish
	jp	00205$
00217$:
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x3b
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:270: case 124:return has(s,ItemID_Cake)?finish(s):give(s,ItemID_Cake,0);
00167$:
	ld	a, #0x36
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00219$
	pop	de
	push	de
	call	_finish
	jp	00205$
00219$:
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x36
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:271: case 126:
00168$:
;src/events.c:272: slot=rpg_find_item(s->rpg,ItemID_Letter);
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	ld	a, #0x37
	push	af
	inc	sp
	push	hl
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#5
	ld	(hl), a
	pop	bc
;src/events.c:273: if(slot==255)return finish(s);
	ldhl	sp,	#3
	ld	a, (hl)
	inc	a
	jr	NZ, 00170$
	pop	de
	push	de
	call	_finish
	jp	00205$
00170$:
;src/events.c:274: rpg_remove_item(s->rpg,slot);s->flags[6]=1;rpg_recruit(s->rpg,3);s->action.target=3;return emit(s,EVENT_CUTSCENE,0,0);
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	push	bc
	ld	a, (hl+)
	push	af
	inc	sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	pop	de
	push	de
	ld	hl, #0x0006
	add	hl, de
	ld	d, h
	ld	(hl), #0x01
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x03
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_recruit
	ld	hl, #_rpg_recruit
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	push	de
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), #0x03
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x15
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:275: case 142:return ask(s,0x150,143);
00171$:
	ld	a, #0x8f
	push	af
	inc	sp
	ld	bc, #0x0150
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00205$
;src/events.c:276: case 143:return ask(s,0x154,144);
00172$:
	ld	a, #0x90
	push	af
	inc	sp
	ld	bc, #0x0154
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00205$
;src/events.c:277: case 144:return ask(s,0x156,145);
00173$:
	ld	a, #0x91
	push	af
	inc	sp
	ld	bc, #0x0156
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00205$
;src/events.c:278: case 146:return has(s,ItemID_Crystal)?finish(s):give(s,ItemID_Crystal,0);
00174$:
	ld	a, #0x3c
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,#5
	ld	(hl), a
	or	a, a
	jr	Z, 00221$
	pop	de
	push	de
	call	_finish
	ldhl	sp,	#4
	ld	(hl), c
	inc	hl
	ld	(hl), b
	jr	00222$
00221$:
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x3c
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	ldhl	sp,	#4
	ld	(hl), c
	inc	hl
	ld	(hl), b
00222$:
	ldhl	sp,	#4
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	00205$
;src/events.c:279: case 156:return say(s,0x244,0);
00175$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0244
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:280: case 166:return say(s,0x238,0);
00176$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0238
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:281: case 170: /* ItemUse_Alsulin: Myau alone cannot open the bottle. */
00177$:
;src/events.c:282: if(s->item_in_battle)return say(s,0xb35c,0);
	pop	de
	push	de
	ld	hl, #0x010d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00179$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb35c
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00179$:
;src/events.c:283: if(!(s->rpg->party[0].status|s->rpg->party[2].status|s->rpg->party[3].status))return say(s,0xb3e3,0);
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, (bc)
	ld	e, a
	ld	hl, #0x0020
	add	hl, bc
	ld	a, (hl)
	or	a, e
	ld	e, a
	ld	hl, #0x0030
	add	hl, bc
	ld	a, (hl)
	or	a, e
	or	a, a
	jr	NZ, 00181$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb3e3
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00181$:
;src/events.c:284: if(s->event!=0xa3)return say(s,0xb569,0);
	pop	de
	push	de
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0xa3
	jr	Z, 00183$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb569
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00183$:
;src/events.c:285: return say(s,0xb3b1,171);
	ld	a, #0xab
	push	af
	inc	sp
	ld	bc, #0xb3b1
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:286: case 171:
00184$:
;src/events.c:287: rpg_remove_item(s->rpg,s->selected_slot);rpg_recruit(s->rpg,2);
	pop	de
	push	de
	ld	hl, #0x010c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#3
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	dec	hl
	push	bc
	ld	a, (hl+)
	push	af
	inc	sp
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, #0x02
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_recruit
	ld	hl, #_rpg_recruit
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/events.c:288: s->object_flags[0]=0;s->flags[10]=255;s->action.target=2;return emit(s,EVENT_CUTSCENE,0,0);
	pop	de
	push	de
	ld	hl, #0x0125
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	pop	de
	push	de
	ld	hl, #0x000a
	add	hl, de
	ld	(hl), #0xff
	pop	de
	push	de
	ld	hl, #0x0120
	add	hl, de
	ld	(hl), #0x02
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x15
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00205$
;src/events.c:289: case 172: /* ItemUse_Polymaterial. */
00185$:
;src/events.c:290: if(s->item_in_battle)return say(s,0xb35c,0);
	pop	de
	push	de
	ld	hl, #0x010d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00187$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb35c
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00187$:
;src/events.c:291: if(!(s->rpg->party[0].status|s->rpg->party[2].status|s->rpg->party[3].status))return say(s,0xb3e3,0);
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, (bc)
	ld	e, a
	ld	hl, #0x0020
	add	hl, bc
	ld	a, (hl)
	or	a, e
	ld	e, a
	ld	hl, #0x0030
	add	hl, bc
	ld	a, (hl)
	or	a, e
	or	a, a
	jr	NZ, 00189$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb3e3
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00189$:
;src/events.c:292: if(s->event!=0xa1)return say(s,0xb3f9,0);
	pop	de
	push	de
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0xa1
	jr	Z, 00191$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb3f9
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00191$:
;src/events.c:293: return say(s,0xb3b1,173);
	ld	a, #0xad
	push	af
	inc	sp
	ld	bc, #0xb3b1
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:294: case 173:
00192$:
;src/events.c:295: rpg_remove_item(s->rpg,s->selected_slot);
	pop	de
	push	de
	ld	hl, #0x010c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	b, a
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	push	bc
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/events.c:296: if(has(s,ItemID_Hapsby))return say(s,0xb569,0);
	ld	a, #0x32
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00194$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb569
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
00194$:
;src/events.c:297: return say(s,0x12c,174);
	ld	a, #0xae
	push	af
	inc	sp
	ld	bc, #0x012c
	ldhl	sp,	#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00205$
;src/events.c:298: case 174:return give(s,ItemID_Hapsby,0);
00195$:
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x32
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:299: case 177:return give(s,s->pending_item,0);
00196$:
	pop	de
	push	de
	ld	hl, #0x010b
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	h, #0x00
	push	hl
	inc	sp
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:300: case 178:return give(s,ItemID_Hovercraft,0);
00197$:
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x22
	ldhl	sp,	#1
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00205$
;src/events.c:301: case 203:return resume(s);
00198$:
	pop	de
	push	de
	call	_resume
	jp	00205$
;src/events.c:302: case 204:return select_replacement(s);
00199$:
	pop	de
	push	de
	call	_select_replacement
	jp	00205$
;src/events.c:303: case 205:
00200$:
;src/events.c:305: if(rpg_replace_item(s->rpg,s->selected_slot,s->pending_item)!=RPG_OK) return select_replacement(s);
	pop	de
	push	de
	ld	hl, #0x010b
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
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x010c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#5
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl+)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_replace_item
	ld	hl, #_rpg_replace_item
	call	___sdcc_bcall_ehl
	add	sp, #4
	or	a, a
	jr	Z, 00202$
	pop	de
	push	de
	call	_select_replacement
	jr	00205$
00202$:
;src/events.c:306: s->action.item=s->pending_item;say(s,0xb6ad,203);s->action.sound=0xb3;return &s->action;
	pop	de
	push	de
	ld	hl, #0x011f
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(bc), a
	ld	a, #0xcb
	push	af
	inc	sp
	ld	bc, #0xb6ad
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0124
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
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0xb3
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jr	00205$
;src/events.c:307: default:return emit(s,EVENT_UNIMPLEMENTED,0,0);
00203$:
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
;src/events.c:308: }
00205$:
;src/events.c:309: }
	add	sp, #6
	ret
;src/events.c:310: const EventAction *event_respond(EventState *s,uint8_t yes) RPG_BANKED {
;	---------------------------------
; Function event_respond
; ---------------------------------
	b_event_respond	= 7
_event_respond::
	add	sp, #-5
;src/events.c:312: if(s->action.kind!=EVENT_YES_NO) return &s->action;
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x02
	jr	Z, 00102$
	ldhl	sp,#2
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	jp	00218$
00102$:
;src/events.c:313: switch(s->stage) {
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0109
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	b, a
	sub	a, #0x08
	jp	Z, 00103$
	ld	a,b
	cp	a,#0x14
	jp	Z,00104$
	cp	a,#0x16
	jp	Z,00109$
	cp	a,#0x1e
	jp	Z,00112$
	cp	a,#0x1f
	jp	Z,00113$
	cp	a,#0x20
	jp	Z,00114$
	cp	a,#0x21
	jp	Z,00117$
	cp	a,#0x2a
	jp	Z,00122$
	cp	a,#0x2b
	jp	Z,00127$
	cp	a,#0x32
	jp	Z,00128$
	cp	a,#0x33
	jp	Z,00131$
	cp	a,#0x3c
	jp	Z,00136$
	cp	a,#0x3e
	jp	Z,00141$
	cp	a,#0x43
	jp	Z,00146$
	cp	a,#0x4e
	jp	Z,00147$
	cp	a,#0x55
	jp	Z,00152$
	cp	a,#0x5d
	jp	Z,00155$
	cp	a,#0x65
	jp	Z,00209$
	cp	a,#0x6c
	jp	Z,00160$
	cp	a,#0x74
	jp	Z,00161$
	cp	a,#0x75
	jp	Z,00166$
	cp	a,#0x78
	jp	Z,00167$
	cp	a,#0x7c
	jp	Z,00168$
	cp	a,#0x81
	jp	Z,00175$
	cp	a,#0x82
	jp	Z,00178$
	cp	a,#0x84
	jp	Z,00179$
	cp	a,#0x87
	jp	Z,00180$
	cp	a,#0x8e
	jp	Z,00181$
	cp	a,#0x8f
	jp	Z,00182$
	cp	a,#0x90
	jp	Z,00183$
	cp	a,#0x91
	jp	Z,00184$
	cp	a,#0x92
	jp	Z,00185$
	cp	a,#0x93
	jp	Z,00187$
	cp	a,#0x94
	jp	Z,00186$
	cp	a,#0x9b
	jp	Z,00191$
	cp	a,#0x9c
	jp	Z,00196$
	cp	a,#0x9d
	jp	Z,00201$
	cp	a,#0x9f
	jp	Z,00202$
	cp	a,#0xa8
	jp	Z,00203$
	cp	a,#0xac
	jp	Z,00204$
	sub	a, #0xb3
	ld	a, #0x01
	jr	Z, 01182$
	xor	a, a
01182$:
	ld	c, a
	or	a, a
	jp	NZ, 00206$
	ld	a,b
	cp	a,#0xb4
	jp	Z,00206$
	cp	a,#0xc8
	jp	Z,00214$
	sub	a, #0xc9
	jp	Z, 00215$
	jp	00216$
;src/events.c:314: case 8:s->action.number=3;return say(s,yes?0x60:0x64,0);
00103$:
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x03
	inc	bc
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	ld	c, #0x60
	jr	NZ, 00221$
	ld	c, #0x64
00221$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:315: case 20:
00104$:
;src/events.c:316: if(!yes) return say(s,0x20,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00106$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0020
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00106$:
;src/events.c:317: if(!has(s,ItemID_Passport)) return say(s,0xce,0);
	ld	a, #0x34
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	NZ, 00108$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00ce
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00108$:
;src/events.c:318: return say(s,0x24,s->event==26?26:22);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x1a
	ld	a, #0x1a
	jr	Z, 00223$
	ld	a, #0x16
00223$:
	push	af
	inc	sp
	ld	bc, #0x0024
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:319: case 22:
00109$:
;src/events.c:320: if(!yes)return say(s,0x29a,DR_FIGHT);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00111$
	ld	a, #0x47
	push	af
	inc	sp
	ld	bc, #0x029a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00111$:
;src/events.c:321: s->action.character=1;say(s,0xb728,DR_KILL);s->action.sound=0xae;return &s->action;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0123
	add	hl, de
	ld	(hl), #0x01
	ld	a, #0x46
	push	af
	inc	sp
	ld	bc, #0xb728
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	ldhl	sp,	#11
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	hl, #0x0124
	add	hl, bc
	ld	(hl), #0xae
	ld	hl, #0x011a
	add	hl, bc
	ld	c, l
	ld	b, h
	jp	00218$
;src/events.c:322: case 30:return yes?ask(s,0x74,31):say(s,0x7c,0);
00112$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00224$
	ld	a, #0x1f
	push	af
	inc	sp
	ld	bc, #0x0074
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00218$
00224$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x007c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:323: case 31:return yes?say(s,0x7e,0):ask(s,0x76,32);
00113$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00226$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x007e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00226$:
	ld	a, #0x20
	push	af
	inc	sp
	ld	bc, #0x0076
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00218$
;src/events.c:324: case 32:
00114$:
;src/events.c:325: if(yes) return say(s,0x7e,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00116$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x007e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00116$:
;src/events.c:326: s->action.number=100;return ask(s,0x78,33);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	(hl), #0x64
	inc	bc
	xor	a, a
	ld	(bc), a
	ld	a, #0x21
	push	af
	inc	sp
	ld	bc, #0x0078
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00218$
;src/events.c:327: case 33:
00117$:
;src/events.c:328: if(!yes) return say(s,0x7c,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00119$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x007c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00119$:
;src/events.c:329: if(s->rpg->money<100) return say(s,0xbd57,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005a
	add	hl, bc
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	sub	a, #0x64
	ld	a, h
	sbc	a, #0x00
	jr	NC, 00121$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xbd57
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00121$:
;src/events.c:330: s->rpg->money-=100;return say(s,0x7a,34);
	ld	de, #0xff9c
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ld	a, #0x22
	push	af
	inc	sp
	ld	bc, #0x007a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:331: case 42:
00122$:
;src/events.c:332: if(!yes)return say(s,0x60,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00124$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0060
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00124$:
;src/events.c:333: if(!has(s,ItemID_DungeonKey))s->object_flags[4]=0;
	ld	a, #0x2d
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	NZ, 00126$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0129
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
00126$:
;src/events.c:334: return say(s,0x58,0);
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0058
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:335: case 43:return say(s,yes?0x60:0x5e,0);
00127$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	ld	c, #0x60
	jr	NZ, 00229$
	ld	c, #0x5e
00229$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:336: case 50:
00128$:
;src/events.c:337: if(yes) return say(s,0x94,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00130$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0094
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00130$:
;src/events.c:338: return has(s,ItemID_LaconiaPot)?ask(s,0x96,51):say(s,0x7c,0);
	ld	a, #0x38
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00230$
	ld	a, #0x33
	push	af
	inc	sp
	ld	bc, #0x0096
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00218$
00230$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x007c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:339: case 51:
00131$:
;src/events.c:340: if(!yes) return say(s,0x7c,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00133$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x007c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00133$:
;src/events.c:341: slot=rpg_find_item(s->rpg,ItemID_LaconiaPot);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	ld	a, #0x38
	push	af
	inc	sp
	push	hl
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#6
	ld	(hl), a
	pop	bc
;src/events.c:342: if(slot==255) return say(s,0x7c,0);
	ldhl	sp,	#4
	ld	a, (hl)
	inc	a
	jr	NZ, 00135$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x007c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00135$:
;src/events.c:343: rpg_remove_item(s->rpg,slot);return say(s,0x9a,52);
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	a, #0x34
	push	af
	inc	sp
	ld	bc, #0x009a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:344: case 60:
00136$:
;src/events.c:345: if(!yes) return say(s,s->event==121?0x20c:0xc2,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00138$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x79
	jr	NZ, 00232$
	ld	bc, #0x020c
	jr	00233$
00232$:
	ld	bc, #0x00c2
00233$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00138$:
;src/events.c:346: slot=rpg_find_item(s->rpg,ItemID_Cola);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	ld	a, #0x24
	push	af
	inc	sp
	push	hl
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#6
	ld	(hl), a
	pop	bc
;src/events.c:347: if(slot==255) return say(s,s->event==131?0xce:0x20e,0);
	ldhl	sp,	#4
	ld	a, (hl)
	inc	a
	jr	NZ, 00140$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x83
	jr	NZ, 00234$
	ld	bc, #0x00ce
	jr	00235$
00234$:
	ld	bc, #0x020e
00235$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00140$:
;src/events.c:348: rpg_remove_item(s->rpg,slot);return say(s,s->event==60?0xbc:s->event==61?0xc4:s->event==121?0x20a:0xea,0);
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	cp	a, #0x3c
	jr	NZ, 00236$
	ld	de, #0x00bc
	jr	00237$
00236$:
	cp	a, #0x3d
	jr	NZ, 00238$
	ld	de, #0x00c4
	jr	00239$
00238$:
	sub	a, #0x79
	jr	NZ, 00240$
	ld	de, #0x020a
	jr	00241$
00240$:
	ld	de, #0x00ea
00241$:
00239$:
00237$:
	ld	c, e
	ld	b, d
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:349: case 62:
00141$:
;src/events.c:350: if(!yes)return say(s,0xda,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00143$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00da
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00143$:
;src/events.c:351: if(s->rpg->money<1200)return say(s,0xd0,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005a
	add	hl, bc
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	sub	a, #0xb0
	ld	a, h
	sbc	a, #0x04
	jr	NC, 00145$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00d0
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00145$:
;src/events.c:352: s->rpg->money-=1200;s->flags[4]=3;return say(s,0x290,0);
	ld	de, #0xfb50
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	(hl), #0x03
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0290
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:353: case 67:return say(s,yes?0x13c:0x116,0);
00146$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00242$
	ld	bc, #0x013c
	jr	00243$
00242$:
	ld	bc, #0x0116
00243$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:354: case 78:
00147$:
;src/events.c:355: if(yes)return say(s,0x13c,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00149$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x013c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00149$:
;src/events.c:356: if(!s->flags[7])s->flags[7]=1;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00151$
	ld	a, #0x01
	ld	(bc), a
00151$:
;src/events.c:357: return say(s,0x13e,0);
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x013e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:358: case 85:if(yes)s->flags[8]=1;return say(s,yes?0x174:0x17c,0);
00152$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00154$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	(hl), #0x01
00154$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00244$
	ld	bc, #0x0174
	jr	00245$
00244$:
	ld	bc, #0x017c
00245$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:359: case 93:
00155$:
;src/events.c:360: if(!yes)return say(s,0x19c,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00157$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x019c
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00157$:
;src/events.c:361: if(s->rpg->money<1000)return say(s,0x19a,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005a
	add	hl, bc
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	sub	a, #0xe8
	ld	a, h
	sbc	a, #0x03
	jr	NC, 00159$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x019a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00159$:
;src/events.c:362: s->rpg->money-=1000;return say(s,0x198,93);
	ld	de, #0xfc18
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ld	a, #0x5d
	push	af
	inc	sp
	ld	bc, #0x0198
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:363: case 108:return say(s,yes?0x1da:0x1d8,0);
00160$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00246$
	ld	bc, #0x01da
	jr	00247$
00246$:
	ld	bc, #0x01d8
00247$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:364: case 116:
00161$:
;src/events.c:365: if(!yes)return say(s,0x1f0,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00163$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x01f0
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00163$:
;src/events.c:366: if(s->rpg->money<400)return say(s,0x1f2,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005a
	add	hl, bc
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	sub	a, #0x90
	ld	a, h
	sbc	a, #0x01
	jr	NC, 00165$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x01f2
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00165$:
;src/events.c:367: s->rpg->money-=400;s->flags[9]=1;return say(s,0x1f4,0);
	ld	de, #0xfe70
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	(hl), #0x01
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x01f4
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:368: case 117:return say(s,yes?0x1fc:0x1fe,0);
00166$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00248$
	ld	bc, #0x01fc
	jr	00249$
00248$:
	ld	bc, #0x01fe
00249$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:369: case 120:return say(s,yes?0x206:0x208,0);
00167$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00250$
	ld	bc, #0x0206
	jr	00251$
00250$:
	ld	bc, #0x0208
00251$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:370: case 124:
00168$:
;src/events.c:371: if(!yes)return say(s,0xb7e3,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00170$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb7e3
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00170$:
;src/events.c:372: if(s->rpg->money<280)return say(s,0xbd57,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x005a
	add	hl, bc
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	e, l
	ld	d, a
	ld	a, e
	sub	a, #0x18
	ld	a, d
	sbc	a, #0x01
	jr	NC, 00172$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xbd57
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00172$:
;src/events.c:373: if(s->rpg->inventory_count>=24)return say(s,0xb813,0);
	ld	hl, #0x0058
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x18
	jr	C, 00174$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb813
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00174$:
;src/events.c:374: s->rpg->money-=280;return say(s,0x20a,124);
	ld	a, e
	add	a, #0xe8
	ld	c, a
	ld	a, d
	adc	a, #0xfe
	ld	b, a
	pop	hl
	push	hl
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	a, #0x7c
	push	af
	inc	sp
	ld	bc, #0x020a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:375: case 129:if(yes)s->flags[4]=1;return say(s,yes?0xe4:0xd4,0);
00175$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00177$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	(hl), #0x01
00177$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	ld	c, #0xe4
	jr	NZ, 00253$
	ld	c, #0xd4
00253$:
	xor	a, a
	ld	b, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:376: case 130:return say(s,yes&&has(s,ItemID_RoadPass)?0x24:0xe8,yes&&has(s,ItemID_RoadPass)?0:ROBOT_FIGHT);
00178$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00254$
	ld	a, #0x33
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00254$
	ld	d, #0x00
	jr	00255$
00254$:
	ld	d, #0x5a
00255$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00259$
	push	de
	ld	a, #0x33
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	push	bc
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	de
	or	a, a
	ld	a, #0x24
	jr	NZ, 00260$
00259$:
	ld	a, #0xe8
00260$:
	ld	b, #0x00
	push	de
	inc	sp
	ld	c, a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:377: case 132:return say(s,yes?0x13c:0x124,0);
00179$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00264$
	ld	bc, #0x013c
	jr	00265$
00264$:
	ld	bc, #0x0124
00265$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:378: case 135:return say(s,yes?0x14c:0x13c,0);
00180$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00266$
	ld	bc, #0x014c
	jr	00267$
00266$:
	ld	bc, #0x013c
00267$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:379: case 142:return say(s,yes?0x14e:0x152,yes?142:0);
00181$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00268$
	ld	d, #0x8e
	jr	00269$
00268$:
	ld	d, #0x00
00269$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00270$
	ld	bc, #0x014e
	jr	00271$
00270$:
	ld	bc, #0x0152
00271$:
	push	de
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:380: case 143:return say(s,yes?0x14e:0x152,yes?143:0);
00182$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00272$
	ld	d, #0x8f
	jr	00273$
00272$:
	ld	d, #0x00
00273$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00274$
	ld	bc, #0x014e
	jr	00275$
00274$:
	ld	bc, #0x0152
00275$:
	push	de
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:381: case 144:return say(s,yes?0x14e:0x152,yes?144:0);
00183$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00276$
	ld	d, #0x90
	jr	00277$
00276$:
	ld	d, #0x00
00277$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00278$
	ld	bc, #0x014e
	jr	00279$
00278$:
	ld	bc, #0x0152
00279$:
	push	de
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:382: case 145:return yes?say(s,0x158,0):ask(s,0x15a,146);
00184$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00280$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0158
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00280$:
	ld	a, #0x92
	push	af
	inc	sp
	ld	bc, #0x015a
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00218$
;src/events.c:383: case 146:return say(s,yes?0x152:0x15c,yes?0:146);
00185$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00282$
	ld	d, #0x00
	jr	00283$
00282$:
	ld	d, #0x92
00283$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00284$
	ld	bc, #0x0152
	jr	00285$
00284$:
	ld	bc, #0x015c
00285$:
	push	de
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:384: case 148:return say(s,yes?0x162:0x164,0);
00186$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00286$
	ld	bc, #0x0162
	jr	00287$
00286$:
	ld	bc, #0x0164
00287$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:385: case 147:
00187$:
;src/events.c:386: if(yes&&has(s,ItemID_RoadPass))return say(s,0x21e,ROBOT_WARP);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00189$
	ld	a, #0x33
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00189$
	ld	a, #0x5b
	push	af
	inc	sp
	ld	bc, #0x021e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00189$:
;src/events.c:387: return say(s,0xe8,ROBOT_FIGHT);
	ld	a, #0x5a
	push	af
	inc	sp
	ld	bc, #0x00e8
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:388: case 155:
00191$:
;src/events.c:389: if(!yes)return say(s,0xa2,GUARD_RETREAT);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00193$
	ld	a, #0x5c
	push	af
	inc	sp
	ld	bc, #0x00a2
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00193$:
;src/events.c:390: slot=rpg_find_item(s->rpg,ItemID_Cake);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	ld	a, #0x36
	push	af
	inc	sp
	push	hl
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#6
	ld	(hl), a
	pop	bc
;src/events.c:391: if(slot==255)return say(s,0xa0,GUARD_RETREAT);
	ldhl	sp,	#4
	ld	a, (hl)
	inc	a
	jr	NZ, 00195$
	ld	a, #0x5c
	push	af
	inc	sp
	ld	bc, #0x00a0
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00195$:
;src/events.c:392: rpg_remove_item(s->rpg,slot);s->flags[17]=255;return say(s,0x9e,0);
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0011
	add	hl, de
	ld	(hl), #0xff
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x009e
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:393: case 156:
00196$:
;src/events.c:394: if(!yes)return say(s,0x246,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00198$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0246
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00198$:
;src/events.c:395: slot=rpg_find_item(s->rpg,ItemID_AmberEye);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	c,l
	ld	b,h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	ld	a, #0x3a
	push	af
	inc	sp
	push	hl
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#6
	ld	(hl), a
	pop	bc
;src/events.c:396: if(slot==255)return say(s,0x248,0);
	ldhl	sp,	#4
	ld	a, (hl)
	inc	a
	jr	NZ, 00200$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0248
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
00200$:
;src/events.c:397: rpg_remove_item(s->rpg,slot);return give(s,ItemID_EclipseTorch,156);
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	a, #0x9c
	push	af
	inc	sp
	ld	a, #0x2f
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_give
	jp	00218$
;src/events.c:398: case 157:return say(s,yes?0x25e:0x260,0);
00201$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00288$
	ld	bc, #0x025e
	jr	00289$
00288$:
	ld	bc, #0x0260
00289$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:399: case 159:return say(s,yes?0x26e:0x270,LASSIC_FIGHT);
00202$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00290$
	ld	bc, #0x026e
	jr	00291$
00290$:
	ld	bc, #0x0270
00291$:
	ld	a, #0x54
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:400: case 168:return say(s,yes?0x22c:0x22a,0);
00203$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00292$
	ld	bc, #0x022c
	jr	00293$
00292$:
	ld	bc, #0x022a
00293$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:401: case 172:return say(s,yes?0x212:0x230,ENDING_RUN);
00204$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00294$
	ld	bc, #0x0212
	jr	00295$
00294$:
	ld	bc, #0x0230
00295$:
	ld	a, #0x62
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00218$
;src/events.c:402: case 179:case 180:
00206$:
;src/events.c:403: if(!yes)return finish(s);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00208$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00218$
00208$:
;src/events.c:404: s->action.target=s->stage==179?0x81:0x82;return emit(s,EVENT_TRAVEL,0,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0120
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	or	a, a
	ld	a, #0x81
	jr	NZ, 00297$
	ld	a, #0x82
00297$:
	ld	(de), a
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x0f
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00218$
;src/events.c:405: case TRAVEL_QUESTION:
00209$:
;src/events.c:406: if(!yes)return emit(s,EVENT_TRAVEL_MENU,0xb754,0);
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00211$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0xb754
	push	de
	ld	a, #0x10
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00218$
00211$:
;src/events.c:409: slot=(uint8_t)(((s->map_id>>3)&3u)*3u+s->travel_destination);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0107
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	swap	a
	rlca
	and	a, #0x3
	ld	c, a
	add	a, a
	add	a, c
	ld	c, a
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0112
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	add	a, c
;src/events.c:410: if(slot>=8u)return emit(s,EVENT_UNIMPLEMENTED,0,0);
	ld	c, a
	sub	a, #0x08
	jr	C, 00213$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jr	00218$
00213$:
;src/events.c:411: s->action.target=routes[slot];return emit(s,EVENT_TRAVEL,0,0);
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0120
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #_event_respond_routes_40000_207
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x0f
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jr	00218$
;src/events.c:413: case 200:return yes?select_replacement(s):ask(s,0xb6c1,201);
00214$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00298$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_select_replacement
	jr	00218$
00298$:
	ld	a, #0xc9
	push	af
	inc	sp
	ld	bc, #0xb6c1
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jr	00218$
;src/events.c:414: case 201:return yes?say(s,0xb6d0,203):select_replacement(s);
00215$:
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00300$
	ld	a, #0xcb
	push	af
	inc	sp
	ld	bc, #0xb6d0
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00218$
00300$:
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_select_replacement
	jr	00218$
;src/events.c:415: default:return emit(s,EVENT_UNIMPLEMENTED,0,0);
00216$:
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
;src/events.c:416: }
00218$:
;src/events.c:417: }
	add	sp, #5
	ret
_event_respond_routes_40000_207:
	.db #0x81	; 129
	.db #0x83	; 131
	.db #0x84	; 132
	.db #0x85	; 133
	.db #0x82	; 130
	.db #0x86	; 134
	.db #0x87	; 135
	.db #0x88	; 136
;src/events.c:418: const EventAction *event_replace_item(EventState *s,uint8_t slot) RPG_BANKED {
;	---------------------------------
; Function event_replace_item
; ---------------------------------
	b_event_replace_item	= 7
_event_replace_item::
	add	sp, #-5
;src/events.c:420: if(s->action.kind!=EVENT_REPLACE_ITEM) return &s->action;
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	a, c
	sub	a, #0x07
	jr	Z, 00102$
	pop	bc
	push	bc
	jp	00109$
00102$:
;src/events.c:421: if(slot==255) return ask(s,0xb671,200);
	ldhl	sp,	#13
	ld	a, (hl)
	inc	a
	jr	NZ, 00104$
	ld	a, #0xc8
	push	af
	inc	sp
	ld	bc, #0xb671
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00109$
00104$:
;src/events.c:422: if(slot>=s->rpg->inventory_count) return &s->action;
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
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
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0058
	add	hl, bc
	ld	e, (hl)
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, e
	jr	C, 00106$
	pop	bc
	push	bc
	jr	00109$
00106$:
;src/events.c:424: result=rpg_item_discardable(s->rpg->inventory[slot]);
	ld	hl, #0x0040
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl), a
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	af
	inc	sp
	ld	e, #b_rpg_item_discardable
	ld	hl, #_rpg_item_discardable
	call	___sdcc_bcall_ehl
	inc	sp
;src/events.c:425: if(!result) return say(s,0xb6de,204);
	or	a, a
	jr	NZ, 00108$
	ld	a, #0xcc
	push	af
	inc	sp
	ld	bc, #0xb6de
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00109$
00108$:
;src/events.c:426: s->selected_slot=slot;s->action.item=s->rpg->inventory[slot];
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010c
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#4
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011f
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	de, #0x40
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/events.c:427: return say(s,0xb69e,205);
	ld	a, #0xcd
	push	af
	inc	sp
	ld	bc, #0xb69e
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
00109$:
;src/events.c:428: }
	add	sp, #5
	ret
;src/events.c:429: const EventAction *event_buy_secret(EventState *s,uint8_t shop,uint8_t option) RPG_BANKED {
;	---------------------------------
; Function event_buy_secret
; ---------------------------------
	b_event_buy_secret	= 7
_event_buy_secret::
	add	sp, #-11
;src/events.c:432: if(rpg_shop_option(shop,option,&item,&price)!=RPG_OK || item!=ItemID_Secrets)
	ldhl	sp,	#1
	ld	e, l
	ld	d, h
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	push	de
	push	bc
	ldhl	sp,	#24
	ld	a, (hl-)
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_rpg_shop_option
	ld	hl, #_rpg_shop_option
	call	___sdcc_bcall_ehl
	add	sp, #6
	or	a, a
	jr	NZ, 00101$
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x40
	jr	Z, 00102$
00101$:
;src/events.c:433: return emit(s,EVENT_UNIMPLEMENTED,0,0);
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ldhl	sp,	#20
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00112$
00102$:
;src/events.c:435: if(s->rpg->inventory_count>=RPG_INVENTORY_SIZE) return say(s,0xb813,0);
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#18
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
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
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0058
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x18
	jr	C, 00105$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb813
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00112$
00105$:
;src/events.c:436: if(s->rpg->money<price) return say(s,0xbd57,0);
	ld	hl, #0x005a
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#1
	ld	a, c
	sub	a, (hl)
	inc	hl
	ld	a, b
	sbc	a, (hl)
	jr	NC, 00107$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xbd57
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00112$
00107$:
;src/events.c:437: if(s->secrets_requests>=2) {
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0102
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x02
	jp	C, 00111$
;src/events.c:438: s->secrets_requests=0;
	xor	a, a
	ld	(bc), a
;src/events.c:439: if(!has(s,ItemID_RoadPass)) {
	push	bc
	ld	a, #0x33
	push	af
	inc	sp
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	or	a, a
	jr	NZ, 00111$
;src/events.c:440: s->rpg->money-=price;rpg_add_item(s->rpg,ItemID_RoadPass);
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x005a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#7
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#1
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	h, #0x33
	push	hl
	inc	sp
	ld	b, a
	push	bc
	ld	e, #b_rpg_add_item
	ld	hl, #_rpg_add_item
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/events.c:441: s->action.item=ItemID_RoadPass;say(s,0x146,0);s->action.sound=0xb3;return &s->action;
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011f
	add	hl, de
	ld	(hl), #0x33
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0146
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0124
	add	hl, de
	ld	a, #0xb3
	ld	(hl), a
	ldhl	sp,#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	jr	00112$
00111$:
;src/events.c:445: s->secrets_requests++;
	ld	a, (bc)
	inc	a
	ld	(bc), a
;src/events.c:446: return say(s,s->secrets_requests==1?0x142:0x144,0);
	dec	a
	jr	NZ, 00114$
	ld	bc, #0x0142
	jr	00115$
00114$:
	ld	bc, #0x0144
00115$:
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
00112$:
;src/events.c:447: }
	add	sp, #11
	ret
;src/events.c:448: const EventAction *event_battle_result(EventState *s,uint8_t outcome,uint8_t chest_opened) RPG_BANKED {
;	---------------------------------
; Function event_battle_result
; ---------------------------------
	b_event_battle_result	= 7
_event_battle_result::
	add	sp, #-5
;src/events.c:449: if(s->action.kind!=EVENT_BATTLE || outcome==RPG_ONGOING)return &s->action;
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl), a
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x0c
	jr	NZ, 00101$
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	NZ, 00102$
00101$:
	pop	de
	push	de
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	jp	00127$
00102$:
;src/events.c:450: if(chest_opened)s->flags[s->battle.flag_index]=255;
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00105$
	pop	de
	push	de
	ld	hl, #0x0115
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	(hl), #0xff
00105$:
;src/events.c:451: if(s->event==55) {restore_status(s);return present(s,EVENT_PRESENT_NIGHTMARE_WAKE,GOV_REST);}
	pop	de
	push	de
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#2
	ld	(hl), a
	sub	a, #0x37
	jr	NZ, 00107$
	pop	de
	push	de
	call	_restore_status
	ld	a, #0x4d
	push	af
	inc	sp
	ld	a, #0x05
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_present
	jp	00127$
00107$:
;src/events.c:454: if(!s->rpg->party[3].hp) {
	pop	de
	push	de
	ld	hl, #0x0100
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#5
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#4
;src/events.c:452: if(s->event==157) {
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	sub	a, #0x9d
	jr	NZ, 00111$
;src/events.c:453: restore_status(s);
	pop	de
	push	de
	call	_restore_status
;src/events.c:454: if(!s->rpg->party[3].hp) {
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0031
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00109$
;src/events.c:455: s->rpg->party[3].hp=s->battle.noah_hp;s->rpg->party[3].status=1;
	pop	de
	push	de
	ld	hl, #0x0119
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	ld	hl, #0x0030
	add	hl, bc
	ld	(hl), #0x01
;src/events.c:456: return say(s,0x256,0);
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0256
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00127$
00109$:
;src/events.c:458: return say(s,0x250,TARZ_REWARD);
	ld	a, #0x52
	push	af
	inc	sp
	ld	bc, #0x0250
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00127$
00111$:
;src/events.c:460: if(outcome==RPG_DEFEAT)return emit(s,EVENT_GAME_OVER,0,0);
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00113$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x12
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00127$
00113$:
;src/events.c:461: if(s->event==158) {s->flags[23]=255;return say(s,0x266,0);}
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x9e
	jr	NZ, 00115$
	pop	de
	push	de
	ld	hl, #0x0017
	add	hl, de
	ld	(hl), #0xff
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0266
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00127$
00115$:
;src/events.c:462: if(s->event==159) {s->flags[22]=1;return say(s,0x2aa,0);}
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x9f
	jr	NZ, 00117$
	pop	de
	push	de
	ld	hl, #0x0016
	add	hl, de
	ld	(hl), #0x01
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x02aa
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00127$
00117$:
;src/events.c:463: if(s->event==171) {
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0xab
	jr	NZ, 00121$
;src/events.c:464: if(!s->rpg->party[0].status)return say(s,0xbf64,53);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	ld	a, (hl)
	or	a, a
	jr	NZ, 00119$
	ld	a, #0x35
	push	af
	inc	sp
	ld	bc, #0xbf64
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	ldhl	sp,	#3
	ld	(hl), c
	inc	hl
	ld	(hl), b
	ldhl	sp,	#3
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jr	00127$
00119$:
;src/events.c:465: return emit(s,EVENT_GOVERNOR_ROOM,0,ENDING_PROMPT);
	ld	a, #0x61
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x18
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	ldhl	sp,	#3
	ld	(hl), c
	inc	hl
	ld	(hl), b
	ldhl	sp,	#3
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jr	00127$
00121$:
;src/events.c:467: if((s->event==22||s->event==130||s->event==147)&&outcome!=RPG_VICTORY)return emit(s,EVENT_MENU,0,0);
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x16
	jr	Z, 00126$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x82
	jr	Z, 00126$
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x93
	jr	NZ, 00123$
00126$:
	ldhl	sp,	#13
	ld	a, (hl)
	dec	a
	jr	Z, 00123$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x0a
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jr	00127$
00123$:
;src/events.c:468: return finish(s);
	pop	de
	push	de
	call	_finish
00127$:
;src/events.c:469: }
	add	sp, #5
	ret
;src/events.c:470: void event_governor_room_loaded(EventState *s) RPG_BANKED {
;	---------------------------------
; Function event_governor_room_loaded
; ---------------------------------
	b_event_governor_room_loaded	= 7
_event_governor_room_loaded::
;src/events.c:471: if(s->action.kind==EVENT_GOVERNOR_ROOM&&s->stage==59u)rpg_rest(s->rpg);
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x011a
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x18
	ret	NZ
	ld	hl, #0x0109
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x3b
	ret	NZ
	inc	b
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	e, #b_rpg_rest
	ld	hl, #_rpg_rest
	call	___sdcc_bcall_ehl
	pop	hl
;src/events.c:472: }
	ret
;src/events.c:473: const EventAction *event_choose_destination(EventState *s,uint8_t destination) RPG_BANKED {
;	---------------------------------
; Function event_choose_destination
; ---------------------------------
	b_event_choose_destination	= 7
_event_choose_destination::
	add	sp, #-3
;src/events.c:475: if(s->action.kind!=EVENT_TRAVEL_MENU)return &s->action;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl), a
	ld	a, c
	sub	a, #0x10
	jr	Z, 00102$
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	jp	00109$
00102$:
;src/events.c:476: if(destination==255u)return finish(s);
	ldhl	sp,	#11
	ld	a, (hl)
	inc	a
	jr	NZ, 00104$
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_finish
	jp	00109$
00104$:
;src/events.c:477: if(destination>2u)return &s->action;
	ld	a, #0x02
	ldhl	sp,	#11
	sub	a, (hl)
	jr	NC, 00106$
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	jp	00109$
00106$:
;src/events.c:478: current=(s->map_id>>3)&3u;s->travel_destination=destination;
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0107
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	swap	a
	rlca
	and	a, #0x1f
	ldhl	sp,	#2
	ld	(hl-), a
	dec	hl
	and	a, #0x03
	ld	(hl), a
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0112
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#11
	ld	a, (hl)
	ld	(de), a
;src/events.c:479: if(current==destination)return say(s,destination==0u?0xb799:destination==1u?0xb790:0xb785,TRAVEL_AGAIN);
	ld	a, (hl)
	dec	a
	ld	a, #0x01
	jr	Z, 00179$
	xor	a, a
00179$:
	ld	c, a
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#0
	sub	a, (hl)
	jr	NZ, 00108$
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, a
	jr	NZ, 00111$
	ld	de, #0xb799
	jr	00112$
00111$:
	ld	a, c
	or	a, a
	jr	Z, 00113$
	ld	de, #0xb790
	jr	00114$
00113$:
	ld	de, #0xb785
00114$:
00112$:
	ld	c, e
	ld	b, d
	ld	a, #0x64
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00109$
00108$:
;src/events.c:480: return ask(s,destination==0u?0xb77b:destination==1u?0xb76f:0xb761,TRAVEL_QUESTION);
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, a
	jr	NZ, 00115$
	ld	bc, #0xb77b
	jr	00116$
00115$:
	ld	a, c
	or	a, a
	jr	Z, 00117$
	ld	de, #0xb76f
	jr	00118$
00117$:
	ld	de, #0xb761
00118$:
	ld	c, e
	ld	b, d
00116$:
	ld	a, #0x65
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
00109$:
;src/events.c:481: }
	add	sp, #3
	ret
;src/events.c:482: const EventAction *event_use_story_item(EventState *s,uint8_t slot,uint8_t in_battle) RPG_BANKED {
;	---------------------------------
; Function event_use_story_item
; ---------------------------------
	b_event_use_story_item	= 7
_event_use_story_item::
	dec	sp
	dec	sp
;src/events.c:484: if(slot>=s->rpg->inventory_count)return emit(s,EVENT_UNIMPLEMENTED,0,0);
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	c, l
	ld	b, h
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0058
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, c
	jr	C, 00102$
	dec	hl
	dec	hl
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jr	00107$
00102$:
;src/events.c:485: item=s->rpg->inventory[slot];s->action.item=item;s->selected_slot=slot;s->item_in_battle=in_battle;
	pop	de
	push	de
	ld	hl, #0x0040
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#10
	ld	c, (hl)
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	b, (hl)
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011f
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, b
	ld	(de), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010c
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, c
	ld	(de), a
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010d
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#11
	ld	a, (hl)
	ld	(de), a
;src/events.c:486: if(item==ItemID_Alsulin)return say(s,0xb366,170);
	ld	a, b
	sub	a, #0x2b
	jr	NZ, 00104$
	ld	a, #0xaa
	push	af
	inc	sp
	ld	bc, #0xb366
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00107$
00104$:
;src/events.c:487: if(item==ItemID_Polymaterial)return say(s,0xb366,172);
	ld	a, b
	sub	a, #0x2c
	jr	NZ, 00106$
	ld	a, #0xac
	push	af
	inc	sp
	ld	bc, #0xb366
	ldhl	sp,	#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00107$
00106$:
;src/events.c:488: return emit(s,EVENT_UNIMPLEMENTED,0,0);
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ldhl	sp,	#11
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
00107$:
;src/events.c:489: }
	inc	sp
	inc	sp
	ret
;src/events.c:490: const EventAction *event_search(EventState *s,uint8_t map_id,uint8_t x,uint8_t y) RPG_BANKED {
;	---------------------------------
; Function event_search
; ---------------------------------
	b_event_search	= 7
_event_search::
	add	sp, #-3
;src/events.c:491: uint8_t item=0;
	ldhl	sp,	#0
	ld	(hl), #0x00
;src/events.c:492: if(map_id==7u && x==0x1eu && y==32u && s->flags[7] && s->flags[7]!=255u) {
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#1
	ld	(hl), a
	ldhl	sp,	#10
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, #0x07
	jr	NZ, 00108$
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x1e
	jr	NZ, 00108$
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x20
	jr	NZ, 00108$
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00108$
	inc	a
	jr	Z, 00108$
;src/events.c:494: s->flags[7]=255;item=ItemID_Flute;
	ld	a, #0xff
	ld	(bc), a
	ldhl	sp,	#0
	ld	(hl), #0x26
	jr	00109$
00108$:
;src/events.c:495: } else if(map_id==1u && x==0x48u && y==36u && s->flags[9] && s->rpg->party[2].shield!=ItemID_MirrorShield) {
	ldhl	sp,	#11
	ld	a, (hl)
	dec	a
	jr	NZ, 00109$
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x48
	jr	NZ, 00109$
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x24
	jr	NZ, 00109$
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00109$
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0100
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x002c
	add	hl, bc
	ld	a, (hl)
	sub	a, #0x1f
	jr	Z, 00109$
;src/events.c:496: item=ItemID_MirrorShield;
	ldhl	sp,	#0
	ld	(hl), #0x1f
00109$:
;src/events.c:498: if(item && !has(s,item)) {s->action.item=item;s->pending_item=item;return say(s,0xb592,177);}
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00115$
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	NZ, 00115$
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x011f
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x010b
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	(bc), a
	ld	a, #0xb1
	push	af
	inc	sp
	ld	bc, #0xb592
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00124$
00115$:
;src/events.c:499: if(s->event==0xa2 && s->flags[8] && has(s,ItemID_Hapsby) && !has(s,ItemID_Hovercraft))return say(s,0x178,178);
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0104
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0xa2
	jr	NZ, 00118$
	ldhl	sp,#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	Z, 00118$
	push	bc
	ld	a, #0x32
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	or	a, a
	jr	Z, 00118$
	push	bc
	ld	a, #0x22
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_has
	ld	hl, #_has
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	or	a, a
	jr	NZ, 00118$
	ld	a, #0xb2
	push	af
	inc	sp
	ld	bc, #0x0178
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00124$
00118$:
;src/events.c:500: if(s->event==0xa3)return say(s,0xfa,0);
	ld	a, (bc)
	sub	a, #0xa3
	jr	NZ, 00123$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x00fa
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00124$
00123$:
;src/events.c:501: return say(s,0xb569,0);
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb569
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
00124$:
;src/events.c:502: }
	add	sp, #3
	ret
	.area _CODE_7
	.area _INITIALIZER
	.area _CABS (ABS)
