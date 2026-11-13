#!/usr/bin/env python3
"""Native source-coordinate battle overlays, background retention and window clips."""
from pathlib import Path
import json,hashlib,subprocess,struct
from PIL import Image
from pyboy import PyBoy
from verify_rom import load_symbols,cartridge_header
from extract_scenes import Source,label
from extract_scene_actors import source_overlay
ROOT=Path(__file__).resolve().parents[1]
MAIN=r'''
#include <gb/gb.h>
#include <gb/cgb.h>
#include "battle_scene.h"
#include "scene.h"
#include "gold_scene.h"
#include "font.h"
#include "assets.h"
uint8_t probe_command,probe_enemy,probe_type,probe_palette,probe_clip,probe_error,probe_ready;
void main(void){
 cpu_fast();DISPLAY_OFF;HIDE_WIN;HIDE_SPRITES;
 VBK_REG=1;set_bkg_data(0,64,ui_font);SWITCH_ROM(3);set_sprite_data(0,ALIS_TILE_COUNT,alis_tiles);SWITCH_ROM(1);
 VBK_REG=0;probe_ready=1;SHOW_BKG;DISPLAY_ON;
 while(1){vsync();if(probe_command){
  if(probe_command<=12u)DISPLAY_OFF;
  if(probe_command==1){battle_scene_configure(probe_type,probe_palette);probe_error=!battle_scene_begin(probe_enemy);}
  else if(probe_command==2)battle_scene_clear();
  else if(probe_command==3)battle_scene_clip(probe_clip);
  else if(probe_command==4)probe_error=battle_scene_world_type(probe_type,probe_palette);
  else if(probe_command==5)probe_error=!battle_scene_animation_frame(probe_clip);
  else if(probe_command==6)battle_scene_flash_enemy(probe_clip);
  else if(probe_command==7)battle_scene_flash_party(probe_clip,1);
  else if(probe_command==8)probe_error=!battle_scene_weapon_frame(probe_clip);
  else if(probe_command==9)battle_scene_weapon_clear();
  else if(probe_command==10)probe_error=!battle_scene_magic_frame(probe_clip);
  else if(probe_command==11)probe_error=!battle_scene_boss_frame(probe_clip,probe_palette);
  else if(probe_command==12)battle_scene_boss_patch(probe_clip);
  else if(probe_command==13){scene_palette_capture();gold_scene_prepare(probe_clip,0u,0u);scene_palette_commit();}
  else if(probe_command==14)gold_scene_blue();
  else if(probe_command==15)battle_scene_flash_enemy(probe_clip);
  else if(probe_command==16)battle_scene_flash_party(probe_clip,1u);
  if(CURRENT_BANK!=1)probe_error|=128;
  if(probe_command<=12u)DISPLAY_ON;probe_command=0;
 }}
}
'''
def reference_weapon(source,effect,frame,enemy,enemy_magic=False):
 from extract_scenes import cpu_offset
 from extract_assets import sms_rgb
 rom=source.rom;record=rom[label('B03_EnemyData')+enemy*32:][:32];desc=rom[label('LABEL_B03_8FC7')+(record[19]-1)*24:][:24]
 if enemy_magic:
  desc=bytearray(desc);start=cpu_offset(3,int.from_bytes(desc[11:13],'little'));cursor=1;pose=desc[1]
  while rom[start+cursor]:pose=rom[start+cursor];cursor+=1
  desc[1]=pose;fx=rom[label('LABEL_5EA8'if effect else'LABEL_5EA2'):][:6]
  actors=[(0,3,frame,desc[6],desc[7],source.graphics(11,int.from_bytes(fx[4:6],'little')),160)]
 else:
  fx=rom[label('LABEL_5BF1')+effect*6:][:6];actors=[(0,3,frame,desc[4],desc[5],source.graphics(18,int.from_bytes(fx[4:6],'little')),160)]
 enemy_graphics=source.graphics(record[16],int.from_bytes(record[17:19],'little'))
 for slot,fields in ((4,desc[:4]),(5,desc[19:23])):
  mode,index,y,x=fields
  if mode and index:actors.append((slot,21,index,y,x,enemy_graphics,0))
 owner=[None]*(256*192);common=rom[label('LABEL_3D1D'):label('LABEL_3D1D')+8]
 # Source OAM lower index has priority; rasterize low priority first, including
 # all enemy sprites rather than precomputing a foreground clip mask.
 for slot,bank,index,y,x,graphics,base in reversed(sorted(actors,key=lambda a:(-a[3],a[0]))):
  table=label('LABEL_B03_96F4'if bank==3 else 'LABEL_B21_8000');start=cpu_offset(bank,int.from_bytes(rom[table+index*2:][:2],'little'));count=rom[start];raw=rom[start+1:start+1+count*3]
  for i in reversed(range(count)):
   dx,tile=raw[count+i*2:count+i*2+2]
   for py in range(8):
    sy=(y+raw[i]+py+1)&255
    if sy>=192:continue
    for px in range(8):
     color=graphics[tile-base][py*8+px]
     if color:owner[sy*256+((x+dx+px)&255)]=common[color]if not slot else None
 image=Image.new('RGBA',(256,192));image.putdata([(*sms_rgb(c),255)if c is not None else (0,0,0,0)for c in owner]);return image

def main():
 out=ROOT/'build/verification/battle-scenes';out.mkdir(parents=True,exist_ok=True)
 (out/'main.c').write_text(MAIN);rom=out/'battle-scenes.gbc'
 names=['battle_scene.c','battle_scene_data.c','battle_motion.c','battle_weapon.c','enemy_magic.c','boss_motion.c','gold_scene.c','gold_scene_bank_123.c','palette_commit.c','battle_animation_data.c','scene.c','scene_data.c','scene_actor.c','scene_actor_data.c','bank_io.c','assets_sprites.c','font.c','dungeon_graphics.c']
 src=[out/'main.c']+[ROOT/'src'/n for n in names]+sorted((ROOT/'src').glob('battle_scene_bank_*.c'))+sorted((ROOT/'src').glob('battle_animation_bank_*.c'))+sorted((ROOT/'src').glob('scene_bank_*.c'))+sorted((ROOT/'src').glob('scene_actor_bank_*.c'))+sorted((ROOT/'src').glob('dungeon_graphics_*.c'))+sorted((ROOT/'src').glob('weapon_bank_*.c'))+sorted((ROOT/'src').glob('enemy_magic_bank_*.c'))+sorted((ROOT/'src').glob('boss_effects_bank_*.c'))
 subprocess.run(['.tools/gbdk/bin/lcc','-msm83:gb','-Wm-yC','-Wm-yt0x1b','-Wm-yo256','-Wm-ya1','-Wl-m','-Wl-j','-Isrc','-o',str(rom),*map(str,src)],cwd=ROOT,check=True)
 sym=load_symbols(rom.with_suffix('.noi'));e=PyBoy(str(rom),window='null',cgb=True,sound_emulated=False,log_level='ERROR');e.set_emulation_speed(0)
 report={'assets':0,'graphics_bytes':0,'oam_records':0,'clip_cases':0,'source_composites':0,'source_sfx_records':0,'map_remaps':0,'animation_assets':0,'palette_bytes':0,'flash_palette_bytes':0,'source_flash_pixels':0,'weapon_assets':0,'weapon_pattern_bytes':0,'weapon_oam_records':0,'weapon_source_pixels':0,'magic_assets':0,'magic_pattern_bytes':0,'magic_source_pixels':0,'screenshots':[]}
 manifest=json.loads((ROOT/'assets/battle-scenes/manifest.json').read_text());patterns=(ROOT/'assets/battle-scenes/patterns.2bpp').read_bytes();source_rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();source=Source(source_rom)
 def val(n):return e.memory[sym[n]]
 def command(c,**args):
  for k,v in args.items():e.memory[sym['probe_'+k]]=v
  e.memory[sym['probe_command']]=c
  for _ in range(500):
   e.tick(1)
   if not val('probe_command'):break
  else:raise AssertionError(('timeout',c,args,hex(e.register_file.PC)))
  if c!=4:assert not val('probe_error'),(c,args,val('probe_error'))
  e.tick(2)
 def bg():return bytes(e.memory[0,0x8800:0x9c00])+bytes(e.memory[1,0x9000:0x9c00])
 def protected():return bytes(e.memory[1,0x9000:0x9400])+bytes(e.memory[1,0x8000:0x8540])
 def shot(name):
  path=out/(name+'.png');e.screen.image.save(path);report['screenshots'].append(str(path))
 def obj_colors():
  result=[]
  for index in range(64):e.memory[0xff6a]=index;result.append(e.memory[0xff6b])
  return bytes(result)
 def check_flash(record,animation=False):
  data=(ROOT/('assets/boss-effects'if animation==3 else'assets/enemy-magic'if animation==2 else'assets/battle-animation' if animation else 'assets/battle-scenes')/f'{record["name"]}.bin').read_bytes();count=record['sprites'];colors=data[count*5:count*5+64]
  for group,cmd in ((0,6),(1,7)):
   expected=bytearray(colors);masks=data[count*5+64+group*8:count*5+72+group*8]
   for pal,mask in enumerate(masks):
    for c in range(1,4):
     if mask>>c&1:expected[(pal*4+c)*2:(pal*4+c)*2+2]=b'\xff\x7f'
   command(cmd,clip=1);assert obj_colors()==expected,(record['name'],group,'white')
   command(cmd,clip=0);assert obj_colors()==colors,(record['name'],group,'restore');report['flash_palette_bytes']+=128
  # Independent source index proof. Floor colors do not change index geometry.
  if record['palette']:return
  source_data=bytearray(source_rom)
  if animation:
   visual=source_data[label('B03_EnemyData')+record['enemy']*32+19]
   source_data[label('LABEL_B03_8FC7')+(visual-1)*24+1]=record['frame']
  indexed=source_overlay(Source(source_data),enemy=record['enemy'],indexed=True).resize((160,120),Image.Resampling.NEAREST)
  pool=boss_patterns if animation==3 else magic_patterns if animation==2 else animation_patterns if animation else patterns
  for i in range(count):
   x,y,pair,attr=struct.unpack_from('<BBHB',data,i*5);pattern=pool[pair*32:pair*32+32];pal=attr&7
   masks=data[count*5+64:count*5+80]
   for row in range(16):
    for col in range(8):
     if y-16+row>=120:continue
     r,g,b,a=indexed.getpixel((x-8+col,y-16+row));source_index=r//85+(g//85)*4+(b//85)*16
     code=(pattern[row*2]>>(7-col)&1)|((pattern[row*2+1]>>(7-col)&1)<<1)
     assert bool(code)==bool(a),(record['name'],i,row,col,'alpha')
     if not a:continue
     assert bool(masks[pal]>>code&1)==(source_index>=3),(record['name'],i,row,col,'enemy')
     assert bool(masks[pal+8]>>code&1)==(source_index==0),(record['name'],i,row,col,'extra')
     report['source_flash_pixels']+=1
 def check_asset(record,clip,animation=False):
  data=(ROOT/('assets/boss-effects'if animation==3 else'assets/enemy-magic'if animation==2 else'assets/battle-animation' if animation else 'assets/battle-scenes')/f'{record["name"]}.bin').read_bytes();count=record['sprites']
  pool=boss_patterns if animation==3 else magic_patterns if animation==2 else animation_patterns if animation else patterns
  assert e.memory[0xff40]&4
  for i in range(count):
   x,y,pair,attr=struct.unpack_from('<BBHB',data,i*5);expected=bytearray(pool[pair*32:pair*32+32]);oam=0xfe00+i*4
   if y-16>=clip:assert (e.memory[oam],e.memory[oam+1])==(0,0);continue
   for line in range(max(0,clip-(y-16)),16):expected[line*2:line*2+2]=b'\0\0'
   assert bytes(e.memory[1,0x8540+i*32:0x8560+i*32])==expected,(record['name'],i,clip)
   assert tuple(e.memory[oam:oam+4])==(y,x,84+i*2,attr),(record['name'],i)
   report['graphics_bytes']+=32;report['oam_records']+=1
  actual=[]
  for index in range(64):e.memory[0xff6a]=index;actual.append(e.memory[0xff6b])
  assert bytes(actual)==data[count*5:count*5+64],record['name'];report['palette_bytes']+=64
 try:
  e.tick(120);assert val('probe_ready')==1;keep=protected()
  # A real source background is loaded once; every floor variant must preserve it.
  command(1,enemy=1,type=1,palette=0);background=bg();shot('palma-sworm')
  for record in manifest['records']:
   command(1,enemy=record['enemy'],type=0,palette=record['palette']);check_asset(record,120);check_flash(record)
   assert protected()==keep and bg()==background,record['name'];report['assets']+=1
   if record['palette']==0 and record['enemy'] in (5,49,60,70,74):shot('enemy-'+str(record['enemy']))
   if record['palette']==0 and record['enemy'] in (1,49,60):
    for clip in (96,104,0,96,120):
     command(3,clip=clip)
     if clip:check_asset(record,clip)
     else:assert not e.memory[0xff40]&2
     assert bg()==background;report['clip_cases']+=1
   command(2);assert bg()==background and not e.memory[0xff40]&4
   assert all(e.memory[0xfe00+i*4]==0 for i in range(40))
  animations=json.loads((ROOT/'assets/battle-animation/manifest.json').read_text());animation_patterns=(ROOT/'assets/battle-animation/patterns.2bpp').read_bytes()
  for record in animations['records']:
   command(1,enemy=record['enemy'],type=0,palette=record['palette']);command(5,clip=record['frame']);check_asset(record,120,True);check_flash(record,True)
   assert protected()==keep and bg()==background,record['name'];report['animation_assets']+=1
  weapons=json.loads((ROOT/'assets/weapon-effects/manifest.json').read_text());weapon_patterns=(ROOT/'assets/weapon-effects/patterns.2bpp').read_bytes()
  initial={r['enemy']:r for r in manifest['records']if not r['palette']}
  last_enemy=0
  for record in weapons['records']:
   enemy=record['enemy']
   if enemy!=last_enemy:
    command(1,enemy=enemy,type=30 if enemy==72 else 32 if enemy==73 else 1,palette=0);command(3,clip=120);last_enemy=enemy;background=bg()
   command(8,clip=record['frame']);data=(ROOT/'assets/weapon-effects'/f'{record["name"]}.bin').read_bytes();count=record['sprites'];base_count=initial[enemy]['sprites']if enemy in initial else 0
   assert protected()==keep and bg()==background
   positions=[]
   for i in range(count):
    x,y,pair,attr=struct.unpack_from('<BBHB',data,i*5);expected=bytearray(weapon_patterns[pair*32:pair*32+32]);tile=84+(base_count+i)*2;oam=0xfe00+i*4
    for line in range(max(0,120-(y-16)),16):expected[line*2:line*2+2]=b'\0\0'
    assert bytes(e.memory[1,0x8000+tile*16:0x8000+tile*16+32])==expected,(record['name'],i,'pattern')
    assert tuple(e.memory[oam:oam+4])==(y,x,tile,attr),(record['name'],i,'oam')
    assert attr&7 in (6,7);positions.append((x,y));report['weapon_pattern_bytes']+=32;report['weapon_oam_records']+=1
   if base_count:
    base=(ROOT/'assets/battle-scenes'/f'{initial[enemy]["name"]}.bin').read_bytes()
    assert obj_colors()[:48]==base[base_count*5:base_count*5+48]
    for i in range(base_count):
     x,y,pair,attr=struct.unpack_from('<BBHB',base,i*5);oam=0xfe00+(i+count)*4
     assert attr&7<6 and tuple(e.memory[oam:oam+4])==(y,x,84+i*2,attr),(record['name'],i,'base')
     positions.append((x,y))
   assert obj_colors()[48:]==data[-16:]
   assert len(positions)<=40 and max(sum(y-16<=line<y for x,y in positions)for line in range(120))<=10
   # Full SMS actor raster order independently determines which original effect
   # pixels remain visible, including enemy sprite fragments in front of it.
   expected=reference_weapon(source,record['effect'],record['frame'],enemy)
   assert hashlib.sha256(expected.tobytes()).hexdigest()==record['source_sha256'],record['name']
   expected=expected.resize((160,120),Image.Resampling.NEAREST);native=Image.new('RGBA',(160,120));palette=struct.unpack('<8H',data[-16:])
   for i in range(count):
    x,y,pair,attr=struct.unpack_from('<BBHB',data,i*5);pattern=weapon_patterns[pair*32:pair*32+32];pal=(attr&7)-6
    for row in range(16):
     for col in range(8):
      if y-16+row>=120:continue
      code=(pattern[row*2]>>(7-col)&1)|((pattern[row*2+1]>>(7-col)&1)<<1);point=(x-8+col,y-16+row)
      assert bool(code)==bool(expected.getpixel(point)[3]),(record['name'],point,'source alpha')
      if code:
       color=palette[pal*4+code];rgb=tuple((0,85,170,255)[min(range(4),key=lambda v:abs((0,10,21,31)[v]-((color>>shift)&31)))]for shift in (0,5,10));native.putpixel(point,(*rgb,255));report['weapon_source_pixels']+=1
   # All SMS levels0/85/170/255 map exactly through GBC5bit endpoints used here.
   assert hashlib.sha256(native.tobytes()).hexdigest()==record['native_sha256'],record['name']
   if enemy in(1,19,58,60,72,73)and record['frame']==103:shot('weapon-'+str(enemy))
   command(9)
   if base_count:check_asset(initial[enemy],120)
   else:assert all(e.memory[0xfe00+i*4]==0 for i in range(40))
   report['weapon_assets']+=1
  magic=json.loads((ROOT/'assets/enemy-magic/manifest.json').read_text());magic_patterns=(ROOT/'assets/enemy-magic/patterns.2bpp').read_bytes()
  for record in magic['records']:
   if record['kind']!='pose':continue
   command(1,enemy=record['enemy'],type=0,palette=record['palette']);background=bg();command(5,clip=record['frame']);check_asset(record,120,2);check_flash(record,2)
   assert protected()==keep and bg()==background;report['magic_assets']+=1
  poses={(r['enemy'],r['frame']):(r,True)for r in animations['records']if not r['palette']}
  poses.update({(r['enemy'],r['frame']):(r,2)for r in magic['records']if r['kind']=='pose'and not r['palette']})
  motions={r['enemy']:r for r in magic['motions']}
  for record in magic['records']:
   if record['kind']!='effect':continue
   enemy=record['enemy'];motion=motions[enemy];seq=motion['sequence'];pose=seq[seq.index(0,1)-1];base_record,kind=poses[(enemy,pose)]
   command(1,enemy=enemy,type=1,palette=0);command(5,clip=pose);background=bg();command(10,clip=record['frame'])
   data=(ROOT/'assets/enemy-magic'/f'{record["name"]}.bin').read_bytes();count=record['sprites'];base_count=base_record['sprites']
   base=(ROOT/('assets/enemy-magic'if kind==2 else'assets/battle-animation')/f'{base_record["name"]}.bin').read_bytes();positions=[]
   for i in range(count):
    x,y,pair,attr=struct.unpack_from('<BBHB',data,i*5);pattern=bytearray(magic_patterns[pair*32:pair*32+32]);tile=84+(base_count+i)*2
    for line in range(max(0,120-(y-16)),16):pattern[line*2:line*2+2]=b'\0\0'
    assert bytes(e.memory[1,0x8000+tile*16:0x8000+tile*16+32])==pattern
    assert tuple(e.memory[0xfe00+i*4:0xfe04+i*4])==(y,x,tile,attr);positions.append((x,y));report['magic_pattern_bytes']+=32
   for i in range(base_count):
    x,y,pair,attr=struct.unpack_from('<BBHB',base,i*5);oam=0xfe00+(i+count)*4
    assert tuple(e.memory[oam:oam+4])==(y,x,84+i*2,attr);positions.append((x,y))
   assert obj_colors()[:48]==base[base_count*5:base_count*5+48]and obj_colors()[48:]==data[-16:]
   assert len(positions)<=40 and max(sum(y-16<=line<y for x,y in positions)for line in range(120))<=10
   expected=reference_weapon(source,motion['effect'],record['frame'],enemy,True)
   assert hashlib.sha256(expected.tobytes()).hexdigest()==record['source_sha256']
   expected=expected.resize((160,120),Image.Resampling.NEAREST);native=Image.new('RGBA',(160,120));palette=struct.unpack('<8H',data[-16:])
   for i in range(count):
    x,y,pair,attr=struct.unpack_from('<BBHB',data,i*5);pattern=magic_patterns[pair*32:pair*32+32];pal=(attr&7)-6
    for row in range(16):
     for col in range(8):
      if y-16+row>=120:continue
      code=(pattern[row*2]>>(7-col)&1)|((pattern[row*2+1]>>(7-col)&1)<<1);point=(x-8+col,y-16+row)
      assert bool(code)==bool(expected.getpixel(point)[3])
      if code:
       color=palette[pal*4+code];rgb=tuple((0,85,170,255)[min(range(4),key=lambda v:abs((0,10,21,31)[v]-((color>>shift)&31)))]for shift in (0,5,10));native.putpixel(point,(*rgb,255));report['magic_source_pixels']+=1
   assert hashlib.sha256(native.tobytes()).hexdigest()==record['native_sha256']
   assert protected()==keep and bg()==background
   if record['frame']in(73,124):shot('enemy-magic-'+str(enemy))
   command(9);check_asset(base_record,120,kind);report['magic_assets']+=1
  boss=json.loads((ROOT/'assets/boss-effects/manifest.json').read_text());boss_patterns=(ROOT/'assets/boss-effects/patterns.2bpp').read_bytes();report['boss_poses']=0;report['boss_patch_cells']=0
  for record in boss['poses']:
   command(1,enemy=record['enemy'],type=30 if record['enemy']==72 else 32,palette=0);background=bg()
   command(11,clip=record['frame'],palette=record['y']);check_asset(record,120,3)
   data=(ROOT/'assets/boss-effects'/f'{record["name"]}.bin').read_bytes();count=record['sprites'];colors=data[count*5:count*5+64];expected=bytearray(colors)
   for pal,mask in enumerate(data[count*5+64:count*5+72]):
    for code in range(1,4):
     if mask>>code&1:expected[(pal*4+code)*2:(pal*4+code)*2+2]=b'\xff\x7f'
   command(6,clip=1);assert obj_colors()==expected;command(6,clip=0);assert obj_colors()==colors
   assert protected()==keep and bg()==background;report['boss_poses']+=1
   if record['frame']in(243,138):shot('boss-motion-'+str(record['enemy']))
   command(11,clip=0,palette=record['y']);assert all(e.memory[0xfe00+i*4]==0 for i in range(40))
  command(1,enemy=73,type=32,palette=0);original=bg()
  for patch in(1,2,0):
   command(12,clip=patch);data=(ROOT/f'assets/boss-effects/patch-{patch}.bin').read_bytes()
   for i,cell in enumerate(boss['patch_cells']):
    address=0x9000+(cell if cell<128 else cell-256)*16
    assert bytes(e.memory[0,address:address+16])==data[i*17:i*17+16]
    assert e.memory[1,0x9800+cell//20*32+cell%20]==data[i*17+16];report['boss_patch_cells']+=1
   assert protected()==keep
  assert bg()==original,'Original Dark Falz rectangle restored'
  gold=json.loads((ROOT/'assets/gold-scene/manifest.json').read_text());gold_data=(ROOT/'assets/gold-scene/scene.bin').read_bytes();report['gold_phase_cases']=[]
  def bg_colors():
   result=[]
   for i in range(56):e.memory[0xff68]=i;result.append(e.memory[0xff69])
   return bytes(result)
  def transition(c,clip):
   before=e.screen.ndarray.copy();frames=[];e.memory[sym['probe_clip']]=clip;e.memory[sym['probe_command']]=c
   for _ in range(500):
    e.tick(1);frames.append(e.screen.ndarray.copy())
    if not val('probe_command'):break
   else:raise AssertionError(('Gold/flash timeout',c,clip))
   for _ in range(3):e.tick(1);frames.append(e.screen.ndarray.copy())
   import numpy as np
   after=frames[-1];assert all(np.array_equal(frame,before)or np.array_equal(frame,after)for frame in frames),(c,clip,'mixed PPUframe')
   return len(frames)
  command(1,enemy=70,type=14,palette=0);gold_base_bg=bg();gold_base_obj=obj_colors()
  for cell in range(300):
   tile=gold_data[gold['map_offset']+cell];attr=gold_data[gold['map_offset']+300+cell];at=0x9800+cell//20*32+cell%20
   assert (e.memory[0,at],e.memory[1,at])==(tile,attr)
   assert bytes(e.memory[0,0x9000+tile*16:0x9010+tile*16])==gold_data[tile*16:tile*16+16]
  for phase in(0,1,2):
   frames=transition(13,phase);assert bg_colors()==gold_data[gold['palette_offset']+phase*56:gold['palette_offset']+(phase+1)*56]
   assert obj_colors()==gold_base_obj and protected()==keep and bg()==gold_base_bg
   shot('gold-phase-'+str(phase));report['gold_phase_cases'].append({'phase':phase,'physical_frames':frames,'mixed_frames':0})
  for cmd in(15,16):
   for white in(1,0):report['gold_phase_cases'].append({'flash_command':cmd,'white':white,'physical_frames':transition(cmd,white),'mixed_frames':0})
  transition(14,0);assert bg_colors()==gold_data[gold['palette_offset']:gold['palette_offset']+56]and obj_colors()==b'\0\x7c'*32;shot('gold-blue-outcome')
  command(2);assert bg_colors()==gold_data[gold['palette_offset']:gold['palette_offset']+56]and all(e.memory[0xfe00+i*4]==0 for i in range(40));shot('gold-blue-cleared')
  for enemy,kind in ((72,30),(73,32)):
   command(1,enemy=1,type=kind,palette=0);expected=bg()
   command(1,enemy=enemy,type=kind,palette=0);assert bg()!=expected;shot('boss-'+str(enemy))
   command(2);assert bg()==expected;assert protected()==keep;shot('boss-'+str(enemy)+'-cleared')
  for group in range(11):
   for nibble in range(16):
    expected=nibble
    if group==0 and expected==5:expected=4
    elif group in (1,7) and expected==1:expected=5
    elif group==8:expected=6
    elif group==10 and expected==9:expected=8
    command(4,type=group,palette=nibble<<4);assert val('probe_error')==(expected or 1);report['map_remaps']+=1
  # Independently composed source tilemap+sprites must equal the transparent overlay.
  for enemy in range(1,75):
   if enemy in (72,73):continue
   overlay=source_overlay(source,enemy=enemy)
   for kind in (1,6):
    actual=source.compose(kind)[0].convert('RGBA');actual.alpha_composite(overlay)
    assert actual.convert('RGB').tobytes()==source.compose(kind,enemy=enemy)[0].tobytes(),(enemy,kind)
    report['source_composites']+=1
  # Sound selection uses enemy visual indirection, not enemy-number indexing.
  import re
  table=(ROOT/'src/audio_tables.c').read_text().split('audio_enemy_sfx[74]={')[1].split('}')[0]
  sounds=list(map(int,table.split(',')))
  for enemy in range(1,75):
   visual=source_rom[label('B03_EnemyData')+enemy*32+19]
   assert sounds[enemy-1]==source_rom[label('LABEL_B03_8FC7')+(visual-1)*24+23]
   report['source_sfx_records']+=1
  report.update(passed=True,rom_sha256=hashlib.sha256(rom.read_bytes()).hexdigest(),header=cartridge_header(rom),scope='All extracted initial-pose/floor variants native VRAM/OAM and source background preservation, original boss clearing, window clipping, source composition and sound-descriptor lookup. Includes all extracted physical attack pose assets; source motion timing is verified separately. Includes104ordinary enemy magic records,39boss poses and30Dark Falz patch-cell writes/restoration with exact existing palettes. Actor choreography, remaining victory/death details and campaign completion have separate evidence.')
  (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
 finally:e.stop(False)
if __name__=='__main__':main()
