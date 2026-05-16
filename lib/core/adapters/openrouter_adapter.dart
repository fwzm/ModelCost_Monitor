import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'provider_adapter.dart';

class OpenRouterAdapter implements ProviderAdapter {
  @override
  String get providerName => 'OpenRouter';

  @override
  Future<BalanceResult?> fetchBalance({
    required String baseUrl,
    required String apiKey,
  }) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      final response = await dio.get(
        '/auth/key',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final credits = data['data'] != null
            ? data['data']['credits']
            : data['credits'];

        return BalanceResult(
          totalBalance: credits != null
              ? double.tryParse(credits.toString())
              : null,
          usedBalance: null,
          remainingBalance: credits != null
              ? double.tryParse(credits.toString())
              : null,
          grantedBalance: null,
          toppedUpBalance: null,
          currency: 'USD',
          isAvailable: true,
          fetchedAt: DateTime.now(),
          source: 'official_api',
        );
      }
    } on DioException catch (e) {
      debugPrint('OpenRouter balance fetch error: ${e.message}');
    } catch (e) {
      debugPrint('OpenRouter balance fetch error: $e');
    }
    return null;
  }

  @override
  Future<List<ModelInfo>> fetchModels({
    required String baseUrl,
    required String apiKey,
  }) async {
    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      final response = await dio.get(
        '/models',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final models = data['data'] as List<dynamic>?;
        if (models != null) {
          return models
              .map(
                (m) => ModelInfo(
                  modelId: m['id'] as String,
                  displayName: m['name'] as String?,
                  providerType: 'openrouter',
                  metadata: m as Map<String, dynamic>?,
                ),
              )
              .toList();
        }
      }
    } catch (e) {
      debugPrint('OpenRouter models fetch error: $e');
    }
    return [];
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
        estimatorName: 'openrouter_fallback',
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
