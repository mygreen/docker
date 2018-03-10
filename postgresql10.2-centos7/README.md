# このイメージについて

CentOS7を元にした、PostgreSQL10.2の環境を構築するイメージです。

# 前提環境

|項目|値|
|:--|:--:|
|イメージ元のOS|CentOS7|
|PostgreSQL|10.2|


# イメージの構築方法

1. Gitリポジトリの取得
    ```console
    # git clone https://github.com/mygreen/docker.git mygreen-docker
    # cd mygreen-docker
    ```

2. ベースとなるCentOS 7のイメージを構築します。
    ```console
    # docker build -t mygreen/base:centos7 base-centos7/build/
    ```

3. PostgreSQLのイメージを構築します。
    ```console
    # docker build -t mygreen/postgresql-10.2:centos7 postgresql-10.2-centos7/build/
    ```

# コンテナの作成と起動
1. ``$PGDATA`` となる ``/var/lib/pgsql/10/data`` をデータディレクトリを事前に作成し、権限を変更しておきます。
    ```console
    # mkdir -p /usr/local/share/postgresql-10.2
    # chmod 777 /usr/local/share/postgresql-10.2
    ```

2. コンテナのポート ``5432`` をホストの任意のポートにマッピングします。下記の例では、 ``5432`` にマッピングしています。また、``$PGDATA`` となる ``/var/lib/pgsql/10/data`` をデータディレクトリとして ``-v`` でマウントします。
    ```console
    # docker run --privileged -d -p 5432:5432 -v /usr/local/share/postgresql-10.2:/var/lib/pgsql/10/data --name postgresql-10.2 mygreen/postgresql-10.2:centos7
    ```

3. コンテナへログインし、DBの初期化、サービスの有効化を行います。
   ```console
   # コンテナへログイン
   # docker exec -it postgresql-10.2 /bin/bash
   
   # 権限の設定とDBの初期化
   # chown -R postgres:postgres /var/lib/pgsql/10/data
   # /usr/pgsql-10/bin/postgresql-10-setup initdb
   
   # サービスの有効化と起動
   # systemctl enable postgresql-10
   # systemctl start postgresql-10
   ```
   

# アクセス方法

- コンテナへのログイン
    ```console
    # docker exec -it postgresql-10.2 /bin/bash
    ```

# システム情報

- PostgreSQLは、 ``/var/lib/pgsql/10`` にインストールされています。
- サービスの再起動は、 ``postgresql-10`` に対して行います。
  - サービスの起動
```console
# systemctl start postgresql-10
```

  - サービスの停止
```console
# systemctl stop postgresql-10
```

  - 設定の反映
```console
# systemctl reload postgresql-10
```

# 基本的な設定
## ``postgresql.conf``
- バックアップ
    ```console
    # su - postgres
    $ cp /var/lib/pgsql/10/data/postgresql.conf /var/lib/pgsql/10/data/postgresql.conf.org
    ```

- 許可アドレス
    ```properties
    #listen_addresses = 'localhost'
    ↓
    listen_addresses = '*'
    ```

- ポート番号（5432から変更する場合）
    ```properties
    #port = 5432
    ↓
    port = 5450
    ```

- 時間がかかるSQLの出力
    ```properties
    #log_min_duration_statement = -1
    ↓
    log_min_duration_statement = 500
    ```

- ログのローテーション（必要ならば行う）
    ```properties
    # 曜日ごとにローテーションする(デフォルト)
    log_filename = 'postgresql-%a.log'
    
    # 毎日ログファイルを変更する
    log_filename = 'postgresql-%Y-%m-%d_%H%M.log'
    ```

- shared_buffersのサイズ変更
    ```properties
    # shared_buffersは物理メモリの1/4くらい。ただし、800MB以下にする。
    shared_buffers = 256MB
    ```

- wal_buffersのサイズ変更
    ```properties
    # wal_buffersは、少なくとも256～512kB。、更新が多い場合には1MB。
    # -1の場合は、sahred_buffersによって決まる。
    wal_buffers = 512kB
    ```

## ``pg_hba.conf``
- バックアップ
    ```console
    # su - postgres
    $ cp /var/lib/pgsql/10/data/pg_hba.conf /var/lib/pgsql/10/data/pg_hba.conf.org
    ```

- 許可アドレス
    ```properties
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            ident
    host    all             all             192.168.12.1/24        password
    ```

## 既存ユーザのパスワードの設定

``` console
# su - postgres
$ psql postgres
postgres=# alter role postgres with password 'postgres';
```


