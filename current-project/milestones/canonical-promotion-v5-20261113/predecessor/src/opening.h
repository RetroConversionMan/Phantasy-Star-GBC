#ifndef PS_OPENING_H
#define PS_OPENING_H
#include <stdint.h>
#define MOVIE_OPENING_CITY 1u
#define MOVIE_ENDING_BITMAP 2u
#define MOVIE_TITLE 3u
extern uint16_t opening_position;
/* LCD off for begin. Original224-tick pan, button1/2 may skip. The
 * 160x144 viewport crops48px horizontally and24px vertically from source.
 * Call tick once after each VBlank. Return1 means pan completed/skipped.
 * The caller owns source fades and the following180-frame skippable hold. */
void opening_begin(void) __banked;
uint8_t opening_tick(uint8_t skip_pressed) __banked;
/* Exact source city caption and ending group image adapted160x120.
 * LCD off, caller owns source180/208-frame holds respectively. */
uint8_t movie_scene_show(uint8_t image) __banked;
/* After the city fade-in, write its original caption; LCD may remain on. */
void movie_city_caption(void) __banked;
#endif
