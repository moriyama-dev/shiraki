# Shiraki（白木）

Shiraki は、MIT ライセンスで公開されている Code - OSS のソースから、不要なものを削ぎ落として作る、軽量で安定したコードエディタです。

- 拡張機能のストアは [Open VSX](https://open-vsx.org/) を使います
- AI 機能は Claude Code 拡張機能のみを想定しています
- 日本語 UI を標準にする予定です
- 現在は Linux（x64）版のみを対象に開発中です

## 使い方 / Usage

### 表示言語 / Display language

初めて起動したときだけ英語で表示されます。もう一度起動すると日本語になります。

The user interface is shown in English only on the very first launch. It switches to Japanese from the next launch.

## ビルド

ビルドの仕組みは VSCodium のものを引き継いでいます。必要なパッケージと手順は [docs/howto-build.md](docs/howto-build.md) を参照してください。開発用のビルドは次のコマンドで行います。

```bash
./dev/build.sh
```

## 問題の報告

不具合や要望は [Issues](https://github.com/moriyama-dev/shiraki/issues) にお寄せください。

## クレジット

Shiraki は次のプロジェクトの成果の上に成り立っています。

- [VSCodium](https://github.com/VSCodium/vscodium)：ビルドスクリプト、パッチ、パッケージングの仕組みをフォークして利用しています（MIT ライセンス）
- [Code - OSS（microsoft/vscode）](https://github.com/microsoft/vscode)：エディタ本体のソースコード（MIT ライセンス）

Shiraki は Microsoft および VSCodium プロジェクトとは関係のない、独立したプロジェクトです。「Visual Studio Code」「VS Code」は Microsoft Corporation の商標です。

## ライセンス

[MIT](LICENSE)
