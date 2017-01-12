# このイメージについて

CentOS6を元にした、Jenkinsを構築するイメージです。
- インストールされるJenkinsは、yumでインストールしたものになります。

# 前提環境

|項目|値|
|:--|:--:|
|イメージ元のOS|CentOS6|
|Jenkins|2.4.x|
|JDK|OpenJDK 8|

# イメージの構築方法

1. Gitリポジトリの取得
    ```console
    # git clone https://github.com/mygreen/docker.git mygreen-docker
    # cd mygreen-docker
    ```

2. ベースとなるCentOS 6のイメージを構築します。
    ```console
    # docker build -t mygreen/base:centos6 base-centos6/build/
    ```

3. Jenkinsのイメージを構築します。
    ```console
    # docker build -t mygreen/jenkins:centos6 jenkins-centos6/build/
    ```

# コンテナの作成と起動

1. ``$JENKINS_HOME`` となる ``/var/lib/jenkins`` をデータディレクトリを事前に作成し、権限を変更しておきます。
    ```console
    # mkdir -p /usr/local/share/jenkins
    # chmod 777 /usr/local/share/jenkins
    ```

2. コンテナのポート ``8080`` をホストの任意のポートにマッピングします。下記の例では、 ``8082`` にマッピングしています。また、``$JENKINS_HOME`` となる ``/var/lib/jenkins`` をデータディレクトリとして ``-v`` でマウントします。

    ```console
# docker run -it -p 8082:8080 -v /usr/local/share/jenkins:/var/lib/jenkins --name jenkins mygreen/jenkins:centos6
    ```

3. コンテナへのログイン
    ```console
    # docker exec -it jenkins /bin/bash
    ```

# アクセス方法
1. 8080ポートをマッピングしたホストのポートにアクセスします。
    ```
    http://<ホスト名>:8082/
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
    ProxyPass         /jenkins  http://localhost:8082/jenkins nocanon
    ProxyPassReverse  /jenkins  http://localhost:8082/jenkins
    ProxyRequests     Off
    AllowEncodedSlashes NoDecode
    
    <Proxy http://localhost:8082/jenkins*>
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
