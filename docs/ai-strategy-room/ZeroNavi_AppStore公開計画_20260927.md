# ZeroNavi App Store公開計画

作成日：2026-09-27

## 1. 現在の基本認識

ZeroNaviは「アプリをこれから作る段階」ではなく、「既存アプリを公開品質に仕上げ、App Storeで初回公開する段階」にある。

GitHub上の現行アプリ実装は368問。一等問題は以下の構成で、1-C081～1-C100の20問が欠落している。

- 旧来問題：78問
- 二等 2-H001～2-H150：150問
- 一等 1-C001～1-C080：80問
- 一等 1-C101～1-C160：60問
- 合計：368問
- 欠落：1-C081～1-C100：20問

既存IDの重複は確認されていない。

## 2. 問題データの最優先対応

### 方針

- 既存問題のID・順番は変更しない。
- 1-C081～1-C100を新規20問として追加する。
- 一等問題を対外的に「100問」と明確に説明できる状態にする。
- 新規20問も国土交通省「無人航空機の飛行の安全に関する教則 第5版」を基準に作成・検証する。
- 既存368問についても、公開前に正解番号、選択肢、解説、参照箇所、重複、出題範囲を機械的・内容的に再確認する。

国土交通省は第5版を2026年7月7日に公布し、2026年7月14日から学科試験を第5版準拠としている。したがって公開前の最終QAは第5版基準で行う。

## 3. MacBook Pro問題の扱い

過去にMacBook ProでXcode実機ビルドを試行して途中で中断した経緯があるため、Mac側にはGitHub mainと一致しない残骸・生成物・旧iOSプロジェクトが存在する可能性を正式なリスクとして記録する。

原則：

- MacBook Proのローカルフォルダを「正」とみなさない。
- Mac上の残骸をGitHubへ戻さない。
- Mac側でXcodeプロジェクトを開く場合も、まずGitHub mainとの一致確認を行う。
- Windows側のローカル TestApp も現時点ではGitHub mainと一致していないため、同期前に未追跡ファイル・差分を確認する。
- GitHub mainを唯一のリリース候補ソースとして扱い、ローカルはそこから再構築・検証する。

## 4. Windows中心の公開方針

通常のiOSビルドはXcodeが必要だが、AppleのApp Store ConnectはビルドアップロードをXcode、Swift Playground、altool、Transporter等で受け付けている。また、CodemagicのようなクラウドCI/CDでは、クラウド上のMac環境でiOSをビルド・署名し、TestFlightやApp Storeへの配布まで自動化できる。

したがってZeroNaviでは、MacBook Proを常用作業環境にせず、次の方式を第一候補として検証する。

**Windows PC → GitHub main → クラウドmacOSビルド（CodemagicまたはGitHub Actions）→ 署名済みIPA → App Store Connect / TestFlight → App Review**

クラウド方式の採用は、実際のビルド可否・Apple Developer資格情報・署名設定・費用を確認してから確定する。

## 5. iPhone / iPad方針

GitHub上のXcode設定では現在 TARGETED_DEVICE_FAMILY = "1,2" で、iPhoneとiPadを対象としている。

AppleはiPadで実行するアプリについてiPadスクリーンショットを必須としている。そのため、初回公開前に以下を明示的に決定する。

A. iPhone+iPadを正式サポートする
B. iPhoneのみへ変更する

変更は承認を取ってから行う。現時点ではコード変更をしない。

## 6. App Store提出に必要な主な項目

- App Storeアプリレコード
- アプリ名
- サブタイトル
- 説明文
- キーワード
- カテゴリ
- 年齢レーティング
- プライバシーポリシーURL
- App Privacy回答
- サポートURL
- 著作権
- コンテンツ権利関係
- 輸出コンプライアンス
- スクリーンショット
- ビルド
- App Review用メモ

AppleはiOSアプリのプライバシーポリシーURLを必須としており、App Store配布時にはApp Privacyでデータ取扱いを説明する必要がある。

## 7. 推奨実行順

1. 1-C081～1-C100を追加
2. 一等問題が100問になることを確認
3. 既存問題を第5版基準でQA
4. CLAUDE.mdの古い「208問」記載を実態に合わせて修正
5. Windows TestApp のローカル差分・未追跡ファイルを確認してからGitHub mainへ安全に同期
6. MacBook Pro側は必要なら別途「残骸調査」だけを行い、リリースソースにはしない
7. クラウドmacOSでCapacitor iOSビルドを検証
8. TestFlightで実機QA
9. App Store Connectメタデータ・スクリーンショット登録
10. App Review提出
11. 無料公開・利用者獲得・バグ報告・改善サイクルへ移行

## 8. 重要な注意

- 「App Store登録」はWindowsのブラウザからApp Store Connectの設定・メタデータ登録を進められるが、署名済みiOSバイナリの生成にはmacOS側のビルド環境が必要になる。ここをクラウドmacOSで置き換えるのが今回の重要な検証ポイント。
- MacBook Proを使わない方針でも、Apple Developer ProgramとApp Store Connectの契約・証明書・APIキー等の設定は必要。
- 初回公開では、問題データの正確性を最優先し、問題数だけを増やすことを目的にしない。

## 9. Apple / Codemagic公式出典

- Apple「Upload builds」：https://developer.apple.com/help/app-store-connect/manage-builds/upload-builds
- Apple「Submit an app」：https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app
- Apple「App privacy」：https://developer.apple.com/help/app-store-connect/reference/app-information/app-privacy
- Apple「Screenshot specifications」：https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications
- Codemagic「First Release Pipeline」：https://docs.codemagic.io/yaml-quick-start/first-signed-build/
- Codemagic「Using codemagic.yaml」：https://docs.codemagic.io/yaml-basic-configuration/yaml-getting-started/
