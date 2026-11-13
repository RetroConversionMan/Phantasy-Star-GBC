#!/usr/bin/env python3
"""Execute original GoldDragon palette store spans and verify native index classes."""
import hashlib,json,struct
from PIL import Image
import z80
from extract_scenes import ROOT,SHA,Source,label

def machine(rom,bank=3):
 c=z80.Z80Machine();c.memory[:0x8000]=rom[:0x8000];c.memory[0x8000:0xc000]=rom[bank*16384:(bank+1)*16384];return c

def span(c,start,stop):
 c.pc=start;c.set_breakpoint(stop);c.ticks_to_stop=100000;c.run();assert c.pc==stop,(hex(c.pc),hex(stop))

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 manifest=json.loads((ROOT/'assets/gold-scene/manifest.json').read_text());base=Source(rom).background(14)[2];phases=[]
 # Execute the original high16 fill loop before FadeIn2. Scene14's background
 # palette is the explicit input; graphics/flight/dialogue are outside this span.
 start=rom.index(b'\x21\x50\xc2\x06\x10',label('LABEL_4497'),label('LABEL_4511'));stop=rom.index(b'\xcd',start+5)
 c=machine(rom);c.memory[0xc240:0xc260]=bytes(base);span(c,start,stop);phases.append(list(c.memory[0xc240:0xc260]));assert phases[0]==manifest['phases'][0]
 # Execute the eight-byte B11_8000 restore into the shadow palette; no VBlank
 # or active C220 palette write occurs before the enemy loader.
 start=rom.index(b'\x21\x00\x80\x11\x50\xc2\x01\x08\0\xed\xb0',start,label('LABEL_4511'))
 c=machine(rom,11);c.memory[0xc240:0xc260]=bytes(phases[0]);c.memory[0xc220:0xc240]=bytes(range(32));span(c,start,start+11);phases.append(list(c.memory[0xc240:0xc260]));assert phases[1]==manifest['phases'][1]and bytes(c.memory[0xc220:0xc240])==bytes(range(32))
 # Run original5FFE until its first graphics-decode call: name and high8 colors
 # are copied by the original bank3 record lookup, before unrelated graphics.
 c=machine(rom);c.memory[0xc240:0xc260]=bytes(phases[1]);c.memory[0xc2e6]=70;span(c,label('LABEL_5FFE'),label('LABEL_3FA'));phases.append(list(c.memory[0xc240:0xc260]));assert phases[2]==manifest['phases'][2]
 # The loader's actual final32-byte shadow-to-active copy.
 start=rom.index(b'\x21\x40\xc2\x11\x20\xc2\x01\x20\0\xed\xb0',label('LABEL_5FFE'),label('LABEL_60FD'));span(c,start,start+11);assert list(c.memory[0xc220:0xc240])==phases[2]
 outcomes=[]
 for entry,sound in(('LABEL_1656',0xaf),('LABEL_1602',0x94)):
  c=machine(rom);c.memory[0xc220:0xc240]=bytes(phases[2]);c.memory[0xc240:0xc260]=bytes(phases[2]);c.memory[0xc2e6]=70
  for pos in range(label('LABEL_1602'),label('LABEL_1688')):
   if rom[pos:pos+3]==b'\x32\x04\xc0':c.set_breakpoint(pos)
  c.pc=label(entry);c.ticks_to_stop=100000;c.run();assert rom[c.pc:c.pc+3]==b'\x32\x04\xc0'and c.a==sound
  assert list(c.memory[0xc220:0xc240])==phases[0]and list(c.memory[0xc240:0xc260])==phases[2]
  outcomes.append({'entry':entry,'first_sound':hex(sound),'active_high16_blue':True,'shadow_unchanged':True})
 data=(ROOT/'assets/gold-scene/scene.bin').read_bytes();indices=(ROOT/'assets/gold-scene/indices.bin').read_bytes();scaled=Image.frombytes('L',(256,192),indices).resize((160,120),Image.Resampling.NEAREST);refs=manifest['palette_refs'];masks=data[manifest['mask_offset']:];pixels=0
 for cell in range(300):
  tile=data[manifest['map_offset']+cell];pal=data[manifest['map_offset']+300+cell];raw=data[tile*16:tile*16+16]
  for y in range(8):
   for x in range(8):
    source=scaled.getpixel((cell%20*8+x,cell//20*8+y));code=((raw[y*2]>>(7-x))&1)|(((raw[y*2+1]>>(7-x))&1)<<1);chosen=refs[pal][code]
    assert (source>=16)==(chosen>=16),'blue outcome eligibility'
    for group,eligible in enumerate((3<=source<=15,source==16,source>=19)):assert bool(masks[group*7+pal]>>code&1)==eligible
    pixels+=1
 out=ROOT/'build/verification/gold-source';out.mkdir(parents=True,exist_ok=True);report={'passed':True,'source_sha256':SHA,'original_palette_spans':5,'phases':phases,'outcomes':outcomes,'source_index_pixels':pixels,'phase1_only_shadow_updated':True,'native_data_bytes':len(data),'quantized_pixels':manifest['quantized_pixels'],'scope':'Actual original palette store/copy code, enemy record lookup, and first victory/defeat sound boundary. Flight, graphics upload, full combat and PPU timing have separate tests.'};(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='phases'},indent=2))
if __name__=='__main__':main()
