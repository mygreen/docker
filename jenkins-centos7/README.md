# このイメージについて

CentOS7を元にした、Jenkinsを構築するイメージです。
- インストールされるJenkinsは、yumでインストールしたものになります。

# 前提環境

|項目|値|
|:--|:--:|
|イメージ元のOS|CentOS7|
|Jenkins|2.x.x（インストール時点での最新版が入ります。）|
|JDK|OpenJDK 8|

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

3. Jenkinsのイメージを構築します。
    ```console
    # docker build -t mygreen/jenkins:centos7 jenkins-centos7/build/
    ```

# コンテナの作成と起動

1. ``$JENKINS_HOME`` となる ``/var/lib/jenkins`` をデータディレクトリを事前に作成し、権限を変更しておきます。
    ```console
    # mkdir -p /usr/local/share/jenkins
    # chmod 777 /usr/local/share/jenkins
    ```

2. コンテナのポート ``8080`` をホストの任意のポートにマッピングします。下記の例では、 ``8082`` にマッピングしています。また、``$JENKINS_HOME`` となる ``/var/lib/jenkins`` をデータディレクトリとして ``-v`` でマウントします。

    ```console
    # docker run --privileged -d -p 8082:8080 -v /usr/local/share/jenkins:/var/lib/jenkins --name jenkins mygreen/jenkins:centos7
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

2. Jenkinsから必要となった初回アクセス時のアンロック用のパスワードを表示します。
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
    systemctl restart jenkins
    ```

## Apache HTTP Serverの設定変更
1. ApacheにJenkinsへのプロキシを設定します。「/etc/httpd/conf.d/jenkins.conf」を作成します。
    ```apache
    ProxyPass         /jenkins  http://localhost:8082/jenkins nocanon
    ProxyPassReverse  /jenkins  http://localhost:8082/jenkins
    ProxyRequests     Off
    AllowEncodedSlashes NoDecode
    
    <Proxy http://localhost:8082/jenkins*>
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
    http://<ホスト名>/jenkins/
    ```

# アップデート方法

Jenkinsは、yumにより管理されているため、yumによりアップデートします。

1. コンテナへのログイン
    ```console
    # docker exec -it jenkins /bin/bash
    ```

2. yumによるアップデート
    ```console
    # yum update jenkins
    ```

3. サービスの再起動
    ```console
    # systemctl restart jenkins
    ```

4. コンテナからのログアウト
    [Ctrl]+[p]キー、[Ctrl]+[q]キーを押します。


