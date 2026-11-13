#!/usr/bin/env python3
"""Walk Camineet -> Palma, fight a natural encounter, and verify save/reload.

Every game-state change uses controller input. Failed level1 runs are recorded;
subsequent attempts vary only the frame at which Start is pressed. No enemy,
party-stat, inventory, money, or RNG injection is used.
"""
from collections import deque
from pathlib import Path
import argparse,hashlib,json,shutil,tempfile
from pyboy import PyBoy
from verify_rom import is_text_revealing,finish_continue_menu,finish_new_game_intro,button,capture,cartridge_header,load_symbols,read_word
ROOT=Path(__file__).resolve().parents[1]
DIRS={'down':(0,1),'right':(1,0),'left':(-1,0),'up':(0,-1)}

def source_route(mapdata,collision,start,predicate):
    previous={start:None};queue=deque([start]);goal=None
    while queue:
        p=queue.popleft()
        if p!=start and predicate(p):goal=p;break
        for key,(dx,dy) in DIRS.items():
            q=((p[0]+dx)%128,(p[1]+dy)%96);flags=collision[mapdata[q[1]*128+q[0]]]
            if q in previous or flags&1 or (flags&12 and not predicate(q)):continue
            previous[q]=(p,key);queue.append(q)
    assert goal is not None,('No source route',start)
    steps=[];p=goal
    while previous[p]:p,key=previous[p];steps.append(key)
    return steps[::-1],goal

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');args=parser.parse_args()
    out=ROOT/'build/verification/integrated-battle';out.mkdir(parents=True,exist_ok=True)
    # Keep the tested inputs together even if a concurrent integration build changes.
    frozen=out/'tested.gbc';shutil.copyfile(args.rom,frozen);shutil.copyfile(args.rom.with_suffix('.noi'),frozen.with_suffix('.noi'))
    syms=load_symbols(frozen.with_suffix('.noi'));report={'header':cartridge_header(frozen),'attempts':[],'checks':[],'injected_fixtures':[],'screenshots':[],'campaign_complete':False}
    maps={g:(ROOT/f'assets/world/world_g{g:02}.map').read_bytes() for g in [0,4]}
    flags={g:(ROOT/f'assets/world/world_g{g:02}.collision').read_bytes() for g in [0,4]}
    success=False
    with tempfile.TemporaryDirectory(prefix='ps-natural-battle-') as tmp:
      for attempt in range(16):
        rom=Path(tmp)/f'attempt-{attempt}.gbc';shutil.copyfile(frozen,rom)
        e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
        delay=300+attempt*17;e.tick(delay)
        record={'start_frame':delay,'controller_steps':0,'encounter_dialogues':[]}
        def val(name):return e.memory[syms[name]]
        def state():return val('screen_state')
        def pos():return read_word(e,syms['player_x']),read_word(e,syms['player_y'])
        def cell():x,y=pos();return ((x-8)//16,(y+1536-16)%1536//16)
        def mapid():return val('world_map_id')
        def party():return bytes(e.memory[syms['game_rpg']:syms['game_rpg']+94])
        def wait(test,reason,limit=1200):
          for _ in range(limit):
            if test():return
            e.tick(1)
          raise AssertionError((reason,state(),pos(),mapid(),hex(e.register_file.PC)))
        def press(key):button(e,key,8,40)
        def shot(name):e.tick(4);report['screenshots'].append(capture(e,out/(name+'.png')))
        def step(key):
          assert state()==1,(state(),key)
          x,y=pos();dx,dy=DIRS[key];target=((x+dx*16)%2048,(y+dy*16)%1536);before=mapid()
          e.button_press(key)
          try:wait(lambda:pos()!=(x,y) or bool(val('step_remaining')) or state()!=1 or mapid()!=before,'start step '+key,600)
          finally:e.button_release(key)
          wait(lambda:(pos()==target and not val('step_remaining')) or state()!=1 or mapid()!=before,'finish step '+key,600)
          e.tick(6);record['controller_steps']+=1
        try:
          press('start');finish_new_game_intro(e,syms);wait(lambda:state()==1,'new game');assert pos()==(1688,304) and party()[:3]==bytes([1,16,0])
          steps,goal=source_route(maps[4],flags[4],cell(),lambda p:p==(109,23))
          for key in steps:step(key)
          wait(lambda:state()==1 and mapid()==0 and pos()==(1368,736) and e.memory[0xff40]&128,'Camineet exit')
          e.tick(60)
          steps,goal=source_route(maps[0],flags[0],cell(),lambda p:maps[0][p[1]*128+p[0]]==1)
          for key in steps:
            if state()==15:break
            step(key)
          # Walk between two source-passable grass cells, avoiding trigger tiles.
          for _ in range(500):
            if state()==15:break
            p=cell();choices=[]
            for key,(dx,dy) in DIRS.items():
              q=((p[0]+dx)%128,(p[1]+dy)%96)
              if maps[0][q[1]*128+q[0]]==1 and not(flags[0][1]&13):choices.append(key)
            assert choices,('No adjacent grass',p)
            step(choices[record['controller_steps']%len(choices)])
          wait(lambda:state()==15,'natural encounter');e.tick(80)
          address=syms['battle_view_battle'];enemy=e.memory[address+128];count=e.memory[address+129]
          record.update(enemy=enemy,count=count,encounter_position=pos(),initial_party=list(party()[:16]))
          assert enemy in (1,5),('Unexpected grass encounter',enemy,cell())
          shot(f'attempt-{attempt}-encounter')
          for _ in range(12000):
            if state()!=15:break
            view=val('battle_view_state')
            if view==1:
              while val('battle_view_choice'):press('right')
              press('a')
            elif view==5:
              dialogue=read_word(e,syms['battle_view_dialogue_id'])
              if dialogue and (not record['encounter_dialogues'] or record['encounter_dialogues'][-1]!=hex(dialogue)):record['encounter_dialogues'].append(hex(dialogue))
              if is_text_revealing(e,syms):e.tick(1)
              else:press('a')
            elif view==6:press('a')
            else:e.tick(1)
          else:raise AssertionError('Battle controller stalled')
          e.tick(80);outcome=val('battle_view_result');record['outcome']=outcome;record['final_party']=list(party()[:16]);report['attempts'].append(record)
          if outcome!=1:
            assert outcome==2,('Unexpected nonvictory',outcome,state());e.stop(False);continue
          assert state()==1 and mapid()==0 and pos()==tuple(record['encounter_position'])
          original=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
          assert hashlib.sha256(original).hexdigest()=='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
          label=next(line for line in (ROOT/'build/sms-reference/ps1built.sym').read_text().splitlines() if line.endswith(' B03_EnemyData'))
          bank,cpu=(int(part,16) for part in label.split()[0].split(':'))
          offset=bank*16384+(cpu&16383)+enemy*32;source_enemy=original[offset:offset+32]
          expected_exp=int.from_bytes(source_enemy[28:30],'little')*count
          expected_money=int.from_bytes(source_enemy[25:27],'little')*count
          assert read_word(e,syms['game_rpg']+3)==expected_exp,(enemy,count,expected_exp,list(party()[:16]))
          assert read_word(e,syms['game_rpg']+90)==expected_money
          assert 0<e.memory[syms['game_rpg']+1]<=16
          assert '0xb71b' in record['encounter_dialogues'] and '0xb604' in record['encounter_dialogues'] and '0xb648' in record['encounter_dialogues']
          report['checks'].append('Controller-only original Camineet exit and Palma grass movement trigger a natural source encounter')
          report['checks'].append('Level1 Alis wins using physical attacks without enemy, HP, inventory, money or RNG injection; actual EXP/chest money match source group rewards')
          # Check full streamed viewport after enemy graphics have been replaced.
          camx=read_word(e,syms['camera_x'])>>3;camy=read_word(e,syms['camera_y'])>>3
          # Read the tested cartridge's converted table, not a potentially
          # different working tree's graphics. Source conversion/priority is
          # independently verified by the exhaustive world tests.
          table=syms['world_g00_metatiles'];table_offset=(table>>16)*16384+(table&16383)
          meta=frozen.read_bytes()[table_offset:table_offset+2048];pairs=0
          report['world_return_conversion_table_sha256']=hashlib.sha256(meta).hexdigest()
          for dy in range(19):
            for dx in range(21):
              tx=(camx+dx)%256;ty=(camy+dy)%192;tile=maps[0][(ty//2)*128+tx//2];off=tile*8+(ty%2)*4+(tx%2)*2;addr=0x9800+((camy+dy)&31)*32+((camx+dx)&31)
              assert (e.memory[0,addr],e.memory[1,addr])==(meta[off],meta[off+1]),(tx,ty)
              pairs+=1
          report['world_return_pairs']=pairs;report['checks'].append('Battle return preserves player location and restores399 world tile/attribute pairs')
          shot('world-after-victory');saved_party=party();saved_pos=pos();saved_facing=val('facing')
          press('select');wait(lambda:state()==8,'save confirmation');assert val('saved_position_valid')==1;shot('save-after-victory')
          e.stop(save=True)
          e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);e.tick(300)
          assert val('saved_position_valid')==1;press('start');finish_continue_menu(e,syms);wait(lambda:state()==1 and e.memory[0xff40]&128,'continue');e.tick(80)
          assert party()==saved_party and pos()==saved_pos and mapid()==0 and val('facing')==saved_facing
          shot('continued-after-victory');report['checks'].append('Power-cycle Continue restores post-battle HP, EXP, money, inventory, RNG, map, position and facing exactly')
          e.stop(False);success=True;break
        except BaseException:
          shot(f'attempt-{attempt}-failure');e.stop(False);raise
    assert success,report['attempts']
    report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='screenshots'},indent=2))
if __name__=='__main__':main()
