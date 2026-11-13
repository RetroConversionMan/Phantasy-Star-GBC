#!/usr/bin/env python3
"""Native scene banking/VRAM probe; this is not an end-to-end story playthrough."""
from pathlib import Path
import json,subprocess,struct,hashlib
from pyboy import PyBoy
from verify_rom import cartridge_header,load_symbols
from extract_scenes import Source,required_pairs,SHA
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "scene.h"
#include "assets.h"
#include "font.h"
uint8_t probe_command,probe_type,probe_portrait,probe_enemy,probe_result,probe_ready;
static const uint16_t reserved_colors[4]={0x001f,0x03e0,0x7c00,0x7fff};
void main(void) {
 DISPLAY_OFF;cpu_fast();HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);
 SWITCH_ROM_MBC5(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);
 SWITCH_ROM_MBC5(1);VBK_REG=0;set_bkg_palette(7,1,reserved_colors);
 probe_ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(probe_command){
  DISPLAY_OFF;if(probe_command==2){scene_palette_flash(probe_type,probe_portrait);probe_result=1;}
  else probe_result=probe_type>=64u&&probe_type<76u?scene_show_room(probe_type-64u,probe_portrait,probe_enemy):scene_show(probe_type,probe_portrait,probe_enemy);
  if(CURRENT_BANK!=1)probe_result|=128;
  DISPLAY_ON;probe_command=0;
 }}
}
'''
def main():
 out=ROOT/'build/verification/scene-probe';out.mkdir(parents=True,exist_ok=True)
 manifest=json.loads((ROOT/'assets/scenes/manifest.json').read_text());source_rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
 assert hashlib.sha256(source_rom).hexdigest()==SHA
 assert {(r['type'],r['portrait'],r['prepared_enemy']) for r in manifest['records']}==set(required_pairs(source_rom))
 source=Source(source_rom)
 for portrait in range(1,62):source.compose(16,portrait)
 (out/'main.c').write_text(MAIN);rom=out/'scene-probe.gbc'
 sources=[out/'main.c']+[ROOT/'src'/s for s in ['scene.c','palette_commit.c','scene_data.c','bank_io.c','font.c','assets_sprites.c']]+sorted((ROOT/'src').glob('scene_bank_*.c'))
 # Relative paths avoid GBDK4.5.0's fixed-size filename buffer.
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom.relative_to(ROOT)),*[str(p.relative_to(ROOT)) for p in sources]],cwd=ROOT,check=True)
 syms=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 patterns=(ROOT/'assets/scenes/patterns.2bpp').read_bytes();timings=[]
 counts={'source_portrait_records':61,'native_scenes':0,'native_pattern_bytes':0,'native_map_attributes':0,'protected_bytes':0,'flash_palette_bytes':0,'source_flash_pixels':0}
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[0,0x8000:0x8800])+bytes(e.memory[1,0x8000:0x8800])
 def colors():
  result=[]
  for i in range(64):e.memory[0xff68]=i;result.append(e.memory[0xff69])
  return bytes(result)
 def flash(effect,white):
  for key,value in [('probe_type',effect),('probe_portrait',white),('probe_command',2)]:e.memory[syms[key]]=value
  for _ in range(100):
   e.tick(1)
   if not e.memory[syms['probe_command']]:break
  else:raise AssertionError('Flash timed out')
  assert e.memory[syms['probe_result']]==1
 def draw(kind,portrait,enemy):
  for key,val in [('probe_type',kind),('probe_portrait',portrait),('probe_enemy',enemy),('probe_command',1)]:e.memory[syms[key]]=val
  for ticks in range(1200):
   e.tick(1)
   if not e.memory[syms['probe_command']]:break
  else:raise AssertionError(('Render timed out',kind,portrait,enemy))
  timings.append(ticks+1);return e.memory[syms['probe_result']]
 try:
  e.tick(180);assert e.memory[syms['probe_ready']]==1;keep=protected()
  for record in manifest['records']:
   name=record['name'];assert draw(record['type'],record['portrait'],record['prepared_enemy'])==1,name
   words=struct.unpack('<300H',(ROOT/'assets/scenes'/f'{name}.map').read_bytes())
   for cell,word in enumerate(words):
    pattern=word&8191;bank=int(cell>=256);tile=cell if cell<256 else cell-256+64
    address=0x9000+tile*16 if tile<128 else 0x8800+(tile-128)*16
    assert bytes(e.memory[bank,address:address+16])==patterns[pattern*16:pattern*16+16],(name,cell,'pattern')
    mapaddr=0x9800+(cell//20)*32+cell%20
    assert (e.memory[0,mapaddr],e.memory[1,mapaddr])==(tile,(word>>13)|(bank<<3)),(name,cell,'map')
    counts['native_pattern_bytes']+=16;counts['native_map_attributes']+=1
   assert protected()==keep,name;counts['protected_bytes']+=len(keep);counts['native_scenes']+=1
   palette=(ROOT/'assets/scenes'/f'{name}.pal').read_bytes();masks=(ROOT/'assets/scenes'/f'{name}.flash').read_bytes()
   assert colors()[:56]==palette,name
   reserved=colors()[56:]
   for effect in (1,2,3,4):
    expected=bytearray(palette)
    for pal in range(7):
     mask=0
     for bit in range(3):
      if effect>>bit&1:mask|=masks[bit*7+pal]
     for c in range(4):
      if mask>>c&1:expected[(pal*4+c)*2:(pal*4+c)*2+2]=b'\xff\x7f'
    flash(effect,1);assert colors()==bytes(expected)+reserved,(name,effect,'white')
    flash(effect,0);assert colors()==palette+reserved,(name,effect,'restore');counts['flash_palette_bytes']+=128
   indices,_,_=source.compose(record['type'],record['portrait'],record['prepared_enemy'],return_indices=True)
   from PIL import Image
   indexed=Image.frombytes('L',(256,192),indices).resize((160,120),Image.Resampling.NEAREST)
   for cell,word in enumerate(words):
    tile=patterns[(word&8191)*16:(word&8191)*16+16];pal=word>>13
    for y in range(8):
     for x in range(8):
      original=indexed.getpixel((cell%20*8+x,cell//20*8+y));code=(tile[y*2]>>(7-x)&1)|((tile[y*2+1]>>(7-x)&1)<<1)
      for group,expected in enumerate((3<=original<=15,original==16,original>=19)):
       assert bool(masks[group*7+pal]>>code&1)==expected,(name,cell,y,x,original,group)
      counts['source_flash_pixels']+=1
   if name in ('16-25-00','16-14-00','18-04-00','20-57-00','22-13-00','29-53-00','30-00-72','32-00-73','68-47-00','68-52-00','71-59-00'):
    e.tick(2);e.screen.image.save(out/(name+'.png'))
  before=bytes(e.memory[0,0x8800:0x9fff])+bytes(e.memory[1,0x8800:0x9fff])
  assert draw(0,1,0)==0 and draw(255,0,0)==0
  assert before==bytes(e.memory[0,0x8800:0x9fff])+bytes(e.memory[1,0x8800:0x9fff])
  report={'passed':True,'header':cartridge_header(rom),**counts,'render_frames':{'min':min(timings),'max':max(timings),'all':timings},'limits':['Separate native graphics probe; integrated scene UI not verified by this test','No original SMS emulator screenshot comparison','Static source poses; animation and dynamic dungeon overlays remain separate']}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items() if k!='render_frames'},indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
