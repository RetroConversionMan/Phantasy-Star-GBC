;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module battle_view
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_dialogue_item_name
	.globl _dialogue_item_name
	.globl b_dialogue_next_page
	.globl _dialogue_next_page
	.globl b_dialogue_open
	.globl _dialogue_open
	.globl b_rpg_battle_decline_chest
	.globl _rpg_battle_decline_chest
	.globl b_rpg_battle_replace_reward
	.globl _rpg_battle_replace_reward
	.globl b_rpg_battle_open_chest
	.globl _rpg_battle_open_chest
	.globl b_rpg_battle_step
	.globl _rpg_battle_step
	.globl b_rpg_battle_prepare
	.globl _rpg_battle_prepare
	.globl b_rpg_claim_rewards
	.globl _rpg_claim_rewards
	.globl b_rpg_battle_begin
	.globl _rpg_battle_begin
	.globl b_rpg_magic_cost
	.globl _rpg_magic_cost
	.globl b_rpg_spell_option
	.globl _rpg_spell_option
	.globl b_rpg_enemy_name
	.globl _rpg_enemy_name
	.globl b_rpg_item_discardable
	.globl _rpg_item_discardable
	.globl _memset
	.globl _strcpy
	.globl b_enemy_art_draw
	.globl _enemy_art_draw
	.globl b_ui_number
	.globl _ui_number
	.globl b_ui_text
	.globl _ui_text
	.globl b_ui_panel
	.globl _ui_panel
	.globl _display_off
	.globl _battle_view_dialogue_id
	.globl _battle_view_result
	.globl _battle_view_choice
	.globl _battle_view_actor
	.globl _battle_view_state
	.globl _battle_view_battle
	.globl b_battle_view_begin
	.globl _battle_view_begin
	.globl b_battle_view_tick
	.globl _battle_view_tick
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_battle_view_battle::
	.ds 179
_battle_view_state::
	.ds 1
_battle_view_actor::
	.ds 1
_battle_view_choice::
	.ds 1
_battle_view_result::
	.ds 1
_battle_view_dialogue_id::
	.ds 2
_party:
	.ds 2
_actions:
	.ds 12
_message:
	.ds 88
_after_message:
	.ds 1
_is_literal:
	.ds 1
_prompt_kind:
	.ds 1
_selected_spell:
	.ds 1
_selected_slot:
	.ds 1
_level_cursor:
	.ds 1
_old_battle_magic:
	.ds 4
_old_map_magic:
	.ds 4
_replacement_slot:
	.ds 1
_enemy_name:
	.ds 9
_item_name:
	.ds 9
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
	.area _CODE_30
;src/battle_view.c:70: static uint8_t eligible(uint8_t c) {
;	---------------------------------
; Function eligible
; ---------------------------------
_eligible:
	ld	c, a
;src/battle_view.c:71: return (party->joined_mask&(1u<<c)) && (party->party[c].status&1u) && party->party[c].hp && !party->party[c].bound;
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	ld	hl, #0x0059
	add	hl, de
	ld	a, (hl)
	ld	b, c
	ld	hl, #0x0001
	inc	b
	jr	00132$
00131$:
	add	hl, hl
00132$:
	dec	b
	jr	NZ,00131$
	and	a, l
	ld	b, #0x00
	or	a, b
	jr	Z, 00103$
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	c, a
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	and	a, #0x01
	jr	Z, 00103$
	ld	hl, #_party
	ld	a, (hl+)
	add	a, c
	ld	c, a
	ld	a, (hl)
	adc	a, #0x00
	ld	b, a
	ld	l, c
	ld	h, b
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00103$
	ld	hl, #0x000d
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
00103$:
	xor	a, a
	ret
00104$:
	ld	a, #0x01
;src/battle_view.c:72: }
	ret
_names:
	.dw __str_0
	.dw __str_1
	.dw __str_2
	.dw __str_3
_spells:
	.dw __str_4
	.dw __str_5
	.dw __str_6
	.dw __str_7
	.dw __str_8
	.dw __str_9
	.dw __str_10
	.dw __str_11
	.dw __str_12
	.dw __str_13
	.dw __str_14
	.dw __str_15
	.dw __str_16
	.dw __str_17
	.dw __str_18
	.dw __str_19
	.dw __str_20
	.dw __str_21
	.dw __str_22
_talk_texts:
	.dw #0xbaae
	.dw #0xbad0
	.dw #0xbae6
	.dw #0xbaf4
	.dw #0xbb06
	.dw #0xbb0d
	.dw #0xbb20
	.dw #0xbb3d
	.dw #0xbb45
	.dw #0xbb5c
	.dw #0xbb8d
	.dw #0xbbbf
	.dw #0xbbd2
	.dw #0xbbf0
	.dw #0xbc1a
	.dw #0xbc42
	.dw #0xbc5b
	.dw #0xbc89
	.dw #0xbcaa
__str_0:
	.ascii "ALIS"
	.db 0x00
__str_1:
	.ascii "MYAU"
	.db 0x00
__str_2:
	.ascii "ODIN"
	.db 0x00
__str_3:
	.ascii "NOAH"
	.db 0x00
__str_4:
	.db 0x00
__str_5:
	.ascii "HEAL"
	.db 0x00
__str_6:
	.ascii "CURE"
	.db 0x00
__str_7:
	.ascii "WALL"
	.db 0x00
__str_8:
	.ascii "PROT"
	.db 0x00
__str_9:
	.ascii "FIRE"
	.db 0x00
__str_10:
	.ascii "THUN"
	.db 0x00
__str_11:
	.ascii "WIND"
	.db 0x00
__str_12:
	.ascii "ROPE"
	.db 0x00
__str_13:
	.ascii "BYE"
	.db 0x00
__str_14:
	.ascii "HELP"
	.db 0x00
__str_15:
	.ascii "TERR"
	.db 0x00
__str_16:
	.ascii "TRAP"
	.db 0x00
__str_17:
	.ascii "EXIT"
	.db 0x00
__str_18:
	.ascii "OPEN"
	.db 0x00
__str_19:
	.ascii "RISE"
	.db 0x00
__str_20:
	.ascii "CHAT"
	.db 0x00
__str_21:
	.ascii "TELE"
	.db 0x00
__str_22:
	.ascii "FLY"
	.db 0x00
;src/battle_view.c:73: static uint8_t character_for_message(void) {
;	---------------------------------
; Function character_for_message
; ---------------------------------
_character_for_message:
;src/battle_view.c:74: uint8_t c=battle_view_battle.last_actor;
	ld	a, (#(_battle_view_battle + 144) + 0)
;src/battle_view.c:75: if(c>=4u)c=battle_view_battle.last_target;
	cp	a, #0x04
	jr	C, 00102$
	ld	a, (#(_battle_view_battle + 145) + 0)
00102$:
;src/battle_view.c:76: return c<4u?c:battle_view_actor<4u?battle_view_actor:0u;
	cp	a, #0x04
	ret	C
	ld	a, (#_battle_view_actor)
	cp	a,#0x04
	ret	C
	xor	a, a
;src/battle_view.c:77: }
	ret
;src/battle_view.c:78: static void message_page(void) {
;	---------------------------------
; Function message_page
; ---------------------------------
_message_page:
;src/battle_view.c:79: dialogue_next_page(&message);
	ld	de, #_message
	push	de
	ld	e, #b_dialogue_next_page
	ld	hl, #_dialogue_next_page
	call	___sdcc_bcall_ehl
	pop	hl
;src/battle_view.c:80: ui_panel(104,5);ui_text(1,1,message.lines[0]);ui_text(1,2,message.lines[1]);ui_text(17,4,">");
	ld	hl, #0x568
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	de, #(_message + 50)
	push	de
	ld	hl, #0x101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #(_message + 69)
	push	de
	ld	hl, #0x201
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_23
	push	de
	ld	hl, #0x411
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:81: battle_view_state=BVIEW_MESSAGE;
	ld	hl, #_battle_view_state
	ld	(hl), #0x05
;src/battle_view.c:82: }
	ret
___str_23:
	.ascii ">"
	.db 0x00
;src/battle_view.c:83: static void say(uint16_t id,uint8_t next,uint8_t character,uint8_t item,uint16_t number) {
;	---------------------------------
; Function say
; ---------------------------------
_say:
	ld	(#_after_message),a
;src/battle_view.c:84: after_message=next;is_literal=0;battle_view_dialogue_id=id;
	xor	a, a
	ld	(#_is_literal),a
	ld	hl, #_battle_view_dialogue_id
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
;src/battle_view.c:85: if(!dialogue_open(&message,id)) {
	push	de
	ld	de, #_message
	push	de
	ld	e, #b_dialogue_open
	ld	hl, #_dialogue_open
	call	___sdcc_bcall_ehl
	add	sp, #4
	or	a, a
	jr	NZ, 00102$
;src/battle_view.c:86: ui_panel(104,5);ui_text(1,1,"TEXT UNAVAILABLE");ui_text(1,3,"A / B");is_literal=1;battle_view_state=BVIEW_MESSAGE;return;
	ld	hl, #0x568
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	de, #___str_24
	push	de
	ld	hl, #0x101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_25
	push	de
	ld	hl, #0x301
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	hl, #_is_literal
	ld	(hl), #0x01
	ld	hl, #_battle_view_state
	ld	(hl), #0x05
	jr	00105$
00102$:
;src/battle_view.c:88: if(character<4u)strcpy(message.character,names[character]);
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00104$
	ld	bc, #_names+0
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	de, #(_message + 18)
	push	de
	call	_strcpy
	add	sp, #4
00104$:
;src/battle_view.c:89: strcpy(message.enemy,enemy_name);dialogue_item_name(item,message.item);message.number=number;
	ld	de, #_enemy_name
	push	de
	ld	de, #(_message + 23)
	push	de
	call	_strcpy
	add	sp, #4
	ld	de, #(_message + 32)
	push	de
	ldhl	sp,	#5
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_dialogue_item_name
	ld	hl, #_dialogue_item_name
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	de, #(_message + 10)
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/battle_view.c:90: message_page();
	call	_message_page
00105$:
;src/battle_view.c:91: }
	pop	hl
	add	sp, #4
	jp	(hl)
___str_24:
	.ascii "TEXT UNAVAILABLE"
	.db 0x00
___str_25:
	.ascii "A / B"
	.db 0x00
;src/battle_view.c:92: static void literal(const char *first,const char *second,uint8_t next) {
;	---------------------------------
; Function literal
; ---------------------------------
_literal:
;src/battle_view.c:93: after_message=next;is_literal=1;battle_view_dialogue_id=0;battle_view_state=BVIEW_MESSAGE;
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(#_after_message),a
	ld	hl, #_is_literal
	ld	(hl), #0x01
	xor	a, a
	ld	hl, #_battle_view_dialogue_id
	ld	(hl+), a
	ld	(hl), a
	ld	hl, #_battle_view_state
	ld	(hl), #0x05
;src/battle_view.c:94: ui_panel(104,5);ui_text(1,1,first);ui_text(1,2,second);ui_text(17,4,">");
	push	bc
	push	de
	ld	hl, #0x568
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	hl, #0x101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	hl, #0x201
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_26
	push	de
	ld	hl, #0x411
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:95: }
	pop	hl
	inc	sp
	jp	(hl)
___str_26:
	.ascii ">"
	.db 0x00
;src/battle_view.c:96: static void command_screen(void) {
;	---------------------------------
; Function command_screen
; ---------------------------------
_command_screen:
;src/battle_view.c:98: RPGCharacter *p=&party->party[battle_view_actor];
	ld	a, (_party)
	ld	c, a
	ld	hl, #_party + 1
	ld	b, (hl)
	ld	a, (#_battle_view_actor)
	swap	a
	and	a, #0xf0
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
;src/battle_view.c:99: battle_view_state=BVIEW_COMMAND;ui_panel(96,6);
	ld	hl, #_battle_view_state
	ld	(hl), #0x01
	push	bc
	ld	hl, #0x660
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
;src/battle_view.c:100: ui_text(0,0,names[battle_view_actor]);ui_text(5,0,"HP");ui_number(8,0,p->hp);
	ld	de, #_names+0
	ld	a, (_battle_view_actor)
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	push	hl
	xor	a, a
	rrca
	push	af
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_27
	push	de
	ld	hl, #0x05
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	ld	l, c
	ld	h, b
	inc	hl
	ld	e, (hl)
	xor	a, a
	push	bc
	ld	d, a
	push	de
	ld	hl, #0x08
	push	hl
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:101: ui_text(12,0,"MP");ui_number(15,0,p->mp);
	ld	de, #___str_28
	push	de
	ld	hl, #0x0c
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	b, #0x00
	ld	c, a
	push	bc
	ld	hl, #0x0f
	push	hl
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:102: ui_text(1,2,"ATTACK");ui_text(8,2,"MAGIC");ui_text(15,2,"ITEM");
	ld	de, #___str_29
	push	de
	ld	hl, #0x201
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_30
	push	de
	ld	hl, #0x208
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_31
	push	de
	ld	hl, #0x20f
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:103: ui_text(1,3,"TALK");ui_text(8,3,"RUN");ui_text(x[battle_view_choice],y[battle_view_choice],">");
	ld	de, #___str_32
	push	de
	ld	hl, #0x301
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_33
	push	de
	ld	hl, #0x308
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	a, #<(_command_screen_y_10000_221)
	ld	hl, #_battle_view_choice
	add	a, (hl)
	ld	c, a
	ld	a, #>(_command_screen_y_10000_221)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	ld	b, a
	ld	a, #<(_command_screen_x_10000_221)
	add	a, (hl)
	ld	e, a
	ld	a, #>(_command_screen_x_10000_221)
	adc	a, #0x00
	ld	d, a
	ld	a, (de)
	ld	de, #___str_34
	push	de
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:104: ui_text(1,5,"A:CHOOSE B:BACK");
	ld	de, #___str_35
	push	de
	ld	hl, #0x501
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:105: }
	ret
_command_screen_x_10000_221:
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x07	; 7
_command_screen_y_10000_221:
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
___str_27:
	.ascii "HP"
	.db 0x00
___str_28:
	.ascii "MP"
	.db 0x00
___str_29:
	.ascii "ATTACK"
	.db 0x00
___str_30:
	.ascii "MAGIC"
	.db 0x00
___str_31:
	.ascii "ITEM"
	.db 0x00
___str_32:
	.ascii "TALK"
	.db 0x00
___str_33:
	.ascii "RUN"
	.db 0x00
___str_34:
	.ascii ">"
	.db 0x00
___str_35:
	.ascii "A:CHOOSE B:BACK"
	.db 0x00
;src/battle_view.c:106: static void spell_screen(void) {
;	---------------------------------
; Function spell_screen
; ---------------------------------
_spell_screen:
;src/battle_view.c:108: battle_view_state=BVIEW_SPELL;ui_panel(0,18);ui_text(1,1,names[battle_view_actor]);ui_text(8,1,"MAGIC");
	ld	hl, #_battle_view_state
	ld	(hl), #0x02
	ld	hl, #0x1200
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	bc, #_names+0
	ld	a, (_battle_view_actor)
	ld	h, #0x00
	ld	l, a
	add	hl, hl
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	hl, #0x101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_36
	push	de
	ld	hl, #0x108
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:109: for(i=0;i<5u;++i){
	ld	b, #0x00
00104$:
;src/battle_view.c:110: id=rpg_spell_option(party,battle_view_actor,i,1);if(!id)break;
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_spell_option
	ld	hl, #_rpg_spell_option
	call	___sdcc_bcall_ehl
	add	sp, #5
	ld	c, a
	pop	af
	ld	b, a
	ld	a, c
	or	a, a
	jr	Z, 00103$
;src/battle_view.c:111: ui_text(3,4+i*2u,spells[id]);ui_text(11,4+i*2u,"MP");ui_number(15,4+i*2u,rpg_magic_cost(id));
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	de, #_spells
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	a, b
	add	a, a
	add	a, #0x04
	ld	e, a
	push	bc
	push	de
	push	hl
	ld	h, e
	ld	l, #0x03
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	push	de
	ld	hl, #___str_37
	push	hl
	ld	h, e
	ld	l, #0x0b
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	pop	bc
	push	bc
	push	de
	ld	a, c
	push	af
	inc	sp
	ld	e, #b_rpg_magic_cost
	ld	hl, #_rpg_magic_cost
	call	___sdcc_bcall_ehl
	inc	sp
	pop	de
	pop	bc
	ld	l, a
	ld	h, #0x00
	push	bc
	push	hl
	ld	h, e
	ld	l, #0x0f
	push	hl
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
;src/battle_view.c:109: for(i=0;i<5u;++i){
	inc	b
	ld	a, b
	sub	a, #0x05
	jp	C, 00104$
00103$:
;src/battle_view.c:113: ui_text(1,4+battle_view_choice*2u,">");ui_text(1,17,"A:CHOOSE B:BACK");
	ld	a, (_battle_view_choice)
	add	a, a
	add	a, #0x04
	ld	de, #___str_38
	push	de
	ld	h, a
	ld	l, #0x01
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_39
	push	de
	ld	hl, #0x1101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:114: }
	ret
___str_36:
	.ascii "MAGIC"
	.db 0x00
___str_37:
	.ascii "MP"
	.db 0x00
___str_38:
	.ascii ">"
	.db 0x00
___str_39:
	.ascii "A:CHOOSE B:BACK"
	.db 0x00
;src/battle_view.c:115: static void item_screen(uint8_t replace) {
;	---------------------------------
; Function item_screen
; ---------------------------------
_item_screen:
	dec	sp
	ld	c, a
;src/battle_view.c:117: if(battle_view_choice>=party->inventory_count)battle_view_choice=party->inventory_count?party->inventory_count-1u:0u;
	ld	a, (_party)
	ld	hl, #_party + 1
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0058
	add	hl, de
	ld	b, (hl)
	ld	a, (#_battle_view_choice)
	sub	a, b
	jr	C, 00102$
	ld	a, b
	or	a, a
	jr	Z, 00113$
	dec	b
	jr	00114$
00113$:
	ld	b, #0x00
00114$:
	ld	hl, #_battle_view_choice
	ld	(hl), b
00102$:
;src/battle_view.c:118: start=(battle_view_choice/6u)*6u;battle_view_state=replace?BVIEW_REPLACE:BVIEW_ITEM;
	ld	a, (_battle_view_choice)
	push	bc
	ld	e, #0x06
	call	__divuchar
	ld	a, c
	pop	bc
	ld	e, a
	add	a, a
	add	a, e
	add	a, a
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, c
	or	a, a
	ld	a, #0x07
	jr	NZ, 00116$
	ld	a, #0x03
00116$:
	ld	(#_battle_view_state),a
;src/battle_view.c:119: ui_panel(0,18);ui_text(2,1,replace?"WHAT TO DROP?":"ITEMS");
	push	bc
	ld	a, #0x12
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	ld	a, c
	or	a, a
	jr	Z, 00117$
	ld	bc, #___str_40+0
	jr	00118$
00117$:
	ld	bc, #___str_41+0
00118$:
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, #0x02
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:120: for(i=0;i<6u;++i){slot=start+i;if(slot>=party->inventory_count)break;
	ld	c, #0x00
00109$:
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, c
	ld	b, a
;src/battle_view.c:117: if(battle_view_choice>=party->inventory_count)battle_view_choice=party->inventory_count?party->inventory_count-1u:0u;
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
;src/battle_view.c:120: for(i=0;i<6u;++i){slot=start+i;if(slot>=party->inventory_count)break;
	ld	hl, #0x0058
	add	hl, de
	ld	a, b
	sub	a, (hl)
	jr	NC, 00105$
;src/battle_view.c:121: dialogue_item_name(party->inventory[slot],item_name);ui_text(4,4+i*2u,item_name);
	ld	hl, #0x0040
	add	hl, de
	ld	e, b
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	push	bc
	ld	de, #_item_name
	push	de
	push	af
	inc	sp
	ld	e, #b_dialogue_item_name
	ld	hl, #_dialogue_item_name
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	ld	a, c
	add	a, a
	add	a, #0x04
	push	bc
	ld	de, #_item_name
	push	de
	push	af
	inc	sp
	ld	a, #0x04
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
;src/battle_view.c:120: for(i=0;i<6u;++i){slot=start+i;if(slot>=party->inventory_count)break;
	inc	c
	ld	a, c
	sub	a, #0x06
	jr	C, 00109$
00105$:
;src/battle_view.c:123: if(!party->inventory_count)ui_text(4,5,"EMPTY");
	ld	a, (_party)
	ld	hl, #_party + 1
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0058
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00107$
	ld	de, #___str_42
	push	de
	ld	a, #0x05
	push	af
	inc	sp
	ld	a, #0x04
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	jr	00108$
00107$:
;src/battle_view.c:124: else ui_text(2,4+(battle_view_choice-start)*2u,">");
	ld	bc, #___str_43+0
	ld	a, (#_battle_view_choice)
	ldhl	sp,	#0
	sub	a, (hl)
	add	a, a
	add	a, #0x04
	push	bc
	push	af
	inc	sp
	ld	a, #0x02
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
00108$:
;src/battle_view.c:125: ui_text(1,17,"A:CHOOSE B:BACK");
	ld	de, #___str_44
	push	de
	ld	a, #0x11
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
;src/battle_view.c:126: }
	add	sp, #5
	ret
___str_40:
	.ascii "WHAT TO DROP?"
	.db 0x00
___str_41:
	.ascii "ITEMS"
	.db 0x00
___str_42:
	.ascii "EMPTY"
	.db 0x00
___str_43:
	.ascii ">"
	.db 0x00
___str_44:
	.ascii "A:CHOOSE B:BACK"
	.db 0x00
;src/battle_view.c:127: static void target_screen(void) {
;	---------------------------------
; Function target_screen
; ---------------------------------
_target_screen:
	dec	sp
	dec	sp
;src/battle_view.c:129: battle_view_state=BVIEW_TARGET;ui_panel(0,18);ui_text(1,1,"WHICH CHARACTER?");
	ld	hl, #_battle_view_state
	ld	(hl), #0x04
	ld	hl, #0x1200
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	de, #___str_45
	push	de
	ld	hl, #0x101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:130: for(i=0;i<4u;++i)if(party->joined_mask&(1u<<i)){
	ld	c, #0x00
00104$:
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	ld	hl, #0x0059
	add	hl, de
	ld	a, (hl)
	ld	b, c
	ld	hl, #0x0001
	inc	b
	jr	00131$
00130$:
	add	hl, hl
00131$:
	dec	b
	jr	NZ,00130$
	and	a, l
	jp	Z, 00105$
;src/battle_view.c:131: ui_text(3,4+i*3u,names[i]);ui_number(9,4+i*3u,party->party[i].hp);
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	de, #_names
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#0
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl), a
	ld	a, c
	add	a, a
	add	a, c
	add	a, #0x04
	ld	b, a
	push	bc
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	c, #0x03
	push	bc
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	ld	a, (_party)
	ld	l, a
	ld	a, (_party + 1)
	ld	h, a
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	add	hl, de
	inc	hl
	ld	l, (hl)
	ld	h, #0x00
	push	bc
	push	de
	push	hl
	ld	c, #0x09
	push	bc
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	pop	bc
;src/battle_view.c:132: ui_text(12,4+i*3u,"/");ui_number(14,4+i*3u,party->party[i].max_hp);
	push	bc
	push	de
	ld	hl, #___str_46
	push	hl
	ld	c, #0x0c
	push	bc
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	pop	bc
	ld	hl, #_party
	ld	a, (hl+)
	add	a, e
	ld	e, a
	ld	a, (hl)
	adc	a, #0x00
	ld	d, a
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ld	d, #0x00
	push	bc
	push	de
	ld	c, #0x0e
	push	bc
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
00105$:
;src/battle_view.c:130: for(i=0;i<4u;++i)if(party->joined_mask&(1u<<i)){
	inc	c
	ld	a, c
	sub	a, #0x04
	jp	C, 00104$
;src/battle_view.c:134: ui_text(1,4+battle_view_choice*3u,">");ui_text(1,17,"A:CHOOSE B:BACK");
	ld	a, (_battle_view_choice)
	ld	c, a
	add	a, a
	add	a, c
	add	a, #0x04
	ld	de, #___str_47
	push	de
	ld	h, a
	ld	l, #0x01
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_48
	push	de
	ld	hl, #0x1101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
;src/battle_view.c:135: }
	add	sp, #6
	ret
___str_45:
	.ascii "WHICH CHARACTER?"
	.db 0x00
___str_46:
	.ascii "/"
	.db 0x00
___str_47:
	.ascii ">"
	.db 0x00
___str_48:
	.ascii "A:CHOOSE B:BACK"
	.db 0x00
;src/battle_view.c:136: static void prompt(uint8_t kind) {
;	---------------------------------
; Function prompt
; ---------------------------------
_prompt:
	ld	(#_prompt_kind),a
;src/battle_view.c:137: prompt_kind=kind;battle_view_choice=0;battle_view_state=BVIEW_PROMPT;
	xor	a, a
	ld	(#_battle_view_choice),a
	ld	hl, #_battle_view_state
	ld	(hl), #0x06
;src/battle_view.c:138: ui_panel(104,5);ui_text(3,1,"YES");ui_text(12,1,"NO");ui_text(1,1,">");ui_text(1,4,"A:CHOOSE");
	ld	hl, #0x568
	push	hl
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	de, #___str_49
	push	de
	ld	hl, #0x103
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_50
	push	de
	ld	hl, #0x10c
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_51
	push	de
	ld	hl, #0x101
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_52
	push	de
	ld	hl, #0x401
	push	hl
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:139: }
	ret
___str_49:
	.ascii "YES"
	.db 0x00
___str_50:
	.ascii "NO"
	.db 0x00
___str_51:
	.ascii ">"
	.db 0x00
___str_52:
	.ascii "A:CHOOSE"
	.db 0x00
;src/battle_view.c:140: static void start_resolution(void) {
;	---------------------------------
; Function start_resolution
; ---------------------------------
_start_resolution:
;src/battle_view.c:141: uint8_t result=rpg_battle_prepare(party,&battle_view_battle,actions);
	ld	de, #_actions
	push	de
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_prepare
	ld	hl, #_rpg_battle_prepare
	call	___sdcc_bcall_ehl
	add	sp, #6
;src/battle_view.c:142: if(result){
	or	a, a
	jr	Z, 00111$
;src/battle_view.c:143: if(result==RPG_NO_MP)say(0xb6f7,NEXT_CHOOSE,battle_view_actor,0,0);
	cp	a, #0x06
	jr	NZ, 00108$
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x01
	ld	de, #0xb6f7
	call	_say
	ret
00108$:
;src/battle_view.c:144: else if(result==RPG_NOT_LEARNED)say(0xb5c8,NEXT_CHOOSE,battle_view_actor,0,0);
	cp	a, #0x07
	jr	NZ, 00105$
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x01
	ld	de, #0xb5c8
	call	_say
	ret
00105$:
;src/battle_view.c:145: else if(result==RPG_DEAD)say(0xb730,NEXT_CHOOSE,battle_view_actor,0,0);
	sub	a, #0x05
	jr	NZ, 00102$
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x01
	ld	de, #0xb730
	call	_say
	ret
00102$:
;src/battle_view.c:146: else literal("ACTION UNAVAILABLE","CHOOSE AGAIN",NEXT_CHOOSE);
	ld	a, #0x01
	push	af
	inc	sp
	ld	bc, #___str_54
	ld	de, #___str_53
	call	_literal
;src/battle_view.c:147: return;
	ret
00111$:
;src/battle_view.c:149: if(actions[battle_view_actor<4u?battle_view_actor:0u].kind==RPG_ACT_RUN){
	ld	hl, #_battle_view_actor
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00126$
	ld	c, (hl)
	ld	b, #0x00
	jr	00127$
00126$:
	ld	bc, #0x0000
00127$:
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	de, #_actions
	add	hl, de
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00122$
;src/battle_view.c:150: if(battle_view_battle.outcome==RPG_ESCAPED)say(0xb25f,NEXT_DONE,battle_view_actor,0,0);
	ld	a, (#(_battle_view_battle + 130) + 0)
	sub	a, #0x03
	jr	NZ, 00113$
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x11
	ld	de, #0xb25f
	call	_say
	ret
00113$:
;src/battle_view.c:151: else say(0xb15e,NEXT_STEP,battle_view_actor,0,0);
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x02
	ld	de, #0xb15e
	call	_say
	ret
00122$:
;src/battle_view.c:152: } else if(battle_view_battle.last_effect==BATTLE_EFFECT_TALK){
	ld	a, (#(_battle_view_battle + 160) + 0)
	sub	a, #0x10
	jr	NZ, 00119$
;src/battle_view.c:153: say(0xb132,NEXT_TALK_REPLY,battle_view_actor,0,0);
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x12
	ld	de, #0xb132
	call	_say
	ret
00119$:
;src/battle_view.c:154: } else if(battle_view_battle.suppress_party){
	ld	a, (#(_battle_view_battle + 158) + 0)
	or	a, a
	jr	Z, 00116$
;src/battle_view.c:155: say(0xb13d,NEXT_STEP,battle_view_actor,0,0);
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x02
	ld	de, #0xb13d
	call	_say
	ret
00116$:
;src/battle_view.c:156: } else battle_view_state=BVIEW_EXECUTE;
	ld	hl, #_battle_view_state
	ld	(hl), #0x08
;src/battle_view.c:157: }
	ret
___str_53:
	.ascii "ACTION UNAVAILABLE"
	.db 0x00
___str_54:
	.ascii "CHOOSE AGAIN"
	.db 0x00
;src/battle_view.c:158: static void next_character(void) {
;	---------------------------------
; Function next_character
; ---------------------------------
_next_character:
;src/battle_view.c:159: ++battle_view_actor;
	ld	hl, #_battle_view_actor
	inc	(hl)
;src/battle_view.c:160: while(battle_view_actor<4u && !eligible(battle_view_actor))++battle_view_actor;
00102$:
	ld	hl, #_battle_view_actor
	ld	a,(hl)
	cp	a,#0x04
	jr	NC, 00104$
	call	_eligible
	or	a, a
	jr	NZ, 00104$
	ld	hl, #_battle_view_actor
	inc	(hl)
	jr	00102$
00104$:
;src/battle_view.c:161: battle_view_choice=0;
	xor	a, a
	ld	(#_battle_view_choice),a
;src/battle_view.c:162: if(battle_view_actor<4u)command_screen();else start_resolution();
	ld	a, (#_battle_view_actor)
	sub	a, #0x04
	jp	NC, _start_resolution
;src/battle_view.c:163: }
	jp	_command_screen
;src/battle_view.c:164: static void new_round(void) {
;	---------------------------------
; Function new_round
; ---------------------------------
_new_round:
;src/battle_view.c:165: memset(actions,0,sizeof actions);battle_view_actor=0;battle_view_choice=0;
	ld	de, #0x000c
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_actions
	push	de
	call	_memset
	add	sp, #6
	xor	a, a
	ld	(#_battle_view_actor), a
	ld	(#_battle_view_choice),a
;src/battle_view.c:166: while(battle_view_actor<4u && !eligible(battle_view_actor))++battle_view_actor;
00102$:
	ld	hl, #_battle_view_actor
	ld	a,(hl)
	cp	a,#0x04
	jr	NC, 00104$
	call	_eligible
	or	a, a
	jr	NZ, 00104$
	ld	hl, #_battle_view_actor
	inc	(hl)
	jr	00102$
00104$:
;src/battle_view.c:167: if(battle_view_actor<4u)command_screen();else start_resolution();
	ld	a, (#_battle_view_actor)
	sub	a, #0x04
	jp	NC, _start_resolution
;src/battle_view.c:168: }
	jp	_command_screen
;src/battle_view.c:169: static void result_screen(void) {
;	---------------------------------
; Function result_screen
; ---------------------------------
_result_screen:
;src/battle_view.c:170: uint8_t outcome=battle_view_battle.outcome;
	ld	hl, #_battle_view_battle + 130
	ld	c, (hl)
;src/battle_view.c:172: if(battle_view_battle.enemy_id==EnemyID_Tarzimal){rpg_claim_rewards(party,&battle_view_battle);resume(NEXT_DONE);}
	ld	hl, #_battle_view_battle + 128
;src/battle_view.c:171: if(outcome==RPG_VICTORY){
	ld	a, c
	dec	a
	jr	NZ, 00121$
;src/battle_view.c:172: if(battle_view_battle.enemy_id==EnemyID_Tarzimal){rpg_claim_rewards(party,&battle_view_battle);resume(NEXT_DONE);}
	ld	a, (hl)
	sub	a, #0x31
	jr	NZ, 00102$
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_claim_rewards
	ld	hl, #_rpg_claim_rewards
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	a, #0x11
	jp	_resume
00102$:
;src/battle_view.c:173: else say(0xb71b,NEXT_REWARDS,0,0,0);
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x04
	ld	de, #0xb71b
	call	_say
	ret
00121$:
;src/battle_view.c:174: }else if(outcome==RPG_DEFEAT){
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00118$
;src/battle_view.c:175: if(battle_view_battle.enemy_id==EnemyID_Tarzimal || battle_view_battle.enemy_id==EnemyID_Saccubus)resume(NEXT_DONE);
	ld	a, (hl)
	cp	a, #0x31
	jr	Z, 00107$
	sub	a, #0x4a
	jr	NZ, 00108$
00107$:
	ld	a, #0x11
	jp	_resume
00108$:
;src/battle_view.c:176: else if(party->joined_mask!=1u)say(0xbd17,NEXT_DEFEAT,0,0,0);
	ld	a, (_party)
	ld	c, a
	ld	hl, #_party + 1
	ld	b, (hl)
	ld	hl, #0x0059
	add	hl, bc
	ld	a, (hl)
	dec	a
	jr	Z, 00105$
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x13
	ld	de, #0xbd17
	call	_say
	ret
00105$:
;src/battle_view.c:177: else say(0xbd23,NEXT_DONE,0,0,0);
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x11
	ld	de, #0xbd23
	call	_say
	ret
00118$:
;src/battle_view.c:178: }else if(outcome==RPG_TALKED)say(0xb132,NEXT_TALK_REPLY,character_for_message(),0,0);
	ld	a, c
	sub	a, #0x04
	jr	NZ, 00115$
	call	_character_for_message
	ld	de, #0x0000
	push	de
	ld	h, #0x00
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	a, #0x12
	ld	de, #0xb132
	call	_say
	ret
00115$:
;src/battle_view.c:179: else if(outcome==RPG_ESCAPED)say(0xb25f,NEXT_DONE,0,0,0);
	ld	a, c
	sub	a, #0x03
	jp	NZ, _new_round
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x11
	ld	de, #0xb25f
	call	_say
;src/battle_view.c:180: else new_round();
;src/battle_view.c:181: }
	ret
;src/battle_view.c:182: static void action_feedback(void) {
;	---------------------------------
; Function action_feedback
; ---------------------------------
_action_feedback:
	add	sp, #-4
;src/battle_view.c:183: RPGBattle *b=&battle_view_battle;
;src/battle_view.c:184: uint8_t c=character_for_message(),enemy=b->last_actor>=4u;
	call	_character_for_message
	ldhl	sp,	#1
	ld	(hl), a
	ld	a, (#_battle_view_battle + 144)
	sub	a, #0x04
	ld	a, #0x00
	rla
	xor	a, #0x01
	ldhl	sp,	#2
	ld	(hl), a
;src/battle_view.c:185: switch(b->last_effect){
	ld	a, (#(_battle_view_battle + 160) + 0)
	ldhl	sp,	#3
	ld	(hl), a
	ld	a, #0x11
	ldhl	sp,	#3
	sub	a, (hl)
	jp	C, 00114$
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #00261$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00261$:
	.dw	00114$
	.dw	00114$
	.dw	00101$
	.dw	00102$
	.dw	00103$
	.dw	00104$
	.dw	00105$
	.dw	00106$
	.dw	00114$
	.dw	00114$
	.dw	00110$
	.dw	00114$
	.dw	00107$
	.dw	00108$
	.dw	00109$
	.dw	00112$
	.dw	00113$
	.dw	00111$
;src/battle_view.c:186: case BATTLE_EFFECT_MISS:say(enemy?0xb118:0xb108,NEXT_STEP,c,0,0);break;
00101$:
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00123$
	ld	a, #0x18
	ld	(hl+), a
	ld	(hl), #0xb1
	jr	00124$
00123$:
	ldhl	sp,	#2
	ld	a, #0x08
	ld	(hl+), a
	ld	(hl), #0xb1
00124$:
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	bc, #0x0000
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	call	_say
	jp	00121$
;src/battle_view.c:187: case BATTLE_EFFECT_BLOCKED:say((b->barrier&0x80u)?0xb1b2:0xb1a3,NEXT_STEP,c,0,0);break;
00102$:
	ld	a, (#(_battle_view_battle + 131) + 0)
	rlca
	jr	NC, 00125$
	ldhl	sp,	#2
	ld	a, #0xb2
	ld	(hl+), a
	ld	(hl), #0xb1
	jr	00126$
00125$:
	ldhl	sp,	#2
	ld	a, #0xa3
	ld	(hl+), a
	ld	(hl), #0xb1
00126$:
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	bc, #0x0000
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	call	_say
	jp	00121$
;src/battle_view.c:188: case BATTLE_EFFECT_BOUND:say(enemy?0xb203:0xb1fc,NEXT_STEP,c,0,0);break;
00103$:
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00127$
	ld	de, #0xb203
	jr	00128$
00127$:
	ld	de, #0xb1fc
00128$:
	ld	bc, #0x0000
	push	bc
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	call	_say
	jp	00121$
;src/battle_view.c:189: case BATTLE_EFFECT_RECOVERED:say(enemy?0xb21d:0xb20a,NEXT_STEP,c,0,0);break;
00104$:
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00129$
	ld	de, #0xb21d
	jr	00130$
00129$:
	ld	de, #0xb20a
00130$:
	ld	bc, #0x0000
	push	bc
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	call	_say
	jp	00121$
;src/battle_view.c:190: case BATTLE_EFFECT_HEAL:say(enemy?0xb1d8:0xb1d0,NEXT_STEP,b->last_target<4u?b->last_target:c,0,0);break;
00105$:
	ld	a, (#(_battle_view_battle + 145) + 0)
	cp	a, #0x04
	jr	NC, 00131$
	ld	c, a
	jr	00132$
00131$:
	ldhl	sp,	#1
	ld	c, (hl)
00132$:
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00133$
	ld	de, #0xb1d8
	jr	00134$
00133$:
	ld	de, #0xb1d0
00134$:
	ld	hl, #0x0000
	push	hl
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x02
	call	_say
	jp	00121$
;src/battle_view.c:191: case BATTLE_EFFECT_BOOST:say(enemy?0xbcc2:0xb22f,NEXT_STEP,b->last_target<4u?b->last_target:c,0,0);break;
00106$:
	ld	a, (#(_battle_view_battle + 145) + 0)
	cp	a, #0x04
	jr	NC, 00135$
	ld	c, a
	jr	00136$
00135$:
	ldhl	sp,	#1
	ld	c, (hl)
00136$:
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00137$
	ld	de, #0xbcc2
	jr	00138$
00137$:
	ld	de, #0xb22f
00138$:
	ld	hl, #0x0000
	push	hl
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x02
	call	_say
	jp	00121$
;src/battle_view.c:192: case BATTLE_EFFECT_ROPE:say(enemy?0xb1ee:0xb1e0,NEXT_STEP,c,0,0);break;
00107$:
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00139$
	ld	de, #0xb1ee
	jr	00140$
00139$:
	ld	de, #0xb1e0
00140$:
	ld	bc, #0x0000
	push	bc
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	call	_say
	jp	00121$
;src/battle_view.c:193: case BATTLE_EFFECT_WEAKEN:say(0xb24c,NEXT_STEP,c,0,0);break;
00108$:
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	ld	de, #0xb24c
	call	_say
	jp	00121$
;src/battle_view.c:194: case BATTLE_EFFECT_BARRIER:say(0xb18b,NEXT_STEP,c,0,0);break;
00109$:
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	ld	de, #0xb18b
	call	_say
	jp	00121$
;src/battle_view.c:195: case BATTLE_EFFECT_PETRIFY:say(0xbe93,NEXT_STEP,c,0,0);break;
00110$:
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	ld	de, #0xbe93
	call	_say
	jp	00121$
;src/battle_view.c:196: case BATTLE_EFFECT_NO_EFFECT:say(0xb2cd,NEXT_STEP,c,0,0);break;
00111$:
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x02
	ld	de, #0xb2cd
	call	_say
	jp	00121$
;src/battle_view.c:197: case BATTLE_EFFECT_ESCAPE:say(0xb25f,NEXT_DONE,c,0,0);break;
00112$:
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x11
	ld	de, #0xb25f
	call	_say
	jp	00121$
;src/battle_view.c:198: case BATTLE_EFFECT_TALK:say(0xb132,NEXT_TALK_REPLY,c,0,0);break;
00113$:
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x12
	ld	de, #0xb132
	call	_say
	jp	00121$
;src/battle_view.c:199: default:
00114$:
;src/battle_view.c:200: ui_panel(96,6);ui_text(1,0,enemy?enemy_name:names[c]);
	ld	a, #0x06
	push	af
	inc	sp
	ld	a, #0x60
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00141$
	ld	bc, #_enemy_name+0
	jr	00142$
00141$:
	ld	bc, #_names+0
	ldhl	sp,	#1
	ld	e, (hl)
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
00142$:
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:201: ui_text(1,1,b->last_effect==BATTLE_EFFECT_FIRE?"FIRE":b->last_effect==BATTLE_EFFECT_THUNDER?"THUNDER":b->last_effect==BATTLE_EFFECT_WIND?"WIND":"ATTACK");
	ld	a, (#(_battle_view_battle + 160) + 0)
	cp	a, #0x08
	jr	NZ, 00143$
	ld	de, #___str_55+0
	jr	00144$
00143$:
	cp	a, #0x09
	jr	NZ, 00145$
	ld	de, #___str_56+0
	jr	00146$
00145$:
	sub	a, #0x0b
	jr	NZ, 00147$
	ld	de, #___str_57+0
	jr	00148$
00147$:
	ld	de, #___str_58+0
00148$:
00146$:
00144$:
	push	de
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:202: ui_text(1,3,"DAMAGE");ui_number(10,3,b->last_damage);
	ld	de, #___str_59
	push	de
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	hl, #_battle_view_battle + 146
	ld	c, (hl)
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:203: if(b->last_target<4u){ui_text(1,4,names[b->last_target]);ui_text(7,4,"HP");ui_number(11,4,party->party[b->last_target].hp);}
	ld	a, (#(_battle_view_battle + 145) + 0)
	ldhl	sp,#3
	ld	(hl), a
	sub	a, #0x04
	jp	NC, 00118$
	ld	a, (hl-)
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
	pop	de
	push	de
	ld	hl, #_names
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
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, #0x04
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_60
	push	de
	ld	a, #0x04
	push	af
	inc	sp
	ld	a, #0x07
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	a, (#_party)
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (#_party + 1)
	ldhl	sp,	#1
	ld	(hl), a
	ld	a, (#(_battle_view_battle + 145) + 0)
	ldhl	sp,#3
	ld	(hl), a
	swap	a
	and	a, #0xf0
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	pop	hl
	push	hl
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
	ld	l, e
	ld	h, d
	inc	hl
	inc	sp
	inc	sp
	ld	e, l
	ld	d, h
	push	de
	ld	a, (de)
	ldhl	sp,	#3
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	ld	a, #0x00
	ld	(hl-), a
	ld	e, (hl)
	ld	d, #0x00
	push	de
	ld	a, #0x04
	push	af
	inc	sp
	ld	a, #0x0b
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	jr	00119$
00118$:
;src/battle_view.c:204: else if(b->last_target<12u){ui_text(1,4,"ENEMY HP");ui_number(11,4,b->enemies[b->last_target-4u].hp);}
	ldhl	sp,	#3
	ld	a, (hl)
	sub	a, #0x0c
	jr	NC, 00119$
	ld	de, #___str_61
	push	de
	ld	a, #0x04
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	a, (#(_battle_view_battle + 145) + 0)
	ld	c, #0x00
	add	a, #0xfc
	ld	l, a
	ld	a, c
	adc	a, #0xff
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_battle_view_battle
	add	hl, de
	inc	hl
	ld	c, (hl)
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x04
	push	af
	inc	sp
	ld	a, #0x0b
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
00119$:
;src/battle_view.c:205: after_message=NEXT_STEP;is_literal=1;battle_view_dialogue_id=0;battle_view_state=BVIEW_MESSAGE;ui_text(17,5,">");break;
	ld	hl, #_after_message
	ld	(hl), #0x02
	ld	hl, #_is_literal
	ld	(hl), #0x01
	xor	a, a
	ld	hl, #_battle_view_dialogue_id
	ld	(hl+), a
	ld	(hl), a
	ld	hl, #_battle_view_state
	ld	(hl), #0x05
	ld	de, #___str_62
	push	de
	ld	a, #0x05
	push	af
	inc	sp
	ld	a, #0x11
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:206: }
00121$:
;src/battle_view.c:207: }
	add	sp, #4
	ret
___str_55:
	.ascii "FIRE"
	.db 0x00
___str_56:
	.ascii "THUNDER"
	.db 0x00
___str_57:
	.ascii "WIND"
	.db 0x00
___str_58:
	.ascii "ATTACK"
	.db 0x00
___str_59:
	.ascii "DAMAGE"
	.db 0x00
___str_60:
	.ascii "HP"
	.db 0x00
___str_61:
	.ascii "ENEMY HP"
	.db 0x00
___str_62:
	.ascii ">"
	.db 0x00
;src/battle_view.c:208: static void execute_step(void) {
;	---------------------------------
; Function execute_step
; ---------------------------------
_execute_step:
;src/battle_view.c:210: while(safety--){
	ld	e, #0x0c
00109$:
	ld	c, e
	dec	e
	ld	a, c
	or	a, a
	ret	Z
;src/battle_view.c:211: if(battle_view_battle.outcome!=RPG_ONGOING){result_screen();return;}
	ld	a, (#_battle_view_battle + 130)
	or	a, a
	jp	NZ, _result_screen
;src/battle_view.c:212: if(battle_view_battle.turn_cursor>=12u){new_round();return;}
	ld	a, (#_battle_view_battle + 159)
	sub	a, #0x0c
	jp	NC, _new_round
;src/battle_view.c:213: rpg_battle_step(party,&battle_view_battle);
	push	de
	ld	bc, #_battle_view_battle
	push	bc
	ld	a, (_party)
	ld	c, a
	ld	hl, #_party + 1
	ld	b, (hl)
	push	bc
	ld	e, #b_rpg_battle_step
	ld	hl, #_rpg_battle_step
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
;src/battle_view.c:214: if(battle_view_battle.last_error!=RPG_OK){
	ld	hl, #_battle_view_battle + 147
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
;src/battle_view.c:215: say(battle_view_battle.last_error==RPG_DEAD?0xb730:battle_view_battle.last_error==RPG_NO_MP?0xb6f7:0xbea1,NEXT_STEP,character_for_message(),0,0);return;
	push	hl
	call	_character_for_message
	ld	c, a
	pop	hl
	ld	a, (hl)
	cp	a, #0x05
	jr	NZ, 00114$
	ld	de, #0xb730
	jr	00115$
00114$:
	sub	a, #0x06
	jr	NZ, 00116$
	ld	de, #0xb6f7
	jr	00117$
00116$:
	ld	de, #0xbea1
00117$:
00115$:
	ld	hl, #0x0000
	push	hl
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x02
	call	_say
	ret
00106$:
;src/battle_view.c:217: if(battle_view_battle.last_effect){action_feedback();return;}
	ld	a, (#_battle_view_battle + 160)
	or	a, a
	jr	Z, 00109$
;src/battle_view.c:219: }
	jp	_action_feedback
;src/battle_view.c:220: static void resume(uint8_t next) {
;	---------------------------------
; Function resume
; ---------------------------------
_resume:
	dec	sp
	dec	sp
	ldhl	sp,	#0
	ld	(hl), a
;src/battle_view.c:222: RPGBattle *b=&battle_view_battle;
;src/battle_view.c:223: switch(next){
	ld	a, #0x16
	sub	a, (hl)
	jp	C, 00163$
	ld	c, (hl)
	ld	b, #0x00
	ld	hl, #00294$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00294$:
	.dw	00163$
	.dw	00101$
	.dw	00108$
	.dw	00109$
	.dw	00172$
	.dw	00117$
	.dw	00123$
	.dw	00128$
	.dw	00132$
	.dw	00133$
	.dw	00134$
	.dw	00138$
	.dw	00142$
	.dw	00146$
	.dw	00147$
	.dw	00148$
	.dw	00149$
	.dw	00158$
	.dw	00153$
	.dw	00154$
	.dw	00155$
	.dw	00156$
	.dw	00157$
;src/battle_view.c:224: case NEXT_CHOOSE:
00101$:
;src/battle_view.c:225: if(battle_view_actor>=4u)battle_view_actor=0;
	ld	hl, #_battle_view_actor
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00105$
	ld	(hl), #0x00
;src/battle_view.c:226: while(battle_view_actor<3u && !eligible(battle_view_actor))++battle_view_actor;
00105$:
	ld	a, (#_battle_view_actor)
	cp	a,#0x03
	jr	NC, 00107$
	call	_eligible
	or	a, a
	jr	NZ, 00107$
	ld	hl, #_battle_view_actor
	inc	(hl)
	jr	00105$
00107$:
;src/battle_view.c:227: battle_view_choice=0;command_screen();break;
	xor	a, a
	ld	(#_battle_view_choice),a
	inc	sp
	inc	sp
	jp	_command_screen
	jp	00163$
;src/battle_view.c:228: case NEXT_STEP:battle_view_state=BVIEW_EXECUTE;execute_step();break;
00108$:
	ld	hl, #_battle_view_state
	ld	(hl), #0x08
	inc	sp
	inc	sp
	jp	_execute_step
	jp	00163$
;src/battle_view.c:229: case NEXT_RESULT:result_screen();break;
00109$:
	inc	sp
	inc	sp
	jp	_result_screen
	jp	00163$
;src/battle_view.c:231: for(i=0;i<4u;++i){old_battle_magic[i]=party->party[i].battle_magic_count;old_map_magic[i]=party->party[i].map_magic_count;}
00172$:
	ldhl	sp,	#1
	ld	(hl), #0x00
00161$:
	ld	de, #_old_battle_magic
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (_party)
	ld	hl, #_party + 1
	ld	b, (hl)
	push	af
	ldhl	sp,	#3
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	c, a
	pop	af
	ld	l, a
	ld	h, b
	ld	b, #0x00
	add	hl, bc
	push	de
	ld	de, #0x000e
	add	hl, de
	pop	de
	ld	a, (hl)
	ld	(de), a
	ld	de, #_old_map_magic
	ldhl	sp,	#1
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #_party
	ld	a, (hl+)
	add	a, c
	ld	c, a
	ld	a, (hl)
	adc	a, #0x00
	ld	b, a
	ld	hl, #0x000f
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#1
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00161$
;src/battle_view.c:232: rpg_claim_rewards(party,b);level_cursor=0;
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_claim_rewards
	ld	hl, #_rpg_claim_rewards
	call	___sdcc_bcall_ehl
	add	sp, #4
	xor	a, a
	ld	(#_level_cursor),a
;src/battle_view.c:233: if(b->exp_reward)say(0xb604,NEXT_LEVEL,0,0,b->exp_reward);else resume(NEXT_CHEST);
	ld	hl, #(_battle_view_battle + 148)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, b
	or	a, c
	jr	Z, 00113$
	push	bc
	xor	a, a
	rrca
	push	af
	ld	a, #0x05
	ld	de, #0xb604
	call	_say
	jp	00163$
00113$:
	ld	a, #0x07
	inc	sp
	inc	sp
	jp	_resume
;src/battle_view.c:234: break;
	jp	00163$
;src/battle_view.c:236: while(level_cursor<4u && !(b->leveled_mask&(1u<<level_cursor)))++level_cursor;
00117$:
	ld	hl, #_level_cursor
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00119$
	ld	a, (#(_battle_view_battle + 166) + 0)
	ld	b, (hl)
	ld	de, #0x0001
	inc	b
	jr	00296$
00295$:
	sla	e
	rl	d
00296$:
	dec	b
	jr	NZ,00295$
	and	a, e
	ld	c, #0x00
	or	a, c
	jr	NZ, 00119$
	inc	(hl)
	jr	00117$
00119$:
;src/battle_view.c:237: if(level_cursor<4u)say(0xb621,NEXT_LEARNED,level_cursor,0,0);else resume(NEXT_CHEST);
	ld	hl, #_level_cursor
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00121$
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x06
	ld	de, #0xb621
	call	_say
	jp	00163$
00121$:
	ld	a, #0x07
	inc	sp
	inc	sp
	jp	_resume
;src/battle_view.c:238: break;
	jp	00163$
;src/battle_view.c:239: case NEXT_LEARNED:
00123$:
;src/battle_view.c:240: i=level_cursor++;
	ld	a, (_level_cursor)
	ld	c, a
	ld	hl, #_level_cursor
	inc	(hl)
;src/battle_view.c:241: if(old_battle_magic[i]!=party->party[i].battle_magic_count || old_map_magic[i]!=party->party[i].map_magic_count)say(0xb635,NEXT_LEVEL,i,0,0);
	ld	hl, #_old_battle_magic
	ld	b, #0x00
	add	hl, bc
	ld	b, (hl)
	ld	a, (_party)
	ld	l, a
	ld	a, (_party + 1)
	ld	h, a
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	add	hl, de
	push	de
	ld	de, #0x000e
	add	hl, de
	pop	de
	ld	a, (hl)
	sub	a, b
	jr	NZ, 00124$
	ld	hl, #_old_map_magic
	ld	b, #0x00
	add	hl, bc
	ld	b, (hl)
	ld	hl, #_party
	ld	a, (hl+)
	add	a, e
	ld	e, a
	ld	a, (hl)
	adc	a, #0x00
	ld	d, a
	ld	hl, #0x000f
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	sub	a, b
	jr	Z, 00125$
00124$:
	ld	de, #0x0000
	push	de
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x05
	ld	de, #0xb635
	call	_say
	jp	00163$
00125$:
;src/battle_view.c:242: else resume(NEXT_LEVEL);break;
	ld	a, #0x05
	inc	sp
	inc	sp
	jp	_resume
	jp	00163$
;src/battle_view.c:243: case NEXT_CHEST:if(b->chest_state==BATTLE_CHEST_PENDING)say(0xbce1,NEXT_ASK_CHEST,0,0,0);else resume(NEXT_DONE);break;
00128$:
	ld	a, (#(_battle_view_battle + 162) + 0)
	dec	a
	jr	NZ, 00130$
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x08
	ld	de, #0xbce1
	call	_say
	jp	00163$
00130$:
	ld	a, #0x11
	inc	sp
	inc	sp
	jp	_resume
	jp	00163$
;src/battle_view.c:244: case NEXT_ASK_CHEST:say(0xb656,NEXT_PROMPT_CHEST,0,0,0);break;
00132$:
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x09
	ld	de, #0xb656
	call	_say
	jp	00163$
;src/battle_view.c:245: case NEXT_PROMPT_CHEST:prompt(PROMPT_CHEST);break;
00133$:
	ld	a, #0x01
	inc	sp
	inc	sp
	jp	_prompt
	jp	00163$
;src/battle_view.c:246: case NEXT_MONEY:
00134$:
;src/battle_view.c:247: if(b->money_reward)say(0xb648,NEXT_FOUND,0,0,b->money_reward);else resume(NEXT_FOUND);break;
	ld	hl, #(_battle_view_battle + 150)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, b
	or	a, c
	jr	Z, 00136$
	push	bc
	xor	a, a
	rrca
	push	af
	ld	a, #0x0b
	ld	de, #0xb648
	call	_say
	jp	00163$
00136$:
	ld	a, #0x0b
	inc	sp
	inc	sp
	jp	_resume
	jp	00163$
;src/battle_view.c:248: case NEXT_FOUND:if(b->item_reward)say(0xb592,NEXT_GIFT,0,b->item_reward,0);else resume(NEXT_DONE);break;
00138$:
	ld	a, (#(_battle_view_battle + 152) + 0)
	or	a, a
	jr	Z, 00140$
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x0c
	ld	de, #0xb592
	call	_say
	jp	00163$
00140$:
	ld	a, #0x11
	inc	sp
	inc	sp
	jp	_resume
	jp	00163$
;src/battle_view.c:249: case NEXT_GIFT:if(b->item_pending)say(0xb671,NEXT_PROMPT_FULL,0,b->item_pending,0);else resume(NEXT_DONE);break;
00142$:
	ld	a, (#(_battle_view_battle + 164) + 0)
	or	a, a
	jr	Z, 00144$
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x0d
	ld	de, #0xb671
	call	_say
	jp	00163$
00144$:
	ld	a, #0x11
	inc	sp
	inc	sp
	jp	_resume
	jp	00163$
;src/battle_view.c:250: case NEXT_PROMPT_FULL:prompt(PROMPT_FULL);break;
00146$:
	ld	a, #0x02
	inc	sp
	inc	sp
	jp	_prompt
	jp	00163$
;src/battle_view.c:251: case NEXT_PROMPT_ABANDON:prompt(PROMPT_ABANDON);break;
00147$:
	ld	a, #0x03
	inc	sp
	inc	sp
	jp	_prompt
	jp	00163$
;src/battle_view.c:252: case NEXT_REPLACE:battle_view_choice=0;item_screen(1);break;
00148$:
	xor	a, a
	ld	(#_battle_view_choice),a
	ld	a, #0x01
	inc	sp
	inc	sp
	jp	_item_screen
	jp	00163$
;src/battle_view.c:253: case NEXT_APPLY_REPLACE:
00149$:
;src/battle_view.c:254: result=rpg_battle_replace_reward(party,b,replacement_slot);
	ld	a, (_replacement_slot)
	push	af
	inc	sp
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_replace_reward
	ld	hl, #_rpg_battle_replace_reward
	call	___sdcc_bcall_ehl
	add	sp, #5
;src/battle_view.c:255: if(result==RPG_OK)say(0xb6ad,NEXT_DONE,0,b->item_reward,0);else resume(NEXT_REPLACE);
	or	a, a
	jr	NZ, 00151$
	ld	a, (#(_battle_view_battle + 152) + 0)
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x11
	ld	de, #0xb6ad
	call	_say
	jr	00163$
00151$:
	ld	a, #0x0f
	inc	sp
	inc	sp
	jp	_resume
;src/battle_view.c:256: break;
	jr	00163$
;src/battle_view.c:257: case NEXT_TALK_REPLY:say(talk_texts[b->talk_index<19u?b->talk_index:0u],NEXT_DONE,character_for_message(),0,0);break;
00153$:
	call	_character_for_message
	ld	c, a
	ld	a, (#(_battle_view_battle + 161) + 0)
	cp	a, #0x13
	jr	NC, 00165$
	ld	h, #0x00
	jr	00166$
00165$:
	xor	a, a
	ld	h, a
00166$:
	ld	l, a
	add	hl, hl
	ld	de, #_talk_texts
	add	hl, de
	ld	a, (hl+)
	ld	b, a
	ld	l, (hl)
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	ld	a, #0x11
	ld	e, b
	ld	d, l
	call	_say
	jr	00163$
;src/battle_view.c:258: case NEXT_DEFEAT:say(0xbd23,NEXT_DONE,0,0,0);break;
00154$:
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x11
	ld	de, #0xbd23
	call	_say
	jr	00163$
;src/battle_view.c:259: case NEXT_SPELLS:spell_screen();break;
00155$:
	inc	sp
	inc	sp
	jp	_spell_screen
	jr	00163$
;src/battle_view.c:260: case NEXT_ITEMS:item_screen(0);break;
00156$:
	xor	a, a
	inc	sp
	inc	sp
	jp	_item_screen
	jr	00163$
;src/battle_view.c:261: case NEXT_TARGET:target_screen();break;
00157$:
	inc	sp
	inc	sp
	jp	_target_screen
	jr	00163$
;src/battle_view.c:262: case NEXT_DONE:battle_view_state=BVIEW_DONE;battle_view_result=b->outcome;break;
00158$:
	ld	hl, #_battle_view_state
	ld	(hl), #0x09
	ld	a, (#(_battle_view_battle + 130) + 0)
	ld	(#_battle_view_result),a
;src/battle_view.c:264: }
00163$:
;src/battle_view.c:265: }
	inc	sp
	inc	sp
	ret
;src/battle_view.c:266: uint8_t battle_view_begin(RPGState *state,uint8_t enemy) RPG_BANKED {
;	---------------------------------
; Function battle_view_begin
; ---------------------------------
	b_battle_view_begin	= 30
_battle_view_begin::
;src/battle_view.c:268: party=state;battle_view_result=0;battle_view_dialogue_id=0;
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(#_party),a
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(#_party + 1),a
	xor	a, a
	ld	(#_battle_view_result), a
	ld	hl, #_battle_view_dialogue_id
	ld	(hl+), a
	ld	(hl), a
;src/battle_view.c:269: error=rpg_battle_begin(party,&battle_view_battle,enemy);if(error)return error;
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_begin
	ld	hl, #_rpg_battle_begin
	call	___sdcc_bcall_ehl
	add	sp, #5
	ld	c,a
	or	a,a
	ret	NZ
;src/battle_view.c:270: rpg_enemy_name(enemy&127u,enemy_name);
	ld	de, #_enemy_name+0
	ldhl	sp,	#8
	ld	b, (hl)
	res	7, b
	push	bc
	push	de
	push	bc
	inc	sp
	ld	e, #b_rpg_enemy_name
	ld	hl, #_rpg_enemy_name
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
;src/battle_view.c:272: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;enemy_art_draw(enemy&127u);DISPLAY_ON;
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	push	bc
	inc	sp
	ld	e, #b_enemy_art_draw
	ld	hl, #_enemy_art_draw
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/battle_view.c:274: new_round();return RPG_OK;
	call	_new_round
	xor	a, a
;src/battle_view.c:275: }
	ret
;src/battle_view.c:276: uint8_t battle_view_tick(uint8_t keys,uint8_t pressed) RPG_BANKED {
;	---------------------------------
; Function battle_view_tick
; ---------------------------------
	b_battle_view_tick	= 30
_battle_view_tick::
	add	sp, #-8
;src/battle_view.c:278: if(battle_view_state==BVIEW_DONE)return battle_view_result;
	ld	a, (#_battle_view_state)
	sub	a, #0x09
	jr	NZ, 00102$
	ld	a, (_battle_view_result)
	jp	00247$
00102$:
;src/battle_view.c:279: if(battle_view_state==BVIEW_EXECUTE){execute_step();return battle_view_result;}
	ld	a, (#_battle_view_state)
	sub	a, #0x08
	jr	NZ, 00104$
	call	_execute_step
	ld	a, (_battle_view_result)
	jp	00247$
00104$:
;src/battle_view.c:280: if(battle_view_state==BVIEW_MESSAGE){
	ld	a, (#_battle_view_state)
	sub	a, #0x05
	jr	NZ, 00112$
;src/battle_view.c:281: if(pressed&(J_A|J_B)){if(!is_literal&&!message.done)message_page();else resume(after_message);}
	ldhl	sp,	#15
	ld	a, (hl)
	and	a, #0x30
	jr	Z, 00110$
	ld	a, (#_is_literal)
	or	a, a
	jr	NZ, 00106$
	ld	a, (#(_message + 12) + 0)
	or	a, a
	jr	NZ, 00106$
	call	_message_page
	jr	00110$
00106$:
	ld	a, (_after_message)
	call	_resume
00110$:
;src/battle_view.c:282: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00247$
00112$:
;src/battle_view.c:285: if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN)){
	ldhl	sp,	#15
	ld	c, (hl)
;src/battle_view.c:288: if(!(pressed&J_A))return battle_view_result;
	ld	a, c
	and	a, #0x10
	ldhl	sp,	#2
	ld	(hl), a
;src/battle_view.c:284: if(battle_view_state==BVIEW_PROMPT){
	ld	a, (#_battle_view_state)
	sub	a, #0x06
	jp	NZ, 00140$
;src/battle_view.c:285: if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN)){
	ld	a, c
	and	a, #0x0f
	jr	Z, 00114$
;src/battle_view.c:286: battle_view_choice^=1u;ui_text(1,1,battle_view_choice?" ":">");ui_text(10,1,battle_view_choice?">":" ");
	ld	hl, #_battle_view_choice
	ld	a, (hl)
	xor	a, #0x01
	ld	(hl), a
	or	a, a
	jr	Z, 00249$
	ld	bc, #___str_63+0
	jr	00250$
00249$:
	ld	bc, #___str_64+0
00250$:
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	a, (#_battle_view_choice)
	or	a, a
	jr	Z, 00251$
	ld	bc, #___str_64+0
	jr	00252$
00251$:
	ld	bc, #___str_63+0
00252$:
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
00114$:
;src/battle_view.c:288: if(!(pressed&J_A))return battle_view_result;
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	NZ, 00116$
	ld	a, (_battle_view_result)
	jp	00247$
00116$:
;src/battle_view.c:289: yes=!battle_view_choice;
	ld	a, (#_battle_view_choice)
	sub	a, #0x01
	ld	a, #0x00
	rla
	ld	c, a
;src/battle_view.c:290: if(prompt_kind==PROMPT_CHEST){
	ld	a, (#_prompt_kind)
	dec	a
	jr	NZ, 00137$
;src/battle_view.c:291: if(!yes){rpg_battle_decline_chest(&battle_view_battle);resume(NEXT_DONE);}
	ld	a, c
	or	a, a
	jr	NZ, 00125$
	ld	de, #_battle_view_battle
	push	de
	ld	e, #b_rpg_battle_decline_chest
	ld	hl, #_rpg_battle_decline_chest
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, #0x11
	call	_resume
	jp	00138$
00125$:
;src/battle_view.c:293: err=rpg_battle_open_chest(party,&battle_view_battle);
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_open_chest
	ld	hl, #_rpg_battle_open_chest
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:294: if(err!=RPG_OK&&err!=RPG_FULL)literal("CHEST UNAVAILABLE","",NEXT_DONE);
	or	a,a
	jr	Z, 00121$
	sub	a, #0x02
	jr	Z, 00121$
	ld	a, #0x11
	push	af
	inc	sp
	ld	bc, #___str_66
	ld	de, #___str_65
	call	_literal
	jp	00138$
00121$:
;src/battle_view.c:295: else if(battle_view_battle.trap_kind)literal("CHEST TRAP","HP REDUCED",NEXT_MONEY);
	ld	a, (#(_battle_view_battle + 163) + 0)
	or	a, a
	jr	Z, 00118$
	ld	a, #0x0a
	push	af
	inc	sp
	ld	bc, #___str_68
	ld	de, #___str_67
	call	_literal
	jr	00138$
00118$:
;src/battle_view.c:296: else resume(NEXT_MONEY);
	ld	a, #0x0a
	call	_resume
	jr	00138$
00137$:
;src/battle_view.c:298: }else if(prompt_kind==PROMPT_FULL){
	ld	a, (#_prompt_kind)
;src/battle_view.c:299: if(yes)say(0xb68c,NEXT_REPLACE,0,0,0);else say(0xb6c1,NEXT_PROMPT_ABANDON,0,battle_view_battle.item_pending,0);
	sub	a, #0x02
	jr	NZ, 00134$
	or	a, c
	jr	Z, 00128$
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x0f
	ld	de, #0xb68c
	call	_say
	jr	00138$
00128$:
	ld	a, (#(_battle_view_battle + 164) + 0)
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x0e
	ld	de, #0xb6c1
	call	_say
	jr	00138$
00134$:
;src/battle_view.c:301: if(yes){id=battle_view_battle.item_pending;rpg_battle_decline_chest(&battle_view_battle);say(0xb6d0,NEXT_DONE,0,id,0);}
	ld	a, c
	or	a, a
	jr	Z, 00131$
	ld	hl, #_battle_view_battle + 164
	ld	b, (hl)
	push	bc
	ld	de, #_battle_view_battle
	push	de
	ld	e, #b_rpg_battle_decline_chest
	ld	hl, #_rpg_battle_decline_chest
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	ld	de, #0x0000
	push	de
	push	bc
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x11
	ld	de, #0xb6d0
	call	_say
	jr	00138$
00131$:
;src/battle_view.c:302: else say(0xb68c,NEXT_REPLACE,0,0,0);
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x0f
	ld	de, #0xb68c
	call	_say
00138$:
;src/battle_view.c:304: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00247$
00140$:
;src/battle_view.c:312: if(pressed&(J_UP|J_LEFT)){battle_view_choice=battle_view_choice?battle_view_choice-1u:4u;command_screen();}
	ld	a, (#_battle_view_choice)
	dec	a
	ldhl	sp,	#3
	ld	(hl), a
;src/battle_view.c:307: if(pressed&J_B){
	ld	a, c
	and	a, #0x20
	ldhl	sp,	#7
	ld	(hl), a
;src/battle_view.c:312: if(pressed&(J_UP|J_LEFT)){battle_view_choice=battle_view_choice?battle_view_choice-1u:4u;command_screen();}
	ld	a, c
	and	a, #0x06
	ldhl	sp,	#4
;src/battle_view.c:313: if(pressed&(J_DOWN|J_RIGHT)){battle_view_choice=(battle_view_choice+1u)%5u;command_screen();}
	ld	(hl+), a
	ld	a, c
	and	a, #0x09
	ld	(hl), a
;src/battle_view.c:306: if(battle_view_state==BVIEW_COMMAND){
	ld	a, (#_battle_view_state)
	dec	a
	jp	NZ, 00169$
;src/battle_view.c:307: if(pressed&J_B){
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00149$
;src/battle_view.c:308: next=battle_view_actor;while(next){--next;if(eligible(next))break;}
	ld	a, (_battle_view_actor)
	ld	c, a
00143$:
	ld	a, c
	or	a, a
	jr	Z, 00145$
	dec	c
	push	bc
	ld	a, c
	call	_eligible
	pop	bc
	or	a, a
	jr	Z, 00143$
00145$:
;src/battle_view.c:309: if(eligible(next))battle_view_actor=next;
	push	bc
	ld	a, c
	call	_eligible
	ld	e, a
	pop	bc
	ld	a, e
	or	a, a
	jr	Z, 00147$
	ld	hl, #_battle_view_actor
	ld	(hl), c
00147$:
;src/battle_view.c:310: battle_view_choice=0;command_screen();return battle_view_result;
	xor	a, a
	ld	(#_battle_view_choice),a
	call	_command_screen
	ld	a, (_battle_view_result)
	jp	00247$
00149$:
;src/battle_view.c:312: if(pressed&(J_UP|J_LEFT)){battle_view_choice=battle_view_choice?battle_view_choice-1u:4u;command_screen();}
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00151$
	ld	a, (#_battle_view_choice)
	or	a, a
	jr	Z, 00253$
	ldhl	sp,	#3
	ld	a, (hl)
	jr	00254$
00253$:
	ld	a, #0x04
00254$:
	ld	(#_battle_view_choice),a
	call	_command_screen
00151$:
;src/battle_view.c:313: if(pressed&(J_DOWN|J_RIGHT)){battle_view_choice=(battle_view_choice+1u)%5u;command_screen();}
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00153$
	ld	a, (_battle_view_choice)
	ld	d, #0x00
	ld	e, a
	inc	de
	ld	bc, #0x0005
	call	__moduint
	ld	hl, #_battle_view_choice
	ld	(hl), c
	call	_command_screen
00153$:
;src/battle_view.c:314: if(!(pressed&J_A))return battle_view_result;
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	NZ, 00155$
	ld	a, (_battle_view_result)
	jp	00247$
00155$:
;src/battle_view.c:315: if(battle_view_choice==0u){actions[battle_view_actor].kind=RPG_ACT_ATTACK;next_character();}
	ld	hl, #_battle_view_actor
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (#_battle_view_choice)
	or	a, a
	jr	NZ, 00166$
	ld	bc, #_actions+0
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	(hl), #0x01
	call	_next_character
	jp	00167$
00166$:
;src/battle_view.c:316: else if(battle_view_choice==1u){
	ld	a, (#_battle_view_choice)
	dec	a
	jr	NZ, 00163$
;src/battle_view.c:317: battle_view_choice=0;
	xor	a, a
	ld	(#_battle_view_choice),a
;src/battle_view.c:318: if(!rpg_spell_option(party,battle_view_actor,0,1))say(battle_view_actor==2u?0xb5ba:0xb5c8,NEXT_CHOOSE,battle_view_actor,0,0);
	ld	a, #0x01
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_spell_option
	ld	hl, #_rpg_spell_option
	call	___sdcc_bcall_ehl
	add	sp, #5
	or	a, a
	jr	NZ, 00157$
	ld	a, (#_battle_view_actor)
	sub	a, #0x02
	jr	NZ, 00255$
	ld	de, #0xb5ba
	jr	00256$
00255$:
	ld	de, #0xb5c8
00256$:
	ld	bc, #0x0000
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x01
	call	_say
	jr	00167$
00157$:
;src/battle_view.c:319: else spell_screen();
	call	_spell_screen
	jr	00167$
00163$:
;src/battle_view.c:320: }else if(battle_view_choice==2u){battle_view_choice=0;item_screen(0);}
	ld	a, (#_battle_view_choice)
	sub	a, #0x02
	jr	NZ, 00160$
	xor	a, a
	ld	(#_battle_view_choice), a
	call	_item_screen
	jr	00167$
00160$:
;src/battle_view.c:321: else{actions[battle_view_actor].kind=battle_view_choice==3u?RPG_ACT_TALK:RPG_ACT_RUN;start_resolution();}
	ld	bc, #_actions+0
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (#_battle_view_choice)
	sub	a, #0x03
	ld	a, #0x05
	jr	Z, 00258$
	ld	a, #0x06
00258$:
	ld	(bc), a
	call	_start_resolution
00167$:
;src/battle_view.c:322: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00247$
00169$:
;src/battle_view.c:324: if(battle_view_state==BVIEW_SPELL){
	ld	a, (#_battle_view_state)
;src/battle_view.c:325: count=0;while(count<5u&&rpg_spell_option(party,battle_view_actor,count,1))++count;
	sub	a, #0x02
	jp	NZ, 00197$
	ld	b, a
00171$:
	ld	a, b
	sub	a, #0x05
	jr	NC, 00335$
	push	bc
	ld	a, #0x01
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_spell_option
	ld	hl, #_rpg_spell_option
	call	___sdcc_bcall_ehl
	add	sp, #5
	pop	bc
	or	a, a
	jr	Z, 00335$
	inc	b
	jr	00171$
00335$:
	ldhl	sp,	#6
;src/battle_view.c:326: if(pressed&J_B){battle_view_choice=1;command_screen();return battle_view_result;}
	ld	a, b
	ld	(hl+), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00175$
	ld	hl, #_battle_view_choice
	ld	(hl), #0x01
	call	_command_screen
	ld	a, (_battle_view_result)
	jp	00247$
00175$:
;src/battle_view.c:327: if(count && (pressed&(J_UP|J_LEFT))){battle_view_choice=battle_view_choice?battle_view_choice-1u:count-1u;spell_screen();}
	ld	a, b
	or	a, a
	jr	Z, 00177$
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00177$
	ld	hl, #_battle_view_choice
	ld	a, (hl)
	or	a, a
	jr	Z, 00259$
	ld	b, (hl)
	dec	b
	jr	00260$
00259$:
	dec	b
00260$:
	ld	hl, #_battle_view_choice
	ld	(hl), b
	call	_spell_screen
00177$:
;src/battle_view.c:328: if(count && (pressed&(J_DOWN|J_RIGHT))){battle_view_choice=(battle_view_choice+1u)%count;spell_screen();}
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00180$
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00180$
	ld	a, (#_battle_view_choice)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#4
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#6
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	c, (hl)
	ld	b, #0x00
	pop	de
	push	de
	call	__moduint
	ld	hl, #_battle_view_choice
	ld	(hl), c
	call	_spell_screen
00180$:
;src/battle_view.c:329: if(!(pressed&J_A)||!count)return battle_view_result;
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00182$
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	NZ, 00183$
00182$:
	ld	a, (_battle_view_result)
	jp	00247$
00183$:
;src/battle_view.c:330: selected_spell=rpg_spell_option(party,battle_view_actor,battle_view_choice,1);
	ld	a, #0x01
	push	af
	inc	sp
	ld	a, (_battle_view_choice)
	ld	h, a
	ld	a, (_battle_view_actor)
	ld	l, a
	push	hl
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_spell_option
	ld	hl, #_rpg_spell_option
	call	___sdcc_bcall_ehl
	add	sp, #5
	ld	(#_selected_spell),a
;src/battle_view.c:331: if(party->party[battle_view_actor].mp<rpg_magic_cost(selected_spell)){say(0xb6f7,NEXT_SPELLS,battle_view_actor,0,0);return battle_view_result;}
	ld	a, (_party)
	ld	c, a
	ld	hl, #_party + 1
	ld	b, (hl)
	ld	a, (#_battle_view_actor)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	inc	hl
	inc	hl
	ld	c, (hl)
	push	bc
	ld	a, (_selected_spell)
	push	af
	inc	sp
	ld	e, #b_rpg_magic_cost
	ld	hl, #_rpg_magic_cost
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, a
	pop	bc
	ld	a, c
	sub	a, e
	jr	NC, 00186$
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x14
	ld	de, #0xb6f7
	call	_say
	ld	a, (_battle_view_result)
	jp	00247$
00186$:
;src/battle_view.c:332: actions[battle_view_actor].kind=RPG_ACT_MAGIC;actions[battle_view_actor].id=selected_spell;
	ld	hl, #_battle_view_actor
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #_actions
	add	hl, bc
	ld	(hl), #0x03
	ld	hl, #_battle_view_actor
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #_actions
	add	hl, bc
	inc	hl
	ld	a, (_selected_spell)
	ld	(hl), a
;src/battle_view.c:333: if(selected_spell==MagicID_Heal||selected_spell==MagicID_Cure||selected_spell==MagicID_Help){battle_view_choice=battle_view_actor;target_screen();}
	ld	a, (#_selected_spell)
	dec	a
	jr	Z, 00191$
	ld	a,(#_selected_spell)
	cp	a,#0x02
	jr	Z, 00191$
	sub	a, #0x0a
	jr	NZ, 00192$
00191$:
	ld	a, (#_battle_view_actor)
	ld	(#_battle_view_choice),a
	call	_target_screen
	jr	00193$
00192$:
;src/battle_view.c:334: else if(selected_spell==MagicID_Chat||selected_spell==MagicID_Tele)start_resolution();
	ld	a,(#_selected_spell)
	cp	a,#0x10
	jr	Z, 00187$
	sub	a, #0x11
	jr	NZ, 00188$
00187$:
	call	_start_resolution
	jr	00193$
00188$:
;src/battle_view.c:335: else next_character();
	call	_next_character
00193$:
;src/battle_view.c:336: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00247$
00197$:
;src/battle_view.c:331: if(party->party[battle_view_actor].mp<rpg_magic_cost(selected_spell)){say(0xb6f7,NEXT_SPELLS,battle_view_actor,0,0);return battle_view_result;}
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
;src/battle_view.c:338: if(battle_view_state==BVIEW_TARGET){
	ld	a, (#_battle_view_state)
	sub	a, #0x04
	jp	NZ, 00216$
;src/battle_view.c:339: if(pressed&J_B){battle_view_choice=0;spell_screen();return battle_view_result;}
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00199$
	xor	a, a
	ld	(#_battle_view_choice),a
	call	_spell_screen
	ld	a, (_battle_view_result)
	jp	00247$
00199$:
;src/battle_view.c:340: if(pressed&(J_UP|J_LEFT)){do{battle_view_choice=(battle_view_choice+3u)&3u;}while(!(party->joined_mask&(1u<<battle_view_choice)));target_screen();}
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00204$
00200$:
	ld	hl, #_battle_view_choice
	ld	a, (hl)
	inc	a
	inc	a
	inc	a
	and	a, #0x03
	ld	(hl), a
	ld	hl, #0x0059
	add	hl, de
	ld	a, (hl)
	ld	hl, #_battle_view_choice
	ld	b, (hl)
	ldhl	sp,	#6
	ld	(hl), #0x01
	inc	hl
	ld	(hl), #0x00
	inc	b
	jr	00799$
00798$:
	ldhl	sp,	#6
	sla	(hl)
	inc	hl
	rl	(hl)
00799$:
	dec	b
	jr	NZ,00798$
	ldhl	sp,	#6
	and	a, (hl)
	ld	b, #0x00
	or	a, b
	jr	Z, 00200$
	push	bc
	call	_target_screen
	pop	bc
00204$:
;src/battle_view.c:341: if(pressed&(J_DOWN|J_RIGHT)){do{battle_view_choice=(battle_view_choice+1u)&3u;}while(!(party->joined_mask&(1u<<battle_view_choice)));target_screen();}
	ld	a, c
	and	a, #0x09
	jr	Z, 00209$
00205$:
	ld	hl, #_battle_view_choice
	ld	a, (hl)
	inc	a
	and	a, #0x03
	ld	(hl), a
	ld	a, (_party)
	ld	hl, #_party + 1
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0059
	add	hl, de
	ld	a, (hl)
	ld	hl, #_battle_view_choice
	ld	b, (hl)
	ld	de, #0x0001
	inc	b
	jr	00802$
00801$:
	sla	e
	rl	d
00802$:
	dec	b
	jr	NZ,00801$
	and	a, e
	ld	b, #0x00
	or	a, b
	jr	Z, 00205$
	push	bc
	call	_target_screen
	pop	bc
00209$:
;src/battle_view.c:342: if(pressed&J_A){
	bit	4, c
	jr	Z, 00214$
;src/battle_view.c:343: if(!(party->party[battle_view_choice].status&1u))say(0xb730,NEXT_TARGET,battle_view_choice,0,0);
	ld	a, (_party)
	ld	c, a
	ld	hl, #_party + 1
	ld	b, (hl)
	ld	a, (#_battle_view_choice)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	rrca
	jr	C, 00211$
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_choice)
	push	af
	inc	sp
	ld	a, #0x16
	ld	de, #0xb730
	call	_say
	jr	00214$
00211$:
;src/battle_view.c:344: else{actions[battle_view_actor].target=battle_view_choice;next_character();}
	ld	hl, #_battle_view_actor
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #_actions
	add	hl, bc
	inc	hl
	inc	hl
	ld	a, (_battle_view_choice)
	ld	(hl), a
	call	_next_character
00214$:
;src/battle_view.c:346: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00247$
00216$:
;src/battle_view.c:348: if(battle_view_state==BVIEW_ITEM||battle_view_state==BVIEW_REPLACE){
	ld	a, (#_battle_view_state)
	sub	a, #0x07
	ld	a, #0x01
	jr	Z, 00807$
	xor	a, a
00807$:
	ld	c, a
	ld	a, (#_battle_view_state)
	sub	a, #0x03
	jr	Z, 00244$
	ld	a, c
	or	a, a
	jp	Z, 00245$
00244$:
;src/battle_view.c:349: next=battle_view_state==BVIEW_REPLACE;
	ldhl	sp,	#6
;src/battle_view.c:350: if(pressed&J_B){if(next)say(0xb671,NEXT_PROMPT_FULL,0,battle_view_battle.item_pending,0);else{battle_view_choice=2;command_screen();}return battle_view_result;}
	ld	a, c
	ld	(hl+), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00221$
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00218$
	ld	a, (#(_battle_view_battle + 164) + 0)
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x0d
	ld	de, #0xb671
	call	_say
	jr	00219$
00218$:
	ld	hl, #_battle_view_choice
	ld	(hl), #0x02
	call	_command_screen
00219$:
	ld	a, (_battle_view_result)
	jp	00247$
00221$:
;src/battle_view.c:351: count=party->inventory_count;
	ld	hl, #0x0058
	add	hl, de
	ld	a, (hl)
;src/battle_view.c:352: if(count&&(pressed&(J_UP|J_LEFT))){battle_view_choice=battle_view_choice?battle_view_choice-1u:count-1u;item_screen(next);}
	ldhl	sp,#7
	ld	(hl), a
	or	a, a
	jr	Z, 00223$
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00223$
	ld	a, (#_battle_view_choice)
	or	a, a
	jr	Z, 00261$
	ldhl	sp,	#3
	ld	a, (hl)
	jr	00262$
00261$:
	ldhl	sp,	#7
	ld	a, (hl)
	dec	a
00262$:
	ld	(#_battle_view_choice),a
	ldhl	sp,	#6
	ld	a, (hl)
	call	_item_screen
00223$:
;src/battle_view.c:353: if(count&&(pressed&(J_DOWN|J_RIGHT))){battle_view_choice=(battle_view_choice+1u)%count;item_screen(next);}
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00226$
	dec	hl
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00226$
	ld	a, (#_battle_view_choice)
	ldhl	sp,	#5
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#7
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	c, (hl)
	ld	b, #0x00
	pop	de
	push	de
	call	__moduint
	ld	hl, #_battle_view_choice
	ld	(hl), c
	ldhl	sp,	#6
	ld	a, (hl)
	call	_item_screen
00226$:
;src/battle_view.c:354: if(!(pressed&J_A)||!count)return battle_view_result;
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00228$
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	NZ, 00229$
00228$:
	ld	a, (_battle_view_result)
	jp	00247$
00229$:
;src/battle_view.c:355: selected_slot=battle_view_choice;id=party->inventory[selected_slot];
	ld	a, (#_battle_view_choice)
	ld	(#_selected_slot),a
	ld	a, (#_party)
	ldhl	sp,	#2
	ld	(hl), a
	ld	a, (#_party + 1)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0040
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
	ld	a, (#_selected_slot)
	ldhl	sp,	#7
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#7
;src/battle_view.c:356: if(next){
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00242$
;src/battle_view.c:357: if(!rpg_item_discardable(id))say(0xb6de,NEXT_REPLACE,0,id,0);
	inc	hl
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_rpg_item_discardable
	ld	hl, #_rpg_item_discardable
	call	___sdcc_bcall_ehl
	inc	sp
	or	a, a
	jr	NZ, 00232$
	ld	de, #0x0000
	push	de
	ldhl	sp,	#9
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	ld	a, #0x0f
	ld	de, #0xb6de
	call	_say
	jp	00245$
00232$:
;src/battle_view.c:358: else{replacement_slot=selected_slot;say(0xb69e,NEXT_APPLY_REPLACE,0,id,0);}
	ld	a, (#_selected_slot)
	ld	(#_replacement_slot),a
	ld	de, #0x0000
	push	de
	ldhl	sp,	#9
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	ld	a, #0x10
	ld	de, #0xb69e
	call	_say
	jp	00245$
00242$:
;src/battle_view.c:360: if((id>=ItemID_Landrover&&id<=ItemID_IceDigger)||id==ItemID_DungeonKey||id==ItemID_MiracleKey||id==ItemID_Nuts)literal("ACTION UNAVAILABLE","NOT YET INTEGRATED",NEXT_ITEMS);
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x21
	jr	C, 00238$
	ld	a, #0x23
	sub	a, (hl)
	jr	NC, 00234$
00238$:
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x2d
	jr	Z, 00234$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x3e
	jr	Z, 00234$
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x31
	jr	NZ, 00235$
00234$:
	ld	a, #0x15
	push	af
	inc	sp
	ld	bc, #___str_70
	ld	de, #___str_69
	call	_literal
	jr	00245$
00235$:
;src/battle_view.c:361: else{actions[battle_view_actor].kind=RPG_ACT_ITEM;actions[battle_view_actor].id=id;next_character();}
	ld	hl, #_battle_view_actor
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #_actions
	add	hl, bc
	ld	(hl), #0x04
	ld	hl, #_battle_view_actor
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl), a
	ld	de, #_actions
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
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
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl)
	ld	(de), a
	call	_next_character
00245$:
;src/battle_view.c:364: return battle_view_result;
	ld	a, (_battle_view_result)
00247$:
;src/battle_view.c:365: }
	add	sp, #8
	ret
___str_63:
	.ascii " "
	.db 0x00
___str_64:
	.ascii ">"
	.db 0x00
___str_65:
	.ascii "CHEST UNAVAILABLE"
	.db 0x00
___str_66:
	.db 0x00
___str_67:
	.ascii "CHEST TRAP"
	.db 0x00
___str_68:
	.ascii "HP REDUCED"
	.db 0x00
___str_69:
	.ascii "ACTION UNAVAILABLE"
	.db 0x00
___str_70:
	.ascii "NOT YET INTEGRATED"
	.db 0x00
	.area _CODE_30
	.area _INITIALIZER
	.area _CABS (ABS)
