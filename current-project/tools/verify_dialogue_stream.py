#!/usr/bin/env python3
"""Compare character/scroll cadence with the original Z80 dialogue interpreter.

The original glyph writer, dictionary expansion, number conversion, placeholder
selection and scrolling execute unchanged. Small observation trampolines emit
characters; WaitForVInt becomes a logical-frame boundary. Button waits return
immediately because terminator rules have a separate exhaustive test.
"""
from pathlib import Path
import ctypes as C,hashlib,json,re,subprocess,tempfile
import z80
from extract_scenes import ROOT,label
SHA='9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
BRIDGE=r'''
#include <string.h>
#include "dialogue.h"
DialogueCursor probe_cursor;
char probe_lower[2][19];
uint8_t probe_narrative,probe_result,probe_character;
uint8_t trace_open(uint16_t id,uint16_t number,uint8_t item,uint8_t character){
 static const char names[4][5]={"ALIS","MYAU","ODIN","NOAH"};
 if(!dialogue_open(&probe_cursor,id))return 0;
 probe_narrative=id>=0xc000;probe_cursor.number=number;
 memcpy(probe_cursor.character,names[character],5);
 strcpy(probe_cursor.enemy,"SCORPION");dialogue_item_name(item,probe_cursor.item);
 dialogue_stream_begin(&probe_cursor,probe_narrative?probe_lower:0);return 1;
}
uint8_t trace_next(void){
 probe_result=dialogue_stream_next(&probe_cursor,probe_narrative?probe_lower:0);
 if(probe_result==DIALOGUE_STREAM_CHAR){
  uint8_t r=probe_cursor.row,c=probe_cursor.column-1;
  probe_character=r<2?probe_cursor.lines[r][c]:probe_lower[r-2][c];
 }
 return probe_result;
}
uint8_t trace_character(void){return probe_character;}
uint8_t trace_done(void){return probe_cursor.done;}
uint8_t trace_terminator(void){return probe_cursor.terminator;}
'''
class Original:
 def __init__(self,rom):
  self.rom=rom;self.cpu=z80.Z80Machine();c=self.cpu
  c.memory[:0x8000]=rom[:0x8000];c.set_breakpoint(0x100)
  c.set_output_callback(self.output);c.set_input_callback(self.input)
  def write(a,v):
   c.memory[a]=v
   if a==0xffff:c.memory[0x8000:0xc000]=rom[v*16384:(v+1)*16384]
  c.set_write_callback(write);c.mark_addr(0xffff,c.WRITE_MARK)
  # Observe the byte at HL without changing flags or glyph-writer behavior.
  address=label('LABEL_33D6');assert bytes(c.memory[address:address+3])==bytes.fromhex('f3c5d5')
  c.memory[address:address+3]=bytes.fromhex('c300e1')
  stub=bytes.fromhex('f57ed3fef1f3c5d5c3')+(address+3).to_bytes(2,'little');c.memory[0xe100:0xe100+len(stub)]=stub
  address=label('LABEL_3302');assert bytes(c.memory[address:address+3])==bytes.fromhex('0e01f3')
  c.memory[address:address+3]=bytes.fromhex('c320e1')
  stub=bytes.fromhex('f5d3fcf10e01f3c3')+(address+3).to_bytes(2,'little');c.memory[0xe120:0xe120+len(stub)]=stub
  address=label('WaitForVInt');c.memory[address:address+4]=bytes.fromhex('d3fdafc9')
  address=label('WaitForButton1Or2');c.memory[address:address+6]=bytes.fromhex('f57ed3fbf1c9')
  self.constants={k:int(v,16)for k,v in re.findall(r'^\.define\s+(\w+)\s+\$([\da-fA-F]+)',(ROOT/'upstream/ps1disasm/ps1.constants.asm').read_text(),re.M)}
 def output(self,p,v):
  p&=255
  if p in(0xfe,0xfc):self.glyphs.append((39 if v==64 else v if p==0xfe else v+48,self.frames))
  elif p==0xfd:
   if v==10:self.frames+=1
  elif p==0xfb:self.waits.append((v,self.frames))
  elif p==0xbf:
   if self.latch is None:self.latch=v
   else:self.address=self.latch|((v&63)<<8);self.code=v>>6;self.latch=None
  elif p==0xbe:self.vram[self.address]=v;self.address=(self.address+1)&16383
 def input(self,p):
  if p&255==0xbe:
   v=self.vram[self.address];self.address=(self.address+1)&16383;return v
  return 255
 def trace(self,record,number,item,character):
  c=self.cpu;self.frames=0;self.glyphs=[];self.waits=[];self.vram=bytearray(16384);self.address=0;self.code=0;self.latch=None
  c.memory[0xc000:0xe000]=bytes(8192);bank=record['sms_bank'];c.memory[0xffff]=bank;c.memory[0x8000:0xc000]=self.rom[bank*16384:(bank+1)*16384]
  for key,value in [('CurrentCharacter',character),('CurrentItem',item)]:c.memory[self.constants[key]]=value
  address=self.constants['CurrentDialogueNumber'];c.memory[address:address+2]=number.to_bytes(2,'little')
  address=self.constants['CurrentBattle_EnemyName'];c.memory[address:address+8]=b'SCORPION'
  c.hl=record['sms_address'];c.pc=label('LABEL_337D'if record['id']>=0xc000 else'LABEL_31F4');c.sp=0xdffc;c.memory[0xdffc:0xdffe]=bytes((0,1))
  for _ in range(100):
   c.ticks_to_stop=1000000;c.run()
   if c.pc==0x100:return self.glyphs,self.frames,self.waits
  raise AssertionError(('Original interpreter timeout',hex(record['id']),hex(c.pc)))
def native_trace(lib,record,number,item,character):
 assert lib.trace_open(record['id'],number,item,character)
 glyphs=[];waits=[];frame=0;segments=[]
 for _ in range(10000):
  result=lib.trace_next()
  if result==0:
   term=lib.trace_terminator()
   if term in(0x61,0x65):waits.append((term,frame))
   if lib.trace_done():return glyphs,frame,waits
  else:
   if result==1:glyphs.append((lib.trace_character(),frame))
   frame+=1
 raise AssertionError(('Native stream timeout',record['id']))
def main():
 out=ROOT/'build/verification/dialogue-stream';out.mkdir(parents=True,exist_ok=True)
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 records=json.loads((ROOT/'assets/dialogue/decoded.json').read_text());original=Original(rom)
 with tempfile.TemporaryDirectory(prefix='ps-dialogue-stream-')as tmp:
  tmp=Path(tmp);bridge=tmp/'bridge.c';bridge.write_text(BRIDGE);libpath=tmp/'dialogue.dylib'
  subprocess.run(['clang','-std=c99','-Wall','-Wextra','-Werror','-O2','-shared','-fPIC','-Isrc',str(bridge),'src/dialogue.c','src/dialogue_data.c','src/dialogue_text_09.c','src/dialogue_text_10.c','-o',str(libpath)],cwd=ROOT,check=True)
  lib=C.CDLL(str(libpath));lib.trace_open.argtypes=[C.c_uint16,C.c_uint16,C.c_uint8,C.c_uint8]
  for name in ('trace_open','trace_next','trace_character','trace_done','trace_terminator'):getattr(lib,name).restype=C.c_uint8
  glyphs=frames=0
  for record in records:
   expected=original.trace(record,12345,63,3);actual=native_trace(lib,record,12345,63,3)
   assert actual==expected,(hex(record['id']),actual,expected)
   glyphs+=len(actual[0]);frames+=actual[1]
  dynamic=next(r for r in records if 0x5e in bytes.fromhex(r['expanded_hex']))
  for n in(0,1,9,10,99,100,999,1000,9999,10000,65535):
   assert native_trace(lib,dynamic,n,63,3)==original.trace(dynamic,n,63,3),(dynamic['id'],n)
  special=next(r for r in records if r['id']==0x1e2);trace=native_trace(lib,special,12345,63,3)
  assert b'LAERMA BERRIES ARE' in bytes(x[0]for x in trace[0])
 report={'passed':True,'source_sha256':SHA,'source_interpreter_records':len(records),'source_glyphs_and_frame_positions':glyphs,'source_glyph_scroll_frames':frames,'extra_number_boundaries':11,'three_line_record_0x1e2_all_glyphs_visible':True,'limits':['Logical source VBlank comparison; native cartridge integration is separate','8px GBC glyphs represent the two SMS half-glyph scroll images as one row shift with the same8frame delay','Controller waits are skipped in this interpreter harness and tested separately']}
 (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
