#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "save.h"
static unsigned checks;
#define CHECK(x) do {++checks;assert(x);} while(0)
static uint16_t legacy_crc(const uint8_t *p) {
    uint16_t crc=65535u;unsigned i,j;
    for(i=0;i<624u;++i){crc^=(uint16_t)p[i]<<8;for(j=0;j<8u;++j)crc=(crc&32768u)?(crc<<1)^0x1021u:crc<<1;}
    return crc;
}
int main(void) {
    GameSave a,b;uint8_t bytes[SAVE_BYTES+2],again[SAVE_BYTES];unsigned i,bit;
    memset(&a,0,sizeof(a));rpg_new_game(&a.rpg);
    a.vehicle_phase=2;a.vehicle_clock=3;
    a.map=4;a.facing=3;a.x=1688;a.y=304;a.secrets_requests=2;a.last_church=9;
    a.rpg.money=65535;a.rpg.rng=0x9a34;
    a.dungeon_active=1;a.dungeon_floor=60;a.dungeon_position=255;a.dungeon_direction=3;a.dungeon_light=2;
    CHECK(rpg_add_item(&a.rpg,ItemID_LaconiaPot)==RPG_OK);
    CHECK(rpg_add_item(&a.rpg,ItemID_RoadPass)==RPG_OK);
    for(i=0;i<256;++i){a.flags[i]=(uint8_t)i;a.object_flags[i]=(uint8_t)(255-i);}
    memset(bytes,0xa5,sizeof(bytes));
    CHECK(save_encode(bytes,&a));CHECK(bytes[SAVE_BYTES]==0xa5&&bytes[SAVE_BYTES+1]==0xa5);
    CHECK(!memcmp(bytes,"PSG\5",4));
    CHECK(bytes[4]==4&&bytes[5]==3&&bytes[6]==0x98&&bytes[7]==6&&bytes[8]==0x30&&bytes[9]==1);
    CHECK(save_decode(&b,bytes));CHECK(b.rpg.money==65535&&b.rpg.rng==0x9a34);
    CHECK(b.dungeon_active==1&&b.dungeon_floor==60&&b.dungeon_position==255&&b.dungeon_direction==3&&b.dungeon_light==2);
    CHECK(b.secrets_requests==2&&b.last_church==9&&!memcmp(a.flags,b.flags,256)&&!memcmp(a.object_flags,b.object_flags,256));
    CHECK(b.vehicle_phase==2&&b.vehicle_clock==3);
    CHECK(save_encode(again,&b));CHECK(!memcmp(bytes,again,SAVE_BYTES));
    for(i=0;i<SAVE_BYTES;++i)for(bit=0;bit<8;++bit) {
        bytes[i]^=1u<<bit;CHECK(!save_decode(&b,bytes));bytes[i]^=1u<<bit;
    }
    CHECK(save_decode(&b,bytes));
    for(i=0;i<24;++i) {
        a.map=i;a.x=(i*97u)%2048u;a.y=(i*67u)%1536u;a.facing=i%4;
        CHECK(save_encode(bytes,&a));CHECK(save_decode(&b,bytes));
        CHECK(a.map==b.map&&a.x==b.x&&a.y==b.y&&a.facing==b.facing);
    }
    for(i=0;i<12u;++i) {
        uint16_t crc;a.vehicle_phase=i%3u;a.vehicle_clock=i/3u;
        CHECK(save_encode(bytes,&a));CHECK(save_decode(&b,bytes));
        CHECK(b.vehicle_phase==a.vehicle_phase&&b.vehicle_clock==a.vehicle_clock);
        bytes[3]=4;crc=legacy_crc(bytes);bytes[624]=(uint8_t)crc;bytes[625]=crc>>8;
        CHECK(save_decode(&b,bytes));CHECK(b.vehicle_phase==0&&b.vehicle_clock==0);
        CHECK(b.rpg.rng==a.rpg.rng&&b.x==a.x&&b.y==a.y&&!memcmp(b.flags,a.flags,256));
    }
    a.vehicle_phase=3;CHECK(!save_encode(bytes,&a));a.vehicle_phase=0;
    a.vehicle_clock=4;CHECK(!save_encode(bytes,&a));a.vehicle_clock=0;
    a.map=24;CHECK(!save_encode(bytes,&a));a.map=0;
    a.x=2048;CHECK(!save_encode(bytes,&a));a.x=0;
    a.y=1536;CHECK(!save_encode(bytes,&a));a.y=0;
    a.facing=4;CHECK(!save_encode(bytes,&a));a.facing=0;
    a.dungeon_floor=61;CHECK(!save_encode(bytes,&a));a.dungeon_floor=0;
    a.dungeon_direction=4;CHECK(!save_encode(bytes,&a));a.dungeon_direction=0;
    a.dungeon_active=2;CHECK(!save_encode(bytes,&a));a.dungeon_active=0;
    for(i=0;i<4;++i){a.vehicle=i*4;CHECK(save_encode(bytes,&a));CHECK(save_decode(&b,bytes));CHECK(b.vehicle==a.vehicle);}
    a.vehicle=3;CHECK(!save_encode(bytes,&a));a.vehicle=0;
    a.rpg.inventory_count=25;CHECK(!save_encode(bytes,&a));a.rpg.inventory_count=2;
    a.rpg.inventory[0]=64;CHECK(!save_encode(bytes,&a));a.rpg.inventory[0]=ItemID_RoadPass;
    a.rpg.party[0].level=31;CHECK(!save_encode(bytes,&a));a.rpg.party[0].level=1;
    a.rpg.party[0].hp=a.rpg.party[0].max_hp+1;CHECK(!save_encode(bytes,&a));
    memset(bytes,0,sizeof(bytes));memcpy(bytes,"PSW\1",4);CHECK(!save_decode(&b,bytes));
    printf("%u save assertions passed\n",checks);return 0;
}
