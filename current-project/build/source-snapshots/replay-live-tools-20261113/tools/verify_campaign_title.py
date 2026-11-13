#!/usr/bin/env python3
"""Compare the earned ending title against a native boot of the same cartridge.

This is a separate read-only visual diagnostic after campaign completion.
The reference boots with the same campaign's actually written cartridge SRAM;
it neither imports state into the campaign nor changes its recorded input.
"""
from pathlib import Path
import argparse,hashlib,json,shutil,tempfile
from PIL import Image,ImageChops
from pyboy import PyBoy
from verify_rom import capture,load_symbols,read_word

def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('run',type=Path);a=p.parse_args();folder=a.run.resolve()
 report=json.loads((folder/('report.json'if(folder/'report.json').exists()else'replay-report.json')).read_text());assert report.get('campaign_complete')and report.get('latest',report.get('final'))['screen']==0
 rom=folder/'campaign.gbc';save=folder/'campaign.gbc.ram';rom_hash=report['header']['sha256']if'header'in report else report['rom_sha256'];assert sha(rom)==rom_hash and save.is_file()
 controller=folder/('controller.jsonl'if(folder/'controller.jsonl').exists()else'recorded-controller.jsonl')
 s=load_symbols(rom.with_suffix('.noi'));before={'controller':sha(controller),'rom':sha(rom),'sram':sha(save)}
 with tempfile.TemporaryDirectory(prefix='ps-ending-title-reference-')as tmp:
  game=Path(tmp)/'reference.gbc';shutil.copyfile(rom,game);shutil.copyfile(save,Path(str(game)+'.ram'))
  e=PyBoy(str(game),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
  assert e.tick(300);boot_frames=300;start_counter=read_word(e,s['frame_counter'])
  while not(e.memory[0xff40]&0x80)or read_word(e,s['frame_counter'])==start_counter:
   assert boot_frames<12300,'Earned-SRAM native title did not finish its display dispatch'
   assert e.tick();boot_frames+=1
  assert e.tick(3);boot_frames+=3
  assert e.memory[s['screen_state']]==0 and e.memory[s['saved_position_valid']]
  assert e.memory[s['title_choice']]==1
  reference=folder/'title-reference-native-earned-save-boot.png';info=capture(e,reference);e.stop(save=False)
 final=folder/('ending-returned-to-title.png'if(folder/'ending-returned-to-title.png').exists()else'replay-ending-title-settled.png');aimg=Image.open(final).convert('RGB');bimg=Image.open(reference).convert('RGB');diff=ImageChops.difference(aimg,bimg)
 changed=sum(x!=(0,0,0)for x in diff.getdata());bbox=diff.getbbox()
 result={'passed':changed==0,'rom_sha256':before['rom'],'same_cartridge_earned_sram_sha256':before['sram'],'reference':'Separate native power-on with this completed campaign cartridge save; no campaign inputs or emulator memory changed','reference_boot_frames':boot_frames,'reference_settle':'LCD enabled, native frame_counter advances after synchronous title dispatch, then three display frames','reference_capture':info,'ending_capture_sha256':sha(final),'differing_pixels':changed,'difference_bounds':bbox,'campaign_mutation':False,'old_cartridge_sram_loaded':False}
 assert before=={'controller':sha(controller),'rom':sha(rom),'sram':sha(save)}
 (folder/'ENDING_TITLE_VISUAL_PROOF.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2));assert result['passed'],'Ending title does not match intact native boot title'
if __name__=='__main__':main()
