import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

/// ARBファイルを解析して翻訳キーと日本語訳のマッピングを取得するクラス
class ArbParser {
  /// ARBファイルから翻訳マッピングを読み込む
  ///
  /// [projectPath] プロジェクトのルートパス
  /// 返り値: キーと日本語訳のマップ
  static Map<String, String> loadTranslations(String projectPath) {
    final translations = <String, String>{};
    final possiblePaths = [
      path.join(projectPath, 'lib', 'l10n', 'app_ja.arb'),
      path.join(projectPath, 'assets', 'l10n', 'app_ja.arb'),
      path.join(projectPath, 'assets', 'translations', 'ja.arb'),
    ];

    File? arbFile;
    for (final filePath in possiblePaths) {
      final file = File(filePath);
      if (file.existsSync()) {
        arbFile = file;
        break;
      }
    }

    if (arbFile == null) {
      return {};
    }

    try {
      final content = arbFile.readAsStringSync();
      final Map<String, dynamic> json = jsonDecode(content);

      // ARBファイルからメタデータを除外して翻訳のみを抽出
      json.forEach((key, value) {
        if (key.startsWith('@')) return; // メタデータをスキップ
        if (value is String) {
          translations[key] = value;
        }
      });

      return translations;
    } catch (e) {
      return {};
    }
  }
}
