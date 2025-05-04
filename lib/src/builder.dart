import 'package:build/build.dart';

import 'generator.dart';

/// L10nキープレビュービルダー
class L10nKeyPreviewBuilder implements Builder {
  final Map<String, String> translations;

  L10nKeyPreviewBuilder(this.translations);

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.preview.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    // ARBファイルは処理しない
    if (inputId.path.contains('.arb')) {
      return;
    }

    // 生成されたファイルは処理しない
    if (inputId.path.contains('.g.dart') ||
        inputId.path.contains('.freezed.dart') ||
        inputId.path.contains('.preview.dart')) {
      return;
    }

    final generator = L10nKeyPreviewGenerator(translations);
    final content = await generator.generatePreview(inputId, buildStep);

    // 元のコンテンツと同じ場合は出力しない
    final originalContent = await buildStep.readAsString(inputId);
    if (content == originalContent) {
      return;
    }

    // 出力ファイルのIDを作成
    final outputId = inputId.changeExtension('.preview.dart');

    // 出力ファイルに書き込む
    await buildStep.writeAsString(outputId, content);
  }
}
