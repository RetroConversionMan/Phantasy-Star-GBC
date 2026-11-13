#ifndef PS_MYAU_FLIGHT_DATA_H
#define PS_MYAU_FLIGHT_DATA_H
#include <stdint.h>
#define MYAU_FLIGHT_TILES 22u
#define MYAU_BATTLE_PALETTE_OFFSET 992u
extern const uint8_t myau_flight_data[];
typedef struct {uint16_t offset;uint8_t sprites;} MyauFlightFrame;
extern const MyauFlightFrame myau_flight_frames[8];
#endif
