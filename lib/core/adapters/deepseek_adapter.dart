import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'provider_adapter.dart';

class DeepSeekAdapter implements ProviderAdapter {
  @override
  String get providerName => 'DeepSeek';

  @override
  Future<BalanceResult?> fetchBalance({
    required String baseUrl,
    required String apiKey,
  }) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
      ));

      final response = await dio.get(
        '/user/balance',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final isAvailable = data['is_available'] as bool?;
        final currency = data['currency'] as String? ?? 'CNY';

        double? totalBalance;
        if (data['total_balance'] != null) {
          totalBalance = double.tryParse(data['total_balance'].toString());
        }

        return BalanceResult(
          totalBalance: totalBalance,
          usedBalance: null,
          remainingBalance: totalBalance,
          grantedBalance: data['granted_balance'] != null 
              ? double.tryParse(data['granted_balance'].toString()) : null,
          toppedUpBalance: data['topped_up_balance'] != null 
              ? double.tryParse(data['topped_up_balance'].toString()) : null,
          currency: currency,
          isAvailable: isAvailable,
          fetchedAt: DateTime.now(),
          source: 'official_api',
        );
      }
    } on DioException catch (e) {
      debugPrint('DeepSeek balance fetch error: ${e.message}');
    } catch (e) {
      debugPrint('DeepSeek balance fetch error: $e');
    }
    return null;
  }

  @override
  Future<List<ModelInfo>> fetchModels({
    required String baseUrl,
    required String apiKey,
  }) async {
    return [
      ModelInfo(
        modelId: 'deepseek-chat',
        displayName: 'DeepSeek Chat',
        providerType: 'deepseek',
      ),
      ModelInfo(
        modelId: 'deepseek-reasoner',
        displayName: 'DeepSeek Reasoner',
        providerType: 'deepseek',
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
        cachedTokens: (usage['prompt_tokens_details'] as Map<String, dynamic>?)?['cached_tokens'] as int?,
        reasoningTokens: (usage['completion_tokens_details'] as Map<String, dynamic>?)?['reasoning_tokens'] as int?,
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
        estimatorName: 'deepseek_fallback',
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
    const chineseCharWeight = 1.5;
    const englishWordWeight = 1.3;

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

      return (chineseChars * chineseCharWeight + englishWords * englishWordWeight).round();
    }

    final promptTokens = estimateTokens(promptText);
    final completionTokens = estimateTokens(completionText);

    return TokenEstimateResult(
      promptTokens: promptTokens,
      completionTokens: completionTokens,
      cachedTokens: 0,
      reasoningTokens: 0,
      totalTokens: promptTokens + completionTokens,
      estimated: true,
      lowConfidence: true,
      estimatorName: 'generic',
      estimatorVersion: '1.0',
    );
  }
}
