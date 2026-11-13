;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module boss_effects_bank_254
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _boss_patches
	.globl _boss_patch_cells
	.globl _boss_pools
	.globl _boss_assets
	.globl _boss_animations
	.globl _boss_pose_lookup
	.globl _boss_pose_keys
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
	.area _CODE_254
	.area _CODE_254
_boss_pose_keys:
	.db #0x48	; 72	'H'
	.db #0x10	; 16
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0x11	; 17
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0x12	; 18
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0x46	; 70	'F'
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0x8e	; 142
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xb3	; 179
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xec	; 236
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xed	; 237
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xee	; 238
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xef	; 239
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf0	; 240
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf1	; 241
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf2	; 242
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf3	; 243
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf4	; 244
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf5	; 245
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf6	; 246
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf7	; 247
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf8	; 248
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xf9	; 249
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xfa	; 250
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xfb	; 251
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xfc	; 252
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xfd	; 253
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xfe	; 254
	.db #0xff	; 255
	.db #0x48	; 72	'H'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x49	; 73	'I'
	.db #0x13	; 19
	.db #0x4f	; 79	'O'
	.db #0x49	; 73	'I'
	.db #0x14	; 20
	.db #0x4f	; 79	'O'
	.db #0x49	; 73	'I'
	.db #0x3d	; 61
	.db #0x4f	; 79	'O'
	.db #0x49	; 73	'I'
	.db #0x3e	; 62
	.db #0x4f	; 79	'O'
	.db #0x49	; 73	'I'
	.db #0x76	; 118	'v'
	.db #0x4f	; 79	'O'
	.db #0x49	; 73	'I'
	.db #0x77	; 119	'w'
	.db #0x4f	; 79	'O'
	.db #0x49	; 73	'I'
	.db #0x88	; 136
	.db #0x4f	; 79	'O'
	.db #0x49	; 73	'I'
	.db #0x89	; 137
	.db #0x4f	; 79	'O'
	.db #0x49	; 73	'I'
	.db #0x8a	; 138
	.db #0x47	; 71	'G'
	.db #0x49	; 73	'I'
	.db #0x8b	; 139
	.db #0x47	; 71	'G'
	.db #0x49	; 73	'I'
	.db #0x8c	; 140
	.db #0x47	; 71	'G'
	.db #0x49	; 73	'I'
	.db #0xcc	; 204
	.db #0x47	; 71	'G'
	.db #0x49	; 73	'I'
	.db #0xcd	; 205
	.db #0x47	; 71	'G'
_boss_pose_lookup:
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
_boss_animations:
	.db #0x03	; 3
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.dw _boss_sequence_0
	.db #0x03	; 3
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.dw _boss_sequence_1
	.db #0x03	; 3
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.dw _boss_sequence_2
	.db #0x03	; 3
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.dw _boss_sequence_3
	.db #0x05	; 5
	.db #0x19	; 25
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xff	; 255
	.dw _boss_sequence_4
_boss_assets:
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_0
	.db #0xff	; 255
	.db #0x05	; 5
	.dw _boss_asset_1
	.db #0xff	; 255
	.db #0x08	; 8
	.dw _boss_asset_2
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_3
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_4
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_5
	.db #0xff	; 255
	.db #0x04	; 4
	.dw _boss_asset_6
	.db #0xff	; 255
	.db #0x05	; 5
	.dw _boss_asset_7
	.db #0xff	; 255
	.db #0x05	; 5
	.dw _boss_asset_8
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_9
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_10
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_11
	.db #0xff	; 255
	.db #0x04	; 4
	.dw _boss_asset_12
	.db #0xff	; 255
	.db #0x0b	; 11
	.dw _boss_asset_13
	.db #0xff	; 255
	.db #0x01	; 1
	.dw _boss_asset_14
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_15
	.db #0xff	; 255
	.db #0x03	; 3
	.dw _boss_asset_16
	.db #0xff	; 255
	.db #0x04	; 4
	.dw _boss_asset_17
	.db #0xff	; 255
	.db #0x06	; 6
	.dw _boss_asset_18
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_19
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_20
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_21
	.db #0xff	; 255
	.db #0x04	; 4
	.dw _boss_asset_22
	.db #0xff	; 255
	.db #0x06	; 6
	.dw _boss_asset_23
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_24
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_25
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_26
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_27
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_28
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_29
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_30
	.db #0xff	; 255
	.db #0x02	; 2
	.dw _boss_asset_31
	.db #0xff	; 255
	.db #0x04	; 4
	.dw _boss_asset_32
	.db #0xff	; 255
	.db #0x17	; 23
	.dw _boss_asset_33
	.db #0xff	; 255
	.db #0x19	; 25
	.dw _boss_asset_34
	.db #0xff	; 255
	.db #0x0f	; 15
	.dw _boss_asset_35
	.db #0xff	; 255
	.db #0x17	; 23
	.dw _boss_asset_36
	.db #0xff	; 255
	.db #0x16	; 22
	.dw _boss_asset_37
	.db #0xff	; 255
	.db #0x06	; 6
	.dw _boss_asset_38
_boss_pools:
	.db #0xff	; 255
	.dw _boss_pairs_0
_boss_patch_cells:
	.db #0x6d	; 109	'm'
	.db #0x6e	; 110	'n'
	.db #0x81	; 129
	.db #0x82	; 130
	.db #0x95	; 149
	.db #0x96	; 150
	.db #0xa9	; 169
	.db #0xaa	; 170
	.db #0xbd	; 189
	.db #0xbe	; 190
_boss_patches:
	.dw _boss_patch_0
	.dw _boss_patch_1
	.dw _boss_patch_2
	.area _INITIALIZER
	.area _CABS (ABS)
