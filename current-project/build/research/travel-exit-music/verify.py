#!/usr/bin/env python3
"""Original DD9 music bytes versus every road/ship exit, host and native.

Focused route requests are explicit fixtures; the native production sequence,
renderer, audio driver and enter_map execute normally. No campaign claim.
"""
from pathlib import Path
import argparse,ctypes as C,hashlib,json,re,subprocess,sys
ROOT=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'tools'))
from pyboy import PyBoy
from verify_rom import load_symbols,read_word,cartridge_header
from verify_travel import State
SHA='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "audio.h"
#include "font.h"
#include "rpg.h"
#include "events.h"
#include "game_sequence.h"
extern RPGState game_rpg;
extern EventState game_events;
extern uint8_t screen_state;
void enter_map(uint8_t,uint16_t,uint16_t);
volatile uint8_t travel_probe_ready,travel_probe_command,travel_probe_tag,travel_probe_skip,travel_probe_clock;
void main(void){
 cpu_fast();DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;VBK_REG=1;set_bkg_data(0,64,ui_font);VBK_REG=0;
 SWITCH_ROM_MBC5(1);audio_install();rpg_new_game(&game_rpg);event_init(&game_events,&game_rpg);
 enter_map(4u,1320u,400u);SHOW_BKG;DISPLAY_ON;travel_probe_ready=1;
 while(1){vsync();
  if(travel_probe_command){travel_probe_command=0;travel_probe_clock=0;start_travel(travel_probe_tag);}
  else if(screen_state==STATE_TRAVEL){++travel_probe_clock;game_sequence_tick(travel_probe_skip&&(travel_probe_clock&1u)?J_A:0u,0u);}
 }
}
'''

def build(snap,source,out):
 (out/'main.c').write_text(MAIN);compiler='.tools/gbdk/bin/lcc'
 flags=['-msm83:gb','-DPS_DUNGEON_LEAN','-DPS_DUNGEON_MOTION','-I'+str(snap/'src')]
 for file,obj,extra in [(snap/'src/main.c',out/'production-main.o',['-Dmain=production_main']),(out/'main.c',out/'probe-main.o',[]),(source,out/'travel.o',[])]:
  subprocess.run([compiler,*flags,*extra,'-c','-o',str(obj.relative_to(ROOT)),str(file.relative_to(ROOT))],cwd=ROOT,check=True)
 value=re.search(r'^SOURCES := (.*)$',(snap/'Makefile').read_text().replace('\\\n',' '),re.M)[1]
 value=re.sub(r'\$\(wildcard ([^)]+)\)',lambda m:' '.join(str(p.relative_to(snap))for pattern in m[1].split()for p in sorted(snap.glob(pattern))),value)
 objects=[snap/'build/obj'/(Path(n).stem+'.o')for n in value.split()if n not in('src/main.c','src/travel.c')]+[out/'production-main.o',out/'probe-main.o',out/'travel.o']
 assert all(p.is_file()for p in objects)
 rom=out/'travel-music.gbc'
 subprocess.run([compiler,'-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in objects]],cwd=ROOT,check=True)
 return rom,{str(p.relative_to(ROOT)):sha(p)for p in objects}

def main():
 p=argparse.ArgumentParser();p.add_argument('--snapshot',type=Path,required=True);p.add_argument('--source',type=Path,required=True);p.add_argument('--output',type=Path,required=True);p.add_argument('--expect-mismatch',action='store_true');args=p.parse_args()
 snap=args.snapshot.resolve();source=args.source.resolve();out=args.output.resolve();out.mkdir(parents=True,exist_ok=True)
 original=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(original).hexdigest()==SHA
 symbols={m[3]:(int(m[1],16),int(m[2],16))for line in(ROOT/'build/sms-reference/ps1built.sym').read_text().splitlines()if(m:=re.match(r'^([0-9a-f]+):([0-9a-f]+) (\w+)$',line))}
 def addr(n):b,c=symbols[n];return c if c<0x8000 else b*0x4000+(c&0x3fff)
 tracks=list(original[addr('LABEL_DD9'):addr('LABEL_DD9')+24])
 table=[int(x,16)for x in re.findall(r'0x([0-9a-f]+)',re.search(r'map_music\[24\]=\{([^}]+)',source.read_text())[1])]
 table_mismatches=[{'map':i,'native':a,'source':b}for i,(a,b)in enumerate(zip(table,tracks))if a!=b]
 library=out/'travel.dylib';subprocess.run(['cc','-std=c99','-O2','-Wall','-Wextra','-Werror','-shared','-fPIC','-I'+str(snap/'src'),str(source),'-o',str(library)],check=True)
 lib=C.CDLL(str(library));lib.travel_begin.argtypes=[C.POINTER(State),C.c_uint8];lib.travel_begin.restype=C.c_uint8;lib.travel_step.argtypes=[C.POINTER(State),C.c_uint8];lib.travel_step.restype=C.c_uint8
 tags=list(range(1,7))+list(range(0x81,0x89));host=[];mismatches=[]
 for tag in tags:
  size=8 if tag<0x80 else 9;base=addr('LABEL_F0C')if tag<0x80 else addr('LABEL_ABF');idx=tag-1 if tag<0x80 else tag-0x81;row=original[base+idx*size:base+(idx+1)*size];exit_map=row[5 if tag<0x80 else 6];want=tracks[exit_map]
  for skip in (False,True):
   s=State();flags=lib.travel_begin(C.byref(s),tag);audio=[{'tick':0,'command':s.music,'map':s.map,'stage':s.stage}];exit_tick=None
   for tick in range(1,6000):
    flags=lib.travel_step(C.byref(s),int(skip and s.stage in(2,3,5,6)))
    if flags&8:
     audio.append({'tick':tick,'command':s.music,'map':s.map,'stage':s.stage})
     if s.stage==1 and s.next_stage==8:exit_tick=tick
    if flags&16:break
   else:raise AssertionError(('host timeout',tag,skip))
   assert s.map==exit_map and exit_tick is not None and tick-exit_tick==40
   if s.music!=want:mismatches.append({'tag':tag,'skip':skip,'map':exit_map,'got':s.music,'want':want})
   state={n:getattr(s,n)for n,_ in State._fields_}
   host.append({'tag':tag,'skip':skip,'source_route_bytes':list(row),'expected_exit_music':want,'audio':audio,'arrival_fade_ticks':tick-exit_tick,'final_state':state})
 rom,objects=build(snap,source,out);sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=True,log_level='ERROR');e.set_emulation_speed(0)
 active=[False];events=[];guard=bytes((0x9d+i*17)&255 for i in range(64));guard_active=False;native=[];native_mismatches=[]
 def hook(_):
  if active[0]:events.append({'command':e.memory[e.register_file.SP+6],'audio_frame':read_word(e,sym['audio_frames']),'map':e.memory[sym['world_map_id']]})
 at=sym['audio_command'];e.hook_register(at>>16,at&65535,hook,None)
 def tick():
  e.tick(1);assert not e.memory[sym['audio_fault']]
  if guard_active:assert bytes(e.memory[0xdbc0:0xdc00])==guard,'64-byte guard changed'
 try:
  for _ in range(300):
   tick()
   if e.memory[sym['travel_probe_ready']]:break
  else:raise AssertionError('probe initialization')
  areas=re.findall(r'^(_DATA|_INITIALIZED|_BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+=',rom.with_suffix('.map').read_text(),re.M);end=max(int(v,16)+int(n,16)for k,v,n in areas);assert end<=0xdbc0
  e.memory[0xdbc0:0xdc00]=guard;guard_active=True
  for case in host:
   persistent=bytes(e.memory[sym['game_rpg']:sym['game_rpg']+94]);events.clear();active[0]=True
   e.memory[sym['travel_probe_tag']]=case['tag'];e.memory[sym['travel_probe_skip']]=case['skip'];e.memory[sym['travel_probe_command']]=1
   for frames in range(1,12000):
    tick()
    if not e.memory[sym['travel_probe_command']]and e.memory[sym['screen_state']]==1:break
   else:raise AssertionError(('native timeout',case['tag'],case['skip'],e.memory[sym['screen_state']],events))
   active[0]=False;assert bytes(e.memory[sym['game_rpg']:sym['game_rpg']+94])==persistent
   commands=[v['command']for v in events];expected=([tracks[case['source_route_bytes'][2]]]if case['tag']<0x80 else[0xb8,0x8f,0xb8])+[case['expected_exit_music']]*2
   if commands!=expected:native_mismatches.append({'tag':case['tag'],'skip':case['skip'],'got':commands,'want':expected})
   assert e.memory[sym['world_map_id']]==case['final_state']['map']
   native.append({'tag':case['tag'],'skip':case['skip'],'audio':events.copy(),'expected_commands':expected,'frames':frames,'arrival_music_physical_audio_frames':(events[-1]['audio_frame']-events[-2]['audio_frame'])&65535,'rpg_state_unchanged':True,'guard64_preserved':True,'final_position':[e.memory[sym['world_map_id']],read_word(e,sym['player_x']),read_word(e,sym['player_y'])]})
   print('native',case['tag'],case['skip'],commands,flush=True)
 finally:e.stop(save=False)
 if args.expect_mismatch:
  assert table_mismatches==[{'map':14,'native':0x88,'source':0x87}]
  assert [(m['tag'],m['skip'])for m in mismatches]==[(3,False),(3,True)]
  assert [(m['tag'],m['skip'])for m in native_mismatches]==[(3,False),(3,True)]
 else:assert not table_mismatches and not mismatches and not native_mismatches
 report={'passed':not(table_mismatches or mismatches or native_mismatches),'expected_negative_control_confirmed':args.expect_mismatch,'source_rom_sha256':SHA,'source_symbols_sha256':sha(ROOT/'build/sms-reference/ps1built.sym'),'source_DD9_tracks':tracks,'source_file':str(source.relative_to(ROOT)),'source_file_sha256':sha(source),'snapshot_manifest_sha256':sha(snap/'MANIFEST.json'),'production_reference_header':cartridge_header(snap/'build/phantasy-star-gbc-world.gbc'),'probe_header':cartridge_header(rom),'objects_sha256':objects,'host_cases':host,'native_cases':native,'table_mismatches':table_mismatches,'host_mismatches':mismatches,'native_mismatches':native_mismatches,'probe_static_end':hex(end),'scope':'Explicit 14 route requests with normal and alternating skip input; production game_sequence, renderer, audio and enter_map. All source DD9 table bytes checked. Not a campaign.'}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':report['passed'],'negative_control':args.expect_mismatch,'host_cases':len(host),'native_cases':len(native),'rom':report['probe_header']['sha256']}))
if __name__=='__main__':main()
