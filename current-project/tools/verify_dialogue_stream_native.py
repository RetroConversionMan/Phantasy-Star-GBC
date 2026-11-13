#!/usr/bin/env python3
"""Native banked dialogue streaming and visible window cells for every record."""
from pathlib import Path
import json,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header,read_word
from verify_dialogue_stream import ROOT,BRIDGE,Original,SHA
MAIN=BRIDGE+r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "ui.h"
#include "font.h"
uint16_t probe_id,probe_number=12345,probe_calls;
uint8_t probe_item=63,probe_character_index=3,probe_command,probe_ready,probe_bank_error,probe_auto;
volatile uint8_t probe_clock;
uint8_t probe_text_clock,probe_needs_page;
char probe_lines[76];
void scanline(void){++probe_clock;}
void draw_glyph(void){
 char glyph[2];uint8_t row=probe_cursor.row,column=probe_cursor.column;
 glyph[0]=row<2?probe_cursor.lines[row][column-1]:probe_lower[row-2][column-1];glyph[1]=0;
 ui_text(column,row+1,glyph);
}
void main(void){
 static const uint16_t palette[4]={0x0000,0x0842,0x4210,0x7fff};
 DISPLAY_OFF;cpu_fast();LCDC_REG=LCDCF_BGON|LCDCF_BG8800|LCDCF_WIN9C00;
 VBK_REG=1;set_bkg_data(0,64,ui_font);fill_bkg_rect(0,0,32,32,15);
 VBK_REG=0;fill_bkg_rect(0,0,32,32,0);
 set_bkg_palette(7,1,palette);SWITCH_ROM_MBC5(1);
 CRITICAL{LYC_REG=0;STAT_REG|=0x40;add_LCD(scanline);IE_REG|=LCD_IFLAG;}
 SHOW_BKG;DISPLAY_ON;probe_ready=1;
 while(1){vsync();if(probe_command||probe_auto){
  if(probe_command==1){trace_open(probe_id,probe_number,probe_item,probe_character_index);ui_panel(probe_narrative?80:104,probe_narrative?8:5);probe_calls=0;probe_needs_page=0;probe_text_clock=probe_clock;}
  else{
   if(probe_command==3)probe_auto=1;
   if(probe_needs_page){ui_panel(80,8);probe_needs_page=0;probe_text_clock=probe_clock;continue;}
   if(probe_text_clock==probe_clock)continue;
   probe_text_clock=probe_clock;
   trace_next();++probe_calls;
   if(probe_result==DIALOGUE_STREAM_WAIT){probe_auto=0;if(probe_narrative&&probe_cursor.resume_line)probe_needs_page=1;}
   if(probe_result==DIALOGUE_STREAM_CHAR)draw_glyph();
   else if(probe_result==DIALOGUE_STREAM_SCROLL){
    ui_text(1,1,probe_cursor.lines[0]);ui_text(1,2,probe_cursor.lines[1]);
    if(probe_narrative){ui_text(1,3,probe_lower[0]);ui_text(1,4,probe_lower[1]);}
   }
   probe_text_clock=probe_clock;
  }
  memcpy(probe_lines,probe_cursor.lines,38);memcpy(probe_lines+38,probe_lower,38);
  if(CURRENT_BANK!=1)probe_bank_error=1;probe_command=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/dialogue-stream-native';out.mkdir(parents=True,exist_ok=True);(out/'main.c').write_text(MAIN);rom=out/'dialogue-stream.gbc'
 sources=[out/'main.c']+[ROOT/'src'/n for n in('dialogue.c','dialogue_data.c','dialogue_text_09.c','dialogue_text_10.c','bank_io.c','font.c','ui.c')]
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo16','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT))for p in sources]],cwd=ROOT,check=True)
 s=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 source=Original((ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes());records=json.loads((ROOT/'assets/dialogue/decoded.json').read_text())
 counts={'records':0,'native_glyphs':0,'native_glyph_scroll_frames':0,'window_cells':0,'maximum_physical_frames_per_tick_command':0}
 def val(n):return e.memory[s[n]]
 def command(c):
  e.memory[s['probe_command']]=c
  for ticks in range(100):
   e.tick(1)
   if not val('probe_command'):break
  else:raise AssertionError('Native dialogue command stalled')
  assert not val('probe_bank_error')
  if c==2:counts['maximum_physical_frames_per_tick_command']=max(counts['maximum_physical_frames_per_tick_command'],ticks+1)
 def lines():return bytes(e.memory[s['probe_lines']:s['probe_lines']+76])
 try:
  e.tick(180);assert val('probe_ready')
  for record in records:
   e.memory[s['probe_id']]=record['id']&255;e.memory[s['probe_id']+1]=record['id']>>8;command(1)
   expected,frames,waits=source.trace(record,12345,63,3);glyphs=[];frame=0;first_line_seen=False
   for _ in range(5000):
    command(2);result=val('probe_result')
    if result==0:
     # Native DialogueCursor layout:8-byte ref,offset/number4,done at12.
     if e.memory[s['probe_cursor']+12]:break
    else:
     if result==1:glyphs.append((val('probe_character'),frame))
     if result in(1,2):
      text=lines();rows=4 if record['id']>=0xc000 else 2
      for row in range(rows):
       for col in range(18):
        address=0x9c00+(row+1)*32+col+1
        assert(e.memory[0,address],e.memory[1,address])==(text[row*19+col]-32,15),(hex(record['id']),frame,row,col)
        counts['window_cells']+=1
      if record['id']==0x1e2 and b'LAERMA BERRIES ARE' in text:first_line_seen=True
     frame+=1
   else:raise AssertionError(('Native text stalled',hex(record['id'])))
   assert (glyphs,frame)==(expected,frames),(hex(record['id']),glyphs,expected,frame,frames)
   if record['id']==0x1e2:
    assert first_line_seen;e.tick(2);picture=e.screen.image.convert('RGB');picture.save(out/'three-line-message-final.png')
    # Confirm the PPU displays the font, not only correct window-map bytes.
    text=lines();lit=0
    for row in range(2):
     for col in range(18):
      tile=text[row*19+col]-32
      for y in range(8):
       for x in range(8):
        expected=(e.memory[1,0x9000+tile*16+y*2]>>(7-x))&1
        actual=picture.getpixel((8+col*8+x,104+8+row*8+y))
        assert (max(actual)>200)==bool(expected),(row,col,x,y,actual,expected)
        lit+=expected
    assert lit>100
   counts['records']+=1;counts['native_glyphs']+=len(glyphs);counts['native_glyph_scroll_frames']+=frame
  cadence=[]
  for record in [next(r for r in records if r['id']==0x1e2),next(r for r in records if r['id']>=0xc000)]:
   e.memory[s['probe_id']]=record['id']&255;e.memory[s['probe_id']+1]=record['id']>>8;command(1)
   segments=[]
   while True:
    before=read_word(e,s['probe_calls']);previous=before;elapsed=0;deltas=[]
    e.memory[s['probe_command']]=3
    for _ in range(1000):
     e.tick(1);elapsed+=1;current=read_word(e,s['probe_calls']);deltas.append(current-previous);previous=current
     if not val('probe_auto') and not val('probe_command'):break
    else:raise AssertionError('Free-running native text stalled')
    calls=current-before
    assert max(deltas)<=1,(hex(record['id']),calls,elapsed,deltas)
    # Banked newline decoding and panel preparation may cross an LCD frame;
    # keep that measured overhead explicit instead of fast-forwarding glyphs.
    assert calls<=elapsed<=calls+12,(hex(record['id']),calls,elapsed,deltas)
    segments.append({'logical_stream_steps':calls,'physical_frames':elapsed,'maximum_steps_in_one_physical_frame':max(deltas)})
    if e.memory[s['probe_cursor']+12]:break
   cadence.append({'id':hex(record['id']),'segments':segments})
  report={'passed':True,'header':cartridge_header(rom),**counts,'free_running_cadence':cadence,'source_sha256':SHA,'three_line_record_first_line_displayed':True,'limits':['Isolated UI probe; production input-latch and integrated scene tests are separate','Original16px glyphs are adapted to native8px font','Native panel/newline overhead adds measured display frames; no catch-up may skip a glyph']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
