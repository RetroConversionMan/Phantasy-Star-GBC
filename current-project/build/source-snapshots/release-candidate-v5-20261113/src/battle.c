/* Native source control flow, bank 18. Provenance and caveats: docs/BATTLE_RULES.md. */
#ifdef __SDCC
#pragma bank 18
#endif
#include "battle.h"
#include <string.h>

static uint8_t alive(const RPGCharacter *p) { return p->status & 1u; }
static uint8_t party_alive(const RPGState *s, uint8_t c) {
    return (s->joined_mask & (1u << c)) && alive(&s->party[c]);
}
static uint8_t party_count(const RPGState *s) {
    uint8_t c, n = 0;
    for (c = 0; c != 4; ++c) if (s->joined_mask & (1u << c)) ++n;
    return n;
}
static uint8_t living_party(const RPGState *s) {
    uint8_t c;
    for (c = 0; c != 4; ++c) if (party_alive(s, c)) return 1;
    return 0;
}
static uint8_t living_enemies(const RPGBattle *b) {
    uint8_t c;
    for (c = 0; c != 8; ++c) if (alive(&b->enemies[c])) return 1;
    return 0;
}
static uint8_t choose_party(RPGState *s) {
    uint8_t c;
    if (!living_party(s)) return RPG_NO_SLOT;
    do { c = rpg_random(s) & 3u; } while (!party_alive(s, c));
    return c;
}
static uint8_t choose_enemy(RPGState *s, const RPGBattle *b) {
    uint8_t c;
    if (!living_enemies(b)) return RPG_NO_SLOT;
    do { c = rpg_random(s) & 7u; } while (!alive(&b->enemies[c]));
    return c;
}
static uint8_t boost(const RPGCharacter *p, uint8_t enemy) {
    uint16_t a = p->attack;
    if (p->status & 0x80u) { a += a >> 1; if (a > 255u) a = 255u; }
    if (enemy && (p->status & 0x40u)) a -= a >> 2;
    return (uint8_t)a;
}
static void record_damage(RPGBattle *b, uint8_t target, uint8_t damage,uint8_t hp) {
    uint16_t n = (uint16_t)b->last_damage + damage;
    b->last_damage = n > 255u ? 255u : (uint8_t)n;
    b->last_target = target;
    if(b->hit_count<RPG_ENEMY_MAX){
        b->hits[b->hit_count].target=target;b->hits[b->hit_count].damage=damage;b->hits[b->hit_count].hp=hp;++b->hit_count;
    }
}
static void damage(RPGBattle *b, RPGCharacter *p, uint8_t target, uint8_t amount) {
    uint8_t lost = amount < p->hp ? amount : p->hp;
    p->hp -= lost;
    if (!p->hp) { p->status = 0; p->bound = 0; }
    record_damage(b, target, lost,p->hp);
}
static void signed_damage(RPGBattle *b, RPGCharacter *p, uint8_t target, uint8_t delta) {
    /* LABEL_15C2: add byte to HP, keep result only when carry is set. This also
       preserves Lassic's unusual positive 1..16 addition without the Crystal. */
    uint8_t old = p->hp;
    uint16_t sum = (uint16_t)old + delta;
    p->hp = sum > 255u ? (uint8_t)sum : 0u;
    if (!p->hp) { p->status = 0; p->bound = 0; }
    record_damage(b, target, old - p->hp,p->hp);
}
static uint8_t decay_binding(RPGState *s, RPGBattle *b, RPGCharacter *p) {
    uint8_t d;
    if (!p->bound) return 0;
    d = (rpg_random(s) & 1u) + 1u;
    p->bound = p->bound > d ? p->bound - d : 0u;
    b->last_effect = p->bound ? BATTLE_EFFECT_BOUND : BATTLE_EFFECT_RECOVERED;
    return 1; /* Recovery consumes this turn too. */
}
static void decay_barrier(RPGState *s, RPGBattle *b) {
    uint8_t n, d;
    if (!(b->enemy_flags & 0x10u)) { b->barrier = 0; b->barrier_break_before=b->hit_count+1u; return; }
    d = rpg_random(s) & 3u;
    n = b->barrier & 0x7fu;
    n = n > d ? n - d : 0u;
    b->barrier = n ? (b->barrier & 0x80u) | n : 0u;
    if(!n)b->barrier_break_before=b->hit_count+1u;
}
static void check_outcome(RPGState *s, RPGBattle *b) {
    uint8_t c, hp = 0, status = 0;
    if (b->outcome != RPG_ONGOING) return;
    /* The source checks enemy HP and party status independently, in this order. */
    for (c = 0; c != 8; ++c) hp |= b->enemies[c].hp;
    if (!hp) { b->outcome = RPG_VICTORY; return; }
    for (c = 0; c != 4; ++c) if (s->joined_mask & (1u << c)) status |= s->party[c].status;
    if (!status) b->outcome = RPG_DEFEAT;
}
static void physical(RPGState *s, RPGBattle *b, RPGCharacter *a, RPGCharacter *d, uint8_t target, uint8_t enemy) {
    uint8_t hit = rpg_physical_damage(s, boost(a, enemy), d->defense, enemy ? d->level : a->level, enemy);
    b->last_effect = hit ? BATTLE_EFFECT_ATTACK : BATTLE_EFFECT_MISS;
    damage(b, d, target, hit);
}
uint8_t rpg_battle_begin(RPGState *s, RPGBattle *b, uint8_t enemy) RPG_BANKED {
    uint8_t data[32], c, max_count, n;
    if (!party_count(s) || rpg_enemy_record(enemy & 0x7fu, data)) return RPG_INVALID;
    memset(b, 0, sizeof(*b));
    b->enemy_id = enemy;
    b->enemy_flags = data[30]; b->run_chance = data[31];
    n = data[20];
    if (!(n & 0x80u)) {
        max_count = party_count(s) * 2u;
        if ((n & 15u) < max_count) max_count = n & 15u;
        if (!max_count) return RPG_INVALID;
        do { n = rpg_random(s) & 7u; } while (n >= max_count);
        ++n;
    }
    n &= 15u;
    if (!n || n > 8u) return RPG_INVALID;
    b->count = n;
    for (c = 0; c < n; ++c) {
        b->enemies[c].status = 1;
        b->enemies[c].hp = b->enemies[c].max_hp = data[21];
        b->enemies[c].attack = data[22]; b->enemies[c].defense = data[23];
    }
    b->item_reward = data[24]; b->trap_chance = data[27];
    b->money_reward = ((uint16_t)data[25] | ((uint16_t)data[26] << 8)) * n;
    b->exp_reward = ((uint16_t)data[28] | ((uint16_t)data[29] << 8)) * n;
    for (c = 0; c != 12; ++c) b->turn_order[c] = c;
    b->turn_cursor = 12;
    b->last_actor = b->last_target = RPG_NO_SLOT;
    /* LABEL_1036/1043 go to victory when entered without a living member
       or when all four HP bytes are zero. Normal gameplay never starts this. */
    if (!living_party(s) || !(s->party[0].hp | s->party[1].hp | s->party[2].hp | s->party[3].hp)) b->outcome = RPG_VICTORY;
    return RPG_OK;
}
uint8_t rpg_try_run(RPGState *s, RPGBattle *b) RPG_BANKED {
    if (b->outcome != RPG_ONGOING) return RPG_INVALID;
    if (rpg_random(s) < b->run_chance && !b->escape_blocked) {
        b->outcome = RPG_ESCAPED; b->last_effect = BATTLE_EFFECT_ESCAPE;
        rpg_refresh_stats(s);
        return RPG_OK;
    }
    b->suppress_party = 1;
    b->last_effect = BATTLE_EFFECT_NO_EFFECT;
    return RPG_ACTION_FAILED;
}
uint8_t rpg_battle_talk(RPGState *s, RPGBattle *b, uint8_t mode) RPG_BANKED {
    uint8_t monster = 0, n;
    if (b->outcome != RPG_ONGOING || mode > 2u) return RPG_INVALID;
    if (!mode) {
        if (!(b->enemy_flags & 0x80u) || s->party[0].attack < b->enemies[0].attack) goto failed;
    } else {
        if (!(b->enemy_flags & 0xc0u)) goto failed;
        if (b->enemy_flags & 0x40u) {
            if (mode == 1u && s->party[0].attack < b->enemies[0].attack) goto failed;
            monster = 1;
        }
    }
    do { n = rpg_random(s) & 15u; } while (n >= (monster ? 10u : 9u));
    b->talk_index = n + (monster ? 9u : 0u);
    b->outcome = RPG_TALKED; b->last_effect = BATTLE_EFFECT_TALK;
    rpg_refresh_stats(s);
    return RPG_OK;
failed:
    b->suppress_party = 1;
    b->last_effect = BATTLE_EFFECT_NO_EFFECT;
    return RPG_ACTION_FAILED;
}
static uint8_t validate_action(const RPGState *s, uint8_t c, const RPGAction *a) {
    if (!party_alive(s, c) || !s->party[c].hp || s->party[c].bound) return RPG_OK;
    if (a->kind == RPG_ACT_MAGIC) {
        if (!rpg_knows_spell(s, c, a->id, 1)) return RPG_NOT_LEARNED;
        if (s->party[c].mp < rpg_magic_cost(a->id)) return RPG_NO_MP;
        if (a->id == MagicID_Heal || a->id == MagicID_Cure || a->id == MagicID_Help)
            if (a->target >= 4u || !party_alive(s, a->target)) return RPG_DEAD;
    } else if (a->kind == RPG_ACT_ITEM) {
        if (rpg_find_item(s, a->id) == RPG_NO_SLOT) return RPG_INVALID;

    } else if (a->kind > RPG_ACT_RUN || a->kind == 2u) return RPG_INVALID;
    return RPG_OK;
}
uint8_t rpg_battle_prepare(RPGState *s, RPGBattle *b, const RPGAction actions[4]) RPG_BANKED {
    uint8_t c, j, t, error;
    if (b->outcome != RPG_ONGOING || b->turn_cursor != 12u) return RPG_INVALID;
    b->suppress_party = 0; b->last_error = RPG_OK; b->last_effect = BATTLE_EFFECT_NONE;
    for (c = 0; c != 4; ++c) {
        error = validate_action(s, c, &actions[c]);
        if (error) { b->last_error = error; return error; }
        if (!party_alive(s, c) || !s->party[c].hp || s->party[c].bound) continue;
        if (actions[c].kind == RPG_ACT_RUN || actions[c].kind == RPG_ACT_TALK ||
            (actions[c].kind == RPG_ACT_MAGIC && (actions[c].id == MagicID_Chat || actions[c].id == MagicID_Tele))) {
            b->last_actor = c;
            if (actions[c].kind == RPG_ACT_RUN) error = rpg_try_run(s, b);
            else {
                t = 0;
                if (actions[c].kind == RPG_ACT_MAGIC) {
                    s->party[c].mp -= rpg_magic_cost(actions[c].id);
                    t = actions[c].id == MagicID_Chat ? 1u : 2u;
                }
                error = rpg_battle_talk(s, b, t);
            }
            b->last_error = error;
            break; /* Source skips the remaining party selections. */
        }
    }
    if (b->outcome != RPG_ONGOING) return RPG_OK;
    memcpy(b->actions, actions, sizeof(b->actions));
    /* LABEL_18F2: twelve swaps with indices sampled from 0..11. The previous
       permutation is retained between rounds, not reset to identity. */
    for (c = 0; c != 12; ++c) {
        do { j = rpg_random(s) & 15u; } while (j >= 12u);
        t = b->turn_order[c]; b->turn_order[c] = b->turn_order[j]; b->turn_order[j] = t;
    }
    b->turn_cursor = 0;
    return RPG_OK;
}
static void enemy_physical(RPGState *s, RPGBattle *b, RPGCharacter *enemy) {
    uint8_t c;
    if (b->barrier) decay_barrier(s, b);
    c = choose_party(s); if (c == RPG_NO_SLOT) return;
    b->last_target = c;
    if (b->barrier) { b->last_effect = BATTLE_EFFECT_BLOCKED; return; }
    physical(s, b, enemy, &s->party[c], c, 1);
    /* Golden Dragon kills the whole party if its physical strike kills Myau. */
    if (!alive(&s->party[c]) && b->enemy_id == EnemyID_GdDragn && c == 1u)
        for (c = 0; c != 4; ++c) s->party[c].status = 0;
}
static void enemy_fire(RPGState *s, RPGBattle *b) {
    uint8_t c, d;b->last_magic_mode=0x80u;
    if (b->barrier & 0x80u) decay_barrier(s, b);
    c = choose_party(s); if (c == RPG_NO_SLOT) return;
    d = 10u - (rpg_random(s) & 3u);
    b->last_target = c; b->last_effect = BATTLE_EFFECT_FIRE;
    if (!(b->barrier & 0x80u)) damage(b, &s->party[c], c, d);
    else {b->last_effect = BATTLE_EFFECT_MAGIC_BLOCKED;b->hit_blocked|=1u<<b->hit_count;record_damage(b,c,0u,s->party[c].hp);}
}
static void enemy_group(RPGState *s, RPGBattle *b, RPGCharacter *enemy, uint8_t base) {
    uint8_t c;b->last_magic_mode=0xc0u;
    for (c = 0; c != 4; ++c) {
        if (b->barrier & 0x80u) decay_barrier(s, b);
        if (!party_alive(s, c)) continue;
        if (b->barrier&0x80u)b->hit_blocked|=1u<<b->hit_count;
        if (base == 255u) physical(s, b, enemy, &s->party[c], c, 1);
        else if (!(b->barrier & 0x80u)) signed_damage(b, &s->party[c], c, base + (rpg_random(s) & 15u));
        else {b->last_effect = BATTLE_EFFECT_MAGIC_BLOCKED;record_damage(b,c,0u,s->party[c].hp);}
    }
}
static void enemy_turn(RPGState *s, RPGBattle *b, uint8_t index) {
    RPGCharacter *p = &b->enemies[index];
    uint8_t c;
    uint16_t hp;
    if (!alive(p) || decay_binding(s, b, p)) return;
    switch (b->enemy_flags & 7u) {
    case 1: /* One-quarter chance to bind; already-bound random target => attack. */
        if (rpg_random(s) & 3u) break;
        if (b->barrier & 0x80u) decay_barrier(s, b);
        if (b->barrier & 0x80u) { b->last_effect = BATTLE_EFFECT_MAGIC_BLOCKED; return; }
        c = choose_party(s); if (c == RPG_NO_SLOT) return;
        if (s->party[c].bound) break;
        s->party[c].bound = 3; b->last_target = c; b->last_effect = BATTLE_EFFECT_ROPE; return;
    case 2:
        if (p->hp >= 30u && (rpg_random(s) & 7u)) break;
        hp = (uint16_t)p->hp + 80u;
        p->hp = hp > p->max_hp ? p->max_hp : (uint8_t)hp;
        b->last_effect = BATTLE_EFFECT_HEAL; b->last_target = index + 4u; return;
    case 3:
        if ((rpg_random(s) & 15u) || (p->status & 0x80u)) break;
        p->status |= 0x80u; b->last_effect = BATTLE_EFFECT_BOOST; return;
    case 4:
        if (rpg_random(s) & 3u) break;
        enemy_fire(s, b); enemy_fire(s, b); return; /* call, then fall-through */
    case 5:
        if (rpg_random(s) & 3u) break;
        b->last_effect = BATTLE_EFFECT_THUNDER;
        enemy_group(s, b, p, 216u); return;
    case 6:
        if (s->party[2].status && s->party[2].shield == ItemID_MirrorShield) break;
        if (b->barrier) decay_barrier(s, b);
        c = choose_party(s); if (c == RPG_NO_SLOT) return;
        s->party[c].status = 0; record_damage(b, c, s->party[c].hp,0u); s->party[c].hp = 0;
        b->last_effect = BATTLE_EFFECT_PETRIFY; return;
    case 7:
        b->last_effect = BATTLE_EFFECT_THUNDER;
        enemy_group(s, b, p, rpg_find_item(s, ItemID_Crystal) == RPG_NO_SLOT ? 1u : 255u); return;
    default: break;
    }
    enemy_physical(s, b, p);
}
static void player_random_spell(RPGState *s, RPGBattle *b, uint8_t amount) {
    uint8_t c = choose_enemy(s, b);
    if (c == RPG_NO_SLOT) return;
    damage(b, &b->enemies[c], c + 4u, amount - (rpg_random(s) & 3u));
}
static void player_group(RPGState *s, RPGBattle *b, uint8_t amount) {
    uint8_t c, d;
    for (c = 0; c != 8; ++c) if (alive(&b->enemies[c])) {
        d = amount;
        if (amount == 40u) d -= rpg_random(s) & 15u;
        damage(b, &b->enemies[c], c + 4u, d);
        if (b->enemy_id == EnemyID_DarkFalz) return;
    }
}
static void player_magic(RPGState *s, RPGBattle *b, uint8_t c, const RPGAction *a) {
    uint8_t i, n, cost;
    if (a->id == MagicID_Heal || a->id == MagicID_Cure) {
        b->last_error = rpg_cast_heal(s, c, a->target, a->id, 1);
        b->last_effect = BATTLE_EFFECT_HEAL; b->last_target = a->target; return;
    }
    cost = rpg_magic_cost(a->id);
    if (s->party[c].mp < cost) { b->last_error = RPG_NO_MP; return; }
    s->party[c].mp -= cost;
    switch (a->id) {
    case MagicID_Wall: b->barrier = 6u; b->last_effect = BATTLE_EFFECT_BARRIER; break;
    case MagicID_Prot: b->barrier = 0x86u; b->last_effect = BATTLE_EFFECT_BARRIER; break;
    case MagicID_Fire:
        b->last_effect = BATTLE_EFFECT_FIRE;
        player_random_spell(s, b, 10u); player_random_spell(s, b, 10u); break;
    case MagicID_Thun:
        b->last_effect = BATTLE_EFFECT_THUNDER; player_group(s, b, 40u); break;
    case MagicID_Wind:
        b->last_effect = BATTLE_EFFECT_WIND;
        for (i = 0; i != 3; ++i) player_random_spell(s, b, 12u);
        break;
    case MagicID_Rope:
        b->last_effect = BATTLE_EFFECT_NO_EFFECT;
        if (!(b->enemy_flags & 0x20u)) break;
        n = 3;
        if (s->party[0].attack < b->enemies[0].attack) { n = rpg_random(s) & 3u; if (!n) break; }
        for (i = 0; i != 8; ++i) if (alive(&b->enemies[i]) && !b->enemies[i].bound) {
            b->enemies[i].bound = n; b->last_target = i + 4u; b->last_effect = BATTLE_EFFECT_ROPE; break;
        }
        break;
    case MagicID_Terr:
        b->last_effect = BATTLE_EFFECT_NO_EFFECT;
        if (s->party[0].attack < b->enemies[0].attack || rpg_random(s) >= 178u) break;
        for (i = 0; i != 8; ++i) if (alive(&b->enemies[i]) && !(b->enemies[i].status & 0x40u)) {
            b->enemies[i].status |= 0x40u; b->last_target = i + 4u; b->last_effect = BATTLE_EFFECT_WEAKEN; break;
        }
        break;
    case MagicID_Help:
        if (a->target < 4u && party_alive(s, a->target)) {
            s->party[a->target].status |= 0x80u; b->last_target = a->target; b->last_effect = BATTLE_EFFECT_BOOST;
        } else b->last_error = RPG_DEAD;
        break;
    case MagicID_Bye:
        if (b->run_chance && !b->escape_blocked) {
            b->outcome = RPG_ESCAPED; b->last_effect = BATTLE_EFFECT_ESCAPE; rpg_refresh_stats(s);
        } else b->last_effect = BATTLE_EFFECT_NO_EFFECT;
        break;
    default: b->last_error = RPG_NOT_IMPLEMENTED; break;
    }
}
static void player_item(RPGState *s, RPGBattle *b, uint8_t c, uint8_t item) {
    uint8_t slot = rpg_find_item(s, item);
    if (slot == RPG_NO_SLOT) { b->last_error = RPG_INVALID; return; }
    b->last_effect = BATTLE_EFFECT_NO_EFFECT;
    if (item == ItemID_Cola || item == ItemID_Burger) {
        b->last_error = rpg_use_item(s, slot, c); b->last_target = c; b->last_effect = BATTLE_EFFECT_HEAL;
    } else if (item == ItemID_Escaper || item == ItemID_Wand) {
        if (item == ItemID_Escaper) rpg_remove_item(s, slot);
        if (b->run_chance && !b->escape_blocked) {
            b->outcome = RPG_ESCAPED; b->last_effect = BATTLE_EFFECT_ESCAPE; rpg_refresh_stats(s);
        }
    } else if (item == ItemID_MagicHat || item == ItemID_Sphere) {
        rpg_remove_item(s, slot);
        b->last_error = rpg_battle_talk(s, b, item == ItemID_MagicHat ? 1u : 2u);
    }
    else b->last_effect = BATTLE_EFFECT_FIELD_ITEM; /* Context-dependent original item dispatch belongs to the field bridge. */
}
static void player_turn(RPGState *s, RPGBattle *b, uint8_t c) {
    const RPGAction *a = &b->actions[c];
    RPGCharacter *p = &s->party[c];
    uint8_t target;
    if (!party_alive(s, c) || b->suppress_party || !p->hp || decay_binding(s, b, p)) return;
    if (a->kind == RPG_ACT_ATTACK) {
        b->last_effect = BATTLE_EFFECT_ATTACK;
        if (p->weapon == ItemID_NeedleGun) player_group(s, b, 5u);
        else if (p->weapon == ItemID_HeatGun) player_group(s, b, 10u);
        else if (p->weapon == ItemID_LaserGun) player_group(s, b, 20u);
        else {
            target = choose_enemy(s, b);
            if (target != RPG_NO_SLOT) physical(s, b, p, &b->enemies[target], target + 4u, 0);
        }
    } else if (a->kind == RPG_ACT_MAGIC) player_magic(s, b, c, a);
    else if (a->kind == RPG_ACT_ITEM) player_item(s, b, c, a->id);
}
uint8_t rpg_battle_step(RPGState *s, RPGBattle *b) RPG_BANKED {
    uint8_t actor;
    if (b->outcome != RPG_ONGOING || b->turn_cursor >= 12u) return b->outcome;
    b->last_magic_mode=b->hit_blocked=b->barrier_break_before=0;b->hit_count=0;b->last_damage = 0; b->last_target = RPG_NO_SLOT; b->last_error = RPG_OK; b->last_effect = BATTLE_EFFECT_NONE;
    actor = b->turn_order[b->turn_cursor++]; b->last_actor = actor;
    if (actor < 4u) player_turn(s, b, actor);
    else if (actor < 12u) enemy_turn(s, b, actor - 4u);
    check_outcome(s, b);
    return b->outcome;
}
uint8_t rpg_battle_round(RPGState *s, RPGBattle *b, const RPGAction actions[4]) RPG_BANKED {
    if (rpg_battle_prepare(s, b, actions)) return b->outcome;
    while (b->turn_cursor < 12u && b->outcome == RPG_ONGOING) rpg_battle_step(s, b);
    return b->outcome;
}
uint8_t rpg_claim_rewards(RPGState *s, RPGBattle *b) RPG_BANKED {
    if (b->outcome != RPG_VICTORY) return RPG_INVALID;
    if (b->exp_claimed) return RPG_OK;
    b->exp_claimed = 1;
    if (b->enemy_id == EnemyID_Tarzimal) { b->rewards_claimed = 1; return RPG_OK; }
    b->leveled_mask = rpg_award_exp(s, b->exp_reward);
    rpg_refresh_stats(s);
    if (!b->money_reward && !b->item_reward) { b->rewards_claimed = 1; return RPG_OK; }
    b->chest_state = BATTLE_CHEST_PENDING;
    return RPG_OK;
}
uint8_t rpg_battle_prepare_chest(RPGState *s, RPGBattle *b) RPG_BANKED {
    uint8_t random;
    if (b->chest_state != BATTLE_CHEST_PENDING) return RPG_INVALID;
    if (b->chest_visual) return RPG_OK;
    random = rpg_random(s); /* LABEL5C63 consumes this even at chance0. */
    b->trap_kind = BATTLE_TRAP_NONE;
    if (b->trap_chance && (b->trap_chance >= 240u || b->trap_chance >= random))
        b->trap_kind = (b->trap_chance & 1u) ? BATTLE_TRAP_SINGLE : BATTLE_TRAP_PARTY;
    b->chest_visual = b->trap_kind==BATTLE_TRAP_SINGLE?0x43u:b->trap_kind==BATTLE_TRAP_PARTY?0x3eu:0x3du;
    return RPG_OK;
}
static void chest_damage(RPGState *s, uint8_t c) {
    if (party_alive(s, c)) s->party[c].hp -= s->party[c].hp / 3u;
}
uint8_t rpg_battle_open_chest(RPGState *s, RPGBattle *b) RPG_BANKED {
    uint8_t c, result;
    if (b->chest_state != BATTLE_CHEST_PENDING && !(b->chest_state == BATTLE_CHEST_OPEN && b->item_pending)) return RPG_INVALID;
    if (b->chest_state == BATTLE_CHEST_PENDING) {
        if (!b->chest_visual) rpg_battle_prepare_chest(s,b); /* Direct API fallback. */
        b->trap_kind=b->chest_visual==0x43u?BATTLE_TRAP_SINGLE:b->chest_visual==0x3eu?BATTLE_TRAP_PARTY:BATTLE_TRAP_NONE;
        b->chest_state = BATTLE_CHEST_OPEN;
        if (b->trap_kind == BATTLE_TRAP_PARTY) for (c = 0; c != 4; ++c) chest_damage(s, c);
        else if (b->trap_kind == BATTLE_TRAP_SINGLE) chest_damage(s, rpg_random(s) & 3u);
        rpg_add_money(s, b->money_reward);
        b->item_pending = b->item_reward;
    }
    if (b->item_pending) {
        result = rpg_add_item(s, b->item_pending);
        if (result) return result;
        b->item_pending = 0;
    }
    b->rewards_claimed = 1;
    return RPG_OK;
}
uint8_t rpg_battle_replace_reward(RPGState *s, RPGBattle *b, uint8_t slot) RPG_BANKED {
    uint8_t result;
    if (b->chest_state != BATTLE_CHEST_OPEN || !b->item_pending) return RPG_INVALID;
    result = rpg_replace_item(s, slot, b->item_pending);
    if (!result) { b->item_pending = 0; b->rewards_claimed = 1; }
    return result;
}
void rpg_battle_decline_chest(RPGBattle *b) RPG_BANKED {
    if (b->chest_state == BATTLE_CHEST_PENDING) b->chest_state = BATTLE_CHEST_DECLINED;
    b->item_pending = 0;
    b->rewards_claimed = 1;
}
