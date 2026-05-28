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
  // ── DeepSeek ──
  DefaultModelPricePreset(
    providerType: ProviderType.deepseek,
    modelName: 'deepseek-chat',
    inputPricePer1M: 0.27,
    outputPricePer1M: 1.10,
    cachedInputPricePer1M: 0.07,
    sourceNote:
        'DeepSeek official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.deepseek,
    modelName: 'deepseek-reasoner',
    inputPricePer1M: 0.55,
    outputPricePer1M: 2.19,
    cachedInputPricePer1M: 0.14,
    reasoningOutputPricePer1M: 2.19,
    sourceNote:
        'DeepSeek official API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Gemini (Google) ──
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-3.5-flash',
    inputPricePer1M: 0.15,
    outputPricePer1M: 0.60,
    cachedInputPricePer1M: 0.015,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-3.1-pro',
    inputPricePer1M: 2.00,
    outputPricePer1M: 15.00,
    cachedInputPricePer1M: 0.20,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier <=200k prompt, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-3-flash-preview',
    inputPricePer1M: 0.50,
    outputPricePer1M: 3.00,
    cachedInputPricePer1M: 0.05,
    reasoningOutputPricePer1M: 3.00,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-2.5-pro',
    inputPricePer1M: 1.25,
    outputPricePer1M: 10.00,
    cachedInputPricePer1M: 0.125,
    reasoningOutputPricePer1M: 10.00,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier <=200k prompt tokens, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-2.5-flash',
    inputPricePer1M: 0.30,
    outputPricePer1M: 2.50,
    cachedInputPricePer1M: 0.03,
    reasoningOutputPricePer1M: 2.50,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-2.5-flash-lite',
    inputPricePer1M: 0.10,
    outputPricePer1M: 0.40,
    cachedInputPricePer1M: 0.01,
    reasoningOutputPricePer1M: 0.40,
    sourceNote:
        'Google Gemini API pricing, Standard paid tier, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.gemini,
    modelName: 'gemini-embedding-001',
    inputPricePer1M: 0.15,
    outputPricePer1M: 0.0,
    sourceNote:
        'Google Gemini API pricing, embedding input price, USD per 1M tokens, checked 2026-05.',
  ),

  // ── OpenAI ──
  DefaultModelPricePreset(
    providerType: ProviderType.openai,
    modelName: 'gpt-4.1',
    inputPricePer1M: 2.00,
    outputPricePer1M: 8.00,
    cachedInputPricePer1M: 0.50,
    sourceNote:
        'OpenAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.openai,
    modelName: 'gpt-4.1-mini',
    inputPricePer1M: 0.40,
    outputPricePer1M: 1.60,
    cachedInputPricePer1M: 0.10,
    sourceNote:
        'OpenAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.openai,
    modelName: 'gpt-4.1-nano',
    inputPricePer1M: 0.10,
    outputPricePer1M: 0.40,
    cachedInputPricePer1M: 0.025,
    sourceNote:
        'OpenAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.openai,
    modelName: 'gpt-4o',
    inputPricePer1M: 2.50,
    outputPricePer1M: 10.00,
    cachedInputPricePer1M: 1.25,
    sourceNote:
        'OpenAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.openai,
    modelName: 'gpt-4o-mini',
    inputPricePer1M: 0.15,
    outputPricePer1M: 0.60,
    cachedInputPricePer1M: 0.075,
    sourceNote:
        'OpenAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.openai,
    modelName: 'o3',
    inputPricePer1M: 2.00,
    outputPricePer1M: 8.00,
    cachedInputPricePer1M: 0.50,
    reasoningOutputPricePer1M: 8.00,
    sourceNote:
        'OpenAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.openai,
    modelName: 'o3-mini',
    inputPricePer1M: 1.10,
    outputPricePer1M: 4.40,
    cachedInputPricePer1M: 0.275,
    reasoningOutputPricePer1M: 4.40,
    sourceNote:
        'OpenAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.openai,
    modelName: 'o4-mini',
    inputPricePer1M: 1.10,
    outputPricePer1M: 4.40,
    cachedInputPricePer1M: 0.275,
    reasoningOutputPricePer1M: 4.40,
    sourceNote:
        'OpenAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Anthropic Claude ──
  DefaultModelPricePreset(
    providerType: ProviderType.anthropic,
    modelName: 'claude-opus-4',
    inputPricePer1M: 15.00,
    outputPricePer1M: 75.00,
    cachedInputPricePer1M: 1.50,
    sourceNote:
        'Anthropic official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.anthropic,
    modelName: 'claude-sonnet-4',
    inputPricePer1M: 3.00,
    outputPricePer1M: 15.00,
    cachedInputPricePer1M: 0.30,
    sourceNote:
        'Anthropic official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.anthropic,
    modelName: 'claude-3.5-sonnet',
    inputPricePer1M: 3.00,
    outputPricePer1M: 15.00,
    cachedInputPricePer1M: 0.30,
    sourceNote:
        'Anthropic official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.anthropic,
    modelName: 'claude-3.5-haiku',
    inputPricePer1M: 0.80,
    outputPricePer1M: 4.00,
    cachedInputPricePer1M: 0.08,
    sourceNote:
        'Anthropic official API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── xAI Grok ──
  DefaultModelPricePreset(
    providerType: ProviderType.xai,
    modelName: 'grok-3',
    inputPricePer1M: 3.00,
    outputPricePer1M: 15.00,
    cachedInputPricePer1M: 0.75,
    sourceNote: 'xAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.xai,
    modelName: 'grok-3-mini',
    inputPricePer1M: 0.30,
    outputPricePer1M: 0.50,
    reasoningOutputPricePer1M: 0.50,
    sourceNote: 'xAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.xai,
    modelName: 'grok-2',
    inputPricePer1M: 2.00,
    outputPricePer1M: 10.00,
    sourceNote: 'xAI official API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Qwen (通义千问) ──
  DefaultModelPricePreset(
    providerType: ProviderType.qwen,
    modelName: 'qwen-max',
    inputPricePer1M: 2.40,
    outputPricePer1M: 9.60,
    cachedInputPricePer1M: 0.60,
    currency: 'USD',
    sourceNote:
        'Alibaba DashScope pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.qwen,
    modelName: 'qwen-plus',
    inputPricePer1M: 0.80,
    outputPricePer1M: 2.00,
    cachedInputPricePer1M: 0.20,
    currency: 'USD',
    sourceNote:
        'Alibaba DashScope pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.qwen,
    modelName: 'qwen-turbo',
    inputPricePer1M: 0.30,
    outputPricePer1M: 0.60,
    cachedInputPricePer1M: 0.06,
    currency: 'USD',
    sourceNote:
        'Alibaba DashScope pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.qwen,
    modelName: 'qwen-long',
    inputPricePer1M: 0.50,
    outputPricePer1M: 2.00,
    cachedInputPricePer1M: 0.10,
    currency: 'USD',
    sourceNote:
        'Alibaba DashScope pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Zhipu GLM (智谱) ──
  DefaultModelPricePreset(
    providerType: ProviderType.zhipu,
    modelName: 'glm-4-plus',
    inputPricePer1M: 5.00,
    outputPricePer1M: 5.00,
    currency: 'USD',
    sourceNote: 'Zhipu GLM API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.zhipu,
    modelName: 'glm-4',
    inputPricePer1M: 14.29,
    outputPricePer1M: 14.29,
    currency: 'USD',
    sourceNote:
        'Zhipu GLM API pricing (≈100 CNY/1M tokens), USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.zhipu,
    modelName: 'glm-4-flash',
    inputPricePer1M: 0.00,
    outputPricePer1M: 0.00,
    currency: 'USD',
    sourceNote: 'Zhipu GLM free tier, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.zhipu,
    modelName: 'glm-4-long',
    inputPricePer1M: 1.00,
    outputPricePer1M: 1.00,
    currency: 'USD',
    sourceNote: 'Zhipu GLM API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── MiniMax ──
  DefaultModelPricePreset(
    providerType: ProviderType.minimax,
    modelName: 'MiniMax-Text-01',
    inputPricePer1M: 1.00,
    outputPricePer1M: 8.00,
    currency: 'USD',
    sourceNote:
        'MiniMax official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.minimax,
    modelName: 'abab6.5s-chat',
    inputPricePer1M: 0.50,
    outputPricePer1M: 1.00,
    currency: 'USD',
    sourceNote:
        'MiniMax official API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Moonshot (Kimi) ──
  DefaultModelPricePreset(
    providerType: ProviderType.moonshot,
    modelName: 'moonshot-v1-128k',
    inputPricePer1M: 10.00,
    outputPricePer1M: 10.00,
    currency: 'USD',
    sourceNote:
        'Moonshot Kimi API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.moonshot,
    modelName: 'moonshot-v1-32k',
    inputPricePer1M: 5.00,
    outputPricePer1M: 5.00,
    currency: 'USD',
    sourceNote:
        'Moonshot Kimi API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.moonshot,
    modelName: 'moonshot-v1-8k',
    inputPricePer1M: 1.50,
    outputPricePer1M: 1.50,
    currency: 'USD',
    sourceNote:
        'Moonshot Kimi API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── SiliconFlow (硅基流动) ──
  DefaultModelPricePreset(
    providerType: ProviderType.siliconFlow,
    modelName: 'deepseek-ai/DeepSeek-V3',
    inputPricePer1M: 0.27,
    outputPricePer1M: 1.10,
    cachedInputPricePer1M: 0.07,
    currency: 'USD',
    sourceNote:
        'SiliconFlow pricing for DeepSeek-V3, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.siliconFlow,
    modelName: 'deepseek-ai/DeepSeek-R1',
    inputPricePer1M: 0.55,
    outputPricePer1M: 2.19,
    cachedInputPricePer1M: 0.14,
    reasoningOutputPricePer1M: 2.19,
    currency: 'USD',
    sourceNote:
        'SiliconFlow pricing for DeepSeek-R1, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.siliconFlow,
    modelName: 'Qwen/Qwen2.5-72B-Instruct',
    inputPricePer1M: 0.35,
    outputPricePer1M: 0.35,
    currency: 'USD',
    sourceNote: 'SiliconFlow pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Groq ──
  DefaultModelPricePreset(
    providerType: ProviderType.groq,
    modelName: 'llama-3.3-70b-versatile',
    inputPricePer1M: 0.59,
    outputPricePer1M: 0.79,
    sourceNote:
        'Groq official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.groq,
    modelName: 'llama-3.1-8b-instant',
    inputPricePer1M: 0.05,
    outputPricePer1M: 0.08,
    sourceNote:
        'Groq official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.groq,
    modelName: 'mixtral-8x7b-32768',
    inputPricePer1M: 0.24,
    outputPricePer1M: 0.24,
    sourceNote:
        'Groq official API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Mistral ──
  DefaultModelPricePreset(
    providerType: ProviderType.mistral,
    modelName: 'mistral-large-latest',
    inputPricePer1M: 2.00,
    outputPricePer1M: 6.00,
    cachedInputPricePer1M: 0.50,
    sourceNote:
        'Mistral official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.mistral,
    modelName: 'mistral-small-latest',
    inputPricePer1M: 0.10,
    outputPricePer1M: 0.30,
    sourceNote:
        'Mistral official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.mistral,
    modelName: 'codestral-latest',
    inputPricePer1M: 0.30,
    outputPricePer1M: 0.90,
    sourceNote:
        'Mistral Codestral pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Perplexity ──
  DefaultModelPricePreset(
    providerType: ProviderType.perplexity,
    modelName: 'sonar-pro',
    inputPricePer1M: 3.00,
    outputPricePer1M: 15.00,
    sourceNote:
        'Perplexity official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.perplexity,
    modelName: 'sonar',
    inputPricePer1M: 1.00,
    outputPricePer1M: 1.00,
    sourceNote:
        'Perplexity official API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Cohere ──
  DefaultModelPricePreset(
    providerType: ProviderType.cohere,
    modelName: 'command-r-plus',
    inputPricePer1M: 2.50,
    outputPricePer1M: 10.00,
    cachedInputPricePer1M: 0.60,
    sourceNote:
        'Cohere official API pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.cohere,
    modelName: 'command-r',
    inputPricePer1M: 0.15,
    outputPricePer1M: 0.60,
    cachedInputPricePer1M: 0.04,
    sourceNote:
        'Cohere official API pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Volcengine Ark (火山方舟) ──
  DefaultModelPricePreset(
    providerType: ProviderType.volcengineArk,
    modelName: 'doubao-1.5-pro-256k',
    inputPricePer1M: 0.70,
    outputPricePer1M: 1.30,
    currency: 'USD',
    sourceNote: 'Volcengine Ark pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.volcengineArk,
    modelName: 'doubao-1.5-lite-32k',
    inputPricePer1M: 0.04,
    outputPricePer1M: 0.08,
    currency: 'USD',
    sourceNote: 'Volcengine Ark pricing, USD per 1M tokens, checked 2026-05.',
  ),

  // ── Tencent Hunyuan (腾讯混元) ──
  DefaultModelPricePreset(
    providerType: ProviderType.tencentHunyuan,
    modelName: 'hunyuan-turbos-latest',
    inputPricePer1M: 1.40,
    outputPricePer1M: 5.60,
    currency: 'USD',
    sourceNote: 'Tencent Hunyuan pricing, USD per 1M tokens, checked 2026-05.',
  ),
  DefaultModelPricePreset(
    providerType: ProviderType.tencentHunyuan,
    modelName: 'hunyuan-lite',
    inputPricePer1M: 0.00,
    outputPricePer1M: 0.00,
    currency: 'USD',
    sourceNote: 'Tencent Hunyuan free tier, checked 2026-05.',
  ),
];
