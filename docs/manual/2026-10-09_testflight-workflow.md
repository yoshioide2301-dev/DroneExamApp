# 2026-10-09 TestFlight 配信の準備（DAY3）

- ブランチ `appstore-prep-1.1.0` を GitHub へ push した（main へは入れない。ユーザー承認B案）。
- `.github/workflows/ios-testflight.yml` を追加した：App Store Connect APIキーで自動署名し、archive → export（destination=upload）で TestFlight へアップロード。起動は手動またはタグ `ios-v*`。ビルド番号は run_number。鍵は RUNNER_TEMP に書き、終了時に削除する。
- 手動実行（workflow_dispatch）は、このファイルが main にあるときだけ使える。ブランチではタグ push で起動する。
- 未検証：Apple Developer の承認前のため、署名付きの実行は一度もしていない。Secrets（4件）は本人が登録する（docs/appstore/testflight-setup.md）。
- `ITSAppUsesNonExemptEncryption=false` は DAY3 前半で追加済み。
