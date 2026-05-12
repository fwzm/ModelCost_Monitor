import '../models/models.dart';

abstract class ProviderAdapter {
  String get providerName;

  Future<BalanceResult?> fetchBalance({
    required String baseUrl,
    required String apiKey,
  });

  Future<List<ModelInfo>> fetchModels({
    required String baseUrl,
    required String apiKey,
  });

  UsageParseResult parseUsageFromResponse({
    required String model,
    required Map<String, dynamic> responseJson,
    required DateTime requestTime,
    required String source,
  });

  TokenEstimateResult estimateTokens({
    required String model,
    required String promptText,
    required String completionText,
  });
}
