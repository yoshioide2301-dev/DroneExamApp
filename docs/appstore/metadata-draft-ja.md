# ゼロナビ App Store Connect 入力案（日本語・下書き）

作成：2026-10-09（Claude）。未入力・未公開。数値・機能はブランチ `appstore-prep-1.1.0` の index.html で確認した範囲だけを書いた。
方針：[紹介方針 2026-10-05](https://github.com/yoshioide2301-dev/DrivingSchoolApp/blob/master/docs/ai-strategy-room/ZeroNavi-marketing-positioning-20261005-1336.md)（過去問集ではない／公式・合格保証・常に最新と書かない）。

## 基本情報
| 項目 | 案 | 制限 |
|---|---|---|
| アプリ名 | ゼロナビ ドローン国家資格 学科対策 | 30文字 |
| サブタイトル | 一等・二等 無人航空機操縦士の学科試験対策 | 30文字 |
| プライマリカテゴリ | 教育 | |
| セカンダリカテゴリ | 参考資料 | |
| 価格 | 無料（App内課金なし） | |
| 著作権 | 2026 Yoshio Ide（アプリ内表示と一致） | |
| バンドルID | com.zerogravityfilms.zeronavi | |
| バージョン | 1.1.0（ビルド 1） | |

## キーワード（100文字以内、アプリ名・サブタイトルの語は重複させない）
```
無人航空機,操縦士,試験,CBT,模試,教則,第5版,問題集,ライセンス,免許,飛行ルール,安全,オフライン
```

## プロモーションテキスト（170文字以内）
国土交通省「無人航空機の飛行の安全に関する教則（第5版）」をもとに独自に作成した388問で、一等・二等の学科試験対策ができます。CBT形式の模擬試験と弱点の復習で、本番に近い形で学べます。

## 説明文
ゼロナビは、無人航空機操縦士（一等・二等）国家資格の学科試験対策アプリです。

■ 過去問集ではなく、独自に作成した問題です
国土交通省「無人航空機の飛行の安全に関する教則（第5版）」や関連資料をもとに、学習用の問題を独自に作成しています。各問に解説と教則の参照箇所を付けています。

■ 主な機能
・全388問（一等向け・二等向け・共通問題）
・一等／二等の切り替え
・章ごとの学習と、間違えた問題だけの復習
・CBT形式の模擬試験と合格ラインの表示
・学習履歴と成績の推移グラフ
・試験日までのカウントダウン
・文字サイズ・表示の調整
・通信なしで使えます（オフライン対応）

■ こんな方に
・一等・二等の学科試験を受ける方
・飛行ルールや安全の知識を確認したい初心者・趣味の操縦者の方

■ ご注意
・本アプリは国土交通省・指定試験機関の公式アプリではありません。
・合格を保証するものではありません。最新の制度・試験案内は公式の情報をご確認ください。
・学習データは端末内にのみ保存され、外部に送信されません。

## App Privacy（プライバシー）
- 回答：「データを収集しない」
- 根拠（2026-09-30 コード確認）：外部通信なし（fetch/XHR/外部URL/外部スクリプト/外部フォントなし）。保存は端末の localStorage のみ。「気になる点を報告」も端末内保存のみで送信しない。
- 再確認：申請直前の最終ビルドでもう一度確認する。

## 年齢区分
- 質問票はすべて「なし」の想定 → 4+

## 輸出コンプライアンス
- Info.plist に `ITSAppUsesNonExemptEncryption = false` を設定済み（暗号化不使用）。

## App Review へのメモ（英語で入力）
```
ZeroNavi is a study app for the Japanese national drone pilot license (written exam).
No login or account is required. All features work offline; no data leaves the device.
The questions are original, created by the developer based on the official MLIT
"Drone Flight Safety Guidelines (5th edition)". This app is not affiliated with
any government agency or the designated examination body.
```

## 本人の判断・操作が必要なもの（未決）
1. Apple Developer Program 登録（年会費・課金）と App Store Connect のアプリ登録。
2. プライバシーポリシー／サポートページの公開URL（連絡先・運営者名を決めて公開）。docs/appstore/ の下書きを使う。
3. iPad 対応：現在 `TARGETED_DEVICE_FAMILY = "1,2"`。両方対応なら iPad 13インチのスクリーンショットも必須。iPhone のみなら設定を "1" に変更。
4. 署名・アップロード方式（Codemagic または GitHub Actions＋App Store Connect APIキー）。
5. スクリーンショット（iPhone 6.9インチ必須）の作成。
6. ブランチ `appstore-prep-1.1.0` を main へ反映（＝GitHub Pages の公開版も更新される）。
