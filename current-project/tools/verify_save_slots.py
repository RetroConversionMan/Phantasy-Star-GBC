#!/usr/bin/env python3
"""Five-slot addressing, label integrity and original Z80 name-edit actions."""
from pathlib import Path
import ctypes as C,json,re,subprocess,tempfile
import z80
from extract_scenes import ROOT,label
class Editor(C.Structure):
 _fields_=[('name',C.c_char*5),('cursor',C.c_uint8),('option',C.c_uint8)]
def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
 constants={k:int(v,16)for k,v in re.findall(r'^\.define\s+(\w+)\s+\$([\da-fA-F]+)',(ROOT/'upstream/ps1disasm/ps1.constants.asm').read_text(),re.M)}
 out=ROOT/'build/verification/save-slots';out.mkdir(parents=True,exist_ok=True)
 with tempfile.TemporaryDirectory(prefix='ps-save-slots-')as tmp:
  libpath=Path(tmp)/'slots.dylib';subprocess.run(['clang','-std=c99','-Wall','-Wextra','-Werror','-O2','-shared','-fPIC','-Isrc','src/save_slots.c','-o',str(libpath)],cwd=ROOT,check=True)
  lib=C.CDLL(str(libpath));lib.save_slot_offset.restype=C.c_uint16
  expected=list(dict.fromkeys(rom[label('LABEL_4280'):label('LABEL_4280')+44]))
  assert len(expected)==36 and [lib.save_name_character(n)for n in range(36)]==expected
  checks=36;actions=0
  for slot in range(256):assert lib.save_slot_offset(slot)==(slot*1024 if slot<5 else 65535);checks+=1
  for char in expected[:33]+[32]:
   name=(C.c_char*5).from_buffer_copy(bytes([char])*5);data=(C.c_uint8*8)();decoded=(C.c_char*5)()
   assert lib.save_label_encode(data,name)==1 and lib.save_label_decode(decoded,data)==1 and bytes(decoded)==bytes(name);checks+=1
   for bit in range(64):
    damaged=(C.c_uint8*8).from_buffer_copy(bytes(data));damaged[bit//8]^=1<<(bit%8)
    assert not lib.save_label_decode(decoded,damaged) and bytes(decoded)==b' '*5;checks+=1
  cpu=z80.Z80Machine();cpu.memory[:0x8000]=rom[:0x8000];cpu.set_breakpoint(0x100)
  # Stop at END's original branch before its tilemap/SRAM label-copy routine;
  # only the editor action is under comparison here, not SMS mapper writes.
  branch=rom.index(bytes.fromhex('fe5e28'),label('GameMode_NameInput'),label('LABEL_3F69'))+2
  end_target=branch+2+int.from_bytes(rom[branch+1:branch+2],'little',signed=True);cpu.set_breakpoint(end_target)
  for name in ('WaitForVInt','LABEL_40C5','LABEL_4117','LABEL_414F'):cpu.memory[label(name)]=0xc9
  for cursor in range(5):
   for option,char in enumerate(expected):
    for erase in (0,1):
     e=Editor();e.name=b'A ;Z!';e.cursor=cursor;e.option=option
     cpu.memory[0xc721:0xc726]=b'A ;Z!';cpu.memory[0xc780]=0;cpu.memory[0xc781]=0x21+cursor;cpu.memory[0xc782]=0;cpu.memory[0xc788]=char
     cpu.memory[constants['Game_is_paused']]=0;cpu.memory[constants['Ctrl_1_pressed']]=0x10 if erase else 0x20
     cpu.memory[constants['Game_mode']]=0xee;cpu.memory[constants['CurrentDialogueNumber']]=1;cpu.memory[constants['CurrentDialogueNumber']+1]=0;cpu.memory[0xc316]=0
     cpu.pc=label('GameMode_NameInput');cpu.sp=0xdffc;cpu.memory[0xdffc:0xdffe]=bytes([0,1]);cpu.ticks_to_stop=100000
     for _ in range(10):
      cpu.run()
      if cpu.pc in(0x100,end_target):break
     assert cpu.pc in(0x100,end_target),(cursor,option,erase,hex(cpu.pc),hex(end_target),hex(cpu.sp))
     ended=lib.save_name_input(C.byref(e),erase)
     assert bytes(e.name)==bytes(cpu.memory[0xc721:0xc726]),(cursor,option,erase,bytes(e.name),bytes(cpu.memory[0xc721:0xc726]))
     assert e.cursor==cpu.memory[0xc781]-0x21 and bool(ended)==(cpu.pc==end_target)
     checks+=3;actions+=1
 report={'passed':True,'checks':checks,'original_z80_name_actions':actions,'source_character_repertoire':36,'native_save_slots':5,'record_stride':1024,'existing_slot0_offset_preserved':True,'scope':'Host helper logic and label corruption only; native five-slot SRAM/UI integration still pending. Original name-edit routines run with display-only helper calls stubbed.'}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
