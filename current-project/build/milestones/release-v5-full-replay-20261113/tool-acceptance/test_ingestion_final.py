from pathlib import Path
import sys,json,shutil,subprocess,time,hashlib
ROOT=Path.cwd();real=ROOT/'build/campaign/release-v5-newgame-b72feead';base=ROOT/'build/verification/live-replay-ingestion-final';assert not base.exists();base.mkdir()
tool=ROOT/'build/source-snapshots/replay-live-tools-20261113/tools/replay_campaign_live.py'
while True:
 try:original=json.loads((real/'report.json').read_text());break
 except json.JSONDecodeError:time.sleep(.05)
allrows=(real/'controller.jsonl').read_bytes().splitlines(keepends=True);ends=[]
for i,row in enumerate(allrows):
 if json.loads(row)['kind']=='checkpoint':ends.append(i+1)
 if len(ends)>=4:break
chunks=[b''.join(allrows[:n])for n in ends];target=original['checkpoints'][3]['name'];cases=[]
def source(name):
 p=base/name;p.mkdir()
 for f in('campaign.gbc','campaign.noi','native-layout.json'):shutil.copyfile(real/f,p/f)
 r=dict(original);r['checkpoints']=original['checkpoints'][:1];r['latest']=r['checkpoints'][-1].copy();r['latest'].pop('name');r['latest'].pop('rom_sha256');r['campaign_complete']=False;r['diagnostic_fixture']='Committed real controller prefix; no injected emulator state or gameplay values'
 (p/'report.json').write_text(json.dumps(r));(p/'controller.jsonl').write_bytes(chunks[0]);return p,r
def launch(src,out):
 log=(out.with_suffix('.log')).open('w');p=subprocess.Popen([sys.executable,str(tool),str(src),'--output',str(out),'--stop-at-checkpoint',target,'--poll-seconds','0.05'],stdout=log,stderr=subprocess.STDOUT);return p,log
def progress(out,p,predicate):
 deadline=time.monotonic()+30
 while time.monotonic()<deadline:
  if p.poll()is not None:raise AssertionError(('premature exit',p.returncode,(out/'replay-failure.json').read_text()if(out/'replay-failure.json').exists()else''))
  try:r=json.loads((out/'progress.json').read_text())
  except(FileNotFoundError,json.JSONDecodeError):time.sleep(.02);continue
  if predicate(r):return r
  time.sleep(.02)
 raise AssertionError('progress timeout')
src,r=source('published-source');out=base/'following-output';p,log=launch(src,out)
a=progress(out,p,lambda r:r['status'].startswith('caught-up')and r['frame']==4512);time.sleep(.2);b=progress(out,p,lambda r:r['caught_up_polls_without_ticks']>=a['caught_up_polls_without_ticks']+2);assert(a['frame'],a['rows'],a['consumed_bytes'])==(b['frame'],b['rows'],b['consumed_bytes']);cases.append('Caught-up wall-clock waiting advances no frames or input rows')
next_line=allrows[ends[0]];partial=next_line[:len(next_line)//2]
with(src/'controller.jsonl').open('ab')as f:f.write(partial)
a=progress(out,p,lambda r:r['caught_up_polls_without_ticks']>=b['caught_up_polls_without_ticks']+2);assert a['frame']==4512 and a['consumed_bytes']==len(chunks[0]);cases.append('Incomplete JSONL tail remains unconsumed without ticking')
# Publish a complete next checkpoint before the report is available.
(src/'report.json').write_text('')
with(src/'controller.jsonl').open('ab')as f:f.write(chunks[1][len(chunks[0])+len(partial):])
a=progress(out,p,lambda r:r['status']=='awaiting-stable-source-report');time.sleep(.2);b=progress(out,p,lambda r:r['caught_up_polls_without_ticks']>=a['caught_up_polls_without_ticks']+2);assert(a['frame'],a['rows'],a['consumed_bytes'])==(b['frame'],b['rows'],b['consumed_bytes']);cases.append('Partial source report waits without consuming/ticking new rows')
r['checkpoints']=original['checkpoints'][:4];r['latest']={k:v for k,v in r['checkpoints'][-1].items()if k not in('name','rom_sha256')};tmp=src/'report.tmp';tmp.write_text(json.dumps(r));tmp.replace(src/'report.json')
with(src/'controller.jsonl').open('ab')as f:f.write(chunks[3][len(chunks[1]):])
assert p.wait(timeout=30)==0;log.close();result=json.loads((out/'prefix-replay-report.json').read_text());assert result['passed']and not result['campaign_complete']and len(result['checkpoints'])==4 and result['frames']==11674;assert(out/'recorded-controller.jsonl').read_bytes()==chunks[3];cases.append('Four exact committed checkpoints and11674frames match fixed-prefix expectations after staggered publication')
# A partial tail is also an observed immutable prefix, even before consumption.
src,r=source('mutated-source');out=base/'mutation-output';p,log=launch(src,out);a=progress(out,p,lambda r:r['status'].startswith('caught-up'))
with(src/'controller.jsonl').open('ab')as f:f.write(b'{"frame":999999')
a=progress(out,p,lambda r:r['caught_up_polls_without_ticks']>=a['caught_up_polls_without_ticks']+2)
raw=(src/'controller.jsonl').read_bytes();(src/'controller.jsonl').write_bytes(raw[:-1]+b'8')
assert p.wait(timeout=10)!=0;log.close();failure=json.loads((out/'replay-failure.json').read_text());assert 'Previously observed controller bytes'in failure['error']and failure['frames']==4512;cases.append('Rewrite of an observed but unconsumed partial tail fails immediately with preserved failure and no retry')
report={'passed':True,'diagnostic_prefix_only':True,'campaign_complete':False,'source_rom_sha256':original['header']['sha256'],'tool_sha256':hashlib.sha256(tool.read_bytes()).hexdigest(),'cases':cases,'scope':'Publication mechanics use copies of a real committed controller prefix. No source campaign files or emulator memory were changed; no ending/final-marker success was fabricated.'};(base/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
