;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module save_ui
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _start_game
	.globl b_ui_number
	.globl _ui_number
	.globl b_ui_text
	.globl _ui_text
	.globl b_ui_panel
	.globl _ui_panel
	.globl b_notice
	.globl _notice
	.globl b_menu_screen
	.globl _menu_screen
	.globl b_title_screen
	.globl _title_screen
	.globl _game_write_slot
	.globl _game_read_slot
	.globl b_save_name_input
	.globl _save_name_input
	.globl b_save_name_move
	.globl _save_name_move
	.globl b_save_name_begin
	.globl _save_name_begin
	.globl b_save_name_character
	.globl _save_name_character
	.globl b_save_label_encode
	.globl _save_label_encode
	.globl b_save_label_decode
	.globl _save_label_decode
	.globl b_save_slot_offset
	.globl _save_slot_offset
	.globl _save_ui_mode
	.globl _save_ui_choice
	.globl _save_valid_mask
	.globl _save_active_slot
	.globl b_save_ui_scan
	.globl _save_ui_scan
	.globl b_save_ui_open
	.globl _save_ui_open
	.globl b_save_ui_tick
	.globl _save_ui_tick
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_labels:
	.ds 30
_editor:
	.ds 7
_return_state:
	.ds 1
_answer:
	.ds 1
_name_repeat:
	.ds 1
_name_keys:
	.ds 1
_save_active_slot::
	.ds 1
_save_valid_mask::
	.ds 1
_save_ui_choice::
	.ds 1
_save_ui_mode::
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
	.area _CODE_122
;src/save_ui.c:12: static void text(uint8_t x,uint8_t y,const char *s) {
;	---------------------------------
; Function text
; ---------------------------------
_text:
	add	sp, #-23
	ldhl	sp,	#22
	ld	(hl-), a
	ld	(hl), e
;src/save_ui.c:13: char copy[21];uint8_t i=0;while(s[i]&&i<20u){copy[i]=s[i];++i;}copy[i]=0;ui_text(x,y,copy);
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
;src/save_ui.c:14: }
	add	sp, #27
	pop	hl
	pop	af
	jp	(hl)
;src/save_ui.c:15: static void read_label(uint8_t slot) {
;	---------------------------------
; Function read_label
; ---------------------------------
_read_label:
	add	sp, #-12
	ldhl	sp,	#10
	ld	(hl), a
;src/save_ui.c:16: uint8_t data[8],i;uint16_t address=0xa000u+SAVE_LABEL_OFFSET+(uint16_t)slot*SAVE_LABEL_BYTES;
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	a, h
	add	a, #0xb4
	ldhl	sp,	#8
	ld	(hl), c
	inc	hl
	ld	(hl), a
;src/save_ui.c:17: ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);
	ld	hl, #_rRAMG
	ld	(hl), #0x0a
	xor	a, a
	ld	(#_rRAMB),a
;src/save_ui.c:18: for(i=0;i<8u;++i)data[i]=*(volatile uint8_t *)(address+i);
	ldhl	sp,	#11
	ld	(hl), #0x00
00102$:
	push	hl
	ld	hl, #2
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#11
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#11
	ld	a, (hl)
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	ld	(bc), a
	ldhl	sp,	#11
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x08
	jr	C, 00102$
;src/save_ui.c:19: DISABLE_RAM_MBC5;save_label_decode(labels[slot],data);labels[slot][5]=0;
	xor	a, a
	ld	(#_rRAMG),a
	ldhl	sp,	#10
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	ld	c, l
	ld	b, h
	ld	hl, #_labels
	add	hl, bc
	ld	e, l
	ld	d, h
	push	bc
	ld	hl, #2
	add	hl, sp
	push	hl
	push	de
	ld	e, #b_save_label_decode
	ld	hl, #_save_label_decode
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	ld	hl, #_labels + 0x0005
	add	hl, bc
	ld	(hl), #0x00
;src/save_ui.c:20: }
	add	sp, #12
	ret
;src/save_ui.c:21: static void write_label(uint8_t slot) {
;	---------------------------------
; Function write_label
; ---------------------------------
_write_label:
	add	sp, #-13
	ldhl	sp,	#12
	ld	(hl), a
;src/save_ui.c:22: uint8_t data[8],i;uint16_t address=0xa000u+SAVE_LABEL_OFFSET+(uint16_t)slot*SAVE_LABEL_BYTES;
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	c, l
	ld	a, h
	add	a, #0xb4
	ld	b, a
	ldhl	sp,	#10
	ld	(hl), c
	inc	hl
	ld	(hl), b
;src/save_ui.c:23: if(!save_label_encode(data,editor.name))return;
	ld	bc, #_editor+0
	ld	hl, #0
	add	hl, sp
	push	bc
	push	hl
	ld	e, #b_save_label_encode
	ld	hl, #_save_label_encode
	call	___sdcc_bcall_ehl
	add	sp, #4
	ldhl	sp,#9
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00108$
;src/save_ui.c:24: ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);*(volatile uint8_t *)(address+5u)=0;
	ld	hl, #_rRAMG
	ld	(hl), #0x0a
	xor	a, a
	ld	(#_rRAMB),a
	ldhl	sp,	#10
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#11
	ld	a, (hl-)
	dec	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/save_ui.c:25: for(i=0;i<8u;++i)if(i!=5u)*(volatile uint8_t *)(address+i)=data[i];
	ld	e, #0x00
00106$:
	ld	a, e
	sub	a, #0x05
	jr	Z, 00107$
	ld	c, e
	ld	b, #0x00
	ldhl	sp,	#8
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
	push	de
	ld	d, #0x00
	ld	hl, #2
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, (hl)
	ld	(bc), a
00107$:
	inc	e
	ld	a, e
	sub	a, #0x08
	jr	C, 00106$
;src/save_ui.c:26: *(volatile uint8_t *)(address+5u)=data[5];DISABLE_RAM_MBC5;read_label(slot);
	ldhl	sp,	#5
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	dec	hl
	ld	d, a
	ld	a, (hl)
	ld	(de), a
	xor	a, a
	ld	(#_rRAMG),a
	ldhl	sp,	#12
	ld	a, (hl)
	call	_read_label
00108$:
;src/save_ui.c:27: }
	add	sp, #13
	ret
;src/save_ui.c:28: void save_ui_scan(void) RPG_BANKED {
;	---------------------------------
; Function save_ui_scan
; ---------------------------------
	b_save_ui_scan	= 122
_save_ui_scan::
;src/save_ui.c:29: uint8_t i,first=255;save_valid_mask=0;
	ld	e, #0xff
	xor	a, a
	ld	(#_save_valid_mask),a
;src/save_ui.c:30: for(i=0;i<5u;++i){if(game_read_slot(i)){save_valid_mask|=1u<<i;if(first==255u)first=i;}read_label(i);}
	ld	d, #0x00
00111$:
	push	de
	ld	a, d
	call	_game_read_slot
	pop	de
	or	a, a
	jr	Z, 00104$
	ld	b, d
	ld	a, #0x01
	inc	b
	jr	00159$
00158$:
	add	a, a
00159$:
	dec	b
	jr	NZ,00158$
	ld	hl, #_save_valid_mask
	or	a, (hl)
	ld	(hl), a
	ld	a, e
	inc	a
	jr	NZ, 00104$
	ld	e, d
00104$:
	push	de
	ld	a, d
	call	_read_label
	pop	de
	inc	d
	ld	a, d
	sub	a, #0x05
	jr	C, 00111$
;src/save_ui.c:31: if(first==255u)save_active_slot=0;
	ld	a, e
	inc	a
	jr	NZ, 00109$
	ld	(#_save_active_slot),a
	jr	00110$
00109$:
;src/save_ui.c:32: else if(!(save_valid_mask&(1u<<save_active_slot)))save_active_slot=first;
	ld	hl, #_save_active_slot
	ld	a, (hl)
	push	af
	ld	bc, #0x0001
	pop	af
	inc	a
	jr	00165$
00164$:
	sla	c
	rl	b
00165$:
	dec	a
	jr	NZ,00164$
	ld	a, (_save_valid_mask)
	and	a, c
	ld	c, #0x00
	or	a, c
	jr	NZ, 00110$
	ld	(hl), e
00110$:
;src/save_ui.c:33: game_read_slot(save_active_slot);saved_position_valid=!!save_valid_mask;
	ld	a, (_save_active_slot)
	call	_game_read_slot
	ld	a, (#_save_valid_mask)
	sub	a, #0x01
	ld	a, #0x00
	rla
	xor	a, #0x01
	ld	(#_saved_position_valid),a
;src/save_ui.c:34: }
	ret
;src/save_ui.c:35: static void back(void) {
;	---------------------------------
; Function back
; ---------------------------------
_back:
;src/save_ui.c:36: if(return_state==0u){title_choice=saved_position_valid?1u:0u;title_screen();}
	ld	a, (#_return_state)
	or	a, a
	jr	NZ, 00102$
	ld	a, (#_saved_position_valid)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00107$
	xor	a, a
00107$:
	ld	(#_title_choice),a
	ld	e, #b_title_screen
	ld	hl, #_title_screen
	jp  ___sdcc_bcall_ehl
00102$:
;src/save_ui.c:37: else menu_screen();
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
;src/save_ui.c:38: }
	jp  ___sdcc_bcall_ehl
;src/save_ui.c:39: static void action_screen(void) {
;	---------------------------------
; Function action_screen
; ---------------------------------
_action_screen:
;src/save_ui.c:40: screen_state=STATE_SAVE_ACTION;HIDE_SPRITES;ui_panel(40,13);
	ld	hl, #_screen_state
	ld	(hl), #0x19
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
	ld	a, #0x0d
	push	af
	inc	sp
	ld	a, #0x28
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
;src/save_ui.c:41: text(4,1,"SAVED GAMES");text(4,4,"CONTINUE");text(4,6,"DELETE");
	ld	de, #___str_0
	push	de
	ld	e, #0x01
	ld	a, #0x04
	call	_text
	ld	de, #___str_1
	push	de
	ld	a,#0x04
	ld	e,a
	call	_text
	ld	de, #___str_2
	push	de
	ld	e, #0x06
	ld	a, #0x04
	call	_text
;src/save_ui.c:42: text(2,4+save_ui_choice*2u,">");text(1,10,"A:CHOOSE  B:BACK");
	ld	bc, #___str_3+0
	ld	a, (_save_ui_choice)
	add	a, a
	add	a, #0x04
	push	bc
	ld	e, a
	ld	a, #0x02
	call	_text
	ld	de, #___str_4
	push	de
	ld	e, #0x0a
	ld	a, #0x01
	call	_text
;src/save_ui.c:43: }
	ret
___str_0:
	.ascii "SAVED GAMES"
	.db 0x00
___str_1:
	.ascii "CONTINUE"
	.db 0x00
___str_2:
	.ascii "DELETE"
	.db 0x00
___str_3:
	.ascii ">"
	.db 0x00
___str_4:
	.ascii "A:CHOOSE  B:BACK"
	.db 0x00
;src/save_ui.c:44: static void slot_screen(void) {
;	---------------------------------
; Function slot_screen
; ---------------------------------
_slot_screen:
;src/save_ui.c:45: uint8_t i;screen_state=STATE_SAVE_SELECT;HIDE_SPRITES;ui_panel(0,18);
	ld	hl, #_screen_state
	ld	(hl), #0x1a
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
;src/save_ui.c:46: text(3,1,save_ui_mode==SAVE_UI_SAVE?"SAVE WHICH FILE?":save_ui_mode==SAVE_UI_LOAD?"LOAD WHICH FILE?":"ERASE WHICH FILE?");
	ld	a, (#_save_ui_mode)
	dec	a
	jr	NZ, 00106$
	ld	bc, #___str_5+0
	jr	00107$
00106$:
	ld	a, (#_save_ui_mode)
	sub	a, #0x02
	jr	NZ, 00108$
	ld	bc, #___str_6+0
	jr	00109$
00108$:
	ld	bc, #___str_7+0
00109$:
00107$:
	push	bc
	ld	e, #0x01
	ld	a, #0x03
	call	_text
;src/save_ui.c:47: for(i=0;i<5u;++i){ui_number(3,4+i*2u,i+1u);text(6,4+i*2u,(save_valid_mask&(1u<<i))?labels[i]:"EMPTY");}
	ld	c, #0x00
00102$:
	ld	e, c
	inc	e
	ld	d, #0x00
	ld	a, c
	add	a, a
	add	a, #0x04
	ld	b, a
	push	bc
	push	de
	push	bc
	inc	sp
	ld	a, #0x03
	push	af
	inc	sp
	ld	e, #b_ui_number
	ld	hl, #_ui_number
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
	ld	a, c
	push	af
	ld	hl, #0x0001
	pop	af
	inc	a
	jr	00153$
00152$:
	add	hl, hl
00153$:
	dec	a
	jr	NZ,00152$
	ld	a, (_save_valid_mask)
	and	a, l
	ld	e, #0x00
	or	a, e
	jr	Z, 00110$
	ld	e, c
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	ld	de, #_labels
	add	hl, de
	jr	00111$
00110$:
	ld	hl, #___str_8
00111$:
	push	bc
	push	hl
	ld	e, b
	ld	a, #0x06
	call	_text
	pop	bc
	inc	c
	ld	a, c
	sub	a, #0x05
	jr	C, 00102$
;src/save_ui.c:48: text(1,4+save_ui_choice*2u,">");text(1,16,"A:CHOOSE  B:BACK");
	ld	bc, #___str_9
	ld	a, (_save_ui_choice)
	add	a, a
	add	a, #0x04
	ld	e, a
	push	bc
	ld	a, #0x01
	call	_text
	ld	de, #___str_10
	push	de
	ld	e, #0x10
	ld	a, #0x01
	call	_text
;src/save_ui.c:49: }
	ret
___str_5:
	.ascii "SAVE WHICH FILE?"
	.db 0x00
___str_6:
	.ascii "LOAD WHICH FILE?"
	.db 0x00
___str_7:
	.ascii "ERASE WHICH FILE?"
	.db 0x00
___str_8:
	.ascii "EMPTY"
	.db 0x00
___str_9:
	.ascii ">"
	.db 0x00
___str_10:
	.ascii "A:CHOOSE  B:BACK"
	.db 0x00
;src/save_ui.c:50: static void confirm_screen(void) {
;	---------------------------------
; Function confirm_screen
; ---------------------------------
_confirm_screen:
;src/save_ui.c:51: screen_state=STATE_SAVE_CONFIRM;ui_panel(64,10);
	ld	hl, #_screen_state
	ld	(hl), #0x1b
	ld	a, #0x0a
	push	af
	inc	sp
	ld	a, #0x40
	push	af
	inc	sp
	ld	e, #b_ui_panel
	ld	hl, #_ui_panel
	call	___sdcc_bcall_ehl
	pop	hl
;src/save_ui.c:52: text(2,1,save_ui_mode==SAVE_UI_SAVE?"SAVE THIS FILE?":"ERASE THIS FILE?");
	ld	a, (#_save_ui_mode)
	dec	a
	jr	NZ, 00103$
	ld	bc, #___str_11+0
	jr	00104$
00103$:
	ld	bc, #___str_12+0
00104$:
	push	bc
	ld	e, #0x01
	ld	a, #0x02
	call	_text
;src/save_ui.c:53: text(4,4,"YES");text(12,4,"NO");text(answer?10:2,4,">");
	ld	de, #___str_13
	push	de
	ld	a,#0x04
	ld	e,a
	call	_text
	ld	de, #___str_14
	push	de
	ld	e, #0x04
	ld	a, #0x0c
	call	_text
	ld	bc, #___str_15+0
	ld	a, (#_answer)
	or	a, a
	ld	a, #0x0a
	jr	NZ, 00106$
	ld	a, #0x02
00106$:
	push	bc
	ld	e, #0x04
	call	_text
;src/save_ui.c:54: text(1,7,"A:CHOOSE  B:BACK");
	ld	de, #___str_16
	push	de
	ld	e, #0x07
	ld	a, #0x01
	call	_text
;src/save_ui.c:55: }
	ret
___str_11:
	.ascii "SAVE THIS FILE?"
	.db 0x00
___str_12:
	.ascii "ERASE THIS FILE?"
	.db 0x00
___str_13:
	.ascii "YES"
	.db 0x00
___str_14:
	.ascii "NO"
	.db 0x00
___str_15:
	.ascii ">"
	.db 0x00
___str_16:
	.ascii "A:CHOOSE  B:BACK"
	.db 0x00
;src/save_ui.c:56: static void name_screen(void) {
;	---------------------------------
; Function name_screen
; ---------------------------------
_name_screen:
	add	sp, #-10
;src/save_ui.c:57: uint8_t i,c;char one[2],name[6];screen_state=STATE_SAVE_NAME;HIDE_SPRITES;ui_panel(0,18);
	ld	hl, #_screen_state
	ld	(hl), #0x1c
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
;src/save_ui.c:58: text(3,0,"NAME THIS FILE");for(i=0;i<5u;++i)name[i]=editor.name[i];name[5]=0;text(7,2,name);
	ld	de, #___str_17
	push	de
	ld	e, #0x00
	ld	a, #0x03
	call	_text
	ld	c, #0x00
00103$:
	ld	e, c
	ld	d, #0x00
	ld	hl, #2
	add	hl, sp
	add	hl, de
	ld	e, l
	ld	d, h
	ld	hl, #_editor
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
	inc	c
	ld	a, c
	sub	a, #0x05
	jr	C, 00103$
	ldhl	sp,	#7
	ld	(hl), #0x00
	ld	hl, #2
	add	hl, sp
	push	hl
	ld	e, #0x02
	ld	a, #0x07
	call	_text
;src/save_ui.c:59: text(7+editor.cursor,3,"^");one[1]=0;
	ld	bc, #___str_18+0
	ld	a, (#(_editor + 5) + 0)
	add	a, #0x07
	push	bc
	ld	e, #0x03
	call	_text
	ldhl	sp,	#1
	ld	(hl), #0x00
;src/save_ui.c:60: for(i=0;i<36u;++i){c=save_name_character(i);one[0]=c;
	ldhl	sp,	#9
	ld	(hl), #0x00
00105$:
	ldhl	sp,	#9
	ld	a, (hl)
	push	af
	inc	sp
	ld	e, #b_save_name_character
	ld	hl, #_save_name_character
	call	___sdcc_bcall_ehl
	inc	sp
	ldhl	sp,	#0
	ld	(hl), a
;src/save_ui.c:61: text(1+(i%6u)*3u,5+(i/6u)*2u,c==0x5cu?">":c==0x5du?"<":c==0x5eu?"END":one);}
	cp	a, #0x5c
	jr	NZ, 00109$
	ld	bc, #___str_19
	jr	00110$
00109$:
	cp	a, #0x5d
	jr	NZ, 00111$
	ld	bc, #___str_20
	jr	00112$
00111$:
	sub	a, #0x5e
	jr	NZ, 00113$
	ld	bc, #___str_21
	jr	00114$
00113$:
	ld	hl, #0
	add	hl, sp
	ld	c, l
	ld	b, h
00114$:
00112$:
00110$:
	ldhl	sp,	#9
	ld	d, (hl)
	push	bc
	push	de
	ld	e, #0x06
	ld	a, d
	call	__divuchar
	ld	a, c
	pop	de
	pop	bc
	add	a, a
	add	a, #0x05
	ldhl	sp,	#8
	ld	(hl), a
	push	bc
	ld	e, #0x06
	ld	a, d
	call	__moduchar
	ld	a, c
	pop	bc
	ld	e, a
	add	a, a
	add	a, e
	inc	a
	push	bc
	ldhl	sp,	#10
	ld	e, (hl)
	call	_text
;src/save_ui.c:60: for(i=0;i<36u;++i){c=save_name_character(i);one[0]=c;
	ldhl	sp,	#9
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x24
	jr	C, 00105$
;src/save_ui.c:62: text((editor.option%6u)*3u,5+(editor.option/6u)*2u,">");
	ld	hl, #(_editor + 6)
	ld	c, (hl)
	push	bc
	ld	e, #0x06
	ld	a, c
	call	__divuchar
	ld	a, c
	pop	bc
	add	a, a
	add	a, #0x05
	ld	b, a
	push	bc
	ld	e, #0x06
	ld	a, c
	call	__moduchar
	ld	a, c
	pop	bc
	ld	e, a
	add	a, a
	add	a, e
	ld	de, #___str_19
	push	de
	ld	e, b
	call	_text
;src/save_ui.c:63: text(1,17,"A:ENTER  B:ERASE");
	ld	de, #___str_22
	push	de
	ld	e, #0x11
	ld	a, #0x01
	call	_text
;src/save_ui.c:64: }
	add	sp, #10
	ret
___str_17:
	.ascii "NAME THIS FILE"
	.db 0x00
___str_18:
	.ascii "^"
	.db 0x00
___str_19:
	.ascii ">"
	.db 0x00
___str_20:
	.ascii "<"
	.db 0x00
___str_21:
	.ascii "END"
	.db 0x00
___str_22:
	.ascii "A:ENTER  B:ERASE"
	.db 0x00
;src/save_ui.c:65: void save_ui_open(uint8_t mode,uint8_t returning) RPG_BANKED {
;	---------------------------------
; Function save_ui_open
; ---------------------------------
	b_save_ui_open	= 122
_save_ui_open::
;src/save_ui.c:66: save_ui_scan();save_ui_mode=mode;return_state=returning;
	ld	e, #b_save_ui_scan
	ld	hl, #_save_ui_scan
	call	___sdcc_bcall_ehl
	ldhl	sp,	#6
	ld	c, (hl)
	ld	hl, #_save_ui_mode
	ld	(hl), c
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(#_return_state),a
;src/save_ui.c:67: save_ui_choice=mode==SAVE_UI_LOAD?0u:save_active_slot;
	ld	a, c
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00123$
	xor	a, a
00123$:
	or	a, a
	jr	Z, 00106$
	ld	c, #0x00
	jr	00107$
00106$:
	ld	hl, #_save_active_slot
	ld	c, (hl)
00107$:
	ld	hl, #_save_ui_choice
	ld	(hl), c
;src/save_ui.c:68: if(mode==SAVE_UI_LOAD)action_screen();else slot_screen();
	or	a, a
	jp	Z, _slot_screen
;src/save_ui.c:69: }
	jp	_action_screen
;src/save_ui.c:70: void save_ui_tick(uint8_t keys,uint8_t pressed) RPG_BANKED {
;	---------------------------------
; Function save_ui_tick
; ---------------------------------
	b_save_ui_tick	= 122
_save_ui_tick::
	add	sp, #-14
;src/save_ui.c:71: uint8_t was_valid,move=0;uint16_t offset;
	ldhl	sp,	#12
	ld	(hl), #0x00
;src/save_ui.c:73: if(pressed&J_B){back();return;}
	ldhl	sp,	#21
	ld	c, (hl)
	ld	a, c
	and	a, #0x20
	ld	e, a
;src/save_ui.c:75: else if(pressed&J_A){save_ui_mode=save_ui_choice?SAVE_UI_DELETE:SAVE_UI_LOAD;save_ui_choice=save_active_slot;slot_screen();}
	ld	a, c
	and	a, #0x10
	ld	b, a
;src/save_ui.c:72: if(screen_state==STATE_SAVE_ACTION) {
	ld	a, (#_screen_state)
;src/save_ui.c:73: if(pressed&J_B){back();return;}
	sub	a, #0x19
	jr	NZ, 00181$
	or	a, e
	jr	Z, 00102$
	call	_back
	jp	00183$
00102$:
;src/save_ui.c:74: if(pressed&(J_UP|J_DOWN)){save_ui_choice^=1u;action_screen();}
	ld	a, c
	and	a, #0x0c
	jr	Z, 00106$
	ld	hl, #_save_ui_choice
	ld	a, (hl)
	xor	a, #0x01
	ld	(hl), a
	call	_action_screen
	jp	00183$
00106$:
;src/save_ui.c:75: else if(pressed&J_A){save_ui_mode=save_ui_choice?SAVE_UI_DELETE:SAVE_UI_LOAD;save_ui_choice=save_active_slot;slot_screen();}
	ld	a, b
	or	a, a
	jp	Z, 00183$
	ld	a, (#_save_ui_choice)
	or	a, a
	ld	a, #0x03
	jr	NZ, 00186$
	ld	a, #0x02
00186$:
	ld	(#_save_ui_mode),a
	ld	a, (#_save_active_slot)
	ld	(#_save_ui_choice),a
	call	_slot_screen
	jp	00183$
00181$:
;src/save_ui.c:76: } else if(screen_state==STATE_SAVE_SELECT) {
	ld	a, (#_screen_state)
;src/save_ui.c:77: if(pressed&J_B){if(return_state==0u){save_ui_choice=0;action_screen();}else back();return;}
	sub	a, #0x1a
	jp	NZ, 00178$
	or	a, e
	jr	Z, 00112$
	ld	a, (#_return_state)
	or	a,a
	jr	NZ, 00109$
	ld	(#_save_ui_choice),a
	call	_action_screen
	jp	00183$
00109$:
	call	_back
	jp	00183$
00112$:
;src/save_ui.c:78: if(pressed&J_UP){if(save_ui_choice)--save_ui_choice;slot_screen();}
	bit	2, c
	jr	Z, 00131$
	ld	hl, #_save_ui_choice
	ld	a, (hl)
	or	a, a
	jr	Z, 00114$
	dec	(hl)
00114$:
	call	_slot_screen
	jp	00183$
00131$:
;src/save_ui.c:79: else if(pressed&J_DOWN){if(save_ui_choice<4u)++save_ui_choice;slot_screen();}
	bit	3, c
	jr	Z, 00128$
	ld	hl, #_save_ui_choice
	ld	a, (hl)
	sub	a, #0x04
	jr	NC, 00116$
	inc	(hl)
00116$:
	call	_slot_screen
	jp	00183$
00128$:
;src/save_ui.c:80: else if(pressed&J_A) {
	ld	a, b
	or	a, a
	jp	Z, 00183$
;src/save_ui.c:81: if(save_ui_mode==SAVE_UI_LOAD){if(save_valid_mask&(1u<<save_ui_choice)){save_active_slot=save_ui_choice;start_game(1);}}
	ld	a, (#_save_ui_choice)
	push	af
	ld	bc, #0x0001
	pop	af
	inc	a
	jr	00462$
00461$:
	sla	c
	rl	b
00462$:
	dec	a
	jr	NZ,00461$
	ld	a, (_save_valid_mask)
	ld	e, a
	ld	a, c
	and	a, e
	ld	c, a
	ld	b, #0x00
	ld	a, (#_save_ui_mode)
	sub	a, #0x02
	jr	NZ, 00123$
	ld	a, b
	or	a, c
	jp	Z, 00183$
	ld	a, (#_save_ui_choice)
	ld	(#_save_active_slot),a
	ld	a, #0x01
	call	_start_game
	jp	00183$
00123$:
;src/save_ui.c:82: else if(save_ui_mode==SAVE_UI_SAVE||(save_valid_mask&(1u<<save_ui_choice))){answer=0;confirm_screen();}
	ld	a, (#_save_ui_mode)
	dec	a
	jr	Z, 00119$
	ld	a, b
	or	a, c
	jp	Z, 00183$
00119$:
	xor	a, a
	ld	(#_answer),a
	call	_confirm_screen
	jp	00183$
00178$:
;src/save_ui.c:98: else {save_name_begin(&editor);name_keys=keys;name_repeat=24;name_screen();}
	ldhl	sp,	#20
	ld	a, (hl)
	ldhl	sp,	#13
	ld	(hl), a
;src/save_ui.c:85: if(pressed&(J_UP|J_DOWN|J_LEFT|J_RIGHT)){answer^=1u;confirm_screen();}
	ld	a, c
	and	a, #0x0f
	ld	c, a
;src/save_ui.c:84: } else if(screen_state==STATE_SAVE_CONFIRM) {
	ld	a, (#_screen_state)
;src/save_ui.c:85: if(pressed&(J_UP|J_DOWN|J_LEFT|J_RIGHT)){answer^=1u;confirm_screen();}
	sub	a, #0x1b
	jp	NZ, 00175$
	or	a, c
	jr	Z, 00149$
	ld	hl, #_answer
	ld	a, (hl)
	xor	a, #0x01
	ld	(hl), a
	call	_confirm_screen
	jp	00183$
00149$:
;src/save_ui.c:86: else if(pressed&J_B){slot_screen();}
	ld	a, e
	or	a, a
	jr	Z, 00146$
	call	_slot_screen
	jp	00183$
00146$:
;src/save_ui.c:87: else if(pressed&J_A) {
	ld	a, b
	or	a, a
	jp	Z, 00183$
;src/save_ui.c:88: if(answer){slot_screen();return;}
	ld	a, (#_answer)
	or	a, a
	jr	Z, 00134$
	call	_slot_screen
	jp	00183$
00134$:
;src/save_ui.c:89: if(save_ui_mode==SAVE_UI_DELETE) {
	ld	a, (#_save_ui_mode)
	sub	a, #0x03
	jr	NZ, 00141$
;src/save_ui.c:90: offset=save_slot_offset(save_ui_choice);ENABLE_RAM_MBC5;SWITCH_RAM_MBC5(0);
	ld	a, (_save_ui_choice)
	push	af
	inc	sp
	ld	e, #b_save_slot_offset
	ld	hl, #_save_slot_offset
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_rRAMG
	ld	(hl), #0x0a
	xor	a, a
	ld	(#_rRAMB),a
;src/save_ui.c:91: *(volatile uint8_t *)(0xa000u+offset)=0;
	ld	hl, #0xa000
	add	hl, bc
	ld	(hl), #0x00
;src/save_ui.c:92: *(volatile uint8_t *)(0xa000u+SAVE_LABEL_OFFSET+(uint16_t)save_ui_choice*8u+5u)=0;
	ld	a, (_save_ui_choice)
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #0xb405
	add	hl, bc
	ld	(hl), #0x00
;src/save_ui.c:93: DISABLE_RAM_MBC5;save_ui_scan();back();
	xor	a, a
	ld	(#_rRAMG),a
	ld	e, #b_save_ui_scan
	ld	hl, #_save_ui_scan
	call	___sdcc_bcall_ehl
	call	_back
	jp	00183$
00141$:
;src/save_ui.c:95: was_valid=save_valid_mask&(1u<<save_ui_choice);
	ld	hl, #_save_ui_choice
	ld	b, (hl)
	ld	a, #0x01
	inc	b
	jr	00471$
00470$:
	add	a, a
00471$:
	dec	b
	jr	NZ,00470$
	ld	hl, #_save_valid_mask
	and	a, (hl)
	ld	c, a
;src/save_ui.c:96: if(!game_write_slot(save_ui_choice)){char failed[]="SAVE FAILED";notice(failed,return_state);return;}
	push	bc
	ld	a, (_save_ui_choice)
	call	_game_write_slot
	pop	bc
	or	a, a
	jr	NZ, 00136$
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	ld	(hl), #0x53
	ldhl	sp,	#1
	ld	a, #0x41
	ld	(hl+), a
	ld	a, #0x56
	ld	(hl+), a
	ld	a, #0x45
	ld	(hl+), a
	ld	a, #0x20
	ld	(hl+), a
	ld	a, #0x46
	ld	(hl+), a
	ld	a, #0x41
	ld	(hl+), a
	ld	a, #0x49
	ld	(hl+), a
	ld	a, #0x4c
	ld	(hl+), a
	ld	a, #0x45
	ld	(hl+), a
	ld	a, #0x44
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, (_return_state)
	push	af
	inc	sp
	push	bc
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00183$
00136$:
;src/save_ui.c:97: if(was_valid){char saved[]="GAME SAVED";notice(saved,return_state);}
	ld	a, c
	or	a, a
	jr	Z, 00138$
	ldhl	sp,	#1
	ld	c, l
	ld	b, h
	ld	(hl), #0x47
	ldhl	sp,	#2
	ld	a, #0x41
	ld	(hl+), a
	ld	a, #0x4d
	ld	(hl+), a
	ld	a, #0x45
	ld	(hl+), a
	ld	a, #0x20
	ld	(hl+), a
	ld	a, #0x53
	ld	(hl+), a
	ld	a, #0x41
	ld	(hl+), a
	ld	a, #0x56
	ld	(hl+), a
	ld	a, #0x45
	ld	(hl+), a
	ld	a, #0x44
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, (_return_state)
	push	af
	inc	sp
	push	bc
	ld	e, #b_notice
	ld	hl, #_notice
	call	___sdcc_bcall_ehl
	add	sp, #3
	jp	00183$
00138$:
;src/save_ui.c:98: else {save_name_begin(&editor);name_keys=keys;name_repeat=24;name_screen();}
	ld	de, #_editor
	push	de
	ld	e, #b_save_name_begin
	ld	hl, #_save_name_begin
	call	___sdcc_bcall_ehl
	pop	hl
	ldhl	sp,	#13
	ld	a, (hl)
	ld	(#_name_keys),a
	ld	hl, #_name_repeat
	ld	(hl), #0x18
	call	_name_screen
	jp	00183$
00175$:
;src/save_ui.c:101: } else if(screen_state==STATE_SAVE_NAME) {
	ld	a, (#_screen_state)
;src/save_ui.c:102: if(pressed&J_B){save_name_input(&editor,1);name_screen();}
	sub	a, #0x1c
	jp	NZ, 00183$
	or	a, e
	jr	Z, 00170$
	ld	a, #0x01
	push	af
	inc	sp
	ld	de, #_editor
	push	de
	ld	e, #b_save_name_input
	ld	hl, #_save_name_input
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_name_screen
	jp	00171$
00170$:
;src/save_ui.c:103: else if(pressed&J_A){if(save_name_input(&editor,0)){write_label(save_active_slot);back();}else name_screen();}
	ld	a, b
	or	a, a
	jr	Z, 00167$
	xor	a, a
	push	af
	inc	sp
	ld	de, #_editor
	push	de
	ld	e, #b_save_name_input
	ld	hl, #_save_name_input
	call	___sdcc_bcall_ehl
	add	sp, #3
	or	a, a
	jr	Z, 00152$
	ld	a, (_save_active_slot)
	call	_write_label
	call	_back
	jr	00171$
00152$:
	call	_name_screen
	jr	00171$
00167$:
;src/save_ui.c:105: if(pressed&(J_UP|J_DOWN|J_LEFT|J_RIGHT)){move=1;name_repeat=24;}
	ld	a, c
	or	a, a
	jr	Z, 00162$
	ldhl	sp,	#12
	ld	(hl), #0x01
	ld	hl, #_name_repeat
	ld	(hl), #0x18
	jr	00163$
00162$:
;src/save_ui.c:106: else if(keys&(J_UP|J_DOWN|J_LEFT|J_RIGHT)){if(keys!=name_keys)name_repeat=24;else if(!--name_repeat){move=1;name_repeat=5;}}
	ldhl	sp,	#13
	ld	a, (hl)
	and	a, #0x0f
	jr	Z, 00163$
	ld	a, (#_name_keys)
	ldhl	sp,	#13
	sub	a, (hl)
	jr	Z, 00157$
	ld	hl, #_name_repeat
	ld	(hl), #0x18
	jr	00163$
00157$:
	ld	hl, #_name_repeat
	dec	(hl)
	ld	a, (hl)
	jr	NZ, 00163$
	ldhl	sp,	#12
	ld	(hl), #0x01
	ld	hl, #_name_repeat
	ld	(hl), #0x05
00163$:
;src/save_ui.c:107: if(move){save_name_move(&editor,(keys&J_LEFT)?-1:(keys&J_RIGHT)?1:0,(keys&J_UP)?-1:(keys&J_DOWN)?1:0);name_screen();}
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	jr	Z, 00171$
	ldhl	sp,	#20
	ld	a, (hl)
	bit	2, a
	jr	Z, 00187$
	ld	c, #0xff
	jr	00188$
00187$:
	bit	3, a
	ld	c, #0x01
	jr	NZ, 00190$
	ld	c, #0x00
00190$:
00188$:
	bit	1, a
	jr	Z, 00191$
	ld	a, #0xff
	jr	00192$
00191$:
	rrca
	jr	NC, 00193$
	ld	a, #0x01
	jr	00194$
00193$:
	xor	a, a
00194$:
00192$:
	ld	e, a
	ld	hl, #_editor
	ld	a, c
	push	af
	inc	sp
	ld	a, e
	push	af
	inc	sp
	push	hl
	ld	e, #b_save_name_move
	ld	hl, #_save_name_move
	call	___sdcc_bcall_ehl
	add	sp, #4
	call	_name_screen
00171$:
;src/save_ui.c:109: name_keys=keys;
	ldhl	sp,	#13
	ld	a, (hl)
	ld	(#_name_keys),a
00183$:
;src/save_ui.c:111: }
	add	sp, #14
	ret
	.area _CODE_122
	.area _INITIALIZER
	.area _CABS (ABS)
