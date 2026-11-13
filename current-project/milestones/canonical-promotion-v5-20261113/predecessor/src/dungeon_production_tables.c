#pragma bank 0
#include "dungeon_graphics.h"
#include "dungeon_views.h"
extern const uint8_t dungeon_production_data[];
const DungeonGraphicAsset dungeon_view_index={20,dungeon_production_data},dungeon_view_front={20,dungeon_production_data+8192};
const DungeonGraphicAsset dungeon_graphic_palettes[12]={
{20,dungeon_production_data+8224},
{20,dungeon_production_data+8628},
{20,dungeon_production_data+9032},
{20,dungeon_production_data+9436},
{20,dungeon_production_data+9840},
{20,dungeon_production_data+10244},
{20,dungeon_production_data+10648},
{20,dungeon_production_data+11052},
{20,dungeon_production_data+11456},
{20,dungeon_production_data+11860},
{20,dungeon_production_data+12264},
{20,dungeon_production_data+12668},
};
