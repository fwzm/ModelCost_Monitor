import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/services.dart';
import '../data/database/database.dart';
import '../core/proxy/proxy_isolate.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.connect();
});

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final accountServiceProvider = Provider<AccountService>((ref) {
  return AccountService(
    database: ref.read(databaseProvider),
    secureStorage: ref.read(secureStorageProvider),
  );
});

final balanceServiceProvider = Provider<BalanceService>((ref) {
  return BalanceService(database: ref.read(databaseProvider));
});

final usageServiceProvider = Provider<UsageService>((ref) {
  return UsageService(database: ref.read(databaseProvider));
});

final pricingServiceProvider = Provider<PricingService>((ref) {
  return PricingService(database: ref.read(databaseProvider));
});

final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(database: ref.read(databaseProvider));
});

final accountsProvider = FutureProvider<List<Account>>((ref) async {
  return ref.watch(accountServiceProvider).getAllAccounts();
});

final balanceSnapshotsProvider = FutureProvider<List<BalanceSnapshot>>((ref) async {
  final accountService = ref.watch(accountServiceProvider);
  final accounts = await accountService.getAllAccounts();
  if (accounts.isEmpty) return [];

  final snapshots = <BalanceSnapshot>[];
  for (final account in accounts) {
    final balance = await ref.watch(balanceServiceProvider).getLatestBalance(account.id);
    if (balance != null) {
      snapshots.add(balance);
    }
  }
  return snapshots;
});

final usageLogsProvider = FutureProvider<List<UsageLog>>((ref) async {
  return ref.watch(usageServiceProvider).getUsageLogs(limit: 10000);
});

final modelPricesProvider = FutureProvider<List<ModelPrice>>((ref) async {
  return ref.watch(pricingServiceProvider).getAllPrices();
});

final todayCostProvider = FutureProvider<double>((ref) async {
  return ref.watch(usageServiceProvider).getTodayCost();
});

final monthCostProvider = FutureProvider<double>((ref) async {
  return ref.watch(usageServiceProvider).getMonthCost();
});

final proxyManagerProvider = Provider<ProxyIsolateManager>((ref) {
  return ProxyIsolateManager();
});
