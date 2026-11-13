#!/usr/bin/env python3
"""Continue an immutable, earned campaign SRAM on an explicitly named ROM.

This is a documented cartridge upgrade, never a fresh-NewGame completion proof.
The source milestone's manifest and cartridge save are verified before copying.
After power-on every game change uses native controller input through Campaign.
"""
from pathlib import Path
import argparse,hashlib,json,shutil,traceback
from campaign_runner import Campaign
from verify_rom import capture,cartridge_header
from verify_story_ui import crc16

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('rom',type=Path);p.add_argument('milestone',type=Path);p.add_argument('--output',type=Path,required=True)
 p.add_argument('--continue-only',action='store_true',help='Verify native Continue and preserve a checkpoint without entering the final maze')
 a=p.parse_args();rom=a.rom.resolve();source=a.milestone.resolve();out=a.output.resolve()
 assert not out.exists(),'A new output directory is required; prior attempts are immutable evidence'
 manifest=json.loads((source/'SHA256.json').read_text())
 for name,digest in manifest.items():assert sha(source/name)==digest,('Source milestone changed',name)
 old=json.loads((source/'report.json').read_text());assert not old['injected_fixtures']
 assert sha(source/'campaign.gbc')==old['header']['sha256']
 saved=(source/'campaign.gbc.ram').read_bytes();assert len(saved)==8192 and saved[:4]==b'PSG\x04'
 assert crc16(saved[:624])==int.from_bytes(saved[624:626],'little'),'Source save CRC is invalid'
 assert old['latest']['story_flags'].get('22')==1 and old['latest']['story_flags'].get('23')==255
 assert old['latest']['map']==14 and old.get('campaign_tasks',{}).get('final_governor')==3
 out.mkdir(parents=True);shutil.copyfile(source/'campaign.gbc.ram',out/'campaign.gbc.ram')
 shutil.copyfile(source/'campaign.gbc.ram',out/'initial-earned-save.ram')
 provenance={'kind':'Byte-identical earned SRAM imported before power-on; no emulator state import',
  'source_milestone':str(source),'source_rom_sha256':old['header']['sha256'],
  'source_save_sha256':sha(source/'campaign.gbc.ram'),'source_controller_log_sha256':sha(source/'controller.jsonl'),
  'source_report_sha256':sha(source/'report.json'),'source_manifest_sha256':sha(source/'SHA256.json'),
  'source_frame':old['latest']['frame'],'source_checkpoints':len(old['checkpoints']),
  'source_deaths':len(old['deaths']),'source_continues':len(old.get('continues',[])),
  'destination_rom_sha256':cartridge_header(rom)['sha256'],'fresh_newgame_completion':False}
 (out/'migration.json').write_text(json.dumps(provenance,indent=2)+'\n')
 q=Campaign(rom,out)
 q.report['save_continuation']=provenance;q.report['campaign_tasks']=dict(old['campaign_tasks'])
 try:
  q.record('earned_sram_power_on',provenance=provenance);q.continue_game();actual=q.snapshot();want=old['latest']
  fields=('vehicle','object_flags','dungeon','map','position','party','items','money','joined','rng','story_flags')
  differences={k:{'saved':want[k],'continued':actual[k]}for k in fields if want[k]!=actual[k]}
  assert not differences,('Native Continue changed earned persistent state',differences)
  q.report['save_continuation']['native_continue_exact_fields']=list(fields)
  q.record('native_continue_matches_earned_save',fields=list(fields));q.checkpoint('earned-save-upgrade-continued',save=False)
  if not a.continue_only:q.final_maze()
  q.report['current_status']='Earned save Continue verified'if a.continue_only else'Final maze continuation completed'
 except BaseException as ex:
  q.report['failure']={'type':type(ex).__name__,'message':str(ex),'traceback':traceback.format_exc(),'state':q.snapshot()}
  q.report['current_status']='Stopped at recorded failure';q.report.setdefault('failures',[]).append(q.report['failure'])
  with(out/'failure.state').open('wb')as f:q.e.save_state(f)
  (out/'failure.json').write_text(json.dumps({'rom_sha256':q.report['header']['sha256'],**q.snapshot()},indent=2)+'\n')
  capture(q.e,out/'failure.png');raise
 finally:
  q.stop()
  for name,digest in manifest.items():assert sha(source/name)==digest,('Immutable source milestone changed',name)
  assert sha(out/'initial-earned-save.ram')==provenance['source_save_sha256']
if __name__=='__main__':main()
