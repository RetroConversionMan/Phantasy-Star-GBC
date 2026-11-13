#!/usr/bin/env python3
"""Native production SELL ABI and original prices, across every item/slot."""
from pathlib import Path
import hashlib,json,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,read_word,cartridge_header
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "services.h"
#include <string.h>
RPGState parties[4];EventState events;ServiceState service;
uint8_t probe_ready,probe_command,probe_party,probe_item,probe_slot,probe_error,probe_count,probe_stage,probe_kind,probe_inventory[24];
uint16_t probe_money,probe_price,probe_dialogue;
void main(void){
 RPGState *r;uint8_t i;const ServiceAction *a;
 cpu_fast();DISPLAY_OFF;probe_ready=1;
 while(1)if(probe_command){
  r=parties+probe_party;rpg_new_game(r);r->money=probe_money;r->inventory_count=24;
  for(i=0;i<24;i++)r->inventory[i]=ItemID_Cola;r->inventory[probe_slot]=probe_item;
  memset(&events,0,sizeof events);events.rpg=r;probe_error=0;
  service_begin(&service,&events,0x1a,7);service_advance(&service);service_select(&service,1);a=service_select(&service,probe_slot);
  probe_price=a->number;
  if(a->kind==SERVICE_YES_NO){
   service_respond(&service,0);
   if(r->inventory_count!=24||r->inventory[probe_slot]!=probe_item||r->money!=probe_money)probe_error=1;
   service_select(&service,probe_slot);a=service_respond(&service,1);
  }
  probe_count=r->inventory_count;probe_money=r->money;memcpy(probe_inventory,r->inventory,24);
  probe_stage=service.stage;probe_kind=a->kind;probe_dialogue=a->dialogue_id;probe_command=0;
 }
}
'''
def main():
 out=ROOT/'build/verification/service-sell';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN);rom=out/'service-sell.gbc'
 sources=[out/'main.c']+[ROOT/'src'/s for s in ('services.c','events.c','events_data.c','rpg.c','rpg_data.c')]
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo32','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),*map(str,sources)],cwd=ROOT,check=True)
 symbols=load_symbols(rom.with_suffix('.noi'));emu=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');emu.set_emulation_speed(0)
 def get(name):return emu.memory[symbols[name]]
 def word(name):return read_word(emu,symbols[name])
 def put(name,value):emu.memory[symbols[name]]=value
 source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();offset=3*16384+0x382f;prices=[int.from_bytes(source[offset+n*2:offset+n*2+2],'little')for n in range(64)];counts={'cases':0,'sold':0,'protected':0,'cancel_retained':0}
 try:
  for _ in range(240):
   emu.tick(1,False,False)
   if get('probe_ready'):break
  assert get('probe_ready')
  for party in range(4):
   put('probe_party',party)
   for item in range(1,64):
    put('probe_item',item)
    for slot in range(24):
     put('probe_slot',slot);money=65530 if party&1 else 123;put('probe_money',money&255);emu.memory[symbols['probe_money']+1]=money>>8;put('probe_command',1)
     for _ in range(120):
      emu.tick(1,False,False)
      if not get('probe_command'):break
     assert not get('probe_command')and not get('probe_error'),(party,item,slot,'timeout/cancel')
     assert word('probe_price')==prices[item]
     if prices[item]:
      assert get('probe_count')==23 and word('probe_money')==min(65535,money+prices[item])and word('probe_dialogue')==0xb8bc,(party,item,slot,get('probe_count'),word('probe_money'),word('probe_dialogue'))
      assert bytes(emu.memory[symbols['probe_inventory']:symbols['probe_inventory']+23])==bytes([36]*23)
      counts['sold']+=1;counts['cancel_retained']+=1
     else:
      assert get('probe_count')==24 and word('probe_money')==money and word('probe_dialogue')==0xbd7e
      assert emu.memory[symbols['probe_inventory']+slot]==item;counts['protected']+=1
     counts['cases']+=1
  report={'passed':True,**counts,'probe_sha256':hashlib.sha256(rom.read_bytes()).hexdigest(),'cartridge':cartridge_header(rom),'source_sha256':hashlib.sha256(source).hexdigest(),'scope':'Actual compiled service_begin/advance/select/respond and RPG sale. Four state addresses, all63itemIDs/all24slots, original ROM prices, cancel then confirm, removal and65535money cap. Fixture input only; main UI route separate.'}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:emu.stop(save=False)
if __name__=='__main__':main()
