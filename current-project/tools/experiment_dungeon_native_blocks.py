#!/usr/bin/env python3
"""Install an unpromoted native-block experiment in an isolated source copy."""
import hashlib,json,struct
from extract_dungeon_graphics import c_array
NATIVE_EXPAND=r'''
/* Experimental: palette-specific blocks bypass the per-tile variant lookup.
 * Input map is held at scratch+448 while the first434bytes hold wanted IDs. */
extern const DungeonGraphicAsset motion_native_lookup[12];
extern const uint8_t motion_native_banks[];
static void native_tile(void) __nonbanked __naked {
    __asm
    push de
    ld a,(hl+)
    ld e,a
    ld a,(hl+)
    ld d,a
    ld a,(hl+)
    ld b,a
    ld a,(hl+)
    ld c,a
    push hl
    ld a,c
    add a
    ld l,a
    ld h,#0
    rl h
    push bc
    ld bc,#_dungeon_render_scratch
    add hl,bc
    ld (hl),e
    inc hl
    ld (hl),d
    pop bc
    pop hl
    pop de
    ld a,c
    ld (de),a
    inc de
    ld a,b
    ld (de),a
    inc de
    ret
    __endasm;
}
static void expand_native_blocks(void) __nonbanked __naked {
    __asm
    ld hl,#(_dungeon_render_scratch+448)
    ld de,#_dungeon_render_map
    ld b,#8
040$:
    ld c,#10
041$:
    push bc
    ld a,(hl+)
    ld c,a
    ld a,(hl+)
    ld b,a
    push hl
    push de
    sla c
    rl b
    ld a,(#_variant_base)
    ld l,a
    ld a,(#_variant_base+1)
    ld h,a
    ld a,(#_block_sources)
    ldh (__current_bank),a
    ld (#0x2000),a
    add hl,bc
    ld a,(hl+)
    ld c,a
    ld b,(hl)
    ld a,b
    rrca
    rrca
    and #63
    ld e,a
    ld d,#0
    ld hl,#_motion_native_banks
    add hl,de
    ld a,(hl)
    ldh (__current_bank),a
    ld (#0x2000),a
    ld a,c
    swap a
    and #240
    ld l,a
    ld a,c
    swap a
    and #15
    ld e,a
    ld a,b
    and #3
    swap a
    or e
    or #64
    ld h,a
    pop de
    call _native_tile
    call _native_tile
    push de
    push hl
    ldhl sp,#7
    ld a,(hl)
    pop hl
    cp #1
    jr z,043$
    ld a,e
    add #36
    ld e,a
    jr nc,042$
    inc d
042$:
    call _native_tile
    call _native_tile
043$:
    pop de
    pop hl
    pop bc
    dec c
    jp nz,041$
    ld a,e
    add #40
    ld e,a
    jr nc,044$
    inc d
044$:
    dec b
    jp nz,040$
    ret
    __endasm;
}
void dungeon_motion_expand_native(const DungeonGraphicAsset *map,uint8_t palette) BANK_IO_FIXED {
    uint8_t saved=CURRENT_BANK;
    const DungeonGraphicAsset *lookup=motion_native_lookup+palette;
    bank_copy((uint8_t *)&dungeon_render_scratch+448u,map->bank,map->data,160u);
    memset(&dungeon_render_scratch,255,MOTION_CACHE_SLOTS*2u);
    block_sources[0]=lookup->bank;variant_base=(uint16_t)lookup->data;
    expand_native_blocks();SWITCH_ROM_MBC5(saved);
}
'''
def install(source,data):
 unique={};blocks=[];lookups=[]
 for palette in range(12):
  lookup=[]
  for raw in data['blocks']:
   block=b''.join(struct.pack('<HBB',*data['variants'][palette][tile])for tile in raw)
   if block not in unique:unique[block]=len(blocks);blocks.append(block)
   lookup.append(unique[block])
  lookups.append(lookup)
 pool_banks=list(range(21,30))+list(range(64,76));assert len(blocks)<=len(pool_banks)*1024
 lookup_banks=[76,78,79,80];names=[]
 metadata='#pragma bank 0\n#include "dungeon_graphics.h"\n'
 for i,bank in enumerate(pool_banks):
  raw=b''.join(blocks[i*1024:(i+1)*1024]);name=f'native_blocks_{bank}.c';names.append(name)
  (source/name).write_text(f'#pragma bank {bank}\n#include <stdint.h>\n'+c_array(f'native_blocks_{bank}',raw))
 metadata+='const uint8_t motion_native_banks[]={'+','.join(str(b)for b in pool_banks)+'};\n'
 for group,bank in enumerate(lookup_banks):
  text=f'#pragma bank {bank}\n#include <stdint.h>\n';name=f'native_lookup_{bank}.c';names.append(name)
  for palette in range(group*3,group*3+3):
   raw=b''.join(struct.pack('<H',n)for n in lookups[palette]);text+=c_array(f'native_lookup_{palette}',raw);metadata+=f'extern const uint8_t native_lookup_{palette}[];\n'
  (source/name).write_text(text)
 metadata+='const DungeonGraphicAsset motion_native_lookup[12]={'+','.join('{'+str(lookup_banks[p//3])+',native_lookup_'+str(p)+'}'for p in range(12))+'};\n';names.append('native_tables.c');(source/names[-1]).write_text(metadata)
 p=source/'dungeon_motion_upload.c';text=p.read_text();start=text.index('static void expand_blocks(');end=text.index('/* Pools start at4000.')
 p.write_text(text[:start]+NATIVE_EXPAND+text[end:])
 p=source/'dungeon_motion_upload.h';text=p.read_text();text=text.replace('#endif','void dungeon_motion_expand_native(const DungeonGraphicAsset *,uint8_t) BANK_IO_FIXED;\n#endif');p.write_text(text)
 p=source/'dungeon_motion.c';text=p.read_text();text=text.replace('dungeon_motion_expand_map(motion_maps+image);\n    dungeon_motion_prepare_variant(variant);','dungeon_motion_expand_native(motion_maps+image,palette);');p.write_text(text)
 report={'blocks':len(blocks),'bytes':len(blocks)*16,'lookup_bytes':sum(len(p)*2 for p in lookups),'pool_banks':pool_banks,'lookup_banks':lookup_banks,'production_sources_changed':False,'production_WRAM_added':0,'raw_sha256':hashlib.sha256(b''.join(blocks)).hexdigest()}
 (source.parent/'native-block-manifest.json').write_text(json.dumps(report,indent=2)+'\n')
 return names
