// 중앙에는 AI나 ERP 소스가 없다. MCP 요청을 SQLite 큐에 저장한다.
import express from 'express';
import { DatabaseSync } from 'node:sqlite';
import { randomUUID, timingSafeEqual } from 'node:crypto';
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
import { z } from 'zod';

export function createHub({ dbPath = 'jobs.sqlite', clients, workers }) {
  const identities = [...clients, ...workers];
  if (identities.some(x => !x.token || x.token.length < 24) ||
      new Set(identities.map(x => x.token)).size !== identities.length) {
    throw new Error('각 사용자/워커에 서로 다른 24자 이상 토큰을 지정하세요.');
  }
  const db = new DatabaseSync(dbPath);
  db.exec(`PRAGMA journal_mode=WAL;
    CREATE TABLE IF NOT EXISTS jobs (
      id TEXT PRIMARY KEY, owner TEXT NOT NULL, expert TEXT NOT NULL,
      question TEXT NOT NULL, context TEXT NOT NULL, parent_id TEXT,
      status TEXT NOT NULL, created INTEGER NOT NULL, expires INTEGER NOT NULL,
      lease TEXT, lease_until INTEGER, worker TEXT, answer TEXT, error TEXT
    );`);
  const app = express();
  // 이 예제는 브라우저 직접 호출을 제공하지 않는다.
  app.use((req, res, next) => req.headers.origin ? res.sendStatus(403) : next());
  app.use(express.json({ limit: '256kb' }));
  const seen = new Map();
  const equal = (a, b) => {
    const x = Buffer.from(a), y = Buffer.from(b);
    return x.length === y.length && timingSafeEqual(x, y);
  };
  const auth = entries => (req, res, next) => {
    const token = (req.headers.authorization || '').replace(/^Bearer /, '');
    req.identity = entries.find(x => equal(x.token, token));
    if (!req.identity) return res.sendStatus(401);
    next();
  };
  const sweep = () => {
    const now = Date.now();
    db.prepare("UPDATE jobs SET status='expired', error='job deadline exceeded' WHERE status IN ('queued','running') AND expires <= ?").run(now);
    // 자동 재실행 대신 실패 처리하여 중복 AI 실행을 피한다.
    db.prepare("UPDATE jobs SET status='failed', error='worker lease expired' WHERE status='running' AND lease_until <= ?").run(now);
  };
  const result = data => ({ content: [{ type: 'text', text: JSON.stringify(data) }] });
  const owned = (id, who) => db.prepare('SELECT * FROM jobs WHERE id=? AND owner=?').get(id, who.id);
  const publicJob = row => ({ id: row.id, expert: row.expert, question: row.question,
    status: row.status, answer: row.answer, error: row.error, parent_id: row.parent_id });

  function makeMcp(who) {
    const server = new McpServer({ name: 'erp-team-hub', version: '0.1.0' });
    server.registerTool('list_experts', { description: '질문 가능한 담당과 워커 최근 접속 상태 조회', inputSchema: {} }, async () => result(
      who.experts.map(expert => ({ expert, online: Date.now() - (seen.get(expert) || 0) < 30000 }))));
    server.registerTool('ask_expert', {
      description: '다른 업무 담당에게 읽기 전용 자문 요청. 즉시 job_id 반환. get_answer로 확인. parent_id로 완료된 자문에 후속 질문.',
      inputSchema: { expert: z.string().max(32), question: z.string().min(1).max(12000),
        context: z.string().max(40000).default(''), parent_id: z.string().uuid().optional() }
    }, async ({ expert, question, context, parent_id }) => {
      sweep();
      if (!who.experts.includes(expert)) throw new Error('이 담당에게 질문할 권한이 없습니다.');
      if (parent_id) {
        const parent = owned(parent_id, who);
        if (!parent || parent.expert !== expert || parent.status !== 'done') throw new Error('완료된 본인 자문만 이어갈 수 있습니다.');
      }
      const active = db.prepare("SELECT count(*) AS n FROM jobs WHERE owner=? AND status IN ('queued','running')").get(who.id).n;
      if (active >= 10) throw new Error('동시 요청 한도 10건 초과');
      const id = randomUUID(), now = Date.now();
      db.prepare('INSERT INTO jobs (id,owner,expert,question,context,parent_id,status,created,expires) VALUES (?,?,?,?,?,?,?,?,?)')
        .run(id, who.id, expert, question, context, parent_id || null, 'queued', now, now + 15 * 60000);
      return result({ job_id: id, status: 'queued', poll_after_seconds: 5 });
    });
    server.registerTool('get_answer', {
      description: '본인이 요청한 자문 결과 조회. queued/running이면 5초 이상 후 다시 확인. 최대 15분 후 만료.',
      inputSchema: { job_id: z.string().uuid() }
    }, async ({ job_id }) => {
      sweep();
      const row = owned(job_id, who);
      if (!row) throw new Error('요청을 찾을 수 없습니다.');
      return result(publicJob(row));
    });
    return server;
  }

  app.post('/mcp', auth(clients), async (req, res, next) => {
    const server = makeMcp(req.identity);
    const transport = new StreamableHTTPServerTransport({ sessionIdGenerator: undefined, enableJsonResponse: true });
    res.on('close', () => { void server.close().catch(() => {}); });
    try { await server.connect(transport); await transport.handleRequest(req, res, req.body); }
    catch (error) { next(error); }
  });
  app.all('/mcp', auth(clients), (_req, res) => res.sendStatus(405));

  app.use('/worker', auth(workers));
  // 짧은 폴링: 워커가 중앙으로 나가는 요청만 사용한다.
  app.post('/worker/claim', (req, res) => {
    const who = req.identity;
    seen.set(who.expert, Date.now());
    sweep();
    db.exec('BEGIN IMMEDIATE');
    try {
      const row = db.prepare("SELECT * FROM jobs WHERE expert=? AND status='queued' ORDER BY created LIMIT 1").get(who.expert);
      if (!row) { db.exec('COMMIT'); return res.sendStatus(204); }
      const lease = randomUUID();
      db.prepare("UPDATE jobs SET status='running', worker=?, lease=?, lease_until=? WHERE id=?")
        .run(who.id, lease, Date.now() + 60000, row.id);
      db.exec('COMMIT');
      const history = [];
      let parentId = row.parent_id;
      // 전체 대화를 무한히 보내지 않는다. 최신 선행 자문 최대 3개.
      for (let i = 0; parentId && i < 3; i++) {
        const prior = db.prepare('SELECT * FROM jobs WHERE id=? AND owner=? AND expert=?').get(parentId, row.owner, row.expert);
        if (!prior) break;
        history.unshift({ question: prior.question, answer: prior.answer });
        parentId = prior.parent_id;
      }
      res.json({ id: row.id, lease, expert: row.expert, question: row.question, context: row.context, history });
    } catch (error) { if (db.isTransaction) db.exec('ROLLBACK'); throw error; }
  });
  for (const action of ['heartbeat', 'complete']) {
    app.post(`/worker/:id/${action}`, (req, res) => {
      sweep();
      const schema = z.object({ lease: z.string().uuid(), answer: z.string().min(1).max(80000).optional(),
        error: z.string().min(1).max(1000).optional() });
      const parsed = schema.safeParse(req.body);
      if (!parsed.success) return res.sendStatus(400);
      const body = parsed.data, who = req.identity;
      const row = db.prepare("SELECT * FROM jobs WHERE id=? AND worker=? AND expert=? AND lease=? AND status='running'")
        .get(req.params.id, who.id, who.expert, body.lease);
      if (!row) return res.sendStatus(409);
      seen.set(who.expert, Date.now());
      if (action === 'heartbeat') {
        db.prepare('UPDATE jobs SET lease_until=? WHERE id=?').run(Date.now() + 60000, row.id);
      } else {
        if ((!body.answer && !body.error) || (body.answer && body.error)) return res.sendStatus(400);
        db.prepare('UPDATE jobs SET status=?,answer=?,error=? WHERE id=?')
          .run(body.error ? 'failed' : 'done', body.answer || null, body.error || null, row.id);
      }
      res.json({ ok: true });
    });
  }
  app.use((error, _req, res, _next) => {
    console.error('Request failed:', error.name);
    if (!res.headersSent) res.status(error.status === 413 ? 413 : 500).json({ error: 'request failed' });
  });
  return { app, db };
}

if (process.argv[1] && import.meta.url === new URL(process.argv[1], 'file:').href) {
  const { app } = createHub({
    dbPath: process.env.DB_PATH || 'jobs.sqlite',
    clients: [{ id: 'hr-user', token: process.env.HR_CLIENT_TOKEN, experts: ['ZFI'] }],
    workers: [{ id: 'fi-mac', token: process.env.FI_WORKER_TOKEN, expert: 'ZFI' }]
  });
  const host = process.env.HOST || '127.0.0.1', port = Number(process.env.PORT || 3000);
  app.listen(port, host, () => console.log(`ERP MCP listening on ${host}:${port}`));
}
