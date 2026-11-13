#!/usr/bin/env python3
"""Run production move_player body against original Z80 7143.

Collision is a supplied truth table in both kernels; rendering/triggers/audio
are observed stubs. This isolates source direction priority, held buttons,
movement boundary lengths, wraparound and the D6 no-direction boundary.
"""
from pathlib import Path
import ctypes as C,hashlib,json,subprocess,sys
ROOT=Path(__file__).resolve().parents[4];WORK=Path(__file__).resolve().parents[1]
sys.path[:0]=[str(ROOT/'tools'),str(WORK/'tools')]
import z80
from verify_party_source import call
from extract_assets import ROM_SHA256
def main():
 text=(WORK/'src/main.c').read_text();body=text[text.index('static void move_player(uint8_t keys) {'):text.index('static void return_from_notice')].replace('static void move_player','void move_player')
 wrapper=r'''
#include <stdint.h>
#define J_RIGHT 1u
#define J_LEFT 2u
#define J_UP 4u
#define J_DOWN 8u
#define J_A 16u
#define J_B 32u
#define WORLD_PIXEL_HEIGHT 1536u
uint16_t player_x,player_y;
uint8_t game_vehicle,step_remaining,facing,world_ice_changed,world_group_id;
uint8_t allowed,sounds,checks,moved,remain,requested;
int8_t step_dx,step_dy;uint8_t game_rpg;
uint8_t world_step_allowed(uint16_t x,uint16_t y,uint8_t face,uint8_t vehicle){(void)x;(void)y;(void)vehicle;++checks;return (allowed>>(face<2u?face^1u:face))&1u;}
void audio_command(uint8_t c){if(c==0xd6)++sounds;}
void redraw_world(uint8_t force){(void)force;}
void draw_player(void){}
void party_world_tick(uint8_t a,uint8_t b,uint8_t c){moved=a;remain=b;requested=c;}
uint8_t check_trigger(void){return 0;}
uint8_t world_meta_at(uint16_t x,uint16_t y){(void)x;(void)y;return 0;}
uint8_t rpg_world_encounter(void*p,uint8_t g,uint16_t x,uint16_t y,uint8_t m,uint8_t v){(void)p;(void)g;(void)x;(void)y;(void)m;(void)v;return 0;}
void begin_battle(uint8_t e,uint8_t from){(void)e;(void)from;}
'''
 out=WORK/'evidence';(out/'movement-production-body.c').write_text(wrapper+body)
 subprocess.run(['cc','-shared','-fPIC','-O2',str(out/'movement-production-body.c'),'-o',str(out/'movement.dylib')],check=True)
 lib=C.CDLL(str(out/'movement.dylib'));lib.move_player.argtypes=[C.c_uint8]
 def put(name,value,word=False):(C.c_uint16 if word else C.c_uint8).in_dll(lib,name).value=value
 def get(name,word=False):return(C.c_uint16 if word else C.c_uint8).in_dll(lib,name).value
 rom=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes();assert hashlib.sha256(rom).hexdigest()==ROM_SHA256
 #74E4 returns Z for admitted directions, preserving BC/DE/HL. Source A is
 #2/4/6/8. Only collision and display upload work are substituted.
 collision=bytes.fromhex('c5d5e56f26001100d0197eb7e1d1c1c9')
 cases=ticks=0
 for vehicle in(0,4,8,12):
  for allowed in range(16):
   for held in range(16):
    for origin in((1688,304),(0,0),(2040,1528)):
     c=z80.Z80Machine();c.memory[:0x8000]=rom[:0x8000];c.memory[0x74e4:0x74e4+len(collision)]=collision
     for a in(0x723d,0x733a,0x72a6):c.memory[a]=0xc9
     for d in range(4):c.memory[0xd002+d*2]=0 if allowed>>d&1 else 1
     c.memory[0xc30e]=vehicle;c.memory[0xc301:0xc303]=origin[0].to_bytes(2,'little');c.memory[0xc305]=origin[1]%192;c.memory[0xc306]=origin[1]//192;c.set_breakpoint(0x100)
     put('player_x',origin[0],True);put('player_y',origin[1],True);put('game_vehicle',vehicle);put('step_remaining',0);put('facing',0);put('sounds',0);put('allowed',allowed)
     key=(4 if held&1 else 0)|(8 if held&2 else 0)|(2 if held&4 else 0)|(1 if held&8 else 0)
     # B is held throughout the first source movement; it must never alter
     # speed. Release directions mid-step, then test the stop boundary.
     for n in range(35):
      h=held if n<5 else 0;c.memory[0xc204]=h;c.memory[0xc004]=0
      call(c,0x7143);before=get('sounds');lib.move_player((key if n<5 else 0)|32)
      wantx=int.from_bytes(c.memory[0xc301:0xc303],'little');wanty=c.memory[0xc306]*192+c.memory[0xc305]
      actual=(get('player_x',True),get('player_y',True));assert actual==(wantx,wanty),(vehicle,allowed,held,origin,n,actual,(wantx,wanty))
      assert get('step_remaining')==c.memory[0xc265]*(2 if vehicle else 1),(vehicle,allowed,held,n,'remaining')
      assert (get('sounds')!=before)==(c.memory[0xc004]==0xd6),(vehicle,allowed,held,n,'D6')
      if not vehicle:
       assert(get('moved'),get('remain'),get('requested'))==(c.memory[0xc264]&15,c.memory[0xc265],h),(vehicle,allowed,held,n,'actor inputs')
      ticks+=1
     cases+=1
 report=dict(passed=True,original_sha256=ROM_SHA256,production_move_player_sha256=hashlib.sha256(body.encode()).hexdigest(),cases=cases,logical_ticks=ticks,controls='B held throughout does not accelerate. Foot1px/16ticks; all3 vehicles2px/8ticks. Source direction fallback, mid-step release, wrapped coordinates and repeated blocked/idle D6 match original7143.',limits=['Collision results are supplied identically; full source terrain collision already has its own world_rules suite. Main menu dispatch is tested separately in native integration.'])
 (out/'movement-source.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
