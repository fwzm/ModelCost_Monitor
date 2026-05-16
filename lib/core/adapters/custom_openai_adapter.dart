import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:json_path/json_path.dart';

import '../models/models.dart';
import 'provider_adapter.dart';

class CustomOpenAIAdapter implements ProviderAdapter {
  @override
  String get providerName => 'Custom OpenAI';

  final Map<String, String>? _jsonPathMappings;

  CustomOpenAIAdapter({Map<String, String>? jsonPathMappings})
    : _jsonPathMappings = jsonPathMappings;

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
                  displayName: m['name'] as String? ?? m['id'] as String,
                  providerType: 'customOpenAI',
                ),
              )
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Custom OpenAI models fetch error: $e');
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
      int? promptTokens;
      int? completionTokens;
      int? totalTokens;
      int? cachedTokens;
      int? reasoningTokens;

      final mappings = _jsonPathMappings;
      if (mappings != null && mappings.isNotEmpty) {
        final promptPath = mappings['prompt_tokens'];
        if (promptPath != null) {
          promptTokens = _extractIntByPath(responseJson, promptPath);
        }
        final completionPath = mappings['completion_tokens'];
        if (completionPath != null) {
          completionTokens = _extractIntByPath(responseJson, completionPath);
        }
        final totalPath = mappings['total_tokens'];
        if (totalPath != null) {
          totalTokens = _extractIntByPath(responseJson, totalPath);
        }
      } else {
        final usage = responseJson['usage'] as Map<String, dynamic>?;
        if (usage != null) {
          promptTokens = usage['prompt_tokens'] as int?;
          completionTokens = usage['completion_tokens'] as int?;
          totalTokens = usage['total_tokens'] as int?;
        }
      }

      final hasUsage = promptTokens != null || completionTokens != null;

      return UsageParseResult(
        promptTokens: promptTokens,
        completionTokens: completionTokens,
        cachedTokens: cachedTokens,
        reasoningTokens: reasoningTokens,
        totalTokens: totalTokens,
        estimated: !hasUsage,
        estimatorName: hasUsage ? null : 'custom_openai_fallback',
        requestStatus: hasUsage
            ? RequestStatus.completed
            : RequestStatus.estimatedOnly,
      );
    } catch (e) {
      return UsageParseResult(
        promptTokens: null,
        completionTokens: null,
        cachedTokens: null,
        reasoningTokens: null,
        totalTokens: null,
        estimated: true,
        estimatorName: 'custom_openai_error',
        requestStatus: RequestStatus.parseError,
      );
    }
  }

  int? _extractIntByPath(Map<String, dynamic> json, String path) {
    try {
      final result = JsonPath(path).read(json);
      if (result.isNotEmpty) {
        final value = result.first.value;
        if (value is int) return value;
        if (value is num) return value.toInt();
        if (value is String) return int.tryParse(value);
      }
    } catch (e) {
      debugPrint('JSONPath extract error for $path: $e');
    }
    return null;
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
