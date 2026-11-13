#!/usr/bin/env python3
"""Governor event55 from earned SRAM: visible fall, audio, arrival and save.

Uses the preserved controller campaign's post-Lassic save, never its emulator
state. The two downstream pit checks use explicitly patched save positions.
"""
import argparse,hashlib,json,pickle,re,shutil,struct,tempfile
from pathlib import Path
import numpy as np
from pyboy import PyBoy
from verify_story_ui import read_save_record,save_record,seal_save,save_record_size,Session,crc16
from verify_rom import load_symbols,cartridge_header,finish_continue_menu,capture
from extract_dungeon_graphics import ROOT,source_composite,indices_image

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);p.add_argument('--output',type=Path,default=ROOT/'build/verification/governor-integration');a=p.parse_args();out=a.output;out.mkdir(parents=True,exist_ok=True)
 s=load_symbols(a.rom.with_suffix('.noi'));saved=ROOT/'build/campaign/milestones/pre-final-governor/campaign.gbc.ram';save=saved.read_bytes();assert hashlib.sha256(save).hexdigest()=='cc347885fac722c6c129a210e60d6ba8173559e98bd3e33285c80f3a3330636d'
 data=pickle.load(open(ROOT/'build/verification/dungeon-motion/source-data.pkl','rb'));ids={v:i for i,v in enumerate(data['indexed'])};source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();layouts=(ROOT/'assets/dungeons/dungeon_layouts.bin').read_bytes();offsets=(ROOT/'assets/dungeons/dungeon_view_offsets.bin').read_bytes();info=(ROOT/'assets/dungeons/dungeon_floor_info.bin').read_bytes()
 report={'header':cartridge_header(a.rom),'earned_save_sha256':hashlib.sha256(save).hexdigest(),'checks':[],'screenshots':[],'fixtures':[],'campaign_complete':False}
 def dungeon_picture(floor,pos,direction):
  layout=[v for byte in layouts[floor*128:(floor+1)*128]for v in(byte>>4,byte&15)];samples=[layout[(pos+offsets[direction*16+n])&255]for n in range(16)];_,g,m=source_composite(source,0,samples);image=ids[indices_image(g,m)];pal=info[floor*4+2]+1
  colors=np.frombuffer((ROOT/f'assets/dungeon-graphics/dungeon_colors_{pal:02}.bin').read_bytes()[312:368],dtype='<u2');result=np.zeros((120,160,4),dtype=np.uint8);result[:,:,3]=255
  for n,raw in enumerate(data['tilemaps'][image]):
   pattern,attr,_=data['variants'][pal][raw];b=data['patterns'][pattern]
   for y in range(8):
    for x in range(8):
     code=((b[y*2]>>(7-x))&1)|(((b[y*2+1]>>(7-x))&1)<<1);color=int(colors[attr*4+code]);result[n//20*8+y,n%20*8+x,:3]=[(color>>shift&31)*8 for shift in(0,5,10)]
  return result
 def room_picture():
  words=struct.unpack('<300H',(ROOT/'assets/scenes/29-00-00.map').read_bytes());patterns=(ROOT/'assets/scenes/patterns.2bpp').read_bytes();colors=np.frombuffer((ROOT/'assets/scenes/29-00-00.pal').read_bytes(),dtype='<u2');result=np.zeros((120,160,4),dtype=np.uint8);result[:,:,3]=255
  for n,word in enumerate(words):
   b=patterns[(word&8191)*16:(word&8191)*16+16]
   for y in range(8):
    for x in range(8):
     code=((b[y*2]>>(7-x))&1)|(((b[y*2+1]>>(7-x))&1)<<1);color=int(colors[(word>>13)*4+code]);result[n//20*8+y,n%20*8+x,:3]=[(color>>shift&31)*8 for shift in(0,5,10)]
  return result
 def shifted(pic,amount):
  result=np.zeros_like(pic);result[:,:,3]=255
  if amount>=0:result[:120-amount]=pic[amount:120]
  else:result[-amount:120]=pic[:120+amount]
  return result
 def key(pic):return hashlib.sha256(pic[:120].tobytes()).hexdigest()
 def compact(items):return[v for i,v in enumerate(items)if not i or v!=items[i-1]]
 class Probe(Session):
  def boot(self):
   self.recording=False;self.frames=[];self.commands=[];self.done=False;self.guard=False;self.debug=[]
   self.e=PyBoy(str(self.rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');self.e.set_emulation_speed(0);self.tick(300);self.title_image=self.e.screen.ndarray.copy()
  def tick(self,n=1):
   for _ in range(n):
    self.e.tick();self.tick_count+=1
    if self.guard:assert bytes(self.e.memory[0xdbc0:0xdc00])==bytes([0xa5])*64 and not self.byte('audio_fault') and not self.byte('dungeon_motion_fault')
    if self.recording:
     assert self.e.memory[0xff40]&128,'LCD disabled during original fall'
     self.frames.append(self.e.screen.ndarray[:120].copy())
     self.debug.append({'PC':hex(self.e.register_file.PC),'LCDC':self.e.memory[0xff40],'LY':self.e.memory[0xff44],'SCY':self.e.memory[0xff42],'WY':self.e.memory[0xff4a],'tiles':[list(self.e.memory[b,addr:addr+16])for b,addr in((0,0x8f20),(0,0x8f30),(1,0x97f0))],'window_first':[self.e.memory[b,0x9800]for b in(0,1)]})
     if self.state()==17 and self.word('frame_counter')!=self.counter:self.recording=False;self.done=True;self.audio_end=self.word('audio_frames')
  def press(self,name,settle=40):
   self.e.button_release(name);self.tick(2);self.e.button_press(name);self.tick(2);self.e.button_release(name);self.tick(settle)
  def begin(self,label):
   self.guard=True;self.e.memory[0xdbc0:0xdc00]=[0xa5]*64
   def start(_):self.recording=True;self.counter=self.word('frame_counter');self.audio_start=self.word('audio_frames')
   address=s[label];self.e.hook_register(address>>16,address&65535,start,None)
   address=s['audio_command'];self.e.hook_register(address>>16,address&65535,lambda _:self.commands.append(self.e.memory[self.e.register_file.SP+6])if self.recording else None,None)
  def verify(self,name,old,new,sounds):
   self.wait(lambda:self.done,name+' completed',5000);self.tick(2)
   expected=[old]+[shifted(old,i*10)for i in range(1,13)]+[shifted(new,-120)]+[shifted(new,-(120-i*10))for i in range(12)]+[shifted(new,-5 if i&1 else 0)for i in range(5)]
   wanted=compact([key(v)for v in expected]);actual=compact([key(v)for v in self.frames]);skip=0
   while actual and actual[0]!=wanted[0] and skip<2:actual.pop(0);skip+=1
   if actual!=wanted:
    from PIL import Image
    for i,frame in enumerate(self.frames):
     if key(frame)not in wanted:Image.fromarray(frame).save(out/f'{name}-unexpected-{i}.png')
    (out/(name+'-trace.json')).write_text(json.dumps({'wanted':wanted,'actual':actual,'frames':[key(f)for f in self.frames],'debug':self.debug},indent=2));raise AssertionError((name,'PPU order',len(actual),len(wanted)))
   assert self.commands==sounds,(name,'sound',self.commands,sounds)
   ticks=(self.audio_end-self.audio_start)&65535;assert abs(ticks-len(self.frames))<=2,(name,'audio cadence',ticks,len(self.frames))
   assert self.byte('dungeon_motion_buffer')==0 and not self.e.memory[0xff40]&8
   assert self.e.memory[0xff40]&64,'Fall failed to restore9C00 window map'
   assert key(self.e.screen.ndarray)==key(new)
   report['checks'].append({'name':name,'physical_frames':len(self.frames),'source_visible_changes':len(wanted)-1,'unmatched_frames':0,'audio_ticks':ticks,'commands':sounds,'guard_bytes':64,'standing_pattern_buffer':0});report['screenshots'].append(capture(self.e,out/(name+'-arrival.png')))
  def ui_regression(self,name,expected):
   self.wait(lambda:not self.byte('dungeon_keys_delay'),'post-fall menu delay');maps=[bytes(self.e.memory[b,0x9800:0x9c00])for b in(0,1)];self.press('start');assert self.state()==2
   assert self.e.memory[0xff40]&64 and maps==[bytes(self.e.memory[b,0x9800:0x9c00])for b in(0,1)],'Menu overwrote dungeon BG map'
   for _ in range(3):self.press('down')
   assert self.byte('menu_choice')==3;self.press('a');self.wait(lambda:self.state()==4,'Search dialogue');self.wait(lambda:not self.revealing(),'Search text')
   assert self.e.memory[0xff40]&64 and maps==[bytes(self.e.memory[b,0x9800:0x9c00])for b in(0,1)],'Dialogue overwrote dungeon BG map'
   height=min(120,self.e.memory[0xff4a]);assert np.array_equal(self.e.screen.ndarray[:height],expected[:height]),'Dialogue damaged exposed dungeon picture'
   report['screenshots'].append(capture(self.e,out/(name+'-dialogue.png')));self.drain(lambda:self.state()==17,'Search closes');self.tick(3);assert key(self.e.screen.ndarray)==key(expected)
   report['checks'].append({'name':name+'-same-session-menu-dialogue','BG_map_9800_preserved_both_banks':True,'window_map_9C00':True,'standing_picture_restored':True,'exposed_dialogue_pixel_checks':height*160})
  def title_regression(self,name):
   if self.state()==8:self.press('a');self.wait(lambda:self.state()==17,'Save notice closes')
   self.wait(lambda:not self.byte('dungeon_keys_delay'),'title menu delay');self.press('start');assert self.state()==2
   for _ in range(5):self.press('down')
   assert self.byte('menu_choice')==5;self.press('a');self.wait(lambda:self.state()==0,'Title after fall');self.tick(60)
   assert self.e.memory[0xff40]&64 and not self.e.memory[0xff40]&8
   assert np.array_equal(self.e.screen.ndarray,self.title_image),'Title after fall differs from intact boot title'
   report['screenshots'].append(capture(self.e,out/(name+'-title.png')));report['checks'].append({'name':name+'-same-session-title','boot_title_pixel_checks':160*144,'window_map_9C00':True,'BG_map_9800':True,'power_cycle_before_check':False})
 with tempfile.TemporaryDirectory(prefix='ps-governor-')as tmp:
  tmp=Path(tmp)
  def session(name,ram):
   folder=tmp/name;folder.mkdir();rom=folder/'game.gbc';shutil.copyfile(a.rom,rom);rom.with_suffix('.gbc.ram').write_bytes(ram);return Probe(rom,s,out,report)
  q=session('earned',save);q.press('start');finish_continue_menu(q.e,s);q.tick(80);assert q.state()==1 and q.byte('world_map_id')==14
  assert(q.word('player_x'),q.word('player_y'))==(520,320)
  q.e.button_press('up');q.wait(lambda:q.state()==4,'walk to Governor');q.e.button_release('up')
  q.wait(lambda:q.state()==4 and not q.revealing(),'governor reply')
  assert q.e.memory[s['game_events']+260]==55
  before=bytes(q.e.memory[s['game_rpg']:s['game_rpg']+94]);q.begin('dungeon_present_scene_fall');close=[]
  address=s['apply_event'];q.e.hook_register(address>>16,address&65535,lambda _:close.append(q.word('audio_frames'))if q.e.memory[s['game_events']+282]==22 else None,None)
  address=s['dplay_scene_fall'];q.e.hook_register(address>>16,address&65535,lambda _:close.append(q.word('audio_frames')),None)
  q.drain(lambda:q.done,'Governor fall');assert len(close)==2 and(close[1]-close[0])&65535==6,('Governor text close',close)
  q.verify('governor-room-fall',room_picture(),dungeon_picture(33,0xe6,0),[0xc0,0x85]);report['checks'][-1]['dialogue_close_audio_ticks']=6;assert list(q.e.memory[s['game_dungeon']:s['game_dungeon']+4])==[33,0xe6,0,6];q.ui_regression('governor-room-fall',dungeon_picture(33,0xe6,0))
  assert bytes(q.e.memory[s['game_rpg']:s['game_rpg']+94])==before,'Governor fall changed party/inventory/RNG'
  q.wait(lambda:not q.byte('dungeon_keys_delay'),'save input delay');q.press('select');q.wait(lambda:q.state()==8,'save after fall');q.e.memory[0]=10;arrival=read_save_record(q.e);q.e.memory[0]=0;assert list(arrival[618:624])==[1,33,0xe6,0,6,0]
  q.title_regression('governor-room-fall');q.e.stop(save=True);q.boot();q.press('start');finish_continue_menu(q.e,s);q.wait(lambda:q.state()==17,'continued final maze');q.tick(30);assert list(q.e.memory[s['game_dungeon']:s['game_dungeon']+4])==[33,0xe6,0,6];assert bytes(q.e.memory[s['game_rpg']:s['game_rpg']+94])==before;q.close();report['checks'].append({'name':'earned-governor-save-power-cycle','arrival':[33,230,0,6],'party_inventory_rng_preserved':True})
  for floor,pos in((33,0x1a),(32,0x79)):
   ram=bytearray(save);record=bytearray(arrival);record[618:624]=bytes((1,floor,pos,0,6,0));seal_save(record);ram[:len(record)]=record
   name=f'pit-{floor}-{pos:02x}';q=session(name,ram);q.begin('dungeon_present_fall');q.press('start');finish_continue_menu(q.e,s);q.wait(lambda:q.done,name+' fall');q.verify(name,dungeon_picture(floor,pos,0),dungeon_picture(floor-1,pos,0),[0xc0]);assert list(q.e.memory[s['game_dungeon']:s['game_dungeon']+3])==[floor-1,pos,0];q.ui_regression(name,dungeon_picture(floor-1,pos,0));q.title_regression(name);q.close();report['fixtures'].append({'name':name,'change':'Only saved dungeon floor/position/direction/light and CRC; saved earned party/items/flags unchanged.','initial':[floor,pos,0]})
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'sha256':report['header']['sha256'],'checks':report['checks']}))
if __name__=='__main__':main()
