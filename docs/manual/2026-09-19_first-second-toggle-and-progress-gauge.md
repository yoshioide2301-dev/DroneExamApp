# 技術履歴: 一等・二等スマート切り替え + 進捗プログレスゲージ

最終更新: 2026-09-19

## 概要

`index.html` に対し、以下2点をウェザップ風のシックなUIで実装した。

1. 一等・二等モードのスライド式トグルスイッチ（メニュー画面ヘッダー直下）
2. ライセンス別の学習進捗ゲージ（解答済み数 / 総問題数 ・ 正解率%、アニメーション付き）

## 実装内容

### 1. 一等・二等トグル（`.license-picker`）
- 既存の `license-btn`（ボタン式）はそのまま活かし、背後に `.license-thumb`（絶対配置の色付きピル）を追加。
- `setLicense(license)` 内で `licenseThumb.style.transform` を `translateX(0)` / `translateX(100%)` に切り替えることで、CSS `transition` によるスライドアニメーションを実現。
- 問題データの判別ロジックは既存の `QUESTIONS[].licenses`（`"first"`/`"second"` 配列）と `questionsFor(chapterId, license)` をそのまま利用（変更なし）。

### 2. 進捗プログレスゲージ（`.progress-card`）
- 新関数 `renderProgressGauge()` が `state.license` に応じて、
  - 総問題数（`QUESTIONS.filter(licenses.includes(license)).length`）
  - 学習進捗（`droneQuizProgress_<license>` に記録された解答済みID数 / 総問題数）
  - 正解率（記録済み解答のうち正解の割合）
  を計算し、メニュー画面上部のカードに描画する。
- 初回描画時に `width:0%` → 実測値へ2段階の `requestAnimationFrame` で遷移させ、CSSの `transition` によるスタンプ感のあるアニメーションを演出。
- `setLicense()` / `recordAnswer()` / `backToMenu()` / 初期化処理の各タイミングで再描画し、常に最新の学習状況を反映する。

### 3. LocalStorage構造の分離（一等・二等が混ざらないように）
- 弱点克服モードの誤答IDリストのキーを、共通の `droneQuizWrongQuestionIds` から **ライセンス別キー** `droneQuizWrongQuestionIds_first` / `droneQuizWrongQuestionIds_second` に分離。
- 学習進捗も同様に `droneQuizProgress_first` / `droneQuizProgress_second` として、ライセンスごとに独立したオブジェクト（`{ [questionId]: isCorrect }`）で保存。
- 既存ユーザーのデータを失わないよう、旧キー `droneQuizWrongQuestionIds` が存在する場合は初回読み込み時に一度だけ、各問題の `licenses` フィールドを見て `first` / `second` それぞれのキーへ振り分け移行し、旧キーは削除する（`migrateLegacyWrongIds()`）。
- 個人情報・認証情報は一切扱っていない（保存されるのは問題IDと正誤フラグのみ）。

## 影響範囲・非互換性
- 既存ユーザーの弱点克服データは初回アクセス時に自動移行されるため、手動対応は不要。
- UIの見た目以外で問題データ構造・章立て・出題ロジックへの変更なし。

## 動作確認
- Node.jsで `<script>` 部を抽出し `node --check` による構文検証を実施（OK）。
- ブラウザ拡張（claude-in-chrome）が未導入のため、実機ブラウザでの目視確認はユーザー側で `node server.js` → `http://localhost:8000` にて実施を推奨。
