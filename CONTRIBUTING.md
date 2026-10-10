# Shiraki への貢献 / Contributing to Shiraki

## 日本語

### 行動規範

このプロジェクトに参加する人は、[行動規範](CODE_OF_CONDUCT.md)を守ってください。

### 不具合の報告と要望

[Issues](https://github.com/moriyama-dev/shiraki/issues) から、不具合報告または要望のテンプレートを選んで書いてください。同じ内容の Issue がすでにないか、先に確認してください。

### 変更の方針

Shiraki は VS Code 本体のソースをできるだけ書き換えない方針です。変更が必要なときは、次の順に検討してください。

1. `product.json` や既定の設定（`src/stable/extensions/shiraki-defaults`）で対応する
2. ビルド時に組み込み拡張機能を除外する
3. それでも足りないときだけ、`patches/shiraki/` に最小限のパッチを追加する

パッチを追加するときは、ファイル名に連番と内容を表す名前を付けてください（例: `08-ui-xxxx.patch`）。製品名は `!!APP_NAME!!` と書くと、ビルド時に置き換わります。

### ビルド

手順は [docs/howto-build.md](docs/howto-build.md) にあります。

### Pull Request

- 変更は1つの目的に絞ってください。
- `main` ブランチに向けて作成してください。
- 何をなぜ変えたかを短く書き、関係する Issue があればリンクしてください。
- AI ツールを使った場合はそのことを書き、内容を自分で確認してから出してください。

## English

### Code of Conduct

Everyone taking part in this project is expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

### Bugs and feature requests

Open an issue from [Issues](https://github.com/moriyama-dev/shiraki/issues) using the bug report or feature request template. Please check first that the same issue does not exist already.

### How changes are made

Shiraki tries to change the VS Code sources as little as possible. When a change is needed, consider these options in order:

1. Use `product.json` or the default settings (`src/stable/extensions/shiraki-defaults`)
2. Exclude built-in extensions at build time
3. Only if that is not enough, add a minimal patch to `patches/shiraki/`

Name new patches with a sequence number and a short description (for example `08-ui-xxxx.patch`). Write the product name as `!!APP_NAME!!`; it is replaced at build time.

### Building

See [docs/howto-build.md](docs/howto-build.md).

### Pull requests

- Keep each change focused on one purpose.
- Open the pull request against the `main` branch.
- Explain briefly what changed and why, and link any related issue.
- If you used AI tools, say so, and review the result yourself before submitting.
