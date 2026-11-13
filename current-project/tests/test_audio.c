#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <math.h>
#include "audio.h"
int main(void){
 uint32_t checks=0;uint16_t divider,frame;uint8_t wave,command,control,shift,divisor,best,expected;
 double target,frequency,error,difference;
 for(wave=0;wave<2;++wave)for(divider=0;divider<1024;++divider){
  target=(wave?65536.0:131072.0)*32.0*divider/3579545.0;
  assert(audio_gb_period(divider,wave)==2048-(uint16_t)floor(target+0.5));++checks;
 }
 for(control=0;control<8;++control)for(divider=0;divider<1024;++divider){
  target=((control&3)==3)?3579545.0/(32.0*(divider?divider:1)):3579545.0/(512u<<(control&3));error=1e20;best=0;
  for(shift=0;shift<14;++shift)for(divisor=0;divisor<8;++divisor){
   frequency=524288.0/(divisor?divisor:0.5)/(1u<<(shift+1));difference=fabs(target-frequency);
   if(difference<error){error=difference;best=(shift<<4)|divisor;}
  }
  assert(audio_gb_noise(control,divider)==(best|((control&4)?0:8)));++checks;
 }
 for(command=0;command<16;++command){expected=command==15?0:(uint8_t)floor(15*pow(10,-command/10.0)+0.5);assert(audio_gb_volume(command)==expected);++checks;}
 for(command=0x81;command<0xda;++command){
  audio_init();audio_command(command);
  for(frame=0;frame<7200;++frame){audio_tick();assert(!audio_fault);++checks;}
 }
 for(frame=0;frame<50000;++frame){if(!(frame%31))audio_command((uint8_t)frame);audio_tick();assert(!audio_fault);++checks;}
 printf("Audio logic checks passed: %lu\n",(unsigned long)checks);return 0;
}
