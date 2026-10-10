# Shiraki のビルド / Building Shiraki

## 日本語

現在ビルドを確認しているのは Linux x64 版だけです。

### 必要なもの

Ubuntu 24.04 で確認しています。

```bash
sudo apt-get install -y \
  build-essential pkg-config \
  libx11-dev libxkbfile-dev libsecret-1-dev libkrb5-dev \
  fakeroot dpkg git curl jq \
  python3 python3-venv python3-pip
```

- Node.js: [.nvmrc](../.nvmrc) に書かれたバージョン。[nvm](https://github.com/nvm-sh/nvm) で入れると、`nvm install` だけで合わせられます。
- Rust: [rustup](https://rustup.rs/) で入れてください。
- 起動確認を画面のない環境で行う場合は `xvfb` も入れてください。

### 手順

```bash
git clone https://github.com/moriyama-dev/shiraki.git
cd shiraki

# .deb を作る（rpm、tar、リモート用サーバー、snap は作らない）
SHOULD_BUILD_RPM=no SHOULD_BUILD_TAR=no SHOULD_BUILD_REH=no \
SHOULD_BUILD_REH_WEB=no SHOULD_BUILD_SNAP=no \
./dev/build.sh -p
```

成果物は次の場所にできます。

- `assets/shiraki_<バージョン>_amd64.deb` とチェックサム
- `VSCode-linux-x64/`（ビルドしたアプリ。`VSCode-linux-x64/shiraki` で直接起動できます）

`./dev/build.sh` のおもなオプション:

| オプション | 意味 |
|---|---|
| `-p` | .deb などのパッケージを作る |
| `-s` | VS Code のソースを取り直さず、手元の `vscode/` を使う |
| `-o` | ビルドを飛ばし、パッケージ作成だけを行う（`-s -o -p` で組み合わせる） |

### 所要時間と資源の目安

CPU 8 コア、メモリ 16GiB の Ubuntu 24.04（仮想マシン）で測った値です。

| 項目 | 目安 |
|---|---|
| フルビルド（`-p` 付き） | 約 9 分 |
| メモリの最大使用量 | 約 7.7GiB |
| ディスク使用量 | 約 12GB |

### Shiraki 独自の変更がある場所

| 場所 | 内容 |
|---|---|
| `product.json` | 製品名、フォルダ名、URL など |
| `src/stable/extensions/shiraki-defaults/` | 既定の設定と Claude Code の案内 |
| `patches/shiraki/` | VS Code 本体への最小限のパッチ |
| `build/shiraki/` | 日本語言語パックの同梱に使うスクリプトと除外リスト |
| `prepare_vscode.sh` | 上記をビルドに組み込む処理 |

パッチが VS Code の新しいバージョンに当たらなくなったときは、VSCodium と同じく `./dev/patch.sh <パッチ名>` で直せます。

## English

Only the Linux x64 build has been verified so far.

### Requirements

Tested on Ubuntu 24.04.

```bash
sudo apt-get install -y \
  build-essential pkg-config \
  libx11-dev libxkbfile-dev libsecret-1-dev libkrb5-dev \
  fakeroot dpkg git curl jq \
  python3 python3-venv python3-pip
```

- Node.js: the version in [.nvmrc](../.nvmrc). With [nvm](https://github.com/nvm-sh/nvm), `nvm install` picks it up.
- Rust: install it with [rustup](https://rustup.rs/).
- Install `xvfb` as well if you want to start the app on a machine without a display.

### Steps

```bash
git clone https://github.com/moriyama-dev/shiraki.git
cd shiraki

# Build the .deb (skip rpm, tar, the remote server and snap)
SHOULD_BUILD_RPM=no SHOULD_BUILD_TAR=no SHOULD_BUILD_REH=no \
SHOULD_BUILD_REH_WEB=no SHOULD_BUILD_SNAP=no \
./dev/build.sh -p
```

The results are:

- `assets/shiraki_<version>_amd64.deb` and its checksums
- `VSCode-linux-x64/` (the built app; run `VSCode-linux-x64/shiraki` to start it directly)

Main options of `./dev/build.sh`:

| Option | Meaning |
|---|---|
| `-p` | Create packages such as the .deb |
| `-s` | Reuse the local `vscode/` sources instead of fetching them again |
| `-o` | Skip the build and only create packages (combine as `-s -o -p`) |

### Time and resources

Measured on Ubuntu 24.04 (virtual machine) with 8 CPU cores and 16 GiB of memory.

| Item | Approximate value |
|---|---|
| Full build (with `-p`) | about 9 minutes |
| Peak memory use | about 7.7 GiB |
| Disk use | about 12 GB |

### Where the Shiraki changes live

| Location | Contents |
|---|---|
| `product.json` | Product name, folder names, URLs |
| `src/stable/extensions/shiraki-defaults/` | Default settings and the Claude Code guide |
| `patches/shiraki/` | Minimal patches to the VS Code sources |
| `build/shiraki/` | Script and keep list for bundling the Japanese language pack |
| `prepare_vscode.sh` | Wires the above into the build |

If a patch no longer applies to a new VS Code version, fix it with `./dev/patch.sh <patch name>`, as in VSCodium.
