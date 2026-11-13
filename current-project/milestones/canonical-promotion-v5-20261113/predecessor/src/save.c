/* Native cartridge save v5 (v4 reads remain supported). Dungeon runtime doors reload, as in the SMS save. */
#ifdef __SDCC
#pragma bank 5
#endif
#include "save.h"
#include <string.h>
#ifdef __SDCC
/* Native in-place expansion needs these compact field offsets. */
typedef char SaveNativeSizeCheck[sizeof(GameSave)==SAVE_BYTES-6u?1:-1];
#endif

static uint16_t checksum(const uint8_t *p,uint16_t bytes) {
    uint16_t crc=0xffffu, i;
    uint8_t bit;
    for(i=0;i<bytes-2u;++i) {
        crc ^= (uint16_t)p[i] << 8;
        for(bit=0;bit<8;++bit) crc=(crc&0x8000u)?(crc<<1)^0x1021u:crc<<1;
    }
    return crc;
}
static uint8_t valid(const GameSave *s) {
    uint8_t i;
    if(s->map>=24u || s->facing>3u || s->x>=2048u || s->y>=1536u ||
       s->rpg.inventory_count>24u || !(s->rpg.joined_mask&1u) || (s->rpg.joined_mask&0xf0u)) return 0;
    if(s->dungeon_active>1u||s->dungeon_floor>=61u||s->dungeon_direction>3u)return 0;
    if((s->vehicle!=0u&&s->vehicle!=4u&&s->vehicle!=8u&&s->vehicle!=12u)||(s->dungeon_active&&s->vehicle))return 0;
    if(s->vehicle_phase>2u||s->vehicle_clock>3u)return 0;
    for(i=0;i<24u;++i) {
        uint8_t item=s->rpg.inventory[i];
        if(i<s->rpg.inventory_count ? (!item || item>63u) : item!=0) return 0;
    }
    for(i=0;i<4;++i) {
        const RPGCharacter *c=&s->rpg.party[i];
        if((s->rpg.joined_mask&(1u<<i)) && (!c->level || c->level>30u)) return 0;
        if(c->hp>c->max_hp || c->mp>c->max_mp || c->weapon>63u || c->armor>63u ||
           c->shield>63u || c->battle_magic_count>5u || c->map_magic_count>5u) return 0;
    }
    return 1;
}
static void put16_back(uint8_t **p,uint16_t v) { *--*p=(uint8_t)(v>>8); *--*p=(uint8_t)v; }
static uint16_t get16(const uint8_t **p) {uint16_t v=*(*p)++;v|=(uint16_t)*(*p)++<<8;return v;}

uint8_t save_encode(uint8_t *out,const GameSave *s) RPG_BANKED {
    uint8_t *p=out+SAVE_BYTES-2u;
    uint16_t i,crc;
    if(!valid(s)) return 0;
    /* Write backwards so the native caller can share a628-byte union with its
     * unpacked state. The format still writes every field explicitly. */
    *--p=s->vehicle_clock;*--p=s->vehicle_phase;
    *--p=s->vehicle;*--p=s->dungeon_light;*--p=s->dungeon_direction;*--p=s->dungeon_position;
    *--p=s->dungeon_floor;*--p=s->dungeon_active;
    for(i=256u;i;) {*--p=s->object_flags[--i];}
    *--p=s->last_church;*--p=s->secrets_requests;
    for(i=256u;i;) {*--p=s->flags[--i];}
    put16_back(&p,s->rpg.rng);put16_back(&p,s->rpg.money);
    *--p=s->rpg.joined_mask;*--p=s->rpg.inventory_count;
    for(i=24u;i;) {*--p=s->rpg.inventory[--i];}
    for(i=4u;i;) {
        const RPGCharacter *c=&s->rpg.party[--i];
        *--p=c->map_magic_count;*--p=c->battle_magic_count;*--p=c->bound;
        *--p=c->shield;*--p=c->armor;*--p=c->weapon;*--p=c->defense;*--p=c->attack;
        *--p=c->max_mp;*--p=c->max_hp;*--p=c->level;put16_back(&p,c->exp);
        *--p=c->mp;*--p=c->hp;*--p=c->status;
    }
    put16_back(&p,s->y);put16_back(&p,s->x);*--p=s->facing;*--p=s->map;
    out[0]='P';out[1]='S';out[2]='G';out[3]=SAVE_VERSION;
    crc=checksum(out,SAVE_BYTES);out[SAVE_BYTES-2u]=(uint8_t)crc;out[SAVE_BYTES-1u]=(uint8_t)(crc>>8);
    return 1;
}
uint8_t save_decode(GameSave *s,const uint8_t *data) RPG_BANKED {
    const uint8_t *p=data+4;
    uint8_t i,version=data[3];
    uint16_t bytes=version==4u?626u:SAVE_BYTES,crc=checksum(data,bytes);
    if(data[0]!='P'||data[1]!='S'||data[2]!='G'||(version!=4u&&version!=SAVE_VERSION) ||
       data[bytes-2u]!=(uint8_t)crc || data[bytes-1u]!=(uint8_t)(crc>>8)) return 0;
    s->map=*p++;s->facing=*p++;s->x=get16(&p);s->y=get16(&p);
    for(i=0;i<4;++i) {
        RPGCharacter *c=&s->rpg.party[i];
        c->status=*p++;c->hp=*p++;c->mp=*p++;c->exp=get16(&p);
        c->level=*p++;c->max_hp=*p++;c->max_mp=*p++;c->attack=*p++;c->defense=*p++;
        c->weapon=*p++;c->armor=*p++;c->shield=*p++;c->bound=*p++;
        c->battle_magic_count=*p++;c->map_magic_count=*p++;
    }
    memmove(s->rpg.inventory,p,24);p+=24;
    s->rpg.inventory_count=*p++;s->rpg.joined_mask=*p++;
    s->rpg.money=get16(&p);s->rpg.rng=get16(&p);
    memmove(s->flags,p,256);p+=256;
    s->secrets_requests=*p++;
    s->last_church=*p++;
    memmove(s->object_flags,p,256);p+=256;
    s->dungeon_active=*p++;s->dungeon_floor=*p++;s->dungeon_position=*p++;
    s->dungeon_direction=*p++;s->dungeon_light=*p++;
    s->vehicle=*p++;
    if(version==4u)s->vehicle_phase=s->vehicle_clock=0;
    else {s->vehicle_phase=*p++;s->vehicle_clock=*p++;}
    return valid(s);
}
