# このイメージについて

CentOS 7を元にした、GitBucketを構築するイメージです。

- https://github.com/gitbucket/gitbucket

# 前提環境

|項目|値|
|:--|:--:|
|イメージ元のOS|CentOS7|
|GitBucket|4.8|
|Java|OpenJDK 8|
|DB|H2DB（デフォルト）|

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

3. GitBucketのイメージを構築します。
    ```console
    # docker build -t mygreen/gitbucket:centos7 gitbucket-centos7/build/
    ```


# コンテナの作成と起動
1. ``$GITBUCKET_HOME`` となる ``/var/lib/gitbucket`` をデータディレクトリを事前に作成し、権限を変更しておきます。
    ```console
    # mkdir -p /usr/local/share/gitbucket
    # chmod 777 /usr/local/share/gitbucket
    ```

2. コンテナのポート ``8080`` をホストの任意のポートにマッピングします。下記の例では、 ``8083`` にマッピングしています。また、``$GITBUCKET_HOME`` となる ``/var/lib/gitbucket`` をデータディレクトリとして ``-v`` でマウントします。

```console
# docker run --privileged -d -p 8083:8080 -v /usr/local/share/gitbucket:/var/lib/gitbucket --name gitbucket mygreen/gitbucket:centos7
```

3. コンテナへのログイン
    ```console
    # docker exec -it gitbucket /bin/bash
    ```

# アクセス方法
1. 8080ポートをマッピングしたホストのポートにアクセスします。
    ```
    http://<ホスト名>:8083/
    ```

2. 初期アカウントは、ユーザ名「root」、パスワード「root」です。

# スクリプトの使い方
- 起動方法
    ```console
    # systemctl start gitbucket
    ```

- 停止方法
    ```console
    # systemctl stop gitbucket
    ```

- アップデート方法

    1.サービスの停止
    ```console
    # systemctl stop gitbucket
    ```

    2.アップデート
    ```console
    # /usr/lib/gitbucket/update.sh
    新しいバージョンのGitBucketを入力してください(例. 4.1) > 4.8 # <= バージョン番号を入力
    ...
    ...アップデートが完了しました。GitBucketを起動してください。
    ```

    3.サービスの起動
    ```console
    # systemctl start gitbucket
    ```


# 設定ファイル
- インストール先
    ```
    /usr/lib/gitbucket
    ```

- データの保存先
    ```
    /var/lib/gitbucket
    ```


# Apache HTTP Serverとの連携
## GitBucketの設定変更
1. GitBucketのContextを「gitbucket」に変更します。 設定ファイル「/usr/lib/gitbucket/gitbucket.conf」中のパラメータ「GITBUCKET_PREFIX」を下記のように変更します。
    ```properties
    ## /usr/lib/gitbucket/gitbucket.conf
    # Context prefix
    GITBUCKET_PREFIX="/gitbucket"
    ```

2. GitBucketを再起動します
    ```console
    # systemctl restart gitbucket
    ```

## Apache HTTP Serverの設定変更
1. ApacheにGitBucketへのプロキシを設定します。「/etc/httpd/conf.d/gitbucket.conf」を作成します。
    ```apache
    ProxyPass         /gitbucket  http://localhost:8083/gitbucket nocanon
    ProxyPassReverse  /gitbucket  http://localhost:8083/gitbucket
    ProxyRequests     Off
    AllowEncodedSlashes NoDecode
    
    <Proxy http://localhost:8083/gitbucket*>
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
    http://<ホスト名>/gitbucket/
    ```
