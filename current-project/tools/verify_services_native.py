#!/usr/bin/env python3
"""Run the source-service acceptance cases on the native CPU at four state addresses."""
from pathlib import Path
import hashlib,json,re,subprocess
from pyboy import PyBoy
from verify_rom import load_symbols,read_word,cartridge_header
ROOT=Path(__file__).resolve().parents[1]
def main():
 out=ROOT/'build/verification/services-native';out.mkdir(parents=True,exist_ok=True)
 original=(ROOT/'tests/test_services.c').read_text()
 body=original.replace('#include <assert.h>','').replace('#include <stdio.h>','')
 body=body.replace('static RPGState r;','static RPGState native_parties[4];\nstatic RPGState *native_party;\n#define r (*native_party)')
 body=body.replace('#define CHECK(x) do{assert(x);++checks;}while(0)','#define CHECK(x) do{if(!(x)){probe_failed_line=__LINE__;probe_ready=1;while(1);}++checks;}while(0)')
 body=body.replace('int main(void){','static void run_cases(void){')
 body=re.sub(r' printf\([^\n]+;return 0;', ' return;',body)
 assert 'printf(' not in body and 'assert(' not in body
 main='#include <gb/gb.h>\n#include <gb/cgb.h>\nuint16_t probe_failed_line,probe_checks;\nuint8_t probe_ready,probe_party;\n'+body+'''
void main(void){
 DISPLAY_OFF;cpu_fast();
 for(probe_party=0;probe_party<4;probe_party++){native_party=native_parties+probe_party;run_cases();}
 probe_checks=checks;probe_ready=1;while(1);
}
'''
 (out/'main.c').write_text(main);rom=out/'services-native.gbc'
 sources=[out/'main.c']+[ROOT/'src'/s for s in ('services.c','events.c','events_data.c','rpg.c','rpg_data.c')]
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo32','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),*map(str,sources)],cwd=ROOT,check=True)
 syms=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 try:
  for _ in range(1200):
   e.tick(1,False,False)
   if e.memory[syms['probe_ready']]:break
  failure=read_word(e,syms['probe_failed_line']);assert not failure,{'generated_line':failure,'source':main.splitlines()[failure-1],'state_address_case':e.memory[syms['probe_party']]}
  checks=read_word(e,syms['probe_checks']);assert e.memory[syms['probe_ready']]and checks==324,checks
  report={'passed':True,'header':cartridge_header(rom),'checks':checks,'state_addresses':4,'source_acceptance_cases_per_address':81,'scope':'Existing source-derived hospital/church/buy/sell/Secrets acceptance cases compiled natively with GBDK4.5.0 and executed on CGB CPU. Explicit fixtures include alive/dead, single/multiple party, refusal, insufficient money, source byte-wrapped hospital cost, revival, original EXP guidance, full/protected inventory and sale cancellation. Main UI separately tested.','inputs_sha256':{str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest()for p in [ROOT/'tests/test_services.c',*sources[1:]]},'campaign_complete':False}
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(save=False)
if __name__=='__main__':main()
