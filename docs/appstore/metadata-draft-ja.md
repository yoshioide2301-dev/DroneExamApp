# ゼロナビ App Store Connect 入力案（日本語・下書き）

作成：2026-10-09（Claude）。未入力・未公開。数値・機能はブランチ `appstore-prep-1.1.0` の index.html で確認した範囲だけを書いた。
方針：[紹介方針 2026-10-05](https://github.com/yoshioide2301-dev/DrivingSchoolApp/blob/master/docs/ai-strategy-room/ZeroNavi-marketing-positioning-20261005-1336.md)（過去問集ではない／公式・合格保証・常に最新と書かない）。

## 基本情報
| 項目 | 案 | 制限 |
|---|---|---|
| アプリ名 | ゼロナビ ドローン国家資格 学科試験対策（2026-10-09 App Store Connect に登録） | 30文字 |
| サブタイトル | 一等・二等 無人航空機操縦士の学科試験対策 | 30文字 |
| プライマリカテゴリ | 教育 | |
| セカンダリカテゴリ | 参考資料 | |
| 価格 | 無料（App内課金なし） | |
| 著作権 | 2026 Yoshio Ide（アプリ内表示と一致） | |
| 販売者名 | Yoshio Ide（Developer は個人で登録。2026-10-09 確認） | |
| バンドルID | com.zerogravityfilms.zeronavi | |
| プライバシーポリシーURL | https://yoshioide2301-dev.github.io/DroneExamApp/docs/appstore/privacy.html（2026-10-10 公開） | |
| サポートURL | https://yoshioide2301-dev.github.io/DroneExamApp/docs/appstore/support.html（2026-10-10 公開） | |
| バージョン | 1.1.0（ビルド 1） | |

## キーワード（100文字以内、アプリ名・サブタイトルの語は重複させない）
```
無人航空機,操縦士,CBT,模試,教則,第5版,問題集,ライセンス,免許,飛行ルール,安全,オフライン,練習問題
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
・学習データは端末内にのみ保存され、外部に送信されません（気になる点の報告は、ご自身でメールを送信した場合のみ運営者に届きます）。

## App Privacy（プライバシー）
- 回答（2026-10-10 変更）：「データを収集する」→ 連絡先情報「メールアドレス」と、ユーザコンテンツ「その他のユーザコンテンツ」（報告の内容）。用途はどちらも「アプリの機能」。トラッキングには使わない。ユーザーに関連付ける：はい（返信のため）。
- 根拠：報告は mailto でメールアプリを開き、利用者が送信した場合だけ zg.dev2301@gmail.com に届く（10/10 本人決定、ミチトと共通方式）。学習データは端末の localStorage のみで、外部通信はない。
- 旧回答「データを収集しない」（2026-09-30）は、報告が端末内保存だけだった版のもの。
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
1. Apple Developer Program：**2026-10-03 承認済み**（個人。年額 ¥12,800、2027-10-02 に自動更新）。次は testflight-setup.md の手順1〜4。
2. プライバシーポリシー／サポートページの公開URL。運営者名は「Yoshio Ide（Zero Gravity Films）」で反映済み。連絡先は未定（専用アドレスを作るかどうか）。docs/appstore/ の下書きを使う。
3. ~~iPad 対応~~ → 2026-10-09 決定：iPhone＋iPad 両対応（`TARGETED_DEVICE_FAMILY = "1,2"` のまま）。iPad 13インチのスクリーンショットが必須。iPad の画面崩れ確認が必要。
4. ~~署名方式~~ → 2026-10-09 決定：GitHub Actions。手順は testflight-setup.md。
5. スクリーンショット（iPhone 6.9インチ必須）の作成。
6. main への反映：2026-10-09 決定（B案）。ブランチで TestFlight の確認まで進め、App Store 公開と同じタイミングで main に入れる（教材反映の承認が必要）。
