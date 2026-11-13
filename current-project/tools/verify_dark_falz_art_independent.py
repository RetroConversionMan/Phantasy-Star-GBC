#!/usr/bin/env python3
"""Independent VDP-index/native-flash-class proof for retained Dark Falz art.

Reads actual5619 snapshots, directly decodes both planar hardware formats,
and executes the original victory-clear path through1679. No asset writes.
"""
from pathlib import Path
import hashlib,json,pickle,struct
from PIL import Image
from extract_scenes import Source,label,SHA,ROOT
from verify_dark_falz_prelude_source import trace

def sms_indices(vram):
 result=bytearray(49152)
 for y in range(192):
  for x in range(256):
   offset=0x3800+(y//8)*64+(x//8)*2;word=vram[offset]|(vram[offset+1]<<8)
   column=(7-x%8)if word&0x200 else x%8;row=(7-y%8)if word&0x400 else y%8
   address=(word&0x1ff)*32+row*4;value=0
   for plane in range(4):value|=((vram[address+plane]>>(7-column))&1)<<plane
   result[y*256+x]=value+(16 if word&0x800 else 0)
 return bytes(result)

def category(index):return 1 if 3<=index<=15 else 2 if index==16 else 3 if index>=19 else 0
def native_color(color):
 levels=(0,10,21,31);return levels[color&3]|(levels[(color>>2)&3]<<5)|(levels[(color>>4)&3]<<10)

def main():
 original=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(original).hexdigest()==SHA
 evidence=ROOT/'build/research/dark-falz-prelude';data=pickle.loads((evidence/'source-trace.pkl').read_bytes());source=Source(original)
 assets=ROOT/'assets/scenes';patterns=(assets/'patterns.2bpp').read_bytes();manifest=json.loads((assets/'manifest.json').read_text());records={r['name']:r for r in manifest['records']};cases=[]
 for phase,name,args in [(0,'31-00-00',(31,0,0)),(1,'32-00-73',(32,0,73))]:
  snap=data['phases'][phase]['snapshot'];indices=sms_indices(snap[0]);palette=bytes(snap[1]);assert indices==data['phases'][phase]['indices']
  composed,colors,_=source.compose(*args,return_indices=True)
  assert composed==indices,(name,'source index mismatch',sum(a!=b for a,b in zip(composed,indices)))
  assert bytes(colors)==palette,(name,'full source palette mismatch')
  sampled=Image.frombytes('L',(256,192),indices).resize((160,120),Image.Resampling.NEAREST).tobytes();mapping=struct.unpack('<300H',(assets/(name+'.map')).read_bytes());pal=struct.unpack('<28H',(assets/(name+'.pal')).read_bytes());masks=(assets/(name+'.flash')).read_bytes();assert len(masks)==21
  quantized=0;decoded=[]
  for y in range(120):
   for x in range(160):
    word=mapping[(y//8)*20+x//8];tile=word&8191;selected=word>>13;address=tile*16+(y%8)*2;bit=7-x%8
    code=((patterns[address]>>bit)&1)|(((patterns[address+1]>>bit)&1)<<1);active=[g+1 for g in range(3)if masks[g*7+selected]&(1<<code)]
    assert len(active)<=1;actual=active[0]if active else 0;expected=category(sampled[y*160+x]);assert actual==expected,(name,x,y,'flash class',actual,expected)
    color=pal[selected*4+code];decoded.append(color);quantized+=color!=native_color(palette[sampled[y*160+x]])
  assert quantized==records[name]['color_quantized_pixels'],(name,'quantization report',quantized,records[name]['color_quantized_pixels'])
  cases.append({'phase':phase,'asset':name,'source_index_pixels_exact':len(indices),'source_palette_bytes_exact':32,'native_flash_class_pixels_exact':len(sampled),'native_RGB_quantized_pixels':quantized,'native_decoded_color_sha256':hashlib.sha256(struct.pack('<19200H',*decoded)).hexdigest()})
 # Also compare the preserved pre-edit artifact, separately from the generic
 # blank-background model. The two histories have different prior palettes.
 preserved=ROOT/'build/research/dark-falz-background/before-32-00-73-source.png'
 previous=Image.open(preserved).convert('RGB');phase=data['phases'][1]
 current=[((phase['palette'][v]&3)*85,((phase['palette'][v]>>2)&3)*85,((phase['palette'][v]>>4)&3)*85)for v in phase['indices']]
 previous_changes=sum(a!=b for a,b in zip(previous.get_flattened_data(),current));assert previous_changes==12740
 # Reproduce a generic lost-background composition without an old image.
 class LostBackground(Source):
  def background(self,kind):return super().background(32 if kind==31 else kind)
 old,old_colors,_=LostBackground(original).compose(32,enemy=73,return_indices=True);phase=data['phases'][1]
 lost=sum(old_colors[a]!=phase['palette'][b]for a,b in zip(old,phase['indices']));assert lost>0
 # Execute the real AF store and15D9/319E/3D36 path. This begins from the
 # actual first-battle state; UI buffers are irrelevant to final map clear.
 ref,phases=trace();c=ref.main;assert c.memory[0xc29e]==32 and c.memory[0xc2e6]==73
 ref.frames.clear();ref.unique.clear();ref.logs.clear();ref.audio.clear();c.pc=label('LABEL_1656');c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1';end=label('LABEL_1679');c.set_breakpoint(end)
 for _ in range(1000):
  c.ticks_to_stop=500000;c.run()
  if c.pc==end:break
 else:raise AssertionError(('victory clear',hex(c.pc)))
 assert ref.audio==[(0,0xaf)] and [r[-1]for r in ref.logs]==[10]*4+[16]
 assert bytes(c.memory[0xd000:0xd600])==b'\0\x08'*768
 final=sms_indices(ref.vram);assert not any(ref.cram[index]for index in final)
 # The retained body is correct before combat; a newly loaded blank type32
 # remains correct after victory's actual3D36 call.
 blank,colors,_=source.compose(32,return_indices=True);assert not any(colors[index]for index in blank)
 report={'passed':True,'source_sha256':SHA,'cases':cases,'preserved_pre_edit_source_RGB_pixels_changed':previous_changes,'generic_blank_model_source_RGB_pixels_changed':lost,'victory_clear':{'audio':ref.audio,'wait_commands':[r[-1]for r in ref.logs],'frames':len(ref.frames),'map_words':'768x0800','final_pixels_black':len(final),'native_blank_type32_correct_after_clear':True,'chronology':'AF precedes four row-restoration waits and one final upload;180 source wait then follows at1683.'},'limits':['Native files are directly decoded, not executed by this independent test; production PPU/runtime integration is a separate proof.','GBC color quantization is measured; flash membership and source indices are exact.','Source victory begins before the battle-menu initialization, so the four temporary restored rows are not treated as a battle-UI image oracle. Final cleared map and palette are actual source results.']}
 out=ROOT/'build/verification/dark-falz-art-independent';out.mkdir(parents=True,exist_ok=True);(out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
