# l10n_key_previewは開発段階で諦めたパッケージです。

# L10n Key Preview

Flutter アプリケーション開発者向けの多言語化支援ツールです。コード内の翻訳キーの横に、対応する日本語訳を直接表示することで、開発時の可読性と効率を向上させます。

## 特徴

- **翻訳キーのプレビュー**: コード内の `l10n.keyName` 形式の翻訳キーの横に、対応する日本語訳をコメントとして表示
- **ビルド時自動生成**: build_runner を使用して自動的にプレビューを生成
- **非侵襲的**: 元のソースコードを変更せず、プレビュー用の別ファイルを生成
- **ARB ファイル対応**: 標準的な ARB 形式の翻訳ファイルをサポート

## 導入方法

1. パッケージを依存関係に追加

```yaml
dependencies:
  l10n_key_preview: ^0.1.0

dev_dependencies:
  build_runner: ^2.4.0
```

2. `build.yaml` ファイルを作成または編集

```yaml
targets:
  $default:
    builders:
      l10n_key_preview|l10n_key_preview:
        enabled: true
        generate_for:
          - lib/**.dart
```

## 使い方

1. ARB 翻訳ファイルを以下のいずれかの場所に配置

   - `lib/l10n/app_ja.arb`
   - `assets/l10n/app_ja.arb`
   - `assets/translations/ja.arb`

2. build_runner を実行してプレビューを生成

```bash
flutter pub run build_runner build
```

3. 生成されたプレビューファイル (`.preview.dart`) を確認

### 例

元のコード

```dart
Text(l10n.welcomeMessage)
```

生成されたプレビュー

```dart
Text(l10n.welcomeMessage) // ようこそ
```

## 設定オプション

`build.yaml` ファイルで以下のオプションを設定できます。

```yaml
targets:
  $default:
    builders:
      l10n_key_preview|l10n_key_preview:
        options:
          skip_generated: true
```

## ライセンス

MIT ライセンスの下で公開されています。
