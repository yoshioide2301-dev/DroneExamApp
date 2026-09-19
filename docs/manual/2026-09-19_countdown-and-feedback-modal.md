# 技術履歴: 試験日カウントダウン / 今日のおすすめ問題 / 問題報告ハーフモーダル

最終更新: 2026-09-19

## 概要
`index.html`（単一ファイル構成を維持）に以下3機能を追加。既存のネイビーテーマ・進捗ゲージ・ライセンス別LocalStorage分離は変更なし。

## 1. CBT試験日カウントダウン
- **配置**: メニュー画面の一等/二等トグル直下、進捗ゲージの上（`#countdownArea`）。
- **LocalStorage**: キー `droneExamTargetDate`、値は `"YYYY-MM-DD"`（ライセンス共通）。形式不正な値は未設定扱い。
- **描画関数**: `renderCountdown()`。状態遷移:
  | 状態 | 表示 |
  |---|---|
  | 未設定 | 「試験日を設定してカウントダウンを開始」ボタン → タップで `input[type=date]` + 保存/キャンセル |
  | 未来日 | 「YYYY年M月D日(曜) の試験まで あと **XX** 日」（ゴールド大数字）＋再設定/クリア |
  | 当日 | 応援メッセージ＋再設定/クリア |
  | 過去日 | 「設定した試験日は過ぎました」＋再設定/クリア |
- 日数は端末ローカル日付の0時基準（`Math.round`）で算出。`backToMenu()` と初期化時に再描画。
- 関連関数: `loadExamDate` / `saveExamDate` / `editCountdown` / `confirmCountdown` / `cancelCountdown` / `clearCountdown`。

## 2. 今日のおすすめ問題（10問）
- **UI**: カウントダウン直下の `.daily-btn`（`startDailyMode()`）。
- **抽出**: `buildDailyQuestions()` — 現在の `state.license` の `droneQuizWrongQuestionIds_<license>` から最大5問（`DAILY_WRONG_MAX`）をランダム抽出し、残りを未選択の同ライセンス問題からランダム補完して計 `DAILY_TOTAL`(=10) 問。誤答なしなら全問ランダム。
- **モード**: `state.mode = 'daily'`。プレイ中はクイズ上部タイトルが「今日のおすすめ問題（X / 10）」、既存の進行バーもそのまま連動。
- **結果**: `showResult()` が daily の場合「本日の学習完了！」＋星アイコンを表示。「もう一度解く」は問題を再生成（`retryChapter()`）。
- 回答は通常通り `recordAnswer()` を通るため、誤答・進捗データは既存キーに反映される。

## 3. 問題・解説の報告（ハーフモーダル）
- **UI**: 解説カード末尾の `.report-btn`（`openReport()`）→ `.phone-screen` 内に絶対配置した `.sheet`（下からスライドイン、`.sheet-backdrop` で背景減光）。実機用のフレーム非表示ルール追記は不要（フレーム装飾の追加ではないため）。
- **入力項目**: どこの誤り（問題文/解説/その他、単一選択）／内容（誤字・脱字、選択肢・正誤判定が違う、図表の誤り、その他、複数選択・1つ以上必須）／補足（任意、`maxlength=250`、文字数カウンタ）。
- **注記**: 「アプリのバージョン・端末情報（UAから取得したOS情報）が一緒に送信されます。」
- **送信仕様（`submitReport()`）**:
  - `application/x-www-form-urlencoded`（`URLSearchParams`）を `fetch(FEEDBACK_FORM_URL, {method:"POST", mode:"no-cors"})` で送信。レスポンスは読めないため失敗は握りつぶす。
  - 内容チェックボックスは同一 entry キーを複数 append（Googleフォームのチェックボックス質問の仕様）。
  - 送信項目: 問題ID（`currentQuestion().id`）/ 誤り箇所 / 内容 / 補足 / OS情報（`getOSInfo()`: iOS x.y・Android x・Windows・macOS・Linux）/ `APP_VERSION`。個人識別情報は送らない。
- **差し替えポイント（JS定数）**:
  - `FEEDBACK_FORM_URL` … `https://docs.google.com/forms/d/e/<FORM_ID>/formResponse`
  - `FEEDBACK_ENTRY` … `questionId/target/kinds/note/device/version` の `entry.XXXXXXXXXX`（フォームの「事前入力したURLを取得」で確認）
  - `APP_VERSION` … リリース時に更新
  - **現状はプレースホルダー**（URLに `PLACEHOLDER` を含む間は送信せず `console.info("[report:mock]", ...)` のみ、UIは成功トースト表示）。実URL設定で自動的に本送信へ切り替わる。

## 検証
- `<script>` を抽出し `node --check` で構文OK。
- Node上のモックDOMで、おすすめ抽出（誤答5+ランダム5=10問・重複なし／誤答なしで10問）、カウントダウンの未来/当日/過去日分岐、UAからのOS判定を確認。
- 実ブラウザでの目視確認（モーダルのアニメーション、date入力UI）は未実施。`node server.js` → `http://localhost:8000` で確認推奨。
