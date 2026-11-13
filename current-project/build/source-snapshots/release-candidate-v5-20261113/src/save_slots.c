#ifdef __SDCC
#pragma bank 122
#endif
#include "save_slots.h"
#include <string.h>
static const uint8_t characters[]="ABCDEFGHIJKLMNOPQRSTUVWXYZ,;.!?-\"\\]^";
static uint16_t checksum(const uint8_t *data) RPG_BANKED {
    uint16_t crc=65535u;uint8_t i,j;
    for(i=0;i<6u;++i){crc^=(uint16_t)data[i]<<8;for(j=0;j<8u;++j)crc=(crc&0x8000u)?(crc<<1)^0x1021u:crc<<1;}
    return crc;
}
static uint8_t valid_name(const char *name) RPG_BANKED {
    uint8_t i,j;
    for(i=0;i<5u;++i){
        if(name[i]==' ')continue;
        for(j=0;j<33u;++j)if(name[i]==characters[j])break;
        if(j==33u)return 0;
    }
    return 1;
}
uint16_t save_slot_offset(uint8_t slot) RPG_BANKED {return slot<5u?(uint16_t)slot*1024u:65535u;}
uint8_t save_label_encode(uint8_t data[8],const char name[5]) RPG_BANKED {
    uint16_t crc;if(!valid_name(name))return 0;
    memcpy(data,name,5u);data[5]=0xa5u;crc=checksum(data);data[6]=(uint8_t)crc;data[7]=crc>>8;return 1;
}
uint8_t save_label_decode(char name[5],const uint8_t data[8]) RPG_BANKED {
    uint16_t crc=checksum(data);
    if(data[5]!=0xa5u||data[6]!=(uint8_t)crc||data[7]!=(crc>>8)||!valid_name((const char *)data)){
        memset(name,' ',5u);return 0;
    }
    memcpy(name,data,5u);return 1;
}
uint8_t save_name_character(uint8_t option) RPG_BANKED {return option<36u?characters[option]:0;}
void save_name_begin(SaveName *e) RPG_BANKED {memset(e->name,' ',5u);e->cursor=e->option=0;}
void save_name_move(SaveName *e,int8_t dx,int8_t dy) RPG_BANKED {
    uint8_t x=e->option%6u,y=e->option/6u;
    if(dx<0&&x)--x;else if(dx>0&&x<5u)++x;
    if(dy<0&&y)--y;else if(dy>0&&y<5u)++y;
    e->option=y*6u+x;
}
uint8_t save_name_input(SaveName *e,uint8_t erase) RPG_BANKED {
    uint8_t c=save_name_character(e->option);
    if(erase){e->name[e->cursor]=' ';if(e->cursor)--e->cursor;return 0;}
    if(c<0x5cu){e->name[e->cursor]=c;if(e->cursor<4u)++e->cursor;}
    else if(c==0x5cu){if(e->cursor<4u)++e->cursor;}
    else if(c==0x5du){if(e->cursor)--e->cursor;}
    else if(c==0x5eu)return 1;
    return 0;
}
