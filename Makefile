# NOTE: migrateデータを作成するためのコマンド
.PHONY: db-migrate

db-migrate:
	docker compose exec app bundle exec ridgepole -f db/Schemafile -c db/config.yml --apply

# NOTE: seedsデータを作成するためのコマンド
.PHONY: create-shallow-binary-tree \
create-medium-binary-tree \
create-deep-binary-tree \
create-all-binary-trees

create-shallow-binary-tree:
	docker compose exec app bundle exec ruby seeds/shallow_binary_tree.rb

create-medium-binary-tree:
	docker compose exec app bundle exec ruby seeds/medium_binary_tree.rb

create-deep-binary-tree:
	docker compose exec app bundle exec ruby seeds/deep_binary_tree.rb

create-all-binary-trees:
	make create-shallow-binary-tree
	make create-medium-binary-tree
	make create-deep-binary-tree

# NOTE: shallow binary treeのbenchmarksを実行するためのコマンド
.PHONY: run-adjacency-list-shallow-benchmark \
run-closure-table-shallow-benchmark \
run-with-recursive-shallow-benchmark \
run-all-shallow-binary-tree-benchmarks

run-adjacency-list-shallow-benchmark:
	docker compose exec app bundle exec ruby benchmarks/adjacency_list/shallow.rb

run-closure-table-shallow-benchmark:
	docker compose exec app bundle exec ruby benchmarks/closure_table/shallow.rb

run-with-recursive-shallow-benchmark:
	docker compose exec app bundle exec ruby benchmarks/with_recursive/shallow.rb

run-all-shallow-binary-tree-benchmarks:
	make run-adjacency-list-shallow-benchmark
	make run-closure-table-shallow-benchmark
	make run-with-recursive-shallow-benchmark

# NOTE: medium binary treeのbenchmarksを実行するためのコマンド
.PHONY: run-adjacency-list-medium-benchmark \
run-closure-table-medium-benchmark \
run-with-recursive-medium-benchmark \
run-all-medium-binary-tree-benchmarks

run-adjacency-list-medium-benchmark:
	docker compose exec app bundle exec ruby benchmarks/adjacency_list/medium.rb

run-closure-table-medium-benchmark:
	docker compose exec app bundle exec ruby benchmarks/closure_table/medium.rb

run-with-recursive-medium-benchmark:
	docker compose exec app bundle exec ruby benchmarks/with_recursive/medium.rb

run-all-medium-binary-tree-benchmarks:
	make run-adjacency-list-medium-benchmark
	make run-closure-table-medium-benchmark
	make run-with-recursive-medium-benchmark

# NOTE: deep binary treeのbenchmarksを実行するためのコマンド
.PHONY: run-adjacency-list-deep-benchmark \
run-closure-table-deep-benchmark \
run-with-recursive-deep-benchmark \
run-all-deep-binary-tree-benchmarks

run-adjacency-list-deep-benchmark:
	docker compose exec app bundle exec ruby benchmarks/adjacency_list/deep.rb

run-closure-table-deep-benchmark:
	docker compose exec app bundle exec ruby benchmarks/closure_table/deep.rb

run-with-recursive-deep-benchmark:
	docker compose exec app bundle exec ruby benchmarks/with_recursive/deep.rb

run-all-deep-binary-tree-benchmarks:
	make run-adjacency-list-deep-benchmark
	make run-closure-table-deep-benchmark
	make run-with-recursive-deep-benchmark
