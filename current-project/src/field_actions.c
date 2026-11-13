/* Native field actions from source1E27..2159,22A8..264x; presentation emitted. */
#ifdef __SDCC
#pragma bank 11
#endif
#include "field_actions.h"
#include <string.h>
static void line(FieldAction *a,uint16_t id){if(a->line_count<3u)a->lines[a->line_count++].dialogue=id;}
static uint8_t fail(FieldAction *a,uint8_t error,uint16_t id){a->error=error;if(id)line(a,id);return a->kind;}
static uint8_t alive(const RPGState *s,uint8_t c){return c<4u&&(s->joined_mask&(1u<<c))&&(s->party[c].status&1u);}
static uint8_t floor_trap(FieldContext *c){
 DungeonObject object;
 /* LABEL684A returnsFF only for an08cell without a matching object record.
  * This intentionally ignores whether a listed object's persistent flag isFF. */
 return c->dungeon && dungeon_sample(c->dungeon,1u)==8u && !dungeon_find_object(c->dungeon,1u,&object);
}
static void transfer(FieldContext *c,FieldAction *a){
 static const uint8_t places[9][3]={{4,0x16,0x69},{4,0x27,0x6b},{7,0x29,0x2a},{9,0x19,0x66},{14,0x29,0x19},{15,0x15,0x43},{17,0x53,0x52},{22,0x15,0x2c},{21,0x28,0x61}};
 uint8_t index=c->events->last_church;
 /* Valid churches supply0..8. Reject a corrupt external context safely. */
 if(index>=9u){a->error=RPG_INVALID;return;}
 a->kind=FIELD_TRANSFER;a->target=places[index][0];a->a=places[index][1];a->b=places[index][2];
}
static void tele(FieldContext *c,FieldAction *a){
 uint8_t found;
 if(c->chest){rpg_battle_prepare_chest(c->rpg,c->chest);found=c->chest->chest_visual!=0x3du;a->kind=FIELD_CHEST_PROMPT;}
 else found=!c->interaction&&floor_trap(c);
 line(a,found?0xb404:0xb424);a->lines[a->line_count-1u].sound_after=0xd5;
}
uint8_t field_cast(FieldContext *c,uint8_t caster,uint8_t spell,uint8_t target,FieldAction *a) RPG_BANKED {
 RPGCharacter *p;uint8_t cost,position,cell,error;
 memset(a,0,sizeof(*a));a->character=target<4u?target:caster;
 if(!alive(c->rpg,caster))return fail(a,RPG_DEAD,0xb730);
 if(!rpg_knows_spell(c->rpg,caster,spell,0))return fail(a,RPG_NOT_LEARNED,caster==2u?0xb5ba:0xb5c8);
 cost=rpg_magic_cost(spell);p=&c->rpg->party[caster];
 if(p->mp<cost)return fail(a,RPG_NO_MP,0xb6f7);
 if(spell==MagicID_Heal||spell==MagicID_Cure){
  if(target==255u)return FIELD_DONE;
  error=rpg_cast_heal(c->rpg,caster,target,spell,0);if(error)return fail(a,error,0xb730);
  a->sound_start=0xab;line(a,0xb1d0);a->lines[0].sound_after=0xc1;return FIELD_DONE;
 }
 p->mp-=cost;
 switch(spell){
 case MagicID_Trap:
  a->sound_start=0xab;
  if(c->chest){rpg_battle_prepare_chest(c->rpg,c->chest);line(a,c->chest->chest_visual==0x3du?0xb27f:0xb28e);c->chest->chest_visual=0x3d;c->chest->trap_kind=BATTLE_TRAP_NONE;a->kind=FIELD_CHEST_OPEN;}
  else if(!c->interaction&&floor_trap(c)){c->dungeon->layout[dungeon_sample_position(c->dungeon,1u)]=0;line(a,0xb28e);a->kind=FIELD_REDRAW;}
  else line(a,0xb569);break;
 case MagicID_Exit:
  if(c->interaction)line(a,0xb172);else{a->sound_start=0xbf;line(a,0xb59c);a->kind=FIELD_EXIT_DUNGEON;}break;
 case MagicID_Open:
  a->sound_start=0xab;
  if(c->interaction||!c->dungeon){line(a,0xb172);break;}
  position=dungeon_sample_position(c->dungeon,1u);cell=c->dungeon->layout[position];
  if((cell&7u)!=6u||(cell&128u)){line(a,0xb172);break;}
  c->dungeon->layout[position]|=128;a->kind=FIELD_OPEN_DOOR;a->target=position;a->a=4;a->sound_end=0xbd;break;
 case MagicID_Rise:
  if(target==255u)break; /* MP was spent before source target selection. */
  a->sound_start=0xab;
  if(target>=4u||!(c->rpg->joined_mask&(1u<<target)))return fail(a,RPG_INVALID,0);
  p=&c->rpg->party[target];if(p->status&1u)line(a,0xb709);
  else{p->status=1;p->hp=p->max_hp;p->mp=p->max_mp;line(a,0xb5b0);}break;
 case MagicID_Tele:case MagicID_Chat:a->sound_start=0xac;tele(c,a);break;
 case MagicID_Fly:
  a->sound_start=0xab;if(!c->interaction)line(a,0xb172);else {line(a,0xb59c);a->sound_end=0xbf;transfer(c,a);}break;
 default:a->kind=FIELD_UNIMPLEMENTED;a->error=RPG_NOT_IMPLEMENTED;break;
 }
 return a->kind;
}
static uint8_t key(FieldContext *c,FieldAction *a,uint8_t miracle){
 uint8_t position,cell,kind;
 if(c->interaction||!c->dungeon){line(a,0xb366);line(a,0xb569);return FIELD_DONE;}
 line(a,0xb2ac);position=dungeon_sample_position(c->dungeon,1u);cell=c->dungeon->layout[position];kind=cell&7u;
 if(!(cell&128u)&&(kind==5u||(miracle&&kind==6u))){if(!c->in_battle)c->dungeon->layout[position]|=128;a->kind=FIELD_OPEN_DOOR;a->target=position;a->a=kind-2u;a->sound_end=0xbd;}
 else line(a,0xb2cd);
 return a->kind;
}
uint8_t field_use_item(FieldContext *c,uint8_t slot,uint8_t target,FieldAction *a) RPG_BANKED {
 uint8_t item,error;static const uint16_t compass[4]={0xbd01,0xbced,0xbd0c,0xbcf7};
 memset(a,0,sizeof(*a));a->character=target<4u?target:0;
 if(slot>=c->rpg->inventory_count)return fail(a,RPG_INVALID,0);
 item=c->rpg->inventory[slot];a->item=item;
 switch(item){
 case ItemID_Cola:case ItemID_Burger:
  if(target==255u)break;
  error=rpg_use_item(c->rpg,slot,target);if(error)return fail(a,error,0xb730);
  line(a,0xb2ac);line(a,0xb1d0);a->lines[1].sound_after=0xc1;break;
 case ItemID_Flute:
  line(a,0xb2ac);line(a,c->in_battle?0xb322:0xbfc4);a->lines[1].sound_before=0xc2;a->lines[1].sound_after=0xd5;
  if(!c->in_battle&&!c->interaction){line(a,0xb59c);a->lines[2].sound_before=0xbf;a->kind=FIELD_EXIT_DUNGEON;}break;
 case ItemID_Flash:
  if(c->in_battle){line(a,0xb366);line(a,0xb35c);break;}
  if(c->interaction||!c->dungeon||c->dungeon->light){line(a,0xb366);line(a,0xb375);break;}
  line(a,0xb2ac);rpg_remove_item(c->rpg,slot);c->dungeon->light=255;dungeon_refresh_light(c->dungeon);a->kind=FIELD_REDRAW;break;
 case ItemID_Transfer:
  line(a,0xb2ac);if(c->in_battle)line(a,0xb2cd);else if(!c->interaction)line(a,0xb312);
  else{rpg_remove_item(c->rpg,slot);line(a,0xb59c);a->sound_end=0xbf;transfer(c,a);}break;
 case ItemID_MagicHat:
  if(c->in_battle){a->kind=FIELD_UNIMPLEMENTED;a->error=RPG_NOT_IMPLEMENTED;break;}
  rpg_remove_item(c->rpg,slot);line(a,0xb2ac);line(a,0xb2cd);break;
 case ItemID_Sphere:
  if(c->in_battle){a->kind=FIELD_UNIMPLEMENTED;a->error=RPG_NOT_IMPLEMENTED;break;}
  rpg_remove_item(c->rpg,slot);line(a,0xb2ac);tele(c,a);break;
 case ItemID_DungeonKey:return key(c,a,0);
 case ItemID_MiracleKey:return key(c,a,1);
 case ItemID_Alsulin:case ItemID_Polymaterial:
  if(c->in_battle){line(a,0xb366);line(a,0xb35c);}else{a->kind=FIELD_STORY_ITEM;a->target=slot;}break;
 case ItemID_EclipseTorch:
  line(a,0xb458);
  if(c->in_battle)line(a,0xb431);else if(c->event_id!=0xafu)line(a,0xb312);
  else {a->kind=FIELD_TORCH_SCENE;a->target=slot;}break;
 case ItemID_AeroPrism:
  line(a,0xb458);if(c->in_battle)line(a,0xb35c);else if(c->event_id!=0xb0u||c->projection==255u)line(a,0xb312);
  else{line(a,0xb4d5);c->projection=255;a->kind=FIELD_PRISM;}break;
 case ItemID_Nuts:
  if(c->rpg->party[1].status && ((c->map_id==23u&&c->interaction&&!c->in_battle)||(c->map_id!=23u&&c->event_id==0xb0u&&c->projection==255u))){line(a,0xb743);a->kind=FIELD_MYAU_FLY;}
  else{line(a,0xb366);line(a,c->in_battle?0xb35c:0xb500);}break;
 case ItemID_Hapsby:if(c->in_battle){line(a,0xb2ac);line(a,0xb52c);}else line(a,0xb544);break;
 case ItemID_Compass:
  if(c->interaction||c->in_battle||!c->dungeon){line(a,0xb366);line(a,c->in_battle?0xb35c:0xb375);}
  else{line(a,0xb2ac);line(a,compass[c->dungeon->direction&3u]);}break;
 case ItemID_Landrover:case ItemID_Hovercraft:case ItemID_IceDigger:a->kind=FIELD_VEHICLE;a->target=slot;break;
 case ItemID_Wand:case ItemID_Escaper:
  if(c->in_battle){a->kind=FIELD_UNIMPLEMENTED;a->error=RPG_NOT_IMPLEMENTED;break;}
  line(a,0xb2ac);line(a,0xb312);break;
 default:
  line(a,0xb2ac);line(a,item>=ItemID_RoadPass?(c->in_battle?0xb312:0xb555):0xb2cd);break;
 }
 return a->kind;
}
/* Original Torch continuation: the palette change precedes the Pot lookup;
 * consumption precedes B471, and Nuts are added only after its close. */
void field_torch_reply(RPGState *r,FieldAction *a) RPG_BANKED {
 if(a->kind!=FIELD_TORCH_SCENE||a->b)return;
 a->b=1;
 if(rpg_find_item(r,ItemID_LaconiaPot)==RPG_NO_SLOT)line(a,0xb49a);
 else {rpg_remove_item(r,a->target);a->a=1;line(a,0xb471);}
}
void field_torch_finish(RPGState *r,FieldAction *a) RPG_BANKED {
 if(a->kind!=FIELD_TORCH_SCENE||a->b!=1u)return;
 if(a->a&&rpg_find_item(r,ItemID_Nuts)==RPG_NO_SLOT&&rpg_add_item(r,ItemID_Nuts)==RPG_OK)a->sound_end=0xb3;
 a->b=2;a->kind=FIELD_DONE;
}
