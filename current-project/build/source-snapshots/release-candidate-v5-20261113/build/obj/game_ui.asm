;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module game_ui
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl b_scene_actor_hide
	.globl _scene_actor_hide
	.globl b_movie_scene_show
	.globl _movie_scene_show
	.globl b_scene_fade_begin
	.globl _scene_fade_begin
	.globl b_game_transition_wait
	.globl _game_transition_wait
	.globl b_game_transition_fade_in
	.globl _game_transition_fade_in
	.globl b_game_transition_fade_out
	.globl _game_transition_fade_out
	.globl b_audio_stop
	.globl _audio_stop
	.globl b_audio_command
	.globl _audio_command
	.globl b_ui_number
	.globl _ui_number
	.globl b_ui_text
	.globl _ui_text
	.globl b_ui_panel
	.globl _ui_panel
	.globl b_dialogue_item_name
	.globl _dialogue_item_name
	.globl b_rpg_magic_cost
	.globl _rpg_magic_cost
	.globl b_rpg_spell_option
	.globl _rpg_spell_option
	.globl b_rpg_shop_option
	.globl _rpg_shop_option
	.globl _display_off
	.globl b_title_screen
	.globl _title_screen
	.globl b_menu_screen
	.globl _menu_screen
	.globl b_help_screen
	.globl _help_screen
	.globl b_notice
	.globl _notice
	.globl b_result
	.globl _result
	.globl b_prompt_screen
	.globl _prompt_screen
	.globl b_shop_screen
	.globl _shop_screen
	.globl b_inventory_screen
	.globl _inventory_screen
	.globl b_item_screen
	.globl _item_screen
	.globl b_party_screen
	.globl _party_screen
	.globl b_status_screen
	.globl _status_screen
	.globl b_travel_menu
	.globl _travel_menu
	.globl b_map_magic_screen
	.globl _map_magic_screen
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_title_loaded:
	.ds 1
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
	.area _CODE_14
;src/game_ui.c:20: static void bank_text(uint8_t x,uint8_t y,const char *text) {
;	---------------------------------
; Function bank_text
; ---------------------------------
_bank_text:
	add	sp, #-23
	ldhl	sp,	#22
	ld	(hl-), a
	ld	(hl), e
;src/game_ui.c:22: while(text[i]&&i<20u){copy[i]=text[i];++i;}copy[i]=0;
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
;src/game_ui.c:23: ui_text(x,y,copy);
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
;src/game_ui.c:24: }
	add	sp, #27
	pop	hl
	pop	af
	jp	(hl)
_names:
	.dw __str_0
	.dw __str_1
	.dw __str_2
	.dw __str_3
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
;src/game_ui.c:44: void title_screen(void) RPG_BANKED {
;	---------------------------------
; Function title_screen
; ---------------------------------
	b_title_screen	= 14
_title_screen::
;src/game_ui.c:45: if(screen_state!=STATE_TITLE||!title_loaded) {
	ld	a, (#_screen_state)
	or	a, a
	jr	NZ, 00103$
	ld	a, (#_title_loaded)
	or	a, a
	jp	NZ, 00104$
00103$:
;src/game_ui.c:48: if(!(LCDC_REG&LCDCF_ON)){scene_fade_begin(1u);DISPLAY_ON;}
	ldh	a, (_LCDC_REG + 0)
	rlca
	jr	C, 00102$
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
00102$:
;src/game_ui.c:49: game_transition_fade_out();DISPLAY_OFF;audio_stop();
	ld	e, #b_game_transition_fade_out
	ld	hl, #_game_transition_fade_out
	call	___sdcc_bcall_ehl
	call	_display_off
	ld	e, #b_audio_stop
	ld	hl, #_audio_stop
	call	___sdcc_bcall_ehl
;src/game_ui.c:50: scene_actor_hide();movie_scene_show(MOVIE_TITLE);
	ld	e, #b_scene_actor_hide
	ld	hl, #_scene_actor_hide
	call	___sdcc_bcall_ehl
	ld	a, #0x03
	push	af
	inc	sp
	ld	e, #b_movie_scene_show
	ld	hl, #_movie_scene_show
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_ui.c:51: game_map_music=0; /* Source C260..C2FF clear, including C2F4. */
	xor	a, a
	ld	(#_game_map_music),a
;src/game_ui.c:52: audio_command(0x81);scene_fade_begin(1u);
	ld	a, #0x81
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	ld	a, #0x01
	push	af
	inc	sp
	ld	e, #b_scene_fade_begin
	ld	hl, #_scene_fade_begin
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_ui.c:53: background_changed=1;title_loaded=1;DISPLAY_ON;
	ld	hl, #_background_changed
	ld	(hl), #0x01
	ld	hl, #_title_loaded
	ld	(hl), #0x01
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/game_ui.c:54: game_transition_wait(2u,0u); /* Original0C, then2FD's14 upload. */
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x02
	push	af
	inc	sp
	ld	e, #b_game_transition_wait
	ld	hl, #_game_transition_wait
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_ui.c:55: game_transition_fade_in();
	ld	e, #b_game_transition_fade_in
	ld	hl, #_game_transition_fade_in
	call	___sdcc_bcall_ehl
00104$:
;src/game_ui.c:57: screen_state=STATE_TITLE;HIDE_SPRITES;ui_panel(80,8);
	xor	a, a
	ld	(#_screen_state),a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	ld	a, #0x08
	push	af
	inc	sp
	ld	a, #0x50
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_ui.c:58: ui_text(4,1,"NEW GAME");ui_text(4,3,saved_position_valid?"CONTINUE":"NO SAVE");
	ld	de, #___str_4
	push	de
	ld	e, #0x01
	ld	a, #0x04
	call	_bank_text
	ld	a, (#_saved_position_valid)
	or	a, a
	jr	Z, 00108$
	ld	bc, #___str_5+0
	jr	00109$
00108$:
	ld	bc, #___str_6+0
00109$:
	push	bc
	ld	e, #0x03
	ld	a, #0x04
	call	_bank_text
;src/game_ui.c:59: ui_text(2,1+title_choice*2u,">");
	ld	a, (_title_choice)
	add	a, a
	inc	a
	ld	de, #___str_7
	push	de
	ld	e, a
	ld	a, #0x02
	call	_bank_text
;src/game_ui.c:60: }
	ret
___str_4:
	.ascii "NEW GAME"
	.db 0x00
___str_5:
	.ascii "CONTINUE"
	.db 0x00
___str_6:
	.ascii "NO SAVE"
	.db 0x00
___str_7:
	.ascii ">"
	.db 0x00
;src/game_ui.c:62: void menu_screen(void) RPG_BANKED {
;	---------------------------------
; Function menu_screen
; ---------------------------------
	b_menu_screen	= 14
_menu_screen::
;src/game_ui.c:63: screen_state=STATE_MENU;HIDE_SPRITES;ui_panel(0,18);
	ld	hl, #_screen_state
	ld	(hl), #0x02
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
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
;src/game_ui.c:64: ui_text(4,1,"PHANTASY STAR");ui_text(4,3,"RESUME");ui_text(4,5,"STATUS");
	ld	de, #___str_8
	push	de
	ld	e, #0x01
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_9
	push	de
	ld	e, #0x03
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_10
	push	de
	ld	e, #0x05
	ld	a, #0x04
	call	_bank_text
;src/game_ui.c:65: ui_text(4,7,"ITEMS");ui_text(4,9,"SEARCH");ui_text(4,11,"SAVE");ui_text(4,13,"TITLE");ui_text(4,15,"HELP");
	ld	de, #___str_11
	push	de
	ld	e, #0x07
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_12
	push	de
	ld	e, #0x09
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_13
	push	de
	ld	e, #0x0b
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_14
	push	de
	ld	e, #0x0d
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_15
	push	de
	ld	e, #0x0f
	ld	a, #0x04
	call	_bank_text
;src/game_ui.c:66: ui_text(4,17,"MAGIC");ui_text(2,3+menu_choice*2u,">");ui_text(1,0,"MESETA");ui_number(10,0,game_rpg.money);
	ld	de, #___str_16
	push	de
	ld	e, #0x11
	ld	a, #0x04
	call	_bank_text
	ld	bc, #___str_17+0
	ld	a, (_menu_choice)
	add	a, a
	add	a, #0x03
	push	bc
	ld	e, a
	ld	a, #0x02
	call	_bank_text
	ld	de, #___str_18
	push	de
	ld	e, #0x00
	ld	a, #0x01
	call	_bank_text
	ld	hl, #(_game_rpg + 90)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	xor	a, a
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/game_ui.c:67: }
	ret
___str_8:
	.ascii "PHANTASY STAR"
	.db 0x00
___str_9:
	.ascii "RESUME"
	.db 0x00
___str_10:
	.ascii "STATUS"
	.db 0x00
___str_11:
	.ascii "ITEMS"
	.db 0x00
___str_12:
	.ascii "SEARCH"
	.db 0x00
___str_13:
	.ascii "SAVE"
	.db 0x00
___str_14:
	.ascii "TITLE"
	.db 0x00
___str_15:
	.ascii "HELP"
	.db 0x00
___str_16:
	.ascii "MAGIC"
	.db 0x00
___str_17:
	.ascii ">"
	.db 0x00
___str_18:
	.ascii "MESETA"
	.db 0x00
;src/game_ui.c:69: void help_screen(void) RPG_BANKED {
;	---------------------------------
; Function help_screen
; ---------------------------------
	b_help_screen	= 14
_help_screen::
;src/game_ui.c:70: screen_state=STATE_HELP;HIDE_SPRITES;ui_panel(0,18);
	ld	hl, #_screen_state
	ld	(hl), #0x03
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
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
;src/game_ui.c:71: ui_text(2,1,"PHANTASY STAR");ui_text(1,3,"D-PAD  WALK");ui_text(1,4,"A / B  FIELD MENU");
	ld	de, #___str_19
	push	de
	ld	e, #0x01
	ld	a, #0x02
	call	_bank_text
	ld	de, #___str_20
	push	de
	ld	e, #0x03
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_21
	push	de
	ld	e, #0x04
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:72: ui_text(1,5,"A      CONFIRM");ui_text(1,6,"START  MENU");ui_text(1,7,"SELECT SAVE");
	ld	de, #___str_22
	push	de
	ld	e, #0x05
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_23
	push	de
	ld	e, #0x06
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_24
	push	de
	ld	e, #0x07
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:73: ui_text(1,9,"SELECT SAVES IN THE");ui_text(1,10,"WORLD AND DUNGEONS");
	ld	de, #___str_25
	push	de
	ld	e, #0x09
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_26
	push	de
	ld	e, #0x0a
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:74: ui_text(1,12,"MENU SAVE SUPPORTS");ui_text(1,13,"FIVE NAMED FILES");ui_text(1,16,"A / B TO RETURN");
	ld	de, #___str_27
	push	de
	ld	e, #0x0c
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_28
	push	de
	ld	e, #0x0d
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_29
	push	de
	ld	e, #0x10
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:75: }
	ret
___str_19:
	.ascii "PHANTASY STAR"
	.db 0x00
___str_20:
	.ascii "D-PAD  WALK"
	.db 0x00
___str_21:
	.ascii "A / B  FIELD MENU"
	.db 0x00
___str_22:
	.ascii "A      CONFIRM"
	.db 0x00
___str_23:
	.ascii "START  MENU"
	.db 0x00
___str_24:
	.ascii "SELECT SAVE"
	.db 0x00
___str_25:
	.ascii "SELECT SAVES IN THE"
	.db 0x00
___str_26:
	.ascii "WORLD AND DUNGEONS"
	.db 0x00
___str_27:
	.ascii "MENU SAVE SUPPORTS"
	.db 0x00
___str_28:
	.ascii "FIVE NAMED FILES"
	.db 0x00
___str_29:
	.ascii "A / B TO RETURN"
	.db 0x00
;src/game_ui.c:77: void notice(const char *s,uint8_t return_to) RPG_BANKED {
;	---------------------------------
; Function notice
; ---------------------------------
	b_notice	= 14
_notice::
;src/game_ui.c:78: notice_return=return_to;screen_state=STATE_NOTICE;HIDE_SPRITES;
	ldhl	sp,	#8
	ld	a, (hl)
	ld	(#_notice_return),a
	ld	hl, #_screen_state
	ld	(hl), #0x08
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;src/game_ui.c:79: ui_panel(88,7);ui_text(1,1,s);ui_text(1,5,"A / B TO RETURN");
	ld	a, #0x07
	push	af
	inc	sp
	ld	a, #0x58
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	ld	a,#0x01
	ld	e,a
	call	_bank_text
	ld	de, #___str_30
	push	de
	ld	e, #0x05
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:80: }
	ret
___str_30:
	.ascii "A / B TO RETURN"
	.db 0x00
;src/game_ui.c:82: void result(uint8_t code,uint8_t return_to) RPG_BANKED {
;	---------------------------------
; Function result
; ---------------------------------
	b_result	= 14
_result::
;src/game_ui.c:83: if(code==RPG_OK) notice("DONE",return_to);
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	NZ, 00123$
	inc	hl
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_31
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00123$:
;src/game_ui.c:84: else if(code==RPG_FULL) notice("INVENTORY FULL",return_to);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00120$
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_32
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00120$:
;src/game_ui.c:85: else if(code==RPG_NO_MONEY) notice("NOT ENOUGH MESETA",return_to);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00117$
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_33
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00117$:
;src/game_ui.c:86: else if(code==RPG_PROTECTED_ITEM) notice("CANNOT DISCARD",return_to);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x09
	jr	NZ, 00114$
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_34
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00114$:
;src/game_ui.c:87: else if(code==RPG_CANNOT_EQUIP) notice("CANNOT EQUIP",return_to);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x04
	jr	NZ, 00111$
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_35
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00111$:
;src/game_ui.c:88: else if(code==RPG_DEAD) notice("CHARACTER IS DEAD",return_to);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x05
	jr	NZ, 00108$
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_36
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00108$:
;src/game_ui.c:89: else if(code==RPG_NO_MP) notice("NOT ENOUGH MP",return_to);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x06
	jr	NZ, 00105$
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_37
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00105$:
;src/game_ui.c:90: else if(code==RPG_NOT_IMPLEMENTED) notice("NOT YET IMPLEMENTED",return_to);
	ldhl	sp,	#6
	ld	a, (hl)
	sub	a, #0x08
	jr	NZ, 00102$
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_38
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	ret
00102$:
;src/game_ui.c:91: else notice("CANNOT DO THAT",return_to);
	ldhl	sp,	#7
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #___str_39
	push	de
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/game_ui.c:92: }
	ret
___str_31:
	.ascii "DONE"
	.db 0x00
___str_32:
	.ascii "INVENTORY FULL"
	.db 0x00
___str_33:
	.ascii "NOT ENOUGH MESETA"
	.db 0x00
___str_34:
	.ascii "CANNOT DISCARD"
	.db 0x00
___str_35:
	.ascii "CANNOT EQUIP"
	.db 0x00
___str_36:
	.ascii "CHARACTER IS DEAD"
	.db 0x00
___str_37:
	.ascii "NOT ENOUGH MP"
	.db 0x00
___str_38:
	.ascii "NOT YET IMPLEMENTED"
	.db 0x00
___str_39:
	.ascii "CANNOT DO THAT"
	.db 0x00
;src/game_ui.c:94: void prompt_screen(void) RPG_BANKED {
;	---------------------------------
; Function prompt_screen
; ---------------------------------
	b_prompt_screen	= 14
_prompt_screen::
;src/game_ui.c:95: screen_state=STATE_PROMPT;ui_panel(104,5);ui_text(3,1,"YES");ui_text(12,1,"NO");
	ld	hl, #_screen_state
	ld	a,#0x05
	ld	(hl),a
	push	af
	inc	sp
	ld	a, #0x68
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	de, #___str_40
	push	de
	ld	e, #0x01
	ld	a, #0x03
	call	_bank_text
	ld	de, #___str_41
	push	de
	ld	e, #0x01
	ld	a, #0x0c
	call	_bank_text
;src/game_ui.c:96: ui_text(choice?10:1,1,">");ui_text(1,4,"A / B:CHOOSE");
	ld	bc, #___str_42+0
	ld	a, (#_choice)
	or	a, a
	ld	a, #0x0a
	jr	NZ, 00104$
	ld	a, #0x01
00104$:
	push	bc
	ld	e, #0x01
	call	_bank_text
	ld	de, #___str_43
	push	de
	ld	e, #0x04
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:97: }
	ret
___str_40:
	.ascii "YES"
	.db 0x00
___str_41:
	.ascii "NO"
	.db 0x00
___str_42:
	.ascii ">"
	.db 0x00
___str_43:
	.ascii "A / B:CHOOSE"
	.db 0x00
;src/game_ui.c:99: void shop_screen(void) RPG_BANKED {
;	---------------------------------
; Function shop_screen
; ---------------------------------
	b_shop_screen	= 14
_shop_screen::
	add	sp, #-3
;src/game_ui.c:101: screen_state=STATE_SHOP;HIDE_SPRITES;ui_panel(0,18);shop_count=0;
	ld	hl, #_screen_state
	ld	(hl), #0x06
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
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
	xor	a, a
	ld	(#_shop_count),a
;src/game_ui.c:102: ui_text(7,1,"SHOP");ui_text(1,3,"MESETA");ui_number(10,3,game_rpg.money);
	ld	de, #___str_44
	push	de
	ld	e, #0x01
	ld	a, #0x07
	call	_bank_text
	ld	de, #___str_45
	push	de
	ld	e, #0x03
	ld	a, #0x01
	call	_bank_text
	ld	hl, #(_game_rpg + 90)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
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
;src/game_ui.c:103: for(i=0;i<3;++i) if(rpg_shop_option(shop_id,i,&item,&price)==RPG_OK) {
	ld	c, #0x00
00106$:
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #3
	add	hl, sp
	push	hl
	push	de
	ld	a, c
	push	af
	inc	sp
	ld	a, (_shop_id)
	push	af
	inc	sp
	ld	e, #b_rpg_shop_option
	ld	hl, #_rpg_shop_option
	call	___sdcc_bcall_ehl
	add	sp, #6
	pop	bc
	or	a, a
	jr	NZ, 00107$
;src/game_ui.c:104: dialogue_item_name(item,item_name);ui_text(3,6+i*3u,item_name);ui_number(12,6+i*3u,price);++shop_count;
	push	bc
	ld	de, #_item_name
	push	de
	ldhl	sp,	#4
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_dialogue_item_name
	ld	hl, #_dialogue_item_name
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	ld	a, c
	add	a, a
	add	a, c
	add	a, #0x06
	ld	b, a
	push	bc
	ld	de, #_item_name
	push	de
	ld	e, b
	ld	a, #0x03
	call	_bank_text
	pop	bc
	push	bc
	ldhl	sp,	#3
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	push	de
	push	bc
	inc	sp
	ld	a, #0x0c
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	ld	hl, #_shop_count
	inc	(hl)
00107$:
;src/game_ui.c:103: for(i=0;i<3;++i) if(rpg_shop_option(shop_id,i,&item,&price)==RPG_OK) {
	inc	c
	ld	a, c
	sub	a, #0x03
	jr	C, 00106$
;src/game_ui.c:106: if(choice>=shop_count) choice=0;
	ld	a, (#_choice)
	ld	hl, #_shop_count
	sub	a, (hl)
	jr	C, 00105$
	xor	a, a
	ld	(#_choice),a
00105$:
;src/game_ui.c:107: ui_text(1,6+choice*3u,">");ui_text(1,16,"A:BUY  B:LEAVE");
	ld	a, (_choice)
	ld	c, a
	add	a, a
	add	a, c
	add	a, #0x06
	ld	de, #___str_46
	push	de
	ld	e, a
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_47
	push	de
	ld	e, #0x10
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:108: }
	add	sp, #3
	ret
___str_44:
	.ascii "SHOP"
	.db 0x00
___str_45:
	.ascii "MESETA"
	.db 0x00
___str_46:
	.ascii ">"
	.db 0x00
___str_47:
	.ascii "A:BUY  B:LEAVE"
	.db 0x00
;src/game_ui.c:110: void inventory_screen(void) RPG_BANKED {
;	---------------------------------
; Function inventory_screen
; ---------------------------------
	b_inventory_screen	= 14
_inventory_screen::
;src/game_ui.c:112: if(item_slot>=game_rpg.inventory_count) item_slot=game_rpg.inventory_count?game_rpg.inventory_count-1u:0;
	ld	hl, #(_game_rpg + 88)
	ld	c, (hl)
	ld	a, (#_item_slot)
	sub	a, c
	jr	C, 00102$
	ld	a, c
	or	a, a
	jr	Z, 00112$
	dec	c
	ld	e, c
	jr	00113$
00112$:
	ld	e, #0x00
00113$:
	ld	hl, #_item_slot
	ld	(hl), e
00102$:
;src/game_ui.c:113: start=(item_slot/6u)*6u;
	ld	a, (_item_slot)
	ld	e, #0x06
	call	__divuchar
	ld	a, c
	add	a, a
	add	a, c
	add	a, a
	ld	c, a
;src/game_ui.c:114: screen_state=replace_source?STATE_REPLACE:STATE_INVENTORY;HIDE_SPRITES;ui_panel(0,18);
	ld	a, (#_replace_source)
	or	a, a
	ld	a, #0x07
	jr	NZ, 00115$
	ld	a, #0x09
00115$:
	ld	(#_screen_state),a
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
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
;src/game_ui.c:115: ui_text(2,1,replace_source?"REPLACE WHICH ITEM?":"INVENTORY");
	ld	a, (#_replace_source)
	or	a, a
	jr	Z, 00116$
	ld	de, #___str_48+0
	jr	00117$
00116$:
	ld	de, #___str_49+0
00117$:
	push	bc
	push	de
	ld	e, #0x01
	ld	a, #0x02
	call	_bank_text
	pop	bc
;src/game_ui.c:116: if(!game_rpg.inventory_count) ui_text(4,5,"EMPTY");
	ld	a, (#(_game_rpg + 88) + 0)
	or	a, a
	jr	NZ, 00124$
	push	bc
	ld	de, #___str_50
	push	de
	ld	e, #0x05
	ld	a, #0x04
	call	_bank_text
	pop	bc
;src/game_ui.c:117: for(row=0;row<6u;++row) {
00124$:
	ld	b, #0x00
00108$:
;src/game_ui.c:118: slot=start+row;if(slot>=game_rpg.inventory_count) break;
	ld	a, c
	add	a, b
	ld	hl, #(_game_rpg + 88)
	ld	l, (hl)
	cp	a, l
	jr	NC, 00107$
;src/game_ui.c:119: dialogue_item_name(game_rpg.inventory[slot],item_name);ui_text(4,4+row*2u,item_name);
	ld	l, a
	ld	h, #0x00
	ld	de, #(_game_rpg + 64)
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
	ld	a, b
	add	a, a
	add	a, #0x04
	push	bc
	ld	de, #_item_name
	push	de
	ld	e, a
	ld	a, #0x04
	call	_bank_text
	pop	bc
;src/game_ui.c:117: for(row=0;row<6u;++row) {
	inc	b
	ld	a, b
	sub	a, #0x06
	jr	C, 00108$
00107$:
;src/game_ui.c:121: ui_text(2,4+(item_slot-start)*2u,">");ui_text(1,17,"A:CHOOSE  B:BACK");
	ld	de, #___str_51
	ld	a, (#_item_slot)
	sub	a, c
	add	a, a
	add	a, #0x04
	push	de
	ld	e, a
	ld	a, #0x02
	call	_bank_text
	ld	de, #___str_52
	push	de
	ld	e, #0x11
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:122: }
	ret
___str_48:
	.ascii "REPLACE WHICH ITEM?"
	.db 0x00
___str_49:
	.ascii "INVENTORY"
	.db 0x00
___str_50:
	.ascii "EMPTY"
	.db 0x00
___str_51:
	.ascii ">"
	.db 0x00
___str_52:
	.ascii "A:CHOOSE  B:BACK"
	.db 0x00
;src/game_ui.c:124: void item_screen(void) RPG_BANKED {
;	---------------------------------
; Function item_screen
; ---------------------------------
	b_item_screen	= 14
_item_screen::
;src/game_ui.c:125: screen_state=STATE_ITEM;ui_panel(32,14);dialogue_item_name(game_rpg.inventory[item_slot],item_name);
	ld	hl, #_screen_state
	ld	(hl), #0x0a
	ld	a, #0x0e
	push	af
	inc	sp
	ld	a, #0x20
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
	ld	bc, #_item_name+0
	ld	de, #_game_rpg+64
	ld	a, (_item_slot)
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	push	bc
	push	bc
	push	af
	inc	sp
	ld	e, #b_dialogue_item_name
	ld	hl, #_dialogue_item_name
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/game_ui.c:126: ui_text(5,1,item_name);ui_text(4,4,"USE");ui_text(4,6,"EQUIP");ui_text(4,8,"DROP");
	ld	e, #0x01
	ld	a, #0x05
	call	_bank_text
	ld	de, #___str_53
	push	de
	ld	a,#0x04
	ld	e,a
	call	_bank_text
	ld	de, #___str_54
	push	de
	ld	e, #0x06
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_55
	push	de
	ld	e, #0x08
	ld	a, #0x04
	call	_bank_text
;src/game_ui.c:127: ui_text(2,4+item_action*2u,">");ui_text(1,12,"A:CHOOSE  B:BACK");
	ld	bc, #___str_56+0
	ld	a, (_item_action)
	add	a, a
	add	a, #0x04
	push	bc
	ld	e, a
	ld	a, #0x02
	call	_bank_text
	ld	de, #___str_57
	push	de
	ld	e, #0x0c
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:128: }
	ret
___str_53:
	.ascii "USE"
	.db 0x00
___str_54:
	.ascii "EQUIP"
	.db 0x00
___str_55:
	.ascii "DROP"
	.db 0x00
___str_56:
	.ascii ">"
	.db 0x00
___str_57:
	.ascii "A:CHOOSE  B:BACK"
	.db 0x00
;src/game_ui.c:130: void party_screen(void) RPG_BANKED {
;	---------------------------------
; Function party_screen
; ---------------------------------
	b_party_screen	= 14
_party_screen::
	dec	sp
	dec	sp
;src/game_ui.c:132: screen_state=STATE_PARTY;ui_panel(0,18);ui_text(3,1,"WHICH CHARACTER?");
	ld	hl, #_screen_state
	ld	(hl), #0x0b
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
	ld	de, #___str_58
	push	de
	ld	e, #0x01
	ld	a, #0x03
	call	_bank_text
;src/game_ui.c:133: for(i=0;i<4u;++i) if(game_rpg.joined_mask&(1u<<i)) {
	ld	c, #0x00
00104$:
	ld	a, (#(_game_rpg + 89) + 0)
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
	jr	Z, 00105$
;src/game_ui.c:134: ui_text(3,4+i*3u,names[i]);ui_number(9,4+i*3u,game_rpg.party[i].hp);
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
	call	_bank_text
	pop	bc
	ld	a, c
	swap	a
	and	a, #0xf0
	add	a, #<(_game_rpg)
	ld	e, a
	ld	a, #0x00
	adc	a, #>(_game_rpg)
	ld	d, a
	ld	l, e
	ld	h, d
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
;src/game_ui.c:135: ui_text(12,4+i*3u,"/");ui_number(14,4+i*3u,game_rpg.party[i].max_hp);
	push	bc
	push	de
	ld	hl, #___str_59
	push	hl
	ld	e, b
	ld	a, #0x0c
	call	_bank_text
	pop	de
	pop	bc
	ld	hl, #0x0006
	add	hl, de
	ld	e, (hl)
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
;src/game_ui.c:133: for(i=0;i<4u;++i) if(game_rpg.joined_mask&(1u<<i)) {
	inc	c
	ld	a, c
	sub	a, #0x04
	jp	C, 00104$
;src/game_ui.c:137: ui_text(1,4+party_choice*3u,">");ui_text(1,17,"A:CHOOSE  B:BACK");
	ld	a, (_party_choice)
	ld	c, a
	add	a, a
	add	a, c
	add	a, #0x04
	ld	de, #___str_60
	push	de
	ld	e, a
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_61
	push	de
	ld	e, #0x11
	ld	a, #0x01
;src/game_ui.c:138: }
	call	_bank_text
	pop	hl
	ret
___str_58:
	.ascii "WHICH CHARACTER?"
	.db 0x00
___str_59:
	.ascii "/"
	.db 0x00
___str_60:
	.ascii ">"
	.db 0x00
___str_61:
	.ascii "A:CHOOSE  B:BACK"
	.db 0x00
;src/game_ui.c:140: void status_screen(void) RPG_BANKED {
;	---------------------------------
; Function status_screen
; ---------------------------------
	b_status_screen	= 14
_status_screen::
	add	sp, #-4
;src/game_ui.c:142: screen_state=STATE_STATUS;ui_panel(0,18);ui_text(6,0,"STATUS");
	ld	hl, #_screen_state
	ld	(hl), #0x0d
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
	ld	de, #___str_62
	push	de
	ld	e, #0x00
	ld	a, #0x06
	call	_bank_text
;src/game_ui.c:143: for(i=0;i<4u;++i) if(game_rpg.joined_mask&(1u<<i)) {
	ld	c, #0x00
00104$:
	ld	a, (#(_game_rpg + 89) + 0)
	ld	b, c
	ld	hl, #0x0001
	inc	b
	jr	00131$
00130$:
	add	hl, hl
00131$:
	dec	b
	jr	NZ,00130$
	ld	b, #0x00
	and	a, l
	jp	Z, 00105$
;src/game_ui.c:144: ui_text(1,2+i*3u,names[i]);ui_text(7,2+i*3u,"LV");ui_number(10,2+i*3u,game_rpg.party[i].level);
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
	ldhl	sp,	#2
	ld	(hl+), a
	add	a, #0x02
	ld	(hl), a
	push	bc
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl+)
	inc	hl
	ld	d, a
	push	de
	ld	e, (hl)
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_63
	push	de
	ldhl	sp,	#7
	ld	e, (hl)
	ld	a, #0x07
	call	_bank_text
	pop	bc
	ld	a, c
	swap	a
	and	a, #0xf0
	add	a, #<(_game_rpg)
	ld	e, a
	ld	a, #0x00
	adc	a, #>(_game_rpg)
	ld	d, a
	ld	hl, #0x0005
	add	hl, de
	ld	l, (hl)
	ld	h, #0x00
	push	bc
	push	de
	push	hl
	ldhl	sp,	#9
	ld	a, (hl)
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	pop	bc
;src/game_ui.c:145: ui_text(1,3+i*3u,"HP");ui_number(4,3+i*3u,game_rpg.party[i].hp);
	ldhl	sp,	#2
	ld	b, (hl)
	inc	b
	inc	b
	inc	b
	push	bc
	push	de
	ld	hl, #___str_64
	push	hl
	ld	e, b
	ld	a, #0x01
	call	_bank_text
	pop	de
	pop	bc
	ld	l, e
	ld	h, d
	inc	hl
	ld	l, (hl)
	ld	h, #0x00
	push	bc
	push	de
	push	hl
	push	bc
	inc	sp
	ld	a, #0x04
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	de
	pop	bc
;src/game_ui.c:146: ui_text(9,3+i*3u,"MP");ui_number(12,3+i*3u,game_rpg.party[i].mp);
	push	bc
	push	de
	ld	hl, #___str_65
	push	hl
	ld	e, b
	ld	a, #0x09
	call	_bank_text
	pop	de
	pop	bc
	inc	de
	inc	de
	ld	a, (de)
	ld	e, a
	ld	d, #0x00
	push	bc
	push	de
	push	bc
	inc	sp
	ld	a, #0x0c
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
00105$:
;src/game_ui.c:143: for(i=0;i<4u;++i) if(game_rpg.joined_mask&(1u<<i)) {
	inc	c
	ld	a, c
	sub	a, #0x04
	jp	C, 00104$
;src/game_ui.c:148: ui_text(1,15,"MESETA");ui_number(10,15,game_rpg.money);ui_text(1,17,"A / B TO RETURN");
	ld	de, #___str_66
	push	de
	ld	e, #0x0f
	ld	a, #0x01
	call	_bank_text
	ld	hl, #(_game_rpg + 90)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	push	bc
	ld	a, #0x0f
	push	af
	inc	sp
	ld	a, #0x0a
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	de, #___str_67
	push	de
	ld	e, #0x11
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:149: }
	add	sp, #4
	ret
___str_62:
	.ascii "STATUS"
	.db 0x00
___str_63:
	.ascii "LV"
	.db 0x00
___str_64:
	.ascii "HP"
	.db 0x00
___str_65:
	.ascii "MP"
	.db 0x00
___str_66:
	.ascii "MESETA"
	.db 0x00
___str_67:
	.ascii "A / B TO RETURN"
	.db 0x00
;src/game_ui.c:151: void travel_menu(void) RPG_BANKED {
;	---------------------------------
; Function travel_menu
; ---------------------------------
	b_travel_menu	= 14
_travel_menu::
;src/game_ui.c:152: screen_state=STATE_TRAVEL_MENU;HIDE_SPRITES;ui_panel(48,12);
	ld	hl, #_screen_state
	ld	(hl), #0x10
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	ld	a, #0x0c
	push	af
	inc	sp
	ld	a, #0x30
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_ui.c:153: ui_text(4,1,"DESTINATION");ui_text(4,4,"GOTHIC");ui_text(4,6,"UZO");ui_text(4,8,"SKURE");
	ld	de, #___str_68
	push	de
	ld	e, #0x01
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_69
	push	de
	ld	a,#0x04
	ld	e,a
	call	_bank_text
	ld	de, #___str_70
	push	de
	ld	e, #0x06
	ld	a, #0x04
	call	_bank_text
	ld	de, #___str_71
	push	de
	ld	e, #0x08
	ld	a, #0x04
	call	_bank_text
;src/game_ui.c:154: ui_text(2,4+choice*2u,">");ui_text(1,11,"A:CHOOSE  B:BACK");
	ld	bc, #___str_72+0
	ld	a, (_choice)
	add	a, a
	add	a, #0x04
	push	bc
	ld	e, a
	ld	a, #0x02
	call	_bank_text
	ld	de, #___str_73
	push	de
	ld	e, #0x0b
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:155: }
	ret
___str_68:
	.ascii "DESTINATION"
	.db 0x00
___str_69:
	.ascii "GOTHIC"
	.db 0x00
___str_70:
	.ascii "UZO"
	.db 0x00
___str_71:
	.ascii "SKURE"
	.db 0x00
___str_72:
	.ascii ">"
	.db 0x00
___str_73:
	.ascii "A:CHOOSE  B:BACK"
	.db 0x00
;src/game_ui.c:156: void map_magic_screen(void) RPG_BANKED {
;	---------------------------------
; Function map_magic_screen
; ---------------------------------
	b_map_magic_screen	= 14
_map_magic_screen::
;src/game_ui.c:158: uint8_t i,id;screen_state=19;HIDE_SPRITES;ui_panel(0,18);
	ld	hl, #_screen_state
	ld	(hl), #0x13
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
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
;src/game_ui.c:159: ui_text(1,1,names[magic_caster]);ui_text(8,1,"MAGIC");
	ld	bc, #_names+0
	ld	a, (_magic_caster)
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
	call	_bank_text
	ld	de, #___str_93
	push	de
	ld	e, #0x01
	ld	a, #0x08
	call	_bank_text
;src/game_ui.c:160: for(i=0;i<5u;++i){id=rpg_spell_option(&game_rpg,magic_caster,i,0);if(!id)break;
	ld	b, #0x00
00104$:
	push	bc
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	a, (_magic_caster)
	push	af
	inc	sp
	ld	de, #_game_rpg
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
;src/game_ui.c:161: ui_text(3,4+i*2u,spells[id]);ui_text(11,4+i*2u,"MP");ui_number(15,4+i*2u,rpg_magic_cost(id));}
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	ld	de, #_map_magic_screen_spells_10000_286
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
	call	_bank_text
	pop	de
	push	de
	ld	hl, #___str_94
	push	hl
	ld	a, #0x0b
	call	_bank_text
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
;src/game_ui.c:160: for(i=0;i<5u;++i){id=rpg_spell_option(&game_rpg,magic_caster,i,0);if(!id)break;
	inc	b
	ld	a, b
	sub	a, #0x05
	jr	C, 00104$
00103$:
;src/game_ui.c:162: ui_text(1,4+magic_choice*2u,">");ui_text(1,17,"A:CHOOSE B:BACK");
	ld	a, (_magic_choice)
	add	a, a
	add	a, #0x04
	ld	de, #___str_95
	push	de
	ld	e, a
	ld	a, #0x01
	call	_bank_text
	ld	de, #___str_96
	push	de
	ld	e, #0x11
	ld	a, #0x01
	call	_bank_text
;src/game_ui.c:163: }
	ret
_map_magic_screen_spells_10000_286:
	.dw ___str_74
	.dw ___str_75
	.dw ___str_76
	.dw ___str_77
	.dw ___str_78
	.dw ___str_79
	.dw ___str_80
	.dw ___str_81
	.dw ___str_82
	.dw ___str_83
	.dw ___str_84
	.dw ___str_85
	.dw ___str_86
	.dw ___str_87
	.dw ___str_88
	.dw ___str_89
	.dw ___str_90
	.dw ___str_91
	.dw ___str_92
___str_74:
	.db 0x00
___str_75:
	.ascii "HEAL"
	.db 0x00
___str_76:
	.ascii "CURE"
	.db 0x00
___str_77:
	.ascii "WALL"
	.db 0x00
___str_78:
	.ascii "PROT"
	.db 0x00
___str_79:
	.ascii "FIRE"
	.db 0x00
___str_80:
	.ascii "THUN"
	.db 0x00
___str_81:
	.ascii "WIND"
	.db 0x00
___str_82:
	.ascii "ROPE"
	.db 0x00
___str_83:
	.ascii "BYE"
	.db 0x00
___str_84:
	.ascii "HELP"
	.db 0x00
___str_85:
	.ascii "TERR"
	.db 0x00
___str_86:
	.ascii "TRAP"
	.db 0x00
___str_87:
	.ascii "EXIT"
	.db 0x00
___str_88:
	.ascii "OPEN"
	.db 0x00
___str_89:
	.ascii "RISE"
	.db 0x00
___str_90:
	.ascii "CHAT"
	.db 0x00
___str_91:
	.ascii "TELE"
	.db 0x00
___str_92:
	.ascii "FLY"
	.db 0x00
___str_93:
	.ascii "MAGIC"
	.db 0x00
___str_94:
	.ascii "MP"
	.db 0x00
___str_95:
	.ascii ">"
	.db 0x00
___str_96:
	.ascii "A:CHOOSE B:BACK"
	.db 0x00
	.area _CODE_14
	.area _INITIALIZER
	.area _CABS (ABS)
