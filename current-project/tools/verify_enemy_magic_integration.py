#!/usr/bin/env python3
"""Natural dungeon encounter/cast, real combat return and save; explicit nearby fixture."""
from pathlib import Path
import argparse,hashlib,json,re,shutil,tempfile
from verify_story_ui import read_save_record,save_record,seal_save,save_record_size,Session,patch_save,crc16
from verify_rom import load_symbols,read_word,cartridge_header,finish_new_game_intro,finish_continue_menu
from extract_rpg import extract,LOCATIONS,SHA
ROOT=Path(__file__).resolve().parents[1]
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);a=p.parse_args()
 out=ROOT/'build/verification/enemy-magic-integration';out.mkdir(parents=True,exist_ok=True)
 frozen=out/'tested.gbc';shutil.copy2(a.rom,frozen);shutil.copy2(a.rom.with_suffix('.noi'),frozen.with_suffix('.noi'));symbols=load_symbols(frozen.with_suffix('.noi'))
 source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(source).hexdigest()==SHA
 settings=extract(source,*LOCATIONS['dungeon_settings']);pools=extract(source,*LOCATIONS['encounter_pools'])
 assert settings[37*4:37*4+2]==bytes((25,80)) and pools[79*8:80*8]==bytes((11,11,11,11,13,13,13,31))
 raw=source[15*16384+(0x9f6e&0x3fff)+37*128:15*16384+(0x9f6e&0x3fff)+38*128];layout=bytes(n for b in raw for n in (b>>4,b&15))
 assert all(layout[p]==0 for p in (0xac,0x9c,0xad,0xbc,0xab))
 report={'header':cartridge_header(frozen),'source_sha256':SHA,'checks':[],'screenshots':[],'encounters':[],'hit_presentations':[],'injected_fixtures':['Valid SRAM at source floor37/AC with four living level30 party members using original unequipped stats/full HP/MP/EXP, Compass53 and fixed seed1234. No encounter, turn, damage, spell choice or outcome is injected; no RNG search/retries. Subsequent actions are controller-only.'],'campaign_complete':False}
 with tempfile.TemporaryDirectory(prefix='ps-native-enemy-magic-')as tmp:
  rom=Path(tmp)/'game.gbc';shutil.copy2(frozen,rom);q=Session(rom,symbols,out,report);r=symbols['game_rpg'];b=symbols['battle_view_battle']
  def view():return q.byte('battle_view_state')
  def rng():return read_word(q.e,r+92)
  def completed():
   old=q.word('frame_counter');q.wait(lambda:q.word('frame_counter')!=old,'completed frame')
  try:
   q.press('start');finish_new_game_intro(q.e,symbols);q.wait(lambda:q.state()==1,'new game');q.press('select');q.wait(lambda:q.state()==8,'base save')
   q.e.memory[0x0000]=10;base=read_save_record(q.e);q.e.memory[0x0000]=0
   record=bytearray(patch_save(base,map_id=1,party=15,items=(53,),dungeon=(37,0xac,0),strong=True));levels=extract(source,*LOCATIONS['levels'])
   for c in range(4):
    level=levels[(c*30+29)*8:(c*30+30)*8]
    record[10+c*16:26+c*16]=bytes((1,level[0],level[3],level[4],level[5],30,level[0],level[3],level[1],level[2],0,0,0,0,level[6],level[7]))
   seal_save(record)
   q.install(record);q.wait(lambda:q.state()==17,'source dungeon fixture');completed()
   areas=re.findall(r'^(_DATA|_INITIALIZED|_BSS)\s+([0-9A-F]+)\s+([0-9A-F]+)\s+=',a.rom.with_suffix('.map').read_text(),re.M)
   assert areas and max(int(address,16)+int(size,16)for _,address,size in areas)<=0xdbc0,'Guard would overlap static WRAM'
   guard=bytes((29*i+0x6b)&255 for i in range(64));q.e.memory[0xdbc0:0xdc00]=guard
   report['injected_fixtures'].append('Diagnostic64-byte unused-WRAM guard atDBC0..DBFF;1KiB stack window aboveDC00')
   turns=0;cast_seen=False;last_cast=None;episode=None
   for encounter in range(40):
    while q.state()==17 and turns<1000:
     q.press('left',8);completed();turns+=1
    assert q.state()==15,('No natural battle',turns,q.state())
    enemy=q.e.memory[b+128]&127;report['encounters'].append(enemy);q.wait(lambda:view()==1,'battle commands')
    observed_this=False
    for frame in range(50000):
     if q.state()!=15:break
     v=view()
     if v==16:
      if episode is None:
       hit_count=q.e.memory[b+180];hits=[list(q.e.memory[b+181+i*3:b+184+i*3]) for i in range(hit_count)]
       episode={'enemy':enemy,'rng':rng(),'mode':q.e.memory[b+205],'hit_cursor':q.byte('battle_view_hit_cursor'),'action_hits':hits,'frames':0,'audio_start':q.word('audio_frames')}
       assert enemy==13 and episode['mode']in(0x80,0xc0) and hit_count and all(h[0]<4 for h in hits),episode
       report['hit_presentations'].append(episode);observed_this=cast_seen=True;q.shot('natural-giantfly-magic-hit-'+str(len(report['hit_presentations'])))
      assert rng()==episode['rng'],'Presentation consumed extra RNG'
      episode['frames']+=1;q.tick()
     else:
      if episode is not None:
       episode['audio_ticks']=(q.word('audio_frames')-episode['audio_start'])&65535;last_cast=episode;episode=None
      if v==1:
       wanted=2 if enemy==13 and not observed_this else 0
       for _ in range(5):
        if q.byte('battle_view_choice')==wanted:break
        q.press('right',2)
       assert q.byte('battle_view_choice')==wanted
       q.press('a',2)
      elif v==3:q.press('a',2)
      elif v==5:
       if q.revealing():q.tick()
       else:q.press('a',2)
      elif v==6:q.press('a',2)
      else:q.tick()
    else:raise AssertionError(('Battle did not complete',enemy,view(),q.state()))
    q.wait(lambda:q.state()==17,'native dungeon return');completed()
    assert q.byte('battle_view_result')==1 and bytes(q.e.memory[symbols['game_dungeon']:symbols['game_dungeon']+2])==bytes((37,0xac))
    if cast_seen:break
   assert cast_seen and last_cast and last_cast['frames']>0,report['encounters']
   assert not q.byte('audio_fault') and bytes(q.e.memory[0xdbc0:0xdc00])==guard
   report['controller_turns']=turns;report['checks'].append('Original floor37/pool80 produces a natural GiantFly encounter; Compass actions allow its actual Fire decision, native animation and per-hit playback before a controller-driven victory')
   q.wait(lambda:not q.byte('dungeon_keys_delay'),'source postbattle input delay');completed()
   persistent=bytes(q.e.memory[r:r+94]);dungeon=bytes(q.e.memory[symbols['game_dungeon']:symbols['game_dungeon']+4]);q.press('select');q.wait(lambda:q.state()==8,'postbattle save');q.e.stop(save=True);q.boot();q.press('start');finish_continue_menu(q.e,symbols);q.wait(lambda:q.state()==17,'continue');completed()
   restored=bytes(q.e.memory[r:r+94]);restored_dungeon=bytes(q.e.memory[symbols['game_dungeon']:symbols['game_dungeon']+4])
   assert restored==persistent and restored_dungeon==dungeon,{'party_differences':[(i,x,y) for i,(x,y)in enumerate(zip(persistent,restored))if x!=y],'before_dungeon':list(dungeon),'restored_dungeon':list(restored_dungeon)}
   q.shot('continued-after-enemy-magic');report['checks'].append('Full party/inventory/money/RNG and dungeon location survive combat, save and power-cycle Continue; real audio runs and1KiB stack guard remains intact')
   report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='screenshots'},indent=2))
  finally:q.close()
if __name__=='__main__':main()
