import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:modelcost_monitor/l10n/l10n.dart';
import 'package:modelcost_monitor/core/models/models.dart';

void main() {
  group('L10n', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await L10n.init(forceLocale: AppLocale.zhCN);
    });

    test('initializes with Chinese locale', () {
      expect(L10n.of('appTitle'), isNotEmpty);
    });

    test('switches to English locale', () async {
      await L10n.init(forceLocale: AppLocale.en);
      expect(L10n.of('appTitle'), isNotEmpty);
    });

    test('switches to Traditional Chinese locale', () async {
      await L10n.init(forceLocale: AppLocale.zhTW);
      expect(L10n.of('appTitle'), isNotEmpty);
    });

    test('returns key for missing translations', () async {
      await L10n.init(forceLocale: AppLocale.en);
      expect(L10n.of('nonexistent_key_12345'), equals('nonexistent_key_12345'));
    });
  });

  group('ProviderType', () {
    test('has all expected values', () {
      expect(ProviderType.values.length, equals(5));
      expect(ProviderType.values, contains(ProviderType.deepseek));
      expect(ProviderType.values, contains(ProviderType.customOpenAI));
      expect(ProviderType.values, contains(ProviderType.gemini));
      expect(ProviderType.values, contains(ProviderType.openrouter));
      expect(ProviderType.values, contains(ProviderType.mimo));
    });

    test('names are correct', () {
      expect(ProviderType.deepseek.name, equals('deepseek'));
      expect(ProviderType.customOpenAI.name, equals('customOpenAI'));
    });
  });

  group('ProxyState', () {
    test('has all expected values', () {
      expect(ProxyState.values.length, equals(6));
    });

    test('names are correct', () {
      expect(ProxyState.stopped.name, equals('stopped'));
      expect(ProxyState.running.name, equals('running'));
      expect(ProxyState.starting.name, equals('starting'));
      expect(ProxyState.stopping.name, equals('stopping'));
      expect(ProxyState.degraded.name, equals('degraded'));
      expect(ProxyState.crashed.name, equals('crashed'));
    });
  });

  group('AccountConfig', () {
    test('creates with required fields', () {
      final config = AccountConfig(
        accountId: 1,
        providerType: ProviderType.deepseek,
        displayName: 'Test Account',
        baseUrl: 'https://api.deepseek.com',
        apiKey: 'sk-test-key',
        currency: 'USD',
        enabled: true,
        proxyEnabled: true,
      );
      expect(config.accountId, equals(1));
      expect(config.providerType, equals(ProviderType.deepseek));
      expect(config.displayName, equals('Test Account'));
      expect(config.enabled, isTrue);
      expect(config.proxyEnabled, isTrue);
      expect(config.apiKeyAlias, isNull);
    });

    test('toMap returns correct values', () {
      final config = AccountConfig(
        accountId: 2,
        providerType: ProviderType.openrouter,
        displayName: 'OR Account',
        baseUrl: 'https://openrouter.ai/api/v1',
        apiKey: 'sk-or-key',
        currency: 'CNY',
        enabled: false,
        proxyEnabled: true,
      );
      final map = config.toMap();
      expect(map['providerType'], equals('openrouter'));
      expect(map['currency'], equals('CNY'));
      expect(map['enabled'], isFalse);
    });
  });

  group('ModelPriceConfig', () {
    test('creates with required fields', () {
      final config = ModelPriceConfig(
        providerType: ProviderType.deepseek,
        modelName: 'deepseek-chat',
        inputPricePer1M: 0.14,
        outputPricePer1M: 0.28,
        currency: 'CNY',
      );
      expect(config.modelName, equals('deepseek-chat'));
      expect(config.inputPricePer1M, equals(0.14));
      expect(config.outputPricePer1M, equals(0.28));
      expect(config.cachedInputPricePer1M, isNull);
      expect(config.reasoningOutputPricePer1M, isNull);
    });
  });

  group('API key masking', () {
    String maskApiKey(String apiKey) {
      if (apiKey.length <= 4) return '****';
      return '****${apiKey.substring(apiKey.length - 4)}';
    }

    test('masks short keys', () {
      expect(maskApiKey('abc'), equals('****'));
      expect(maskApiKey(''), equals('****'));
    });

    test('masks long keys showing last 4 chars', () {
      expect(maskApiKey('sk-1234567890abcdefghijklmnopqrstuvwxyz'), equals('****wxyz'));
      expect(maskApiKey('sk-1234'), equals('****1234'));
    });
  });
}
