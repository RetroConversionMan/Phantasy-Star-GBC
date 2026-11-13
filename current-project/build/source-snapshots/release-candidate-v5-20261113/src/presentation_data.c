#pragma bank 12
#include "presentation_data.h"
extern const uint8_t presentation_odin[];
extern const uint8_t presentation_torch[];
extern const uint8_t presentation_prism[];
extern const uint8_t presentation_ending_sky[];
const PresentationAsset presentation_assets[4]={
{128,30,31,7,presentation_odin},
{128,245,0,2,presentation_torch},
{128,181,0,38,presentation_prism},
{128,149,0,10,presentation_ending_sky}
};
