#!/usr/bin/env python3
"""Controller-driven original DarkFalz reveal and two Governor return routes.

Explicit CRC-valid SRAM fixtures provide location, prerequisites and party.
After Continue, all story, item and combat progress uses controller input.
Read-only hooks record order; the only RAM write is an unused stack guard.
"""
import argparse,hashlib,json,re,shutil,struct,tempfile
from pathlib import Path
import numpy as np
from PIL import Image
from pyboy import PyBoy
from verify_story_ui import read_save_record,save_record,seal_save,save_record_size,Session,patch_save,crc16,ROOT
from verify_rom import load_symbols,cartridge_header,capture

def scene(name):
 words=struct.unpack('<300H',(ROOT/f'assets/scenes/{name}.map').read_bytes());patterns=(ROOT/'assets/scenes/patterns.2bpp').read_bytes();colors=np.frombuffer((ROOT/f'assets/scenes/{name}.pal').read_bytes(),dtype='<u2');result=np.zeros((120,160,4),dtype=np.uint8);result[:,:,3]=255
 for n,word in enumerate(words):
  b=patterns[(word&8191)*16:(word&8191)*16+16]
  for y in range(8):
   for x in range(8):
    code=((b[y*2]>>(7-x))&1)|(((b[y*2+1]>>(7-x))&1)<<1);color=int(colors[(word>>13)*4+code]);result[n//20*8+y,n%20*8+x,:3]=[(color>>shift&31)*8 for shift in(0,5,10)]
 return result

def faded(pic,step):
 rgb=pic[:,:,:3].astype(np.uint16);sms=((rgb//8*3+15)//31);target=sms[:,:,0]+sms[:,:,1]*4+sms[:,:,2]*16;v=np.zeros_like(target)
 for _ in range(step):v=np.where(v==target,v,np.where(v+16<=target,v+16,np.where(v+4<=target,v+4,v+1)))
 result=pic.copy()
 for i,shift in enumerate((0,2,4)):
  c=(v>>shift)&3;result[:,:,i]=(c*10+(c>=2))*8
 return result

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);p.add_argument('--output',type=Path,default=ROOT/'build/verification/final-presentation');a=p.parse_args();out=a.output;out.mkdir(parents=True,exist_ok=True)
 s=load_symbols(a.rom.with_suffix('.noi'));obj=a.rom.parent/'obj/main.sym';local={m[1]:int(m[2],16)for m in re.finditer(r'^\s*2 _([A-Za-z0-9_]+)\s+([0-9A-Fa-f]+) R?G?R?$',obj.read_text(),re.M)};bases={s[n]-v for n,v in local.items()if n in s};assert len(bases)==1;baseaddr=bases.pop();s.update({n:baseaddr+v for n,v in local.items()if n not in s})
 base=bytearray(save_record((ROOT/'build/campaign/milestones/pre-final-governor/campaign.gbc.ram').read_bytes()));base[104:618]=bytes(514);seal_save(base)
 report={'header':cartridge_header(a.rom),'checks':[],'fixtures':[],'screenshots':[],'campaign_complete':False}
 dark=scene('31-00-73');palace=scene('29-00-00');actor=np.array(Image.open(ROOT/'assets/scene-actors/0-53-255-gbc.png').convert('RGBA'));channels=actor[:,:,:3]//85;actor[:,:,:3]=(channels*10+(channels>=2))*8;portrait=palace.copy();mask=actor[:,:,3]!=0;portrait[mask]=actor[mask]
 class Probe(Session):
  def boot(self):
   self.trace=[];self.hooks=[];self.commands=[];self.guard=False;self.pictures={};self.texts=[];self.active=False;self.done=False;self.start_rpg=None;self.before_heal=None
   self.e=PyBoy(str(self.rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');self.e.set_emulation_speed(0);self.tick(300)
  def tick(self,n=1):
   for _ in range(n):
    self.e.tick();self.tick_count+=1
    if self.guard:assert bytes(self.e.memory[0xdbc0:0xdc00])==bytes([0xa5])*64 and not self.byte('audio_fault')
    if not self.active:continue
    mode=self.byte('game_movie_mode');stage=self.byte('game_movie_stage');state=self.state()
    point={'tick':self.tick_count,'audio':self.word('audio_frames'),'mode':mode,'stage':stage,'state':state,'LCDC':self.e.memory[0xff40],'actor':self.byte('scene_actor_active')}
    if mode in(4,5):
     point['image']=hashlib.sha256(self.e.screen.ndarray[:120].tobytes()).hexdigest();self.trace.append(point)
     if stage in(64,68) and self.e.memory[0xff40]&128:self.pictures.setdefault(stage,[]).append(self.e.screen.ndarray[:120].copy())
    if state==4:
     text=self.word('dialogue')
     if not self.texts or self.texts[-1]!=text:self.texts.append(text)
  def press(self,key,settle=2):
   self.e.button_release(key);self.tick(2);self.e.button_press(key);self.tick(2);self.e.button_release(key);self.tick(settle)
  def mark(self,name):
   self.hooks.append({'name':name,'tick':self.tick_count,'audio':self.word('audio_frames'),'mode':self.byte('game_movie_mode'),'stage':self.byte('game_movie_stage'),'rpg':list(self.e.memory[s['game_rpg']:s['game_rpg']+94]),'flags':list(self.e.memory[s['game_events']:s['game_events']+256])})
   if name=='start_dark_falz_reveal':self.start_rpg=bytes(self.e.memory[s['game_rpg']:s['game_rpg']+94])
   if name=='battle_view_begin' and self.start_rpg is not None:assert bytes(self.e.memory[s['game_rpg']:s['game_rpg']+94])==self.start_rpg,'Prelude changed party/inventory/RNG'
  def begin(self):
   self.active=True;self.guard=True;self.e.memory[0xdbc0:0xdc00]=[0xa5]*64
   for name in('start_dark_falz_reveal','start_governor_room','scene_show','event_governor_room_loaded','scene_portrait_show','battle_view_begin'):
    addr=s[name];self.e.hook_register(addr>>16,addr&65535,lambda _,name=name:self.mark(name),None)
   addr=s['audio_command'];self.e.hook_register(addr>>16,addr&65535,lambda _:self.commands.append({'command':self.e.memory[self.e.register_file.SP+6],'tick':self.tick_count,'audio':self.word('audio_frames'),'mode':self.byte('game_movie_mode'),'stage':self.byte('game_movie_stage')}),None)
  def run(self,target,why,limit=25000):
   for n in range(limit):
    if target():return
    if self.state()in(4,18,24) and not self.revealing() and n%24==0:self.press('a')
    elif self.state()==15 and self.byte('battle_view_state')in(1,5) and not self.revealing() and n%24==0:self.press('a')
    else:self.tick()
   raise AssertionError((why,self.state(),self.byte('game_movie_stage'),self.texts))
  def governor_picture(self,name):
   self.tick(3);actual=self.e.screen.ndarray[:104].copy();expected=portrait[:104];assert np.array_equal(actual,expected),(name,'Governor portrait PPU',int(np.any(actual!=expected,axis=2).sum()));report['screenshots'].append(capture(self.e,out/(name+'-governor.png')))
  def finish(self,name):
   (out/(name+'-trace.json')).write_text(json.dumps({'hooks':self.hooks,'frames':self.trace,'commands':self.commands,'dialogue':self.texts},indent=2)+'\n')
   for stage,frames in self.pictures.items():
    expected=dark if stage==64 else portrait
    matches=[i for i,f in enumerate(frames)if np.array_equal(f,expected)]
    Image.fromarray(frames[-1]).save(out/f'{name}-stage{stage}.png')
    assert matches,(name,'PPU composition',stage,min(int(np.any(f!=expected,axis=2).sum())for f in frames))
   returns=[h for h in self.hooks if h['name']=='start_governor_room']
   if returns:
    expected=returns[-1]['rpg'].copy()
    if name=='nightmare':
     for n in range(4):
      if expected[n*16]:expected[n*16+1:n*16+3]=expected[n*16+6:n*16+8]
    assert expected==list(self.e.memory[s['game_rpg']:s['game_rpg']+94]),(name,'Governor return party/inventory/RNG')
    assert returns[-1]['flags']==list(self.e.memory[s['game_events']:s['game_events']+256]),(name,'Governor return story flags')
   reveal=sum(f['stage']==64 for f in self.trace)
   if name=='dark-alive-unskipped':assert reveal==30,('unskipped reveal duration',reveal)
   elif name.startswith('dark-'):assert 0<reveal<30,('fresh input skipped reveal',reveal)
   fades=[]
   for stage,expected in((62,dark),(67,palace)):
    allowed=[hashlib.sha256(faded(expected,n).tobytes()).hexdigest()for n in range(10)];observed=[f['image']for f in self.trace if f['stage']==stage and f['LCDC']&128];white=hashlib.sha256(np.full((120,160,4),255,dtype=np.uint8).tobytes()).hexdigest();restart=0
    # PyBoy exposes the LCD-off white buffer until the first complete scan.
    # Count this documented asset-upload boundary separately; it may only
    # border a fade, never interrupt the original palette pose sequence.
    while observed and observed[0]==white:observed.pop(0);restart+=1
    while observed and observed[-1]==white:observed.pop();restart+=1
    unique=[h for i,h in enumerate(observed)if not i or h!=observed[i-1]]
    wanted=[h for i,h in enumerate(allowed)if not i or h!=allowed[i-1]]
    if observed:assert unique==wanted,(name,'fade pixel order',stage,unique,wanted)
    fades.append({'stage':stage,'frames':len(observed),'source_palette_poses':len(unique),'mixed_frames':0,'lcd_restart_white_frames':restart})
   return {'case':name,'guard_bytes':64,'dialogue':self.texts,'movie_stages':list(dict.fromkeys(f['stage']for f in self.trace)),'source_scene_pixel_checks':sum(19200 for _ in self.pictures)+(16640 if any(h['name']=='scene_portrait_show'for h in self.hooks)else 0),'reveal_visible_frames':reveal,'party_inventory_rng_and_flags_preserved_except_source_nightmare_heal':True,'fades':fades,'commands':self.commands,'timing':[{k:v for k,v in h.items()if k not in('rpg','flags')}for h in self.hooks]}
 with tempfile.TemporaryDirectory(prefix='ps-final-presentation-')as temp:
  def session(name,record):
   folder=Path(temp)/name;folder.mkdir();rom=folder/'game.gbc';shutil.copyfile(a.rom,rom);q=Probe(rom,s,out,report);q.install(record);q.begin();return q
  for dead,skip in((False,None),(True,'a'),(False,'b')):
   name='dark-'+('dead'if dead else'alive')+'-'+(skip or'unskipped');record=bytearray(patch_save(base,party=15,items=(62,),dungeon=(31,0xde,0),strong=True,flags={22:1,23:255}))
   if dead:record[10:12]=bytes(2);seal_save(record)
   q=session(name,record);q.use();q.run(lambda:q.state()==17,'MiracleKey');q.wait(lambda:not q.byte('dungeon_keys_delay'),'door delay');q.press('up');q.wait(lambda:q.byte('game_movie_mode')==4,'DarkFalz prelude')
   if skip:
    q.e.button_press(skip);q.wait(lambda:q.byte('game_movie_stage')==64,'reveal wait');q.tick(3);assert q.byte('game_movie_stage')==64,'Held fade input incorrectly skipped reveal';q.e.button_release(skip);q.tick(2);q.press(skip)
   q.wait(lambda:q.state()==15,'battle starts');assert sum(c['command']==147 for c in q.commands)==1
   starts=[h for h in q.hooks if h['name']=='start_dark_falz_reveal'];scenes=[h for h in q.hooks if h['name']=='scene_show'];assert len(starts)==1 and scenes and(scenes[0]['audio']-starts[0]['audio'])&65535==208,('208-frame source hold',starts,scenes[:1])
   if skip=='b':report['checks'].append(q.finish(name));q.close();continue
   q.run(lambda:q.state()==5,'Governor ending choice');assert q.byte('scene_actor_active') and q.byte('scene_context_type')==29
   assert(0xbf64 in q.texts)==dead,(name,'Alis-dead branch',q.texts);q.governor_picture(name)
   # Both original answer routes are executed through the first ending movie.
   if dead:q.press('right')
   q.press('a');q.run(lambda:q.state()==23 and q.byte('game_movie_mode')==3,'ending starts');assert(0x230 if dead else 0x212)in q.texts
   report['checks'].append(q.finish(name));q.close();report['fixtures'].append({'name':name,'save':'floor31/DE/North, MiracleKey, Shadow/Lassic flags, four strong level30 characters','Alis_dead':dead,'skip_button':skip})
  name='nightmare';record=bytearray(patch_save(base,map_id=14,x=520,y=320,party=1));record[10:26]=bytes((1,16,0,0,0,1,16,0,8,8,0,0,0,0,0,0));seal_save(record);q=session(name,record);q.e.button_press('up');q.wait(lambda:q.state()==4,'Governor entry');q.e.button_release('up');q.run(lambda:q.state()==4 and q.word('dialogue')==0xaa,'nightmare return');q.wait(lambda:not q.revealing(),'Governor return text')
  before=[h for h in q.hooks if h['name']=='event_governor_room_loaded'];assert len(before)==1 and before[0]['rpg'][0:2]==[1,0],before
  assert list(q.e.memory[s['game_rpg']:s['game_rpg']+2])==[1,16] and q.byte('scene_actor_active');assert 55 in q.items();assert 0x2a2 in q.texts and 0xaa in q.texts;q.governor_picture(name)
  report['checks'].append(q.finish(name));q.close();report['fixtures'].append({'name':name,'save':'map14 below Governor, fresh level1 Alis with16HP, no Letter/Noah/Lassic flags','outcome':'Actual Saccubus defeat, source status restore then room-load healing'})
 report['limits']=['These are explicit-save integration cases, not a start-to-ending campaign.','Native LCD-off asset uploads pause score IRQs and expose the emulator white buffer until a complete scan; reports count these separately from source waits. Total scene wall-clock duration is not asserted identical to SMS.'];report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'sha256':report['header']['sha256'],'cases':len(report['checks']),'pixel_checks':sum(c['source_scene_pixel_checks']for c in report['checks'])}))
if __name__=='__main__':main()
