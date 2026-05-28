import 'package:flutter_test/flutter_test.dart';
import 'package:modelcost_monitor/core/models/models.dart';
import 'package:modelcost_monitor/core/providers/provider_catalog.dart';
import 'package:modelcost_monitor/l10n/l10n.dart';

void main() {
  group('ProviderType', () {
    test('has all expected values', () {
      expect(ProviderType.values.length, equals(providerCatalog.length));
      expect(ProviderType.values, contains(ProviderType.deepseek));
      expect(ProviderType.values, contains(ProviderType.openai));
      expect(ProviderType.values, contains(ProviderType.anthropic));
      expect(ProviderType.values, contains(ProviderType.mimo));
      expect(ProviderType.values, contains(ProviderType.gemini));
      expect(ProviderType.values, contains(ProviderType.openrouter));
      expect(ProviderType.values, contains(ProviderType.azureOpenAI));
      expect(ProviderType.values, contains(ProviderType.groq));
      expect(ProviderType.values, contains(ProviderType.mistral));
      expect(ProviderType.values, contains(ProviderType.togetherAI));
      expect(ProviderType.values, contains(ProviderType.fireworksAI));
      expect(ProviderType.values, contains(ProviderType.perplexity));
      expect(ProviderType.values, contains(ProviderType.xai));
      expect(ProviderType.values, contains(ProviderType.cohere));
      expect(ProviderType.values, contains(ProviderType.cerebras));
      expect(ProviderType.values, contains(ProviderType.moonshot));
      expect(ProviderType.values, contains(ProviderType.qwen));
      expect(ProviderType.values, contains(ProviderType.zhipu));
      expect(ProviderType.values, contains(ProviderType.siliconFlow));
      expect(ProviderType.values, contains(ProviderType.volcengineArk));
      expect(ProviderType.values, contains(ProviderType.tencentHunyuan));
      expect(ProviderType.values, contains(ProviderType.minimax));
      expect(ProviderType.values, contains(ProviderType.novita));
      expect(ProviderType.values, contains(ProviderType.customOpenAI));
    });

    test('name property matches enum value', () {
      expect(ProviderType.deepseek.name, equals('deepseek'));
      expect(ProviderType.azureOpenAI.name, equals('azureOpenAI'));
      expect(ProviderType.togetherAI.name, equals('togetherAI'));
      expect(ProviderType.customOpenAI.name, equals('customOpenAI'));
    });

    test('catalog provides defaults for every provider', () {
      for (final type in ProviderType.values) {
        final entry = providerCatalogFor(type);
        expect(entry.defaultBaseUrl, isNotEmpty);
        expect(entry.defaultModel, isNotEmpty);
        expect(entry.noteKey, startsWith('provider_note_'));
      }
    });
  });

  group('ProxyState', () {
    test('has all expected values', () {
      expect(ProxyState.values.length, equals(6));
      expect(ProxyState.values, contains(ProxyState.stopped));
      expect(ProxyState.values, contains(ProxyState.running));
      expect(ProxyState.values, contains(ProxyState.crashed));
    });
  });

  group('AccountConfig', () {
    final config = AccountConfig(
      accountId: 1,
      providerType: ProviderType.deepseek,
      displayName: 'Test',
      baseUrl: 'https://api.example.com',
      apiKeyAlias: 'alias',
      apiKey: 'sk-1234567890abcdef',
      currency: 'CNY',
      enabled: true,
      proxyEnabled: false,
    );

    test('toMap round-trips via fromMap', () {
      final map = config.toMap();
      final restored = AccountConfig.fromMap(map);
      expect(restored.accountId, equals(1));
      expect(restored.providerType, equals(ProviderType.deepseek));
      expect(restored.displayName, equals('Test'));
      expect(restored.baseUrl, equals('https://api.example.com'));
      expect(restored.apiKeyAlias, equals('alias'));
      expect(restored.apiKey, equals('sk-1234567890abcdef'));
      expect(restored.currency, equals('CNY'));
      expect(restored.enabled, isTrue);
      expect(restored.proxyEnabled, isFalse);
    });

    test('fromMap defaults unknown provider to customOpenAI', () {
      final map = config.toMap();
      map['providerType'] = 'unknown_provider';
      final restored = AccountConfig.fromMap(map);
      expect(restored.providerType, equals(ProviderType.customOpenAI));
    });

    test('fromMap defaults missing currency to USD', () {
      final map = config.toMap();
      map.remove('currency');
      final restored = AccountConfig.fromMap(map);
      expect(restored.currency, equals('USD'));
    });

    test('fromMap defaults missing enabled/proxyEnabled to true', () {
      final map = config.toMap();
      map.remove('enabled');
      map.remove('proxyEnabled');
      final restored = AccountConfig.fromMap(map);
      expect(restored.enabled, isTrue);
      expect(restored.proxyEnabled, isTrue);
    });
  });

  group('ModelPriceConfig', () {
    test('stores all fields correctly', () {
      final price = ModelPriceConfig(
        providerType: ProviderType.openrouter,
        modelName: 'gpt-4o',
        inputPricePer1M: 2.5,
        outputPricePer1M: 10.0,
        cachedInputPricePer1M: 1.25,
        reasoningOutputPricePer1M: 15.0,
        currency: 'USD',
      );
      expect(price.providerType, equals(ProviderType.openrouter));
      expect(price.modelName, equals('gpt-4o'));
      expect(price.inputPricePer1M, equals(2.5));
      expect(price.outputPricePer1M, equals(10.0));
      expect(price.cachedInputPricePer1M, equals(1.25));
      expect(price.reasoningOutputPricePer1M, equals(15.0));
      expect(price.currency, equals('USD'));
    });

    test('optional fields default to null', () {
      final price = ModelPriceConfig(
        providerType: ProviderType.deepseek,
        modelName: 'deepseek-chat',
        inputPricePer1M: 0.14,
        outputPricePer1M: 0.28,
        currency: 'CNY',
      );
      expect(price.cachedInputPricePer1M, isNull);
      expect(price.reasoningOutputPricePer1M, isNull);
    });
  });

  group('API key masking', () {
    String maskApiKey(String key) {
      if (key.length <= 8) return '****';
      return '${key.substring(0, 4)}...${key.substring(key.length - 4)}';
    }

    test('masks long key showing first 4 and last 4', () {
      expect(maskApiKey('sk-1234567890abcdef'), equals('sk-1...cdef'));
    });

    test('masks short key entirely', () {
      expect(maskApiKey('sk-12'), equals('****'));
    });

    test('masks exactly 8-char key entirely', () {
      expect(maskApiKey('sk-12345'), equals('****'));
    });
  });

  group('L10n', () {
    test('init with forced locale loads strings', () async {
      await L10n.init(forceLocale: AppLocale.en);
      expect(L10n.current, equals(AppLocale.en));
      expect(L10n.of('app_title'), equals('ModelCost Monitor'));
      expect(L10n.of('proxy_start'), equals('Start'));
    });

    test('of returns key itself for missing entries', () async {
      await L10n.init(forceLocale: AppLocale.en);
      expect(L10n.of('nonexistent_key'), equals('nonexistent_key'));
    });

    test('switching locale changes strings', () async {
      await L10n.init(forceLocale: AppLocale.zhCN);
      expect(L10n.of('proxy_start'), isNot(equals('Start')));
      await L10n.init(forceLocale: AppLocale.en);
      expect(L10n.of('proxy_start'), equals('Start'));
    });
  });
}
