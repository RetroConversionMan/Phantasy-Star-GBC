;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module scene_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _scene_pattern_pools
	.globl _scene_assets
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
	.area _CODE_13
	.area _CODE_13
_scene_assets:
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_000
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_001
	.db #0x02	; 2
	.db #0x37	; 55	'7'
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_002
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_003
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_004
	.db #0x05	; 5
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_005
	.db #0x05	; 5
	.db #0x37	; 55	'7'
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_006
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_007
	.db #0x06	; 6
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_008
	.db #0x06	; 6
	.db #0x0a	; 10
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_009
	.db #0x06	; 6
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x61	; 97	'a'
	.dw _scene_map_010
	.db #0x06	; 6
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_011
	.db #0x06	; 6
	.db #0x15	; 21
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_012
	.db #0x06	; 6
	.db #0x16	; 22
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_013
	.db #0x06	; 6
	.db #0x17	; 23
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_014
	.db #0x06	; 6
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_015
	.db #0x06	; 6
	.db #0x37	; 55	'7'
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_016
	.db #0x06	; 6
	.db #0x38	; 56	'8'
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_017
	.db #0x06	; 6
	.db #0x39	; 57	'9'
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_018
	.db #0x06	; 6
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_019
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_020
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x62	; 98	'b'
	.dw _scene_map_021
	.db #0x08	; 8
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_022
	.db #0x08	; 8
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_023
	.db #0x08	; 8
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_024
	.db #0x08	; 8
	.db #0x0d	; 13
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_025
	.db #0x08	; 8
	.db #0x11	; 17
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_026
	.db #0x08	; 8
	.db #0x15	; 21
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_027
	.db #0x08	; 8
	.db #0x31	; 49	'1'
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_028
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_029
	.db #0x09	; 9
	.db #0x1d	; 29
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_030
	.db #0x09	; 9
	.db #0x27	; 39
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_031
	.db #0x09	; 9
	.db #0x28	; 40
	.db #0x00	; 0
	.db #0x63	; 99	'c'
	.dw _scene_map_032
	.db #0x09	; 9
	.db #0x33	; 51	'3'
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_033
	.db #0x0a	; 10
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_034
	.db #0x0a	; 10
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_035
	.db #0x0a	; 10
	.db #0x13	; 19
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_036
	.db #0x0a	; 10
	.db #0x31	; 49	'1'
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_037
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_038
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_039
	.db #0x0d	; 13
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_040
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_041
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_042
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x64	; 100	'd'
	.dw _scene_map_043
	.db #0x10	; 16
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_044
	.db #0x10	; 16
	.db #0x02	; 2
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_045
	.db #0x10	; 16
	.db #0x06	; 6
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_046
	.db #0x10	; 16
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_047
	.db #0x10	; 16
	.db #0x09	; 9
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_048
	.db #0x10	; 16
	.db #0x0a	; 10
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_049
	.db #0x10	; 16
	.db #0x0b	; 11
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_050
	.db #0x10	; 16
	.db #0x0d	; 13
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_051
	.db #0x10	; 16
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_052
	.db #0x10	; 16
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_053
	.db #0x10	; 16
	.db #0x11	; 17
	.db #0x00	; 0
	.db #0x65	; 101	'e'
	.dw _scene_map_054
	.db #0x10	; 16
	.db #0x12	; 18
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_055
	.db #0x10	; 16
	.db #0x16	; 22
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_056
	.db #0x10	; 16
	.db #0x17	; 23
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_057
	.db #0x10	; 16
	.db #0x19	; 25
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_058
	.db #0x10	; 16
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_059
	.db #0x10	; 16
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_060
	.db #0x11	; 17
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_061
	.db #0x11	; 17
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_062
	.db #0x11	; 17
	.db #0x1a	; 26
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_063
	.db #0x11	; 17
	.db #0x1d	; 29
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_064
	.db #0x11	; 17
	.db #0x1e	; 30
	.db #0x00	; 0
	.db #0x66	; 102	'f'
	.dw _scene_map_065
	.db #0x11	; 17
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_066
	.db #0x11	; 17
	.db #0x25	; 37
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_067
	.db #0x11	; 17
	.db #0x26	; 38
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_068
	.db #0x11	; 17
	.db #0x27	; 39
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_069
	.db #0x11	; 17
	.db #0x29	; 41
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_070
	.db #0x11	; 17
	.db #0x2a	; 42
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_071
	.db #0x11	; 17
	.db #0x2b	; 43
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_072
	.db #0x11	; 17
	.db #0x2d	; 45
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_073
	.db #0x11	; 17
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_074
	.db #0x11	; 17
	.db #0x34	; 52	'4'
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_075
	.db #0x11	; 17
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x67	; 103	'g'
	.dw _scene_map_076
	.db #0x12	; 18
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_077
	.db #0x12	; 18
	.db #0x04	; 4
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_078
	.db #0x12	; 18
	.db #0x08	; 8
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_079
	.db #0x12	; 18
	.db #0x0c	; 12
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_080
	.db #0x13	; 19
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_081
	.db #0x13	; 19
	.db #0x1b	; 27
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_082
	.db #0x13	; 19
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_083
	.db #0x13	; 19
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_084
	.db #0x13	; 19
	.db #0x2c	; 44
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_085
	.db #0x13	; 19
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_086
	.db #0x14	; 20
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x68	; 104	'h'
	.dw _scene_map_087
	.db #0x14	; 20
	.db #0x39	; 57	'9'
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_088
	.db #0x15	; 21
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_089
	.db #0x15	; 21
	.db #0x39	; 57	'9'
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_090
	.db #0x15	; 21
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_091
	.db #0x16	; 22
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_092
	.db #0x16	; 22
	.db #0x0d	; 13
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_093
	.db #0x16	; 22
	.db #0x11	; 17
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_094
	.db #0x16	; 22
	.db #0x15	; 21
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_095
	.db #0x17	; 23
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_096
	.db #0x17	; 23
	.db #0x25	; 37
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_097
	.db #0x17	; 23
	.db #0x29	; 41
	.db #0x00	; 0
	.db #0x69	; 105	'i'
	.dw _scene_map_098
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_099
	.db #0x18	; 24
	.db #0x03	; 3
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_100
	.db #0x18	; 24
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_101
	.db #0x18	; 24
	.db #0x15	; 21
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_102
	.db #0x19	; 25
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_103
	.db #0x19	; 25
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_104
	.db #0x19	; 25
	.db #0x27	; 39
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_105
	.db #0x1a	; 26
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_106
	.db #0x1a	; 26
	.db #0x0e	; 14
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_107
	.db #0x1a	; 26
	.db #0x11	; 17
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_108
	.db #0x1a	; 26
	.db #0x17	; 23
	.db #0x00	; 0
	.db #0x6a	; 106	'j'
	.dw _scene_map_109
	.db #0x1b	; 27
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_110
	.db #0x1b	; 27
	.db #0x25	; 37
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_111
	.db #0x1b	; 27
	.db #0x26	; 38
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_112
	.db #0x1b	; 27
	.db #0x29	; 41
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_113
	.db #0x1b	; 27
	.db #0x2a	; 42
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_114
	.db #0x1b	; 27
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_115
	.db #0x1c	; 28
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_116
	.db #0x1c	; 28
	.db #0x33	; 51	'3'
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_117
	.db #0x1c	; 28
	.db #0x36	; 54	'6'
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_118
	.db #0x1d	; 29
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_119
	.db #0x1d	; 29
	.db #0x35	; 53	'5'
	.db #0x00	; 0
	.db #0x6b	; 107	'k'
	.dw _scene_map_120
	.db #0x1e	; 30
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.dw _scene_map_121
	.db #0x1e	; 30
	.db #0x00	; 0
	.db #0x48	; 72	'H'
	.db #0x6c	; 108	'l'
	.dw _scene_map_122
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.dw _scene_map_123
	.db #0x1f	; 31
	.db #0x00	; 0
	.db #0x49	; 73	'I'
	.db #0x6c	; 108	'l'
	.dw _scene_map_124
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.dw _scene_map_125
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x49	; 73	'I'
	.db #0x6c	; 108	'l'
	.dw _scene_map_126
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x4a	; 74	'J'
	.db #0x6c	; 108	'l'
	.dw _scene_map_127
	.db #0x40	; 64
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.dw _scene_map_128
	.db #0x40	; 64
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.dw _scene_map_129
	.db #0x40	; 64
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.dw _scene_map_130
	.db #0x40	; 64
	.db #0x17	; 23
	.db #0x00	; 0
	.db #0x6c	; 108	'l'
	.dw _scene_map_131
	.db #0x40	; 64
	.db #0x1b	; 27
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_132
	.db #0x40	; 64
	.db #0x1d	; 29
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_133
	.db #0x40	; 64
	.db #0x2f	; 47
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_134
	.db #0x40	; 64
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_135
	.db #0x40	; 64
	.db #0x33	; 51	'3'
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_136
	.db #0x40	; 64
	.db #0x34	; 52	'4'
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_137
	.db #0x40	; 64
	.db #0x3b	; 59
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_138
	.db #0x40	; 64
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_139
	.db #0x40	; 64
	.db #0x3d	; 61
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_140
	.db #0x41	; 65	'A'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_141
	.db #0x41	; 65	'A'
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_142
	.db #0x42	; 66	'B'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6d	; 109	'm'
	.dw _scene_map_143
	.db #0x42	; 66	'B'
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_144
	.db #0x43	; 67	'C'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_145
	.db #0x43	; 67	'C'
	.db #0x0f	; 15
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_146
	.db #0x43	; 67	'C'
	.db #0x17	; 23
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_147
	.db #0x43	; 67	'C'
	.db #0x1b	; 27
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_148
	.db #0x43	; 67	'C'
	.db #0x32	; 50	'2'
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_149
	.db #0x43	; 67	'C'
	.db #0x33	; 51	'3'
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_150
	.db #0x43	; 67	'C'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_151
	.db #0x44	; 68	'D'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_152
	.db #0x44	; 68	'D'
	.db #0x10	; 16
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_153
	.db #0x44	; 68	'D'
	.db #0x2f	; 47
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_154
	.db #0x44	; 68	'D'
	.db #0x33	; 51	'3'
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_155
	.db #0x45	; 69	'E'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_156
	.db #0x45	; 69	'E'
	.db #0x33	; 51	'3'
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_157
	.db #0x45	; 69	'E'
	.db #0x34	; 52	'4'
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_158
	.db #0x46	; 70	'F'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_159
	.db #0x47	; 71	'G'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_160
	.db #0x47	; 71	'G'
	.db #0x3b	; 59
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_161
	.db #0x48	; 72	'H'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_162
	.db #0x48	; 72	'H'
	.db #0x3c	; 60
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_163
	.db #0x48	; 72	'H'
	.db #0x3d	; 61
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_164
	.db #0x49	; 73	'I'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_165
	.db #0x4a	; 74	'J'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x6e	; 110	'n'
	.dw _scene_map_166
	.db #0x4a	; 74	'J'
	.db #0x1d	; 29
	.db #0x00	; 0
	.db #0xc0	; 192
	.dw _scene_map_167
	.db #0x4b	; 75	'K'
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xc0	; 192
	.dw _scene_map_168
_scene_pattern_pools:
	.db #0x61	; 97	'a'
	.dw _scene_patterns_00
	.db #0x62	; 98	'b'
	.dw _scene_patterns_01
	.db #0x63	; 99	'c'
	.dw _scene_patterns_02
	.db #0x64	; 100	'd'
	.dw _scene_patterns_03
	.db #0x65	; 101	'e'
	.dw _scene_patterns_04
	.db #0x66	; 102	'f'
	.dw _scene_patterns_05
	.db #0x67	; 103	'g'
	.dw _scene_patterns_06
	.db #0x68	; 104	'h'
	.dw _scene_patterns_07
	.db #0x69	; 105	'i'
	.dw _scene_patterns_08
	.db #0x6a	; 106	'j'
	.dw _scene_patterns_09
	.db #0x6b	; 107	'k'
	.dw _scene_patterns_10
	.db #0x6c	; 108	'l'
	.dw _scene_patterns_11
	.db #0x6d	; 109	'm'
	.dw _scene_patterns_12
	.area _INITIALIZER
	.area _CABS (ABS)
