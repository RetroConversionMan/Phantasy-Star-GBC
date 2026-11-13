#!/usr/bin/env python3
"""Trace original item message/audio/state order; this is source evidence, not port validation."""
from pathlib import Path
import hashlib,json
import z80
from extract_enemies import SYMBOLS,SHA
ROOT=Path(__file__).resolve().parents[1]
ROM=(ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
assert hashlib.sha256(ROM).hexdigest()==SHA
ADDR=lambda name:SYMBOLS[name][1]
TEXT={cpu:int(name.rsplit('_',1)[1],16) for name,(bank,cpu) in SYMBOLS.items() if name.startswith('LABEL_B12_')}
ITEMS={'Cola':36,'Burger':37,'Escaper':40,'Wand':4,'MagicHat':42,'Sphere':46}

def trace(name,actor=0,alive=True,hp=7,maxhp=100,chance=1,interaction=1,blocked=False,flags=0x80,attack=50,enemy_attack=50,seed=0x733c):
    c=z80.Z80Machine();c.memory[:0x8000]=ROM[:0x8000]
    item=ITEMS[name];p=0xc400+16*actor
    c.memory[p]=int(alive);c.memory[p+1]=hp;c.memory[p+6]=maxhp
    c.memory[0xc408]=attack;c.memory[0xc448]=enemy_attack
    c.memory[0xc29d]=255;c.memory[0xc29e]=interaction;c.memory[0xc267]=actor
    c.memory[0xc2c4]=item;c.memory[0xc2e7]=chance;c.memory[0xc2e8]=flags
    c.memory[0xc4c0:0xc4c3]=bytes((item,53,0));c.memory[0xc4e2]=2
    c.memory[0xc29b:0xc29d]=bytes((0xc0,0xc4));c.memory[0xc20c:0xc20e]=seed.to_bytes(2,'little')
    c.pc=ADDR('ItemUse_'+name);c.sp=0xdffc;c.memory[0xdffc:0xdffe]=b'\0\1'
    hooks={ADDR('ShowDialogue_B12'):'text',ADDR('LABEL_3464'):'close',ADDR('LABEL_687A'):'escape_geometry'}
    sounds={i for i in range(0x8000-3) if ROM[i:i+3]==b'\x32\x04\xc0'}
    for at in [0x100,*hooks,*sounds]:c.set_breakpoint(at)
    events=[]
    def state():
        return {'hp':c.memory[p+1],'count':c.memory[0xc4e2],'inventory':list(c.memory[0xc4c0:0xc4c2]),'actor':c.memory[0xc267],'rng':int.from_bytes(c.memory[0xc20c:0xc20e],'little')}
    for _ in range(100):
        c.ticks_to_stop=100000;c.run()
        if c.pc==0x100:break
        before=state()
        if c.pc in sounds:
            events.append({'kind':'sound','value':f'{c.a:02X}',**before})
            c.memory[0xc004]=c.a;c.pc+=3;continue
        assert c.pc in hooks,('unexpected source stop',name,hex(c.pc))
        hook=hooks[c.pc]
        if hook=='text':events.append({'kind':'text','value':f'{TEXT[c.hl]:04X}',**before})
        elif hook=='close':events.append({'kind':'close',**before})
        else:c.f=(c.f&~64)|(0 if blocked else 64)
        c.pc=int.from_bytes(c.memory[c.sp:c.sp+2],'little');c.sp+=2
    else:raise AssertionError(('Original item did not return',name,hex(c.pc)))
    return {'item':name,'inputs':dict(actor=actor,alive=alive,hp=hp,maxhp=maxhp,chance=chance,interaction=interaction,blocked=blocked,flags=flags,attack=attack,enemy_attack=enemy_attack,seed=seed),'events':events,'final':state()}

def tokens(t):return [(e['kind'],e.get('value')) for e in t['events']]
def main():
    cases=[]
    for name,amount in [('Cola',10),('Burger',40)]:
        for actor in range(4):
            for alive in (False,True):
                for hp,maxhp in ((7,100),(95,100),(250,255),(100,100)):
                    t=trace(name,actor=actor,alive=alive,hp=hp,maxhp=maxhp);cases.append(t)
                    assert tokens(t)==([('text','B2AC'),('text','B1D0'),('sound','C1'),('close',None)] if alive else [('text','B730'),('close',None)]),t
                    assert all(e['hp']==hp and e['count']==2 for e in t['events'][:3]),t
                    expected=min(hp+amount,255,maxhp) if alive else hp
                    assert t['final']['hp']==expected and t['final']['count']==(1 if alive else 2),t
                    if alive:assert t['events'][-1]['hp']==expected and t['events'][-1]['count']==2
    for name in ('Wand','Escaper'):
        for chance in (0,1,255):
            for interaction in (0,1):
                for blocked in (False,True):
                    t=trace(name,chance=chance,interaction=interaction,blocked=blocked);cases.append(t)
                    success=bool(chance and (interaction or not blocked))
                    assert tokens(t)==[('text','B2AC')]+([('sound','BC'),('text','B25F')] if success else [('text','B2CD')])+[('close',None)],t
                    assert all(e['count']==(1 if name=='Escaper' else 2) for e in t['events']),t
                    assert t['final']['actor']==(5 if success else 0),t
                    assert t['events'][-1]['actor']==0,t
    for name in ('MagicHat','Sphere'):
        for flags in (0,0x40,0x80,0xc0):
            for attack in (49,50,51):
                for seed in (0,1,0x733c,65535):
                    t=trace(name,flags=flags,attack=attack,seed=seed);cases.append(t)
                    success=bool(flags and (name=='Sphere' or not flags&0x40 or attack>=50));monster=bool(flags&0x40)
                    tok=tokens(t);assert tok[0]==('text','B2AC') and all(e['count']==1 for e in t['events']),t
                    if not success:
                        assert tok==[('text','B2AC'),('text','B13D'),('close',None)] and t['final']['actor']==4,t
                    else:
                        table=ADDR('LABEL_1B73' if monster else 'LABEL_198A')
                        replies={f'{TEXT[int.from_bytes(ROM[table+i*2:table+i*2+2],"little")]:04X}' for i in range(10 if monster else 9)}
                        assert tok[:(3 if monster else 2)]==([('text','B2AC'),('sound','AC'),('text','B132')] if monster else [('text','B2AC'),('text','B132')]),t
                        reply=t['events'][3 if monster else 2];assert reply['kind']=='text' and reply['value'] in replies,t
                        assert tok[-(2 if monster else 1):]==([('sound','D5'),('close',None)] if monster else [('close',None)]),t
                        assert t['final']['actor']==6,t
    out=ROOT/'build/research/battle-item-timeline';out.mkdir(parents=True,exist_ok=True)
    (out/'traces.json').write_text(json.dumps(cases,indent=2)+'\n')
    report={'source_sha256':SHA,'source_cases_passed':len(cases),'item_handlers':list(ITEMS),'hooks':['Dialogue recorded at entry and returned without waiting','UI close recorded and returned','LABEL687A geometry Z flag supplied explicitly; independent geometry tests cover its logic'],'original_executed':['Item handler control flow','Alive checks and HP saturation','Inventory removal and movement','Escape/talk flags and outcome transitions','Original RNG and reply-table selection','Sound command stores'], 'port_validated':False,'presentation_gaps_pending':['Use-item prefix for food/Wand/Escaper/Hat/Sphere','C1 after healed text','BC before escape text','Monster-only AC and D5','Failed Hat/Sphere retain use-item prefix'],'state_chronology_note':'Current battle kernel computes final action state before playback. These traces record original commit boundaries; visual/audio ordering alone does not prove runtime state ordering.'}
    (out/'report.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
