export function pair(base,target){
 if(base[0]==='U'||target[0]==='U')return '미확인';
 if(base[0]==='N'&&target[0]==='N')return '판정 없음';
 if(base[0]==='N'&&target[0]==='P')return '신규';
 if(base[0]==='P'&&target[0]==='N')return '누락';
 return base[1]===target[1]?'변경없음':'수정';
}
export function compare(original,extracted,sap){return [pair(original,extracted),pair(original,sap),pair(sap,extracted)];}
