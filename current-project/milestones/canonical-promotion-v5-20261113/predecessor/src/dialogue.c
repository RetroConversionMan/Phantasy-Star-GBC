#ifdef __SDCC
#pragma bank 8
#endif
#include "dialogue.h"
#include <string.h>
#ifdef __SDCC
#include "bank_io.h"
#else
static uint8_t bank_read8(uint8_t bank,const uint8_t *ptr) { (void)bank; return *ptr; }
#endif

static void clear_lines(DialogueCursor *c) {
    memset(c->lines[0],' ',18); memset(c->lines[1],' ',18);
    c->lines[0][18]=0; c->lines[1][18]=0; c->row=0;c->column=0;
}
static void newline(DialogueCursor *c) {
    if(c->row) { memcpy(c->lines[0],c->lines[1],19); memset(c->lines[1],' ',18); }
    c->row=1;c->column=0;
}
static void put_char(DialogueCursor *c,char ch) {
    if(c->column==18) newline(c);
    c->lines[c->row][c->column++]=ch=='@'?'\'':ch;
}
uint8_t dialogue_open(DialogueCursor *c,uint16_t id) DIALOGUE_BANKED {
    uint16_t i;
    memset(c,0,sizeof(*c));c->done=1;
    for(i=0;i<dialogue_ref_count;i++) if(dialogue_refs[i].id==id) {
        c->ref=dialogue_refs[i]; c->done=0;
        memcpy(c->character,"ALIS",5); clear_lines(c); return 1;
    }
    return 0;
}
void dialogue_item_name(uint8_t item,char out[9]) DIALOGUE_BANKED {
    if(item<=64) memcpy(out,dialogue_items[item],9); else out[0]=0;
}
static void number_token(DialogueCursor *c) {
    uint16_t n=c->number, place=10000;
    uint8_t pos=0,digit,started=0;
    while(place) {
        digit=(uint8_t)(n/place);n%=place;
        if(digit||started||place==1) {c->token[pos++]=(char)('0'+digit);started=1;}
        place/=10;
    }
    c->token[pos]=0;
}
uint8_t dialogue_next_page(DialogueCursor *c) DIALOGUE_BANKED {
    uint8_t b;
    if(c->done) return 0;
    if(c->resume_line) {newline(c);c->resume_line=0;}
    while(c->offset<c->ref.length) {
        b=bank_read8(c->ref.bank,c->ref.text+c->offset++);
        if(b>=0x62 && b<=0x65) {c->done=1;c->terminator=b;return 1;}
        if(b==0x61) {c->resume_line=1;return 1;}
        if(b==0x60) {newline(c);continue;}
        if(b==0x5f) {clear_lines(c);continue;}
        if(b>=0x5b && b<=0x5e) {
            if(b==0x5b) {memcpy(c->token,c->character,5);}
            else if(b==0x5c) memcpy(c->token,c->enemy,9);
            else if(b==0x5d) memcpy(c->token,c->item,9);
            else number_token(c);
            for(c->token_pos=0;c->token_pos<8 && c->token[c->token_pos];c->token_pos++) put_char(c,c->token[c->token_pos]);
            continue;
        }
        put_char(c,(char)b);
    }
    c->done=1; return 1;
}
static void story_clear(DialogueCursor *c,char lower[2][19]) DIALOGUE_BANKED {
    clear_lines(c);memset(lower[0],' ',18);memset(lower[1],' ',18);
    lower[0][18]=0;lower[1][18]=0;
}
static void story_char(DialogueCursor *c,char lower[2][19],char ch) DIALOGUE_BANKED {
    if(c->column>=18u){if(c->row<3u)++c->row;c->column=0;}
    if(c->row<2u)c->lines[c->row][c->column++]=ch=='@'?'\'':ch;
    else lower[c->row-2u][c->column++]=ch=='@'?'\'':ch;
}
uint8_t dialogue_next_story_page(DialogueCursor *c,char lower[2][19]) DIALOGUE_BANKED {
    uint8_t b;
    if(c->done)return 0;
    story_clear(c,lower);c->resume_line=0;
    while(c->offset<c->ref.length) {
        b=bank_read8(c->ref.bank,c->ref.text+c->offset++);
        if(b>=0x62u&&b<=0x65u){c->done=1;c->terminator=b;return 1;}
        if(b==0x61u)return 1;
        if(b==0x60u){if(c->row<3u)++c->row;c->column=0;continue;}
        if(b==0x5fu){story_clear(c,lower);continue;}
        if(b>=0x5bu&&b<=0x5eu) {
            if(b==0x5bu)memcpy(c->token,c->character,5);
            else if(b==0x5cu)memcpy(c->token,c->enemy,9);
            else if(b==0x5du)memcpy(c->token,c->item,9);
            else number_token(c);
            for(c->token_pos=0;c->token_pos<8u&&c->token[c->token_pos];++c->token_pos)
                story_char(c,lower,c->token[c->token_pos]);
        } else story_char(c,lower,(char)b);
    }
    c->done=1;return 1;
}

void dialogue_stream_begin(DialogueCursor *c,char lower[2][19]) DIALOGUE_BANKED {
    if(lower)story_clear(c,lower);else clear_lines(c);
    c->resume_line=0;c->token_pos=255;c->stream_delay=0;
}
static uint8_t stream_newline(DialogueCursor *c) {
    uint8_t scroll=c->row;
    newline(c);
    if(scroll)c->stream_delay=7u;
    return scroll;
}
uint8_t dialogue_stream_next(DialogueCursor *c,char lower[2][19]) DIALOGUE_BANKED {
    uint8_t b;
    if(c->done)return DIALOGUE_STREAM_WAIT;
    if(c->stream_delay){--c->stream_delay;return DIALOGUE_STREAM_DELAY;}
    if(c->resume_line) {
        c->resume_line=0;
        if(lower)story_clear(c,lower);
        else if(stream_newline(c))return DIALOGUE_STREAM_SCROLL;
    }
    while(1) {
        if(c->token_pos<8u && c->token[c->token_pos]) {
            if(!lower&&c->column==18u&&stream_newline(c))return DIALOGUE_STREAM_SCROLL;
            b=(uint8_t)c->token[c->token_pos++];
            if(lower)story_char(c,lower,(char)b);else put_char(c,(char)b);
            return DIALOGUE_STREAM_CHAR;
        }
        c->token_pos=255;
        if(c->offset>=c->ref.length){c->done=1;return DIALOGUE_STREAM_WAIT;}
        b=bank_read8(c->ref.bank,c->ref.text+c->offset);
        if(b>=0x61u&&b<=0x65u) {
            ++c->offset;c->terminator=b;
            if(b==0x61u)c->resume_line=1;else c->done=1;
            return DIALOGUE_STREAM_WAIT;
        }
        if(b==0x60u) {
            ++c->offset;
            if(lower){if(c->row<3u)++c->row;c->column=0;}
            else if(stream_newline(c))return DIALOGUE_STREAM_SCROLL;
            continue;
        }
        if(b==0x5fu) {
            ++c->offset;if(lower)story_clear(c,lower);else clear_lines(c);continue;
        }
        if(b>=0x5bu&&b<=0x5eu) {
            ++c->offset;
            if(b==0x5bu)memcpy(c->token,c->character,5);
            else if(b==0x5cu)memcpy(c->token,c->enemy,9);
            else if(b==0x5du)memcpy(c->token,c->item,9);
            else number_token(c);
            c->token_pos=0;continue;
        }
        if(!lower&&c->column==18u&&stream_newline(c))return DIALOGUE_STREAM_SCROLL;
        ++c->offset;
        if(lower)story_char(c,lower,(char)b);else put_char(c,(char)b);
        return DIALOGUE_STREAM_CHAR;
    }
}

uint16_t dialogue_wait_frames(uint8_t terminator,uint8_t narrative) DIALOGUE_BANKED {
    if(narrative)return terminator==0x63u?208u:65535u;
    if(terminator==0x62u)return 0;
    if(terminator==0x63u)return 30u;
    if(terminator==0x64u)return 208u;
    return 65535u;
}
uint8_t dialogue_wait_tick(uint16_t *remaining,uint8_t terminator,uint8_t narrative,uint8_t pressed) DIALOGUE_BANKED {
    if(!*remaining)return 1;
    if(*remaining==65535u)return !!pressed;
    if(!narrative&&terminator==0x63u&&pressed){*remaining=0;return 1;}
    --*remaining;return !*remaining;
}
