#!/usr/bin/env python3
"""Native explicit-fixture event continuations through production apply_event.

Only main's infinite control loop is replaced; real handlers, dialogue opening,
RPG changes, fades, native palettes and sound-command dispatch execute.
"""
import sys,json,hashlib,shutil,tempfile,re,argparse
from pathlib import Path
ROOT=next(p for p in Path(__file__).resolve().parents if(p/'upstream/ps1disasm/ps1original.sms').exists());sys.path.insert(0,str(ROOT/'tools'))
from pyboy import PyBoy
from verify_rom import load_symbols
from verify_final_presentation import faded
import numpy as np
from PIL import Image
parser=argparse.ArgumentParser();parser.add_argument('--probe',type=Path,required=True);parser.add_argument('--output',type=Path,required=True);args=parser.parse_args();ROM=args.probe;OUT=args.output
def main():
 OUT.mkdir(parents=True,exist_ok=True)
 title=np.array(Image.open(ROOT/'assets/opening/title-gbc.png').convert('RGBA'))[:80];v=title[:,:,:3]//85;title[:,:,:3]=(v*10+(v>=2))*8
 title_poses=[hashlib.sha256(faded(title,n).tobytes()).hexdigest()for n in range(10)];white=hashlib.sha256(np.full(title.shape,255,dtype=np.uint8).tobytes()).hexdigest();title_proofs=[]
 symbols=load_symbols(ROM.with_suffix('.noi'));records=[];sounds=[];rest=[];pictures=[];phase_calls=[];resets=[];motor={'pending':False,'queued':0}
 with tempfile.TemporaryDirectory()as tmp:
  rom=Path(tmp)/'test.gbc';shutil.copyfile(ROM,rom);e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0)
  def byte(name):return e.memory[symbols[name]]
  def word(name):p=symbols[name];return e.memory[p]|e.memory[p+1]<<8
  def snapshot():return {'audio':word('audio_frames'),'party':[list(e.memory[symbols['game_rpg']+i*16:symbols['game_rpg']+i*16+3])for i in range(4)],'clock':byte('game_fade_clock'),'map_music':byte('game_map_music'),'state':byte('screen_state')}
  def tick():e.tick();assert not byte('audio_fault')
  for _ in range(1000):
   tick()
   if byte('probe_ready')==255:break
  else:raise AssertionError('probe boot')
  e.memory[0xdbc0:0xdc00]=[0xa5]*64
  def command(_):
   r=snapshot();r['command']=e.memory[e.register_file.SP+6]
   if r['command']==0xa0 or (r['command']==0xc1 and sounds and sounds[-1]['command']==0xa0):
    old=e.memory[0xff68];palette=[]
    for i in range(64):e.memory[0xff68]=i;palette.append(e.memory[0xff69])
    e.memory[0xff68]=old;r['black_background_and_UI']=not any(palette);assert not any(palette),palette
   sounds.append(r)
  def heal(_):rest.append(snapshot())
  def queued(_):motor['pending']=True;motor['queued']+=1
  def ticked(_):motor['pending']=False
  def reset(_):
   assert not motor['pending'],'Unconsumed world motor at title reset'
   resets.append({'clock':byte('game_fade_clock'),'mailbox':e.memory[symbols['audio_ram']+4],'motor_queue_drained':True})
  for name,fun in(('audio_command' ,command),('rpg_rest',heal),('game_transition_vint16',lambda _:phase_calls.append(byte('game_fade_clock'))),('audio_stop',reset),('audio_command_before_tick',queued),('audio_tick',ticked)):
   a=symbols[name];e.hook_register(a>>16,a&65535,fun,None)
  def request(n):
   start=len(sounds);phase_start=len(phase_calls);title_frames=[];old=snapshot();e.memory[symbols['probe_request']]=n
   for t in range(20000):
    tick();assert bytes(e.memory[0xdbc0:0xdc00])==bytes([0xa5])*64
    if n==10 and sounds[start:] and sounds[-1]['command']==0x81 and e.memory[0xff40]&128:title_frames.append(hashlib.sha256(e.screen.ndarray[:80].tobytes()).hexdigest())
    if n==5 and t%4==0:pictures.append((t,hashlib.sha256(e.screen.ndarray[:104].tobytes()).hexdigest()))
    if byte('probe_ready')==n and byte('probe_request')==0:break
   else:raise AssertionError(('request timeout',n,byte('screen_state')))
   r={'request':n,'frames':t+1,'before':old,'after':snapshot(),'sounds':sounds[start:],'vint16_calls':phase_calls[phase_start:]};records.append(r)
   if n==10:
    while title_frames and title_frames[0]==white:title_frames.pop(0)
    unique=[h for i,h in enumerate(title_frames)if not i or h!=title_frames[i-1]];wanted=[h for i,h in enumerate(title_poses)if not i or h!=title_poses[i-1]]
    assert unique==wanted,('title fade order or mixed pixels',unique,wanted);title_proofs.append({'source_palette_poses':len(unique),'mixed_frames':0,'pixel_checks':len(title_frames)*80*160})
   return r
  request(1);request(2);r=request(3);assert [x['command']for x in r['sounds']]==[0xc1];assert r['sounds'][0]['party'][0]==[1,1,2];assert r['after']['party'][0]==[1,100,30]and r['after']['party'][1]==[0,2,3]
  request(4);r=request(5);assert [x['command']for x in r['sounds']]==[0xa0,0xc1];assert r['sounds'][0]['party'][0]==[1,1,2]and r['sounds'][1]['party'][0]==[1,100,30];assert (r['sounds'][1]['audio']-r['sounds'][0]['audio'])&65535==208
  request(6);r=request(7);assert[x['command']for x in r['sounds']]==[0xae];assert r['sounds'][0]['party'][1][0]==1 and r['after']['party'][1][0]==1;r=request(8);assert r['after']['party'][1][:2]==[0,0]and not r['sounds']
  r=request(9);assert[x['command']for x in r['sounds']]==[0xb3];assert r['after']['map_music']==0x87 and r['after']['state']==1;assert e.memory[symbols['game_rpg']+64]==36 and e.memory[symbols['game_rpg']+88]==1
  for phase in range(4):
   e.memory[symbols['probe_clock']]=phase;request(4);r=request(5);assert len(r['vint16_calls'])==phase+33+40;assert r['vint16_calls'][0]==phase and r['after']['clock']==3
   r=request(10);assert len(r['vint16_calls'])==phase+33+40;assert[x['command']for x in r['sounds']]==[0x81];assert r['after']['clock']==3 and r['after']['map_music']==0;assert resets[-1]['mailbox']==0x80
  e.memory[symbols['probe_clock']]=2;r=request(11);assert len(r['vint16_calls'])==152 and r['after']['clock']==2
  # Exact native UI colors must survive the source fade/restore adaptation.
  e.memory[0xff68]=56;pal=[]
  for i in range(8):e.memory[0xff68]=56+i;pal.append(e.memory[0xff69])
  expected=[2|3<<5|8<<10,6|10<<5|19<<10,30|22<<5|8<<10,30|30<<5|27<<10];assert pal==list(b''.join(x.to_bytes(2,'little')for x in expected)),pal
  e.stop(save=False)
 report={'passed':True,'probe_sha256':hashlib.sha256(ROM.read_bytes()).hexdigest(),'requests':records,'audio_commands':sounds,'healing_entry_snapshots':rest,'driver_resets':resets,'motor_commands_queued_before_title':motor['queued'],'title_fade_proofs':title_proofs,'source_phase_calls':len(phase_calls),'guest_picture_samples':pictures,'guard_bytes':64,'native_ui_palette_restored':True,'limits':['Explicit RAM fixture requests replace only main control loop. Dialogue completion is supplied by test; production apply_event and handlers execute.','Not a complete campaign. Source-machine-code wait/state oracle is separate.']};(OUT/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'native_requests':len(records),'commands':[x['command']for x in sounds]}))
if __name__=='__main__':main()
