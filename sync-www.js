/* Capacitor 用: 配信ファイルだけを www/ にコピーする（www/ は生成物・git管理外） */
const fs = require('fs');
fs.rmSync('www', { recursive: true, force: true });
fs.mkdirSync('www', { recursive: true });
['index.html', 'manifest.json', 'service-worker.js'].forEach(f => fs.copyFileSync(f, 'www/' + f));
fs.cpSync('icons', 'www/icons', { recursive: true });
console.log('www ready');
