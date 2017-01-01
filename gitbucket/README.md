# このイメージについて

CentOS 6を元にした、GitBucketを構築するイメージです。

- https://github.com/gitbucket/gitbucket

# イメージの構築方法
`mygreen/centos6-base` を元に構築します。

1. Gitリポジトリの取得
    ```console
    # git clone https://github.com/mygreen/docker.git mygreen-docker
    # cd mygreen-docker
    ```

2. ベースとなるCentOS 6のイメージを構築します。
    ```console
    # docker build -t mygreen/centos6-base:1.0 centos6-base/build/
    ```

3. GitBucketのイメージを構築します。
    ```console
    # docker build -t mygreen/gitbucket:1.0 gitbucket/build/
    ```


# コンテナの作成と起動

- コンテナのポート ``8080`` をホストの任意のポートにマウントします。
- ``GITBUCKET_HOME`` となる ``/var/lib/gitbucket`` をデータディレクトリとして ``-v`` でマウントします。

```console
# docker run -it -p 28080:8080 -v /usr/local/share/gitbucket:/var/lib/gitbucket --name gitbucket mygreen/gitbucket:1.0
```


# アクセス方法
1. 8080ポートをマッピングしたポートにアクセスします。
    ```
    http://<ホスト名>:28080/
    ```

2. 初期アカウントは、ユーザ名「root」、パスワード「root」です。

# スクリプトの使い方
- 起動方法
    ```console
    # service gitbucket start
    ```

- 停止方法
    ```console
    # service gitbucket stop
    ```

- アップデート方法

    1.サービスの停止
    ```console
    # service gitbucket stop
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
    # service gitbucket start
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
    # service gitbucket restart
    ```

## Apache HTTP Serverの設定変更
1. ApacheにGitBucketへのプロキシを設定します。「/etc/httpd/conf.d/gitbucket.conf」を作成します。
    ```apache
    ProxyPass         /gitbucket  http://localhost:28080/gitbucket nocanon
    ProxyPassReverse  /gitbucket  http://localhost:28080/gitbucket
    ProxyRequests     Off
    AllowEncodedSlashes NoDecode
    
    <Proxy http://localhost:28080/gitbucket*>
      Order deny,allow
      Allow from all
    </Proxy>
    ```

2. Apacheの設定ファイルが正しいか確認します。
    ```console
    # /etc/init.d/httpd configtest
    Syntax OK
    ```

3. Apacheの設定ファイルを読み直します。
    ```console
    # /etc/init.d/httpd reload
    httpd を再読み込み中:
    ```

4. ブラウザからアクセスできるか確認します。
    ```
    http://<ホスト名>/gitbucket/
    ```
