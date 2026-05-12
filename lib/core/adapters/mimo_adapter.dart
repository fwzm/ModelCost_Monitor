import '../models/models.dart';
import 'provider_adapter.dart';

class MiMoAdapter implements ProviderAdapter {
  @override
  String get providerName => 'MiMo';

  @override
  Future<BalanceResult?> fetchBalance({
    required String baseUrl,
    required String apiKey,
  }) async {
    return null;
  }

  @override
  Future<List<ModelInfo>> fetchModels({
    required String baseUrl,
    required String apiKey,
  }) async {
    return [
      ModelInfo(
        modelId: 'mimo-v1-chat',
        displayName: 'MiMo V1 Chat',
        providerType: 'mimo',
      ),
    ];
  }

  @override
  UsageParseResult parseUsageFromResponse({
    required String model,
    required Map<String, dynamic> responseJson,
    required DateTime requestTime,
    required String source,
  }) {
    try {
      final usage = responseJson['usage'] as Map<String, dynamic>?;
      if (usage == null) {
        return UsageParseResult(
          promptTokens: null,
          completionTokens: null,
          cachedTokens: null,
          reasoningTokens: null,
          totalTokens: null,
          estimated: true,
          estimatorName: null,
          requestStatus: RequestStatus.estimatedOnly,
        );
      }

      return UsageParseResult(
        promptTokens: usage['prompt_tokens'] as int?,
        completionTokens: usage['completion_tokens'] as int?,
        cachedTokens: null,
        reasoningTokens: null,
        totalTokens: usage['total_tokens'] as int?,
        estimated: false,
        estimatorName: null,
        requestStatus: RequestStatus.completed,
      );
    } catch (e) {
      return UsageParseResult(
        promptTokens: null,
        completionTokens: null,
        cachedTokens: null,
        reasoningTokens: null,
        totalTokens: null,
        estimated: true,
        estimatorName: 'mimo_fallback',
        requestStatus: RequestStatus.parseError,
      );
    }
  }

  @override
  TokenEstimateResult estimateTokens({
    required String model,
    required String promptText,
    required String completionText,
  }) {
    int estimateTokens(String text) {
      int chineseChars = 0;
      int englishWords = 0;

      for (int i = 0; i < text.length; i++) {
        final codeUnit = text.codeUnitAt(i);
        if (codeUnit > 0x4E00 && codeUnit < 0x9FFF) {
          chineseChars++;
        }
      }

      final englishPattern = RegExp(r'[a-zA-Z]+');
      englishWords = englishPattern.allMatches(text).length;

      return (chineseChars * 1.5 + englishWords * 1.3).round();
    }

    return TokenEstimateResult(
      promptTokens: estimateTokens(promptText),
      completionTokens: estimateTokens(completionText),
      cachedTokens: 0,
      reasoningTokens: 0,
      totalTokens: estimateTokens(promptText) + estimateTokens(completionText),
      estimated: true,
      lowConfidence: true,
      estimatorName: 'generic',
      estimatorVersion: '1.0',
    );
  }
}
