#pragma bank 17
#include "dungeon.h"
#include "bank_io.h"
#include <string.h>
static uint8_t object_record(uint8_t floor,uint8_t position,DungeonObject *object) {
    uint8_t i,row[7];
    for(i=0;i<DUNGEON_OBJECT_COUNT;++i) {
        bank_copy(row,DUNGEON_DATA_BANK,dungeon_objects+(uint16_t)i*7u,7u);
        if(row[0]==floor && row[1]==position) {
            object->flag_address=(uint16_t)row[2]|((uint16_t)row[3]<<8);
            object->type=row[4];object->a=row[5];object->b=row[6];object->position=position;
            return 1;
        }
    }
    return 0;
}
void dungeon_refresh_light(DungeonState *state) DUNGEON_BANKED {
    uint8_t info[4],lit[6],i,natural=0;
    bank_copy(info,DUNGEON_DATA_BANK,dungeon_floor_info+(uint16_t)state->floor*4u,4u);
    state->encounter_rate=info[0];state->encounter_pool=info[1];state->music=info[3];
    bank_copy(lit,DUNGEON_DATA_BANK,dungeon_naturally_lit,6u);
    for(i=0;i<6u;++i) if(lit[i]==state->floor) natural=1;
    state->light=(state->light || natural)?info[2]+1u:0u;
    state->palette_index=state->light;
}
uint8_t dungeon_load_floor(DungeonState *state,uint8_t floor) DUNGEON_BANKED {
    uint8_t raw[128],i;
    if(floor>=DUNGEON_FLOOR_COUNT) return 0;
    bank_copy(raw,DUNGEON_DATA_BANK,dungeon_layouts+(uint16_t)floor*128u,128u);
    for(i=0;i<128u;++i) {
        state->layout[(uint16_t)i*2u]=raw[i]>>4;
        state->layout[(uint16_t)i*2u+1u]=raw[i]&15u;
    }
    state->floor=floor;dungeon_refresh_light(state);return 1;
}
uint8_t dungeon_enter(DungeonState *state,uint8_t floor,uint8_t position,uint8_t direction) DUNGEON_BANKED {
    if(floor>=DUNGEON_FLOOR_COUNT || direction>3u) return 0;
    memset(state,0,sizeof(*state));state->position=position;state->direction=direction;
    return dungeon_load_floor(state,floor);
}
uint8_t dungeon_sample_position(const DungeonState *state,uint8_t view) DUNGEON_BANKED {
    uint8_t offset;
    if(view>15u) return state->position;
    offset=bank_read8(DUNGEON_DATA_BANK,dungeon_view_offsets+(state->direction&3u)*16u+view);
    return state->position+offset;
}
uint8_t dungeon_sample(const DungeonState *state,uint8_t view) DUNGEON_BANKED {
    return state->layout[dungeon_sample_position(state,view)]&127u;
}
uint8_t dungeon_find_object(const DungeonState *state,uint8_t view,DungeonObject *object) DUNGEON_BANKED {
    uint8_t position=dungeon_sample_position(state,view);
    memset(object,0,sizeof(*object));
    if((state->layout[position]&127u)!=8u) return 0;
    if(!object_record(state->floor,position,object)) return 0;
    object->view=view;return 1;
}
uint8_t dungeon_active_object(const DungeonState *state,uint8_t view,
    const uint8_t *story_flags,const uint8_t *object_flags,DungeonObject *object) DUNGEON_BANKED {
    uint8_t value;
    if(!dungeon_find_object(state,view,object)) return 0;
    if((object->flag_address>>8)==0xc5u) value=story_flags[(uint8_t)object->flag_address];
    else value=object_flags[(uint8_t)object->flag_address];
    return value!=255u;
}
uint8_t dungeon_transition(const DungeonState *state,DungeonAction *action) DUNGEON_BANKED {
    uint8_t position=dungeon_sample_position(state,1u),i,row[5];
    memset(action,0,sizeof(*action));
    if(!(state->layout[position]&8u)) return 0;
    for(i=0;i<DUNGEON_TRANSITION_COUNT;++i) {
        bank_copy(row,DUNGEON_DATA_BANK,dungeon_transitions+(uint16_t)i*5u,5u);
        if(row[0]==state->floor && row[1]==position) {
            action->target=row[2];action->a=row[3];action->b=row[4];
            if(row[2]<128u) action->mode=DUNGEON_MAP;
            else {
                action->mode=DUNGEON_INTERACTION;
                /* FC goes to the current interaction context without changing it. */
                action->interaction=row[2]==255u?15u:row[2]==254u?13u:row[2]==253u?30u:255u;
            }
            return action->mode;
        }
    }
    action->mode=DUNGEON_EXIT_SAVED;return action->mode;
}
uint8_t dungeon_step(DungeonState *state,uint8_t command,DungeonAction *action) DUNGEON_BANKED {
    uint8_t position,type,cell,delta,new_floor,count=1;
    DungeonObject object;
    memset(action,0,sizeof(*action));
    if(state->floor>=DUNGEON_FLOOR_COUNT || state->direction>3u || command>DUNGEON_CMD_ACTION) {
        action->mode=DUNGEON_INVALID;return action->mode;
    }
    /* LABEL_65EE checks record existence, not whether its flag is already FF. */
    if(state->layout[state->position]==8u && !object_record(state->floor,state->position,&object)) {
        new_floor=state->floor?state->floor-1u:0u;
        dungeon_load_floor(state,new_floor);action->mode=DUNGEON_FELL;
        action->target=new_floor;return action->mode;
    }
    if(command==DUNGEON_CMD_LEFT || command==DUNGEON_CMD_RIGHT) {
        state->direction=(state->direction+(command==DUNGEON_CMD_LEFT?3u:1u))&3u;
        action->mode=DUNGEON_TURNED;return action->mode;
    }
    if(command==DUNGEON_CMD_NONE) return 0;
    position=dungeon_sample_position(state,command==DUNGEON_CMD_BACK?11u:1u);
    cell=state->layout[position];type=cell&7u;
    if(command==DUNGEON_CMD_ACTION) {
        if(type==4u && !(cell&128u)) {
            state->layout[position]|=128u;action->mode=DUNGEON_OPENED;
        } else action->mode=DUNGEON_MENU;
        return action->mode;
    }
    if(command==DUNGEON_CMD_BACK) {
        if(type) return 0;
        state->position=position;action->mode=DUNGEON_MOVED;
        action->step_count=1u;action->positions[0]=position;return action->mode;
    }
    if(type==1u) return 0;
    if(type==2u || type==3u) {
        if(cell&8u) return dungeon_transition(state,action);
        new_floor=state->floor+(type==2u?1u:255u);
        if(!dungeon_load_floor(state,new_floor)) {action->mode=DUNGEON_INVALID;return action->mode;}
        action->mode=DUNGEON_CHANGED_FLOOR;action->target=new_floor;count=2;
    } else if(type>=4u && type<=6u) {
        if(!(cell&128u)) return 0;
        if(cell&8u) return dungeon_transition(state,action);
        count=2;
    } else if(type==7u) count=2;
    if(!action->mode) action->mode=DUNGEON_MOVED;
    delta=position-state->position;
    action->positions[0]=position;action->step_count=count;
    if(count==2u) {
        action->positions[1]=position+delta;state->position=action->positions[1];
    } else state->position=position;
    return action->mode;
}
