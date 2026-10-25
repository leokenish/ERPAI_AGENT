#!/usr/bin/env python3
"""Offline extraction audit; never connects to SAP or changes project source."""
import hashlib, json, zipfile
from collections import Counter
from pathlib import Path
root = Path(__file__).resolve().parents[2]
d = json.loads((root/'conversation-data.json').read_text(encoding='utf-8'))
assets = {a['id']:a for a in d['assets']}
with zipfile.ZipFile(root/assets['SUP-PRIOR-EXTRACTION-ZIP']['path']) as z:
    n = [x for x in z.namelist() if x.endswith('/conversation-data.json')][0]
    old = json.loads(z.read(n))
    prefix = n.rsplit('/',1)[0]+'/'
    original_assets = {a['id']:a for a in old['assets']}
    unchanged_asset_files = 0
    for a in old['assets']:
        if a['availability']=='included' and a['id']!='TRANSCRIPT-MD':
            assert z.read(prefix+a['path']) == (root/a['path']).read_bytes(), a['id']
            unchanged_asset_files += 1
messages=[m for t in d['threads'] for m in t['messages']]
lookup={m['id']:m for m in messages}
for t in old['threads']:
    for m in t['messages']:
        for key in ['id','sequence','role','timestamp','content_type','content_markdown','source_locator','redacted','asset_ids']:
            assert m[key]==lookup[m['id']][key], (m['id'],key)
assert d['project_id']==old['project_id']
assert [e['id'] for e in d['episodes']]==[e['id'] for e in old['episodes']]
for a,b in zip(old['episodes'][:-1],d['episodes'][:-1]):
    assert a==b, a['id']
assert d['episodes'][-1]['message_refs']==old['episodes'][-1]['message_refs']+['A007','A008','A009']
assert len(lookup)==len(messages)==101
audit=json.loads((root/assets['SUP-RESPONSE-AUDIT']['path']).read_text())
users={m['id'] for m in messages if m['role']=='user'}
assert len(audit['user_requests'])==len(users)==92
assert {r['user_message_id'] for r in audit['user_requests']}==users
for m in messages:
    if m['role']=='assistant':
        assert m['response_stage'] in ['progress','final']
        for u in m['reply_to_user_message_ids']:
            assert u in users and lookup[u]['sequence']<m['sequence']
    else:
        for aid in m['response_coverage']['assistant_message_ids']:
            assert m['id'] in lookup[aid]['reply_to_user_message_ids']
for r in audit['user_requests']:
    direct=[m['id'] for m in messages if r['user_message_id'] in m.get('reply_to_user_message_ids',[])]
    assert direct==r['assistant_message_ids']
    if r['status']=='missing': assert not direct
    if r['status']=='full': assert r['final_message_ids']
counts=Counter(r['status'] for r in audit['user_requests'])
assert counts=={'missing':89,'full':3}
for mid in ['A007','A008','A009']: assert lookup[mid]['timestamp'] is None
print(json.dumps({'result':'PASS','unchanged_original_messages':98,'unchanged_original_asset_files':unchanged_asset_files,'added_recent_assistant_messages':3,'newly_recovered_historical_core_answers':0,'request_coverage':dict(counts),'scope':'교육 데이터의 대응 관계와 원문 보존. SAP 실행 검증 아님.'},ensure_ascii=False,indent=2))
