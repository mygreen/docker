# このイメージについて

CentOS6を元にした、開発用サーバのベースとなるイメージ。

- CentOS6.8のイメージをベースにしています。
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
    # docker build -t mygreen/base:centos6 base-centos6/build/
    ```

# コンテナの作成と起動

```console
# docker run -it --name centos6-test01 mygreen/base:centos6 /bin/bash
```

