#!/usr/bin/env python3
"""Earn a new-ROM campaign prefix by replaying controller input from power-on.

Never loads old SRAM, an old save state, or writes emulator memory. Every
checkpoint must match the old committed controller prefix, including RNG.
The final emulator state is created only after that new-ROM gameplay passes.
A mismatch stops immediately; this tool does not retry or search timing/seeds.
"""
from pathlib import Path
import argparse,copy,hashlib,json,shutil,time,traceback
from pyboy import PyBoy
from native_layout import native_event_layout
from verify_rom import load_symbols,read_word,cartridge_header,capture

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('rom',type=Path);p.add_argument('prefix',type=Path);p.add_argument('--output',type=Path,required=True)
 p.add_argument('--checkpoint',required=True);p.add_argument('--timing-probe',action='store_true',help='Diagnostic replay to latest completed checkpoint while preserving a later stopped source tail');a=p.parse_args()
 source=a.prefix.resolve();out=a.output.resolve();assert not out.exists(),'Requires a new output with no SRAM or state'
 old=json.loads((source/'report.json').read_text());assert not old.get('save_continuation')and not old.get('injected_fixtures'),'Prefix must originate from a clean New Game'
 target=next(c for c in old['checkpoints']if c['name']==a.checkpoint)
 assert target==old['checkpoints'][-1],'Use the latest committed source checkpoint, not an earlier retry point'
 assert target['frame']==old['latest']['frame']or(a.timing_probe and target['frame']<old['latest']['frame']),'A later stopped source tail requires explicit --timing-probe'
 rows=(source/'controller.jsonl').read_text().splitlines();events=[json.loads(l)for l in rows]
 stop=next(i for i,e in enumerate(events)if e['kind']=='checkpoint'and e['name']==a.checkpoint and e['frame']==target['frame'])
 tail=events[stop+1:]
 if target['frame']==old['latest']['frame']:
  assert not any(e['kind']in('press','release')for e in tail),'Committed endpoint has later unplayed controller input'
 events=events[:stop+1];rows=rows[:stop+1]
 assert all(x['frame']<=y['frame']for x,y in zip(events,events[1:])),'Prefix rewinds time'
 assert not any(e['kind']=='native_continue'for e in events)or old.get('deaths'),'Continue requires actual recorded deaths in a fresh campaign'
 expected_rows=[c for c in old['checkpoints']if c['frame']<=target['frame']]
 expected_keys=[(c['name'],c['frame'])for c in expected_rows]
 assert len(set(expected_keys))==len(expected_keys)and len({c['name']for c in expected_rows})==len(expected_rows),'Duplicate expected checkpoints'
 assert [(row['name'],row['frame'])for row in events if row['kind']=='checkpoint']==expected_keys,'Controller checkpoint order/set differs from the recorded report'
 expected=dict(zip(expected_keys,expected_rows))
 out.mkdir();rom=out/'campaign.gbc';shutil.copyfile(a.rom,rom);shutil.copyfile(a.rom.with_suffix('.noi'),rom.with_suffix('.noi'))
 tooling=out/'verification-tooling';tooling.mkdir()
 tool_names=('replay_campaign_prefix.py','replay_campaign.py','native_layout.py','verify_rom.py','verify_campaign_title.py','campaign_runner.py','run_campaign_story.py','campaign_dungeon_route.py','campaign_world_route.py','campaign_hover_route.py')
 for name in tool_names:shutil.copyfile(Path(__file__).resolve().parent/name,tooling/name)
 tool_hashes={name:sha(tooling/name)for name in tool_names}
 (tooling/'MANIFEST.json').write_text(json.dumps(tool_hashes,indent=2)+'\n')
 layout=native_event_layout(a.rom);event_objects=layout['event_object_flags_offset']
 if layout:(out/'native-layout.json').write_text(json.dumps(layout,indent=2)+'\n')
 header=cartridge_header(rom);s=load_symbols(rom.with_suffix('.noi'));frame=0;checked=[];started=time.monotonic()
 e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 def byte(n,off=0):return e.memory[s[n]+off]
 def word(n,off=0):return read_word(e,s[n]+off)
 def snapshot():
  count=byte('game_rpg',88);x,y=word('player_x'),word('player_y')
  result={'vehicle':byte('game_vehicle'),'dungeon':[byte('game_dungeon',i)for i in range(4)]if byte('game_dungeon',264)else None,'object_flags':{str(i):byte('game_events',event_objects+i)for i in range(256)if byte('game_events',event_objects+i)},'frame':frame,'screen':byte('screen_state'),'map':byte('world_map_id'),'position':[x,y],'cell':[(x-8)//16,(y+1536-16)%1536//16],'party':[list(e.memory[s['game_rpg']+i*16:s['game_rpg']+(i+1)*16])for i in range(4)],'items':list(e.memory[s['game_rpg']+64:s['game_rpg']+64+count])if count else[],'money':word('game_rpg',90),'joined':byte('game_rpg',89),'rng':word('game_rpg',92),'story_flags':{str(i):byte('game_events',i)for i in range(256)if byte('game_events',i)}}
  if 'vehicle_cycle' in s:result['vehicle_cycle']=[byte('vehicle_cycle',i)for i in range(2)]
  if 'game_fade_clock' in s:result['fade_clock']=byte('game_fade_clock');result['map_music']=byte('game_map_music')
  return result
 proof={'source_report_sha256':sha(source/'report.json'),'source_controller_sha256':sha(source/'controller.jsonl'),'source_rom_sha256':old['header']['sha256'],'rom_sha256':header['sha256'],'checkpoint':a.checkpoint,'target_frame':target['frame'],'source_latest_frame':old['latest']['frame'],'timing_probe':a.timing_probe,'omitted_gameplay_frames':old['latest']['frame']-target['frame'],'omitted_unfinished_tail':'Retained unchanged in the original source controller log; diagnostic truncation is explicit'if old['latest']['frame']>target['frame']else None,'post_checkpoint_metadata_omitted':[e['kind']for e in tail]if old['latest']['frame']==target['frame']else None,'initial_sram_loaded':False,'save_states_loaded':False,'state_injection':False,'retries':0,'passed':False}
 proof.update(replay_tooling_sha256=tool_hashes,candidate_symbols_sha256=sha(rom.with_suffix('.noi')),checkpoint_comparison='Every expected gameplay key must exist and match; exact ordered unique checkpoint sequence')
 try:
  for row in events:
   if row['frame']>frame:assert e.tick(row['frame']-frame);frame=row['frame']
   if row['kind']=='press':e.button_press(row['key'])
   elif row['kind']=='release':e.button_release(row['key'])
   elif row['kind']=='checkpoint':
    actual=snapshot();want={k:v for k,v in expected[row['name'],frame].items()if k not in('name','rom_sha256')}
    diff={k:{'expected':v,'actual':actual.get(k),'missing':k not in actual}for k,v in want.items()if k not in actual or actual[k]!=v}
    assert not diff,(row['name'],frame,diff)
    checked.append({'name':row['name'],'rom_sha256':header['sha256'],**actual});print(json.dumps({'replayed':row['name'],'frame':frame}),flush=True)
  actual=snapshot();assert actual['screen']in(1,17)and [(c['name'],c['frame'])for c in checked]==expected_keys
  assert sha(source/'report.json')==proof['source_report_sha256']and sha(source/'controller.jsonl')==proof['source_controller_sha256'],'Source run changed during prefix replay'
  assert sha(source/'campaign.gbc')==proof['source_rom_sha256']and sha(rom)==header['sha256'],'A cartridge changed during prefix replay'
  assert sha(rom.with_suffix('.noi'))==proof['candidate_symbols_sha256']and {name:sha(tooling/name)for name in tool_names}==tool_hashes,'Frozen symbols or verification tooling changed during replay'
  final=out/(a.checkpoint+'.state')
  with final.open('wb')as f:e.save_state(f)
  final.with_suffix('.json').write_text(json.dumps({'rom_sha256':header['sha256'],**actual},indent=2)+'\n');capture(e,final.with_suffix('.png'))
  (out/'controller.jsonl').write_text('\n'.join(rows)+'\n')
  report=copy.deepcopy(old);report['header']=header;report['checkpoints']=checked;report['latest']=actual;report['campaign_complete']=False;report.pop('failure',None)
  for key,statekey in(('battles','after'),('routes','result'),('failures','state')):
   if key in report:report[key]=[r for r in report[key]if r[statekey]['frame']<=frame]
  for key in('deaths','continues'):
   if key in report:report[key]=[r for r in report[key]if r.get('frame',r.get('after',{}).get('frame',0))<=frame]
  if layout:report['native_layout']=layout
  report['current_status']='New ROM independently earned the controller prefix from clean power-on; ready to continue current story phase'
  proof.update(passed=True,frames=frame,checkpoints=len(checked),elapsed_seconds=round(time.monotonic()-started,1),generated_resume_state=final.name,generated_resume_state_sha256=sha(final),replayed_controller_sha256=sha(out/'controller.jsonl'))
  report['elapsed_seconds']=proof['elapsed_seconds']
  report['prefix_replay_provenance']=proof
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
  (out/'FRESH_START_PROVENANCE.json').write_text(json.dumps({'rom_sha256':header['sha256'],'initial_sram':None,'initial_emulator_state':None,'start':'Native New Game by independently replaying verified controller prefix from clean power-on','controller_only':True,'phase_count':51,'source_prefix':str(source),'source_report_sha256':proof['source_report_sha256'],'source_controller_sha256':proof['source_controller_sha256'],'all_checkpoints_matched':True,'old_resume_log_annotations':'Metadata only: no old save state is loaded during replay','new_rom_generated_resume_state':final.name},indent=2)+'\n')
 except BaseException as ex:
  proof.update(error=str(ex),traceback=traceback.format_exc(),frame=frame,checked=len(checked));raise
 finally:
  e.stop(save=proof['passed']);(out/'PREFIX_REPLAY_PROOF.json').write_text(json.dumps(proof,indent=2)+'\n')
 print(json.dumps(proof,indent=2))
if __name__=='__main__':main()
