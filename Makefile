#PostgresSql環境を構築
#ホスト（ローカルマシン）のポート5432をコンテナの5432ポートにマッピング
postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
#データベース作成
createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank
#データベース削除
dropdb:
	docker exec -it postgres12 dropdb simple_bank
#テーブル挿入
#localhost:5432の5432はローカルマシン（ホストマシン）の5432ポートを指します。
migrateup:
	migrate -path db/migration -database 'postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable' -verbose up
#テーブル削除
migratedown:
	 migrate -path db/migration -database 'postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable' -verbose down

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

.PHONY:	postgres createdb dropdb migrateup migratedown sqlc