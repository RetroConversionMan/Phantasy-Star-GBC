#ifndef PS_CUTSCENE_H
#define PS_CUTSCENE_H
#include "rpg.h"
#define CUTSCENE_DONE 0u
#define CUTSCENE_TEXT 1u
#define CUTSCENE_MYAU 1u
#define CUTSCENE_ODIN 2u
#define CUTSCENE_NOAH 3u
#define CUTSCENE_INTRO_DIALOGUE 4u
#define CUTSCENE_LAERMA 5u
#define CUTSCENE_ENDING_DIALOGUE 6u
typedef struct {uint8_t kind,portrait;uint16_t dialogue_id;} CutsceneAction;
typedef struct {uint8_t sequence,step,first_speaker;CutsceneAction action;} CutsceneState;
/* Exact LABEL43CF/4414/4461 speaker/text order. Intro/Laerma/ending
 * sequences here cover their narrative portions, not surrounding movement. */
const CutsceneAction *cutscene_begin(CutsceneState *state,uint8_t sequence,const RPGState *rpg) RPG_BANKED;
const CutsceneAction *cutscene_advance(CutsceneState *state) RPG_BANKED;
/* Original LABEL467C/46D1 larger portraits0..8. LCD must be off. */
uint8_t cutscene_portrait_show(uint8_t portrait) RPG_BANKED;
#endif
