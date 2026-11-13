#!/usr/bin/env python3
"""Walk actual service entrances and source-confirmation UI in an isolated ROM copy."""
from collections import deque
from pathlib import Path
import argparse,json,shutil,tempfile
from pyboy import PyBoy
from verify_rom import finish_new_game_intro,button,capture,cartridge_header,load_symbols,read_word
ROOT=Path(__file__).resolve().parents[1]
DIRS={'left':(-1,0),'right':(1,0),'up':(0,-1),'down':(0,1)}
def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc');args=parser.parse_args()
    symbols=load_symbols(args.rom.with_suffix('.noi'));out=ROOT/'build/verification/services-emulator';out.mkdir(parents=True,exist_ok=True)
    report={'header':cartridge_header(args.rom),'checks':[],'injected_fixtures':[],'walking_steps':0,'screenshots':[],'campaign_complete':False}
    with tempfile.TemporaryDirectory(prefix='ps-services-') as tmp:
        rom=Path(tmp)/args.rom.name;shutil.copyfile(args.rom,rom)
        e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);e.tick(300)
        def state():return e.memory[symbols['screen_state']]
        def pos():return read_word(e,symbols['player_x']),read_word(e,symbols['player_y'])
        def mapid():return e.memory[symbols['world_map_id']]
        def wait(test,reason,limit=2400):
            for _ in range(limit):
                if test():return
                e.tick(1)
            raise AssertionError((reason,state(),pos(),mapid(),hex(e.register_file.PC)))
        def press(key):button(e,key,12,80)
        def input_():
            e.tick(100)
            for _ in range(3000):
                if state()!=4:return state()
                if 'dialogue_revealing' in symbols and e.memory[symbols['dialogue_revealing']]:e.tick(1)
                else:press('a')
            raise AssertionError('Dialogue did not yield')
        def shot(name):e.tick(80);report['screenshots'].append(capture(e,out/(name+'.png')))
        def route_region(x,y):
            group=0 if mapid()==0 else 4
            data=(ROOT/f'assets/world/world_g{group:02}.map').read_bytes();collision=(ROOT/f'assets/world/world_g{group:02}.collision').read_bytes()
            start=((pos()[0]-8)//16,(pos()[1]-16)//16);goals={(x,y),(x+1,y),(x,(y+1)%96),(x+1,(y+1)%96)}
            previous={start:None};queue=deque([start]);dest=None
            while queue:
                p=queue.popleft()
                if p in goals and p!=start and collision[data[p[1]*128+p[0]]]&8:dest=p;break
                for key,(dx,dy) in DIRS.items():
                    q=((p[0]+dx)%128,(p[1]+dy)%96);flags=collision[data[q[1]*128+q[0]]]
                    if q in previous or flags&1 or (flags&12 and q not in goals):continue
                    previous[q]=(p,key);queue.append(q)
            assert dest is not None,('No valid source route',start,goals,mapid())
            steps=[];p=dest
            while previous[p]:p,key=previous[p];steps.append(key)
            return steps[::-1]
        def walk(x,y):
            for key in route_region(x,y):
                assert state()==1
                px,py=pos();dx,dy=DIRS[key];target=((px+dx*16)%2048,(py+dy*16)%1536);before=mapid()
                e.button_press(key)
                # A native grid step remains committed after key release.
                # Release as soon as it starts, so a long graphics upload
                # cannot hide the boundary and accidentally begin another.
                try:wait(lambda:pos()!=(px,py) or bool(e.memory[symbols['step_remaining']]) or state()!=1 or mapid()!=before,'start step '+key,400)
                finally:e.button_release(key)
                wait(lambda:(pos()==target and not e.memory[symbols['step_remaining']]) or state()!=1 or mapid()!=before,'finish step '+key,400)
                e.tick(6);report['walking_steps']+=1
            e.tick(180)
        def fixture_money(value):
            a=symbols['game_rpg']+90;e.memory[a]=value&255;e.memory[a+1]=value>>8
        press('start');finish_new_game_intro(e,symbols);wait(lambda:state()==1,'New game');e.tick(100)
        walk(94,24);assert input_()==5;press('down');press('b');assert input_()==1
        report['checks'].append('Armory welcome declined through original dialogue and farewell, no mutation')
        walk(94,24);assert input_()==5;press('b'if 'dialogue_revealing'in symbols else'a');assert input_()==6;press('a');shot('insufficient-money');assert input_()==1
        assert e.memory[symbols['game_rpg']+88]==0
        report['checks'].append('Armory selection without funds shows original failure and exits')
        fixture_money(30);report['injected_fixtures'].append('Set money30 for actual Leather Shield purchase; no battle reward claimed')
        walk(94,24);assert input_()==5;press('a');assert input_()==6;shot('armory-stock');press('a');assert input_()==5
        assert e.memory[symbols['game_rpg']+88]==1 and e.memory[symbols['game_rpg']+64]==25
        assert read_word(e,symbols['game_rpg']+90)==0;press('down');press('b');assert input_()==1
        report['checks'].append('Leather Shield costs30, enters shared inventory, and original another-purchase prompt works')
        walk(99,24);assert input_()==14;press('right');press('a');assert input_()==9
        press('a');assert input_()==5
        press('down');press('b');assert input_()==9
        assert e.memory[symbols['game_rpg']+88]==1 and read_word(e,symbols['game_rpg']+90)==0
        press('a');assert input_()==5;shot('sale-price-confirmation');press('a');sale_state=input_()
        sale={'screen':sale_state,'money':read_word(e,symbols['game_rpg']+90),'inventory_count':e.memory[symbols['game_rpg']+88],'service_bytes':list(e.memory[symbols['game_service']:symbols['game_service']+24])}
        (out/'sale-result.json').write_text(json.dumps({'header':report['header'],**sale},indent=2)+'\n')
        assert sale_state==5 and sale['money']==15 and not sale['inventory_count'],sale
        shot('sale-completed');press('down');press('b');assert input_()==1
        report['checks'].append('Camineet tools SELL quotes15 for the actually purchased Leather Shield; No preserves it/money, Yes removes it once and credits15; decline another sale returns outside')
        walk(107,29);assert input_()==5;assert e.memory[symbols['game_events']+259]==1
        press('down');press('b');shot('church-blessing');assert input_()==1
        report['checks'].append('Church entry records C317 before prompt; decline shows blessing and EXP-to-next guidance')
        walk(109,22);wait(lambda:mapid()==0 and state()==1 and bool(e.memory[0xff40]&128),'Exit Camineet');e.tick(100)
        walk(70,55);wait(lambda:mapid()==6 and state()==1 and bool(e.memory[0xff40]&128),'Enter Parolit');e.tick(100)
        e.memory[symbols['game_rpg']+1]=1;fixture_money(15)
        report['injected_fixtures'].append('Set AlisHP1 and money15 for hospital fee; Camineet-to-Parolit travel uses only controller input')
        walk(36,69);assert input_()==5;press('a');assert input_()==5, {'state':state(),'service':list(e.memory[symbols['game_service']:symbols['game_service']+24]),'rpg':list(e.memory[symbols['game_rpg']:symbols['game_rpg']+16])}
        assert e.memory[symbols['game_rpg']+1]==1 and read_word(e,symbols['game_rpg']+90)==15
        shot('hospital-fee-confirmation');press('a');shot('hospital-healed');assert input_()==1
        assert e.memory[symbols['game_rpg']+1]==16 and read_word(e,symbols['game_rpg']+90)==0
        report['checks'].append('Parolit hospital quotes15 and changes HP/money only after explicit yes')
        walk(36,69);assert input_()==5;press('a');shot('hospital-already-healed');assert input_()==1
        report['checks'].append('Already-healed single-member hospital branch shows source careful farewell without charging')
        e.stop(save=False)
    report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='screenshots'},indent=2))
if __name__=='__main__':main()
