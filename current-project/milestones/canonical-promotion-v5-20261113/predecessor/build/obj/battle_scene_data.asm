;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Mac OS X ppc)
;--------------------------------------------------------
	.module battle_scene_data
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _battle_scene_lookup
	.globl _battle_scene_pools
	.globl _battle_scene_assets
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
_battle_scene_assets:
	.db #0x8c	; 140
	.db #0x08	; 8
	.dw _battle_overlay_000
	.db #0x8c	; 140
	.db #0x04	; 4
	.dw _battle_overlay_001
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_002
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_003
	.db #0x8c	; 140
	.db #0x07	; 7
	.dw _battle_overlay_004
	.db #0x8c	; 140
	.db #0x07	; 7
	.dw _battle_overlay_005
	.db #0x8c	; 140
	.db #0x04	; 4
	.dw _battle_overlay_006
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_007
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_008
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_009
	.db #0x8c	; 140
	.db #0x07	; 7
	.dw _battle_overlay_010
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_011
	.db #0x8c	; 140
	.db #0x08	; 8
	.dw _battle_overlay_012
	.db #0x8c	; 140
	.db #0x06	; 6
	.dw _battle_overlay_013
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_014
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_015
	.db #0x8c	; 140
	.db #0x04	; 4
	.dw _battle_overlay_016
	.db #0x8c	; 140
	.db #0x0c	; 12
	.dw _battle_overlay_017
	.db #0x8d	; 141
	.db #0x0c	; 12
	.dw _battle_overlay_018
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_019
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_020
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_021
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_022
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_023
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_024
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_025
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_026
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_027
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_028
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_029
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_030
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_031
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_032
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_033
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_034
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_035
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_036
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_037
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_038
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_039
	.db #0x8d	; 141
	.db #0x0d	; 13
	.dw _battle_overlay_040
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_041
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_042
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_043
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_044
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_045
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_046
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_047
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_048
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_049
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_050
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_051
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_052
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_053
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_054
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_055
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_056
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_057
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_058
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_059
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_060
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_061
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_062
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_063
	.db #0x8d	; 141
	.db #0x12	; 18
	.dw _battle_overlay_064
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_065
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_066
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_067
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_068
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_069
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_070
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_071
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_072
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_073
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_074
	.db #0x8d	; 141
	.db #0x0e	; 14
	.dw _battle_overlay_075
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_076
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_077
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_078
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_079
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_080
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_081
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_082
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_083
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_084
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_085
	.db #0x8e	; 142
	.db #0x08	; 8
	.dw _battle_overlay_086
	.db #0x8e	; 142
	.db #0x06	; 6
	.dw _battle_overlay_087
	.db #0x8e	; 142
	.db #0x0c	; 12
	.dw _battle_overlay_088
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_089
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_090
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_091
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_092
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_093
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_094
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_095
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_096
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_097
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_098
	.db #0x8e	; 142
	.db #0x19	; 25
	.dw _battle_overlay_099
	.db #0x8e	; 142
	.db #0x0f	; 15
	.dw _battle_overlay_100
	.db #0x8e	; 142
	.db #0x0a	; 10
	.dw _battle_overlay_101
	.db #0x8e	; 142
	.db #0x0c	; 12
	.dw _battle_overlay_102
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_103
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_104
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_105
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_106
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_107
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_108
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_109
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_110
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_111
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_112
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_113
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_114
	.db #0x8e	; 142
	.db #0x0a	; 10
	.dw _battle_overlay_115
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_116
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_117
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_118
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_119
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_120
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_121
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_122
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_123
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_124
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_125
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_126
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_127
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_128
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_129
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_130
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_131
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_132
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_133
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_134
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_135
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_136
	.db #0x8e	; 142
	.db #0x15	; 21
	.dw _battle_overlay_137
	.db #0x8e	; 142
	.db #0x06	; 6
	.dw _battle_overlay_138
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_139
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_140
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_141
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_142
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_143
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_144
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_145
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_146
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_147
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_148
	.db #0x8e	; 142
	.db #0x0d	; 13
	.dw _battle_overlay_149
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_150
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_151
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_152
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_153
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_154
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_155
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_156
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_157
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_158
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_159
	.db #0x8e	; 142
	.db #0x12	; 18
	.dw _battle_overlay_160
	.db #0x8e	; 142
	.db #0x0e	; 14
	.dw _battle_overlay_161
	.db #0x8f	; 143
	.db #0x08	; 8
	.dw _battle_overlay_162
	.db #0x8f	; 143
	.db #0x0f	; 15
	.dw _battle_overlay_163
	.db #0x8f	; 143
	.db #0x0f	; 15
	.dw _battle_overlay_164
	.db #0x8f	; 143
	.db #0x0e	; 14
	.dw _battle_overlay_165
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_166
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_167
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_168
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_169
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_170
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_171
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_172
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_173
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_174
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_175
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_176
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_177
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_178
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_179
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_180
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_181
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_182
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_183
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_184
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_185
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_186
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_187
	.db #0x8f	; 143
	.db #0x0a	; 10
	.dw _battle_overlay_188
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_189
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_190
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_191
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_192
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_193
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_194
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_195
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_196
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_197
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_198
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_199
	.db #0x8f	; 143
	.db #0x0e	; 14
	.dw _battle_overlay_200
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_201
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_202
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_203
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_204
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_205
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_206
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_207
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_208
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_209
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_210
	.db #0x8f	; 143
	.db #0x12	; 18
	.dw _battle_overlay_211
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_212
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_213
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_214
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_215
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_216
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_217
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_218
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_219
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_220
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_221
	.db #0x8f	; 143
	.db #0x19	; 25
	.dw _battle_overlay_222
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_223
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_224
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_225
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_226
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_227
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_228
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_229
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_230
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_231
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_232
	.db #0x8f	; 143
	.db #0x15	; 21
	.dw _battle_overlay_233
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_234
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_235
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_236
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_237
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_238
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_239
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_240
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_241
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_242
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_243
	.db #0x8f	; 143
	.db #0x14	; 20
	.dw _battle_overlay_244
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_245
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_246
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_247
	.db #0x8f	; 143
	.db #0x11	; 17
	.dw _battle_overlay_248
	.db #0x90	; 144
	.db #0x11	; 17
	.dw _battle_overlay_249
	.db #0x90	; 144
	.db #0x11	; 17
	.dw _battle_overlay_250
	.db #0x90	; 144
	.db #0x11	; 17
	.dw _battle_overlay_251
	.db #0x90	; 144
	.db #0x11	; 17
	.dw _battle_overlay_252
	.db #0x90	; 144
	.db #0x11	; 17
	.dw _battle_overlay_253
	.db #0x90	; 144
	.db #0x11	; 17
	.dw _battle_overlay_254
	.db #0x90	; 144
	.db #0x11	; 17
	.dw _battle_overlay_255
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_256
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_257
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_258
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_259
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_260
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_261
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_262
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_263
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_264
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_265
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_266
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_267
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_268
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_269
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_270
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_271
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_272
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_273
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_274
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_275
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_276
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_277
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_278
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_279
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_280
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_281
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_282
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_283
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_284
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_285
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_286
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_287
	.db #0x90	; 144
	.db #0x12	; 18
	.dw _battle_overlay_288
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_289
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_290
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_291
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_292
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_293
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_294
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_295
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_296
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_297
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_298
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_299
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_300
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_301
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_302
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_303
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_304
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_305
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_306
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_307
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_308
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_309
	.db #0x90	; 144
	.db #0x20	; 32
	.dw _battle_overlay_310
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_311
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_312
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_313
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_314
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_315
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_316
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_317
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_318
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_319
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_320
	.db #0x90	; 144
	.db #0x10	; 16
	.dw _battle_overlay_321
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_322
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_323
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_324
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_325
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_326
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_327
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_328
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_329
	.db #0x90	; 144
	.db #0x19	; 25
	.dw _battle_overlay_330
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_331
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_332
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_333
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_334
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_335
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_336
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_337
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_338
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_339
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_340
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_341
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_342
	.db #0x91	; 145
	.db #0x12	; 18
	.dw _battle_overlay_343
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_344
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_345
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_346
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_347
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_348
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_349
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_350
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_351
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_352
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_353
	.db #0x91	; 145
	.db #0x14	; 20
	.dw _battle_overlay_354
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_355
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_356
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_357
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_358
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_359
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_360
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_361
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_362
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_363
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_364
	.db #0x91	; 145
	.db #0x19	; 25
	.dw _battle_overlay_365
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_366
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_367
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_368
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_369
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_370
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_371
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_372
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_373
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_374
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_375
	.db #0x91	; 145
	.db #0x11	; 17
	.dw _battle_overlay_376
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_377
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_378
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_379
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_380
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_381
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_382
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_383
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_384
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_385
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_386
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_387
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_388
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_389
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_390
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_391
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_392
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_393
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_394
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_395
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_396
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_397
	.db #0x91	; 145
	.db #0x20	; 32
	.dw _battle_overlay_398
	.db #0x90	; 144
	.db #0x08	; 8
	.dw _battle_overlay_399
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_400
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_401
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_402
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_403
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_404
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_405
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_406
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_407
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_408
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_409
	.db #0x91	; 145
	.db #0x10	; 16
	.dw _battle_overlay_410
	.db #0x91	; 145
	.db #0x0c	; 12
	.dw _battle_overlay_411
	.db #0x91	; 145
	.db #0x0c	; 12
	.dw _battle_overlay_412
	.db #0x91	; 145
	.db #0x0c	; 12
	.dw _battle_overlay_413
	.db #0x92	; 146
	.db #0x0c	; 12
	.dw _battle_overlay_414
	.db #0x92	; 146
	.db #0x0c	; 12
	.dw _battle_overlay_415
	.db #0x92	; 146
	.db #0x0c	; 12
	.dw _battle_overlay_416
	.db #0x92	; 146
	.db #0x0c	; 12
	.dw _battle_overlay_417
	.db #0x92	; 146
	.db #0x0c	; 12
	.dw _battle_overlay_418
	.db #0x92	; 146
	.db #0x0c	; 12
	.dw _battle_overlay_419
	.db #0x92	; 146
	.db #0x0c	; 12
	.dw _battle_overlay_420
	.db #0x92	; 146
	.db #0x0c	; 12
	.dw _battle_overlay_421
_battle_scene_pools:
	.db #0x8c	; 140
	.dw _battle_pairs_00
	.db #0x8d	; 141
	.dw _battle_pairs_01
	.db #0x8c	; 140
	.dw _battle_pairs_02
_battle_scene_lookup:
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0001
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0002
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0003
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0004
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0005
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0006
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0007
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0008
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x0009
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000a
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000b
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000c
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000d
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000e
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x000f
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0010
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0011
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
	.dw #0x0012
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
	.dw #0x0013
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
	.dw #0x001e
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
	.dw #0x0029
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
	.dw #0x0034
	.dw #0x003d
	.dw #0x003e
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
	.dw #0x003f
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
	.dw #0x0040
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
	.dw #0x004b
	.dw #0x0054
	.dw #0x0055
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0056
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0057
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
	.dw #0x0058
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
	.dw #0x0059
	.dw #0x0062
	.dw #0x0063
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0064
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0065
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
	.dw #0x0066
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
	.dw #0x0067
	.dw #0x0070
	.dw #0x0071
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0072
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
	.dw #0x0073
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
	.dw #0x0074
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
	.dw #0x007f
	.dw #0x0088
	.dw #0x0089
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
	.dw #0x008a
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
	.dw #0x008b
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
	.dw #0x0096
	.dw #0x009f
	.dw #0x00a0
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a1
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a2
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a3
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a4
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
	.dw #0x00a5
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
	.dw #0x00a6
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
	.dw #0x00b1
	.dw #0x00ba
	.dw #0x00bb
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
	.dw #0x00bc
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
	.dw #0x00bd
	.dw #0x00c6
	.dw #0x00c7
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
	.dw #0x00c8
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
	.dw #0x00c9
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
	.dw #0x00d4
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
	.dw #0x00df
	.dw #0x00e8
	.dw #0x00e9
	.dw #0x00ea
	.dw #0x00eb
	.dw #0x00ec
	.dw #0x00ed
	.dw #0x00ee
	.dw #0x00ef
	.dw #0x00f0
	.dw #0x00f1
	.dw #0x00f2
	.dw #0x00ea
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
	.dw #0x00f5
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
	.dw #0x0100
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
	.dw #0x010b
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
	.dw #0x0116
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
	.dw #0x0121
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
	.dw #0x012c
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
	.dw #0x0137
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
	.dw #0x0142
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
	.dw #0x014d
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
	.dw #0x0158
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
	.dw #0x0163
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
	.dw #0x016e
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
	.dw #0x0179
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
	.dw #0x0184
	.dw #0x018d
	.dw #0x018e
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
	.dw #0x018f
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
	.dw #0x0190
	.dw #0x0199
	.dw #0x019a
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
	.dw #0xffff
	.dw #0xffff
	.dw #0x019b
	.dw #0x019c
	.dw #0x019d
	.dw #0x019e
	.dw #0x019f
	.dw #0x01a0
	.dw #0x01a1
	.dw #0x01a2
	.dw #0x01a3
	.dw #0x019b
	.dw #0x01a4
	.dw #0x01a5
	.area _INITIALIZER
	.area _CABS (ABS)
