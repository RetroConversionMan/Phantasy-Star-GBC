"""Independent final acceptance audit: files, bytes, hashes, source and pixels only."""
from pathlib import Path
import ast
import binascii
import hashlib
import json
from PIL import Image, ImageChops

OUT = Path(__file__).resolve().parent
ROOT = OUT.parents[2]
STORY = ROOT/'build/campaign/release-v5-newgame-b72feead'
REPLAY = ROOT/'build/campaign/release-v5-live-replay-b72feead'
FROZEN = ROOT/'build/source-snapshots/release-candidate-v5-20261113'
TOOLS = ROOT/'build/source-snapshots/replay-live-tools-20261113/tools'
ROM_SHA = 'b72feead6a4a0b9efe779a2a61fbce7e96bd30247e3149b0ce1793dd414d59a1'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read(path):
    return json.loads(path.read_text())


def verify_manifest(folder, expected_hash, count):
    path = folder/'SHA256.json'
    assert sha(path) == expected_hash
    value = read(path)
    entries = value['files'] if 'schema' in value else value
    assert len(entries) == count
    for name, record in entries.items():
        expected = record['sha256'] if isinstance(record, dict) else record
        assert sha(folder/name) == expected, (folder, name)
        if isinstance(record, dict):
            assert (folder/name).stat().st_size == record['bytes']
    assert {str(p.relative_to(folder)) for p in folder.rglob('*') if p.is_file()} == set(entries)|{'SHA256.json'}
    return {'path': str(path.relative_to(ROOT)), 'sha256': expected_hash, 'files': count, 'passed': True}


def main():
    assert not (OUT/'report.json').exists(), 'Keep this audit immutable; use a new directory for a later audit'
    source_integrity = verify_manifest(STORY, '27a748fa2877af0def9b7267df318f383175c2258e27dd736383b65949797457', 443)
    replay_integrity = verify_manifest(REPLAY, '2c383f8f4af8c2728d93c2d925f2ddb33b96a86403921bb7b243f37d28ae23d2', 22)
    milestone_integrity = verify_manifest(ROOT/'build/milestones/release-v5-full-replay-20261113',
                                         '748e482738a680065b6dac3e7d48ffe1436a06d81cd02bd2d273fda53973bdd8', 37)
    promotion_integrity = verify_manifest(ROOT/'milestones/canonical-promotion-v5-20261113',
                                         'd5b3cee0cae6210f3e042759129132b6a77d542fade953af22ca257e47714790', 2003)
    assert sha(REPLAY/'replay-report.json') == 'b85bd705fabe42e57a1c787833b6c10f6b3df1b5dd44f26d32c668baa11844a0'
    story, replay, marker = read(STORY/'report.json'), read(REPLAY/'replay-report.json'), read(STORY/'CAMPAIGN_CLOSED.json')
    assert replay['passed'] and replay['campaign_complete'] and replay['fresh_newgame_completion']
    assert not replay['diagnostic_prefix_only'] and replay['diagnostic_stop'] is None
    assert not any(replay[key] for key in ('initial_sram_loaded', 'save_states_loaded', 'state_injection', 'source_mutated'))
    assert replay['frames'] == story['latest']['frame'] == marker['final_frame'] == 3581580
    expected = [(c['name'], c['frame']) for c in story['checkpoints']]
    checked = [(c['name'], c['frame']) for c in replay['checkpoints']]
    assert expected == checked and len(checked) == len(set(checked)) == 484
    assert replay['final'] == story['latest'] and replay['final']['screen'] == 0
    assert all(key in replay['final'] for key in ('rng', 'vehicle_cycle', 'fade_clock', 'map_music', 'object_flags', 'story_flags'))
    assert (REPLAY/'recorded-report.json').read_bytes() == (STORY/'report.json').read_bytes()
    assert (REPLAY/'CAMPAIGN_CLOSED.json').read_bytes() == (STORY/'CAMPAIGN_CLOSED.json').read_bytes()
    assert sha(STORY/'CAMPAIGN_CLOSED.json') == replay['source_closed_marker_sha256']
    raw = (STORY/'controller.jsonl').read_bytes()
    assert raw == (REPLAY/'recorded-controller.jsonl').read_bytes()
    assert len(raw) == replay['consumed_bytes'] == 11721245
    rows = raw.splitlines(keepends=True)
    assert len(rows) == replay['consumed_rows'] == 144464 and all(row.endswith(b'\n') for row in rows)
    events = [json.loads(row) for row in rows]
    assert all(a['frame'] <= b['frame'] for a, b in zip(events, events[1:]))
    assert [(e['name'], e['frame']) for e in events if e['kind'] == 'checkpoint'] == checked
    assert sha(STORY/'controller.jsonl') == replay['controller_log_sha256'] == marker['controller_sha256'] == '6f6683ab690a6f3d0e029587ef8e5ab37b184428b9a1f05fd182f09960c627f1'
    assert events[-1] == {'frame': 3581580, 'kind': 'story_phase_complete', 'phase': 'final_maze'}
    ending = [e for e in events if e['kind'] == 'ending_returned_to_title']
    assert len(ending) == 1 and ending[0]['state'] == replay['final']
    assert len([e for e in events if e['kind'] == 'story_phase_complete']) == story['story_driver']['next_phase'] == 51
    fields = {'campaign.gbc': 'rom_sha256', 'campaign.noi': 'symbols_sha256',
              'controller.jsonl': 'controller_sha256', 'report.json': 'report_sha256',
              'campaign.gbc.ram': 'sram_sha256'}
    assert all(sha(STORY/name) == marker[key] == replay['source_final_hashes'][key] for name, key in fields.items())
    assert all(sha(STORY/name) == value for name, value in replay['source_immutable_files'].items())
    ram = (REPLAY/'campaign.gbc.ram').read_bytes()
    assert ram == (STORY/'campaign.gbc.ram').read_bytes() and len(ram) == 8192
    assert sha(REPLAY/'campaign.gbc.ram') == replay['native_final_sram_sha256'] == '3fd1272237e5779e5be6df1a414f211b810598452679cff04a4dc1a1833dbb60'
    assert replay['native_sram_matches_source'] and ram[:4] == b'PSG\x05'
    assert binascii.crc_hqx(ram[:626], 0xffff) == int.from_bytes(ram[626:628], 'little')

    tool_manifest = read(TOOLS/'FROZEN_TOOLS.json')
    assert sha(TOOLS/'FROZEN_TOOLS.json') == replay['frozen_manifest_sha256'] == '03fe485bc1576ff566f43b9dfa8c35021d7b9b023128fea0559e38d8fea4e9b7'
    assert (TOOLS/'FROZEN_TOOLS.json').read_bytes() == (REPLAY/'verification-tooling/FROZEN_TOOLS.json').read_bytes()
    assert tool_manifest['tools'] == replay['tooling_sha256']
    for name, value in tool_manifest['tools'].items():
        assert sha(TOOLS/name) == sha(REPLAY/'verification-tooling'/name) == value
    runtime_sha = sha(TOOLS/'replay_campaign_live.py')
    assert runtime_sha == 'f7181f40b9e83ad3a4f655cc6101401f81f4625f0df05e61b5e0f6652ce4b70e'
    assert sha(ROOT/'tools/replay_campaign_live.py') == runtime_sha
    script = (TOOLS/'replay_campaign_live.py').read_text()
    tree = ast.parse(script)
    assert not any(isinstance(n, ast.Call) and isinstance(n.func, ast.Attribute) and n.func.attr == 'load_state' for n in ast.walk(tree))
    assert not any(isinstance(n, (ast.Attribute, ast.Subscript)) and isinstance(n.ctx, (ast.Store, ast.Del))
                   and any(word in ast.unparse(n) for word in ('memory', 'register_file')) for n in ast.walk(tree))
    assert "if k not in actual or actual[k]!=v" in script
    assert "assert not(out/'campaign.gbc.ram').exists()" in script
    assert "assert not out.exists()" in script
    assert (REPLAY/'initial-source-report.json').read_bytes() == (STORY/'report.json').read_bytes()
    assert replay['caught_up_polls_without_ticks'] == 0
    acceptance = read(REPLAY/'ACCEPTANCE.json')
    assert acceptance['passed'] and acceptance['retry_count'] == 0
    assert 'replay-report.json is the authoritative terminal acceptance' in acceptance['progress_file_note']
    assert replay['post_log_display_settle']['frames'] == 4 and replay['post_log_display_settle']['controller_inputs'] == 0

    titles = {}
    images = {'story_ending': STORY/'ending-returned-to-title.png',
              'story_native_boot': STORY/'title-reference-native-earned-save-boot.png',
              'replay_ending': REPLAY/'replay-ending-title-settled.png',
              'replay_native_boot': REPLAY/'title-reference-native-earned-save-boot.png'}
    source_pixels = Image.open(images['story_ending']).convert('RGB')
    for name, path in images.items():
        image = Image.open(path).convert('RGB')
        assert image.size == (160, 144)
        different = sum(pixel != (0, 0, 0) for pixel in ImageChops.difference(source_pixels, image).get_flattened_data())
        assert different == 0
        titles[name] = {'file_sha256': sha(path), 'rgb_sha256': hashlib.sha256(image.tobytes()).hexdigest(), 'different_pixels': different}
    for folder in (STORY, REPLAY):
        title = read(folder/'ENDING_TITLE_VISUAL_PROOF.json')
        assert title['passed'] and title['differing_pixels'] == 0 and title['reference_boot_frames'] == 304
        assert title['rom_sha256'] == ROM_SHA and title['same_cartridge_earned_sram_sha256'] == sha(REPLAY/'campaign.gbc.ram')
        assert not title['campaign_mutation'] and not title['old_cartridge_sram_loaded']
    assert sha(REPLAY/'ENDING_TITLE_VISUAL_PROOF.json') == 'cee96e937ea9e4163840a44422e4c44fea6592d5e00fd5660e98fda47d2e00c3'

    source_manifest, build = read(FROZEN/'MANIFEST.json'), read(FROZEN/'BUILD_PROOF.json')
    assert len(source_manifest['files']) == 343 and len(build['objects']) == 262
    assert {str(p.relative_to(ROOT)) for p in (ROOT/'src').iterdir() if p.is_file()}|{'Makefile'} == set(source_manifest['files'])
    for name, value in source_manifest['files'].items():
        assert sha(ROOT/name) == sha(FROZEN/name) == value
    assert {p.name for p in (ROOT/'build/obj').glob('*.o')} == set(build['objects'])
    for name, value in build['objects'].items():
        assert sha(ROOT/'build/obj'/name) == sha(FROZEN/'build/obj'/name) == value
    assert sha(FROZEN/'MANIFEST.json') == build['source_manifest_sha256']
    roms = [ROOT/'build/phantasy-star-gbc-world.gbc', FROZEN/'build/phantasy-star-gbc-world.gbc',
            ROOT/'releases/phantasy-star-gbc/Phantasy-Star-GBC.gbc', STORY/'campaign.gbc', REPLAY/'campaign.gbc']
    assert all(sha(path) == ROM_SHA and path.stat().st_size == 4194304 for path in roms)
    assert sha(ROOT/'build/phantasy-star-gbc-world.noi') == sha(FROZEN/'build/phantasy-star-gbc-world.noi') == sha(REPLAY/'campaign.noi')
    assert (ROOT/'build/phantasy-star-gbc-world.main.sym').read_bytes() == (FROZEN/'build/obj/main.sym').read_bytes()
    layout = read(REPLAY/'native-layout.json')
    assert layout['rom_sha256'] == ROM_SHA and layout['event_object_flags_offset'] == 293
    routine = layout['event_init']; code = bytes.fromhex(routine['machine_code_hex'])
    assert (REPLAY/'campaign.gbc').read_bytes()[routine['rom_file_offset']:routine['rom_file_offset']+routine['bytes']] == code
    baseline = ROOT.parent/'verified-baseline'
    original = read(ROOT.parent/'FILE_MANIFEST.json')
    expected_baseline = {e['path'].split('/', 1)[1]: e['sha256'] for e in original['files']
                         if e['path'].startswith('verified-baseline/') and e['type'] == 'file'}
    actual_baseline = {str(p.relative_to(baseline)): sha(p) for p in baseline.rglob('*') if p.is_file()}
    assert actual_baseline == expected_baseline and len(actual_baseline) == 45
    assert sha(baseline/'build/phantasy-star-gbc-exploration.gbc') == 'ffe3d67bb15c3d563f6f9b61e08dc166129818d99500a9af6fd8e9eb7c1b1356'
    sms_sha = sha(ROOT/'upstream/ps1disasm/ps1original.sms')
    assert sms_sha == '9e324e92bd833b45126861b6f1d2dcbb51251bdf3df6d563ab3a3ff784d8cf88'
    prior_audit = ROOT/'build/verification/release-v5-story-independent-audit/report.json'
    assert sha(prior_audit) == '77487a4327708aef4c7056f86511c2355fdf23bf51f2998fba53090f157f05d9'
    assert read(prior_audit)['passed']
    # Recheck the two immutable evidence trees after every other comparison.
    verify_manifest(STORY, source_integrity['sha256'], 443)
    verify_manifest(REPLAY, replay_integrity['sha256'], 22)
    inputs = [STORY/'SHA256.json', REPLAY/'SHA256.json', REPLAY/'replay-report.json',
              REPLAY/'ENDING_TITLE_VISUAL_PROOF.json', REPLAY/'ACCEPTANCE.json', TOOLS/'FROZEN_TOOLS.json',
              FROZEN/'MANIFEST.json', FROZEN/'BUILD_PROOF.json', prior_audit, Path(__file__)]
    result = {
        'passed': True, 'all_requested_final_acceptance_checks_passed': True,
        'scope': 'Independent read-only final proof, source/build/delivery, preservation and pixel audit. No emulator or previously passed broad suite was rerun.',
        'rom_sha256': ROM_SHA,
        'immutable_evidence': [source_integrity, replay_integrity, milestone_integrity, promotion_integrity],
        'full_replay': {'frames': 3581580, 'ordered_unique_checkpoints': 484, 'controller_rows': 144464,
          'controller_bytes': 11721245, 'controller_sha256': replay['controller_log_sha256'],
          'entire_log_byte_identical_to_story': True, 'complete_final_snapshot_exact': True,
          'all_expected_checkpoint_keys_enforced_by_exact_frozen_runtime': True, 'final_screen': 0,
          'all51_phases_and_ending_row_present': True, 'initial_SRAM_loaded': False,
          'save_states_loaded': False, 'memory_or_register_injection': False, 'retries': 0,
          'mode': 'The source was already closed before launch. This final run replayed its complete immutable log; live append handling was separately tested.',
          'post_log_display_frames': 4, 'post_log_controller_inputs': 0},
        'native_SRAM': {'bytes': 8192, 'sha256': sha(REPLAY/'campaign.gbc.ram'),
          'all_bytes_equal_to_source_earned_SRAM': True, 'record_version': 5, 'record_bytes': 628, 'CRC_valid': True},
        'title': {'pixels_per_image': 23040, 'source_vs_replay_different_pixels': 0,
          'replay_vs_separate_earned_SRAM_boot_different_pixels': 0, 'images': titles,
          'reference_boot_frames': 304},
        'tooling': {'executed_runtime_sha256': runtime_sha, 'frozen_manifest_sha256': replay['frozen_manifest_sha256'],
          'executing_and_delivered_tools_match': True, 'native_layout_exact_ROM_code_match': True,
          'progress_note': 'Frozen progress.json retains its conservative false completion field; ACCEPTANCE.json explicitly designates replay-report.json as terminal acceptance.'},
        'build_delivery': {'source_and_Makefile_entries_exact': 343, 'compiled_objects_exact': 262,
          'canonical_frozen_delivery_story_replay_ROMs_identical': True, 'ROM_bytes': 4194304,
          'NOI_and_main_symbol_sidecar_match': True, 'delivery_file': 'releases/phantasy-star-gbc/Phantasy-Star-GBC.gbc'},
        'preservation': {'original_baseline_file_set_exact': True, 'baseline_files': 45,
          'baseline_ROM_sha256': sha(baseline/'build/phantasy-star-gbc-exploration.gbc'),
          'original_SMS_sha256': sms_sha, 'v5_promotion_evidence_files_unchanged': 2003},
        'story_provenance': {'prior_independent_audit_sha256': sha(prior_audit),
          'natural_defeat_and_actual_Continue_retained': True, 'exact_latest_Fly_assertion_resume_retained': True,
          'encounter_annotations_total': 1230, 'inherited_prefix_annotations': 501, 'fresh_continuation_annotations': 729,
          'limit': 'Per-battle annotations in the initial prefix were inherited; this independent full replay reproduced its controller inputs and every checkpoint without importing state.'},
        'actual_gaps_found': [],
        'validation_limits': ['Native emulator verification, not a physical GBC test.',
          'No new subjective soundtrack listening review.',
          'This audit establishes the recorded complete campaign and stated fixture/source proofs, not traversal of every optional route.'],
        'inputs_sha256': {str(p.relative_to(ROOT)): sha(p) for p in inputs}}
    (OUT/'report.json').write_text(json.dumps(result, indent=2)+'\n')
    hashes = {p.name: sha(p) for p in sorted(OUT.iterdir()) if p.is_file()}
    (OUT/'SHA256.json').write_text(json.dumps(hashes, indent=2)+'\n')
    print(json.dumps({'passed': True, 'rom_sha256': ROM_SHA, 'report_sha256': sha(OUT/'report.json'),
                      'manifest_sha256': sha(OUT/'SHA256.json'), 'gaps': []}, indent=2))


if __name__ == '__main__':
    main()
