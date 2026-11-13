#pragma bank 1
#include <gb/gb.h>
#include <gb/cgb.h>
#include <string.h>
#include "ui.h"
static uint8_t tiles[20], attrs[20];
void ui_text(uint8_t x,uint8_t y,const char *s) __banked {
    uint8_t n=0,c;
    while(*s && n<20u-x) {c=(uint8_t)*s++;tiles[n++]=(c>=32u&&c<=95u)?c-32u:0u;}
    VBK_REG=0;set_win_tiles(x,y,n,1,tiles);
}
void ui_panel(uint8_t y,uint8_t rows) __banked {
    uint8_t row;
    memset(tiles,0,20);memset(attrs,15,20);
    for(row=0;row<rows;++row) {
        VBK_REG=0;set_win_tiles(0,row,20,1,tiles);
        VBK_REG=1;set_win_tiles(0,row,20,1,attrs);
    }
    VBK_REG=0;move_win(7,y);SHOW_WIN;
}
void ui_number(uint8_t x,uint8_t y,uint16_t value) __banked {
    char digits[6];uint8_t i=5;
    digits[i]=0;
    do {digits[--i]='0'+value%10u;value/=10u;} while(value&&i);
    ui_text(x,y,digits+i);
}
