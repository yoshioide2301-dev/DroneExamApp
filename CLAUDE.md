# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 🔄 開発の上昇サイクル / 🔒 セキュリティ＆コスト厳守ルール

このプロジェクトの開発フロー・セキュリティ方針・コスト方針の正式な定義は
[`docs/manual/development_style.md`](docs/manual/development_style.md) を参照すること。
修正完了時は同ファイル配下(`docs/manual/`)へ技術履歴サマリーを自動蓄積する。

特に以下は毎セッション厳守:
- **個人情報・認証情報・クライアント情報をコードにハードコード/読込しない**
- **コスト・トークン節約のため、コード変更は常に最小限かつ簡潔に。不要な外部ライブラリを勝手に追加しない**

## Project Overview

**DroneQuizApp**(ドローン国家資格 学科対策アプリ)は、無人航空機操縦士(一等・二等)国家資格の学科試験対策を行う単一HTMLファイルのWebアプリです。国土交通省「無人航空機の飛行の安全に関する教則(第5版)」に準拠した全128問を収録しています。

本番公開URL: **https://yoshioide2301-dev.github.io/DroneExamApp/**
(GitHub Pages / リポジトリ `DroneExamApp` は Public)

## 🚀 起動・開発コマンド

- ローカル起動: `node server.js` → `http://localhost:8000` でアクセス
  - `server.js` は依存パッケージ不要の素朴な静的ファイルサーバー(`http`/`fs`のみ使用)。`npm install` は不要。
- ビルドステップは存在しない。`index.html` を直接編集し、保存すればそのまま動作に反映される。
- デプロイ: `main` ブランチに push すると GitHub Pages が自動再ビルド・再公開する(手動デプロイ操作は不要)。
  ```
  git add .
  git commit -m "..."
  git push
  ```

## 🎨 コードスタイル・デザインルール

- **単一ファイル構成が絶対ルール**: HTML/CSS/JS は全て `index.html` 一枚に `<style>`/`<script>` インラインで記述する。別ファイルへの分割(`.css`/`.js`切り出し)はしないこと。
- **ダークテーマ(ネイビー基調)UIを維持する**: 背景は `--navy-top` / `--navy-deep` / `--navy-bottom` によるグラデーション。新しいUIパーツを追加する場合もこのカラースキームを踏襲すること。
- **PC向けプレビュー用の「疑似iPhoneフレーム」(`.phone-frame` / `.phone-notch`)は表示用の飾りであり、実機PWA/スマホブラウザでは `@media (max-width:480px)` と `@media (display-mode:standalone)` によって縁取り・ノッチ・ダミーステータスバー(`.status-bar`)を `display:none` にして消す設計になっている。**
  - 実機で二重表示になる不具合が過去に発生したため、フレーム装飾に新要素を追加する際は必ずこの2つの `@media` ブロックにも非表示化ルールを追記すること。
- 画面切り替えは `.screen` / `.screen.active` のクラス付け替え方式(`showScreen(id)`)。SPA的なルーティングライブラリは使わない。
- SwiftUI設計思想のプロトタイプが `DroneQuizApp/`(Swiftファイル一式: `App/` `Models/` `ViewModels/` `Views/`)に残っている。これはデザイン・データ構造の**参照元**であり、Web版のデプロイ対象には含まれない(GitHub Pagesは `index.html` のみを配信)。UI変更時はこのSwiftUI版との一貫性を意識する。

## 💾 データ構造・プロジェクト構造

```
TestApp/
├── index.html        # アプリ本体(HTML+CSS+JS全部入り、デプロイ対象)
├── server.js          # ローカル確認用の簡易静的サーバー
└── DroneQuizApp/       # SwiftUIプロトタイプ(参照用、デプロイ対象外)
    ├── App/
    ├── Models/
    ├── ViewModels/
    └── Views/
```

- **`CHAPTERS`**: 教則の章構成(全5章)。`id` / `title` / `subtitle` / `icon` / `pageRange` を持つ配列。
- **`QUESTIONS`**: 全128問の設問データ配列。各要素は以下の形式:
  ```js
  { id:"ch1-01", licenses:["first","second"], chapterID:1, category:"操縦者の心得",
    question:"...", choices:[...], correct:1, explanation:"...", ref:"第1章 1節（P.7）" }
  ```
  - `licenses` は `"first"`(一等)/`"second"`(二等)資格区分。両資格共通の設問は両方を含む。
- **弱点克服モード用 localStorage キー**: `droneQuizWrongQuestionIds`(定数名 `WRONG_IDS_KEY`)
  - 誤答した設問の `id` を JSON 配列として保存する。次回起動時にこのキーを読み込み、弱点だけを抽出した復習セッションを構成する。
  - localStorage が使用できない環境(プライベートブラウズ等)では例外を握りつぶし、記憶をスキップする設計(`try/catch`)になっているため、この挙動を壊さないこと。
- 時刻表示などの装飾要素(`#clock`)は `initClock()` が15秒間隔で更新するが、実機では前述の通り非表示化される。
