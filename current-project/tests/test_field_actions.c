#include "field_actions.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static unsigned checks;
#define CHECK(v) do {++checks;if(!(v)){fprintf(stderr,"FAIL%d:%s\n",__LINE__,#v);assert(v);}}while(0)
static RPGState r;static EventState e;static DungeonState d;static RPGBattle b;static FieldContext c;static FieldAction a;
static void setup(void){unsigned i;memset(&c,0,sizeof c);memset(&e,0,sizeof e);memset(&b,0,sizeof b);rpg_new_game(&r);for(i=1;i<4;i++)rpg_recruit(&r,i);for(i=0;i<4;i++)r.party[i].level=30;rpg_refresh_stats(&r);rpg_rest(&r);dungeon_enter(&d,0,0x55,0);c.rpg=&r;c.events=&e;c.dungeon=&d;c.map_id=4;e.rpg=&r;}
static void give(uint8_t item){memset(r.inventory,0,24);r.inventory[0]=item;r.inventory_count=1;}
static void healing(void){uint8_t old;
 setup();old=r.party[0].mp;field_cast(&c,0,MagicID_Heal,255,&a);CHECK(r.party[0].mp==old&&!a.line_count);
 r.party[1].status=0;field_cast(&c,0,MagicID_Heal,1,&a);CHECK(r.party[0].mp==old&&a.lines[0].dialogue==0xb730);
 r.party[1].status=1;r.party[1].hp=1;field_cast(&c,0,MagicID_Heal,1,&a);CHECK(r.party[1].hp==21&&r.party[0].mp==old-2&&a.sound_start==0xab&&a.lines[0].sound_after==0xc1);
 old=r.party[3].mp;field_cast(&c,3,MagicID_Rise,255,&a);CHECK(r.party[3].mp==old-12&&!a.line_count&&!a.sound_start);
 old=r.party[3].mp;field_cast(&c,3,MagicID_Rise,1,&a);CHECK(r.party[3].mp==old-12&&a.lines[0].dialogue==0xb709);
 r.party[1].status=0;r.party[1].hp=r.party[1].mp=0;r.party[1].bound=3;field_cast(&c,3,MagicID_Rise,1,&a);CHECK(r.party[1].status==1&&r.party[1].hp==r.party[1].max_hp&&r.party[1].mp==r.party[1].max_mp&&r.party[1].bound==3&&a.lines[0].dialogue==0xb5b0);
 give(ItemID_Cola);r.party[1].status=0;field_use_item(&c,0,1,&a);CHECK(r.inventory_count==1&&a.error==RPG_DEAD);
 r.party[1].status=1;r.party[1].hp=r.party[1].max_hp;field_use_item(&c,0,1,&a);CHECK(r.inventory_count==0&&r.party[1].hp==r.party[1].max_hp);
}
static void doors(void){unsigned cell,k;uint8_t p;setup();p=dungeon_sample_position(&d,1);
 for(k=0;k<3;k++)for(cell=0;cell<256;cell++){
  d.layout[p]=cell;r.party[3].mp=100;give(k==0?ItemID_DungeonKey:ItemID_MiracleKey);
  if(k==2)field_cast(&c,3,MagicID_Open,0,&a);else field_use_item(&c,0,0,&a);
  if(!(cell&128)&&((cell&7)==(k==2?6:5)||(k==1&&(cell&7)==6))){CHECK(a.kind==FIELD_OPEN_DOOR&&d.layout[p]==(cell|128)&&a.a==((cell&7)-2));}
  else CHECK(a.kind==FIELD_DONE&&d.layout[p]==cell);
  CHECK(r.inventory_count==1);CHECK(r.party[3].mp==(k==2?96:100));
 }
 c.interaction=1;r.party[3].mp=100;field_cast(&c,3,MagicID_Open,0,&a);CHECK(r.party[3].mp==96&&a.lines[0].dialogue==0xb172);
}
static void battle_items(void){
 unsigned cell,k;uint8_t p;setup();c.in_battle=1;p=dungeon_sample_position(&d,1);
 for(k=0;k<2;k++)for(cell=0;cell<256;cell++){
  d.layout[p]=cell;give(k?ItemID_MiracleKey:ItemID_DungeonKey);field_use_item(&c,0,0,&a);
  CHECK(d.layout[p]==cell&&r.inventory_count==1);
  CHECK(a.lines[0].dialogue==0xb2ac);
  if(!(cell&128)&&((cell&7)==5||(k&&(cell&7)==6)))CHECK(a.kind==FIELD_OPEN_DOOR&&a.a==((cell&7)-2)&&a.line_count==1);
  else CHECK(a.kind==FIELD_DONE&&a.lines[1].dialogue==0xb2cd);
 }
 c.interaction=1;field_use_item(&c,0,0,&a);CHECK(a.kind==FIELD_DONE&&a.lines[0].dialogue==0xb366&&a.lines[1].dialogue==0xb569);
 for(k=0;k<2;k++){give(k?ItemID_Alsulin:ItemID_Polymaterial);field_use_item(&c,0,0,&a);CHECK(a.kind==FIELD_DONE&&a.lines[0].dialogue==0xb366&&a.lines[1].dialogue==0xb35c&&r.inventory_count==1);}
}
static void floor_traps(void){unsigned floor,pos,i;uint8_t exists,p;setup();
 for(floor=0;floor<61;floor++)for(pos=0;pos<256;pos++){
  d.floor=floor;d.position=pos+16;d.direction=0;p=dungeon_sample_position(&d,1);CHECK(p==pos);d.layout[p]=8;exists=0;
  for(i=0;i<DUNGEON_OBJECT_COUNT;i++)if(dungeon_objects[i*7]==floor&&dungeon_objects[i*7+1]==pos)exists=1;
  r.party[3].mp=100;field_cast(&c,3,MagicID_Tele,0,&a);CHECK(a.lines[0].dialogue==(exists?0xb424:0xb404)&&r.party[3].mp==96&&d.layout[p]==8);
  r.party[1].mp=100;field_cast(&c,1,MagicID_Trap,0,&a);CHECK(a.lines[0].dialogue==(exists?0xb569:0xb28e)&&d.layout[p]==(exists?8:0)&&r.party[1].mp==98);
 }
}
static void light_and_travel(void){uint8_t old;setup();give(ItemID_Flash);d.light=0;field_use_item(&c,0,0,&a);CHECK(a.kind==FIELD_REDRAW&&d.light&&r.inventory_count==0);
 give(ItemID_Flash);field_use_item(&c,0,0,&a);CHECK(a.lines[1].dialogue==0xb375&&r.inventory_count==1);c.in_battle=1;field_use_item(&c,0,0,&a);CHECK(a.lines[1].dialogue==0xb35c&&r.inventory_count==1);
 setup();give(ItemID_Flute);field_use_item(&c,0,0,&a);CHECK(a.kind==FIELD_EXIT_DUNGEON&&a.line_count==3&&a.lines[1].sound_before==0xc2&&a.lines[1].sound_after==0xd5&&r.inventory_count==1);
 c.interaction=1;field_use_item(&c,0,0,&a);CHECK(a.kind==0&&a.line_count==2);
 give(ItemID_Transfer);c.interaction=0;field_use_item(&c,0,0,&a);CHECK(r.inventory_count==1&&a.lines[1].dialogue==0xb312);
 c.interaction=1;e.last_church=8;field_use_item(&c,0,0,&a);CHECK(r.inventory_count==0&&a.kind==FIELD_TRANSFER&&a.target==21&&a.a==0x28&&a.b==0x61);
 old=r.party[0].mp;c.interaction=0;field_cast(&c,0,MagicID_Fly,0,&a);CHECK(r.party[0].mp==old-8&&a.kind==0&&a.lines[0].dialogue==0xb172);
 old=r.party[1].mp;c.interaction=1;field_cast(&c,1,MagicID_Exit,0,&a);CHECK(r.party[1].mp==old-4&&a.lines[0].dialogue==0xb172);
}
static void story(void){setup();give(ItemID_EclipseTorch);c.event_id=0xaf;field_use_item(&c,0,0,&a);CHECK(r.inventory_count==1&&a.kind==FIELD_TORCH_SCENE&&a.line_count==1);
 field_torch_reply(&r,&a);CHECK(a.lines[1].dialogue==0xb49a&&r.inventory_count==1);field_torch_finish(&r,&a);CHECK(r.inventory_count==1&&a.kind==FIELD_DONE);
 rpg_add_item(&r,ItemID_LaconiaPot);field_use_item(&c,0,0,&a);CHECK(r.inventory_count==2&&a.line_count==1);
 field_torch_reply(&r,&a);CHECK(rpg_find_item(&r,ItemID_EclipseTorch)==RPG_NO_SLOT&&rpg_find_item(&r,ItemID_LaconiaPot)!=RPG_NO_SLOT&&rpg_find_item(&r,ItemID_Nuts)==RPG_NO_SLOT&&a.lines[1].dialogue==0xb471);
 field_torch_finish(&r,&a);CHECK(rpg_find_item(&r,ItemID_Nuts)!=RPG_NO_SLOT&&r.inventory_count==2&&a.sound_end==0xb3);
 give(ItemID_AeroPrism);c.event_id=0xb0;c.projection=0;field_use_item(&c,0,0,&a);CHECK(a.kind==FIELD_PRISM&&c.projection==255&&r.inventory_count==1);field_use_item(&c,0,0,&a);CHECK(a.kind==0&&a.lines[1].dialogue==0xb312);
 give(ItemID_Nuts);r.party[1].status=2;c.in_battle=1;field_use_item(&c,0,0,&a);CHECK(a.kind==FIELD_MYAU_FLY&&r.inventory_count==1);c.map_id=23;field_use_item(&c,0,0,&a);CHECK(a.kind==0&&a.lines[1].dialogue==0xb35c);c.in_battle=0;c.interaction=1;field_use_item(&c,0,0,&a);CHECK(a.kind==FIELD_MYAU_FLY);
 give(ItemID_MagicHat);field_use_item(&c,0,0,&a);CHECK(!r.inventory_count&&a.lines[1].dialogue==0xb2cd);
 give(ItemID_Sphere);field_use_item(&c,0,0,&a);CHECK(!r.inventory_count&&a.lines[1].dialogue==0xb424&&a.lines[1].sound_after==0xd5);
 give(ItemID_Alsulin);field_use_item(&c,0,0,&a);CHECK(a.kind==FIELD_STORY_ITEM&&r.inventory_count==1);
}
static void chest_magic(void){uint16_t seed;setup();b.chest_state=BATTLE_CHEST_PENDING;b.trap_chance=255;c.chest=&b;
 field_cast(&c,3,MagicID_Tele,0,&a);CHECK(a.kind==FIELD_CHEST_PROMPT&&b.chest_visual==0x43&&a.lines[0].dialogue==0xb404);seed=r.rng;
 field_cast(&c,1,MagicID_Trap,0,&a);CHECK(a.kind==FIELD_CHEST_OPEN&&b.chest_visual==0x3d&&a.lines[0].dialogue==0xb28e&&r.rng==seed);
 CHECK(rpg_battle_open_chest(&r,&b)==RPG_OK&&r.rng==seed&&b.trap_kind==0);
}
int main(void){healing();doors();battle_items();floor_traps();light_and_travel();story();chest_magic();printf("Field action checks passed: %u\n",checks);return 0;}
