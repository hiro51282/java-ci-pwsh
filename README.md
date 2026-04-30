# Java Minimal CI Pipeline (PowerShell + GitHub Actions)

## 概要

このリポジトリは、**PowerShellスクリプトを用いた最小構成のJavaビルド検証パイプライン**をGitHub Actions上で実行するためのサンプルです。

目的は以下の通りです：

* 外部リポジトリからソースを取得（envフェーズ）
* Javaコンパイルを実行（runフェーズ）
* 成功・失敗の両ケースをCI上で検証
* コンパイルエラー内容をログとして取得

---

## 構成

```
.
├─ .github/workflows/ci.yml
├─ scripts/
│  ├─ env.ps1
│  └─ run.ps1
├─ define.json
└─ logs/ (CI実行時に生成)
```

---

## define.json

ビルド全体の定義は1ファイルに集約されています。

```json
{
  "env": {
    "repo": "https://github.com/hiro51282/java-ci-sample",
    "workspace": "./workspace"
  },
  "run": {
    "success": "src/Success.java",
    "fail": "src/Fail.java",
    "logDir": "./logs"
  }
}
```

### env

* `repo`: テスト対象のJavaリポジトリ
* `workspace`: クローン先

### run

* `success`: コンパイル成功するべきファイル
* `fail`: コンパイル失敗するべきファイル
* `logDir`: ログ出力先

---

## scripts

### env.ps1

* define.jsonを読み込む
* 指定されたリポジトリをcloneする

### run.ps1

* Success.java → 成功しなければNG
* Fail.java → 失敗しなければNG
* コンパイルエラーをログ出力
* 最終結果をexit codeで返す

---

## GitHub Actions

ワークフローは以下の順序で実行されます：

1. リポジトリのチェックアウト
2. Java環境のセットアップ
3. env.ps1 実行（環境構築）
4. run.ps1 実行（ビルド＆検証）
5. ログをartifactとして保存

---

## 成功条件

CIは以下を満たした場合に成功とみなされます：

* Success.java がコンパイル成功
* Fail.java がコンパイル失敗

---

## 失敗条件

以下のいずれかでCIは失敗します：

* Success.java が失敗
* Fail.java が成功
* スクリプト実行エラー

---

## ログ

コンパイルエラーは以下に出力されます：

```
logs/fail.err
```

また、GitHub ActionsのArtifactsからダウンロード可能です。

---

## 特徴

* 最小構成（100行未満のスクリプト）
* PowerShellのみで構成
* define.jsonによる設定駆動
* ローカル環境非依存
* CI上で完結

---

## 想定用途

* CI導入の検証
* ビルドスクリプトの最小構成サンプル
* 失敗ケースを含むテストパイプラインの検証

---

## 補足

このリポジトリは教育・検証用途を目的としており、大規模プロジェクト（例：数万ファイル規模）のビルドには適していません。

---

## ライセンス

任意に利用・改変可能
# java-ci-pwsh
