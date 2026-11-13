#!/usr/bin/env python3
"""Extract original dialogue, validating assembly directives against pinned ROM bytes.

No English rewrite: expand dictionary bytes, preserve controls/dynamic placeholders,
and follow fall-through labels until the actual source terminator.
"""
import ast
import hashlib
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SHA = '9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'

def extract():
    rom = (ROOT/'upstream/ps1disasm/ps1original.sms').read_bytes()
    assert hashlib.sha256(rom).hexdigest() == SHA
    source = (ROOT/'upstream/ps1disasm/ps1.asm').read_text()
    sound = (ROOT/'upstream/ps1disasm/sound/sound_driver.asm').read_text()
    symbols = {}
    for line in (ROOT/'build/sms-reference/ps1built.sym').read_text().splitlines():
        m = re.fullmatch(r'([0-9a-fA-F]+):([0-9a-fA-F]+) (\w+)', line)
        if m: symbols[m[3]] = (int(m[1],16), int(m[2],16))
    constants = {m[1]:int(m[2],16) for m in re.finditer(r'^\.define\s+(\w+)\s+\$([0-9a-fA-F]+)', (ROOT/'upstream/ps1disasm/ps1.constants.asm').read_text(), re.M)}
    def offset(bank, address): return bank*0x4000 + address%0x4000
    def byte(bank,address): return rom[offset(bank,address)]
    def word(bank,address): return byte(bank,address) | byte(bank,address+1)<<8
    def directive(text, width):
        result = bytearray()
        for token in re.findall(r'"(?:\\.|[^"\\])*"|;.*|[^,\s;]+', text):
            if token.startswith(';'): break
            if token.startswith('"'): result.extend(ast.literal_eval(token).encode('ascii'))
            else:
                value = int(token[1:],16) if token.startswith('$') else constants[token] if token in constants else symbols[token][1]
                result.extend(value.to_bytes(width,'little'))
        return result
    verified = 0
    # Entire contiguous bank2 text/dictionary block, including all pointer aliases.
    address = 0x8000
    section = source.split('DialogueBlock:',1)[1].split('.BANK 3',1)[0]
    for line in section.splitlines():
        m = re.match(r'\s*\.d([bw])\s+(.+)',line,re.I)
        if not m: continue
        data = directive(m[2],1 if m[1].lower()=='b' else 2)
        assert rom[offset(2,address):offset(2,address)+len(data)] == data, hex(address)
        address += len(data); verified += len(data)
    # All B12 dialogue labels whose first directive is text/control (exclude code).
    service = {}
    for m in re.finditer(r'^(LABEL_B12_[0-9A-F]+):\s*\n((?:\.db[^\n]*\n)+)',sound,re.M):
        if 'Dialogue_' not in m[2] and 'Word_' not in m[2]: continue
        bank,addr = symbols[m[1]]
        if bank != 12: continue
        data = b''.join(directive(line[4:],1) for line in m[2].splitlines())
        assert rom[offset(bank,addr):offset(bank,addr)+len(data)] == data, m[1]
        service[addr] = m[1]; verified += len(data)
    dictionary = []
    for i in range(128):
        addr = word(2,symbols['DialogueWordBlock'][1]+2*i)
        out = bytearray()
        while byte(2,addr) != 0x65:
            c=byte(2,addr); assert c < 0x80; out.append(c); addr+=1
        dictionary.append(out)
    def decode(bank,addr):
        out=bytearray()
        while True:
            c=byte(bank,addr); addr+=1
            if c>=128: out.extend(dictionary[c&127])
            else: out.append(c)
            if 0x62<=c<=0x65: return bytes(out)
            assert len(out)<4096
    records=[]
    for index in range(2,0x2ab,2):
        addr=word(2,0x8000+index-2)
        assert addr==symbols[f'Dialogue_Index_{index:04X}'][1]
        records.append((index,2,addr,decode(2,addr)))
    for addr in sorted(service): records.append((addr,12,addr,decode(12,addr)))
    narrative=[]
    for name in re.findall(r'^(LABEL_B[0-9A-F]+):',source.split('LABEL_B49B:',1)[1].split('DialogueWordBlock:',1)[0],re.M):
        bank,addr=symbols[name];assert bank==2
        narrative.append((name,addr))
    narrative.insert(0,('LABEL_B49B',symbols['LABEL_B49B'][1]))
    for name,addr in narrative:records.append((0xc000+(addr-0x8000),2,addr,decode(2,addr)))
    (ROOT/'src/story_text_ids.h').write_text('/* Original bank2 direct narrative labels in a distinct native ID range. */\n#ifndef PS_STORY_TEXT_IDS_H\n#define PS_STORY_TEXT_IDS_H\n'+''.join(f'#define STORY_TEXT_{name[6:]} 0x{0xc000+addr-0x8000:04x}u\n' for name,addr in narrative)+'#endif\n')
    # Each text stays within one bank. Every byte remains original except dictionary expansion.
    chunks=[bytearray()]; refs=[];text_banks=[9,10,77]
    for index,bank,addr,data in records:
        if len(chunks[-1])+len(data)>15000: chunks.append(bytearray())
        refs.append((index,text_banks[len(chunks)-1],len(chunks[-1]),len(data),data[-1]))
        chunks[-1].extend(data)
    assert len(chunks)<=3
    src=ROOT/'src'; assets=ROOT/'assets/dialogue'; assets.mkdir(parents=True,exist_ok=True)
    for i,data in zip(text_banks,chunks):
        body='\n'.join(','.join(f'0x{x:02x}' for x in data[n:n+24])+',' for n in range(0,len(data),24))
        (src/f'dialogue_text_{i:02d}.c').write_text(f'/* Generated from verified original ROM. */\n#ifdef __SDCC\n#pragma bank {i}\n#endif\n#include <stdint.h>\nconst uint8_t dialogue_text_{i:02d}[]={{\n{body}\n}};\n')
    declarations=''.join(f'extern const uint8_t dialogue_text_{i:02d}[];\n' for i in text_banks[:len(chunks)])
    body='\n'.join(f'{{0x{index:04x},{bank},dialogue_text_{bank:02d}+{offset_},{length},0x{term:02x}}},' for index,bank,offset_,length,term in refs)
    # Item name strings are fixed eight-byte fields, 0x65 pads/terminates.
    names=[]
    for i in range(65):
        b,a=symbols['ItemNames']; raw=rom[offset(b,a)+i*8:offset(b,a)+(i+1)*8]
        name=raw.split(b'\x65')[0].decode('ascii').replace('@',"'")
        names.append(name)
    names_c=','.join(json.dumps(n) for n in names)
    # Only exact two-instruction source handlers qualify for automatic native dispatch.
    table=source.split('LABEL_4773:',1)[1].split('LABEL_48DF:',1)[0]
    handlers=re.findall(r'\.dw\s+(\w+)',table)
    simple=[]
    for handler in handlers:
        match=re.search(r'^'+handler+r':\s*\n\s*ld\s+hl,\s*\$([0-9A-Fa-f]+)\s*\n\s*jp\s+ShowDialogue_B2\s*\n',source,re.M)
        simple.append(int(match[1],16) if match else 0)
    (src/'dialogue_data.c').write_text('/* Generated by tools/extract_dialogue.py. */\n#ifdef __SDCC\n#pragma bank 8\n#endif\n#include "dialogue.h"\n'+declarations+f'const DialogueRef dialogue_refs[{len(refs)}]={{\n'+body+'\n};\n'+f'const uint16_t dialogue_ref_count={len(refs)};\nconst char dialogue_items[65][9]={{'+names_c+'};\n')
    (src/'events_data.c').write_text('/* Exact two-instruction original event handlers; zero means native branching required. */\n#ifdef __SDCC\n#pragma bank 7\n#endif\n#include <stdint.h>\nconst uint16_t event_simple_dialogue['+str(len(simple)+1)+']={0,'+','.join(hex(x) for x in simple)+'};\n')
    report={'source_sha256':SHA,'assembly_bytes_verified':verified,'story_references':341,'service_references':len(service),'expanded_bytes':sum(map(len,chunks)),'text_banks':text_banks[:len(chunks)],'narrative_references':len(narrative),'native_simple_event_handlers':sum(bool(x) for x in simple),'event_count':len(simple)}
    (assets/'manifest.json').write_text(json.dumps(report,indent=2)+'\n')
    (assets/'decoded.json').write_text(json.dumps([{'id':index,'sms_bank':bank,'sms_address':addr,'expanded_hex':data.hex()} for index,bank,addr,data in records],indent=2)+'\n')
    print(json.dumps(report,indent=2))
    return records,refs,simple

if __name__=='__main__': extract()
