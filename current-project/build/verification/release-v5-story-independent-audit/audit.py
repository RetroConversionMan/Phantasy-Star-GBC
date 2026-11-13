"""Read-only completed-story evidence audit; never creates an emulator."""
from pathlib import Path
from collections import Counter
import ast
import binascii
import hashlib
import json
from PIL import Image, ImageChops

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
RUN = ROOT/'build/campaign/release-v5-newgame-b72feead'
OLD = ROOT/'build/campaign/release-v4-newgame-55b71a17'
MILESTONE = ROOT/'build/milestones/release-v5-campaign-story-20261113'
ROM_SHA = 'b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    return json.loads(path.read_text())


def main():
    assert not (OUT/'report.json').exists(), 'Preserve the accepted audit; use a new output for another audit'
    manifest = read(RUN/'SHA256.json')
    assert sha(RUN/'SHA256.json') == '27a748fa2877af0def9b7267df318f383175c2258e27dd736383b65949797457'
    assert len(manifest) == 443 and all(sha(RUN/name) == value for name, value in manifest.items())
    assert {str(p.relative_to(RUN)) for p in RUN.rglob('*') if p.is_file()} == set(manifest)|{'SHA256.json'}
    marker, report, prefix = (read(RUN/name) for name in ('CAMPAIGN_CLOSED.json', 'report.json', 'PREFIX_REPLAY_PROOF.json'))
    named = {'campaign.gbc': 'rom_sha256', 'campaign.noi': 'symbols_sha256',
             'controller.jsonl': 'controller_sha256', 'report.json': 'report_sha256',
             'campaign.gbc.ram': 'sram_sha256'}
    assert marker['schema'] == 1 and marker['closed'] and marker['campaign_complete']
    assert all(sha(RUN/name) == marker[key] for name, key in named.items())
    assert marker['rom_sha256'] == report['header']['sha256'] == ROM_SHA
    assert sha(ROOT/'build/phantasy-star-gbc-world.gbc') == ROM_SHA
    assert marker['final_frame'] == report['latest']['frame'] == 3581580
    assert marker['checkpoint_count'] == len(report['checkpoints']) == 484
    assert report['campaign_complete'] and not report['injected_fixtures'] and not report.get('save_continuation')

    raw = (RUN/'controller.jsonl').read_bytes()
    lines = raw.splitlines(keepends=True)
    assert all(line.endswith(b'\n') for line in lines)
    events = [json.loads(line) for line in lines]
    assert all(a['frame'] <= b['frame'] for a, b in zip(events, events[1:]))
    checkpoint_keys = [(c['name'], c['frame']) for c in report['checkpoints']]
    assert len(set(checkpoint_keys)) == len({c['name'] for c in report['checkpoints']}) == 484
    assert [(e['name'], e['frame']) for e in events if e['kind'] == 'checkpoint'] == checkpoint_keys
    assert [c['name'][:3] for c in report['checkpoints']] == [f'{i:03d}' for i in range(484)]
    assert all(all(key in c for key in ('rng', 'vehicle_cycle', 'fade_clock', 'map_music')) for c in report['checkpoints'])
    held = set()
    for event in events:
        if event['kind'] == 'press':
            assert event['key'] not in held
            held.add(event['key'])
        elif event['kind'] == 'release':
            assert event['key'] in held
            held.remove(event['key'])
    assert not held
    ending = [e for e in events if e['kind'] == 'ending_returned_to_title']
    assert len(ending) == 1 and ending[0]['frame'] == 3581580 and ending[0]['state'] == report['latest']
    assert report['latest']['screen'] == 0
    assert events[-1] == {'frame': 3581580, 'kind': 'story_phase_complete', 'phase': 'final_maze'}
    driver_ast = ast.parse((RUN/'driver-final/run_campaign_story.py').read_text())
    phases = ast.literal_eval(next(n.value for n in driver_ast.body if isinstance(n, ast.Assign)
                                  and any(isinstance(t, ast.Name) and t.id == 'PHASES' for t in n.targets)))
    expected_phases = [phase[0] for phase in phases]
    assert len(expected_phases) == report['story_driver']['next_phase'] == 51
    assert [e['phase'] for e in events if e['kind'] == 'story_phase_complete'] == expected_phases == report['story_driver']['completed']
    assert report['battles'][-1]['enemy'] == 73 and report['battles'][-1]['outcome'] == 1

    old_report = read(OLD/'report.json')
    assert prefix['passed'] and prefix['frames'] == prefix['source_latest_frame'] == 1633795
    assert prefix['checkpoints'] == 352 and prefix['omitted_gameplay_frames'] == 0 and prefix['retries'] == 0
    assert not any(prefix[key] for key in ('initial_sram_loaded', 'save_states_loaded', 'state_injection', 'timing_probe'))
    assert prefix['source_report_sha256'] == sha(OLD/'report.json')
    assert prefix['source_controller_sha256'] == sha(OLD/'controller.jsonl')
    assert prefix['rom_sha256'] == ROM_SHA
    stop = next(i for i, e in enumerate(events) if e['kind'] == 'checkpoint' and e['name'] == prefix['checkpoint'])
    prefix_bytes = b''.join(lines[:stop+1])
    assert hashlib.sha256(prefix_bytes).hexdigest() == prefix['replayed_controller_sha256']
    assert prefix_bytes == b''.join((OLD/'controller.jsonl').read_bytes().splitlines(keepends=True)[:-1])
    assert sha(RUN/prefix['generated_resume_state']) == prefix['generated_resume_state_sha256']
    assert all({k: v for k, v in a.items() if k != 'rom_sha256'} == {k: v for k, v in b.items() if k != 'rom_sha256'}
               for a, b in zip(report['checkpoints'][:352], old_report['checkpoints']))
    inherited = ('battles', 'routes', 'deaths', 'continues', 'failures', 'milestones')
    assert all(report[key][:len(old_report[key])] == old_report[key] for key in inherited)
    assert len(report['battles']) == 1230
    assert sum(b['after']['frame'] <= 1633795 for b in report['battles']) == 501
    assert sum(b['after']['frame'] > 1633795 for b in report['battles']) == 729

    initial_tools, final_tools = read(RUN/'verification-tooling/MANIFEST.json'), read(RUN/'driver-final/MANIFEST.json')
    assert len(initial_tools) == 10 and len(final_tools) == 9
    for folder, files in (('verification-tooling', initial_tools), ('driver-final', final_tools)):
        assert all(sha(RUN/folder/name) == value for name, value in files.items())
    assert set(initial_tools)-set(final_tools) == {'replay_campaign_prefix.py'}
    assert not set(final_tools)-set(initial_tools)
    changed_tools = sorted(name for name in final_tools if initial_tools[name] != final_tools[name])
    assert changed_tools == ['campaign_runner.py', 'verify_campaign_title.py']
    memory_writes, loads, seed_calls = [], [], []
    for folder in ('verification-tooling', 'driver-final'):
        for path in (RUN/folder).glob('*.py'):
            for node in ast.walk(ast.parse(path.read_text())):
                if isinstance(node, (ast.Attribute, ast.Subscript)) and isinstance(node.ctx, (ast.Store, ast.Del)):
                    if any(word in ast.unparse(node) for word in ('memory', 'register_file')):
                        memory_writes.append([folder, path.name, node.lineno])
                if isinstance(node, ast.Call) and isinstance(node.func, ast.Attribute):
                    if node.func.attr == 'load_state':
                        loads.append([folder, path.name, node.lineno])
                    if node.func.attr in ('seed', 'set_memory_value'):
                        seed_calls.append([folder, path.name, node.lineno])
    assert not memory_writes and not seed_calls
    assert loads == [['verification-tooling', 'campaign_runner.py', 41], ['driver-final', 'campaign_runner.py', 41]]
    # Manual review of the exact hashed source accompanies these AST checks:
    # fresh prefix starts in a required-new directory, never loads a state,
    # and full-driver resume must match every latest native snapshot key.
    final_driver = (RUN/'driver-final/run_campaign_story.py').read_text()
    assert "assert all(meta.get(k)==v for k,v in current['latest'].items())" in final_driver
    assert 'e.load_state' not in (RUN/'verification-tooling/replay_campaign_prefix.py').read_text()

    assert len(report['deaths']) == len(report['continues']) == 1 and len(report['failures']) == 2
    death = report['deaths'][0]
    assert death['frame'] == 1613443 and [p[1] for p in death['party']] == [0, 0, 0, 0]
    assert report['continues'][0]['frame'] == 1613883
    failure = read(RUN/'failure-002.json')
    assert failure['rom_sha256'] == ROM_SHA and failure['frame'] == 3037490
    assert report['failures'][1]['state'] == {k: v for k, v in failure.items() if k != 'rom_sha256'}
    assert failure['party'][0][1:3] == [152, 0] and failure['party'][0][10] == 14
    assert failure['object_flags']['203'] == 255 and failure['screen'] == 1 and failure['map'] == 0
    assert all((RUN/('failure'+s)).read_bytes() == (RUN/('failure-002'+s)).read_bytes() for s in ('.state', '.json', '.png'))
    resumes = [e for e in events if e['kind'] == 'resume']
    assert [e['frame'] for e in resumes] == [1613443, 1633795, 3037490]
    assert [Path(e['checkpoint']).name for e in resumes] == ['failure-001.state', '351-torch-continue-aukba-rested.state', 'failure-002.state']
    returned = [e for e in events if e['kind'] == 'source_return_without_fly']
    assert len(returned) == 1 and returned[0]['frame'] == 3037490
    assert sha(RUN/'driver-correction-002-fly-return/campaign_runner.py') == final_tools['campaign_runner.py']
    correction = read(RUN/'driver-correction-002-fly-return/MANIFEST.json')
    assert correction['driver_sha256'] == final_tools['campaign_runner.py'] and correction['frame'] == 3037490

    title = read(RUN/'ENDING_TITLE_VISUAL_PROOF.json')
    ending_image = Image.open(RUN/'ending-returned-to-title.png').convert('RGB')
    boot_image = Image.open(RUN/'title-reference-native-earned-save-boot.png').convert('RGB')
    assert ending_image.size == boot_image.size == (160, 144)
    differences = sum(pixel != (0, 0, 0) for pixel in ImageChops.difference(ending_image, boot_image).get_flattened_data())
    assert differences == title['differing_pixels'] == 0 and title['passed']
    assert title['ending_capture_sha256'] == sha(RUN/'ending-returned-to-title.png')
    assert hashlib.sha256(boot_image.tobytes()).hexdigest() == title['reference_capture']['sha256_pixels']
    assert title['same_cartridge_earned_sram_sha256'] == marker['sram_sha256']
    ram = (RUN/'campaign.gbc.ram').read_bytes()
    assert len(ram) == 8192 and ram[:4] == b'PSG\x05'
    assert binascii.crc_hqx(ram[:626], 0xffff) == int.from_bytes(ram[626:628], 'little')
    milestone = read(MILESTONE/'MANIFEST.json')
    assert all(sha(RUN/name) == value for name, value in milestone['evidence'].items())
    assert sha(MILESTONE/'SUMMARY.md') == milestone['summary_sha256']
    assert milestone['phases'] == 51 and milestone['checkpoints'] == 484 and milestone['final_frame'] == 3581580
    assert 'independent full controller replay is still pending' in (MILESTONE/'SUMMARY.md').read_text().lower()
    assert all(sha(RUN/name) == value for name, value in manifest.items()), 'Story evidence changed during audit'

    inputs = [RUN/name for name in ('SHA256.json', 'CAMPAIGN_CLOSED.json', 'report.json', 'controller.jsonl',
              'ENDING_TITLE_VISUAL_PROOF.json', 'PREFIX_REPLAY_PROOF.json', 'PREFIX_METADATA_PROVENANCE.json',
              'FRESH_START_PROVENANCE.json', 'driver-final/MANIFEST.json', 'verification-tooling/MANIFEST.json',
              'driver-correction-002-fly-return/MANIFEST.json', 'failure-002.json')]
    inputs += [MILESTONE/'MANIFEST.json', MILESTONE/'SUMMARY.md', Path(__file__)]
    result = {
        'passed': True,
        'scope': 'Independent read-only completed-story/provenance/hash/pixel audit. No emulator or broad gameplay suite was rerun. Full independent controller replay remains pending.',
        'rom_sha256': ROM_SHA, 'manifest_files': 443, 'all_manifest_entries_match': True, 'unmanifested_source_files': 0,
        'closed_marker_all_five_hashes_match': True,
        'controller_rows': len(events), 'controller_frames_monotonic': True, 'complete_JSONL_records_only': True,
        'balanced_controller_edges': True, 'pressed_edges': Counter(e['kind'] for e in events)['press'],
        'ordered_unique_checkpoints': 484, 'all51_phase_completions_exact_once': True,
        'DarkFalz73_victory_recorded': True, 'final_title_frame': 3581580, 'final_title_state_matches_report': True,
        'encounter_annotations': {'total': 1230, 'inherited_v4_prefix': 501, 'fresh_b72_continuation': 729,
          'limit': 'Prefix per-battle annotations were inherited, not recollected. B72 independently re-executed the exact input prefix and generated/compared all352 native checkpoint snapshots.'},
        'clean_prefix': {'frames': 1633795, 'checkpoints': 352, 'input_bytes': len(prefix_bytes),
          'zero_omitted_gameplay_frames': True, 'old_SRAM_or_state_loaded': False, 'retries': 0,
          'generated_b72_resume_state_hash_matches': True},
        'driver_provenance': {'initial_prefix_tools': 10, 'final_driver_helpers': 9,
          'initial_only': ['replay_campaign_prefix.py'], 'changed_common_files': changed_tools,
          'runner_change': 'Fly failure return uses native Hovercraft when actual Alis MP is below8; no game/source/state change.',
          'title_helper_change': 'Separate reference boot waits for LCD and native frame-counter progress, then3 frames; no campaign mutation.',
          'gameplay_memory_register_writes': 0, 'seed_writes': 0,
          'resume_annotations': [{'frame': e['frame'], 'file': Path(e['checkpoint']).name} for e in resumes],
          'resume_meaning': 'First is inherited log metadata ignored by clean b72 prefix replay. The two b72 process resumes load only their exact latest same-ROM native-generated states.'},
        'retained_failures': {'natural_full_party_defeats': 1, 'real_Continues': 1,
          'natural_defeat_frame': 1613443, 'Continue_frame': 1613883,
          'runner_Fly_assertion_frame': 3037490, 'Alis_HP_MP_at_assertion': [152, 0],
          'earned_Sword14_and_object203_preserved': True, 'failure_state_duplicates_identical': True,
          'forward_exact_resume_guard_and_log_verified': True, 'earlier_checkpoint_retry': False},
        'title': {'pixels': 23040, 'differing_pixels': differences, 'reference_boot_frames': 304,
          'reference': 'Separate native boot using this same completed cartridge earned SRAM',
          'campaign_memory_or_input_mutated': False},
        'native_save': {'bytes': 8192, 'version': 5, 'record_bytes': 628, 'CRC_valid': True,
          'sha256': marker['sram_sha256']},
        'story_milestone_links_and_summary_hash_match': True,
        'inputs_sha256': {str(p.relative_to(ROOT)): sha(p) for p in inputs},
        'story_complete': True, 'independent_full_replay_complete': False,
        'remaining_acceptance': 'Audit the world agent full replay/final-title evidence and final release/preservation hashes after replay finishes.'}
    (OUT/'report.json').write_text(json.dumps(result, indent=2)+'\n')
    hashes = {p.name: sha(p) for p in sorted(OUT.iterdir()) if p.is_file()}
    (OUT/'SHA256.json').write_text(json.dumps(hashes, indent=2)+'\n')
    print(json.dumps({k: result[k] for k in ('passed', 'rom_sha256', 'manifest_files', 'ordered_unique_checkpoints', 'final_title_frame', 'story_complete', 'independent_full_replay_complete')}, indent=2))


if __name__ == '__main__':
    main()
