#ifndef PS_SERVICES_H
#define PS_SERVICES_H
#include "events.h"
#define SERVICE_DONE 0u
#define SERVICE_DIALOGUE 1u
#define SERVICE_YES_NO 2u
#define SERVICE_PARTY 3u
#define SERVICE_GOODS 4u
#define SERVICE_ITEMS 5u
#define SERVICE_BUY_SELL 6u
#define SERVICE_EFFECT 7u /* Emit sound, then advance without a frame delay. */
#define SERVICE_WAIT 8u /* Emit sound, wait target frames (0=input), then advance. */
#define SERVICE_INVALID 255u
typedef struct {
    uint8_t kind;
    uint16_t dialogue_id,number;
    uint8_t item,character,target,sound;
} ServiceAction;
typedef struct {
    EventState *events;
    uint8_t type,shop,stage,character,slot,exp_character;
    ServiceAction action;
} ServiceState;
/* Bank19. Service state is transient; shared RPG and persistent event fields are authoritative.
 * Selection actions may include a dialogue_id to display before opening the selector;
 * rendering that message does not call advance. select255 is source cancel.
 * BUY_SELL selection0 buys,1 sells. GOODS selection is the zero-based shop option.
 */
const ServiceAction *service_begin(ServiceState *,EventState *,uint8_t type,uint8_t shop) RPG_BANKED;
const ServiceAction *service_advance(ServiceState *) RPG_BANKED;
const ServiceAction *service_respond(ServiceState *,uint8_t yes) RPG_BANKED;
const ServiceAction *service_select(ServiceState *,uint8_t selection) RPG_BANKED;
#endif
