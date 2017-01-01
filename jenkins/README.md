# このイメージについて

CentOS6を元にした、Jenkinsを構築するイメージです。
- インストールされるJenkinsは、yumでインストールしたものになります。

# イメージの構築方法

1. Gitリポジトリの取得
    ```console
    # git clone https://github.com/mygreen/docker.git mygreen-docker
    # cd mygreen-docker
    ```

2. ベースとなるCentOS 6のイメージを構築します。
    ```console
    # docker build -t mygreen/centos6-base:1.0 centos6-base/build/
    ```

3. Jenkinsのイメージを構築します。
    ```console
    # docker build -t mygreen/jenkins:1.0 jenkins/build/
    ```

# コンテナの作成と起動

- コンテナのポート ``8080`` をホストの任意のポートにマウントします。
- ``JENKINS_HOME`` となる ``/var/lib/jenkins`` をデータディレクトリとして ``-v`` でマウントします。

```console
# docker run -it -p 18080:8080 -v /usr/local/share/jenkins:/var/lib/jenkins --name jenkins mygreen/jenkins:1.0

```

# アクセス方法
1. 8080ポートをマッピングしたポートにアクセスします。
    ```
    http://<ホスト名>:18080/
    ```

2. Jenkins2から必要となった初回アクセス時のアンロック用のパスワードを表示します。
    ```console
    # cat /var/lib/jenkins/secrets/initialAdminPassword
    ```

3. jenkinsの設定ファイルは、 ``/etc/sysconfig/jekins`` に格納されています。

# Apache HTTP Serverとの連携
## Jenkinsの設定変更
1. JenkinsのContextを「jenkins」に変更します。 設定ファイル「/etc/sysconfig/jenkins」中のパラメータ「JENKINS_ARGS」を下記のように変更します。
    ```properties
    ## /etc/sysconfig/jenkins
    #JENKINS_ARGS=""
    JENKINS_ARGS="--prefix=/jenkins"
    ```

2. Jenkinsを再起動します
    ```bash
    service jenkins restart
    ```

## Apache HTTP Serverの設定変更
1. ApacheにJenkinsへのプロキシを設定します。「/etc/httpd/conf.d/jenkins.conf」を作成します。
    ```apache
    ProxyPass         /jenkins  http://localhost:18080/jenkins nocanon
    ProxyPassReverse  /jenkins  http://localhost:18080/jenkins
    ProxyRequests     Off
    AllowEncodedSlashes NoDecode
    
    <Proxy http://localhost:18080/jenkins*>
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
    http://<ホスト名>/jenkins/
    ```
