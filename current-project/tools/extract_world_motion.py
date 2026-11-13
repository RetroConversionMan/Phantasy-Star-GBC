#!/usr/bin/env python3
"""Extract original 62BC world-pattern phases and source-index priority.

Writes only the requested output directories. The original ROM, baseline and
current production source are never implicit output targets.
"""
from pathlib import Path
import argparse, hashlib, importlib.util, json, struct
from extract_assets import address, decode_tile, c_array
from extract_world import (ROOT, SOURCE_SHA256, scene_source, convert_scene,
                           write_header, write_group, write_index)

# LABEL_62BC's BC operands become (first SMS pattern, number of patterns).
# LABEL_630A calculates the VDP address as (0x0800 + C) * 8.
RANGES = ((4,12),(16,3),(19,4),(23,6),(29,8),(37,16))
RELOADS = (31,15,15,3,15,7)
TABLES = tuple(0x6345 + i*16 for i in range(6))
DATA_BANKS = (24,25)

def animation_frames(rom, slot, tile):
    first,count = RANGES[slot]
    assert first <= tile < first+count
    return [decode_tile(rom[address(14,ptr):address(14,ptr)+count*32],tile-first)
            for ptr in struct.unpack_from('<8H',rom,TABLES[slot])]

def convert_motion_scene(source, rom, helper):
    group = source['group']
    enables = list(rom[0xDF1+group*14+3:0xDF1+group*14+9])
    priority = {word & 0x9FF for words in source['definitions'].values()
                for word in words if word & 0x1000}
    dynamic = {}
    for key in source['uses']:
        for slot,(first,count) in enumerate(RANGES):
            if enables[slot] and first <= (key & 511) < first+count:
                dynamic[key] = slot
    if not dynamic and not priority:
        return {**convert_scene(source), 'animation_enable': enables,
                'animation_patches': [[] for _ in range(6)], 'priority_keys': []}
    keys = sorted(source['uses'])
    frames = {}; source_palettes = {}; samples = []
    for key in keys:
        base = 16 if key & 0x800 else 0
        source_palettes[key] = source['source_palettes'][base:base+16]
        frames[key] = [decode_tile(source['source_tiles'],key & 511)]
        if key in dynamic:
            frames[key] += animation_frames(rom,dynamic[key],key & 511)
        weight = source['uses'][key] * (1 if key in dynamic else 9)
        samples.extend((frame,source_palettes[key],weight,key in priority)
                       for frame in frames[key])
    palettes = helper.choose_world_palettes(samples,7)
    graphics = bytearray(); converted = {}; static_dedupe = {}; patches = [[] for _ in range(6)]
    for key in keys:
        palette = helper.choose_world_tile_palette(frames[key],source_palettes[key],palettes,key in priority)
        initial,_ = helper.convert_world_tile(frames[key][0],source_palettes[key],palettes,key in priority,palette)
        if key in dynamic or initial not in static_dedupe:
            number = len(graphics)//16
            graphics.extend(initial)
            if key not in dynamic:
                static_dedupe[initial] = number
        else:
            number = static_dedupe[initial]
        if number >= 448:
            raise ValueError(f'Group {group} exceeds the protected 448-pattern allocation')
        tile = number if number < 256 else number-256+64
        bank = int(number >= 256)
        converted[key] = tile,palette | bank*8
        if key in dynamic:
            data = b''.join(helper.convert_world_tile(frame,source_palettes[key],palettes,key in priority,palette)[0]
                            for frame in frames[key][1:])
            patches[dynamic[key]].append((tile,bank,data,key,palette))
    metas = bytearray(256*8)
    for meta,words in source['definitions'].items():
        for quadrant,word in enumerate(words):
            tile,attr = converted[word & 0x9FF]
            metas[meta*8+quadrant*2:meta*8+quadrant*2+2] = bytes((tile,helper.world_attribute(word,attr)))
    return {**source,'graphics':bytes(graphics),'metatiles':bytes(metas),'palettes':palettes,
            'tile_count':len(graphics)//16,'animation_enable':enables,
            'animation_patches':patches,'priority_keys':sorted(priority)}

HEADER = '''/* Generated source62BC/630A animation descriptors. */
#ifndef PS_WORLD_MOTION_DATA_H
#define PS_WORLD_MOTION_DATA_H
#include <stdint.h>
typedef struct WorldMotionSlot {
    uint8_t bank, tile, count, vram_bank;
    const uint8_t *frames;
} WorldMotionSlot;
extern const uint8_t world_motion_enables[11][6];
extern const uint8_t world_motion_reloads[6];
extern const WorldMotionSlot world_motion_slots[2][6];
#endif
'''

def write_motion(scenes,folder):
    (folder/'world_motion_data.h').write_text(HEADER)
    index = '#pragma bank 21\n#include "world_motion_data.h"\n\n'
    for group in range(2):
        bank = DATA_BANKS[group]
        text = f'#pragma bank {bank}\n#include "world_motion_data.h"\n\n'
        total = 0
        for slot,patches in enumerate(scenes[group]['animation_patches']):
            if not patches:
                continue
            name = f'world_motion_g{group}_s{slot}'
            first,bank_vram=patches[0][:2]
            assert [(tile,vb) for tile,vb,*_ in patches]==[(first+n,bank_vram) for n in range(len(patches))],(group,slot,'Native patches must form one protected contiguous upload')
            data=b''.join(entry[2][phase*16:(phase+1)*16] for phase in range(8) for entry in patches)
            text += c_array(name,data)+'\n'
            total += len(data)
            index += f'extern const uint8_t {name}[];\n'
        assert total <= 16384,(group,total)
        (folder/f'world_motion_bank_{bank}.c').write_text(text)
    index += '\nconst uint8_t world_motion_enables[11][6] = {\n'
    index += ',\n'.join('    {'+','.join(map(str,s['animation_enable']))+'}' for s in scenes)+'\n};\n'
    index += c_array('world_motion_reloads',RELOADS)
    index += '\nconst WorldMotionSlot world_motion_slots[2][6] = {\n'
    for group in range(2):
        index += '    {\n'
        index += ',\n'.join(f'        {{{DATA_BANKS[group]},{patches[0][0]},{len(patches)},{patches[0][1]},world_motion_g{group}_s{slot}}}' if patches else '        {0,0,0,0,0}'
                            for slot,patches in enumerate(scenes[group]['animation_patches']))
        index += '\n    },\n'
    index += '};\n'
    (folder/'world_motion_data.c').write_text(index)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rom',type=Path,default=ROOT/'upstream/ps1disasm/ps1original.sms')
    parser.add_argument('--src',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True)
    parser.add_argument('--priority-helper',type=Path,required=True)
    args = parser.parse_args()
    rom = args.rom.read_bytes();assert hashlib.sha256(rom).hexdigest()==SOURCE_SHA256
    spec=importlib.util.spec_from_file_location('world_priority',args.priority_helper)
    helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
    args.src.mkdir(parents=True,exist_ok=True);args.output.mkdir(parents=True,exist_ok=True)
    scenes=[];reports=[];write_header(args.src/'world_assets.h')
    for group in range(11):
        scene=convert_motion_scene(scene_source(rom,group),rom,helper)
        scenes.append(scene);report=write_group(scene,args.src,args.output)
        report.update(animation_enable=scene['animation_enable'],priority_keys=scene['priority_keys'],
                      animation_patches=[len(patches) for patches in scene['animation_patches']],
                      patch_source_keys=[[entry[3] for entry in patches] for patches in scene['animation_patches']])
        reports.append(report)
        print(json.dumps({k:report[k] for k in ('group','tile_count','asset_bytes','animation_patches')}),flush=True)
    write_index(rom,scenes,args.src);write_motion(scenes,args.src)
    manifest={'source_sha256':SOURCE_SHA256,'source_routine':'62BC/630A','source_bank':14,
              'ranges':RANGES,'reloads':RELOADS,'phase_tables':[hex(x) for x in TABLES],
              'scheduler':'Only first expired enabled slot uploads; later timers do not decrement that frame. Full 8-bit phase increments normally and decrements for road tags >=4; table selection masks phase&7.',
              'groups':reports,'priority_helper_sha256':hashlib.sha256(args.priority_helper.read_bytes()).hexdigest()}
    (args.output/'motion-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    # Keep the general asset inventory current as well; the old static
    # extractor's manifest otherwise falsely describes these animated assets.
    inventory={'source_sha256':SOURCE_SHA256,'group_count':11,'map_count':24,
               'metatile_width':128,'metatile_height':96,
               'map_id_to_group':list(rom[0xDC1:0xDC1+24]),'groups':reports,
               'motion_manifest':'motion-manifest.json',
               'limitations':['Native palettes reduce original colors to GBC limits.',
                              'This extractor emits source data; runtime event gates, transport and animation scheduling are implemented and tested separately.']}
    (args.output/'manifest.json').write_text(json.dumps(inventory,indent=2)+'\n')

if __name__=='__main__':main()
