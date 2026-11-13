#!/usr/bin/env python3
"""Actual transition-composed UI; wait field menu fade; read-only runtime hooks."""
from pathlib import Path
import sys,argparse,json,hashlib,re,shutil,tempfile
ROOT=Path(__file__).resolve().parents[3];sys.path.insert(0,str(ROOT/'tools'))
from verify_story_ui import Session,patch_save as patch_save_v4,crc16
from verify_rom import load_symbols,cartridge_header,finish_new_game_intro,capture

def patch_save(base,**kw):
 version=base[3];assert version in(4,5)and len(base)==(626 if version==4 else 628)
 if version==4:return patch_save_v4(base,**kw)
 original=bytearray(base[:624]);original[3]=4;original+=crc16(original).to_bytes(2,'little')
 result=bytearray(patch_save_v4(bytes(original),**kw)[:624]);result[3]=5
 result+=base[624:626];result+=crc16(result).to_bytes(2,'little');return bytes(result)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--snapshot',type=Path,default=ROOT/'build/source-snapshots/service-inventory-candidate');ap.add_argument('--output',type=Path,default=ROOT/'build/verification/service-inventory-ui');args=ap.parse_args();snap=args.snapshot.resolve();out=args.output.resolve();out.mkdir(parents=True,exist_ok=True)
 original_rom=snap/'build/phantasy-star-gbc-world.gbc';rom=out/'tested.gbc';shutil.copyfile(original_rom,rom);shutil.copyfile(original_rom.with_suffix('.noi'),rom.with_suffix('.noi'));symbols=load_symbols(rom.with_suffix('.noi'))
 local={m[1]:int(m[2],16)for m in re.finditer(r'^\s*2 _([A-Za-z0-9_]+)\s+([0-9A-Fa-f]+) R?G?R?$',(snap/'build/obj/main.sym').read_text(),re.M)}
 bases={symbols[n]-v for n,v in local.items()if n in symbols};assert len(bases)==1;base=bases.pop();symbols.update({n:base+v for n,v in local.items()if n not in symbols})
 report={'header':cartridge_header(rom),'cases':[],'screenshots':[],'campaign_complete':False,'scope':'Actual composed item/service/event menus; waits for source outer fades. All audio commands remain recorded; service/award assertions exclude verified outer music and D6/D8. After explicit source-valid version4/626-byte or version5/628-byte SRAM fixtures. After Continue only controller input and a diagnostic64-byte stack guard are written. Read-only hooks record original message/audio/state boundaries.','source_sha256':'9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'}
 guard=bytes((0x93+i*19)&255 for i in range(64))
 with tempfile.TemporaryDirectory(prefix='ps-service-item-')as temp:
  temp=Path(temp)
  def new(name):
   d=temp/name;d.mkdir();p=d/'game.gbc';shutil.copyfile(rom,p);return Session(p,symbols,out,report)
  q=new('base');q.press('start');finish_new_game_intro(q.e,symbols);q.wait(lambda:q.state()==1,'NewGame');q.press('select');q.wait(lambda:q.state()==8,'Save');q.e.memory[0]=10;base=bytes(q.e.memory[0xa000:0xa000+(628 if q.e.memory[0xa003]==5 else 626)]);q.e.memory[0]=0;q.close()
  def setup(name,items=(),actor=0,hp=7,mp=1,alive=1,money=1000,old=0,members=15,map_id=4,x=105,y=18,max_hp=100,max_mp=30,secrets=0):
   q=new(name);r=bytearray(patch_save(base,party=members,items=items,map_id=map_id,x=x*16+8,y=y*16+16));p=10+actor*16
   r[p:p+16]=bytes([alive,hp,mp,0,0,2,max_hp,max_mp,10,10,old,0,0,0,0,0]);r[100:102]=money.to_bytes(2,'little');r[360]=secrets;r[-2:]=crc16(r[:-2]).to_bytes(2,'little');q.install(r)
   assert q.state()==1,(name,'setup',q.state());q.e.memory[0xdbc0:0xdc00]=guard;events=[]
   def state(kind):
    p=symbols['game_rpg']+actor*16
    return {'kind':kind,'clock':q.word('audio_frames'),'screen':q.state(),'hp':q.e.memory[p+1],'mp':q.e.memory[p+2],'status':q.e.memory[p],'equipment':list(q.e.memory[p+10:p+13]),'money':int.from_bytes(bytes(q.e.memory[symbols['game_rpg']+90:symbols['game_rpg']+92]),'little'),'items':q.items(),'field_active':q.byte('field_active')}
   def hook(kind):
    e=state(kind)
    if kind=='text':e['value']=int.from_bytes(bytes(q.e.memory[q.e.register_file.SP+8:q.e.register_file.SP+10]),'little')
    if kind=='sound':e['value']=q.e.memory[q.e.register_file.SP+6]
    if kind=='service_advance':e['action']=q.e.memory[symbols['game_service']+8]
    events.append(e)
   for label,kind in [('dialogue_open','text'),('audio_command','sound'),('rpg_equip_finish','equip_commit'),('inventory_equipment_done','panel_close'),('inventory_screen','inventory'),('service_advance','service_advance')]:
    a=symbols[label];q.e.hook_register(a>>16,a&65535,hook,kind)
   return q,events,state
  def end(q,events,name,extra=None):
   assert bytes(q.e.memory[0xdbc0:0xdc00])==guard,(name,'guard');assert not q.byte('audio_fault')
   report['cases'].append({'name':name,'events':events,'final_items':q.items(),'guard64_preserved':True,**(extra or{})});q.close();(out/'progress.json').write_text(json.dumps({'passed_cases':len(report['cases']),'last':name}))
  def item_menu(q,action):
   q.press('start');q.wait(lambda:q.state()==2,'field menu fade');q.tick(30);q.press('down');q.press('down');q.press('a');assert q.state()==9;q.press('a');assert q.state()==10
   for _ in range(action):q.press('down')
   q.press('a',2)
  def drain(q,target,why):
   q.e.button_release('a')
   for frame in range(20000):
    if target():
     q.e.button_release('a')
     if q.state()in(5,6,7,11,14):q.tick(30)
     return
    if q.state()==4 and not q.revealing()and frame%24==0:q.e.button_press('a')
    else:q.e.button_release('a')
    q.tick()
   raise AssertionError((why,q.state(),hex(q.word('dialogue'))))
  def ready(q,id):q.wait(lambda:q.state()in(4,5) and q.word('dialogue')==id and not q.revealing(),f'text {id:04x}')
  def sounds(events):
   # Source outer transitions/idle now emit music and D6/D8. Preserve every
   # event in the report; award/service assertions concern their own effects.
   allowed={0xb3,0xc1,0xc5,0xd6,0xd8,*range(0x81,0x95)}
   actual=[e['value']for e in events if e['kind']=='sound'];assert all(v in allowed for v in actual),actual
   return [v for v in actual if v in(0xb3,0xc1,0xc5)]
  for name,item,actor,alive,old,cancel,text in [('equip_empty',1,0,1,0,False,0xb2b6),('equip_swap',1,0,1,2,False,0xb2b6),('equip_odin',1,2,1,0,False,0xb2b6),('equip_noah',4,3,1,0,False,0xb2b6),('equip_myau',20,1,1,0,False,0xb2b6),('equip_shield',25,0,1,0,False,0xb2b6),('equip_ineligible',17,0,1,0,False,0xb5de),('equip_dead',1,0,0,0,False,0xb730),('equip_nongear',36,0,1,0,False,0xb5f0),('equip_protected_nongear',56,0,1,0,False,0xb5f0),('equip_cancel',1,0,1,0,True,None)]:
   q,events,state=setup(name,[item,36],actor=actor,alive=alive,hp=7 if alive else 0,old=old);item_menu(q,1)
   if q.state()==11:
    for _ in range(actor):q.press('down',2)
    q.press('b'if cancel else'a',2)
   if cancel: q.wait(lambda:q.state()==9,'cancelled equipment');assert q.items()==[item,36]
   else:
    ready(q,text);assert [e['value']for e in events if e['kind']=='text']==[text]
    if text==0xb2b6:
     assert q.items()==[old if item==1 else 0,36],(name,'swap-before-text',q.items());drain(q,lambda:q.state()==30,'equipment panel')
     q.tick(40);assert q.state()==30,(name,'explicit button wait');q.shot(name+'-panel');q.press('a',2);q.wait(lambda:q.state()==9,'equipment finished')
     closes=[e for e in events if e['kind']=='panel_close'];commits=[e for e in events if e['kind']=='equip_commit'];assert len(closes)==len(commits)==1
     assert (commits[0]['clock']-closes[0]['clock'])&65535==14,(name,'8+6 close',events)
     assert commits[0]['items']==[old if item==1 else 0,36]
     assert q.items()==([old,36]if item==1 and old else[36])
    else:drain(q,lambda:q.state()==9,'denied equipment');assert q.items()==[item,36]
   assert not sounds(events),(name,sounds(events));end(q,events,name)
  for name,item,text in [('drop_ordinary',1,0xb2c2),('drop_duplicate',36,0xb2c2),('drop_protected',56,0xb6de)]:
   q,events,state=setup(name,[item,36]);item_menu(q,2);ready(q,text);assert q.items()==[item,36];q.shot(name);drain(q,lambda:q.state()==9,'drop finished');assert q.items()==([item,36]if item==56 else[36]);assert not sounds(events);end(q,events,name)
  for name,hp,mp,max_hp,max_mp,money,alive,choice in [('hospital_success',7,1,100,30,1000,1,'yes'),('hospital_wrap',1,0,255,10,8,1,'yes'),('hospital_no_money',7,1,100,30,0,1,'yes'),('hospital_decline',7,1,100,30,1000,1,'no'),('hospital_full',100,30,100,30,1000,1,'yes'),('hospital_dead',0,0,100,30,1000,0,'yes'),('hospital_cancel',7,1,100,30,1000,1,'cancel')]:
   q,events,state=setup(name,hp=hp,mp=mp,max_hp=max_hp,max_mp=max_mp,money=money,alive=alive,map_id=6,x=36,y=71)
   q.press('up',2);drain(q,lambda:q.state()==5,'hospital entry');q.press('a',2);drain(q,lambda:q.state()==11,'hospital selection');q.press('b'if choice=='cancel'else'a',2)
   if choice=='cancel':drain(q,lambda:q.state()==1,'hospital cancel')
   elif alive and(hp!=max_hp or mp!=max_mp):
    drain(q,lambda:q.state()==5,'hospital quote');
    if choice=='no':q.press('right',2)
    q.press('a',2)
    if choice=='yes'and money>=((max_hp-hp+max_mp-mp)&255):
     ready(q,0xb938);c1=next(e for e in events if e['kind']=='sound'and e['value']==0xc1);healed=next(e for e in events if e['kind']=='text'and e['value']==0xb938)
     assert c1['hp']==hp and c1['mp']==mp and c1['money']==money-((max_hp-hp+max_mp-mp)&255);assert healed['hp']==max_hp and healed['mp']==max_mp
    elif choice=='yes':ready(q,0xbd57);assert 0xc1 not in sounds(events)
    else:drain(q,lambda:q.state()==11,'hospital declined');assert 0xc1 not in sounds(events)
   else:
    ready(q,0xb730 if not alive else 0xb96b);assert 0xc1 not in sounds(events)
   end(q,events,name)
  for name,money,alive,skip in [('revival_fullwait',40,0,None),('revival_skip7',40,0,7),('revival_no_money',39,0,None),('revival_living',1000,1,None)]:
   q,events,state=setup(name,actor=1,hp=0 if not alive else 7,alive=alive,money=money,map_id=4,x=107,y=31)
   q.press('up',2);drain(q,lambda:q.state()==5,'church entry');q.press('a',2);drain(q,lambda:q.state()==11,'church party');q.press('down',2);q.press('a',2)
   if alive:ready(q,0xba56);assert 0xc5 not in sounds(events)
   else:
    drain(q,lambda:q.state()==5,'revival quote');q.press('a',2)
    if money<40:ready(q,0xbd9f);assert 0xc5 not in sounds(events)
    else:
     # Advance text one frame at a time, stopping when the C5 boundary occurs.
     held=False
     for frame in range(15000):
      if any(e['kind']=='sound'and e['value']==0xc5 for e in events):break
      if q.state()==4 and not q.revealing()and frame%24==0:q.e.button_press('a');held=True
      elif held:q.e.button_release('a');held=False
      q.tick()
     else:raise AssertionError((name,'no C5',events))
     q.e.button_release('a');c5=next(e for e in events if e['kind']=='sound'and e['value']==0xc5)
     if skip:
      while((q.word('audio_frames')-c5['clock'])&65535)<skip:q.tick()
      q.e.button_press('b');q.tick();q.e.button_release('b')
     q.wait(lambda:any(e['kind']=='service_advance'and e.get('action')==8 for e in events),'revival wait ends')
     done=next(e for e in events if e['kind']=='service_advance'and e.get('action')==8);assert ((done['clock']-c5['clock'])&65535)==(skip or 30),(name,'wait',c5,done)
     assert c5['hp']==100 and c5['status']==1 and c5['money']==0
   end(q,events,name)
  # Real Nekise event2 gives the Pot; full paths exercise original replacement UI.
  for name,items,mode in [('award_free',[],None),('award_full_replace',[36]*24,'replace'),('award_full_abandon',[36]*24,'abandon'),('award_protected_then_replace',[56]+[36]*23,'protected'),('award_cancel_replace',[36]*24,'cancel')]:
   q,events,state=setup(name,items=items,x=85,y=17);q.press('up',2);q.wait(lambda:q.state()!=1,'Nekise entered')
   if mode is None:
    drain(q,lambda:q.state()==1,'Nekise award');assert q.items()==[56],(name,q.items(),events);assert sounds(events)==[0xb3],(name,sounds(events),events)
   else:
    drain(q,lambda:q.state()==5,'inventory full')
    if mode=='abandon':q.press('right',2);q.press('a',2);drain(q,lambda:q.state()==5,'abandon question');q.press('a',2);drain(q,lambda:q.state()==1,'abandoned');assert not sounds(events);assert q.items()==items
    else:
     q.press('a',2);drain(q,lambda:q.state()==7,'replacement selector')
     if mode=='cancel':
      q.press('b',2);drain(q,lambda:q.state()==5,'cancel returns question');assert not sounds(events);q.press('a',2);drain(q,lambda:q.state()==7,'replacement again')
     if mode=='protected':q.press('a',2);ready(q,0xb6de);assert not sounds(events);drain(q,lambda:q.state()==7,'protected retry');q.press('down',2)
     q.press('a',2);ready(q,0xb69e);assert q.items()==items;drain(q,lambda:q.state()==1,'replaced award');assert sounds(events)==[0xb3];assert q.items()[1 if mode=='protected'else 0]==56
   end(q,events,name)
  for name,items,money,vehicle,cancel in [('shop_new',[],30,False,False),('shop_duplicate',[25],30,False,False),('shop_no_money',[],0,False,False),('shop_full',[36]*24,1000,False,False),('shop_cancel',[],30,False,True),('shop_vehicle_new',[],10000,True,False),('shop_vehicle_duplicate',[33],10000,True,False)]:
   q,events,state=setup(name,items=items,money=money,map_id=17 if vehicle else 4,x=70 if vehicle else 94,y=63 if vehicle else 26)
   q.press('up',2);drain(q,lambda:q.state()in(5,14),'shop entry');q.press('a',2);drain(q,lambda:q.state()==6,'shop goods');q.press('b'if cancel else'a',2)
   if cancel:ready(q,0xb7e3);assert not sounds(events);assert q.items()==items
   elif len(items)==24:ready(q,0xb813);assert not sounds(events);assert state('current')['money']==money
   elif money==0:ready(q,0xbd57);assert not sounds(events);assert not q.items()
   else:
    ready(q,0xb807);added=not(vehicle and 33 in items);assert sounds(events)==([0xb3]if added else[]),(name,events)
    assert q.items()==items+([33 if vehicle else 25]if added else[]);assert state('current')['money']==money-(5200 if vehicle else 30)
   end(q,events,name)
  for name,items in [('secrets_award',[]),('secrets_duplicate',[51])]:
   q,events,state=setup(name,items=items,money=200,map_id=13,x=86,y=77,secrets=2)
   q.press('up',2);drain(q,lambda:q.state()==14,'Secrets buy/sell');q.press('a',2);drain(q,lambda:q.state()==6,'Secrets goods');q.press('down',2);q.press('down',2);q.press('a',2)
   ready(q,0x142 if items else 0x146);assert sounds(events)==([]if items else[0xb3]);assert q.items()==[51];assert state('current')['money']==(200 if items else 0);end(q,events,name)
  q,events,state=setup('equip_single',items=[1,36],members=1);item_menu(q,1);ready(q,0xb2b6);assert not any(e['screen']==11 for e in events);drain(q,lambda:q.state()==30,'single equipment panel');q.tick(40);assert q.state()==30;q.press('a',2);q.wait(lambda:q.state()==9,'single equipment finish');assert q.items()==[36];end(q,events,'equip_single')
  q,events,state=setup('church_single_alive',members=1,map_id=4,x=107,y=31);q.press('up',2);drain(q,lambda:q.state()==5,'single church entry');q.press('a',2);ready(q,0xba56)
  drain(q,lambda:q.e.memory[symbols['game_service']+8]==8,'single alive extra wait');q.tick(40);assert not any(e['kind']=='text'and e['value']==0xba3c for e in events);q.press('b',2);ready(q,0xba3c);assert not sounds(events);end(q,events,'church_single_alive')
 report['source_files_sha256']={str(p.relative_to(snap)):hashlib.sha256(p.read_bytes()).hexdigest()for p in sorted((snap/'src').glob('*'))if p.is_file()}
 report['objects_sha256']={str(p.relative_to(snap)):hashlib.sha256(p.read_bytes()).hexdigest()for p in sorted((snap/'build/obj').glob('*.o'))}
 report['passed']=True;(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({'passed':True,'cases':len(report['cases']),'rom_sha256':report['header']['sha256']}))
if __name__=='__main__':main()
