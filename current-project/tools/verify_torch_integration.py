#!/usr/bin/env python3
"""Actual Laerma Tree event/menu chronology from explicit SRAM fixtures.

No item, event, palette, or outcome writes occur after Continue. Original-Z80
inventory and effect ordering is checked separately by verify_torch_source.py.
"""
from pathlib import Path
import argparse,hashlib,json,re,shutil,tempfile
from verify_story_ui import read_save_record,save_record,seal_save,save_record_size,Session,crc16
from verify_rom import load_symbols,cartridge_header,finish_new_game_intro,capture
ROOT=Path(__file__).resolve().parents[1]

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('rom',type=Path);p.add_argument('--output',type=Path,default=ROOT/'build/verification/torch-integration');a=p.parse_args()
 out=a.output;out.mkdir(parents=True,exist_ok=True);rom=a.rom.resolve();s=load_symbols(rom.with_suffix('.noi'))
 local_file=rom.with_suffix('.main.sym')
 if not local_file.exists():local_file=rom.parent/'obj/main.sym'
 local={m[1]:int(m[2],16)for m in re.finditer(r'^\s*2 _([A-Za-z0-9_]+)\s+([0-9A-Fa-f]+) R?G?R?$',local_file.read_text(),re.M)}
 bases={s[n]-v for n,v in local.items()if n in s};assert len(bases)==1;b=bases.pop();s.update({n:b+v for n,v in local.items()if n not in s})
 report={'header':cartridge_header(rom),'cases':[],'screenshots':[],'campaign_complete':False,'injected_fixtures':['Source NewGame save patched only for map/position, inventory and IceDigger vehicle mode; CRC recomputed. Party, flags, money and RNG retain NewGame values.','Read-only hooks record function boundaries/audio commands. No runtime game-state writes.'],'native_adaptation':'The five-row native dialogue window is hidden together, followed by the original six close VBlanks; the SMS restores six half-glyph rows progressively.'}
 with tempfile.TemporaryDirectory(prefix='ps-torch-ui-')as temp:
  temp=Path(temp)
  def session(name):
   folder=temp/name;folder.mkdir();path=folder/'game.gbc';shutil.copyfile(rom,path);return Session(path,s,out,report)
  q=session('newgame');q.press('start');finish_new_game_intro(q.e,s);q.wait(lambda:q.state()==1,'NewGame');q.press('select');q.wait(lambda:q.state()==8,'Save');q.e.memory[0]=10;base=read_save_record(q.e);q.e.memory[0]=0;q.close();assert len(base)==save_record_size(base)
  cases=[('off_event',[47,56],0,False),('pot_absent',[47,35],0,True),('pot_absent_nuts_present',[49,47,35],1,True),('pot_present',[47,56,35],0,True),('nuts_present',[56,49,47,35],2,True),('selected_duplicate',[47,56,47,35,39],2,True),('full_inventory',[47,56,35]+[39]*21,0,True),('full_inventory_nuts_present',[47,56,49,35]+[39]*20,0,True)]
  for name,items,slot,tree in cases:
   q=session(name);record=bytearray(base)
   if tree:record[4:10]=bytes((2,3))+(4*16+8).to_bytes(2,'little')+(4*16+16).to_bytes(2,'little');record[623]=12
   record[74:98]=bytes(items)+bytes(24-len(items));record[98]=len(items);seal_save(record);q.install(record)
   if tree:q.press('right',2);q.wait(lambda:q.state()==2,'Laerma Tree event175');assert q.e.memory[s['game_events']+260]==175,('event',q.e.memory[s['game_events']+260])
   events=[];frames=[];recording=[False]
   def snap(kind):
    return {'kind':kind,'frame':q.tick_count,'audio_frame':q.word('audio_frames'),'items':q.items(),'state':q.state(),'window_visible':bool(q.e.memory[0xff40]&32),'phase':q.e.memory[s['field_action']+7],'field_active':q.byte('field_active')}
   def hook(kind):
    if recording[0]:
     value=snap(kind)
     if kind=='sound':value['command']=q.e.memory[q.e.register_file.SP+6]
     events.append(value)
   for label,kind in [('field_torch_reply','reply_commit'),('field_torch_finish','award_commit'),('presentation_begin','effect_begin'),('audio_command','sound')]:
    addr=s[label];q.e.hook_register(addr>>16,addr&65535,hook,kind)
   recording[0]=True;q.use(slot);q.wait(lambda:q.state()==4 and not q.revealing(),'B458 ready');assert q.word('dialogue')==0xb458 and q.items()==items
   events.append({**snap('dialogue'),'text':q.word('dialogue')});q.e.button_release('a');q.tick(2);q.e.button_press('a');q.tick(1);q.e.button_release('a')
   expected_reply=0xb471 if tree and 56 in items else 0xb49a if tree else 0xb312
   q.wait(lambda:q.state()==4 and q.word('dialogue')==expected_reply and not q.revealing(),'Torch reply');events.append({**snap('dialogue'),'text':q.word('dialogue')})
   consumed=items[:slot]+items[slot+1:]if tree and 56 in items else items
   assert q.items()==consumed,(name,'reply inventory',q.items(),consumed)
   if tree:assert q.word('presentation_frame')==1
   while not q.e.memory[s['dialogue']+12]:
    q.press('a',2);q.wait(lambda:q.state()==4 and not q.revealing(),'reply next page');assert q.items()==consumed
   report['screenshots'].append(capture(q.e,out/(name+'-reply.png')))
   q.e.button_release('a');q.tick(2);q.e.button_press('a')
   for frame in range(100):
    q.tick();frames.append(snap('close_frame'))
    if frame==0:q.e.button_release('a')
    if q.state()==2:break
   else:raise AssertionError((name,'close did not return',frames[-4:],events))
   final=consumed+([49]if tree and 56 in items and 49 not in consumed else[])
   assert q.items()==final,(name,'final inventory',q.items(),final)
   closing=[f for f in frames if f['field_active'] and not f['window_visible']]
   assert len(closing)==6,(name,'six close frames',len(closing),frames)
   assert all(f['items']==consumed for f in closing)
   if tree:
    effect=next(e for e in events if e['kind']=='effect_begin');reply=next(e for e in events if e['kind']=='reply_commit')
    assert effect['items']==items and reply['items']==items and effect['window_visible'] and reply['window_visible']
    assert (reply['audio_frame']-effect['audio_frame'])&65535==1,(name,'effect VBlank',effect,reply)
   sounds=[e['command']for e in events if e['kind']=='sound']
   assert sounds==([179]if final!=consumed else[]),(name,sounds)
   awards=[e for e in events if e['kind']=='award_commit']
   if tree:assert len(awards)==1 and awards[0]['items']==consumed
   report['cases'].append({'name':name,'initial_items':items,'selected_slot':slot,'tree_event':tree,'reply':hex(expected_reply),'final_items':final,'events':events,'close_frames':frames});q.close()
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'rom_sha256':report['header']['sha256'],'cases':len(report['cases'])}))
if __name__=='__main__':main()
