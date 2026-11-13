#ifndef PS_UI_H
#define PS_UI_H
#include <stdint.h>
void ui_panel(uint8_t y,uint8_t rows) __banked;
void ui_text(uint8_t x,uint8_t y,const char *s) __banked;
void ui_number(uint8_t x,uint8_t y,uint16_t value) __banked;
#endif
