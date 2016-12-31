# このイメージについて

CentOS6を元にした、開発用サーバのベースとなるイメージ。

- CentOS6.8のイメージをベースにしています。
- `Base` `Developement Tools` の基本パッケージがインストールされています。
- 日本語のロケール、タイムゾーンが設定されていいます。

# イメージの構築方法

```bash
cd /usr/tmp/mygreen-docker
docker build -t mygreen/centos6-base:1.0 centos6-base/build/
```

# コンテナの起動
```bash
docker run -it --name mycentos6 mygreen/centos6-base:1.0 /bin/bash
```

