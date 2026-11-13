#!/usr/bin/env python3
"""Actual SM83 in-place savev5 encode/decode and legacyv4 compatibility."""
from pathlib import Path
import binascii,hashlib,json,subprocess,sys
ROOT=next(p for p in Path(__file__).resolve().parents if(p/'upstream/ps1disasm/ps1original.sms').exists());WORK=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT/'tools'))
from pyboy import PyBoy
from verify_rom import load_symbols,read_word
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "save.h"
union {GameSave game;uint8_t bytes[SAVE_BYTES];} storage;
uint8_t ready,command,result,probe_phase,probe_clock,decoded_phase,decoded_clock;
uint16_t native_size,record_size;
void main(void){uint8_t i;DISPLAY_OFF;cpu_fast();native_size=sizeof(GameSave);record_size=SAVE_BYTES;
 for(i=0;i<64u;++i)((volatile uint8_t*)0xdbc0)[i]=0xa5;ready=1;DISPLAY_ON;
 while(1){vsync();if(command){
  if(command==1){memset(&storage,0,sizeof(storage));rpg_new_game(&storage.game.rpg);storage.game.map=4;storage.game.x=1688;storage.game.y=304;storage.game.vehicle=8;storage.game.vehicle_phase=probe_phase;storage.game.vehicle_clock=probe_clock;storage.game.rpg.money=1234;storage.game.flags[147]=255;storage.game.object_flags[99]=255;result=save_encode(storage.bytes,&storage.game);}
  else if(command==2){result=save_decode(&storage.game,storage.bytes);decoded_phase=storage.game.vehicle_phase;decoded_clock=storage.game.vehicle_clock;}
  else result=save_encode(storage.bytes,&storage.game);
  command=0;
 }}
}
'''
def main():
 out=WORK/'evidence/native-save';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN)
 objs=['build/obj/save.o','build/obj/rpg.o','build/obj/rpg_data.o']
 subprocess.run(['../../../.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo8','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o','evidence/native-save/save.gbc','evidence/native-save/main.c',*objs],cwd=WORK,check=True)
 path=out/'save.gbc';s=load_symbols(path.with_suffix('.noi'));e=PyBoy(str(path),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0);checks=0
 def issue(cmd):
  nonlocal checks
  e.memory[s['command']]=cmd
  for _ in range(100):
   e.tick(1)
   if not e.memory[s['command']]:break
  else:raise AssertionError('save command timeout')
  assert e.memory[s['result']]==1;assert bytes(e.memory[0xdbc0:0xdc00])==b'\xa5'*64;checks+=1
 try:
  e.tick(120);assert e.memory[s['ready']];assert read_word(e,s['native_size'])==622;assert read_word(e,s['record_size'])==628
  for phase in range(3):
   for clock in range(4):
    e.memory[s['probe_phase']]=phase;e.memory[s['probe_clock']]=clock;issue(1);packet=bytes(e.memory[s['storage']:s['storage']+628]);assert packet[:4]==b'PSG\5'and packet[624:626]==bytes((phase,clock));assert int.from_bytes(packet[-2:],'little')==binascii.crc_hqx(packet[:-2],65535)
    issue(2);assert(e.memory[s['decoded_phase']],e.memory[s['decoded_clock']])==(phase,clock);issue(3);assert bytes(e.memory[s['storage']:s['storage']+628])==packet
    legacy=bytearray(packet[:624]);legacy[3]=4;legacy+=binascii.crc_hqx(legacy,65535).to_bytes(2,'little');e.memory[s['storage']:s['storage']+626]=legacy;issue(2)
    assert(e.memory[s['decoded_phase']],e.memory[s['decoded_clock']])==(0,0);issue(3);upgraded=bytes(e.memory[s['storage']:s['storage']+628]);assert upgraded[:624]==packet[:624]and upgraded[624:626]==b'\0\0'
  report=dict(passed=True,probe_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),production_save_object_sha256=hashlib.sha256((WORK/'build/obj/save.o').read_bytes()).hexdigest(),native_GameSave_bytes=622,record_bytes=628,cycle_states=12,native_commands=checks,checks='Actual SM83 same-buffer encode/decode, every valid phase/clock combination,CRC,v4 migration preserving all preexisting bytes,64-byte guard.')
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(save=False)
if __name__=='__main__':main()
