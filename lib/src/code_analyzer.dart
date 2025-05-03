import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// Dartコード内の翻訳キー使用箇所を検出するビジター
class L10nKeyVisitor extends RecursiveAstVisitor<void> {
  final Map<String, String> translations;
  final List<L10nKeyUsage> usages = [];

  L10nKeyVisitor(this.translations);

  @override
  void visitPropertyAccess(PropertyAccess node) {
    // l10n.keyName パターンを検出
    if (node.target is SimpleIdentifier &&
        (node.target as SimpleIdentifier).name == 'l10n') {
      final keyName = node.propertyName.name;
      if (translations.containsKey(keyName)) {
        usages.add(
          L10nKeyUsage(
            node: node,
            key: keyName,
            translation: translations[keyName]!,
          ),
        );
      }
    }
    super.visitPropertyAccess(node);
  }
}

/// 翻訳キーの使用箇所を表すクラス
class L10nKeyUsage {
  final AstNode node;
  final String key;
  final String translation;

  L10nKeyUsage({
    required this.node,
    required this.key,
    required this.translation,
  });
}
