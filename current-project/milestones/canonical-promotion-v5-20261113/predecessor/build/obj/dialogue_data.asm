;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module dialogue_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _dialogue_items
	.globl _dialogue_ref_count
	.globl _dialogue_refs
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
	.area _CODE_8
	.area _CODE_8
_dialogue_refs:
	.dw #0x0002
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 0)
	.dw #0x00a5
	.db #0x65	; 101	'e'
	.dw #0x0004
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 165)
	.dw #0x003f
	.db #0x65	; 101	'e'
	.dw #0x0006
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 228)
	.dw #0x0038
	.db #0x65	; 101	'e'
	.dw #0x0008
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 284)
	.dw #0x00cd
	.db #0x65	; 101	'e'
	.dw #0x000a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 489)
	.dw #0x00af
	.db #0x65	; 101	'e'
	.dw #0x000c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 664)
	.dw #0x0057
	.db #0x65	; 101	'e'
	.dw #0x000e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 751)
	.dw #0x0035
	.db #0x65	; 101	'e'
	.dw #0x0010
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 804)
	.dw #0x0037
	.db #0x65	; 101	'e'
	.dw #0x0012
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 859)
	.dw #0x0034
	.db #0x65	; 101	'e'
	.dw #0x0014
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 911)
	.dw #0x002d
	.db #0x65	; 101	'e'
	.dw #0x0016
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 956)
	.dw #0x0042
	.db #0x65	; 101	'e'
	.dw #0x0018
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1022)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0x001a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1069)
	.dw #0x0040
	.db #0x65	; 101	'e'
	.dw #0x001c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1133)
	.dw #0x0030
	.db #0x65	; 101	'e'
	.dw #0x001e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1181)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0x0020
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1228)
	.dw #0x0012
	.db #0x65	; 101	'e'
	.dw #0x0022
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1246)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x0024
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1280)
	.dw #0x0011
	.db #0x65	; 101	'e'
	.dw #0x0026
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1297)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x0028
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1331)
	.dw #0x0021
	.db #0x65	; 101	'e'
	.dw #0x002a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1364)
	.dw #0x0067
	.db #0x65	; 101	'e'
	.dw #0x002c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1467)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x002e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1501)
	.dw #0x002b
	.db #0x65	; 101	'e'
	.dw #0x0030
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1544)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0x0032
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1595)
	.dw #0x0059
	.db #0x65	; 101	'e'
	.dw #0x0034
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1684)
	.dw #0x00a2
	.db #0x65	; 101	'e'
	.dw #0x0036
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1846)
	.dw #0x0082
	.db #0x65	; 101	'e'
	.dw #0x0038
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 1976)
	.dw #0x0043
	.db #0x65	; 101	'e'
	.dw #0x003a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2043)
	.dw #0x003b
	.db #0x65	; 101	'e'
	.dw #0x003c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2102)
	.dw #0x0077
	.db #0x65	; 101	'e'
	.dw #0x003e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2221)
	.dw #0x0037
	.db #0x65	; 101	'e'
	.dw #0x0040
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2276)
	.dw #0x003f
	.db #0x65	; 101	'e'
	.dw #0x0042
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2339)
	.dw #0x0046
	.db #0x65	; 101	'e'
	.dw #0x0044
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2409)
	.dw #0x003c
	.db #0x65	; 101	'e'
	.dw #0x0046
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2469)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0x0048
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2520)
	.dw #0x0037
	.db #0x65	; 101	'e'
	.dw #0x004a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2575)
	.dw #0x005d
	.db #0x65	; 101	'e'
	.dw #0x004c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2668)
	.dw #0x003c
	.db #0x65	; 101	'e'
	.dw #0x004e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2728)
	.dw #0x0036
	.db #0x65	; 101	'e'
	.dw #0x0050
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2782)
	.dw #0x0017
	.db #0x65	; 101	'e'
	.dw #0x0052
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2805)
	.dw #0x0046
	.db #0x65	; 101	'e'
	.dw #0x0054
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2875)
	.dw #0x0011
	.db #0x65	; 101	'e'
	.dw #0x0056
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2892)
	.dw #0x0023
	.db #0x62	; 98	'b'
	.dw #0x0058
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 2927)
	.dw #0x004f
	.db #0x65	; 101	'e'
	.dw #0x005a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3006)
	.dw #0x002e
	.db #0x65	; 101	'e'
	.dw #0x005c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3052)
	.dw #0x0041
	.db #0x62	; 98	'b'
	.dw #0x005e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3117)
	.dw #0x003c
	.db #0x65	; 101	'e'
	.dw #0x0060
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3177)
	.dw #0x000f
	.db #0x65	; 101	'e'
	.dw #0x0062
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3192)
	.dw #0x0038
	.db #0x62	; 98	'b'
	.dw #0x0064
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3248)
	.dw #0x00c1
	.db #0x65	; 101	'e'
	.dw #0x0066
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3441)
	.dw #0x008d
	.db #0x65	; 101	'e'
	.dw #0x0068
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3582)
	.dw #0x003b
	.db #0x65	; 101	'e'
	.dw #0x006a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3641)
	.dw #0x004e
	.db #0x65	; 101	'e'
	.dw #0x006c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3719)
	.dw #0x0032
	.db #0x65	; 101	'e'
	.dw #0x006e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3769)
	.dw #0x003b
	.db #0x65	; 101	'e'
	.dw #0x0070
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3828)
	.dw #0x001c
	.db #0x62	; 98	'b'
	.dw #0x0072
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3856)
	.dw #0x003a
	.db #0x62	; 98	'b'
	.dw #0x0074
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3914)
	.dw #0x0026
	.db #0x62	; 98	'b'
	.dw #0x0076
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3952)
	.dw #0x0022
	.db #0x62	; 98	'b'
	.dw #0x0078
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 3986)
	.dw #0x0033
	.db #0x62	; 98	'b'
	.dw #0x007a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4037)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0x007c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4067)
	.dw #0x0017
	.db #0x65	; 101	'e'
	.dw #0x007e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4090)
	.dw #0x0031
	.db #0x65	; 101	'e'
	.dw #0x0080
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4139)
	.dw #0x002c
	.db #0x65	; 101	'e'
	.dw #0x0082
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4183)
	.dw #0x002e
	.db #0x65	; 101	'e'
	.dw #0x0084
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4229)
	.dw #0x0038
	.db #0x65	; 101	'e'
	.dw #0x0086
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4285)
	.dw #0x0040
	.db #0x65	; 101	'e'
	.dw #0x0088
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4349)
	.dw #0x0032
	.db #0x65	; 101	'e'
	.dw #0x008a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4399)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x008c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4433)
	.dw #0x0044
	.db #0x65	; 101	'e'
	.dw #0x008e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4501)
	.dw #0x0021
	.db #0x65	; 101	'e'
	.dw #0x0090
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4534)
	.dw #0x0034
	.db #0x65	; 101	'e'
	.dw #0x0092
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4586)
	.dw #0x0044
	.db #0x62	; 98	'b'
	.dw #0x0094
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4654)
	.dw #0x0010
	.db #0x65	; 101	'e'
	.dw #0x0096
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4670)
	.dw #0x0040
	.db #0x62	; 98	'b'
	.dw #0x0098
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4734)
	.dw #0x0022
	.db #0x62	; 98	'b'
	.dw #0x009a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4768)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x009c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4802)
	.dw #0x002f
	.db #0x62	; 98	'b'
	.dw #0x009e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4849)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0x00a0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4879)
	.dw #0x002c
	.db #0x65	; 101	'e'
	.dw #0x00a2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4923)
	.dw #0x001b
	.db #0x65	; 101	'e'
	.dw #0x00a4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 4950)
	.dw #0x010a
	.db #0x65	; 101	'e'
	.dw #0x00a6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5216)
	.dw #0x00c7
	.db #0x65	; 101	'e'
	.dw #0x00a8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5415)
	.dw #0x0085
	.db #0x65	; 101	'e'
	.dw #0x00aa
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5548)
	.dw #0x0043
	.db #0x65	; 101	'e'
	.dw #0x00ac
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5615)
	.dw #0x0041
	.db #0x65	; 101	'e'
	.dw #0x00ae
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5680)
	.dw #0x0042
	.db #0x65	; 101	'e'
	.dw #0x00b0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5746)
	.dw #0x0024
	.db #0x65	; 101	'e'
	.dw #0x00b2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5782)
	.dw #0x0007
	.db #0x65	; 101	'e'
	.dw #0x00b4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5789)
	.dw #0x000d
	.db #0x65	; 101	'e'
	.dw #0x00b6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5802)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0x00b8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5833)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0x00ba
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5863)
	.dw #0x0021
	.db #0x62	; 98	'b'
	.dw #0x00bc
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 5896)
	.dw #0x0077
	.db #0x65	; 101	'e'
	.dw #0x00be
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6015)
	.dw #0x0055
	.db #0x65	; 101	'e'
	.dw #0x00c0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6100)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0x00c2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6151)
	.dw #0x0024
	.db #0x65	; 101	'e'
	.dw #0x00c4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6187)
	.dw #0x00af
	.db #0x65	; 101	'e'
	.dw #0x00c6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6362)
	.dw #0x008b
	.db #0x65	; 101	'e'
	.dw #0x00c8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6501)
	.dw #0x0046
	.db #0x65	; 101	'e'
	.dw #0x00ca
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6571)
	.dw #0x0059
	.db #0x65	; 101	'e'
	.dw #0x00cc
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6660)
	.dw #0x0039
	.db #0x65	; 101	'e'
	.dw #0x00ce
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6717)
	.dw #0x0011
	.db #0x65	; 101	'e'
	.dw #0x00d0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6734)
	.dw #0x0045
	.db #0x65	; 101	'e'
	.dw #0x00d2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6803)
	.dw #0x0031
	.db #0x65	; 101	'e'
	.dw #0x00d4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6852)
	.dw #0x0025
	.db #0x65	; 101	'e'
	.dw #0x00d6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6889)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0x00d8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6921)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0x00da
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6952)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0x00dc
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 6999)
	.dw #0x001a
	.db #0x65	; 101	'e'
	.dw #0x00de
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7025)
	.dw #0x0043
	.db #0x65	; 101	'e'
	.dw #0x00e0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7092)
	.dw #0x005d
	.db #0x65	; 101	'e'
	.dw #0x00e2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7185)
	.dw #0x005d
	.db #0x62	; 98	'b'
	.dw #0x00e4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7278)
	.dw #0x0062
	.db #0x65	; 101	'e'
	.dw #0x00e6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7376)
	.dw #0x001c
	.db #0x62	; 98	'b'
	.dw #0x00e8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7404)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0x00ea
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7434)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0x00ec
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7481)
	.dw #0x001f
	.db #0x62	; 98	'b'
	.dw #0x00ee
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7512)
	.dw #0x005b
	.db #0x65	; 101	'e'
	.dw #0x00f0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7603)
	.dw #0x0042
	.db #0x65	; 101	'e'
	.dw #0x00f2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7669)
	.dw #0x003e
	.db #0x62	; 98	'b'
	.dw #0x00f4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7731)
	.dw #0x003c
	.db #0x65	; 101	'e'
	.dw #0x00f6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7791)
	.dw #0x005b
	.db #0x65	; 101	'e'
	.dw #0x00f8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7882)
	.dw #0x0054
	.db #0x65	; 101	'e'
	.dw #0x00fa
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 7966)
	.dw #0x0067
	.db #0x65	; 101	'e'
	.dw #0x00fc
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8069)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x00fe
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8103)
	.dw #0x0021
	.db #0x65	; 101	'e'
	.dw #0x0100
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8136)
	.dw #0x0024
	.db #0x65	; 101	'e'
	.dw #0x0102
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8172)
	.dw #0x0038
	.db #0x65	; 101	'e'
	.dw #0x0104
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8228)
	.dw #0x003c
	.db #0x65	; 101	'e'
	.dw #0x0106
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8288)
	.dw #0x0063
	.db #0x65	; 101	'e'
	.dw #0x0108
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8387)
	.dw #0x0042
	.db #0x65	; 101	'e'
	.dw #0x010a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8453)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x010c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8487)
	.dw #0x0050
	.db #0x65	; 101	'e'
	.dw #0x010e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8567)
	.dw #0x0054
	.db #0x65	; 101	'e'
	.dw #0x0110
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8651)
	.dw #0x0023
	.db #0x65	; 101	'e'
	.dw #0x0112
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8686)
	.dw #0x0043
	.db #0x65	; 101	'e'
	.dw #0x0114
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8753)
	.dw #0x0020
	.db #0x62	; 98	'b'
	.dw #0x0116
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8785)
	.dw #0x003b
	.db #0x65	; 101	'e'
	.dw #0x0118
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8844)
	.dw #0x0075
	.db #0x65	; 101	'e'
	.dw #0x011a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 8961)
	.dw #0x003b
	.db #0x65	; 101	'e'
	.dw #0x011c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9020)
	.dw #0x0012
	.db #0x65	; 101	'e'
	.dw #0x011e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9038)
	.dw #0x0024
	.db #0x65	; 101	'e'
	.dw #0x0120
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9074)
	.dw #0x0073
	.db #0x65	; 101	'e'
	.dw #0x0122
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9189)
	.dw #0x0032
	.db #0x65	; 101	'e'
	.dw #0x0124
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9239)
	.dw #0x0054
	.db #0x65	; 101	'e'
	.dw #0x0126
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9323)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x0128
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9357)
	.dw #0x0061
	.db #0x65	; 101	'e'
	.dw #0x012a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9454)
	.dw #0x0018
	.db #0x65	; 101	'e'
	.dw #0x012c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9478)
	.dw #0x0042
	.db #0x65	; 101	'e'
	.dw #0x012e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9544)
	.dw #0x0019
	.db #0x65	; 101	'e'
	.dw #0x0130
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9569)
	.dw #0x0058
	.db #0x65	; 101	'e'
	.dw #0x0132
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9657)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0x0134
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9708)
	.dw #0x0055
	.db #0x65	; 101	'e'
	.dw #0x0136
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9793)
	.dw #0x0061
	.db #0x65	; 101	'e'
	.dw #0x0138
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9890)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0x013a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9937)
	.dw #0x002a
	.db #0x62	; 98	'b'
	.dw #0x013c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9979)
	.dw #0x0010
	.db #0x65	; 101	'e'
	.dw #0x013e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 9995)
	.dw #0x0063
	.db #0x65	; 101	'e'
	.dw #0x0140
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10094)
	.dw #0x001d
	.db #0x65	; 101	'e'
	.dw #0x0142
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10123)
	.dw #0x0038
	.db #0x65	; 101	'e'
	.dw #0x0144
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10179)
	.dw #0x0040
	.db #0x65	; 101	'e'
	.dw #0x0146
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10243)
	.dw #0x0052
	.db #0x65	; 101	'e'
	.dw #0x0148
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10325)
	.dw #0x0043
	.db #0x62	; 98	'b'
	.dw #0x014a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10392)
	.dw #0x0021
	.db #0x62	; 98	'b'
	.dw #0x014c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10425)
	.dw #0x0067
	.db #0x65	; 101	'e'
	.dw #0x014e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10528)
	.dw #0x0006
	.db #0x65	; 101	'e'
	.dw #0x0150
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10534)
	.dw #0x0020
	.db #0x62	; 98	'b'
	.dw #0x0152
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10566)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0x0154
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10594)
	.dw #0x0023
	.db #0x62	; 98	'b'
	.dw #0x0156
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10629)
	.dw #0x0021
	.db #0x62	; 98	'b'
	.dw #0x0158
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10662)
	.dw #0x001b
	.db #0x65	; 101	'e'
	.dw #0x015a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10689)
	.dw #0x0025
	.db #0x62	; 98	'b'
	.dw #0x015c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10726)
	.dw #0x005b
	.db #0x65	; 101	'e'
	.dw #0x015e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10817)
	.dw #0x0027
	.db #0x65	; 101	'e'
	.dw #0x0160
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10856)
	.dw #0x003a
	.db #0x62	; 98	'b'
	.dw #0x0162
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10914)
	.dw #0x0030
	.db #0x65	; 101	'e'
	.dw #0x0164
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10962)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0x0166
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 10993)
	.dw #0x001b
	.db #0x65	; 101	'e'
	.dw #0x0168
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11020)
	.dw #0x0042
	.db #0x65	; 101	'e'
	.dw #0x016a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11086)
	.dw #0x003c
	.db #0x65	; 101	'e'
	.dw #0x016c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11146)
	.dw #0x0084
	.db #0x65	; 101	'e'
	.dw #0x016e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11278)
	.dw #0x003f
	.db #0x65	; 101	'e'
	.dw #0x0170
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11341)
	.dw #0x0060
	.db #0x65	; 101	'e'
	.dw #0x0172
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11437)
	.dw #0x0031
	.db #0x62	; 98	'b'
	.dw #0x0174
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11486)
	.dw #0x0077
	.db #0x65	; 101	'e'
	.dw #0x0176
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11605)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0x0178
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11652)
	.dw #0x0043
	.db #0x65	; 101	'e'
	.dw #0x017a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11719)
	.dw #0x000f
	.db #0x65	; 101	'e'
	.dw #0x017c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11734)
	.dw #0x0032
	.db #0x65	; 101	'e'
	.dw #0x017e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11784)
	.dw #0x0030
	.db #0x65	; 101	'e'
	.dw #0x0180
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11832)
	.dw #0x005b
	.db #0x65	; 101	'e'
	.dw #0x0182
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11923)
	.dw #0x002a
	.db #0x65	; 101	'e'
	.dw #0x0184
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 11965)
	.dw #0x0039
	.db #0x65	; 101	'e'
	.dw #0x0186
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12022)
	.dw #0x0034
	.db #0x65	; 101	'e'
	.dw #0x0188
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12074)
	.dw #0x005f
	.db #0x65	; 101	'e'
	.dw #0x018a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12169)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0x018c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12197)
	.dw #0x005a
	.db #0x65	; 101	'e'
	.dw #0x018e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12287)
	.dw #0x000d
	.db #0x65	; 101	'e'
	.dw #0x0190
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12300)
	.dw #0x0074
	.db #0x65	; 101	'e'
	.dw #0x0192
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12416)
	.dw #0x0044
	.db #0x65	; 101	'e'
	.dw #0x0194
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12484)
	.dw #0x0084
	.db #0x62	; 98	'b'
	.dw #0x0196
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12616)
	.dw #0x0047
	.db #0x62	; 98	'b'
	.dw #0x0198
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12687)
	.dw #0x0018
	.db #0x65	; 101	'e'
	.dw #0x019a
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12711)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0x019c
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12741)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x019e
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12775)
	.dw #0x0019
	.db #0x65	; 101	'e'
	.dw #0x01a0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12800)
	.dw #0x0025
	.db #0x65	; 101	'e'
	.dw #0x01a2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12837)
	.dw #0x003e
	.db #0x65	; 101	'e'
	.dw #0x01a4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12899)
	.dw #0x0027
	.db #0x65	; 101	'e'
	.dw #0x01a6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 12938)
	.dw #0x0083
	.db #0x65	; 101	'e'
	.dw #0x01a8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13069)
	.dw #0x005e
	.db #0x65	; 101	'e'
	.dw #0x01aa
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13163)
	.dw #0x0097
	.db #0x65	; 101	'e'
	.dw #0x01ac
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13314)
	.dw #0x0075
	.db #0x65	; 101	'e'
	.dw #0x01ae
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13431)
	.dw #0x0036
	.db #0x65	; 101	'e'
	.dw #0x01b0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13485)
	.dw #0x0019
	.db #0x65	; 101	'e'
	.dw #0x01b2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13510)
	.dw #0x009a
	.db #0x65	; 101	'e'
	.dw #0x01b4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13664)
	.dw #0x006b
	.db #0x65	; 101	'e'
	.dw #0x01b6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13771)
	.dw #0x002d
	.db #0x65	; 101	'e'
	.dw #0x01b8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13816)
	.dw #0x001b
	.db #0x65	; 101	'e'
	.dw #0x01ba
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13843)
	.dw #0x0059
	.db #0x65	; 101	'e'
	.dw #0x01bc
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13932)
	.dw #0x003a
	.db #0x65	; 101	'e'
	.dw #0x01be
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 13990)
	.dw #0x009f
	.db #0x65	; 101	'e'
	.dw #0x01c0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14149)
	.dw #0x005d
	.db #0x65	; 101	'e'
	.dw #0x01c2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14242)
	.dw #0x002b
	.db #0x65	; 101	'e'
	.dw #0x01c4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14285)
	.dw #0x0041
	.db #0x65	; 101	'e'
	.dw #0x01c6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14350)
	.dw #0x0011
	.db #0x65	; 101	'e'
	.dw #0x01c8
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14367)
	.dw #0x003b
	.db #0x65	; 101	'e'
	.dw #0x01ca
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14426)
	.dw #0x0051
	.db #0x65	; 101	'e'
	.dw #0x01cc
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14507)
	.dw #0x0064
	.db #0x65	; 101	'e'
	.dw #0x01ce
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14607)
	.dw #0x0032
	.db #0x65	; 101	'e'
	.dw #0x01d0
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14657)
	.dw #0x009a
	.db #0x65	; 101	'e'
	.dw #0x01d2
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14811)
	.dw #0x0075
	.db #0x65	; 101	'e'
	.dw #0x01d4
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14928)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x01d6
	.db #0x09	; 9
	.dw (_dialogue_text_09 + 14962)
	.dw #0x0022
	.db #0x62	; 98	'b'
	.dw #0x01d8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 0)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0x01da
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 31)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0x01dc
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 61)
	.dw #0x001d
	.db #0x65	; 101	'e'
	.dw #0x01de
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 90)
	.dw #0x003f
	.db #0x65	; 101	'e'
	.dw #0x01e0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 153)
	.dw #0x0044
	.db #0x65	; 101	'e'
	.dw #0x01e2
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 221)
	.dw #0x0049
	.db #0x65	; 101	'e'
	.dw #0x01e4
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 294)
	.dw #0x005f
	.db #0x65	; 101	'e'
	.dw #0x01e6
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 389)
	.dw #0x0032
	.db #0x65	; 101	'e'
	.dw #0x01e8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 439)
	.dw #0x003f
	.db #0x65	; 101	'e'
	.dw #0x01ea
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 502)
	.dw #0x0096
	.db #0x62	; 98	'b'
	.dw #0x01ec
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 652)
	.dw #0x0078
	.db #0x62	; 98	'b'
	.dw #0x01ee
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 772)
	.dw #0x001d
	.db #0x62	; 98	'b'
	.dw #0x01f0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 801)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x01f2
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 835)
	.dw #0x0024
	.db #0x65	; 101	'e'
	.dw #0x01f4
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 871)
	.dw #0x008a
	.db #0x65	; 101	'e'
	.dw #0x01f6
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1009)
	.dw #0x0068
	.db #0x65	; 101	'e'
	.dw #0x01f8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1113)
	.dw #0x0026
	.db #0x65	; 101	'e'
	.dw #0x01fa
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1151)
	.dw #0x0026
	.db #0x62	; 98	'b'
	.dw #0x01fc
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1189)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0x01fe
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1221)
	.dw #0x0053
	.db #0x65	; 101	'e'
	.dw #0x0200
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1304)
	.dw #0x0036
	.db #0x65	; 101	'e'
	.dw #0x0202
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1358)
	.dw #0x0048
	.db #0x65	; 101	'e'
	.dw #0x0204
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1430)
	.dw #0x003f
	.db #0x62	; 98	'b'
	.dw #0x0206
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1493)
	.dw #0x0021
	.db #0x65	; 101	'e'
	.dw #0x0208
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1526)
	.dw #0x003d
	.db #0x65	; 101	'e'
	.dw #0x020a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1587)
	.dw #0x0014
	.db #0x65	; 101	'e'
	.dw #0x020c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1607)
	.dw #0x000b
	.db #0x65	; 101	'e'
	.dw #0x020e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1618)
	.dw #0x0011
	.db #0x65	; 101	'e'
	.dw #0x0210
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1635)
	.dw #0x000b
	.db #0x65	; 101	'e'
	.dw #0x0212
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1646)
	.dw #0x005c
	.db #0x65	; 101	'e'
	.dw #0x0214
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1738)
	.dw #0x004f
	.db #0x65	; 101	'e'
	.dw #0x0216
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1817)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0x0218
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1868)
	.dw #0x001b
	.db #0x65	; 101	'e'
	.dw #0x021a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1895)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0x021c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1946)
	.dw #0x001c
	.db #0x62	; 98	'b'
	.dw #0x021e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 1974)
	.dw #0x0047
	.db #0x65	; 101	'e'
	.dw #0x0220
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2045)
	.dw #0x0037
	.db #0x65	; 101	'e'
	.dw #0x0222
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2100)
	.dw #0x0023
	.db #0x65	; 101	'e'
	.dw #0x0224
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2135)
	.dw #0x0023
	.db #0x65	; 101	'e'
	.dw #0x0226
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2170)
	.dw #0x0023
	.db #0x65	; 101	'e'
	.dw #0x0228
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2205)
	.dw #0x0024
	.db #0x62	; 98	'b'
	.dw #0x022a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2241)
	.dw #0x002e
	.db #0x65	; 101	'e'
	.dw #0x022c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2287)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0x022e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2315)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0x0230
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2366)
	.dw #0x0043
	.db #0x65	; 101	'e'
	.dw #0x0232
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2433)
	.dw #0x0060
	.db #0x65	; 101	'e'
	.dw #0x0234
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2529)
	.dw #0x0034
	.db #0x65	; 101	'e'
	.dw #0x0236
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2581)
	.dw #0x001a
	.db #0x65	; 101	'e'
	.dw #0x0238
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2607)
	.dw #0x003f
	.db #0x65	; 101	'e'
	.dw #0x023a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2670)
	.dw #0x0083
	.db #0x65	; 101	'e'
	.dw #0x023c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2801)
	.dw #0x0042
	.db #0x65	; 101	'e'
	.dw #0x023e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 2867)
	.dw #0x009a
	.db #0x62	; 98	'b'
	.dw #0x0240
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3021)
	.dw #0x0052
	.db #0x62	; 98	'b'
	.dw #0x0242
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3103)
	.dw #0x000e
	.db #0x62	; 98	'b'
	.dw #0x0244
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3117)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0x0246
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3149)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0x0248
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3181)
	.dw #0x0035
	.db #0x65	; 101	'e'
	.dw #0x024a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3234)
	.dw #0x0057
	.db #0x62	; 98	'b'
	.dw #0x024c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3321)
	.dw #0x003b
	.db #0x65	; 101	'e'
	.dw #0x024e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3380)
	.dw #0x0034
	.db #0x65	; 101	'e'
	.dw #0x0250
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3432)
	.dw #0x007c
	.db #0x65	; 101	'e'
	.dw #0x0252
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3556)
	.dw #0x005b
	.db #0x65	; 101	'e'
	.dw #0x0254
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3647)
	.dw #0x0044
	.db #0x65	; 101	'e'
	.dw #0x0256
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3715)
	.dw #0x003f
	.db #0x65	; 101	'e'
	.dw #0x0258
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3778)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0x025a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3812)
	.dw #0x0048
	.db #0x62	; 98	'b'
	.dw #0x025c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3884)
	.dw #0x0016
	.db #0x62	; 98	'b'
	.dw #0x025e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3906)
	.dw #0x0030
	.db #0x65	; 101	'e'
	.dw #0x0260
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 3954)
	.dw #0x0039
	.db #0x65	; 101	'e'
	.dw #0x0262
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4011)
	.dw #0x003d
	.db #0x65	; 101	'e'
	.dw #0x0264
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4072)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0x0266
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4100)
	.dw #0x0052
	.db #0x65	; 101	'e'
	.dw #0x0268
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4182)
	.dw #0x0034
	.db #0x65	; 101	'e'
	.dw #0x026a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4234)
	.dw #0x0019
	.db #0x65	; 101	'e'
	.dw #0x026c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4259)
	.dw #0x007e
	.db #0x62	; 98	'b'
	.dw #0x026e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4385)
	.dw #0x0041
	.db #0x65	; 101	'e'
	.dw #0x0270
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4450)
	.dw #0x0034
	.db #0x65	; 101	'e'
	.dw #0x0272
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4502)
	.dw #0x0185
	.db #0x62	; 98	'b'
	.dw #0x0274
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 4891)
	.dw #0x0169
	.db #0x62	; 98	'b'
	.dw #0x0276
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 5252)
	.dw #0x0149
	.db #0x62	; 98	'b'
	.dw #0x0278
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 5581)
	.dw #0x0104
	.db #0x62	; 98	'b'
	.dw #0x027a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 5841)
	.dw #0x005c
	.db #0x65	; 101	'e'
	.dw #0x027c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 5933)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0x027e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 5965)
	.dw #0x003a
	.db #0x65	; 101	'e'
	.dw #0x0280
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6023)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0x0282
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6055)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0x0284
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6102)
	.dw #0x0040
	.db #0x65	; 101	'e'
	.dw #0x0286
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6166)
	.dw #0x0078
	.db #0x65	; 101	'e'
	.dw #0x0288
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6286)
	.dw #0x0034
	.db #0x65	; 101	'e'
	.dw #0x028a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6338)
	.dw #0x003c
	.db #0x65	; 101	'e'
	.dw #0x028c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6398)
	.dw #0x0072
	.db #0x62	; 98	'b'
	.dw #0x028e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6512)
	.dw #0x0032
	.db #0x62	; 98	'b'
	.dw #0x0290
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6562)
	.dw #0x003a
	.db #0x65	; 101	'e'
	.dw #0x0292
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6620)
	.dw #0x0038
	.db #0x65	; 101	'e'
	.dw #0x0294
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6676)
	.dw #0x002c
	.db #0x65	; 101	'e'
	.dw #0x0296
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6720)
	.dw #0x001f
	.db #0x62	; 98	'b'
	.dw #0x0298
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6751)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0x029a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6782)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0x029c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6813)
	.dw #0x0035
	.db #0x65	; 101	'e'
	.dw #0x029e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6866)
	.dw #0x005a
	.db #0x65	; 101	'e'
	.dw #0x02a0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6956)
	.dw #0x001c
	.db #0x63	; 99	'c'
	.dw #0x02a2
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 6984)
	.dw #0x0015
	.db #0x65	; 101	'e'
	.dw #0x02a4
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7005)
	.dw #0x001a
	.db #0x65	; 101	'e'
	.dw #0x02a6
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7031)
	.dw #0x003b
	.db #0x65	; 101	'e'
	.dw #0x02a8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7090)
	.dw #0x0040
	.db #0x65	; 101	'e'
	.dw #0x02aa
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7154)
	.dw #0x0065
	.db #0x65	; 101	'e'
	.dw #0xb108
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7255)
	.dw #0x0015
	.db #0x63	; 99	'c'
	.dw #0xb118
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7276)
	.dw #0x0015
	.db #0x63	; 99	'c'
	.dw #0xb128
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7297)
	.dw #0x000a
	.db #0x62	; 98	'b'
	.dw #0xb132
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7307)
	.dw #0x000b
	.db #0x63	; 99	'c'
	.dw #0xb13d
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7318)
	.dw #0x0026
	.db #0x63	; 99	'c'
	.dw #0xb15e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7356)
	.dw #0x0016
	.db #0x63	; 99	'c'
	.dw #0xb172
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7378)
	.dw #0x001c
	.db #0x63	; 99	'c'
	.dw #0xb18b
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7406)
	.dw #0x001f
	.db #0x63	; 99	'c'
	.dw #0xb1a3
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7437)
	.dw #0x0029
	.db #0x63	; 99	'c'
	.dw #0xb1b2
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7478)
	.dw #0x0028
	.db #0x63	; 99	'c'
	.dw #0xb1c1
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7518)
	.dw #0x001a
	.db #0x63	; 99	'c'
	.dw #0xb1d0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7544)
	.dw #0x000d
	.db #0x63	; 99	'c'
	.dw #0xb1d8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7557)
	.dw #0x000d
	.db #0x63	; 99	'c'
	.dw #0xb1e0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7570)
	.dw #0x000e
	.db #0x63	; 99	'c'
	.dw #0xb1ee
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7584)
	.dw #0x000e
	.db #0x63	; 99	'c'
	.dw #0xb1fc
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7598)
	.dw #0x000f
	.db #0x63	; 99	'c'
	.dw #0xb203
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7613)
	.dw #0x000f
	.db #0x63	; 99	'c'
	.dw #0xb20a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7628)
	.dw #0x0019
	.db #0x63	; 99	'c'
	.dw #0xb21d
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7653)
	.dw #0x0018
	.db #0x63	; 99	'c'
	.dw #0xb22f
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7677)
	.dw #0x001d
	.db #0x63	; 99	'c'
	.dw #0xb24c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7706)
	.dw #0x0013
	.db #0x63	; 99	'c'
	.dw #0xb25f
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7725)
	.dw #0x0025
	.db #0x63	; 99	'c'
	.dw #0xb27f
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7762)
	.dw #0x0013
	.db #0x65	; 101	'e'
	.dw #0xb28e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7781)
	.dw #0x0021
	.db #0x65	; 101	'e'
	.dw #0xb2ac
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7814)
	.dw #0x000a
	.db #0x63	; 99	'c'
	.dw #0xb2b6
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7824)
	.dw #0x000c
	.db #0x62	; 98	'b'
	.dw #0xb2c2
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7836)
	.dw #0x000b
	.db #0x65	; 101	'e'
	.dw #0xb2cd
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7847)
	.dw #0x0016
	.db #0x63	; 99	'c'
	.dw #0xb2e3
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7869)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0xb2fb
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7899)
	.dw #0x0017
	.db #0x65	; 101	'e'
	.dw #0xb305
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7922)
	.dw #0x000a
	.db #0x63	; 99	'c'
	.dw #0xb30a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7932)
	.dw #0x000d
	.db #0x63	; 99	'c'
	.dw #0xb312
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7945)
	.dw #0x001a
	.db #0x63	; 99	'c'
	.dw #0xb322
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 7971)
	.dw #0x0024
	.db #0x63	; 99	'c'
	.dw #0xb35c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8007)
	.dw #0x0015
	.db #0x63	; 99	'c'
	.dw #0xb366
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8028)
	.dw #0x000f
	.db #0x63	; 99	'c'
	.dw #0xb375
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8043)
	.dw #0x001d
	.db #0x65	; 101	'e'
	.dw #0xb392
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8072)
	.dw #0x0024
	.db #0x65	; 101	'e'
	.dw #0xb3b1
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8108)
	.dw #0x0038
	.db #0x63	; 99	'c'
	.dw #0xb3e3
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8164)
	.dw #0x0021
	.db #0x65	; 101	'e'
	.dw #0xb3f9
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8197)
	.dw #0x000b
	.db #0x65	; 101	'e'
	.dw #0xb404
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8208)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0xb424
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8240)
	.dw #0x0011
	.db #0x65	; 101	'e'
	.dw #0xb431
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8257)
	.dw #0x002a
	.db #0x63	; 99	'c'
	.dw #0xb458
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8299)
	.dw #0x001c
	.db #0x63	; 99	'c'
	.dw #0xb471
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8327)
	.dw #0x003a
	.db #0x65	; 101	'e'
	.dw #0xb49a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8385)
	.dw #0x0043
	.db #0x65	; 101	'e'
	.dw #0xb4d5
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8452)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0xb500
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8503)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0xb52c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8550)
	.dw #0x001d
	.db #0x65	; 101	'e'
	.dw #0xb544
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8579)
	.dw #0x0016
	.db #0x65	; 101	'e'
	.dw #0xb555
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8601)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0xb569
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8631)
	.dw #0x0033
	.db #0x65	; 101	'e'
	.dw #0xb592
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8682)
	.dw #0x000d
	.db #0x65	; 101	'e'
	.dw #0xb59c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8695)
	.dw #0x0014
	.db #0x63	; 99	'c'
	.dw #0xb5b0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8715)
	.dw #0x0012
	.db #0x65	; 101	'e'
	.dw #0xb5ba
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8733)
	.dw #0x0017
	.db #0x63	; 99	'c'
	.dw #0xb5c8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8756)
	.dw #0x001d
	.db #0x63	; 99	'c'
	.dw #0xb5de
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8785)
	.dw #0x001a
	.db #0x65	; 101	'e'
	.dw #0xb5f0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8811)
	.dw #0x001d
	.db #0x65	; 101	'e'
	.dw #0xb604
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8840)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0xb621
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8872)
	.dw #0x0014
	.db #0x65	; 101	'e'
	.dw #0xb635
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8892)
	.dw #0x0013
	.db #0x65	; 101	'e'
	.dw #0xb648
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8911)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0xb656
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8939)
	.dw #0x0018
	.db #0x62	; 98	'b'
	.dw #0xb665
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8963)
	.dw #0x000c
	.db #0x65	; 101	'e'
	.dw #0xb671
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 8975)
	.dw #0x0039
	.db #0x62	; 98	'b'
	.dw #0xb68c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9032)
	.dw #0x001b
	.db #0x62	; 98	'b'
	.dw #0xb69e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9059)
	.dw #0x000f
	.db #0x65	; 101	'e'
	.dw #0xb6ad
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9074)
	.dw #0x0014
	.db #0x65	; 101	'e'
	.dw #0xb6c1
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9094)
	.dw #0x0012
	.db #0x62	; 98	'b'
	.dw #0xb6d0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9112)
	.dw #0x0010
	.db #0x65	; 101	'e'
	.dw #0xb6de
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9128)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0xb6f7
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9156)
	.dw #0x0019
	.db #0x63	; 99	'c'
	.dw #0xb709
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9181)
	.dw #0x0012
	.db #0x63	; 99	'c'
	.dw #0xb71b
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9199)
	.dw #0x000d
	.db #0x65	; 101	'e'
	.dw #0xb728
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9212)
	.dw #0x0008
	.db #0x63	; 99	'c'
	.dw #0xb730
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9220)
	.dw #0x0013
	.db #0x63	; 99	'c'
	.dw #0xb743
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9239)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0xb754
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9267)
	.dw #0x0014
	.db #0x62	; 98	'b'
	.dw #0xb761
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9287)
	.dw #0x0024
	.db #0x62	; 98	'b'
	.dw #0xb76f
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9323)
	.dw #0x0022
	.db #0x62	; 98	'b'
	.dw #0xb77b
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9357)
	.dw #0x0023
	.db #0x62	; 98	'b'
	.dw #0xb785
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9392)
	.dw #0x0011
	.db #0x62	; 98	'b'
	.dw #0xb790
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9409)
	.dw #0x000f
	.db #0x62	; 98	'b'
	.dw #0xb799
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9424)
	.dw #0x0012
	.db #0x62	; 98	'b'
	.dw #0xb7aa
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9442)
	.dw #0x0023
	.db #0x65	; 101	'e'
	.dw #0xb7c7
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9477)
	.dw #0x0030
	.db #0x62	; 98	'b'
	.dw #0xb7e3
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9525)
	.dw #0x0012
	.db #0x65	; 101	'e'
	.dw #0xb7f5
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9543)
	.dw #0x001b
	.db #0x62	; 98	'b'
	.dw #0xb807
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9570)
	.dw #0x001a
	.db #0x62	; 98	'b'
	.dw #0xb813
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9596)
	.dw #0x0035
	.db #0x65	; 101	'e'
	.dw #0xb832
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9649)
	.dw #0x003c
	.db #0x62	; 98	'b'
	.dw #0xb85d
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9709)
	.dw #0x002c
	.db #0x62	; 98	'b'
	.dw #0xb882
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9753)
	.dw #0x001e
	.db #0x62	; 98	'b'
	.dw #0xb89a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9783)
	.dw #0x0028
	.db #0x62	; 98	'b'
	.dw #0xb8bc
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9823)
	.dw #0x001a
	.db #0x62	; 98	'b'
	.dw #0xb8c8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9849)
	.dw #0x0024
	.db #0x62	; 98	'b'
	.dw #0xb8e0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9885)
	.dw #0x0036
	.db #0x62	; 98	'b'
	.dw #0xb90a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9939)
	.dw #0x0024
	.db #0x62	; 98	'b'
	.dw #0xb925
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9975)
	.dw #0x0018
	.db #0x62	; 98	'b'
	.dw #0xb938
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 9999)
	.dw #0x0021
	.db #0x65	; 101	'e'
	.dw #0xb951
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10032)
	.dw #0x002f
	.db #0x65	; 101	'e'
	.dw #0xb964
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10079)
	.dw #0x0013
	.db #0x65	; 101	'e'
	.dw #0xb96b
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10098)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0xb97f
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10126)
	.dw #0x0034
	.db #0x62	; 98	'b'
	.dw #0xb9b0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10178)
	.dw #0x0019
	.db #0x63	; 99	'c'
	.dw #0xb9c4
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10203)
	.dw #0x001b
	.db #0x63	; 99	'c'
	.dw #0xb9d3
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10230)
	.dw #0x001a
	.db #0x62	; 98	'b'
	.dw #0xb9e5
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10256)
	.dw #0x000d
	.db #0x62	; 98	'b'
	.dw #0xb9ee
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10269)
	.dw #0x001f
	.db #0x62	; 98	'b'
	.dw #0xba04
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10300)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0xba1f
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10330)
	.dw #0x001d
	.db #0x65	; 101	'e'
	.dw #0xba3c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10359)
	.dw #0x001d
	.db #0x65	; 101	'e'
	.dw #0xba56
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10388)
	.dw #0x000c
	.db #0x62	; 98	'b'
	.dw #0xba62
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10400)
	.dw #0x0037
	.db #0x62	; 98	'b'
	.dw #0xba82
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10455)
	.dw #0x001c
	.db #0x62	; 98	'b'
	.dw #0xba93
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10483)
	.dw #0x0010
	.db #0x63	; 99	'c'
	.dw #0xbaa3
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10499)
	.dw #0x000b
	.db #0x65	; 101	'e'
	.dw #0xbaae
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10510)
	.dw #0x002e
	.db #0x65	; 101	'e'
	.dw #0xbad0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10556)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0xbae6
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10587)
	.dw #0x0016
	.db #0x65	; 101	'e'
	.dw #0xbaf4
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10609)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0xbb06
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10637)
	.dw #0x0007
	.db #0x65	; 101	'e'
	.dw #0xbb0d
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10644)
	.dw #0x0022
	.db #0x65	; 101	'e'
	.dw #0xbb20
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10678)
	.dw #0x003a
	.db #0x65	; 101	'e'
	.dw #0xbb3d
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10736)
	.dw #0x000b
	.db #0x65	; 101	'e'
	.dw #0xbb45
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10747)
	.dw #0x001d
	.db #0x65	; 101	'e'
	.dw #0xbb5c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10776)
	.dw #0x004a
	.db #0x65	; 101	'e'
	.dw #0xbb8d
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10850)
	.dw #0x0038
	.db #0x65	; 101	'e'
	.dw #0xbbbf
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10906)
	.dw #0x001b
	.db #0x65	; 101	'e'
	.dw #0xbbd2
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10933)
	.dw #0x002c
	.db #0x65	; 101	'e'
	.dw #0xbbf0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 10977)
	.dw #0x003e
	.db #0x65	; 101	'e'
	.dw #0xbc1a
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11039)
	.dw #0x002d
	.db #0x65	; 101	'e'
	.dw #0xbc42
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11084)
	.dw #0x002c
	.db #0x65	; 101	'e'
	.dw #0xbc5b
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11128)
	.dw #0x0038
	.db #0x65	; 101	'e'
	.dw #0xbc89
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11184)
	.dw #0x0031
	.db #0x65	; 101	'e'
	.dw #0xbcaa
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11233)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0xbcc2
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11263)
	.dw #0x001f
	.db #0x63	; 99	'c'
	.dw #0xbce1
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11294)
	.dw #0x0018
	.db #0x62	; 98	'b'
	.dw #0xbced
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11318)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0xbcf7
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11348)
	.dw #0x001e
	.db #0x65	; 101	'e'
	.dw #0xbd01
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11378)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0xbd0c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11409)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0xbd17
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11440)
	.dw #0x0012
	.db #0x65	; 101	'e'
	.dw #0xbd23
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11458)
	.dw #0x0047
	.db #0x65	; 101	'e'
	.dw #0xbd57
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11529)
	.dw #0x0030
	.db #0x65	; 101	'e'
	.dw #0xbd7e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11577)
	.dw #0x001f
	.db #0x65	; 101	'e'
	.dw #0xbd97
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11608)
	.dw #0x001b
	.db #0x62	; 98	'b'
	.dw #0xbd9f
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11635)
	.dw #0x003f
	.db #0x65	; 101	'e'
	.dw #0xbdce
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11698)
	.dw #0x001e
	.db #0x62	; 98	'b'
	.dw #0xbde6
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11728)
	.dw #0x001d
	.db #0x62	; 98	'b'
	.dw #0xbdff
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11757)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0xbe1b
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11785)
	.dw #0x0022
	.db #0x62	; 98	'b'
	.dw #0xbe35
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11819)
	.dw #0x0013
	.db #0x63	; 99	'c'
	.dw #0xbe45
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11838)
	.dw #0x0024
	.db #0x62	; 98	'b'
	.dw #0xbe5e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11874)
	.dw #0x001f
	.db #0x62	; 98	'b'
	.dw #0xbe6f
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11905)
	.dw #0x0020
	.db #0x62	; 98	'b'
	.dw #0xbe82
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11937)
	.dw #0x0019
	.db #0x65	; 101	'e'
	.dw #0xbe93
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11962)
	.dw #0x001c
	.db #0x65	; 101	'e'
	.dw #0xbea1
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 11990)
	.dw #0x001a
	.db #0x65	; 101	'e'
	.dw #0xbeb6
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12016)
	.dw #0x001d
	.db #0x64	; 100	'd'
	.dw #0xbed0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12045)
	.dw #0x001e
	.db #0x64	; 100	'd'
	.dw #0xbee8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12075)
	.dw #0x001e
	.db #0x64	; 100	'd'
	.dw #0xbefd
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12105)
	.dw #0x0015
	.db #0x64	; 100	'd'
	.dw #0xbf09
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12126)
	.dw #0x001e
	.db #0x64	; 100	'd'
	.dw #0xbf21
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12156)
	.dw #0x0020
	.db #0x64	; 100	'd'
	.dw #0xbf3b
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12188)
	.dw #0x0037
	.db #0x65	; 101	'e'
	.dw #0xbf64
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12243)
	.dw #0x0074
	.db #0x65	; 101	'e'
	.dw #0xbfc4
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12359)
	.dw #0x001b
	.db #0x65	; 101	'e'
	.dw #0xf49b
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12386)
	.dw #0x0069
	.db #0x65	; 101	'e'
	.dw #0xf4fc
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12491)
	.dw #0x0101
	.db #0x65	; 101	'e'
	.dw #0xf5d5
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12748)
	.dw #0x0054
	.db #0x65	; 101	'e'
	.dw #0xf617
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12832)
	.dw #0x0039
	.db #0x65	; 101	'e'
	.dw #0xf646
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12889)
	.dw #0x000a
	.db #0x65	; 101	'e'
	.dw #0xf64d
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12899)
	.dw #0x0030
	.db #0x65	; 101	'e'
	.dw #0xf66e
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 12947)
	.dw #0x0069
	.db #0x65	; 101	'e'
	.dw #0xf6c1
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13052)
	.dw #0x0035
	.db #0x65	; 101	'e'
	.dw #0xf6f3
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13105)
	.dw #0x0066
	.db #0x65	; 101	'e'
	.dw #0xf746
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13207)
	.dw #0x0055
	.db #0x65	; 101	'e'
	.dw #0xf786
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13292)
	.dw #0x003d
	.db #0x65	; 101	'e'
	.dw #0xf7b9
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13353)
	.dw #0x0020
	.db #0x65	; 101	'e'
	.dw #0xf7d1
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13385)
	.dw #0x00a2
	.db #0x65	; 101	'e'
	.dw #0xf85c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13547)
	.dw #0x003c
	.db #0x65	; 101	'e'
	.dw #0xf884
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13607)
	.dw #0x00e0
	.db #0x65	; 101	'e'
	.dw #0xf929
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13831)
	.dw #0x005b
	.db #0x65	; 101	'e'
	.dw #0xf97c
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 13922)
	.dw #0x006f
	.db #0x65	; 101	'e'
	.dw #0xf9e8
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 14033)
	.dw #0x000b
	.db #0x63	; 99	'c'
	.dw #0xf9f0
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 14044)
	.dw #0x000b
	.db #0x63	; 99	'c'
	.dw #0xf9fb
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 14055)
	.dw #0x000b
	.db #0x63	; 99	'c'
	.dw #0xfa06
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 14066)
	.dw #0x000f
	.db #0x63	; 99	'c'
	.dw #0xfa12
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 14081)
	.dw #0x0045
	.db #0x63	; 99	'c'
	.dw #0xfa54
	.db #0x0a	; 10
	.dw (_dialogue_text_10 + 14150)
	.dw #0x0036
	.db #0x63	; 99	'c'
_dialogue_ref_count:
	.dw #0x0216
_dialogue_items:
	.ascii "        "
	.db 0x00
	.ascii "WOODCANE"
	.db 0x00
	.ascii "SHT. SWD"
	.db 0x00
	.ascii "IRN. SWD"
	.db 0x00
	.ascii "WAND"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "IRN.FANG"
	.db 0x00
	.ascii "IRN. AXE"
	.db 0x00
	.ascii "TIT. SWD"
	.db 0x00
	.ascii "CRC. SWD"
	.db 0x00
	.ascii "NEEDLGUN"
	.db 0x00
	.ascii "SIL.FANG"
	.db 0x00
	.ascii "HEAT.GUN"
	.db 0x00
	.ascii "LGT.SABR"
	.db 0x00
	.ascii "LASR.GUN"
	.db 0x00
	.ascii "LAC. SWD"
	.db 0x00
	.ascii "LAC. AXE"
	.db 0x00
	.ascii "LTH.ARMR"
	.db 0x00
	.ascii "WHT.MANT"
	.db 0x00
	.ascii "LGT.SUIT"
	.db 0x00
	.ascii "IRN.ARMR"
	.db 0x00
	.ascii "THCK.FUR"
	.db 0x00
	.ascii "ZIR.ARMR"
	.db 0x00
	.ascii "DMD.ARMR"
	.db 0x00
	.ascii "LAC.ARMR"
	.db 0x00
	.ascii "FRD.MANT"
	.db 0x00
	.ascii "LTH. SLD"
	.db 0x00
	.ascii "BRNZ.SLD"
	.db 0x00
	.ascii "IRN. SLD"
	.db 0x00
	.ascii "CRC. SLD"
	.db 0x00
	.ascii "GLOVE"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "LASR.SLD"
	.db 0x00
	.ascii "MIRR.SLD"
	.db 0x00
	.ascii "LAC. SLD"
	.db 0x00
	.ascii "LANDROVR"
	.db 0x00
	.ascii "HOVRCRFT"
	.db 0x00
	.ascii "ICE DIGR"
	.db 0x00
	.ascii "COLA"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "BURGER"
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "FLUTE"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "FLASH"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "ESCAPER"
	.db 0x00
	.db 0x00
	.ascii "TRANSER"
	.db 0x00
	.db 0x00
	.ascii "MAGC HAT"
	.db 0x00
	.ascii "ALSULIN"
	.db 0x00
	.db 0x00
	.ascii "POLYMTRL"
	.db 0x00
	.ascii "DUGN KEY"
	.db 0x00
	.ascii "SPHERE"
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "TORCH"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "PRISM"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "NUTS"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "HAPSBY"
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "ROADPASS"
	.db 0x00
	.ascii "PASSPORT"
	.db 0x00
	.ascii "COMPASS"
	.db 0x00
	.db 0x00
	.ascii "CAKE"
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "LETTER"
	.db 0x00
	.db 0x00
	.db 0x00
	.ascii "LAC. POT"
	.db 0x00
	.ascii "MAG.LAMP"
	.db 0x00
	.ascii "AMBR EYE"
	.db 0x00
	.ascii "GAS. SLD"
	.db 0x00
	.ascii "CRYSTAL"
	.db 0x00
	.db 0x00
	.ascii "M SYSTEM"
	.db 0x00
	.ascii "MRCL KEY"
	.db 0x00
	.ascii "ZILLION"
	.db 0x00
	.db 0x00
	.ascii "SECRETS"
	.db 0x00
	.db 0x00
	.area _INITIALIZER
	.area _CABS (ABS)
