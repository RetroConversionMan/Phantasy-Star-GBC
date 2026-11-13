;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module weapon_bank_182
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _weapon_pools
	.globl _weapon_assets
	.globl _weapon_lookup
	.globl _weapon_enemy_groups
	.globl _weapon_frame_indices
	.globl _weapon_effects
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
	.area _CODE_182
	.area _CODE_182
_weapon_effects:
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x66	; 102	'f'
	.db #0x6b	; 107	'k'
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x0a	; 10
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x0a	; 10
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x0a	; 10
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x0a	; 10
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x6a	; 106	'j'
	.db #0x72	; 114	'r'
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x71	; 113	'q'
	.db #0x76	; 118	'v'
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x0a	; 10
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x05	; 5
	.db #0x0a	; 10
	.db #0xa7	; 167
	.db #0x03	; 3
	.db #0x18	; 24
	.db #0x21	; 33
	.db #0xa2	; 162
	.db #0x03	; 3
	.db #0x6a	; 106	'j'
	.db #0x72	; 114	'r'
	.db #0xa6	; 166
	.db #0x03	; 3
	.db #0x11	; 17
	.db #0x19	; 25
	.db #0xa3	; 163
	.db #0x03	; 3
	.db #0x5e	; 94
	.db #0x63	; 99	'c'
	.db #0xa5	; 165
	.db #0x03	; 3
	.db #0x09	; 9
	.db #0x12	; 18
	.db #0xa4	; 164
	.db #0x03	; 3
	.db #0x62	; 98	'b'
	.db #0x67	; 103	'g'
	.db #0xa4	; 164
	.db #0x03	; 3
	.db #0x75	; 117	'u'
	.db #0x7a	; 122	'z'
	.db #0xa8	; 168
	.db #0x03	; 3
	.db #0x20	; 32
	.db #0x29	; 41
	.db #0xa9	; 169
	.db #0x03	; 3
	.db #0x28	; 40
	.db #0x32	; 50	'2'
	.db #0xaa	; 170
	.db #0x03	; 3
	.db #0x31	; 49	'1'
	.db #0x3a	; 58
_weapon_frame_indices:
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x0a	; 10
	.db #0x0b	; 11
	.db #0x0c	; 12
	.db #0x0d	; 13
	.db #0x0e	; 14
	.db #0x0f	; 15
	.db #0x10	; 16
	.db #0x11	; 17
	.db #0x12	; 18
	.db #0x13	; 19
	.db #0x14	; 20
	.db #0x15	; 21
	.db #0x16	; 22
	.db #0x17	; 23
	.db #0x18	; 24
	.db #0x19	; 25
	.db #0x1a	; 26
	.db #0x1b	; 27
	.db #0x1c	; 28
	.db #0x1d	; 29
	.db #0x1e	; 30
	.db #0x1f	; 31
	.db #0x20	; 32
	.db #0x21	; 33
	.db #0x22	; 34
	.db #0x23	; 35
	.db #0x24	; 36
	.db #0x25	; 37
	.db #0x26	; 38
	.db #0x27	; 39
	.db #0x28	; 40
	.db #0x29	; 41
	.db #0x2a	; 42
	.db #0x2b	; 43
	.db #0x2c	; 44
	.db #0x2d	; 45
	.db #0x2e	; 46
	.db #0x2f	; 47
	.db #0x30	; 48	'0'
	.db #0x31	; 49	'1'
	.db #0x32	; 50	'2'
	.db #0x33	; 51	'3'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x34	; 52	'4'
	.db #0x35	; 53	'5'
	.db #0x36	; 54	'6'
	.db #0x37	; 55	'7'
	.db #0x38	; 56	'8'
	.db #0x39	; 57	'9'
	.db #0x3a	; 58
	.db #0x3b	; 59
	.db #0x3c	; 60
	.db #0x3d	; 61
	.db #0x3e	; 62
	.db #0x3f	; 63
	.db #0x40	; 64
	.db #0x41	; 65	'A'
	.db #0x42	; 66	'B'
	.db #0x43	; 67	'C'
	.db #0x44	; 68	'D'
	.db #0x45	; 69	'E'
	.db #0x46	; 70	'F'
	.db #0x47	; 71	'G'
	.db #0x48	; 72	'H'
	.db #0x49	; 73	'I'
	.db #0x4a	; 74	'J'
	.db #0x4b	; 75	'K'
	.db #0x4c	; 76	'L'
	.db #0x4d	; 77	'M'
	.db #0x4e	; 78	'N'
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0xff	; 255
_weapon_enemy_groups:
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x04	; 4
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0x04	; 4
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0x0a	; 10
	.db #0x06	; 6
	.db #0x05	; 5
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x0b	; 11
	.db #0x06	; 6
	.db #0x0c	; 12
	.db #0x07	; 7
	.db #0x09	; 9
	.db #0x06	; 6
	.db #0x0c	; 12
	.db #0x0a	; 10
	.db #0x0d	; 13
	.db #0x05	; 5
	.db #0x09	; 9
	.db #0x0e	; 14
	.db #0x06	; 6
	.db #0x09	; 9
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x09	; 9
	.db #0x0f	; 15
	.db #0x0d	; 13
	.db #0x10	; 16
	.db #0x11	; 17
	.db #0x09	; 9
	.db #0x0e	; 14
	.db #0x11	; 17
	.db #0x0d	; 13
	.db #0x11	; 17
	.db #0x0f	; 15
	.db #0x07	; 7
	.db #0x12	; 18
	.db #0x12	; 18
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x13	; 19
	.db #0x0b	; 11
	.db #0x07	; 7
	.db #0x11	; 17
	.db #0x11	; 17
	.db #0x14	; 20
	.db #0x0e	; 14
	.db #0x0e	; 14
	.db #0x07	; 7
	.db #0x13	; 19
	.db #0x15	; 21
	.db #0x06	; 6
	.db #0x00	; 0
_weapon_lookup:
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
	.dw #0x000c
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
	.dw #0x0022
	.dw #0x0023
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
	.dw #0x0050
	.dw #0x0051
	.dw #0x0052
	.dw #0x0053
	.dw #0x0054
	.dw #0x0055
	.dw #0x0056
	.dw #0x0050
	.dw #0x0050
	.dw #0x0057
	.dw #0x0058
	.dw #0x0059
	.dw #0x005a
	.dw #0x005b
	.dw #0x0050
	.dw #0x0050
	.dw #0x005c
	.dw #0x005d
	.dw #0x005e
	.dw #0x005f
	.dw #0x0060
	.dw #0x0061
	.dw #0x0050
	.dw #0x0050
	.dw #0x0062
	.dw #0x0063
	.dw #0x0064
	.dw #0x0065
	.dw #0x0066
	.dw #0x0067
	.dw #0x0050
	.dw #0x0050
	.dw #0x0068
	.dw #0x0069
	.dw #0x006a
	.dw #0x006b
	.dw #0x006c
	.dw #0x006d
	.dw #0x006e
	.dw #0x0050
	.dw #0x0050
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
	.dw #0x009c
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
	.dw #0x00b2
	.dw #0x00b3
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
	.dw #0x0050
	.dw #0x0050
	.dw #0x00e0
	.dw #0x00e1
	.dw #0x00e2
	.dw #0x00e3
	.dw #0x00e4
	.dw #0x00e5
	.dw #0x0050
	.dw #0x0050
	.dw #0x00e6
	.dw #0x00e7
	.dw #0x00e8
	.dw #0x00e9
	.dw #0x00ea
	.dw #0x0050
	.dw #0x0050
	.dw #0x00eb
	.dw #0x00ec
	.dw #0x00ed
	.dw #0x00ee
	.dw #0x00ef
	.dw #0x00f0
	.dw #0x0050
	.dw #0x0050
	.dw #0x00f1
	.dw #0x00f2
	.dw #0x00f3
	.dw #0x00f4
	.dw #0x00f5
	.dw #0x00f6
	.dw #0x0050
	.dw #0x0050
	.dw #0x00f7
	.dw #0x00f8
	.dw #0x00f9
	.dw #0x00fa
	.dw #0x00fb
	.dw #0x00fc
	.dw #0x00fd
	.dw #0x0050
	.dw #0x0050
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
	.dw #0x0050
	.dw #0x0050
	.dw #0x0123
	.dw #0x0124
	.dw #0x0125
	.dw #0x0126
	.dw #0x0127
	.dw #0x0128
	.dw #0x0050
	.dw #0x0050
	.dw #0x0129
	.dw #0x012a
	.dw #0x012b
	.dw #0x012c
	.dw #0x012d
	.dw #0x0050
	.dw #0x0050
	.dw #0x012e
	.dw #0x012f
	.dw #0x0130
	.dw #0x0131
	.dw #0x0132
	.dw #0x0133
	.dw #0x0050
	.dw #0x0050
	.dw #0x0134
	.dw #0x0135
	.dw #0x0136
	.dw #0x0137
	.dw #0x0138
	.dw #0x0139
	.dw #0x0050
	.dw #0x0050
	.dw #0x013a
	.dw #0x013b
	.dw #0x013c
	.dw #0x013d
	.dw #0x013e
	.dw #0x013f
	.dw #0x0140
	.dw #0x0050
	.dw #0x0050
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
	.dw #0x0050
	.dw #0x0050
	.dw #0x0050
	.dw #0x0166
	.dw #0x0167
	.dw #0x0168
	.dw #0x0169
	.dw #0x016a
	.dw #0x0050
	.dw #0x0050
	.dw #0x016b
	.dw #0x016c
	.dw #0x016d
	.dw #0x016e
	.dw #0x016f
	.dw #0x0050
	.dw #0x0050
	.dw #0x0050
	.dw #0x0170
	.dw #0x0171
	.dw #0x0172
	.dw #0x0173
	.dw #0x0174
	.dw #0x0050
	.dw #0x0050
	.dw #0x0175
	.dw #0x0176
	.dw #0x0177
	.dw #0x0178
	.dw #0x0179
	.dw #0x017a
	.dw #0x0050
	.dw #0x0050
	.dw #0x017b
	.dw #0x017c
	.dw #0x017d
	.dw #0x017e
	.dw #0x017f
	.dw #0x0180
	.dw #0x0181
	.dw #0x0050
	.dw #0x0050
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
	.dw #0x01af
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
	.dw #0x01c5
	.dw #0x01c6
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
	.dw #0x01fb
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
	.dw #0x0211
	.dw #0x0212
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
	.dw #0x0247
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
	.dw #0x025d
	.dw #0x025e
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
	.dw #0x0293
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
	.dw #0x02a9
	.dw #0x02aa
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
	.dw #0x0050
	.dw #0x0050
	.dw #0x02d7
	.dw #0x02d8
	.dw #0x02d9
	.dw #0x02da
	.dw #0x02db
	.dw #0x02dc
	.dw #0x0050
	.dw #0x0050
	.dw #0x02dd
	.dw #0x02de
	.dw #0x02df
	.dw #0x02e0
	.dw #0x02e1
	.dw #0x0050
	.dw #0x0050
	.dw #0x02e2
	.dw #0x02e3
	.dw #0x02e4
	.dw #0x02e5
	.dw #0x02e6
	.dw #0x02e7
	.dw #0x0050
	.dw #0x0050
	.dw #0x02e8
	.dw #0x02e9
	.dw #0x02ea
	.dw #0x02eb
	.dw #0x02ec
	.dw #0x02ed
	.dw #0x0050
	.dw #0x0050
	.dw #0x02ee
	.dw #0x02ef
	.dw #0x02f0
	.dw #0x02f1
	.dw #0x02f2
	.dw #0x02f3
	.dw #0x02f4
	.dw #0x0050
	.dw #0x0050
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
	.dw #0x0322
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
	.dw #0x0338
	.dw #0x0339
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
	.dw #0x036e
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
	.dw #0x0384
	.dw #0x0385
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
	.dw #0x03aa
	.dw #0x03ab
	.dw #0x03ac
	.dw #0x03ad
	.dw #0x03ae
	.dw #0x03af
	.dw #0x03b0
	.dw #0x03b1
	.dw #0x0050
	.dw #0x0050
	.dw #0x03b2
	.dw #0x03b3
	.dw #0x03b4
	.dw #0x03b5
	.dw #0x03b6
	.dw #0x03b7
	.dw #0x0050
	.dw #0x0050
	.dw #0x03b8
	.dw #0x03b9
	.dw #0x03ba
	.dw #0x03bb
	.dw #0x03bc
	.dw #0x0050
	.dw #0x0050
	.dw #0x03bd
	.dw #0x03be
	.dw #0x03bf
	.dw #0x03c0
	.dw #0x03c1
	.dw #0x03c2
	.dw #0x0050
	.dw #0x0050
	.dw #0x03c3
	.dw #0x03c4
	.dw #0x03c5
	.dw #0x03c6
	.dw #0x03c7
	.dw #0x03c8
	.dw #0x0050
	.dw #0x0050
	.dw #0x03c9
	.dw #0x03ca
	.dw #0x03cb
	.dw #0x03cc
	.dw #0x03cd
	.dw #0x03ce
	.dw #0x03cf
	.dw #0x0050
	.dw #0x0050
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
	.dw #0x03fd
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
	.dw #0x0413
	.dw #0x0414
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
	.dw #0x0449
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
	.dw #0x045f
	.dw #0x0460
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
	.dw #0x0050
	.dw #0x0050
	.dw #0x048d
	.dw #0x048e
	.dw #0x048f
	.dw #0x0490
	.dw #0x0491
	.dw #0x0492
	.dw #0x0050
	.dw #0x0050
	.dw #0x0493
	.dw #0x0494
	.dw #0x0495
	.dw #0x0496
	.dw #0x0497
	.dw #0x0050
	.dw #0x0050
	.dw #0x0498
	.dw #0x0499
	.dw #0x049a
	.dw #0x049b
	.dw #0x049c
	.dw #0x049d
	.dw #0x0050
	.dw #0x0050
	.dw #0x049e
	.dw #0x049f
	.dw #0x04a0
	.dw #0x04a1
	.dw #0x04a2
	.dw #0x04a3
	.dw #0x0050
	.dw #0x0050
	.dw #0x04a4
	.dw #0x04a5
	.dw #0x04a6
	.dw #0x04a7
	.dw #0x04a8
	.dw #0x04a9
	.dw #0x04aa
	.dw #0x0050
	.dw #0x0050
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
	.dw #0x04d8
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
	.dw #0x04ee
	.dw #0x04ef
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
	.dw #0x0524
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
	.dw #0x053a
	.dw #0x053b
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
	.dw #0x057a
	.dw #0x057b
	.dw #0x057c
	.dw #0x057d
	.dw #0x057e
	.dw #0x0570
	.dw #0x057f
	.dw #0x0580
	.dw #0x0581
	.dw #0x0582
	.dw #0x0583
	.dw #0x0584
	.dw #0x0585
	.dw #0x0586
	.dw #0x0587
	.dw #0x0588
	.dw #0x0589
	.dw #0x058a
	.dw #0x058b
	.dw #0x058c
	.dw #0x058d
	.dw #0x058e
	.dw #0x0586
	.dw #0x0587
	.dw #0x058f
	.dw #0x0590
	.dw #0x0591
	.dw #0x0592
	.dw #0x0593
	.dw #0x0594
	.dw #0x0595
	.dw #0x0596
	.dw #0x0597
	.dw #0x0598
	.dw #0x0599
	.dw #0x059a
	.dw #0x059b
	.dw #0x059c
	.dw #0x059d
	.dw #0x059e
	.dw #0x059f
	.dw #0x05a0
	.dw #0x05a1
	.dw #0x05a2
	.dw #0x05a3
	.dw #0x05a4
	.dw #0x05a5
	.dw #0x05a6
	.dw #0x05a7
	.dw #0x05a8
	.dw #0x05a9
	.dw #0x05aa
	.dw #0x05ab
	.dw #0x05ac
	.dw #0x05ad
	.dw #0x05ae
	.dw #0x05af
	.dw #0x05b0
	.dw #0x05b1
	.dw #0x05b2
	.dw #0x05b3
	.dw #0x05b4
	.dw #0x05b5
	.dw #0x05b6
	.dw #0x05b7
	.dw #0x05b8
	.dw #0x05b9
	.dw #0x05ba
	.dw #0x05bb
	.dw #0x05bc
	.dw #0x05bd
	.dw #0x05be
	.dw #0x05bf
	.dw #0x05c0
	.dw #0x05c1
	.dw #0x05c2
	.dw #0x05c3
	.dw #0x05c4
	.dw #0x05c5
	.dw #0x05c6
	.dw #0x05c7
	.dw #0x05c8
	.dw #0x05c9
	.dw #0x05ca
	.dw #0x05bc
	.dw #0x05cb
	.dw #0x05cc
	.dw #0x05cd
	.dw #0x05ce
	.dw #0x05cf
	.dw #0x05d0
	.dw #0x05d1
	.dw #0x05d2
	.dw #0x05d3
	.dw #0x05d4
	.dw #0x05d5
	.dw #0x05d6
	.dw #0x05d7
	.dw #0x05d8
	.dw #0x05d9
	.dw #0x05da
	.dw #0x05d2
	.dw #0x05d3
	.dw #0x05db
	.dw #0x05dc
	.dw #0x05dd
	.dw #0x05de
	.dw #0x05df
	.dw #0x05e0
	.dw #0x05e1
	.dw #0x05e2
	.dw #0x05e3
	.dw #0x05e4
	.dw #0x05e5
	.dw #0x05e6
	.dw #0x05e7
	.dw #0x05e8
	.dw #0x05e9
	.dw #0x05ea
	.dw #0x05eb
	.dw #0x05ec
	.dw #0x05ed
	.dw #0x05ee
	.dw #0x05ef
	.dw #0x05f0
	.dw #0x05f1
	.dw #0x05f2
	.dw #0x05f3
	.dw #0x05f4
	.dw #0x05f5
	.dw #0x05f6
	.dw #0x05f7
	.dw #0x05f8
	.dw #0x05f9
	.dw #0x05fa
	.dw #0x05fb
	.dw #0x05fc
	.dw #0x05fd
	.dw #0x05fe
	.dw #0x028a
	.dw #0x028b
	.dw #0x028c
	.dw #0x028d
	.dw #0x05ff
	.dw #0x028f
	.dw #0x0290
	.dw #0x0291
	.dw #0x0292
	.dw #0x0293
	.dw #0x0294
	.dw #0x0600
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
	.dw #0x0293
	.dw #0x02a2
	.dw #0x0601
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
	.dw #0x02a9
	.dw #0x02aa
	.dw #0x02b2
	.dw #0x0602
	.dw #0x02b4
	.dw #0x02b5
	.dw #0x02b6
	.dw #0x02b7
	.dw #0x0603
	.dw #0x0604
	.dw #0x0605
	.dw #0x0606
	.dw #0x0607
	.dw #0x0608
	.dw #0x0609
	.dw #0x02bf
	.dw #0x060a
	.dw #0x060b
	.dw #0x060c
	.dw #0x02c3
	.dw #0x060d
	.dw #0x060e
	.dw #0x060f
	.dw #0x0610
	.dw #0x0611
	.dw #0x0612
	.dw #0x02ca
	.dw #0x0613
	.dw #0x0614
	.dw #0x02cd
	.dw #0x0615
	.dw #0x0616
	.dw #0x0617
	.dw #0x02d1
	.dw #0x0618
_weapon_assets:
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0000
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0001
	.db #0x93	; 147
	.db #0x05	; 5
	.dw _weapon_asset_0002
	.db #0x93	; 147
	.db #0x04	; 4
	.dw _weapon_asset_0003
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0004
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0005
	.db #0x93	; 147
	.db #0x05	; 5
	.dw _weapon_asset_0006
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0007
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0008
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0009
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0010
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0011
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0012
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0013
	.db #0x93	; 147
	.db #0x06	; 6
	.dw _weapon_asset_0014
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0015
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0016
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0017
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0018
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0019
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0020
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0021
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0022
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0023
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0024
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0025
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0026
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0027
	.db #0x93	; 147
	.db #0x06	; 6
	.dw _weapon_asset_0028
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0029
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0030
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0031
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0032
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0033
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0034
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0035
	.db #0x93	; 147
	.db #0x06	; 6
	.dw _weapon_asset_0036
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0037
	.db #0x93	; 147
	.db #0x04	; 4
	.dw _weapon_asset_0038
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0039
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0040
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0041
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0042
	.db #0x93	; 147
	.db #0x05	; 5
	.dw _weapon_asset_0043
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0044
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0045
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0046
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0047
	.db #0x93	; 147
	.db #0x01	; 1
	.dw _weapon_asset_0048
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0049
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0050
	.db #0x93	; 147
	.db #0x04	; 4
	.dw _weapon_asset_0051
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0052
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0053
	.db #0x93	; 147
	.db #0x04	; 4
	.dw _weapon_asset_0054
	.db #0x93	; 147
	.db #0x05	; 5
	.dw _weapon_asset_0055
	.db #0x93	; 147
	.db #0x04	; 4
	.dw _weapon_asset_0056
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0057
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0058
	.db #0x93	; 147
	.db #0x04	; 4
	.dw _weapon_asset_0059
	.db #0x93	; 147
	.db #0x02	; 2
	.dw _weapon_asset_0060
	.db #0x93	; 147
	.db #0x03	; 3
	.dw _weapon_asset_0061
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0062
	.db #0xb7	; 183
	.db #0x05	; 5
	.dw _weapon_asset_0063
	.db #0xb7	; 183
	.db #0x05	; 5
	.dw _weapon_asset_0064
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0065
	.db #0xb7	; 183
	.db #0x05	; 5
	.dw _weapon_asset_0066
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0067
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0068
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0069
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0070
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0071
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0072
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0073
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0074
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0075
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0076
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0077
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0078
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0079
	.db #0x93	; 147
	.db #0x00	; 0
	.dw _weapon_asset_0080
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0081
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0082
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0083
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0084
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0085
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0086
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0087
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0088
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0089
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0090
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0091
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0092
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0093
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0094
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0095
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0096
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0097
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0098
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0099
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0100
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0101
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0102
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0103
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0104
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0105
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0106
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0107
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0108
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0109
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0110
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0111
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0112
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0113
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0114
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0115
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0116
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0117
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0118
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0119
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0120
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0121
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0122
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0123
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0124
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0125
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0126
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0127
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0128
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0129
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0130
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0131
	.db #0xb7	; 183
	.db #0x05	; 5
	.dw _weapon_asset_0132
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0133
	.db #0xb7	; 183
	.db #0x05	; 5
	.dw _weapon_asset_0134
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0135
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0136
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0137
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0138
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0139
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0140
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0141
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0142
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0143
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0144
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0145
	.db #0xb7	; 183
	.db #0x05	; 5
	.dw _weapon_asset_0146
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0147
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0148
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0149
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0150
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0151
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0152
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0153
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0154
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0155
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0156
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0157
	.db #0xb7	; 183
	.db #0x07	; 7
	.dw _weapon_asset_0158
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0159
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0160
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0161
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0162
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0163
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0164
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0165
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0166
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0167
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0168
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0169
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0170
	.db #0xb7	; 183
	.db #0x04	; 4
	.dw _weapon_asset_0171
	.db #0xb7	; 183
	.db #0x03	; 3
	.dw _weapon_asset_0172
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0173
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0174
	.db #0xb7	; 183
	.db #0x01	; 1
	.dw _weapon_asset_0175
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0176
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0177
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0178
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0179
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0180
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0181
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0182
	.db #0xb7	; 183
	.db #0x02	; 2
	.dw _weapon_asset_0183
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0184
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0185
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0186
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0187
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0188
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0189
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0190
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0191
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0192
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0193
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0194
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0195
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0196
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0197
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0198
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0199
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0200
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0201
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0202
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0203
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0204
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0205
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0206
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0207
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0208
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0209
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0210
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0211
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0212
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0213
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0214
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0215
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0216
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0217
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0218
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0219
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0220
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0221
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0222
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0223
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0224
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0225
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0226
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0227
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0228
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0229
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0230
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0231
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0232
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0233
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0234
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0235
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0236
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0237
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0238
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0239
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0240
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0241
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0242
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0243
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0244
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0245
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0246
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0247
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0248
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0249
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0250
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0251
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0252
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0253
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0254
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0255
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0256
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0257
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0258
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0259
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0260
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0261
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0262
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0263
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0264
	.db #0xb8	; 184
	.db #0x07	; 7
	.dw _weapon_asset_0265
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0266
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0267
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0268
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0269
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0270
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0271
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0272
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0273
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0274
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0275
	.db #0xb8	; 184
	.db #0x01	; 1
	.dw _weapon_asset_0276
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0277
	.db #0xb8	; 184
	.db #0x02	; 2
	.dw _weapon_asset_0278
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0279
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0280
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0281
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0282
	.db #0xb8	; 184
	.db #0x05	; 5
	.dw _weapon_asset_0283
	.db #0xb8	; 184
	.db #0x07	; 7
	.dw _weapon_asset_0284
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0285
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0286
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0287
	.db #0xb8	; 184
	.db #0x03	; 3
	.dw _weapon_asset_0288
	.db #0xb8	; 184
	.db #0x06	; 6
	.dw _weapon_asset_0289
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0290
	.db #0xb8	; 184
	.db #0x04	; 4
	.dw _weapon_asset_0291
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0292
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0293
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0294
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0295
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0296
	.db #0xb9	; 185
	.db #0x06	; 6
	.dw _weapon_asset_0297
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0298
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0299
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0300
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0301
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0302
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0303
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0304
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0305
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0306
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0307
	.db #0xb9	; 185
	.db #0x07	; 7
	.dw _weapon_asset_0308
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0309
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0310
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0311
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0312
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0313
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0314
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0315
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0316
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0317
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0318
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0319
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0320
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0321
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0322
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0323
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0324
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0325
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0326
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0327
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0328
	.db #0xb9	; 185
	.db #0x07	; 7
	.dw _weapon_asset_0329
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0330
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0331
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0332
	.db #0xb9	; 185
	.db #0x06	; 6
	.dw _weapon_asset_0333
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0334
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0335
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0336
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0337
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0338
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0339
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0340
	.db #0xb9	; 185
	.db #0x07	; 7
	.dw _weapon_asset_0341
	.db #0xb9	; 185
	.db #0x07	; 7
	.dw _weapon_asset_0342
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0343
	.db #0xb9	; 185
	.db #0x06	; 6
	.dw _weapon_asset_0344
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0345
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0346
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0347
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0348
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0349
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0350
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0351
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0352
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0353
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0354
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0355
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0356
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0357
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0358
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0359
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0360
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0361
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0362
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0363
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0364
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0365
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0366
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0367
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0368
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0369
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0370
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0371
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0372
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0373
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0374
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0375
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0376
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0377
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0378
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0379
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0380
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0381
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0382
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0383
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0384
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0385
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0386
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0387
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0388
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0389
	.db #0xb9	; 185
	.db #0x02	; 2
	.dw _weapon_asset_0390
	.db #0xb9	; 185
	.db #0x01	; 1
	.dw _weapon_asset_0391
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0392
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0393
	.db #0xb9	; 185
	.db #0x05	; 5
	.dw _weapon_asset_0394
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0395
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0396
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0397
	.db #0xb9	; 185
	.db #0x06	; 6
	.dw _weapon_asset_0398
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0399
	.db #0xb9	; 185
	.db #0x03	; 3
	.dw _weapon_asset_0400
	.db #0xb9	; 185
	.db #0x04	; 4
	.dw _weapon_asset_0401
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0402
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0403
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0404
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0405
	.db #0xba	; 186
	.db #0x06	; 6
	.dw _weapon_asset_0406
	.db #0xba	; 186
	.db #0x06	; 6
	.dw _weapon_asset_0407
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0408
	.db #0xba	; 186
	.db #0x06	; 6
	.dw _weapon_asset_0409
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0410
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0411
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0412
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0413
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0414
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0415
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0416
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0417
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0418
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0419
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0420
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0421
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0422
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0423
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0424
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0425
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0426
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0427
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0428
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0429
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0430
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0431
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0432
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0433
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0434
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0435
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0436
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0437
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0438
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0439
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0440
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0441
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0442
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0443
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0444
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0445
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0446
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0447
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0448
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0449
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0450
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0451
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0452
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0453
	.db #0xba	; 186
	.db #0x06	; 6
	.dw _weapon_asset_0454
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0455
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0456
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0457
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0458
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0459
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0460
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0461
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0462
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0463
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0464
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0465
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0466
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0467
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0468
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0469
	.db #0xba	; 186
	.db #0x07	; 7
	.dw _weapon_asset_0470
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0471
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0472
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0473
	.db #0xba	; 186
	.db #0x07	; 7
	.dw _weapon_asset_0474
	.db #0xba	; 186
	.db #0x06	; 6
	.dw _weapon_asset_0475
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0476
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0477
	.db #0xba	; 186
	.db #0x06	; 6
	.dw _weapon_asset_0478
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0479
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0480
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0481
	.db #0xba	; 186
	.db #0x07	; 7
	.dw _weapon_asset_0482
	.db #0xba	; 186
	.db #0x06	; 6
	.dw _weapon_asset_0483
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0484
	.db #0xba	; 186
	.db #0x07	; 7
	.dw _weapon_asset_0485
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0486
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0487
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0488
	.db #0xba	; 186
	.db #0x07	; 7
	.dw _weapon_asset_0489
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0490
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0491
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0492
	.db #0xba	; 186
	.db #0x07	; 7
	.dw _weapon_asset_0493
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0494
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0495
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0496
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0497
	.db #0xba	; 186
	.db #0x04	; 4
	.dw _weapon_asset_0498
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0499
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0500
	.db #0xba	; 186
	.db #0x05	; 5
	.dw _weapon_asset_0501
	.db #0xba	; 186
	.db #0x03	; 3
	.dw _weapon_asset_0502
	.db #0xba	; 186
	.db #0x02	; 2
	.dw _weapon_asset_0503
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0504
	.db #0xba	; 186
	.db #0x01	; 1
	.dw _weapon_asset_0505
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0506
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0507
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0508
	.db #0xbb	; 187
	.db #0x06	; 6
	.dw _weapon_asset_0509
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0510
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0511
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0512
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0513
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0514
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0515
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0516
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0517
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0518
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0519
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0520
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0521
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0522
	.db #0xbb	; 187
	.db #0x06	; 6
	.dw _weapon_asset_0523
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0524
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0525
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0526
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0527
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0528
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0529
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0530
	.db #0xbb	; 187
	.db #0x06	; 6
	.dw _weapon_asset_0531
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0532
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0533
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0534
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0535
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0536
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0537
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0538
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0539
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0540
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0541
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0542
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0543
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0544
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0545
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0546
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0547
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0548
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0549
	.db #0xbb	; 187
	.db #0x05	; 5
	.dw _weapon_asset_0550
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0551
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0552
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0553
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0554
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0555
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0556
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0557
	.db #0xbb	; 187
	.db #0x05	; 5
	.dw _weapon_asset_0558
	.db #0xbb	; 187
	.db #0x05	; 5
	.dw _weapon_asset_0559
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0560
	.db #0xbb	; 187
	.db #0x05	; 5
	.dw _weapon_asset_0561
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0562
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0563
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0564
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0565
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0566
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0567
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0568
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0569
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0570
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0571
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0572
	.db #0xbb	; 187
	.db #0x06	; 6
	.dw _weapon_asset_0573
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0574
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0575
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0576
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0577
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0578
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0579
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0580
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0581
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0582
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0583
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0584
	.db #0xbb	; 187
	.db #0x05	; 5
	.dw _weapon_asset_0585
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0586
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0587
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0588
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0589
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0590
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0591
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0592
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0593
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0594
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0595
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0596
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0597
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0598
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0599
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0600
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0601
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0602
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0603
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0604
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0605
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0606
	.db #0xbb	; 187
	.db #0x05	; 5
	.dw _weapon_asset_0607
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0608
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0609
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0610
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0611
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0612
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0613
	.db #0xbb	; 187
	.db #0x05	; 5
	.dw _weapon_asset_0614
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0615
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0616
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0617
	.db #0xbb	; 187
	.db #0x02	; 2
	.dw _weapon_asset_0618
	.db #0xbb	; 187
	.db #0x01	; 1
	.dw _weapon_asset_0619
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0620
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0621
	.db #0xbb	; 187
	.db #0x05	; 5
	.dw _weapon_asset_0622
	.db #0xbb	; 187
	.db #0x03	; 3
	.dw _weapon_asset_0623
	.db #0xbb	; 187
	.db #0x04	; 4
	.dw _weapon_asset_0624
	.db #0xbc	; 188
	.db #0x07	; 7
	.dw _weapon_asset_0625
	.db #0xbc	; 188
	.db #0x06	; 6
	.dw _weapon_asset_0626
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0627
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0628
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0629
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0630
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0631
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0632
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0633
	.db #0xbc	; 188
	.db #0x06	; 6
	.dw _weapon_asset_0634
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0635
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0636
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0637
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0638
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0639
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0640
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0641
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0642
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0643
	.db #0xbc	; 188
	.db #0x07	; 7
	.dw _weapon_asset_0644
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0645
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0646
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0647
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0648
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0649
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0650
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0651
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0652
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0653
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0654
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0655
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0656
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0657
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0658
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0659
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0660
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0661
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0662
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0663
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0664
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0665
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0666
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0667
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0668
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0669
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0670
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0671
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0672
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0673
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0674
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0675
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0676
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0677
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0678
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0679
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0680
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0681
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0682
	.db #0xbc	; 188
	.db #0x07	; 7
	.dw _weapon_asset_0683
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0684
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0685
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0686
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0687
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0688
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0689
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0690
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0691
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0692
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0693
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0694
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0695
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0696
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0697
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0698
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0699
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0700
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0701
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0702
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0703
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0704
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0705
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0706
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0707
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0708
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0709
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0710
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0711
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0712
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0713
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0714
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0715
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0716
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0717
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0718
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0719
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0720
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0721
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0722
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0723
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0724
	.db #0xbc	; 188
	.db #0x05	; 5
	.dw _weapon_asset_0725
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0726
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0727
	.db #0xbc	; 188
	.db #0x03	; 3
	.dw _weapon_asset_0728
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0729
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0730
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0731
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0732
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0733
	.db #0xbc	; 188
	.db #0x04	; 4
	.dw _weapon_asset_0734
	.db #0xbc	; 188
	.db #0x01	; 1
	.dw _weapon_asset_0735
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0736
	.db #0xbc	; 188
	.db #0x02	; 2
	.dw _weapon_asset_0737
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0738
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0739
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0740
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0741
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0742
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0743
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0744
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0745
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0746
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0747
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0748
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0749
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0750
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0751
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0752
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0753
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0754
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0755
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0756
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0757
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0758
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0759
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0760
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0761
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0762
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0763
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0764
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0765
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0766
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0767
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0768
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0769
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0770
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0771
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0772
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0773
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0774
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0775
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0776
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0777
	.db #0xbd	; 189
	.db #0x06	; 6
	.dw _weapon_asset_0778
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0779
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0780
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0781
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0782
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0783
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0784
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0785
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0786
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0787
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0788
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0789
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0790
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0791
	.db #0xbd	; 189
	.db #0x06	; 6
	.dw _weapon_asset_0792
	.db #0xbd	; 189
	.db #0x06	; 6
	.dw _weapon_asset_0793
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0794
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0795
	.db #0xbd	; 189
	.db #0x07	; 7
	.dw _weapon_asset_0796
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0797
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0798
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0799
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0800
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0801
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0802
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0803
	.db #0xbd	; 189
	.db #0x07	; 7
	.dw _weapon_asset_0804
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0805
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0806
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0807
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0808
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0809
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0810
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0811
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0812
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0813
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0814
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0815
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0816
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0817
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0818
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0819
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0820
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0821
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0822
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0823
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0824
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0825
	.db #0xbd	; 189
	.db #0x06	; 6
	.dw _weapon_asset_0826
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0827
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0828
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0829
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0830
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0831
	.db #0xbd	; 189
	.db #0x02	; 2
	.dw _weapon_asset_0832
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0833
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0834
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0835
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0836
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0837
	.db #0xbd	; 189
	.db #0x01	; 1
	.dw _weapon_asset_0838
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0839
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0840
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0841
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0842
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0843
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0844
	.db #0xbd	; 189
	.db #0x06	; 6
	.dw _weapon_asset_0845
	.db #0xbd	; 189
	.db #0x05	; 5
	.dw _weapon_asset_0846
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0847
	.db #0xbd	; 189
	.db #0x04	; 4
	.dw _weapon_asset_0848
	.db #0xbe	; 190
	.db #0x06	; 6
	.dw _weapon_asset_0849
	.db #0xbd	; 189
	.db #0x03	; 3
	.dw _weapon_asset_0850
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0851
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0852
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0853
	.db #0xbe	; 190
	.db #0x06	; 6
	.dw _weapon_asset_0854
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0855
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0856
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0857
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0858
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0859
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0860
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0861
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0862
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0863
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0864
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0865
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0866
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0867
	.db #0xbe	; 190
	.db #0x06	; 6
	.dw _weapon_asset_0868
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0869
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0870
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0871
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0872
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0873
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0874
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0875
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0876
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0877
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0878
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0879
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0880
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0881
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0882
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0883
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0884
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0885
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0886
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0887
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0888
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0889
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0890
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0891
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0892
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0893
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0894
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0895
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0896
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0897
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0898
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0899
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0900
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0901
	.db #0xbe	; 190
	.db #0x06	; 6
	.dw _weapon_asset_0902
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0903
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0904
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0905
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0906
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0907
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0908
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0909
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0910
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0911
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0912
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0913
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0914
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0915
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0916
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0917
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0918
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0919
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0920
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0921
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0922
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0923
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0924
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0925
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0926
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0927
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0928
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0929
	.db #0xbe	; 190
	.db #0x06	; 6
	.dw _weapon_asset_0930
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0931
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0932
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0933
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0934
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0935
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0936
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0937
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0938
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0939
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0940
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0941
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0942
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0943
	.db #0xbe	; 190
	.db #0x06	; 6
	.dw _weapon_asset_0944
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0945
	.db #0xbe	; 190
	.db #0x04	; 4
	.dw _weapon_asset_0946
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0947
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0948
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0949
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0950
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0951
	.db #0xbe	; 190
	.db #0x05	; 5
	.dw _weapon_asset_0952
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0953
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0954
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0955
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0956
	.db #0xbe	; 190
	.db #0x03	; 3
	.dw _weapon_asset_0957
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0958
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0959
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0960
	.db #0xbe	; 190
	.db #0x01	; 1
	.dw _weapon_asset_0961
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0962
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_0963
	.db #0xbe	; 190
	.db #0x02	; 2
	.dw _weapon_asset_0964
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0965
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0966
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_0967
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0968
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_0969
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_0970
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_0971
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_0972
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_0973
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0974
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0975
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_0976
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_0977
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0978
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_0979
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_0980
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_0981
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_0982
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_0983
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_0984
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_0985
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_0986
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_0987
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_0988
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_0989
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_0990
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_0991
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_0992
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0993
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_0994
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0995
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_0996
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_0997
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_0998
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_0999
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1000
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1001
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1002
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1003
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1004
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1005
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1006
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1007
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1008
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1009
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1010
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_1011
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1012
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1013
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1014
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1015
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1016
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1017
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1018
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1019
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1020
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1021
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1022
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1023
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1024
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1025
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1026
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1027
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1028
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1029
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1030
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1031
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1032
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1033
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1034
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1035
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1036
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1037
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1038
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1039
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1040
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1041
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1042
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1043
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1044
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1045
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1046
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1047
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1048
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1049
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1050
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1051
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1052
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1053
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1054
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1055
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1056
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1057
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1058
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1059
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1060
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1061
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1062
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1063
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_1064
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1065
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1066
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1067
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1068
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1069
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1070
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1071
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_1072
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_1073
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1074
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1075
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1076
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1077
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1078
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1079
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1080
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1081
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_1082
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1083
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1084
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1085
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1086
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1087
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1088
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1089
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1090
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1091
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1092
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1093
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1094
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1095
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1096
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1097
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1098
	.db #0xbf	; 191
	.db #0x07	; 7
	.dw _weapon_asset_1099
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1100
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1101
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1102
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1103
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1104
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1105
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1106
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1107
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1108
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1109
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1110
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1111
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1112
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_1113
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1114
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1115
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1116
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1117
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1118
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1119
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1120
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1121
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1122
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1123
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1124
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1125
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1126
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1127
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1128
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1129
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1130
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1131
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1132
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1133
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1134
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1135
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1136
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1137
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1138
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1139
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1140
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1141
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1142
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1143
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1144
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1145
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1146
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1147
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1148
	.db #0xbf	; 191
	.db #0x06	; 6
	.dw _weapon_asset_1149
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1150
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1151
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1152
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1153
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1154
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1155
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1156
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1157
	.db #0xbf	; 191
	.db #0x07	; 7
	.dw _weapon_asset_1158
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1159
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1160
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1161
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1162
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1163
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1164
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1165
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1166
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1167
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1168
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1169
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1170
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1171
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1172
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1173
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1174
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1175
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1176
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1177
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1178
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1179
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1180
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1181
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1182
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1183
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1184
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1185
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1186
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1187
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1188
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1189
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1190
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1191
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1192
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1193
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1194
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1195
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1196
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1197
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1198
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1199
	.db #0xbf	; 191
	.db #0x01	; 1
	.dw _weapon_asset_1200
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1201
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1202
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1203
	.db #0xbf	; 191
	.db #0x02	; 2
	.dw _weapon_asset_1204
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1205
	.db #0xbf	; 191
	.db #0x03	; 3
	.dw _weapon_asset_1206
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1207
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1208
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1209
	.db #0xbf	; 191
	.db #0x04	; 4
	.dw _weapon_asset_1210
	.db #0xbf	; 191
	.db #0x05	; 5
	.dw _weapon_asset_1211
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1212
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1213
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1214
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1215
	.db #0xd5	; 213
	.db #0x07	; 7
	.dw _weapon_asset_1216
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1217
	.db #0xd5	; 213
	.db #0x06	; 6
	.dw _weapon_asset_1218
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1219
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1220
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1221
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1222
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1223
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1224
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1225
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1226
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1227
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1228
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1229
	.db #0xd5	; 213
	.db #0x06	; 6
	.dw _weapon_asset_1230
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1231
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1232
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1233
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1234
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1235
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1236
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1237
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1238
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1239
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1240
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1241
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1242
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1243
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1244
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1245
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1246
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1247
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1248
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1249
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1250
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1251
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1252
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1253
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1254
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1255
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1256
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1257
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1258
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1259
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1260
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1261
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1262
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1263
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1264
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1265
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1266
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1267
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1268
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1269
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1270
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1271
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1272
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1273
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1274
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1275
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1276
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1277
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1278
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1279
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1280
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1281
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1282
	.db #0xd5	; 213
	.db #0x07	; 7
	.dw _weapon_asset_1283
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1284
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1285
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1286
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1287
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1288
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1289
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1290
	.db #0xd5	; 213
	.db #0x06	; 6
	.dw _weapon_asset_1291
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1292
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1293
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1294
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1295
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1296
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1297
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1298
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1299
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1300
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1301
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1302
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1303
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1304
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1305
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1306
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1307
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1308
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1309
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1310
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1311
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1312
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1313
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1314
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1315
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1316
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1317
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1318
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1319
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1320
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1321
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1322
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1323
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1324
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1325
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1326
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1327
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1328
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1329
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1330
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1331
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1332
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1333
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1334
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1335
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1336
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1337
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1338
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1339
	.db #0xd5	; 213
	.db #0x07	; 7
	.dw _weapon_asset_1340
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1341
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1342
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1343
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1344
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1345
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1346
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1347
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1348
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1349
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1350
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1351
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1352
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1353
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1354
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1355
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1356
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1357
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1358
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1359
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1360
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1361
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1362
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1363
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1364
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1365
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1366
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1367
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1368
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1369
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1370
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1371
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1372
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1373
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1374
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1375
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1376
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1377
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1378
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1379
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1380
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1381
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1382
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1383
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1384
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1385
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1386
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1387
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1388
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1389
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1390
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1391
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1392
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1393
	.db #0xd5	; 213
	.db #0x06	; 6
	.dw _weapon_asset_1394
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1395
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1396
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1397
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1398
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1399
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1400
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1401
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1402
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1403
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1404
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1405
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1406
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1407
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1408
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1409
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1410
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1411
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1412
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1413
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1414
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1415
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1416
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1417
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1418
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1419
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1420
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1421
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1422
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1423
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1424
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1425
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1426
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1427
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1428
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1429
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1430
	.db #0xd5	; 213
	.db #0x06	; 6
	.dw _weapon_asset_1431
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1432
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1433
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1434
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1435
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1436
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1437
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1438
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1439
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1440
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1441
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1442
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1443
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1444
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1445
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1446
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1447
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1448
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1449
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1450
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1451
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1452
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1453
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1454
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1455
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1456
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1457
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1458
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1459
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1460
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1461
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1462
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1463
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1464
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1465
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1466
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1467
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1468
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1469
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1470
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1471
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1472
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1473
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1474
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1475
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1476
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1477
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1478
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1479
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1480
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1481
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1482
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1483
	.db #0xd5	; 213
	.db #0x06	; 6
	.dw _weapon_asset_1484
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1485
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1486
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1487
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1488
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1489
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1490
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1491
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1492
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1493
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1494
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1495
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1496
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1497
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1498
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1499
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1500
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1501
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1502
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1503
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1504
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1505
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1506
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1507
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1508
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1509
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1510
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1511
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1512
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1513
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1514
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1515
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1516
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1517
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1518
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1519
	.db #0xd5	; 213
	.db #0x06	; 6
	.dw _weapon_asset_1520
	.db #0xd5	; 213
	.db #0x01	; 1
	.dw _weapon_asset_1521
	.db #0xd5	; 213
	.db #0x06	; 6
	.dw _weapon_asset_1522
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1523
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1524
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1525
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1526
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1527
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1528
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1529
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1530
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1531
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1532
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1533
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1534
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1535
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1536
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1537
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1538
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1539
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1540
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1541
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1542
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1543
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1544
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1545
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1546
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1547
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1548
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1549
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1550
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1551
	.db #0xd5	; 213
	.db #0x05	; 5
	.dw _weapon_asset_1552
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1553
	.db #0xd5	; 213
	.db #0x04	; 4
	.dw _weapon_asset_1554
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1555
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1556
	.db #0xd5	; 213
	.db #0x02	; 2
	.dw _weapon_asset_1557
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1558
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1559
	.db #0xd5	; 213
	.db #0x03	; 3
	.dw _weapon_asset_1560
_weapon_pools:
	.db #0x93	; 147
	.dw _weapon_pairs_00
	.db #0x93	; 147
	.dw _weapon_pairs_01
	.db #0x93	; 147
	.dw _weapon_pairs_02
	.db #0xb7	; 183
	.dw _weapon_pairs_03
	.db #0xb7	; 183
	.dw _weapon_pairs_04
	.db #0xb7	; 183
	.dw _weapon_pairs_05
	.db #0xb8	; 184
	.dw _weapon_pairs_06
	.db #0xb8	; 184
	.dw _weapon_pairs_07
	.db #0xb8	; 184
	.dw _weapon_pairs_08
	.db #0xb9	; 185
	.dw _weapon_pairs_09
	.db #0xb9	; 185
	.dw _weapon_pairs_10
	.db #0xb9	; 185
	.dw _weapon_pairs_11
	.db #0xba	; 186
	.dw _weapon_pairs_12
	.db #0xba	; 186
	.dw _weapon_pairs_13
	.db #0xba	; 186
	.dw _weapon_pairs_14
	.db #0xbb	; 187
	.dw _weapon_pairs_15
	.db #0xbb	; 187
	.dw _weapon_pairs_16
	.db #0xbb	; 187
	.dw _weapon_pairs_17
	.db #0xbc	; 188
	.dw _weapon_pairs_18
	.db #0xbc	; 188
	.dw _weapon_pairs_19
	.db #0xbc	; 188
	.dw _weapon_pairs_20
	.db #0xbd	; 189
	.dw _weapon_pairs_21
	.db #0xbd	; 189
	.dw _weapon_pairs_22
	.db #0xbd	; 189
	.dw _weapon_pairs_23
	.db #0xbe	; 190
	.dw _weapon_pairs_24
	.db #0xbe	; 190
	.dw _weapon_pairs_25
	.db #0xbe	; 190
	.dw _weapon_pairs_26
	.db #0xbf	; 191
	.dw _weapon_pairs_27
	.db #0xbf	; 191
	.dw _weapon_pairs_28
	.db #0x93	; 147
	.dw _weapon_pairs_29
	.area _INITIALIZER
	.area _CABS (ABS)
