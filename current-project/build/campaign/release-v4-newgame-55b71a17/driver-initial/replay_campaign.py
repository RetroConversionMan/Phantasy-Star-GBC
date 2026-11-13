#!/usr/bin/env python3
"""Independently replay the campaign joypad log from power-on.

The default starts without SRAM. --earned-save explicitly permits only the
byte-identical initial save documented by a cartridge-upgrade continuation.
No save states or emulator memory writes are used. Every logged checkpoint is
compared with its recorded native state, including the RNG.
--candidate-rom and --output replay a completed fresh campaign on separately
identified ROM bytes without replacing or modifying the recorded run.
"""
from pathlib import Path
import argparse,hashlib,json,shutil,tempfile,time
from pyboy import PyBoy
from native_layout import native_event_layout
from verify_rom import load_symbols,read_word,cartridge_header,capture

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('run',type=Path);p.add_argument('--earned-save',action='store_true');p.add_argument('--trace-enemy',type=int,help='Read-only native battle-step snapshots for a specific enemy')
 p.add_argument('--candidate-rom',type=Path,help='Explicit different candidate for a clean power-on replay of a completed fresh campaign');p.add_argument('--output',type=Path,help='Required new evidence directory for --candidate-rom');a=p.parse_args();folder=a.run.resolve()
 report=json.loads((folder/'report.json').read_text());recorded_rom=folder/'campaign.gbc';assert cartridge_header(recorded_rom)==report['header']
 sha=lambda path:hashlib.sha256(path.read_bytes()).hexdigest()
 source_hashes={name:sha(folder/name)for name in('report.json','controller.jsonl','campaign.gbc','campaign.noi')}
 assert bool(a.candidate_rom)==bool(a.output),'Candidate replay requires both --candidate-rom and a new --output'
 rom=a.candidate_rom.resolve()if a.candidate_rom else recorded_rom;destination=a.output.resolve()if a.output else folder;replayed_header=cartridge_header(rom)
 provenance=report.get('save_continuation');assert bool(provenance)==a.earned_save,'Earned-save continuation requires explicit --earned-save; a fresh run must not use it'
 if provenance:assert hashlib.sha256((folder/'initial-earned-save.ram').read_bytes()).hexdigest()==provenance['source_save_sha256'],'Initial earned save changed'
 if a.candidate_rom:
  assert report.get('campaign_complete')and not provenance and not report.get('injected_fixtures'),'Candidate replay requires a completed fresh campaign without injected fixtures'
  assert not destination.exists(),'Candidate evidence directory must be new, with no SRAM or emulator state'
  destination.mkdir();shutil.copyfile(rom,destination/'campaign.gbc');shutil.copyfile(rom.with_suffix('.noi'),destination/'campaign.noi')
  shutil.copyfile(folder/'report.json',destination/'recorded-report.json');shutil.copyfile(folder/'controller.jsonl',destination/'recorded-controller.jsonl')
  (destination/'CANDIDATE_REPLAY_PROVENANCE.json').write_text(json.dumps({'kind':'Independent clean power-on replay of a completed recorded controller log on explicitly identified candidate bytes','recorded_run':str(folder),'recorded_rom_sha256':report['header']['sha256'],'replayed_rom_sha256':replayed_header['sha256'],'candidate_symbols_sha256':sha(rom.with_suffix('.noi')),'source_files_sha256':source_hashes,'initial_sram_loaded':False,'save_states_loaded':False,'state_injection':False,'source_run_mutated':False,'status':'Replay started; completion requires replay-report.json with passed=true'},indent=2)+'\n')
 layout=report.get('native_layout');event_objects=292
 if a.candidate_rom:layout=native_event_layout(rom)
 elif layout:assert native_event_layout(rom,folder/'native-layout.json')==layout
 if layout:event_objects=layout['event_object_flags_offset']
 symbols=load_symbols(rom.with_suffix('.noi'));events=[json.loads(line)for line in(folder/'controller.jsonl').read_text().splitlines()]
 assert all(a['frame']<=b['frame']for a,b in zip(events,events[1:])),'Controller log rewinds time'
 expected={(c['name'],c['frame']):c for c in report['checkpoints']};checked=[];trace=[];frame=0;started=time.monotonic()
 with tempfile.TemporaryDirectory(prefix='ps-campaign-replay-')as tmp:
  game=Path(tmp)/'clean.gbc';shutil.copyfile(rom,game)
  if provenance:shutil.copyfile(folder/'initial-earned-save.ram',Path(str(game)+'.ram'))
  e=PyBoy(str(game),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
  def byte(n,offset=0):return e.memory[symbols[n]+offset]
  def word(n,offset=0):return read_word(e,symbols[n]+offset)
  if a.trace_enemy is not None:
   def trace_step(_):
    if byte('battle_view_battle',128)!=a.trace_enemy:return
    b=symbols['battle_view_battle'];r=symbols['game_rpg']
    trace.append({'frame_before_tick_batch':frame,'rng':word('game_rpg',92),'outcome':byte('battle_view_battle',130),'turn_cursor':byte('battle_view_battle',159),'last_actor':byte('battle_view_battle',144),'last_target':byte('battle_view_battle',145),'last_damage':byte('battle_view_battle',146),'last_error':byte('battle_view_battle',147),'last_effect':byte('battle_view_battle',160),'enemy_hp':[e.memory[b+i*16+1]for i in range(byte('battle_view_battle',129))],'party':[list(e.memory[r+i*16:r+(i+1)*16])for i in range(4)],'actions':[list(e.memory[b+168+i*3:b+171+i*3])for i in range(4)],'hits':[list(e.memory[b+181+i*3:b+184+i*3])for i in range(byte('battle_view_battle',180))]})
   address=symbols['rpg_battle_step'];e.hook_register(address>>16,address&65535,trace_step,None)
  def snapshot():
   count=byte('game_rpg',88);x,y=word('player_x'),word('player_y')
   result={'vehicle':byte('game_vehicle'),'dungeon':[byte('game_dungeon',i)for i in range(4)]if byte('game_dungeon',264)else None,'object_flags':{str(i):byte('game_events',event_objects+i)for i in range(256)if byte('game_events',event_objects+i)},'screen':byte('screen_state'),'map':byte('world_map_id'),'position':[x,y],'cell':[(x-8)//16,(y+1536-16)%1536//16],'party':[list(e.memory[symbols['game_rpg']+i*16:symbols['game_rpg']+(i+1)*16])for i in range(4)],'items':list(e.memory[symbols['game_rpg']+64:symbols['game_rpg']+64+count])if count else[],'money':word('game_rpg',90),'joined':byte('game_rpg',89),'rng':word('game_rpg',92),'story_flags':{str(i):byte('game_events',i)for i in range(256)if byte('game_events',i)}}
   if 'vehicle_cycle' in symbols:result['vehicle_cycle']=[byte('vehicle_cycle',i)for i in range(2)]
   if 'game_fade_clock' in symbols:result['fade_clock']=byte('game_fade_clock');result['map_music']=byte('game_map_music')
   return result
  for row in events:
   if row['frame']>frame:assert e.tick(row['frame']-frame);frame=row['frame']
   if row['kind']=='press':e.button_press(row['key'])
   elif row['kind']=='release':e.button_release(row['key'])
   elif row['kind']=='checkpoint':
    actual=snapshot();want=expected[row['name'],frame];diff={k:{'expected':want[k],'actual':v}for k,v in actual.items()if k in want and v!=want[k]}
    if diff:
     (destination/'replay-failure.json').write_text(json.dumps({'passed':False,'checkpoint':row['name'],'frame':frame,'recorded_rom_sha256':report['header']['sha256'],'replayed_rom_sha256':replayed_header['sha256'],'difference':diff},indent=2)+'\n')
    assert not diff,(row['name'],frame,diff);checked.append({'name':row['name'],'frame':frame});print(json.dumps({'replayed':row['name'],'frame':frame}),flush=True)
  if report['latest']['frame']>frame:assert e.tick(report['latest']['frame']-frame);frame=report['latest']['frame']
  assert len(checked)==len(expected),'Controller log did not contain every recorded checkpoint'
  actual=snapshot();assert all(actual[k]==report['latest'][k]for k in actual if k in report['latest']),(actual,report['latest'])
  display_settle=None
  if report.get('campaign_complete'):
   assert actual['screen']==0
   settled=0;start_counter=word('frame_counter')
   while not(e.memory[0xff40]&0x80)or word('frame_counter')==start_counter:
    assert settled<12000,'Ending title did not enable its display'
    assert e.tick();settled+=1
   assert e.tick(3);settled+=3
   assert byte('screen_state')==0,'Final title changed during display settling'
   picture=destination/'replay-ending-title-settled.png';picture_info=capture(e,picture)
   assert picture_info['unique_colors']>1,'Settled title capture is blank'
   display_settle={'post_log_frames':settled,'screen':byte('screen_state'),'lcd_enabled':bool(e.memory[0xff40]&0x80),'capture':picture.name,'capture_sha256':hashlib.sha256(picture.read_bytes()).hexdigest(),'unique_colors':picture_info['unique_colors'],'controller_inputs':0}
  e.stop(save=bool(a.candidate_rom))
  if a.candidate_rom:shutil.copyfile(Path(str(game)+'.ram'),destination/'campaign.gbc.ram')
 complete=bool(report.get('campaign_complete'));assert not complete or(actual['screen']==0 and any(e['kind']=='ending_returned_to_title'for e in events)),'Completion requires an actual recorded ending return to title'
 result={'passed':True,'rom_sha256':replayed_header['sha256'],'recorded_rom_sha256':report['header']['sha256'],'replayed_rom_sha256':replayed_header['sha256'],'controller_log_sha256':source_hashes['controller.jsonl'],'frames':frame,'checkpoints':checked,'final':actual,'elapsed_seconds':round(time.monotonic()-started,1),'state_injection':False,'save_states_loaded':False,'initial_earned_sram_loaded':bool(provenance),'initial_earned_sram_sha256':provenance['source_save_sha256']if provenance else None,'campaign_complete':complete,'fresh_newgame_completion':complete and not provenance}
 assert source_hashes=={name:sha(folder/name)for name in source_hashes},'Recorded source run changed during replay'
 assert sha(rom)==replayed_header['sha256'],'Replayed cartridge changed on disk'
 if a.candidate_rom:result.update(candidate_replay=True,source_run_mutated=False,native_final_sram_sha256=sha(destination/'campaign.gbc.ram'),native_final_sram_kind='Written by this candidate replay after native in-game saves; no source SRAM imported')
 if display_settle is not None:result['post_log_display_settle']=display_settle
 (destination/'replay-report.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items()if k not in('checkpoints','final')},indent=2))
 if a.trace_enemy is not None:(destination/('replay-enemy-'+str(a.trace_enemy)+'-trace.json')).write_text(json.dumps({'read_only':True,'boundary':'Before the next original battle step; last_actor/effect/hits describe the preceding completed action. Frame is the preceding controller-log batch boundary.','rom_sha256':replayed_header['sha256'],'records':trace},indent=2)+'\n')
if __name__=='__main__':main()
