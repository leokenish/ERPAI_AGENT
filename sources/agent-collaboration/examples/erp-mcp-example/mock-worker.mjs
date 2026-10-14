// 통신 확인 전용. AI를 호출하거나 ZFI 소스를 읽지 않는다.
import { setTimeout as sleep } from 'node:timers/promises';
const base = process.env.HUB_URL || 'http://127.0.0.1:3000';
const token = process.env.FI_WORKER_TOKEN;
if (!token) throw new Error('FI_WORKER_TOKEN이 필요합니다.');
async function post(path, body = {}) {
  const res = await fetch(base + path, { method: 'POST',
    headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
    body: JSON.stringify(body), signal: AbortSignal.timeout(15000) });
  if (!res.ok) throw new Error(`HTTP ${res.status}`);
  return res.status === 204 ? null : res.json();
}
while (true) {
  try {
    const job = await post('/worker/claim');
    if (job) {
      // 실제 워커에서는 이 자리에 Codex 자문 실행을 연결한다.
      await post(`/worker/${job.id}/complete`, { lease: job.lease,
        answer: '[MOCK] FI 워커까지 질문 전달 성공. 실제 ERP 소스 분석 결과가 아닙니다.' });
      console.log('Answered mock job:', job.id);
    }
  } catch (error) { console.error(error.message); }
  await sleep(3000);
}
