# minetest

[minetest](https://www.minetest.net/) の mod や worlds、サーバ設定などを保存するリポジトリ。

## セットアップ

### クライアントのインストール方法

[Downloads ページ](https://www.minetest.net/downloads/) に従ってインストールを行う。

Mac OS の場合は `/usr/local/opt/minetest/minetest.app` にアプリケーションがインストールされる。

### サーバのセットアップ方法

`make deploy` で k8s の現在のクラスタの `minetest` namespace にサーバがデプロイされる。

データディレクトリは `compute-2` node の `/data/minetest` ディレクトリを利用する前提になっているので、
あらかじめノード上にディレクトリを作成して所有者を minetest ユーザ (30000) に変更しておく。

#### サーバの設定

サーバ設定は `server/deployment/config.yml` で定義される ConfigMap で管理している。
変更した場合はデプロイし直してサーバを再起動すると設定が反映される。

#### mods のインストール

サーバの `/var/lib/minetest/.minetest/mods` ディレクトリに mods のディレクトリを入れると mods を利用できるようになる。
mods の有効化は `/var/lib/minetest/.minetest/worlds/world/world.mt` を編集して `load_mod_*` の該当の行を `true` に書き換えてサーバを再起動する。

サーバ上で直接編集できない場合は手元にファイルをコピーして書き換えた後、書き戻すとよい。

```sh
kubectl cp $(pod名):/var/lib/minetest/.minetest/worlds/world/world.mt world.mt
kubectl cp world.mt $(pod名):/var/lib/minetest/.minetest/worlds/world/world.mt
```

#### games のインストール

サーバの `/var/lib/minetest/.minetest/games` ディレクトリに games のディレクトリを入れると追加した games を利用できるようになる。
起動するゲームは `server/deployment/deploy.yml` の command で指定する。

## その他

### データフォルダ

Mac OS の場合は以下のディレクトリにデータが格納される。

`~/Library/Application Support/minetest`
