/* Native rules port. IDs and arithmetic follow the pinned SMS disassembly. */
#ifndef PS_RPG_H
#define PS_RPG_H
#include <stdint.h>
#include "rpg_data.h"
#ifdef __SDCC
#define RPG_BANKED __banked
#else
#define RPG_BANKED
#endif
#define RPG_PARTY_SIZE 4u
#define RPG_INVENTORY_SIZE 24u
#define RPG_ENEMY_MAX 8u
#define RPG_NO_SLOT 255u
#define RPG_OK 0u
#define RPG_INVALID 1u
#define RPG_FULL 2u
#define RPG_NO_MONEY 3u
#define RPG_CANNOT_EQUIP 4u
#define RPG_DEAD 5u
#define RPG_NO_MP 6u
#define RPG_NOT_LEARNED 7u
#define RPG_NOT_IMPLEMENTED 8u
#define RPG_PROTECTED_ITEM 9u
#define RPG_ACTION_FAILED 10u
#define RPG_ONGOING 0u
#define RPG_VICTORY 1u
#define RPG_DEFEAT 2u
#define RPG_ESCAPED 3u
#define RPG_TALKED 4u
#define RPG_ACT_WAIT 0u
#define RPG_ACT_ATTACK 1u
#define RPG_ACT_MAGIC 3u
#define RPG_ACT_ITEM 4u
#define RPG_ACT_TALK 5u
#define RPG_ACT_RUN 6u

typedef struct {
    uint8_t status, hp, mp;
    uint16_t exp;
    uint8_t level, max_hp, max_mp, attack, defense;
    uint8_t weapon, armor, shield, bound, battle_magic_count, map_magic_count;
} RPGCharacter;
typedef struct {
    RPGCharacter party[RPG_PARTY_SIZE];
    uint8_t inventory[RPG_INVENTORY_SIZE], inventory_count, joined_mask;
    uint16_t money, rng;
} RPGState;
typedef struct { uint8_t kind, id, target; } RPGAction;
/* Runtime presentation trace; exact applied hits, never additional RNG rolls. */
typedef struct { uint8_t target,damage,hp; } RPGHit;
typedef struct {
    RPGCharacter enemies[RPG_ENEMY_MAX];
    uint8_t enemy_id, count, outcome, barrier, turn_order[12];
    uint8_t last_actor, last_target, last_damage, last_error;
    uint16_t exp_reward, money_reward;
    uint8_t item_reward, trap_chance, rewards_claimed;
    /* Runtime-only battle context; not part of the persistent RPGState format. */
    uint8_t enemy_flags, run_chance, escape_blocked, suppress_party;
    uint8_t turn_cursor, last_effect, talk_index, chest_state, trap_kind;
    uint8_t item_pending, exp_claimed, leveled_mask, chest_visual;
    RPGAction actions[RPG_PARTY_SIZE];
    uint8_t hit_count;
    RPGHit hits[RPG_ENEMY_MAX];
    uint8_t last_magic_mode,hit_blocked; /* SourceC88A80/C0 and per-hit C2EF bit7. */
    uint8_t barrier_break_before; /* 0 absent; otherwise before hit index+1. */
} RPGBattle;

/* Call seed_rng after new_game with input/frame timing; deterministic for tests. */
void rpg_new_game(RPGState *state) RPG_BANKED;
void rpg_seed_rng(RPGState *state, uint16_t seed) RPG_BANKED;
uint8_t rpg_random(RPGState *state) RPG_BANKED;
uint8_t rpg_recruit(RPGState *state, uint8_t character) RPG_BANKED;
void rpg_refresh_stats(RPGState *state) RPG_BANKED;
uint8_t rpg_add_item(RPGState *state, uint8_t item) RPG_BANKED;
uint8_t rpg_remove_item(RPGState *state, uint8_t slot) RPG_BANKED;
/* Returns inventory slot, or RPG_NO_SLOT. Item IDs are the source byte IDs. */
uint8_t rpg_find_item(const RPGState *state, uint8_t item) RPG_BANKED;
uint8_t rpg_item_discardable(uint8_t item) RPG_BANKED;
uint8_t rpg_drop_item(RPGState *state, uint8_t slot) RPG_BANKED;
uint8_t rpg_item_equippers(uint8_t item) RPG_BANKED;
/* ItemAction_Equip swaps before B2B6; zero-slot removal and UpdateCharStats
 * follow its equipment panel, button wait and text close. */
uint8_t rpg_equip_stage(RPGState *state, uint8_t slot, uint8_t character) RPG_BANKED;
void rpg_equip_finish(RPGState *state, uint8_t slot) RPG_BANKED;
uint8_t rpg_equip(RPGState *state, uint8_t slot, uint8_t character) RPG_BANKED;
uint8_t rpg_replace_item(RPGState *state, uint8_t slot, uint8_t item) RPG_BANKED;
uint8_t rpg_shop_option(uint8_t shop, uint8_t option, uint8_t *item, uint16_t *price) RPG_BANKED;
uint8_t rpg_buy(RPGState *state, uint8_t shop, uint8_t option) RPG_BANKED;
uint8_t rpg_use_item(RPGState *state, uint8_t slot, uint8_t character) RPG_BANKED;
void rpg_rest(RPGState *state) RPG_BANKED;
uint16_t rpg_sell_price(uint8_t item) RPG_BANKED;
uint8_t rpg_sell(RPGState *state, uint8_t slot) RPG_BANKED;
void rpg_add_money(RPGState *state, uint16_t amount) RPG_BANKED;
uint16_t rpg_hospital_cost(const RPGState *state, uint8_t character) RPG_BANKED;
uint8_t rpg_hospital(RPGState *state, uint8_t character) RPG_BANKED;
uint16_t rpg_revival_cost(const RPGState *state, uint8_t character) RPG_BANKED;
uint8_t rpg_revive(RPGState *state, uint8_t character) RPG_BANKED;
/* Returns a bit mask of members gaining one level; overflow skips leveling. */
uint8_t rpg_award_exp(RPGState *state, uint16_t amount) RPG_BANKED;
uint8_t rpg_knows_spell(const RPGState *state, uint8_t caster, uint8_t spell, uint8_t in_battle) RPG_BANKED;
uint8_t rpg_cast_heal(RPGState *state, uint8_t caster, uint8_t target, uint8_t spell, uint8_t in_battle) RPG_BANKED;
/* Bank-safe source record getters; names include a terminating NUL. */
uint16_t rpg_exp_to_next(const RPGState *state, uint8_t character) RPG_BANKED;
uint8_t rpg_enemy_record(uint8_t enemy, uint8_t destination[32]) RPG_BANKED;
uint8_t rpg_enemy_name(uint8_t enemy, char destination[9]) RPG_BANKED;
uint8_t rpg_spell_option(const RPGState *state, uint8_t character, uint8_t option, uint8_t in_battle) RPG_BANKED;
uint8_t rpg_magic_cost(uint8_t spell) RPG_BANKED;
/* Source encounter pool IDs are one-based; zero means no encounter. */
uint8_t rpg_encounter_from_pool(RPGState *state, uint8_t pool) RPG_BANKED;
uint8_t rpg_battle_begin(RPGState *state, RPGBattle *battle, uint8_t enemy) RPG_BANKED;
uint8_t rpg_battle_round(RPGState *state, RPGBattle *battle, const RPGAction actions[4]) RPG_BANKED;
uint8_t rpg_try_run(RPGState *state, RPGBattle *battle) RPG_BANKED;
uint8_t rpg_claim_rewards(RPGState *state, RPGBattle *battle) RPG_BANKED;
/* Direct damage formula port, useful for deterministic regression fixtures. */
uint8_t rpg_physical_damage(RPGState *state, uint8_t attack, uint8_t defense, uint8_t fallback_level, uint8_t enemy_attack) RPG_BANKED;
#endif
