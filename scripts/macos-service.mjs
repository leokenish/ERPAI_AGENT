import {homedir} from 'node:os';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {mkdir,writeFile,rm,access} from 'node:fs/promises';
import {spawnSync} from 'node:child_process';
if(process.platform!=='darwin'){console.error('이 명령은 운영할 macOS에서 실행하세요.');process.exit(1);}
const action=process.argv[2]||'status';
const label='com.kbs.erp-ai-learning-portal';
const domain=`gui/${process.getuid()}`;
const repo=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
const plist=path.join(homedir(),'Library/LaunchAgents',label+'.plist');
const logs=path.join(homedir(),'Library/Logs/erp-ai-portal');
const xml=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&apos;'}[c]));
const run=(args,allowFail=false)=>{const r=spawnSync('launchctl',args,{stdio:allowFail?'ignore':'inherit'});if(r.error)throw r.error;if(r.status!==0&&!allowFail)process.exit(r.status||1);return r.status;};
if(action==='install'){
 await access(path.join(repo,'dist/index.html'));
 await mkdir(path.dirname(plist),{recursive:true});await mkdir(logs,{recursive:true});
 const host=process.env.HOST||'0.0.0.0',port=process.env.PORT||'8080';
 if(!/^\d+$/.test(port)||+port<1||+port>65535)throw Error('PORT must be 1–65535');
 const content=`<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0"><dict>
<key>Label</key><string>${label}</string>
<key>ProgramArguments</key><array><string>${xml(process.execPath)}</string><string>${xml(path.join(repo,'scripts/server.mjs'))}</string></array>
<key>WorkingDirectory</key><string>${xml(repo)}</string>
<key>EnvironmentVariables</key><dict><key>HOST</key><string>${xml(host)}</string><key>PORT</key><string>${xml(port)}</string></dict>
<key>RunAtLoad</key><true/><key>KeepAlive</key><true/>
<key>ThrottleInterval</key><integer>10</integer>
<key>StandardOutPath</key><string>${xml(path.join(logs,'stdout.log'))}</string>
<key>StandardErrorPath</key><string>${xml(path.join(logs,'stderr.log'))}</string>
</dict></plist>\n`;
 await writeFile(plist,content,{mode:0o600});
 run(['bootout',domain+'/'+label],true);run(['bootstrap',domain,plist]);
 console.log(`사용자 로그인 후 자동 실행을 등록했습니다. http://${host}:${port}\n로그: ${logs}\n시스템 절전·로그아웃 중의 상시 제공은 별도 운영 조건입니다.`);
}else if(action==='status')run(['print',domain+'/'+label]);
else if(action==='restart')run(['kickstart','-k',domain+'/'+label]);
else if(action==='stop'){run(['bootout',domain+'/'+label]);console.log('현재 사용자 세션에서 중지했습니다. 다시 등록하려면 service:install을 실행하세요.');}
else if(action==='uninstall'){run(['bootout',domain+'/'+label],true);await rm(plist,{force:true});console.log('이 포털의 사용자 자동 실행 등록을 제거했습니다.');}
else{console.error('사용법: install | status | restart | stop | uninstall');process.exit(1);}
