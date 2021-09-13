# growi
## 起動補法
```
docker compose up -d
```

## 注意点
- data配下にgrowi-data,mongo-config,mongo-data,elasticsearch-dataの4つのデータ用フォルダが生成される
- 最初にベース環境にて[id]コマンドを使って現在のユーザのuidとgidを確認し、docker-compose.yml内のGID、UID項目を変えるべし
- elasticsearch-dataフォルダはsudo chown -R 1000:root ./data/elasticsearch-dataすべし(1000はidコマンドで出てくるUIDによっては変更する必要あり)

以上、、
