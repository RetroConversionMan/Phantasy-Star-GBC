from pathlib import Path
import hashlib,json,sys,traceback
ROOT=Path.cwd();sys.path.insert(0,str(ROOT/'tools'))
from campaign_runner import Campaign
from verify_rom import capture
out=ROOT/'build/campaign/release-v4-newgame-55b71a17';resume=out/'failure-001.state'
old=json.loads((out/'report.json').read_text());meta=json.loads(resume.with_suffix('.json').read_text())
assert all(meta.get(k)==v for k,v in old['latest'].items())
assert old['failure']['message']=='Natural defeat: failure checkpoint retained. Continue explicitly from actual save.'
assert old['story_driver']['current_phase']=='torch'
q=Campaign(out/'campaign.gbc',out,resume)
try:
 q.record('story_native_defeat_recovery',phase='torch',death_count=len(q.report['deaths']),route='Original Flute, Corona/Aukba return caves, church and hospital; stop at rested native checkpoint before field vehicle use')
 q.torch_recover()
 q.report.pop('failure',None);q.report['current_status']='Held after actual Continue and original Aukba recovery; latest state exactly equals the last checkpoint, before field vehicle use'
 assert q.snapshot()=={k:v for k,v in q.report['checkpoints'][-1].items()if k not in('name','rom_sha256')}
 q.record('campaign_hold_after_recovery',checkpoint=q.report['checkpoints'][-1]['name'],reason='Await separately verified vehicle-reload candidate; this unchanged v4 run ends here')
 q.flush()
except BaseException as ex:
 q.report['failure']={'type':type(ex).__name__,'message':str(ex),'traceback':traceback.format_exc(),'state':q.snapshot()};q.report.setdefault('failures',[]).append(q.report['failure']);q.report['current_status']='Stopped during source Torch recovery'
 stem='failure-'+str(len(q.report['failures'])).zfill(3)
 assert not(out/(stem+'.state')).exists()
 with(out/(stem+'.state')).open('wb')as f:q.e.save_state(f)
 (out/(stem+'.json')).write_text(json.dumps({'rom_sha256':q.report['header']['sha256'],**q.snapshot()},indent=2)+'\n');capture(q.e,out/(stem+'.png'));raise
finally:q.stop()
