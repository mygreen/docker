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
    # docker build -t mygreen/centos6-base:1.0 centos6-base/build/
    ```

# コンテナの起動

```console
# docker run -it --name mycentos6 mygreen/centos6-base:1.0 /bin/bash
```

