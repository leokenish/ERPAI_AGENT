import {createHash} from 'node:crypto';

// The reading edition changes presentation only. Source records and downloads stay intact.
export function applyReadingEdition(project,definition,render){
 const messages=new Map(project.messages.map(m=>[m.id,m]));
 const episodes=new Map(project.episodes.map(e=>[e.id,e]));
 for(const [id,entry] of Object.entries(definition?.excludedMessages||{})){
  const message=messages.get(id);
  if(!message||entry.source_sha256!==createHash('sha256').update(message.content_markdown).digest('hex'))throw Error(`Stale reading exclusion: ${project.id}/${id}`);
  message.readingHidden=true;
 }
 for(const message of project.messages){
  if(message.content_type==='unavailable'||message.delivery_kind==='progress')message.readingHidden=true;
 }
 for(const [id,entry] of Object.entries(definition?.responseEdits||{})){
  const message=messages.get(id);
  if(!message||message.role!=='assistant'||entry.source_sha256!==createHash('sha256').update(message.content_markdown).digest('hex'))throw Error(`Stale reading response: ${project.id}/${id}`);
  message.reading_markdown=entry.content_markdown;
  message.readingHtml=render(entry.content_markdown,`${id}-reading`);
 }
 for(const [id,entry] of Object.entries(definition?.episodes||{})){
  const episode=episodes.get(id);if(!episode)throw Error(`Unknown reading episode: ${project.id}/${id}`);
  for(const field of ['title','goal','commentary_markdown','outcome_markdown','prerequisites'])if(field in entry)episode[field]=entry[field];
  episode.commentaryHtml=render(episode.commentary_markdown,`${id}-commentary`);
  episode.outcomeHtml=render(episode.outcome_markdown,`${id}-outcome`);
 }
 for(const episode of project.episodes)episode.readingHidden=!episode.message_refs.some(id=>!messages.get(id).readingHidden);
 const visibleEpisodes=project.episodes.filter(e=>!e.readingHidden);
 const visibleIds=new Set(visibleEpisodes.flatMap(e=>e.message_refs).filter(id=>!messages.get(id).readingHidden));
 project.readingCounts={episodes:visibleEpisodes.length,messages:visibleIds.size};
 return project;
}
