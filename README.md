# Kaigi on Rails 2025 - Hierarchy Structure

## プロジェクト概要
[Kaigi on Rails 2025 「階層構造を表現するデータ構造とリファクタリング 〜1年で10倍成長したプロダクトの変化と課題〜」](https://kaigionrails.org/2025/talks/Yuhi-Sato/#day2)のサンプルコードです。  

ActiveRecord 上で階層構造を扱う 3 つの実装パターン（Adjacency List、Closure Table、Recursive CTE）について、完全二分木を題材に、モデル実装・データ生成・ノード探索ベンチマークを Docker 上で再現できるように構成しています。

## 技術スタック
- Ruby 3.4.3 / Rails 8.0.2.1
- PostgreSQL 17
- Ridgepole を用いたスキーマ管理
- Benchmark / benchmark-ips / StackProf（必要に応じて手動利用）
- Docker & Docker Compose による開発環境

## セットアップ
1. コンテナを起動します。
   ```bash
   docker compose up -d --build
   ```
2. Ridgepole でデータベーススキーマを適用します。
   ```bash
   make db-migrate
   ```

## データセットの作成
ベンチマークは事前にバイナリツリーのデータを投入しておく必要があります。`Seeds::BinaryTrees` では 3 種類の深さに応じたツリーを生成できます。

| コマンド | ツリーの深さ (0-based) | 生成ノード数 | ルートノード名の例 |
| --- | --- | --- | --- |
| `make create-shallow-binary-tree` | 6 | 127 | `shallow_tree_node_0_0` |
| `make create-medium-binary-tree` | 9 | 1,023 | `medium_tree_node_0_0` |
| `make create-deep-binary-tree` | 13 | 16,383 | `deep_tree_node_0_0` |
| `make create-all-binary-trees` | 上記すべて | ー | ー |

再生成時は既存データを自動的に削除します。

## ベンチマークの実行
それぞれの実装方式に対し、浅い／中程度／深いツリーでの子孫検索コストを測定できます。`Benchmark.bm` の結果が標準出力に表示されます。

| 深さ | まとめて実行 | Adjacency List | Closure Table | Recursive CTE |
| --- | --- | --- | --- | --- |
| shallow | `make run-all-shallow-binary-tree-benchmarks` | `make run-adjacency-list-shallow-benchmark` | `make run-closure-table-shallow-benchmark` | `make run-with-recursive-shallow-benchmark` |
| medium  | `make run-all-medium-binary-tree-benchmarks` | `make run-adjacency-list-medium-benchmark` | `make run-closure-table-medium-benchmark` | `make run-with-recursive-medium-benchmark` |
| deep    | `make run-all-deep-binary-tree-benchmarks` | `make run-adjacency-list-deep-benchmark` | `make run-closure-table-deep-benchmark` | `make run-with-recursive-deep-benchmark` |

各スクリプトは `benchmarks/<strategy>/<depth>.rb` に配置されており、`Benchmark::bm` の他に StackProf などを組み合わせて手動で計測することも可能です。

## ディレクトリ構成（抜粋）
```text
benchmarks/           # 階層モデル別・深さ別のベンチマークスクリプト
models/               # Adjacency List / Closure Table / Recursive CTE の各実装
seeds/                # バイナリツリーを生成する Seed スクリプト
db/Schemafile         # Ridgepole 用スキーマ定義
Makefile              # よく使う操作のショートカット
Dockerfile, docker-compose.yml
```

## 環境変数
PostgreSQL への接続情報は `db/config.yml` で ERB 越しに参照しています。デフォルト値は以下の通りです。

- `DB_HOST` (既定: `localhost` / Docker Compose 利用時は `db`)
- `DB_USERNAME` (既定: `postgres`)
- `DB_PASSWORD` (既定: `password`)
- `DB_DATABASE` (既定: `kaigi_on_rails_2025_hierarchy_structure`)

Docker Compose では `app` サービスにこれらが設定済みです。ローカルで直接実行する場合は `.env` などで上書きしてください。
