;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module enemy_magic_bank_252
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _enemy_magic_pools
	.globl _enemy_magic_assets
	.globl _enemy_magic_effect_lookup
	.globl _enemy_magic_pose_lookup
	.globl _enemy_magic_pose_keys
	.globl _enemy_magic_animations
	.globl _enemy_magic_effects
	.globl _enemy_magic_kinds
	.globl _enemy_magic_enemies
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
	.area _CODE_252
	.area _CODE_252
_enemy_magic_enemies:
	.db #0x0d	; 13
	.db #0x17	; 23
	.db #0x2f	; 47
	.db #0x31	; 49	'1'
	.db #0x38	; 56	'8'
	.db #0x39	; 57	'9'
	.db #0x41	; 65	'A'
_enemy_magic_kinds:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x01	; 1
_enemy_magic_effects:
	.db #0xa8	; 168
	.db #0x03	; 3
	.db #0x46	; 70	'F'
	.db #0x4f	; 79	'O'
	.db #0xa9	; 169
	.db #0x03	; 3
	.db #0x79	; 121	'y'
	.db #0x82	; 130
_enemy_magic_animations:
	.db #0x01	; 1
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.db #0xfd	; 253
	.dw _enemy_magic_sequence_13
	.db #0x05	; 5
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x70	; 112	'p'
	.db #0xfd	; 253
	.dw _enemy_magic_sequence_23
	.db #0x0f	; 15
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0xfd	; 253
	.dw _enemy_magic_sequence_47
	.db #0x07	; 7
	.db #0x0a	; 10
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0xfd	; 253
	.dw _enemy_magic_sequence_49
	.db #0x0f	; 15
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0xfd	; 253
	.dw _enemy_magic_sequence_56
	.db #0x07	; 7
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0xad	; 173
	.db #0xfd	; 253
	.dw _enemy_magic_sequence_57
	.db #0x05	; 5
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0xb5	; 181
	.db #0xfd	; 253
	.dw _enemy_magic_sequence_65
_enemy_magic_pose_keys:
	.db #0x2f	; 47
	.db #0x1f	; 31
	.db #0x38	; 56	'8'
	.db #0x1f	; 31
	.db #0x39	; 57	'9'
	.db #0xae	; 174
	.db #0x39	; 57	'9'
	.db #0xaf	; 175
_enemy_magic_pose_lookup:
	.dw #0x0018
	.dw #0x0019
	.dw #0x001a
	.dw #0x001b
	.dw #0x001c
	.dw #0x001d
	.dw #0x001e
	.dw #0x001f
	.dw #0x0020
	.dw #0x0018
	.dw #0x0021
	.dw #0x0022
	.dw #0x0033
	.dw #0x0034
	.dw #0x0035
	.dw #0x0036
	.dw #0x0037
	.dw #0x0038
	.dw #0x0039
	.dw #0x003a
	.dw #0x003b
	.dw #0x0033
	.dw #0x003c
	.dw #0x003d
	.dw #0x0046
	.dw #0x0047
	.dw #0x0048
	.dw #0x0049
	.dw #0x004a
	.dw #0x004b
	.dw #0x004c
	.dw #0x004d
	.dw #0x004e
	.dw #0x0046
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
	.dw #0x0051
	.dw #0x005a
	.dw #0x005b
_enemy_magic_effect_lookup:
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
	.dw #0x003e
	.dw #0x003f
	.dw #0x0040
	.dw #0x0041
	.dw #0x0042
	.dw #0x0043
	.dw #0x0044
	.dw #0x0045
	.dw #0x005c
	.dw #0x005d
	.dw #0x005e
	.dw #0x005f
	.dw #0x0060
	.dw #0x0061
	.dw #0x0062
	.dw #0x0063
_enemy_magic_assets:
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_000
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_001
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_002
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_003
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_004
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_005
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_006
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_007
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_008
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_009
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_010
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_011
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_012
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_013
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_014
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_015
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_016
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_017
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_018
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_019
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_020
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_021
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_022
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_023
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_024
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_025
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_026
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_027
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_028
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_029
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_030
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_031
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_032
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_033
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_034
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_035
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_036
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_037
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_038
	.db #0xfd	; 253
	.db #0x03	; 3
	.dw _enemy_magic_asset_039
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_040
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_041
	.db #0xfd	; 253
	.db #0x03	; 3
	.dw _enemy_magic_asset_042
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_043
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_044
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_045
	.db #0xfd	; 253
	.db #0x05	; 5
	.dw _enemy_magic_asset_046
	.db #0xfd	; 253
	.db #0x06	; 6
	.dw _enemy_magic_asset_047
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_048
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_049
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_050
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_051
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_052
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_053
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_054
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_055
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_056
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_057
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_058
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_059
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_060
	.db #0xfd	; 253
	.db #0x11	; 17
	.dw _enemy_magic_asset_061
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_062
	.db #0xfd	; 253
	.db #0x03	; 3
	.dw _enemy_magic_asset_063
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_064
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_065
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_066
	.db #0xfd	; 253
	.db #0x03	; 3
	.dw _enemy_magic_asset_067
	.db #0xfd	; 253
	.db #0x03	; 3
	.dw _enemy_magic_asset_068
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_069
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_070
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_071
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_072
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_073
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_074
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_075
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_076
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_077
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_078
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_079
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_080
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_081
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_082
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_083
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_084
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_085
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_086
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_087
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_088
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_089
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_090
	.db #0xfd	; 253
	.db #0x12	; 18
	.dw _enemy_magic_asset_091
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_092
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_093
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_094
	.db #0xfd	; 253
	.db #0x04	; 4
	.dw _enemy_magic_asset_095
	.db #0xfd	; 253
	.db #0x05	; 5
	.dw _enemy_magic_asset_096
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_097
	.db #0xfd	; 253
	.db #0x01	; 1
	.dw _enemy_magic_asset_098
	.db #0xfd	; 253
	.db #0x02	; 2
	.dw _enemy_magic_asset_099
_enemy_magic_pools:
	.db #0xfd	; 253
	.dw _enemy_magic_pairs_00
	.area _INITIALIZER
	.area _CABS (ABS)
