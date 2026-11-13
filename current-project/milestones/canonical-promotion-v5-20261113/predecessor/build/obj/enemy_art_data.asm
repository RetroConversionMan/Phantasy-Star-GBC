;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module enemy_art_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _enemy_art
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
	.area _CODE
	.area _CODE
_enemy_art:
	.db #0x36	; 54	'6'
	.db #0x15	; 21
	.dw _enemy_01_tiles
	.dw _enemy_01_map
	.dw _enemy_01_attrs
	.dw _enemy_01_palettes
	.db #0x36	; 54	'6'
	.db #0x09	; 9
	.dw _enemy_02_tiles
	.dw _enemy_02_map
	.dw _enemy_02_attrs
	.dw _enemy_02_palettes
	.db #0x36	; 54	'6'
	.db #0x17	; 23
	.dw _enemy_03_tiles
	.dw _enemy_03_map
	.dw _enemy_03_attrs
	.dw _enemy_03_palettes
	.db #0x36	; 54	'6'
	.db #0x1d	; 29
	.dw _enemy_04_tiles
	.dw _enemy_04_map
	.dw _enemy_04_attrs
	.dw _enemy_04_palettes
	.db #0x36	; 54	'6'
	.db #0x1b	; 27
	.dw _enemy_05_tiles
	.dw _enemy_05_map
	.dw _enemy_05_attrs
	.dw _enemy_05_palettes
	.db #0x36	; 54	'6'
	.db #0x1b	; 27
	.dw _enemy_06_tiles
	.dw _enemy_06_map
	.dw _enemy_06_attrs
	.dw _enemy_06_palettes
	.db #0x36	; 54	'6'
	.db #0x09	; 9
	.dw _enemy_07_tiles
	.dw _enemy_07_map
	.dw _enemy_07_attrs
	.dw _enemy_07_palettes
	.db #0x36	; 54	'6'
	.db #0x22	; 34
	.dw _enemy_08_tiles
	.dw _enemy_08_map
	.dw _enemy_08_attrs
	.dw _enemy_08_palettes
	.db #0x36	; 54	'6'
	.db #0x17	; 23
	.dw _enemy_09_tiles
	.dw _enemy_09_map
	.dw _enemy_09_attrs
	.dw _enemy_09_palettes
	.db #0x36	; 54	'6'
	.db #0x1d	; 29
	.dw _enemy_10_tiles
	.dw _enemy_10_map
	.dw _enemy_10_attrs
	.dw _enemy_10_palettes
	.db #0x36	; 54	'6'
	.db #0x1b	; 27
	.dw _enemy_11_tiles
	.dw _enemy_11_map
	.dw _enemy_11_attrs
	.dw _enemy_11_palettes
	.db #0x36	; 54	'6'
	.db #0x22	; 34
	.dw _enemy_12_tiles
	.dw _enemy_12_map
	.dw _enemy_12_attrs
	.dw _enemy_12_palettes
	.db #0x36	; 54	'6'
	.db #0x15	; 21
	.dw _enemy_13_tiles
	.dw _enemy_13_map
	.dw _enemy_13_attrs
	.dw _enemy_13_palettes
	.db #0x36	; 54	'6'
	.db #0x0e	; 14
	.dw _enemy_14_tiles
	.dw _enemy_14_map
	.dw _enemy_14_attrs
	.dw _enemy_14_palettes
	.db #0x36	; 54	'6'
	.db #0x21	; 33
	.dw _enemy_15_tiles
	.dw _enemy_15_map
	.dw _enemy_15_attrs
	.dw _enemy_15_palettes
	.db #0x37	; 55	'7'
	.db #0x17	; 23
	.dw _enemy_16_tiles
	.dw _enemy_16_map
	.dw _enemy_16_attrs
	.dw _enemy_16_palettes
	.db #0x37	; 55	'7'
	.db #0x09	; 9
	.dw _enemy_17_tiles
	.dw _enemy_17_map
	.dw _enemy_17_attrs
	.dw _enemy_17_palettes
	.db #0x37	; 55	'7'
	.db #0x27	; 39
	.dw _enemy_18_tiles
	.dw _enemy_18_map
	.dw _enemy_18_attrs
	.dw _enemy_18_palettes
	.db #0x37	; 55	'7'
	.db #0x27	; 39
	.dw _enemy_19_tiles
	.dw _enemy_19_map
	.dw _enemy_19_attrs
	.dw _enemy_19_palettes
	.db #0x37	; 55	'7'
	.db #0x35	; 53	'5'
	.dw _enemy_20_tiles
	.dw _enemy_20_map
	.dw _enemy_20_attrs
	.dw _enemy_20_palettes
	.db #0x37	; 55	'7'
	.db #0x1f	; 31
	.dw _enemy_21_tiles
	.dw _enemy_21_map
	.dw _enemy_21_attrs
	.dw _enemy_21_palettes
	.db #0x37	; 55	'7'
	.db #0x2d	; 45
	.dw _enemy_22_tiles
	.dw _enemy_22_map
	.dw _enemy_22_attrs
	.dw _enemy_22_palettes
	.db #0x37	; 55	'7'
	.db #0x3a	; 58
	.dw _enemy_23_tiles
	.dw _enemy_23_map
	.dw _enemy_23_attrs
	.dw _enemy_23_palettes
	.db #0x37	; 55	'7'
	.db #0x2a	; 42
	.dw _enemy_24_tiles
	.dw _enemy_24_map
	.dw _enemy_24_attrs
	.dw _enemy_24_palettes
	.db #0x37	; 55	'7'
	.db #0x2d	; 45
	.dw _enemy_25_tiles
	.dw _enemy_25_map
	.dw _enemy_25_attrs
	.dw _enemy_25_palettes
	.db #0x37	; 55	'7'
	.db #0x35	; 53	'5'
	.dw _enemy_26_tiles
	.dw _enemy_26_map
	.dw _enemy_26_attrs
	.dw _enemy_26_palettes
	.db #0x37	; 55	'7'
	.db #0x24	; 36
	.dw _enemy_27_tiles
	.dw _enemy_27_map
	.dw _enemy_27_attrs
	.dw _enemy_27_palettes
	.db #0x37	; 55	'7'
	.db #0x0e	; 14
	.dw _enemy_28_tiles
	.dw _enemy_28_map
	.dw _enemy_28_attrs
	.dw _enemy_28_palettes
	.db #0x38	; 56	'8'
	.db #0x27	; 39
	.dw _enemy_29_tiles
	.dw _enemy_29_map
	.dw _enemy_29_attrs
	.dw _enemy_29_palettes
	.db #0x38	; 56	'8'
	.db #0x58	; 88	'X'
	.dw _enemy_30_tiles
	.dw _enemy_30_map
	.dw _enemy_30_attrs
	.dw _enemy_30_palettes
	.db #0x38	; 56	'8'
	.db #0x2a	; 42
	.dw _enemy_31_tiles
	.dw _enemy_31_map
	.dw _enemy_31_attrs
	.dw _enemy_31_palettes
	.db #0x38	; 56	'8'
	.db #0x1f	; 31
	.dw _enemy_32_tiles
	.dw _enemy_32_map
	.dw _enemy_32_attrs
	.dw _enemy_32_palettes
	.db #0x38	; 56	'8'
	.db #0x27	; 39
	.dw _enemy_33_tiles
	.dw _enemy_33_map
	.dw _enemy_33_attrs
	.dw _enemy_33_palettes
	.db #0x38	; 56	'8'
	.db #0x1f	; 31
	.dw _enemy_34_tiles
	.dw _enemy_34_map
	.dw _enemy_34_attrs
	.dw _enemy_34_palettes
	.db #0x38	; 56	'8'
	.db #0x2a	; 42
	.dw _enemy_35_tiles
	.dw _enemy_35_map
	.dw _enemy_35_attrs
	.dw _enemy_35_palettes
	.db #0x38	; 56	'8'
	.db #0x1f	; 31
	.dw _enemy_36_tiles
	.dw _enemy_36_map
	.dw _enemy_36_attrs
	.dw _enemy_36_palettes
	.db #0x38	; 56	'8'
	.db #0x3a	; 58
	.dw _enemy_37_tiles
	.dw _enemy_37_map
	.dw _enemy_37_attrs
	.dw _enemy_37_palettes
	.db #0x38	; 56	'8'
	.db #0x3d	; 61
	.dw _enemy_38_tiles
	.dw _enemy_38_map
	.dw _enemy_38_attrs
	.dw _enemy_38_palettes
	.db #0x38	; 56	'8'
	.db #0x0e	; 14
	.dw _enemy_39_tiles
	.dw _enemy_39_map
	.dw _enemy_39_attrs
	.dw _enemy_39_palettes
	.db #0x38	; 56	'8'
	.db #0x1f	; 31
	.dw _enemy_40_tiles
	.dw _enemy_40_map
	.dw _enemy_40_attrs
	.dw _enemy_40_palettes
	.db #0x39	; 57	'9'
	.db #0x3f	; 63
	.dw _enemy_41_tiles
	.dw _enemy_41_map
	.dw _enemy_41_attrs
	.dw _enemy_41_palettes
	.db #0x39	; 57	'9'
	.db #0x2a	; 42
	.dw _enemy_42_tiles
	.dw _enemy_42_map
	.dw _enemy_42_attrs
	.dw _enemy_42_palettes
	.db #0x39	; 57	'9'
	.db #0x24	; 36
	.dw _enemy_43_tiles
	.dw _enemy_43_map
	.dw _enemy_43_attrs
	.dw _enemy_43_palettes
	.db #0x39	; 57	'9'
	.db #0x2a	; 42
	.dw _enemy_44_tiles
	.dw _enemy_44_map
	.dw _enemy_44_attrs
	.dw _enemy_44_palettes
	.db #0x39	; 57	'9'
	.db #0x2a	; 42
	.dw _enemy_45_tiles
	.dw _enemy_45_map
	.dw _enemy_45_attrs
	.dw _enemy_45_palettes
	.db #0x39	; 57	'9'
	.db #0x25	; 37
	.dw _enemy_46_tiles
	.dw _enemy_46_map
	.dw _enemy_46_attrs
	.dw _enemy_46_palettes
	.db #0x39	; 57	'9'
	.db #0x35	; 53	'5'
	.dw _enemy_47_tiles
	.dw _enemy_47_map
	.dw _enemy_47_attrs
	.dw _enemy_47_palettes
	.db #0x39	; 57	'9'
	.db #0x3d	; 61
	.dw _enemy_48_tiles
	.dw _enemy_48_map
	.dw _enemy_48_attrs
	.dw _enemy_48_palettes
	.db #0x39	; 57	'9'
	.db #0x1e	; 30
	.dw _enemy_49_tiles
	.dw _enemy_49_map
	.dw _enemy_49_attrs
	.dw _enemy_49_palettes
	.db #0x39	; 57	'9'
	.db #0x5e	; 94
	.dw _enemy_50_tiles
	.dw _enemy_50_map
	.dw _enemy_50_attrs
	.dw _enemy_50_palettes
	.db #0x39	; 57	'9'
	.db #0x25	; 37
	.dw _enemy_51_tiles
	.dw _enemy_51_map
	.dw _enemy_51_attrs
	.dw _enemy_51_palettes
	.db #0x3a	; 58
	.db #0x3c	; 60
	.dw _enemy_52_tiles
	.dw _enemy_52_map
	.dw _enemy_52_attrs
	.dw _enemy_52_palettes
	.db #0x3a	; 58
	.db #0x5e	; 94
	.dw _enemy_53_tiles
	.dw _enemy_53_map
	.dw _enemy_53_attrs
	.dw _enemy_53_palettes
	.db #0x3a	; 58
	.db #0x3d	; 61
	.dw _enemy_54_tiles
	.dw _enemy_54_map
	.dw _enemy_54_attrs
	.dw _enemy_54_palettes
	.db #0x3a	; 58
	.db #0x44	; 68	'D'
	.dw _enemy_55_tiles
	.dw _enemy_55_map
	.dw _enemy_55_attrs
	.dw _enemy_55_palettes
	.db #0x3a	; 58
	.db #0x35	; 53	'5'
	.dw _enemy_56_tiles
	.dw _enemy_56_map
	.dw _enemy_56_attrs
	.dw _enemy_56_palettes
	.db #0x3a	; 58
	.db #0x45	; 69	'E'
	.dw _enemy_57_tiles
	.dw _enemy_57_map
	.dw _enemy_57_attrs
	.dw _enemy_57_palettes
	.db #0x3a	; 58
	.db #0x3d	; 61
	.dw _enemy_58_tiles
	.dw _enemy_58_map
	.dw _enemy_58_attrs
	.dw _enemy_58_palettes
	.db #0x3a	; 58
	.db #0x3d	; 61
	.dw _enemy_59_tiles
	.dw _enemy_59_map
	.dw _enemy_59_attrs
	.dw _enemy_59_palettes
	.db #0x3a	; 58
	.db #0x6d	; 109	'm'
	.dw _enemy_60_tiles
	.dw _enemy_60_map
	.dw _enemy_60_attrs
	.dw _enemy_60_palettes
	.db #0x3b	; 59
	.db #0x6d	; 109	'm'
	.dw _enemy_61_tiles
	.dw _enemy_61_map
	.dw _enemy_61_attrs
	.dw _enemy_61_palettes
	.db #0x3b	; 59
	.db #0x2b	; 43
	.dw _enemy_62_tiles
	.dw _enemy_62_map
	.dw _enemy_62_attrs
	.dw _enemy_62_palettes
	.db #0x3b	; 59
	.db #0x58	; 88	'X'
	.dw _enemy_63_tiles
	.dw _enemy_63_map
	.dw _enemy_63_attrs
	.dw _enemy_63_palettes
	.db #0x3b	; 59
	.db #0x45	; 69	'E'
	.dw _enemy_64_tiles
	.dw _enemy_64_map
	.dw _enemy_64_attrs
	.dw _enemy_64_palettes
	.db #0x3b	; 59
	.db #0x44	; 68	'D'
	.dw _enemy_65_tiles
	.dw _enemy_65_map
	.dw _enemy_65_attrs
	.dw _enemy_65_palettes
	.db #0x3b	; 59
	.db #0x5e	; 94
	.dw _enemy_66_tiles
	.dw _enemy_66_map
	.dw _enemy_66_attrs
	.dw _enemy_66_palettes
	.db #0x3b	; 59
	.db #0x3a	; 58
	.dw _enemy_67_tiles
	.dw _enemy_67_map
	.dw _enemy_67_attrs
	.dw _enemy_67_palettes
	.db #0x3b	; 59
	.db #0x6d	; 109	'm'
	.dw _enemy_68_tiles
	.dw _enemy_68_map
	.dw _enemy_68_attrs
	.dw _enemy_68_palettes
	.db #0x3c	; 60
	.db #0x6d	; 109	'm'
	.dw _enemy_69_tiles
	.dw _enemy_69_map
	.dw _enemy_69_attrs
	.dw _enemy_69_palettes
	.db #0x3c	; 60
	.db #0x1c	; 28
	.dw _enemy_70_tiles
	.dw _enemy_70_map
	.dw _enemy_70_attrs
	.dw _enemy_70_palettes
	.db #0x3c	; 60
	.db #0x2b	; 43
	.dw _enemy_71_tiles
	.dw _enemy_71_map
	.dw _enemy_71_attrs
	.dw _enemy_71_palettes
	.db #0x3c	; 60
	.db #0x3f	; 63
	.dw _enemy_72_tiles
	.dw _enemy_72_map
	.dw _enemy_72_attrs
	.dw _enemy_72_palettes
	.db #0x3c	; 60
	.db #0x19	; 25
	.dw _enemy_73_tiles
	.dw _enemy_73_map
	.dw _enemy_73_attrs
	.dw _enemy_73_palettes
	.db #0x3c	; 60
	.db #0x19	; 25
	.dw _enemy_74_tiles
	.dw _enemy_74_map
	.dw _enemy_74_attrs
	.dw _enemy_74_palettes
	.area _INITIALIZER
	.area _CABS (ABS)
