#ifndef PS_ENDING_UPLOAD_H
#define PS_ENDING_UPLOAD_H
#include "ending_walk_data.h"
#include "bank_io.h"
extern uint16_t ending_uploaded_patterns;
extern uint8_t ending_upload_buffer,ending_upload_fault;
/* Prepare the inactive pattern/map buffer in existing dungeon scratch RAM.
 * step performs short synchronous HBlank DMA chunks; it never leaves DMA active
 * across a return/bank switch. commit switches maps only after step completes. */
void ending_upload_begin(uint8_t bank,const uint8_t *data,uint8_t target) BANK_IO_FIXED;
uint8_t ending_upload_step(void) BANK_IO_FIXED;
void ending_upload_commit(void) BANK_IO_FIXED;
void ending_upload_home(void) BANK_IO_FIXED;
#endif
