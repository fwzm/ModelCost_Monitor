import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:drift/drift.dart' show Value;

import '../../data/database/database.dart';
import '../models/models.dart';

export 'secure_storage_service.dart';
export 'tray_service.dart';
export 'notification_service.dart';
export 'proxy_lifecycle_service.dart';

class SecureStorageService {
  static const _prefix = 'api_key_';
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> storeApiKey(int accountId, String apiKey) async {
    await _storage.write(key: '$_prefix$accountId', value: apiKey);
  }

  Future<String?> getApiKey(int accountId) async {
    return _storage.read(key: '$_prefix$accountId');
  }

  Future<void> deleteApiKey(int accountId) async {
    await _storage.delete(key: '$_prefix$accountId');
  }

  Future<Map<int, String>> getAllApiKeys(List<int> accountIds) async {
    final result = <int, String>{};
    for (final id in accountIds) {
      final key = await getApiKey(id);
      if (key != null) {
        result[id] = key;
      }
    }
    return result;
  }

  String maskApiKey(String apiKey) {
    if (apiKey.length <= 4) {
      return '****';
    }
    return '****${apiKey.substring(apiKey.length - 4)}';
  }
}

class AccountService {
  final AppDatabase database;
  final SecureStorageService secureStorage;

  AccountService({required this.database, required this.secureStorage});

  Future<List<Account>> getAllAccounts() {
    return database.getAllAccounts();
  }

  Future<Account?> getAccountById(int id) {
    return database.getAccountById(id);
  }

  Future<int> createAccount(AccountsCompanion account, String apiKey) async {
    final id = await database.insertAccount(account);
    await secureStorage.storeApiKey(id, apiKey);
    await database.updateAccount(
      id,
      AccountsCompanion(apiKeyAlias: Value(secureStorage.maskApiKey(apiKey))),
    );
    return id;
  }

  Future<int> updateAccount(
    int id,
    AccountsCompanion account, [
    String? newApiKey,
  ]) async {
    final result = await database.updateAccount(id, account);
    if (newApiKey != null && newApiKey.isNotEmpty) {
      await secureStorage.storeApiKey(id, newApiKey);
      await database.updateAccount(
        id,
        AccountsCompanion(
          apiKeyAlias: Value(secureStorage.maskApiKey(newApiKey)),
        ),
      );
    }
    return result;
  }

  Future<int> deleteAccount(int id) async {
    await secureStorage.deleteApiKey(id);
    return database.deleteAccount(id);
  }

  Future<String?> getApiKey(int accountId) {
    return secureStorage.getApiKey(accountId);
  }
}

class BalanceService {
  final AppDatabase database;

  BalanceService({required this.database});

  Future<BalanceSnapshot?> getLatestBalance(int accountId) {
    return database.getLatestBalance(accountId);
  }

  Future<List<BalanceSnapshot>> getBalanceHistory(
    int accountId, {
    int limit = 10,
  }) {
    return database.getBalanceSnapshotsByAccount(accountId, limit: limit);
  }

  Future<int> recordBalance(BalanceSnapshotsCompanion snapshot) {
    return database.insertBalanceSnapshot(snapshot);
  }
}

class UsageService {
  final AppDatabase database;

  UsageService({required this.database});

  Future<List<UsageLog>> getUsageLogs({
    int? accountId,
    DateTime? from,
    DateTime? to,
    int limit = 100,
    int offset = 0,
  }) {
    return database.getUsageLogs(
      accountId: accountId,
      from: from,
      to: to,
      limit: limit,
    );
  }

  Future<int> recordUsage(UsageLogsCompanion log) {
    return database.insertUsageLog(log);
  }

  Future<double> getTodayCost({int? accountId}) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final logs = await database.getUsageLogs(
      accountId: accountId,
      from: startOfDay,
      to: DateTime.now(),
      limit: 10000,
    );
    return logs
        .where((l) => l.cost != null)
        .fold<double>(0.0, (sum, l) => sum + l.cost!);
  }

  Future<double> getMonthCost({int? accountId}) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final logs = await database.getUsageLogs(
      accountId: accountId,
      from: startOfMonth,
      to: DateTime.now(),
      limit: 10000,
    );
    return logs
        .where((l) => l.cost != null)
        .fold<double>(0.0, (sum, l) => sum + l.cost!);
  }
}

class PricingService {
  final AppDatabase database;

  PricingService({required this.database});

  Future<List<ModelPrice>> getAllPrices() {
    return database.getAllModelPrices();
  }

  Future<ModelPrice?> getPrice(ProviderType providerType, String modelName) {
    return database.getModelPrice(providerType, modelName);
  }

  Future<int> addPrice(ModelPricesCompanion price) {
    return database.insertModelPrice(price);
  }

  Future<int> upsertPrice(ModelPricesCompanion price) {
    return database.upsertModelPrice(price);
  }

  Future<int> updatePrice(int id, ModelPricesCompanion price) {
    return database.updateModelPrice(id, price);
  }

  Future<int> deletePrice(int id) {
    return database.deleteModelPrice(id);
  }
}

class SettingsService {
  final AppDatabase database;

  SettingsService({required this.database});

  Future<String?> getSetting(String key) {
    return database.getSetting(key);
  }

  Future<int> setSetting(String key, String value) {
    return database.setSetting(key, value);
  }

  Future<String> getProxyHost() async {
    return await getSetting('proxy_host') ?? '127.0.0.1';
  }

  Future<int> getProxyPort() async {
    final value = await getSetting('proxy_port');
    return int.tryParse(value ?? '8787') ?? 8787;
  }

  Future<bool> isCorsEnabled() async {
    final value = await getSetting('enable_cors');
    return value != 'false';
  }

  Future<bool> isHttpsEnabled() async {
    final value = await getSetting('enable_https');
    return value == 'true';
  }
}
