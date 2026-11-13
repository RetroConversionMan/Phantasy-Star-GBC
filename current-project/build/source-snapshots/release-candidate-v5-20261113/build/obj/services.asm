;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module services
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _memset
	.globl b_event_buy_secret
	.globl _event_buy_secret
	.globl b_rpg_exp_to_next
	.globl _rpg_exp_to_next
	.globl b_rpg_revive
	.globl _rpg_revive
	.globl b_rpg_revival_cost
	.globl _rpg_revival_cost
	.globl b_rpg_hospital_cost
	.globl _rpg_hospital_cost
	.globl b_rpg_sell
	.globl _rpg_sell
	.globl b_rpg_sell_price
	.globl _rpg_sell_price
	.globl b_rpg_buy
	.globl _rpg_buy
	.globl b_rpg_shop_option
	.globl _rpg_shop_option
	.globl b_service_begin
	.globl _service_begin
	.globl b_service_advance
	.globl _service_advance
	.globl b_service_respond
	.globl _service_respond
	.globl b_service_select
	.globl _service_select
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
	.area _CODE_19
;src/services.c:13: static const ServiceAction *emit(ServiceState *s,uint8_t kind,uint16_t dialogue,uint8_t stage) {
;	---------------------------------
; Function emit
; ---------------------------------
_emit:
	ld	c, a
;src/services.c:14: s->stage=stage;s->action.kind=kind;s->action.dialogue_id=dialogue;s->action.sound=0;
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ldhl	sp,	#6
	ld	a, (hl)
	pop	hl
	ld	(hl), a
	ld	hl, #0x0008
	add	hl, de
	ld	(hl), c
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
	ld	hl, #0x0010
	add	hl, de
	ld	(hl), #0x00
;src/services.c:15: s->action.target=s->shop;s->action.character=s->character;
	ld	hl, #0x000f
	add	hl, de
	ld	c, e
	ld	b, d
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	(hl), a
	ld	hl, #0x000e
	add	hl, de
	ld	c, l
	ld	b, h
	ld	hl, #0x0005
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/services.c:16: return &s->action;
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
;src/services.c:17: }
	pop	hl
	add	sp, #3
	jp	(hl)
;src/services.c:18: static const ServiceAction *say(ServiceState *s,uint16_t id,uint8_t stage) {return emit(s,SERVICE_DIALOGUE,id,stage);}
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
;src/services.c:19: static const ServiceAction *ask(ServiceState *s,uint16_t id,uint8_t stage) {return emit(s,SERVICE_YES_NO,id,stage);}
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
;src/services.c:20: static const ServiceAction *done(ServiceState *s) {return emit(s,SERVICE_DONE,0,DONE);}
;	---------------------------------
; Function done
; ---------------------------------
_done:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0000
	push	bc
	xor	a, a
	call	_emit
	ret
;src/services.c:22: static uint8_t multiple(ServiceState *s) RPG_BANKED {return (s->events->rpg->joined_mask&14u)!=0;}
;	---------------------------------
; Function multiple
; ---------------------------------
	b_multiple	= 19
_multiple:
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	inc	b
	ld	l, c
	ld	h, b
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	ld	a, (hl)
	and	a, #0x0e
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ret
;src/services.c:23: static const ServiceAction *hospital_choose(ServiceState *s) {
;	---------------------------------
; Function hospital_choose
; ---------------------------------
_hospital_choose:
;src/services.c:24: if(multiple(s)) return emit(s,SERVICE_PARTY,0xb925,H_CHOOSE);
	push	de
	push	de
	ld	e, #b_multiple
	ld	hl, #_multiple
	call	___sdcc_bcall_ehl
	pop	hl
	pop	de
	or	a, a
	jr	Z, 00102$
	ld	a, #0x02
	push	af
	inc	sp
	ld	bc, #0xb925
	push	bc
	ld	a, #0x03
	call	_emit
	ret
00102$:
;src/services.c:25: emit(s,SERVICE_PARTY,0,H_CHOOSE);return service_select(s,0);
	push	de
	ld	a, #0x02
	push	af
	inc	sp
	ld	bc, #0x0000
	push	bc
	ld	a, #0x03
	call	_emit
	pop	de
	xor	a, a
	push	af
	inc	sp
	push	de
	ld	e, #b_service_select
	ld	hl, #_service_select
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/services.c:26: }
	ret
;src/services.c:27: static const ServiceAction *hospital_return(ServiceState *s) {
;	---------------------------------
; Function hospital_return
; ---------------------------------
_hospital_return:
;src/services.c:28: return multiple(s)?hospital_choose(s):say(s,0xb951,DONE);
	push	de
	push	de
	ld	e, #b_multiple
	ld	hl, #_multiple
	call	___sdcc_bcall_ehl
	pop	hl
	pop	de
	or	a, a
	jp	NZ, _hospital_choose
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb951
	call	_say
;src/services.c:29: }
	ret
;src/services.c:30: static const ServiceAction *church_exit(ServiceState *s) {return say(s,0xba3c,C_BLESS);}
;	---------------------------------
; Function church_exit
; ---------------------------------
_church_exit:
	ld	a, #0x0e
	push	af
	inc	sp
	ld	bc, #0xba3c
	call	_say
	ret
;src/services.c:31: static const ServiceAction *church_choose(ServiceState *s) {
;	---------------------------------
; Function church_choose
; ---------------------------------
_church_choose:
;src/services.c:32: if(multiple(s)) return emit(s,SERVICE_PARTY,0xb9d3,C_CHOOSE);
	push	de
	push	de
	ld	e, #b_multiple
	ld	hl, #_multiple
	call	___sdcc_bcall_ehl
	pop	hl
	pop	de
	or	a, a
	jr	Z, 00102$
	ld	a, #0x09
	push	af
	inc	sp
	ld	bc, #0xb9d3
	push	bc
	ld	a, #0x03
	call	_emit
	ret
00102$:
;src/services.c:33: s->character=0;return say(s,0xba56,C_ALIVE);
	ld	hl, #0x0005
	add	hl, de
	ld	(hl), #0x00
	ld	a, #0x0d
	push	af
	inc	sp
	ld	bc, #0xba56
	call	_say
;src/services.c:34: }
	ret
;src/services.c:35: static const ServiceAction *goods(ServiceState *s) {return emit(s,SERVICE_GOODS,0xb7f5,B_CHOOSE);}
;	---------------------------------
; Function goods
; ---------------------------------
_goods:
	ld	a, #0x12
	push	af
	inc	sp
	ld	bc, #0xb7f5
	push	bc
	ld	a, #0x04
	call	_emit
	ret
;src/services.c:36: static const ServiceAction *items(ServiceState *s) {return emit(s,SERVICE_ITEMS,0xb882,S_CHOOSE);}
;	---------------------------------
; Function items
; ---------------------------------
_items:
	ld	a, #0x14
	push	af
	inc	sp
	ld	bc, #0xb882
	push	bc
	ld	a, #0x05
	call	_emit
	ret
;src/services.c:37: static const ServiceAction *church_experience(ServiceState *s) {
;	---------------------------------
; Function church_experience
; ---------------------------------
_church_experience:
	add	sp, #-9
	ldhl	sp,	#7
	ld	a, e
	ld	(hl+), a
;src/services.c:38: RPGState *r=s->events->rpg;
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	inc	b
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#2
	ld	(hl+), a
	inc	de
	ld	a, (de)
;src/services.c:39: while(s->exp_character<4u) {
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
00105$:
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
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
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	sub	a, #0x04
	jp	NC, 00107$
;src/services.c:40: s->character=s->exp_character++;
	inc	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	inc	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(bc), a
;src/services.c:41: if(!(r->party[s->character].status&1u)) continue;
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	rrca
	jr	NC, 00105$
;src/services.c:42: if(r->party[s->character].level>=30u) return say(s,0xbdff,C_EXP);
	ld	a, (bc)
	ldhl	sp,	#4
	ld	(hl-), a
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	hl, #0x0005
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
	ld	(hl), a
	sub	a, #0x1e
	jr	C, 00104$
	inc	hl
	ld	a, #0x10
	push	af
	inc	sp
	ld	bc, #0xbdff
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00108$
00104$:
;src/services.c:43: s->action.number=rpg_exp_to_next(r,s->character);return say(s,0xba1f,C_EXP);
	ldhl	sp,#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	dec	hl
	ld	a, (hl-)
	dec	hl
	push	af
	inc	sp
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_exp_to_next
	ld	hl, #_rpg_exp_to_next
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#3
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
	ld	a, #0x10
	push	af
	inc	sp
	ld	bc, #0xba1f
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00108$
00107$:
;src/services.c:45: return done(s);
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_done
	ldhl	sp,	#5
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ldhl	sp,	#5
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00108$:
;src/services.c:46: }
	add	sp, #9
	ret
;src/services.c:47: const ServiceAction *service_begin(ServiceState *s,EventState *events,uint8_t type,uint8_t shop) RPG_BANKED {
;	---------------------------------
; Function service_begin
; ---------------------------------
	b_service_begin	= 19
_service_begin::
;src/services.c:48: memset(s,0,sizeof(*s));s->events=events;s->type=type;s->shop=shop&31u;
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0011
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl+)
	ld	(de), a
	dec	de
	ld	c, e
	ld	b, d
	inc	bc
	inc	bc
	ld	a, (hl+)
	ld	(bc), a
	ld	c, e
	ld	b, d
	inc	bc
	inc	bc
	inc	bc
;src/services.c:49: if(type>=0x12u && type<=0x13u) return ask(s,0xb8c8,H_ENTER);
	ld	a, (hl-)
	and	a, #0x1f
	ld	(bc), a
	ld	a, (hl)
	sub	a, #0x12
	jr	C, 00102$
	ld	a, #0x13
	sub	a, (hl)
	jr	C, 00102$
	ld	a, #0x01
	push	af
	inc	sp
	ld	bc, #0xb8c8
	call	_ask
	ret
00102$:
;src/services.c:50: if(type>=0x14u && type<=0x15u) {events->last_church=shop;return ask(s,0xb97f,C_ENTER);}
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x14
	jr	C, 00105$
	ld	a, #0x15
	sub	a, (hl)
	jr	C, 00105$
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #0x0103
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#11
	ld	a, (hl)
	ld	(bc), a
	ld	a, #0x08
	push	af
	inc	sp
	ld	bc, #0xb97f
	call	_ask
	ret
00105$:
;src/services.c:51: if(type>=0x16u && type<=0x17u) return ask(s,0xb7c7,B_ENTER);
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x16
	jr	C, 00108$
	ld	a, #0x17
	sub	a, (hl)
	jr	C, 00108$
	ld	a, #0x11
	push	af
	inc	sp
	ld	bc, #0xb7c7
	call	_ask
	ret
00108$:
;src/services.c:52: if(type>=0x18u && type<=0x19u) return ask(s,0xb832,B_ENTER);
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x18
	jr	C, 00111$
	ld	a, #0x19
	sub	a, (hl)
	jr	C, 00111$
	ld	a, #0x11
	push	af
	inc	sp
	ld	bc, #0xb832
	call	_ask
	ret
00111$:
;src/services.c:53: if(type>=0x1au && type<=0x1bu) return say(s,0xb85d,BS_CHOOSE);
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x1a
	jr	C, 00114$
	ld	a, #0x1b
	sub	a, (hl)
	jr	C, 00114$
	ld	a, #0x17
	push	af
	inc	sp
	ld	bc, #0xb85d
	call	_say
	ret
00114$:
;src/services.c:54: return emit(s,SERVICE_INVALID,0,DONE);
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0x0000
	push	bc
	ld	a, #0xff
	call	_emit
;src/services.c:55: }
	ret
;src/services.c:56: const ServiceAction *service_advance(ServiceState *s) RPG_BANKED {
;	---------------------------------
; Function service_advance
; ---------------------------------
	b_service_advance	= 19
_service_advance::
	add	sp, #-6
;src/services.c:58: if(s->action.kind!=SERVICE_DIALOGUE && s->action.kind!=SERVICE_EFFECT && s->action.kind!=SERVICE_WAIT) return &s->action;
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
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#5
	ld	(hl), a
	dec	a
	jr	Z, 00102$
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x07
	jr	Z, 00102$
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x08
	jr	Z, 00102$
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	jp	00124$
00102$:
;src/services.c:59: switch(s->stage) {
	pop	de
	push	de
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ld	a, #0x1a
	sub	a, c
	jp	C, 00122$
	ld	b, #0x00
	ld	hl, #00200$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00200$:
	.dw	00105$
	.dw	00122$
	.dw	00122$
	.dw	00107$
	.dw	00106$
	.dw	00122$
	.dw	00109$
	.dw	00122$
	.dw	00122$
	.dw	00122$
	.dw	00122$
	.dw	00110$
	.dw	00112$
	.dw	00113$
	.dw	00117$
	.dw	00118$
	.dw	00119$
	.dw	00122$
	.dw	00122$
	.dw	00122$
	.dw	00120$
	.dw	00122$
	.dw	00122$
	.dw	00121$
	.dw	00108$
	.dw	00111$
	.dw	00116$
;src/services.c:60: case DONE:return done(s);
00105$:
	pop	de
	push	de
	call	_done
	jp	00124$
;src/services.c:61: case H_RETURN:return hospital_return(s);
00106$:
	pop	de
	push	de
	call	_hospital_return
	jp	00124$
;src/services.c:62: case H_FULL:return multiple(s)?hospital_choose(s):say(s,0xb964,DONE);
00107$:
	pop	de
	push	de
	push	de
	ld	e, #b_multiple
	ld	hl, #_multiple
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,#5
	ld	(hl), a
	or	a, a
	jr	Z, 00126$
	pop	de
	push	de
	call	_hospital_choose
	ldhl	sp,	#4
	ld	(hl), c
	inc	hl
	ld	(hl), b
	jr	00127$
00126$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb964
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	ldhl	sp,	#4
	ld	(hl), c
	inc	hl
	ld	(hl), b
00127$:
	ldhl	sp,	#4
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	00124$
;src/services.c:63: case H_FILL:
00108$:
;src/services.c:64: s->events->rpg->party[s->character].hp=s->events->rpg->party[s->character].max_hp;
	ldhl	sp,	#0
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
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
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e,l
	ld	d,h
	inc	hl
	ld	a, e
	add	a, #0x06
	ld	e, a
	jr	NC, 00201$
	inc	d
00201$:
	ld	a, (de)
	ld	(hl), a
;src/services.c:65: s->events->rpg->party[s->character].mp=s->events->rpg->party[s->character].max_mp;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	inc	h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, (bc)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	inc	bc
	inc	bc
	ld	de, #0x0007
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
;src/services.c:66: return say(s,0xb938,H_HEALED);
	ld	a, #0x06
	push	af
	inc	sp
	ld	bc, #0xb938
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00124$
;src/services.c:67: case H_HEALED:return multiple(s)?ask(s,0xb90a,H_ANOTHER):done(s);
00109$:
	pop	de
	push	de
	push	de
	ld	e, #b_multiple
	ld	hl, #_multiple
	call	___sdcc_bcall_ehl
	pop	hl
	or	a, a
	jr	Z, 00128$
	ld	a, #0x07
	push	af
	inc	sp
	ld	bc, #0xb90a
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00124$
00128$:
	pop	de
	push	de
	call	_done
	jp	00124$
;src/services.c:68: case C_CAST:
00110$:
;src/services.c:69: result=rpg_revive(s->events->rpg,s->character);
	pop	de
	push	de
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	b, a
	pop	de
	push	de
	ld	a, (de)
	ld	l, a
	inc	de
	ld	a, (de)
	ld	h, a
	inc	h
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	inc	sp
	push	hl
	ld	e, #b_rpg_revive
	ld	hl, #_rpg_revive
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/services.c:70: return say(s,result==RPG_OK?0xb9c4:0xbd9f,result==RPG_OK?C_REVIVED:C_AGAIN);
	or	a, a
	ld	e, #0x19
	jr	Z, 00131$
	ld	e, #0x0c
00131$:
	or	a, a
	jr	NZ, 00132$
	ld	bc, #0xb9c4
	jr	00133$
00132$:
	ld	bc, #0xbd9f
00133$:
	ld	a, e
	push	af
	inc	sp
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00124$
;src/services.c:71: case C_REVIVED:
00111$:
;src/services.c:72: emit(s,SERVICE_WAIT,0,C_AGAIN);s->action.sound=0xc5;s->action.target=30;return &s->action;
	ld	a, #0x0c
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x08
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	ldhl	sp,	#12
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	hl, #0x0010
	add	hl, bc
	ld	(hl), #0xc5
	ld	hl, #0x000f
	add	hl, bc
	ld	(hl), #0x1e
	ld	hl, #0x0008
	add	hl, bc
	ld	c, l
	ld	b, h
	jp	00124$
;src/services.c:73: case C_AGAIN:return ask(s,0xb9e5,C_AGAIN);
00112$:
	ld	a, #0x0c
	push	af
	inc	sp
	ld	bc, #0xb9e5
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00124$
;src/services.c:74: case C_ALIVE:
00113$:
;src/services.c:75: if(multiple(s))return ask(s,0xb9e5,C_AGAIN);
	pop	de
	push	de
	push	de
	ld	e, #b_multiple
	ld	hl, #_multiple
	call	___sdcc_bcall_ehl
	pop	hl
	or	a, a
	jr	Z, 00115$
	ld	a, #0x0c
	push	af
	inc	sp
	ld	bc, #0xb9e5
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00124$
00115$:
;src/services.c:76: emit(s,SERVICE_WAIT,0,C_ALONE_WAIT);s->action.target=0;return &s->action;
	ld	a, #0x1a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x08
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	ldhl	sp,	#12
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	ld	hl, #0x000f
	add	hl, bc
	ld	(hl), #0x00
	ld	hl, #0x0008
	add	hl, bc
	ld	c, l
	ld	b, h
	jr	00124$
;src/services.c:77: case C_ALONE_WAIT:return church_exit(s);
00116$:
	pop	de
	push	de
	call	_church_exit
	jr	00124$
;src/services.c:78: case C_BLESS:return say(s,0xba04,C_GUIDE);
00117$:
	ld	a, #0x0f
	push	af
	inc	sp
	ld	bc, #0xba04
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00124$
;src/services.c:79: case C_GUIDE:s->exp_character=0;return church_experience(s);
00118$:
	pop	de
	push	de
	ld	hl, #0x0007
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	pop	de
	push	de
	call	_church_experience
	jr	00124$
;src/services.c:80: case C_EXP:return church_experience(s);
00119$:
	pop	de
	push	de
	call	_church_experience
	jr	00124$
;src/services.c:81: case S_CHOOSE:return items(s);
00120$:
	pop	de
	push	de
	call	_items
	jr	00124$
;src/services.c:82: case BS_CHOOSE:return emit(s,SERVICE_BUY_SELL,0,BS_CHOOSE);
00121$:
	ld	a, #0x17
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x06
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jr	00124$
;src/services.c:83: default:return emit(s,SERVICE_INVALID,0,DONE);
00122$:
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
;src/services.c:84: }
00124$:
;src/services.c:85: }
	add	sp, #6
	ret
;src/services.c:86: const ServiceAction *service_respond(ServiceState *s,uint8_t yes) RPG_BANKED {
;	---------------------------------
; Function service_respond
; ---------------------------------
	b_service_respond	= 19
_service_respond::
	add	sp, #-6
;src/services.c:89: RPGState *r=s->events->rpg;
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
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	inc	b
	ld	e, c
	ld	d, b
	ld	a, (de)
	ldhl	sp,	#4
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;src/services.c:91: if(s->action.kind!=SERVICE_YES_NO) return &s->action;
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x02
	jr	Z, 00102$
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	jp	00123$
00102$:
;src/services.c:92: switch(s->stage) {
	pop	de
	push	de
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	cp	a, #0x01
	jr	Z, 00103$
	cp	a, #0x05
	jr	Z, 00104$
	cp	a, #0x07
	jp	Z, 00109$
	cp	a, #0x08
	jp	Z, 00110$
	cp	a, #0x0a
	jp	Z, 00111$
	cp	a, #0x0c
	jp	Z, 00112$
	cp	a, #0x11
	jp	Z, 00114$
	cp	a, #0x13
	jp	Z, 00114$
	cp	a, #0x15
	jp	Z, 00115$
	sub	a, #0x16
	jp	Z, 00120$
	jp	00121$
;src/services.c:93: case H_ENTER:return yes?hospital_choose(s):say(s,0xb951,DONE);
00103$:
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00125$
	pop	de
	push	de
	call	_hospital_choose
	jp	00123$
00125$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb951
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00123$
;src/services.c:94: case H_COST:
00104$:
;src/services.c:95: if(!yes)return hospital_return(s);
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	NZ, 00106$
	pop	de
	push	de
	call	_hospital_return
	jp	00123$
00106$:
;src/services.c:98: if(r->money<s->action.number)return say(s,0xbd57,DONE);
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x005a
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
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	pop	de
	push	de
	ld	hl, #0x000b
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#4
	ld	a, (hl+)
	sub	a, c
	ld	a, (hl)
	sbc	a, b
	jr	NC, 00108$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xbd57
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00123$
00108$:
;src/services.c:99: r->money-=s->action.number;
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, e
	sub	a, c
	ld	e, a
	ld	a, d
	sbc	a, b
	ld	b, a
	ld	c, e
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/services.c:100: emit(s,SERVICE_EFFECT,0,H_FILL);s->action.sound=0xc1;return &s->action;
	ld	a, #0x18
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0x07
	ldhl	sp,	#3
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
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
	ld	hl, #0x0010
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
	ld	(hl), #0xc1
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
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
	jp	00123$
;src/services.c:101: case H_ANOTHER:return yes?hospital_choose(s):say(s,0xb951,DONE);
00109$:
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00127$
	pop	de
	push	de
	call	_hospital_choose
	jp	00123$
00127$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb951
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00123$
;src/services.c:102: case C_ENTER:return yes?church_choose(s):church_exit(s);
00110$:
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00129$
	pop	de
	push	de
	call	_church_choose
	jp	00123$
00129$:
	pop	de
	push	de
	call	_church_exit
	jp	00123$
;src/services.c:103: case C_COST:return yes?say(s,0xb9b0,C_CAST):ask(s,0xb9e5,C_AGAIN);
00111$:
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
	ld	a, #0x0b
	push	af
	inc	sp
	ld	bc, #0xb9b0
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00123$
00131$:
	ld	a, #0x0c
	push	af
	inc	sp
	ld	bc, #0xb9e5
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00123$
;src/services.c:104: case C_AGAIN:return yes?church_choose(s):church_exit(s);
00112$:
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00133$
	pop	de
	push	de
	call	_church_choose
	jp	00123$
00133$:
	pop	de
	push	de
	call	_church_exit
	jp	00123$
;src/services.c:105: case B_ENTER:case B_AGAIN:return yes?goods(s):say(s,0xb7e3,DONE);
00114$:
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00135$
	pop	de
	push	de
	call	_goods
	jp	00123$
00135$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb7e3
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00123$
;src/services.c:106: case S_COST:
00115$:
;src/services.c:107: if(!yes)return items(s);
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	NZ, 00117$
	pop	de
	push	de
	call	_items
	jr	00123$
00117$:
;src/services.c:108: result=rpg_sell(r,s->slot);
	pop	de
	push	de
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	push	af
	inc	sp
	ldhl	sp,	#5
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_sell
	ld	hl, #_rpg_sell
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/services.c:109: if(result!=RPG_OK)return say(s,0xbd7e,S_CHOOSE);
	or	a, a
	jr	Z, 00119$
	ld	a, #0x14
	push	af
	inc	sp
	ld	bc, #0xbd7e
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00123$
00119$:
;src/services.c:110: return ask(s,0xb8bc,S_AGAIN);
	ld	a, #0x16
	push	af
	inc	sp
	ld	bc, #0xb8bc
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jr	00123$
;src/services.c:111: case S_AGAIN:return yes?items(s):say(s,0xb7e3,DONE);
00120$:
	ldhl	sp,	#14
	ld	a, (hl)
	or	a, a
	jr	Z, 00137$
	pop	de
	push	de
	call	_items
	jr	00123$
00137$:
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb7e3
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00123$
;src/services.c:112: default:return emit(s,SERVICE_INVALID,0,DONE);
00121$:
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
;src/services.c:113: }
00123$:
;src/services.c:114: }
	add	sp, #6
	ret
;src/services.c:115: const ServiceAction *service_select(ServiceState *s,uint8_t selection) RPG_BANKED {
;	---------------------------------
; Function service_select
; ---------------------------------
	b_service_select	= 19
_service_select::
	add	sp, #-16
;src/services.c:116: RPGState *r=s->events->rpg;
	ldhl	sp,	#22
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
	ldhl	sp,	#23
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (de)
	ld	c, a
	inc	de
	ld	a, (de)
	ld	b, a
	inc	b
	ld	e, c
	ld	d, b
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
;src/services.c:121: if(s->action.kind==SERVICE_PARTY) {
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#7
	ld	(hl), a
;src/services.c:122: if(selection==255u)return s->stage==H_CHOOSE?say(s,0xb951,DONE):church_exit(s);
	ldhl	sp,	#24
	ld	a, (hl)
	inc	a
	ld	a, #0x01
	jr	Z, 00341$
	xor	a, a
00341$:
	ld	c, a
;src/services.c:123: if(selection>=4u || !(r->joined_mask&(1u<<selection)))return &s->action;
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
;src/services.c:128: s->action.number=rpg_hospital_cost(r,selection);return ask(s,0xb8e0,H_COST);
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
;src/services.c:121: if(s->action.kind==SERVICE_PARTY) {
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x03
	jp	NZ, 00152$
;src/services.c:122: if(selection==255u)return s->stage==H_CHOOSE?say(s,0xb951,DONE):church_exit(s);
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
	ld	a, c
	or	a, a
	jr	Z, 00102$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	sub	a, #0x02
	jr	NZ, 00156$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb951
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	ldhl	sp,	#14
	ld	(hl), c
	inc	hl
	ld	(hl), b
	jr	00157$
00156$:
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_church_exit
	ldhl	sp,	#14
	ld	(hl), c
	inc	hl
	ld	(hl), b
00157$:
	ldhl	sp,	#14
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	00154$
00102$:
;src/services.c:123: if(selection>=4u || !(r->joined_mask&(1u<<selection)))return &s->action;
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00103$
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0059
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#24
	ld	b, (hl)
	ld	de, #0x0001
	inc	b
	jr	00347$
00346$:
	sla	e
	rl	d
00347$:
	dec	b
	jr	NZ,00346$
	and	a, e
	ld	c, #0x00
	or	a, c
	jr	NZ, 00104$
00103$:
	ldhl	sp,	#8
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	00154$
00104$:
;src/services.c:124: s->character=selection;p=&r->party[selection];
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#24
	ld	a, (hl)
	ld	(bc), a
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
;src/services.c:125: if(s->stage==H_CHOOSE) {
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
;src/services.c:126: if(!(p->status&1u))return say(s,0xb730,H_RETURN);
	ld	l, c
	ld	h, b
;src/services.c:125: if(s->stage==H_CHOOSE) {
	cp	a, #0x02
	jr	NZ, 00112$
;src/services.c:126: if(!(p->status&1u))return say(s,0xb730,H_RETURN);
	ld	a, (hl)
	rrca
	jr	C, 00107$
	ld	a, #0x04
	push	af
	inc	sp
	ld	bc, #0xb730
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00154$
00107$:
;src/services.c:127: if(p->hp==p->max_hp && p->mp==p->max_mp)return say(s,0xb96b,H_FULL);
	ld	l, c
	ld	h, b
	inc	hl
	ld	e, (hl)
	ld	hl, #0x0006
	add	hl, bc
	ld	a, (hl)
	sub	a, e
	jr	NZ, 00109$
	ld	l, c
	ld	h, b
	inc	hl
	inc	hl
	ld	e, (hl)
	ld	hl, #0x0007
	add	hl, bc
	ld	a, (hl)
	sub	a, e
	jr	NZ, 00109$
	ld	a, #0x03
	push	af
	inc	sp
	ld	bc, #0xb96b
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00154$
00109$:
;src/services.c:128: s->action.number=rpg_hospital_cost(r,selection);return ask(s,0xb8e0,H_COST);
	ldhl	sp,	#24
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_hospital_cost
	ld	hl, #_rpg_hospital_cost
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	a, #0x05
	push	af
	inc	sp
	ld	bc, #0xb8e0
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00154$
00112$:
;src/services.c:130: if(s->stage==C_CHOOSE) {
	sub	a, #0x09
	jp	NZ, 00153$
;src/services.c:131: if(p->status&1u)return say(s,0xba56,C_ALIVE);
	ld	a, (hl)
	rrca
	jr	NC, 00114$
	ld	a, #0x0d
	push	af
	inc	sp
	ld	bc, #0xba56
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00154$
00114$:
;src/services.c:132: s->action.number=rpg_revival_cost(r,selection);return ask(s,0xb9ee,C_COST);
	ldhl	sp,	#24
	ld	a, (hl)
	push	af
	inc	sp
	ldhl	sp,	#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_revival_cost
	ld	hl, #_rpg_revival_cost
	call	___sdcc_bcall_ehl
	add	sp, #3
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	a, #0x0a
	push	af
	inc	sp
	ld	bc, #0xb9ee
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jp	00154$
00152$:
;src/services.c:138: s->action.item=item;s->action.number=price;
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#14
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#13
	ld	(hl), a
;src/services.c:144: count=r->inventory_count;result=rpg_buy(r,s->shop,selection);
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0058
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl), a
;src/services.c:134: } else if(s->action.kind==SERVICE_GOODS) {
	ldhl	sp,	#7
	ld	a, (hl)
;src/services.c:135: if(selection==255u)return say(s,0xb7e3,DONE);
	sub	a, #0x04
	jp	NZ, 00149$
	or	a, c
	jr	Z, 00118$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb7e3
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00154$
00118$:
;src/services.c:136: result=rpg_shop_option(s->shop,selection,&item,&price);
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	push	bc
	ld	hl, #3
	add	hl, sp
	push	hl
	push	de
	ldhl	sp,	#30
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_rpg_shop_option
	ld	hl, #_rpg_shop_option
	call	___sdcc_bcall_ehl
	add	sp, #6
	pop	bc
;src/services.c:137: if(result!=RPG_OK)return &s->action;
	or	a, a
	jr	Z, 00120$
	ldhl	sp,	#8
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	00154$
00120$:
;src/services.c:138: s->action.item=item;s->action.number=price;
	ldhl	sp,	#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/services.c:136: result=rpg_shop_option(s->shop,selection,&item,&price);
	ld	a, (bc)
	ld	c, a
;src/services.c:142: say(s,event_action->dialogue_id,DONE);s->action.sound=event_action->sound;return &s->action;
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0010
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
;src/services.c:139: if(item==ItemID_Secrets) {
	ldhl	sp,	#0
	ld	a, (hl)
	sub	a, #0x40
	jr	NZ, 00122$
;src/services.c:140: event_action=event_buy_secret(s->events,s->shop,selection);
	ldhl	sp,#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b, a
	inc	de
	ld	a, (de)
	ldhl	sp,	#24
	ld	h, (hl)
	push	hl
	inc	sp
	ld	h, c
	push	hl
	inc	sp
	ld	e, b
	ld	d, a
	push	de
	ld	e, #b_event_buy_secret
	ld	hl, #_event_buy_secret
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#14
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/services.c:141: s->action.item=event_action->item;
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/services.c:142: say(s,event_action->dialogue_id,DONE);s->action.sound=event_action->sound;return &s->action;
	ldhl	sp,	#14
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	ldhl	sp,	#8
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	00154$
00122$:
;src/services.c:144: count=r->inventory_count;result=rpg_buy(r,s->shop,selection);
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	(hl), a
	ldhl	sp,	#24
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_buy
	ld	hl, #_rpg_buy
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/services.c:145: if(result==RPG_FULL)return say(s,0xb813,DONE);
	cp	a, #0x02
	jr	NZ, 00124$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb813
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00154$
00124$:
;src/services.c:146: if(result==RPG_NO_MONEY)return say(s,0xbd57,DONE);
	cp	a, #0x03
	jr	NZ, 00126$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xbd57
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00154$
00126$:
;src/services.c:147: if(result!=RPG_OK)return emit(s,SERVICE_INVALID,0,DONE);
	or	a, a
	jr	Z, 00128$
	xor	a, a
	push	af
	inc	sp
	ld	de, #0x0000
	push	de
	ld	a, #0xff
	ldhl	sp,	#25
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_emit
	jp	00154$
00128$:
;src/services.c:148: ask(s,0xb807,B_AGAIN);if(r->inventory_count!=count)s->action.sound=0xb3;return &s->action;
	ld	a, #0x13
	push	af
	inc	sp
	ld	bc, #0xb807
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (de)
	ld	c, a
	ld	a, (hl)
	sub	a, c
	jr	Z, 00130$
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0xb3
00130$:
	ldhl	sp,	#8
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	00154$
00149$:
;src/services.c:149: } else if(s->action.kind==SERVICE_ITEMS) {
	ldhl	sp,	#7
	ld	a, (hl)
;src/services.c:150: if(selection==255u)return say(s,0xb7e3,DONE);
	sub	a, #0x05
	jp	NZ, 00146$
	or	a, c
	jr	Z, 00132$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb7e3
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jp	00154$
00132$:
;src/services.c:151: if(selection>=r->inventory_count)return &s->action;
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#24
	ld	a, (hl)
	sub	a, c
	jr	C, 00134$
	ldhl	sp,	#8
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
	jp	00154$
00134$:
;src/services.c:152: s->slot=selection;s->action.item=r->inventory[selection];
	ldhl	sp,#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#24
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,#5
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0040
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#24
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	ldhl	sp,	#12
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/services.c:153: s->action.number=rpg_sell_price(s->action.item);
	push	af
	inc	sp
	ld	e, #b_rpg_sell_price
	ld	hl, #_rpg_sell_price
	call	___sdcc_bcall_ehl
	inc	sp
	ldhl	sp,	#10
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, c
	ld	(hl+), a
;src/services.c:154: if(!s->action.number)return say(s,0xbd7e,S_CHOOSE);
	ld	a,b
	ld	(hl),a
	or	a, c
	jr	NZ, 00136$
	ld	a, #0x14
	push	af
	inc	sp
	ld	bc, #0xbd7e
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00154$
00136$:
;src/services.c:155: return ask(s,0xb89a,S_COST);
	ld	a, #0x15
	push	af
	inc	sp
	ld	bc, #0xb89a
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_ask
	jr	00154$
00146$:
;src/services.c:156: } else if(s->action.kind==SERVICE_BUY_SELL) {
	ldhl	sp,	#7
	ld	a, (hl)
;src/services.c:157: if(selection==255u)return say(s,0xb7e3,DONE);
	sub	a, #0x06
	jr	NZ, 00153$
	or	a, c
	jr	Z, 00138$
	xor	a, a
	push	af
	inc	sp
	ld	bc, #0xb7e3
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_say
	jr	00154$
00138$:
;src/services.c:158: if(selection==0u)return goods(s);
	ldhl	sp,	#24
	ld	a, (hl)
	or	a, a
	jr	NZ, 00140$
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_goods
	jr	00154$
00140$:
;src/services.c:159: if(selection==1u)return items(s);
	ldhl	sp,	#24
	ld	a, (hl)
	dec	a
	jr	NZ, 00153$
	ldhl	sp,	#22
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	_items
	jr	00154$
00153$:
;src/services.c:161: return &s->action;
	ldhl	sp,	#8
	ld	c, (hl)
	inc	hl
	ld	b, (hl)
00154$:
;src/services.c:162: }
	add	sp, #16
	ret
	.area _CODE_19
	.area _INITIALIZER
	.area _CABS (ABS)
