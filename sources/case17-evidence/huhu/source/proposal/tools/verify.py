"""Local proposal checks. Flow models are not ABAP or SAP execution."""
from pathlib import Path
from decimal import Decimal, ROUND_CEILING
import hashlib,json,re

HERE=Path(__file__).resolve().parents[1]
ROOT=HERE.parents[1]
D=Decimal
results=[]

def row(day,raw,flag=True,start='000000',end='240000'):
    return dict(day=day,raw=D(str(raw)),flag=flag,start=start,end=end)

def current_calculation(rows,ngt=False,error=False):
    if error:
        return None
    total=sum((x['raw'] for x in rows),D(0)).quantize(D('.1'),rounding=ROUND_CEILING)*100
    detail=[dict(x) for x in rows if x['flag'] or ngt]
    grouped=[]
    for x in sorted(detail,key=lambda x:(x['day'],x['start'],x['end'])):
        if grouped and grouped[-1]['day']==x['day']:
            grouped[-1]['end']=max(grouped[-1]['end'],x['end'])
            grouped[-1]['raw']+=x['raw']
            grouped[-1]['flag']=grouped[-1]['flag'] or x['flag']
        else:
            grouped.append(dict(x))
    count=sum(x['flag'] for x in grouped)
    if len(grouped)==1:
        amounts={grouped[0]['day']:total}
    elif len(grouped)==2:
        amounts={x['day']:(total if count==1 else x['raw']*100) if x['flag'] else D(0) for x in grouped}
    else:
        amounts={'original':total}
    return dict(total=total,detail=detail,grouped=grouped,amounts=amounts,count=count)

def record(name,expected_label,check):
    assert check,name
    results.append(dict(id='S%02d'%(len(results)+1),name=name,expected_label=expected_label,status='PASS'))

split=[row('토',800,start='120000',end='200000'),row('일',600,end='060000'),row('토',200,start='200000',end='220000')]
a=current_calculation(split,True)
record('토8 / 일6 / 토2, 양일 대휴','토 100,000 + 일 60,000원',a['amounts']=={'토':D(100000),'일':D(60000)} and a['total']==160000)
b=current_calculation(list(reversed(split)),True)
record('계산 행 순서가 바뀜','날짜별 금액과 합계 동일',a['amounts']==b['amounts'])
record('대휴X와 특근상세 조건 동시 충족','상세 3행, 날짜 2묶음',len(a['detail'])==3 and len(a['grouped'])==2)
c=current_calculation([row('토',300),row('일',200,False)])
record('3+2, 다른 날짜가 상세에서 빠짐','한 대휴 금액 50,000원',c['amounts']=={'토':D(50000)})
c=current_calculation([row('토',300),row('일',200,False)],True)
record('3+2, 날짜 상세는 두 묶음','대휴일 50,000 / 다른 날 0원',c['amounts']=={'토':D(50000),'일':D(0)})
c=current_calculation([row('토',0,False),row('일',600)])
record('2+6, 익일에만 대휴 발생','익일 대휴 금액 60,000원',c['amounts']=={'일':D(60000)})
c=current_calculation([row('토',600),row('일',0,False)])
record('6+2, 첫날에만 대휴 발생','첫날 대휴 금액 60,000원',c['amounts']=={'토':D(60000)})
c=current_calculation([row('토',600)])
record('이전8만원 → 현재6시간 재계산','새 금액 60,000원 사용',c['amounts']=={'토':D(60000)})
c=current_calculation([row('토',0)])
record('정상 계산값이 0','이전 비영금액 대신 0원',c['amounts']=={'토':D(0)})
c=current_calculation([row('토',0),row('일',0)],True)
record('시차B에서 새J가 계산되지 않은 행','양일 J 0 유지',c['amounts']=={'토':D(0),'일':D(0)})
c=current_calculation([row('토',0,start='120000',end='200000'),row('토',0,start='200000',end='220000')])
record('D/T 단일일 분할, 새J 0','한 날짜 J 0 유지',c['amounts']=={'토':D(0)} and len(c['grouped'])==1)
stale={'토':D(999999),'일':D(777777)}
c=current_calculation([row('토',600)])
record('동일 사번·날짜에 임시금액 잔존 가정','현재 금액 60,000 / 잔존값 미참조',c['amounts']=={'토':D(60000)} and stale=={'토':D(999999),'일':D(777777)})
c=current_calculation([row('토',0,False)])
record('대휴 상세가 없는 입력','기본 저장 구조의 새J 0',c['amounts']=={'original':D(0)})
record('최초 GET_DATA가 E 반환','금액 저장 단계로 진행하지 않음',current_calculation(split,True,True) is None)
c=current_calculation([row('토','800.01',start='120000'),row('토','199.99',start='200000'),row('일',600)],True)
record('날짜별 상세 금액의 단위 변환','토 100,000원, ×100 한 번',c['amounts']=={'토':D(100000),'일':D(60000)})
current_calculation(split,True)
c=current_calculation([row('토',0)])
record('다음 호출에서 새 초기화','앞 호출의 160,000원이 남지 않음',c['total']==0 and len(c['detail'])==1)

(HERE/'checks/scenarios.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')

changes=json.loads((HERE/'changes.json').read_text())
files={'F03':'LZHR008_2F03.abap','SAVE':'ZHR_52TM_GET_OVERTIME_SAVE.abap'}
for key,filename in files.items():
    before=(HERE/'originals'/filename).read_text().splitlines(keepends=True)
    reconstructed=[];cursor=0
    for c in [c for c in changes if c['source']==key]:
        assert ''.join(before[c['start']-1:c['end']])==c['before']
        assert (HERE/'snippets'/(c['id']+'.abap')).read_text()==c['after']
        reconstructed.extend(before[cursor:c['start']-1]);reconstructed.extend(c['after'].splitlines(keepends=True));cursor=c['end']
    reconstructed.extend(before[cursor:])
    assert ''.join(reconstructed)==(HERE/'proposed'/filename).read_text()

f03=(HERE/'proposed/LZHR008_2F03.abap').read_text()
save=(HERE/'proposed/ZHR_52TM_GET_OVERTIME_SAVE.abap').read_text()
assert not re.search(r'^\s*(MODIFY|SELECT|DELETE).*zhrdaehuamt',f03+'\n'+save,re.M|re.I)
target=f03[f03.index('FORM calc_work_time_daily TABLES'):]
target=target[:target.index('ENDFORM.')]
assert target.count('APPEND ls_result TO pt_zdaeh.')==1
assert 'ADD ls_result-zjorgehamt TO lv_zjorgehamt.' in target
assert 'REFRESH pt_zdaeh.' in target
assert save.index("IF lv_code+0(1) EQ 'E'.") < save.index('SELECT seqnr')
assert save.index('ls_zthrbs01-jorgeh = ls_zdaeh-zjorgehamt * 100.') > save.index('PERFORM split_overtime_data')
assert 'ls_overtime_data-jorgeh      TO ls_zthrbs01-jorgeh' in save
assert not re.search(r'\b(VALUE|NEW|COND|REDUCE|FILTER)\s+[\w#]*\s*\(',''.join(c['after'] for c in changes),re.I)

source_before=json.loads((HERE/'source-hashes-before.json').read_text())
source_after={str(p.relative_to(ROOT)):hashlib.sha256(p.read_bytes()).hexdigest() for p in (ROOT/'exports/ZHR5').rglob('*') if p.is_file() and p.name!='.DS_Store'}
assert source_before==source_after
grammar=json.loads((HERE/'checks/grammar.json').read_text())
assert grammar['status']=='PASS',grammar
report={'status':'PASS','scope':'proposal-only; source/context/snippet/static/conditional-model checks',
        'protected_file_count':len(source_before),'source_preservation':'PASS',
        'exact_before_snippets':'PASS','candidate_reconstruction':'PASS','static_contracts':'PASS',
        'v700_grammar':grammar['status'],'model_cases':len(results),
        'abap_runtime_execution':'NOT_RUN','sap_execution':'NOT_RUN',
        'full_f05_business_result':'REVIEW_REQUIRED',
        'note':'Python models receive already-calculated rows. No DAILY/NORM/F05/DB runtime or policy validation.'}
(HERE/'checks/validation.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(report,ensure_ascii=False))
