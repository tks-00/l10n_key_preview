import 'package:build/build.dart';
import 'dart:io';

import 'src/builder.dart';
import 'src/arb_parser.dart';

/// ビルダーファクトリ関数
///
/// BuilderOptionsからL10nKeyPreviewBuilderを生成。
/// 翻訳ファイルを読み込み、ビルダーに渡す。
Builder l10nKeyPreviewBuilder(BuilderOptions options) {
  // 翻訳ファイルを読み込む
  final projectPath = Directory.current.path;
  final translations = ArbParser.loadTranslations(projectPath);

  return L10nKeyPreviewBuilder(translations);
}
