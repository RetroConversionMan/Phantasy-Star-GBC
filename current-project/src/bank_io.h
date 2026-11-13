/* ROM0 transfer helpers. They always restore the caller's selected ROM bank. */
#ifndef PS_BANK_IO_H
#define PS_BANK_IO_H
#include <stdint.h>
#ifdef __SDCC
#define BANK_IO_FIXED __nonbanked
#else
#define BANK_IO_FIXED
#endif
uint8_t bank_read8(uint8_t bank, const void *address) BANK_IO_FIXED;
void bank_copy(void *destination, uint8_t bank, const void *source, uint16_t length) BANK_IO_FIXED;
/* count==0 means 256 tiles, as in the GBDK API. LCD must be off for bulk loads. */
void bank_bkg_data(uint8_t bank, uint8_t first, uint8_t count, const uint8_t *source, uint8_t vram_bank) BANK_IO_FIXED;
/* Atomic CGB pattern phase: 1..16 contiguous tiles, 16-byte-aligned ROM data.
 * Waits for early VBlank if LCD is active; preserves ROM/VRAM banks. */
void bank_bkg_phase(uint8_t bank, uint8_t first, uint8_t count, const uint8_t *source, uint8_t vram_bank) BANK_IO_FIXED;
#endif
