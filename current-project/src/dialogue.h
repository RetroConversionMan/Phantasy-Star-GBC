#ifndef PS_DIALOGUE_H
#define PS_DIALOGUE_H
#include <stdint.h>
#ifdef __SDCC
#define DIALOGUE_BANKED __banked
#else
#define DIALOGUE_BANKED
#endif
#define DIALOGUE_WIDTH 18u
typedef struct {
    uint16_t id;
    uint8_t bank;
    const uint8_t *text;
    uint16_t length;
    uint8_t terminator;
} DialogueRef;
typedef struct {
    DialogueRef ref;
    uint16_t offset, number;
    uint8_t done, terminator, row, column, resume_line, token_pos;
    char character[5], enemy[9], item[9], token[9];
    char lines[2][19];
    uint8_t stream_delay;
} DialogueCursor;
/* IDs2..0x2aa are bank2 indices,8000..BFFF bank12 CPU addresses,
 * C000..FFFF direct bank2 narrative CPU addresses plus4000. */
uint8_t dialogue_open(DialogueCursor *cursor, uint16_t id) DIALOGUE_BANKED;
/* Produces original 18-column text. Control61 pauses; controls62..65 finish, preserved in terminator.
 * Returns 0 only when invalid/already finished. Read cursor.lines after a successful call. */
uint8_t dialogue_next_page(DialogueCursor *cursor) DIALOGUE_BANKED;
/* LABEL337D four-line narrative: upper lines in cursor.lines, lower lines in
 * caller's38-byte buffer. Original page61 clears all four lines on resume. */
uint8_t dialogue_next_story_page(DialogueCursor *cursor,char lower_lines[2][19]) DIALOGUE_BANKED;
/* One source character per call/VBlank. Pass NULL for regular dialogue or
 * a two-line lower buffer for four-line narrative. WAIT ends a segment;
 * call again only after its original terminator wait. SCROLL redraws the
 * two-line window and begins the source's eight-frame scrolling interval.
 * Native glyphs are8px high; the SMS's two half-glyph scroll images are
 * represented by one native row shift with the same total delay. */
#define DIALOGUE_STREAM_WAIT 0u
#define DIALOGUE_STREAM_CHAR 1u
#define DIALOGUE_STREAM_SCROLL 2u
#define DIALOGUE_STREAM_DELAY 3u
void dialogue_stream_begin(DialogueCursor *cursor,char lower_lines[2][19]) DIALOGUE_BANKED;
uint8_t dialogue_stream_next(DialogueCursor *cursor,char lower_lines[2][19]) DIALOGUE_BANKED;
void dialogue_item_name(uint8_t item, char out[9]) DIALOGUE_BANKED;
/* Original31FA/337D wait semantics. Use61 for a non-final page.
 * UINT16_MAX means wait for A/B;0 means immediate continuation. No text
 * reveal delay is included here. Tick once per VBlank, pressed is A/B edge. */
uint16_t dialogue_wait_frames(uint8_t terminator,uint8_t narrative) DIALOGUE_BANKED;
uint8_t dialogue_wait_tick(uint16_t *remaining,uint8_t terminator,uint8_t narrative,uint8_t pressed) DIALOGUE_BANKED;
extern const DialogueRef dialogue_refs[];
extern const uint16_t dialogue_ref_count;
extern const char dialogue_items[65][9];
#endif
