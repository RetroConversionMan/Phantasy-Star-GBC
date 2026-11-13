#!/usr/bin/env python3
"""Real-input Camineet event/UI/save regression, with separately labeled WRAM fixtures.

Routes derive from original expanded map/collision bytes; this does not claim a
full campaign run. Emulator saves are isolated in a temporary copy of the ROM.
"""
from collections import deque
from pathlib import Path
import argparse
import json
import shutil
import tempfile
from pyboy import PyBoy
from verify_rom import finish_continue_menu,finish_new_game_intro,button, capture, cartridge_header, load_symbols, read_word
ROOT=Path(__file__).resolve().parents[1]
DIRS={'right':(1,0),'left':(-1,0),'down':(0,1),'up':(0,-1)}

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('rom',type=Path,nargs='?',default=ROOT/'build/phantasy-star-gbc-world.gbc')
    args=parser.parse_args();symbols=load_symbols(args.rom.with_suffix('.noi'))
    out=ROOT/'build/verification/expansion';out.mkdir(parents=True,exist_ok=True)
    report={'header':cartridge_header(args.rom),'real_input_checks':[],'injected_fixtures':[], 'routes':[], 'screenshots':[],'campaign_complete':False}
    mapdata=(ROOT/'assets/world/world_g04.map').read_bytes();collision=(ROOT/'assets/world/world_g04.collision').read_bytes()
    def route(start,dest):
        previous={start:None};queue=deque([start])
        while queue:
            p=queue.popleft()
            if p==dest:break
            for key,(dx,dy) in DIRS.items():
                q=((p[0]+dx)%128,(p[1]+dy)%96);flags=collision[mapdata[q[1]*128+q[0]]]
                if q in previous or flags&1 or (flags&12 and q!=dest):continue
                previous[q]=(p,key);queue.append(q)
        assert dest in previous,f'No source-valid route to {dest}'
        steps=[];p=dest
        while previous[p]:p,key=previous[p];steps.append(key)
        return steps[::-1]
    with tempfile.TemporaryDirectory(prefix='ps-expansion-') as tmp:
        rom=Path(tmp)/args.rom.name;shutil.copyfile(args.rom,rom)
        def boot():
            e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);e.tick(300);return e
        emulator=boot()
        def state():return emulator.memory[symbols['screen_state']]
        def pos():return read_word(emulator,symbols['player_x']),read_word(emulator,symbols['player_y'])
        def wait(test,reason,frames=2400):
            for _ in range(frames):
                if test():return
                assert emulator.tick(1)
            raise AssertionError(f'{reason}; state={state()}, pos={pos()}, pc={hex(emulator.register_file.PC)}')
        def press(key):button(emulator,key,12,80)
        def shot(name):
            emulator.tick(4);report['screenshots'].append(capture(emulator,out/(name+'.png')))
        def window_line(row):return ''.join(chr(emulator.memory[0,0x9c00+row*32+x]+32) for x in range(20))
        def dismiss():
            count=0
            while state()==4:
                press('a');count+=1
                assert count<40,'Dialogue did not terminate'
            wait(lambda:state()==1,'Expected return to exploration')
            return count
        def walk(destination,name):
            start=((pos()[0]-8)//16,(pos()[1]-16)//16);steps=route(start,destination)
            for key in steps:
                assert state()==1, (name,state())
                x,y=pos();dx,dy=DIRS[key];target=((x+dx*16)%2048,(y+dy*16)%1536);before_map=emulator.memory[symbols['world_map_id']]
                emulator.button_press(key)
                try:wait(lambda:(pos()==target and not emulator.memory[symbols['step_remaining']]) or state()!=1 or emulator.memory[symbols['world_map_id']]!=before_map,f'Walking {key} to {target}',400)
                finally:emulator.button_release(key)
                emulator.tick(6)
            report['routes'].append({'name':name,'start_cell':start,'destination_cell':destination,'input_steps':len(steps)})
        assert state()==0;shot('title');press('start');finish_new_game_intro(emulator,symbols);wait(lambda:state()==1,'New game')
        assert pos()==(1688,304);assert emulator.memory[symbols['world_map_id']]==4
        assert list(emulator.memory[symbols['game_rpg']:symbols['game_rpg']+3])==[1,16,0]
        report['real_input_checks'].append('New game starts at original Camineet position with Alis HP16')
        walk((102,22),'Suelo introduction');wait(lambda:state()==4,'Suelo dialogue');emulator.tick(80)
        assert emulator.memory[symbols['game_events']+1]==1
        assert "I'M SUELO." in window_line(1)
        shot('suelo-introduction');dismiss()
        report['real_input_checks'].append('Source-valid walking route triggers Suelo introduction and C501 flag')
        # Explicit damaged-HP fixture tests the real repeat-conversation route; it is not a battle.
        emulator.memory[symbols['game_rpg']+1]=1
        report['injected_fixtures'].append('Set Alis HP to1 in WRAM solely to verify repeat Suelo healing; no battle occurred')
        walk((102,22),'Suelo repeat');wait(lambda:state()==4,'Suelo repeated interaction');emulator.tick(80);assert 'PLEASE REST' in window_line(1)
        assert emulator.memory[symbols['game_rpg']+1]==1;dismiss();assert emulator.memory[symbols['game_rpg']+1]==16
        walk((85,16),'Nekise and Laconian Pot');wait(lambda:state()==4,'Nekise dialogue');emulator.tick(80)
        assert "I'M NEKISE." in window_line(1);shot('nekise-introduction');dismiss()
        assert emulator.memory[symbols['game_events']+2]==1, {'state':state(),'events':list(emulator.memory[symbols['game_events']+256:symbols['game_events']+280]),'rpg':list(emulator.memory[symbols['game_rpg']+64:symbols['game_rpg']+94])}
        assert emulator.memory[symbols['game_rpg']+88]==1
        assert emulator.memory[symbols['game_rpg']+64]==56
        walk((85,16),'Nekise repeat');wait(lambda:state()==4,'Repeated Nekise');emulator.tick(80);dismiss()
        assert emulator.memory[symbols['game_rpg']+88]==1
        report['real_input_checks'].append('Nekise awards exactly one Laconian Pot; repeat visit preserves inventory')
        press('start');wait(lambda:state()==2,'Pause menu');press('down');press('a');wait(lambda:state()==13,'Status')
        shot('status');press('b');wait(lambda:state()==2,'Return from status');press('down');press('a');wait(lambda:state()==9,'Inventory')
        assert 'LAC. POT' in window_line(4);shot('inventory');press('b');wait(lambda:state()==2,'Return from inventory');press('b');wait(lambda:state()==1,'Resume')
        report['real_input_checks'].append('Status and inventory screens open by controller input and show acquired pot')
        saved_pos=pos();press('select');wait(lambda:state()==8,'Save confirmation');assert emulator.memory[symbols['saved_position_valid']]==1;shot('save-confirmation')
        emulator.stop(save=True);emulator=boot();assert emulator.memory[symbols['saved_position_valid']]==1
        press('start');finish_continue_menu(emulator,symbols);wait(lambda:state()==1,'Continue after restart');assert pos()==saved_pos
        assert emulator.memory[symbols['game_events']+1]==1 and emulator.memory[symbols['game_events']+2]==1
        assert emulator.memory[symbols['game_rpg']+88]==1 and emulator.memory[symbols['game_rpg']+64]==56
        report['real_input_checks'].append('Power-cycle Continue restores position, Suelo/Nekise flags, and Laconian Pot')
        # Walk through the original map transition rectangle at (109,22), not the decorative town boundary.
        walk((109,23),'Camineet original exit');wait(lambda:state()==1 and emulator.memory[symbols['world_map_id']]==0 and pos()==(1368,736) and bool(emulator.memory[0xff40]&128),'Camineet exit to original Palma destination')
        shot('palma-arrival');report['real_input_checks'].append('Actual walking across Camineet exit changes to original Palma map')
        emulator.stop(save=False)
    report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k!='screenshots'},indent=2))
if __name__=='__main__':main()
