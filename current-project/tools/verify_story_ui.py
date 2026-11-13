#!/usr/bin/env python3
"""Integrated controller story scenes with explicit source-valid SRAM fixtures.

Only the opening/new-game portion starts without fixtures. Other scenarios
place the party beside original triggers with listed inventory/story prerequisites;
all prompts, item use, battles and presentation are then actual controller input.
This is not a start-to-ending campaign playthrough.
"""
from pathlib import Path
import argparse,json,shutil,tempfile,re,hashlib
from pyboy import PyBoy
from verify_rom import is_text_revealing,finish_continue_menu,button,capture,cartridge_header,load_symbols,read_word,wait_dispatch
from verify_world_logic import source_group,source_action
ROOT=Path(__file__).resolve().parents[1]

def crc16(data):
 crc=65535
 for byte in data:
  crc^=byte<<8
  for _ in range(8):crc=((crc<<1)^0x1021 if crc&32768 else crc<<1)&65535
 return crc

def save_record_size(data):
 assert len(data)>=4 and data[:3]==b'PSG' and data[3] in(4,5),('Unsupported save record',bytes(data[:4]))
 return {4:626,5:628}[data[3]]

def save_record(data):
 size=save_record_size(data);assert len(data)>=size,('Truncated save',len(data),size)
 return bytes(data[:size])

def seal_save(data):
 assert len(data)==save_record_size(data)
 data[-2:]=crc16(data[:-2]).to_bytes(2,'little');return data

def read_save_record(emulator,address=0xa000):
 """Read the versioned record while caller has enabled native SRAM."""
 size=save_record_size(bytes(emulator.memory[address:address+4]))
 return bytes(emulator.memory[address:address+size])


def patch_save(base,*,map_id=4,x=1688,y=304,party=1,items=(),dungeon=None,strong=False,flags=None):
 data=bytearray(base);assert len(data)==save_record_size(data)
 data[4:10]=bytes((map_id,0))+x.to_bytes(2,'little')+y.to_bytes(2,'little')
 for c in range(4):
  offset=10+c*16
  if party&(1<<c):
   data[offset:offset+16]=bytes([1,255 if strong else 32,60,0,0,30 if strong else 1,255 if strong else 32,60,255 if strong else 32,255 if strong else 32,2 if c==0 else 0,16 if c==0 else 0,0,0,5,5])
  else:data[offset:offset+16]=bytes(16)
 data[74:98]=bytes(items)+bytes(24-len(items));data[98]=len(items);data[99]=party
 data[100:102]=(10000).to_bytes(2,'little');data[102:104]=(0x1234).to_bytes(2,'little')
 if flags:
  for index,value in flags.items():data[104+index]=value
 data[618:624]=bytes((1,*dungeon,1,0))if dungeon else bytes(6)
 seal_save(data);return bytes(data)

class Session:
 def __init__(self,rom,symbols,out,report):
  self.rom=rom;self.s=symbols;self.out=out;self.report=report;self.e=None;self.tick_count=0
  self.boot()
 def boot(self):
  self.e=PyBoy(str(self.rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');self.e.set_emulation_speed(0);self.tick(300)
 def tick(self,n=1):self.e.tick(n);self.tick_count+=n
 def byte(self,name):return self.e.memory[self.s[name]]
 def word(self,name):return read_word(self.e,self.s[name])
 def state(self):return self.byte('screen_state')
 def revealing(self):return is_text_revealing(self.e,self.s)
 def press(self,key,settle=40):
  # Text intentionally freezes the source latch. A release during typing
  # may not have been sampled, so discrete menu actions begin released.
  self.e.button_release(key);self.tick(2);self.e.button_press(key);self.tick(2)
  self.e.button_release(key);self.complete_dispatch();self.tick(settle)
 def complete_dispatch(self,count=2,limit=10000):
  if 'frame_counter'not in self.s:self.tick(count);return
  previous=self.word('frame_counter');completed=0
  for _ in range(limit):
   self.tick();current=self.word('frame_counter')
   if current!=previous:
    previous=current;completed+=1
    if completed>=count:return
  raise AssertionError(('Dispatch did not return',self.state(),hex(self.e.register_file.PC)))
 def wait(self,predicate,reason,limit=10000):
  for _ in range(limit):
   if predicate():return
   self.tick()
  raise AssertionError((reason,self.state(),self.byte('game_movie_mode'),self.byte('game_movie_stage'),hex(self.e.register_file.PC)))
 def shot(self,name):self.tick(3);self.report['screenshots'].append(capture(self.e,self.out/(name+'.png')))
 def install(self,record):
  assert len(record)==save_record_size(record)and int.from_bytes(record[-2:],'little')==crc16(record[:-2])
  self.report.setdefault('save_records',[]).append({'version':record[3],'bytes':len(record),'sha256':hashlib.sha256(record).hexdigest()})
  self.e.memory[0x0000]=10;self.e.memory[0x4000]=0
  for n,value in enumerate(record):self.e.memory[0xa000+n]=value
  self.e.memory[0x0000]=0;self.e.stop(save=True);self.boot();assert self.byte('saved_position_valid')==1
  self.press('start');finish_continue_menu(self.e,self.s);self.complete_dispatch();self.tick(100)
 def drain(self,target,why,limit=20000,record_story=None):
  last=None
  for n in range(limit):
   if target():return
   state=self.state()
   if state==18 and record_story is not None:
    p=self.s['game_cutscene'];key=(self.e.memory[p],self.e.memory[p+4],read_word(self.e,p+5))
    if self.e.memory[p+3]==1 and key!=last:record_story.append(key);last=key
   if state in(4,18,24) and not self.revealing() and n%24==0:self.press('a',2)
   else:self.tick()
  raise AssertionError((why,self.state(),self.byte('game_movie_mode'),self.byte('game_movie_stage')))
 def items(self):
  p=self.s['game_rpg'];count=self.e.memory[p+88];return list(self.e.memory[p+64:p+64+count])if count else[]
 def use(self,slot=0):
  if self.state()in(1,17):self.press('start');self.wait(lambda:self.state()==2,'field menu fade');self.complete_dispatch()
  assert self.state()==2,('itemmenu',self.state())
  for _ in range(8):
   if self.byte('menu_choice')==2:break
   self.press('down')
  self.press('a');assert self.state()==9
  for _ in range(slot):self.press('down')
  self.press('a');assert self.state()==10;self.press('a')
 def close(self):self.e.stop(save=False)

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');p.add_argument('--output',type=Path);p.add_argument('--only',choices=('opening','myau','odin','noah','flight','ending'));p.add_argument('--ending-prelude',action='store_true',help='Stop before credits for explicitly labeled integration probes');p.add_argument('--ending-audio-guard',action='store_true',help='Check real score interrupts through credits and64unused bytes below the1KiB stack window');a=p.parse_args()
 out=a.output or ROOT/'build/verification/story-ui'/(a.only or'all');out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc';shutil.copyfile(a.rom,frozen);shutil.copyfile(a.rom.with_suffix('.noi'),frozen.with_suffix('.noi'));symbols=load_symbols(frozen.with_suffix('.noi'))
 # SDCC keeps static WRAM labels out ofNOI. Resolve their relocatable DATA
 # offsets only after validating the shared base against all public labels.
 candidates=[a.rom.parent/'obj/main.sym',a.rom.with_suffix('.main.sym'),ROOT/'build/obj/main.sym'];errors=[]
 for object_symbols in candidates:
  if not object_symbols.exists():continue
  local={m[1]:int(m[2],16)for m in re.finditer(r'^\s*2 _([A-Za-z0-9_]+)\s+([0-9A-Fa-f]+) R?G?R?$',object_symbols.read_text(),re.M)}
  bases={symbols[name]-offset for name,offset in local.items()if name in symbols}
  if len(bases)==1:break
  errors.append((str(object_symbols),sorted(bases)))
 else:raise AssertionError(('No object symbols match tested cartridge',errors))
 shutil.copyfile(object_symbols,out/'main-symbols.sym')
 data_base=bases.pop();symbols.update({name:data_base+offset for name,offset in local.items()if name not in symbols})
 report={'header':cartridge_header(frozen),'checks':[],'injected_fixtures':[],'screenshots':[],'campaign_complete':False};source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
 with tempfile.TemporaryDirectory(prefix='ps-story-ui-')as tmp:
  tmp=Path(tmp)
  def session(name):
   folder=tmp/name;folder.mkdir();rom=folder/'game.gbc';shutil.copyfile(frozen,rom);return Session(rom,symbols,out,report)
  q=session('opening');q.shot('title');q.press('start');q.wait(lambda:q.state()==23 and q.byte('game_movie_stage')==3,'pan start')
  initial=q.word('opening_position');ticks=q.tick_count;previous=initial;changes=0
  while q.state()==23 and q.byte('game_movie_stage')==3:
   q.tick();position=q.word('opening_position');assert position in(previous,previous+1),(previous,position)
   changes+=position!=previous;previous=position
  assert previous==352 and changes==352-initial
  pan_frames=q.tick_count-ticks;q.shot('opening-planet');q.wait(lambda:q.state()==18,'intro narrative',5000);stories=[];q.drain(lambda:q.state()==1,'intro complete',record_story=stories)
  assert [s[1]for s in stories]==[0,1,2],stories
  assert q.byte('world_map_id')==4 and(q.word('player_x'),q.word('player_y'))==(1688,304)
  q.shot('newgame-camineet');q.press('select');q.wait(lambda:q.state()==8,'base save');q.e.memory[0x0000]=10;base=read_save_record(q.e);q.e.memory[0x0000]=0;q.close()
  report['checks'].append({'opening':'Original title, full unskipped pan/city/three-record narrative, then source newgame','pan_source_changes':changes,'pan_emulator_frames':pan_frames,'story_records':stories})
  def wanted(name):return not a.only or a.only==name
  if wanted('myau'):
   q=session('myau');record=patch_save(base,map_id=14,x=27*16+8,y=29*16+16,items=(56,));q.install(record)
   report['injected_fixtures'].append('SRAM fixture:map14 beside original event54, Laconian Pot56, Alis only; no recruitment flag injected')
   q.press('up');q.drain(lambda:q.state()==5,'Myau firstprompt');q.press('right');q.press('a');q.drain(lambda:q.state()==5,'Myau exchange prompt');q.press('a');stories=[]
   q.drain(lambda:q.state()==1,'Myau recruitment',record_story=stories);assert q.byte('game_rpg')==1 and q.e.memory[symbols['game_rpg']+89]==3
   assert 43 in q.items()and 56 not in q.items();assert [s[1]for s in stories]==[3,4,3,4,3],stories;q.shot('myau-recruited');q.close();report['checks'].append({'myau':'Both original prompts, Pot exchange, Alsulin award and five original speaker records','story_records':stories})
  if wanted('odin'):
   q=session('odin');q.install(patch_save(base,party=3,items=(43,),dungeon=(0,0xe2,1)))
   report['injected_fixtures'].append('SRAM fixture:floor0/E2 facing original Odin objectE3, Myau joined, Alsulin43; C50A remains0')
   q.wait(lambda:q.state()==2,'Odin menu');q.use();q.drain(lambda:q.state()==20,'Odin revival starts');q.wait(lambda:q.state()==22,'Odin111-frame wait');assert q.word('presentation_frame')==111;q.shot('odin-revival')
   q.press('a');stories=[];q.drain(lambda:q.state()==17,'Odin narrative',record_story=stories);assert q.e.memory[symbols['game_rpg']+89]==7 and 43 not in q.items();assert q.e.memory[symbols['game_events']+10]==255
   assert [s[1]for s in stories]==[5,3,5,3,5],stories;q.close();report['checks'].append({'odin':'Actual Alsulin use,111-frame revival/button wait and five-record recruitment','story_records':stories})
  if wanted('noah'):
   q=session('noah');q.install(patch_save(base,party=7,items=(55,),dungeon=(29,0x68,2)))
   report['injected_fixtures'].append('SRAM fixture:floor29/68 facing Noah room78, first3party joined, Letter55; C506 remains0')
   q.wait(lambda:q.state()==17,'Noah doorway');q.press('a');q.press('up');q.wait(lambda:q.state()!=17,'Noah room entered');stories=[];q.drain(lambda:q.state()==17,'Noah recruitment',record_story=stories)
   assert q.e.memory[symbols['game_rpg']+89]==15 and 55 not in q.items();assert q.e.memory[symbols['game_events']+6]==1;assert [s[1]for s in stories]==[3,6],stories;q.close();report['checks'].append({'noah':'Opened original door, Letter recruitment and two-record narrative','story_records':stories})
  if wanted('flight'):
   q=session('flight');q.install(patch_save(base,map_id=0,party=15,items=(48,49),dungeon=(15,0x1c,1),strong=True))
   report['injected_fixtures'].append('SRAM fixture:floor15/1C beside original Baya Malay event176, Prism/Nuts, living4party with level30/HP255/attack255/defense255 for GoldDragon battle')
   q.wait(lambda:q.state()==17,'Baya Malay stair');q.press('up');q.wait(lambda:q.state()==2,'Prism menu');q.use(0);q.drain(lambda:q.state()==20,'Prism effect');q.wait(lambda:q.state()==2,'Prism completes');assert q.word('presentation_frame')==320;q.shot('revealed-castle')
   q.use(1);stories=[];q.drain(lambda:q.state()==15,'GoldDragon battle',record_story=stories);assert [s[1]for s in stories]==[7,8],stories
   assert q.word('myau_flight_frame')==507 and q.byte('scene_context_type')==14;q.shot('gold-dragon')
   for _ in range(10000):
    if q.state()!=15:break
    if q.revealing():q.tick()
    else:q.press('a',20)
   q.wait(lambda:q.state()==1 and q.byte('world_map_id')==23,'Flying castle arrival');assert(q.word('player_x'),q.word('player_y'))==(504,528);q.shot('flying-castle')
   q.use(q.items().index(49));q.drain(lambda:q.state()==23,'Return flight begins');q.wait(lambda:q.state()==1 and q.byte('world_map_id')==0,'Return to Palma',4000)
   assert q.word('myau_flight_frame')==571 and(q.word('player_x'),q.word('player_y'))==(1224,784);q.shot('myau-return-palma');q.close();report['checks'].append({'flight':'Actual Prism/Nuts menus, Laerma narrative,507-frame outbound/GoldDragon to castle and571-frame return to original Palma destination','story_records':stories})
  if wanted('ending'):
   q=session('ending');q.install(patch_save(base,party=15,items=(62,),dungeon=(31,0xde,0),strong=True,flags={22:1,23:255}))
   report['injected_fixtures'].append('SRAM fixture:floor31/DE facing original DarkFalz doorCE, MiracleKey,4strong party, prior Shadow/Lassic flags; no DarkFalz outcome or ending state injected')
   audio_window=[];audio_changes=[];guard=bytes((0xa6+i*13)&255 for i in range(64))
   if a.ending_audio_guard:
    ram_areas=re.findall(r'^(_DATA|_INITIALIZED|_BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+=',a.rom.with_suffix('.map').read_text(),re.M)
    assert ram_areas and max(int(address,16)+int(size,16) for _,address,size in ram_areas)<=0xdbc0,'Guard would overlap static WRAM'
    q.e.memory[0xdbc0:0xdc00]=guard
    report['injected_fixtures'].append('Diagnostic64-byte guard atDBC0..DBFF, below the1KiB DC00..DFFF stack window; no game state changed')
   q.wait(lambda:q.state()==17,'DarkFalz door');q.use();q.drain(lambda:q.state()==17,'MiracleKey opens');q.wait(lambda:not q.byte('dungeon_keys_delay'),'door input delay');q.press('up');q.drain(lambda:q.state()==15,'DarkFalz encounter');q.shot('dark-falz')
   for _ in range(10000):
    if q.state()!=15:break
    if q.revealing():q.tick()
    else:q.press('a',20)
   q.drain(lambda:q.state()==5,'Ending choice');q.press('a');stories=[];stages=[];closing_texts=[]
   for frame in range(60000):
    if q.state()==0:break
    if a.ending_prelude and q.state()==23 and q.byte('game_movie_stage')==52:break
    if q.state()==24:
     text=read_word(q.e,symbols['dialogue'])
     if text and(not closing_texts or closing_texts[-1]!=text):closing_texts.append(text)
    if q.state()==23:
     stage=q.byte('game_movie_stage')
     if not stages or stages[-1]!=stage:stages.append(stage)
     # stage52 remains set while title_screen performs its LCD-off upload.
     # Measure the active ending, excluding that documented scheduler pause.
     if a.ending_audio_guard and stage==52 and q.word('ending_walk_frame')<3499 and q.e.memory[0xff40]&128:
      point=(q.tick_count,q.word('audio_frames'))
      if not audio_window:audio_window=[point,point]
      else:audio_window[-1]=point
      difference=((point[1]-audio_window[0][1])&65535)-(point[0]-audio_window[0][0])
      if not audio_changes or audio_changes[-1]['difference']!=difference:
       audio_changes.append({'physical':point[0]-audio_window[0][0],'score':point[1],'difference':difference,'logical':q.word('ending_walk_frame'),'pc':hex(q.e.register_file.PC),'LY':q.e.memory[0xff44],'HDMA':q.e.memory[0xff55]})
      assert not q.byte('audio_fault'),('ending audio fault',q.byte('audio_fault'))
    if q.state()==18:
     p=symbols['game_cutscene'];key=(q.e.memory[p],q.e.memory[p+4],read_word(q.e,p+5))
     if q.e.memory[p+3]==1 and(not stories or stories[-1]!=key):stories.append(key)
    if q.state()in(4,18,24)and not q.revealing()and frame%24==0:q.press('a',2)
    else:q.tick()
   assert(q.state()==23 and q.byte('game_movie_stage')==52)if a.ending_prelude else q.state()==0,('Ending incomplete',q.state(),stages);assert closing_texts==[0xbeb6,0xbed0,0xbee8,0xbefd,0xbf09,0xbf21],closing_texts;assert[s[1]for s in stories]==[3,5,6,4,3,3],stories
   if a.ending_audio_guard:
    assert len(audio_window)==2 and not a.ending_prelude,audio_window
    physical=audio_window[1][0]-audio_window[0][0];score=(audio_window[1][1]-audio_window[0][1])&65535
    (out/'ending-audio-cadence.json').write_text(json.dumps({'header':report['header'],'physical':physical,'score':score,'changes':audio_changes},indent=2)+'\n')
    assert physical>3499 and abs(score-physical)<=2,(physical,score,audio_window)
    assert bytes(q.e.memory[0xdbc0:0xdc00])==guard,'Ending/battle crossed lower1KiB stack guard'
    report['checks'].append({'ending_real_audio_IRQ_frames':score,'ending_measured_native_frames':physical,'difference_allowed_for_ISR_sampling':2,'stack_guard':'DBC0..DBFF unchanged through DarkFalz, complete ending and return to title','audio_fault':q.byte('audio_fault')})
   q.shot('ending-prelude'if a.ending_prelude else'ending-title');q.close();report['checks'].append({'ending':'Actual MiracleKey/door, DarkFalz combat, ending choice, sky/text/story/bitmap','credits_verified':not a.ending_prelude,'stopped_before_credits':a.ending_prelude,'story_records':stories,'closing_texts':closing_texts,'stages':stages})
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
if __name__=='__main__':main()
