// Compatibility entry point: regenerate both themes from the repaired PNGs.
// Optional asset regeneration only; ordinary npm run build uses checked-in SVGs.
import {spawnSync} from 'node:child_process';
import {fileURLToPath} from 'node:url';
const script=fileURLToPath(new URL('./build-hero.py',import.meta.url));
const result=spawnSync('python3',[script],{stdio:'inherit'});
if(result.error)throw result.error;
process.exit(result.status??1);
