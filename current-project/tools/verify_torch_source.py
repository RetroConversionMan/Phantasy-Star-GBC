#!/usr/bin/env python3
"""Execute original EclipseTorch dispatch, palette IRQ and inventory chronology.

Dialogue text drawing is a capture boundary. Original7CA6, inventory routines,
3464/3A57 six-row close and the actual selected VBlank handlers execute.
"""
import hashlib,json
from ending_reference import Ending,ROM,ROOT
from extract_scenes import label,SYMBOLS
from extract_dungeon_graphics import SHA
INV=0xc4c0;COUNT=0xc4e2;CURRENT=0xc2c4;DIALOGUE=0xc2d3
TEXTS={SYMBOLS['LABEL_B12_'+name][1]:name for name in('B458','B431','B312','B49A','B471')}
class Torch(Ending):
 def __init__(self):
  self.events=[];self.observe=False;super().__init__();self.main.memory[label('ShowDialogue_B12'):label('ShowDialogue_B12')+3]=bytes((0xd3,0xfb,0xc9))
 def snapshot(self,c):
  return {'inventory':list(c.memory[INV:INV+c.memory[COUNT]]),'count':c.memory[COUNT],'current_item':c.memory[CURRENT],'active_palette':list(c.memory[0xc220:0xc240]),'dialogue_open':c.memory[DIALOGUE]}
 def machine(self,irq):
  c=super().machine(irq)
  def write(address,value):
   old=c.memory[address];c.memory[address]=value
   if address==0xffff:c.memory[0x8000:0xc000]=ROM[value*16384:(value+1)*16384]
   if not irq and self.observe:
    kind='inventory_count'if address==COUNT else'current_item'if address==CURRENT else'close_begin'if address==DIALOGUE and not value else'sound'if address==0xc004 else None
    if kind:self.events.append({'kind':kind,'before':old,'value':value,**self.snapshot(c)})
   if address==0xc004 and not irq:self.audio.append((len(self.frames),value))
   if address==0xc2f5 and not irq:self.credits.append((len(self.frames),value))
  c.set_write_callback(write)
  for address in(COUNT,CURRENT,DIALOGUE):c.mark_addr(address,c.WRITE_MARK)
  return c
 def output(self,c,port,value):
  if port&255==0xfb:
   assert c==self.main and c.hl in TEXTS,hex(c.hl)
   c.memory[DIALOGUE]=255;c.memory[0xffff]=12;c.memory[0x8000:0xc000]=ROM[12*16384:13*16384]
   self.events.append({'kind':'dialogue','text':TEXTS[c.hl],**self.snapshot(c)});return
  if port&255==0xfd and self.observe:
   event={'kind':'VBlank','command':value,**self.snapshot(c)};self.events.append(event);super().output(c,port,value);event['CRAM_after']=list(self.cram);return
  super().output(c,port,value)
def run_case(name,items,slot,battle,event_id,reply):
 s=Torch();c=s.main;c.memory[INV:INV+24]=bytes(items)+bytes(24-len(items));c.memory[COUNT]=len(items);c.memory[CURRENT]=47;c.memory[0xc29b:0xc29d]=(INV+slot).to_bytes(2,'little');c.memory[0xc29d]=battle;c.memory[0xc2db]=event_id;c.memory[DIALOGUE]=0
 assert items[slot]==47;c.memory[0xc220:0xc240]=bytes(range(32));s.cram[:]=bytes(range(32));before=list(items);s.observe=True;s.run(c,label('ItemUse_EclipseTorch'),0xdffc)
 dialogs=[e for e in s.events if e['kind']=='dialogue'];waits=[e for e in s.events if e['kind']=='VBlank'];assert [e['text']for e in dialogs]==['B458',reply]
 assert dialogs[0]['inventory']==before
 effect=not battle and event_id==175;haspot=56 in items
 palette=list(range(32));palette[27:32]=ROM[label('LABEL_B03_BE4D'):label('LABEL_B03_BE4D')+5]
 assert [e['command']for e in waits]==([22]if effect else[])+[10]*6
 if effect:
  assert waits[0]['inventory']==before and waits[0]['active_palette']==palette and waits[0]['CRAM_after']==palette
  assert all(e['active_palette']==palette for e in waits)
 else:assert all(e['active_palette']==list(range(32))for e in waits)
 consumed=before[:slot]+before[slot+1:]if effect and haspot else before
 assert dialogs[1]['inventory']==consumed,(name,'Torch consumption before reply')
 closing=[e for e in s.events if e['kind']=='close_begin'];assert len(closing)==1 and closing[0]['inventory']==consumed
 assert all(e['inventory']==consumed for e in waits if e['command']==10),'Nuts changed before close completed'
 final=consumed+([49]if effect and haspot and 49 not in consumed else[])
 assert s.snapshot(c)['inventory']==final and c.memory[COUNT]==len(final)
 assert [e['value']for e in s.events if e['kind']=='sound']==([179]if final!=consumed else[])
 if final!=consumed:
  lastclose=max(i for i,e in enumerate(s.events)if e['kind']=='VBlank');add=next(i for i,e in enumerate(s.events)if e['kind']=='inventory_count'and e['value']>e['before']);assert add>lastclose
 return {'name':name,'initial_inventory':items,'selected_slot':slot,'battle':battle,'event_id':event_id,'final_inventory':final,'palette_effect':effect,'events':s.events}
def main():
 assert hashlib.sha256(ROM).hexdigest()==SHA
 cases=[run_case(*c)for c in(
  ('off_event',[47,56],0,0,0,'B312'),('battle_denial',[47,56],0,1,175,'B431'),('battle_precedes_event_denial',[47],0,1,0,'B431'),
  ('pot_absent',[47],0,0,175,'B49A'),('pot_absent_nuts_present',[49,47],1,0,175,'B49A'),('pot_present',[47,56],0,0,175,'B471'),
  ('nuts_already_present',[56,49,47],2,0,175,'B471'),('selected_middle_and_duplicate_torch',[47,56,47,39],2,0,175,'B471'),
  ('full_inventory',[47,56]+[39]*22,0,0,175,'B471'),('full_inventory_nuts_present',[47,56,49]+[39]*21,0,0,175,'B471'))]
 out=ROOT/'build/verification/torch-source';out.mkdir(parents=True,exist_ok=True)
 report={'passed':True,'source_sha256':SHA,'cases':cases,'effect_palette_address':'C23B..C23F','effect_values':list(ROM[label('LABEL_B03_BE4D'):label('LABEL_B03_BE4D')+5]),'chronology':'B458; battle/event gate; original7CA6 and one22(0x16)VBlank; Pot check; selected Torch removal only with Pot; B49A/B471; actual3464 six10(0x0A)VBlanks; add Nuts only after close and only when absent.','reference':'Original Z80 item handler,7CA6 palette writer,inventory helpers,3464/3A57 and selected VBlank handlers execute. Dialogue drawing alone is intercepted; controller and sound engine are not emulated by this oracle.'}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({**report,'cases':[{k:v for k,v in c.items()if k!='events'}for c in cases]},indent=2))
if __name__=='__main__':main()
