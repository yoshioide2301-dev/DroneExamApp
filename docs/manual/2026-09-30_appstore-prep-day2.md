# 2026-09-30 App Store申請準備（DAY2）

未commit・ローカルのみ。Capacitor sync・署名・公開は未実施。

## 変更
- index.html: 試用版 ZeroNavi-Demo の 4f0e652（問題IDを設問の前に表示。通常の出題とCBT）と 8068a412（2-H020/040の設問と解説の改訂、解説の「教則第5版の改訂点」バッジ）を取り込んだ。試用版のService Worker無効化とmanifestの試用名は取り込んでいない。388問、ID、並び順、correctは変わっていない。
- AppIcon: `icons/zeronavi-icon-1024-v2.png` を基にした。角丸の外側（下の角は白、右下に小さな星形マーク）を内側のグラデーションで塗りつぶし、1024px・RGB（透過なし）にした。旧仮アイコンは `icons/icon-1024.png` に同じものが残っている。
- 起動画面: `SplashNavy.imageset` を新たに追加した（ネイビーのグラデーション＋中央にアイコン）。LaunchScreen.storyboard の参照先と背景色を #002244 に変えた。旧 `Splash.imageset` は残してある。
- バージョン: package.json と Xcode の MARKETING_VERSION を 1.1.0 にした（アプリ内の APP_VERSION は元から 1.1.0）。CURRENT_PROJECT_VERSION は 1 のまま。package-lock.json は元から name が testapp のままで、npm の再生成時にそろう想定のため触っていない。
- docs/appstore/privacy.html・support.html: 下書き。連絡先と運営者名は「要確認」で、公開しない。

## コードで確認した事実（プライバシー）
- index.html と service-worker.js に外部通信（fetch/XHR/外部URL/外部スクリプト/外部フォント）はない。SWはキャッシュのみで応答する。
- 保存先は localStorage だけ（学習履歴・CBT履歴・再開状態・試験日・設定・報告内容）。
- 「気になる点を報告」は端末に保存されるだけで、送信されない（最大200件、OS種別・バージョンを含む）。
- iCloud同期はプレースホルダー。1.5秒待ったあと「同期が完了しました」と表示するが、実際には同期しない。
