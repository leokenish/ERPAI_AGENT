import { Marked } from '../vendor/marked.mjs';
export const escapeHTML = s => String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
export function safeURL(value) {
  const s = String(value || '').trim();
  if (/^[\u0000-\u0020]|[\u0000-\u001f\\]/.test(s)) return '#';
  if (/^https?:\/\//i.test(s) || s.startsWith('#')) return s;
  if (/^[\w./%-]+$/.test(s) && !s.split('/').includes('..') && !s.startsWith('/')) return s;
  return '#';
}
export function renderMarkdown(markdown, {headingPrefix='',headingIds={},headingAliases={},keepTitle=false,headingOffset=0,resolveURL,renderDocumentTree,renderWorkChat,renderWorktimeLab}={}) {
  const toc = []; let count = 0;
  const parser = new Marked({gfm:true,breaks:false});
  parser.use({renderer:{
    html({text}) {return escapeHTML(text);},
    blockquote({tokens,text}) {
      const caution=/^\s*(?:\*\*)?(?:주의(?:사항)?|경고|CAUTION|WARNING)(?:\*\*)?(?:[：:\s]|$)/i.test(text);
      if(!caution)return false;
      return `<blockquote class="caution">\n${this.parser.parse(tokens)}</blockquote>\n`;
    },
    heading({tokens,depth,text}) {
      ++count;
      const id = `${headingPrefix}section-${headingIds[count]??count}`;
      const aliases=(headingAliases[count]??[]).map(n=>`<span id="${headingPrefix}section-${n}" aria-hidden="true"></span>`).join('');
      if (depth === 2 || depth === 3) toc.push({id,depth,text:text.replace(/[*`]/g,'')});
      const level=Math.min(6,depth+headingOffset);
      return `${aliases}<h${level} id="${id}">${this.parser.parseInline(tokens)}</h${level}>`;
    },
    link({href,tokens}) {
      const resolved=resolveURL?resolveURL(href):href;
      if(!resolved)return `<span class="source-link-unavailable">${this.parser.parseInline(tokens)}</span>`;
      const url=safeURL(resolved); const external=/^https?:/.test(url);
      return `<a href="${escapeHTML(url)}"${external?' target="_blank" rel="noopener noreferrer"':''}${url.startsWith('downloads/')?' download':''}>${this.parser.parseInline(tokens)}</a>`;
    },
    image({href,text}) {
      const url=safeURL(resolveURL?resolveURL(href):href);
      if(!url.startsWith('assets/'))return `<span>${escapeHTML(text)}</span>`;
      return `<figure><button class="image-zoom" data-image="${escapeHTML(url)}" aria-label="${escapeHTML(text)} 크게 보기"><img src="${escapeHTML(url)}" alt="${escapeHTML(text)}" loading="lazy"></button><figcaption>${escapeHTML(text)}</figcaption></figure>`;
    },
    code({text,lang}) {if(lang==='worktime-lab'&&renderWorktimeLab)return renderWorktimeLab(text.trim());if(lang==='work-chat'&&renderWorkChat)return renderWorkChat(text);if(lang==='document-tree'&&renderDocumentTree)return renderDocumentTree(text);return `<div class="codeblock"><div class="codebar"><span>${escapeHTML(lang||'예시')}</span><button type="button" data-copy>복사</button></div><pre><code>${escapeHTML(text)}</code></pre></div>`;}
  }});
  const html=parser.parse(keepTitle?markdown:markdown.replace(/^# .+\r?\n/,''));
  return {html:html.replaceAll('<table>','<div class="table-wrap" tabindex="0"><table>').replaceAll('</table>','</table></div>'),toc};
}
