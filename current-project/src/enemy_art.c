#pragma bank 31
#include <gb/gb.h>
#include <gb/cgb.h>
#include "enemy_art.h"
#include "bank_io.h"
static uint8_t line[20];
static uint16_t colors[28];
uint8_t enemy_art_draw(uint8_t enemy) __banked {
    uint8_t y;const EnemyArt *a;
    if(!enemy||enemy>74u)return 0;
    a=&enemy_art[enemy-1u];
    bank_bkg_data(a->bank,0,a->tile_count,a->tiles,0);
    bank_copy(colors,a->bank,a->palettes,56);set_bkg_palette(0,7,colors);
    for(y=0;y<14u;++y) {
        bank_copy(line,a->bank,a->map+(uint16_t)y*20u,20);
        VBK_REG=0;set_bkg_tiles(0,y,20,1,line);
        bank_copy(line,a->bank,a->attrs+(uint16_t)y*20u,20);
        VBK_REG=1;set_bkg_tiles(0,y,20,1,line);
    }
    VBK_REG=0;move_bkg(0,0);return 1;
}
