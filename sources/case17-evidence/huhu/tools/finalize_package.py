"""Validate preserved content, publish checksums, and verify the teaching ZIP.

Run after build_visuals.py, build_site.py, and check_site.cjs.
This performs local file/model checks only; it does not connect to SAP.
"""
from collections import Counter, defaultdict
from datetime import datetime, timezone
from hashlib import sha256
from pathlib import Path
from urllib.parse import urlsplit, unquote, parse_qs
import json
import zipfile
from bs4 import BeautifulSoup

OUT = Path(__file__).resolve().parents[1]
ROOT = OUT.parents[1]
ZIP = OUT.parent / 'ZHR5_AI_교육사례_휴휴대휴_20261031.zip'


def read(name):
    return json.loads((OUT / name).read_text(encoding='utf-8'))


def write(name, value):
    (OUT / name).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def digest(path):
    return sha256(path.read_bytes()).hexdigest()


def fnv(text):
    value = 2166136261
    data = text.encode('utf-16-le')
    for pos in range(0, len(data), 2):
        value = ((value ^ int.from_bytes(data[pos:pos + 2], 'little')) * 16777619) & 0xffffffff
    return f'{value:08x}'


def check(condition, context):
    if not condition:
        raise AssertionError(context)


def package_files():
    return sorted(p for p in OUT.rglob('*') if p.is_file()
                  and p.name != '.DS_Store' and p.suffix != '.pyc'
                  and not {'__pycache__', 'node_modules'}.intersection(p.parts))


# All public messages must match the bounded app receipt, including old mistakes.
conversation = read('conversation/messages.json')
messages = conversation['messages']
receipt = read('evidence/app-thread-receipt.json')
check(len(messages) == len(receipt['messages']) == 65, 'public message count')
for message, original in zip(messages, receipt['messages']):
    check(message['role'] == original['role'] and fnv(message['text']) == original['fnv1a_utf16'], message['number'])
    check(message['phase'] in ('user', 'commentary', 'final_answer'), 'public phases only')
check(Counter(m['role'] for m in messages) == {'user': 16, 'assistant': 49}, 'speaker count')
check(receipt['pages'][-1]['has_more'] is False, 'complete app pagination')
for name in ('transcript.md', 'transcript.txt'):
    text = (OUT / 'conversation' / name).read_text()
    for message in messages:
        check(message['text'] in text, (name, message['number']))
attachments = read('attachments/inventory.json')
check(not attachments['user_uploaded_images'], 'unexpected image attachment')
for block in read('conversation/code-blocks/index.json'):
    check(digest(OUT / block['file']) == block['sha256'], block['file'])

# Compare every source copy to both its saved hash and the unchanged workspace file.
copies = read('evidence/copied-files.json')
for item in copies:
    check(digest(OUT / item['file']) == item['sha256'], item['file'])
    check(digest(ROOT / item['source']) == item['sha256'], item['source'])
protected = read('source/proposal/source-hashes-before.json')
for name, expected in protected.items():
    check(digest(ROOT / name) == expected, 'protected source changed: ' + name)

# Every displayed line must correspond to the preserved original or proposed file.
changes = read('source/proposal/changes.json')
names = {'F03': 'LZHR008_2F03.abap', 'SAVE': 'ZHR_52TM_GET_OVERTIME_SAVE.abap'}
for change in changes:
    for folder, body, start, end in (
        ('originals', 'before', 'start', 'end'),
        ('proposed', 'after', 'after_start', 'after_end'),
    ):
        lines = (OUT / 'source/proposal' / folder / names[change['source']]).read_text().splitlines(keepends=True)
        actual = ''.join(lines[change[start] - 1:change[end]])
        check(actual == change[body], (change['id'], body, 'line mapping'))
    check((OUT / 'source/proposal/snippets' / (change['id'] + '.abap')).read_text() == change['after'], change['id'])
for source, name in names.items():
    lines = (OUT / 'source/proposal/originals' / name).read_text().splitlines(keepends=True)
    for change in sorted((c for c in changes if c['source'] == source), key=lambda c: c['start'], reverse=True):
        lines[change['start'] - 1:change['end']] = change['after'].splitlines(keepends=True)
    check(''.join(lines) == (OUT / 'source/proposal/proposed' / name).read_text(), name + ' reconstruction')

# These are arithmetic consistency checks, not simulations of actual SAP execution.
lesson = read('data/case-study.json')
for case in lesson['rates']:
    check(case['cash'] == [int(h * r * 10000) for h, r in zip(case['hours'], case['rates'])], case['id'])
    check(sum(case['leave_days']) == case['leave_count'], case['id'])
    if case['naive'] is not None:
        check(sum(case['cash']) * 2 == case['naive'], case['id'])
    if 'contributions' in case:
        check(sum(case['contributions']) == sum(case['settlement']), case['id'])
for case in lesson['splits']:
    totals = defaultdict(int)
    for day, amount in zip(case['dates'], case['raw_money']):
        totals[day] += amount
    check([totals['토'], totals['일']] == case['day_totals'], case['id'])
    check(sum(totals.values()) == case['total'], case['id'])
    check(len(totals) == 2 and sum(v > 0 for v in totals.values()) == case['leaves'], case['id'])

browser = read('evidence/browser-check.json')
check(browser['status'] == 'PASS' and not browser['page_errors'] and not browser['external_requests'], 'browser QA')
visuals = read('assets/visuals/index.json')
check(len(visuals) == 9, 'visual count')
for asset in visuals:
    check((OUT / asset['svg']).is_file() and (OUT / asset['png']).is_file(), asset['id'])
    check((OUT / asset['png']).read_bytes().startswith(b'\x89PNG\r\n\x1a\n'), asset['png'])

# Check the six new pages and the earlier report. Some generated files are written below.
catalog_text = (OUT / 'assets/source-data.js').read_text()
catalog = json.loads(catalog_text.removeprefix('window.SOURCE_FILES=').rstrip(';\n'))
catalog_by_path = {item['path']: item for item in catalog}
for item in catalog:
    check(item['text'] == (OUT / item['path']).read_text(), 'catalog stale: ' + item['path'])
future = {OUT / 'manifest.json', OUT / 'evidence/package-check.json', OUT / 'SHA256SUMS.txt'}
html_pages = list(OUT.glob('*.html')) + [OUT / 'source/proposal/report.html']
soups = {p: BeautifulSoup(p.read_text(), 'html.parser') for p in html_pages}
link_count = 0
for page, soup in soups.items():
    for node in soup.find_all(href=True) + soup.find_all(src=True):
        url = node.get('href') or node.get('src')
        parsed = urlsplit(url)
        if parsed.scheme or parsed.netloc:
            continue
        target = (page.parent / unquote(parsed.path)).resolve() if parsed.path else page
        check(target == OUT or OUT in target.parents, ('nonportable HTML target', page.name, url))
        check(target.exists() or target in future, ('missing HTML target', page.name, url))
        if parsed.fragment and target.suffix == '.html' and target in soups:
            check(soups[target].find(id=unquote(parsed.fragment)) is not None, ('missing anchor', page.name, url))
        query = parse_qs(parsed.query)
        if target.name == 'source-viewer.html' and query.get('file'):
            name = query['file'][0]
            check(name in catalog_by_path, ('source not in catalog', name))
            if query.get('line'):
                check(1 <= int(query['line'][0]) <= len(catalog_by_path[name]['text'].splitlines()), ('source line', url))
        link_count += 1

result = {
    'status': 'PASS', 'checked_at_utc': datetime.now(timezone.utc).isoformat(),
    'scope': 'Local educational-package validation; no SAP connection or execution',
    'public_messages_exact': len(messages), 'app_receipt_match': 'PASS',
    'user_uploaded_images_in_this_thread': 0, 'source_copies_hash_verified': len(copies),
    'protected_export_files_unchanged': len(protected), 'before_after_line_mappings': len(changes) * 2,
    'full_candidate_reconstruction': 'PASS', 'historical_code_blocks': 10,
    'educational_rate_cases': len(lesson['rates']), 'educational_split_cases': len(lesson['splits']),
    'svg_png_pairs': len(visuals), 'local_html_links': link_count,
    'source_catalog_exact_files': len(catalog), 'browser': browser['status'],
    'sap_syntax_check': 'NOT_RUN', 'sap_runtime_or_activation': 'NOT_RUN',
    'known_limits': ['No user image attachments found in this chat',
        'Actual production correction causes and transaction persistence are unverified',
        'F05 final flags/date/expense for combined 3+2 leave require SAP review',
        'Fixed transcript cutoff is the education-package request; later packaging messages are excluded']
}
write('evidence/package-check.json', result)
files = [p for p in package_files() if p.name not in ('manifest.json', 'SHA256SUMS.txt')]
entries = [{'path': str(p.relative_to(OUT)), 'bytes': p.stat().st_size,
            'sha256': digest(p), 'category': p.relative_to(OUT).parts[0]} for p in files]
write('manifest.json', {'format_version': 1, 'package': OUT.name,
      'scope': 'Original public conversation, preserved evidence, unapplied code proposal, and educational derivatives',
      'excluded_from_manifest': ['manifest.json', 'SHA256SUMS.txt'], 'files': entries})
checksummed = [p for p in package_files() if p.name != 'SHA256SUMS.txt']
(OUT / 'SHA256SUMS.txt').write_text(''.join(f'{digest(p)}  {p.relative_to(OUT)}\n' for p in checksummed))

files = package_files()
with zipfile.ZipFile(ZIP, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
    for path in files:
        archive.write(path, str(Path(OUT.name) / path.relative_to(OUT)))
with zipfile.ZipFile(ZIP) as archive:
    check(archive.testzip() is None, 'ZIP CRC')
    check(len(archive.namelist()) == len(files), 'ZIP file count')
    for path in files:
        name = str(Path(OUT.name) / path.relative_to(OUT))
        check(sha256(archive.read(name)).hexdigest() == digest(path), 'ZIP byte mismatch: ' + name)
zip_result = {'status': 'PASS', 'zip': str(ZIP), 'sha256': digest(ZIP),
              'bytes': ZIP.stat().st_size, 'files': len(files), 'crc': 'PASS',
              'all_entries_sha256_match': 'PASS', 'package_check': result}
ZIP.with_suffix('.verification.json').write_text(json.dumps(zip_result, ensure_ascii=False, indent=2) + '\n')
print(json.dumps(zip_result, ensure_ascii=False, indent=2))
