#!/usr/bin/env python3
"""Full immutable cartridge: source buttons, road followers and ship exclusion.

Targeted fixtures grant living party statuses and Road Pass/Passport only.
Locations, transitions, RNG, input timing and outcomes are never injected.
This is integration evidence, not an earned full-game campaign.
"""
from pathlib import Path
import argparse,hashlib,json,shutil,sys,tempfile
ROOT=Path(__file__).resolve().parents[4];WORK=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from pyboy import PyBoy
from verify_rom import finish_new_game_intro,load_symbols,read_word
from verify_integrated_battle import source_route,DIRS
from verify_world_logic import source_group,source_action
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--rom',type=Path,default=WORK/'build/phantasy-star-gbc-world.gbc');parser.add_argument('--output',type=Path,default=WORK/'evidence/integration');args=parser.parse_args()
 out=args.output;out.mkdir(parents=True,exist_ok=True)
 rom=args.rom;s=load_symbols(rom.with_suffix('.noi'));source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
 report=dict(rom_sha256=hashlib.sha256(rom.read_bytes()).hexdigest(),fixtures=['Living status bit for all four characters; Road Pass and Passport. No location, RNG, event, stats, outcome or emulator-state injection.'],checks=[],screenshots=[])
 with tempfile.TemporaryDirectory(prefix='ps-party-integration-')as tmp:
  private=Path(tmp)/'party.gbc';shutil.copyfile(rom,private)
  e=PyBoy(str(private),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
  def val(name):return e.memory[s[name]]
  def state():return val('screen_state')
  def pos():return read_word(e,s['player_x']),read_word(e,s['player_y'])
  trace=[]
  def wait(fn,why,limit=16000):
   for _ in range(limit):
    if fn():return
    point=(why,state(),pos(),val('step_remaining'),val('last_keys')if'last_keys'in s else None,read_word(e,s['frame_counter']))
    if not trace or point!=trace[-1]:trace.append(point)
    e.tick(1)
   (out/'failure-trace.json').write_text(json.dumps(trace,indent=2))
   raise AssertionError((why,state(),pos(),val('step_remaining'),hex(e.register_file.PC)))
  def press(key):
   e.button_release(key);e.tick(2);e.button_press(key);e.tick(1);e.button_release(key);e.tick(3)
   # A dialogue acknowledgment can synchronously spend many native frames
   # in a source fade while screen_state still names the old dialogue.
   # Wait for the dispatch to return before issuing another acknowledgment.
   for _ in range(2):
    before=read_word(e,s['frame_counter']);wait(lambda:read_word(e,s['frame_counter'])!=before,'completed button dispatch')
  def ready():wait(lambda:state()!=4 or not val('dialogue_revealing'),'text completion')
  def settle_walk():
   wait(lambda:state()==1,'walking state')
   for _ in range(2):
    before=read_word(e,s['frame_counter']);wait(lambda:read_word(e,s['frame_counter'])!=before,'complete walking iteration')
  def shot(name):
   e.tick(3);e.screen.image.save(out/(name+'.png'));report['screenshots'].append(name+'.png')
  def walk_event(event):
   e.button_release('a');e.button_release('b');settle_walk()
   m=val('world_map_id');grid,flags,entries=source_group(source,source[0xdc1+m]);x,y=pos();cell=((x-8)//16,(y+1520)%1536//16)
   def goal(q):
    a=source_action(source,m,grid,flags,entries,*q);return a[0]==12 and a[1]<18 and a[2]==event
   route,_=source_route(grid,flags,cell,goal)
   for key in route:
    assert state()==1,(event,key,state(),pos());x,y=pos();dx,dy=DIRS[key];target=((x+dx*16)%2048,(y+dy*16)%1536)
    e.button_press(key)
    wait(lambda:pos()!=(x,y)or val('step_remaining')or state()!=1,'committed route step')
    e.button_release(key)
    wait(lambda:(pos()==target and not val('step_remaining'))or state()!=1,'released route step completion');e.tick(2)
   wait(lambda:state()in(4,5),'event')
  def to_travel():
   for _ in range(100):
    if state()==21:return
    assert state()in(4,5),(state(),pos());ready();press('a')
   raise AssertionError('travel prompt')
  try:
   e.tick(300);press('start');finish_new_game_intro(e,s);wait(lambda:state()==1,'new game');e.tick(4)
   # Field B and A both open the menu. Single-frame release avoids the old
   # menu return's absent map fade, which the separate transition patch owns.
   for key in('b','a'):
    press(key);wait(lambda:state()==2,key+' field menu');press('b');settle_walk()
   report['checks'].append('Both original action buttons open the field menu at rest.')
   # A tap inside a step is not queued; B held until its boundary opens menu
   # after exactly one 16px footstep and never accelerates it.
   origin=pos();e.button_press('right');wait(lambda:0<val('step_remaining')<14,'step started')
   e.button_press('a');e.tick(1);e.button_release('a');e.button_release('right');wait(lambda:not val('step_remaining'),'released step finish');e.tick(2)
   assert state()==1 and pos()==(origin[0]+16,origin[1]),('nonqueued A',state(),pos(),origin)
   settle_walk();origin=pos();start_frame=read_word(e,s['frame_counter']);e.button_press('left')
   wait(lambda:pos()!=origin or val('step_remaining'),'committed B-test step');e.button_release('left');e.button_press('b')
   wait(lambda:state()==2,'held B boundary');e.button_release('left');e.button_release('b');e.tick(2)
   assert pos()==(origin[0]-16,origin[1]),('B altered step',origin,pos())
   report['checks'].append('A released during a step is not deferred. Held B opens only at the completed 16px step, with no running speed override.')
   press('b');settle_walk()
   r=s['game_rpg']
   for i in range(4):e.memory[r+i*16]=1
   e.memory[r+64]=51;e.memory[r+65]=52;e.memory[r+88]=2
   walk_event(11);to_travel()
   frames=0;road_poses=[]
   while state()==21:
    e.tick(1);frames+=1
    if val('party_world')==0 and e.memory[s['party_world']+40]==4:
     a=bytes(e.memory[s['party_world']:s['party_world']+42])
     if any(a[i*10+1]!=128 for i in range(4))and len(road_poses)<8:road_poses.append(a.hex())
    if frames==180:shot('road-four-living-actors')
    assert frames<5000
   wait(lambda:state()==1 and val('world_map_id')==5,'Palma spaceport');e.tick(4)
   assert e.memory[s['party_world']+40]==4
   assert sum(e.memory[0xfe00+i*4]!=0 for i in range(40))==22
   shot('road-arrival-all-party');assert road_poses
   report['checks'].append('Original road1 uses four living party actors and its standing follower poses; normal arrival rebuilds all22 OAM entries.')
   walk_event(26)
   for _ in range(100):
    if state()==1:break
    ready();press('a')
   wait(lambda:state()==1,'passport guard');e.button_release('a');e.button_release('b');settle_walk()
   walk_event(179);to_travel();ship_seen=False;frames=0
   while state()==21:
    e.tick(1);frames+=1
    oam=bytes(e.memory[0xfe00:0xfea0]);live=[i for i in range(40)if oam[i*4]]
    if len(live)==16 and all(84<=oam[i*4+2]<100 for i in live):
     ship_seen=True
     if 'ship-without-passengers.png'not in report['screenshots']and frames>120 and e.screen.image.getextrema()[0][1]>96:shot('ship-without-passengers')
    assert frames<6000
   wait(lambda:state()==1 and val('world_map_id')==16,'Motavia spaceport');e.tick(4)
   assert ship_seen and e.memory[s['party_world']+40]==4
   assert sum(e.memory[0xfe00+i*4]!=0 for i in range(40))==22
   shot('ship-arrival-restored-party')
   report['checks'].append('Original ship81 displays only its16 ship sprites during travel; arrival restores all living party actors and their patterns/palettes.')
   report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
  finally:e.stop(save=False)
if __name__=='__main__':main()
