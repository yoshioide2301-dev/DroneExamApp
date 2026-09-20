# 技術履歴: プレビュー用スマホ枠の撤廃とフルスクリーン・レスポンシブ化（本番リリース仕様）

最終更新: 2026-09-20

## 変更内容（`index.html`）
- **削除したHTML**: `.page` ラッパー、`.page-caption`（「DroneQuizApp Web Preview / SwiftUIプロトタイプ準拠・ブラウザ動作版」）、`.phone-frame`、`.phone-notch`、`.status-bar`（`#clock`・電波/Wi-Fi/電池のSVG）。
- **削除したCSS**: `.page` / `.page-caption` / `.phone-frame`（`::before`/`::after` のサイドボタン含む）/ `.phone-notch` / `.status-bar` / `.status-icons`、および `@media (max-width:480px)` と `@media (display-mode:standalone)` の「枠を消す」ための上書きルール（不要になったため）。
- **削除したJS**: `initClock()` とその呼び出し（`#clock` が存在しないため）。
- **新構造**: `.phone-screen` を `.app-shell` に置き換え（`position:relative; width:100%; height:100vh→100dvh; overflow:hidden`＋ネイビーのグラデーション）。枠・角丸・余白・影なしで実機ブラウザ全体（iPhone/iPad）に直接広がる。`.app-content` 以下（画面・モーダル・シート・トースト）は変更なし。モーダル等は `position:absolute; inset:0` のまま `.app-shell` 基準で全画面に重なる。`body` 背景はネイビー（`--navy-deep`）に統一。
- `CLAUDE.md` の該当ルール（疑似iPhoneフレームの二重表示回避の記述・`#clock`）を撤廃済みの実態に合わせて更新。

## 検証
- `<script>` 構文チェックOK、`<div>` 開閉97/97一致、CSS波括弧291/291一致、旧クラス名・`initClock`・`#clock` の残存なし。
- 疑似DOMモックで、起動・再開ポップアップ・「あとで見直す」フィルター・成長グラフ（本番/ミニ）の既存検証を再実行し全PASS、外部通信0件。問題データ（208問）・LocalStorageキー・各モードのロジックは無変更。
- 実機/ブラウザでの目視は未実施（要確認: iPad横幅での各画面の間延び有無）。
