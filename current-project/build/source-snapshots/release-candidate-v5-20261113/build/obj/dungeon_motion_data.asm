;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dungeon_motion_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _motion_sequences
	.globl _motion_fixed
	.globl _motion_lookup
	.globl _motion_patterns
	.globl _motion_blocks
	.globl _motion_variants
	.globl _motion_maps
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE_77
	.area _CODE_77
_motion_maps:
	.db #0xe2	; 226
	.dw (_dungeon_motion_bank_226 + 16088)
	.db #0xe3	; 227
	.dw (_dungeon_motion_bank_227 + 16088)
	.db #0xe4	; 228
	.dw (_dungeon_motion_bank_228 + 16088)
	.db #0xe5	; 229
	.dw (_dungeon_motion_bank_229 + 16088)
	.db #0xe6	; 230
	.dw (_dungeon_motion_bank_230 + 16088)
	.db #0xe7	; 231
	.dw (_dungeon_motion_bank_231 + 16088)
	.db #0xe8	; 232
	.dw (_dungeon_motion_bank_232 + 16088)
	.db #0xe9	; 233
	.dw (_dungeon_motion_bank_233 + 16088)
	.db #0xea	; 234
	.dw (_dungeon_motion_bank_234 + 16088)
	.db #0xeb	; 235
	.dw (_dungeon_motion_bank_235 + 16088)
	.db #0xec	; 236
	.dw (_dungeon_motion_bank_236 + 16088)
	.db #0xed	; 237
	.dw (_dungeon_motion_bank_237 + 16088)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 4464)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 4624)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 4784)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 4944)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 5104)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 5264)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 5424)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 5584)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 5744)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 5904)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 6064)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 6224)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 6384)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 6544)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 6704)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 6864)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 7024)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 7184)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 7344)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 7504)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 7664)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 7824)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 7984)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 8144)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 8304)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 8464)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 8624)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 8784)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 8944)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 9104)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 9264)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 9424)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 9584)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 9744)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 9904)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 10064)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 10224)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 10384)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 10544)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 10704)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 10864)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 11024)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 11184)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 11344)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 11504)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 11664)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 11824)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 11984)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 12144)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 12304)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 12464)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 12624)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 12784)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 12944)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 13104)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 13264)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 13424)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 13584)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 13744)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 13904)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 14064)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 14224)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 14384)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 14544)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 14704)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 14864)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 15024)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 15184)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 15344)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 15504)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 15664)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 15824)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 15984)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 16144)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 0)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 160)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 320)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 480)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 640)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 800)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 960)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 1120)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 1280)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 1440)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 1600)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 1760)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 1920)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 2080)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 2240)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 2400)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 2560)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 2720)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 2880)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 3040)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 3200)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 3360)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 3520)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 3680)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 3840)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 4000)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 4160)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 4320)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 4480)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 4640)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 4800)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 4960)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 5120)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 5280)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 5440)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 5600)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 5760)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 5920)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 6080)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 6240)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 6400)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 6560)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 6720)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 6880)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 7040)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 7200)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 7360)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 7520)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 7680)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 7840)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 8000)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 8160)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 8320)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 8480)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 8640)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 8800)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 8960)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 9120)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 9280)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 9440)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 9600)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 9760)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 9920)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 10080)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 10240)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 10400)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 10560)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 10720)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 10880)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 11040)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 11200)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 11360)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 11520)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 11680)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 11840)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 12000)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 12160)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 12320)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 12480)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 12640)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 12800)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 12960)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 13120)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 13280)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 13440)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 13600)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 13760)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 13920)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 14080)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 14240)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 14400)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 14560)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 14720)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 14880)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 15040)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 15200)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 15360)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 15520)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 15680)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 15840)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 16000)
	.db #0xee	; 238
	.dw (_dungeon_motion_bank_238 + 16160)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 0)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 160)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 320)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 480)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 640)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 800)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 960)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 1120)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 1280)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 1440)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 1600)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 1760)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 1920)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 2080)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 2240)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 2400)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 2560)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 2720)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 2880)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 3040)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 3200)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 3360)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 3520)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 3680)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 3840)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 4000)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 4160)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 4320)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 4480)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 4640)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 4800)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 4960)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 5120)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 5280)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 5440)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 5600)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 5760)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 5920)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 6080)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 6240)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 6400)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 6560)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 6720)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 6880)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 7040)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 7200)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 7360)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 7520)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 7680)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 7840)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 8000)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 8160)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 8320)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 8480)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 8640)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 8800)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 8960)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 9120)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 9280)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 9440)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 9600)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 9760)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 9920)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 10080)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 10240)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 10400)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 10560)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 10720)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 10880)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 11040)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 11200)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 11360)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 11520)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 11680)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 11840)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 12000)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 12160)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 12320)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 12480)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 12640)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 12800)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 12960)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 13120)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 13280)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 13440)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 13600)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 13760)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 13920)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 14080)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 14240)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 14400)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 14560)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 14720)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 14880)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 15040)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 15200)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 15360)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 15520)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 15680)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 15840)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 16000)
	.db #0xef	; 239
	.dw (_dungeon_motion_bank_239 + 16160)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 0)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 160)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 320)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 480)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 640)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 800)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 960)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 1120)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 1280)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 1440)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 1600)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 1760)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 1920)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 2080)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 2240)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 2400)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 2560)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 2720)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 2880)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 3040)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 3200)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 3360)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 3520)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 3680)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 3840)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 4000)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 4160)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 4320)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 4480)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 4640)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 4800)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 4960)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 5120)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 5280)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 5440)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 5600)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 5760)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 5920)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 6080)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 6240)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 6400)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 6560)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 6720)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 6880)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 7040)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 7200)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 7360)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 7520)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 7680)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 7840)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 8000)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 8160)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 8320)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 8480)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 8640)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 8800)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 8960)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 9120)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 9280)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 9440)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 9600)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 9760)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 9920)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 10080)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 10240)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 10400)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 10560)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 10720)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 10880)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 11040)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 11200)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 11360)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 11520)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 11680)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 11840)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 12000)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 12160)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 12320)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 12480)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 12640)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 12800)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 12960)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 13120)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 13280)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 13440)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 13600)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 13760)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 13920)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 14080)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 14240)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 14400)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 14560)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 14720)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 14880)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 15040)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 15200)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 15360)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 15520)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 15680)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 15840)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 16000)
	.db #0xf0	; 240
	.dw (_dungeon_motion_bank_240 + 16160)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 0)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 160)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 320)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 480)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 640)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 800)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 960)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 1120)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 1280)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 1440)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 1600)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 1760)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 1920)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 2080)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 2240)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 2400)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 2560)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 2720)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 2880)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 3040)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 3200)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 3360)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 3520)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 3680)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 3840)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 4000)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 4160)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 4320)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 4480)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 4640)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 4800)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 4960)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 5120)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 5280)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 5440)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 5600)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 5760)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 5920)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 6080)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 6240)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 6400)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 6560)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 6720)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 6880)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 7040)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 7200)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 7360)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 7520)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 7680)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 7840)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 8000)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 8160)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 8320)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 8480)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 8640)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 8800)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 8960)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 9120)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 9280)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 9440)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 9600)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 9760)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 9920)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 10080)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 10240)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 10400)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 10560)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 10720)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 10880)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 11040)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 11200)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 11360)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 11520)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 11680)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 11840)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 12000)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 12160)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 12320)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 12480)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 12640)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 12800)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 12960)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 13120)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 13280)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 13440)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 13600)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 13760)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 13920)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 14080)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 14240)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 14400)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 14560)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 14720)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 14880)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 15040)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 15200)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 15360)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 15520)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 15680)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 15840)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 16000)
	.db #0xf1	; 241
	.dw (_dungeon_motion_bank_241 + 16160)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 0)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 160)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 320)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 480)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 640)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 800)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 960)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 1120)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 1280)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 1440)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 1600)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 1760)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 1920)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 2080)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 2240)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 2400)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 2560)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 2720)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 2880)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 3040)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 3200)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 3360)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 3520)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 3680)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 3840)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 4000)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 4160)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 4320)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 4480)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 4640)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 4800)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 4960)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 5120)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 5280)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 5440)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 5600)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 5760)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 5920)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 6080)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 6240)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 6400)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 6560)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 6720)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 6880)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 7040)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 7200)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 7360)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 7520)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 7680)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 7840)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 8000)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 8160)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 8320)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 8480)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 8640)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 8800)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 8960)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 9120)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 9280)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 9440)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 9600)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 9760)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 9920)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 10080)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 10240)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 10400)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 10560)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 10720)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 10880)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 11040)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 11200)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 11360)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 11520)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 11680)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 11840)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 12000)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 12160)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 12320)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 12480)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 12640)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 12800)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 12960)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 13120)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 13280)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 13440)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 13600)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 13760)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 13920)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 14080)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 14240)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 14400)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 14560)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 14720)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 14880)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 15040)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 15200)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 15360)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 15520)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 15680)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 15840)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 16000)
	.db #0xf2	; 242
	.dw (_dungeon_motion_bank_242 + 16160)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 0)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 160)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 320)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 480)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 640)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 800)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 960)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 1120)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 1280)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 1440)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 1600)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 1760)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 1920)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 2080)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 2240)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 2400)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 2560)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 2720)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 2880)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 3040)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 3200)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 3360)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 3520)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 3680)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 3840)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 4000)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 4160)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 4320)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 4480)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 4640)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 4800)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 4960)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 5120)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 5280)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 5440)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 5600)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 5760)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 5920)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 6080)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 6240)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 6400)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 6560)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 6720)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 6880)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 7040)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 7200)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 7360)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 7520)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 7680)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 7840)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 8000)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 8160)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 8320)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 8480)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 8640)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 8800)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 8960)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 9120)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 9280)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 9440)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 9600)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 9760)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 9920)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 10080)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 10240)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 10400)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 10560)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 10720)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 10880)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 11040)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 11200)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 11360)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 11520)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 11680)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 11840)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 12000)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 12160)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 12320)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 12480)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 12640)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 12800)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 12960)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 13120)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 13280)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 13440)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 13600)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 13760)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 13920)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 14080)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 14240)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 14400)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 14560)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 14720)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 14880)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 15040)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 15200)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 15360)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 15520)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 15680)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 15840)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 16000)
	.db #0xf3	; 243
	.dw (_dungeon_motion_bank_243 + 16160)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 0)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 160)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 320)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 480)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 640)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 800)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 960)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 1120)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 1280)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 1440)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 1600)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 1760)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 1920)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 2080)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 2240)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 2400)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 2560)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 2720)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 2880)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 3040)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 3200)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 3360)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 3520)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 3680)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 3840)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 4000)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 4160)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 4320)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 4480)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 4640)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 4800)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 4960)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 5120)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 5280)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 5440)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 5600)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 5760)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 5920)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 6080)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 6240)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 6400)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 6560)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 6720)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 6880)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 7040)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 7200)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 7360)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 7520)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 7680)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 7840)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 8000)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 8160)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 8320)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 8480)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 8640)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 8800)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 8960)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 9120)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 9280)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 9440)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 9600)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 9760)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 9920)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 10080)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 10240)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 10400)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 10560)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 10720)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 10880)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 11040)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 11200)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 11360)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 11520)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 11680)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 11840)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 12000)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 12160)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 12320)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 12480)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 12640)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 12800)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 12960)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 13120)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 13280)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 13440)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 13600)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 13760)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 13920)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 14080)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 14240)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 14400)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 14560)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 14720)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 14880)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 15040)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 15200)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 15360)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 15520)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 15680)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 15840)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 16000)
	.db #0xf4	; 244
	.dw (_dungeon_motion_bank_244 + 16160)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 0)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 160)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 320)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 480)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 640)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 800)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 960)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 1120)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 1280)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 1440)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 1600)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 1760)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 1920)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 2080)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 2240)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 2400)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 2560)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 2720)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 2880)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 3040)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 3200)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 3360)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 3520)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 3680)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 3840)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 4000)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 4160)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 4320)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 4480)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 4640)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 4800)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 4960)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 5120)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 5280)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 5440)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 5600)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 5760)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 5920)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 6080)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 6240)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 6400)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 6560)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 6720)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 6880)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 7040)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 7200)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 7360)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 7520)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 7680)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 7840)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 8000)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 8160)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 8320)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 8480)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 8640)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 8800)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 8960)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 9120)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 9280)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 9440)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 9600)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 9760)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 9920)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 10080)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 10240)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 10400)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 10560)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 10720)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 10880)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 11040)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 11200)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 11360)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 11520)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 11680)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 11840)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 12000)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 12160)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 12320)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 12480)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 12640)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 12800)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 12960)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 13120)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 13280)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 13440)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 13600)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 13760)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 13920)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 14080)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 14240)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 14400)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 14560)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 14720)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 14880)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 15040)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 15200)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 15360)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 15520)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 15680)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 15840)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 16000)
	.db #0xf5	; 245
	.dw (_dungeon_motion_bank_245 + 16160)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 0)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 160)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 320)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 480)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 640)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 800)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 960)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 1120)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 1280)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 1440)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 1600)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 1760)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 1920)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 2080)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 2240)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 2400)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 2560)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 2720)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 2880)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 3040)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 3200)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 3360)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 3520)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 3680)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 3840)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 4000)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 4160)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 4320)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 4480)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 4640)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 4800)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 4960)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 5120)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 5280)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 5440)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 5600)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 5760)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 5920)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 6080)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 6240)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 6400)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 6560)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 6720)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 6880)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 7040)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 7200)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 7360)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 7520)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 7680)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 7840)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 8000)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 8160)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 8320)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 8480)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 8640)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 8800)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 8960)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 9120)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 9280)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 9440)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 9600)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 9760)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 9920)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 10080)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 10240)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 10400)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 10560)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 10720)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 10880)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 11040)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 11200)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 11360)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 11520)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 11680)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 11840)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 12000)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 12160)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 12320)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 12480)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 12640)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 12800)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 12960)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 13120)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 13280)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 13440)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 13600)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 13760)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 13920)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 14080)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 14240)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 14400)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 14560)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 14720)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 14880)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 15040)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 15200)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 15360)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 15520)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 15680)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 15840)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 16000)
	.db #0xf6	; 246
	.dw (_dungeon_motion_bank_246 + 16160)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 0)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 160)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 320)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 480)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 640)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 800)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 960)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 1120)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 1280)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 1440)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 1600)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 1760)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 1920)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 2080)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 2240)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 2400)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 2560)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 2720)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 2880)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 3040)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 3200)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 3360)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 3520)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 3680)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 3840)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 4000)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 4160)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 4320)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 4480)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 4640)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 4800)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 4960)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 5120)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 5280)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 5440)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 5600)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 5760)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 5920)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 6080)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 6240)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 6400)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 6560)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 6720)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 6880)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 7040)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 7200)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 7360)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 7520)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 7680)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 7840)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 8000)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 8160)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 8320)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 8480)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 8640)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 8800)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 8960)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 9120)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 9280)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 9440)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 9600)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 9760)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 9920)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 10080)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 10240)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 10400)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 10560)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 10720)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 10880)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 11040)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 11200)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 11360)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 11520)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 11680)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 11840)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 12000)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 12160)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 12320)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 12480)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 12640)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 12800)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 12960)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 13120)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 13280)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 13440)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 13600)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 13760)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 13920)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 14080)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 14240)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 14400)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 14560)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 14720)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 14880)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 15040)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 15200)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 15360)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 15520)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 15680)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 15840)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 16000)
	.db #0xf7	; 247
	.dw (_dungeon_motion_bank_247 + 16160)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 0)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 160)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 320)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 480)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 640)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 800)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 960)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 1120)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 1280)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 1440)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 1600)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 1760)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 1920)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 2080)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 2240)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 2400)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 2560)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 2720)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 2880)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 3040)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 3200)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 3360)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 3520)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 3680)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 3840)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 4000)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 4160)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 4320)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 4480)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 4640)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 4800)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 4960)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 5120)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 5280)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 5440)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 5600)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 5760)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 5920)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 6080)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 6240)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 6400)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 6560)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 6720)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 6880)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 7040)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 7200)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 7360)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 7520)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 7680)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 7840)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 8000)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 8160)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 8320)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 8480)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 8640)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 8800)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 8960)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 9120)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 9280)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 9440)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 9600)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 9760)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 9920)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 10080)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 10240)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 10400)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 10560)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 10720)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 10880)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 11040)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 11200)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 11360)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 11520)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 11680)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 11840)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 12000)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 12160)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 12320)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 12480)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 12640)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 12800)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 12960)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 13120)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 13280)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 13440)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 13600)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 13760)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 13920)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 14080)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 14240)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 14400)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 14560)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 14720)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 14880)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 15040)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 15200)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 15360)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 15520)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 15680)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 15840)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 16000)
	.db #0xf8	; 248
	.dw (_dungeon_motion_bank_248 + 16160)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 0)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 160)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 320)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 480)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 640)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 800)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 960)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 1120)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 1280)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 1440)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 1600)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 1760)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 1920)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 2080)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 2240)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 2400)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 2560)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 2720)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 2880)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 3040)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 3200)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 3360)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 3520)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 3680)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 3840)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 4000)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 4160)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 4320)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 4480)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 4640)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 4800)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 4960)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 5120)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 5280)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 5440)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 5600)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 5760)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 5920)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 6080)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 6240)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 6400)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 6560)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 6720)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 6880)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 7040)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 7200)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 7360)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 7520)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 7680)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 7840)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 8000)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 8160)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 8320)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 8480)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 8640)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 8800)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 8960)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 9120)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 9280)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 9440)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 9600)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 9760)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 9920)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 10080)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 10240)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 10400)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 10560)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 10720)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 10880)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 11040)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 11200)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 11360)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 11520)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 11680)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 11840)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 12000)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 12160)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 12320)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 12480)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 12640)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 12800)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 12960)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 13120)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 13280)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 13440)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 13600)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 13760)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 13920)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 14080)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 14240)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 14400)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 14560)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 14720)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 14880)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 15040)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 15200)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 15360)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 15520)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 15680)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 15840)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 16000)
	.db #0xf9	; 249
	.dw (_dungeon_motion_bank_249 + 16160)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 0)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 160)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 320)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 480)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 640)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 800)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 960)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 1120)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 1280)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 1440)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 1600)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 1760)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 1920)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 2080)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 2240)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 2400)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 2560)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 2720)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 2880)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 3040)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 3200)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 3360)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 3520)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 3680)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 3840)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 4000)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 4160)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 4320)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 4480)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 4640)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 4800)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 4960)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 5120)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 5280)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 5440)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 5600)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 5760)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 5920)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 6080)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 6240)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 6400)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 6560)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 6720)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 6880)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 7040)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 7200)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 7360)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 7520)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 7680)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 7840)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 8000)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 8160)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 8320)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 8480)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 8640)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 8800)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 8960)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 9120)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 9280)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 9440)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 9600)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 9760)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 9920)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 10080)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 10240)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 10400)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 10560)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 10720)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 10880)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 11040)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 11200)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 11360)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 11520)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 11680)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 11840)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 12000)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 12160)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 12320)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 12480)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 12640)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 12800)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 12960)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 13120)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 13280)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 13440)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 13600)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 13760)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 13920)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 14080)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 14240)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 14400)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 14560)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 14720)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 14880)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 15040)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 15200)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 15360)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 15520)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 15680)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 15840)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 16000)
	.db #0xfa	; 250
	.dw (_dungeon_motion_bank_250 + 16160)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 0)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 160)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 320)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 480)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 640)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 800)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 960)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 1120)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 1280)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 1440)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 1600)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 1760)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 1920)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 2080)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 2240)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 2400)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 2560)
	.db #0xfb	; 251
	.dw (_dungeon_motion_bank_251 + 2720)
_motion_variants:
	.db #0xe2	; 226
	.dw (_dungeon_motion_bank_226 + 0)
	.db #0xe3	; 227
	.dw (_dungeon_motion_bank_227 + 0)
	.db #0xe4	; 228
	.dw (_dungeon_motion_bank_228 + 0)
	.db #0xe5	; 229
	.dw (_dungeon_motion_bank_229 + 0)
	.db #0xe6	; 230
	.dw (_dungeon_motion_bank_230 + 0)
	.db #0xe7	; 231
	.dw (_dungeon_motion_bank_231 + 0)
	.db #0xe8	; 232
	.dw (_dungeon_motion_bank_232 + 0)
	.db #0xe9	; 233
	.dw (_dungeon_motion_bank_233 + 0)
	.db #0xea	; 234
	.dw (_dungeon_motion_bank_234 + 0)
	.db #0xeb	; 235
	.dw (_dungeon_motion_bank_235 + 0)
	.db #0xec	; 236
	.dw (_dungeon_motion_bank_236 + 0)
	.db #0xed	; 237
	.dw (_dungeon_motion_bank_237 + 0)
_motion_blocks:
	.db #0xe1	; 225
	.dw (_dungeon_motion_bank_225 + 0)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 3152)
_motion_patterns:
	.db #0xd1	; 209
	.dw (_dungeon_motion_bank_209 + 0)
	.db #0xd2	; 210
	.dw (_dungeon_motion_bank_210 + 0)
	.db #0xd3	; 211
	.dw (_dungeon_motion_bank_211 + 0)
	.db #0xd4	; 212
	.dw (_dungeon_motion_bank_212 + 0)
	.db #0xd6	; 214
	.dw (_dungeon_motion_bank_214 + 0)
	.db #0xd7	; 215
	.dw (_dungeon_motion_bank_215 + 0)
	.db #0xd8	; 216
	.dw (_dungeon_motion_bank_216 + 0)
	.db #0xd9	; 217
	.dw (_dungeon_motion_bank_217 + 0)
	.db #0xda	; 218
	.dw (_dungeon_motion_bank_218 + 0)
	.db #0xdb	; 219
	.dw (_dungeon_motion_bank_219 + 0)
	.db #0xdc	; 220
	.dw (_dungeon_motion_bank_220 + 0)
	.db #0xdd	; 221
	.dw (_dungeon_motion_bank_221 + 0)
	.db #0xde	; 222
	.dw (_dungeon_motion_bank_222 + 0)
	.db #0xdf	; 223
	.dw (_dungeon_motion_bank_223 + 0)
	.db #0xe0	; 224
	.dw (_dungeon_motion_bank_224 + 0)
_motion_lookup:
	.dw #0x0000
	.dw #0x0001
	.dw #0x0002
	.dw #0x0003
	.dw #0x0004
	.dw #0x0005
	.dw #0x0006
	.dw #0x0007
	.dw #0x0008
	.dw #0x0009
	.dw #0x000a
	.dw #0x000b
	.dw #0x000c
	.dw #0x000d
	.dw #0x000e
	.dw #0x000f
	.dw #0x0010
	.dw #0x0011
	.dw #0x0012
	.dw #0x0013
	.dw #0x0014
	.dw #0x0015
	.dw #0x0016
	.dw #0x0017
	.dw #0x0018
	.dw #0x0019
	.dw #0x001a
	.dw #0x001b
	.dw #0x001c
	.dw #0x001d
	.dw #0x001e
	.dw #0x001f
	.dw #0x0020
	.dw #0x0021
	.dw #0x0022
	.dw #0x0023
	.dw #0x0024
	.dw #0x0025
	.dw #0x0026
	.dw #0x0027
	.dw #0x0028
	.dw #0x0029
	.dw #0x002a
	.dw #0x002b
	.dw #0x002c
	.dw #0x002d
	.dw #0x002e
	.dw #0x002f
	.dw #0x0030
	.dw #0x0031
	.dw #0x0032
	.dw #0x0033
	.dw #0x0034
	.dw #0x0035
	.dw #0x0036
	.dw #0x0037
	.dw #0x0038
	.dw #0x0039
	.dw #0x003a
	.dw #0x003b
	.dw #0x003c
	.dw #0x003d
	.dw #0x003e
	.dw #0x003f
	.dw #0x0040
	.dw #0x0041
	.dw #0x0042
	.dw #0x0043
	.dw #0x0044
	.dw #0x0045
	.dw #0x0046
	.dw #0x0047
	.dw #0x0048
	.dw #0x0049
	.dw #0x004a
	.dw #0x004b
	.dw #0x004c
	.dw #0x004d
	.dw #0x004e
	.dw #0x004f
	.dw #0x0050
	.dw #0x0051
	.dw #0x0052
	.dw #0x0053
	.dw #0x0054
	.dw #0x0055
	.dw #0x0056
	.dw #0x0057
	.dw #0x0058
	.dw #0x0059
	.dw #0x005a
	.dw #0x005b
	.dw #0x005c
	.dw #0x005d
	.dw #0x005e
	.dw #0x005f
	.dw #0x0060
	.dw #0x0061
	.dw #0x0062
	.dw #0x0063
	.dw #0x0064
	.dw #0x0065
	.dw #0x0066
	.dw #0x0067
	.dw #0x0068
	.dw #0x0069
	.dw #0x006a
	.dw #0x006b
	.dw #0x006c
	.dw #0x006d
	.dw #0x006e
	.dw #0x006f
	.dw #0x0070
	.dw #0x0071
	.dw #0x0072
	.dw #0x0073
	.dw #0x0074
	.dw #0x0075
	.dw #0x0076
	.dw #0x0077
	.dw #0x0078
	.dw #0x0079
	.dw #0x007a
	.dw #0x007b
	.dw #0x007c
	.dw #0x007d
	.dw #0x007e
	.dw #0x007f
	.dw #0x0080
	.dw #0x0081
	.dw #0x0082
	.dw #0x0083
	.dw #0x0084
	.dw #0x0085
	.dw #0x0086
	.dw #0x0087
	.dw #0x0088
	.dw #0x0089
	.dw #0x008a
	.dw #0x008b
	.dw #0x008c
	.dw #0x008d
	.dw #0x008e
	.dw #0x008f
	.dw #0x0090
	.dw #0x0091
	.dw #0x0092
	.dw #0x0093
	.dw #0x0094
	.dw #0x0095
	.dw #0x0096
	.dw #0x0097
	.dw #0x0098
	.dw #0x0099
	.dw #0x009a
	.dw #0x009b
	.dw #0x009c
	.dw #0x009d
	.dw #0x009e
	.dw #0x009f
	.dw #0x00a0
	.dw #0x00a1
	.dw #0x00a2
	.dw #0x00a3
	.dw #0x00a4
	.dw #0x00a5
	.dw #0x00a6
	.dw #0x00a7
	.dw #0x00a8
	.dw #0x00a9
	.dw #0x00aa
	.dw #0x00ab
	.dw #0x00ac
	.dw #0x00ad
	.dw #0x00ae
	.dw #0x00af
	.dw #0x00b0
	.dw #0x00b1
	.dw #0x00b2
	.dw #0x00b3
	.dw #0x00b4
	.dw #0x00b5
	.dw #0x00b6
	.dw #0x00b7
	.dw #0x00b8
	.dw #0x00b9
	.dw #0x00ba
	.dw #0x00bb
	.dw #0x00bc
	.dw #0x00bd
	.dw #0x00be
	.dw #0x00bf
	.dw #0x00c0
	.dw #0x00c1
	.dw #0x00c2
	.dw #0x00c3
	.dw #0x00c4
	.dw #0x00c5
	.dw #0x00c6
	.dw #0x00c7
	.dw #0x00c8
	.dw #0x00c9
	.dw #0x00ca
	.dw #0x00cb
	.dw #0x00cc
	.dw #0x00cd
	.dw #0x00ce
	.dw #0x00cf
	.dw #0x00d0
	.dw #0x00d1
	.dw #0x00d2
	.dw #0x00d3
	.dw #0x00d4
	.dw #0x00d5
	.dw #0x00d6
	.dw #0x00d7
	.dw #0x00d8
	.dw #0x00d9
	.dw #0x00da
	.dw #0x00db
	.dw #0x00dc
	.dw #0x00dd
	.dw #0x00de
	.dw #0x00df
	.dw #0x00e0
	.dw #0x00e1
	.dw #0x00e2
	.dw #0x00e3
	.dw #0x00e4
	.dw #0x00e5
	.dw #0x00e6
	.dw #0x00e7
	.dw #0x00e8
	.dw #0x00e9
	.dw #0x00ea
	.dw #0x00eb
	.dw #0x00ec
	.dw #0x00ed
	.dw #0x00ee
	.dw #0x00ef
	.dw #0x00f0
	.dw #0x00f0
	.dw #0x00f1
	.dw #0x00f2
	.dw #0x00f3
	.dw #0x00f4
	.dw #0x00f5
	.dw #0x00f6
	.dw #0x00f7
	.dw #0x00f8
	.dw #0x00f9
	.dw #0x00fa
	.dw #0x00fb
	.dw #0x00fc
	.dw #0x00fd
	.dw #0x00fe
	.dw #0x00ff
	.dw #0x0100
	.dw #0x0101
	.dw #0x0102
	.dw #0x0103
	.dw #0x0104
	.dw #0x0105
	.dw #0x0106
	.dw #0x0107
	.dw #0x0108
	.dw #0x0109
	.dw #0x010a
	.dw #0x010b
	.dw #0x010c
	.dw #0x010d
	.dw #0x010e
	.dw #0x010f
	.dw #0x0110
	.dw #0x0111
	.dw #0x0112
	.dw #0x0113
	.dw #0x0114
	.dw #0x0115
	.dw #0x0116
	.dw #0x0117
	.dw #0x0118
	.dw #0x0119
	.dw #0x011a
	.dw #0x011b
	.dw #0x011c
	.dw #0x011d
	.dw #0x011e
	.dw #0x011f
	.dw #0x0120
	.dw #0x0121
	.dw #0x0122
	.dw #0x0123
	.dw #0x0124
	.dw #0x0125
	.dw #0x0126
	.dw #0x0127
	.dw #0x0128
	.dw #0x0129
	.dw #0x012a
	.dw #0x012b
	.dw #0x012c
	.dw #0x012d
	.dw #0x012e
	.dw #0x012f
	.dw #0x0130
	.dw #0x0131
	.dw #0x0132
	.dw #0x0133
	.dw #0x0134
	.dw #0x0135
	.dw #0x0136
	.dw #0x0137
	.dw #0x0138
	.dw #0x0139
	.dw #0x013a
	.dw #0x013b
	.dw #0x013c
	.dw #0x013d
	.dw #0x013e
	.dw #0x013f
	.dw #0x0140
	.dw #0x0141
	.dw #0x0142
	.dw #0x0143
	.dw #0x0144
	.dw #0x0145
	.dw #0x0146
	.dw #0x0147
	.dw #0x0148
	.dw #0x0149
	.dw #0x014a
	.dw #0x014b
	.dw #0x014c
	.dw #0x014d
	.dw #0x014e
	.dw #0x014f
	.dw #0x0150
	.dw #0x0151
	.dw #0x0152
	.dw #0x0153
	.dw #0x0154
	.dw #0x0155
	.dw #0x0156
	.dw #0x0157
	.dw #0x0158
	.dw #0x0159
	.dw #0x015a
	.dw #0x015b
	.dw #0x015c
	.dw #0x015d
	.dw #0x015e
	.dw #0x015f
	.dw #0x0160
	.dw #0x0161
	.dw #0x0162
	.dw #0x0163
	.dw #0x0164
	.dw #0x0165
	.dw #0x0166
	.dw #0x0167
	.dw #0x0168
	.dw #0x0169
	.dw #0x016a
	.dw #0x016b
	.dw #0x016c
	.dw #0x016d
	.dw #0x016e
	.dw #0x016f
	.dw #0x0170
	.dw #0x0171
	.dw #0x0172
	.dw #0x0173
	.dw #0x0174
	.dw #0x0175
	.dw #0x0176
	.dw #0x0177
	.dw #0x0178
	.dw #0x0179
	.dw #0x017a
	.dw #0x017b
	.dw #0x017c
	.dw #0x017d
	.dw #0x017e
	.dw #0x017f
	.dw #0x0180
	.dw #0x0181
	.dw #0x0182
	.dw #0x0183
	.dw #0x0184
	.dw #0x0185
	.dw #0x0186
	.dw #0x0187
	.dw #0x0188
	.dw #0x0189
	.dw #0x018a
	.dw #0x018b
	.dw #0x018c
	.dw #0x018d
	.dw #0x018e
	.dw #0x018f
	.dw #0x0190
	.dw #0x0191
	.dw #0x0192
	.dw #0x0193
	.dw #0x0194
	.dw #0x0195
	.dw #0x0196
	.dw #0x0197
	.dw #0x0198
	.dw #0x0199
	.dw #0x019a
	.dw #0x019b
	.dw #0x019c
	.dw #0x019d
	.dw #0x019e
	.dw #0x019f
	.dw #0x01a0
	.dw #0x01a1
	.dw #0x01a2
	.dw #0x01a3
	.dw #0x01a4
	.dw #0x01a5
	.dw #0x01a6
	.dw #0x01a7
	.dw #0x01a8
	.dw #0x01a9
	.dw #0x01aa
	.dw #0x01ab
	.dw #0x01ac
	.dw #0x01ad
	.dw #0x01ae
	.dw #0x01af
	.dw #0x01b0
	.dw #0x01b1
	.dw #0x01b2
	.dw #0x01b3
	.dw #0x01b4
	.dw #0x01b5
	.dw #0x01b6
	.dw #0x01b7
	.dw #0x01b8
	.dw #0x01b9
	.dw #0x01ba
	.dw #0x01bb
	.dw #0x01bc
	.dw #0x01bd
	.dw #0x01be
	.dw #0x01bf
	.dw #0x01c0
	.dw #0x01c1
	.dw #0x01c2
	.dw #0x01c3
	.dw #0x01c4
	.dw #0x01c5
	.dw #0x01c6
	.dw #0x01c7
	.dw #0x01c8
	.dw #0x01c9
	.dw #0x01ca
	.dw #0x01cb
	.dw #0x01cc
	.dw #0x01cd
	.dw #0x01ce
	.dw #0x01cf
	.dw #0x01d0
	.dw #0x01d1
	.dw #0x01d2
	.dw #0x01d3
	.dw #0x01d4
	.dw #0x01d5
	.dw #0x01d6
	.dw #0x01d7
	.dw #0x01d8
	.dw #0x01d9
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x01da
	.dw #0x01db
	.dw #0x01dc
	.dw #0x01dd
	.dw #0x01de
	.dw #0x01df
	.dw #0x01e0
	.dw #0x01e1
	.dw #0x01e2
	.dw #0x01e3
	.dw #0x01e4
	.dw #0x01e5
	.dw #0x01e6
	.dw #0x01e7
	.dw #0x01e8
	.dw #0x01e9
	.dw #0x01ea
	.dw #0x01eb
	.dw #0x01ec
	.dw #0x01ed
	.dw #0x01ee
	.dw #0x01ef
	.dw #0x01f0
	.dw #0x01f1
	.dw #0x01f2
	.dw #0x01f3
	.dw #0x01f4
	.dw #0x01f5
	.dw #0x01f6
	.dw #0x01f7
	.dw #0x01f8
	.dw #0x01f9
	.dw #0x01fa
	.dw #0x01fb
	.dw #0x01fc
	.dw #0x01fd
	.dw #0x01fe
	.dw #0x01ff
	.dw #0x0200
	.dw #0x0201
	.dw #0x0202
	.dw #0x0203
	.dw #0x0204
	.dw #0x0205
	.dw #0x0206
	.dw #0x0207
	.dw #0x0208
	.dw #0x0209
	.dw #0x020a
	.dw #0x020b
	.dw #0x020c
	.dw #0x020d
	.dw #0x020e
	.dw #0x020f
	.dw #0x0210
	.dw #0x0211
	.dw #0x0212
	.dw #0x0213
	.dw #0x0214
	.dw #0x0215
	.dw #0x0216
	.dw #0x0217
	.dw #0x0218
	.dw #0x0219
	.dw #0x021a
	.dw #0x021b
	.dw #0x021c
	.dw #0x021d
	.dw #0x021e
	.dw #0x021f
	.dw #0x0220
	.dw #0x0221
	.dw #0x0222
	.dw #0x0223
	.dw #0x0224
	.dw #0x0225
	.dw #0x0226
	.dw #0x0227
	.dw #0x0228
	.dw #0x0229
	.dw #0x022a
	.dw #0x022b
	.dw #0x022c
	.dw #0x022d
	.dw #0x022e
	.dw #0x022f
	.dw #0x0230
	.dw #0x0231
	.dw #0x0232
	.dw #0x0233
	.dw #0x0234
	.dw #0x0235
	.dw #0x0236
	.dw #0x0237
	.dw #0x0238
	.dw #0x0239
	.dw #0x023a
	.dw #0x023b
	.dw #0x023c
	.dw #0x023d
	.dw #0x023e
	.dw #0x023f
	.dw #0x0240
	.dw #0x0241
	.dw #0x0242
	.dw #0x0243
	.dw #0x0244
	.dw #0x0245
	.dw #0x0246
	.dw #0x0247
	.dw #0x0248
	.dw #0x0249
	.dw #0x024a
	.dw #0x024b
	.dw #0x024c
	.dw #0x024d
	.dw #0x024e
	.dw #0x024f
	.dw #0x0250
	.dw #0x0251
	.dw #0x0252
	.dw #0x0253
	.dw #0x0254
	.dw #0x0255
	.dw #0x0256
	.dw #0x0257
	.dw #0x0258
	.dw #0x0259
	.dw #0x025a
	.dw #0x025b
	.dw #0x025c
	.dw #0x025d
	.dw #0x025e
	.dw #0x025f
	.dw #0x0260
	.dw #0x0261
	.dw #0x0262
	.dw #0x0263
	.dw #0x0264
	.dw #0x0265
	.dw #0x0266
	.dw #0x0267
	.dw #0x0268
	.dw #0x0269
	.dw #0x026a
	.dw #0x026b
	.dw #0x026c
	.dw #0x026d
	.dw #0x026e
	.dw #0x026f
	.dw #0x0270
	.dw #0x0271
	.dw #0x0272
	.dw #0x0273
	.dw #0x0274
	.dw #0x0275
	.dw #0x0276
	.dw #0x0277
	.dw #0x0278
	.dw #0x0279
	.dw #0x027a
	.dw #0x027b
	.dw #0x027c
	.dw #0x027d
	.dw #0x027e
	.dw #0x027f
	.dw #0x0280
	.dw #0x0281
	.dw #0x0282
	.dw #0x0283
	.dw #0x0284
	.dw #0x0285
	.dw #0x0286
	.dw #0x0287
	.dw #0x0288
	.dw #0x0289
	.dw #0x028a
	.dw #0x028b
	.dw #0x028c
	.dw #0x028d
	.dw #0x028e
	.dw #0x028f
	.dw #0x0290
	.dw #0x0291
	.dw #0x0292
	.dw #0x0293
	.dw #0x0294
	.dw #0x0295
	.dw #0x0296
	.dw #0x0297
	.dw #0x0298
	.dw #0x0299
	.dw #0x029a
	.dw #0x029b
	.dw #0x029c
	.dw #0x029d
	.dw #0x029e
	.dw #0x029f
	.dw #0x02a0
	.dw #0x02a1
	.dw #0x02a2
	.dw #0x02a3
	.dw #0x02a4
	.dw #0x02a5
	.dw #0x02a6
	.dw #0x02a7
	.dw #0x02a8
	.dw #0x02a9
	.dw #0x02aa
	.dw #0x02ab
	.dw #0x02ac
	.dw #0x02ad
	.dw #0x02ae
	.dw #0x02af
	.dw #0x02b0
	.dw #0x02b1
	.dw #0x02b2
	.dw #0x02b3
	.dw #0x02b4
	.dw #0x02b5
	.dw #0x02b6
	.dw #0x02b7
	.dw #0x02b8
	.dw #0x02b9
	.dw #0x02ba
	.dw #0x02bb
	.dw #0x02bc
	.dw #0x02bd
	.dw #0x02be
	.dw #0x02bf
	.dw #0x02c0
	.dw #0x02c1
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x02c2
	.dw #0x02c3
	.dw #0x02c4
	.dw #0x02c5
	.dw #0x02c6
	.dw #0x02c7
	.dw #0x02c8
	.dw #0x02c9
	.dw #0x02ca
	.dw #0x02cb
	.dw #0x02cc
	.dw #0x02cd
	.dw #0x02ce
	.dw #0x02cf
	.dw #0x02d0
	.dw #0x02d1
	.dw #0x02d2
	.dw #0x02d3
	.dw #0x02d4
	.dw #0x02d5
	.dw #0x02d6
	.dw #0x02d7
	.dw #0x02d8
	.dw #0x02d9
	.dw #0x02da
	.dw #0x02db
	.dw #0x02dc
	.dw #0x02dd
	.dw #0x02de
	.dw #0x02df
	.dw #0x02e0
	.dw #0x02e1
	.dw #0x02e2
	.dw #0x02e3
	.dw #0x02e4
	.dw #0x02e5
	.dw #0x02e6
	.dw #0x02e7
	.dw #0x02e8
	.dw #0x02e9
	.dw #0x02ea
	.dw #0x02eb
	.dw #0x02ec
	.dw #0x02ed
	.dw #0x02ee
	.dw #0x02ef
	.dw #0x02f0
	.dw #0x02f1
	.dw #0x02f2
	.dw #0x02f3
	.dw #0x02f4
	.dw #0x02f5
	.dw #0x02f6
	.dw #0x02f7
	.dw #0x02f8
	.dw #0x02f9
	.dw #0x02fa
	.dw #0x02fb
	.dw #0x02fc
	.dw #0x02fd
	.dw #0x02fe
	.dw #0x02ff
	.dw #0x0300
	.dw #0x0301
	.dw #0x0302
	.dw #0x0303
	.dw #0x0304
	.dw #0x0305
	.dw #0x0306
	.dw #0x0307
	.dw #0x0308
	.dw #0x0309
	.dw #0x030a
	.dw #0x030b
	.dw #0x030c
	.dw #0x030d
	.dw #0x030e
	.dw #0x030f
	.dw #0x0310
	.dw #0x0311
	.dw #0x0312
	.dw #0x0313
	.dw #0x0314
	.dw #0x0315
	.dw #0x0316
	.dw #0x0317
	.dw #0x0318
	.dw #0x0319
	.dw #0x031a
	.dw #0x031b
	.dw #0x031c
	.dw #0x031d
	.dw #0x031e
	.dw #0x031f
	.dw #0x0320
	.dw #0x0321
	.dw #0x0322
	.dw #0x0323
	.dw #0x0324
	.dw #0x0325
	.dw #0x0326
	.dw #0x0327
	.dw #0x0328
	.dw #0x0329
	.dw #0x032a
	.dw #0x032b
	.dw #0x032c
	.dw #0x032d
	.dw #0x032e
	.dw #0x032f
	.dw #0x0330
	.dw #0x0331
	.dw #0x0332
	.dw #0x0333
	.dw #0x0334
	.dw #0x0335
	.dw #0x0336
	.dw #0x0337
	.dw #0x0338
	.dw #0x0339
	.dw #0x033a
	.dw #0x033b
	.dw #0x033c
	.dw #0x033d
	.dw #0x033e
	.dw #0x033f
	.dw #0x0340
	.dw #0x0341
	.dw #0x0342
	.dw #0x0343
	.dw #0x0344
	.dw #0x0345
	.dw #0x0346
	.dw #0x0347
	.dw #0x0348
	.dw #0x0349
	.dw #0x034a
	.dw #0x034b
	.dw #0x034c
	.dw #0x034d
	.dw #0x034e
	.dw #0x034f
	.dw #0x0350
	.dw #0x0351
	.dw #0x0352
	.dw #0x0353
	.dw #0x0354
	.dw #0x0355
	.dw #0x0356
	.dw #0x0357
	.dw #0x0358
	.dw #0x0359
	.dw #0x035a
	.dw #0x035b
	.dw #0x035c
	.dw #0x035d
	.dw #0x035e
	.dw #0x035f
	.dw #0x0360
	.dw #0x0361
	.dw #0x0362
	.dw #0x0363
	.dw #0x0364
	.dw #0x0365
	.dw #0x0366
	.dw #0x0367
	.dw #0x0368
	.dw #0x0369
	.dw #0x036a
	.dw #0x036b
	.dw #0x036c
	.dw #0x036d
	.dw #0x036e
	.dw #0x036f
	.dw #0x0370
	.dw #0x0371
	.dw #0x0372
	.dw #0x0373
	.dw #0x0374
	.dw #0x0375
	.dw #0x0376
	.dw #0x0377
	.dw #0x0378
	.dw #0x0379
	.dw #0x037a
	.dw #0x037b
	.dw #0x037c
	.dw #0x037d
	.dw #0x037e
	.dw #0x037f
	.dw #0x0380
	.dw #0x0381
	.dw #0x0382
	.dw #0x0383
	.dw #0x0384
	.dw #0x0385
	.dw #0x0386
	.dw #0x0387
	.dw #0x0388
	.dw #0x0389
	.dw #0x038a
	.dw #0x038b
	.dw #0x038c
	.dw #0x038d
	.dw #0x038e
	.dw #0x038f
	.dw #0x0390
	.dw #0x0391
	.dw #0x0392
	.dw #0x0393
	.dw #0x0394
	.dw #0x0395
	.dw #0x0396
	.dw #0x0397
	.dw #0x0398
	.dw #0x0399
	.dw #0x039a
	.dw #0x039b
	.dw #0x039c
	.dw #0x039d
	.dw #0x039e
	.dw #0x039f
	.dw #0x03a0
	.dw #0x03a1
	.dw #0x03a2
	.dw #0x03a3
	.dw #0x03a4
	.dw #0x03a5
	.dw #0x03a6
	.dw #0x03a7
	.dw #0x03a8
	.dw #0x03a9
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x03aa
	.dw #0x03ab
	.dw #0x03ac
	.dw #0x03ad
	.dw #0x03ae
	.dw #0x03af
	.dw #0x03b0
	.dw #0x03b1
	.dw #0x03b2
	.dw #0x03b3
	.dw #0x03b4
	.dw #0x03b5
	.dw #0x03b6
	.dw #0x03b7
	.dw #0x03b8
	.dw #0x03b9
	.dw #0x03ba
	.dw #0x03bb
	.dw #0x03bc
	.dw #0x03bd
	.dw #0x03be
	.dw #0x03bf
	.dw #0x03c0
	.dw #0x03c1
	.dw #0x03c2
	.dw #0x03c3
	.dw #0x03c4
	.dw #0x03c5
	.dw #0x03c6
	.dw #0x03c7
	.dw #0x03c8
	.dw #0x03c9
	.dw #0x03ca
	.dw #0x03cb
	.dw #0x03cc
	.dw #0x03cd
	.dw #0x03ce
	.dw #0x03cf
	.dw #0x03d0
	.dw #0x03d1
	.dw #0x03d2
	.dw #0x03d3
	.dw #0x03d4
	.dw #0x03d5
	.dw #0x03d6
	.dw #0x03d7
	.dw #0x03d8
	.dw #0x03d9
	.dw #0x03da
	.dw #0x03db
	.dw #0x03dc
	.dw #0x03dd
	.dw #0x03de
	.dw #0x03df
	.dw #0x03e0
	.dw #0x03e1
	.dw #0x03e2
	.dw #0x03e3
	.dw #0x03e4
	.dw #0x03e5
	.dw #0x03e6
	.dw #0x03e7
	.dw #0x03e8
	.dw #0x03e9
	.dw #0x03ea
	.dw #0x03eb
	.dw #0x03ec
	.dw #0x03ed
	.dw #0x03ee
	.dw #0x03ef
	.dw #0x03f0
	.dw #0x03f1
	.dw #0x03f2
	.dw #0x03f3
	.dw #0x03f4
	.dw #0x03f5
	.dw #0x03f6
	.dw #0x03f7
	.dw #0x03f8
	.dw #0x03f9
	.dw #0x03fa
	.dw #0x03fb
	.dw #0x03fc
	.dw #0x03fd
	.dw #0x03fe
	.dw #0x03ff
	.dw #0x0400
	.dw #0x0401
	.dw #0x0402
	.dw #0x0403
	.dw #0x0404
	.dw #0x0405
	.dw #0x0406
	.dw #0x0407
	.dw #0x0408
	.dw #0x0409
	.dw #0x040a
	.dw #0x040b
	.dw #0x040c
	.dw #0x040d
	.dw #0x040e
	.dw #0x040f
	.dw #0x0410
	.dw #0x0411
	.dw #0x0412
	.dw #0x0413
	.dw #0x0414
	.dw #0x0415
	.dw #0x0416
	.dw #0x0417
	.dw #0x0418
	.dw #0x0419
	.dw #0x041a
	.dw #0x041b
	.dw #0x041c
	.dw #0x041d
	.dw #0x041e
	.dw #0x041f
	.dw #0x0420
	.dw #0x0421
	.dw #0x0422
	.dw #0x0423
	.dw #0x0424
	.dw #0x0425
	.dw #0x0426
	.dw #0x0427
	.dw #0x0428
	.dw #0x0429
	.dw #0x042a
	.dw #0x042b
	.dw #0x042c
	.dw #0x042d
	.dw #0x042e
	.dw #0x042f
	.dw #0x0430
	.dw #0x0431
	.dw #0x0432
	.dw #0x0433
	.dw #0x0434
	.dw #0x0435
	.dw #0x0436
	.dw #0x0437
	.dw #0x0438
	.dw #0x0439
	.dw #0x043a
	.dw #0x043b
	.dw #0x043c
	.dw #0x043d
	.dw #0x043e
	.dw #0x043f
	.dw #0x0440
	.dw #0x0441
	.dw #0x0442
	.dw #0x0443
	.dw #0x0444
	.dw #0x0445
	.dw #0x0446
	.dw #0x0447
	.dw #0x0448
	.dw #0x0449
	.dw #0x044a
	.dw #0x044b
	.dw #0x044c
	.dw #0x044d
	.dw #0x044e
	.dw #0x044f
	.dw #0x0450
	.dw #0x0451
	.dw #0x0452
	.dw #0x0453
	.dw #0x0454
	.dw #0x0455
	.dw #0x0456
	.dw #0x0457
	.dw #0x0458
	.dw #0x0459
	.dw #0x045a
	.dw #0x045b
	.dw #0x045c
	.dw #0x045d
	.dw #0x045e
	.dw #0x045f
	.dw #0x0460
	.dw #0x0461
	.dw #0x0462
	.dw #0x0463
	.dw #0x0464
	.dw #0x0465
	.dw #0x0466
	.dw #0x0467
	.dw #0x0468
	.dw #0x0469
	.dw #0x046a
	.dw #0x046b
	.dw #0x046c
	.dw #0x046d
	.dw #0x046e
	.dw #0x046f
	.dw #0x0470
	.dw #0x0471
	.dw #0x0472
	.dw #0x0473
	.dw #0x0474
	.dw #0x0475
	.dw #0x0476
	.dw #0x0477
	.dw #0x0478
	.dw #0x0479
	.dw #0x047a
	.dw #0x047b
	.dw #0x047c
	.dw #0x047d
	.dw #0x047e
	.dw #0x047f
	.dw #0x0480
	.dw #0x0481
	.dw #0x0482
	.dw #0x0483
	.dw #0x0484
	.dw #0x0485
	.dw #0x0486
	.dw #0x0487
	.dw #0x0488
	.dw #0x0489
	.dw #0x048a
	.dw #0x048b
	.dw #0x048c
	.dw #0x048d
	.dw #0x048e
	.dw #0x048f
	.dw #0x0490
	.dw #0x0491
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0492
	.dw #0x0493
	.dw #0x0494
	.dw #0x0495
	.dw #0x0496
	.dw #0x0497
	.dw #0x0498
	.dw #0x0499
	.dw #0x049a
	.dw #0x049b
	.dw #0x049c
	.dw #0x049d
	.dw #0x049e
	.dw #0x049f
	.dw #0x04a0
	.dw #0x04a1
	.dw #0x04a2
	.dw #0x04a3
	.dw #0x04a4
	.dw #0x04a5
	.dw #0x04a6
	.dw #0x04a7
	.dw #0x04a8
	.dw #0x04a9
	.dw #0x04aa
	.dw #0x04ab
	.dw #0x04ac
	.dw #0x04ad
	.dw #0x04ae
	.dw #0x04af
	.dw #0x04b0
	.dw #0x04b1
	.dw #0x04b2
	.dw #0x04b3
	.dw #0x04b4
	.dw #0x04b5
	.dw #0x04b6
	.dw #0x04b7
	.dw #0x04b8
	.dw #0x04b9
	.dw #0x04ba
	.dw #0x04bb
	.dw #0x04bc
	.dw #0x04bd
	.dw #0x04be
	.dw #0x04bf
	.dw #0x04c0
	.dw #0x04c1
	.dw #0x04c2
	.dw #0x04c3
	.dw #0x04c4
	.dw #0x04c5
	.dw #0x04c6
	.dw #0x04c7
	.dw #0x04c8
	.dw #0x04c9
	.dw #0x04ca
	.dw #0x04cb
	.dw #0x04cc
	.dw #0x04cd
	.dw #0x04ce
	.dw #0x04cf
	.dw #0x04d0
	.dw #0x04d1
	.dw #0x04d2
	.dw #0x04d3
	.dw #0x04d4
	.dw #0x04d5
	.dw #0x04d6
	.dw #0x04d7
	.dw #0x04d8
	.dw #0x04d9
	.dw #0x04da
	.dw #0x04db
	.dw #0x04dc
	.dw #0x04dd
	.dw #0x04de
	.dw #0x04df
	.dw #0x04e0
	.dw #0x04e1
	.dw #0x04e2
	.dw #0x04e3
	.dw #0x04e4
	.dw #0x04e5
	.dw #0x04e6
	.dw #0x04e7
	.dw #0x04e8
	.dw #0x04e9
	.dw #0x04ea
	.dw #0x04eb
	.dw #0x04ec
	.dw #0x04ed
	.dw #0x04ee
	.dw #0x04ef
	.dw #0x04f0
	.dw #0x04f1
	.dw #0x04f2
	.dw #0x04f3
	.dw #0x04f4
	.dw #0x04f5
	.dw #0x04f6
	.dw #0x04f7
	.dw #0x04f8
	.dw #0x04f9
	.dw #0x04fa
	.dw #0x04fb
	.dw #0x04fc
	.dw #0x04fd
	.dw #0x04fe
	.dw #0x04ff
	.dw #0x0500
	.dw #0x0501
	.dw #0x0502
	.dw #0x0503
	.dw #0x0504
	.dw #0x0505
	.dw #0x0506
	.dw #0x0507
	.dw #0x0508
	.dw #0x0509
	.dw #0x050a
	.dw #0x050b
	.dw #0x050c
	.dw #0x050d
	.dw #0x050e
	.dw #0x050f
	.dw #0x0510
	.dw #0x0511
	.dw #0x0512
	.dw #0x0513
	.dw #0x0514
	.dw #0x0515
	.dw #0x0516
	.dw #0x0517
	.dw #0x0518
	.dw #0x0519
	.dw #0x051a
	.dw #0x051b
	.dw #0x051c
	.dw #0x051d
	.dw #0x051e
	.dw #0x051f
	.dw #0x0520
	.dw #0x0521
	.dw #0x0522
	.dw #0x0523
	.dw #0x0524
	.dw #0x0525
	.dw #0x0526
	.dw #0x0527
	.dw #0x0528
	.dw #0x0529
	.dw #0x052a
	.dw #0x052b
	.dw #0x052c
	.dw #0x052d
	.dw #0x052e
	.dw #0x052f
	.dw #0x0530
	.dw #0x0531
	.dw #0x0532
	.dw #0x0533
	.dw #0x0534
	.dw #0x0535
	.dw #0x0536
	.dw #0x0537
	.dw #0x0538
	.dw #0x0539
	.dw #0x053a
	.dw #0x053b
	.dw #0x053c
	.dw #0x053d
	.dw #0x053e
	.dw #0x053f
	.dw #0x0540
	.dw #0x0541
	.dw #0x0542
	.dw #0x0543
	.dw #0x0544
	.dw #0x0545
	.dw #0x0546
	.dw #0x0547
	.dw #0x0548
	.dw #0x0549
	.dw #0x054a
	.dw #0x054b
	.dw #0x054c
	.dw #0x054d
	.dw #0x054e
	.dw #0x054f
	.dw #0x0550
	.dw #0x0551
	.dw #0x0552
	.dw #0x0553
	.dw #0x0554
	.dw #0x0555
	.dw #0x0556
	.dw #0x0557
	.dw #0x0558
	.dw #0x0559
	.dw #0x055a
	.dw #0x055b
	.dw #0x055c
	.dw #0x055d
	.dw #0x055e
	.dw #0x055f
	.dw #0x0560
	.dw #0x0561
	.dw #0x0562
	.dw #0x0563
	.dw #0x0564
	.dw #0x0565
	.dw #0x0566
	.dw #0x0567
	.dw #0x0568
	.dw #0x0569
	.dw #0x056a
	.dw #0x056b
	.dw #0x056c
	.dw #0x056d
	.dw #0x056e
	.dw #0x056f
	.dw #0x0570
	.dw #0x0571
	.dw #0x0572
	.dw #0x0573
	.dw #0x0574
	.dw #0x0575
	.dw #0x0576
	.dw #0x0577
	.dw #0x0578
	.dw #0x0579
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
_motion_fixed:
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x057a
	.dw #0x057b
	.dw #0x057c
	.dw #0x057d
	.dw #0x057e
	.dw #0x057f
	.dw #0x0580
	.dw #0x00e8
	.dw #0x0581
	.dw #0x0582
	.dw #0x0583
	.dw #0x0584
	.dw #0x0585
	.dw #0x0586
	.dw #0x0587
	.dw #0x00e8
	.dw #0x0588
	.dw #0x0589
	.dw #0x058a
	.dw #0x058b
	.dw #0x058c
	.dw #0x058d
	.dw #0x058e
	.dw #0x00e8
	.dw #0x058f
	.dw #0x0590
	.dw #0x0591
	.dw #0x0592
	.dw #0x0593
	.dw #0x0594
	.dw #0x0595
_motion_sequences:
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x05	; 5
	.db #0x04	; 4
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x0a	; 10
	.db #0x0b	; 11
	.db #0x0c	; 12
	.db #0x0d	; 13
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x17	; 23
	.db #0x18	; 24
	.db #0x19	; 25
	.db #0x1a	; 26
	.db #0x1b	; 27
	.db #0x1c	; 28
	.db #0x1d	; 29
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x1f	; 31
	.db #0x20	; 32
	.db #0x21	; 33
	.db #0x22	; 34
	.db #0x23	; 35
	.db #0x24	; 36
	.db #0x25	; 37
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x0f	; 15
	.db #0x10	; 16
	.db #0x11	; 17
	.db #0x12	; 18
	.db #0x13	; 19
	.db #0x14	; 20
	.db #0x15	; 21
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x0d	; 13
	.db #0x0c	; 12
	.db #0x0b	; 11
	.db #0x0a	; 10
	.db #0x09	; 9
	.db #0x08	; 8
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x25	; 37
	.db #0x24	; 36
	.db #0x23	; 35
	.db #0x22	; 34
	.db #0x21	; 33
	.db #0x20	; 32
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x1d	; 29
	.db #0x1c	; 28
	.db #0x1b	; 27
	.db #0x1a	; 26
	.db #0x19	; 25
	.db #0x18	; 24
	.db #0x17	; 23
	.db #0x00	; 0
	.db #0xff	; 255
	.db #0x15	; 21
	.db #0x14	; 20
	.db #0x13	; 19
	.db #0x12	; 18
	.db #0x11	; 17
	.db #0x10	; 16
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0xff	; 255
	.area _INITIALIZER
	.area _CABS (ABS)
