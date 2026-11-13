/* Scanline0 entry remains in ROM0; banked trampoline restores the caller.
 * A full score tick can exceed VBlank's10 scanlines. Running at LY0 preserves
 * GBDK display_off()'s VBlank window and gives exactly one tick per LCD frame.
 * Motor effects precede the source score tick; a later main-thread command
 * remains pending for the following tick (original235 / 7C18 / 7143). */
#ifdef __SDCC
#pragma bank 0
#include <gb/gb.h>
#endif
#include "audio.h"
static volatile uint8_t audio_before_tick;
void audio_command_before_tick(uint8_t command) AUDIO_FIXED {
#ifdef __SDCC
 CRITICAL {
#endif
  /* An expired motor replaces the OLD C004. 80 is the source idle/ack
   * value; zero would reset the score driver. Preserve only later writes. */
  audio_ram[4]=0x80u;
  audio_before_tick=command;
#ifdef __SDCC
 }
#endif
}
#ifdef __SDCC
static void audio_scanline(void) AUDIO_FIXED {
 uint8_t command=audio_before_tick,later;
 if(command) {
  audio_before_tick=0;
  later=audio_ram[4];
  audio_ram[4]=command;
  audio_tick();
  if(later!=0x80u)audio_ram[4]=later;
 } else audio_tick();
}
void audio_install(void) AUDIO_FIXED {
 CRITICAL {audio_before_tick=0;audio_init();LYC_REG=0;STAT_REG|=0x40;add_LCD(audio_scanline);IE_REG|=LCD_IFLAG;}
}
#else
void audio_install(void){audio_before_tick=0;audio_init();}
#endif
