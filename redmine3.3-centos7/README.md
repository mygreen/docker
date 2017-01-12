# このイメージについて

CentOS7を元にした、Remine3.3の環境を構築するイメージです。
DBは、SQLiteのためコンテナ単体で動作します。

# 前提環境

|項目|値|
|:--|:--:|
|イメージ元のOS|CentOS7|
|Redmine|3.3.2|
|Ruby|2.2.3|
|DB|SQLite3|
|Web Server|Apache HTTP Server 2.4|


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

3. Redmineのイメージを構築します。
    ```console
    # docker build -t mygreen/redmine3.3:centos7 redmine3.3-centos7/build/
    ```

# コンテナの作成と起動

- コンテナのポート ``80`` をホストの任意のポートにマッピングします。下記の例では、 ``8081`` にマッピングしています。

```console
# docker run --privileged -d -p 8081:80 --name redmine3.3 mygreen/redmine3.3:centos7

```

- コンテナへログイン

```console
# docker exec -it redmine3.3 /bin/bash
```

# アクセス方法
1. 80ポートをマッピングしたホストのポートにアクセスします。
    ```
    http://<ホスト名>:8081/redmine/
    ```

2. 管理者アカウントでログインします。
 - ログインID:admin
 - パスワード:admin

3. 初期設定の詳細は、下記を参照してください。
 - http://redmine.jp/tech_note/first-step/admin/




# システム情報

- redmineは、 ``/var/lib/redmine`` にインストールされています。
  - 実際には、 ``/var/lib/redmine-3.3.2`` からのシンボリックリンクになります。
- apacheの設定は、 ``/etc/httpd/conf.d/redmine.conf`` で行っています。
- サービスの再起動は、httpdに対して行います。
  - サービスの起動
```console
# systemctl httpd start
```

  - サービスの停止
```console
# systemctl httpd stop
```

# Apache HTTP Serverとの連携
ホスト側のApache HTTP Serverと連携する際には、プロキシを設定します。

1. ホスト側のApacheにredmineへのプロキシを設定します。「/etc/httpd/conf.d/redmine.conf」を作成します。
    ```apache
    ProxyPass         /redmine  http://localhost:8081/redmine nocanon
    ProxyPassReverse  /redmine  http://localhost:8081/redmine
    ProxyRequests     Off
    AllowEncodedSlashes NoDecode
    
    <Proxy http://localhost:8081/redmine*>
      Require all granted
    </Proxy>
    ```

2. Apacheの設定ファイルが正しいか確認します。
    ```console
    # service httpd configtest
    Syntax OK
    ```

3. Apacheを再起動します。
    ```console
    # systemctl restart httpd
    ```

4. ブラウザからアクセスできるか確認します。
    ```
    http://<ホスト名>/redmine/
    ```
