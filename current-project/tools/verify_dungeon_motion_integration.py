#!/usr/bin/env python3
"""Production doors/stairs/pitfall PPU order, real audio and1KiB stack guard.

Fixtures are explicit source-valid SRAM positions/items, not campaign progress.
All subsequent actions use controller input. Native expected images use the
independently verified source-index artwork and native palette conversion.
"""
import argparse,functools,hashlib,json,pickle,re,shutil,tempfile
from pathlib import Path
import numpy as np
from pyboy import PyBoy
from verify_story_ui import read_save_record,save_record,seal_save,save_record_size,Session,patch_save
from verify_rom import load_symbols,cartridge_header,finish_new_game_intro,read_word
from extract_dungeon_graphics import ROOT,source_composite,indices_image

def main():
 parser=argparse.ArgumentParser();parser.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/motion-integration/motion-integration.gbc');parser.add_argument('--output',type=Path);a=parser.parse_args()
 out=a.output or ROOT/'build/verification/dungeon-motion/integration';out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc'
 for suffix in('.gbc','.noi','.map'):shutil.copyfile(a.rom.with_suffix(suffix),frozen.with_suffix(suffix))
 a.rom=frozen;s=load_symbols(a.rom.with_suffix('.noi'))
 areas=re.findall(r'^(_DATA|_INITIALIZED|_BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+=',a.rom.with_suffix('.map').read_text(),re.M)
 assert areas and max(int(address,16)+int(size,16)for _,address,size in areas)<=0xdbc0,'Stack guard overlaps static WRAM'
 data=pickle.load(open(ROOT/'build/verification/dungeon-motion/source-data.pkl','rb'));ids={p:i for i,p in enumerate(data['indexed'])}
 source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();layouts=(ROOT/'assets/dungeons/dungeon_layouts.bin').read_bytes();offsets=(ROOT/'assets/dungeons/dungeon_view_offsets.bin').read_bytes();info=(ROOT/'assets/dungeons/dungeon_floor_info.bin').read_bytes()
 report={'header':cartridge_header(a.rom),'fixtures':[],'checks':[],'campaign_complete':False}
 def scene(floor,pos,dir,front=None):
  layout=[v for byte in layouts[floor*128:(floor+1)*128]for v in(byte>>4,byte&15)]
  samples=[layout[(pos+offsets[dir*16+n])&255]for n in range(16)]
  if front is not None:samples[1]=front
  _,g,m=source_composite(source,0,samples);return ids[indices_image(g,m)]
 @functools.lru_cache(None)
 def picture(image,palette):
  colors=np.frombuffer((ROOT/f'assets/dungeon-graphics/dungeon_colors_{palette:02}.bin').read_bytes()[312:368],dtype='<u2')
  result=np.zeros((144,160,4),dtype=np.uint8);result[:,:,3]=255
  for n,raw in enumerate(data['tilemaps'][image]):
   pattern,attr,_=data['variants'][palette][raw];b=data['patterns'][pattern]
   for y in range(8):
    for x in range(8):
     code=((b[y*2]>>(7-x))&1)|(((b[y*2+1]>>(7-x))&1)<<1);color=int(colors[attr*4+code])
     result[n//20*8+y,n%20*8+x,:3]=[(color>>shift&31)*8 for shift in(0,5,10)]
  return result
 def key(image):return hashlib.sha256(image[:120].tobytes()).hexdigest()
 def compact(values):return [v for i,v in enumerate(values)if not i or v!=values[i-1]]
 def shifted(image,amount):
  result=np.zeros_like(image);result[:,:,3]=255
  if amount>=0:result[:120-amount]=image[amount:120]
  else:result[-amount:120]=image[:120+amount]
  return result
 def faded(image,steps,inside):
  result=image.copy();levels=result[:120,:,:3].astype(np.int32)//80;color=levels[:,:,0]+levels[:,:,1]*4+levels[:,:,2]*16;value=np.zeros_like(color)if inside else color.copy()
  for _ in range(steps):
   if inside:
    value+=np.where(value==color,0,np.where(value+16<=color,16,np.where(value+4<=color,4,1)))
   else:value-=np.where(value&3,1,np.where(value&12,4,np.where(value&48,16,0)))
  for channel,shift in enumerate((0,2,4)):
   c=(value>>shift)&3;result[:120,:,channel]=(c*10+(c>=2))*8
  return result
 class Probe(Session):
  def boot(self):
   self.guard=False;self.recording=False;self.done=False;self.frames=[];self.commands=[];self.monitor=None
   self.e=PyBoy(str(self.rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');self.e.set_emulation_speed(0);self.tick(300)
  def tick(self,n=1):
   for _ in range(n):
    self.e.tick(1);self.tick_count+=1
    if self.guard:
     assert bytes(self.e.memory[0xdbc0:0xdc00])==bytes([0xa5])*64,'Production motion/audio stack guard changed'
     assert not self.byte('audio_fault') and not self.byte('dungeon_motion_fault')
    if self.recording:
     assert self.e.memory[0xff40]&128,'LCD restarted during source motion'
     self.frames.append(self.e.screen.ndarray.copy())
     if self.word('frame_counter')!=self.start_counter and self.state()==17:
      self.recording=False;self.done=True;self.audio_end=self.word('audio_frames')
    if self.monitor:self.monitor()
  def press(self,keyname,settle=40):
   self.e.button_release(keyname);self.tick(2);self.e.button_press(keyname);self.tick(2);self.e.button_release(keyname);self.tick(settle)
  def begin_capture(self,name):
   self.guard=True;self.e.memory[0xdbc0:0xdc00]=[0xa5]*64;self.done=False;self.frames=[];self.commands=[]
   def begin(_):
    self.recording=True;self.start_counter=self.word('frame_counter');self.audio_begin=self.word('audio_frames')
   address=s[name];self.e.hook_register(address>>16,address&65535,begin,None)
   address=s['audio_command']
   self.e.hook_register(address>>16,address&65535,lambda _:self.commands.append(self.e.memory[self.e.register_file.SP+6])if self.recording else None,None)
  def check_frames(self,name,expected,sound):
   self.wait(lambda:self.done,name+' completes',5000);self.tick(2)
   wanted=compact([key(p)for p in expected]);actual=[key(p)for p in self.frames]
   # The hook can begin after the PPU has latched the preceding menu frame.
   skipped=0
   while actual and actual[0]!=wanted[0] and skipped<2:actual.pop(0);skipped+=1
   observed=compact(actual)
   if observed!=wanted:
    allowed=set(wanted);bad=[i for i,k in enumerate(actual)if k not in allowed]
    for i in bad[:5]:
     from PIL import Image
     Image.fromarray(self.frames[i+skipped]).save(out/f'{name}-unexpected-{i}.png')
    raise AssertionError((name,'visible order',len(observed),len(wanted),'unexpected',bad[:15]))
   assert self.commands==sound,(name,self.commands,sound)
   assert self.byte('dungeon_motion_buffer')==0 and not(self.e.memory[0xff40]&8)
   assert self.e.memory[0xff40]&64,'Motion failed to restore9C00 UI window map'
   irq=(self.audio_end-self.audio_begin)&65535;assert abs(irq-len(self.frames))<=2,(name,irq,len(self.frames))
   report['checks'].append({'name':name,'source_visible_changes':len(wanted)-1,'physical_frames':len(self.frames),'audio_irq_ticks':irq,'unmatched_frames':0,'preceding_menu_frames':skipped,'commands':self.commands,'standing_pattern_buffer':0})
 with tempfile.TemporaryDirectory(prefix='ps-motion-production-')as tmp:
  tmp=Path(tmp)
  def session(name):
   folder=tmp/name;folder.mkdir();rom=folder/'game.gbc';shutil.copyfile(a.rom,rom);return Probe(rom,s,out,report)
  q=session('base');q.press('start');finish_new_game_intro(q.e,s);q.wait(lambda:q.state()==1,'newgame');q.press('select');q.wait(lambda:q.state()==8,'base save');q.e.memory[0x0000]=10;base=read_save_record(q.e);q.e.memory[0x0000]=0;q.close()
  for style,floor,pos,direction,item in((2,2,0x68,1,None),(3,1,0x27,2,45),(4,9,0xea,1,62)):
   name='door-'+str(style);q=session(name);q.install(patch_save(base,strong=True,items=()if item is None else(item,),dungeon=(floor,pos,direction)));q.wait(lambda:q.state()==17,name+' entry')
   palette=info[floor*4+2]+1;fronts=[style+2,130 if style<4 else 131,style+130]
   expected=[picture(scene(floor,pos,direction,v),palette)for v in fronts]
   q.begin_capture('dungeon_present_door')
   if item is None:q.press('a')
   else:q.use();q.drain(lambda:q.done,name+' dialogue/door')
   q.check_frames(name,expected,[0xbd]);q.close();report['fixtures'].append({'name':name,'dungeon':[floor,pos,direction],'items':[]if item is None else[item]})
  q=session('stairs');floor,pos,direction=19,0x52,1;q.install(patch_save(base,strong=True,dungeon=(floor,pos,direction)));q.wait(lambda:q.state()==17,'stair entry')
  old=picture(scene(19,0x52,1),info[19*4+2]+1);new=picture(scene(18,0x54,1),info[18*4+2]+1)
  expected=[old]+[faded(old,i,False)for i in range(1,10)]+[faded(new,i,True)for i in range(1,10)]
  q.begin_capture('dungeon_present_transition');q.press('up');q.check_frames('stairs',expected,[0xc3]);q.close();report['fixtures'].append({'name':'stairs','dungeon':[19,0x52,1]})
  q=session('fall');q.install(patch_save(base,strong=True,dungeon=(19,0x49,0)));q.wait(lambda:q.state()==17,'pitfall entry')
  old=picture(scene(19,0x39,0),info[19*4+2]+1);new=picture(scene(18,0x39,0),info[18*4+2]+1)
  expected=[old]+[shifted(old,i*10)for i in range(1,13)]+[shifted(new,-120)]+[shifted(new,-(120-i*10))for i in range(12)]+[shifted(new,-5 if i&1 else 0)for i in range(5)]
  q.begin_capture('dungeon_present_fall');q.press('up');q.check_frames('fall',expected,[0xc0]);q.close();report['fixtures'].append({'name':'fall','dungeon':[19,0x49,0],'controller':'forward into original floor19/39 pit, automatic fall to18/39'})
  for name,initial,standing,enemy,item,need_magic in(('large-enemy',(28,0x3e,0),(28,0x2e,0),60,None,False),('enemy-magic',(8,0x35,2),(8,0x55,2),13,45,True)):
   q=session(name);q.install(patch_save(base,strong=True,items=()if item is None else(item,),dungeon=initial));q.wait(lambda:q.state()==17,name+' entry')
   q.guard=True;q.e.memory[0xdbc0:0xdc00]=[0xa5]*64
   floor,pos,direction=standing;palette=info[floor*4+2]+1;image=scene(floor,pos,direction);entry_checks=[]
   def before_battle(_):
    assert key(q.e.screen.ndarray)==key(picture(image,palette)),(name,'Final standing pose was not visible before battle setup')
    entry_checks.append({'standing_PPU_before_battle_setup':True,'audio_frame':q.word('audio_frames')})
   address=s['battle_view_begin'];q.e.hook_register(address>>16,address&65535,before_battle,None)
   if item is not None:
    q.use();q.drain(lambda:q.state()==17,name+' key door');q.wait(lambda:not q.byte('dungeon_keys_delay'),name+' input delay')
   q.press('up');q.wait(lambda:q.state()==15 and q.byte('battle_view_state')==1,name+' command',10000)
   assert len(entry_checks)==1,(name,'Missing standing checkpoint')
   assert q.byte('battle_scene_enemy')==enemy and q.byte('battle_scene_type')==0
   # Every standing tile must live in primary BG bank0 before actors use
   # OBJ bank1 tile84 onward. Large actors deliberately cross tile127.
   addresses={};tilemap=[]
   for n,raw in enumerate(data['tilemaps'][image]):
    address=0x9800+n//20*32+n%20;tile=q.e.memory[0,address];attr=q.e.memory[1,address]
    pattern,pal=data['variants'][palette][raw][:2];assert attr==pal,(name,n,'primary background attribute',attr,pal)
    pattern_address=0x9000+tile*16 if tile<128 else 0x8800+(tile-128)*16
    actual=bytes(q.e.memory[0,pattern_address:pattern_address+16]);assert actual==data['patterns'][pattern],(name,n,'source standing pattern')
    addresses[pattern_address]=actual;tilemap.append((address,tile,attr))
   font=bytes(q.e.memory[1,0x9000:0x9400]);stats={'frames':0,'lcd_off_frames':0,'max_visible_OBJ_tile':0,'states':set(),'background_bytes_checked':0,'standing_entry':entry_checks}
   audio_start=q.word('audio_frames');frame_start=q.tick_count
   def monitor():
    if not(q.e.memory[0xff40]&128):stats['lcd_off_frames']+=1
    if q.state()!=15 or not q.byte('scene_actor_active') or q.byte('battle_view_state')==9:return
    # Existing battle result/chest setup briefly disables LCD. This probe
    # checks VRAM preservation there too; motion's own no-restart check above
    # remains stricter. Score IRQ cadence counts only LCD-active frames.
    assert not(q.e.memory[0xff40]&8),(name,'battle map',q.e.memory[0xff40],q.byte('battle_view_state'),hex(q.e.register_file.PC))
    assert q.byte('dungeon_motion_buffer')==0,(name,'actor uses secondary BG patterns')
    for address,want in addresses.items():assert bytes(q.e.memory[0,address:address+16])==want,(name,'actor overwrote background',hex(address))
    for address,tile,attr in tilemap:assert(q.e.memory[0,address],q.e.memory[1,address])==(tile,attr),(name,'actor changed background map')
    assert bytes(q.e.memory[1,0x9000:0x9400])==font,(name,'actor overwrote font')
    for i in range(40):
     address=0xfe00+i*4
     if q.e.memory[address] and q.e.memory[address+1]:stats['max_visible_OBJ_tile']=max(stats['max_visible_OBJ_tile'],q.e.memory[address+2])
    stats['frames']+=1;stats['states'].add(q.byte('battle_view_state'));stats['background_bytes_checked']+=len(addresses)*16+600+1024
   q.monitor=monitor
   # TALK consumes source turns without killing the fixed enemy, giving the
   # real enemy AI a chance to select both normal and offensive-magic poses.
   turns=0
   for turn in range(8 if need_magic else 1):
    assert q.state()==15 and q.byte('battle_view_state')==1
    while q.byte('battle_view_choice')!=3:q.press('down')
    q.press('a');turns+=1
    assert q.byte('battle_view_state')!=1,(name,'TALK input not accepted')
    for _ in range(20000):
     if q.state()!=15 or q.byte('battle_view_state')==1:break
     if q.byte('battle_view_state')==5 and not q.revealing():q.press('a',2)
     else:q.tick()
    assert q.state()==15 and q.byte('battle_view_state')==1,(name,'talk unexpectedly ended battle')
    if not need_magic or 16 in stats['states']:break
   assert (16 in stats['states'])if need_magic else(11 in stats['states']),(name,'required enemy animation',stats)
   if not need_magic:assert stats['max_visible_OBJ_tile']>=128,(name,'large actor did not exercise overlap',stats)
   for _ in range(20000):
    if q.state()!=15:break
    if q.byte('battle_view_state')==1:
     while q.byte('battle_view_choice'):q.press('down')
     q.press('a')
    elif not q.revealing() and q.byte('battle_view_state')in(5,6,12):q.press('a',2)
    else:q.tick()
   q.drain(lambda:q.state()==17,name+' returns to dungeon');q.wait(lambda:not q.byte('dungeon_keys_delay'),name+' resumed input');q.monitor=None
   irq=(q.word('audio_frames')-audio_start)&65535;physical=q.tick_count-frame_start;active=physical-stats['lcd_off_frames'];assert abs(irq-active)<=2,(name,irq,physical,active)
   assert q.byte('dungeon_motion_buffer')==0 and not(q.e.memory[0xff40]&8)
   direction_address=s['game_dungeon']+2;before=q.e.memory[direction_address];q.e.button_press('left')
   q.wait(lambda:q.e.memory[direction_address]!=before,name+' post-actor turn begins');q.e.button_release('left');counter=q.word('frame_counter')
   q.wait(lambda:q.word('frame_counter')!=counter,name+' post-actor turn completes')
   assert q.state()in(17,15) and q.byte('dungeon_motion_buffer')==0,(name,'Post-actor turn failed',q.state(),q.byte('dungeon_motion_buffer'))
   stats['post_actor_turn_state']=q.state()
   stats['states']=sorted(stats['states']);report['checks'].append({'name':name,'enemy':enemy,'talk_turns':turns,'physical_frames':physical,'LCD_active_frames':active,'audio_irq_ticks':irq,**stats});report['fixtures'].append({'name':name,'dungeon':initial,'items':[]if item is None else[item],'strong_party':True});q.close()
 report['passed']=True;report['guard']={'address':'0xDBC0','bytes':64,'stack_window':1024,'intact':True};(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
