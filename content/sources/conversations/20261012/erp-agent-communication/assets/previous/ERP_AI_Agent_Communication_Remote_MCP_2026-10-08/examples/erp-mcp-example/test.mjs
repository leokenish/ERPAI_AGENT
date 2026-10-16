import test from 'node:test';
import assert from 'node:assert/strict';
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StreamableHTTPClientTransport } from '@modelcontextprotocol/sdk/client/streamableHttp.js';
import { createHub } from './server.mjs';

test('MCP 요청 → 워커 → 답변, 후속 질문, 사용자/워커 권한 분리', async () => {
  const hr = 'test-hr-token-123456789012345', fi = 'test-fi-token-123456789012345';
  const other = 'test-other-token-123456789012345', mm = 'test-mm-token-123456789012345';
  const { app, db } = createHub({ dbPath: ':memory:',
    clients: [{ id: 'hr', token: hr, experts: ['ZFI'] }, { id: 'other', token: other, experts: ['ZFI'] }],
    workers: [{ id: 'fi', token: fi, expert: 'ZFI' }, { id: 'mm', token: mm, expert: 'ZMM' }] });
  const http = app.listen(0, '127.0.0.1');
  await new Promise(resolve => http.once('listening', resolve));
  const base = `http://127.0.0.1:${http.address().port}`;
  const connected = [];
  const client = async token => {
    const c = new Client({ name: 'test', version: '1' });
    await c.connect(new StreamableHTTPClientTransport(new URL(base + '/mcp'), {
      requestInit: { headers: { Authorization: `Bearer ${token}` } } }));
    connected.push(c); return c;
  };
  const post = (path, token, body = {}) => fetch(base + path, { method: 'POST',
    headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
  const data = response => JSON.parse(response.content[0].text);
  try {
    const c = await client(hr), c2 = await client(other);
    assert.equal((await post('/worker/claim', hr)).status, 401);
    assert.equal((await c.callTool({ name: 'ask_expert', arguments: { expert: 'ZMM', question: 'x' } })).isError, true);
    const ask = await c.callTool({ name: 'ask_expert', arguments: { expert: 'ZFI', question: '전표 취소?' } });
    const id = data(ask).job_id;
    assert.equal((await c2.callTool({ name: 'get_answer', arguments: { job_id: id } })).isError, true);
    assert.equal((await post('/worker/claim', mm)).status, 204);
    const job = await (await post('/worker/claim', fi)).json();
    assert.equal(job.id, id);
    assert.equal((await post(`/worker/${id}/complete`, mm, { lease: job.lease, answer: 'bad' })).status, 409);
    assert.equal((await post(`/worker/${id}/complete`, fi, { lease: job.lease, answer: '근거 확인 필요' })).status, 200);
    assert.equal(data(await c.callTool({ name: 'get_answer', arguments: { job_id: id } })).answer, '근거 확인 필요');
    await c.callTool({ name: 'ask_expert', arguments: { expert: 'ZFI', question: '추가 확인', parent_id: id } });
    const next = await (await post('/worker/claim', fi)).json();
    assert.equal(next.history[0].question, '전표 취소?');
    db.prepare('UPDATE jobs SET lease_until=0 WHERE id=?').run(next.id);
    assert.equal((await post(`/worker/${next.id}/complete`, fi, { lease: next.lease, answer: 'late' })).status, 409);
    assert.equal(data(await c.callTool({ name: 'get_answer', arguments: { job_id: next.id } })).status, 'failed');
  } finally {
    for (const c of connected) await c.close();
    await new Promise(resolve => http.close(resolve)); db.close();
  }
});
