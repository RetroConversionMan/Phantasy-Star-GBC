;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module battle_animation_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _battle_animation_pools
	.globl _battle_animations
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
	.area _CODE_31
	.area _CODE_31
_battle_animations:
	.db #0x01	; 1
	.db #0x0b	; 11
	.db #0x03	; 3
	.db #0x66	; 102	'f'
	.db #0x97	; 151
	.dw _battle_motion_sequence_01
	.db #0x07	; 7
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0xb4	; 180
	.dw _battle_motion_sequence_02
	.db #0x05	; 5
	.db #0x0d	; 13
	.db #0x04	; 4
	.db #0xd3	; 211
	.db #0xa7	; 167
	.dw _battle_motion_sequence_03
	.db #0x03	; 3
	.db #0x0c	; 12
	.db #0x06	; 6
	.db #0x82	; 130
	.db #0xb4	; 180
	.dw _battle_motion_sequence_04
	.db #0x01	; 1
	.db #0x0b	; 11
	.db #0x03	; 3
	.db #0x50	; 80	'P'
	.db #0x9d	; 157
	.dw _battle_motion_sequence_05
	.db #0x01	; 1
	.db #0x0b	; 11
	.db #0x03	; 3
	.db #0x50	; 80	'P'
	.db #0xa9	; 169
	.dw _battle_motion_sequence_06
	.db #0x07	; 7
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0xb4	; 180
	.dw _battle_motion_sequence_07
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x04	; 4
	.db #0x99	; 153
	.db #0xae	; 174
	.dw _battle_motion_sequence_08
	.db #0x05	; 5
	.db #0x0d	; 13
	.db #0x04	; 4
	.db #0xd3	; 211
	.db #0xb4	; 180
	.dw _battle_motion_sequence_09
	.db #0x03	; 3
	.db #0x0c	; 12
	.db #0x06	; 6
	.db #0x82	; 130
	.db #0xb4	; 180
	.dw _battle_motion_sequence_10
	.db #0x01	; 1
	.db #0x0b	; 11
	.db #0x03	; 3
	.db #0x50	; 80	'P'
	.db #0xb0	; 176
	.dw _battle_motion_sequence_11
	.db #0x03	; 3
	.db #0x07	; 7
	.db #0x04	; 4
	.db #0x99	; 153
	.db #0xb5	; 181
	.dw _battle_motion_sequence_12
	.db #0x01	; 1
	.db #0x0b	; 11
	.db #0x03	; 3
	.db #0x66	; 102	'f'
	.db #0xb2	; 178
	.dw _battle_motion_sequence_13
	.db #0x07	; 7
	.db #0x0a	; 10
	.db #0x05	; 5
	.db #0xce	; 206
	.db #0xb5	; 181
	.dw _battle_motion_sequence_14
	.db #0x03	; 3
	.db #0x0a	; 10
	.db #0x06	; 6
	.db #0x9d	; 157
	.db #0xb5	; 181
	.dw _battle_motion_sequence_15
	.db #0x05	; 5
	.db #0x0d	; 13
	.db #0x04	; 4
	.db #0xd3	; 211
	.db #0xb5	; 181
	.dw _battle_motion_sequence_16
	.db #0x07	; 7
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0xb5	; 181
	.dw _battle_motion_sequence_17
	.db #0x03	; 3
	.db #0x11	; 17
	.db #0x08	; 8
	.db #0xd7	; 215
	.db #0xb5	; 181
	.dw _battle_motion_sequence_18
	.db #0x07	; 7
	.db #0x0a	; 10
	.db #0x07	; 7
	.db #0x2d	; 45
	.db #0xb5	; 181
	.dw _battle_motion_sequence_19
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x28	; 40
	.db #0xb5	; 181
	.dw _battle_motion_sequence_20
	.db #0x07	; 7
	.db #0x0b	; 11
	.db #0x05	; 5
	.db #0x00	; 0
	.db #0xb5	; 181
	.dw _battle_motion_sequence_21
	.db #0x07	; 7
	.db #0x0b	; 11
	.db #0x09	; 9
	.db #0x5d	; 93
	.db #0xb5	; 181
	.dw _battle_motion_sequence_22
	.db #0x05	; 5
	.db #0x0b	; 11
	.db #0x06	; 6
	.db #0x70	; 112	'p'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_23
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x06	; 6
	.db #0x4a	; 74	'J'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_24
	.db #0x07	; 7
	.db #0x0b	; 11
	.db #0x09	; 9
	.db #0x5d	; 93
	.db #0xb5	; 181
	.dw _battle_motion_sequence_25
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x28	; 40
	.db #0xb5	; 181
	.dw _battle_motion_sequence_26
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0x40	; 64
	.db #0xb5	; 181
	.dw _battle_motion_sequence_27
	.db #0x07	; 7
	.db #0x0a	; 10
	.db #0x05	; 5
	.db #0xce	; 206
	.db #0xb5	; 181
	.dw _battle_motion_sequence_28
	.db #0x03	; 3
	.db #0x11	; 17
	.db #0x08	; 8
	.db #0xd7	; 215
	.db #0xb5	; 181
	.dw _battle_motion_sequence_29
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0x06	; 6
	.db #0x16	; 22
	.db #0xb5	; 181
	.dw _battle_motion_sequence_30
	.db #0x0b	; 11
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x69	; 105	'i'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_31
	.db #0x07	; 7
	.db #0x0b	; 11
	.db #0x08	; 8
	.db #0x35	; 53	'5'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_32
	.db #0x07	; 7
	.db #0x0a	; 10
	.db #0x07	; 7
	.db #0x2d	; 45
	.db #0xb5	; 181
	.dw _battle_motion_sequence_33
	.db #0x07	; 7
	.db #0x0b	; 11
	.db #0x05	; 5
	.db #0x00	; 0
	.db #0xb5	; 181
	.dw _battle_motion_sequence_34
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x06	; 6
	.db #0x4a	; 74	'J'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_35
	.db #0x07	; 7
	.db #0x0b	; 11
	.db #0x08	; 8
	.db #0x35	; 53	'5'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_36
	.db #0x05	; 5
	.db #0x0b	; 11
	.db #0x06	; 6
	.db #0x70	; 112	'p'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_37
	.db #0x03	; 3
	.db #0x0f	; 15
	.db #0x08	; 8
	.db #0x54	; 84	'T'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_38
	.db #0x07	; 7
	.db #0x0a	; 10
	.db #0x05	; 5
	.db #0xce	; 206
	.db #0xb5	; 181
	.dw _battle_motion_sequence_39
	.db #0x07	; 7
	.db #0x0b	; 11
	.db #0x05	; 5
	.db #0x00	; 0
	.db #0xb5	; 181
	.dw _battle_motion_sequence_40
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x20	; 32
	.db #0xb5	; 181
	.dw _battle_motion_sequence_41
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x06	; 6
	.db #0x4a	; 74	'J'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_42
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0x40	; 64
	.db #0xb5	; 181
	.dw _battle_motion_sequence_43
	.db #0x0b	; 11
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x69	; 105	'i'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_44
	.db #0x0b	; 11
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x69	; 105	'i'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_45
	.db #0x03	; 3
	.db #0x0c	; 12
	.db #0x08	; 8
	.db #0x79	; 121	'y'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_46
	.db #0x0f	; 15
	.db #0x06	; 6
	.db #0x03	; 3
	.db #0x1c	; 28
	.db #0xb5	; 181
	.dw _battle_motion_sequence_47
	.db #0x03	; 3
	.db #0x0f	; 15
	.db #0x08	; 8
	.db #0x54	; 84	'T'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_48
	.db #0x07	; 7
	.db #0x0a	; 10
	.db #0x04	; 4
	.db #0x24	; 36
	.db #0xb5	; 181
	.dw _battle_motion_sequence_49
	.db #0x07	; 7
	.db #0x06	; 6
	.db #0x04	; 4
	.db #0xbb	; 187
	.db #0xb5	; 181
	.dw _battle_motion_sequence_50
	.db #0x03	; 3
	.db #0x0c	; 12
	.db #0x08	; 8
	.db #0x79	; 121	'y'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_51
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0x20	; 32
	.db #0xb5	; 181
	.dw _battle_motion_sequence_52
	.db #0x07	; 7
	.db #0x06	; 6
	.db #0x04	; 4
	.db #0xbb	; 187
	.db #0xb5	; 181
	.dw _battle_motion_sequence_53
	.db #0x03	; 3
	.db #0x0f	; 15
	.db #0x08	; 8
	.db #0x54	; 84	'T'
	.db #0xb5	; 181
	.dw _battle_motion_sequence_54
	.db #0x05	; 5
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0xb5	; 181
	.db #0xb5	; 181
	.dw _battle_motion_sequence_55
	.db #0x0f	; 15
	.db #0x06	; 6
	.db #0x03	; 3
	.db #0x1c	; 28
	.db #0xb5	; 181
	.dw _battle_motion_sequence_56
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0xad	; 173
	.db #0xb5	; 181
	.dw _battle_motion_sequence_57
	.db #0x07	; 7
	.db #0x0e	; 14
	.db #0x08	; 8
	.db #0xa3	; 163
	.db #0xb5	; 181
	.dw _battle_motion_sequence_58
	.db #0x07	; 7
	.db #0x0e	; 14
	.db #0x08	; 8
	.db #0xa3	; 163
	.db #0xb5	; 181
	.dw _battle_motion_sequence_59
	.db #0x03	; 3
	.db #0x09	; 9
	.db #0x07	; 7
	.db #0x02	; 2
	.db #0xb5	; 181
	.dw _battle_motion_sequence_60
	.db #0x03	; 3
	.db #0x09	; 9
	.db #0x07	; 7
	.db #0x02	; 2
	.db #0xb5	; 181
	.dw _battle_motion_sequence_61
	.db #0x03	; 3
	.db #0x0d	; 13
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0xb5	; 181
	.dw _battle_motion_sequence_62
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0x06	; 6
	.db #0x16	; 22
	.db #0xb5	; 181
	.dw _battle_motion_sequence_63
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0xad	; 173
	.db #0xb5	; 181
	.dw _battle_motion_sequence_64
	.db #0x05	; 5
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0xb5	; 181
	.db #0xb5	; 181
	.dw _battle_motion_sequence_65
	.db #0x07	; 7
	.db #0x06	; 6
	.db #0x04	; 4
	.db #0xbb	; 187
	.db #0xb5	; 181
	.dw _battle_motion_sequence_66
	.db #0x03	; 3
	.db #0x09	; 9
	.db #0x06	; 6
	.db #0xc0	; 192
	.db #0xb5	; 181
	.dw _battle_motion_sequence_67
	.db #0x03	; 3
	.db #0x09	; 9
	.db #0x07	; 7
	.db #0x02	; 2
	.db #0xb5	; 181
	.dw _battle_motion_sequence_68
	.db #0x03	; 3
	.db #0x09	; 9
	.db #0x07	; 7
	.db #0x02	; 2
	.db #0xb5	; 181
	.dw _battle_motion_sequence_69
	.db #0x03	; 3
	.db #0x12	; 18
	.db #0x09	; 9
	.db #0xe3	; 227
	.db #0xb5	; 181
	.dw _battle_motion_sequence_70
	.db #0x03	; 3
	.db #0x0d	; 13
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0xb5	; 181
	.dw _battle_motion_sequence_71
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.dw #0x0000
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.dw #0x0000
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x04	; 4
	.db #0xdf	; 223
	.db #0xb5	; 181
	.dw _battle_motion_sequence_74
_battle_animation_pools:
	.db #0x95	; 149
	.dw _battle_motion_pairs_00
	.db #0x96	; 150
	.dw _battle_motion_pairs_01
	.db #0x97	; 151
	.dw _battle_motion_pairs_02
	.db #0x98	; 152
	.dw _battle_motion_pairs_03
	.db #0x99	; 153
	.dw _battle_motion_pairs_04
	.db #0x9a	; 154
	.dw _battle_motion_pairs_05
	.db #0x9b	; 155
	.dw _battle_motion_pairs_06
	.db #0x9c	; 156
	.dw _battle_motion_pairs_07
	.area _INITIALIZER
	.area _CABS (ABS)
