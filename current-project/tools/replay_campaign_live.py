#!/usr/bin/env python3
"""Independent clean-power-on replay of a live, append-only campaign log.

No source SRAM/state is imported. Caught-up waiting never advances emulation.
Completion requires the source's immutable post-close marker, exact final input
bytes/report/checkpoints/native SRAM, and settled title. A named prefix stop is
explicitly diagnostic and can never report campaign completion.
"""
from pathlib import Path
import argparse,hashlib,json,shutil,time,traceback
from pyboy import PyBoy
from native_layout import native_event_layout
from verify_rom import load_symbols,read_word,cartridge_header,capture

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def stable_json(path):
 try:
  first=path.read_bytes();result=json.loads(first)
  if path.read_bytes()!=first:return None
  return result,first
 except (FileNotFoundError,json.JSONDecodeError,UnicodeDecodeError):return None

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('source',type=Path);p.add_argument('--output',type=Path,required=True)
 p.add_argument('--stop-at-checkpoint',help='Declared diagnostic prefix only; never final completion');p.add_argument('--poll-seconds',type=float,default=0.5);a=p.parse_args()
 source=a.source.resolve();out=a.output.resolve();assert not out.exists(),'Require a new output with no SRAM/state';assert a.poll_seconds>0
 directory=Path(__file__).resolve().parent;frozen_path=directory/'FROZEN_TOOLS.json';frozen=json.loads(frozen_path.read_text());frozen_hash=sha(frozen_path)
 def tooling_ok():
  assert sha(frozen_path)==frozen_hash and all(sha(directory/n)==v for n,v in frozen['tools'].items()),'Frozen replay tooling changed'
 tooling_ok();assert Path(__file__).name in frozen['tools']
 while (read:=stable_json(source/'report.json'))is None:time.sleep(a.poll_seconds)
 report,initial_report_bytes=read;assert not report.get('save_continuation')and not report.get('injected_fixtures'),'Live proof requires fresh controller-only campaign'
 source_files={'campaign.gbc':sha(source/'campaign.gbc'),'campaign.noi':sha(source/'campaign.noi'),'native-layout.json':sha(source/'native-layout.json')}
 assert source_files['campaign.gbc']==report['header']['sha256']
 layout=native_event_layout(source/'campaign.gbc',source/'native-layout.json');assert report['native_layout']==layout
 object_offset=layout['event_object_flags_offset'];out.mkdir();shutil.copyfile(source/'campaign.gbc',out/'campaign.gbc');shutil.copyfile(source/'campaign.noi',out/'campaign.noi')
 shutil.copyfile(source/'native-layout.json',out/'native-layout.json');(out/'initial-source-report.json').write_bytes(initial_report_bytes)
 shutil.copytree(directory,out/'verification-tooling',ignore=shutil.ignore_patterns('__pycache__'))
 assert not(out/'campaign.gbc.ram').exists()
 header=cartridge_header(out/'campaign.gbc');symbols=load_symbols(out/'campaign.noi');started=time.monotonic();last_immutable=0;last_progress=0
 frame=0;rows=0;checked=[];published_checkpoints=[];consumed=bytearray();observed_raw=b'';closed_marker_bytes=None;rolling=hashlib.sha256();held=set();idle_polls=0;last_row=None;end_event=False;phase_complete=False;emulator=None;finished=False
 log=(out/'recorded-controller.jsonl').open('wb')
 provenance={'source':str(source),'rom_sha256':header['sha256'],'source_immutable_files':source_files,'tooling_sha256':frozen['tools'],'frozen_manifest_sha256':frozen_hash,'initial_sram_loaded':False,'save_states_loaded':False,'state_injection':False,'source_mutated':False,'diagnostic_stop':a.stop_at_checkpoint,'finalization':'Only immutable CAMPAIGN_CLOSED.json after source process/emulator/log close; no transient campaign_complete acceptance'}
 (out/'LIVE_REPLAY_PROVENANCE.json').write_text(json.dumps(provenance,indent=2)+'\n')
 def immutable(force=False):
  nonlocal last_immutable
  now=time.monotonic()
  if force or now-last_immutable>=30:
   assert all(sha(source/n)==v for n,v in source_files.items()),'Source cartridge/symbol/layout changed';tooling_ok()
   assert sha(out/'verification-tooling/FROZEN_TOOLS.json')==frozen_hash and all(sha(out/'verification-tooling'/n)==v for n,v in frozen['tools'].items()),'Delivered verification tooling changed'
   assert sha(out/'campaign.gbc')==source_files['campaign.gbc']and sha(out/'campaign.noi')==source_files['campaign.noi'],'Replay cartridge/symbols changed';last_immutable=now
 def read_log():
  nonlocal observed_raw
  raw=(source/'controller.jsonl').read_bytes()
  assert len(raw)>=len(observed_raw)and raw[:len(observed_raw)]==observed_raw,'Previously observed controller bytes were changed or truncated'
  observed_raw=raw;return raw
 def accept_report(value):
  nonlocal report,published_checkpoints
  assert value['header']==header and value['native_layout']==layout
  assert not value.get('save_continuation')and not value.get('injected_fixtures')
  entries=value['checkpoints'];keys=[(c['name'],c['frame'])for c in entries]
  assert len(set(keys))==len(keys)and len({c['name']for c in entries})==len(entries),'Duplicate source checkpoints'
  assert entries[:len(published_checkpoints)]==published_checkpoints,'Published checkpoint metadata rewound or changed'
  published_checkpoints=entries;report=value
 accept_report(report)
 def read_report_wait(index=None):
  nonlocal idle_polls
  while True:
   immutable();read=stable_json(source/'report.json')
   if read:
    value,raw=read;accept_report(value)
    if index is None or index<len(published_checkpoints):return raw
   idle_polls+=1;progress('awaiting-stable-source-report',True);time.sleep(a.poll_seconds)
 def progress(status,force=False):
  nonlocal last_progress
  now=time.monotonic()
  if force or now-last_progress>=10:
   value={'status':status,'frame':frame,'rows':rows,'checkpoints':len(checked),'last_checkpoint':checked[-1]if checked else None,'consumed_bytes':len(consumed),'consumed_sha256':rolling.hexdigest(),'caught_up_polls_without_ticks':idle_polls,'held_keys':sorted(held),'elapsed_seconds':round(now-started,1),'campaign_complete':False,'rom_sha256':header['sha256']}
   (out/'progress.json').write_text(json.dumps(value,indent=2)+'\n');last_progress=now
 try:
  emulator=PyBoy(str(out/'campaign.gbc'),window='null',cgb=True,sound_emulated=False,log_level='ERROR');emulator.set_emulation_speed(0)
  def byte(n,offset=0):return emulator.memory[symbols[n]+offset]
  def word(n,offset=0):return read_word(emulator,symbols[n]+offset)
  def snapshot():
   count=byte('game_rpg',88);x,y=word('player_x'),word('player_y')
   result={'frame':frame,'vehicle':byte('game_vehicle'),'dungeon':[byte('game_dungeon',i)for i in range(4)]if byte('game_dungeon',264)else None,'object_flags':{str(i):byte('game_events',object_offset+i)for i in range(256)if byte('game_events',object_offset+i)},'screen':byte('screen_state'),'map':byte('world_map_id'),'position':[x,y],'cell':[(x-8)//16,(y+1536-16)%1536//16],'party':[list(emulator.memory[symbols['game_rpg']+i*16:symbols['game_rpg']+(i+1)*16])for i in range(4)],'items':list(emulator.memory[symbols['game_rpg']+64:symbols['game_rpg']+64+count])if count else[],'money':word('game_rpg',90),'joined':byte('game_rpg',89),'rng':word('game_rpg',92),'story_flags':{str(i):byte('game_events',i)for i in range(256)if byte('game_events',i)}}
   if 'vehicle_cycle'in symbols:result['vehicle_cycle']=[byte('vehicle_cycle',i)for i in range(2)]
   if 'game_fade_clock'in symbols:result['fade_clock']=byte('game_fade_clock');result['map_music']=byte('game_map_music')
   return result
  def compare(expected):
   actual=snapshot();want={k:v for k,v in expected.items()if k not in('name','rom_sha256')}
   diff={k:{'expected':v,'actual':actual.get(k),'missing':k not in actual}for k,v in want.items()if k not in actual or actual[k]!=v}
   assert not diff,('Native state mismatch',expected.get('name','latest'),frame,diff)
   return actual
  while True:
   immutable();raw=read_log();published=raw[:raw.rfind(b'\n')+1]
   assert len(published)>=len(consumed)and published[:len(consumed)]==consumed,'Source controller prefix was changed or truncated'
   additions=published[len(consumed):].splitlines(keepends=True)
   if additions:read_report_wait()
   for line in additions:
    assert line.endswith(b'\n');row=json.loads(line);assert isinstance(row['frame'],int)and row['frame']>=frame,'Controller log rewinds time'
    if row['frame']>frame:assert emulator.tick(row['frame']-frame);frame=row['frame']
    if row['kind']=='press':emulator.button_press(row['key']);held.add(row['key'])
    elif row['kind']=='release':emulator.button_release(row['key']);held.discard(row['key'])
    elif row['kind']=='checkpoint':
     index=len(checked)
     if index>=len(published_checkpoints):read_report_wait(index)
     expected=published_checkpoints[index];assert(row['name'],frame)==(expected['name'],expected['frame']),'Checkpoint order/set differs'
     compare(expected);checked.append({'name':row['name'],'frame':frame});print(json.dumps({'replayed':row['name'],'frame':frame}),flush=True)
    if row['kind']=='ending_returned_to_title':end_event=True
    if row['kind']=='story_phase_complete'and row.get('phase')=='final_maze':phase_complete=True
    consumed.extend(line);rolling.update(line);log.write(line);log.flush();rows+=1;last_row=row;immutable();progress('replaying')
    if a.stop_at_checkpoint and row['kind']=='checkpoint'and row['name']==a.stop_at_checkpoint:
     immutable(True);current=read_log();assert current[:len(consumed)]==consumed
     result={**provenance,'passed':True,'diagnostic_prefix_only':True,'campaign_complete':False,'frames':frame,'checkpoints':checked,'final':snapshot(),'consumed_rows':rows,'consumed_bytes':len(consumed),'consumed_controller_sha256':rolling.hexdigest(),'source_prefix_byte_exact':True,'omitted_later_source_bytes':len(current)-len(consumed),'elapsed_seconds':round(time.monotonic()-started,1)}
     (out/'prefix-replay-report.json').write_text(json.dumps(result,indent=2)+'\n');finished=True;emulator.stop(save=False);emulator=None;progress('diagnostic-prefix-passed',True);return
   if additions:continue
   marker_read=stable_json(source/'CAMPAIGN_CLOSED.json')
   if marker_read:
    assert not a.stop_at_checkpoint,'Closed source did not contain the requested diagnostic checkpoint'
    marker,marker_bytes=marker_read;assert marker['schema']==1 and marker['closed']is True and marker['campaign_complete']is True
    if closed_marker_bytes is None:closed_marker_bytes=marker_bytes
    else:assert marker_bytes==closed_marker_bytes,'Published closed marker changed'
    final_read=stable_json(source/'report.json');assert final_read is not None,'Closed source report is not stable'
    final,final_bytes=final_read;accept_report(final);immutable(True)
    pinned={'rom_sha256':sha(source/'campaign.gbc'),'symbols_sha256':sha(source/'campaign.noi'),'controller_sha256':sha(source/'controller.jsonl'),'report_sha256':hashlib.sha256(final_bytes).hexdigest(),'sram_sha256':sha(source/'campaign.gbc.ram')}
    assert all(marker[k]==v for k,v in pinned.items()),'Closed marker file hashes differ'
    final_log=read_log()
    # The last rows/marker may arrive between the caught-up read and this
    # marker read. Consume those valid complete rows on the next iteration.
    if final_log!=consumed:
     assert final_log.startswith(consumed)and final_log.endswith(b'\n'),'Closed source has invalid or incomplete controller bytes'
     continue
    assert rolling.hexdigest()==pinned['controller_sha256']==sha(out/'recorded-controller.jsonl'),'Consumed whole-log bytes differ'
    assert marker['final_frame']==final['latest']['frame']and marker['checkpoint_count']==len(final['checkpoints'])
    assert final['campaign_complete']and final['story_driver']['next_phase']==51 and end_event and phase_complete,'Incomplete final story boundary'
    assert [(c['name'],c['frame'])for c in checked]==[(c['name'],c['frame'])for c in final['checkpoints']],'Final checkpoint order/set differs'
    assert final['latest']['frame']>=frame
    if final['latest']['frame']>frame:assert emulator.tick(final['latest']['frame']-frame);frame=final['latest']['frame']
    actual=compare(final['latest']);assert actual['screen']==0
    settled=0;counter=word('frame_counter')
    while not(emulator.memory[0xff40]&128)or word('frame_counter')==counter:
     assert settled<12000,'Ending title dispatch did not settle';assert emulator.tick();settled+=1
    assert emulator.tick(3);settled+=3;assert byte('screen_state')==0
    picture=capture(emulator,out/'replay-ending-title-settled.png');assert picture['unique_colors']>1
    emulator.stop(save=True);emulator=None
    assert sha(out/'campaign.gbc.ram')==pinned['sram_sha256'],'Freshly generated native SRAM differs from closed source earned SRAM'
    assert (source/'CAMPAIGN_CLOSED.json').read_bytes()==marker_bytes and (source/'report.json').read_bytes()==final_bytes and read_log()==final_log
    assert all(sha(source/n)==pinned[k]for n,k in(('campaign.gbc','rom_sha256'),('campaign.noi','symbols_sha256'),('campaign.gbc.ram','sram_sha256')));immutable(True)
    (out/'recorded-report.json').write_bytes(final_bytes);(out/'CAMPAIGN_CLOSED.json').write_bytes(marker_bytes)
    result={**provenance,'passed':True,'diagnostic_prefix_only':False,'campaign_complete':True,'fresh_newgame_completion':True,'frames':frame,'checkpoints':checked,'final':actual,'consumed_rows':rows,'controller_log_sha256':rolling.hexdigest(),'consumed_bytes':len(consumed),'source_final_hashes':pinned,'source_closed_marker_sha256':hashlib.sha256(marker_bytes).hexdigest(),'native_final_sram_sha256':sha(out/'campaign.gbc.ram'),'native_sram_matches_source':True,'post_log_display_settle':{'frames':settled,'screen':0,'capture':picture,'capture_sha256':sha(out/'replay-ending-title-settled.png'),'controller_inputs':0},'caught_up_polls_without_ticks':idle_polls,'elapsed_seconds':round(time.monotonic()-started,1)}
    (out/'replay-report.json').write_text(json.dumps(result,indent=2)+'\n');finished=True;progress('full-replay-passed',True);print(json.dumps({'passed':True,'campaign_complete':True,'frames':frame,'checkpoints':len(checked),'rom_sha256':header['sha256']}),flush=True);return
   idle_polls+=1;progress('caught-up-awaiting-published-input-or-closed-marker',True);time.sleep(a.poll_seconds)
 except BaseException as error:
  failure={**provenance,'passed':False,'campaign_complete':False,'frames':frame,'checked_checkpoints':checked,'consumed_rows':rows,'consumed_bytes':len(consumed),'consumed_controller_sha256':rolling.hexdigest(),'last_row':last_row,'error':str(error),'traceback':traceback.format_exc(),'elapsed_seconds':round(time.monotonic()-started,1)}
  (out/'replay-failure.json').write_text(json.dumps(failure,indent=2)+'\n');raise
 finally:
  log.close()
  if emulator is not None:emulator.stop(save=False)

if __name__=='__main__':main()
