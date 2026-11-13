from pathlib import Path
import argparse,json,sys,shutil,tempfile,hashlib
ROOT=Path.cwd();sys.path.insert(0,str(ROOT/'build/source-snapshots/verification-v5-tools/tools'))
from verify_story_ui import Session,patch_save,save_record,seal_save
from verify_rom import load_symbols,cartridge_header
p=argparse.ArgumentParser();p.add_argument('rom',type=Path);p.add_argument('--out',type=Path,required=True);a=p.parse_args();a.out.mkdir(parents=True,exist_ok=True)
s=load_symbols(a.rom.with_suffix('.noi'));r={'header':cartridge_header(a.rom),'cases':[],'screenshots':[],'scope':'Explicit valid v5 vehicle fixture; every menu and item action after Continue is controller input. Read-only function hooks count map loads/fades and observe source clock/music.'}
base=save_record((ROOT/'build/campaign/milestones/pre-final-governor/campaign.gbc.ram').read_bytes());record=bytearray(patch_save(base,map_id=0,x=1368,y=736,party=1,items=(33,)));record[104:618]=bytes(514);record[362]=record[366]=255
record=record[:-2]+bytearray((1,2,0,0));record[3]=5;seal_save(record)
with tempfile.TemporaryDirectory()as tmp:
 rom=Path(tmp)/'game.gbc';shutil.copyfile(a.rom,rom);q=Session(rom,s,a.out,r);q.install(record);trace=[]
 def hook(name):
  def mark(_):
   v={'name':name,'tick':q.tick_count,'frame':q.word('frame_counter'),'audio':q.word('audio_frames'),'phase':q.byte('game_fade_clock'),'music':q.byte('game_map_music'),'vehicle':q.byte('game_vehicle'),'state':q.state()}
   if name in('audio_command','game_transition_map_music'):v['command']=q.e.memory[q.e.register_file.SP+6]
   trace.append(v)
  return mark
 for name in('game_field_item','reload_world_mode','resume_walk','game_transition_fade_out','game_transition_fade_in','game_transition_vint16','game_transition_map_music','audio_command','world_load_graphics','party_world_reset','vehicle_palette_reset'):
  addr=s[name];q.e.hook_register(addr>>16,addr&65535,hook(name),None)
 for name in('board','dismount'):
  q.press('start');q.wait(lambda:q.state()==2,'fieldmenu');q.complete_dispatch()
  q.press('down');q.press('down');q.press('a');assert q.state()==9
  trace.clear();start=q.tick_count;q.press('a')
  if q.state()==10:q.press('a')
  q.drain(lambda:q.state()==1,'vehicle result');q.complete_dispatch()
  assert q.byte('game_vehicle')==(4 if name=='board'else 0)
  points=[v for v in trace if v['name']!='game_transition_vint16'];phase=[v for v in trace if v['name']=='game_transition_vint16']
  r['cases'].append({'case':name,'frames':q.tick_count-start,'loads':sum(v['name']=='reload_world_mode'for v in trace),'phase_calls':len(phase),'phase_trace':[v['phase']for v in phase],'points':points,'ending_phase':q.byte('game_fade_clock'),'ending_music':q.byte('game_map_music'),'position':[q.word('player_x'),q.word('player_y')],'inventory':q.items()})
 q.close()
(a.out/'report.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({'rom':r['header']['sha256'],'cases':[{k:v for k,v in c.items()if k not in('points','phase_trace')}for c in r['cases']]}))
