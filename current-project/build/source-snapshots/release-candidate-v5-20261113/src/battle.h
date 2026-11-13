#ifndef PS_BATTLE_H
#define PS_BATTLE_H
#include "rpg.h"
#define BATTLE_BANK 18u
#define BATTLE_EFFECT_NONE 0u
#define BATTLE_EFFECT_ATTACK 1u
#define BATTLE_EFFECT_MISS 2u
#define BATTLE_EFFECT_BLOCKED 3u
#define BATTLE_EFFECT_BOUND 4u
#define BATTLE_EFFECT_RECOVERED 5u
#define BATTLE_EFFECT_HEAL 6u
#define BATTLE_EFFECT_BOOST 7u
#define BATTLE_EFFECT_FIRE 8u
#define BATTLE_EFFECT_THUNDER 9u
#define BATTLE_EFFECT_PETRIFY 10u
#define BATTLE_EFFECT_WIND 11u
#define BATTLE_EFFECT_ROPE 12u
#define BATTLE_EFFECT_WEAKEN 13u
#define BATTLE_EFFECT_BARRIER 14u
#define BATTLE_EFFECT_ESCAPE 15u
#define BATTLE_EFFECT_TALK 16u
#define BATTLE_EFFECT_NO_EFFECT 17u
#define BATTLE_EFFECT_MAGIC_BLOCKED 18u
#define BATTLE_EFFECT_FIELD_ITEM 19u
#define BATTLE_CHEST_NONE 0u
#define BATTLE_CHEST_PENDING 1u
#define BATTLE_CHEST_OPEN 2u
#define BATTLE_CHEST_DECLINED 3u
#define BATTLE_TRAP_NONE 0u
#define BATTLE_TRAP_PARTY 1u
#define BATTLE_TRAP_SINGLE 2u
/* Call only for a completed source movement/action latch, never every frame.
   World x/y are this port's center/feet coordinates; metatile is source sample
   0x14 at x-8,y-16 after transition handling. map_group3+ has no encounters.
   Dungeon turning also counts; ahead_cell is the raw cell in front. */
uint8_t rpg_world_encounter(RPGState *state, uint8_t map_group, uint16_t x, uint16_t y, uint8_t metatile, uint8_t vehicle) RPG_BANKED;
uint8_t rpg_dungeon_encounter(RPGState *state, uint8_t floor, uint8_t ahead_cell) RPG_BANKED;
uint8_t rpg_dungeon_settings_get(uint8_t floor, uint8_t destination[4]) RPG_BANKED;
/* prepare handles immediate menu actions; step resolves one shuffled actor.
   Steps use original random targets, not RPGAction.target except Heal/Cure/Help.
   Caller sets escape_blocked from dungeon rear/side geometry (LABEL_687A).
   turn_cursor==12 means ready for a new selection round. */
uint8_t rpg_battle_prepare(RPGState *state, RPGBattle *battle, const RPGAction actions[4]) RPG_BANKED;
uint8_t rpg_battle_step(RPGState *state, RPGBattle *battle) RPG_BANKED;
/* mode 0=ordinary Talk, 1=Chat/Magic Hat, 2=Tele/Sphere; caller handles costs. */
uint8_t rpg_battle_talk(RPGState *state, RPGBattle *battle, uint8_t mode) RPG_BANKED;
/* claim_rewards awards EXP once and schedules a chest; it does not open it.
   prepare_chest rolls once when the closed chest first appears (LABEL5C63),
   even if declined. chest_visual is0unprepared,3Dsafe,3Epartytrap,43singletrap.
   Open awards money once, resolves its trap, then adds any item. RPG_FULL leaves
   item_pending set for Inventory_AddItem's original discard/replace prompts. */
uint8_t rpg_battle_open_chest(RPGState *state, RPGBattle *battle) RPG_BANKED;
uint8_t rpg_battle_prepare_chest(RPGState *state, RPGBattle *battle) RPG_BANKED;
uint8_t rpg_battle_replace_reward(RPGState *state, RPGBattle *battle, uint8_t slot) RPG_BANKED;
void rpg_battle_decline_chest(RPGBattle *battle) RPG_BANKED;
#endif
