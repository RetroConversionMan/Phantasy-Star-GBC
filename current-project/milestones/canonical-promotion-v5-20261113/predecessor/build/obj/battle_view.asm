;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module battle_view
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_chest_show
	.globl _chest_show
	.globl b_game_field_battle_item
	.globl _game_field_battle_item
	.globl b_chest_motion_tick
	.globl _chest_motion_tick
	.globl b_chest_motion_begin
	.globl _chest_motion_begin
	.globl b_audio_enemy_effect
	.globl _audio_enemy_effect
	.globl b_audio_battle_track
	.globl _audio_battle_track
	.globl b_audio_command
	.globl _audio_command
	.globl b_dialogue_wait_tick
	.globl _dialogue_wait_tick
	.globl b_dialogue_wait_frames
	.globl _dialogue_wait_frames
	.globl b_dialogue_item_name
	.globl _dialogue_item_name
	.globl b_dialogue_stream_next
	.globl _dialogue_stream_next
	.globl b_dialogue_stream_begin
	.globl _dialogue_stream_begin
	.globl b_dialogue_open
	.globl _dialogue_open
	.globl b_rpg_battle_decline_chest
	.globl _rpg_battle_decline_chest
	.globl b_rpg_battle_replace_reward
	.globl _rpg_battle_replace_reward
	.globl b_rpg_battle_prepare_chest
	.globl _rpg_battle_prepare_chest
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
	.globl b_gold_scene_blue
	.globl _gold_scene_blue
	.globl b_boss_motion_tick
	.globl _boss_motion_tick
	.globl b_boss_motion_begin
	.globl _boss_motion_begin
	.globl b_enemy_magic_sound
	.globl _enemy_magic_sound
	.globl b_enemy_magic_tick
	.globl _enemy_magic_tick
	.globl b_enemy_magic_begin
	.globl _enemy_magic_begin
	.globl b_battle_weapon_sound
	.globl _battle_weapon_sound
	.globl b_battle_weapon_tick
	.globl _battle_weapon_tick
	.globl b_battle_weapon_begin
	.globl _battle_weapon_begin
	.globl b_battle_motion_tick
	.globl _battle_motion_tick
	.globl b_battle_motion_begin_magic
	.globl _battle_motion_begin_magic
	.globl b_battle_motion_begin
	.globl _battle_motion_begin
	.globl b_battle_scene_boss_patch
	.globl _battle_scene_boss_patch
	.globl b_battle_scene_boss_frame
	.globl _battle_scene_boss_frame
	.globl b_battle_scene_magic_frame
	.globl _battle_scene_magic_frame
	.globl b_battle_scene_weapon_clear
	.globl _battle_scene_weapon_clear
	.globl b_battle_scene_weapon_frame
	.globl _battle_scene_weapon_frame
	.globl b_battle_scene_flash_party
	.globl _battle_scene_flash_party
	.globl b_battle_scene_flash_enemy
	.globl _battle_scene_flash_enemy
	.globl b_battle_scene_animation_frame
	.globl _battle_scene_animation_frame
	.globl b_battle_scene_hide
	.globl _battle_scene_hide
	.globl b_battle_scene_clip
	.globl _battle_scene_clip
	.globl b_battle_scene_clear
	.globl _battle_scene_clear
	.globl b_battle_scene_begin
	.globl _battle_scene_begin
	.globl b_ui_number
	.globl _ui_number
	.globl b_ui_text
	.globl _ui_text
	.globl b_ui_panel
	.globl _ui_panel
	.globl _display_off
	.globl _battle_view_menu_allowed
	.globl _battle_view_field_menu_pending
	.globl _battle_view_chest_pending
	.globl _battle_view_dialogue_id
	.globl _battle_view_text_revealing
	.globl _battle_view_hit_cursor
	.globl _battle_view_result
	.globl _battle_view_choice
	.globl _battle_view_actor
	.globl _battle_view_state
	.globl _battle_view_battle
	.globl b_battle_view_begin
	.globl _battle_view_begin
	.globl b_battle_view_chest_begin
	.globl _battle_view_chest_begin
	.globl b_battle_view_chest_prompt
	.globl _battle_view_chest_prompt
	.globl b_battle_view_chest_open
	.globl _battle_view_chest_open
	.globl b_battle_view_chest_leave
	.globl _battle_view_chest_leave
	.globl b_battle_view_chest_abandon
	.globl _battle_view_chest_abandon
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
	.ds 208
_battle_view_state::
	.ds 1
_battle_view_actor::
	.ds 1
_battle_view_choice::
	.ds 1
_battle_view_result::
	.ds 1
_battle_view_hit_cursor::
	.ds 1
_battle_view_text_revealing::
	.ds 1
_battle_view_dialogue_id::
	.ds 2
_battle_view_chest_pending::
	.ds 1
_battle_view_field_menu_pending::
	.ds 1
_battle_view_menu_allowed::
	.ds 1
_chest_motion:
	.ds 7
_chest_clock:
	.ds 1
_party:
	.ds 2
_actions:
	.ds 12
_message:
	.ds 89
_after_message:
	.ds 1
_is_literal:
	.ds 1
_prompt_kind:
	.ds 1
_selected_slot:
	.ds 1
_selection_phase:
	.ds 1
_message_wait:
	.ds 2
_message_clock:
	.ds 1
_item_line:
	.ds 1
_item_after:
	.ds 1
_item_close_frames:
	.ds 1
_level_cursor:
	.ds 1
_old_battle_magic:
	.ds 4
_old_map_magic:
	.ds 4
_replacement_slot:
	.ds 1
_deaths_pending:
	.ds 1
_dragon_fall:
	.ds 1
_previous_alive:
	.ds 4
_audio_delay_start:
	.ds 1
_audio_delay_frames:
	.ds 1
_enemy_motion:
	.ds 6
_weapon_motion:
	.ds 7
_enemy_effect:
	.ds 7
_boss_motion:
	.ds 10
_magic_phase:
	.ds 1
_motion_clock:
	.ds 1
_motion_last_frame:
	.ds 1
_feedback_animated:
	.ds 1
_motion_hit_hold:
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
;src/battle_view.c:44: static void view_text(uint8_t x,uint8_t y,const char *text) {
;	---------------------------------
; Function view_text
; ---------------------------------
_view_text:
	add	sp, #-23
	ldhl	sp,	#22
	ld	(hl-), a
	ld	(hl), e
;src/battle_view.c:46: while(text[i]&&i<20u){copy[i]=text[i];++i;}copy[i]=0;
	ld	c, #0x00
00102$:
	ldhl	sp,#25
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	b, a
	ld	e, c
	ld	d, #0x00
	ld	hl, #0
	add	hl, sp
	add	hl, de
	ld	a, b
	or	a, a
	jr	Z, 00104$
	ld	a, c
	sub	a, #0x14
	jr	NC, 00104$
	ld	(hl), b
	inc	c
	jr	00102$
00104$:
	ld	(hl), #0x00
;src/battle_view.c:47: ui_text(x,y,copy);
	ld	hl, #0
	add	hl, sp
	push	hl
	ldhl	sp,	#23
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
;src/battle_view.c:48: }
	add	sp, #27
	pop	hl
	pop	af
	jp	(hl)
;src/battle_view.c:50: static void view_panel(uint8_t y,uint8_t rows) {
;	---------------------------------
; Function view_panel
; ---------------------------------
_view_panel:
	ld	b, a
	ld	a, e
;src/battle_view.c:51: ui_panel(y,rows);
	push	bc
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
;src/battle_view.c:53: battle_scene_clip(y);
	push	bc
	push	bc
	inc	sp
	ld	e, #b_battle_scene_clip
	ld	hl, #_battle_scene_clip
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
;src/battle_view.c:54: if(!battle_scene_enemy && scene_actor_active){if(y)SHOW_SPRITES;else HIDE_SPRITES;}
	ld	a, (#_battle_scene_enemy)
	or	a, a
	ret	NZ
	ld	a, (#_scene_actor_active)
	or	a, a
	ret	Z
	ld	a, b
	or	a, a
	jr	Z, 00102$
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
	ret
00102$:
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/battle_view.c:56: }
	ret
;src/battle_view.c:132: static void chest_pose(uint8_t frame) {
;	---------------------------------
; Function chest_pose
; ---------------------------------
_chest_pose:
	ld	b, a
;src/battle_view.c:134: DISPLAY_OFF;chest_show(frame);DISPLAY_ON;
	call	_display_off
	push	bc
	inc	sp
	ld	e, #b_chest_show
	ld	hl, #_chest_show
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/battle_view.c:138: }
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
;src/battle_view.c:143: static uint8_t eligible(uint8_t c) {
;	---------------------------------
; Function eligible
; ---------------------------------
_eligible:
	ld	c, a
;src/battle_view.c:144: return (party->joined_mask&(1u<<c)) && (party->party[c].status&1u) && party->party[c].hp && !party->party[c].bound;
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
;src/battle_view.c:145: }
	ret
;src/battle_view.c:146: static uint8_t character_for_message(void) {
;	---------------------------------
; Function character_for_message
; ---------------------------------
_character_for_message:
;src/battle_view.c:147: uint8_t c=battle_view_battle.last_actor;
	ld	a, (#(_battle_view_battle + 144) + 0)
;src/battle_view.c:148: if(c>=4u)c=battle_view_battle.last_target;
	cp	a, #0x04
	jr	C, 00102$
	ld	a, (#(_battle_view_battle + 145) + 0)
00102$:
;src/battle_view.c:149: return c<4u?c:battle_view_actor<4u?battle_view_actor:0u;
	cp	a, #0x04
	ret	C
	ld	a, (#_battle_view_actor)
	cp	a,#0x04
	ret	C
	xor	a, a
;src/battle_view.c:150: }
	ret
;src/battle_view.c:151: static void message_page(void) {
;	---------------------------------
; Function message_page
; ---------------------------------
_message_page:
;src/battle_view.c:152: battle_view_text_revealing=1;ui_text(17,4," ");
	ld	hl, #_battle_view_text_revealing
	ld	(hl), #0x01
	ld	de, #___str_23
	push	de
	ld	e, #0x04
	ld	a, #0x11
	call	_view_text
;src/battle_view.c:153: battle_view_state=BVIEW_MESSAGE;message_clock=audio_clock;
	ld	hl, #_battle_view_state
	ld	(hl), #0x05
	ld	a, (#_audio_clock)
	ld	(#_message_clock),a
;src/battle_view.c:154: }
	ret
___str_23:
	.ascii " "
	.db 0x00
;src/battle_view.c:155: static void say(uint16_t id,uint8_t next,uint8_t character,uint8_t item,uint16_t number) {
;	---------------------------------
; Function say
; ---------------------------------
_say:
	ld	(#_after_message),a
;src/battle_view.c:156: after_message=next;is_literal=0;battle_view_dialogue_id=id;battle_view_text_revealing=0;
	xor	a, a
	ld	(#_is_literal),a
	ld	hl, #_battle_view_dialogue_id
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	xor	a, a
	ld	(#_battle_view_text_revealing),a
;src/battle_view.c:157: if(!dialogue_open(&message,id)) {
	push	de
	ld	de, #_message
	push	de
	ld	e, #b_dialogue_open
	ld	hl, #_dialogue_open
	call	___sdcc_bcall_ehl
	add	sp, #4
	or	a, a
	jr	NZ, 00102$
;src/battle_view.c:158: ui_panel(104,5);ui_text(1,1,"TEXT UNAVAILABLE");ui_text(1,3,"A / B");is_literal=1;battle_view_state=BVIEW_MESSAGE;return;
	ld	e, #0x05
	ld	a, #0x68
	call	_view_panel
	ld	de, #___str_24
	push	de
	ld	a,#0x01
	ld	e,a
	call	_view_text
	ld	de, #___str_25
	push	de
	ld	e, #0x03
	ld	a, #0x01
	call	_view_text
	ld	hl, #_is_literal
	ld	(hl), #0x01
	ld	hl, #_battle_view_state
	ld	(hl), #0x05
	jr	00105$
00102$:
;src/battle_view.c:160: if(character<4u)strcpy(message.character,names[character]);
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
;src/battle_view.c:161: strcpy(message.enemy,enemy_name);dialogue_item_name(item,message.item);message.number=number;
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
;src/battle_view.c:162: dialogue_stream_begin(&message,0);ui_panel(104,5);message_page();
	ld	de, #0x0000
	push	de
	ld	de, #_message
	push	de
	ld	e, #b_dialogue_stream_begin
	ld	hl, #_dialogue_stream_begin
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	e, #0x05
	ld	a, #0x68
	call	_view_panel
	call	_message_page
00105$:
;src/battle_view.c:163: }
	pop	hl
	add	sp, #4
	jp	(hl)
___str_24:
	.ascii "TEXT UNAVAILABLE"
	.db 0x00
___str_25:
	.ascii "A / B"
	.db 0x00
;src/battle_view.c:164: static void literal(const char *first,const char *second,uint8_t next) {
;	---------------------------------
; Function literal
; ---------------------------------
_literal:
;src/battle_view.c:165: after_message=next;is_literal=1;battle_view_dialogue_id=0;battle_view_text_revealing=0;battle_view_state=BVIEW_MESSAGE;
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(#_after_message),a
	ld	hl, #_is_literal
	ld	(hl), #0x01
	xor	a, a
	ld	hl, #_battle_view_dialogue_id
	ld	(hl+), a
	ld	(hl), a
	xor	a, a
	ld	(#_battle_view_text_revealing),a
	ld	hl, #_battle_view_state
	ld	(hl), #0x05
;src/battle_view.c:166: ui_panel(104,5);ui_text(1,1,first);ui_text(1,2,second);ui_text(17,4,">");
	push	bc
	push	de
	ld	e, #0x05
	ld	a, #0x68
	call	_view_panel
	ld	a,#0x01
	ld	e,a
	call	_view_text
	ld	e, #0x02
	ld	a, #0x01
	call	_view_text
	ld	de, #___str_26
	push	de
	ld	e, #0x04
	ld	a, #0x11
	call	_view_text
;src/battle_view.c:167: }
	pop	hl
	inc	sp
	jp	(hl)
___str_26:
	.ascii ">"
	.db 0x00
;src/battle_view.c:168: static void command_screen(void) {
;	---------------------------------
; Function command_screen
; ---------------------------------
_command_screen:
;src/battle_view.c:170: RPGCharacter *p=&party->party[battle_view_actor];
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
;src/battle_view.c:171: battle_view_state=BVIEW_COMMAND;ui_panel(96,6);
	ld	hl, #_battle_view_state
	ld	(hl), #0x01
	push	bc
	ld	e, #0x06
	ld	a, #0x60
	call	_view_panel
	pop	bc
;src/battle_view.c:172: ui_text(0,0,names[battle_view_actor]);ui_text(5,0,"HP");ui_number(8,0,p->hp);
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
	ld	e, a
	call	_view_text
	ld	de, #___str_27
	push	de
	ld	e, #0x00
	ld	a, #0x05
	call	_view_text
	pop	bc
	ld	l, c
	ld	h, b
	inc	hl
	ld	e, (hl)
	xor	a, a
	push	bc
	ld	d, a
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x08
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:173: ui_text(12,0,"MP");ui_number(15,0,p->mp);
	ld	de, #___str_28
	push	de
	ld	e, #0x00
	ld	a, #0x0c
	call	_view_text
	pop	bc
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	b, #0x00
	ld	c, a
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x0f
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:174: ui_text(1,2,"ATTACK");ui_text(8,2,"MAGIC");ui_text(15,2,"ITEM");
	ld	de, #___str_29
	push	de
	ld	e, #0x02
	ld	a, #0x01
	call	_view_text
	ld	de, #___str_30
	push	de
	ld	e, #0x02
	ld	a, #0x08
	call	_view_text
	ld	de, #___str_31
	push	de
	ld	e, #0x02
	ld	a, #0x0f
	call	_view_text
;src/battle_view.c:175: ui_text(1,3,"TALK");ui_text(8,3,"RUN");ui_text(x[battle_view_choice],y[battle_view_choice],">");
	ld	de, #___str_32
	push	de
	ld	e, #0x03
	ld	a, #0x01
	call	_view_text
	ld	de, #___str_33
	push	de
	ld	e, #0x03
	ld	a, #0x08
	call	_view_text
	ld	a, #<(_command_screen_y_10000_336)
	ld	hl, #_battle_view_choice
	add	a, (hl)
	ld	c, a
	ld	a, #>(_command_screen_y_10000_336)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	ld	e, a
	ld	a, #<(_command_screen_x_10000_336)
	add	a, (hl)
	ld	c, a
	ld	a, #>(_command_screen_x_10000_336)
	adc	a, #0x00
	ld	b, a
	ld	a, (bc)
	ld	bc, #___str_34
	push	bc
	call	_view_text
;src/battle_view.c:176: ui_text(1,5,"A:CHOOSE B:BACK");
	ld	de, #___str_35
	push	de
	ld	e, #0x05
	ld	a, #0x01
	call	_view_text
;src/battle_view.c:177: }
	ret
_command_screen_x_10000_336:
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x07	; 7
_command_screen_y_10000_336:
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
;src/battle_view.c:178: static void spell_screen(void) {
;	---------------------------------
; Function spell_screen
; ---------------------------------
_spell_screen:
;src/battle_view.c:180: battle_view_state=BVIEW_SPELL;ui_panel(0,18);ui_text(1,1,names[battle_view_actor]);ui_text(8,1,"MAGIC");
	ld	hl, #_battle_view_state
	ld	(hl), #0x02
	ld	e, #0x12
	xor	a, a
	call	_view_panel
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
	ld	a,#0x01
	ld	e,a
	call	_view_text
	ld	de, #___str_36
	push	de
	ld	e, #0x01
	ld	a, #0x08
	call	_view_text
;src/battle_view.c:181: for(i=0;i<5u;++i){
	ld	b, #0x00
00104$:
;src/battle_view.c:182: id=rpg_spell_option(party,battle_view_actor,i,1);if(!id)break;
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
;src/battle_view.c:183: ui_text(3,4+i*2u,spells[id]);ui_text(11,4+i*2u,"MP");ui_number(15,4+i*2u,rpg_magic_cost(id));
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
	ld	a, #0x03
	call	_view_text
	pop	de
	push	de
	ld	hl, #___str_37
	push	hl
	ld	a, #0x0b
	call	_view_text
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
	ld	a, e
	push	af
	inc	sp
	ld	a, #0x0f
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
;src/battle_view.c:181: for(i=0;i<5u;++i){
	inc	b
	ld	a, b
	sub	a, #0x05
	jr	C, 00104$
00103$:
;src/battle_view.c:185: ui_text(1,4+battle_view_choice*2u,">");ui_text(1,17,"A:CHOOSE B:BACK");
	ld	a, (_battle_view_choice)
	add	a, a
	add	a, #0x04
	ld	de, #___str_38
	push	de
	ld	e, a
	ld	a, #0x01
	call	_view_text
	ld	de, #___str_39
	push	de
	ld	e, #0x11
	ld	a, #0x01
	call	_view_text
;src/battle_view.c:186: }
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
;src/battle_view.c:187: static void item_screen(uint8_t replace) {
;	---------------------------------
; Function item_screen
; ---------------------------------
_item_screen:
	dec	sp
	ld	c, a
;src/battle_view.c:189: if(battle_view_choice>=party->inventory_count)battle_view_choice=party->inventory_count?party->inventory_count-1u:0u;
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
;src/battle_view.c:190: start=(battle_view_choice/6u)*6u;battle_view_state=replace?BVIEW_REPLACE:BVIEW_ITEM;
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
;src/battle_view.c:191: ui_panel(0,18);ui_text(2,1,replace?"WHAT TO DROP?":"ITEMS");
	push	bc
	ld	e, #0x12
	xor	a, a
	call	_view_panel
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
	ld	e, #0x01
	ld	a, #0x02
	call	_view_text
;src/battle_view.c:192: for(i=0;i<6u;++i){slot=start+i;if(slot>=party->inventory_count)break;
	ld	c, #0x00
00109$:
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, c
	ld	b, a
;src/battle_view.c:189: if(battle_view_choice>=party->inventory_count)battle_view_choice=party->inventory_count?party->inventory_count-1u:0u;
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
;src/battle_view.c:192: for(i=0;i<6u;++i){slot=start+i;if(slot>=party->inventory_count)break;
	ld	hl, #0x0058
	add	hl, de
	ld	a, b
	sub	a, (hl)
	jr	NC, 00105$
;src/battle_view.c:193: dialogue_item_name(party->inventory[slot],item_name);ui_text(4,4+i*2u,item_name);
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
	ld	e, a
	ld	a, #0x04
	call	_view_text
	pop	bc
;src/battle_view.c:192: for(i=0;i<6u;++i){slot=start+i;if(slot>=party->inventory_count)break;
	inc	c
	ld	a, c
	sub	a, #0x06
	jr	C, 00109$
00105$:
;src/battle_view.c:195: if(!party->inventory_count)ui_text(4,5,"EMPTY");
	ld	a, (_party)
	ld	hl, #_party + 1
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0058
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00107$
	ld	bc, #___str_42+0
	push	bc
	ld	e, #0x05
	ld	a, #0x04
	call	_view_text
	jr	00108$
00107$:
;src/battle_view.c:196: else ui_text(2,4+(battle_view_choice-start)*2u,">");
	ld	bc, #___str_43+0
	ld	a, (#_battle_view_choice)
	ldhl	sp,	#0
	sub	a, (hl)
	add	a, a
	add	a, #0x04
	ld	e, a
	push	bc
	ld	a, #0x02
	call	_view_text
00108$:
;src/battle_view.c:197: ui_text(1,17,"A:CHOOSE B:BACK");
	ld	de, #___str_44
	push	de
	ld	e, #0x11
	ld	a, #0x01
	call	_view_text
;src/battle_view.c:198: }
	inc	sp
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
;src/battle_view.c:199: static void target_screen(void) {
;	---------------------------------
; Function target_screen
; ---------------------------------
_target_screen:
	dec	sp
	dec	sp
;src/battle_view.c:201: battle_view_state=BVIEW_TARGET;ui_panel(0,18);ui_text(1,1,"WHICH CHARACTER?");
	ld	hl, #_battle_view_state
	ld	(hl), #0x04
	ld	e, #0x12
	xor	a, a
	call	_view_panel
	ld	de, #___str_45
	push	de
	ld	a,#0x01
	ld	e,a
	call	_view_text
;src/battle_view.c:202: for(i=0;i<4u;++i)if(party->joined_mask&(1u<<i)){
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
;src/battle_view.c:203: ui_text(3,4+i*3u,names[i]);ui_number(9,4+i*3u,party->party[i].hp);
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
	ld	e, b
	ld	a, #0x03
	call	_view_text
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
	push	bc
	inc	sp
	ld	a, #0x09
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	pop	bc
;src/battle_view.c:204: ui_text(12,4+i*3u,"/");ui_number(14,4+i*3u,party->party[i].max_hp);
	push	bc
	push	de
	ld	hl, #___str_46
	push	hl
	ld	e, b
	ld	a, #0x0c
	call	_view_text
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
	push	bc
	inc	sp
	ld	a, #0x0e
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
00105$:
;src/battle_view.c:202: for(i=0;i<4u;++i)if(party->joined_mask&(1u<<i)){
	inc	c
	ld	a, c
	sub	a, #0x04
	jp	C, 00104$
;src/battle_view.c:206: ui_text(1,4+battle_view_choice*3u,">");ui_text(1,17,"A:CHOOSE B:BACK");
	ld	a, (_battle_view_choice)
	ld	c, a
	add	a, a
	add	a, c
	add	a, #0x04
	ld	de, #___str_47
	push	de
	ld	e, a
	ld	a, #0x01
	call	_view_text
	ld	de, #___str_48
	push	de
	ld	e, #0x11
	ld	a, #0x01
;src/battle_view.c:207: }
	call	_view_text
	pop	hl
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
;src/battle_view.c:208: static void prompt(uint8_t kind) {
;	---------------------------------
; Function prompt
; ---------------------------------
_prompt:
	ld	(#_prompt_kind),a
;src/battle_view.c:209: prompt_kind=kind;battle_view_choice=0;battle_view_state=BVIEW_PROMPT;
	xor	a, a
	ld	(#_battle_view_choice),a
	ld	hl, #_battle_view_state
	ld	(hl), #0x06
;src/battle_view.c:210: ui_panel(104,5);ui_text(3,1,"YES");ui_text(12,1,"NO");ui_text(1,1,">");ui_text(1,4,"A:CHOOSE");
	ld	e, #0x05
	ld	a, #0x68
	call	_view_panel
	ld	de, #___str_49
	push	de
	ld	e, #0x01
	ld	a, #0x03
	call	_view_text
	ld	de, #___str_50
	push	de
	ld	e, #0x01
	ld	a, #0x0c
	call	_view_text
	ld	de, #___str_51
	push	de
	ld	a,#0x01
	ld	e,a
	call	_view_text
	ld	de, #___str_52
	push	de
	ld	e, #0x04
	ld	a, #0x01
	call	_view_text
;src/battle_view.c:211: }
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
;src/battle_view.c:212: static void start_resolution(void) {
;	---------------------------------
; Function start_resolution
; ---------------------------------
_start_resolution:
;src/battle_view.c:213: uint8_t result=rpg_battle_prepare(party,&battle_view_battle,actions);
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
;src/battle_view.c:214: if(result){
	or	a, a
	jr	Z, 00111$
;src/battle_view.c:215: if(result==RPG_NO_MP)say(0xb6f7,NEXT_CHOOSE,battle_view_actor,0,0);
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
;src/battle_view.c:216: else if(result==RPG_NOT_LEARNED)say(0xb5c8,NEXT_CHOOSE,battle_view_actor,0,0);
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
;src/battle_view.c:217: else if(result==RPG_DEAD)say(0xb730,NEXT_CHOOSE,battle_view_actor,0,0);
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
;src/battle_view.c:218: else literal("ACTION UNAVAILABLE","CHOOSE AGAIN",NEXT_CHOOSE);
	ld	a, #0x01
	push	af
	inc	sp
	ld	bc, #___str_54
	ld	de, #___str_53
	call	_literal
;src/battle_view.c:219: return;
	ret
00111$:
;src/battle_view.c:221: if(actions[battle_view_actor<4u?battle_view_actor:0u].kind==RPG_ACT_RUN ||
	ld	hl, #_battle_view_actor
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00119$
	ld	c, (hl)
	ld	b, #0x00
	jr	00120$
00119$:
	ld	bc, #0x0000
00120$:
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	de, #_actions
	add	hl, de
	ld	a, (hl)
	sub	a, #0x06
	jp	Z, _command_feedback
;src/battle_view.c:222: battle_view_battle.last_effect==BATTLE_EFFECT_TALK || battle_view_battle.suppress_party)command_feedback();
	ld	a, (#(_battle_view_battle + 160) + 0)
	sub	a, #0x10
	jp	Z, _command_feedback
	ld	a, (#(_battle_view_battle + 158) + 0)
	or	a, a
	jp	NZ, _command_feedback
;src/battle_view.c:223: else battle_view_state=BVIEW_EXECUTE;
	ld	hl, #_battle_view_state
	ld	(hl), #0x08
;src/battle_view.c:224: }
	ret
___str_53:
	.ascii "ACTION UNAVAILABLE"
	.db 0x00
___str_54:
	.ascii "CHOOSE AGAIN"
	.db 0x00
;src/battle_view.c:225: static void next_character(void) {
;	---------------------------------
; Function next_character
; ---------------------------------
_next_character:
;src/battle_view.c:226: ++battle_view_actor;
	ld	hl, #_battle_view_actor
	inc	(hl)
;src/battle_view.c:227: while(battle_view_actor<4u && !eligible(battle_view_actor))++battle_view_actor;
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
;src/battle_view.c:228: battle_view_choice=0;
	xor	a, a
	ld	(#_battle_view_choice),a
;src/battle_view.c:229: if(battle_view_actor<4u)command_screen();else start_resolution();
	ld	a, (#_battle_view_actor)
	sub	a, #0x04
	jp	NC, _start_resolution
;src/battle_view.c:230: }
	jp	_command_screen
;src/battle_view.c:231: static void new_round(void) {
;	---------------------------------
; Function new_round
; ---------------------------------
_new_round:
;src/battle_view.c:232: memset(actions,0,sizeof actions);battle_view_actor=0;battle_view_choice=0;
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
;src/battle_view.c:233: while(battle_view_actor<4u && !eligible(battle_view_actor))++battle_view_actor;
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
;src/battle_view.c:234: if(battle_view_actor<4u)command_screen();else start_resolution();
	ld	a, (#_battle_view_actor)
	sub	a, #0x04
	jp	NC, _start_resolution
;src/battle_view.c:235: }
	jp	_command_screen
;src/battle_view.c:236: static void result_screen(void) {
;	---------------------------------
; Function result_screen
; ---------------------------------
_result_screen:
;src/battle_view.c:237: uint8_t outcome=battle_view_battle.outcome;
	ld	hl, #_battle_view_battle + 130
	ld	c, (hl)
;src/battle_view.c:239: if(battle_view_battle.enemy_id==EnemyID_Tarzimal){audio_command(0xd8);rpg_claim_rewards(party,&battle_view_battle);resume(NEXT_DONE);}
;src/battle_view.c:238: if(outcome==RPG_VICTORY){
	ld	a, c
	dec	a
	jr	NZ, 00127$
;src/battle_view.c:239: if(battle_view_battle.enemy_id==EnemyID_Tarzimal){audio_command(0xd8);rpg_claim_rewards(party,&battle_view_battle);resume(NEXT_DONE);}
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x31
	jr	NZ, 00105$
	ld	a, #0xd8
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
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
00105$:
;src/battle_view.c:243: audio_command(0xaf);
	ld	a, #0xaf
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/battle_view.c:245: if(battle_view_battle.enemy_id==70u&&battle_scene_type==14u)gold_scene_blue();
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x46
	jr	NZ, 00102$
	ld	a, (#_battle_scene_type)
	sub	a, #0x0e
	jr	NZ, 00102$
	ld	e, #b_gold_scene_blue
	ld	hl, #_gold_scene_blue
	call	___sdcc_bcall_ehl
00102$:
;src/battle_view.c:247: close_delay(battle_view_battle.enemy_id==EnemyID_DarkFalz?4u:14u,NEXT_VICTORY_CLEAR);
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x49
	ld	a, #0x04
	jr	Z, 00132$
	ld	a, #0x0e
00132$:
	ld	e, #0x21
	jp	_close_delay
00127$:
;src/battle_view.c:249: }else if(outcome==RPG_DEFEAT){
	ld	a, c
	sub	a, #0x02
	jr	NZ, 00124$
;src/battle_view.c:251: if(battle_view_battle.enemy_id==70u&&battle_scene_type==14u)gold_scene_blue();
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x46
	jr	NZ, 00108$
	ld	a, (#_battle_scene_type)
	sub	a, #0x0e
	jr	NZ, 00108$
	ld	e, #b_gold_scene_blue
	ld	hl, #_gold_scene_blue
	call	___sdcc_bcall_ehl
00108$:
;src/battle_view.c:253: if(battle_view_battle.enemy_id==EnemyID_Tarzimal || battle_view_battle.enemy_id==EnemyID_Saccubus){audio_command(0xd8);resume(NEXT_DONE);}
	ld	a, (#(_battle_view_battle + 128) + 0)
	cp	a, #0x31
	jr	Z, 00113$
	sub	a, #0x4a
	jr	NZ, 00114$
00113$:
	ld	a, #0xd8
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x11
	jp	_resume
00114$:
;src/battle_view.c:254: else {audio_command(0x94);if(party->joined_mask!=1u)say(0xbd17,NEXT_DEFEAT,0,0,0);else say(0xbd23,NEXT_DONE,0,0,0);}
	ld	a, #0x94
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, (_party)
	ld	hl, #_party + 1
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0059
	add	hl, de
	ld	a, (hl)
	dec	a
	jr	Z, 00111$
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x13
	ld	de, #0xbd17
	call	_say
	ret
00111$:
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x11
	ld	de, #0xbd23
	call	_say
	ret
00124$:
;src/battle_view.c:255: }else if(outcome==RPG_TALKED)say(0xb132,NEXT_TALK_REPLY,character_for_message(),0,0);
	ld	a, c
	sub	a, #0x04
	jr	NZ, 00121$
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
00121$:
;src/battle_view.c:256: else if(outcome==RPG_ESCAPED)say(0xb25f,NEXT_DONE,0,0,0);
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
;src/battle_view.c:257: else new_round();
;src/battle_view.c:258: }
	ret
;src/battle_view.c:259: static void item_next_line(void) {
;	---------------------------------
; Function item_next_line
; ---------------------------------
_item_next_line:
;src/battle_view.c:260: if(item_line>=field_action.line_count){
	ld	hl, #_field_action + 2
	ld	a, (#_item_line)
	sub	a, (hl)
	jr	C, 00102$
;src/battle_view.c:263: close_delay(6u,item_after);return;
	ld	a, (_item_after)
	ld	e, a
	ld	a, #0x06
	jp	_close_delay
00102$:
;src/battle_view.c:265: if(field_action.lines[item_line].sound_before)audio_command(field_action.lines[item_line].sound_before);
	ld	de, #_field_action + 10
	ld	a, (#_item_line)
	add	a, a
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, de
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	push	de
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	de
00104$:
;src/battle_view.c:266: say(field_action.lines[item_line].dialogue,NEXT_ITEM_LINE,field_action.character,field_action.item,0);
	ld	hl, #_field_action + 3
	ld	c, (hl)
	ld	hl, #_field_action + 4
	ld	b, (hl)
	ld	a, (#_item_line)
	add	a, a
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	ld	de, #0x0000
	push	de
	ld	a, c
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, #0x18
	ld	e, l
	ld	d, h
	call	_say
;src/battle_view.c:267: }
	ret
;src/battle_view.c:268: static void close_delay(uint8_t frames,uint8_t next) {
;	---------------------------------
; Function close_delay
; ---------------------------------
_close_delay:
	ld	(#_item_close_frames),a
	ld	hl, #_item_after
	ld	(hl), e
;src/battle_view.c:269: item_close_frames=frames;item_after=next;message_clock=audio_clock;battle_view_state=BVIEW_ITEM_CLOSE;
	ld	a, (#_audio_clock)
	ld	(#_message_clock),a
	ld	hl, #_battle_view_state
	ld	(hl), #0x12
;src/battle_view.c:270: }
	ret
;src/battle_view.c:271: static void one_line(uint16_t id,uint8_t sound,uint8_t after,uint8_t character) {
;	---------------------------------
; Function one_line
; ---------------------------------
_one_line:
	ld	c, a
;src/battle_view.c:272: memset(&field_action,0,sizeof field_action);field_action.character=character;
	push	de
	ld	hl, #0x0016
	push	hl
	ld	l, h
	push	hl
	ld	hl, #_field_action
	push	hl
	call	_memset
	add	sp, #6
	pop	de
	ld	hl, #_field_action + 4
	push	hl
	ldhl	sp,	#5
	ld	a, (hl)
	pop	hl
	ld	(hl), a
;src/battle_view.c:273: field_action.lines[0].dialogue=id;field_action.lines[0].sound_before=sound;
	ld	hl, #_field_action + 10
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	ld	hl, #(_field_action + 12)
	ld	(hl), c
;src/battle_view.c:274: field_action.line_count=1;item_line=0;item_after=after;item_next_line();
	ld	hl, #_field_action + 2
	ld	(hl), #0x01
	xor	a, a
	ld	(#_item_line),a
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(#_item_after),a
	call	_item_next_line
;src/battle_view.c:275: }
	pop	hl
	pop	af
	jp	(hl)
;src/battle_view.c:276: static void command_feedback(void) {
;	---------------------------------
; Function command_feedback
; ---------------------------------
_command_feedback:
	add	sp, #-4
;src/battle_view.c:277: RPGBattle *b=&battle_view_battle;RPGAction *a=actions+b->last_actor;
	ld	bc, #_actions+0
	ld	a, (#(_battle_view_battle + 144) + 0)
	ldhl	sp,#3
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
;src/battle_view.c:278: if(a->kind==RPG_ACT_RUN){
	inc	sp
	inc	sp
	push	bc
	pop	de
	push	de
	ld	a, (de)
;src/battle_view.c:279: if(b->outcome==RPG_ESCAPED){audio_command(0xbc);resume(NEXT_DONE);}
;src/battle_view.c:278: if(a->kind==RPG_ACT_RUN){
	sub	a, #0x06
	jr	NZ, 00105$
;src/battle_view.c:279: if(b->outcome==RPG_ESCAPED){audio_command(0xbc);resume(NEXT_DONE);}
	ld	a, (#(_battle_view_battle + 130) + 0)
	sub	a, #0x03
	jr	NZ, 00102$
	ld	a, #0xbc
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x11
	call	_resume
	jp	00114$
00102$:
;src/battle_view.c:280: else one_line(0xb15e,0,NEXT_STEP,b->last_actor);
	ldhl	sp,	#3
	ld	h, (hl)
	ld	l, #0x02
	push	hl
	xor	a, a
	ld	de, #0xb15e
	call	_one_line
;src/battle_view.c:281: return;
	jp	00114$
00105$:
;src/battle_view.c:283: memset(&field_action,0,sizeof field_action);field_action.character=b->last_actor;
	ld	de, #0x0016
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_field_action
	push	de
	call	_memset
	add	sp, #6
	ld	a, (#(_battle_view_battle + 144) + 0)
	ld	(#(_field_action + 4)),a
;src/battle_view.c:284: if(a->kind==RPG_ACT_MAGIC&&a->id==MagicID_Chat)audio_command(0xab);
	pop	de
	push	de
	ld	a, (de)
	sub	a, #0x03
	jr	NZ, 00107$
	inc	bc
	ld	a, (bc)
	sub	a, #0x10
	jr	NZ, 00107$
	ld	a, #0xab
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00107$:
;src/battle_view.c:285: field_action.lines[0].dialogue=b->outcome==RPG_TALKED?0xb132:0xb13d;
	ld	a, (#(_battle_view_battle + 130) + 0)
	sub	a, #0x04
	jr	NZ, 00116$
	ldhl	sp,	#2
	ld	a, #0x32
	ld	(hl+), a
	ld	(hl), #0xb1
	jr	00117$
00116$:
	ldhl	sp,	#2
	ld	a, #0x3d
	ld	(hl+), a
	ld	(hl), #0xb1
00117$:
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #(_field_action + 10)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle_view.c:286: field_action.line_count=1;item_after=NEXT_STEP;
	ld	hl, #(_field_action + 2)
	ld	(hl), #0x01
	ld	hl, #_item_after
	ld	(hl), #0x02
;src/battle_view.c:287: if(b->outcome==RPG_TALKED){
	ld	a, (#(_battle_view_battle + 130) + 0)
	sub	a, #0x04
	jr	NZ, 00113$
;src/battle_view.c:288: field_action.lines[1].dialogue=talk_texts[b->talk_index<19u?b->talk_index:0u];field_action.line_count=2;item_after=NEXT_DONE;
	ld	bc, #_talk_texts+0
	ld	a, (#(_battle_view_battle + 161) + 0)
	cp	a, #0x13
	jr	NC, 00118$
	ld	h, #0x00
	jr	00119$
00118$:
	xor	a, a
	ld	h, a
00119$:
	ld	l, a
	add	hl, hl
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #(_field_action + 14)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	hl, #(_field_action + 2)
	ld	(hl), #0x02
	ld	hl, #_item_after
	ld	(hl), #0x11
;src/battle_view.c:289: if(a->kind==RPG_ACT_MAGIC&&(b->enemy_flags&0x40u)){
	pop	de
	push	de
	ld	a, (de)
	sub	a, #0x03
	jr	NZ, 00113$
	ld	a, (#(_battle_view_battle + 155) + 0)
	bit	6, a
	jr	Z, 00113$
;src/battle_view.c:290: field_action.lines[0].sound_before=0xac;field_action.lines[1].sound_after=0xd5;
	ld	hl, #_field_action + 12
	ld	(hl), #0xac
	ld	hl, #_field_action + 17
	ld	(hl), #0xd5
00113$:
;src/battle_view.c:293: item_line=0;item_next_line();
	xor	a, a
	ld	(#_item_line),a
	call	_item_next_line
00114$:
;src/battle_view.c:294: }
	add	sp, #4
	ret
;src/battle_view.c:295: static uint8_t support_feedback(void) {
;	---------------------------------
; Function support_feedback
; ---------------------------------
_support_feedback:
	add	sp, #-9
;src/battle_view.c:296: RPGBattle *b=&battle_view_battle;uint8_t c=b->last_actor,id,target;
	ld	a, (#(_battle_view_battle + 144) + 0)
;src/battle_view.c:297: if(c>=4u||actions[c].kind!=RPG_ACT_MAGIC)return 0;
	ldhl	sp,#0
	ld	(hl), a
	sub	a, #0x04
	jr	NC, 00101$
	ld	bc, #_actions+0
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	sub	a, #0x03
	jr	Z, 00102$
00101$:
	xor	a, a
	jp	00136$
00102$:
;src/battle_view.c:298: if(!b->last_error&&(b->last_effect==BATTLE_EFFECT_NONE||b->last_effect==BATTLE_EFFECT_BOUND||b->last_effect==BATTLE_EFFECT_RECOVERED))return 0;
	ld	a, (#(_battle_view_battle + 147) + 0)
	ldhl	sp,#1
	ld	(hl), a
	or	a, a
	jr	NZ, 00105$
	ld	a, (#(_battle_view_battle + 160) + 0)
	or	a, a
	jr	Z, 00104$
	cp	a, #0x04
	jr	Z, 00104$
	sub	a, #0x05
	jr	NZ, 00105$
00104$:
	xor	a, a
	jp	00136$
00105$:
;src/battle_view.c:299: id=actions[c].id;target=actions[c].target;
	ld	l, c
	ld	h, b
	inc	hl
	ld	e, (hl)
	inc	bc
	inc	bc
	ld	a, (bc)
	ldhl	sp,	#2
	ld	(hl), a
;src/battle_view.c:300: if(id!=MagicID_Heal&&id!=MagicID_Cure&&id!=MagicID_Help&&id!=MagicID_Wall&&id!=MagicID_Prot&&id!=MagicID_Rope&&id!=MagicID_Terr&&id!=MagicID_Bye)return 0;
	ld	a, e
	dec	a
	ld	a, #0x01
	jr	Z, 00353$
	xor	a, a
00353$:
	ldhl	sp,	#3
	ld	(hl), a
	ld	a, e
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00355$
	xor	a, a
00355$:
	ldhl	sp,	#4
	ld	(hl), a
	ld	a, e
	sub	a, #0x0a
	ld	a, #0x01
	jr	Z, 00357$
	xor	a, a
00357$:
	ldhl	sp,	#5
	ld	(hl), a
	ld	a, e
	sub	a, #0x03
	ld	a, #0x01
	jr	Z, 00359$
	xor	a, a
00359$:
	ldhl	sp,	#6
	ld	(hl), a
	ld	a, e
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 00361$
	xor	a, a
00361$:
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, e
	sub	a, #0x08
	ld	a, #0x01
	jr	Z, 00363$
	xor	a, a
00363$:
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, e
	sub	a, #0x09
	ld	a, #0x01
	jr	Z, 00365$
	xor	a, a
00365$:
	ld	c, a
	ldhl	sp,	#3
	bit	0, (hl)
	jr	NZ, 00110$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00110$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00110$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00110$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00110$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00110$
	ld	a, e
	sub	a, #0x0b
	jr	Z, 00110$
	bit	0, c
	jr	NZ, 00110$
	xor	a, a
	jp	00136$
00110$:
;src/battle_view.c:301: if(b->last_error&&b->last_error!=RPG_DEAD)return 0;
	ldhl	sp,	#1
	ld	a, (hl)
	sub	a, #0x05
	ld	a, #0x01
	jr	Z, 00368$
	xor	a, a
00368$:
	ld	b, a
	ldhl	sp,	#1
	ld	a, (hl)
	or	a, a
	jr	Z, 00119$
	bit	0, b
	jr	NZ, 00119$
	xor	a, a
	jp	00136$
00119$:
;src/battle_view.c:302: if(b->last_error==RPG_DEAD){one_line(0xb730,id==MagicID_Help?0xab:0,NEXT_STEP,target);return 1;}
	ld	a, b
	or	a, a
	jr	Z, 00122$
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	ld	a, #0xab
	jr	NZ, 00139$
	xor	a, a
00139$:
	ldhl	sp,	#2
	ld	h, (hl)
	push	hl
	inc	sp
	ld	h, #0x02
	push	hl
	inc	sp
	ld	de, #0xb730
	call	_one_line
	ld	a, #0x01
	jp	00136$
00122$:
;src/battle_view.c:303: if(id==MagicID_Bye){one_line(b->outcome==RPG_ESCAPED?0xb25f:0xb172,b->outcome==RPG_ESCAPED?0xbc:0,b->outcome==RPG_ESCAPED?NEXT_DONE:NEXT_STEP,c);return 1;}
	ld	a, c
	or	a, a
	jr	Z, 00124$
	ld	a, (#(_battle_view_battle + 130) + 0)
	sub	a, #0x03
	ld	a, #0x01
	jr	Z, 00370$
	xor	a, a
00370$:
	ldhl	sp,	#7
	ld	(hl), a
	or	a, a
	jr	Z, 00140$
	inc	hl
	ld	(hl), #0x11
	jr	00141$
00140$:
	ldhl	sp,	#8
	ld	(hl), #0x02
00141$:
	ldhl	sp,	#8
	ld	a, (hl-)
	ld	c, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00142$
	ld	b, #0xbc
	jr	00143$
00142$:
	ld	b, #0x00
00143$:
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00144$
	ld	de, #0xb25f
	jr	00145$
00144$:
	ld	de, #0xb172
00145$:
	ldhl	sp,	#0
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, c
	push	af
	inc	sp
	ld	a, b
	call	_one_line
	ld	a, #0x01
	jp	00136$
00124$:
;src/battle_view.c:304: memset(&field_action,0,sizeof field_action);field_action.character=(id==MagicID_Heal||id==MagicID_Cure||id==MagicID_Help)?target:c;
	ld	de, #0x0016
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_field_action
	push	de
	call	_memset
	add	sp, #6
	ldhl	sp,	#3
	bit	0, (hl)
	jr	NZ, 00149$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00149$
	inc	hl
	bit	0, (hl)
	jr	Z, 00146$
00149$:
	ldhl	sp,	#2
	ld	a, (hl)
	jr	00147$
00146$:
	ldhl	sp,	#0
	ld	a, (hl)
00147$:
	ld	hl, #(_field_action + 4)
;src/battle_view.c:305: field_action.line_count=1;field_action.lines[0].sound_before=0xab;
	ld	(hl-), a
	dec	hl
	ld	(hl), #0x01
	ld	hl, #_field_action + 12
	ld	(hl), #0xab
;src/battle_view.c:306: if(id==MagicID_Heal||id==MagicID_Cure){field_action.lines[0].dialogue=0xb1d0;field_action.lines[0].sound_after=0xc1;}
	ld	bc, #_field_action + 10
	ldhl	sp,	#3
	ld	a, (hl)
	or	a, a
	jr	NZ, 00132$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00133$
00132$:
	ld	a, #0xd0
	ld	(bc), a
	inc	bc
	ld	a, #0xb1
	ld	(bc), a
	ld	hl, #_field_action + 13
	ld	(hl), #0xc1
	jr	00134$
00133$:
;src/battle_view.c:307: else if(id==MagicID_Help)field_action.lines[0].dialogue=0xb22f;
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00130$
	ld	a, #0x2f
	ld	(bc), a
	inc	bc
	ld	a, #0xb2
	ld	(bc), a
	jr	00134$
00130$:
;src/battle_view.c:308: else if(id==MagicID_Wall||id==MagicID_Prot)field_action.lines[0].dialogue=0xb18b;
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	NZ, 00125$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00126$
00125$:
	ld	a, #0x8b
	ld	(bc), a
	inc	bc
	ld	a, #0xb1
	ld	(bc), a
	jr	00134$
00126$:
;src/battle_view.c:309: else field_action.lines[0].dialogue=b->last_effect==BATTLE_EFFECT_NO_EFFECT?0xb172:id==MagicID_Rope?0xb1e0:0xb24c;
	ld	a, (#(_battle_view_battle + 160) + 0)
	sub	a, #0x11
	jr	NZ, 00154$
	ld	de, #0xb172
	jr	00155$
00154$:
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00156$
	ld	de, #0xb1e0
	jr	00157$
00156$:
	ld	de, #0xb24c
00157$:
00155$:
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
00134$:
;src/battle_view.c:310: item_line=0;item_after=NEXT_STEP;item_next_line();return 1;
	xor	a, a
	ld	(#_item_line),a
	ld	hl, #_item_after
	ld	(hl), #0x02
	call	_item_next_line
	ld	a, #0x01
00136$:
;src/battle_view.c:311: }
	add	sp, #9
	ret
;src/battle_view.c:312: static uint8_t core_item_feedback(void) {
;	---------------------------------
; Function core_item_feedback
; ---------------------------------
_core_item_feedback:
	add	sp, #-3
;src/battle_view.c:313: RPGBattle *b=&battle_view_battle;uint8_t c=b->last_actor,item;
	ld	hl, #_battle_view_battle + 144
	ld	b, (hl)
;src/battle_view.c:314: if(c>=4u||actions[c].kind!=RPG_ACT_ITEM)return 0;
	ld	a, b
	sub	a, #0x04
	jr	NC, 00101$
	ld	e, b
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	ld	de, #_actions
	add	hl, de
	ld	a, (hl)
	sub	a, #0x04
	jr	Z, 00102$
00101$:
	xor	a, a
	jp	00134$
00102$:
;src/battle_view.c:315: if(b->last_error&&b->last_error!=RPG_ACTION_FAILED)return 0;
	ld	de, #_battle_view_battle + 147
	ld	a, (de)
	or	a, a
	jr	Z, 00105$
	sub	a, #0x0a
	jr	Z, 00105$
	xor	a, a
	jp	00134$
00105$:
;src/battle_view.c:316: if(b->last_effect!=BATTLE_EFFECT_HEAL&&b->last_effect!=BATTLE_EFFECT_NO_EFFECT&&b->last_effect!=BATTLE_EFFECT_ESCAPE&&b->last_effect!=BATTLE_EFFECT_TALK)return 0;
	ld	de, #_battle_view_battle + 160
	ld	a, (de)
	cp	a, #0x06
	jr	Z, 00108$
	cp	a, #0x11
	jr	Z, 00108$
	cp	a, #0x0f
	jr	Z, 00108$
	sub	a, #0x10
	jr	Z, 00108$
	xor	a, a
	jp	00134$
00108$:
;src/battle_view.c:317: item=actions[c].id;
	inc	hl
	ld	e, (hl)
;src/battle_view.c:318: if(item!=ItemID_Cola&&item!=ItemID_Burger&&item!=ItemID_Wand&&item!=ItemID_Escaper&&item!=ItemID_MagicHat&&item!=ItemID_Sphere)return 0;
	ld	a, e
	sub	a, #0x24
	ld	a, #0x01
	jr	Z, 00287$
	xor	a, a
00287$:
	ld	c, a
	ld	a, e
	sub	a, #0x25
	ld	a, #0x01
	jr	Z, 00289$
	xor	a, a
00289$:
	ldhl	sp,	#2
	ld	(hl), a
	ld	a, e
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 00291$
	xor	a, a
00291$:
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, e
	sub	a, #0x28
	ld	a, #0x01
	jr	Z, 00293$
	xor	a, a
00293$:
	ldhl	sp,	#1
	ld	(hl), a
	bit	0, c
	jr	NZ, 00113$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00113$
	dec	hl
	dec	hl
	bit	0, (hl)
	jr	NZ, 00113$
	inc	hl
	bit	0, (hl)
	jr	NZ, 00113$
	ld	a,e
	cp	a,#0x2a
	jr	Z, 00113$
	sub	a, #0x2e
	jr	Z, 00113$
	xor	a, a
	jp	00134$
00113$:
;src/battle_view.c:319: memset(&field_action,0,sizeof field_action);field_action.character=c;field_action.item=item;
	push	de
	ld	hl, #0x0016
	push	hl
	ld	l, h
	push	hl
	ld	hl, #_field_action
	push	hl
	call	_memset
	add	sp, #6
	pop	de
	ld	hl, #_field_action + 4
	ld	(hl), b
	ld	hl, #_field_action + 3
	ld	(hl), e
;src/battle_view.c:320: field_action.lines[0].dialogue=0xb2ac;field_action.line_count=2;item_after=NEXT_STEP;
	ld	hl, #(_field_action + 10)
	ld	a, #0xac
	ld	(hl+), a
	ld	(hl), #0xb2
	ld	hl, #(_field_action + 2)
	ld	(hl), #0x02
	ld	hl, #_item_after
	ld	(hl), #0x02
;src/battle_view.c:321: if(item==ItemID_Cola||item==ItemID_Burger){field_action.lines[1].dialogue=0xb1d0;field_action.lines[1].sound_after=0xc1;}
	ld	a, c
	or	a, a
	jr	NZ, 00130$
	ldhl	sp,	#2
	ld	a, (hl)
	or	a, a
	jr	Z, 00131$
00130$:
	ld	hl, #(_field_action + 14)
	ld	a, #0xd0
	ld	(hl+), a
	ld	a, #0xb1
	ld	(hl+), a
	inc	hl
	ld	(hl), #0xc1
	jp	00132$
00131$:
;src/battle_view.c:323: field_action.lines[1].dialogue=b->outcome==RPG_ESCAPED?0xb25f:0xb2cd;
	ld	a, (#(_battle_view_battle + 130) + 0)
	ldhl	sp,	#2
	ld	(hl), a
;src/battle_view.c:324: if(b->outcome==RPG_ESCAPED){field_action.lines[1].sound_before=0xbc;item_after=NEXT_DONE;}
;src/battle_view.c:322: else if(item==ItemID_Wand||item==ItemID_Escaper){
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	NZ, 00126$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00127$
00126$:
;src/battle_view.c:323: field_action.lines[1].dialogue=b->outcome==RPG_ESCAPED?0xb25f:0xb2cd;
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00136$
	ldhl	sp,	#1
	ld	a, #0x5f
	ld	(hl+), a
	ld	(hl), #0xb2
	jr	00137$
00136$:
	ldhl	sp,	#1
	ld	a, #0xcd
	ld	(hl+), a
	ld	(hl), #0xb2
00137$:
	ldhl	sp,	#1
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #(_field_action + 14)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/battle_view.c:324: if(b->outcome==RPG_ESCAPED){field_action.lines[1].sound_before=0xbc;item_after=NEXT_DONE;}
	ld	a, (#(_battle_view_battle + 130) + 0)
	sub	a, #0x03
	jr	NZ, 00132$
	inc	hl
	ld	(hl), #0xbc
	ld	hl, #_item_after
	ld	(hl), #0x11
	jr	00132$
00127$:
;src/battle_view.c:325: }else if(b->outcome!=RPG_TALKED)field_action.lines[1].dialogue=0xb13d;
	ldhl	sp,	#2
	ld	a, (hl)
	sub	a, #0x04
	jr	Z, 00124$
	ld	hl, #(_field_action + 14)
	ld	a, #0x3d
	ld	(hl+), a
	ld	(hl), #0xb1
	jr	00132$
00124$:
;src/battle_view.c:327: field_action.lines[1].dialogue=0xb132;field_action.line_count=3;
	ld	hl, #(_field_action + 14)
	ld	a, #0x32
	ld	(hl+), a
	ld	(hl), #0xb1
	ld	hl, #(_field_action + 2)
	ld	(hl), #0x03
;src/battle_view.c:328: field_action.lines[2].dialogue=talk_texts[b->talk_index<19u?b->talk_index:0u];item_after=NEXT_DONE;
	ld	a, (#(_battle_view_battle + 161) + 0)
	cp	a, #0x13
	jr	NC, 00138$
	ld	h, #0x00
	jr	00139$
00138$:
	xor	a, a
	ld	h, a
00139$:
	ld	l, a
	add	hl, hl
	ld	de, #_talk_texts
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	hl, #(_field_action + 18)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
	ld	hl, #_item_after
	ld	(hl), #0x11
;src/battle_view.c:329: if(b->enemy_flags&0x40u){field_action.lines[1].sound_before=0xac;field_action.lines[2].sound_after=0xd5;}
	ld	a, (#(_battle_view_battle + 155) + 0)
	bit	6, a
	jr	Z, 00132$
	ld	hl, #(_field_action + 16)
	ld	(hl), #0xac
	ld	hl, #_field_action + 21
	ld	(hl), #0xd5
00132$:
;src/battle_view.c:331: item_line=0;item_next_line();return 1;
	xor	a, a
	ld	(#_item_line),a
	call	_item_next_line
	ld	a, #0x01
00134$:
;src/battle_view.c:332: }
	add	sp, #3
	ret
;src/battle_view.c:333: static void action_feedback(void) {
;	---------------------------------
; Function action_feedback
; ---------------------------------
_action_feedback:
	add	sp, #-5
;src/battle_view.c:334: RPGBattle *b=&battle_view_battle;
;src/battle_view.c:335: uint8_t c=character_for_message(),enemy=b->last_actor>=4u;
	call	_character_for_message
	ldhl	sp,	#4
	ld	(hl), a
	ld	a, (#(_battle_view_battle + 144) + 0)
	sub	a, #0x04
	ld	a, #0x00
	rla
	xor	a, #0x01
	ldhl	sp,	#0
	ld	(hl), a
;src/battle_view.c:337: if(b->last_effect==BATTLE_EFFECT_ATTACK||b->last_effect==BATTLE_EFFECT_MISS||b->last_effect==BATTLE_EFFECT_BLOCKED||b->last_effect==BATTLE_EFFECT_PETRIFY){
	ld	hl, #(_battle_view_battle + 160)
	ld	c, (hl)
	ld	a, c
	dec	a
	jr	Z, 00116$
	ld	a,c
	cp	a,#0x02
	jr	Z, 00116$
	cp	a,#0x03
	jr	Z, 00116$
	sub	a, #0x0a
	jr	NZ, 00117$
00116$:
;src/battle_view.c:338: if(enemy){
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00106$
;src/battle_view.c:340: if(!feedback_animated)
	ld	a, (#_feedback_animated)
	or	a, a
	jp	NZ, 00118$
;src/battle_view.c:342: audio_command(audio_enemy_effect(b->enemy_id&127u));
	ld	a, (#(_battle_view_battle + 128) + 0)
	res	7, a
	push	af
	inc	sp
	ld	e, #b_audio_enemy_effect
	ld	hl, #_audio_enemy_effect
	call	___sdcc_bcall_ehl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	jr	00118$
00106$:
;src/battle_view.c:346: if(!feedback_animated)
	ld	a, (#_feedback_animated)
	or	a, a
	jr	NZ, 00118$
;src/battle_view.c:348: audio_command(b->last_effect==BATTLE_EFFECT_MISS?0xbb:0xad);
	ld	a, c
	sub	a, #0x02
	ld	a, #0xbb
	jr	Z, 00153$
	ld	a, #0xad
00153$:
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	jr	00118$
00117$:
;src/battle_view.c:350: }else if(b->last_effect==BATTLE_EFFECT_HEAL||b->last_effect==BATTLE_EFFECT_BOOST||b->last_effect==BATTLE_EFFECT_ROPE){audio_command(enemy?0xa1:b->last_effect==BATTLE_EFFECT_HEAL?0xc1:0xab);}
	ld	a, c
	sub	a, #0x06
	ld	a, #0x01
	jr	Z, 00427$
	xor	a, a
00427$:
	ld	e, a
	or	a, a
	jr	NZ, 00111$
	ld	a,c
	cp	a,#0x07
	jr	Z, 00111$
	sub	a, #0x0c
	jr	NZ, 00112$
00111$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00154$
	ld	e, #0xa1
	jr	00155$
00154$:
	ld	a, e
	or	a, a
	ld	e, #0xc1
	jr	NZ, 00157$
	ld	e, #0xab
00157$:
00155$:
	ld	a, e
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	jr	00118$
00112$:
;src/battle_view.c:351: else if(b->last_effect==BATTLE_EFFECT_WEAKEN||b->last_effect==BATTLE_EFFECT_BARRIER)audio_command(0xab);
	ld	a,c
	cp	a,#0x0d
	jr	Z, 00108$
	sub	a, #0x0e
	jr	NZ, 00118$
00108$:
	ld	a, #0xab
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00118$:
;src/battle_view.c:352: switch(b->last_effect){
	ld	hl, #(_battle_view_battle + 160)
	ld	c, (hl)
	ld	a, #0x13
	sub	a, c
	jp	C, 00139$
	ld	b, #0x00
	ld	hl, #00434$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00434$:
	.dw	00139$
	.dw	00139$
	.dw	00125$
	.dw	00126$
	.dw	00128$
	.dw	00129$
	.dw	00130$
	.dw	00131$
	.dw	00139$
	.dw	00139$
	.dw	00135$
	.dw	00139$
	.dw	00132$
	.dw	00133$
	.dw	00134$
	.dw	00137$
	.dw	00138$
	.dw	00136$
	.dw	00127$
	.dw	00122$
;src/battle_view.c:353: case BATTLE_EFFECT_FIELD_ITEM:
00122$:
;src/battle_view.c:354: game_field_battle_item(actions[b->last_actor].id,b->last_actor);item_line=0;item_after=NEXT_STEP;
	ld	hl, #(_battle_view_battle + 144)
	ld	b, (hl)
	ld	e, b
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	ld	de, #_actions
	add	hl, de
	inc	hl
	ld	a, (hl)
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	e, #b_game_field_battle_item
	ld	hl, #_game_field_battle_item
	call	___sdcc_bcall_ehl
	pop	hl
	xor	a, a
	ld	(#_item_line),a
	ld	hl, #_item_after
	ld	(hl), #0x02
;src/battle_view.c:355: if(field_action.sound_start)audio_command(field_action.sound_start);
	ld	a, (#(_field_action + 8) + 0)
	or	a, a
	jr	Z, 00124$
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00124$:
;src/battle_view.c:356: item_next_line();break;
	call	_item_next_line
	jp	00150$
;src/battle_view.c:357: case BATTLE_EFFECT_MISS:one_line(enemy?0xb118:0xb108,0,enemy?NEXT_PHYSICAL_DEATH:NEXT_STEP,c);break;
00125$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00158$
	ld	b, #0x1d
	jr	00159$
00158$:
	ld	b, #0x02
00159$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00160$
	ld	de, #0xb118
	jr	00161$
00160$:
	ld	de, #0xb108
00161$:
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	xor	a, a
	call	_one_line
	jp	00150$
;src/battle_view.c:358: case BATTLE_EFFECT_BLOCKED:one_line(0xb1a3,0,NEXT_PHYSICAL_DEATH,c);break;
00126$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x1d
	push	hl
	xor	a, a
	ld	de, #0xb1a3
	call	_one_line
	jp	00150$
;src/battle_view.c:359: case BATTLE_EFFECT_MAGIC_BLOCKED:one_line(0xb1b2,0,NEXT_STEP,c);break;
00127$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x02
	push	hl
	xor	a, a
	ld	de, #0xb1b2
	call	_one_line
	jp	00150$
;src/battle_view.c:360: case BATTLE_EFFECT_BOUND:one_line(enemy?0xb203:0xb1fc,0,NEXT_STEP,c);break;
00128$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00162$
	ld	de, #0xb203
	jr	00163$
00162$:
	ld	de, #0xb1fc
00163$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x02
	push	hl
	xor	a, a
	call	_one_line
	jp	00150$
;src/battle_view.c:361: case BATTLE_EFFECT_RECOVERED:one_line(enemy?0xb21d:0xb20a,0,NEXT_STEP,c);break;
00129$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00164$
	ld	de, #0xb21d
	jr	00165$
00164$:
	ld	de, #0xb20a
00165$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x02
	push	hl
	xor	a, a
	call	_one_line
	jp	00150$
;src/battle_view.c:362: case BATTLE_EFFECT_HEAL:one_line(enemy?0xb1d8:0xb1d0,0,NEXT_STEP,b->last_target<4u?b->last_target:c);break;
00130$:
	ld	a, (#(_battle_view_battle + 145) + 0)
	cp	a, #0x04
	jr	NC, 00166$
	ld	c, a
	jr	00167$
00166$:
	ldhl	sp,	#4
	ld	c, (hl)
00167$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00168$
	ld	de, #0xb1d8
	jr	00169$
00168$:
	ld	de, #0xb1d0
00169$:
	ld	h, c
	ld	l, #0x02
	push	hl
	xor	a, a
	call	_one_line
	jp	00150$
;src/battle_view.c:363: case BATTLE_EFFECT_BOOST:one_line(enemy?0xbcc2:0xb22f,0,NEXT_STEP,b->last_target<4u?b->last_target:c);break;
00131$:
	ld	a, (#(_battle_view_battle + 145) + 0)
	cp	a, #0x04
	jr	NC, 00170$
	ld	c, a
	jr	00171$
00170$:
	ldhl	sp,	#4
	ld	c, (hl)
00171$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00172$
	ld	de, #0xbcc2
	jr	00173$
00172$:
	ld	de, #0xb22f
00173$:
	ld	h, c
	ld	l, #0x02
	push	hl
	xor	a, a
	call	_one_line
	jp	00150$
;src/battle_view.c:364: case BATTLE_EFFECT_ROPE:one_line(enemy?0xb1ee:0xb1e0,0,NEXT_STEP,c);break;
00132$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00174$
	ld	de, #0xb1ee
	jr	00175$
00174$:
	ld	de, #0xb1e0
00175$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x02
	push	hl
	xor	a, a
	call	_one_line
	jp	00150$
;src/battle_view.c:365: case BATTLE_EFFECT_WEAKEN:one_line(0xb24c,0,NEXT_STEP,c);break;
00133$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x02
	push	hl
	xor	a, a
	ld	de, #0xb24c
	call	_one_line
	jp	00150$
;src/battle_view.c:366: case BATTLE_EFFECT_BARRIER:one_line(0xb18b,0,NEXT_STEP,c);break;
00134$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x02
	push	hl
	xor	a, a
	ld	de, #0xb18b
	call	_one_line
	jp	00150$
;src/battle_view.c:367: case BATTLE_EFFECT_PETRIFY:one_line(0xbe93,0,NEXT_PHYSICAL_HOLD,c);break;
00135$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x1e
	push	hl
	xor	a, a
	ld	de, #0xbe93
	call	_one_line
	jp	00150$
;src/battle_view.c:368: case BATTLE_EFFECT_NO_EFFECT:one_line(!enemy && actions[b->last_actor].kind==RPG_ACT_MAGIC?0xb172:0xb2cd,0,NEXT_STEP,c);break;
00136$:
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	NZ, 00176$
	ld	hl, #(_battle_view_battle + 144)
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	de, #_actions
	add	hl, de
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00176$
	ld	de, #0xb172
	jr	00177$
00176$:
	ld	de, #0xb2cd
00177$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x02
	push	hl
	xor	a, a
	call	_one_line
	jp	00150$
;src/battle_view.c:369: case BATTLE_EFFECT_ESCAPE:one_line(0xb25f,0xbc,NEXT_DONE,c);break;
00137$:
	ldhl	sp,	#4
	ld	h, (hl)
	ld	l, #0x11
	push	hl
	ld	a, #0xbc
	ld	de, #0xb25f
	call	_one_line
	jp	00150$
;src/battle_view.c:370: case BATTLE_EFFECT_TALK:say(0xb132,NEXT_TALK_REPLY,c,0,0);break;
00138$:
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x12
	ld	de, #0xb132
	call	_say
	jp	00150$
;src/battle_view.c:371: default:
00139$:
;src/battle_view.c:372: ui_panel(96,6);if(enemy)ui_text(1,0,enemy_name);else ui_text(1,0,names[c]);
	ld	e, #0x06
	ld	a, #0x60
	call	_view_panel
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	jr	Z, 00141$
	ld	de, #_enemy_name
	push	de
	ld	e, #0x00
	ld	a, #0x01
	call	_view_text
	jr	00142$
00141$:
	ld	bc, #_names+0
	ldhl	sp,	#4
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
	ld	e, #0x00
	ld	a, #0x01
	call	_view_text
00142$:
;src/battle_view.c:373: ui_text(1,1,b->last_effect==BATTLE_EFFECT_FIRE?"FIRE":b->last_effect==BATTLE_EFFECT_THUNDER?"THUNDER":b->last_effect==BATTLE_EFFECT_WIND?"WIND":"ATTACK");
	ld	a, (#(_battle_view_battle + 160) + 0)
	cp	a, #0x08
	jr	NZ, 00181$
	ld	de, #___str_55+0
	jr	00182$
00181$:
	cp	a, #0x09
	jr	NZ, 00183$
	ld	de, #___str_56+0
	jr	00184$
00183$:
	sub	a, #0x0b
	jr	NZ, 00185$
	ld	de, #___str_57+0
	jr	00186$
00185$:
	ld	de, #___str_58+0
00186$:
00184$:
00182$:
	push	de
	ld	a,#0x01
	ld	e,a
	call	_view_text
;src/battle_view.c:374: if(b->last_target<4u){ui_text(1,4,names[b->last_target]);ui_text(7,4,"HP");ui_number(11,4,party->party[b->last_target].hp);}
	ld	a, (#(_battle_view_battle + 145) + 0)
	ldhl	sp,#4
	ld	(hl), a
	sub	a, #0x04
	jp	NC, 00147$
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
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_names
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
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	e, #0x04
	ld	a, #0x01
	call	_view_text
	ld	de, #___str_59
	push	de
	ld	e, #0x04
	ld	a, #0x07
	call	_view_text
	ld	a, (#_party)
	ldhl	sp,	#1
	ld	(hl), a
	ld	a, (#_party + 1)
	ldhl	sp,	#2
	ld	(hl), a
	ld	a, (#(_battle_view_battle + 145) + 0)
	ldhl	sp,#4
	ld	(hl), a
	swap	a
	and	a, #0xf0
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#1
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
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
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	ld	a, (de)
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
	jr	00148$
00147$:
;src/battle_view.c:375: else if(b->last_target<12u && b->enemy_id!=EnemyID_DarkFalz){ui_text(1,4,"ENEMY HP");ui_number(11,4,b->enemies[b->last_target-4u].hp);}
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x0c
	jr	NC, 00148$
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x49
	jr	Z, 00148$
	ld	de, #___str_60
	push	de
	ld	e, #0x04
	ld	a, #0x01
	call	_view_text
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
00148$:
;src/battle_view.c:377: resume(enemy?NEXT_PHYSICAL_DEATH:NEXT_STEP);break;
	ldhl	sp,	#0
	ld	a, (hl)
	or	a, a
	ld	a, #0x1d
	jr	NZ, 00188$
	ld	a, #0x02
00188$:
	call	_resume
;src/battle_view.c:378: }
00150$:
;src/battle_view.c:379: }
	add	sp, #5
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
	.ascii "HP"
	.db 0x00
___str_60:
	.ascii "ENEMY HP"
	.db 0x00
;src/battle_view.c:381: static void magic_hit_begin(void) {
;	---------------------------------
; Function magic_hit_begin
; ---------------------------------
_magic_hit_begin:
	add	sp, #-9
;src/battle_view.c:382: RPGHit *hit=battle_view_battle.hits+battle_view_hit_cursor;
	ld	hl, #_battle_view_hit_cursor
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	ld	bc, #(_battle_view_battle + 181)
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#2
	ld	(hl), a
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#3
	ld	(hl), a
;src/battle_view.c:384: if(!selection_phase.barrier_reported&&battle_view_battle.barrier_break_before==battle_view_hit_cursor+1u){
	ld	a, (#_selection_phase + 0)
	ldhl	sp,#8
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	NZ, 00102$
	ld	a, (#(_battle_view_battle + 207) + 0)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (#_battle_view_hit_cursor)
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	ld	(hl), #0x00
	pop	de
	push	de
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
	ld	(hl+), a
	inc	hl
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ldhl	sp,	#5
	ld	a, (hl+)
	inc	hl
	sub	a, (hl)
	jr	NZ, 00102$
	dec	hl
	ld	a, (hl+)
	inc	hl
	sub	a, (hl)
	jr	NZ, 00102$
;src/battle_view.c:385: selection_phase.barrier_reported=1;one_line(0xb1c1,0,NEXT_MAGIC_BEGIN,0);return;
	ld	hl, #_selection_phase
	ld	(hl), #0x01
	ld	hl, #0x1c
	push	hl
	xor	a, a
	ld	de, #0xb1c1
	call	_one_line
	jp	00106$
00102$:
;src/battle_view.c:387: boss=boss_motion_begin(&boss_motion,battle_view_battle.enemy_id,hit->target);
	ldhl	sp,	#2
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	b, a
	ld	hl, #(_battle_view_battle + 128)
	ld	c, (hl)
	push	bc
	inc	sp
	ld	a, c
	push	af
	inc	sp
	ld	de, #_boss_motion
	push	de
	ld	e, #b_boss_motion_begin
	ld	hl, #_boss_motion_begin
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#6
	ld	(hl), a
;src/battle_view.c:388: if(!boss)battle_motion_begin_magic(&enemy_motion,battle_view_battle.enemy_id);
	or	a, a
	jr	NZ, 00105$
	ld	hl, #(_battle_view_battle + 128)
	ld	b, (hl)
	push	bc
	inc	sp
	ld	de, #_enemy_motion
	push	de
	ld	e, #b_battle_motion_begin_magic
	ld	hl, #_battle_motion_begin_magic
	call	___sdcc_bcall_ehl
	add	sp, #3
00105$:
;src/battle_view.c:389: enemy_effect.active=0;magic_phase=motion_hit_hold=0;motion_last_frame=enemy_motion.frame;
	ld	hl, #(_enemy_effect + 6)
	ld	(hl), #0x00
	xor	a, a
	ld	(#_motion_hit_hold), a
	ld	(#_magic_phase),a
	ld	a, (#(_enemy_motion + 1) + 0)
	ld	(#_motion_last_frame),a
;src/battle_view.c:390: ui_panel(96,6);ui_text(1,0,enemy_name);ui_text(1,1,battle_view_battle.enemy_id==73u?"ATTACK":battle_view_battle.last_magic_mode==0x80u?"FIRE":"THUNDER");
	ld	e, #0x06
	ld	a, #0x60
	call	_view_panel
	ld	de, #_enemy_name
	push	de
	ld	e, #0x00
	ld	a, #0x01
	call	_view_text
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x49
	jr	NZ, 00108$
	ld	de, #___str_61+0
	ldhl	sp,	#7
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	jr	00109$
00108$:
	ld	a, (#(_battle_view_battle + 205) + 0)
	sub	a, #0x80
	jr	NZ, 00110$
	ld	de, #___str_62+0
	ldhl	sp,	#7
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
	jr	00111$
00110$:
	ld	de, #___str_63+0
	ldhl	sp,	#7
	ld	a, e
	ld	(hl+), a
	ld	(hl), d
00111$:
00109$:
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	a,#0x01
	ld	e,a
	call	_view_text
;src/battle_view.c:391: ui_text(1,3,names[hit->target]);ui_text(7,3,"HP");ui_number(11,3,(uint8_t)(hit->hp+hit->damage));
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (hl-)
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
	ld	hl, #_names
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
	inc	hl
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
	ld	e, #0x03
	ld	a, #0x01
	call	_view_text
	ld	de, #___str_64
	push	de
	ld	e, #0x03
	ld	a, #0x07
	call	_view_text
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	inc	bc
	ld	a, (bc)
	ld	(hl+), a
	xor	a, a
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
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
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
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#3
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, #0x0b
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/battle_view.c:392: audio_command(audio_enemy_effect(battle_view_battle.enemy_id));motion_clock=audio_clock;battle_view_state=boss?BVIEW_BOSS_ANIMATION:BVIEW_ENEMY_MAGIC;
	ld	a, (#(_battle_view_battle + 128) + 0)
	ldhl	sp,#8
	ld	(hl), a
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_audio_enemy_effect
	ld	hl, #_audio_enemy_effect
	call	___sdcc_bcall_ehl
	inc	sp
	ldhl	sp,#8
	ld	(hl), a
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, (#_audio_clock)
	ld	(#_motion_clock),a
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	ld	c, #0x13
	jr	NZ, 00113$
	ld	c, #0x10
00113$:
	ld	hl, #_battle_view_state
	ld	(hl), c
00106$:
;src/battle_view.c:393: }
	add	sp, #9
	ret
___str_61:
	.ascii "ATTACK"
	.db 0x00
___str_62:
	.ascii "FIRE"
	.db 0x00
___str_63:
	.ascii "THUNDER"
	.db 0x00
___str_64:
	.ascii "HP"
	.db 0x00
;src/battle_view.c:395: static uint8_t present_action(void) {
;	---------------------------------
; Function present_action
; ---------------------------------
_present_action:
;src/battle_view.c:399: if(core_item_feedback()||support_feedback())return 1;
	call	_core_item_feedback
	or	a, a
	jr	NZ, 00101$
	call	_support_feedback
	or	a, a
	jr	Z, 00102$
00101$:
	ld	a, #0x01
	ret
00102$:
;src/battle_view.c:400: if(!selection_phase.barrier_reported&&battle_view_battle.barrier_break_before==1u){selection_phase.barrier_reported=1;one_line(0xb1c1,0,NEXT_PRESENT_ACTION,0);return 1;}
	ld	bc, #_selection_phase+0
	ld	a, (bc)
	or	a, a
	jr	NZ, 00105$
	ld	a, (#(_battle_view_battle + 207) + 0)
	dec	a
	jr	NZ, 00105$
	ld	a, #0x01
	ld	(bc), a
	ld	hl, #0x1b
	push	hl
	xor	a, a
	ld	de, #0xb1c1
	call	_one_line
	ld	a, #0x01
	ret
00105$:
;src/battle_view.c:401: if(battle_view_battle.last_error!=RPG_OK){
	ld	a, (#(_battle_view_battle + 147) + 0)
	or	a, a
	jr	Z, 00108$
;src/battle_view.c:402: say(battle_view_battle.last_error==RPG_DEAD?0xb730:battle_view_battle.last_error==RPG_NO_MP?0xb6f7:battle_view_battle.last_error==RPG_ACTION_FAILED?0xb13d:0xbea1,NEXT_STEP,character_for_message(),0,0);return 1;
	call	_character_for_message
	ld	b, a
	ld	a, (#(_battle_view_battle + 147) + 0)
	cp	a, #0x05
	jr	NZ, 00140$
	ld	de, #0xb730
	jr	00141$
00140$:
	cp	a, #0x06
	jr	NZ, 00142$
	ld	de, #0xb6f7
	jr	00143$
00142$:
	sub	a, #0x0a
	jr	NZ, 00144$
	ld	de, #0xb13d
	jr	00145$
00144$:
	ld	de, #0xbea1
00145$:
00143$:
00141$:
	ld	hl, #0x0000
	push	hl
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, #0x02
	call	_say
	ld	a, #0x01
	ret
00108$:
;src/battle_view.c:404: if(battle_view_battle.last_effect){
	ld	a, (#(_battle_view_battle + 160) + 0)
	or	a, a
	jp	Z, 00137$
;src/battle_view.c:406: feedback_animated=0;
	xor	a, a
	ld	(#_feedback_animated),a
;src/battle_view.c:407: if(battle_view_battle.last_actor>=4u && battle_view_battle.hit_count &&
	ld	a, (#(_battle_view_battle + 144) + 0)
	sub	a, #0x04
	ld	a, #0x00
	rla
	ld	c, a
;src/battle_view.c:408: (battle_view_battle.enemy_id==72u||battle_view_battle.enemy_id==73u)){
;src/battle_view.c:407: if(battle_view_battle.last_actor>=4u && battle_view_battle.hit_count &&
	bit	0, c
	jr	NZ, 00110$
	ld	a, (#(_battle_view_battle + 180) + 0)
	or	a, a
	jr	Z, 00110$
;src/battle_view.c:408: (battle_view_battle.enemy_id==72u||battle_view_battle.enemy_id==73u)){
	ld	a, (#(_battle_view_battle + 128) + 0)
	cp	a, #0x48
	jr	Z, 00109$
	sub	a, #0x49
	jr	NZ, 00110$
00109$:
;src/battle_view.c:409: battle_view_hit_cursor=0;magic_hit_begin();return 1;
	xor	a, a
	ld	(#_battle_view_hit_cursor),a
	call	_magic_hit_begin
	ld	a, #0x01
	ret
00110$:
;src/battle_view.c:411: if(battle_view_battle.last_actor>=4u && battle_view_battle.last_magic_mode && battle_view_battle.hit_count &&
	bit	0, c
	jr	NZ, 00115$
	ld	a, (#(_battle_view_battle + 205) + 0)
	or	a, a
	jr	Z, 00115$
	ld	a, (#(_battle_view_battle + 180) + 0)
	or	a, a
	jr	Z, 00115$
;src/battle_view.c:412: battle_motion_begin_magic(&enemy_motion,battle_view_battle.enemy_id)){
	ld	hl, #(_battle_view_battle + 128)
	ld	b, (hl)
	push	bc
	inc	sp
	ld	de, #_enemy_motion
	push	de
	ld	e, #b_battle_motion_begin_magic
	ld	hl, #_battle_motion_begin_magic
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00115$
;src/battle_view.c:413: battle_view_hit_cursor=0;magic_hit_begin();return 1;
	xor	a, a
	ld	(#_battle_view_hit_cursor),a
	call	_magic_hit_begin
	ld	a, #0x01
	ret
00115$:
;src/battle_view.c:415: if(battle_view_battle.last_actor>=4u &&
	ld	a, (#(_battle_view_battle + 144) + 0)
	sub	a, #0x04
	jr	C, 00120$
;src/battle_view.c:416: (battle_view_battle.last_effect==BATTLE_EFFECT_ATTACK || battle_view_battle.last_effect==BATTLE_EFFECT_MISS || battle_view_battle.last_effect==BATTLE_EFFECT_BLOCKED || battle_view_battle.last_effect==BATTLE_EFFECT_PETRIFY) &&
	ld	a, (#(_battle_view_battle + 160) + 0)
	cp	a, #0x01
	jr	Z, 00125$
	cp	a, #0x02
	jr	Z, 00125$
	cp	a, #0x03
	jr	Z, 00125$
	sub	a, #0x0a
	jr	NZ, 00120$
00125$:
;src/battle_view.c:417: battle_motion_begin(&enemy_motion,battle_view_battle.enemy_id)) {
	ld	hl, #(_battle_view_battle + 128)
	ld	b, (hl)
	ld	de, #_enemy_motion
	push	bc
	inc	sp
	push	de
	ld	e, #b_battle_motion_begin
	ld	hl, #_battle_motion_begin
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00120$
;src/battle_view.c:418: ui_panel(96,6);ui_text(1,0,enemy_name);ui_text(1,2,"ATTACK");
	ld	e, #0x06
	ld	a, #0x60
	call	_view_panel
	ld	de, #_enemy_name
	push	de
	ld	e, #0x00
	ld	a, #0x01
	call	_view_text
	ld	de, #___str_65
	push	de
	ld	e, #0x02
	ld	a, #0x01
	call	_view_text
;src/battle_view.c:419: motion_clock=audio_clock;motion_last_frame=enemy_motion.frame;motion_hit_hold=0;
	ld	a, (#_audio_clock)
	ld	(#_motion_clock),a
	ld	a, (#(_enemy_motion + 1) + 0)
	ld	(#_motion_last_frame),a
	xor	a, a
	ld	(#_motion_hit_hold),a
;src/battle_view.c:420: audio_command(audio_enemy_effect(battle_view_battle.enemy_id));battle_view_state=BVIEW_ENEMY_ANIMATION;return 1;
	ld	a, (#(_battle_view_battle + 128) + 0)
	push	af
	inc	sp
	ld	e, #b_audio_enemy_effect
	ld	hl, #_audio_enemy_effect
	call	___sdcc_bcall_ehl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_battle_view_state
	ld	(hl), #0x0b
	ld	a, #0x01
	ret
00120$:
;src/battle_view.c:422: if(battle_view_battle.last_actor<4u && battle_view_battle.hit_count &&
	ld	hl, #(_battle_view_battle + 144)
	ld	c, (hl)
	ld	a, c
	sub	a, #0x04
	jp	NC, 00129$
	ld	a, (#(_battle_view_battle + 180) + 0)
	or	a, a
	jp	Z, 00129$
;src/battle_view.c:423: (battle_view_battle.last_effect==BATTLE_EFFECT_ATTACK || battle_view_battle.last_effect==BATTLE_EFFECT_MISS ||
	ld	hl, #(_battle_view_battle + 160)
	ld	l, (hl)
;src/battle_view.c:424: battle_view_battle.last_effect==BATTLE_EFFECT_FIRE || battle_view_battle.last_effect==BATTLE_EFFECT_THUNDER || battle_view_battle.last_effect==BATTLE_EFFECT_WIND)){
	ld	a, l
	sub	a, #0x08
	ld	a, #0x01
	jr	Z, 00406$
	xor	a, a
00406$:
	ld	d, a
	ld	a, l
	sub	a, #0x09
	ld	a, #0x01
	jr	Z, 00408$
	xor	a, a
00408$:
	ld	e, a
	ld	a, l
	sub	a, #0x0b
	ld	a, #0x01
	jr	Z, 00410$
	xor	a, a
00410$:
	ld	b, a
;src/battle_view.c:423: (battle_view_battle.last_effect==BATTLE_EFFECT_ATTACK || battle_view_battle.last_effect==BATTLE_EFFECT_MISS ||
	ld	a, l
	dec	a
	jr	Z, 00128$
	ld	a, l
	sub	a, #0x02
	jr	Z, 00128$
;src/battle_view.c:424: battle_view_battle.last_effect==BATTLE_EFFECT_FIRE || battle_view_battle.last_effect==BATTLE_EFFECT_THUNDER || battle_view_battle.last_effect==BATTLE_EFFECT_WIND)){
	ld	a, d
	or	a, a
	jr	NZ, 00128$
	or	a, e
	jr	NZ, 00128$
	or	a, b
	jp	Z, 00129$
00128$:
;src/battle_view.c:425: i=battle_view_battle.last_effect==BATTLE_EFFECT_FIRE?16u:battle_view_battle.last_effect==BATTLE_EFFECT_THUNDER?17u:battle_view_battle.last_effect==BATTLE_EFFECT_WIND?18u:party->party[battle_view_battle.last_actor].weapon;
	ld	a, d
	or	a, a
	jr	Z, 00146$
	ld	b, #0x10
	jr	00147$
00146$:
	ld	a, e
	or	a, a
	jr	Z, 00148$
	ld	b, #0x11
	jr	00149$
00148$:
	ld	a, b
	or	a, a
	jr	Z, 00150$
	ld	b, #0x12
	jr	00151$
00150$:
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	ld	a, c
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	bc, #0x000a
	add	hl, bc
	ld	a, (hl)
	ld	b, a
00151$:
00149$:
00147$:
;src/battle_view.c:426: if(battle_weapon_begin(&weapon_motion,i)){
	push	bc
	push	bc
	inc	sp
	ld	de, #_weapon_motion
	push	de
	ld	e, #b_battle_weapon_begin
	ld	hl, #_battle_weapon_begin
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	or	a, a
	jr	Z, 00129$
;src/battle_view.c:427: battle_view_hit_cursor=0;ui_panel(96,6);ui_text(1,0,names[battle_view_battle.last_actor]);
	xor	a, a
	ld	(#_battle_view_hit_cursor),a
	push	bc
	ld	e, #0x06
	ld	a, #0x60
	call	_view_panel
	pop	bc
	ld	hl, #(_battle_view_battle + 144)
	ld	l, (hl)
	ld	h, #0x00
	add	hl, hl
	ld	de, #_names
	add	hl, de
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	push	bc
	push	hl
	ld	e, #0x00
	ld	a, #0x01
	call	_view_text
	pop	bc
;src/battle_view.c:428: ui_text(1,1,i==16u?"FIRE":i==17u?"THUNDER":i==18u?"WIND":"ATTACK");
	ld	a, b
	sub	a, #0x10
	jr	NZ, 00152$
	ld	bc, #___str_66+0
	jr	00153$
00152$:
	ld	a, b
	sub	a, #0x11
	jr	NZ, 00154$
	ld	bc, #___str_67+0
	jr	00155$
00154$:
	ld	a, b
	sub	a, #0x12
	jr	NZ, 00156$
	ld	bc, #___str_68+0
	jr	00157$
00156$:
	ld	bc, #___str_65+0
00157$:
00155$:
00153$:
	push	bc
	ld	a,#0x01
	ld	e,a
	call	_view_text
;src/battle_view.c:429: motion_clock=audio_clock;battle_view_state=BVIEW_PLAYER_WEAPON;return 1;
	ld	a, (#_audio_clock)
	ld	(#_motion_clock),a
	ld	hl, #_battle_view_state
	ld	(hl), #0x0f
	ld	a, #0x01
	ret
00129$:
;src/battle_view.c:433: action_feedback();return 1;
	call	_action_feedback
	ld	a, #0x01
	ret
00137$:
;src/battle_view.c:435: return 0;
	xor	a, a
;src/battle_view.c:436: }
	ret
___str_65:
	.ascii "ATTACK"
	.db 0x00
___str_66:
	.ascii "FIRE"
	.db 0x00
___str_67:
	.ascii "THUNDER"
	.db 0x00
___str_68:
	.ascii "WIND"
	.db 0x00
;src/battle_view.c:437: static void execute_step(void) {
;	---------------------------------
; Function execute_step
; ---------------------------------
_execute_step:
	add	sp, #-4
;src/battle_view.c:439: while(safety--){
	ldhl	sp,	#2
	ld	(hl), #0x0c
00117$:
	ldhl	sp,	#2
	ld	c, (hl)
	dec	(hl)
	ld	a, c
	or	a, a
	jp	Z, 00124$
;src/battle_view.c:440: if(battle_view_battle.outcome!=RPG_ONGOING){result_screen();return;}
	ld	a, (#(_battle_view_battle + 130) + 0)
	or	a, a
	jr	Z, 00102$
	call	_result_screen
	jp	00124$
00102$:
;src/battle_view.c:441: if(battle_view_battle.turn_cursor>=12u){new_round();return;}
	ld	a, (#(_battle_view_battle + 159) + 0)
	sub	a, #0x0c
	jr	C, 00133$
	call	_new_round
	jp	00124$
;src/battle_view.c:442: for(i=0;i<4u;++i)previous_alive[i]=(party->party[i].status&1u)&&party->party[i].hp;
00133$:
	ldhl	sp,	#3
	ld	(hl), #0x00
00120$:
	ld	de, #_previous_alive
	ldhl	sp,	#3
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (_party)
	ld	hl, #_party + 1
	ld	b, (hl)
	push	af
	ldhl	sp,	#5
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	c, a
	pop	af
	ld	l, a
	ld	h, b
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	and	a, #0x01
	jr	Z, 00126$
	ld	hl, #_party
	ld	a, (hl+)
	add	a, c
	ld	c, a
	ld	a, (hl)
	adc	a, #0x00
	ld	b, a
	inc	bc
	ld	a, (bc)
	or	a, a
	jr	NZ, 00127$
00126$:
	xor	a, a
	jr	00128$
00127$:
	ld	a, #0x01
00128$:
	ld	(de), a
	ldhl	sp,	#3
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00120$
;src/battle_view.c:443: rpg_battle_step(party,&battle_view_battle);selection_phase.barrier_reported=0;
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_step
	ld	hl, #_rpg_battle_step
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	hl, #_selection_phase
	ld	(hl), #0x00
;src/battle_view.c:444: for(i=0;i<4u;++i)if(previous_alive[i]&&!party->party[i].hp && battle_view_battle.last_effect!=BATTLE_EFFECT_PETRIFY)deaths_pending|=1u<<i;
	ldhl	sp,	#3
	ld	(hl), #0x00
00122$:
	ld	de, #_previous_alive
	ldhl	sp,	#3
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00123$
	ld	a, (#_party)
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (#_party + 1)
	ldhl	sp,	#1
	ld	(hl+), a
	inc	hl
	ld	a, (hl)
	swap	a
	and	a, #0xf0
	ld	e, a
	ld	d, #0x00
	pop	hl
	push	hl
	add	hl, de
	inc	hl
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00123$
	ld	a, (#(_battle_view_battle + 160) + 0)
	sub	a, #0x0a
	jr	Z, 00123$
	ldhl	sp,	#3
	ld	b, (hl)
	ld	a, #0x01
	inc	b
	jr	00245$
00244$:
	add	a, a
00245$:
	dec	b
	jr	NZ,00244$
	ld	hl, #_deaths_pending
	or	a, (hl)
	ld	(hl), a
00123$:
	ldhl	sp,	#3
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00122$
;src/battle_view.c:445: if(battle_view_battle.enemy_id==EnemyID_GdDragn && (deaths_pending&2u) && battle_view_battle.outcome==RPG_DEFEAT)dragon_fall=1;
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x46
	jr	NZ, 00112$
	ld	a, (_deaths_pending)
	bit	1, a
	jr	Z, 00112$
	ld	a, (#(_battle_view_battle + 130) + 0)
	sub	a, #0x02
	jr	NZ, 00112$
	ld	hl, #_dragon_fall
	ld	(hl), #0x01
00112$:
;src/battle_view.c:446: if(present_action())return;
	call	_present_action
	or	a, a
	jp	Z, 00117$
00124$:
;src/battle_view.c:448: }
	add	sp, #4
	ret
;src/battle_view.c:449: static void resume(uint8_t next) {
;	---------------------------------
; Function resume
; ---------------------------------
_resume:
	dec	sp
	ld	c, a
;src/battle_view.c:451: RPGBattle *b=&battle_view_battle;
;src/battle_view.c:452: switch(next){
	ld	a, #0x23
	sub	a, c
	jp	C, 00216$
	ld	b, #0x00
	ld	hl, #00462$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00462$:
	.dw	00216$
	.dw	00101$
	.dw	00108$
	.dw	00129$
	.dw	00235$
	.dw	00137$
	.dw	00143$
	.dw	00148$
	.dw	00152$
	.dw	00153$
	.dw	00154$
	.dw	00158$
	.dw	00162$
	.dw	00169$
	.dw	00170$
	.dw	00171$
	.dw	00172$
	.dw	00192$
	.dw	00176$
	.dw	00177$
	.dw	00178$
	.dw	00179$
	.dw	00180$
	.dw	00181$
	.dw	00188$
	.dw	00183$
	.dw	00187$
	.dw	00118$
	.dw	00182$
	.dw	00121$
	.dw	00128$
	.dw	00196$
	.dw	00203$
	.dw	00197$
	.dw	00198$
	.dw	00191$
;src/battle_view.c:453: case NEXT_CHOOSE:
00101$:
;src/battle_view.c:454: if(battle_view_actor>=4u)battle_view_actor=0;
	ld	hl, #_battle_view_actor
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00105$
	ld	(hl), #0x00
;src/battle_view.c:455: while(battle_view_actor<3u && !eligible(battle_view_actor))++battle_view_actor;
00105$:
	ld	hl, #_battle_view_actor
	ld	a, (hl)
	sub	a, #0x03
	jr	NC, 00107$
	ld	a, (hl)
	call	_eligible
	or	a, a
	jr	NZ, 00107$
	ld	hl, #_battle_view_actor
	inc	(hl)
	jr	00105$
00107$:
;src/battle_view.c:456: battle_view_choice=0;command_screen();break;
	xor	a, a
	ld	(#_battle_view_choice),a
	inc	sp
	jp	_command_screen
	jp	00216$
;src/battle_view.c:457: case NEXT_STEP:
00108$:
;src/battle_view.c:458: if(deaths_pending){for(i=0;i<4u;++i)if(deaths_pending&(1u<<i))break;deaths_pending&=~(1u<<i);say(0xb728,NEXT_STEP,i,0,0);}
	ld	a, (#_deaths_pending)
	or	a, a
	jr	Z, 00116$
	ld	c, #0x00
00212$:
	ld	a, c
	push	af
	ld	hl, #0x0001
	pop	af
	inc	a
	jr	00464$
00463$:
	add	hl, hl
00464$:
	dec	a
	jr	NZ,00463$
	ld	a, (_deaths_pending)
	and	a, l
	ld	b, #0x00
	or	a, b
	jr	NZ, 00111$
	inc	c
	ld	a, c
	sub	a, #0x04
	jr	C, 00212$
00111$:
	ld	b, c
	ld	a, #0x01
	inc	b
	jr	00466$
00465$:
	add	a, a
00466$:
	dec	b
	jr	NZ,00465$
	cpl
	ld	hl, #_deaths_pending
	and	a, (hl)
	ld	(hl), a
	ld	de, #0x0000
	push	de
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x02
	ld	de, #0xb728
	call	_say
	jp	00216$
00116$:
;src/battle_view.c:459: else if(dragon_fall){dragon_fall=0;say(0xbf3b,NEXT_STEP,1,0,0);}
	ld	hl, #_dragon_fall
	ld	a, (hl)
	or	a, a
	jr	Z, 00113$
	ld	de, #0x0000
	ld	(hl), e
	push	de
	ld	hl, #0x01
	push	hl
	ld	a, #0x02
	ld	de, #0xbf3b
	call	_say
	jp	00216$
00113$:
;src/battle_view.c:460: else{battle_view_state=BVIEW_EXECUTE;execute_step();}break;
	ld	hl, #_battle_view_state
	ld	(hl), #0x08
	inc	sp
	jp	_execute_step
	jp	00216$
;src/battle_view.c:461: case NEXT_PRESENT_ACTION:
00118$:
;src/battle_view.c:462: if(!present_action())resume(NEXT_STEP);break;
	call	_present_action
	or	a, a
	jp	NZ, 00216$
	ld	a, #0x02
	inc	sp
	jp	_resume
	jp	00216$
;src/battle_view.c:463: case NEXT_PHYSICAL_DEATH:
00121$:
;src/battle_view.c:464: i=b->last_target;
	ld	hl, #_battle_view_battle + 145
	ld	c, (hl)
;src/battle_view.c:465: if(i<4u&&(deaths_pending&(1u<<i))){
	ld	a,c
	cp	a,#0x04
	jr	NC, 00125$
	push	af
	ld	hl, #0x0001
	pop	af
	inc	a
	jr	00468$
00467$:
	add	hl, hl
00468$:
	dec	a
	jr	NZ,00467$
	ld	a, (_deaths_pending)
	ld	e, a
	ld	d, #0x00
	ld	a, l
	and	a, e
	ld	b, #0x00
	or	a, b
	jr	Z, 00125$
;src/battle_view.c:466: deaths_pending&=~(1u<<i);memset(&field_action,0,sizeof field_action);
	ld	b, c
	ld	a, #0x01
	inc	b
	jr	00470$
00469$:
	add	a, a
00470$:
	dec	b
	jr	NZ,00469$
	cpl
	ld	hl, #_deaths_pending
	and	a, (hl)
	ld	(hl), a
	ld	de, #0x0016
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_field_action
	push	de
	call	_memset
	add	sp, #6
;src/battle_view.c:467: field_action.character=i;field_action.lines[0].dialogue=0xb728;field_action.line_count=1;
	ld	hl, #(_field_action + 4)
	ld	(hl), c
	ld	hl, #(_field_action + 10)
	ld	a, #0x28
	ld	(hl+), a
	ld	(hl), #0xb7
	ld	bc, #_field_action + 2
	ld	a, #0x01
	ld	(bc), a
;src/battle_view.c:468: if(dragon_fall){dragon_fall=0;field_action.lines[1].dialogue=0xbf3b;field_action.line_count=2;}
	ld	hl, #_dragon_fall
	ld	a, (hl)
	or	a, a
	jr	Z, 00123$
	ld	(hl), #0x00
	ld	hl, #(_field_action + 14)
	ld	a, #0x3b
	ld	(hl+), a
	ld	(hl), #0xbf
	ld	a, #0x02
	ld	(bc), a
00123$:
;src/battle_view.c:469: item_line=0;item_after=NEXT_PHYSICAL_HOLD;item_next_line();
	xor	a, a
	ld	(#_item_line),a
	ld	hl, #_item_after
	ld	(hl), #0x1e
	inc	sp
	jp	_item_next_line
	jp	00216$
00125$:
;src/battle_view.c:470: }else resume(NEXT_PHYSICAL_HOLD);break;
	ld	a, #0x1e
	inc	sp
	jp	_resume
	jp	00216$
;src/battle_view.c:471: case NEXT_PHYSICAL_HOLD:close_delay(4u,NEXT_STEP);break;
00128$:
	ld	e, #0x02
	ld	a, #0x04
	inc	sp
	jp	_close_delay
	jp	00216$
;src/battle_view.c:472: case NEXT_RESULT:result_screen();break;
00129$:
	inc	sp
	jp	_result_screen
	jp	00216$
;src/battle_view.c:474: for(i=0;i<4u;++i){old_battle_magic[i]=party->party[i].battle_magic_count;old_map_magic[i]=party->party[i].map_magic_count;}
00235$:
	ldhl	sp,	#0
	ld	(hl), #0x00
00214$:
	ld	de, #_old_battle_magic
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (_party)
	ld	hl, #_party + 1
	ld	b, (hl)
	push	af
	ldhl	sp,	#2
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
	ldhl	sp,	#0
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
	ldhl	sp,	#0
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x04
	jr	C, 00214$
;src/battle_view.c:475: rpg_claim_rewards(party,b);level_cursor=0;
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
;src/battle_view.c:476: if(b->exp_reward)say(0xb604,NEXT_LEVEL,0,0,b->exp_reward);else resume(NEXT_CHEST);
	ld	hl, #(_battle_view_battle + 148)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, b
	or	a, c
	jr	Z, 00133$
	push	bc
	xor	a, a
	rrca
	push	af
	ld	a, #0x05
	ld	de, #0xb604
	call	_say
	jp	00216$
00133$:
	ld	a, #0x07
	inc	sp
	jp	_resume
;src/battle_view.c:477: break;
	jp	00216$
;src/battle_view.c:479: while(level_cursor<4u && !(b->leveled_mask&(1u<<level_cursor)))++level_cursor;
00137$:
	ld	hl, #_level_cursor
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00139$
	ld	a, (#(_battle_view_battle + 166) + 0)
	ld	b, (hl)
	ld	de, #0x0001
	inc	b
	jr	00472$
00471$:
	sla	e
	rl	d
00472$:
	dec	b
	jr	NZ,00471$
	and	a, e
	ld	c, #0x00
	or	a, c
	jr	NZ, 00139$
	inc	(hl)
	jr	00137$
00139$:
;src/battle_view.c:480: if(level_cursor<4u){audio_command(0xba);say(0xb621,NEXT_LEARNED,level_cursor,0,0);}else resume(NEXT_CHEST);
	ld	a, (#_level_cursor)
	sub	a, #0x04
	jr	NC, 00141$
	ld	a, #0xba
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_level_cursor)
	push	af
	inc	sp
	ld	a, #0x06
	ld	de, #0xb621
	call	_say
	jp	00216$
00141$:
	ld	a, #0x07
	inc	sp
	jp	_resume
;src/battle_view.c:481: break;
	jp	00216$
;src/battle_view.c:482: case NEXT_LEARNED:
00143$:
;src/battle_view.c:483: i=level_cursor++;
	ld	a, (_level_cursor)
	ld	c, a
	ld	hl, #_level_cursor
	inc	(hl)
;src/battle_view.c:484: if(old_battle_magic[i]!=party->party[i].battle_magic_count || old_map_magic[i]!=party->party[i].map_magic_count)say(0xb635,NEXT_LEVEL,i,0,0);
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
	jr	NZ, 00144$
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
	jr	Z, 00145$
00144$:
	ld	de, #0x0000
	push	de
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x05
	ld	de, #0xb635
	call	_say
	jp	00216$
00145$:
;src/battle_view.c:485: else resume(NEXT_LEVEL);break;
	ld	a, #0x05
	inc	sp
	jp	_resume
	jp	00216$
;src/battle_view.c:486: case NEXT_CHEST:if(b->chest_state==BATTLE_CHEST_PENDING){battle_view_chest_pending=1;rpg_battle_prepare_chest(party,b);chest_pose(0x3a);say(0xbce1,NEXT_ASK_CHEST,0,0,0);}else resume(NEXT_DONE);break;
00148$:
	ld	a, (#(_battle_view_battle + 162) + 0)
	dec	a
	jr	NZ, 00150$
	ld	hl, #_battle_view_chest_pending
	ld	(hl), #0x01
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_prepare_chest
	ld	hl, #_rpg_battle_prepare_chest
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	a, #0x3a
	call	_chest_pose
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x08
	ld	de, #0xbce1
	call	_say
	jp	00216$
00150$:
	ld	a, #0x11
	inc	sp
	jp	_resume
	jp	00216$
;src/battle_view.c:487: case NEXT_ASK_CHEST:say(0xb656,NEXT_PROMPT_CHEST,0,0,0);break;
00152$:
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x09
	ld	de, #0xb656
	call	_say
	jp	00216$
;src/battle_view.c:488: case NEXT_PROMPT_CHEST:prompt(PROMPT_CHEST);break;
00153$:
	ld	a, #0x01
	inc	sp
	jp	_prompt
	jp	00216$
;src/battle_view.c:489: case NEXT_MONEY:
00154$:
;src/battle_view.c:490: if(b->money_reward)say(0xb648,NEXT_FOUND,0,0,b->money_reward);else resume(NEXT_FOUND);break;
	ld	hl, #(_battle_view_battle + 150)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	a, b
	or	a, c
	jr	Z, 00156$
	push	bc
	xor	a, a
	rrca
	push	af
	ld	a, #0x0b
	ld	de, #0xb648
	call	_say
	jp	00216$
00156$:
	ld	a, #0x0b
	inc	sp
	jp	_resume
	jp	00216$
;src/battle_view.c:491: case NEXT_FOUND:if(b->item_reward)say(0xb592,NEXT_GIFT,0,b->item_reward,0);else resume(NEXT_CHEST_CLOSE);break;
00158$:
	ld	a, (#(_battle_view_battle + 152) + 0)
	or	a, a
	jr	Z, 00160$
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x0c
	ld	de, #0xb592
	call	_say
	jp	00216$
00160$:
	ld	a, #0x23
	inc	sp
	jp	_resume
	jp	00216$
;src/battle_view.c:492: case NEXT_GIFT:
00162$:
;src/battle_view.c:494: result=rpg_battle_open_chest(party,b);
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
;src/battle_view.c:495: if(result==RPG_FULL)say(0xb671,NEXT_PROMPT_FULL,0,b->item_pending,0);
	cp	a, #0x02
	jr	NZ, 00167$
	ld	a, (#(_battle_view_battle + 164) + 0)
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x0d
	ld	de, #0xb671
	call	_say
	jp	00216$
00167$:
;src/battle_view.c:496: else if(result==RPG_OK){audio_command(0xb3);resume(NEXT_CHEST_CLOSE);}
	or	a, a
	jr	NZ, 00164$
	ld	a, #0xb3
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x23
	inc	sp
	jp	_resume
	jp	00216$
00164$:
;src/battle_view.c:497: else literal("CHEST UNAVAILABLE","",NEXT_CHEST_CLOSE);
	ld	a, #0x23
	push	af
	inc	sp
	ld	bc, #___str_70
	ld	de, #___str_69
	call	_literal
;src/battle_view.c:498: break;
	jp	00216$
;src/battle_view.c:499: case NEXT_PROMPT_FULL:prompt(PROMPT_FULL);break;
00169$:
	ld	a, #0x02
	inc	sp
	jp	_prompt
	jp	00216$
;src/battle_view.c:500: case NEXT_PROMPT_ABANDON:prompt(PROMPT_ABANDON);break;
00170$:
	ld	a, #0x03
	inc	sp
	jp	_prompt
	jp	00216$
;src/battle_view.c:501: case NEXT_REPLACE:battle_view_choice=0;item_screen(1);break;
00171$:
	xor	a, a
	ld	(#_battle_view_choice),a
	ld	a, #0x01
	inc	sp
	jp	_item_screen
	jp	00216$
;src/battle_view.c:502: case NEXT_APPLY_REPLACE:
00172$:
;src/battle_view.c:503: result=rpg_battle_replace_reward(party,b,replacement_slot);
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
;src/battle_view.c:504: if(result==RPG_OK){audio_command(0xb3);say(0xb6ad,NEXT_CHEST_CLOSE,0,b->item_reward,0);}else resume(NEXT_REPLACE);
	or	a, a
	jr	NZ, 00174$
	ld	a, #0xb3
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, (#(_battle_view_battle + 152) + 0)
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x23
	ld	de, #0xb6ad
	call	_say
	jp	00216$
00174$:
	ld	a, #0x0f
	inc	sp
	jp	_resume
;src/battle_view.c:505: break;
	jp	00216$
;src/battle_view.c:506: case NEXT_TALK_REPLY:say(talk_texts[b->talk_index<19u?b->talk_index:0u],NEXT_DONE,character_for_message(),0,0);break;
00176$:
	call	_character_for_message
	ldhl	sp,	#0
	ld	(hl), a
	ld	a, (#(_battle_view_battle + 161) + 0)
	cp	a, #0x13
	jr	NC, 00218$
	ld	e, a
	ld	d, #0x00
	jr	00219$
00218$:
	ld	de, #0x0000
00219$:
	ld	l, e
	ld	h, d
	add	hl, hl
	ld	de, #_talk_texts
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ldhl	sp,	#3
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x11
	ld	e, c
	ld	d, b
	call	_say
	jp	00216$
;src/battle_view.c:507: case NEXT_DEFEAT:say(0xbd23,NEXT_DONE,0,0,0);break;
00177$:
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x11
	ld	de, #0xbd23
	call	_say
	jp	00216$
;src/battle_view.c:508: case NEXT_SPELLS:spell_screen();break;
00178$:
	inc	sp
	jp	_spell_screen
	jp	00216$
;src/battle_view.c:509: case NEXT_ITEMS:item_screen(0);break;
00179$:
	xor	a, a
	inc	sp
	jp	_item_screen
	jp	00216$
;src/battle_view.c:510: case NEXT_TARGET:target_screen();break;
00180$:
	inc	sp
	jp	_target_screen
	jp	00216$
;src/battle_view.c:511: case NEXT_BEGIN_TALK:start_resolution();break;
00181$:
	inc	sp
	jp	_start_resolution
	jp	00216$
;src/battle_view.c:513: case NEXT_MAGIC_BEGIN:magic_hit_begin();break;
00182$:
	inc	sp
	jp	_magic_hit_begin
	jp	00216$
;src/battle_view.c:514: case NEXT_MAGIC_DEATH:
00183$:
;src/battle_view.c:515: i=b->hits[battle_view_hit_cursor].target;
	ld	a, (#_battle_view_hit_cursor)
	ld	c, a
	add	a, a
	add	a, c
	ld	l, a
	ld	h, #0x00
	ld	de, #(_battle_view_battle + 181)
	add	hl, de
;src/battle_view.c:516: if(!b->hits[battle_view_hit_cursor].hp){deaths_pending&=~(1u<<i);one_line(0xb728,0,NEXT_MAGIC_HOLD,i);}
	ld	a, (hl+)
	inc	hl
	ld	b, a
	ld	a, (hl)
	or	a, a
	jr	NZ, 00185$
	ld	c, b
	ld	a, #0x01
	inc	c
	jr	00481$
00480$:
	add	a, a
00481$:
	dec	c
	jr	NZ,00480$
	cpl
	ld	hl, #_deaths_pending
	and	a, (hl)
	ld	(hl), a
	ld	c, #0x1a
	push	bc
	xor	a, a
	ld	de, #0xb728
	call	_one_line
	jp	00216$
00185$:
;src/battle_view.c:517: else resume(NEXT_MAGIC_HOLD);break;
	ld	a, #0x1a
	inc	sp
	jp	_resume
	jp	00216$
;src/battle_view.c:518: case NEXT_MAGIC_HOLD:
00187$:
;src/battle_view.c:519: motion_hit_hold=4;motion_clock=audio_clock;battle_view_state=BVIEW_ENEMY_MAGIC_HOLD;break;
	ld	hl, #_motion_hit_hold
	ld	(hl), #0x04
	ld	a, (#_audio_clock)
	ld	(#_motion_clock),a
	ld	hl, #_battle_view_state
	ld	(hl), #0x11
	jp	00216$
;src/battle_view.c:521: case NEXT_ITEM_LINE:
00188$:
;src/battle_view.c:522: if(field_action.lines[item_line].sound_after)audio_command(field_action.lines[item_line].sound_after);
	ld	a, (#_item_line)
	add	a, a
	add	a, a
	ld	l, a
	ld	h, #0x00
	ld	de, #(_field_action + 10)
	add	hl, de
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00190$
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00190$:
;src/battle_view.c:523: ++item_line;item_next_line();break;
	ld	hl, #_item_line
	inc	(hl)
	inc	sp
	jp	_item_next_line
	jp	00216$
;src/battle_view.c:524: case NEXT_CHEST_CLOSE:
00191$:
;src/battle_view.c:529: HIDE_WIN;HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/battle_view.c:531: close_delay(6u,NEXT_DONE);break;
	ld	e, #0x11
	ld	a, #0x06
	inc	sp
	jp	_close_delay
	jp	00216$
;src/battle_view.c:532: case NEXT_DONE:
00192$:
;src/battle_view.c:533: if(b->outcome==RPG_ESCAPED||b->outcome==RPG_TALKED){
	ld	a, (#(_battle_view_battle + 130) + 0)
	cp	a, #0x03
	jr	Z, 00193$
	sub	a, #0x04
	jr	NZ, 00194$
00193$:
;src/battle_view.c:536: close_delay(b->enemy_id==EnemyID_DarkFalz?4u:14u,NEXT_HIDE_RETURN);break;
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x49
	ld	a, #0x04
	jr	Z, 00221$
	ld	a, #0x0e
00221$:
	ld	e, #0x1f
	inc	sp
	jp	_close_delay
	jp	00216$
00194$:
;src/battle_view.c:538: resume(NEXT_RETURN);break;
	ld	a, #0x20
	inc	sp
	jp	_resume
	jp	00216$
;src/battle_view.c:539: case NEXT_HIDE_RETURN:
00196$:
;src/battle_view.c:541: DISPLAY_OFF;HIDE_WIN;battle_scene_clear();DISPLAY_ON;
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ld	e, #b_battle_scene_clear
	ld	hl, #_battle_scene_clear
	call	___sdcc_bcall_ehl
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/battle_view.c:543: close_delay(1u,NEXT_RETURN);break;
	ld	e, #0x20
	ld	a, #0x01
	inc	sp
	jp	_close_delay
	jp	00216$
;src/battle_view.c:544: case NEXT_VICTORY_CLEAR:
00197$:
;src/battle_view.c:546: DISPLAY_OFF;HIDE_WIN;battle_scene_clear();DISPLAY_ON;
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ld	e, #b_battle_scene_clear
	ld	hl, #_battle_scene_clear
	call	___sdcc_bcall_ehl
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/battle_view.c:548: close_delay(1u,NEXT_VICTORY_UPLOAD);break;
	ld	e, #0x22
	ld	a, #0x01
	inc	sp
	jp	_close_delay
	jr	00216$
;src/battle_view.c:549: case NEXT_VICTORY_UPLOAD:
00198$:
;src/battle_view.c:550: if(b->enemy_id==EnemyID_Lassic||b->enemy_id==EnemyID_DarkFalz){audio_delay_start=audio_clock;audio_delay_frames=180u;battle_view_state=BVIEW_AUDIO_WAIT;}
	ld	a, (#(_battle_view_battle + 128) + 0)
	cp	a, #0x48
	jr	Z, 00199$
	sub	a, #0x49
	jr	NZ, 00200$
00199$:
	ld	a, (#_audio_clock)
	ld	(#_audio_delay_start),a
	ld	hl, #_audio_delay_frames
	ld	(hl), #0xb4
	ld	hl, #_battle_view_state
	ld	(hl), #0x0a
	jr	00216$
00200$:
;src/battle_view.c:551: else{audio_command(0xd8);say(0xb71b,NEXT_REWARDS,0,0,0);}break;
	ld	a, #0xd8
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x04
	ld	de, #0xb71b
	call	_say
	jr	00216$
;src/battle_view.c:552: case NEXT_RETURN:
00203$:
;src/battle_view.c:554: battle_scene_hide();
	ld	e, #b_battle_scene_hide
	ld	hl, #_battle_scene_hide
	call	___sdcc_bcall_ehl
;src/battle_view.c:556: if(b->outcome==RPG_ESCAPED||b->outcome==RPG_TALKED)audio_command(0xd8);
	ld	a, (#(_battle_view_battle + 130) + 0)
	cp	a, #0x03
	jr	Z, 00204$
	sub	a, #0x04
	jr	NZ, 00205$
00204$:
	ld	a, #0xd8
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00205$:
;src/battle_view.c:557: if(battle_view_field_menu_pending){battle_view_state=BVIEW_CHEST_MENU;battle_view_result=BATTLE_VIEW_MENU;}
	ld	a, (#_battle_view_field_menu_pending)
	or	a, a
	jr	Z, 00208$
	ld	hl, #_battle_view_state
	ld	(hl), #0x0c
	ld	hl, #_battle_view_result
	ld	(hl), #0xfe
	jr	00216$
00208$:
;src/battle_view.c:558: else{battle_view_state=BVIEW_DONE;battle_view_result=b->outcome;}break;
	ld	hl, #_battle_view_state
	ld	(hl), #0x09
	ld	a, (#(_battle_view_battle + 130) + 0)
	ld	(#_battle_view_result),a
;src/battle_view.c:560: }
00216$:
;src/battle_view.c:561: }
	inc	sp
	ret
___str_69:
	.ascii "CHEST UNAVAILABLE"
	.db 0x00
___str_70:
	.db 0x00
;src/battle_view.c:562: uint8_t battle_view_begin(RPGState *state,uint8_t enemy) RPG_BANKED {
;	---------------------------------
; Function battle_view_begin
; ---------------------------------
	b_battle_view_begin	= 30
_battle_view_begin::
;src/battle_view.c:564: party=state;battle_view_result=0;battle_view_dialogue_id=0;battle_view_text_revealing=0;battle_view_hit_cursor=0;deaths_pending=0;dragon_fall=0;battle_view_chest_pending=0;battle_view_field_menu_pending=0;battle_view_menu_allowed=1;
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
	xor	a, a
	ld	(#_battle_view_text_revealing), a
	ld	(#_battle_view_hit_cursor),a
	xor	a, a
	ld	(#_deaths_pending), a
	ld	(#_dragon_fall),a
	xor	a, a
	ld	(#_battle_view_chest_pending), a
	ld	(#_battle_view_field_menu_pending),a
	ld	hl, #_battle_view_menu_allowed
	ld	(hl), #0x01
;src/battle_view.c:565: error=rpg_battle_begin(party,&battle_view_battle,enemy);if(error)return error;
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
;src/battle_view.c:566: track=audio_battle_track(enemy);if(track)audio_command(track);
	ldhl	sp,	#8
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_audio_battle_track
	ld	hl, #_audio_battle_track
	call	___sdcc_bcall_ehl
	inc	sp
	ld	b, a
	or	a, a
	jr	Z, 00104$
	push	bc
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00104$:
;src/battle_view.c:567: rpg_enemy_name(enemy&127u,enemy_name);
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
;src/battle_view.c:569: DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;battle_scene_begin(enemy&127u);DISPLAY_ON;
	call	_display_off
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	push	bc
	inc	sp
	ld	e, #b_battle_scene_begin
	ld	hl, #_battle_scene_begin
	call	___sdcc_bcall_ehl
	inc	sp
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/battle_view.c:571: new_round();return RPG_OK;
	call	_new_round
	xor	a, a
;src/battle_view.c:572: }
	ret
;src/battle_view.c:573: void battle_view_chest_begin(RPGState *state,uint8_t item,uint16_t money,uint8_t trap) RPG_BANKED {
;	---------------------------------
; Function battle_view_chest_begin
; ---------------------------------
	b_battle_view_chest_begin	= 30
_battle_view_chest_begin::
;src/battle_view.c:574: party=state;battle_view_result=0;battle_view_dialogue_id=0;battle_view_text_revealing=0;battle_view_hit_cursor=0;deaths_pending=0;dragon_fall=0;
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
	xor	a, a
	ld	(#_battle_view_text_revealing), a
	ld	(#_battle_view_hit_cursor),a
	xor	a, a
	ld	(#_deaths_pending), a
	ld	(#_dragon_fall),a
;src/battle_view.c:575: battle_view_field_menu_pending=0;battle_view_menu_allowed=1;
	xor	a, a
	ld	(#_battle_view_field_menu_pending),a
	ld	hl, #_battle_view_menu_allowed
	ld	(hl), #0x01
;src/battle_view.c:576: memset(&battle_view_battle,0,sizeof(battle_view_battle));
	xor	a, a
	scf
	push	af
	ld	de, #0x0000
	push	de
	ld	de, #_battle_view_battle
	push	de
	call	_memset
	add	sp, #6
;src/battle_view.c:577: battle_view_battle.outcome=RPG_VICTORY;battle_view_battle.rewards_claimed=1;
	ld	hl, #_battle_view_battle + 130
	ld	(hl), #0x01
	ld	hl, #_battle_view_battle + 154
	ld	(hl), #0x01
;src/battle_view.c:578: battle_view_battle.exp_claimed=1;battle_view_battle.chest_state=BATTLE_CHEST_PENDING;
	ld	hl, #_battle_view_battle + 165
	ld	(hl), #0x01
	ld	hl, #_battle_view_battle + 162
	ld	(hl), #0x01
;src/battle_view.c:579: battle_view_battle.item_reward=item;battle_view_battle.money_reward=money;battle_view_battle.trap_chance=trap;
	ld	de, #(_battle_view_battle + 152)
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	(de), a
	ld	de, #(_battle_view_battle + 150)
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl+)
	ld	(de), a
	ld	de, #(_battle_view_battle + 153)
	ld	a, (hl)
	ld	(de), a
;src/battle_view.c:580: rpg_battle_prepare_chest(party,&battle_view_battle);battle_view_chest_pending=1;
	ld	de, #_battle_view_battle
	push	de
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	push	de
	ld	e, #b_rpg_battle_prepare_chest
	ld	hl, #_rpg_battle_prepare_chest
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	hl, #_battle_view_chest_pending
	ld	(hl), #0x01
;src/battle_view.c:581: chest_pose(0x3a);
	ld	a, #0x3a
	call	_chest_pose
;src/battle_view.c:582: say(0xbd97,NEXT_ASK_CHEST,0,0,0);
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x08
	ld	de, #0xbd97
	call	_say
;src/battle_view.c:583: }
	ret
;src/battle_view.c:584: void battle_view_chest_prompt(uint8_t search) RPG_BANKED {
;	---------------------------------
; Function battle_view_chest_prompt
; ---------------------------------
	b_battle_view_chest_prompt	= 30
_battle_view_chest_prompt::
;src/battle_view.c:585: if(!battle_view_chest_pending)return;
	ld	a, (#_battle_view_chest_pending)
	or	a, a
	ret	Z
;src/battle_view.c:586: battle_view_result=0;chest_pose(0x3a);
	xor	a, a
	ld	(#_battle_view_result),a
	ld	a, #0x3a
	call	_chest_pose
;src/battle_view.c:587: if(search)say(0xb569,NEXT_ASK_CHEST,0,0,0);else resume(NEXT_ASK_CHEST);
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x08
	ld	de, #0xb569
	call	_say
	ret
00104$:
	ld	a, #0x08
;src/battle_view.c:588: }
	jp	_resume
;src/battle_view.c:589: void battle_view_chest_open(void) RPG_BANKED {
;	---------------------------------
; Function battle_view_chest_open
; ---------------------------------
	b_battle_view_chest_open	= 30
_battle_view_chest_open::
;src/battle_view.c:590: if(!battle_view_chest_pending)return;
	ld	a, (#_battle_view_chest_pending)
	or	a, a
	ret	Z
;src/battle_view.c:591: battle_view_result=0;audio_command(0xb0);chest_motion_begin(&chest_motion,battle_view_battle.chest_visual);
	xor	a, a
	ld	(#_battle_view_result),a
	ld	a, #0xb0
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #(_battle_view_battle + 167)
	ld	b, (hl)
	push	bc
	inc	sp
	ld	de, #_chest_motion
	push	de
	ld	e, #b_chest_motion_begin
	ld	hl, #_chest_motion_begin
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/battle_view.c:592: chest_clock=audio_clock;battle_view_state=BVIEW_CHEST_ANIMATION;
	ld	a, (#_audio_clock)
	ld	(#_chest_clock),a
	ld	hl, #_battle_view_state
	ld	(hl), #0x0d
;src/battle_view.c:594: HIDE_WIN;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
;src/battle_view.c:596: }
	ret
;src/battle_view.c:597: void battle_view_chest_leave(void) RPG_BANKED {
;	---------------------------------
; Function battle_view_chest_leave
; ---------------------------------
	b_battle_view_chest_leave	= 30
_battle_view_chest_leave::
;src/battle_view.c:598: if(!battle_view_field_menu_pending&&!battle_view_chest_pending)return;
	ld	a, (#_battle_view_field_menu_pending)
	or	a, a
	jr	NZ, 00102$
	ld	a, (#_battle_view_chest_pending)
	or	a, a
	ret	Z
00102$:
;src/battle_view.c:599: battle_view_field_menu_pending=0;if(battle_view_chest_pending)rpg_battle_decline_chest(&battle_view_battle);
	xor	a, a
	ld	(#_battle_view_field_menu_pending),a
	ld	a, (#_battle_view_chest_pending)
	or	a, a
	jr	Z, 00105$
	ld	de, #_battle_view_battle
	push	de
	ld	e, #b_rpg_battle_decline_chest
	ld	hl, #_rpg_battle_decline_chest
	call	___sdcc_bcall_ehl
	pop	hl
00105$:
;src/battle_view.c:600: battle_view_chest_pending=0;resume(NEXT_DONE);
	xor	a, a
	ld	(#_battle_view_chest_pending),a
	ld	a, #0x11
;src/battle_view.c:601: }
	jp	_resume
;src/battle_view.c:602: void battle_view_chest_abandon(void) RPG_BANKED {
;	---------------------------------
; Function battle_view_chest_abandon
; ---------------------------------
	b_battle_view_chest_abandon	= 30
_battle_view_chest_abandon::
;src/battle_view.c:603: if(!battle_view_field_menu_pending&&!battle_view_chest_pending)return;
	ld	a, (#_battle_view_field_menu_pending)
	or	a, a
	jr	NZ, 00102$
	ld	a, (#_battle_view_chest_pending)
	or	a, a
	ret	Z
00102$:
;src/battle_view.c:604: battle_view_field_menu_pending=0;if(battle_view_chest_pending)rpg_battle_decline_chest(&battle_view_battle);
	xor	a, a
	ld	(#_battle_view_field_menu_pending),a
	ld	a, (#_battle_view_chest_pending)
	or	a, a
	jr	Z, 00105$
	ld	de, #_battle_view_battle
	push	de
	ld	e, #b_rpg_battle_decline_chest
	ld	hl, #_rpg_battle_decline_chest
	call	___sdcc_bcall_ehl
	pop	hl
00105$:
;src/battle_view.c:605: battle_view_chest_pending=0;
	xor	a, a
	ld	(#_battle_view_chest_pending),a
;src/battle_view.c:607: battle_scene_hide();
	ld	e, #b_battle_scene_hide
	ld	hl, #_battle_scene_hide
	call	___sdcc_bcall_ehl
;src/battle_view.c:609: battle_view_result=0;battle_view_state=0;battle_view_text_revealing=0;
	xor	a, a
	ld	(#_battle_view_result), a
	ld	(#_battle_view_state),a
	xor	a, a
	ld	(#_battle_view_text_revealing),a
;src/battle_view.c:610: }
	ret
;src/battle_view.c:611: uint8_t battle_view_tick(uint8_t keys,uint8_t pressed) RPG_BANKED {
;	---------------------------------
; Function battle_view_tick
; ---------------------------------
	b_battle_view_tick	= 30
_battle_view_tick::
	add	sp, #-10
;src/battle_view.c:613: if(battle_view_state==BVIEW_ITEM_CLOSE){
	ld	a, (#_battle_view_state)
	sub	a, #0x12
	jr	NZ, 00107$
;src/battle_view.c:614: while((uint8_t)(audio_clock-message_clock)){++message_clock;if(!--item_close_frames){resume(item_after);return battle_view_result;}}
00103$:
	ld	a, (#_audio_clock)
	ld	hl, #_message_clock
	sub	a, (hl)
	or	a, a
	jr	Z, 00105$
	inc	(hl)
	ld	hl, #_item_close_frames
	dec	(hl)
	ld	a, (hl)
	jr	NZ, 00103$
	ld	a, (_item_after)
	call	_resume
	ld	a, (_battle_view_result)
	jp	00416$
00105$:
;src/battle_view.c:615: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00107$:
;src/battle_view.c:618: if(battle_view_state==BVIEW_ENEMY_MAGIC_HOLD){
	ld	a, (#_battle_view_state)
	sub	a, #0x11
	jr	NZ, 00121$
;src/battle_view.c:619: while((uint8_t)(audio_clock-motion_clock)){
00117$:
	ld	a, (#_audio_clock)
	ld	hl, #_motion_clock
	sub	a, (hl)
	or	a, a
	jr	Z, 00119$
;src/battle_view.c:620: ++motion_clock;if(--motion_hit_hold)continue;
	inc	(hl)
	ld	hl, #_motion_hit_hold
	dec	(hl)
	ld	a, (hl)
	jr	NZ, 00117$
;src/battle_view.c:621: ++battle_view_hit_cursor;
	ld	hl, #_battle_view_hit_cursor
	inc	(hl)
;src/battle_view.c:622: if(battle_view_hit_cursor<battle_view_battle.hit_count)magic_hit_begin();
	ld	hl, #_battle_view_battle + 180
	ld	c, (hl)
	ld	a, (#_battle_view_hit_cursor)
	sub	a, c
	jr	NC, 00115$
	call	_magic_hit_begin
	jr	00116$
00115$:
;src/battle_view.c:623: else if(!selection_phase.barrier_reported&&battle_view_battle.barrier_break_before){selection_phase.barrier_reported=1;one_line(0xb1c1,0,NEXT_STEP,0);}
	ld	bc, #_selection_phase+0
	ld	a, (bc)
	or	a, a
	jr	NZ, 00111$
	ld	a, (#(_battle_view_battle + 207) + 0)
	or	a, a
	jr	Z, 00111$
	ld	a, #0x01
	ld	(bc), a
	ld	hl, #0x02
	push	hl
	xor	a, a
	ld	de, #0xb1c1
	call	_one_line
	jr	00116$
00111$:
;src/battle_view.c:624: else{feedback_animated=1;resume(NEXT_STEP);}return battle_view_result;
	ld	hl, #_feedback_animated
	ld	(hl), #0x01
	ld	a, #0x02
	call	_resume
00116$:
	ld	a, (_battle_view_result)
	jp	00416$
00119$:
;src/battle_view.c:625: }return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00121$:
;src/battle_view.c:627: if(battle_view_state==BVIEW_BOSS_ANIMATION){
	ld	a, (#_battle_view_state)
	sub	a, #0x13
	jp	NZ, 00146$
;src/battle_view.c:628: if(audio_clock!=motion_clock){
	ld	a, (#_audio_clock)
	ld	hl, #_motion_clock
	sub	a, (hl)
	jp	Z, 00144$
;src/battle_view.c:629: motion_clock=audio_clock;
	ld	a, (#_audio_clock)
	ld	(#_motion_clock),a
;src/battle_view.c:630: id=boss_motion_tick(&boss_motion);
	ld	de, #_boss_motion
	push	de
	ld	e, #b_boss_motion_tick
	ld	hl, #_boss_motion_tick
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,	#9
	ld	(hl), a
;src/battle_view.c:631: if(id&BOSS_MOTION_PATCH)battle_scene_boss_patch(boss_motion.patch);
	push	hl
	ldhl	sp,	#11
	bit	2, (hl)
	pop	hl
	jr	Z, 00123$
	ld	a, (#(_boss_motion + 8) + 0)
	push	af
	inc	sp
	ld	e, #b_battle_scene_boss_patch
	ld	hl, #_battle_scene_boss_patch
	call	___sdcc_bcall_ehl
	inc	sp
00123$:
;src/battle_view.c:632: if(id&BOSS_MOTION_FRAME)battle_scene_boss_frame(boss_motion.frame,boss_motion.y);
	push	hl
	ldhl	sp,	#11
	bit	0, (hl)
	pop	hl
	jr	Z, 00125$
	ld	a, (#(_boss_motion + 2) + 0)
	ld	hl, #_boss_motion + 1
	ld	b, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	e, #b_battle_scene_boss_frame
	ld	hl, #_battle_scene_boss_frame
	call	___sdcc_bcall_ehl
	inc	sp
	inc	sp
00125$:
;src/battle_view.c:633: if(id&BOSS_MOTION_IMPACT){
	push	hl
	ldhl	sp,	#11
	bit	1, (hl)
	pop	hl
	jp	Z, 00132$
;src/battle_view.c:636: if(battle_view_battle.enemy_id==72u||battle_view_battle.hits[battle_view_hit_cursor].damage){
	ld	hl, #(_battle_view_battle + 128)
	ld	c, (hl)
	ld	a, c
	sub	a, #0x48
	jr	Z, 00127$
	ld	a, (#_battle_view_hit_cursor)
	ld	c, a
	add	a, a
	add	a, c
	ld	l, a
	ld	h, #0x00
	ld	de, #(_battle_view_battle + 181)
	add	hl, de
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00128$
00127$:
;src/battle_view.c:637: audio_command(0xae);
	ld	a, #0xae
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/battle_view.c:641: for(motion_hit_hold=10u;motion_hit_hold;){--motion_hit_hold;battle_scene_flash_party(motion_hit_hold&1u,battle_view_battle.enemy_id==73u);}
	ld	hl, #_motion_hit_hold
	ld	(hl), #0x0a
00414$:
	ld	hl, #_motion_hit_hold
	dec	(hl)
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x49
	ld	a, #0x01
	jr	Z, 01621$
	xor	a, a
01621$:
	ld	b, a
	ld	a, (_motion_hit_hold)
	and	a, #0x01
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	e, #b_battle_scene_flash_party
	ld	hl, #_battle_scene_flash_party
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, (#_motion_hit_hold)
	or	a, a
	jr	NZ, 00414$
;src/battle_view.c:642: ui_number(11,3,battle_view_battle.hits[battle_view_hit_cursor].hp);motion_clock=audio_clock;
	ld	a, (#_battle_view_hit_cursor)
	ld	c, a
	add	a, a
	add	a, c
	ld	l, a
	ld	h, #0x00
	ld	de, #(_battle_view_battle + 181)
	add	hl, de
	inc	hl
	inc	hl
	ld	c, (hl)
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, #0x0b
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	a, (#_audio_clock)
	ld	hl, #_motion_clock
	ld	(hl), a
	jr	00132$
00128$:
;src/battle_view.c:643: }else audio_command(0xbb);
	ld	a, #0xbb
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00132$:
;src/battle_view.c:645: if(id&BOSS_MOTION_DONE){
	push	hl
	ldhl	sp,	#11
	bit	3, (hl)
	pop	hl
	jp	Z, 00144$
;src/battle_view.c:646: if(battle_view_battle.enemy_id==72u && (battle_view_battle.hit_blocked&(1u<<battle_view_hit_cursor)))one_line(0xb1b2,0,NEXT_MAGIC_DEATH,battle_view_battle.hits[battle_view_hit_cursor].target);
	ld	hl, #_battle_view_battle + 128
	ld	c, (hl)
;src/battle_view.c:636: if(battle_view_battle.enemy_id==72u||battle_view_battle.hits[battle_view_hit_cursor].damage){
	ld	a, (#_battle_view_hit_cursor)
	ld	e, a
	add	a, a
	add	a, e
	ldhl	sp,	#9
	ld	(hl), a
;src/battle_view.c:646: if(battle_view_battle.enemy_id==72u && (battle_view_battle.hit_blocked&(1u<<battle_view_hit_cursor)))one_line(0xb1b2,0,NEXT_MAGIC_DEATH,battle_view_battle.hits[battle_view_hit_cursor].target);
	ld	a, c
	sub	a, #0x48
	jr	NZ, 00138$
	ld	a, (#(_battle_view_battle + 206) + 0)
	ld	hl, #_battle_view_hit_cursor
	ld	b, (hl)
	ld	de, #0x0001
	inc	b
	jr	01626$
01625$:
	sla	e
	rl	d
01626$:
	dec	b
	jr	NZ,01625$
	and	a, e
	ld	b, #0x00
	or	a, b
	jr	Z, 00138$
	ld	de, #(_battle_view_battle + 181)
	ldhl	sp,	#9
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	h, a
	ld	l, #0x19
	push	hl
	xor	a, a
	ld	de, #0xb1b2
	call	_one_line
	jr	00139$
00138$:
;src/battle_view.c:647: else if(battle_view_battle.enemy_id==73u&&!battle_view_battle.hits[battle_view_hit_cursor].damage)one_line(battle_view_battle.last_effect==BATTLE_EFFECT_BLOCKED?0xb1a3:0xb118,0,NEXT_MAGIC_DEATH,battle_view_battle.hits[battle_view_hit_cursor].target);
	ld	a, c
	sub	a, #0x49
	jr	NZ, 00134$
	ld	de, #(_battle_view_battle + 181)
	ldhl	sp,	#9
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c,l
	ld	b,h
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00134$
	ld	a, (bc)
	ld	b, a
	ld	a, (#(_battle_view_battle + 160) + 0)
	sub	a, #0x03
	jr	NZ, 00418$
	ld	de, #0xb1a3
	jr	00419$
00418$:
	ld	de, #0xb118
00419$:
	ld	c, #0x19
	push	bc
	xor	a, a
	call	_one_line
	jr	00139$
00134$:
;src/battle_view.c:648: else resume(NEXT_MAGIC_DEATH);
	ld	a, #0x19
	call	_resume
00139$:
;src/battle_view.c:649: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00144$:
;src/battle_view.c:651: }return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00146$:
;src/battle_view.c:653: if(battle_view_state==BVIEW_ENEMY_MAGIC){
	ld	a, (#_battle_view_state)
	sub	a, #0x10
	jp	NZ, 00177$
;src/battle_view.c:654: while((uint8_t)(audio_clock-motion_clock)){
00173$:
	ld	a, (#_audio_clock)
	ld	hl, #_motion_clock
	sub	a, (hl)
	or	a, a
	jp	Z, 00175$
;src/battle_view.c:655: ++motion_clock;
	inc	(hl)
;src/battle_view.c:656: if(magic_phase==2u){
	ld	a, (#_magic_phase)
	sub	a, #0x02
	jr	NZ, 00161$
;src/battle_view.c:657: --motion_hit_hold;battle_scene_flash_party(motion_hit_hold&1u,0);
	ld	hl, #_motion_hit_hold
	dec	(hl)
	ld	a, (hl)
	and	a, #0x01
	ld	h, #0x00
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	e, #b_battle_scene_flash_party
	ld	hl, #_battle_scene_flash_party
	call	___sdcc_bcall_ehl
	pop	hl
;src/battle_view.c:658: if(motion_hit_hold)continue;
	ld	a, (#_motion_hit_hold)
	or	a, a
	jr	NZ, 00173$
;src/battle_view.c:659: ui_number(11,3,battle_view_battle.hits[battle_view_hit_cursor].hp);magic_phase=0;
	ld	a, (#_battle_view_hit_cursor)
	ld	c, a
	add	a, a
	add	a, c
	ld	l, a
	ld	h, #0x00
	ld	de, #(_battle_view_battle + 181)
	add	hl, de
	inc	hl
	inc	hl
	ld	c, (hl)
	ld	b, #0x00
	push	bc
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, #0x0b
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	xor	a, a
	ld	(#_magic_phase),a
	jp	00162$
00161$:
;src/battle_view.c:660: }else if(magic_phase==1u){
	ld	a, (#_magic_phase)
	dec	a
	jp	NZ, 00162$
;src/battle_view.c:661: id=enemy_magic_tick(&enemy_effect);
	ld	de, #_enemy_effect
	push	de
	push	de
	ld	e, #b_enemy_magic_tick
	ld	hl, #_enemy_magic_tick
	call	___sdcc_bcall_ehl
	pop	hl
	ld	c, a
	pop	de
;src/battle_view.c:662: if(id&ENEMY_MAGIC_SOUND)audio_command(enemy_magic_sound(&enemy_effect));
	bit	1, c
	jr	Z, 00150$
	push	bc
	push	de
	ld	e, #b_enemy_magic_sound
	ld	hl, #_enemy_magic_sound
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
	push	bc
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
00150$:
;src/battle_view.c:663: if(id&ENEMY_MAGIC_FRAME)battle_scene_magic_frame(enemy_effect.frame);
	bit	0, c
	jr	Z, 00152$
	ld	a, (#(_enemy_effect + 1) + 0)
	push	bc
	push	af
	inc	sp
	ld	e, #b_battle_scene_magic_frame
	ld	hl, #_battle_scene_magic_frame
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
00152$:
;src/battle_view.c:664: if(!(id&ENEMY_MAGIC_IMPACT))continue;
	bit	2, c
	jp	Z, 00173$
;src/battle_view.c:665: battle_scene_weapon_clear();
	ld	e, #b_battle_scene_weapon_clear
	ld	hl, #_battle_scene_weapon_clear
	call	___sdcc_bcall_ehl
;src/battle_view.c:666: if(battle_view_battle.hit_blocked&(1u<<battle_view_hit_cursor)){audio_command(0xbb);magic_phase=0;}
	ld	a, (#(_battle_view_battle + 206) + 0)
	ld	hl, #_battle_view_hit_cursor
	ld	b, (hl)
	ld	de, #0x0001
	inc	b
	jr	01641$
01640$:
	sla	e
	rl	d
01641$:
	dec	b
	jr	NZ,01640$
	and	a, e
	ld	c, #0x00
	or	a, c
	jr	Z, 00156$
	ld	a, #0xbb
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	xor	a, a
	ld	(#_magic_phase),a
	jr	00162$
00156$:
;src/battle_view.c:667: else{audio_command(0xae);motion_hit_hold=10;magic_phase=2;continue;}
	ld	a, #0xae
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_motion_hit_hold
	ld	(hl), #0x0a
	ld	hl, #_magic_phase
	ld	(hl), #0x02
	jp	00173$
00162$:
;src/battle_view.c:669: id=battle_motion_tick(&enemy_motion);
	ld	de, #_enemy_motion
	push	de
	ld	e, #b_battle_motion_tick
	ld	hl, #_battle_motion_tick
	call	___sdcc_bcall_ehl
	pop	hl
	ld	c, a
;src/battle_view.c:670: if((id&BATTLE_MOTION_FRAME)&&enemy_motion.frame!=motion_last_frame){battle_scene_animation_frame(enemy_motion.frame);motion_last_frame=enemy_motion.frame;}
	bit	0, c
	jr	Z, 00164$
	ld	a, (#(_enemy_motion + 1) + 0)
	ld	hl, #_motion_last_frame
	cp	a, (hl)
	jr	Z, 00164$
	push	bc
	push	af
	inc	sp
	ld	e, #b_battle_scene_animation_frame
	ld	hl, #_battle_scene_animation_frame
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
	ld	a, (#(_enemy_motion + 1) + 0)
	ld	(#_motion_last_frame),a
00164$:
;src/battle_view.c:671: if(id&BATTLE_MOTION_IMPACT){enemy_magic_begin(&enemy_effect,battle_view_battle.enemy_id);magic_phase=1;}
	bit	1, c
	jr	Z, 00167$
	ld	a, (#(_battle_view_battle + 128) + 0)
	push	bc
	push	af
	inc	sp
	ld	de, #_enemy_effect
	push	de
	ld	e, #b_enemy_magic_begin
	ld	hl, #_enemy_magic_begin
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	ld	hl, #_magic_phase
	ld	(hl), #0x01
00167$:
;src/battle_view.c:672: if(id&BATTLE_MOTION_DONE){
	bit	2, c
	jp	Z, 00173$
;src/battle_view.c:673: if(battle_view_battle.hit_blocked&(1u<<battle_view_hit_cursor))one_line(0xb1b2,0,NEXT_MAGIC_DEATH,battle_view_battle.hits[battle_view_hit_cursor].target);
	ld	a, (#(_battle_view_battle + 206) + 0)
	ldhl	sp,	#9
	ld	(hl), a
	ld	a, (#_battle_view_hit_cursor)
	push	af
	ld	bc, #0x0001
	pop	af
	inc	a
	jr	01647$
01646$:
	sla	c
	rl	b
01647$:
	dec	a
	jr	NZ,01646$
	ldhl	sp,	#9
	ld	a, (hl)
	and	a, c
	jr	Z, 00169$
	ld	a, (#_battle_view_hit_cursor)
	ld	c, a
	add	a, a
	add	a, c
	ldhl	sp,	#9
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ld	hl, #(_battle_view_battle + 181)
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	h, a
	ld	l, #0x19
	push	hl
	xor	a, a
	ld	de, #0xb1b2
	call	_one_line
	jr	00170$
00169$:
;src/battle_view.c:674: else resume(NEXT_MAGIC_DEATH);
	ld	a, #0x19
	call	_resume
00170$:
;src/battle_view.c:675: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00175$:
;src/battle_view.c:677: }return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00177$:
;src/battle_view.c:679: if(battle_view_state==BVIEW_PLAYER_WEAPON){
	ld	a, (#_battle_view_state)
	sub	a, #0x0f
	jp	NZ, 00193$
;src/battle_view.c:680: while((uint8_t)(audio_clock-motion_clock)){
00189$:
	ld	a, (#_audio_clock)
	ld	hl, #_motion_clock
	sub	a, (hl)
	or	a, a
	jp	Z, 00191$
;src/battle_view.c:681: ++motion_clock;id=battle_weapon_tick(&weapon_motion);
	inc	(hl)
	ld	de, #_weapon_motion
	push	de
	ld	e, #b_battle_weapon_tick
	ld	hl, #_battle_weapon_tick
	call	___sdcc_bcall_ehl
	pop	hl
	ld	c, a
;src/battle_view.c:682: if(id&WEAPON_MOTION_SOUND)audio_command(battle_weapon_sound(weapon_motion.effect));
	bit	1, c
	jr	Z, 00179$
	ld	a, (#_weapon_motion + 0)
	push	bc
	push	af
	inc	sp
	ld	e, #b_battle_weapon_sound
	ld	hl, #_battle_weapon_sound
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
	push	bc
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
00179$:
;src/battle_view.c:683: if(id&WEAPON_MOTION_FRAME)battle_scene_weapon_frame(weapon_motion.frame);
	bit	0, c
	jr	Z, 00181$
	ld	a, (#(_weapon_motion + 1) + 0)
	push	bc
	push	af
	inc	sp
	ld	e, #b_battle_scene_weapon_frame
	ld	hl, #_battle_scene_weapon_frame
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
00181$:
;src/battle_view.c:684: if(id&WEAPON_MOTION_CLEAR)battle_scene_weapon_clear();
	bit	2, c
	jr	Z, 00183$
	push	bc
	ld	e, #b_battle_scene_weapon_clear
	ld	hl, #_battle_scene_weapon_clear
	call	___sdcc_bcall_ehl
	pop	bc
00183$:
;src/battle_view.c:685: if(id&WEAPON_MOTION_DONE){
	bit	3, c
	jr	Z, 00189$
;src/battle_view.c:686: if(battle_view_battle.last_effect!=BATTLE_EFFECT_MISS){motion_hit_hold=10;audio_command(0xad);battle_view_state=BVIEW_PLAYER_HIT;}
	ld	a, (#(_battle_view_battle + 160) + 0)
	sub	a, #0x02
	jr	Z, 00185$
	ld	hl, #_motion_hit_hold
	ld	(hl), #0x0a
	ld	a, #0xad
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_battle_view_state
	ld	(hl), #0x0e
	jr	00186$
00185$:
;src/battle_view.c:687: else{audio_command(0xbb);feedback_animated=1;action_feedback();}return battle_view_result;
	ld	a, #0xbb
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_feedback_animated
	ld	(hl), #0x01
	call	_action_feedback
00186$:
	ld	a, (_battle_view_result)
	jp	00416$
00191$:
;src/battle_view.c:690: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00193$:
;src/battle_view.c:692: if(battle_view_state==BVIEW_PLAYER_HIT){
	ld	a, (#_battle_view_state)
	sub	a, #0x0e
	jp	NZ, 00205$
;src/battle_view.c:693: while((uint8_t)(audio_clock-motion_clock)){
00201$:
	ld	a, (#_audio_clock)
	ld	hl, #_motion_clock
	sub	a, (hl)
	or	a, a
	jp	Z, 00203$
;src/battle_view.c:694: ++motion_clock;--motion_hit_hold;battle_scene_flash_enemy(motion_hit_hold&1u);
	inc	(hl)
	ld	hl, #_motion_hit_hold
	dec	(hl)
	ld	a, (hl)
	and	a, #0x01
	push	af
	inc	sp
	ld	e, #b_battle_scene_flash_enemy
	ld	hl, #_battle_scene_flash_enemy
	call	___sdcc_bcall_ehl
	inc	sp
;src/battle_view.c:695: if(!motion_hit_hold){
	ld	a, (#_motion_hit_hold)
	or	a, a
	jr	NZ, 00201$
;src/battle_view.c:696: if(battle_view_battle.enemy_id!=EnemyID_DarkFalz){
	ld	a, (#(_battle_view_battle + 128) + 0)
	sub	a, #0x49
	jr	Z, 00195$
;src/battle_view.c:697: ui_text(1,3,"ENEMY HP");ui_number(11,3,battle_view_battle.hits[battle_view_hit_cursor].hp);
	ld	de, #___str_71
	push	de
	ld	e, #0x03
	ld	a, #0x01
	call	_view_text
	ld	a, (#_battle_view_hit_cursor)
	ld	c, a
	add	a, a
	add	a, c
	ld	l, a
	ld	h, #0x00
	ld	de, #(_battle_view_battle + 181)
	add	hl, de
	inc	hl
	inc	hl
	ld	c, (hl)
	xor	a, a
	ld	b, a
	push	bc
	ld	a, #0x03
	push	af
	inc	sp
	ld	a, #0x0b
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
00195$:
;src/battle_view.c:699: ++battle_view_hit_cursor;
	ld	hl, #_battle_view_hit_cursor
	inc	(hl)
;src/battle_view.c:700: if(battle_view_hit_cursor<battle_view_battle.hit_count){
	ld	hl, #(_battle_view_battle + 180)
	ld	c, (hl)
	ld	a, (#_battle_view_hit_cursor)
	sub	a, c
	jr	NC, 00197$
;src/battle_view.c:701: battle_weapon_begin(&weapon_motion,weapon_motion.effect);battle_view_state=BVIEW_PLAYER_WEAPON;
	ld	bc, #_weapon_motion+0
	ld	a, (bc)
	push	af
	inc	sp
	push	bc
	ld	e, #b_battle_weapon_begin
	ld	hl, #_battle_weapon_begin
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	hl, #_battle_view_state
	ld	(hl), #0x0f
	jr	00198$
00197$:
;src/battle_view.c:702: }else{feedback_animated=1;action_feedback();}
	ld	hl, #_feedback_animated
	ld	(hl), #0x01
	call	_action_feedback
00198$:
;src/battle_view.c:703: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00203$:
;src/battle_view.c:706: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00205$:
;src/battle_view.c:708: if(battle_view_state==BVIEW_ENEMY_ANIMATION){
	ld	a, (#_battle_view_state)
	sub	a, #0x0b
	jp	NZ, 00221$
;src/battle_view.c:709: while((uint8_t)(audio_clock-motion_clock)) {
00217$:
	ld	a, (#_audio_clock)
	ld	hl, #_motion_clock
	sub	a, (hl)
	or	a, a
	jp	Z, 00219$
;src/battle_view.c:710: ++motion_clock;if(motion_hit_hold){
	inc	(hl)
	ld	hl, #_motion_hit_hold
	ld	a, (hl)
	or	a, a
	jr	Z, 00207$
;src/battle_view.c:711: --motion_hit_hold;battle_scene_flash_party(motion_hit_hold&1u,battle_view_battle.enemy_id==70u||battle_view_battle.enemy_id==73u||battle_view_battle.enemy_id==74u);continue;
	dec	(hl)
	ld	a, (#(_battle_view_battle + 128) + 0)
	cp	a, #0x46
	jr	Z, 00421$
	cp	a, #0x49
	jr	Z, 00421$
	sub	a, #0x4a
	jr	Z, 00421$
	ld	b, #0x00
	jr	00422$
00421$:
	ld	b, #0x01
00422$:
	ld	a, (_motion_hit_hold)
	and	a, #0x01
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	e, #b_battle_scene_flash_party
	ld	hl, #_battle_scene_flash_party
	call	___sdcc_bcall_ehl
	pop	hl
	jr	00217$
00207$:
;src/battle_view.c:712: }id=battle_motion_tick(&enemy_motion);
	ld	de, #_enemy_motion
	push	de
	ld	e, #b_battle_motion_tick
	ld	hl, #_battle_motion_tick
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,	#8
	ld	(hl), a
;src/battle_view.c:713: if((id&BATTLE_MOTION_FRAME) && enemy_motion.frame!=motion_last_frame){battle_scene_animation_frame(enemy_motion.frame);motion_last_frame=enemy_motion.frame;}
	push	hl
	ldhl	sp,	#10
	bit	0, (hl)
	pop	hl
	jr	Z, 00209$
	ld	a, (#(_enemy_motion + 1) + 0)
	ld	hl, #_motion_last_frame
	cp	a, (hl)
	jr	Z, 00209$
	push	af
	inc	sp
	ld	e, #b_battle_scene_animation_frame
	ld	hl, #_battle_scene_animation_frame
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, (#(_enemy_motion + 1) + 0)
	ld	hl, #_motion_last_frame
	ld	(hl), a
00209$:
;src/battle_view.c:714: if(id&BATTLE_MOTION_IMPACT){audio_command(battle_view_battle.last_damage?0xae:0xbb);if(battle_view_battle.last_damage)motion_hit_hold=10;}
	push	hl
	ldhl	sp,	#10
	bit	1, (hl)
	pop	hl
	jr	Z, 00214$
	ld	a, (#(_battle_view_battle + 146) + 0)
	or	a, a
	jr	Z, 00426$
	ldhl	sp,	#9
	ld	(hl), #0xae
	jr	00427$
00426$:
	ldhl	sp,	#9
	ld	(hl), #0xbb
00427$:
	ldhl	sp,	#9
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, (#(_battle_view_battle + 146) + 0)
	or	a, a
	jr	Z, 00214$
	ld	hl, #_motion_hit_hold
	ld	(hl), #0x0a
00214$:
;src/battle_view.c:715: if(id&BATTLE_MOTION_DONE){feedback_animated=1;action_feedback();return battle_view_result;}
	push	hl
	ldhl	sp,	#10
	bit	2, (hl)
	pop	hl
	jp	Z, 00217$
	ld	hl, #_feedback_animated
	ld	(hl), #0x01
	call	_action_feedback
	ld	a, (_battle_view_result)
	jp	00416$
00219$:
;src/battle_view.c:717: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00221$:
;src/battle_view.c:720: if(battle_view_state==BVIEW_CHEST_MENU)return BATTLE_VIEW_MENU;
	ld	a, (#_battle_view_state)
	sub	a, #0x0c
	jr	NZ, 00223$
	ld	a, #0xfe
	jp	00416$
00223$:
;src/battle_view.c:721: if(battle_view_state==BVIEW_CHEST_ANIMATION){
	ld	a, (#_battle_view_state)
	sub	a, #0x0d
	jp	NZ, 00247$
;src/battle_view.c:722: while((uint8_t)(audio_clock-chest_clock)) {
00243$:
	ld	a, (#_audio_clock)
	ld	hl, #_chest_clock
	sub	a, (hl)
	or	a, a
	jp	Z, 00245$
;src/battle_view.c:723: ++chest_clock;err=chest_motion.hold;id=chest_motion_tick(&chest_motion);
	inc	(hl)
	ld	hl, #(_chest_motion + 5)
	ld	c, (hl)
	push	bc
	ld	de, #_chest_motion
	push	de
	ld	e, #b_chest_motion_tick
	ld	hl, #_chest_motion_tick
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,	#11
	ld	(hl), a
	pop	bc
;src/battle_view.c:725: if(err)battle_scene_flash_party(chest_motion.hold&1u,battle_view_battle.enemy_id==70u||battle_view_battle.enemy_id==73u||battle_view_battle.enemy_id==74u);
	ld	a, c
	or	a, a
	jr	Z, 00225$
	ld	a, (#(_battle_view_battle + 128) + 0)
	cp	a, #0x46
	jr	Z, 00429$
	cp	a, #0x49
	jr	Z, 00429$
	sub	a, #0x4a
	jr	Z, 00429$
	ld	b, #0x00
	jr	00430$
00429$:
	ld	b, #0x01
00430$:
	ld	a, (#(_chest_motion + 5) + 0)
	and	a, #0x01
	push	bc
	inc	sp
	push	af
	inc	sp
	ld	e, #b_battle_scene_flash_party
	ld	hl, #_battle_scene_flash_party
	call	___sdcc_bcall_ehl
	inc	sp
	inc	sp
00225$:
;src/battle_view.c:726: if(id&CHEST_MOTION_FRAME)chest_show(chest_motion.frame);
	push	hl
	ldhl	sp,	#11
	bit	0, (hl)
	pop	hl
	jr	Z, 00227$
	ld	a, (#_chest_motion + 0)
	push	af
	inc	sp
	ld	e, #b_chest_show
	ld	hl, #_chest_show
	call	___sdcc_bcall_ehl
	inc	sp
00227$:
;src/battle_view.c:728: if(id&CHEST_MOTION_SOUND)audio_command(chest_motion.visual==0x3eu?0xb1:0xb2);
	push	hl
	ldhl	sp,	#11
	bit	1, (hl)
	pop	hl
	jr	Z, 00229$
	ld	a, (#(_chest_motion + 2) + 0)
	sub	a, #0x3e
	ld	a, #0xb1
	jr	Z, 00435$
	ld	a, #0xb2
00435$:
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00229$:
;src/battle_view.c:729: if(id&CHEST_MOTION_DONE){
	push	hl
	ldhl	sp,	#11
	bit	3, (hl)
	pop	hl
	jp	Z, 00243$
;src/battle_view.c:733: id=battle_view_battle.item_reward;battle_view_battle.item_reward=0;
	ld	hl,#(_battle_view_battle + 152)
	ld	b,(hl)
	ld	(hl), #0x00
;src/battle_view.c:734: err=rpg_battle_open_chest(party,&battle_view_battle);
	push	bc
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
	ld	c, a
	pop	af
	ld	b, a
;src/battle_view.c:735: battle_view_battle.item_reward=id;
	ld	hl, #(_battle_view_battle + 152)
	ld	(hl), b
;src/battle_view.c:736: if(err==RPG_OK&&id){battle_view_battle.item_pending=id;battle_view_battle.rewards_claimed=0;}
	ld	a, c
	or	a, a
	jr	NZ, 00231$
	or	a, b
	jr	Z, 00231$
	ld	hl, #(_battle_view_battle + 164)
	ld	(hl), b
	ld	hl, #_battle_view_battle + 154
	ld	(hl), #0x00
00231$:
;src/battle_view.c:737: battle_view_chest_pending=0;
	xor	a, a
	ld	(#_battle_view_chest_pending),a
;src/battle_view.c:738: if(err!=RPG_OK&&err!=RPG_FULL)literal("CHEST UNAVAILABLE","",NEXT_DONE);
	ld	a, c
	or	a, a
	jr	Z, 00238$
	ld	a, c
	sub	a, #0x02
	jr	Z, 00238$
	ld	a, #0x11
	push	af
	inc	sp
	ld	bc, #___str_73
	ld	de, #___str_72
	call	_literal
	jr	00239$
00238$:
;src/battle_view.c:739: else if(!battle_view_battle.money_reward&&!battle_view_battle.item_reward)say(0xb665,NEXT_CHEST_CLOSE,0,0,0);
	ld	hl, #_battle_view_battle + 150
	ld	a, (hl+)
	ld	c, (hl)
	or	a, c
	jr	NZ, 00234$
	ld	a, (#(_battle_view_battle + 152) + 0)
	or	a, a
	jr	NZ, 00234$
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x23
	ld	de, #0xb665
	call	_say
	jr	00239$
00234$:
;src/battle_view.c:740: else resume(NEXT_MONEY);return battle_view_result;
	ld	a, #0x0a
	call	_resume
00239$:
	ld	a, (_battle_view_result)
	jp	00416$
00245$:
;src/battle_view.c:743: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00247$:
;src/battle_view.c:745: if(battle_view_state==BVIEW_AUDIO_WAIT){if((uint8_t)(audio_clock-audio_delay_start)>=audio_delay_frames){audio_command(0xd8);say(0xb71b,NEXT_REWARDS,0,0,0);}return battle_view_result;}
	ld	a, (#_battle_view_state)
	sub	a, #0x0a
	jr	NZ, 00251$
	ld	a, (#_audio_clock)
	ld	hl, #_audio_delay_start
	sub	a, (hl)
	ld	c, a
	ld	hl, #_audio_delay_frames
	sub	a, (hl)
	jr	C, 00249$
	ld	a, #0xd8
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x04
	ld	de, #0xb71b
	call	_say
00249$:
	ld	a, (_battle_view_result)
	jp	00416$
00251$:
;src/battle_view.c:746: if(battle_view_state==BVIEW_DONE)return battle_view_result;
	ld	a, (#_battle_view_state)
	sub	a, #0x09
	jr	NZ, 00253$
	ld	a, (_battle_view_result)
	jp	00416$
00253$:
;src/battle_view.c:747: if(battle_view_state==BVIEW_EXECUTE){execute_step();return battle_view_result;}
	ld	a, (#_battle_view_state)
	sub	a, #0x08
	jr	NZ, 00255$
	call	_execute_step
	ld	a, (_battle_view_result)
	jp	00416$
00255$:
;src/battle_view.c:748: if(battle_view_state==BVIEW_MESSAGE){
	ld	a, (#_battle_view_state)
	sub	a, #0x05
	jp	NZ, 00287$
;src/battle_view.c:749: if(battle_view_text_revealing){
	ld	a, (#_battle_view_text_revealing)
	or	a, a
	jp	Z, 00279$
;src/battle_view.c:750: if((uint8_t)(audio_clock-message_clock)){
	ld	a, (#_audio_clock)
	ld	hl, #_message_clock
	sub	a, (hl)
	or	a, a
	jp	Z, 00277$
;src/battle_view.c:751: message_clock=audio_clock;count=message.row;next=message.column;
	ld	a, (#_audio_clock)
	ld	(#_message_clock),a
	ld	bc, #_message+0
	ld	a, (#(_message + 14) + 0)
	ldhl	sp,	#5
	ld	(hl), a
	ld	a, (#(_message + 15) + 0)
	ldhl	sp,	#6
	ld	(hl), a
;src/battle_view.c:752: id=dialogue_stream_next(&message,0);
	ld	e, c
	ld	d, b
	push	bc
	ld	hl, #0x0000
	push	hl
	push	de
	ld	e, #b_dialogue_stream_next
	ld	hl, #_dialogue_stream_next
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,	#9
	ld	(hl), a
	pop	bc
;src/battle_view.c:753: if(id==DIALOGUE_STREAM_SCROLL||(id==DIALOGUE_STREAM_CHAR&&(message.row<count||(message.row==count&&message.column<=next)))){
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x02
	jr	Z, 00269$
	ldhl	sp,	#7
	ld	a, (hl)
	dec	a
	ld	a, #0x01
	jr	Z, 01690$
	xor	a, a
01690$:
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00270$
	ld	a, (#(_message + 14) + 0)
	ldhl	sp,#9
	ld	(hl), a
	ld	a, (hl)
	ldhl	sp,	#5
	sub	a, (hl)
	jr	C, 00269$
	ld	a, (hl)
	ldhl	sp,	#9
	sub	a, (hl)
	jr	NZ, 00270$
	ld	a, (#(_message + 15) + 0)
	ldhl	sp,	#9
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	ldhl	sp,	#9
	sub	a, (hl)
	jr	C, 00270$
00269$:
;src/battle_view.c:754: ui_text(1,1,message.lines[0]);ui_text(1,2,message.lines[1]);
	push	bc
	ld	de, #(_message + 50)
	push	de
	ld	a,#0x01
	ld	e,a
	call	_view_text
	pop	bc
	ld	de, #(_message + 69)
	push	de
	ld	e, #0x02
	ld	a, #0x01
	call	_view_text
	jp	00271$
00270$:
;src/battle_view.c:755: }else if(id==DIALOGUE_STREAM_CHAR){
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00267$
;src/battle_view.c:756: glyph[0]=message.lines[message.row][message.column-1u];glyph[1]=0;
	ld	a, (#(_message + 14) + 0)
	ld	c, a
	add	a, a
	add	a, a
	add	a, c
	add	a, a
	add	a, a
	sub	a, c
	add	a, #<((_message + 50))
	ld	c, a
	ld	a, #0x00
	adc	a, #>((_message + 50))
	ld	b, a
	ld	a, (#(_message + 15) + 0)
	dec	a
	add	a, c
	ld	c, a
	ld	a, #0x00
	adc	a, b
	ld	b, a
	ld	a, (bc)
	ldhl	sp,	#2
	ld	(hl+), a
	ld	(hl), #0x00
;src/battle_view.c:757: ui_text(message.column,1u+message.row,glyph);
	ld	hl, #(_message + 14)
	ld	c, (hl)
	inc	c
	ld	a, (#(_message + 15) + 0)
	ld	hl, #2
	add	hl, sp
	push	hl
	ld	e, c
	call	_view_text
	jr	00271$
00267$:
;src/battle_view.c:759: else if(id==DIALOGUE_STREAM_WAIT){
	ldhl	sp,	#7
	ld	a, (hl)
;src/battle_view.c:760: battle_view_text_revealing=0;message_wait=dialogue_wait_frames(message.done?message.terminator:0x61u,0);
	or	a,a
	jr	NZ, 00271$
	ld	(#_battle_view_text_revealing),a
	ld	a, (#(_message + 12) + 0)
	or	a, a
	jr	Z, 00436$
	ld	hl, #(_message + 13)
	ld	b, (hl)
	jr	00437$
00436$:
	ld	b, #0x61
00437$:
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	e, #b_dialogue_wait_frames
	ld	hl, #_dialogue_wait_frames
	call	___sdcc_bcall_ehl
	pop	hl
	ld	hl, #_message_wait
	ld	a, c
;src/battle_view.c:761: if(!message_wait){if(!message.done)message_page();else resume(after_message);}
	ld	(hl+), a
	ld	(hl), b
	or	a, b
	jr	NZ, 00262$
	ld	a, (#(_message + 12) + 0)
	or	a, a
	jr	NZ, 00257$
	call	_message_page
	jr	00263$
00257$:
	ld	a, (_after_message)
	call	_resume
	jr	00263$
00262$:
;src/battle_view.c:762: else if(message_wait==65535u)ui_text(17,4,">");return battle_view_result;
	ld	a, (_message_wait)
	ld	c, a
	ld	hl, #_message_wait + 1
	ld	b, (hl)
	ld	a, c
	and	a, b
	inc	a
	jr	NZ, 00263$
	ld	de, #___str_74
	push	de
	ld	e, #0x04
	ld	a, #0x11
	call	_view_text
00263$:
	ld	a, (_battle_view_result)
	jp	00416$
00271$:
;src/battle_view.c:766: message_clock=audio_clock;
	ld	a, (#_audio_clock)
	ld	(#_message_clock),a
00277$:
;src/battle_view.c:768: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00279$:
;src/battle_view.c:770: if(is_literal?(pressed&(J_A|J_B)):dialogue_wait_tick(&message_wait,message.done?message.terminator:0x61u,0,pressed&(J_A|J_B))){if(!is_literal&&!message.done)message_page();else resume(after_message);}
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl), a
	ld	a, (#_is_literal)
	or	a, a
	jr	Z, 00438$
	ldhl	sp,	#9
	ld	a, (hl)
	and	a, #0x30
	jr	00439$
00438$:
	ldhl	sp,	#9
	ld	a, (hl)
	and	a, #0x30
	ld	c, a
	ld	de, #_message+0
	ld	hl, #0x000c
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	Z, 00440$
	ld	hl, #(_message + 13)
	ld	b, (hl)
	jr	00441$
00440$:
	ld	b, #0x61
00441$:
	ld	de, #_message_wait+0
	ld	a, c
	push	af
	inc	sp
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	push	de
	ld	e, #b_dialogue_wait_tick
	ld	hl, #_dialogue_wait_tick
	call	___sdcc_bcall_ehl
	add	sp, #5
00439$:
	or	a, a
	jr	Z, 00285$
	ld	a, (#_is_literal)
	or	a, a
	jr	NZ, 00281$
	ld	a, (#(_message + 12) + 0)
	or	a, a
	jr	NZ, 00281$
	call	_message_page
	jr	00285$
00281$:
	ld	a, (_after_message)
	call	_resume
00285$:
;src/battle_view.c:771: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00287$:
;src/battle_view.c:774: if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN)){
	ldhl	sp,	#17
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
;src/battle_view.c:773: if(battle_view_state==BVIEW_PROMPT){
	ld	a, (#_battle_view_state)
	sub	a, #0x06
	jp	NZ, 00311$
;src/battle_view.c:774: if(pressed&(J_LEFT|J_RIGHT|J_UP|J_DOWN)){
	ldhl	sp,	#8
	ld	a, (hl)
	and	a, #0x0f
	jr	Z, 00289$
;src/battle_view.c:775: battle_view_choice^=1u;ui_text(1,1,battle_view_choice?" ":">");ui_text(10,1,battle_view_choice?">":" ");
	ld	hl, #_battle_view_choice
	ld	a, (hl)
	xor	a, #0x01
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00442$
	ld	bc, #___str_75+0
	jr	00443$
00442$:
	ld	bc, #___str_74+0
00443$:
	push	bc
	ld	a,#0x01
	ld	e,a
	call	_view_text
	ld	a, (#_battle_view_choice)
	or	a, a
	jr	Z, 00444$
	ld	bc, #___str_74+0
	jr	00445$
00444$:
	ld	bc, #___str_75+0
00445$:
	push	bc
	ld	e, #0x01
	ld	a, #0x0a
	call	_view_text
00289$:
;src/battle_view.c:777: if(!(pressed&(J_A|J_B)))return battle_view_result;
	ldhl	sp,	#8
	ld	a, (hl)
	and	a, #0x30
	jr	NZ, 00291$
	ld	a, (_battle_view_result)
	jp	00416$
00291$:
;src/battle_view.c:778: yes=!battle_view_choice;
	ld	a, (#_battle_view_choice)
	sub	a, #0x01
	ld	a, #0x00
	rla
	ldhl	sp,	#9
	ld	(hl), a
;src/battle_view.c:779: if(prompt_kind==PROMPT_CHEST){
	ld	a, (#_prompt_kind)
	dec	a
	jr	NZ, 00308$
;src/battle_view.c:780: if(!yes){
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	NZ, 00296$
;src/battle_view.c:781: if(battle_view_menu_allowed){battle_view_field_menu_pending=1;battle_view_state=BVIEW_CHEST_MENU;battle_view_result=BATTLE_VIEW_MENU;}
	ld	a, (#_battle_view_menu_allowed)
	or	a, a
	jr	Z, 00293$
	ld	hl, #_battle_view_field_menu_pending
	ld	(hl), #0x01
	ld	hl, #_battle_view_state
	ld	(hl), #0x0c
	ld	hl, #_battle_view_result
	ld	(hl), #0xfe
	jp	00309$
00293$:
;src/battle_view.c:782: else{battle_view_chest_pending=0;rpg_battle_decline_chest(&battle_view_battle);resume(NEXT_DONE);}
	xor	a, a
	ld	(#_battle_view_chest_pending),a
	ld	de, #_battle_view_battle
	push	de
	ld	e, #b_rpg_battle_decline_chest
	ld	hl, #_rpg_battle_decline_chest
	call	___sdcc_bcall_ehl
	pop	hl
	ld	a, #0x11
	call	_resume
	jr	00309$
00296$:
;src/battle_view.c:784: else battle_view_chest_open();
	ld	e, #b_battle_view_chest_open
	ld	hl, #_battle_view_chest_open
	call	___sdcc_bcall_ehl
	jr	00309$
00308$:
;src/battle_view.c:785: }else if(prompt_kind==PROMPT_FULL){
	ld	a, (#_prompt_kind)
	sub	a, #0x02
	jr	NZ, 00305$
;src/battle_view.c:786: if(yes)say(0xb68c,NEXT_REPLACE,0,0,0);else say(0xb6c1,NEXT_PROMPT_ABANDON,0,battle_view_battle.item_pending,0);
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	Z, 00299$
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x0f
	ld	de, #0xb68c
	call	_say
	jr	00309$
00299$:
	ld	a, (#(_battle_view_battle + 164) + 0)
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x0e
	ld	de, #0xb6c1
	call	_say
	jr	00309$
00305$:
;src/battle_view.c:788: if(yes){id=battle_view_battle.item_pending;rpg_battle_decline_chest(&battle_view_battle);say(0xb6d0,NEXT_CHEST_CLOSE,0,id,0);}
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	Z, 00302$
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
	ld	a, #0x23
	ld	de, #0xb6d0
	call	_say
	jr	00309$
00302$:
;src/battle_view.c:789: else say(0xb68c,NEXT_REPLACE,0,0,0);
	ld	de, #0x0000
	push	de
	xor	a, a
	rrca
	push	af
	ld	a, #0x0f
	ld	de, #0xb68c
	call	_say
00309$:
;src/battle_view.c:791: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00311$:
;src/battle_view.c:799: if(pressed&(J_UP|J_LEFT)){battle_view_choice=battle_view_choice?battle_view_choice-1u:4u;command_screen();}
	ld	a, (#_battle_view_choice)
	dec	a
	ldhl	sp,	#4
	ld	(hl), a
;src/battle_view.c:794: if(pressed&J_B){
	ldhl	sp,	#8
	ld	a, (hl+)
	and	a, #0x20
;src/battle_view.c:799: if(pressed&(J_UP|J_LEFT)){battle_view_choice=battle_view_choice?battle_view_choice-1u:4u;command_screen();}
	ld	(hl-), a
	ld	a, (hl)
	and	a, #0x06
	ldhl	sp,	#5
	ld	(hl), a
;src/battle_view.c:800: if(pressed&(J_DOWN|J_RIGHT)){battle_view_choice=(battle_view_choice+1u)%5u;command_screen();}
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	and	a, #0x09
;src/battle_view.c:801: if(!(pressed&J_A))return battle_view_result;
	ld	(hl+), a
	inc	hl
	ld	a, (hl-)
	and	a, #0x10
	ld	(hl), a
;src/battle_view.c:793: if(battle_view_state==BVIEW_COMMAND){
	ld	a, (#_battle_view_state)
	dec	a
	jp	NZ, 00343$
;src/battle_view.c:794: if(pressed&J_B){
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	Z, 00320$
;src/battle_view.c:795: next=battle_view_actor;while(next){--next;if(eligible(next))break;}
	ld	a, (_battle_view_actor)
	ld	c, a
00314$:
	ld	a, c
	or	a, a
	jr	Z, 00316$
	dec	c
	push	bc
	ld	a, c
	call	_eligible
	pop	bc
	or	a, a
	jr	Z, 00314$
00316$:
;src/battle_view.c:796: if(eligible(next))battle_view_actor=next;
	push	bc
	ld	a, c
	call	_eligible
	pop	bc
	or	a, a
	jr	Z, 00318$
	ld	hl, #_battle_view_actor
	ld	(hl), c
00318$:
;src/battle_view.c:797: battle_view_choice=0;command_screen();return battle_view_result;
	xor	a, a
	ld	(#_battle_view_choice),a
	call	_command_screen
	ld	a, (_battle_view_result)
	jp	00416$
00320$:
;src/battle_view.c:799: if(pressed&(J_UP|J_LEFT)){battle_view_choice=battle_view_choice?battle_view_choice-1u:4u;command_screen();}
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00322$
	ld	a, (#_battle_view_choice)
	or	a, a
	jr	Z, 00446$
	ldhl	sp,	#4
	ld	a, (hl)
	jr	00447$
00446$:
	ld	a, #0x04
00447$:
	ld	(#_battle_view_choice),a
	call	_command_screen
00322$:
;src/battle_view.c:800: if(pressed&(J_DOWN|J_RIGHT)){battle_view_choice=(battle_view_choice+1u)%5u;command_screen();}
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00324$
	ld	a, (_battle_view_choice)
	ld	d, #0x00
	ld	e, a
	inc	de
	ld	bc, #0x0005
	call	__moduint
	ld	hl, #_battle_view_choice
	ld	(hl), c
	call	_command_screen
00324$:
;src/battle_view.c:801: if(!(pressed&J_A))return battle_view_result;
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	NZ, 00326$
	ld	a, (_battle_view_result)
	jp	00416$
00326$:
;src/battle_view.c:802: if(battle_view_choice==0u){actions[battle_view_actor].kind=RPG_ACT_ATTACK;next_character();}
	ld	hl, #_battle_view_actor
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl), a
	ld	a, (#_battle_view_choice)
	or	a, a
	jr	NZ, 00340$
	ld	bc, #_actions+0
	ldhl	sp,	#8
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	(hl), #0x01
	call	_next_character
	jp	00341$
00340$:
;src/battle_view.c:803: else if(battle_view_choice==1u){
	ld	a, (#_battle_view_choice)
	dec	a
	jr	NZ, 00337$
;src/battle_view.c:804: battle_view_choice=0;
	xor	a, a
	ld	(#_battle_view_choice),a
;src/battle_view.c:805: if(!rpg_spell_option(party,battle_view_actor,0,1))say(battle_view_actor==2u?0xb5ba:0xb5c8,NEXT_CHOOSE,battle_view_actor,0,0);
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
	jr	NZ, 00328$
	ld	a, (#_battle_view_actor)
	sub	a, #0x02
	jr	NZ, 00448$
	ld	de, #0xb5ba
	jr	00449$
00448$:
	ld	de, #0xb5c8
00449$:
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
	jr	00341$
00328$:
;src/battle_view.c:806: else spell_screen();
	call	_spell_screen
	jr	00341$
00337$:
;src/battle_view.c:807: }else if(battle_view_choice==2u){battle_view_choice=0;item_screen(0);}
	ld	a, (#_battle_view_choice)
	sub	a, #0x02
	jr	NZ, 00334$
	xor	a, a
	ld	(#_battle_view_choice), a
	call	_item_screen
	jr	00341$
00334$:
;src/battle_view.c:808: else{actions[battle_view_actor].kind=battle_view_choice==3u?RPG_ACT_TALK:RPG_ACT_RUN;if(battle_view_choice==3u)say(0xb128,NEXT_BEGIN_TALK,battle_view_actor,0,0);else start_resolution();}
	ld	bc, #_actions+0
	ldhl	sp,	#8
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (#_battle_view_choice)
	sub	a, #0x03
	ld	a, #0x05
	jr	Z, 00451$
	ld	a, #0x06
00451$:
	ld	(bc), a
	ld	a, (#_battle_view_choice)
	sub	a, #0x03
	jr	NZ, 00331$
	ld	de, #0x0000
	push	de
	xor	a, a
	push	af
	inc	sp
	ld	a, (_battle_view_actor)
	push	af
	inc	sp
	ld	a, #0x17
	ld	de, #0xb128
	call	_say
	jr	00341$
00331$:
	call	_start_resolution
00341$:
;src/battle_view.c:809: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00343$:
;src/battle_view.c:811: if(battle_view_state==BVIEW_SPELL){
	ld	a, (#_battle_view_state)
;src/battle_view.c:812: count=0;while(count<5u&&rpg_spell_option(party,battle_view_actor,count,1))++count;
	sub	a, #0x02
	jp	NZ, 00371$
	ld	b, a
00345$:
	ld	a, b
	sub	a, #0x05
	jr	NC, 00618$
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
	jr	Z, 00618$
	inc	b
	jr	00345$
00618$:
	ldhl	sp,	#8
;src/battle_view.c:813: if(pressed&J_B){battle_view_choice=1;command_screen();return battle_view_result;}
	ld	a, b
	ld	(hl+), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00349$
	ld	hl, #_battle_view_choice
	ld	(hl), #0x01
	call	_command_screen
	ld	a, (_battle_view_result)
	jp	00416$
00349$:
;src/battle_view.c:814: if(count && (pressed&(J_UP|J_LEFT))){battle_view_choice=battle_view_choice?battle_view_choice-1u:count-1u;spell_screen();}
	ld	a, b
	or	a, a
	jr	Z, 00351$
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00351$
	ld	hl, #_battle_view_choice
	ld	a, (hl)
	or	a, a
	jr	Z, 00452$
	ld	b, (hl)
	dec	b
	jr	00453$
00452$:
	dec	b
00453$:
	ld	hl, #_battle_view_choice
	ld	(hl), b
	call	_spell_screen
00351$:
;src/battle_view.c:815: if(count && (pressed&(J_DOWN|J_RIGHT))){battle_view_choice=(battle_view_choice+1u)%count;spell_screen();}
	ldhl	sp,	#8
	ld	a, (hl)
	or	a, a
	jr	Z, 00354$
	dec	hl
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00354$
	ld	a, (#_battle_view_choice)
	ldhl	sp,	#9
	ld	(hl), a
	ld	a, (hl)
	ldhl	sp,	#5
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
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#5
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
00354$:
;src/battle_view.c:816: if(!(pressed&J_A)||!count)return battle_view_result;
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00356$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00357$
00356$:
	ld	a, (_battle_view_result)
	jp	00416$
00357$:
;src/battle_view.c:817: selected_spell=rpg_spell_option(party,battle_view_actor,battle_view_choice,1);
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
	ld	b, a
	ld	hl, #_selection_phase
	ld	(hl), b
;src/battle_view.c:818: if(party->party[battle_view_actor].mp<rpg_magic_cost(selected_spell)){say(0xb6f7,NEXT_SPELLS,battle_view_actor,0,0);return battle_view_result;}
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
	ld	a, (#_battle_view_actor)
	swap	a
	and	a, #0xf0
	ld	l, a
	ld	h, #0x00
	add	hl, de
	inc	hl
	inc	hl
	ld	c, (hl)
	push	bc
	push	bc
	inc	sp
	ld	e, #b_rpg_magic_cost
	ld	hl, #_rpg_magic_cost
	call	___sdcc_bcall_ehl
	inc	sp
	ld	e, a
	pop	bc
	ld	a, c
	sub	a, e
	jr	NC, 00360$
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
	jp	00416$
00360$:
;src/battle_view.c:819: actions[battle_view_actor].kind=RPG_ACT_MAGIC;actions[battle_view_actor].id=selected_spell;
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
	ld	c, l
	ld	b, h
	ld	a, (#_selection_phase + 0)
	ld	(bc), a
;src/battle_view.c:820: if(selected_spell==MagicID_Heal||selected_spell==MagicID_Cure||selected_spell==MagicID_Help){battle_view_choice=battle_view_actor;target_screen();}
	ld	a, (#_selection_phase + 0)
	dec	a
	jr	Z, 00365$
	ld	a, (#_selection_phase + 0)
	sub	a, #0x02
	jr	Z, 00365$
	ld	a, (#_selection_phase + 0)
	sub	a, #0x0a
	jr	NZ, 00366$
00365$:
	ld	a, (#_battle_view_actor)
	ld	(#_battle_view_choice),a
	call	_target_screen
	jr	00367$
00366$:
;src/battle_view.c:821: else if(selected_spell==MagicID_Chat||selected_spell==MagicID_Tele)start_resolution();
	ld	a, (#_selection_phase + 0)
	sub	a, #0x10
	jr	Z, 00361$
	ld	a, (#_selection_phase + 0)
	sub	a, #0x11
	jr	NZ, 00362$
00361$:
	call	_start_resolution
	jr	00367$
00362$:
;src/battle_view.c:822: else next_character();
	call	_next_character
00367$:
;src/battle_view.c:823: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00371$:
;src/battle_view.c:818: if(party->party[battle_view_actor].mp<rpg_magic_cost(selected_spell)){say(0xb6f7,NEXT_SPELLS,battle_view_actor,0,0);return battle_view_result;}
	ld	a, (_party)
	ld	e, a
	ld	hl, #_party + 1
	ld	d, (hl)
;src/battle_view.c:825: if(battle_view_state==BVIEW_TARGET){
	ld	a, (#_battle_view_state)
	sub	a, #0x04
	jp	NZ, 00390$
;src/battle_view.c:826: if(pressed&J_B){battle_view_choice=0;spell_screen();return battle_view_result;}
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl)
	or	a, a
	jr	Z, 00373$
	xor	a, a
	ld	(#_battle_view_choice),a
	call	_spell_screen
	ld	a, (_battle_view_result)
	jp	00416$
00373$:
;src/battle_view.c:827: if(pressed&(J_UP|J_LEFT)){do{battle_view_choice=(battle_view_choice+3u)&3u;}while(!(party->joined_mask&(1u<<battle_view_choice)));target_screen();}
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00378$
00374$:
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
	ldhl	sp,	#8
	ld	(hl), #0x01
	inc	hl
	ld	(hl), #0x00
	inc	b
	jr	01728$
01727$:
	ldhl	sp,	#8
	sla	(hl)
	inc	hl
	rl	(hl)
01728$:
	dec	b
	jr	NZ,01727$
	ldhl	sp,	#8
	and	a, (hl)
	ld	b, #0x00
	or	a, b
	jr	Z, 00374$
	push	bc
	call	_target_screen
	pop	bc
00378$:
;src/battle_view.c:828: if(pressed&(J_DOWN|J_RIGHT)){do{battle_view_choice=(battle_view_choice+1u)&3u;}while(!(party->joined_mask&(1u<<battle_view_choice)));target_screen();}
	ld	a, c
	and	a, #0x09
	jr	Z, 00383$
00379$:
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
	jr	01731$
01730$:
	sla	e
	rl	d
01731$:
	dec	b
	jr	NZ,01730$
	and	a, e
	ld	b, #0x00
	or	a, b
	jr	Z, 00379$
	push	bc
	call	_target_screen
	pop	bc
00383$:
;src/battle_view.c:829: if(pressed&J_A){
	bit	4, c
	jr	Z, 00388$
;src/battle_view.c:830: if(!(party->party[battle_view_choice].status&1u))say(0xb730,NEXT_TARGET,battle_view_choice,0,0);
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
	jr	C, 00385$
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
	jr	00388$
00385$:
;src/battle_view.c:831: else{actions[battle_view_actor].target=battle_view_choice;next_character();}
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
00388$:
;src/battle_view.c:833: return battle_view_result;
	ld	a, (_battle_view_result)
	jp	00416$
00390$:
;src/battle_view.c:835: if(battle_view_state==BVIEW_ITEM||battle_view_state==BVIEW_REPLACE){
	ld	a, (#_battle_view_state)
	sub	a, #0x07
	ld	a, #0x01
	jr	Z, 01736$
	xor	a, a
01736$:
	ld	c, a
	ld	a, (#_battle_view_state)
	sub	a, #0x03
	jr	Z, 00411$
	ld	a, c
	or	a, a
	jp	Z, 00412$
00411$:
;src/battle_view.c:836: next=battle_view_state==BVIEW_REPLACE;
	ldhl	sp,	#8
;src/battle_view.c:837: if(pressed&J_B){if(next)say(0xb671,NEXT_PROMPT_FULL,0,battle_view_battle.item_pending,0);else{battle_view_choice=2;command_screen();}return battle_view_result;}
	ld	a, c
	ld	(hl+), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00395$
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00392$
	ld	a, (#(_battle_view_battle + 164) + 0)
	ld	de, #0x0000
	push	de
	ld	h, a
	ld	l, #0x00
	push	hl
	ld	a, #0x0d
	ld	de, #0xb671
	call	_say
	jr	00393$
00392$:
	ld	hl, #_battle_view_choice
	ld	(hl), #0x02
	call	_command_screen
00393$:
	ld	a, (_battle_view_result)
	jp	00416$
00395$:
;src/battle_view.c:838: count=party->inventory_count;
	ld	hl, #0x0058
	add	hl, de
	ld	a, (hl)
;src/battle_view.c:839: if(count&&(pressed&(J_UP|J_LEFT))){battle_view_choice=battle_view_choice?battle_view_choice-1u:count-1u;item_screen(next);}
	ldhl	sp,#9
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00397$
	ldhl	sp,	#5
	ld	a, (hl)
	or	a, a
	jr	Z, 00397$
	ld	a, (#_battle_view_choice)
	or	a, a
	jr	Z, 00454$
	ldhl	sp,	#4
	ld	a, (hl)
	jr	00455$
00454$:
	ldhl	sp,	#9
	ld	a, (hl)
	dec	a
00455$:
	ld	(#_battle_view_choice),a
	ldhl	sp,	#8
	ld	a, (hl)
	call	_item_screen
00397$:
;src/battle_view.c:840: if(count&&(pressed&(J_DOWN|J_RIGHT))){battle_view_choice=(battle_view_choice+1u)%count;item_screen(next);}
	ldhl	sp,	#9
	ld	a, (hl)
	or	a, a
	jr	Z, 00400$
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	Z, 00400$
	ld	a, (#_battle_view_choice)
	ldhl	sp,	#6
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
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#5
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
	ldhl	sp,	#8
	ld	a, (hl)
	call	_item_screen
00400$:
;src/battle_view.c:841: if(!(pressed&J_A)||!count)return battle_view_result;
	ldhl	sp,	#7
	ld	a, (hl)
	or	a, a
	jr	Z, 00402$
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	NZ, 00403$
00402$:
	ld	a, (_battle_view_result)
	jp	00416$
00403$:
;src/battle_view.c:842: selected_slot=battle_view_choice;id=party->inventory[selected_slot];
	ld	a, (#_battle_view_choice)
	ld	(#_selected_slot),a
	ld	a, (#_party)
	ldhl	sp,	#4
	ld	(hl), a
	ld	a, (#_party + 1)
	ldhl	sp,	#5
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0040
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (#_selected_slot)
	ldhl	sp,	#9
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#6
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#9
;src/battle_view.c:843: if(next){
	ld	(hl-), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00409$
;src/battle_view.c:844: if(!rpg_item_discardable(id))say(0xb6de,NEXT_REPLACE,0,id,0);
	inc	hl
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_rpg_item_discardable
	ld	hl, #_rpg_item_discardable
	call	___sdcc_bcall_ehl
	inc	sp
	or	a, a
	jr	NZ, 00406$
	ld	de, #0x0000
	push	de
	ldhl	sp,	#11
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	ld	a, #0x0f
	ld	de, #0xb6de
	call	_say
	jr	00412$
00406$:
;src/battle_view.c:845: else{replacement_slot=selected_slot;say(0xb69e,NEXT_APPLY_REPLACE,0,id,0);}
	ld	a, (#_selected_slot)
	ld	(#_replacement_slot),a
	ld	de, #0x0000
	push	de
	ldhl	sp,	#11
	ld	h, (hl)
	ld	l, #0x00
	push	hl
	ld	a, #0x10
	ld	de, #0xb69e
	call	_say
	jr	00412$
00409$:
;src/battle_view.c:847: actions[battle_view_actor].kind=RPG_ACT_ITEM;actions[battle_view_actor].id=id;next_character();
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
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl), a
	ld	de, #_actions
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
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
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	ld	d, a
	ld	a, (hl)
	ld	(de), a
	call	_next_character
00412$:
;src/battle_view.c:850: return battle_view_result;
	ld	a, (_battle_view_result)
00416$:
;src/battle_view.c:851: }
	add	sp, #10
	ret
___str_71:
	.ascii "ENEMY HP"
	.db 0x00
___str_72:
	.ascii "CHEST UNAVAILABLE"
	.db 0x00
___str_73:
	.db 0x00
___str_74:
	.ascii ">"
	.db 0x00
___str_75:
	.ascii " "
	.db 0x00
	.area _CODE_30
	.area _INITIALIZER
	.area _CABS (ABS)
