# 2026-09-19 サーバー＆ngrok 一発起動バッチの追加

## 概要
改修・検証のたびに手動で行っていた「ディレクトリ移動 → `node server.js` → `ngrok http 8000`」を自動化するWindows用バッチを作成。

## 成果物
- `C:\Users\yoshi\Desktop\ドローンアプリ一発起動.bat`(リポジトリ外・デスクトップ直下に配置、デプロイ対象外)

## 動作
1. ウィンドウ1(cmd): `cd /d C:\Users\yoshi\Desktop\TestApp` → `node server.js`(ポート8000待機)
2. 2秒待機後、ウィンドウ2(PowerShell): `ngrok http 8000`

## 注意
- ngrok が PATH に通っていて、認証トークン設定済みであること(トークンはコード・リポジトリに含めない)。
- 外部ライブラリの追加なし。バッチ内は文字化け回避のためASCIIのみ。
- 終了は各ウィンドウを閉じる(Ctrl+C)。
