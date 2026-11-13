from pathlib import Path
import sys,json,hashlib
ROOT=Path.cwd();sys.path.insert(0,str(ROOT/'tools'))
from ending_reference import Ending,ROM
from extract_scenes import label,SHA
class Oracle(Ending):
 def __init__(self):
  self.active=False;self.points=[];self.text=[];super().__init__()
  self.hooks={label(n):n for n in('PlayerMenu_Item','LABEL_1BEE','LABEL_1C15','LABEL_3BC5','GameMode_LoadMap','FadeOut2','FadeIn2','LABEL_C97','LABEL_34D5','CheckOptionSelect','ShowDialogue_B12')}
  for p in self.hooks:self.main.set_breakpoint(p)
 def run(self,c,pc,sp):
  c.pc=pc;c.sp=sp;c.memory[sp:sp+2]=b'\0\1'
  for _ in range(20000):
   c.ticks_to_stop=500000;c.run()
   if c.pc==0x100:return
   if c is not self.main or c.pc not in self.hooks:continue
   at=c.pc;name=self.hooks[at]
   if self.active:self.points.append({'name':name,'frame':len(self.frames),'phase':c.memory[0xc21d],'music':c.memory[0xc2f4],'vehicle':c.memory[0xc30e],'mode':c.memory[0xc202],'a':c.a})
   if name in('LABEL_34D5','CheckOptionSelect','ShowDialogue_B12'):
    if name=='ShowDialogue_B12':self.text.append(c.hl)
    else:c.a=0;c.c=0
    c.pc=c.memory[c.sp]|c.memory[c.sp+1]<<8;c.sp+=2
   else:
    c.clear_breakpoint(at);c.ticks_to_stop=1;c.run();c.set_breakpoint(at)
  raise AssertionError(('source hang',hex(c.pc),len(self.frames)))
def main():
 assert hashlib.sha256(ROM).hexdigest()==SHA;cases=[]
 for phase in range(4):
  s=Oracle();c=s.main;c.memory[0xc301:0xc303]=bytes((0xd0,4));c.memory[0xc305:0xc307]=bytes((0x30,3));c.memory[0xc308:0xc30a]=bytes(2);c.memory[0xc400:0xc403]=bytes((1,16,0));c.memory[0xc406]=16;c.memory[0xc202]=8
  s.run(c,label('GameMode_LoadMap'),0xdffc);assert c.memory[0xc202]==9
  for action in('board','dismount'):
   s.points=[];s.frames=[];s.logs=[];s.audio=[];s.text=[];s.active=True
   c.memory[0xc21d]=phase;c.memory[0xc202]=13;c.memory[0xc29e]=1;c.memory[0xc29d]=0;c.memory[0xc2db]=0;c.memory[0xc2e9]=0;c.memory[0xc2d8]=0;c.memory[0xc2c4]=33;c.memory[0xc4e2]=1;c.memory[0xc4c0]=33
   s.run(c,label('PlayerMenu_Item'),0xdffc);assert c.memory[0xc30e]==(4 if action=='board'else 0) and c.memory[0xc2d8]==255
   s.run(c,label('LABEL_1BEE'),0xdffc);assert c.memory[0xc202]==13
   s.run(c,label('LABEL_3BC5'),0xdffc);assert c.memory[0xc202]==8
   start=len(s.frames);s.run(c,label('GameMode_LoadMap'),0xdffc);assert c.memory[0xc202]==9
   assert sum(p['name']=='GameMode_LoadMap'for p in s.points)==1
   assert sum(p['name']=='FadeOut2'for p in s.points)==1 and sum(p['name']=='FadeIn2'for p in s.points)==1
   cases.append({'action':action,'initial_phase':phase,'reload_frames':len(s.frames)-start,'final_phase':c.memory[0xc21d],'final_music':c.memory[0xc2f4],'audio':s.audio,'points':s.points,'dialogue_addresses':s.text,'wait_commands':[p[-1]for p in s.logs[start:]],'source_vehicle':c.memory[0xc30e]});s.active=False
 denied=[]
 for name,map_id,x,y,vehicle in(('town-denied',4,1688,304,0),('blocked-dismount',0,8,16,4)):
  s=Oracle();c=s.main;cx=(x-136)%2048;cy=(y-112)%1536
  c.memory[0xc301:0xc303]=cx.to_bytes(2,'little');c.memory[0xc305:0xc307]=bytes((cy%192,cy//192));c.memory[0xc308]=ROM[0xdc1+map_id];c.memory[0xc309]=map_id;c.memory[0xc400:0xc403]=bytes((1,16,0));c.memory[0xc406]=16;c.memory[0xc30e]=vehicle;c.memory[0xc202]=8
  s.run(c,label('GameMode_LoadMap'),0xdffc);s.active=True;s.points=[];s.text=[];s.frames=[];s.audio=[]
  c.memory[0xc202]=13;c.memory[0xc29e]=1;c.memory[0xc29d]=0;c.memory[0xc2d8]=0;c.memory[0xc2c4]=33;c.memory[0xc4e2]=1;c.memory[0xc4c0]=33
  position=bytes(c.memory[0xc300:0xc307]);s.run(c,label('PlayerMenu_Item'),0xdffc)
  assert c.memory[0xc30e]==vehicle and c.memory[0xc2d8]==0 and c.memory[0xc202]==13 and bytes(c.memory[0xc300:0xc307])==position
  assert not any(p['name']in('GameMode_LoadMap','FadeOut2','FadeIn2')for p in s.points)
  denied.append({'case':name,'loads':0,'vehicle_preserved':vehicle,'position_preserved':True,'deferred_request':0,'interaction_mode':13,'dialogue_addresses':s.text,'points':s.points})
 out=ROOT/'build/verification/vehicle-map-reload-source';out.mkdir(parents=True,exist_ok=True);r={'passed':True,'original_sha256':SHA,'cases':cases,'denied':denied,'scope':'Original PlayerMenu_Item, source vehicle geometry, item mutation, closure and1BEE→1C15→3BC5 routing execute. Text rendering and option selectors return their explicitly selected input (Landrover USE); source close-row waits execute. Full LoadMap, fades, VBlank and actor/graphics routines execute; score driver is stubbed with command writes recorded.'};(out/'report.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({'passed':True,'success_cases':len(cases),'denied_cases':len(denied)}))
if __name__=='__main__':main()
