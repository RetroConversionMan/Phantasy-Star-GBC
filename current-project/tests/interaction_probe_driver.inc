/* Explicit native test harness. Actual production helpers above are included;
 * only dialogue-completion input is supplied by the test driver. */
uint8_t probe_request,probe_ready,probe_clock;
static void probe_fresh(void){
 rpg_new_game(&game_rpg);event_init(&game_events,&game_rpg);game_dungeon.active=0;
 game_rpg.party[0].hp=1;game_rpg.party[0].mp=2;game_rpg.party[0].max_hp=100;game_rpg.party[0].max_mp=30;
 game_rpg.party[1].hp=2;game_rpg.party[1].mp=3;
 game_map_music=0x87;game_fade_clock=probe_clock;
 DISPLAY_OFF;HIDE_WIN;scene_actor_hide();scene_show(16u,0u,0u);DISPLAY_ON;
 background_changed=1;scene_context_type=16;game_events.type=16;
}
void main(void){uint8_t request;
 DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;cpu_fast();audio_install();
 VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;SPRITES_8x8;set_bkg_palette(7,1,ui_palette);
 rpg_new_game(&game_rpg);event_init(&game_events,&game_rpg);world_select(4u);world_load_graphics();
 player_x=1704;player_y=304;party_world_reset(0);redraw_world(1);SHOW_BKG;SHOW_SPRITES;DISPLAY_ON;probe_clock=3;probe_ready=255;
 while(1){vsync();request=probe_request;if(!request)continue;probe_ready=0;
  if(request==1u){probe_fresh();event_begin(&game_events,16,1,0,4);apply_event();}
  else if(request==2u||request==3u||request==5u||request==8u){event_advance(&game_events);apply_event();}
  else if(request==4u){probe_fresh();event_begin(&game_events,16,57,0,4);apply_event();}
  else if(request==6u){probe_fresh();rpg_recruit(&game_rpg,1u);event_begin(&game_events,16,22,0,4);apply_event();}
  else if(request==7u){event_respond(&game_events,1u);apply_event();}
  else if(request==9u){probe_fresh();game_events.event=0;game_events.stage=177u;game_events.pending_item=ItemID_Cola;game_events.action.kind=EVENT_DIALOGUE;event_advance(&game_events);apply_event();}
  else if(request==10u){probe_fresh();screen_state=2u;audio_command_before_tick(0xd0u);title_screen();}
  else if(request==11u){game_fade_clock=probe_clock;ending_walk_begin(1u);while(!ending_walk_tick())vsync();}
  probe_request=0;probe_ready=request;
 }
}
