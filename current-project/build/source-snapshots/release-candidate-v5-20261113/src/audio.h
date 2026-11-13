/* Native source-score interpreter and Game Boy Color APU adapter. */
#ifndef PS_AUDIO_H
#define PS_AUDIO_H
#include <stdint.h>
#ifdef __SDCC
#define AUDIO_BANKED __banked
#define AUDIO_FIXED __nonbanked
#else
#define AUDIO_BANKED
#define AUDIO_FIXED
#endif
#define AUDIO_RAM_SIZE 512u
/* Preserves C000..C1FF sound RAM layout for independent machine-code tests. */
extern uint8_t audio_ram[AUDIO_RAM_SIZE];
extern uint16_t audio_tone[3];
extern uint8_t audio_volume[4],audio_noise,audio_fault,audio_music;
extern uint16_t audio_frames;
extern volatile uint8_t audio_clock;
void audio_init(void) AUDIO_BANKED;
void audio_command(uint8_t command) AUDIO_BANKED;
void audio_tick(void) AUDIO_BANKED;
void audio_stop(void) AUDIO_BANKED;
/* Install once during startup; reserves STAT LY==LYC0 interrupt, once/frame.
 * Main-thread commands are one-byte mailboxes. LCD-off pauses advancement. */
void audio_install(void) AUDIO_FIXED;
/* Original world-IRQ motor order: discard the older mailbox command, consume
 * this effect on the next real score tick, then retain any later ordinary
 * command. Motor caller passes D0 or D1; this never adds a score tick. */
void audio_command_before_tick(uint8_t command) AUDIO_FIXED;
uint8_t audio_map_track(uint8_t map) AUDIO_BANKED;
/* Zero means preserve the current track (original DarkFalz battle entry). */
uint8_t audio_battle_track(uint8_t enemy) AUDIO_BANKED;
uint8_t audio_enemy_effect(uint8_t enemy) AUDIO_BANKED;
/* Pure source->APU conversions are exported for accuracy tests. */
uint16_t audio_gb_period(uint16_t divider,uint8_t wave) AUDIO_BANKED;
uint8_t audio_gb_volume(uint8_t attenuation) AUDIO_BANKED;
uint8_t audio_gb_noise(uint8_t control,uint16_t tone2) AUDIO_BANKED;
#endif
