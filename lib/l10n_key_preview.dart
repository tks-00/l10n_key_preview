/// L10nKeyPreview パッケージ
///
/// Flutter アプリケーション開発者向けの多言語化支援ツール。
/// コード内の翻訳キーの横に、対応する日本語訳を直接表示することで、開発時の可読性と効率を向上させます。
library;

export 'src/builder.dart';
export 'src/generator.dart';
export 'src/arb_parser.dart';
export 'src/code_analyzer.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
