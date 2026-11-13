#pragma bank 0
#include "world_assets.h"

extern const uint8_t world_g00_map[];
extern const uint8_t world_g00_metatiles[];
extern const uint8_t world_g00_collision[];
extern const uint8_t world_g00_tiles[];
extern const uint16_t world_g00_palettes[];
extern const WorldExit world_g00_exits[];
extern const uint8_t world_g01_map[];
extern const uint8_t world_g01_metatiles[];
extern const uint8_t world_g01_collision[];
extern const uint8_t world_g01_tiles[];
extern const uint16_t world_g01_palettes[];
extern const WorldExit world_g01_exits[];
extern const uint8_t world_g02_map[];
extern const uint8_t world_g02_metatiles[];
extern const uint8_t world_g02_collision[];
extern const uint8_t world_g02_tiles[];
extern const uint16_t world_g02_palettes[];
extern const WorldExit world_g02_exits[];
extern const uint8_t world_g03_map[];
extern const uint8_t world_g03_metatiles[];
extern const uint8_t world_g03_collision[];
extern const uint8_t world_g03_tiles[];
extern const uint16_t world_g03_palettes[];
extern const WorldExit world_g03_exits[];
extern const uint8_t world_g04_map[];
extern const uint8_t world_g04_metatiles[];
extern const uint8_t world_g04_collision[];
extern const uint8_t world_g04_tiles[];
extern const uint16_t world_g04_palettes[];
extern const WorldExit world_g04_exits[];
extern const uint8_t world_g05_map[];
extern const uint8_t world_g05_metatiles[];
extern const uint8_t world_g05_collision[];
extern const uint8_t world_g05_tiles[];
extern const uint16_t world_g05_palettes[];
extern const WorldExit world_g05_exits[];
extern const uint8_t world_g06_map[];
extern const uint8_t world_g06_metatiles[];
extern const uint8_t world_g06_collision[];
extern const uint8_t world_g06_tiles[];
extern const uint16_t world_g06_palettes[];
extern const WorldExit world_g06_exits[];
extern const uint8_t world_g07_map[];
extern const uint8_t world_g07_metatiles[];
extern const uint8_t world_g07_collision[];
extern const uint8_t world_g07_tiles[];
extern const uint16_t world_g07_palettes[];
extern const WorldExit world_g07_exits[];
extern const uint8_t world_g08_map[];
extern const uint8_t world_g08_metatiles[];
extern const uint8_t world_g08_collision[];
extern const uint8_t world_g08_tiles[];
extern const uint16_t world_g08_palettes[];
extern const WorldExit world_g08_exits[];
extern const uint8_t world_g09_map[];
extern const uint8_t world_g09_metatiles[];
extern const uint8_t world_g09_collision[];
extern const uint8_t world_g09_tiles[];
extern const uint16_t world_g09_palettes[];
extern const WorldExit world_g09_exits[];
extern const uint8_t world_g10_map[];
extern const uint8_t world_g10_metatiles[];
extern const uint8_t world_g10_collision[];
extern const uint8_t world_g10_tiles[];
extern const uint16_t world_g10_palettes[];
extern const WorldExit world_g10_exits[];

const uint8_t world_map_group[24] = {
    0x00,0x01,0x02,0x03,0x04,0x04,0x04,0x05,0x05,0x05,0x05,0x05,0x06,0x06,0x07,0x07,
    0x07,0x07,0x07,0x08,0x08,0x09,0x09,0x0a
};

const uint8_t world_map_music[24] = {
    0x82,0x83,0x84,0x84,0x87,0x87,0x87,0x88,0x88,0x88,0x88,0x88,0x87,0x87,0x87,0x88,
    0x87,0x88,0x88,0x84,0x84,0x88,0x88,0x85
};

const WorldScene world_scenes[WORLD_GROUP_COUNT] = {
    {32, 33, 308, world_g00_map, world_g00_metatiles, world_g00_collision, world_g00_tiles, world_g00_palettes, world_g00_exits, 46 },
    {34, 35, 182, world_g01_map, world_g01_metatiles, world_g01_collision, world_g01_tiles, world_g01_palettes, world_g01_exits, 24 },
    {36, 37, 120, world_g02_map, world_g02_metatiles, world_g02_collision, world_g02_tiles, world_g02_palettes, world_g02_exits, 17 },
    {38, 39, 120, world_g03_map, world_g03_metatiles, world_g03_collision, world_g03_tiles, world_g03_palettes, world_g03_exits, 0 },
    {40, 41, 227, world_g04_map, world_g04_metatiles, world_g04_collision, world_g04_tiles, world_g04_palettes, world_g04_exits, 96 },
    {42, 43, 154, world_g05_map, world_g05_metatiles, world_g05_collision, world_g05_tiles, world_g05_palettes, world_g05_exits, 47 },
    {44, 45, 126, world_g06_map, world_g06_metatiles, world_g06_collision, world_g06_tiles, world_g06_palettes, world_g06_exits, 120 },
    {46, 47, 333, world_g07_map, world_g07_metatiles, world_g07_collision, world_g07_tiles, world_g07_palettes, world_g07_exits, 102 },
    {48, 49, 52, world_g08_map, world_g08_metatiles, world_g08_collision, world_g08_tiles, world_g08_palettes, world_g08_exits, 42 },
    {50, 51, 186, world_g09_map, world_g09_metatiles, world_g09_collision, world_g09_tiles, world_g09_palettes, world_g09_exits, 39 },
    {52, 53, 66, world_g10_map, world_g10_metatiles, world_g10_collision, world_g10_tiles, world_g10_palettes, world_g10_exits, 6 },
};
