;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module inventory_menu
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _inventory_dialogue_overlay
	.globl _show_dialogue
	.globl b_ui_text
	.globl _ui_text
	.globl b_ui_panel
	.globl _ui_panel
	.globl b_dialogue_item_name
	.globl _dialogue_item_name
	.globl b_party_screen
	.globl _party_screen
	.globl b_inventory_screen
	.globl _inventory_screen
	.globl b_rpg_equip_finish
	.globl _rpg_equip_finish
	.globl b_rpg_equip_stage
	.globl _rpg_equip_stage
	.globl b_rpg_item_equippers
	.globl _rpg_item_equippers
	.globl b_rpg_item_discardable
	.globl _rpg_item_discardable
	.globl b_rpg_remove_item
	.globl _rpg_remove_item
	.globl b_rpg_refresh_stats
	.globl _rpg_refresh_stats
	.globl _memset
	.globl _vsync
	.globl b_inventory_equip_begin
	.globl _inventory_equip_begin
	.globl b_inventory_equip_select
	.globl _inventory_equip_select
	.globl b_inventory_drop_begin
	.globl _inventory_drop_begin
	.globl b_inventory_action_advance
	.globl _inventory_action_advance
	.globl b_inventory_equipment_done
	.globl _inventory_equipment_done
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
;src/inventory_menu.c:15: static void close_rows(uint8_t rows) {while(rows--)vsync();}
;	---------------------------------
; Function close_rows
; ---------------------------------
_close_rows:
	ld	c, a
00101$:
	ld	a, c
	dec	c
	or	a, a
	ret	Z
	call	_vsync
	jr	00101$
;src/inventory_menu.c:16: static void finish(uint8_t refresh) {
;	---------------------------------
; Function finish
; ---------------------------------
_finish:
	ld	c, a
;src/inventory_menu.c:17: HIDE_WIN;close_rows(6u);
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	push	bc
	ld	a, #0x06
	call	_close_rows
	pop	bc
;src/inventory_menu.c:18: if(refresh)rpg_refresh_stats(&game_rpg);
	ld	a, c
	or	a, a
	jr	Z, 00102$
	push	bc
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
	pop	bc
00102$:
;src/inventory_menu.c:19: if(refresh&&(game_rpg.joined_mask&14u))close_rows(9u);
	ld	a, c
	or	a, a
	jr	Z, 00104$
	ld	a, (#(_game_rpg + 89) + 0)
	and	a, #0x0e
	jr	Z, 00104$
	ld	a, #0x09
	call	_close_rows
00104$:
;src/inventory_menu.c:20: field_active=0;inventory_screen();
	xor	a, a
	ld	(#_field_active),a
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
;src/inventory_menu.c:21: }
	jp  ___sdcc_bcall_ehl
;src/inventory_menu.c:22: static void start(uint8_t slot) {
;	---------------------------------
; Function start
; ---------------------------------
_start:
	ld	c, a
;src/inventory_menu.c:23: memset(&field_action,0,sizeof(field_action));field_active=2;
	ld	de, #0x0016
	push	de
	ld	de, #0x0000
	push	de
	ld	de, #_field_action
	push	de
	call	_memset
	add	sp, #6
	ld	hl, #_field_active
	ld	(hl), #0x02
;src/inventory_menu.c:24: field_action.a=slot;field_action.item=game_rpg.inventory[slot];field_action.character=255;
	ld	hl, #(_field_action + 6)
	ld	(hl), c
	ld	hl, #(_game_rpg + 64)
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	hl, #(_field_action + 3)
	ld	(hl+), a
	ld	(hl), #0xff
;src/inventory_menu.c:25: }
	ret
;src/inventory_menu.c:26: void inventory_equip_begin(uint8_t slot) RPG_BANKED {
;	---------------------------------
; Function inventory_equip_begin
; ---------------------------------
	b_inventory_equip_begin	= 19
_inventory_equip_begin::
;src/inventory_menu.c:27: start(slot);
	ldhl	sp,	#6
	ld	a, (hl)
	call	_start
;src/inventory_menu.c:28: if(!rpg_item_equippers(field_action.item)) {
	ld	a, (#(_field_action + 3) + 0)
	push	af
	inc	sp
	ld	e, #b_rpg_item_equippers
	ld	hl, #_rpg_item_equippers
	call	___sdcc_bcall_ehl
	inc	sp
	or	a, a
	jr	NZ, 00102$
;src/inventory_menu.c:29: field_action.target=ITEM_CLOSE;show_dialogue(0xb5f0);return;
	ld	hl, #_field_action + 5
	ld	(hl), #0x01
	ld	de, #0xb5f0
	jp	_show_dialogue
00102$:
;src/inventory_menu.c:31: if(!(game_rpg.joined_mask&14u)){inventory_equip_select(0u);return;}
	ld	a, (#(_game_rpg + 89) + 0)
	and	a, #0x0e
	jr	NZ, 00104$
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_inventory_equip_select
	ld	hl, #_inventory_equip_select
	call	___sdcc_bcall_ehl
	inc	sp
	ret
00104$:
;src/inventory_menu.c:32: party_choice=0;party_screen();
	xor	a, a
	ld	(#_party_choice),a
	ld	e, #b_party_screen
	ld	hl, #_party_screen
;src/inventory_menu.c:33: }
	jp  ___sdcc_bcall_ehl
;src/inventory_menu.c:34: void inventory_equip_select(uint8_t character) RPG_BANKED {
;	---------------------------------
; Function inventory_equip_select
; ---------------------------------
	b_inventory_equip_select	= 19
_inventory_equip_select::
;src/inventory_menu.c:36: if(character==255u){
	ldhl	sp,	#6
	ld	a, (hl)
	inc	a
	jr	NZ, 00104$
;src/inventory_menu.c:37: rpg_refresh_stats(&game_rpg);
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_refresh_stats
	ld	hl, #_rpg_refresh_stats
	call	___sdcc_bcall_ehl
	pop	hl
;src/inventory_menu.c:38: if(game_rpg.joined_mask&14u)close_rows(9u);
	ld	a, (#(_game_rpg + 89) + 0)
	and	a, #0x0e
	jr	Z, 00102$
	ld	a, #0x09
	call	_close_rows
00102$:
;src/inventory_menu.c:39: field_active=0;inventory_screen();return;
	xor	a, a
	ld	(#_field_active),a
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
	jp  ___sdcc_bcall_ehl
00104$:
;src/inventory_menu.c:41: field_action.character=character;
	ld	de, #(_field_action + 4)
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(de), a
;src/inventory_menu.c:42: result=rpg_equip_stage(&game_rpg,field_action.a,character);
	ld	hl, #_field_action + 6
	ld	b, (hl)
	ldhl	sp,	#6
	ld	a, (hl)
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_equip_stage
	ld	hl, #_rpg_equip_stage
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/inventory_menu.c:43: field_action.target=result==RPG_OK?ITEM_EQUIP_TEXT:ITEM_EQUIP_DENIED;
	ld	c, a
	or	a, a
	ld	a, #0x03
	jr	Z, 00108$
	ld	a, #0x04
00108$:
	ld	(#(_field_action + 5)),a
;src/inventory_menu.c:44: show_dialogue(result==RPG_OK?0xb2b6:result==RPG_DEAD?0xb730:0xb5de);
	ld	a, c
	or	a, a
	jr	NZ, 00109$
	ld	de, #0xb2b6
	jp	_show_dialogue
00109$:
	ld	a, c
	sub	a, #0x05
	jr	NZ, 00111$
	ld	de, #0xb730
	jp	_show_dialogue
00111$:
	ld	de, #0xb5de
;src/inventory_menu.c:45: }
	jp	_show_dialogue
;src/inventory_menu.c:46: void inventory_drop_begin(uint8_t slot) RPG_BANKED {
;	---------------------------------
; Function inventory_drop_begin
; ---------------------------------
	b_inventory_drop_begin	= 19
_inventory_drop_begin::
;src/inventory_menu.c:47: start(slot);field_action.target=rpg_item_discardable(field_action.item)?ITEM_DROP:ITEM_CLOSE;
	ldhl	sp,	#6
	ld	a, (hl)
	call	_start
	ld	a, (#(_field_action + 3) + 0)
	push	af
	inc	sp
	ld	e, #b_rpg_item_discardable
	ld	hl, #_rpg_item_discardable
	call	___sdcc_bcall_ehl
	inc	sp
	or	a, a
	ld	a, #0x02
	jr	NZ, 00104$
	ld	a, #0x01
00104$:
	ld	(#(_field_action + 5)),a
;src/inventory_menu.c:48: show_dialogue(field_action.target==ITEM_DROP?0xb2c2:0xb6de);
	sub	a, #0x02
	jr	NZ, 00105$
	ld	de, #0xb2c2
	jp	_show_dialogue
00105$:
	ld	de, #0xb6de
;src/inventory_menu.c:49: }
	jp	_show_dialogue
;src/inventory_menu.c:50: void inventory_action_advance(void) RPG_BANKED {
;	---------------------------------
; Function inventory_action_advance
; ---------------------------------
	b_inventory_action_advance	= 19
_inventory_action_advance::
	add	sp, #-15
;src/inventory_menu.c:52: if(field_action.target==ITEM_EQUIP_TEXT){
	ld	a, (#(_field_action + 5) + 0)
	ldhl	sp,#14
	ld	(hl), a
	sub	a, #0x03
	jp	NZ, 00103$
;src/inventory_menu.c:55: p=&game_rpg.party[field_action.character];ui_panel(40u,13u);
	ld	a, (#(_field_action + 4) + 0)
	swap	a
	and	a, #0xf0
	add	a, #<(_game_rpg)
	ld	c, a
	ld	a, #0x00
	adc	a, #>(_game_rpg)
	ld	b, a
	push	bc
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
	pop	bc
;src/inventory_menu.c:56: for(i=0;i<3u;++i){
	ld	hl, #0x000c
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
	ld	hl, #0x000b
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#13
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#12
	ld	(hl), a
	ld	hl, #0x000a
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#15
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#14
	ld	(hl), a
	ld	c, #0x00
00106$:
;src/inventory_menu.c:57: item=i==0u?p->weapon:i==1u?p->armor:p->shield;
	ld	a, c
	or	a, a
	jr	NZ, 00110$
	ldhl	sp,#13
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jr	00111$
00110$:
	ld	a, c
	dec	a
	jr	NZ, 00112$
	ldhl	sp,#11
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	jr	00113$
00112$:
	ldhl	sp,#9
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
00113$:
00111$:
;src/inventory_menu.c:58: dialogue_item_name(item,name);ui_text(3u,2u+i*2u,name);
	ld	hl, #0
	add	hl, sp
	push	hl
	push	bc
	push	hl
	push	af
	inc	sp
	ld	e, #b_dialogue_item_name
	ld	hl, #_dialogue_item_name
	call	___sdcc_bcall_ehl
	add	sp, #3
	pop	bc
	pop	hl
	ld	a, c
	add	a, a
	add	a, #0x02
	push	bc
	push	hl
	push	af
	inc	sp
	ld	a, #0x03
	push	af
	inc	sp
	ld	e, #b_ui_text
	ld	hl, #_ui_text
	call	___sdcc_bcall_ehl
	add	sp, #4
	pop	bc
;src/inventory_menu.c:56: for(i=0;i<3u;++i){
	inc	c
	ld	a, c
	sub	a, #0x03
	jr	C, 00106$
;src/inventory_menu.c:60: inventory_dialogue_overlay();screen_state=STATE_EQUIPMENT_PANEL;return;
	call	_inventory_dialogue_overlay
	ld	hl, #_screen_state
	ld	(hl), #0x1e
	jr	00108$
00103$:
;src/inventory_menu.c:62: if(field_action.target==ITEM_DROP)rpg_remove_item(&game_rpg,field_action.a);
	ldhl	sp,	#14
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00105$
	ld	a, (#_field_action + 6)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_remove_item
	ld	hl, #_rpg_remove_item
	call	___sdcc_bcall_ehl
	add	sp, #3
00105$:
;src/inventory_menu.c:63: finish(field_action.target==ITEM_EQUIP_DENIED);
	ld	a, (#(_field_action + 5) + 0)
	sub	a, #0x04
	ld	a, #0x01
	jr	Z, 00164$
	xor	a, a
00164$:
	call	_finish
00108$:
;src/inventory_menu.c:64: }
	add	sp, #15
	ret
;src/inventory_menu.c:65: void inventory_equipment_done(void) RPG_BANKED {
;	---------------------------------
; Function inventory_equipment_done
; ---------------------------------
	b_inventory_equipment_done	= 19
_inventory_equipment_done::
;src/inventory_menu.c:66: HIDE_WIN;close_rows(8u);close_rows(6u);
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ld	a, #0x08
	call	_close_rows
	ld	a, #0x06
	call	_close_rows
;src/inventory_menu.c:67: rpg_equip_finish(&game_rpg,field_action.a);
	ld	hl, #(_field_action + 6)
	ld	b, (hl)
	push	bc
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_equip_finish
	ld	hl, #_rpg_equip_finish
	call	___sdcc_bcall_ehl
	add	sp, #3
;src/inventory_menu.c:68: if(game_rpg.joined_mask&14u)close_rows(9u);
	ld	a, (#(_game_rpg + 89) + 0)
	and	a, #0x0e
	jr	Z, 00102$
	ld	a, #0x09
	call	_close_rows
00102$:
;src/inventory_menu.c:69: field_active=0;inventory_screen();
	xor	a, a
	ld	(#_field_active),a
	ld	e, #b_inventory_screen
	ld	hl, #_inventory_screen
;src/inventory_menu.c:70: }
	jp  ___sdcc_bcall_ehl
	.area _CODE_19
	.area _INITIALIZER
	.area _CABS (ABS)
