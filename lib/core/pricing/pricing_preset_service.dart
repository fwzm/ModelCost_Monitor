import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:http/http.dart' as http;

import '../../data/database/database.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'default_model_prices.dart';

class PricingPresetImportResult {
  final int importedCount;
  final int skippedCount;
  final String source;

  const PricingPresetImportResult({
    required this.importedCount,
    required this.skippedCount,
    required this.source,
  });
}

class PricingPresetService {
  static const _openRouterModelsUrl = 'https://openrouter.ai/api/v1/models';

  Future<PricingPresetImportResult> applyBuiltInPresets(
    PricingService service,
  ) async {
    var imported = 0;
    for (final preset in defaultModelPricePresets) {
      await service.upsertPrice(
        ModelPricesCompanion.insert(
          providerType: preset.providerType,
          modelName: preset.modelName,
          inputPricePer1M: preset.inputPricePer1M,
          outputPricePer1M: preset.outputPricePer1M,
          cachedInputPricePer1M: Value(preset.cachedInputPricePer1M),
          reasoningOutputPricePer1M: Value(preset.reasoningOutputPricePer1M),
          currency: Value(preset.currency),
          sourceNote: Value(preset.sourceNote),
          effectiveFrom: Value(DateTime(2026, 5, 27)),
        ),
      );
      imported++;
    }

    return PricingPresetImportResult(
      importedCount: imported,
      skippedCount: 0,
      source: 'built_in',
    );
  }

  Future<PricingPresetImportResult> importOpenRouterPrices(
    PricingService service, {
    int maxModels = 500,
  }) async {
    final response = await http
        .get(
          Uri.parse(_openRouterModelsUrl),
          headers: const {
            'Accept': 'application/json',
            'User-Agent': 'ModelCost-Monitor/1.0.0',
          },
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'OpenRouter models API returned HTTP ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['data'] is! List) {
      throw const FormatException('Unexpected OpenRouter models response');
    }

    var imported = 0;
    var skipped = 0;
    final models = (decoded['data'] as List).take(maxModels);
    for (final item in models) {
      if (item is! Map<String, dynamic>) {
        skipped++;
        continue;
      }
      final id = item['id']?.toString();
      final pricing = item['pricing'];
      if (id == null || pricing is! Map<String, dynamic>) {
        skipped++;
        continue;
      }

      final inputPerToken = _parsePrice(pricing['prompt']);
      final outputPerToken = _parsePrice(pricing['completion']);
      if (inputPerToken == null || outputPerToken == null) {
        skipped++;
        continue;
      }

      final cachedInputPerToken = _parsePrice(pricing['input_cache_read']);
      final reasoningPerToken = _parsePrice(pricing['internal_reasoning']);
      await service.upsertPrice(
        ModelPricesCompanion.insert(
          providerType: ProviderType.openrouter,
          modelName: id,
          inputPricePer1M: inputPerToken * 1000000,
          outputPricePer1M: outputPerToken * 1000000,
          cachedInputPricePer1M: Value(
            cachedInputPerToken == null ? null : cachedInputPerToken * 1000000,
          ),
          reasoningOutputPricePer1M: Value(
            reasoningPerToken == null ? null : reasoningPerToken * 1000000,
          ),
          currency: const Value('USD'),
          sourceNote: const Value(
            'OpenRouter /api/v1/models pricing, USD per token converted to per 1M tokens.',
          ),
          effectiveFrom: Value(DateTime.now()),
        ),
      );
      imported++;
    }

    return PricingPresetImportResult(
      importedCount: imported,
      skippedCount: skipped,
      source: _openRouterModelsUrl,
    );
  }

  double? _parsePrice(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
