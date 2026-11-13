from pathlib import Path
import argparse,json,sys,shutil,tempfile,re
ROOT=Path.cwd();sys.path.insert(0,str(ROOT/'build/source-snapshots/verification-v5-tools/tools'))
from verify_story_ui import Session,patch_save,save_record,seal_save
from verify_rom import load_symbols,cartridge_header
p=argparse.ArgumentParser();p.add_argument('rom',type=Path);p.add_argument('--out',type=Path,required=True);p.add_argument('--expected-loads',type=int,default=1);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=True)
s=load_symbols(a.rom.with_suffix('.noi'));r={'header':cartridge_header(a.rom),'cases':[],'screenshots':[],'scope':'Explicit valid v5 vehicle fixtures; every menu and item action after Continue uses controller input. Read-only hooks count complete loads/fades and observe source phase/music/context. Negative geometry is a declared edge fixture, not campaign positioning.'}
local={m[1]:int(m[2],16)for m in re.finditer(r'^\s*2 _([A-Za-z0-9_]+)\s+([0-9A-Fa-f]+) R?G?R?$',(a.rom.parent/'obj/main.sym').read_text(),re.M)}
bases={s[n]-v for n,v in local.items()if n in s};assert len(bases)==1
data_base=bases.pop();s.update({n:data_base+v for n,v in local.items()if n not in s})
base=save_record((ROOT/'build/campaign/milestones/pre-final-governor/campaign.gbc.ram').read_bytes())
def fixture(map_id,x,y,vehicle):
 record=bytearray(patch_save(base,map_id=map_id,x=x,y=y,party=1,items=(33,)));record[104:618]=bytes(514);record[362]=record[366]=255
 record=record[:-2]+bytearray((1,2,0,0));record[3]=5;record[623]=vehicle;seal_save(record);return record
class Probe(Session):
 def boot(self):
  self.texts=[];super().boot()
 def tick(self,n=1):
  for _ in range(n):
   super().tick()
   if self.state()==4:
    text=self.word('dialogue')
    if not self.texts or self.texts[-1]!=text:self.texts.append(text)
with tempfile.TemporaryDirectory()as tmp:
 for group,record,actions in [
  ('success',fixture(0,1368,736,0),[('board',4,[0xb2ac,0xb305]),('dismount',0,[0xb30a])]),
  ('town-denied',fixture(4,1688,304,0),[('town-denied',0,[0xb2ac,0xb2e3])]),
  ('blocked-dismount',fixture(0,8,16,4),[('blocked-dismount',4,[0xb2fb])])]:
  folder=Path(tmp)/group;folder.mkdir();rom=folder/'game.gbc';shutil.copyfile(a.rom,rom);q=Probe(rom,s,a.out,r);q.install(record);trace=[]
  def point(name):
   return {'name':name,'tick':q.tick_count,'frame':q.word('frame_counter'),'audio':q.word('audio_frames'),'phase':q.byte('game_fade_clock'),'music':q.byte('game_map_music'),'vehicle':q.byte('game_vehicle'),'state':q.state(),'event':q.e.memory[s['game_events']+260],'event_type':q.e.memory[s['game_events']+261],'cycle':list(q.e.memory[s['vehicle_cycle']:s['vehicle_cycle']+2])}
  def hook(name):
   def mark(_):
    v=point(name)
    if name in('audio_command','game_transition_map_music'):v['command']=q.e.memory[q.e.register_file.SP+6]
    trace.append(v)
   return mark
  for name in('game_field_item','reload_world_mode','resume_walk','game_transition_fade_out','game_transition_fade_in','game_transition_vint16','game_transition_map_music','audio_command','world_load_graphics','party_world_reset','vehicle_palette_reset'):
   addr=s[name];q.e.hook_register(addr>>16,addr&65535,hook(name),None)
  for name,vehicle,texts in actions:
   q.press('start');q.wait(lambda:q.state()==2,'fieldmenu');q.complete_dispatch()
   q.press('down');q.press('down');q.press('a');assert q.state()==9
   old=point('before-use');position=[q.word('player_x'),q.word('player_y')];trace.clear();q.texts=[];start=q.tick_count;q.press('a')
   if q.state()==10:q.press('a')
   expected_state=1 if group=='success'else 2
   q.drain(lambda:q.state()==expected_state,'vehicle result');q.complete_dispatch();trace.append(point('dispatch-return'))
   assert q.byte('game_vehicle')==vehicle and q.items()==[33]
   # dialogue_open clears its cursor before installing the next nonzero
   # bank12 ID, while screen_state still identifies the preceding dialogue.
   assert [t for t in q.texts if t]==texts,(name,q.texts,texts)
   assert list(q.e.memory[s['vehicle_cycle']:s['vehicle_cycle']+2])==[1,2]
   assert [q.word('player_x'),q.word('player_y')]==position
   loads=[v for v in trace if v['name']=='reload_world_mode'];phase=[v for v in trace if v['name']=='game_transition_vint16']
   assert len(loads)==(a.expected_loads if group=='success'else 0)
   if group=='success':
    assert len(phase)==76*a.expected_loads
    assert q.byte('game_fade_clock')==3 and q.byte('game_map_music')==(0x8f if vehicle else 0x82)
    assert q.e.memory[s['game_events']+260:s['game_events']+262]==[0,0]
    assert q.byte('scene_context_type')==0
   else:assert q.e.memory[s['game_events']+260:s['game_events']+262]==[old['event'],old['event_type']]
   r['cases'].append({'case':name,'frames':q.tick_count-start,'loads':len(loads),'phase_calls':len(phase),'phase_trace':[v['phase']for v in phase],'points':[v for v in trace if v['name']!='game_transition_vint16'],'ending_phase':q.byte('game_fade_clock'),'ending_music':q.byte('game_map_music'),'position':position,'inventory':q.items(),'dialogue':q.texts,'cycle_preserved':[1,2],'source_return_context_preserved':True})
  q.close()
r['passed']=True;(a.out/'report.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({'passed':True,'rom':r['header']['sha256'],'cases':[{k:v for k,v in c.items()if k not in('points','phase_trace')}for c in r['cases']]}))
