process.env.HOST ||= '0.0.0.0';
process.env.PORT ||= '4173';
const {start}=await import('./server.mjs'); start();
