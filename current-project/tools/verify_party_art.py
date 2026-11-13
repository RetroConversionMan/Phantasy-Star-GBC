#!/usr/bin/env python3
"""Decode compiled party assets independently; retain exact source transparency."""
from pathlib import Path
import hashlib,json,struct,sys
import z80
from PIL import Image
ROOT=Path(__file__).resolve().parents[4];WORK=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(ROOT/'tools'))
from verify_rom import load_symbols
from extract_assets import ROM_SHA256
def main():
 source=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(source).hexdigest()==ROM_SHA256
 path=WORK/'build/phantasy-star-gbc-world.gbc';rom=path.read_bytes();syms=load_symbols(path.with_suffix('.noi'))
 def data(name,size):
  a=syms[name];off=(a>>16)*16384+(a&65535)-16384;return rom[off:off+size]
 tiles=data('party_world_tiles',4960);attrs=data('party_world_attrs',310);pal=struct.unpack('<32H',data('party_world_palettes',64))
 # Execute the original palette copy block, including its17-byte first
 # copy, rather than repeating the generator's sprite-index arithmetic.
 c=z80.Z80Machine();c.memory[:0x8000]=source[:0x8000]
 start=source.find(bytes.fromhex('1140c2011100edb0'),0xc00);assert start==0xc2d
 c.hl=0xd1e;c.sp=0xdffc;c.pc=start;c.set_breakpoint(0xc54)
 c.ticks_to_stop=100000;c.run();assert c.pc==0xc54
 sms=bytes(c.memory[0xc250:0xc260]);assert sms[1:14]==source[0xda3:0xdb0]
 native=[tuple((v>>s&31)*255//31 for s in(0,5,10))for v in pal]
 def rgb(v):return tuple((v>>s&3)*85 for s in(0,2,4))
 def gb(v):return sum(round(c*31/255)<<s for c,s in zip(rgb(v),(0,5,10)))
 changed=opaque=alpha=0;index=0;sheet=Image.new('RGB',(16*20,4*60),(32,40,48));per_actor=[]
 for actor,(name,address,frames,width)in enumerate((('Alis',0x8000,14,6),('Noah',0x8a80,13,6),('Odin',0x9440,14,6),('Myau',0x9ec0,16,4))):
  errors=0
  for frame in range(frames):
   for q in range(width):
    original=source[28*16384+address-0x8000+(frame*width+q)*32:][:32];raw=tiles[index*16:(index+1)*16];pid=attrs[index];assert pid<8
    for y in range(8):
     for x in range(8):
      source_index=sum(((original[y*4+b]>>(7-x))&1)<<b for b in range(4));code=((raw[y*2]>>(7-x))&1)|(((raw[y*2+1]>>(7-x))&1)<<1)
      assert bool(source_index)==bool(code),(name,frame,q,x,y,'alpha');alpha+=1
      if source_index:
       opaque+=1;wrong=gb(sms[source_index])!=pal[pid*4+code];changed+=wrong;errors+=wrong
       ox=frame*20+(q&1)*8+x;oy=actor*60+(q//2)*8+y
       sheet.putpixel((ox,oy),rgb(sms[source_index]));sheet.putpixel((ox,oy+28),native[pid*4+code])
    index+=1
  per_actor.append(dict(actor=name,frames=frames,quantized_opaque_pixels=errors))
 assert(index,alpha,opaque)==(310,19840,12143)
 out=WORK/'evidence';sheet.resize((960,720),Image.Resampling.NEAREST).save(out/'all-source-and-native-party-poses.png')
 report=dict(passed=True,original_sha256=ROM_SHA256,production_rom_sha256=hashlib.sha256(rom).hexdigest(),source_frames=57,tiles=index,alpha_pixels=alpha,opaque_pixels=opaque,quantized_opaque_pixels=changed,per_actor=per_actor,limits=['The CGB permits3 opaque colors per8x8 OBJ tile and8 simultaneous OBJ palettes. Source opaque pixel reductions are counted above across all57 poses. Original silhouettes, all poses, actor ordering and movement are preserved.'])
 (out/'compiled-art.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
