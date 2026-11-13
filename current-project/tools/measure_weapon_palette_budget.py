#!/usr/bin/env python3
"""Reproducible RGB cost of reserving two OBJ palettes for original effects."""
import hashlib,json
from PIL import Image
from extract_battle_scenes import ROOT,SHA,Source,source_overlay,enemy_palette,convert

def main():
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==SHA
 source=Source(rom);records=[]
 for enemy in range(1,75):
  if enemy in(72,73):continue
  indexed=source_overlay(source,enemy=enemy,indexed=True);palette=enemy_palette(source,enemy,0)
  a=convert(indexed,palette,8);b=convert(indexed,palette,6)
  opaque=sum(bool(v)for v in indexed.resize((160,120),Image.Resampling.NEAREST).getchannel('A').get_flattened_data())
  records.append({'enemy':enemy,'opaque_pixels':opaque,'eight_palette_rgb_mismatches':a[3],'six_palette_rgb_mismatches':b[3]})
 report={'source_sha256':SHA,'ordinary_initial_poses':len(records),'opaque_pixels':sum(r['opaque_pixels']for r in records),'eight_palette_rgb_mismatches':sum(r['eight_palette_rgb_mismatches']for r in records),'six_palette_rgb_mismatches':sum(r['six_palette_rgb_mismatches']for r in records),'source_flash_class_mismatches':0,'records':records,'scope':'RGB adaptation of source first poses at unlit/common floor palette0; every conversion asserts exact source flash class for every opaque pixel. Additional floor/physical poses are tested by the native renderer.'}
 (ROOT/'assets/weapon-effects/palette-budget.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps({k:v for k,v in report.items()if k!='records'},indent=2))
if __name__=='__main__':main()
