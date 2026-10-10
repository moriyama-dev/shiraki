# 削ったもの・残したもの / What was removed and what was kept

VS Code 1.135 をもとにした Linux x64 版の内容です。VSCodium が 94 個同梱している組み込み拡張機能のうち 50 個を削り、2 個を加えて、46 個にしました。

This describes the Linux x64 build based on VS Code 1.135. Of the 94 built-in extensions shipped by VSCodium, 50 were removed and 2 were added, leaving 46.

## 削った組み込み拡張機能 / Removed built-in extensions

| 種類 / Kind | 拡張機能 / Extensions |
|---|---|
| AI 関連 / AI | `prompt-basics` |
| アカウント・リモート / Accounts and remote | `microsoft-authentication`, `tunnel-forwarding` |
| ノートブック / Notebooks | `ipynb`, `notebook-renderers` |
| 古いタスクランナー / Legacy task runners | `grunt`, `gulp`, `jake` |
| 開発者向け・その他 / Developer tools and others | `extension-editing`, `terminal-suggest`, `markdown-math`, `ms-vscode.js-debug-companion`, `ms-vscode.vscode-js-profile-table` |
| 配色・アイコンテーマ / Color and icon themes | `theme-abyss`, `theme-kimbie-dark`, `theme-monokai`, `theme-monokai-dimmed`, `theme-quietlight`, `theme-red`, `theme-solarized-dark`, `theme-solarized-light`, `theme-tomorrow-night-blue`, `theme-modern-icons` |
| 言語の文法 / Language grammars | `bat`, `clojure`, `coffeescript`, `cpp`, `csharp`, `dart`, `fsharp`, `go`, `groovy`, `handlebars`, `hlsl`, `java`, `julia`, `latex`, `lua`, `objective-c`, `perl`, `powershell`, `pug`, `r`, `razor`, `restructuredtext`, `ruby`, `rust`, `shaderlab`, `swift`, `vb` |

削った言語は、Markdown のコードブロックの中でも色が付きません。必要な場合は Open VSX から拡張機能を入れてください。

Removed languages are no longer highlighted inside Markdown code blocks either. Install an extension from Open VSX if you need one.

## 残した組み込み拡張機能 / Kept built-in extensions

| 種類 / Kind | 拡張機能 / Extensions |
|---|---|
| PHP | `php`, `php-language-features` |
| JavaScript / TypeScript | `javascript`, `typescript-basics`, `typescript-language-features`, `npm`, `ms-vscode.js-debug`, `debug-auto-launch`, `debug-server-ready` |
| HTML / CSS | `html`, `html-language-features`, `css`, `css-language-features`, `scss`, `less`, `emmet` |
| Markdown | `markdown-basics`, `markdown-language-features`, `mermaid-markdown-features` |
| Git / GitHub | `git`, `git-base`, `merge-conflict`, `github`, `github-authentication` |
| ファイル形式 / File formats | `json`, `json-language-features`, `xml`, `yaml`, `ini`, `dotenv`, `shellscript`, `sql`, `log`, `diff`, `docker`, `make`, `python` |
| エディター / Editor | `configuration-editing`, `search-result`, `references-view`, `media-preview`, `simple-browser`, `theme-defaults`, `theme-seti` |
| Shiraki で追加 / Added by Shiraki | `MS-CEINTL.vscode-language-pack-ja`（日本語言語パック / Japanese language pack）, `shiraki-defaults`（既定の設定と Claude Code の案内 / default settings and the Claude Code guide） |

## 止めた機能 / Disabled features

| 機能 / Feature | 方法 / How |
|---|---|
| 組み込みのチャット、インライン提案などの AI 機能 / Built-in chat, inline suggestions and other AI features | `chat.disableAIFeatures` を既定で有効（VSCodium の設定を引き継ぎ） / `chat.disableAIFeatures` on by default (inherited from VSCodium) |
| Agents ウィンドウ（`--agents`） / Agents window (`--agents`) | 通常のウィンドウを開くように変更 / Opens a regular window instead (`patches/shiraki/04`) |
| GitHub Copilot の管理設定ファイルの監視 / Watching the GitHub Copilot managed settings file | 監視しない / Not watched (`patches/shiraki/05`) |
| `~/.cache/Microsoft/DeveloperTools/deviceid` の作成 / Creating that device id file | 作らない / Not created (`patches/shiraki/07`) |
| テレメトリと実験機能 / Telemetry and experiments | 無効（VSCodium の設定を引き継ぎ） / Disabled (inherited from VSCodium) |
| 音声入力の接続先、Microsoft のヘルプ用リンク / Voice endpoint, Microsoft help links | `product.json` で空にした / Emptied in `product.json` |
| 自動更新 / Automatic updates | 配布の仕組みができるまで無効 / Disabled until Shiraki has its own update feed |

## 既定の設定 / Default settings

`shiraki-defaults` 拡張機能で次の値を既定にしています。ユーザー設定で変更できます。

The `shiraki-defaults` extension sets these defaults. They can be changed in the user settings.

| 設定 / Setting | 値 / Value |
|---|---|
| `extensions.ignoreRecommendations` | `true` |
| `workbench.startupEditor` | `none` |
| `editor.minimap.enabled` | `false` |
| `chat.agentsControl.enabled` | `hidden` |
| `breadcrumbs.enabled` | `false` |
| `git.autofetch` | `false` |
| `npm.autoDetect` | `off` |
| `files.watcherExclude`, `search.exclude` | `node_modules`, `vendor`, `wp-content/uploads`, `wp-content/cache`, `dist`, `build`, `.next` を追加 / added |
