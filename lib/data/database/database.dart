import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/models/models.dart';
import '../../core/pricing/default_model_prices.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    BalanceSnapshots,
    UsageLogs,
    ModelPrices,
    AlertRules,
    AppSettings,
    ProviderCapabilities,
    SchemaMigrationLogs,
    ProxyRuntimeLogs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  factory AppDatabase.connect() {
    return AppDatabase(_openConnection());
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedCapabilities();
        await _seedDefaultSettings();
        await _seedDefaultModelPrices();
        await customStatement('PRAGMA journal_mode=WAL');
        await customStatement('PRAGMA synchronous=NORMAL');
        await customStatement('PRAGMA foreign_keys=ON');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await _backupDatabase();
        await m.createAll();
        await _seedCapabilities();
        await _seedDefaultModelPrices();
        await customStatement('PRAGMA journal_mode=WAL');
        await customStatement('PRAGMA synchronous=NORMAL');
        await customStatement('PRAGMA foreign_keys=ON');
        await schemaMigrationLogs.insertOne(
          SchemaMigrationLogsCompanion.insert(
            fromVersion: from,
            toVersion: to,
            success: true,
          ),
        );
      },
      beforeOpen: (OpeningDetails details) async {
        await customStatement('PRAGMA journal_mode=WAL');
        await customStatement('PRAGMA synchronous=NORMAL');
        await customStatement('PRAGMA foreign_keys=ON');
      },
    );
  }

  Future<void> _backupDatabase() async {
    try {
      final dbDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbDir.path, 'modelcost_monitor.sqlite');
      final backupPath =
          '$dbPath.backup_${DateTime.now().millisecondsSinceEpoch}';
      final dbFile = File(dbPath);
      if (await dbFile.exists()) {
        await dbFile.copy(backupPath);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Database backup failed: $e');
    }
  }

  Future<void> _seedCapabilities() async {
    final capabilities = [
      (
        ProviderType.deepseek,
        true,
        true,
        true,
        true,
        false,
        'https://api.deepseek.com',
      ),
      (
        ProviderType.mimo,
        false,
        true,
        true,
        true,
        true,
        'https://api.xiaomimimo.com/v1',
      ),
      (
        ProviderType.gemini,
        false,
        true,
        true,
        true,
        true,
        'https://generativelanguage.googleapis.com/v1beta',
      ),
      (
        ProviderType.openrouter,
        true,
        true,
        true,
        true,
        false,
        'https://openrouter.ai/api/v1',
      ),
      (ProviderType.customOpenAI, false, false, true, true, false, null),
    ];

    for (final (type, balance, models, usage, streaming, manual, baseUrl)
        in capabilities) {
      await into(providerCapabilities).insert(
        ProviderCapabilitiesCompanion.insert(
          providerType: type,
          supportsBalanceQuery: Value(balance),
          supportsModelList: Value(models),
          supportsUsageParsing: Value(usage),
          supportsStreaming: Value(streaming),
          requiresManualQuota: Value(manual),
          baseUrlTemplate: Value(baseUrl),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  Future<void> _seedDefaultSettings() async {
    final defaultSettings = {
      'proxy_host': '127.0.0.1',
      'proxy_port': '8787',
      'proxy_scheme': 'http',
      'enable_cors': 'true',
      'enable_https': 'false',
      'enable_tokenizer_fallback': 'true',
      'ui_refresh_interval_ms': '500',
      'proxy_max_retries': '5',
      'proxy_retry_base_interval_ms': '100',
      'log_retention_days': '30',
    };

    for (final entry in defaultSettings.entries) {
      try {
        await into(appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            key: entry.key,
            value: Value(entry.value),
          ),
        );
      } catch (e) {
        // ignore: avoid_print
        print('Failed to seed setting ${entry.key}: $e');
      }
    }
  }

  Future<void> _seedDefaultModelPrices() async {
    for (final preset in defaultModelPricePresets) {
      await into(modelPrices).insert(
        ModelPricesCompanion.insert(
          providerType: preset.providerType,
          modelName: preset.modelName,
          inputPricePer1M: preset.inputPricePer1M,
          outputPricePer1M: preset.outputPricePer1M,
          cachedInputPricePer1M: Value(preset.cachedInputPricePer1M),
          reasoningOutputPricePer1M: Value(preset.reasoningOutputPricePer1M),
          currency: Value(preset.currency),
          sourceNote: Value(preset.sourceNote),
          effectiveFrom: Value(DateTime(2026, 5, 16)),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  Future<List<Account>> getAllAccounts() => select(accounts).get();

  Future<Account?> getAccountById(int id) {
    return (select(accounts)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<Account>> getEnabledAccounts() {
    return (select(accounts)..where((t) => t.enabled.equals(true))).get();
  }

  Future<int> insertAccount(AccountsCompanion account) =>
      into(accounts).insert(account);

  Future<int> updateAccount(int id, AccountsCompanion account) {
    return (update(accounts)..where((t) => t.id.equals(id))).write(account);
  }

  Future<int> deleteAccount(int id) {
    return (delete(accounts)..where((t) => t.id.equals(id))).go();
  }

  Future<List<BalanceSnapshot>> getBalanceSnapshotsByAccount(
    int accountId, {
    int limit = 10,
  }) {
    return (select(balanceSnapshots)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
          ..limit(limit))
        .get();
  }

  Future<BalanceSnapshot?> getLatestBalance(int accountId) {
    return (select(balanceSnapshots)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertBalanceSnapshot(BalanceSnapshotsCompanion snapshot) =>
      into(balanceSnapshots).insert(snapshot);

  Future<List<UsageLog>> getUsageLogs({
    int? accountId,
    DateTime? from,
    DateTime? to,
    int limit = 100,
    int offset = 0,
  }) {
    var query = select(usageLogs);
    if (accountId != null) {
      query = query..where((t) => t.accountId.equals(accountId));
    }
    if (from != null) {
      query = query..where((t) => t.requestTime.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query = query..where((t) => t.requestTime.isSmallerOrEqualValue(to));
    }
    return (query
          ..orderBy([(t) => OrderingTerm.desc(t.requestTime)])
          ..limit(limit))
        .get();
  }

  Future<int> insertUsageLog(UsageLogsCompanion log) =>
      into(usageLogs).insert(log);

  Future<List<ModelPrice>> getAllModelPrices() => select(modelPrices).get();

  Future<ModelPrice?> getModelPrice(
    ProviderType providerType,
    String modelName,
  ) {
    return (select(modelPrices)..where(
          (t) =>
              t.providerType.equalsValue(providerType) &
              t.modelName.equals(modelName),
        ))
        .getSingleOrNull();
  }

  Future<int> insertModelPrice(ModelPricesCompanion price) =>
      into(modelPrices).insert(price);

  Future<int> upsertModelPrice(ModelPricesCompanion price) {
    return into(modelPrices).insertOnConflictUpdate(price);
  }

  Future<int> updateModelPrice(int id, ModelPricesCompanion price) {
    return (update(modelPrices)..where((t) => t.id.equals(id))).write(price);
  }

  Future<int> deleteModelPrice(int id) {
    return (delete(modelPrices)..where((t) => t.id.equals(id))).go();
  }

  Future<List<AlertRule>> getAllAlertRules() => select(alertRules).get();

  Future<int> insertAlertRule(AlertRulesCompanion rule) =>
      into(alertRules).insert(rule);

  Future<String?> getSetting(String key) {
    return (select(appSettings)..where((t) => t.key.equals(key)))
        .getSingleOrNull()
        .then((row) => row?.value);
  }

  Future<int> setSetting(String key, String value) {
    return (update(appSettings)..where((t) => t.key.equals(key))).write(
      AppSettingsCompanion(value: Value(value)),
    );
  }

  Future<List<ProxyRuntimeLog>> getProxyRuntimeLogs({int limit = 100}) {
    return (select(proxyRuntimeLogs)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<int> insertProxyRuntimeLog(ProxyRuntimeLogsCompanion log) =>
      into(proxyRuntimeLogs).insert(log);

  Future<int> cleanOldProxyRuntimeLogs(int retentionDays) {
    final cutoff = DateTime.now().subtract(Duration(days: retentionDays));
    return (delete(
      proxyRuntimeLogs,
    )..where((t) => t.createdAt.isSmallerThanValue(cutoff))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbDir.path, 'modelcost_monitor.sqlite'));
    return NativeDatabase(dbFile);
  });
}
