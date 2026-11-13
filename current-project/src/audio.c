/* Source: upstream/ps1disasm/sound/sound_driver.asm, 8000..8873.
 * C implementation of score/control flow; PSG writes are adapted to the GBC APU.
 * All byte arithmetic deliberately wraps like the source Z80 instructions. */
#ifdef __SDCC
#pragma bank 15
#include <gb/gb.h>
#include <gb/cgb.h>
#endif
#include <string.h>
#include "audio.h"
#include "audio_data.h"
#include "bank_io.h"
uint8_t audio_ram[AUDIO_RAM_SIZE];
uint16_t audio_tone[3],audio_frames;
uint8_t audio_volume[4],audio_noise,audio_fault,audio_music;
volatile uint8_t audio_clock;
static uint8_t latch,noise_written;
#ifndef __SDCC
uint8_t audio_trace[1024];
uint16_t audio_trace_count;
#endif
#define R audio_ram
#define CH(n) (R+14u+32u*(n))
static uint8_t rd(uint16_t addr){
 if(addr<0x4000u)return bank_read8(62,audio_low0+addr);
 if(addr<0x8000u)return bank_read8(63,audio_low1+(addr&0x3fffu));
 if(addr<0xc000u)return bank_read8(AUDIO_DATA_BANK,audio_data+(addr&0x3fffu));
 if((addr&0x1fffu)<AUDIO_RAM_SIZE)return R[addr&0x1fffu];
 audio_fault=10;return 0;
}
static uint16_t rw(uint16_t addr){uint8_t low=rd(addr);return low|((uint16_t)rd(addr+1u)<<8);}
static uint16_t cw(const uint8_t *c,uint8_t offset){return c[offset]|((uint16_t)c[offset+1u]<<8);}
static void sw(uint8_t *c,uint8_t offset,uint16_t v){c[offset]=(uint8_t)v;c[offset+1u]=(uint8_t)(v>>8);}
static void psg(uint8_t value){
 uint8_t channel;
#ifndef __SDCC
 if(audio_trace_count<sizeof(audio_trace))audio_trace[audio_trace_count++]=value;else audio_fault=1;
#endif
 if(value&128u)latch=(value>>4)&7u;
 channel=latch>>1;
 if(latch&1u)audio_volume[channel]=value&15u;
 else if(channel==3u){audio_noise=value&7u;noise_written=1;}
 else if(value&128u)audio_tone[channel]=(audio_tone[channel]&0x3f0u)|(value&15u);
 else audio_tone[channel]=(audio_tone[channel]&15u)|((uint16_t)(value&63u)<<4);
}
static void silence(void){uint8_t i;for(i=0;i<8u;++i)psg(rd(0x803bu+i));}
static void clear_control(void){memset(R+3,0,11);}
static void reset_driver(void){uint8_t i;clear_control();for(i=0;i<15u;++i){CH(i)[0]=0;CH(i)[24]=CH(i)[25]=CH(i)[26]=0;}silence();}
static void volume(uint8_t *c){psg((uint8_t)(((c[8]&15u)|c[1])+16u));}
static void tone(uint8_t control,uint16_t frequency){
 /* LABEL8812 preserves the source's odd high-byte OR/rotate representation. */
 uint8_t v=(uint8_t)((frequency&0xf0u)|(frequency>>8));
 psg((uint8_t)((frequency&15u)|control));psg((uint8_t)((v>>4)|(v<<4)));
}
static void acknowledge(void){R[4]=0x80;}
static void resume(void){
 uint8_t i;silence();R[2]=R[5];R[10]=0x80;R[11]=10;CH(6)[0]|=4;
 for(i=0;i<6u;++i){CH(i)[23]=CH(i)[8];CH(i)[8]=9;}acknowledge();
}
static void fade_begin(void){R[10]=3;if(!(R[2]&128u))CH(6)[0]=0;psg(0xff);CH(14)[0]=0;acknowledge();}
static void command(uint8_t cmd){
 uint8_t index,flags,count,i,j,first;uint16_t address;
 if(!(cmd&128u)||cmd>=0xdau){reset_driver();return;}
 if(cmd<0xa0u){
  if(cmd>=0x95u){acknowledge();return;}if(cmd==0x80u)return;
  index=cmd-0x81u;flags=rd(0x823fu+index);R[5]=R[2]&127u;R[1]=R[2]=flags;
  if(R[10]&128u)for(i=0;i<6u;++i)CH(i)[8]=CH(i)[23];
  clear_control();silence();first=10;
  if(!(flags&128u)){reset_driver();first=3;}
  address=rw(0x8253u+index*2u);audio_music=cmd;
 }else if(cmd<0xd0u){
  address=rw(0x827bu+(cmd-0xa0u)*2u);flags=rd(address+2u);
  if(flags!=0xc0u&&flags!=0xe0u&&flags!=0xa0u){reset_driver();first=3;}
  else {
   if(flags==0xe0u){psg(0xdf);CH(6)[0]|=4;psg(0xe7);}
   first=8;
   if(flags==0xa0u){
    if(rd(address+11u)==0xe0u){psg(0xe7);CH(6)[0]|=4;CH(14)[0]|=4;psg(0xdf);}
    first=7;CH(4)[0]|=4;CH(12)[0]|=4;
   }
   psg(0xff);CH(5)[0]|=4;CH(13)[0]|=4;
  }
 }else if(cmd<0xd5u){address=rw(0x82dbu+(cmd-0xd0u)*2u);first=9;psg(0xff);psg(0xdf);}
 else {
  if(cmd==0xd5u){CH(8)[0]=CH(7)[0]=0;for(i=4;i<=6u;++i)CH(i)[0]&=0xfbu;for(i=13;i<=15u;++i)CH(i)[0]&=0xfbu;silence();acknowledge();}
  else if(cmd==0xd6u){if(CH(9)[0]&128u){CH(9)[0]=0;psg(0xdf);psg(0xff);}acknowledge();}
  else if(cmd==0xd9u)resume();
  else {if(cmd==0xd8u&&R[2]!=0x7fu)R[6]=128;R[11]=R[9]=10;fade_begin();}
  return;
 }
 count=rd(address++);
 if(first+count>15u){audio_fault=2;return;}
 for(i=0;i<count;++i){
  uint8_t *c=CH(first+i);for(j=0;j<9u;++j)c[j]=rd(address++);
  c[9]=32;c[10]=1;c[11]=c[12]=c[13]=0;volume(c);
 }
 acknowledge();
}
static void tempo(void){
 uint8_t i,first,count;
 if(!R[1]||--R[1])return;
 R[1]=R[2]&127u;first=(R[2]&128u)?0:10;count=(R[2]&128u)?7:5;
 for(i=0;i<count;++i)++CH(first+i)[10];
}
static void fade(void){
 uint8_t i,first,count,v;
 if(!R[10]||--R[11])return;
 if(R[10]&128u){
  R[11]=10;if(++R[10]==0x8bu){R[10]=0;CH(6)[0]&=0xfb;return;}
  for(i=0;i<6u;++i){v=CH(i)[8]-1u;if(!(v&128u)&&v>=CH(i)[23])CH(i)[8]=v;}return;
 }
 R[11]=R[9];
 if(++R[10]==12u){R[10]=0;if(R[2]==0x7fu)command(0x85);else if(!(R[2]&128u))reset_driver();else if(R[6])resume();return;}
 first=(R[2]&128u)?10:0;count=(R[2]&128u)?4:6;
 for(i=0;i<count;++i){v=CH(first+i)[8]+1u;if(v!=16u)CH(first+i)[8]=v;}
}
static void priority(void){
 if(!(CH(9)[0]&128u))return;
 if(CH(8)[0]&128u){CH(9)[0]|=4;return;}
 if((CH(9)[0]&64u)&&CH(9)[1]==0xe0u)CH(3)[0]|=4;
 CH(5)[0]|=4;
}
static void finish_channel(uint8_t *c){
 CH(9)[0]&=0xfb;R[8]=0;c[0]=0;psg(c[1]+31u);psg(0xe5);
 if(CH(4)[0]&128u){tone(CH(4)[1],cw(CH(4),14));CH(4)[0]&=0xfb;}
 CH(12)[0]&=0xfb;CH(14)[0]&=0xfb;CH(6)[0]&=0xfb;
 if(CH(5)[0]&128u){tone(CH(5)[1],cw(CH(5),14));CH(5)[0]&=0xfb;}
 CH(13)[0]&=0xfb;
}
/* Return0 terminates this channel update; return1 continues reading score. */
static uint8_t score_command(uint8_t *c,uint8_t op,uint16_t *pointer){
 uint16_t p=*pointer,target;uint8_t v=rd(p),slot;
 switch(op){
 case 0xee:c[2]+=v;break;
 case 0xef:case 0xfe:case 0xff:
  if(R[10]&128u)c[23]=(c[23]+v)&15u;else {c[8]=(c[8]+v)&15u;volume(c);}break;
 case 0xf0:if(v==1)c[7]|=3;else c[7]&=0xfc;break;
 case 0xf1:R[9]=R[11]=v;fade_begin();break;
 case 0xf2:finish_channel(c);return 0;
 case 0xf3:psg(v|0xe0u);if((v&3u)==3u)c[0]&=0xbf;else c[0]|=64;break;
 case 0xf4:c[6]=v;break;
 case 0xf5:if(v!=0x80u)c[7]=v;++p;break;
 case 0xf6:p=rw(p)-1u;break;
 case 0xf7:
  slot=24u+v;if(slot>=32u){audio_fault=3;return 0;}
  ++p;if(!c[slot])c[slot]=rd(p);++p;if(--c[slot])p=rw(p)-1u;else ++p;break;
 case 0xf8:
  target=rw(p);++p;--c[9];slot=c[9];--c[9];
  if(!slot||slot>=32u){audio_fault=4;return 0;}c[slot]=(uint8_t)(p>>8);c[slot-1]=(uint8_t)p;p=target-1u;break;
 case 0xf9:if(c[9]>30u){audio_fault=5;return 0;}p=cw(c,c[9]);c[9]+=2;break;
 case 0xfa:c[2]=v;break;
 case 0xfb:c[5]+=v;++p;break;
 case 0xfc:if(v==1){c[0]|=32;if(c[8])c[8]-=2;}else {c[0]&=0xdf;if(c[8])c[8]+=2;}break;
 case 0xfd:if(v==1)c[0]|=8;else c[0]&=0xf7;break;
 default:audio_fault=6;return 0;
 }
 *pointer=p+1u;return 1;
}
static void new_duration(uint8_t *c,uint8_t value,uint16_t pointer){
 /* multiplier0 means256 source additions, yielding0 in an8bit accumulator. */
 c[10]=c[21]=(uint8_t)(value*c[2]);
 c[12]=c[13]=c[11]=c[19]=c[20]=0;sw(c,3,pointer);
}
static void drum(uint8_t *c,uint8_t v){
 uint8_t instrument,attenuation;
 if(v&8u){instrument=2;attenuation=4;}
 else if(v&34u){instrument=(v&1u)?4:3;attenuation=5;}
 else if(v&5u){instrument=1;attenuation=6;}
 else {c[7]=0;psg(0xff);return;}
 if(v&4u)attenuation-=2;c[7]=instrument;c[8]=attenuation;
}
static uint8_t next_note(uint8_t *c,uint8_t rhythm){
 uint16_t p=cw(c,3),frequency;uint8_t v,n,guard=0;
 while(++guard){
  v=rd(p++);
  if(v>=0xe0u){if(!score_command(c,v,&p))return 0;continue;}
  if(rhythm){
   if(v&128u){drum(c,v);v=rd(p++);if(v&128u){--p;v=c[21];c[12]=c[13]=c[11]=c[19]=c[20]=0;c[10]=v;sw(c,3,p);return 1;}}
   new_duration(c,v,p);return 1;
  }
  if(c[0]&8u){frequency=((uint16_t)v<<8)|rd(p++);frequency+=(int8_t)c[5];sw(c,14,frequency);}
  else if(v>=128u){n=v-128u;if(n)n+=c[5];sw(c,14,rw(0x8874u+(uint16_t)n*2u));}
  else {new_duration(c,v,p);return 1;}
  if(c[0]&32u){c[18]=c[17]=rd(p++);if(!(c[0]&8u))c[17]=rd(p++);v=rd(p++);}
  else {v=rd(p);if(v&128u){c[10]=c[21];c[12]=c[13]=c[11]=c[19]=c[20]=0;sw(c,3,p);return 1;}++p;}
  new_duration(c,v,p);return 1;
 }
 audio_fault=7;return 0;
}
static uint8_t envelope(uint8_t *c,uint8_t *value){
 uint16_t base=rw(0xa877u+(uint16_t)(c[7]-1u)*2u);uint8_t v,guard=0;
 while(++guard){v=rd(base+c[12]);
  if(!(v&128u)){++c[12];v+=c[8];*value=(v&16u)?15:v;return 1;}
  if(v==0x82u){c[19]=31;psg(c[1]+31u);return 0;}
  if(v==0x81u){c[19]=255;return 0;}
  c[12]=(v==0x80u)?0:rd(base+c[12]+1u);
 }
 audio_fault=8;return 0;
}
static uint8_t modulation(uint8_t *c,uint16_t *frequency){
 uint16_t base=rw(0xa916u+(uint16_t)(c[6]-1u)*2u);uint8_t v,guard=0;
 while(++guard){v=rd(base+c[13]);
  if(!(v&128u)){++c[13];c[16]=v;*frequency+=v;return 1;}
  if(v==0x83u)c[13]=rd(base+c[13]+1u);
  else if(v==0x80u)c[13]=0;
  else {c[20]=255;return 0;}
 }
 audio_fault=9;return 0;
}
static void update_channel(uint8_t *c,uint8_t rhythm){
 uint8_t v,delta;uint16_t frequency;
 ++c[11];delta=c[10]-c[11];
 if(!delta){if(!next_note(c,rhythm))return;delta=128;}
 if(rhythm){
  if((c[0]&4u)||(c[19]&16u)||((uint8_t)(c[7]-1u)&128u))return;
  if(envelope(c,&v))psg(v|0xf0u);return;
 }
 R[12]=delta;
 if(delta!=128u&&(c[0]&32u)){R[12]=128;sw(c,14,cw(c,14)+(int8_t)c[18]);}
 if((c[0]&4u)||c[19]==31u)return;
 if(c[19]!=255u&&!((uint8_t)(c[7]-1u)&128u)){
  if(!envelope(c,&v))return;psg((uint8_t)((v|c[1])+16u));
 }
 if(!(R[12]&128u)&&(c[20]&128u))return;
 if(!(R[12]&128u)&&((uint8_t)(c[6]-1u)&128u))return;
 frequency=cw(c,14);
 if(!((uint8_t)(c[6]-1u)&128u)&&!modulation(c,&frequency))return;
 if(!(c[0]&64u))tone(c[1]==0xe0u?0xc0u:c[1],frequency);
}

/* Native hardware adapter. Keep original PSG state separately: the two chips
 * have different attenuation resolution, noise polynomials and phase behavior. */
uint16_t audio_gb_period(uint16_t divider,uint8_t wave) AUDIO_BANKED {
 return audio_apu_period[wave?1:0][divider&1023u];
}
uint8_t audio_gb_volume(uint8_t attenuation) AUDIO_BANKED {
 static const uint8_t levels[16]={15,12,9,8,6,5,4,3,2,2,2,1,1,1,1,0};
 return levels[attenuation&15u];
}
uint8_t audio_gb_noise(uint8_t control,uint16_t tone2) AUDIO_BANKED {
 uint8_t period=control&3u;
 return ((period==3u)?audio_apu_noise[tone2&1023u]:audio_apu_fixed_noise[period])|((control&4u)?0u:8u);
}
#ifdef __SDCC
static uint8_t previous_volume[4],previous_noise;
static void apu(void){
 uint8_t i,v,n,changed;uint16_t frequency;
 for(i=0;i<3u;++i){
  v=audio_tone[i]?audio_gb_volume(audio_volume[i]):0;frequency=audio_gb_period(audio_tone[i],i==2u);changed=(v!=previous_volume[i]);
  if(i==0){if(changed)NR12_REG=v<<4;NR13_REG=(uint8_t)frequency;NR14_REG=(frequency>>8)|(changed?128u:0u);}
  else if(i==1){if(changed)NR22_REG=v<<4;NR23_REG=(uint8_t)frequency;NR24_REG=(frequency>>8)|(changed?128u:0u);}
  else {
   if(changed){NR30_REG=0;for(n=0;n<16u;++n)_AUD3WAVERAM[n]=n<8u?((8u+v/2u)*17u):((8u-(v+1u)/2u)*17u);NR30_REG=128;NR32_REG=v?32:0;}
   NR33_REG=(uint8_t)frequency;NR34_REG=(frequency>>8)|(changed?128u:0u);
  }
  previous_volume[i]=v;
 }
 v=audio_gb_volume(audio_volume[3]);n=audio_gb_noise(audio_noise,audio_tone[2]);
 changed=(v!=previous_volume[3]||n!=previous_noise||noise_written);if(changed){NR42_REG=v<<4;NR43_REG=n;NR44_REG=128;}
 previous_volume[3]=v;previous_noise=n;noise_written=0;
}
#else
static void apu(void){}
#endif
void audio_init(void) AUDIO_BANKED {
 memset(R,0,sizeof(audio_ram));memset(audio_tone,0,sizeof(audio_tone));memset(audio_volume,15,sizeof(audio_volume));audio_fault=audio_music=0;audio_frames=0;audio_clock=0;latch=0;reset_driver();acknowledge();
#ifdef __SDCC
 NR52_REG=128;NR50_REG=0x77;NR51_REG=0xff;NR10_REG=0;NR11_REG=NR21_REG=0x80;NR12_REG=NR22_REG=NR42_REG=0;NR30_REG=0;memset(previous_volume,255,4);previous_noise=255;
#endif
 apu();
}
void audio_command(uint8_t cmd) AUDIO_BANKED {R[4]=cmd;}
void audio_stop(void) AUDIO_BANKED {
#ifdef __SDCC
 CRITICAL {
#endif
 reset_driver();acknowledge();audio_music=0;apu();
#ifdef __SDCC
 }
#endif
}
uint8_t audio_map_track(uint8_t map) AUDIO_BANKED {
 /* Original bank0 LABEL_DD9; indexed by source C309 mapID, not graphic group. */
 static const uint8_t tracks[24]={0x82,0x83,0x84,0x84,0x87,0x87,0x87,0x88,0x88,0x88,0x88,0x88,0x87,0x87,0x87,0x88,0x87,0x88,0x88,0x84,0x84,0x88,0x88,0x85};
 return map<24u?tracks[map]:0;
}
uint8_t audio_battle_track(uint8_t enemy) AUDIO_BANKED {return enemy==73u?0u:(enemy==72u?0x92u:0x89u);}
uint8_t audio_enemy_effect(uint8_t enemy) AUDIO_BANKED {return enemy&&enemy<75u?audio_enemy_sfx[enemy-1u]:0;}
void audio_tick(void) AUDIO_BANKED {
 uint8_t i,first,count,rhythm;
#ifndef __SDCC
 audio_trace_count=0;
#endif
 ++audio_frames;++audio_clock;tempo();fade();command(R[4]);priority();first=(R[2]&128u)?7:3;count=(R[2]&128u)?8:7;rhythm=(R[2]&128u)?14:6;
 for(i=first;i<first+count;++i)if(CH(i)[0]&128u)update_channel(CH(i),i==rhythm);
 apu();
}
