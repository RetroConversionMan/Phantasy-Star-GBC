#ifndef PS_MYAU_FLIGHT_H
#define PS_MYAU_FLIGHT_H
#include <stdint.h>
extern uint16_t myau_flight_frame;
/* LCD off: load source scene15 and actor15/16 poses84..8B. return_trip is
 * source C309==23. Tick once/VBlank; caller playsB9 when frame becomes1.
 * Return1 after507 ticks outbound /571 return, including18B9 final VBlank.
 * Caller owns fades, GoldDragon70 battle and original map destinations. */
uint8_t myau_flight_begin(uint8_t return_trip) __banked;
uint8_t myau_flight_tick(void) __banked;
/* Source4497:all OBJ source colors30, then restore low8 fromB11_8000. */
void myau_battle_palette(uint8_t restore) __banked;
#endif
