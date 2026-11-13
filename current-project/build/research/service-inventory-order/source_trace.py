#!/usr/bin/env python3
"""Execute pinned original handlers; UI hooks expose source mutation boundaries."""
from pathlib import Path
import sys,json,hashlib
ROOT=Path(__file__).resolve().parents[3]
sys.path.insert(0,str(ROOT/'tools'))
import z80
from audit_battle_item_timeline import ROM,SHA,ADDR,TEXT

def trace(kind,**kw):
 c=z80.Z80Machine();c.memory[:0x8000]=ROM[:0x8000]
 c.memory[0x8000:0xc000]=ROM[32768:49152]
 actor=kw.get('actor',0);slot=kw.get('slot',0);item=kw.get('item',1)
 inv=kw.get('inventory',[1,36]);hp=kw.get('hp',7);mp=kw.get('mp',1)
 for i in range(4):c.memory[0xc400+i*16:0xc410+i*16]=bytes([1,hp,mp,0,0,2,100,30,10,10,0,0,0,0,0,0])
 p=0xc400+actor*16;c.memory[p]=kw.get('alive',1)
 c.memory[p+6]=kw.get('max_hp',100);c.memory[p+7]=kw.get('max_mp',30)
 c.memory[p+10]=kw.get('old',0)
 c.memory[0xc4c0:0xc4d8]=bytes((inv+[0]*24)[:24]);c.memory[0xc4e2]=len(inv)
 c.memory[0xc4e0:0xc4e2]=kw.get('money',1000).to_bytes(2,'little')
 c.memory[0xc4f0]=kw.get('members',3);c.memory[0xc2c4]=item
 c.memory[0xc29b:0xc29d]=(0xc4c0+slot).to_bytes(2,'little')
 c.memory[0xc2ec]=kw.get('secret_count',2)
 c.memory[0xc80f]=0x3d;c.memory[0xc2e1:0xc2e3]=bytes((0,0xc5));c.memory[0xc2dd:0xc2df]=(10).to_bytes(2,'little');c.memory[0xc2df]=item
 c.memory[0xc100:0xc103]=bytes([item])+kw.get('price',30).to_bytes(2,'little')
 entries={'hospital':'LABEL_2999','church':'LABEL_2A98','add':'Inventory_AddItem','equip':'ItemAction_Equip','drop':'ItemAction_Drop','secret':'LABEL_2C46','shop':'LABEL_2BDC','chest':'LABEL_28EE'}
 c.pc=ADDR(entries[kind]);c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\x00\x01';c.hl=(kw.get('money',1000)-200)&65535
 events=[];waits=0;selections=iter(kw.get('select',[actor]));answers=iter(kw.get('answers',[True,False]));replacements=iter(kw.get('replace',[slot]));selected=0
 def state():return {'money':int.from_bytes(c.memory[0xc4e0:0xc4e2],'little'),'hp':c.memory[p+1],'mp':c.memory[p+2],'status':c.memory[p],'count':c.memory[0xc4e2],'inventory':list(c.memory[0xc4c0:0xc4d8]),'equipment':list(c.memory[p+10:p+13]),'actor_hidden':c.memory[0xc900]==0xd0}
 def write(a,v):
  c.memory[a]=v
  if a==0xffff:c.memory[0x8000:0xc000]=ROM[v*16384:(v+1)*16384]
  if a==0xc004:events.append({'kind':'sound','value':f'{v:02X}',**state()})
 c.set_write_callback(write)
 for a in (0xffff,0xc004):c.mark_addr(a,c.WRITE_MARK)
 hooks={ADDR('ShowDialogue_B12'):'text',ADDR('ShowDialogue_B2'):'text2',ADDR('ShowYesNoPrompt'):'prompt',ADDR('LABEL_18B9'):'chest_animation',ADDR('LABEL_38D9'):'goods',ADDR('LABEL_3665'):'party',ADDR('LABEL_3656'):'replace',ADDR('LABEL_3464'):'close6',ADDR('LABEL_36BB'):'party_close',ADDR('LABEL_3707'):'equipment_panel',ADDR('LABEL_374D'):'equipment_close8',ADDR('WaitForButton1Or2'):'button',ADDR('WaitForVInt'):'wait',ADDR('LABEL_39E9'):'money_panel',ADDR('LABEL_39F7'):'money_update',ADDR('LABEL_3A12'):'money_close',ADDR('LABEL_34D5'):'inventory_open',ADDR('LABEL_3999'):'shop_close',ADDR('UpdateCharStats'):'refresh'}
 for a in [0x100,*hooks]:c.set_breakpoint(a)
 for loop in range(500):
  c.ticks_to_stop=100000;c.run()
  if c.pc==0x100:break
  assert c.pc in hooks,(kind,kw,hex(c.pc))
  h=hooks[c.pc]
  if h=='text':
   v=f'{TEXT[c.hl]:04X}';events.append({'kind':'text','value':v,**state()})
   # End a service iteration at its next-action prompt; do not synthesize more customers.
   if v in ('B90A','B9E5','BA3C') or (v=='B925' and selected):break
  elif h=='text2':events.append({'kind':'text','value':f'{c.hl:04X}',**state()})
  elif h=='prompt':
   yes=next(answers,False);c.a=0 if yes else 1;c.f=(c.f&~64)|(64 if yes else 0)
   events.append({'kind':'answer','value':yes,**state()})
  elif h=='party':
   value=next(selections,255);selected+=1;c.a=0 if value==255 else value;c.c=0x10 if value==255 else 0
   events.append({'kind':'select','value':value,**state()})
  elif h=='goods':
   c.hl=0xc100;c.c=0x10 if kw.get('cancel') else 0;events.append({'kind':'goods',**state()})
  elif h=='replace':
   value=next(replacements,255);c.c=0x10 if value==255 else 0
   if value!=255:
    c.memory[0xc29b:0xc29d]=(0xc4c0+value).to_bytes(2,'little');c.memory[0xc2c4]=c.memory[0xc4c0+value]
   events.append({'kind':'replace','value':value,**state()})
  elif h=='wait':
   waits+=1;events.append({'kind':'wait','value':c.a,**state()});c.memory[0xc205]=0x10 if waits==kw.get('skip',-1) else 0;c.a=0;c.f|=64
  else:events.append({'kind':h,**state()})
  c.pc=int.from_bytes(c.memory[c.sp:c.sp+2],'little');c.sp+=2
 else:raise AssertionError(('not finished',kind,kw,hex(c.pc)))
 return {'kind':kind,'inputs':kw,'events':events,'final':state()}

def main():
 cases=[]
 def add(kind,**kw):
  t=trace(kind,**kw);cases.append(t);return t
 for actor in range(4):
  for hp,mp,money,alive in [(7,1,1000,1),(100,30,1000,1),(0,0,1000,0),(7,1,0,1)]:add('hospital',actor=actor,hp=hp,mp=mp,money=money,alive=alive)
 add('hospital',max_hp=255,max_mp=10,hp=1,mp=0,money=8)
 add('hospital',answers=[False]);add('hospital',select=[255]);add('hospital',members=0)
 for actor in range(4):
  for money,alive,skip in [(40,0,-1),(39,0,-1),(40,0,1),(40,0,7),(1000,1,-1)]:add('church',actor=actor,money=money,alive=alive,hp=0,skip=skip)
 add('church',members=0);add('church',answers=[False]);add('church',select=[255])
 for item in (1,4,17,20,25,36,56):
  for actor in range(4):add('equip',item=item,inventory=[item,36],actor=actor)
 add('equip',item=1,inventory=[1,36],old=2);add('equip',item=1,inventory=[1,36],alive=0);add('equip',item=1,inventory=[1,36],select=[255])
 for item in (1,36,56):add('drop',item=item,inventory=[item,36])
 for inv in ([],[36],[36]*23,[36]*24):add('add',item=36,inventory=inv,answers=[False,True])
 add('add',item=37,inventory=[36]*24,answers=[True],replace=[0])
 add('add',item=37,inventory=[56]+[36]*23,answers=[True],replace=[0,1])
 add('add',item=37,inventory=[36]*24,answers=[True,False,True],replace=[255])
 for count in (0,1,2):
  for inv in ([],[51]):add('secret',inventory=inv,secret_count=count)
 for item,inv,money,cancel in [(25,[],1000,False),(25,[25],1000,False),(33,[],10000,False),(33,[33],10000,False),(25,[36]*24,1000,False),(25,[],0,False),(25,[],1000,True)]:
  add('shop',item=item,inventory=inv,money=money,price=5200 if item==33 else 30,cancel=cancel,answers=[False])
 for item,inv,answers,replace in [(38,[],[],[]),(38,[38],[],[]),(38,[56]+[36]*23,[True],[1]),(38,[56]+[36]*23,[True,True],[0,255,1]),(38,[36]*24,[False,True],[]),(0,[],[],[])]:
  add('chest',item=item,inventory=inv,answers=answers,replace=replace)
 for t in cases:
  sounds=[e for e in t['events'] if e['kind']=='sound']
  if t['kind']=='hospital':
   for e in sounds:
    assert e['value']=='C1' and e['hp']==t['inputs'].get('hp',7)
    assert next(x for x in t['events'] if x['kind']=='text' and x['value']=='B938')['hp']==t['inputs'].get('max_hp',100)
  if t['kind']=='church' and sounds:
   assert [e['value'] for e in sounds]==['C5']
   waits=[e for e in t['events'] if e['kind']=='wait'];assert len(waits)==(t['inputs']['skip'] if t['inputs']['skip']>0 else 30)
  if t['kind'] in ('equip','drop'):assert not sounds
  if t['kind']=='add' and sounds:assert [e['value'] for e in sounds]==['B3']
  if t['kind']=='chest':
   assert t['events'][-1]['kind']=='close6'and t['events'][-1]['actor_hidden']
  if t['kind']=='shop':
   k=t['inputs'];success=not k['cancel'] and len(k['inventory'])<24 and k['money']>=k['price'];added=success and not(k['item']==33 and 33 in k['inventory'])
   assert [e['value']for e in sounds]==(['B3']if added else[])
   assert t['final']['money']==k['money']-(k['price']if success else 0)
   assert t['final']['count']==len(k['inventory'])+int(added)
 out=Path(__file__).resolve().parent
 (out/'source-traces.json').write_text(json.dumps(cases,indent=2)+'\n')
 report={'source_sha256':SHA,'script_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'cases':len(cases),'passed':True,'hooks':'Original handlers and state mutations execute. Text/UI/selectors return with recorded fixture choices; original2D33 loop executes all WaitForVInt iterations. UpdateCharStats entry recorded, not executed. Service traces stop at next-action prompt. Exact native presentation is separate proof.'}
 (out/'source-report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
