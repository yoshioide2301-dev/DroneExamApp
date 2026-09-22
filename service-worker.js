/* ゼロナビ Service Worker：完全オフライン用（外部通信なし）
   アプリ構成ファイルを install 時に端末内へ永続キャッシュし、以降はキャッシュのみで応答する。
   index.html 等を更新したら CACHE_NAME の版数を上げること（旧キャッシュは activate で削除）。 */
const CACHE_NAME = "zeronavi-v2";
const APP_FILES = ["./", "index.html", "manifest.json", "icons/zeronavi-icon-192-v2.png", "icons/zeronavi-icon-512-v2.png", "icons/zeronavi-icon-1024-v2.png"];

self.addEventListener("install", e => {
  e.waitUntil(caches.open(CACHE_NAME).then(c => c.addAll(APP_FILES)).then(() => self.skipWaiting()));
});

self.addEventListener("activate", e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== CACHE_NAME).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

/* キャッシュ優先。未登録のURLはネットワークへ出さず、ページ遷移なら index.html を返す */
self.addEventListener("fetch", e => {
  if(e.request.method !== "GET") return;
  e.respondWith(
    caches.match(e.request, { ignoreSearch: true }).then(hit =>
      hit || (e.request.mode === "navigate" ? caches.match("index.html") : Response.error()))
  );
});
