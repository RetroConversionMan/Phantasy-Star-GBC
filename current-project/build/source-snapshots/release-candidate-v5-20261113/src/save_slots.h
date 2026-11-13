#ifndef PS_SAVE_SLOTS_H
#define PS_SAVE_SLOTS_H
#include "rpg.h"
#define SAVE_SLOT_COUNT 5u
#define SAVE_SLOT_STRIDE 1024u
#define SAVE_LABEL_OFFSET 5120u
#define SAVE_LABEL_BYTES 8u
typedef struct {char name[5];uint8_t cursor,option;} SaveName;
/* Original five game slots, with native626-byte records in1024-byte strides.
 * Slot0 retains the earlier cartridge record atA000. Labels are a separate
 * version-independent native directory; invalid labels never invalidate games. */
uint16_t save_slot_offset(uint8_t slot) RPG_BANKED;
uint8_t save_label_decode(char name[5],const uint8_t data[8]) RPG_BANKED;
uint8_t save_label_encode(uint8_t data[8],const char name[5]) RPG_BANKED;
/* Original LABEL_4280 repertoire and GameMode_NameInput actions, adapted to a
 * six-column native grid. A enters/advances; B erases current then backs up;
 * selector codes5C/5D/5E mean advance/back/end. Characters never wrap at5. */
uint8_t save_name_character(uint8_t option) RPG_BANKED;
void save_name_begin(SaveName *editor) RPG_BANKED;
void save_name_move(SaveName *editor,int8_t dx,int8_t dy) RPG_BANKED;
uint8_t save_name_input(SaveName *editor,uint8_t erase) RPG_BANKED;
#endif
