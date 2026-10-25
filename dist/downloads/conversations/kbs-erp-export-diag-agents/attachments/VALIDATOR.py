#!/usr/bin/env python3
"""Validate the educational bundle, not SAP programs."""
import json, hashlib
from pathlib import Path
root=Path(__file__).resolve().parents[2]
d=json.loads((root/'conversation-data.json').read_text(encoding='utf-8'))
assert d['schema_version']=='1.0'
messages=[m for t in d['threads'] for m in t['messages']]
mids=[m['id'] for m in messages];aids=[a['id'] for a in d['assets']]
assert len(mids)==len(set(mids));assert len(aids)==len(set(aids))
assert len({e['id'] for e in d['episodes']})==len(d['episodes'])
assert d['coverage']['status']=='partial'
for t in d['threads']:
 assert [m['sequence'] for m in t['messages']]==list(range(1,len(t['messages'])+1))
for m in messages:
 assert m['role'] in ('user','assistant')
 assert m['content_type'] in ('verbatim','excerpt','summary')
 assert set(m['asset_ids']) <= set(aids)
 assert isinstance(m['redacted'],bool)
order={m['id']:i for i,m in enumerate(messages)}
nodes={'sap','export','git','knowledge','codex','diag','maps','feedback','agent','lookup','hub','worker','expert','telegram','erp-api','portal'}
covered=set()
for e in d['episodes']:
 assert set(e['message_refs']) <= set(mids)
 assert [order[x] for x in e['message_refs']]==sorted(order[x] for x in e['message_refs'])
 assert set(e['asset_ids']) <= set(aids)
 assert set(e['map_nodes']) <= nodes
 covered.update(e['message_refs'])
assert covered==set(mids)
for a in d['assets']:
 assert set(a['related_message_ids'])<=set(mids)
 if a['availability']=='included':
  assert a['path'] and not Path(a['path']).is_absolute()
  p=(root/a['path']).resolve();assert p.is_relative_to(root.resolve());assert p.is_file(),a['path']
  assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256'],a['path']
 else:assert a['path'] is None
print(json.dumps({'result':'PASS','threads':len(d['threads']),'messages':len(messages),'episodes':len(d['episodes']),'included_assets':sum(a['availability']=='included' for a in d['assets']),'unavailable_assets':sum(a['availability']=='unavailable' for a in d['assets']),'scope':'교육 자료 JSON·참조·순서·첨부 SHA-256. SAP 테스트 아님.'},ensure_ascii=False,indent=2))
