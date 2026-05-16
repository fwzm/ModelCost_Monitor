import '../models/models.dart';

class DefaultModelPricePreset {
  final ProviderType providerType;
  final String modelName;
  final double inputPricePer1M;
  final double outputPricePer1M;
  final double? cachedInputPricePer1M;
  final double? reasoningOutputPricePer1M;
  final String currency;
  final String sourceNote;

  const DefaultModelPricePreset({
    required this.providerType,
    required this.modelName,
    required this.inputPricePer1M,
    required this.outputPricePer1M,
    this.cachedInputPricePer1M,
    this.reasoningOutputPricePer1M,
    this.currency = 'USD',
    required this.sourceNote,
  });
}

const defaultModelPricePresets = <DefaultModelPricePreset>[
  DefaultModelPricePreset(
    providerType: ProviderType.deepseek,
    modelName: 'deepseek-chat',
    inputPricePer1M: 0.27,
    outputPricePer1M: 1.10,
    cachedInputPricePer1M: 0.07,
    sourceNote:
        'DeepSeek official API pricing, USD per 1M tokens, checked 2026-05-16.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.deepseek,
    modelName: 'deepseek-reasoner',
    inputPricePer1M: 0.55,
    outputPricePer1M: 2.19,
    cachedInputPricePer1M: 0.14,
    reasoningOutputPricePer1M: 2.19,
    sourceNote:
        'DeepSeek official API pricing, USD per 1M tokens, checked 2026-05-16.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-3-flash-preview',
    inputPricePer1M: 0.50,
    outputPricePer1M: 3.00,
    cachedInputPricePer1M: 0.05,
    reasoningOutputPricePer1M: 3.00,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier, USD per 1M tokens, checked 2026-05-16.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-2.5-pro',
    inputPricePer1M: 1.25,
    outputPricePer1M: 10.00,
    cachedInputPricePer1M: 0.125,
    reasoningOutputPricePer1M: 10.00,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier <=200k prompt tokens, USD per 1M tokens, checked 2026-05-16.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-2.5-flash',
    inputPricePer1M: 0.30,
    outputPricePer1M: 2.50,
    cachedInputPricePer1M: 0.03,
    reasoningOutputPricePer1M: 2.50,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier, USD per 1M tokens, checked 2026-05-16.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-2.5-flash-lite',
    inputPricePer1M: 0.10,
    outputPricePer1M: 0.40,
    cachedInputPricePer1M: 0.01,
    reasoningOutputPricePer1M: 0.40,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier, USD per 1M tokens, checked 2026-05-16.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-embedding-001',
    inputPricePer1M: 0.15,
    outputPricePer1M: 0.0,
    sourceNote:
        'Google Gemini API pricing, embedding input price, USD per 1M tokens, checked 2026-05-16.',
  ),
];
