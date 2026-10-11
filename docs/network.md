# Shiraki の通信 / Network activity of Shiraki

[日本語](#日本語) | [English](#english)

## 日本語

### 調べ方

Shiraki 1.135.06816（Linux x64）を、設定のない新しいユーザーの状態で起動し、Chromium の通信記録（`--log-net-log`）で通信先を調べました（2026 年 10 月）。記録した場面は次のとおりです。

- 初回起動
- 2 回目の起動
- Welcome を開く
- 拡張機能ビューを開く
- Open VSX から入れた拡張機能がある状態での起動
- 拡張機能のインストール

この記録で分かるのは、Shiraki 本体（メインプロセス、画面、共有プロセス）の通信です。拡張機能ホストや言語サーバーが Node.js で直接行う通信は記録に含まれません。同梱の拡張機能のそうした通信は、ソースコードから調べて[別の表](#同梱の拡張機能が行う通信)にまとめています。あとから入れた拡張機能（Claude Code など）の通信は、それぞれの拡張機能によります。

### Shiraki 本体が行う通信

| 通信先 | 目的 | いつ発生するか | 止める方法 |
|---|---|---|---|
| `raw.githubusercontent.com/EclipseFdn/publish-extensions/.../extension-control/extensions.json` | 拡張機能の制御リスト（悪意のある拡張機能や非推奨の拡張機能の一覧）を取得する | 起動のたびと、拡張機能ビューを開いたとき | 設定では止められません。安全のために残しています（[理由](#拡張機能の制御リストを残している理由)） |
| `open-vsx.org/vscode/gallery/extensionquery`、`open-vsx.org/vscode/asset/...`、`openvsx.eclipsecontent.org` | 拡張機能の一覧、検索結果、アイコンを表示する | 拡張機能ビューを開いたときと、拡張機能を検索したとき | 拡張機能ビューを開かなければ発生しません |
| `open-vsx.org/vscode/gallery/<発行者>/<名前>/latest` | インストール済みの拡張機能に新しい版があるかを確認する | Open VSX から入れた拡張機能がある場合に、起動時と、その後 12 時間ごと | `"extensions.autoCheckUpdates": false` |
| `open-vsx.org`、`openvsx.eclipsecontent.org` | 拡張機能をダウンロードしてインストール、更新する | 拡張機能をインストールしたときと、更新を自動で入れるとき | 自動の更新は `"extensions.autoUpdate": "off"` で止められます |

Welcome を開いても、ここに挙げたもの以外の通信は発生しません。

### 同梱の拡張機能が行う通信

ソースコードから確認したものです。どれもファイルを開いたときや編集したときに発生し、起動しただけでは発生しません。

| 通信先 | 拡張機能と目的 | いつ発生するか | 止める方法 |
|---|---|---|---|
| `registry.npmjs.org` | npm: `package.json` を編集するときのパッケージ名の補完と説明の表示 | `package.json` を編集したとき | `"npm.fetchOnlinePackageInfo": false` |
| `registry.npmjs.org` | TypeScript / JavaScript: 型定義の自動取得 | JavaScript のファイルを開いたとき | `"typescript.disableAutomaticTypeAcquisition": true` |
| `json.schemastore.org` など、JSON ファイルの `$schema` に書かれた URL | JSON: スキーマの取得（入力補完と検証に使う） | JSON ファイルを開いたとき | `"json.schemaDownload.enable": false` |
| `github.com`、`api.github.com` | GitHub、Git: サインイン、clone、push、pull | ユーザーが GitHub へのサインインや Git のリモート操作をしたとき | 操作をしなければ発生しません |
| 文書に書かれた画像などの URL | Markdown のプレビュー | 外部の画像を含む Markdown をプレビューしたとき | 外部の画像を含めなければ発生しません |

### 止めた通信

| 通信や機能 | 止めた方法 |
|---|---|
| テレメトリ（利用状況の送信） | 無効（VSCodium の設定を引き継ぎ） |
| 実験機能（設定の配信） | 無効（VSCodium の設定を引き継ぎ） |
| Shiraki 本体の自動更新 | 配布の仕組みができるまで無効 |
| Welcome のお知らせの取得（`raw.githubusercontent.com/moriyama-dev/shiraki/...`） | 既定で無効（`patches/shiraki/08`） |
| スペルチェック用の辞書のダウンロード（`redirector.gvt1.com`） | スペルチェック機能を無効にして、辞書を取得しないようにした（`patches/shiraki/09`） |
| GitHub Copilot の利用資格や設定の取得（`api.github.com/copilot_internal/...` など） | `product.json` で URL を空にした |
| 音声入力の接続先（Microsoft） | `product.json` で URL を空にした |
| Microsoft のヘルプ用リンク（ビデオ、ヒント、キーボードショートカットの参照など） | `product.json` で URL を空にし、メニューから外した |
| GitHub Copilot の管理設定ファイルの監視 | 監視しない（`patches/shiraki/05`）。通信ではありませんが、Copilot 関連として止めています |
| 端末 ID のファイル（`~/.cache/Microsoft/DeveloperTools/deviceid`）の作成 | 作らない（`patches/shiraki/07`）。通信ではありませんが、利用者を識別する情報なので止めています |

### 拡張機能の制御リストを残している理由

このリストは Open VSX を運営する Eclipse Foundation が公開しているもので、悪意のあることが分かった拡張機能や、名前が変わった拡張機能、非推奨になった拡張機能が載っています。Shiraki はこれを使って、危険な拡張機能のインストールを止めたり、警告を出したりします。通信は増えますが、拡張機能を安全に使うために必要と判断して残しています。

## English

### How this was measured

Shiraki 1.135.06816 (Linux x64) was started as a new user with no settings, and its network activity was recorded with the Chromium network log (`--log-net-log`) in October 2026. These situations were recorded:

- First launch
- Second launch
- Opening the Welcome page
- Opening the Extensions view
- Launching with an extension installed from Open VSX
- Installing an extension

The log covers the network activity of Shiraki itself (main process, windows and shared process). Requests made directly with Node.js by the extension host or language servers are not included. For the bundled extensions, those requests were checked in the source code and are listed in a [separate table](#requests-made-by-bundled-extensions). Extensions you install yourself (such as Claude Code) make their own requests.

### Requests made by Shiraki

| Destination | Purpose | When | How to stop it |
|---|---|---|---|
| `raw.githubusercontent.com/EclipseFdn/publish-extensions/.../extension-control/extensions.json` | Download the extension control list (malicious and deprecated extensions) | On every launch, and when the Extensions view is opened | Cannot be turned off in the settings. Kept for safety ([reason](#why-the-extension-control-list-is-kept)) |
| `open-vsx.org/vscode/gallery/extensionquery`, `open-vsx.org/vscode/asset/...`, `openvsx.eclipsecontent.org` | Show the list of extensions, search results and icons | When the Extensions view is opened, and when searching for extensions | Does not happen unless the Extensions view is opened |
| `open-vsx.org/vscode/gallery/<publisher>/<name>/latest` | Check whether installed extensions have a newer version | At launch and every 12 hours, if extensions from Open VSX are installed | `"extensions.autoCheckUpdates": false` |
| `open-vsx.org`, `openvsx.eclipsecontent.org` | Download, install and update extensions | When installing an extension, and when updates are installed automatically | Automatic updates can be stopped with `"extensions.autoUpdate": "off"` |

Opening the Welcome page causes no requests other than the ones above.

### Requests made by bundled extensions

These were checked in the source code. All of them happen when files are opened or edited, not at launch.

| Destination | Extension and purpose | When | How to stop it |
|---|---|---|---|
| `registry.npmjs.org` | npm: package name completion and details while editing `package.json` | When editing `package.json` | `"npm.fetchOnlinePackageInfo": false` |
| `registry.npmjs.org` | TypeScript / JavaScript: automatic type acquisition | When opening JavaScript files | `"typescript.disableAutomaticTypeAcquisition": true` |
| `json.schemastore.org` and other URLs given in `$schema` of JSON files | JSON: download schemas used for completion and validation | When opening JSON files | `"json.schemaDownload.enable": false` |
| `github.com`, `api.github.com` | GitHub and Git: sign in, clone, push, pull | When you sign in to GitHub or work with Git remotes | Does not happen without those actions |
| Image and other URLs written in documents | Markdown preview | When previewing Markdown that contains remote images | Does not happen without remote images |

### Stopped requests

| Request or feature | How it was stopped |
|---|---|
| Telemetry (usage data) | Disabled (inherited from VSCodium) |
| Experiments (remote settings) | Disabled (inherited from VSCodium) |
| Automatic updates of Shiraki itself | Disabled until Shiraki has its own distribution |
| Welcome page announcements (`raw.githubusercontent.com/moriyama-dev/shiraki/...`) | Off by default (`patches/shiraki/08`) |
| Spell checker dictionary download (`redirector.gvt1.com`) | The spell checker is disabled, so no dictionary is downloaded (`patches/shiraki/09`) |
| GitHub Copilot entitlement and settings requests (`api.github.com/copilot_internal/...` and others) | URLs emptied in `product.json` |
| Voice input endpoint (Microsoft) | URL emptied in `product.json` |
| Microsoft help links (videos, tips, keyboard shortcuts reference and others) | URLs emptied in `product.json` and removed from the menu |
| Watching the GitHub Copilot managed settings file | Not watched (`patches/shiraki/05`). Not a network request, but stopped as part of the Copilot features |
| Creating the device id file (`~/.cache/Microsoft/DeveloperTools/deviceid`) | Not created (`patches/shiraki/07`). Not a network request, but it identifies the user, so it was stopped |

### Why the extension control list is kept

The list is published by the Eclipse Foundation, which runs Open VSX. It names extensions found to be malicious, extensions that were renamed and extensions that are deprecated. Shiraki uses it to block or warn about dangerous extensions. It adds a request at launch, but it is kept because it helps keep extension use safe.
