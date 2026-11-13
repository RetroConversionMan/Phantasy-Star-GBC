#!/usr/bin/env python3
"""Run the established source campaign route on one unchanged cartridge.

Starts with no SRAM and uses only Campaign's controller actions. Stops with an
exact auditable checkpoint on a natural defeat or unhandled route condition;
it never searches seeds, rewinds, injects state, or silently upgrades the ROM.
"""
from pathlib import Path
import argparse,json,shutil,traceback
from campaign_runner import Campaign
from verify_rom import capture

# The money targets are actual earned Meseta, not injected starting resources.
# They cover known purchases/revivals in the previously traversed source route.
PHASES=[
 ('newgame','newgame',()),('roadpass_funds','grind',(330,200)),
 ('roadpass','roadpass',()),('myau','passport_myau',()),('return_palma','return_palma',()),
 ('odin','odin',()),('compass','compass',()),('key_rumor','key_rumor',()),('warehouse','warehouse',()),
 ('naula_funds','grind',(800,200)),('cake_prepare','cake_prepare',()),('cake','cake',()),
 ('governor_funds','grind',(1000,200)),('governor','governor',()),('noah','noah',()),('noah_return','noah_return',()),
 ('luveno_funds','grind',(5000,300)),('luveno','luveno',()),('construction','construction',()),('abion','abion',()),
 ('hapsby','hapsby',()),('uzo','uzo',()),('hovercraft','hovercraft',()),('boss_gear','boss_gear',()),
 ('blue_dragon','blue_dragon',()),('recover_party','recover_party',()),('dezoris','dezoris',()),('torch','torch',()),
 ('aukba','aukba',()),('ice_funds','ice_funds',(12000,300)),('ice_digger','ice_digger',()),
 ('laconia_armor','laconia_armor',()),('laconia_shield','diamond_shield',()),('wand_funds','ice_funds',(1800,150)),
 ('skure_wand','skure_wand',()),('dr_mad','dr_mad',()),('laerma_nuts','laerma_nuts',()),('aero_prism','aero_prism',()),
 ('endgame_gear','endgame_gear',(200,)),('tarzimal','tarzimal',()),('gas_shield','gas_shield',()),
 ('mirror_shield','mirror_shield',()),('crystal','crystal',()),('laconia_sword','laconia_sword',()),
 ('silver_fang','silver_fang',()),('final_climb','final_climb',()),('castle_shadow','castle_shadow',()),
 ('lassic','lassic',()),('final_governor_prepare','final_governor_prepare',()),('final_training','final_training',()),('final_maze','final_maze',())]

def recovery_cost(q):
 # Source hospital LABEL2999 wraps the two missing-resource bytes before
 # widening; church revival costs20 times the actual current level.
 return sum(((p[6]-p[1]+p[7]-p[2])&255)if p[0]&1 else p[5]*20
            for i,p in enumerate(q.party())if q.byte('game_rpg',89)&(1<<i))

def reach_skure(q):
 if q.map()==21:return
 assert q.map()==22,'Post-Prism preflight must begin in the actual Fly destination'
 q.record('story_preflight',reason='A prior original church revival changed Fly destination to Aukba; traverse the original Skure return caves')
 q.leave_aukba()
 for goals,start,end,name in [
  ([(14,57),(15,57)],(50,0x59,2),(50,0xdb,2),'Post-Prism original western return'),
  ([(22,77),(23,77)],(48,0x87,2),(48,0xed,1),'Post-Prism original southwest return'),
  ([(36,89),(37,89)],(47,0xd2,1),(47,0xdd,1),'Post-Prism original southern return')]:
  q.use(35);q.drain((1,));assert q.byte('game_vehicle')==12
  q.dezoris_passage(goals,start,end,name)
 q.walk([(43,70),(43,71)],'Post-Prism original Skure entrance');assert q.map()==19
 q.walk([(19,16),(20,16)],'Post-Prism original Skure underground');q.drain((17,))
 q.dungeon_multi_walk((40,0x6b,0));q.dungeon_step('up');q.wait(lambda:q.state()==1,'Skure underground exit');q.tick(80)
 assert q.map()==21;q.checkpoint('fresh-story-skure-return')

def skure_funds(q,target,max_battles=200):
 """The already traversed Skure corridor, using native encounters/recovery."""
 assert q.map()==21 and q.state()==1
 before=len(q.report['battles']);q.mp_reserve=8
 while q.word('game_rpg',90)<target+recovery_cost(q):
  assert q.word('game_rpg',90)>=recovery_cost(q),'Earned funds do not cover original recovery; retain this state for an explicit route decision'
  q.skure_recover();q.checkpoint('fresh-story-skure-funds')
  q.walk([(95,15),(96,15)],'Skure source cave for actual equipment and travel funds');q.drain((17,));assert q.dungeon_state()[:3]==(40,0x6b,2)
  q.dungeon_multi_walk((40,0x7b,0));visit=len(q.report['battles'])
  for _ in range(3000):
   if any(not q.byte('game_rpg',i*16)&1 for i in range(4)):break
   if len(q.report['battles'])-before>=max_battles:raise RuntimeError('Actual Skure battle budget reached; native state retained')
   if len(q.report['battles'])-visit>=10 or q.word('game_rpg',90)>=target+recovery_cost(q):break
   if q.dungeon_state()[1]!=0x7b:q.dungeon_multi_walk((40,0x7b,0))
   q.dungeon_step('left'if q.dungeon_state()[2]==0 else'right');assert q.state()==17
  else:raise AssertionError('No source Skure encounter within3000turns')
  q.use(38);q.drain((1,));assert q.map()==21
 assert q.word('game_rpg',90)>=recovery_cost(q)
 q.skure_recover();assert q.word('game_rpg',90)>=target
 q.record('story_preflight_funds_earned',location='Skure',target=target,money=q.word('game_rpg',90))

def preflight(q,name):
 if q.report.get('campaign_tasks',{}).get(name,0):return
 if name=='endgame_gear':reach_skure(q);skure_funds(q,3600)
 elif name=='tarzimal':skure_funds(q,2200)
 elif name=='silver_fang'and q.word('game_rpg',90)<2200:q.grind(2200,200)

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);p.add_argument('--output',type=Path,required=True)
 p.add_argument('--resume',type=Path,help='Exact continuation of this run, never an earlier checkpoint retry')
 p.add_argument('--continue-after-defeat',action='store_true',help='After loading the exact recorded defeat, use actual Continue for a supported funds/final-climb phase')
 p.add_argument('--stop-after',choices=[r[0]for r in PHASES]);a=p.parse_args();out=a.output.resolve()
 if not a.resume:assert not out.exists(),'Fresh campaign requires a new output without SRAM'
 else:
  current=json.loads((out/'report.json').read_text());meta=json.loads(a.resume.with_suffix('.json').read_text())
  assert all(meta.get(k)==v for k,v in current['latest'].items()),'Resume must match the exact latest state, never an earlier checkpoint'
 q=Campaign(a.rom.resolve(),out,a.resume)
 try:
  driver=q.report.setdefault('story_driver',{'next_phase':0,'completed':[]})
  assert not q.report.get('save_continuation'),'This driver is for a fresh single-ROM campaign'
  if a.continue_after_defeat:
   assert a.resume and q.report.get('failure',{}).get('message')=='Natural defeat: failure checkpoint retained. Continue explicitly from actual save.'
   phase=PHASES[driver['next_phase']][0]
   assert phase in('roadpass_funds','naula_funds','governor_funds','luveno_funds','ice_funds','wand_funds','laconia_shield','final_climb','final_training'),('Recovery needs a source-route decision for this phase',phase)
   q.record('story_native_defeat_recovery',phase=phase,death_count=len(q.report['deaths']))
   if phase=='final_climb':q.final_recover()
   elif phase=='laconia_shield':q.shield_recover()
   else:q.continue_game()
  for index,(name,method,args)in enumerate(PHASES):
   if index<driver['next_phase']:continue
   driver['current_phase']=name;q.record('story_phase_begin',phase=name)
   # Earlier phase CLI invocations reset these strategy preferences; preserve
   # that behavior while keeping the emulator and controller log continuous.
   q.force_fight=set();q.avoid_combat=False;q.mp_reserve=q.myau_reserve=q.noah_reserve=0
   preflight(q,name)
   getattr(q,method)(*args)
   driver['completed'].append(name);driver['next_phase']=index+1;q.record('story_phase_complete',phase=name)
   q.report['current_status']='Story phase completed: '+name;q.report.pop('failure',None);q.flush()
   if name==a.stop_after:break
 except BaseException as ex:
  q.report['failure']={'type':type(ex).__name__,'message':str(ex),'traceback':traceback.format_exc(),'state':q.snapshot()}
  q.report['current_status']='Stopped at recorded failure';q.report.setdefault('failures',[]).append(q.report['failure'])
  stem='failure-'+str(len(q.report['failures'])).zfill(3)
  assert not(out/(stem+'.state')).exists()
  with(out/(stem+'.state')).open('wb')as f:q.e.save_state(f)
  (out/(stem+'.json')).write_text(json.dumps({'rom_sha256':q.report['header']['sha256'],**q.snapshot()},indent=2)+'\n')
  capture(q.e,out/(stem+'.png'))
  for suffix in('.state','.json','.png'):shutil.copyfile(out/(stem+suffix),out/('failure'+suffix))
  raise
 finally:q.stop()
if __name__=='__main__':main()
