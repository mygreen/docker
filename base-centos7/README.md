# このイメージについて

CentOS7を元にした、開発用サーバのベースとなるイメージ。

- CentOS7.3のイメージをベースにしています。
- `Base` `Developement Tools` の基本パッケージがインストールされています。
- 日本語のロケール、タイムゾーンが設定されていいます。

# イメージの構築方法

1. Gitリポジトリの取得
    ```console
    # git clone https://github.com/mygreen/docker.git mygreen-docker
    # cd mygreen-docker
    ```

2. Dockerイメージのビルド
    ```console
    # docker build -t mygreen/base:centos7 base-centos7/build/
    ```

# コンテナの起動

- コンテナの生成と起動
```console
# docker run --privileged -d --name mycentos7 mygreen/base:centos7 /sbin/init
```

- コンテナへのログイン
```console
# docker exec -it centos7-test01 /bin/bash
```

