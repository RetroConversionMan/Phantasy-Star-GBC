;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module scene_actor_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _scene_actors
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
_scene_actors:
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_000
	.db #0x00	; 0
	.db #0x02	; 2
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_001
	.db #0x00	; 0
	.db #0x03	; 3
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_002
	.db #0x00	; 0
	.db #0x04	; 4
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_003
	.db #0x00	; 0
	.db #0x05	; 5
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_004
	.db #0x00	; 0
	.db #0x06	; 6
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_005
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_006
	.db #0x00	; 0
	.db #0x08	; 8
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_007
	.db #0x00	; 0
	.db #0x09	; 9
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_008
	.db #0x00	; 0
	.db #0x0a	; 10
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_009
	.db #0x00	; 0
	.db #0x0b	; 11
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_010
	.db #0x00	; 0
	.db #0x0c	; 12
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_011
	.db #0x00	; 0
	.db #0x0d	; 13
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_012
	.db #0x00	; 0
	.db #0x0e	; 14
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_013
	.db #0x00	; 0
	.db #0x0f	; 15
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_014
	.db #0x00	; 0
	.db #0x10	; 16
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_015
	.db #0x00	; 0
	.db #0x11	; 17
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_016
	.db #0x00	; 0
	.db #0x12	; 18
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_017
	.db #0x00	; 0
	.db #0x13	; 19
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_018
	.db #0x00	; 0
	.db #0x14	; 20
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_019
	.db #0x00	; 0
	.db #0x15	; 21
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_020
	.db #0x00	; 0
	.db #0x16	; 22
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_021
	.db #0x00	; 0
	.db #0x17	; 23
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_022
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x13	; 19
	.db #0x14	; 20
	.dw _scene_actor_023
	.db #0x00	; 0
	.db #0x19	; 25
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_024
	.db #0x00	; 0
	.db #0x1a	; 26
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_025
	.db #0x00	; 0
	.db #0x1b	; 27
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_026
	.db #0x00	; 0
	.db #0x1c	; 28
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_027
	.db #0x00	; 0
	.db #0x1d	; 29
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_028
	.db #0x00	; 0
	.db #0x1e	; 30
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_029
	.db #0x00	; 0
	.db #0x1f	; 31
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_030
	.db #0x00	; 0
	.db #0x20	; 32
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_031
	.db #0x00	; 0
	.db #0x21	; 33
	.db #0xff	; 255
	.db #0x6f	; 111	'o'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_032
	.db #0x00	; 0
	.db #0x22	; 34
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_033
	.db #0x00	; 0
	.db #0x23	; 35
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_034
	.db #0x00	; 0
	.db #0x24	; 36
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_035
	.db #0x00	; 0
	.db #0x25	; 37
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_036
	.db #0x00	; 0
	.db #0x26	; 38
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_037
	.db #0x00	; 0
	.db #0x27	; 39
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_038
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_039
	.db #0x00	; 0
	.db #0x29	; 41
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_040
	.db #0x00	; 0
	.db #0x2a	; 42
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_041
	.db #0x00	; 0
	.db #0x2b	; 43
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_042
	.db #0x00	; 0
	.db #0x2c	; 44
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_043
	.db #0x00	; 0
	.db #0x2d	; 45
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_044
	.db #0x00	; 0
	.db #0x2e	; 46
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_045
	.db #0x00	; 0
	.db #0x2f	; 47
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_046
	.db #0x00	; 0
	.db #0x30	; 48	'0'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x18	; 24
	.db #0x19	; 25
	.dw _scene_actor_047
	.db #0x00	; 0
	.db #0x31	; 49	'1'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x1b	; 27
	.db #0x1c	; 28
	.dw _scene_actor_048
	.db #0x00	; 0
	.db #0x32	; 50	'2'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x12	; 18
	.db #0x12	; 18
	.dw _scene_actor_049
	.db #0x00	; 0
	.db #0x33	; 51	'3'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x11	; 17
	.db #0x11	; 17
	.dw _scene_actor_050
	.db #0x00	; 0
	.db #0x34	; 52	'4'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x1d	; 29
	.db #0x1e	; 30
	.dw _scene_actor_051
	.db #0x00	; 0
	.db #0x35	; 53	'5'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x1b	; 27
	.db #0x1b	; 27
	.dw _scene_actor_052
	.db #0x00	; 0
	.db #0x36	; 54	'6'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x1a	; 26
	.db #0x1b	; 27
	.dw _scene_actor_053
	.db #0x00	; 0
	.db #0x37	; 55	'7'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x16	; 22
	.db #0x16	; 22
	.dw _scene_actor_054
	.db #0x00	; 0
	.db #0x38	; 56	'8'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x1b	; 27
	.db #0x1b	; 27
	.dw _scene_actor_055
	.db #0x00	; 0
	.db #0x39	; 57	'9'
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x11	; 17
	.db #0x1c	; 28
	.dw _scene_actor_056
	.db #0x00	; 0
	.db #0x3a	; 58
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x1e	; 30
	.db #0x1f	; 31
	.dw _scene_actor_057
	.db #0x00	; 0
	.db #0x3b	; 59
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x1a	; 26
	.db #0x1a	; 26
	.dw _scene_actor_058
	.db #0x00	; 0
	.db #0x3c	; 60
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x10	; 16
	.db #0x10	; 16
	.dw _scene_actor_059
	.db #0x00	; 0
	.db #0x3d	; 61
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x10	; 16
	.db #0x10	; 16
	.dw _scene_actor_060
	.db #0x01	; 1
	.db #0x08	; 8
	.db #0xff	; 255
	.db #0x70	; 112	'p'
	.db #0x15	; 21
	.db #0x15	; 21
	.dw _scene_actor_061
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x00	; 0
	.db #0x71	; 113	'q'
	.db #0x1d	; 29
	.db #0x20	; 32
	.dw _scene_actor_062
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x01	; 1
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_063
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x02	; 2
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_064
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x03	; 3
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_065
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x04	; 4
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_066
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x05	; 5
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_067
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x06	; 6
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_068
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x07	; 7
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_069
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x08	; 8
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_070
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x09	; 9
	.db #0x71	; 113	'q'
	.db #0x1d	; 29
	.db #0x20	; 32
	.dw _scene_actor_071
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x0a	; 10
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_072
	.db #0x01	; 1
	.db #0x16	; 22
	.db #0x0b	; 11
	.db #0x71	; 113	'q'
	.db #0x20	; 32
	.db #0x20	; 32
	.dw _scene_actor_073
	.db #0x01	; 1
	.db #0x1b	; 27
	.db #0xff	; 255
	.db #0x71	; 113	'q'
	.db #0x10	; 16
	.db #0x10	; 16
	.dw _scene_actor_074
	.db #0x01	; 1
	.db #0x2b	; 43
	.db #0xff	; 255
	.db #0x71	; 113	'q'
	.db #0x10	; 16
	.db #0x10	; 16
	.dw _scene_actor_075
	.db #0x01	; 1
	.db #0x2e	; 46
	.db #0xff	; 255
	.db #0x71	; 113	'q'
	.db #0x1a	; 26
	.db #0x1a	; 26
	.dw _scene_actor_076
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x00	; 0
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_077
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x01	; 1
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_078
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x02	; 2
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_079
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x03	; 3
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_080
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x04	; 4
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_081
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x05	; 5
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_082
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x06	; 6
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_083
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x07	; 7
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_084
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x08	; 8
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_085
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x09	; 9
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_086
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x0a	; 10
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_087
	.db #0x01	; 1
	.db #0x31	; 49	'1'
	.db #0x0b	; 11
	.db #0x71	; 113	'q'
	.db #0x14	; 20
	.db #0x14	; 20
	.dw _scene_actor_088
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x1a	; 26
	.db #0x1c	; 28
	.dw _scene_actor_089
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x01	; 1
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_090
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x02	; 2
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_091
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x03	; 3
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_092
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x04	; 4
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_093
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x05	; 5
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_094
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x06	; 6
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_095
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x07	; 7
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_096
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x08	; 8
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_097
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x09	; 9
	.db #0x72	; 114	'r'
	.db #0x1a	; 26
	.db #0x1c	; 28
	.dw _scene_actor_098
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x0a	; 10
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_099
	.db #0x01	; 1
	.db #0x3e	; 62
	.db #0x0b	; 11
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_100
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x00	; 0
	.db #0x72	; 114	'r'
	.db #0x1a	; 26
	.db #0x1c	; 28
	.dw _scene_actor_101
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x01	; 1
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_102
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x02	; 2
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_103
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x03	; 3
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_104
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x04	; 4
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_105
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x05	; 5
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_106
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x06	; 6
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_107
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x07	; 7
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_108
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x08	; 8
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_109
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x09	; 9
	.db #0x72	; 114	'r'
	.db #0x1a	; 26
	.db #0x1c	; 28
	.dw _scene_actor_110
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x0a	; 10
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_111
	.db #0x01	; 1
	.db #0x47	; 71	'G'
	.db #0x0b	; 11
	.db #0x72	; 114	'r'
	.db #0x1c	; 28
	.db #0x1c	; 28
	.dw _scene_actor_112
	.area _INITIALIZER
	.area _CABS (ABS)
