# TestFlight 配信の準備手順（Apple Developer 承認後）

作成：2026-10-09（Claude）。署名方式は GitHub Actions に決定（2026-10-09 ユーザー承認）。
ワークフロー：`.github/workflows/ios-testflight.yml`（署名付きビルド → App Store Connect へアップロード。審査提出・公開はしない）。

## 本人の操作（PCのブラウザで、計4か所）
1. **Bundle ID の登録**：developer.apple.com → Certificates, Identifiers & Profiles → Identifiers → ＋ → App IDs → App。
   Bundle ID（Explicit）に `com.zerogravityfilms.zeronavi`、説明に `ZeroNavi`。機能のチェックは不要。
2. **アプリの登録**：appstoreconnect.apple.com → アプリ → ＋ → 新規アプリ。
   プラットフォーム iOS／名前「ゼロナビ ドローン国家資格 学科対策」／言語 日本語／Bundle ID は手順1のもの／SKU `zeronavi`。
3. **APIキーの作成**：App Store Connect → ユーザとアクセス → 統合 → App Store Connect API → チームキー → ＋。
   名前 `github-actions`、アクセス「**管理（Admin）**」（クラウドの配布用証明書を作るために必要）。
   `.p8` ファイルは **1回しかダウンロードできない**。Key ID と Issuer ID も控える。
4. **GitHub Secrets への登録**：github.com/yoshioide2301-dev/DroneExamApp → Settings → Secrets and variables → Actions → New repository secret を4回。

   | 名前 | 中身 |
   |---|---|
   | `ASC_KEY_ID` | 手順3の Key ID |
   | `ASC_ISSUER_ID` | 手順3の Issuer ID |
   | `ASC_KEY_P8` | `.p8` ファイルをメモ帳で開いた全文（BEGIN〜END の行を含む） |
   | `APPLE_TEAM_ID` | developer.apple.com → Account → メンバーシップの詳細 の チームID（10文字） |

   登録したら `.p8` ファイルは安全な場所に保管する。チャット・メール・repoには貼らない。

## Claude の操作（登録が済んだと知らせてもらった後）
- ブランチ `appstore-prep-1.1.0` にタグ `ios-v1.1.0-b<番号>` を付けて push → ワークフローが起動。
- ビルド番号は実行回数（`github.run_number`）で自動的に増える。
- 成功すると15〜30分ほどで App Store Connect の TestFlight にビルドが表示される。
- 内部テスター（本人のApple ID）を追加し、iPhone／iPad の TestFlight アプリで実機確認。

## 注意
- repo は公開なので Actions のログは誰でも見られる。Secrets の値は GitHub が自動で伏せ字にする。ワークフローは鍵の中身を表示せず、終了時に削除する。
- 審査への提出（App Review）と公開は、本人の承認を得てから App Store Connect で行う。
