;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module game_field
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _reload_world_mode
	.globl _enter_map
	.globl _resume_walk
	.globl _show_dialogue
	.globl b_battle_view_chest_open
	.globl _battle_view_chest_open
	.globl b_battle_view_chest_prompt
	.globl _battle_view_chest_prompt
	.globl b_start_field_scene
	.globl _start_field_scene
	.globl b_audio_command
	.globl _audio_command
	.globl b_world_decode_destination
	.globl _world_decode_destination
	.globl b_world_vehicle_use
	.globl _world_vehicle_use
	.globl b_world_flags_at
	.globl _world_flags_at
	.globl b_dplay_show_opening
	.globl _dplay_show_opening
	.globl b_result
	.globl _result
	.globl b_menu_screen
	.globl _menu_screen
	.globl b_apply_event
	.globl _apply_event
	.globl b_field_torch_finish
	.globl _field_torch_finish
	.globl b_field_torch_reply
	.globl _field_torch_reply
	.globl b_field_use_item
	.globl _field_use_item
	.globl b_field_cast
	.globl _field_cast
	.globl b_event_use_story_item
	.globl _event_use_story_item
	.globl b_rpg_find_item
	.globl _rpg_find_item
	.globl _memset
	.globl _vsync
	.globl _field_active
	.globl _field_action
	.globl b_game_field_advance
	.globl _game_field_advance
	.globl b_game_field_scene_done
	.globl _game_field_scene_done
	.globl b_game_field_item
	.globl _game_field_item
	.globl b_game_field_spell
	.globl _game_field_spell
	.globl b_game_field_battle_item
	.globl _game_field_battle_item
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_field_action::
	.ds 22
_field_active::
	.ds 1
_field_line:
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
	.area _CODE_12
;src/game_field.c:25: static void context(FieldContext *c) {
;	---------------------------------
; Function context
; ---------------------------------
_context:
	add	sp, #-8
	ldhl	sp,	#6
	ld	a, e
	ld	(hl+), a
;src/game_field.c:26: memset(c,0,sizeof(*c));c->rpg=&game_rpg;c->events=&game_events;
	ld	a, d
	ld	(hl-), a
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	de, #0x000f
	push	de
	ld	de, #0x0000
	push	de
	push	bc
	call	_memset
	add	sp, #6
	ldhl	sp,	#6
	ld	b, (hl)
	inc	hl
	ld	c, (hl)
	ld	l, b
	ld	h, c
	ld	(hl), #<(_game_rpg)
	inc	hl
	ld	(hl), #>(_game_rpg)
	ldhl	sp,	#6
	ld	a, (hl+)
	ld	c, a
;src/game_field.c:27: c->dungeon=game_dungeon.active?&game_dungeon.dungeon:0;
	ld	a, (hl-)
	ld	b, a
	inc	bc
	inc	bc
	ld	a, #<(_game_events)
	ld	(bc), a
	inc	bc
	ld	a, #>(_game_events)
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (#(_game_dungeon + 264) + 0)
	or	a, a
	jr	Z, 00105$
	ld	de, #_game_dungeon
	jr	00106$
00105$:
	ld	de, #0x0000
00106$:
	ld	a, e
	ld	(bc), a
	inc	bc
	ld	a, d
	ld	(bc), a
;src/game_field.c:28: c->interaction=game_events.event?game_events.type:game_dungeon.active?0:
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ld	a, (#(_game_events + 260) + 0)
	or	a, a
	jr	Z, 00107$
	ld	a, (#(_game_events + 261) + 0)
	jr	00108$
00107$:
	ld	a, (#(_game_dungeon + 264) + 0)
	or	a, a
	jr	Z, 00109$
	xor	a, a
	jr	00110$
00109$:
;src/game_field.c:29: world_flags_at((player_x-8u)&2047u,(player_y+1536u-16u)%1536u)>>4;
	ld	a, (#_player_y)
	ldhl	sp,	#2
	ld	(hl), a
	ld	a, (#_player_y + 1)
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x05f0
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl-), a
	ld	bc, #0x0600
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	call	__moduint
	ld	a, (_player_x)
	ld	hl, #_player_x + 1
	ld	d, (hl)
	add	a, #0xf8
	ld	e, a
	ld	a, d
	adc	a, #0xff
	and	a, #0x07
	push	bc
	ld	d, a
	push	de
	ld	e, #b_world_flags_at
	ld	hl, #_world_flags_at
	call	___sdcc_bcall_ehl
	add	sp, #4
	swap	a
	and	a, #0x0f
00110$:
00108$:
	pop	hl
	push	hl
	ld	(hl), a
;src/game_field.c:30: c->map_id=world_map_id;c->map_group=world_group_id;c->event_id=game_events.event;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (_world_map_id)
	ld	(bc), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (_world_group_id)
	ld	(bc), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000c
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (#(_game_events + 260) + 0)
	ld	(bc), a
;src/game_field.c:31: c->projection=game_events.portrait;c->vehicle=game_vehicle;
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000d
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (#(_game_events + 262) + 0)
	ld	(bc), a
	ldhl	sp,#6
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000e
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (_game_vehicle)
	ld	(bc), a
;src/game_field.c:32: if(battle_view_chest_pending)c->chest=&battle_view_battle;
	ld	a, (#_battle_view_chest_pending)
	or	a, a
	jr	Z, 00103$
	ldhl	sp,#6
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	b,l
	ld	c,h
	ld	(hl), #<(_battle_view_battle)
	inc	hl
	ld	(hl), #>(_battle_view_battle)
00103$:
;src/game_field.c:33: }
	add	sp, #8
	ret
;src/game_field.c:34: static void finish(void) {
;	---------------------------------
; Function finish
; ---------------------------------
_finish:
	add	sp, #-10
;src/game_field.c:39: if(field_action.item==ItemID_EclipseTorch){HIDE_WIN;for(close_frames=0;close_frames<6u;++close_frames)vsync();}
	ld	a, (#(_field_action + 3) + 0)
	sub	a, #0x2f
	jr	NZ, 00103$
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xdf
	ldh	(_LCDC_REG + 0), a
	ld	c, #0x06
00126$:
	call	_vsync
	dec	c
	jr	NZ, 00126$
00103$:
;src/game_field.c:40: field_active=0;if(field_action.sound_end&&field_action.kind!=FIELD_OPEN_DOOR&&field_action.kind!=FIELD_TORCH_SCENE)audio_command(field_action.sound_end);
	xor	a, a
	ld	(#_field_active),a
	ld	hl, #(_field_action + 9)
	ld	b, (hl)
	ld	a, b
	or	a, a
	jr	Z, 00105$
	ld	a, (#_field_action + 0)
	cp	a, #0x04
	jr	Z, 00105$
	sub	a, #0x09
	jr	Z, 00105$
	push	bc
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00105$:
;src/game_field.c:41: switch(field_action.kind) {
	ld	a, (#_field_action + 0)
	cp	a, #0x0c
	jp	NC, 00122$
	ld	c, a
	ld	b, #0x00
	ld	hl, #00184$
	add	hl, bc
	add	hl, bc
	ld	c, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, c
	jp	(hl)
00184$:
	.dw	00108$
	.dw	00111$
	.dw	00113$
	.dw	00114$
	.dw	00112$
	.dw	00109$
	.dw	00110$
	.dw	00121$
	.dw	00121$
	.dw	00117$
	.dw	00115$
	.dw	00116$
;src/game_field.c:42: case FIELD_DONE:menu_screen();break;
00108$:
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jp	00127$
;src/game_field.c:43: case FIELD_CHEST_OPEN:battle_view_chest_open();screen_state=15;break;
00109$:
	ld	e, #b_battle_view_chest_open
	ld	hl, #_battle_view_chest_open
	call	___sdcc_bcall_ehl
	ld	hl, #_screen_state
	ld	(hl), #0x0f
	jp	00127$
;src/game_field.c:44: case FIELD_CHEST_PROMPT:battle_view_chest_prompt(0);screen_state=15;break;
00110$:
	xor	a, a
	push	af
	inc	sp
	ld	e, #b_battle_view_chest_prompt
	ld	hl, #_battle_view_chest_prompt
	call	___sdcc_bcall_ehl
	inc	sp
	ld	hl, #_screen_state
	ld	(hl), #0x0f
	jp	00127$
;src/game_field.c:45: case FIELD_REDRAW:resume_walk();break;
00111$:
	call	_resume_walk
	jp	00127$
;src/game_field.c:46: case FIELD_OPEN_DOOR:dplay_show_opening(&game_dungeon,field_action.a);resume_walk();break;
00112$:
	ld	hl, #_field_action + 6
	ld	b, (hl)
	push	bc
	inc	sp
	ld	de, #_game_dungeon
	push	de
	ld	e, #b_dplay_show_opening
	ld	hl, #_dplay_show_opening
	call	___sdcc_bcall_ehl
	add	sp, #3
	call	_resume_walk
	jp	00127$
;src/game_field.c:47: case FIELD_EXIT_DUNGEON:enter_map(world_map_id,player_x,player_y);break;
00113$:
	ld	a, (_player_y)
	ld	e, a
	ld	hl, #_player_y + 1
	ld	d, (hl)
	push	de
	ld	a, (_player_x)
	ld	e, a
	ld	hl, #_player_x + 1
	ld	d, (hl)
	ld	a, (_world_map_id)
	call	_enter_map
	jp	00127$
;src/game_field.c:48: case FIELD_TRANSFER:
00114$:
;src/game_field.c:49: destination.target=field_action.target;destination.a=field_action.a;destination.b=field_action.b;
	ldhl	sp,	#0
	ld	c, l
	ld	b, h
	ld	a, (#(_field_action + 5) + 0)
	ldhl	sp,	#1
	ld	(hl+), a
	ld	a, (#(_field_action + 6) + 0)
	ld	(hl+), a
	ld	a, (#(_field_action + 7) + 0)
	ld	(hl), a
;src/game_field.c:50: world_decode_destination(&destination,&x,&y);enter_map(destination.target,x,y);break;
	ldhl	sp,	#6
	ld	e, l
	ld	d, h
	ld	hl, #8
	add	hl, sp
	push	hl
	push	de
	push	bc
	ld	e, #b_world_decode_destination
	ld	hl, #_world_decode_destination
	call	___sdcc_bcall_ehl
	add	sp, #6
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	de
	ldhl	sp,	#8
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	call	_enter_map
	jr	00127$
;src/game_field.c:51: case FIELD_STORY_ITEM:event_use_story_item(&game_events,field_action.target,0);apply_event();break;
00115$:
	ld	hl, #_field_action + 5
	ld	b, (hl)
	xor	a, a
	push	af
	inc	sp
	push	bc
	inc	sp
	ld	de, #_game_events
	push	de
	ld	e, #b_event_use_story_item
	ld	hl, #_event_use_story_item
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	e, #b_apply_event
	ld	hl, #_apply_event
	call	___sdcc_bcall_ehl
	jr	00127$
;src/game_field.c:52: case FIELD_VEHICLE:reload_world_mode();resume_walk();break;
00116$:
	call	_reload_world_mode
	call	_resume_walk
	jr	00127$
;src/game_field.c:53: case FIELD_TORCH_SCENE:field_torch_finish(&game_rpg,&field_action);if(field_action.sound_end)audio_command(field_action.sound_end);menu_screen();break;
00117$:
	ld	de, #_field_action
	push	de
	ld	de, #_game_rpg
	push	de
	ld	e, #b_field_torch_finish
	ld	hl, #_field_torch_finish
	call	___sdcc_bcall_ehl
	add	sp, #4
	ld	a, (#(_field_action + 9) + 0)
	or	a, a
	jr	Z, 00119$
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00119$:
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
	call	___sdcc_bcall_ehl
	jr	00127$
;src/game_field.c:54: case FIELD_PRISM:case FIELD_MYAU_FLY:start_field_scene(field_action.kind);break;
00121$:
	push	af
	inc	sp
	ld	e, #b_start_field_scene
	ld	hl, #_start_field_scene
	call	___sdcc_bcall_ehl
	inc	sp
	jr	00127$
;src/game_field.c:55: default:result(RPG_NOT_IMPLEMENTED,2);break;
00122$:
	ld	a, #0x02
	push	af
	inc	sp
	ld	a, #0x08
	push	af
	inc	sp
	ld	e, #b_result
	ld	hl, #_result
	call	___sdcc_bcall_ehl
	pop	hl
;src/game_field.c:56: }
00127$:
;src/game_field.c:57: }
	add	sp, #10
	ret
;src/game_field.c:58: static void next_line(void) {
;	---------------------------------
; Function next_line
; ---------------------------------
_next_line:
;src/game_field.c:59: if(field_line>=field_action.line_count){finish();return;}
	ld	hl, #_field_action + 2
	ld	a, (#_field_line)
	sub	a, (hl)
	jp	NC, _finish
;src/game_field.c:60: if(field_action.lines[field_line].sound_before)audio_command(field_action.lines[field_line].sound_before);
	ld	bc, #_field_action + 10
	ld	a, (#_field_line)
	add	a, a
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	push	bc
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
	pop	bc
00104$:
;src/game_field.c:61: show_dialogue(field_action.lines[field_line].dialogue);
	ld	a, (#_field_line)
	add	a, a
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
;src/game_field.c:62: }
	jp	_show_dialogue
;src/game_field.c:63: static void start(void) {
;	---------------------------------
; Function start
; ---------------------------------
_start:
;src/game_field.c:64: field_active=1;field_line=0;
	ld	hl, #_field_active
	ld	(hl), #0x01
	xor	a, a
	ld	(#_field_line),a
;src/game_field.c:65: if(field_action.sound_start)audio_command(field_action.sound_start);
	ld	a, (#(_field_action + 8) + 0)
	or	a, a
	jp	Z, _next_line
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_field.c:66: next_line();
;src/game_field.c:67: }
	jp	_next_line
;src/game_field.c:68: void game_field_advance(void) RPG_BANKED {
;	---------------------------------
; Function game_field_advance
; ---------------------------------
	b_game_field_advance	= 12
_game_field_advance::
;src/game_field.c:69: if(field_line<field_action.line_count&&field_action.lines[field_line].sound_after)
	ld	hl, #_field_action + 2
	ld	c, (hl)
	ld	hl, #_field_line
	ld	a, (hl)
	sub	a, c
	jr	NC, 00102$
	ld	bc, #_field_action + 10
	ld	a, (hl)
	add	a, a
	add	a, a
	ld	l, a
	ld	h, #0x00
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
;src/game_field.c:70: audio_command(field_action.lines[field_line].sound_after);
	push	af
	inc	sp
	ld	e, #b_audio_command
	ld	hl, #_audio_command
	call	___sdcc_bcall_ehl
	inc	sp
00102$:
;src/game_field.c:71: ++field_line;
	ld	hl, #_field_line
	inc	(hl)
;src/game_field.c:74: if(field_action.kind==FIELD_TORCH_SCENE&&field_line==1u&&!field_action.b){
	ld	a, (#_field_action + 0)
	sub	a, #0x09
	jp	NZ, _next_line
	ld	a, (hl)
	dec	a
	jp	NZ, _next_line
	ld	a, (#(_field_action + 7) + 0)
	or	a, a
	jp	NZ, _next_line
;src/game_field.c:75: start_field_scene(FIELD_TORCH_SCENE);return;
	ld	a, #0x09
	push	af
	inc	sp
	ld	e, #b_start_field_scene
	ld	hl, #_start_field_scene
	call	___sdcc_bcall_ehl
	inc	sp
;src/game_field.c:77: next_line();
;src/game_field.c:78: }
	ret
;src/game_field.c:79: void game_field_scene_done(void) RPG_BANKED {
;	---------------------------------
; Function game_field_scene_done
; ---------------------------------
	b_game_field_scene_done	= 12
_game_field_scene_done::
;src/game_field.c:80: if(field_active){
	ld	a, (#_field_active)
	or	a, a
	jr	Z, 00104$
;src/game_field.c:81: if(field_action.kind==FIELD_TORCH_SCENE)field_torch_reply(&game_rpg,&field_action);
	ld	bc, #_field_action+0
	ld	a, (bc)
	sub	a, #0x09
	jp	NZ, _next_line
	push	bc
	ld	de, #_game_rpg
	push	de
	ld	e, #b_field_torch_reply
	ld	hl, #_field_torch_reply
	call	___sdcc_bcall_ehl
	add	sp, #4
;src/game_field.c:82: next_line();
	jp	_next_line
00104$:
;src/game_field.c:83: }else menu_screen();
	ld	e, #b_menu_screen
	ld	hl, #_menu_screen
;src/game_field.c:84: }
	jp  ___sdcc_bcall_ehl
;src/game_field.c:85: void game_field_item(uint8_t slot,uint8_t target) RPG_BANKED {
;	---------------------------------
; Function game_field_item
; ---------------------------------
	b_game_field_item	= 12
_game_field_item::
	add	sp, #-19
;src/game_field.c:87: context(&c);field_use_item(&c,slot,target,&field_action);game_events.portrait=c.projection;
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	call	_context
	pop	de
	ld	bc, #_field_action+0
	ld	l, c
	ld	h, b
	push	bc
	push	hl
	ldhl	sp,	#30
	ld	a, (hl-)
	ld	b, a
	ld	c, (hl)
	push	bc
	push	de
	ld	e, #b_field_use_item
	ld	hl, #_field_use_item
	call	___sdcc_bcall_ehl
	add	sp, #6
	pop	bc
	ldhl	sp,	#13
	ld	a, (hl)
	ld	(#(_game_events + 262)),a
;src/game_field.c:88: if(field_action.kind==FIELD_VEHICLE) {
	ld	a, (#_field_action + 0)
	sub	a, #0x0b
	jp	NZ, 00106$
;src/game_field.c:89: mode=(field_action.item-32u)*4u;exiting=mode==game_vehicle;
	ld	a, (#(_field_action + 3) + 0)
	add	a, #0xe0
	add	a, a
	add	a, a
	ld	d, a
	ld	a, (#_game_vehicle)
	sub	a, d
	ld	a, #0x01
	jr	Z, 00169$
	xor	a, a
00169$:
	ldhl	sp,	#15
	ld	(hl), a
;src/game_field.c:90: result=world_vehicle_use(&player_x,&player_y,facing,c.interaction,mode,&game_vehicle);
	ld	hl, #8
	add	hl, sp
	ld	e, (hl)
	push	bc
	ld	hl, #_game_vehicle
	push	hl
	push	de
	ld	a, (_facing)
	push	af
	inc	sp
	ld	de, #_player_y
	push	de
	ld	de, #_player_x
	push	de
	ld	e, #b_world_vehicle_use
	ld	hl, #_world_vehicle_use
	call	___sdcc_bcall_ehl
	add	sp, #9
	ldhl	sp,	#18
	ld	(hl), a
	pop	bc
;src/game_field.c:91: field_action.line_count=exiting?1u:2u;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	ld	a, #0x01
	jr	NZ, 00110$
	ld	a, #0x02
00110$:
	ld	(#(_field_action + 2)),a
;src/game_field.c:92: field_action.lines[0].dialogue=exiting?(result?0xb30a:0xb2fb):0xb2ac;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	jr	Z, 00111$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00113$
	ld	de, #0xb30a
	jr	00112$
00113$:
	ld	de, #0xb2fb
	jr	00112$
00111$:
	ld	de, #0xb2ac
00112$:
	ldhl	sp,	#17
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl-), a
	ld	de, #(_field_action + 10)
	ld	a, (hl+)
	ld	(de), a
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/game_field.c:93: if(!exiting)field_action.lines[1].dialogue=result?0xb305:0xb2e3;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	jr	NZ, 00102$
	inc	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00115$
	ld	bc, #0xb305
	jr	00116$
00115$:
	ld	bc, #0xb2e3
00116$:
	ld	hl, #(_field_action + 14)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
00102$:
;src/game_field.c:94: if(!result)field_action.kind=FIELD_DONE;
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	NZ, 00106$
	ld	hl, #_field_action
	ld	(hl), #0x00
00106$:
;src/game_field.c:96: start();
	call	_start
;src/game_field.c:97: }
	add	sp, #19
	ret
;src/game_field.c:98: void game_field_spell(uint8_t caster,uint8_t spell,uint8_t target) RPG_BANKED {
;	---------------------------------
; Function game_field_spell
; ---------------------------------
	b_game_field_spell	= 12
_game_field_spell::
	add	sp, #-15
;src/game_field.c:99: FieldContext c;context(&c);field_cast(&c,caster,spell,target,&field_action);start();
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	push	de
	call	_context
	pop	de
	ld	bc, #_field_action
	push	bc
	ldhl	sp,	#25
	ld	a, (hl-)
	ld	b, a
	ld	a, (hl-)
	ld	c, a
	push	bc
	ld	a, (hl)
	push	af
	inc	sp
	push	de
	ld	e, #b_field_cast
	ld	hl, #_field_cast
	call	___sdcc_bcall_ehl
	add	sp, #7
	call	_start
;src/game_field.c:100: }
	add	sp, #15
	ret
;src/game_field.c:102: void game_field_battle_item(uint8_t item,uint8_t actor) RPG_BANKED {
;	---------------------------------
; Function game_field_battle_item
; ---------------------------------
	b_game_field_battle_item	= 12
_game_field_battle_item::
	add	sp, #-17
;src/game_field.c:103: FieldContext c;uint8_t mode,boarding=0,result;
	ldhl	sp,	#15
	ld	(hl), #0x00
;src/game_field.c:104: context(&c);c.in_battle=1;c.chest=0;c.interaction=battle_scene_type;
	ld	hl, #0
	add	hl, sp
	ld	e, l
	ld	d, h
	call	_context
	ldhl	sp,	#9
	ld	(hl), #0x01
	xor	a, a
	ldhl	sp,	#6
	ld	(hl+), a
	ld	(hl), a
	ld	a, (#_battle_scene_type)
	ldhl	sp,	#8
	ld	(hl), a
;src/game_field.c:105: field_use_item(&c,rpg_find_item(&game_rpg,item),actor,&field_action);
	ldhl	sp,	#23
	ld	a, (hl)
	push	af
	inc	sp
	ld	de, #_game_rpg
	push	de
	ld	e, #b_rpg_find_item
	ld	hl, #_rpg_find_item
	call	___sdcc_bcall_ehl
	add	sp, #3
	ld	de, #_field_action
	push	de
	ldhl	sp,	#26
	ld	h, (hl)
	push	hl
	inc	sp
	push	af
	inc	sp
	ld	hl, #4
	add	hl, sp
	ld	e, l
	ld	d, h
	push	de
	ld	e, #b_field_use_item
	ld	hl, #_field_use_item
	call	___sdcc_bcall_ehl
	add	sp, #6
;src/game_field.c:106: field_action.character=actor;
	ld	de, #(_field_action + 4)
	ldhl	sp,	#24
	ld	a, (hl)
	ld	(de), a
;src/game_field.c:107: if(field_action.kind==FIELD_VEHICLE) {
	ld	a, (#_field_action + 0)
	sub	a, #0x0b
	jr	NZ, 00106$
;src/game_field.c:110: mode=(item-32u)*4u;
	dec	hl
	ld	a, (hl)
	add	a, #0xe0
	add	a, a
	add	a, a
	ld	b, a
;src/game_field.c:111: result=world_vehicle_use(&player_x,&player_y,facing,c.interaction,mode,&boarding);
	ldhl	sp,	#8
	ld	c, (hl)
	ld	de, #_player_y+0
	ld	hl, #15
	add	hl, sp
	push	hl
	push	bc
	ld	a, (_facing)
	push	af
	inc	sp
	push	de
	ld	de, #_player_x
	push	de
	ld	e, #b_world_vehicle_use
	ld	hl, #_world_vehicle_use
	call	___sdcc_bcall_ehl
	add	sp, #9
	ldhl	sp,	#16
	ld	(hl), a
;src/game_field.c:112: field_action.line_count=2;field_action.lines[0].dialogue=0xb2ac;
	ld	hl, #_field_action + 2
	ld	(hl), #0x02
	ld	hl, #(_field_action + 10)
	ld	a, #0xac
	ld	(hl+), a
	ld	(hl), #0xb2
;src/game_field.c:113: field_action.lines[1].dialogue=result?0xb305:0xb2e3;
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	Z, 00108$
	ld	bc, #0xb305
	jr	00109$
00108$:
	ld	bc, #0xb2e3
00109$:
	ld	hl, #(_field_action + 14)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/game_field.c:114: if(result)game_vehicle=boarding;else field_action.kind=FIELD_DONE;
	ldhl	sp,	#16
	ld	a, (hl)
	or	a, a
	jr	Z, 00102$
	dec	hl
	ld	a, (hl)
	ld	(#_game_vehicle),a
	jr	00106$
00102$:
	ld	hl, #_field_action
	ld	(hl), #0x00
00106$:
;src/game_field.c:119: }
	add	sp, #17
	ret
	.area _CODE_12
	.area _INITIALIZER
	.area _CABS (ABS)
