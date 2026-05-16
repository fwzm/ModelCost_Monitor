import '../models/models.dart';

abstract class TokenEstimator {
  String get name;

  TokenEstimateResult estimate({
    required String model,
    required String inputText,
    required String outputText,
    Map<String, dynamic>? rawRequest,
    Map<String, dynamic>? rawResponse,
  });
}

class OpenAITokenEstimator implements TokenEstimator {
  @override
  final String name = 'openai';
  final String _encoding;
  final String _version;

  OpenAITokenEstimator({
    String encoding = 'cl100k_base',
    String version = '1.0.0',
  }) : _encoding = encoding,
       _version = version;

  @override
  TokenEstimateResult estimate({
    required String model,
    required String inputText,
    required String outputText,
    Map<String, dynamic>? rawRequest,
    Map<String, dynamic>? rawResponse,
  }) {
    String encoding = _encoding;
    if (model.contains('o1') ||
        model.contains('o2') ||
        model.contains('gpt-4o')) {
      encoding = 'o200k_base';
    }

    final inputTokens = _estimateTokens(inputText, encoding);
    final outputTokens = _estimateTokens(outputText, encoding);

    return TokenEstimateResult(
      promptTokens: inputTokens,
      completionTokens: outputTokens,
      cachedTokens: 0,
      reasoningTokens: 0,
      totalTokens: inputTokens + outputTokens,
      estimated: true,
      lowConfidence: false,
      estimatorName: name,
      estimatorVersion: _version,
    );
  }

  int _estimateTokens(String text, String encoding) {
    if (text.isEmpty) return 0;

    int chineseChars = 0;
    int otherChars = 0;

    for (int i = 0; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      if (codeUnit > 0x4E00 && codeUnit < 0x9FFF) {
        chineseChars++;
      } else {
        otherChars++;
      }
    }

    if (encoding == 'o200k_base') {
      return (chineseChars * 1.5 + otherChars * 0.25).round();
    }

    return (chineseChars * 1.5 + otherChars * 0.3).round();
  }
}

class GenericTokenEstimator implements TokenEstimator {
  @override
  final String name = 'generic';
  final String _version;

  GenericTokenEstimator({String version = '1.0.0'}) : _version = version;

  @override
  TokenEstimateResult estimate({
    required String model,
    required String inputText,
    required String outputText,
    Map<String, dynamic>? rawRequest,
    Map<String, dynamic>? rawResponse,
  }) {
    final inputTokens = _estimateTokens(inputText);
    final outputTokens = _estimateTokens(outputText);

    return TokenEstimateResult(
      promptTokens: inputTokens,
      completionTokens: outputTokens,
      cachedTokens: 0,
      reasoningTokens: 0,
      totalTokens: inputTokens + outputTokens,
      estimated: true,
      lowConfidence: true,
      estimatorName: name,
      estimatorVersion: _version,
    );
  }

  int _estimateTokens(String text) {
    if (text.isEmpty) return 0;

    int chineseChars = 0;
    int englishWords = 0;

    final englishPattern = RegExp(r'[a-zA-Z]+');
    englishWords = englishPattern.allMatches(text).length;

    for (int i = 0; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      if (codeUnit > 0x4E00 && codeUnit < 0x9FFF) {
        chineseChars++;
      }
    }

    return (chineseChars * 1.5 + englishWords * 1.3).round();
  }
}
