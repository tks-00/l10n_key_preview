// ignore_for_file: override_on_non_overriding_member

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:build/build.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
// import 'package:logging/logging.dart';

/// L10nキープレビューを生成するクラス
class L10nKeyPreviewGenerator {
  final Map<String, String> translations;

  L10nKeyPreviewGenerator(this.translations);

  /// プレビューを生成する
  Future<String> generatePreview(AssetId inputId, BuildStep buildStep) async {
    final content = await buildStep.readAsString(inputId);

    // 翻訳キーを検出
    final keys = await _findL10nKeys(content, buildStep);
    if (keys.isEmpty) {
      return content;
    }

    // コメントを挿入
    return _insertComments(content, keys);
  }

  /// 翻訳キーを検出する
  Future<List<_L10nKeyInfo>> _findL10nKeys(
      String content, BuildStep buildStep) async {
    final result = parseString(content: content);
    final visitor = _L10nKeyVisitor(translations, buildStep);
    result.unit.visitChildren(visitor);
    return visitor.keys;
  }

  /// コメントを挿入する
  String _insertComments(String content, List<_L10nKeyInfo> keys) {
    // 位置の降順でソート（後ろから挿入するため）
    keys.sort((a, b) => b.position.compareTo(a.position));

    // 行ごとに分割
    final lines = content.split('\n');

    // 各キーに対して処理
    for (final key in keys) {
      // 行番号と列番号を計算
      int position = 0;
      int lineNumber = 0;

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (position + line.length + 1 > key.position) {
          lineNumber = i;
          break;
        }
        position += line.length + 1; // +1 for newline
      }

      // 行を取得
      final line = lines[lineNumber];

      // すでにコメントが存在する場合は追加しない
      if (line.contains('// ${key.translation}')) {
        continue;
      }

      // 行末にコメントを追加する
      // 既存のコメントがある場合は、その前に挿入
      final commentIndex = line.indexOf('//');
      if (commentIndex >= 0) {
        final beforeComment = line.substring(0, commentIndex).trimRight();
        final afterComment = line.substring(commentIndex);
        lines[lineNumber] =
            '$beforeComment // ${key.translation} $afterComment';
      } else {
        lines[lineNumber] = '$line // ${key.translation}';
      }
    }

    // 行を結合して返す
    return lines.join('\n');
  }
}

/// 翻訳キーの情報
class _L10nKeyInfo {
  final String key;
  final String translation;
  final int position;

  _L10nKeyInfo(this.key, this.translation, this.position);
}

/// 翻訳キーを検出するビジター
class _L10nKeyVisitor extends RecursiveAstVisitor<void> {
  final Map<String, String> translations;
  final List<_L10nKeyInfo> keys = [];
  // final log = Logger('l10n_key_preview');
  final BuildStep buildStep;

  _L10nKeyVisitor(this.translations, this.buildStep);

  @override
  void visitPropertyAccess(PropertyAccess node) {
    // l10n.keyの形式を検出
    if (node.target is SimpleIdentifier &&
        (node.target as SimpleIdentifier).name == 'l10n') {
      final key = node.propertyName.name;
      final translation = translations[key];
      if (translation != null) {
        log.fine(
            'Found l10n key (property): $key with translation: $translation');

        // ノードの位置を取得
        keys.add(_L10nKeyInfo(key, translation, node.offset));
      }
    }
    super.visitPropertyAccess(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    // l10n.keyの別の形式を検出
    if (node.prefix.name == 'l10n') {
      final key = node.identifier.name;
      final translation = translations[key];
      if (translation != null) {
        log.fine(
            'Found l10n key (prefixed): $key with translation: $translation');

        // ノードの位置を取得
        keys.add(_L10nKeyInfo(key, translation, node.offset));
      }
    }
    super.visitPrefixedIdentifier(node);
  }
}
