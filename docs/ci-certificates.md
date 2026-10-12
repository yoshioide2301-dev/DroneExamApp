# CI の署名用証明書の自動取り消しと、復旧の手順

2026-10-12 作成（Claude）。本人承認：証明書の取り消しの自動化はOK。ただし本番リリース中の最新版を誤って消さない再確認と、万一のときの復旧手順を用意すること。

## なぜ取り消すのか
GitHub Actions のビルドは毎回まっさらな Mac で動く。自動署名（`-allowProvisioningUpdates`）は、そのたびに Apple の開発用証明書を1枚作る。放っておくと上限に達し、ビルドが「Your account has reached the maximum number of certificates」で失敗する（10/12 のビルド4で発生し、11枚を掃除した）。

## 仕組み
- スクリプト：`.github/scripts/asc-certs.mjs`（App Store Connect API）
- `ios-testflight.yml`：ビルド前に証明書の一覧を保存し、最後に `revoke-new` で「この回に作った開発用の証明書」だけを取り消す。
- `（DrivingSchoolApp 側にあり）`：上限に達したときの一回限りの掃除（タグ `asc-certs-cleanup-*`）。開発用だけを取り消す。

## 誤って消さないための再確認（revoke-new）
次のすべてに当てはまる証明書だけを取り消す。一つでも外れたら取り消さない。
1. ビルド前の一覧に無い（この回に作られた）
2. 開発用（DEVELOPMENT／IOS_DEVELOPMENT）。**配布用（DISTRIBUTION）は自動では一切取り消さない**
3. 作られたばかり（有効期限が今から360日より先）
4. 1回に取り消すのは2枚まで。それより多ければ、何もせずに止める

取り消しが失敗しても、ビルドの成功・失敗には影響しない。

## リリース中のアプリへの影響
- 証明書は、アプリを作って署名するときに使うもの。App Store で公開中のアプリと TestFlight に届いたビルドは、Apple が署名し直して配るため、証明書を取り消しても**利用者の手元のアプリや公開中の版は止まらない**。
- 開発用の証明書は、App Store・TestFlight の配布には使われない。

## 万一、必要な証明書を消してしまったとき（復旧の手順）
証明書は「取り消し」を元に戻せない。新しく作り直して復旧する。
1. **CI のビルドの場合**：何もしなくてよい。次のビルドで自動署名が新しい証明書を作る。タグを付け直すか、Actions の画面で失敗した実行を「Re-run」する。
2. **Mac の Xcode で手元から署名していた場合**：Xcode →「Settings」→「Accounts」→ チームを選び「Manage Certificates」→「＋」で「Apple Development」（配布なら「Apple Distribution」）を作る。または Xcode の自動署名にまかせてビルドすれば作り直される。
3. **配布用の証明書を手で作り直す場合**：developer.apple.com →「Certificates, Identifiers & Profiles」→「Certificates」→「＋」→「Apple Distribution」。Mac のキーチェーンアクセスで証明書署名要求（CSR）を作って登録し、ダウンロードした証明書を開いてキーチェーンに入れる。
4. **プロビジョニングプロファイルが無効になった場合**：自動署名なら次のビルドで作り直される。手動のものは developer.apple.com の「Profiles」で作り直す。
5. 何を取り消したかは、Actions の実行ログ（「この回に作った開発用の証明書を取り消す」の手順）に証明書 ID が残る。

## 確認の手順
- 一覧だけ見る：`ASC_KEY_ID`・`ASC_ISSUER_ID`・`ASC_KEY_P8` を環境変数に入れて `node .github/scripts/asc-certs.mjs list`
- 上限に達したら：タグ `asc-certs-cleanup-YYYYMMDD` を push（本人の確認のうえで）
