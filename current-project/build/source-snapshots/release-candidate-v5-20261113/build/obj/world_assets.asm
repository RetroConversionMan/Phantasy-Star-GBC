;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module world_assets
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _world_scenes
	.globl _world_map_music
	.globl _world_map_group
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
	.area _CODE_0
	.area _CODE_0
_world_map_group:
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x04	; 4
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x05	; 5
	.db #0x06	; 6
	.db #0x06	; 6
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x08	; 8
	.db #0x08	; 8
	.db #0x09	; 9
	.db #0x09	; 9
	.db #0x0a	; 10
_world_map_music:
	.db #0x82	; 130
	.db #0x83	; 131
	.db #0x84	; 132
	.db #0x84	; 132
	.db #0x87	; 135
	.db #0x87	; 135
	.db #0x87	; 135
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x87	; 135
	.db #0x87	; 135
	.db #0x87	; 135
	.db #0x88	; 136
	.db #0x87	; 135
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x84	; 132
	.db #0x84	; 132
	.db #0x88	; 136
	.db #0x88	; 136
	.db #0x85	; 133
_world_scenes:
	.db #0x20	; 32
	.db #0x21	; 33
	.dw #0x0134
	.dw _world_g00_map
	.dw _world_g00_metatiles
	.dw _world_g00_collision
	.dw _world_g00_tiles
	.dw _world_g00_palettes
	.dw _world_g00_exits
	.db #0x2e	; 46
	.db #0x22	; 34
	.db #0x23	; 35
	.dw #0x00b6
	.dw _world_g01_map
	.dw _world_g01_metatiles
	.dw _world_g01_collision
	.dw _world_g01_tiles
	.dw _world_g01_palettes
	.dw _world_g01_exits
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x25	; 37
	.dw #0x0078
	.dw _world_g02_map
	.dw _world_g02_metatiles
	.dw _world_g02_collision
	.dw _world_g02_tiles
	.dw _world_g02_palettes
	.dw _world_g02_exits
	.db #0x11	; 17
	.db #0x26	; 38
	.db #0x27	; 39
	.dw #0x0078
	.dw _world_g03_map
	.dw _world_g03_metatiles
	.dw _world_g03_collision
	.dw _world_g03_tiles
	.dw _world_g03_palettes
	.dw _world_g03_exits
	.db #0x00	; 0
	.db #0x28	; 40
	.db #0x29	; 41
	.dw #0x00e3
	.dw _world_g04_map
	.dw _world_g04_metatiles
	.dw _world_g04_collision
	.dw _world_g04_tiles
	.dw _world_g04_palettes
	.dw _world_g04_exits
	.db #0x60	; 96
	.db #0x2a	; 42
	.db #0x2b	; 43
	.dw #0x009a
	.dw _world_g05_map
	.dw _world_g05_metatiles
	.dw _world_g05_collision
	.dw _world_g05_tiles
	.dw _world_g05_palettes
	.dw _world_g05_exits
	.db #0x2f	; 47
	.db #0x2c	; 44
	.db #0x2d	; 45
	.dw #0x007e
	.dw _world_g06_map
	.dw _world_g06_metatiles
	.dw _world_g06_collision
	.dw _world_g06_tiles
	.dw _world_g06_palettes
	.dw _world_g06_exits
	.db #0x78	; 120	'x'
	.db #0x2e	; 46
	.db #0x2f	; 47
	.dw #0x014d
	.dw _world_g07_map
	.dw _world_g07_metatiles
	.dw _world_g07_collision
	.dw _world_g07_tiles
	.dw _world_g07_palettes
	.dw _world_g07_exits
	.db #0x66	; 102	'f'
	.db #0x30	; 48	'0'
	.db #0x31	; 49	'1'
	.dw #0x0034
	.dw _world_g08_map
	.dw _world_g08_metatiles
	.dw _world_g08_collision
	.dw _world_g08_tiles
	.dw _world_g08_palettes
	.dw _world_g08_exits
	.db #0x2a	; 42
	.db #0x32	; 50	'2'
	.db #0x33	; 51	'3'
	.dw #0x00ba
	.dw _world_g09_map
	.dw _world_g09_metatiles
	.dw _world_g09_collision
	.dw _world_g09_tiles
	.dw _world_g09_palettes
	.dw _world_g09_exits
	.db #0x27	; 39
	.db #0x34	; 52	'4'
	.db #0x35	; 53	'5'
	.dw #0x0042
	.dw _world_g10_map
	.dw _world_g10_metatiles
	.dw _world_g10_collision
	.dw _world_g10_tiles
	.dw _world_g10_palettes
	.dw _world_g10_exits
	.db #0x06	; 6
	.area _INITIALIZER
	.area _CABS (ABS)
