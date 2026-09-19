# 技術履歴: 章別「誤答消去型」学習モード（サブタブ）

最終更新: 2026-09-19

## 概要
「問題演習」タブの「章から選ぶ」上部に2つのサブタブを追加。「間違えた問題のみ」では各章の誤答数を「あとX問」で表示し、正解するたびに誤答リストから消去、0件で章カードをゴールド化して「🎉 対策完了！」を表示する。CBT模擬試験・SVGグラフ・カウントダウン・おすすめ10問・学習資料・報告フォームのコードとキーは無変更（差分パッチのみ）。

## サブタブ構造
- `#chapterViewSeg`（`.seg`）: 「章から選ぶ（全問）」/「章から選ぶ（間違えた問題のみ）」。`setChapterView(view)` が `state.chapterView`（`'all'`既定 / `'wrong'`）を更新し `renderChapterList()` を再描画。
- 全問ビュー: 従来どおり `startQuiz(chapterId)`、カードに総問題数。
- 誤答ビュー: `startChapterWrong(chapterId)`。カード右側のバッジは
  - 残りあり: `あと X 問`（`.wrong-badge`、薄い赤背景/オレンジ文字）
  - 残り0かつ達成済み: `🎉 対策完了！`（`.clear-badge`、ゴールド）＋カード枠線を `#eab308`（`.chapter-card.cleared`）
  - 残り0で達成履歴なし: `誤答なし`（グレー）。※未学習の章が「対策完了」と誤表示されるのを避けるため。
- `backToMenu()` が `renderChapterList()` を呼ぶよう変更し、戻った際にバッジが最新化される。

## LocalStorage連携
- 使用する誤答リストは既存の `droneQuizWrongQuestionIds_first/second`（依頼文の `wrong_questions` は存在しないため既存キーを利用）。章の判定は問題の `chapterID`、資格は `licenses`。
- 新規キー `droneChapterCleared_<license>` = `{ "<chapterID>": true }`（達成フラグ）。`recordAnswer()` 内で、
  - 誤答リストからIDを**削除した結果その章が0件**になった時に ON、
  - その章で**不正解**になった時に OFF。
  どのモード（おすすめ10問・CBT・弱点克服等）で消し込んでも同じ規則で更新される。
- ヘルパー: `wrongQuestionsFor(chapterId, license)` / `loadChapterCleared` / `setChapterCleared`。

## 消去ロジックとリアルタイムUI
- 抽出: 誤答リスト ∩ 当該章 ∩ 現在の資格。0件ならトースト「この章に間違えた問題はありません。」で開始しない。
- 正解した瞬間に既存 `recordAnswer()` がIDをリストから削除（不正解は残したまま次へ）。直後に `updateRemainBadge()` がクイズ画面上部の `#quizRemainBadge` を「あと X 問」へ更新（0で金色の「🎉 対策完了！」）。
- セッションは開始時点の誤答リストを1周（不正解は同一セッション内では再出題しない）。結果画面は残りが0なら金色「🎉 対策完了！」、残りがあれば「この章の誤答 あとN問」を併記。「もう一度解く」は残りがあれば再抽出、0なら一覧に戻る。
- `state.mode = 'chapterWrong'` を追加（`retryChapter` / `showResult` / `renderQuestion` を分岐）。

## 検証
- `<script>` 抽出で `node --check` OK。既存キー/定数（`KISOKU_BASE_VERSION`・`CBT_HISTORY_KEY`・`EXAM_DATE_KEY`・`FEEDBACK_FORM_URL`）の残存を確認。
- モックDOMで、章別件数、正解時の「あと3→2問」、不正解でリスト保持、他章の誤答が消えないこと、0件でのバッジ/フラグON・金色結果表示、再誤答でフラグOFFを確認。
- 実ブラウザでの目視確認（ゴールド枠・バッジ配色・スマホ幅）は未実施。
