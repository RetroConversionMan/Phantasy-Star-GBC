#include "rpg.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static unsigned cases;
#define CHECK(x) do { ++cases; if (!(x)) { fprintf(stderr, "FAIL line %d: %s\n", __LINE__, #x); assert(x); } } while (0)
static void initial_and_recruitment(void) {
    RPGState s;
    rpg_new_game(&s);
    CHECK(s.joined_mask == 1 && s.money == 0 && s.inventory_count == 0);
    CHECK(s.party[0].level == 1 && s.party[0].hp == 16 && s.party[0].mp == 0);
    CHECK(s.party[0].attack == 12 && s.party[0].defense == 13);
    CHECK(rpg_recruit(&s, 1) == RPG_OK);
    CHECK(s.party[1].hp == 22 && s.party[1].weapon == 0 && s.party[1].armor == 0);
    CHECK(rpg_recruit(&s, 2) == RPG_OK);
    CHECK(s.party[2].weapon == ItemID_IronAxe && s.party[2].armor == ItemID_IronArmor);
    CHECK(rpg_recruit(&s, 3) == RPG_OK);
    CHECK(s.party[3].weapon == ItemID_WoodCane && s.party[3].armor == ItemID_WhiteMantle);
    CHECK(s.joined_mask == 15 && rpg_recruit(&s, 3) == RPG_INVALID);
    CHECK(rpg_recruit(&s, 4) == RPG_INVALID);
}
static void inventory_equipment(void) {
    RPGState s, before;
    uint8_t i;
    rpg_new_game(&s);
    CHECK(rpg_add_item(&s, 0) == RPG_INVALID && rpg_add_item(&s, 64) == RPG_INVALID);
    CHECK(rpg_find_item(&s, ItemID_Cola) == RPG_NO_SLOT);
    CHECK(rpg_add_item(&s, ItemID_IronSword) == RPG_OK);
    CHECK(rpg_equip(&s, 0, 0) == RPG_OK);
    CHECK(s.party[0].weapon == ItemID_IronSword && s.party[0].attack == 20);
    CHECK(s.inventory_count == 1 && s.inventory[0] == ItemID_ShortSword);
    CHECK(rpg_add_item(&s, ItemID_LeatherShield) == RPG_OK);
    CHECK(rpg_equip(&s, 1, 0) == RPG_OK);
    CHECK(s.inventory_count == 1 && s.inventory[1] == 0 && s.party[0].defense == 16);
    CHECK(rpg_add_item(&s, ItemID_IronFang) == RPG_OK);
    before = s;
    CHECK(rpg_equip(&s, 1, 0) == RPG_CANNOT_EQUIP && !memcmp(&s, &before, sizeof s));
    CHECK(rpg_add_item(&s, ItemID_LaconiaPot) == RPG_OK);
    CHECK(rpg_item_discardable(ItemID_LaconiaPot) == 0 && rpg_item_discardable(ItemID_Cola) != 0);
    CHECK(rpg_item_discardable(0) == 0 && rpg_item_discardable(64) == 0);
    CHECK(rpg_drop_item(&s, 2) == RPG_PROTECTED_ITEM);
    CHECK(rpg_replace_item(&s, 2, ItemID_Cola) == RPG_PROTECTED_ITEM);
    CHECK(rpg_remove_item(&s, 2) == RPG_OK);
    CHECK(rpg_remove_item(&s, 0) == RPG_OK && s.inventory[0] == ItemID_IronFang);
    CHECK(rpg_replace_item(&s, 0, ItemID_Burger) == RPG_OK && s.inventory[0] == ItemID_Burger);
    for (i = s.inventory_count; i < 24; ++i) CHECK(rpg_add_item(&s, ItemID_Cola) == RPG_OK);
    before = s;
    CHECK(rpg_add_item(&s, ItemID_Burger) == RPG_FULL && !memcmp(&s, &before, sizeof s));
    CHECK(rpg_remove_item(&s, 24) == RPG_INVALID);
    CHECK(rpg_remove_item(&s, 23) == RPG_OK && s.inventory[23] == 0);
    s.party[0].status = 0; s.party[0].hp = 0;
    CHECK(rpg_equip(&s, 0, 0) == RPG_DEAD);
    CHECK(rpg_equip(&s, 0, 4) == RPG_INVALID);
}
static void shops(void) {
    RPGState s, before;
    uint8_t item, shop, option, vehicle_shop = 255, vehicle_option = 255;
    uint16_t price;
    rpg_new_game(&s);
    CHECK(rpg_shop_option(1, 0, &item, &price) == RPG_OK && item == ItemID_LeatherShield && price == 30);
    CHECK(rpg_shop_option(1, 2, &item, &price) == RPG_OK && item == ItemID_CeramicShield && price == 1400);
    CHECK(rpg_shop_option(1, 3, &item, &price) == RPG_INVALID);
    CHECK(rpg_shop_option(29, 0, &item, &price) == RPG_INVALID);
    before = s;
    CHECK(rpg_buy(&s, 1, 0) == RPG_NO_MONEY && !memcmp(&s, &before, sizeof s));
    s.money = 30;
    CHECK(rpg_buy(&s, 1, 0) == RPG_OK && s.money == 0 && s.inventory[0] == ItemID_LeatherShield);
    s.money = 200;
    before = s;
    CHECK(rpg_buy(&s, 8, 2) == RPG_NOT_IMPLEMENTED && !memcmp(&s, &before, sizeof s));
    for (shop = 0; shop < 29; ++shop) for (option = 0; option < 3; ++option)
        if (rpg_shop_option(shop, option, &item, &price) == RPG_OK && item == ItemID_Landrover) { vehicle_shop = shop; vehicle_option = option; }
    CHECK(vehicle_shop != 255);
    rpg_new_game(&s); s.money = 65535;
    CHECK(rpg_shop_option(vehicle_shop, vehicle_option, &item, &price) == RPG_OK);
    CHECK(rpg_buy(&s, vehicle_shop, vehicle_option) == RPG_OK);
    CHECK(rpg_buy(&s, vehicle_shop, vehicle_option) == RPG_OK);
    CHECK(s.inventory_count == 1 && s.money == 65535u - 2u * price);
    while (s.inventory_count < 24) rpg_add_item(&s, ItemID_Cola);
    before = s;
    CHECK(rpg_buy(&s, vehicle_shop, vehicle_option) == RPG_FULL && !memcmp(&s, &before, sizeof s));
    rpg_new_game(&s);
    CHECK(rpg_sell_price(ItemID_ShortSword) == 15);
    CHECK(rpg_sell_price(ItemID_LaconiaPot) == 0 && rpg_sell_price(ItemID_Secrets) == 0);
    rpg_add_item(&s, ItemID_ShortSword); s.money = 65530;
    CHECK(rpg_sell(&s, 0) == RPG_OK && s.money == 65535 && s.inventory_count == 0);
    rpg_add_item(&s, ItemID_LaconiaPot); before = s;
    CHECK(rpg_sell(&s, 0) == RPG_PROTECTED_ITEM && !memcmp(&s, &before, sizeof s));
    s.money = 65530; rpg_add_money(&s, 9); CHECK(s.money == 65535);
    rpg_add_money(&s, 0); CHECK(s.money == 65535);
}
static void healing(void) {
    RPGState s, before;
    rpg_new_game(&s);
    s.party[0].hp = 1;
    rpg_add_item(&s, ItemID_Cola);
    CHECK(rpg_use_item(&s, 0, 0) == RPG_OK && s.party[0].hp == 11 && s.inventory_count == 0);
    rpg_add_item(&s, ItemID_Burger);
    CHECK(rpg_use_item(&s, 0, 0) == RPG_OK && s.party[0].hp == 16);
    rpg_add_item(&s, ItemID_Cola); s.party[0].status = 0; s.party[0].hp = 0;
    before = s;
    CHECK(rpg_use_item(&s, 0, 0) == RPG_DEAD && !memcmp(&s, &before, sizeof s));
    rpg_rest(&s); CHECK(s.party[0].hp == 0);
    CHECK(rpg_hospital(&s, 0) == RPG_DEAD);
    s.money = 19;
    CHECK(rpg_revive(&s, 0) == RPG_NO_MONEY);
    s.money = 20;
    CHECK(rpg_revive(&s, 0) == RPG_OK && s.money == 0 && s.party[0].hp == 16 && s.party[0].status == 1);
    s.party[0].level = 4; rpg_refresh_stats(&s);
    s.party[0].hp = 1; s.party[0].mp = 4;
    CHECK(rpg_cast_heal(&s, 0, 0, MagicID_Heal, 0) == RPG_OK && s.party[0].hp == 21 && s.party[0].mp == 2);
    CHECK(rpg_cast_heal(&s, 0, 0, MagicID_Heal, 1) == RPG_OK && s.party[0].hp == 34 && s.party[0].mp == 0);
    CHECK(rpg_cast_heal(&s, 0, 0, MagicID_Heal, 0) == RPG_NO_MP);
    CHECK(rpg_cast_heal(&s, 0, 0, MagicID_Cure, 0) == RPG_NOT_LEARNED);
    s.party[0].hp = 33; s.money = 5;
    CHECK(rpg_hospital_cost(&s, 0) == 5);
    CHECK(rpg_hospital(&s, 0) == RPG_OK && s.party[0].hp == 34 && s.party[0].mp == 4 && s.money == 0);
    rpg_recruit(&s, 3); s.party[3].level = 30; rpg_refresh_stats(&s);
    s.party[3].hp = 1; s.party[3].mp = 0;
    CHECK(s.party[3].max_hp == 195 && s.party[3].max_mp == 83);
    CHECK(rpg_hospital_cost(&s, 3) == 21); /* 194+83=277; source A wraps to 21 */
    s.money = 21;
    CHECK(rpg_hospital(&s, 3) == RPG_OK && s.money == 0);
}
static void experience(void) {
    RPGState s;
    rpg_new_game(&s); rpg_recruit(&s, 1);
    s.party[0].hp = 1;
    CHECK(rpg_exp_to_next(&s, 0) == 20);
    CHECK(rpg_award_exp(&s, 19) == 0 && s.party[0].exp == 19 && s.party[1].exp == 19);
    CHECK(rpg_award_exp(&s, 1) == 1 && s.party[0].level == 2 && s.party[0].hp == 1);
    CHECK(rpg_award_exp(&s, 1000) == 3 && s.party[0].level == 3 && s.party[1].level == 2);
    CHECK(rpg_award_exp(&s, 0) == 0 && s.party[0].level == 3);
    CHECK(rpg_exp_to_next(&s, 0) == (uint16_t)(100u - 1020u));
    s.party[1].status = 0; s.party[1].hp = 0;
    CHECK(rpg_award_exp(&s, 1) == 1 && s.party[1].exp == 1020);
    s.party[0].exp = 65530;
    CHECK(rpg_award_exp(&s, 10) == 0 && s.party[0].exp == 65535 && s.party[0].level == 4);
    s.party[0].level = 30; s.party[0].exp = 0;
    CHECK(rpg_award_exp(&s, 65535) == 0 && s.party[0].level == 30);
    CHECK(s.party[0].hp == 1);
}
static uint16_t reference_step(uint16_t seed) {
    unsigned feedback = ((seed >> 15) ^ (seed >> 13) ^ (seed >> 4) ^ seed) & 1u;
    uint16_t n = (uint16_t)((seed << 1) | feedback);
    return n ? n : 0x733c;
}
static void rng_and_damage(void) {
    RPGState s;
    uint16_t seed;
    unsigned i;
    rpg_new_game(&s); rpg_seed_rng(&s, 0); CHECK(s.rng == 0x733c);
    seed = s.rng;
    for (i = 0; i < 65535; ++i) {
        seed = reference_step(seed);
        CHECK(rpg_random(&s) == (uint8_t)seed && s.rng == seed);
    }
    /* Zero scaled defense: randomized 255 attack always lies in 190..252. */
    for (i = 0; i < 1000; ++i) {
        uint8_t d = rpg_physical_damage(&s, 255, 0, 1, 0);
        CHECK(d >= 190 && d <= 252);
        CHECK(rpg_physical_damage(&s, 0, 0, 0, 0) == 1);
        d = rpg_physical_damage(&s, 0, 0, 30, 1);
        CHECK(d >= 1 && d <= 16);
    }
}
int main(void) {
    initial_and_recruitment(); inventory_equipment(); shops(); healing(); experience(); rng_and_damage();
    printf("RPG logic checks passed: %u\n", cases);
    return 0;
}
