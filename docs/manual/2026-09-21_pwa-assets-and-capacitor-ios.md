# 技術履歴: PWAアセット生成 と Capacitor iOS プロジェクト初期化（ゼロナビ）

最終更新: 2026-09-21

## 追加ファイル
- `manifest.json`: 名前/短縮名「ゼロナビ」、`start_url:"index.html"`、`display:"standalone"`、`background_color:#2c3e50`、`theme_color:#34495e`、アイコン192/512/1024。
- `service-worker.js`: install 時に `index.html`/`manifest.json`/アイコンを Cache API へ保存、fetch はキャッシュ優先で応答（未登録URLはネットワークへ出さず、遷移なら index.html）。**外部通信なし・ソース内に fetch() 呼び出しなし**。更新時は `CACHE_NAME` の版数を上げる。
- `icons/icon-{192,512,1024}.png`: **プレースホルダー**（#34495e地に白い「Z」、Node で生成）。正式アイコンがリポジトリに存在しなかったため。同名で差し替えれば反映される（iOS側は `ios/App/App/Assets.xcassets/AppIcon.appiconset/AppIcon-512@2x.png` も差し替え）。
- `package.json` / `capacitor.config.json`（appId `com.zerogravityfilms.zeronavi`、appName「ゼロナビ」、webDir `www`）/ `sync-www.js` / `.gitignore`（node_modules, www）。
- `ios/`: `npx cap add ios` で生成（Swift Package Manager 構成、CocoaPods不要）。

## index.html の変更（`<head>`）
manifest リンク、`theme-color`、`apple-touch-icon`、Service Worker 登録スクリプト（http/https のみ・try/catch。Capacitor の `capacitor://` では登録しない）。

## ワークフロー
`npm run cap:sync`（www へコピー → `cap sync ios`）→ macOS の Xcode で `ios/App` を開いてビルド。

## 検証
JS3ブロック・manifest(JSON)・service-worker の構文OK、CSS波括弧バランスOK、通信呼び出し0件、既存のナビゲーション疑似テスト12項目PASS。Xcodeビルド・実機/オフライン起動は未検証（Windows環境のため）。
