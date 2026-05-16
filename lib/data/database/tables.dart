import 'package:drift/drift.dart';
import '../../core/models/models.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get providerType => textEnum<ProviderType>()();
  TextColumn get displayName => text().withLength(min: 1, max: 100)();
  TextColumn get baseUrl => text().withLength(max: 500)();
  TextColumn get apiKeyAlias => text().withLength(max: 20).nullable()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get proxyEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class BalanceSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  RealColumn get totalBalance => real().nullable()();
  RealColumn get usedBalance => real().nullable()();
  RealColumn get remainingBalance => real().nullable()();
  RealColumn get grantedBalance => real().nullable()();
  RealColumn get toppedUpBalance => real().nullable()();
  TextColumn get currency => text()();
  BoolColumn get isAvailable => boolean().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get source => text().withLength(max: 50)();
}

class UsageLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  TextColumn get providerType => textEnum<ProviderType>()();
  TextColumn get modelName => text().withLength(max: 200)();
  DateTimeColumn get requestTime => dateTime()();
  IntColumn get promptTokens => integer().nullable()();
  IntColumn get completionTokens => integer().nullable()();
  IntColumn get cachedTokens => integer().nullable()();
  IntColumn get reasoningTokens => integer().nullable()();
  IntColumn get totalTokens => integer().nullable()();
  BoolColumn get estimated => boolean().withDefault(const Constant(false))();
  BoolColumn get lowConfidence =>
      boolean().withDefault(const Constant(false))();
  TextColumn get estimatorName => text().nullable()();
  RealColumn get cost => real().nullable()();
  TextColumn get currency => text()();
  IntColumn get statusCode => integer().nullable()();
  TextColumn get requestStatus => textEnum<RequestStatus>()();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get source => textEnum<UsageSource>()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ModelPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get providerType => textEnum<ProviderType>()();
  TextColumn get modelName => text().withLength(max: 200)();
  RealColumn get inputPricePer1M => real()();
  RealColumn get outputPricePer1M => real()();
  RealColumn get cachedInputPricePer1M => real().nullable()();
  RealColumn get reasoningOutputPricePer1M => real().nullable()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  DateTimeColumn get effectiveFrom => dateTime().nullable()();
  DateTimeColumn get effectiveTo => dateTime().nullable()();
  TextColumn get sourceNote => text().nullable()();
  BoolColumn get userEditable => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {providerType, modelName},
  ];
}

class AlertRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get alertType => text().withLength(max: 50)();
  RealColumn get threshold => real()();
  TextColumn get providerType => textEnum<ProviderType>().nullable()();
  IntColumn get accountId => integer().references(Accounts, #id).nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class AppSettings extends Table {
  TextColumn get key => text().withLength(max: 100).unique()();
  TextColumn get value => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class ProviderCapabilities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get providerType => textEnum<ProviderType>().unique()();
  BoolColumn get supportsBalanceQuery =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get supportsModelList =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get supportsUsageParsing =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get supportsStreaming =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get requiresManualQuota =>
      boolean().withDefault(const Constant(false))();
  TextColumn get baseUrlTemplate => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class SchemaMigrationLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fromVersion => integer()();
  IntColumn get toVersion => integer()();
  DateTimeColumn get migratedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get success => boolean()();
  TextColumn get errorMessage => text().nullable()();
}

class ProxyRuntimeLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventType => textEnum<ProxyRuntimeEventType>()();
  TextColumn get previousState => textEnum<ProxyState>().nullable()();
  TextColumn get nextState => textEnum<ProxyState>().nullable()();
  TextColumn get scheme => text().nullable()();
  TextColumn get host => text().nullable()();
  IntColumn get port => integer().nullable()();
  TextColumn get message => text().nullable()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
