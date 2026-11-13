/* Test-only link boundary while the actual ending-walk renderer is authored.
 * This is excluded from the production cartridge. It never completes credits,
 * so focused opening/flight tests cannot accidentally certify a fake ending. */
#pragma bank 121
#include "ending_walk.h"
void ending_walk_begin(uint8_t light) WORLD_BANKED {(void)light;}
uint8_t ending_walk_tick(void) WORLD_BANKED {return 0;}
