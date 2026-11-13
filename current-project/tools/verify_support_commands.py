#!/usr/bin/env python3
"""Original-Z80 versus native actual-menu support/command chronology.

Uses a frozen production object set and explicit combat fixtures, not campaign
progress. Game state is configured before input; the one forced initiative
boundary is recorded. Rule commits are precomputed, not source-timed.
"""
from pathlib import Path
import argparse,hashlib,json,re,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header,read_word
from audit_battle_command_timeline import trace,tokens,ENTRIES
ENTRIES['EnemyFire']='LABEL_1421'
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include <stddef.h>
#include "battle_view.h"
#include "battle_scene.h"
#include "audio.h"
#include "font.h"
extern RPGState game_rpg;
typedef char layout_check[(sizeof(RPGBattle)==208u&&offsetof(RPGBattle,barrier_break_before)==207u)?1:-1];
volatile uint8_t support_ready,support_command,support_force,support_config[16];
static const uint16_t palette[]={RGB(2,3,8),RGB(6,10,19),RGB(30,22,8),RGB(30,30,27)};
static const uint8_t bits[]={1,2,4,8};
void main(void){
 uint8_t i,keys,pressed,last=0,was_revealing;
 cpu_fast();DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;
 set_bkg_palette(7,1,palette);SWITCH_ROM_MBC5(1);audio_install();SHOW_BKG;DISPLAY_ON;support_ready=1;
 while(1){
  vsync();keys=joypad();pressed=keys&~last;was_revealing=battle_view_text_revealing;
  if(support_command){
   rpg_new_game(&game_rpg);for(i=1;i<4;i++)rpg_recruit(&game_rpg,i);
   for(i=0;i<4;i++)game_rpg.party[i].level=30;rpg_refresh_stats(&game_rpg);rpg_rest(&game_rpg);
   for(i=0;i<4;i++){
    game_rpg.party[i].status=(support_config[13]&bits[i])?1u:0u;
    game_rpg.party[i].hp=game_rpg.party[i].status?support_config[6]:0;
    game_rpg.party[i].max_hp=support_config[7];game_rpg.party[i].mp=game_rpg.party[i].max_mp=100;
    game_rpg.party[i].attack=support_config[4];game_rpg.party[i].defense=80;
   }
   battle_scene_configure(1,0);battle_view_begin(&game_rpg,support_config[12]);
   battle_view_battle.count=1;
   for(i=0;i<8;i++){battle_view_battle.enemies[i].status=i?0:1;battle_view_battle.enemies[i].hp=i?0:support_config[6];}
   battle_view_battle.enemies[0].max_hp=support_config[7];battle_view_battle.enemies[0].attack=support_config[5];battle_view_battle.enemies[0].bound=support_config[15];
   battle_view_battle.enemy_flags=support_config[1];battle_view_battle.run_chance=support_config[2];battle_view_battle.escape_blocked=support_config[3];battle_view_battle.barrier=support_config[10];
   rpg_seed_rng(&game_rpg,(uint16_t)support_config[8]|((uint16_t)support_config[9]<<8));support_force=1;support_command=0;
  }else battle_view_tick(keys,pressed);
  if(support_force&&(battle_view_state==BVIEW_EXECUTE||battle_view_battle.suppress_party)){
   memset(battle_view_battle.turn_order,255,12);battle_view_battle.turn_order[0]=support_config[11]?4:support_config[0];battle_view_battle.turn_cursor=0;
   game_rpg.party[support_config[0]].bound=support_config[14];
   rpg_seed_rng(&game_rpg,(uint16_t)support_config[8]|((uint16_t)support_config[9]<<8));support_force=0;
  }
  if(!was_revealing)last=keys;
 }
}
'''

def build(snap,out):
 (out/'main.c').write_text(MAIN);compiler='.tools/gbdk/bin/lcc';flags=['-msm83:gb','-DPS_DUNGEON_LEAN','-DPS_DUNGEON_MOTION','-I'+str(snap/'src')]
 for source,obj,extra in [(snap/'src/main.c',out/'production-main.o',['-Dmain=production_main']),(out/'main.c',out/'probe-main.o',[])]:
  subprocess.run([compiler,*flags,*extra,'-c','-o',str(obj.relative_to(ROOT)),str(source.relative_to(ROOT))],cwd=ROOT,check=True)
 value=re.search(r'^SOURCES := (.*)$',(snap/'Makefile').read_text().replace('\\\n',' '),re.M)[1]
 value=re.sub(r'\$\(wildcard ([^)]+)\)',lambda m:' '.join(str(p.relative_to(snap))for pattern in m[1].split()for p in sorted(snap.glob(pattern))),value)
 objects=[snap/'build/obj'/(Path(n).stem+'.o')for n in value.split()if n!='src/main.c']+[out/'production-main.o',out/'probe-main.o'];assert all(n.is_file()for n in objects)
 rom=out/'support-commands.gbc';subprocess.run([compiler,'-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-o',str(rom.relative_to(ROOT)),*[str(n.relative_to(ROOT))for n in objects]],cwd=ROOT,check=True)
 return rom,{str(n.relative_to(ROOT)):hashlib.sha256(n.read_bytes()).hexdigest()for n in objects}

def main():
 p=argparse.ArgumentParser();p.add_argument('--snapshot',type=Path,default=ROOT/'build/source-snapshots/support-command-candidate');p.add_argument('--output',type=Path,default=ROOT/'build/verification/support-commands');p.add_argument('--skip-build',action='store_true');a=p.parse_args();out=a.output.resolve();out.mkdir(parents=True,exist_ok=True)
 if a.skip_build:rom=out/'support-commands.gbc';objects={}
 else:rom,objects=build(a.snapshot.resolve(),out)
 s=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0)
 events=[];close_spans=[];pending_close=[None];presentation_rng=[None];recording=[False];stop=[False];frame=[0];guard=bytes((0x9d+i*17)&255 for i in range(64));report={'header':cartridge_header(rom),'production_rom':cartridge_header(a.snapshot/'build/phantasy-star-gbc-world.gbc'),'cases':[],'objects_sha256':objects,'scope':'Native real battle menus with explicit pre-combat fixtures and forced initiative; source-Z80 message/sound/close order and final effects. Not a campaign. Persistent rule mutations remain precomputed.'}
 def val(n):return e.memory[s[n]]
 def state():return val('battle_view_state')
 def hook(kind):
  if recording[0]:
   if kind=='round':
    if any(k=='close'for k,v,c in events):
     stop[0]=True;recording[0]=False
    return
   if kind=='close_begin':
    length=e.register_file.A;pending_close[0]=(length,e.register_file.E,read_word(e,s['audio_frames']))
    if length==6 or not any(k=='close'for k,v,c in events):events.append(('close',None,pending_close[0][2]))
    return
   if kind=='resume':
    if pending_close[0]and e.register_file.A==pending_close[0][1]:
     length,after,clock=pending_close[0];elapsed=(read_word(e,s['audio_frames'])-clock)&65535;assert elapsed==length,('exact close interval',length,elapsed,events);close_spans.append(length);pending_close[0]=None
    return
   sp=e.register_file.SP;value=None if kind=='hit'else read_word(e,sp+8)if kind=='text'else e.memory[sp+6]
   if kind!='text'or value!=0xb128:
    rng=read_word(e,s['game_rpg']+92)
    if presentation_rng[0]is None:presentation_rng[0]=rng
    else:assert rng==presentation_rng[0],('presentation RNG',kind,value,events)
   events.append((kind,value,read_word(e,s['audio_frames'])))
 for name,kind in [('dialogue_open','text'),('audio_command','sound'),('boss_motion_begin','hit'),('rpg_battle_prepare','round')]:
  address=s[name];e.hook_register(address>>16,address&65535,hook,kind)
 local={m[1]:int(m[2],16)for m in re.finditer(r'^\s*8 _([A-Za-z0-9_]+)\s+([0-9A-Fa-f]+) [GR]+$',(a.snapshot/'build/obj/battle_view.sym').read_text(),re.M)}
 bases={s[n]-v for n,v in local.items()if n in s and n.startswith('battle_view_')};assert len(bases)==1;bases=bases.pop()
 for name,kind in [('close_delay','close_begin'),('resume','resume')]:
  address=bases+local[name];e.hook_register(address>>16,address&65535,hook,kind)
 last_state=[0];guard_active=[False]
 def tick(n=1):
  for _ in range(n):
   if stop[0]:break
   e.tick(1);frame[0]+=1
   last_state[0]=state();assert not val('audio_fault')
   if guard_active[0]:assert bytes(e.memory[0xdbc0:0xdc00])==guard
 def press(key):
  e.button_release(key);tick(4);e.button_press(key);tick(8);e.button_release(key);tick(30)
 def wait(fn,why,limit=3000):
  for _ in range(limit):
   if fn():return
   tick()
  raise AssertionError((why,state(),hex(read_word(e,s['battle_view_dialogue_id'])),events))
 spells={'Heal':(0,0),'Bye':(0,1),'Chat':(0,2),'Rope':(0,4),'Cure':(1,0),'Terr':(1,1),'Wall':(1,2),'Help':(1,3),'Tele':(3,1),'Prot':(3,3)}
 cases=[]
 for name in ('Heal','Cure'):
  for hp,maxhp in [(7,100),(95,100),(250,255)]:cases.append((name,dict(hp=hp,maxhp=maxhp)))
 for name in ('Wall','Prot','Help'):cases.append((name,{}))
 for flags,attack,enemy_bound in [(0,50,0),(32,50,0),(32,49,0),(32,50,3)]:cases.append(('Rope',dict(flags=flags,attack=attack,enemy_bound=enemy_bound)))
 for attack,seed in [(49,1),(50,1),(50,127)]:cases.append(('Terr',dict(attack=attack,seed=seed)))
 for name in ('Bye','Run'):
  for chance,blocked in [(0,False),(255,False),(255,True)]:cases.append((name,dict(chance=chance,blocked=blocked)))
 for name in ('Talk','Chat','Tele'):
  for flags,attack in [(0,50),(128,49),(128,50),(64,49),(64,50),(192,50)]:cases.append((name,dict(flags=flags,attack=attack)))
 for name,flags,seed in [('EnemyRope',1,2),('EnemyHeal',2,1),('EnemyHelp',3,8)]:cases.append((name,dict(flags=flags,seed=seed)))
 for name in ('PlayerBound','EnemyBound'):
  for remaining in (1,3):cases.append((name,dict(bound=remaining,enemy_bound=remaining,seed=1)))
 cases.append(('EnemyRope',dict(flags=1,seed=2,barrier=129)))
 cases.append(('EnemyRope',dict(flags=17,seed=2,barrier=129)))
 for name,flags,enemy_id,seeds in [('EnemyFire',20,13,(2,8)),('EnemyThunder',21,56,(2,4,8,512))]:
  for seed in seeds:cases.append((name,dict(flags=flags,seed=seed,barrier=129,hp=200,maxhp=255,living_mask=15,enemy_id=enemy_id)))
 cases.append(('EnemyThunder',dict(flags=21,seed=2,barrier=129,hp=200,maxhp=255,living_mask=1,enemy_id=56)))
 try:
  tick(180);assert val('support_ready')
  areas=re.findall(r'^(_DATA|_INITIALIZED|_BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+=',rom.with_suffix('.map').read_text(),re.M);assert areas and max(int(v,16)+int(n,16)for k,v,n in areas)<=0xdbc0;e.memory[0xdbc0:0xdc00]=guard;guard_active[0]=True
  for number,(name,options)in enumerate(cases):
   actor=spells.get(name,(0,0))[0];enemy=name.startswith('Enemy');source=dict(actor=actor,target=actor,flags=128,attack=50,enemy_attack=50,hp=7,maxhp=100,chance=1,blocked=False,seed=1,living_mask=1<<actor,rng_zero=True);source.update(options);enemy_id=source.pop('enemy_id',1)
   if source['blocked']:source['interaction']=0
   config=[actor,source['flags'],source['chance'],int(source['blocked']),source['attack'],source['enemy_attack'],source['hp'],source['maxhp'],source['seed']&255,source['seed']>>8,source.get('barrier',0),int(enemy),enemy_id,source['living_mask'],source.get('bound',0),source.get('enemy_bound',0)]
   recording[0]=False;stop[0]=False;pending_close[0]=None;presentation_rng[0]=None;e.memory[s['support_config']:s['support_config']+16]=config;e.memory[s['support_command']]=1;wait(lambda:not val('support_command'),'fixture');tick(3);assert state()==1
   assert [e.memory[s['game_rpg']+i*16]for i in range(4)]==[(source['living_mask']>>i)&1 for i in range(4)],('fixture status',config,list(e.memory[s['support_config']:s['support_config']+16]),[list(e.memory[s['game_rpg']+i*16:s['game_rpg']+i*16+16])for i in range(4)])
   if name in spells:
    press('right');press('a');assert state()==2
    for _ in range(spells[name][1]):press('down')
    events.clear();close_spans.clear();recording[0]=True;press('a')
    if state()==4:press('a')
   else:
    for _ in range(3 if name=='Talk' else 4 if name=='Run' else 0):press('right')
    events.clear();close_spans.clear();recording[0]=True;press('a')
   while state()==1 and not events:press('a')
   for elapsed in range(3000):
    if stop[0]or(state()in(1,9)and events):break
    if state()==5 and not val('battle_view_text_revealing'):press('a')
    else:tick()
   else:raise AssertionError((name,'completion',state(),val('battle_view_actor'),val('battle_view_choice'),val('support_force'),hex(e.register_file.PC),events))
   recording[0]=False;original=trace(name,**source);expected=[(kind,int(value,16)if value else None)for kind,value in tokens(original)]
   actual=[(kind,value)for kind,value,_ in events];ended=original['final']['actor']in(5,6)
   if name in ('EnemyFire','EnemyThunder'):actual=[event for event in actual if event[0]!='sound']
   if ended:expected.append(('sound',0xd8))
   # Run has no dialogue close; its mandatory14+1 teardown is recorded once.
   if name=='Run'and ended:expected.insert(-1,('close',None))
   assert actual==expected,(name,options,actual,expected)
   if ended:
    close=next(clock for kind,value,clock in events if kind=='close');d8=next(clock for kind,value,clock in events if kind=='sound'and value==0xd8)
    # All requested waits are checked exactly at close_delay/resume entry.
    # LCD-off scene clearing adds native upload/IRQ alignment between them.
    assert close_spans==([14,1]if name=='Run'else[6,14,1]),(name,close_spans)
    minimum=sum(close_spans);assert minimum<=((d8-close)&65535)<=minimum+4,(name,'exit waits',events)
   else:
    assert close_spans and all(n==6 for n in close_spans),(name,'six close waits',close_spans,events)
   native_mp=e.memory[s['game_rpg']+actor*16+2];native_hp=e.memory[s['game_rpg']+actor*16+1]
   assert native_mp==original['final']['mp'] and native_hp==original['final']['hp'],(name,'MP/HP',native_mp,native_hp,original['final'])
   assert [e.memory[s['game_rpg']+i*16+1]for i in range(4)]==original['final']['party_hp'],(name,'partyHP',original['final'])
   assert e.memory[s['battle_view_battle']+1]==original['final']['enemy_hp'],(name,'enemyHP',original['final'])
   report['cases'].append({'command':name,'source_inputs':source,'source_trace':original,'events':[(kind,hex(value)if value is not None else None,clock)for kind,value,clock in events],'exact_close_intervals':close_spans.copy(),'source_final':original['final'],'native_final_mp':native_mp,'native_final_hp':native_hp,'result':val('battle_view_result'),'presentation_rng_unchanged':True,'guard64_preserved':True})
   (out/'progress.json').write_text(json.dumps({'passed_cases':len(report['cases']),'last':name},indent=2)+'\n')
  report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'cases':len(report['cases']),'rom_sha256':report['header']['sha256']}))
 finally:e.stop(save=False)
if __name__=='__main__':main()
