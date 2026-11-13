/* Native state/rules port of the pinned SMS disassembly. See docs/RPG_RULES.md. */
#ifdef __SDCC
#pragma bank 4
#endif
#include "rpg.h"
#include <string.h>

static uint8_t joined(const RPGState *s, uint8_t c) {
    return c < RPG_PARTY_SIZE && (s->joined_mask & (1u << c));
}
static uint8_t living(const RPGState *s, uint8_t c) {
    return joined(s, c) && (s->party[c].status & 1u);
}
static uint16_t word(const uint8_t *p) {
    return (uint16_t)p[0] | ((uint16_t)p[1] << 8);
}
static void refresh_character(RPGCharacter *p, uint8_t c) {
    const uint8_t *level;
    if (!(p->status & 1u) || !p->level || p->level > 30u) return;
    level = rpg_levels[c][p->level - 1u];
    /* UpdateCharStats resets temporary attack/weak/binding state. */
    p->status = 1u;
    p->bound = 0u;
    p->max_hp = level[0];
    p->max_mp = level[3];
    p->attack = (uint8_t)(level[1] + (p->weapon < 64u ? rpg_equip_boost[p->weapon] : 0u));
    p->defense = (uint8_t)(level[2] + (p->armor < 64u ? rpg_equip_boost[p->armor] : 0u)
                                 + (p->shield < 64u ? rpg_equip_boost[p->shield] : 0u));
    p->battle_magic_count = level[6];
    p->map_magic_count = level[7];
}
void rpg_refresh_stats(RPGState *s) RPG_BANKED {
    uint8_t c;
    for (c = 0; c != RPG_PARTY_SIZE; ++c) if (joined(s, c)) refresh_character(&s->party[c], c);
}
void rpg_new_game(RPGState *s) RPG_BANKED {
    memset(s, 0, sizeof(*s));
    s->rng = 0x733cu;
    s->joined_mask = 1u;
    s->party[0].status = 1u;
    s->party[0].level = 1u;
    s->party[0].weapon = ItemID_ShortSword;
    s->party[0].armor = ItemID_LeatherArmor;
    refresh_character(&s->party[0], 0u);
    s->party[0].hp = s->party[0].max_hp;
    s->party[0].mp = s->party[0].max_mp;
}
uint8_t rpg_recruit(RPGState *s, uint8_t c) RPG_BANKED {
    RPGCharacter *p;
    if (c >= RPG_PARTY_SIZE || joined(s, c)) return RPG_INVALID;
    p = &s->party[c];
    memset(p, 0, sizeof(*p));
    if (c == 2u) { p->weapon = ItemID_IronAxe; p->armor = ItemID_IronArmor; }
    if (c == 3u) { p->weapon = ItemID_WoodCane; p->armor = ItemID_WhiteMantle; }
    s->joined_mask |= (uint8_t)(1u << c);
    p->status = p->level = 1u;
    rpg_refresh_stats(s);
    p->hp = p->max_hp;
    p->mp = p->max_mp;
    return RPG_OK;
}
void rpg_seed_rng(RPGState *s, uint16_t seed) RPG_BANKED {
    s->rng = seed ? seed : 0x733cu;
}
static uint8_t ror(uint8_t v) { return (uint8_t)((v >> 1) | (v << 7)); }
uint8_t rpg_random(RPGState *s) RPG_BANKED {
    /* UpdateRNGSeed feedback, with the unavailable Z80 R contribution set to 0.
       Caller mixes frame/input timing when seeding; deterministic after that. */
    uint8_t h = (uint8_t)(s->rng >> 8), l = (uint8_t)s->rng;
    uint8_t a = (uint8_t)(ror(ror(h)) ^ h);
    a = (uint8_t)(ror(a) ^ l);
    a = (uint8_t)(ror(ror(ror(ror(a)))) ^ l);
    s->rng = (uint16_t)((s->rng << 1) | (a & 1u));
    if (!s->rng) s->rng = 0x733cu;
    return (uint8_t)s->rng;
}
uint8_t rpg_find_item(const RPGState *s, uint8_t item) RPG_BANKED {
    uint8_t i;
    if (!item || item >= 64u || s->inventory_count > RPG_INVENTORY_SIZE) return RPG_NO_SLOT;
    for (i = 0; i < s->inventory_count; ++i) if (s->inventory[i] == item) return i;
    return RPG_NO_SLOT;
}
uint8_t rpg_add_item(RPGState *s, uint8_t item) RPG_BANKED {
    if (!item || item >= 64u) return RPG_INVALID;
    if (s->inventory_count >= RPG_INVENTORY_SIZE) return RPG_FULL;
    s->inventory[s->inventory_count++] = item;
    return RPG_OK;
}
uint8_t rpg_remove_item(RPGState *s, uint8_t slot) RPG_BANKED {
    uint8_t i;
    if (s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
    --s->inventory_count;
    for (i = slot; i < s->inventory_count; ++i) s->inventory[i] = s->inventory[i + 1u];
    s->inventory[s->inventory_count] = 0u;
    return RPG_OK;
}
uint8_t rpg_item_discardable(uint8_t item) RPG_BANKED {
    return item && item < 64u && !(rpg_item_flags[item] & 4u);
}
uint8_t rpg_drop_item(RPGState *s, uint8_t slot) RPG_BANKED {
    uint8_t item;
    if (s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
    item = s->inventory[slot];
    if (!item || item >= 64u) return RPG_INVALID;
    if (rpg_item_flags[item] & 4u) return RPG_PROTECTED_ITEM;
    return rpg_remove_item(s, slot);
}
uint8_t rpg_replace_item(RPGState *s, uint8_t slot, uint8_t item) RPG_BANKED {
    uint8_t old;
    if (!item || item >= 64u || s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
    old = s->inventory[slot];
    if (!old || old >= 64u) return RPG_INVALID;
    if (rpg_item_flags[old] & 4u) return RPG_PROTECTED_ITEM;
    s->inventory[slot] = item;
    return RPG_OK;
}
uint8_t rpg_item_equippers(uint8_t item) RPG_BANKED {
    return item && item < 64u ? rpg_item_flags[item] >> 4 : 0u;
}
uint8_t rpg_equip_stage(RPGState *s, uint8_t slot, uint8_t c) RPG_BANKED {
    uint8_t item, flags, old;
    /* GBDK4.5.0 otherwise drops the computed party pointer when the staged
     * variant returns before removal/refresh. Keep that pointer materialized. */
    RPGCharacter * volatile p;
    if (!joined(s, c) || s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
    if (!living(s, c)) return RPG_DEAD;
    item = s->inventory[slot];
    if (!item || item >= 64u) return RPG_INVALID;
    flags = rpg_item_flags[item];
    if (!(flags & (0x10u << c)) || (flags & 3u) == 3u) return RPG_CANNOT_EQUIP;
    p = &s->party[c];
    if ((flags & 3u) == 0u) { old = p->weapon; p->weapon = item; }
    else if ((flags & 3u) == 1u) { old = p->armor; p->armor = item; }
    else { old = p->shield; p->shield = item; }
    s->inventory[slot] = old;
    return RPG_OK;
}
void rpg_equip_finish(RPGState *s, uint8_t slot) RPG_BANKED {
    if (slot < s->inventory_count && !s->inventory[slot]) rpg_remove_item(s, slot);
    rpg_refresh_stats(s);
}
uint8_t rpg_equip(RPGState *s, uint8_t slot, uint8_t c) RPG_BANKED {
    uint8_t result = rpg_equip_stage(s, slot, c);
    if (result == RPG_OK) rpg_equip_finish(s, slot);
    return result;
}
uint8_t rpg_shop_option(uint8_t shop, uint8_t option, uint8_t *item, uint16_t *price) RPG_BANKED {
    const uint8_t *p;
    if (shop >= RPG_SHOP_COUNT || option > 2u || option > rpg_shops[shop][0]) return RPG_INVALID;
    p = &rpg_shops[shop][1u + option * 3u];
    *item = p[0];
    *price = word(p + 1);
    return *item ? RPG_OK : RPG_INVALID;
}
uint8_t rpg_buy(RPGState *s, uint8_t shop, uint8_t option) RPG_BANKED {
    uint8_t item, result;
    uint16_t price;
    result = rpg_shop_option(shop, option, &item, &price);
    if (result) return result;
    if (s->inventory_count >= RPG_INVENTORY_SIZE) return RPG_FULL;
    if (s->money < price) return RPG_NO_MONEY;
    /* LABEL_2C46 needs session/story context, never index item 64 into flags. */
    if (item >= ItemID_Secrets) return RPG_NOT_IMPLEMENTED;
    s->money -= price;
    /* Original charges again for an already owned vehicle but adds no duplicate. */
    if (item >= ItemID_Landrover && item <= ItemID_IceDigger && rpg_find_item(s, item) != RPG_NO_SLOT) return RPG_OK;
    return rpg_add_item(s, item);
}
void rpg_add_money(RPGState *s, uint16_t amount) RPG_BANKED {
    uint16_t sum = s->money + amount;
    s->money = sum < s->money ? 65535u : sum;
}
uint16_t rpg_sell_price(uint8_t item) RPG_BANKED {
    return item && item < 64u ? word(rpg_sell_prices[item]) : 0u;
}
uint8_t rpg_sell(RPGState *s, uint8_t slot) RPG_BANKED {
    uint16_t price;
    if (s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
    price = rpg_sell_price(s->inventory[slot]);
    if (!price) return RPG_PROTECTED_ITEM;
    rpg_remove_item(s, slot);
    rpg_add_money(s, price);
    return RPG_OK;
}
static void heal(RPGCharacter *p, uint8_t amount) {
    uint16_t sum = (uint16_t)p->hp + amount;
    p->hp = sum > p->max_hp ? p->max_hp : (uint8_t)sum;
}
uint8_t rpg_use_item(RPGState *s, uint8_t slot, uint8_t c) RPG_BANKED {
    uint8_t item;
    if (!joined(s, c) || s->inventory_count > RPG_INVENTORY_SIZE || slot >= s->inventory_count) return RPG_INVALID;
    item = s->inventory[slot];
    if (item != ItemID_Cola && item != ItemID_Burger) return RPG_NOT_IMPLEMENTED;
    if (!living(s, c)) return RPG_DEAD;
    heal(&s->party[c], item == ItemID_Cola ? 10u : 40u);
    return rpg_remove_item(s, slot);
}
void rpg_rest(RPGState *s) RPG_BANKED {
    uint8_t c;
    for (c = 0; c != RPG_PARTY_SIZE; ++c) if (living(s, c)) {
        s->party[c].hp = s->party[c].max_hp;
        s->party[c].mp = s->party[c].max_mp;
    }
}
uint16_t rpg_hospital_cost(const RPGState *s, uint8_t c) RPG_BANKED {
    const RPGCharacter *p;
    if (!living(s, c)) return 0u;
    p = &s->party[c];
    /* LABEL_2999 adds these differences in A before zero-extending to HL. */
    return (uint8_t)((p->max_hp - p->hp) + (p->max_mp - p->mp));
}
uint8_t rpg_hospital(RPGState *s, uint8_t c) RPG_BANKED {
    uint16_t cost;
    if (!joined(s, c)) return RPG_INVALID;
    if (!living(s, c)) return RPG_DEAD;
    cost = rpg_hospital_cost(s, c);
    if (s->money < cost) return RPG_NO_MONEY;
    s->money -= cost;
    s->party[c].hp = s->party[c].max_hp;
    s->party[c].mp = s->party[c].max_mp;
    return RPG_OK;
}
uint16_t rpg_revival_cost(const RPGState *s, uint8_t c) RPG_BANKED {
    return joined(s, c) ? (uint16_t)s->party[c].level * 20u : 0u;
}
uint8_t rpg_revive(RPGState *s, uint8_t c) RPG_BANKED {
    uint16_t cost;
    if (!joined(s, c) || living(s, c)) return RPG_INVALID;
    cost = rpg_revival_cost(s, c);
    if (s->money < cost) return RPG_NO_MONEY;
    s->money -= cost;
    s->party[c].status = 1u;
    s->party[c].hp = s->party[c].max_hp;
    s->party[c].mp = s->party[c].max_mp;
    return RPG_OK;
}
uint8_t rpg_award_exp(RPGState *s, uint16_t amount) RPG_BANKED {
    uint8_t c, leveled = 0u;
    if (!amount) return 0u;
    for (c = 0; c != RPG_PARTY_SIZE; ++c) if (living(s, c)) {
        RPGCharacter *p = &s->party[c];
        uint16_t sum = p->exp + amount;
        if (sum < p->exp) { p->exp = 65535u; continue; }
        p->exp = sum;
        if (p->level && p->level < 30u && sum >= word(&rpg_levels[c][p->level][4])) {
            ++p->level;
            leveled |= (uint8_t)(1u << c);
        }
    }
    rpg_refresh_stats(s);
    return leveled;
}
uint8_t rpg_knows_spell(const RPGState *s, uint8_t c, uint8_t spell, uint8_t in_battle) RPG_BANKED {
    uint8_t i, count, row;
    const uint8_t *spells;
    if (!joined(s, c) || c == 2u || !spell || spell >= 19u) return 0u;
    row = c == 3u ? 2u : c;
    spells = in_battle ? rpg_battle_spells[row] : rpg_map_spells[row];
    count = in_battle ? s->party[c].battle_magic_count : s->party[c].map_magic_count;
    if (count > 5u) count = 5u;
    for (i = 0u; i < count; ++i) if ((spells[i] & 31u) == spell) return 1u;
    return 0u;
}
uint8_t rpg_cast_heal(RPGState *s, uint8_t caster, uint8_t target, uint8_t spell, uint8_t in_battle) RPG_BANKED {
    uint8_t cost;
    if (!joined(s, caster) || !joined(s, target)) return RPG_INVALID;
    if (!living(s, caster) || !living(s, target)) return RPG_DEAD;
    if (spell != MagicID_Heal && spell != MagicID_Cure) return RPG_INVALID;
    if (!rpg_knows_spell(s, caster, spell, in_battle)) return RPG_NOT_LEARNED;
    cost = rpg_spell_cost[spell];
    if (s->party[caster].mp < cost) return RPG_NO_MP;
    s->party[caster].mp -= cost;
    heal(&s->party[target], spell == MagicID_Heal ? 20u : 80u);
    return RPG_OK;
}
static uint8_t scale(RPGState *s, uint8_t value) {
    uint8_t quarter = value >> 2;
    return (uint8_t)((value >> 1) + quarter + (((uint16_t)rpg_random(s) * quarter) >> 8));
}
uint8_t rpg_physical_damage(RPGState *s, uint8_t attack, uint8_t defense, uint8_t fallback_level, uint8_t enemy_attack) RPG_BANKED {
    uint8_t a = scale(s, attack), d = scale(s, defense), r;
    if (a > d) return a - d;
    d -= a;
    if (d >= 16u && !(d & 1u)) return 0u;
    do { r = rpg_random(s) & 31u; } while (r > fallback_level);
    return (enemy_attack ? (r >> 1) : r) + 1u;
}

uint8_t rpg_enemy_record(uint8_t enemy, uint8_t destination[32]) RPG_BANKED {
    if (!enemy || enemy >= RPG_ENEMY_COUNT) return RPG_INVALID;
    memcpy(destination, rpg_enemies[enemy], 32u);
    return RPG_OK;
}
uint8_t rpg_enemy_name(uint8_t enemy, char destination[9]) RPG_BANKED {
    if (enemy >= RPG_ENEMY_COUNT) return RPG_INVALID;
    memcpy(destination, rpg_enemy_names[enemy], 9u);
    return RPG_OK;
}
uint8_t rpg_magic_cost(uint8_t spell) RPG_BANKED {
    return spell < 19u ? rpg_spell_cost[spell] : 0u;
}
uint8_t rpg_encounter_from_pool(RPGState *s, uint8_t pool) RPG_BANKED {
    if (!pool || pool > RPG_ENCOUNTER_POOL_COUNT) return 0u;
    return rpg_encounter_pools[pool - 1u][rpg_random(s) & 7u];
}

uint16_t rpg_exp_to_next(const RPGState *s, uint8_t c) RPG_BANKED {
    if (!joined(s, c) || !s->party[c].level || s->party[c].level >= 30u) return 0u;
    return (uint16_t)(word(&rpg_levels[c][s->party[c].level][4]) - s->party[c].exp);
}
uint8_t rpg_world_encounter(RPGState *s, uint8_t group, uint16_t x, uint16_t y, uint8_t metatile, uint8_t vehicle) RPG_BANKED {
    uint8_t region, chance, column, row, pool;
    uint16_t top = (y + 1536u - 16u) % 1536u;
    if (group >= 3u) return 0u;
    region = (uint8_t)((top / 192u) * 8u + (((x - 8u) & 2047u) >> 8));
    chance = rpg_world_regions[group][region][0];
    if (vehicle) chance >>= 2;
    if (rpg_random(s) >= chance) return 0u;
    column = rpg_world_regions[group][region][1];
    row = rpg_terrain_lookup[metatile] + (group ? 10u : 0u);
    /* Original lookup deliberately overlaps adjacent ROM records. Preserve the
       byte-address window rather than invent terrain classifications. */
    pool = rpg_map_encounter_window[row][column];
    return rpg_encounter_from_pool(s, pool);
}
uint8_t rpg_dungeon_encounter(RPGState *s, uint8_t floor, uint8_t ahead_cell) RPG_BANKED {
    if (floor >= 61u) return 0u;
    if (rpg_random(s) >= rpg_dungeon_settings[floor][0]) return 0u;
    if (ahead_cell & 7u) return 0u;
    return rpg_encounter_from_pool(s, rpg_dungeon_settings[floor][1]);
}
uint8_t rpg_dungeon_settings_get(uint8_t floor, uint8_t destination[4]) RPG_BANKED {
    if (floor >= 61u) return RPG_INVALID;
    memcpy(destination, rpg_dungeon_settings[floor], 4u);
    return RPG_OK;
}

uint8_t rpg_spell_option(const RPGState *s, uint8_t c, uint8_t option, uint8_t in_battle) RPG_BANKED {
    uint8_t count, row;
    if (!joined(s, c) || c == 2u || option >= 5u) return 0u;
    count = in_battle ? s->party[c].battle_magic_count : s->party[c].map_magic_count;
    if (option >= count) return 0u;
    row = c == 3u ? 2u : c;
    return (in_battle ? rpg_battle_spells[row][option] : rpg_map_spells[row][option]) & 31u;
}
