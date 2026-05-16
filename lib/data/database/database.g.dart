// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _providerTypeMeta = const VerificationMeta(
    'providerType',
  );
  @override
  late final GeneratedColumn<String> providerType = GeneratedColumn<String>(
    'provider_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseUrlMeta = const VerificationMeta(
    'baseUrl',
  );
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
    'base_url',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apiKeyAliasMeta = const VerificationMeta(
    'apiKeyAlias',
  );
  @override
  late final GeneratedColumn<String> apiKeyAlias = GeneratedColumn<String>(
    'api_key_alias',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _proxyEnabledMeta = const VerificationMeta(
    'proxyEnabled',
  );
  @override
  late final GeneratedColumn<bool> proxyEnabled = GeneratedColumn<bool>(
    'proxy_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("proxy_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    providerType,
    displayName,
    baseUrl,
    apiKeyAlias,
    currency,
    enabled,
    proxyEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('provider_type')) {
      context.handle(
        _providerTypeMeta,
        providerType.isAcceptableOrUnknown(
          data['provider_type']!,
          _providerTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerTypeMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(
        _baseUrlMeta,
        baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('api_key_alias')) {
      context.handle(
        _apiKeyAliasMeta,
        apiKeyAlias.isAcceptableOrUnknown(
          data['api_key_alias']!,
          _apiKeyAliasMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('proxy_enabled')) {
      context.handle(
        _proxyEnabledMeta,
        proxyEnabled.isAcceptableOrUnknown(
          data['proxy_enabled']!,
          _proxyEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      providerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_type'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      baseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url'],
      )!,
      apiKeyAlias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}api_key_alias'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      proxyEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}proxy_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String providerType;
  final String displayName;
  final String baseUrl;
  final String? apiKeyAlias;
  final String currency;
  final bool enabled;
  final bool proxyEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Account({
    required this.id,
    required this.providerType,
    required this.displayName,
    required this.baseUrl,
    this.apiKeyAlias,
    required this.currency,
    required this.enabled,
    required this.proxyEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['provider_type'] = Variable<String>(providerType);
    map['display_name'] = Variable<String>(displayName);
    map['base_url'] = Variable<String>(baseUrl);
    if (!nullToAbsent || apiKeyAlias != null) {
      map['api_key_alias'] = Variable<String>(apiKeyAlias);
    }
    map['currency'] = Variable<String>(currency);
    map['enabled'] = Variable<bool>(enabled);
    map['proxy_enabled'] = Variable<bool>(proxyEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      providerType: Value(providerType),
      displayName: Value(displayName),
      baseUrl: Value(baseUrl),
      apiKeyAlias: apiKeyAlias == null && nullToAbsent
          ? const Value.absent()
          : Value(apiKeyAlias),
      currency: Value(currency),
      enabled: Value(enabled),
      proxyEnabled: Value(proxyEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      providerType: serializer.fromJson<String>(json['providerType']),
      displayName: serializer.fromJson<String>(json['displayName']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      apiKeyAlias: serializer.fromJson<String?>(json['apiKeyAlias']),
      currency: serializer.fromJson<String>(json['currency']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      proxyEnabled: serializer.fromJson<bool>(json['proxyEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'providerType': serializer.toJson<String>(providerType),
      'displayName': serializer.toJson<String>(displayName),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'apiKeyAlias': serializer.toJson<String?>(apiKeyAlias),
      'currency': serializer.toJson<String>(currency),
      'enabled': serializer.toJson<bool>(enabled),
      'proxyEnabled': serializer.toJson<bool>(proxyEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Account copyWith({
    int? id,
    String? providerType,
    String? displayName,
    String? baseUrl,
    Value<String?> apiKeyAlias = const Value.absent(),
    String? currency,
    bool? enabled,
    bool? proxyEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Account(
    id: id ?? this.id,
    providerType: providerType ?? this.providerType,
    displayName: displayName ?? this.displayName,
    baseUrl: baseUrl ?? this.baseUrl,
    apiKeyAlias: apiKeyAlias.present ? apiKeyAlias.value : this.apiKeyAlias,
    currency: currency ?? this.currency,
    enabled: enabled ?? this.enabled,
    proxyEnabled: proxyEnabled ?? this.proxyEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      providerType: data.providerType.present
          ? data.providerType.value
          : this.providerType,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      apiKeyAlias: data.apiKeyAlias.present
          ? data.apiKeyAlias.value
          : this.apiKeyAlias,
      currency: data.currency.present ? data.currency.value : this.currency,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      proxyEnabled: data.proxyEnabled.present
          ? data.proxyEnabled.value
          : this.proxyEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('providerType: $providerType, ')
          ..write('displayName: $displayName, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('apiKeyAlias: $apiKeyAlias, ')
          ..write('currency: $currency, ')
          ..write('enabled: $enabled, ')
          ..write('proxyEnabled: $proxyEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    providerType,
    displayName,
    baseUrl,
    apiKeyAlias,
    currency,
    enabled,
    proxyEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.providerType == this.providerType &&
          other.displayName == this.displayName &&
          other.baseUrl == this.baseUrl &&
          other.apiKeyAlias == this.apiKeyAlias &&
          other.currency == this.currency &&
          other.enabled == this.enabled &&
          other.proxyEnabled == this.proxyEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> providerType;
  final Value<String> displayName;
  final Value<String> baseUrl;
  final Value<String?> apiKeyAlias;
  final Value<String> currency;
  final Value<bool> enabled;
  final Value<bool> proxyEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.providerType = const Value.absent(),
    this.displayName = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.apiKeyAlias = const Value.absent(),
    this.currency = const Value.absent(),
    this.enabled = const Value.absent(),
    this.proxyEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String providerType,
    required String displayName,
    required String baseUrl,
    this.apiKeyAlias = const Value.absent(),
    this.currency = const Value.absent(),
    this.enabled = const Value.absent(),
    this.proxyEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : providerType = Value(providerType),
       displayName = Value(displayName),
       baseUrl = Value(baseUrl);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? providerType,
    Expression<String>? displayName,
    Expression<String>? baseUrl,
    Expression<String>? apiKeyAlias,
    Expression<String>? currency,
    Expression<bool>? enabled,
    Expression<bool>? proxyEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (providerType != null) 'provider_type': providerType,
      if (displayName != null) 'display_name': displayName,
      if (baseUrl != null) 'base_url': baseUrl,
      if (apiKeyAlias != null) 'api_key_alias': apiKeyAlias,
      if (currency != null) 'currency': currency,
      if (enabled != null) 'enabled': enabled,
      if (proxyEnabled != null) 'proxy_enabled': proxyEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? providerType,
    Value<String>? displayName,
    Value<String>? baseUrl,
    Value<String?>? apiKeyAlias,
    Value<String>? currency,
    Value<bool>? enabled,
    Value<bool>? proxyEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      providerType: providerType ?? this.providerType,
      displayName: displayName ?? this.displayName,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKeyAlias: apiKeyAlias ?? this.apiKeyAlias,
      currency: currency ?? this.currency,
      enabled: enabled ?? this.enabled,
      proxyEnabled: proxyEnabled ?? this.proxyEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (providerType.present) {
      map['provider_type'] = Variable<String>(providerType.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (apiKeyAlias.present) {
      map['api_key_alias'] = Variable<String>(apiKeyAlias.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (proxyEnabled.present) {
      map['proxy_enabled'] = Variable<bool>(proxyEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('providerType: $providerType, ')
          ..write('displayName: $displayName, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('apiKeyAlias: $apiKeyAlias, ')
          ..write('currency: $currency, ')
          ..write('enabled: $enabled, ')
          ..write('proxyEnabled: $proxyEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BalanceSnapshotsTable extends BalanceSnapshots
    with TableInfo<$BalanceSnapshotsTable, BalanceSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BalanceSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _totalBalanceMeta = const VerificationMeta(
    'totalBalance',
  );
  @override
  late final GeneratedColumn<double> totalBalance = GeneratedColumn<double>(
    'total_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usedBalanceMeta = const VerificationMeta(
    'usedBalance',
  );
  @override
  late final GeneratedColumn<double> usedBalance = GeneratedColumn<double>(
    'used_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remainingBalanceMeta = const VerificationMeta(
    'remainingBalance',
  );
  @override
  late final GeneratedColumn<double> remainingBalance = GeneratedColumn<double>(
    'remaining_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _grantedBalanceMeta = const VerificationMeta(
    'grantedBalance',
  );
  @override
  late final GeneratedColumn<double> grantedBalance = GeneratedColumn<double>(
    'granted_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toppedUpBalanceMeta = const VerificationMeta(
    'toppedUpBalance',
  );
  @override
  late final GeneratedColumn<double> toppedUpBalance = GeneratedColumn<double>(
    'topped_up_balance',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAvailableMeta = const VerificationMeta(
    'isAvailable',
  );
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
    'is_available',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_available" IN (0, 1))',
    ),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    totalBalance,
    usedBalance,
    remainingBalance,
    grantedBalance,
    toppedUpBalance,
    currency,
    isAvailable,
    fetchedAt,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balance_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<BalanceSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('total_balance')) {
      context.handle(
        _totalBalanceMeta,
        totalBalance.isAcceptableOrUnknown(
          data['total_balance']!,
          _totalBalanceMeta,
        ),
      );
    }
    if (data.containsKey('used_balance')) {
      context.handle(
        _usedBalanceMeta,
        usedBalance.isAcceptableOrUnknown(
          data['used_balance']!,
          _usedBalanceMeta,
        ),
      );
    }
    if (data.containsKey('remaining_balance')) {
      context.handle(
        _remainingBalanceMeta,
        remainingBalance.isAcceptableOrUnknown(
          data['remaining_balance']!,
          _remainingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('granted_balance')) {
      context.handle(
        _grantedBalanceMeta,
        grantedBalance.isAcceptableOrUnknown(
          data['granted_balance']!,
          _grantedBalanceMeta,
        ),
      );
    }
    if (data.containsKey('topped_up_balance')) {
      context.handle(
        _toppedUpBalanceMeta,
        toppedUpBalance.isAcceptableOrUnknown(
          data['topped_up_balance']!,
          _toppedUpBalanceMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('is_available')) {
      context.handle(
        _isAvailableMeta,
        isAvailable.isAcceptableOrUnknown(
          data['is_available']!,
          _isAvailableMeta,
        ),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BalanceSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BalanceSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      totalBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_balance'],
      ),
      usedBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}used_balance'],
      ),
      remainingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_balance'],
      ),
      grantedBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}granted_balance'],
      ),
      toppedUpBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}topped_up_balance'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      isAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_available'],
      ),
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $BalanceSnapshotsTable createAlias(String alias) {
    return $BalanceSnapshotsTable(attachedDatabase, alias);
  }
}

class BalanceSnapshot extends DataClass implements Insertable<BalanceSnapshot> {
  final int id;
  final int accountId;
  final double? totalBalance;
  final double? usedBalance;
  final double? remainingBalance;
  final double? grantedBalance;
  final double? toppedUpBalance;
  final String currency;
  final bool? isAvailable;
  final DateTime fetchedAt;
  final String source;
  const BalanceSnapshot({
    required this.id,
    required this.accountId,
    this.totalBalance,
    this.usedBalance,
    this.remainingBalance,
    this.grantedBalance,
    this.toppedUpBalance,
    required this.currency,
    this.isAvailable,
    required this.fetchedAt,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || totalBalance != null) {
      map['total_balance'] = Variable<double>(totalBalance);
    }
    if (!nullToAbsent || usedBalance != null) {
      map['used_balance'] = Variable<double>(usedBalance);
    }
    if (!nullToAbsent || remainingBalance != null) {
      map['remaining_balance'] = Variable<double>(remainingBalance);
    }
    if (!nullToAbsent || grantedBalance != null) {
      map['granted_balance'] = Variable<double>(grantedBalance);
    }
    if (!nullToAbsent || toppedUpBalance != null) {
      map['topped_up_balance'] = Variable<double>(toppedUpBalance);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || isAvailable != null) {
      map['is_available'] = Variable<bool>(isAvailable);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['source'] = Variable<String>(source);
    return map;
  }

  BalanceSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return BalanceSnapshotsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      totalBalance: totalBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(totalBalance),
      usedBalance: usedBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(usedBalance),
      remainingBalance: remainingBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(remainingBalance),
      grantedBalance: grantedBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(grantedBalance),
      toppedUpBalance: toppedUpBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(toppedUpBalance),
      currency: Value(currency),
      isAvailable: isAvailable == null && nullToAbsent
          ? const Value.absent()
          : Value(isAvailable),
      fetchedAt: Value(fetchedAt),
      source: Value(source),
    );
  }

  factory BalanceSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BalanceSnapshot(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      totalBalance: serializer.fromJson<double?>(json['totalBalance']),
      usedBalance: serializer.fromJson<double?>(json['usedBalance']),
      remainingBalance: serializer.fromJson<double?>(json['remainingBalance']),
      grantedBalance: serializer.fromJson<double?>(json['grantedBalance']),
      toppedUpBalance: serializer.fromJson<double?>(json['toppedUpBalance']),
      currency: serializer.fromJson<String>(json['currency']),
      isAvailable: serializer.fromJson<bool?>(json['isAvailable']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'totalBalance': serializer.toJson<double?>(totalBalance),
      'usedBalance': serializer.toJson<double?>(usedBalance),
      'remainingBalance': serializer.toJson<double?>(remainingBalance),
      'grantedBalance': serializer.toJson<double?>(grantedBalance),
      'toppedUpBalance': serializer.toJson<double?>(toppedUpBalance),
      'currency': serializer.toJson<String>(currency),
      'isAvailable': serializer.toJson<bool?>(isAvailable),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'source': serializer.toJson<String>(source),
    };
  }

  BalanceSnapshot copyWith({
    int? id,
    int? accountId,
    Value<double?> totalBalance = const Value.absent(),
    Value<double?> usedBalance = const Value.absent(),
    Value<double?> remainingBalance = const Value.absent(),
    Value<double?> grantedBalance = const Value.absent(),
    Value<double?> toppedUpBalance = const Value.absent(),
    String? currency,
    Value<bool?> isAvailable = const Value.absent(),
    DateTime? fetchedAt,
    String? source,
  }) => BalanceSnapshot(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    totalBalance: totalBalance.present ? totalBalance.value : this.totalBalance,
    usedBalance: usedBalance.present ? usedBalance.value : this.usedBalance,
    remainingBalance: remainingBalance.present
        ? remainingBalance.value
        : this.remainingBalance,
    grantedBalance: grantedBalance.present
        ? grantedBalance.value
        : this.grantedBalance,
    toppedUpBalance: toppedUpBalance.present
        ? toppedUpBalance.value
        : this.toppedUpBalance,
    currency: currency ?? this.currency,
    isAvailable: isAvailable.present ? isAvailable.value : this.isAvailable,
    fetchedAt: fetchedAt ?? this.fetchedAt,
    source: source ?? this.source,
  );
  BalanceSnapshot copyWithCompanion(BalanceSnapshotsCompanion data) {
    return BalanceSnapshot(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      totalBalance: data.totalBalance.present
          ? data.totalBalance.value
          : this.totalBalance,
      usedBalance: data.usedBalance.present
          ? data.usedBalance.value
          : this.usedBalance,
      remainingBalance: data.remainingBalance.present
          ? data.remainingBalance.value
          : this.remainingBalance,
      grantedBalance: data.grantedBalance.present
          ? data.grantedBalance.value
          : this.grantedBalance,
      toppedUpBalance: data.toppedUpBalance.present
          ? data.toppedUpBalance.value
          : this.toppedUpBalance,
      currency: data.currency.present ? data.currency.value : this.currency,
      isAvailable: data.isAvailable.present
          ? data.isAvailable.value
          : this.isAvailable,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BalanceSnapshot(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('totalBalance: $totalBalance, ')
          ..write('usedBalance: $usedBalance, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('grantedBalance: $grantedBalance, ')
          ..write('toppedUpBalance: $toppedUpBalance, ')
          ..write('currency: $currency, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    totalBalance,
    usedBalance,
    remainingBalance,
    grantedBalance,
    toppedUpBalance,
    currency,
    isAvailable,
    fetchedAt,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BalanceSnapshot &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.totalBalance == this.totalBalance &&
          other.usedBalance == this.usedBalance &&
          other.remainingBalance == this.remainingBalance &&
          other.grantedBalance == this.grantedBalance &&
          other.toppedUpBalance == this.toppedUpBalance &&
          other.currency == this.currency &&
          other.isAvailable == this.isAvailable &&
          other.fetchedAt == this.fetchedAt &&
          other.source == this.source);
}

class BalanceSnapshotsCompanion extends UpdateCompanion<BalanceSnapshot> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<double?> totalBalance;
  final Value<double?> usedBalance;
  final Value<double?> remainingBalance;
  final Value<double?> grantedBalance;
  final Value<double?> toppedUpBalance;
  final Value<String> currency;
  final Value<bool?> isAvailable;
  final Value<DateTime> fetchedAt;
  final Value<String> source;
  const BalanceSnapshotsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.totalBalance = const Value.absent(),
    this.usedBalance = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.grantedBalance = const Value.absent(),
    this.toppedUpBalance = const Value.absent(),
    this.currency = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.source = const Value.absent(),
  });
  BalanceSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    this.totalBalance = const Value.absent(),
    this.usedBalance = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.grantedBalance = const Value.absent(),
    this.toppedUpBalance = const Value.absent(),
    required String currency,
    this.isAvailable = const Value.absent(),
    required DateTime fetchedAt,
    required String source,
  }) : accountId = Value(accountId),
       currency = Value(currency),
       fetchedAt = Value(fetchedAt),
       source = Value(source);
  static Insertable<BalanceSnapshot> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<double>? totalBalance,
    Expression<double>? usedBalance,
    Expression<double>? remainingBalance,
    Expression<double>? grantedBalance,
    Expression<double>? toppedUpBalance,
    Expression<String>? currency,
    Expression<bool>? isAvailable,
    Expression<DateTime>? fetchedAt,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (totalBalance != null) 'total_balance': totalBalance,
      if (usedBalance != null) 'used_balance': usedBalance,
      if (remainingBalance != null) 'remaining_balance': remainingBalance,
      if (grantedBalance != null) 'granted_balance': grantedBalance,
      if (toppedUpBalance != null) 'topped_up_balance': toppedUpBalance,
      if (currency != null) 'currency': currency,
      if (isAvailable != null) 'is_available': isAvailable,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (source != null) 'source': source,
    });
  }

  BalanceSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<double?>? totalBalance,
    Value<double?>? usedBalance,
    Value<double?>? remainingBalance,
    Value<double?>? grantedBalance,
    Value<double?>? toppedUpBalance,
    Value<String>? currency,
    Value<bool?>? isAvailable,
    Value<DateTime>? fetchedAt,
    Value<String>? source,
  }) {
    return BalanceSnapshotsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      totalBalance: totalBalance ?? this.totalBalance,
      usedBalance: usedBalance ?? this.usedBalance,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      grantedBalance: grantedBalance ?? this.grantedBalance,
      toppedUpBalance: toppedUpBalance ?? this.toppedUpBalance,
      currency: currency ?? this.currency,
      isAvailable: isAvailable ?? this.isAvailable,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (totalBalance.present) {
      map['total_balance'] = Variable<double>(totalBalance.value);
    }
    if (usedBalance.present) {
      map['used_balance'] = Variable<double>(usedBalance.value);
    }
    if (remainingBalance.present) {
      map['remaining_balance'] = Variable<double>(remainingBalance.value);
    }
    if (grantedBalance.present) {
      map['granted_balance'] = Variable<double>(grantedBalance.value);
    }
    if (toppedUpBalance.present) {
      map['topped_up_balance'] = Variable<double>(toppedUpBalance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalanceSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('totalBalance: $totalBalance, ')
          ..write('usedBalance: $usedBalance, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('grantedBalance: $grantedBalance, ')
          ..write('toppedUpBalance: $toppedUpBalance, ')
          ..write('currency: $currency, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $UsageLogsTable extends UsageLogs
    with TableInfo<$UsageLogsTable, UsageLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _providerTypeMeta = const VerificationMeta(
    'providerType',
  );
  @override
  late final GeneratedColumn<String> providerType = GeneratedColumn<String>(
    'provider_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelNameMeta = const VerificationMeta(
    'modelName',
  );
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
    'model_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requestTimeMeta = const VerificationMeta(
    'requestTime',
  );
  @override
  late final GeneratedColumn<DateTime> requestTime = GeneratedColumn<DateTime>(
    'request_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptTokensMeta = const VerificationMeta(
    'promptTokens',
  );
  @override
  late final GeneratedColumn<int> promptTokens = GeneratedColumn<int>(
    'prompt_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completionTokensMeta = const VerificationMeta(
    'completionTokens',
  );
  @override
  late final GeneratedColumn<int> completionTokens = GeneratedColumn<int>(
    'completion_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedTokensMeta = const VerificationMeta(
    'cachedTokens',
  );
  @override
  late final GeneratedColumn<int> cachedTokens = GeneratedColumn<int>(
    'cached_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasoningTokensMeta = const VerificationMeta(
    'reasoningTokens',
  );
  @override
  late final GeneratedColumn<int> reasoningTokens = GeneratedColumn<int>(
    'reasoning_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalTokensMeta = const VerificationMeta(
    'totalTokens',
  );
  @override
  late final GeneratedColumn<int> totalTokens = GeneratedColumn<int>(
    'total_tokens',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedMeta = const VerificationMeta(
    'estimated',
  );
  @override
  late final GeneratedColumn<bool> estimated = GeneratedColumn<bool>(
    'estimated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("estimated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lowConfidenceMeta = const VerificationMeta(
    'lowConfidence',
  );
  @override
  late final GeneratedColumn<bool> lowConfidence = GeneratedColumn<bool>(
    'low_confidence',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("low_confidence" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _estimatorNameMeta = const VerificationMeta(
    'estimatorName',
  );
  @override
  late final GeneratedColumn<String> estimatorName = GeneratedColumn<String>(
    'estimator_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusCodeMeta = const VerificationMeta(
    'statusCode',
  );
  @override
  late final GeneratedColumn<int> statusCode = GeneratedColumn<int>(
    'status_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requestStatusMeta = const VerificationMeta(
    'requestStatus',
  );
  @override
  late final GeneratedColumn<String> requestStatus = GeneratedColumn<String>(
    'request_status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    providerType,
    modelName,
    requestTime,
    promptTokens,
    completionTokens,
    cachedTokens,
    reasoningTokens,
    totalTokens,
    estimated,
    lowConfidence,
    estimatorName,
    cost,
    currency,
    statusCode,
    requestStatus,
    errorMessage,
    source,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('provider_type')) {
      context.handle(
        _providerTypeMeta,
        providerType.isAcceptableOrUnknown(
          data['provider_type']!,
          _providerTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerTypeMeta);
    }
    if (data.containsKey('model_name')) {
      context.handle(
        _modelNameMeta,
        modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta),
      );
    } else if (isInserting) {
      context.missing(_modelNameMeta);
    }
    if (data.containsKey('request_time')) {
      context.handle(
        _requestTimeMeta,
        requestTime.isAcceptableOrUnknown(
          data['request_time']!,
          _requestTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestTimeMeta);
    }
    if (data.containsKey('prompt_tokens')) {
      context.handle(
        _promptTokensMeta,
        promptTokens.isAcceptableOrUnknown(
          data['prompt_tokens']!,
          _promptTokensMeta,
        ),
      );
    }
    if (data.containsKey('completion_tokens')) {
      context.handle(
        _completionTokensMeta,
        completionTokens.isAcceptableOrUnknown(
          data['completion_tokens']!,
          _completionTokensMeta,
        ),
      );
    }
    if (data.containsKey('cached_tokens')) {
      context.handle(
        _cachedTokensMeta,
        cachedTokens.isAcceptableOrUnknown(
          data['cached_tokens']!,
          _cachedTokensMeta,
        ),
      );
    }
    if (data.containsKey('reasoning_tokens')) {
      context.handle(
        _reasoningTokensMeta,
        reasoningTokens.isAcceptableOrUnknown(
          data['reasoning_tokens']!,
          _reasoningTokensMeta,
        ),
      );
    }
    if (data.containsKey('total_tokens')) {
      context.handle(
        _totalTokensMeta,
        totalTokens.isAcceptableOrUnknown(
          data['total_tokens']!,
          _totalTokensMeta,
        ),
      );
    }
    if (data.containsKey('estimated')) {
      context.handle(
        _estimatedMeta,
        estimated.isAcceptableOrUnknown(data['estimated']!, _estimatedMeta),
      );
    }
    if (data.containsKey('low_confidence')) {
      context.handle(
        _lowConfidenceMeta,
        lowConfidence.isAcceptableOrUnknown(
          data['low_confidence']!,
          _lowConfidenceMeta,
        ),
      );
    }
    if (data.containsKey('estimator_name')) {
      context.handle(
        _estimatorNameMeta,
        estimatorName.isAcceptableOrUnknown(
          data['estimator_name']!,
          _estimatorNameMeta,
        ),
      );
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('status_code')) {
      context.handle(
        _statusCodeMeta,
        statusCode.isAcceptableOrUnknown(data['status_code']!, _statusCodeMeta),
      );
    }
    if (data.containsKey('request_status')) {
      context.handle(
        _requestStatusMeta,
        requestStatus.isAcceptableOrUnknown(
          data['request_status']!,
          _requestStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requestStatusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      providerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_type'],
      )!,
      modelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_name'],
      )!,
      requestTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}request_time'],
      )!,
      promptTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prompt_tokens'],
      ),
      completionTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completion_tokens'],
      ),
      cachedTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cached_tokens'],
      ),
      reasoningTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reasoning_tokens'],
      ),
      totalTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_tokens'],
      ),
      estimated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}estimated'],
      )!,
      lowConfidence: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}low_confidence'],
      )!,
      estimatorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estimator_name'],
      ),
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      statusCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_code'],
      ),
      requestStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UsageLogsTable createAlias(String alias) {
    return $UsageLogsTable(attachedDatabase, alias);
  }
}

class UsageLog extends DataClass implements Insertable<UsageLog> {
  final int id;
  final int accountId;
  final String providerType;
  final String modelName;
  final DateTime requestTime;
  final int? promptTokens;
  final int? completionTokens;
  final int? cachedTokens;
  final int? reasoningTokens;
  final int? totalTokens;
  final bool estimated;
  final bool lowConfidence;
  final String? estimatorName;
  final double? cost;
  final String currency;
  final int? statusCode;
  final String requestStatus;
  final String? errorMessage;
  final String source;
  final DateTime createdAt;
  const UsageLog({
    required this.id,
    required this.accountId,
    required this.providerType,
    required this.modelName,
    required this.requestTime,
    this.promptTokens,
    this.completionTokens,
    this.cachedTokens,
    this.reasoningTokens,
    this.totalTokens,
    required this.estimated,
    required this.lowConfidence,
    this.estimatorName,
    this.cost,
    required this.currency,
    this.statusCode,
    required this.requestStatus,
    this.errorMessage,
    required this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['provider_type'] = Variable<String>(providerType);
    map['model_name'] = Variable<String>(modelName);
    map['request_time'] = Variable<DateTime>(requestTime);
    if (!nullToAbsent || promptTokens != null) {
      map['prompt_tokens'] = Variable<int>(promptTokens);
    }
    if (!nullToAbsent || completionTokens != null) {
      map['completion_tokens'] = Variable<int>(completionTokens);
    }
    if (!nullToAbsent || cachedTokens != null) {
      map['cached_tokens'] = Variable<int>(cachedTokens);
    }
    if (!nullToAbsent || reasoningTokens != null) {
      map['reasoning_tokens'] = Variable<int>(reasoningTokens);
    }
    if (!nullToAbsent || totalTokens != null) {
      map['total_tokens'] = Variable<int>(totalTokens);
    }
    map['estimated'] = Variable<bool>(estimated);
    map['low_confidence'] = Variable<bool>(lowConfidence);
    if (!nullToAbsent || estimatorName != null) {
      map['estimator_name'] = Variable<String>(estimatorName);
    }
    if (!nullToAbsent || cost != null) {
      map['cost'] = Variable<double>(cost);
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || statusCode != null) {
      map['status_code'] = Variable<int>(statusCode);
    }
    map['request_status'] = Variable<String>(requestStatus);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsageLogsCompanion toCompanion(bool nullToAbsent) {
    return UsageLogsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      providerType: Value(providerType),
      modelName: Value(modelName),
      requestTime: Value(requestTime),
      promptTokens: promptTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(promptTokens),
      completionTokens: completionTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(completionTokens),
      cachedTokens: cachedTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedTokens),
      reasoningTokens: reasoningTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(reasoningTokens),
      totalTokens: totalTokens == null && nullToAbsent
          ? const Value.absent()
          : Value(totalTokens),
      estimated: Value(estimated),
      lowConfidence: Value(lowConfidence),
      estimatorName: estimatorName == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatorName),
      cost: cost == null && nullToAbsent ? const Value.absent() : Value(cost),
      currency: Value(currency),
      statusCode: statusCode == null && nullToAbsent
          ? const Value.absent()
          : Value(statusCode),
      requestStatus: Value(requestStatus),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      source: Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory UsageLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageLog(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      providerType: serializer.fromJson<String>(json['providerType']),
      modelName: serializer.fromJson<String>(json['modelName']),
      requestTime: serializer.fromJson<DateTime>(json['requestTime']),
      promptTokens: serializer.fromJson<int?>(json['promptTokens']),
      completionTokens: serializer.fromJson<int?>(json['completionTokens']),
      cachedTokens: serializer.fromJson<int?>(json['cachedTokens']),
      reasoningTokens: serializer.fromJson<int?>(json['reasoningTokens']),
      totalTokens: serializer.fromJson<int?>(json['totalTokens']),
      estimated: serializer.fromJson<bool>(json['estimated']),
      lowConfidence: serializer.fromJson<bool>(json['lowConfidence']),
      estimatorName: serializer.fromJson<String?>(json['estimatorName']),
      cost: serializer.fromJson<double?>(json['cost']),
      currency: serializer.fromJson<String>(json['currency']),
      statusCode: serializer.fromJson<int?>(json['statusCode']),
      requestStatus: serializer.fromJson<String>(json['requestStatus']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'providerType': serializer.toJson<String>(providerType),
      'modelName': serializer.toJson<String>(modelName),
      'requestTime': serializer.toJson<DateTime>(requestTime),
      'promptTokens': serializer.toJson<int?>(promptTokens),
      'completionTokens': serializer.toJson<int?>(completionTokens),
      'cachedTokens': serializer.toJson<int?>(cachedTokens),
      'reasoningTokens': serializer.toJson<int?>(reasoningTokens),
      'totalTokens': serializer.toJson<int?>(totalTokens),
      'estimated': serializer.toJson<bool>(estimated),
      'lowConfidence': serializer.toJson<bool>(lowConfidence),
      'estimatorName': serializer.toJson<String?>(estimatorName),
      'cost': serializer.toJson<double?>(cost),
      'currency': serializer.toJson<String>(currency),
      'statusCode': serializer.toJson<int?>(statusCode),
      'requestStatus': serializer.toJson<String>(requestStatus),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UsageLog copyWith({
    int? id,
    int? accountId,
    String? providerType,
    String? modelName,
    DateTime? requestTime,
    Value<int?> promptTokens = const Value.absent(),
    Value<int?> completionTokens = const Value.absent(),
    Value<int?> cachedTokens = const Value.absent(),
    Value<int?> reasoningTokens = const Value.absent(),
    Value<int?> totalTokens = const Value.absent(),
    bool? estimated,
    bool? lowConfidence,
    Value<String?> estimatorName = const Value.absent(),
    Value<double?> cost = const Value.absent(),
    String? currency,
    Value<int?> statusCode = const Value.absent(),
    String? requestStatus,
    Value<String?> errorMessage = const Value.absent(),
    String? source,
    DateTime? createdAt,
  }) => UsageLog(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    providerType: providerType ?? this.providerType,
    modelName: modelName ?? this.modelName,
    requestTime: requestTime ?? this.requestTime,
    promptTokens: promptTokens.present ? promptTokens.value : this.promptTokens,
    completionTokens: completionTokens.present
        ? completionTokens.value
        : this.completionTokens,
    cachedTokens: cachedTokens.present ? cachedTokens.value : this.cachedTokens,
    reasoningTokens: reasoningTokens.present
        ? reasoningTokens.value
        : this.reasoningTokens,
    totalTokens: totalTokens.present ? totalTokens.value : this.totalTokens,
    estimated: estimated ?? this.estimated,
    lowConfidence: lowConfidence ?? this.lowConfidence,
    estimatorName: estimatorName.present
        ? estimatorName.value
        : this.estimatorName,
    cost: cost.present ? cost.value : this.cost,
    currency: currency ?? this.currency,
    statusCode: statusCode.present ? statusCode.value : this.statusCode,
    requestStatus: requestStatus ?? this.requestStatus,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  UsageLog copyWithCompanion(UsageLogsCompanion data) {
    return UsageLog(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      providerType: data.providerType.present
          ? data.providerType.value
          : this.providerType,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      requestTime: data.requestTime.present
          ? data.requestTime.value
          : this.requestTime,
      promptTokens: data.promptTokens.present
          ? data.promptTokens.value
          : this.promptTokens,
      completionTokens: data.completionTokens.present
          ? data.completionTokens.value
          : this.completionTokens,
      cachedTokens: data.cachedTokens.present
          ? data.cachedTokens.value
          : this.cachedTokens,
      reasoningTokens: data.reasoningTokens.present
          ? data.reasoningTokens.value
          : this.reasoningTokens,
      totalTokens: data.totalTokens.present
          ? data.totalTokens.value
          : this.totalTokens,
      estimated: data.estimated.present ? data.estimated.value : this.estimated,
      lowConfidence: data.lowConfidence.present
          ? data.lowConfidence.value
          : this.lowConfidence,
      estimatorName: data.estimatorName.present
          ? data.estimatorName.value
          : this.estimatorName,
      cost: data.cost.present ? data.cost.value : this.cost,
      currency: data.currency.present ? data.currency.value : this.currency,
      statusCode: data.statusCode.present
          ? data.statusCode.value
          : this.statusCode,
      requestStatus: data.requestStatus.present
          ? data.requestStatus.value
          : this.requestStatus,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageLog(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('providerType: $providerType, ')
          ..write('modelName: $modelName, ')
          ..write('requestTime: $requestTime, ')
          ..write('promptTokens: $promptTokens, ')
          ..write('completionTokens: $completionTokens, ')
          ..write('cachedTokens: $cachedTokens, ')
          ..write('reasoningTokens: $reasoningTokens, ')
          ..write('totalTokens: $totalTokens, ')
          ..write('estimated: $estimated, ')
          ..write('lowConfidence: $lowConfidence, ')
          ..write('estimatorName: $estimatorName, ')
          ..write('cost: $cost, ')
          ..write('currency: $currency, ')
          ..write('statusCode: $statusCode, ')
          ..write('requestStatus: $requestStatus, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    providerType,
    modelName,
    requestTime,
    promptTokens,
    completionTokens,
    cachedTokens,
    reasoningTokens,
    totalTokens,
    estimated,
    lowConfidence,
    estimatorName,
    cost,
    currency,
    statusCode,
    requestStatus,
    errorMessage,
    source,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageLog &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.providerType == this.providerType &&
          other.modelName == this.modelName &&
          other.requestTime == this.requestTime &&
          other.promptTokens == this.promptTokens &&
          other.completionTokens == this.completionTokens &&
          other.cachedTokens == this.cachedTokens &&
          other.reasoningTokens == this.reasoningTokens &&
          other.totalTokens == this.totalTokens &&
          other.estimated == this.estimated &&
          other.lowConfidence == this.lowConfidence &&
          other.estimatorName == this.estimatorName &&
          other.cost == this.cost &&
          other.currency == this.currency &&
          other.statusCode == this.statusCode &&
          other.requestStatus == this.requestStatus &&
          other.errorMessage == this.errorMessage &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class UsageLogsCompanion extends UpdateCompanion<UsageLog> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<String> providerType;
  final Value<String> modelName;
  final Value<DateTime> requestTime;
  final Value<int?> promptTokens;
  final Value<int?> completionTokens;
  final Value<int?> cachedTokens;
  final Value<int?> reasoningTokens;
  final Value<int?> totalTokens;
  final Value<bool> estimated;
  final Value<bool> lowConfidence;
  final Value<String?> estimatorName;
  final Value<double?> cost;
  final Value<String> currency;
  final Value<int?> statusCode;
  final Value<String> requestStatus;
  final Value<String?> errorMessage;
  final Value<String> source;
  final Value<DateTime> createdAt;
  const UsageLogsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.providerType = const Value.absent(),
    this.modelName = const Value.absent(),
    this.requestTime = const Value.absent(),
    this.promptTokens = const Value.absent(),
    this.completionTokens = const Value.absent(),
    this.cachedTokens = const Value.absent(),
    this.reasoningTokens = const Value.absent(),
    this.totalTokens = const Value.absent(),
    this.estimated = const Value.absent(),
    this.lowConfidence = const Value.absent(),
    this.estimatorName = const Value.absent(),
    this.cost = const Value.absent(),
    this.currency = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.requestStatus = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UsageLogsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required String providerType,
    required String modelName,
    required DateTime requestTime,
    this.promptTokens = const Value.absent(),
    this.completionTokens = const Value.absent(),
    this.cachedTokens = const Value.absent(),
    this.reasoningTokens = const Value.absent(),
    this.totalTokens = const Value.absent(),
    this.estimated = const Value.absent(),
    this.lowConfidence = const Value.absent(),
    this.estimatorName = const Value.absent(),
    this.cost = const Value.absent(),
    required String currency,
    this.statusCode = const Value.absent(),
    required String requestStatus,
    this.errorMessage = const Value.absent(),
    required String source,
    this.createdAt = const Value.absent(),
  }) : accountId = Value(accountId),
       providerType = Value(providerType),
       modelName = Value(modelName),
       requestTime = Value(requestTime),
       currency = Value(currency),
       requestStatus = Value(requestStatus),
       source = Value(source);
  static Insertable<UsageLog> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<String>? providerType,
    Expression<String>? modelName,
    Expression<DateTime>? requestTime,
    Expression<int>? promptTokens,
    Expression<int>? completionTokens,
    Expression<int>? cachedTokens,
    Expression<int>? reasoningTokens,
    Expression<int>? totalTokens,
    Expression<bool>? estimated,
    Expression<bool>? lowConfidence,
    Expression<String>? estimatorName,
    Expression<double>? cost,
    Expression<String>? currency,
    Expression<int>? statusCode,
    Expression<String>? requestStatus,
    Expression<String>? errorMessage,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (providerType != null) 'provider_type': providerType,
      if (modelName != null) 'model_name': modelName,
      if (requestTime != null) 'request_time': requestTime,
      if (promptTokens != null) 'prompt_tokens': promptTokens,
      if (completionTokens != null) 'completion_tokens': completionTokens,
      if (cachedTokens != null) 'cached_tokens': cachedTokens,
      if (reasoningTokens != null) 'reasoning_tokens': reasoningTokens,
      if (totalTokens != null) 'total_tokens': totalTokens,
      if (estimated != null) 'estimated': estimated,
      if (lowConfidence != null) 'low_confidence': lowConfidence,
      if (estimatorName != null) 'estimator_name': estimatorName,
      if (cost != null) 'cost': cost,
      if (currency != null) 'currency': currency,
      if (statusCode != null) 'status_code': statusCode,
      if (requestStatus != null) 'request_status': requestStatus,
      if (errorMessage != null) 'error_message': errorMessage,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UsageLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<String>? providerType,
    Value<String>? modelName,
    Value<DateTime>? requestTime,
    Value<int?>? promptTokens,
    Value<int?>? completionTokens,
    Value<int?>? cachedTokens,
    Value<int?>? reasoningTokens,
    Value<int?>? totalTokens,
    Value<bool>? estimated,
    Value<bool>? lowConfidence,
    Value<String?>? estimatorName,
    Value<double?>? cost,
    Value<String>? currency,
    Value<int?>? statusCode,
    Value<String>? requestStatus,
    Value<String?>? errorMessage,
    Value<String>? source,
    Value<DateTime>? createdAt,
  }) {
    return UsageLogsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      providerType: providerType ?? this.providerType,
      modelName: modelName ?? this.modelName,
      requestTime: requestTime ?? this.requestTime,
      promptTokens: promptTokens ?? this.promptTokens,
      completionTokens: completionTokens ?? this.completionTokens,
      cachedTokens: cachedTokens ?? this.cachedTokens,
      reasoningTokens: reasoningTokens ?? this.reasoningTokens,
      totalTokens: totalTokens ?? this.totalTokens,
      estimated: estimated ?? this.estimated,
      lowConfidence: lowConfidence ?? this.lowConfidence,
      estimatorName: estimatorName ?? this.estimatorName,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      statusCode: statusCode ?? this.statusCode,
      requestStatus: requestStatus ?? this.requestStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (providerType.present) {
      map['provider_type'] = Variable<String>(providerType.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (requestTime.present) {
      map['request_time'] = Variable<DateTime>(requestTime.value);
    }
    if (promptTokens.present) {
      map['prompt_tokens'] = Variable<int>(promptTokens.value);
    }
    if (completionTokens.present) {
      map['completion_tokens'] = Variable<int>(completionTokens.value);
    }
    if (cachedTokens.present) {
      map['cached_tokens'] = Variable<int>(cachedTokens.value);
    }
    if (reasoningTokens.present) {
      map['reasoning_tokens'] = Variable<int>(reasoningTokens.value);
    }
    if (totalTokens.present) {
      map['total_tokens'] = Variable<int>(totalTokens.value);
    }
    if (estimated.present) {
      map['estimated'] = Variable<bool>(estimated.value);
    }
    if (lowConfidence.present) {
      map['low_confidence'] = Variable<bool>(lowConfidence.value);
    }
    if (estimatorName.present) {
      map['estimator_name'] = Variable<String>(estimatorName.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (statusCode.present) {
      map['status_code'] = Variable<int>(statusCode.value);
    }
    if (requestStatus.present) {
      map['request_status'] = Variable<String>(requestStatus.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageLogsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('providerType: $providerType, ')
          ..write('modelName: $modelName, ')
          ..write('requestTime: $requestTime, ')
          ..write('promptTokens: $promptTokens, ')
          ..write('completionTokens: $completionTokens, ')
          ..write('cachedTokens: $cachedTokens, ')
          ..write('reasoningTokens: $reasoningTokens, ')
          ..write('totalTokens: $totalTokens, ')
          ..write('estimated: $estimated, ')
          ..write('lowConfidence: $lowConfidence, ')
          ..write('estimatorName: $estimatorName, ')
          ..write('cost: $cost, ')
          ..write('currency: $currency, ')
          ..write('statusCode: $statusCode, ')
          ..write('requestStatus: $requestStatus, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ModelPricesTable extends ModelPrices
    with TableInfo<$ModelPricesTable, ModelPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _providerTypeMeta = const VerificationMeta(
    'providerType',
  );
  @override
  late final GeneratedColumn<String> providerType = GeneratedColumn<String>(
    'provider_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelNameMeta = const VerificationMeta(
    'modelName',
  );
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
    'model_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputPricePer1MMeta = const VerificationMeta(
    'inputPricePer1M',
  );
  @override
  late final GeneratedColumn<double> inputPricePer1M = GeneratedColumn<double>(
    'input_price_per1_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outputPricePer1MMeta = const VerificationMeta(
    'outputPricePer1M',
  );
  @override
  late final GeneratedColumn<double> outputPricePer1M = GeneratedColumn<double>(
    'output_price_per1_m',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedInputPricePer1MMeta =
      const VerificationMeta('cachedInputPricePer1M');
  @override
  late final GeneratedColumn<double> cachedInputPricePer1M =
      GeneratedColumn<double>(
        'cached_input_price_per1_m',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reasoningOutputPricePer1MMeta =
      const VerificationMeta('reasoningOutputPricePer1M');
  @override
  late final GeneratedColumn<double> reasoningOutputPricePer1M =
      GeneratedColumn<double>(
        'reasoning_output_price_per1_m',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _effectiveFromMeta = const VerificationMeta(
    'effectiveFrom',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveFrom =
      GeneratedColumn<DateTime>(
        'effective_from',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _effectiveToMeta = const VerificationMeta(
    'effectiveTo',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveTo = GeneratedColumn<DateTime>(
    'effective_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceNoteMeta = const VerificationMeta(
    'sourceNote',
  );
  @override
  late final GeneratedColumn<String> sourceNote = GeneratedColumn<String>(
    'source_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userEditableMeta = const VerificationMeta(
    'userEditable',
  );
  @override
  late final GeneratedColumn<bool> userEditable = GeneratedColumn<bool>(
    'user_editable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_editable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    providerType,
    modelName,
    inputPricePer1M,
    outputPricePer1M,
    cachedInputPricePer1M,
    reasoningOutputPricePer1M,
    currency,
    effectiveFrom,
    effectiveTo,
    sourceNote,
    userEditable,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'model_prices';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelPrice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('provider_type')) {
      context.handle(
        _providerTypeMeta,
        providerType.isAcceptableOrUnknown(
          data['provider_type']!,
          _providerTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerTypeMeta);
    }
    if (data.containsKey('model_name')) {
      context.handle(
        _modelNameMeta,
        modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta),
      );
    } else if (isInserting) {
      context.missing(_modelNameMeta);
    }
    if (data.containsKey('input_price_per1_m')) {
      context.handle(
        _inputPricePer1MMeta,
        inputPricePer1M.isAcceptableOrUnknown(
          data['input_price_per1_m']!,
          _inputPricePer1MMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputPricePer1MMeta);
    }
    if (data.containsKey('output_price_per1_m')) {
      context.handle(
        _outputPricePer1MMeta,
        outputPricePer1M.isAcceptableOrUnknown(
          data['output_price_per1_m']!,
          _outputPricePer1MMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outputPricePer1MMeta);
    }
    if (data.containsKey('cached_input_price_per1_m')) {
      context.handle(
        _cachedInputPricePer1MMeta,
        cachedInputPricePer1M.isAcceptableOrUnknown(
          data['cached_input_price_per1_m']!,
          _cachedInputPricePer1MMeta,
        ),
      );
    }
    if (data.containsKey('reasoning_output_price_per1_m')) {
      context.handle(
        _reasoningOutputPricePer1MMeta,
        reasoningOutputPricePer1M.isAcceptableOrUnknown(
          data['reasoning_output_price_per1_m']!,
          _reasoningOutputPricePer1MMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('effective_from')) {
      context.handle(
        _effectiveFromMeta,
        effectiveFrom.isAcceptableOrUnknown(
          data['effective_from']!,
          _effectiveFromMeta,
        ),
      );
    }
    if (data.containsKey('effective_to')) {
      context.handle(
        _effectiveToMeta,
        effectiveTo.isAcceptableOrUnknown(
          data['effective_to']!,
          _effectiveToMeta,
        ),
      );
    }
    if (data.containsKey('source_note')) {
      context.handle(
        _sourceNoteMeta,
        sourceNote.isAcceptableOrUnknown(data['source_note']!, _sourceNoteMeta),
      );
    }
    if (data.containsKey('user_editable')) {
      context.handle(
        _userEditableMeta,
        userEditable.isAcceptableOrUnknown(
          data['user_editable']!,
          _userEditableMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelPrice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      providerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_type'],
      )!,
      modelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_name'],
      )!,
      inputPricePer1M: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}input_price_per1_m'],
      )!,
      outputPricePer1M: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}output_price_per1_m'],
      )!,
      cachedInputPricePer1M: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cached_input_price_per1_m'],
      ),
      reasoningOutputPricePer1M: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}reasoning_output_price_per1_m'],
      ),
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      effectiveFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_from'],
      ),
      effectiveTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_to'],
      ),
      sourceNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_note'],
      ),
      userEditable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_editable'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ModelPricesTable createAlias(String alias) {
    return $ModelPricesTable(attachedDatabase, alias);
  }
}

class ModelPrice extends DataClass implements Insertable<ModelPrice> {
  final int id;
  final String providerType;
  final String modelName;
  final double inputPricePer1M;
  final double outputPricePer1M;
  final double? cachedInputPricePer1M;
  final double? reasoningOutputPricePer1M;
  final String currency;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;
  final String? sourceNote;
  final bool userEditable;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ModelPrice({
    required this.id,
    required this.providerType,
    required this.modelName,
    required this.inputPricePer1M,
    required this.outputPricePer1M,
    this.cachedInputPricePer1M,
    this.reasoningOutputPricePer1M,
    required this.currency,
    this.effectiveFrom,
    this.effectiveTo,
    this.sourceNote,
    required this.userEditable,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['provider_type'] = Variable<String>(providerType);
    map['model_name'] = Variable<String>(modelName);
    map['input_price_per1_m'] = Variable<double>(inputPricePer1M);
    map['output_price_per1_m'] = Variable<double>(outputPricePer1M);
    if (!nullToAbsent || cachedInputPricePer1M != null) {
      map['cached_input_price_per1_m'] = Variable<double>(
        cachedInputPricePer1M,
      );
    }
    if (!nullToAbsent || reasoningOutputPricePer1M != null) {
      map['reasoning_output_price_per1_m'] = Variable<double>(
        reasoningOutputPricePer1M,
      );
    }
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || effectiveFrom != null) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom);
    }
    if (!nullToAbsent || effectiveTo != null) {
      map['effective_to'] = Variable<DateTime>(effectiveTo);
    }
    if (!nullToAbsent || sourceNote != null) {
      map['source_note'] = Variable<String>(sourceNote);
    }
    map['user_editable'] = Variable<bool>(userEditable);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ModelPricesCompanion toCompanion(bool nullToAbsent) {
    return ModelPricesCompanion(
      id: Value(id),
      providerType: Value(providerType),
      modelName: Value(modelName),
      inputPricePer1M: Value(inputPricePer1M),
      outputPricePer1M: Value(outputPricePer1M),
      cachedInputPricePer1M: cachedInputPricePer1M == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedInputPricePer1M),
      reasoningOutputPricePer1M:
          reasoningOutputPricePer1M == null && nullToAbsent
          ? const Value.absent()
          : Value(reasoningOutputPricePer1M),
      currency: Value(currency),
      effectiveFrom: effectiveFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveFrom),
      effectiveTo: effectiveTo == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveTo),
      sourceNote: sourceNote == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceNote),
      userEditable: Value(userEditable),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ModelPrice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelPrice(
      id: serializer.fromJson<int>(json['id']),
      providerType: serializer.fromJson<String>(json['providerType']),
      modelName: serializer.fromJson<String>(json['modelName']),
      inputPricePer1M: serializer.fromJson<double>(json['inputPricePer1M']),
      outputPricePer1M: serializer.fromJson<double>(json['outputPricePer1M']),
      cachedInputPricePer1M: serializer.fromJson<double?>(
        json['cachedInputPricePer1M'],
      ),
      reasoningOutputPricePer1M: serializer.fromJson<double?>(
        json['reasoningOutputPricePer1M'],
      ),
      currency: serializer.fromJson<String>(json['currency']),
      effectiveFrom: serializer.fromJson<DateTime?>(json['effectiveFrom']),
      effectiveTo: serializer.fromJson<DateTime?>(json['effectiveTo']),
      sourceNote: serializer.fromJson<String?>(json['sourceNote']),
      userEditable: serializer.fromJson<bool>(json['userEditable']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'providerType': serializer.toJson<String>(providerType),
      'modelName': serializer.toJson<String>(modelName),
      'inputPricePer1M': serializer.toJson<double>(inputPricePer1M),
      'outputPricePer1M': serializer.toJson<double>(outputPricePer1M),
      'cachedInputPricePer1M': serializer.toJson<double?>(
        cachedInputPricePer1M,
      ),
      'reasoningOutputPricePer1M': serializer.toJson<double?>(
        reasoningOutputPricePer1M,
      ),
      'currency': serializer.toJson<String>(currency),
      'effectiveFrom': serializer.toJson<DateTime?>(effectiveFrom),
      'effectiveTo': serializer.toJson<DateTime?>(effectiveTo),
      'sourceNote': serializer.toJson<String?>(sourceNote),
      'userEditable': serializer.toJson<bool>(userEditable),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ModelPrice copyWith({
    int? id,
    String? providerType,
    String? modelName,
    double? inputPricePer1M,
    double? outputPricePer1M,
    Value<double?> cachedInputPricePer1M = const Value.absent(),
    Value<double?> reasoningOutputPricePer1M = const Value.absent(),
    String? currency,
    Value<DateTime?> effectiveFrom = const Value.absent(),
    Value<DateTime?> effectiveTo = const Value.absent(),
    Value<String?> sourceNote = const Value.absent(),
    bool? userEditable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ModelPrice(
    id: id ?? this.id,
    providerType: providerType ?? this.providerType,
    modelName: modelName ?? this.modelName,
    inputPricePer1M: inputPricePer1M ?? this.inputPricePer1M,
    outputPricePer1M: outputPricePer1M ?? this.outputPricePer1M,
    cachedInputPricePer1M: cachedInputPricePer1M.present
        ? cachedInputPricePer1M.value
        : this.cachedInputPricePer1M,
    reasoningOutputPricePer1M: reasoningOutputPricePer1M.present
        ? reasoningOutputPricePer1M.value
        : this.reasoningOutputPricePer1M,
    currency: currency ?? this.currency,
    effectiveFrom: effectiveFrom.present
        ? effectiveFrom.value
        : this.effectiveFrom,
    effectiveTo: effectiveTo.present ? effectiveTo.value : this.effectiveTo,
    sourceNote: sourceNote.present ? sourceNote.value : this.sourceNote,
    userEditable: userEditable ?? this.userEditable,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ModelPrice copyWithCompanion(ModelPricesCompanion data) {
    return ModelPrice(
      id: data.id.present ? data.id.value : this.id,
      providerType: data.providerType.present
          ? data.providerType.value
          : this.providerType,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      inputPricePer1M: data.inputPricePer1M.present
          ? data.inputPricePer1M.value
          : this.inputPricePer1M,
      outputPricePer1M: data.outputPricePer1M.present
          ? data.outputPricePer1M.value
          : this.outputPricePer1M,
      cachedInputPricePer1M: data.cachedInputPricePer1M.present
          ? data.cachedInputPricePer1M.value
          : this.cachedInputPricePer1M,
      reasoningOutputPricePer1M: data.reasoningOutputPricePer1M.present
          ? data.reasoningOutputPricePer1M.value
          : this.reasoningOutputPricePer1M,
      currency: data.currency.present ? data.currency.value : this.currency,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
      effectiveTo: data.effectiveTo.present
          ? data.effectiveTo.value
          : this.effectiveTo,
      sourceNote: data.sourceNote.present
          ? data.sourceNote.value
          : this.sourceNote,
      userEditable: data.userEditable.present
          ? data.userEditable.value
          : this.userEditable,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelPrice(')
          ..write('id: $id, ')
          ..write('providerType: $providerType, ')
          ..write('modelName: $modelName, ')
          ..write('inputPricePer1M: $inputPricePer1M, ')
          ..write('outputPricePer1M: $outputPricePer1M, ')
          ..write('cachedInputPricePer1M: $cachedInputPricePer1M, ')
          ..write('reasoningOutputPricePer1M: $reasoningOutputPricePer1M, ')
          ..write('currency: $currency, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('sourceNote: $sourceNote, ')
          ..write('userEditable: $userEditable, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    providerType,
    modelName,
    inputPricePer1M,
    outputPricePer1M,
    cachedInputPricePer1M,
    reasoningOutputPricePer1M,
    currency,
    effectiveFrom,
    effectiveTo,
    sourceNote,
    userEditable,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelPrice &&
          other.id == this.id &&
          other.providerType == this.providerType &&
          other.modelName == this.modelName &&
          other.inputPricePer1M == this.inputPricePer1M &&
          other.outputPricePer1M == this.outputPricePer1M &&
          other.cachedInputPricePer1M == this.cachedInputPricePer1M &&
          other.reasoningOutputPricePer1M == this.reasoningOutputPricePer1M &&
          other.currency == this.currency &&
          other.effectiveFrom == this.effectiveFrom &&
          other.effectiveTo == this.effectiveTo &&
          other.sourceNote == this.sourceNote &&
          other.userEditable == this.userEditable &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ModelPricesCompanion extends UpdateCompanion<ModelPrice> {
  final Value<int> id;
  final Value<String> providerType;
  final Value<String> modelName;
  final Value<double> inputPricePer1M;
  final Value<double> outputPricePer1M;
  final Value<double?> cachedInputPricePer1M;
  final Value<double?> reasoningOutputPricePer1M;
  final Value<String> currency;
  final Value<DateTime?> effectiveFrom;
  final Value<DateTime?> effectiveTo;
  final Value<String?> sourceNote;
  final Value<bool> userEditable;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ModelPricesCompanion({
    this.id = const Value.absent(),
    this.providerType = const Value.absent(),
    this.modelName = const Value.absent(),
    this.inputPricePer1M = const Value.absent(),
    this.outputPricePer1M = const Value.absent(),
    this.cachedInputPricePer1M = const Value.absent(),
    this.reasoningOutputPricePer1M = const Value.absent(),
    this.currency = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    this.sourceNote = const Value.absent(),
    this.userEditable = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ModelPricesCompanion.insert({
    this.id = const Value.absent(),
    required String providerType,
    required String modelName,
    required double inputPricePer1M,
    required double outputPricePer1M,
    this.cachedInputPricePer1M = const Value.absent(),
    this.reasoningOutputPricePer1M = const Value.absent(),
    this.currency = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.effectiveTo = const Value.absent(),
    this.sourceNote = const Value.absent(),
    this.userEditable = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : providerType = Value(providerType),
       modelName = Value(modelName),
       inputPricePer1M = Value(inputPricePer1M),
       outputPricePer1M = Value(outputPricePer1M);
  static Insertable<ModelPrice> custom({
    Expression<int>? id,
    Expression<String>? providerType,
    Expression<String>? modelName,
    Expression<double>? inputPricePer1M,
    Expression<double>? outputPricePer1M,
    Expression<double>? cachedInputPricePer1M,
    Expression<double>? reasoningOutputPricePer1M,
    Expression<String>? currency,
    Expression<DateTime>? effectiveFrom,
    Expression<DateTime>? effectiveTo,
    Expression<String>? sourceNote,
    Expression<bool>? userEditable,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (providerType != null) 'provider_type': providerType,
      if (modelName != null) 'model_name': modelName,
      if (inputPricePer1M != null) 'input_price_per1_m': inputPricePer1M,
      if (outputPricePer1M != null) 'output_price_per1_m': outputPricePer1M,
      if (cachedInputPricePer1M != null)
        'cached_input_price_per1_m': cachedInputPricePer1M,
      if (reasoningOutputPricePer1M != null)
        'reasoning_output_price_per1_m': reasoningOutputPricePer1M,
      if (currency != null) 'currency': currency,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (effectiveTo != null) 'effective_to': effectiveTo,
      if (sourceNote != null) 'source_note': sourceNote,
      if (userEditable != null) 'user_editable': userEditable,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ModelPricesCompanion copyWith({
    Value<int>? id,
    Value<String>? providerType,
    Value<String>? modelName,
    Value<double>? inputPricePer1M,
    Value<double>? outputPricePer1M,
    Value<double?>? cachedInputPricePer1M,
    Value<double?>? reasoningOutputPricePer1M,
    Value<String>? currency,
    Value<DateTime?>? effectiveFrom,
    Value<DateTime?>? effectiveTo,
    Value<String?>? sourceNote,
    Value<bool>? userEditable,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ModelPricesCompanion(
      id: id ?? this.id,
      providerType: providerType ?? this.providerType,
      modelName: modelName ?? this.modelName,
      inputPricePer1M: inputPricePer1M ?? this.inputPricePer1M,
      outputPricePer1M: outputPricePer1M ?? this.outputPricePer1M,
      cachedInputPricePer1M:
          cachedInputPricePer1M ?? this.cachedInputPricePer1M,
      reasoningOutputPricePer1M:
          reasoningOutputPricePer1M ?? this.reasoningOutputPricePer1M,
      currency: currency ?? this.currency,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      sourceNote: sourceNote ?? this.sourceNote,
      userEditable: userEditable ?? this.userEditable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (providerType.present) {
      map['provider_type'] = Variable<String>(providerType.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (inputPricePer1M.present) {
      map['input_price_per1_m'] = Variable<double>(inputPricePer1M.value);
    }
    if (outputPricePer1M.present) {
      map['output_price_per1_m'] = Variable<double>(outputPricePer1M.value);
    }
    if (cachedInputPricePer1M.present) {
      map['cached_input_price_per1_m'] = Variable<double>(
        cachedInputPricePer1M.value,
      );
    }
    if (reasoningOutputPricePer1M.present) {
      map['reasoning_output_price_per1_m'] = Variable<double>(
        reasoningOutputPricePer1M.value,
      );
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<DateTime>(effectiveFrom.value);
    }
    if (effectiveTo.present) {
      map['effective_to'] = Variable<DateTime>(effectiveTo.value);
    }
    if (sourceNote.present) {
      map['source_note'] = Variable<String>(sourceNote.value);
    }
    if (userEditable.present) {
      map['user_editable'] = Variable<bool>(userEditable.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelPricesCompanion(')
          ..write('id: $id, ')
          ..write('providerType: $providerType, ')
          ..write('modelName: $modelName, ')
          ..write('inputPricePer1M: $inputPricePer1M, ')
          ..write('outputPricePer1M: $outputPricePer1M, ')
          ..write('cachedInputPricePer1M: $cachedInputPricePer1M, ')
          ..write('reasoningOutputPricePer1M: $reasoningOutputPricePer1M, ')
          ..write('currency: $currency, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('effectiveTo: $effectiveTo, ')
          ..write('sourceNote: $sourceNote, ')
          ..write('userEditable: $userEditable, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AlertRulesTable extends AlertRules
    with TableInfo<$AlertRulesTable, AlertRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _alertTypeMeta = const VerificationMeta(
    'alertType',
  );
  @override
  late final GeneratedColumn<String> alertType = GeneratedColumn<String>(
    'alert_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 50),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thresholdMeta = const VerificationMeta(
    'threshold',
  );
  @override
  late final GeneratedColumn<double> threshold = GeneratedColumn<double>(
    'threshold',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerTypeMeta = const VerificationMeta(
    'providerType',
  );
  @override
  late final GeneratedColumn<String> providerType = GeneratedColumn<String>(
    'provider_type',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    alertType,
    threshold,
    providerType,
    accountId,
    enabled,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alert_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlertRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('alert_type')) {
      context.handle(
        _alertTypeMeta,
        alertType.isAcceptableOrUnknown(data['alert_type']!, _alertTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_alertTypeMeta);
    }
    if (data.containsKey('threshold')) {
      context.handle(
        _thresholdMeta,
        threshold.isAcceptableOrUnknown(data['threshold']!, _thresholdMeta),
      );
    } else if (isInserting) {
      context.missing(_thresholdMeta);
    }
    if (data.containsKey('provider_type')) {
      context.handle(
        _providerTypeMeta,
        providerType.isAcceptableOrUnknown(
          data['provider_type']!,
          _providerTypeMeta,
        ),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      alertType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alert_type'],
      )!,
      threshold: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}threshold'],
      )!,
      providerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_type'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AlertRulesTable createAlias(String alias) {
    return $AlertRulesTable(attachedDatabase, alias);
  }
}

class AlertRule extends DataClass implements Insertable<AlertRule> {
  final int id;
  final String alertType;
  final double threshold;
  final String? providerType;
  final int? accountId;
  final bool enabled;
  final DateTime createdAt;
  const AlertRule({
    required this.id,
    required this.alertType,
    required this.threshold,
    this.providerType,
    this.accountId,
    required this.enabled,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['alert_type'] = Variable<String>(alertType);
    map['threshold'] = Variable<double>(threshold);
    if (!nullToAbsent || providerType != null) {
      map['provider_type'] = Variable<String>(providerType);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['enabled'] = Variable<bool>(enabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AlertRulesCompanion toCompanion(bool nullToAbsent) {
    return AlertRulesCompanion(
      id: Value(id),
      alertType: Value(alertType),
      threshold: Value(threshold),
      providerType: providerType == null && nullToAbsent
          ? const Value.absent()
          : Value(providerType),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      enabled: Value(enabled),
      createdAt: Value(createdAt),
    );
  }

  factory AlertRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertRule(
      id: serializer.fromJson<int>(json['id']),
      alertType: serializer.fromJson<String>(json['alertType']),
      threshold: serializer.fromJson<double>(json['threshold']),
      providerType: serializer.fromJson<String?>(json['providerType']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'alertType': serializer.toJson<String>(alertType),
      'threshold': serializer.toJson<double>(threshold),
      'providerType': serializer.toJson<String?>(providerType),
      'accountId': serializer.toJson<int?>(accountId),
      'enabled': serializer.toJson<bool>(enabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AlertRule copyWith({
    int? id,
    String? alertType,
    double? threshold,
    Value<String?> providerType = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
    bool? enabled,
    DateTime? createdAt,
  }) => AlertRule(
    id: id ?? this.id,
    alertType: alertType ?? this.alertType,
    threshold: threshold ?? this.threshold,
    providerType: providerType.present ? providerType.value : this.providerType,
    accountId: accountId.present ? accountId.value : this.accountId,
    enabled: enabled ?? this.enabled,
    createdAt: createdAt ?? this.createdAt,
  );
  AlertRule copyWithCompanion(AlertRulesCompanion data) {
    return AlertRule(
      id: data.id.present ? data.id.value : this.id,
      alertType: data.alertType.present ? data.alertType.value : this.alertType,
      threshold: data.threshold.present ? data.threshold.value : this.threshold,
      providerType: data.providerType.present
          ? data.providerType.value
          : this.providerType,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertRule(')
          ..write('id: $id, ')
          ..write('alertType: $alertType, ')
          ..write('threshold: $threshold, ')
          ..write('providerType: $providerType, ')
          ..write('accountId: $accountId, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    alertType,
    threshold,
    providerType,
    accountId,
    enabled,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertRule &&
          other.id == this.id &&
          other.alertType == this.alertType &&
          other.threshold == this.threshold &&
          other.providerType == this.providerType &&
          other.accountId == this.accountId &&
          other.enabled == this.enabled &&
          other.createdAt == this.createdAt);
}

class AlertRulesCompanion extends UpdateCompanion<AlertRule> {
  final Value<int> id;
  final Value<String> alertType;
  final Value<double> threshold;
  final Value<String?> providerType;
  final Value<int?> accountId;
  final Value<bool> enabled;
  final Value<DateTime> createdAt;
  const AlertRulesCompanion({
    this.id = const Value.absent(),
    this.alertType = const Value.absent(),
    this.threshold = const Value.absent(),
    this.providerType = const Value.absent(),
    this.accountId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AlertRulesCompanion.insert({
    this.id = const Value.absent(),
    required String alertType,
    required double threshold,
    this.providerType = const Value.absent(),
    this.accountId = const Value.absent(),
    this.enabled = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : alertType = Value(alertType),
       threshold = Value(threshold);
  static Insertable<AlertRule> custom({
    Expression<int>? id,
    Expression<String>? alertType,
    Expression<double>? threshold,
    Expression<String>? providerType,
    Expression<int>? accountId,
    Expression<bool>? enabled,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alertType != null) 'alert_type': alertType,
      if (threshold != null) 'threshold': threshold,
      if (providerType != null) 'provider_type': providerType,
      if (accountId != null) 'account_id': accountId,
      if (enabled != null) 'enabled': enabled,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AlertRulesCompanion copyWith({
    Value<int>? id,
    Value<String>? alertType,
    Value<double>? threshold,
    Value<String?>? providerType,
    Value<int?>? accountId,
    Value<bool>? enabled,
    Value<DateTime>? createdAt,
  }) {
    return AlertRulesCompanion(
      id: id ?? this.id,
      alertType: alertType ?? this.alertType,
      threshold: threshold ?? this.threshold,
      providerType: providerType ?? this.providerType,
      accountId: accountId ?? this.accountId,
      enabled: enabled ?? this.enabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (alertType.present) {
      map['alert_type'] = Variable<String>(alertType.value);
    }
    if (threshold.present) {
      map['threshold'] = Variable<double>(threshold.value);
    }
    if (providerType.present) {
      map['provider_type'] = Variable<String>(providerType.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertRulesCompanion(')
          ..write('id: $id, ')
          ..write('alertType: $alertType, ')
          ..write('threshold: $threshold, ')
          ..write('providerType: $providerType, ')
          ..write('accountId: $accountId, ')
          ..write('enabled: $enabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String? value;
  final DateTime updatedAt;
  const AppSetting({required this.key, this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
    DateTime? updatedAt,
  }) => AppSetting(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProviderCapabilitiesTable extends ProviderCapabilities
    with TableInfo<$ProviderCapabilitiesTable, ProviderCapability> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProviderCapabilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _providerTypeMeta = const VerificationMeta(
    'providerType',
  );
  @override
  late final GeneratedColumn<String> providerType = GeneratedColumn<String>(
    'provider_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _supportsBalanceQueryMeta =
      const VerificationMeta('supportsBalanceQuery');
  @override
  late final GeneratedColumn<bool> supportsBalanceQuery = GeneratedColumn<bool>(
    'supports_balance_query',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("supports_balance_query" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _supportsModelListMeta = const VerificationMeta(
    'supportsModelList',
  );
  @override
  late final GeneratedColumn<bool> supportsModelList = GeneratedColumn<bool>(
    'supports_model_list',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("supports_model_list" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _supportsUsageParsingMeta =
      const VerificationMeta('supportsUsageParsing');
  @override
  late final GeneratedColumn<bool> supportsUsageParsing = GeneratedColumn<bool>(
    'supports_usage_parsing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("supports_usage_parsing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _supportsStreamingMeta = const VerificationMeta(
    'supportsStreaming',
  );
  @override
  late final GeneratedColumn<bool> supportsStreaming = GeneratedColumn<bool>(
    'supports_streaming',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("supports_streaming" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _requiresManualQuotaMeta =
      const VerificationMeta('requiresManualQuota');
  @override
  late final GeneratedColumn<bool> requiresManualQuota = GeneratedColumn<bool>(
    'requires_manual_quota',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_manual_quota" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _baseUrlTemplateMeta = const VerificationMeta(
    'baseUrlTemplate',
  );
  @override
  late final GeneratedColumn<String> baseUrlTemplate = GeneratedColumn<String>(
    'base_url_template',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    providerType,
    supportsBalanceQuery,
    supportsModelList,
    supportsUsageParsing,
    supportsStreaming,
    requiresManualQuota,
    baseUrlTemplate,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provider_capabilities';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProviderCapability> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('provider_type')) {
      context.handle(
        _providerTypeMeta,
        providerType.isAcceptableOrUnknown(
          data['provider_type']!,
          _providerTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerTypeMeta);
    }
    if (data.containsKey('supports_balance_query')) {
      context.handle(
        _supportsBalanceQueryMeta,
        supportsBalanceQuery.isAcceptableOrUnknown(
          data['supports_balance_query']!,
          _supportsBalanceQueryMeta,
        ),
      );
    }
    if (data.containsKey('supports_model_list')) {
      context.handle(
        _supportsModelListMeta,
        supportsModelList.isAcceptableOrUnknown(
          data['supports_model_list']!,
          _supportsModelListMeta,
        ),
      );
    }
    if (data.containsKey('supports_usage_parsing')) {
      context.handle(
        _supportsUsageParsingMeta,
        supportsUsageParsing.isAcceptableOrUnknown(
          data['supports_usage_parsing']!,
          _supportsUsageParsingMeta,
        ),
      );
    }
    if (data.containsKey('supports_streaming')) {
      context.handle(
        _supportsStreamingMeta,
        supportsStreaming.isAcceptableOrUnknown(
          data['supports_streaming']!,
          _supportsStreamingMeta,
        ),
      );
    }
    if (data.containsKey('requires_manual_quota')) {
      context.handle(
        _requiresManualQuotaMeta,
        requiresManualQuota.isAcceptableOrUnknown(
          data['requires_manual_quota']!,
          _requiresManualQuotaMeta,
        ),
      );
    }
    if (data.containsKey('base_url_template')) {
      context.handle(
        _baseUrlTemplateMeta,
        baseUrlTemplate.isAcceptableOrUnknown(
          data['base_url_template']!,
          _baseUrlTemplateMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProviderCapability map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProviderCapability(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      providerType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider_type'],
      )!,
      supportsBalanceQuery: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_balance_query'],
      )!,
      supportsModelList: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_model_list'],
      )!,
      supportsUsageParsing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_usage_parsing'],
      )!,
      supportsStreaming: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}supports_streaming'],
      )!,
      requiresManualQuota: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_manual_quota'],
      )!,
      baseUrlTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_url_template'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProviderCapabilitiesTable createAlias(String alias) {
    return $ProviderCapabilitiesTable(attachedDatabase, alias);
  }
}

class ProviderCapability extends DataClass
    implements Insertable<ProviderCapability> {
  final int id;
  final String providerType;
  final bool supportsBalanceQuery;
  final bool supportsModelList;
  final bool supportsUsageParsing;
  final bool supportsStreaming;
  final bool requiresManualQuota;
  final String? baseUrlTemplate;
  final DateTime updatedAt;
  const ProviderCapability({
    required this.id,
    required this.providerType,
    required this.supportsBalanceQuery,
    required this.supportsModelList,
    required this.supportsUsageParsing,
    required this.supportsStreaming,
    required this.requiresManualQuota,
    this.baseUrlTemplate,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['provider_type'] = Variable<String>(providerType);
    map['supports_balance_query'] = Variable<bool>(supportsBalanceQuery);
    map['supports_model_list'] = Variable<bool>(supportsModelList);
    map['supports_usage_parsing'] = Variable<bool>(supportsUsageParsing);
    map['supports_streaming'] = Variable<bool>(supportsStreaming);
    map['requires_manual_quota'] = Variable<bool>(requiresManualQuota);
    if (!nullToAbsent || baseUrlTemplate != null) {
      map['base_url_template'] = Variable<String>(baseUrlTemplate);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProviderCapabilitiesCompanion toCompanion(bool nullToAbsent) {
    return ProviderCapabilitiesCompanion(
      id: Value(id),
      providerType: Value(providerType),
      supportsBalanceQuery: Value(supportsBalanceQuery),
      supportsModelList: Value(supportsModelList),
      supportsUsageParsing: Value(supportsUsageParsing),
      supportsStreaming: Value(supportsStreaming),
      requiresManualQuota: Value(requiresManualQuota),
      baseUrlTemplate: baseUrlTemplate == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUrlTemplate),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProviderCapability.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProviderCapability(
      id: serializer.fromJson<int>(json['id']),
      providerType: serializer.fromJson<String>(json['providerType']),
      supportsBalanceQuery: serializer.fromJson<bool>(
        json['supportsBalanceQuery'],
      ),
      supportsModelList: serializer.fromJson<bool>(json['supportsModelList']),
      supportsUsageParsing: serializer.fromJson<bool>(
        json['supportsUsageParsing'],
      ),
      supportsStreaming: serializer.fromJson<bool>(json['supportsStreaming']),
      requiresManualQuota: serializer.fromJson<bool>(
        json['requiresManualQuota'],
      ),
      baseUrlTemplate: serializer.fromJson<String?>(json['baseUrlTemplate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'providerType': serializer.toJson<String>(providerType),
      'supportsBalanceQuery': serializer.toJson<bool>(supportsBalanceQuery),
      'supportsModelList': serializer.toJson<bool>(supportsModelList),
      'supportsUsageParsing': serializer.toJson<bool>(supportsUsageParsing),
      'supportsStreaming': serializer.toJson<bool>(supportsStreaming),
      'requiresManualQuota': serializer.toJson<bool>(requiresManualQuota),
      'baseUrlTemplate': serializer.toJson<String?>(baseUrlTemplate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProviderCapability copyWith({
    int? id,
    String? providerType,
    bool? supportsBalanceQuery,
    bool? supportsModelList,
    bool? supportsUsageParsing,
    bool? supportsStreaming,
    bool? requiresManualQuota,
    Value<String?> baseUrlTemplate = const Value.absent(),
    DateTime? updatedAt,
  }) => ProviderCapability(
    id: id ?? this.id,
    providerType: providerType ?? this.providerType,
    supportsBalanceQuery: supportsBalanceQuery ?? this.supportsBalanceQuery,
    supportsModelList: supportsModelList ?? this.supportsModelList,
    supportsUsageParsing: supportsUsageParsing ?? this.supportsUsageParsing,
    supportsStreaming: supportsStreaming ?? this.supportsStreaming,
    requiresManualQuota: requiresManualQuota ?? this.requiresManualQuota,
    baseUrlTemplate: baseUrlTemplate.present
        ? baseUrlTemplate.value
        : this.baseUrlTemplate,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProviderCapability copyWithCompanion(ProviderCapabilitiesCompanion data) {
    return ProviderCapability(
      id: data.id.present ? data.id.value : this.id,
      providerType: data.providerType.present
          ? data.providerType.value
          : this.providerType,
      supportsBalanceQuery: data.supportsBalanceQuery.present
          ? data.supportsBalanceQuery.value
          : this.supportsBalanceQuery,
      supportsModelList: data.supportsModelList.present
          ? data.supportsModelList.value
          : this.supportsModelList,
      supportsUsageParsing: data.supportsUsageParsing.present
          ? data.supportsUsageParsing.value
          : this.supportsUsageParsing,
      supportsStreaming: data.supportsStreaming.present
          ? data.supportsStreaming.value
          : this.supportsStreaming,
      requiresManualQuota: data.requiresManualQuota.present
          ? data.requiresManualQuota.value
          : this.requiresManualQuota,
      baseUrlTemplate: data.baseUrlTemplate.present
          ? data.baseUrlTemplate.value
          : this.baseUrlTemplate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProviderCapability(')
          ..write('id: $id, ')
          ..write('providerType: $providerType, ')
          ..write('supportsBalanceQuery: $supportsBalanceQuery, ')
          ..write('supportsModelList: $supportsModelList, ')
          ..write('supportsUsageParsing: $supportsUsageParsing, ')
          ..write('supportsStreaming: $supportsStreaming, ')
          ..write('requiresManualQuota: $requiresManualQuota, ')
          ..write('baseUrlTemplate: $baseUrlTemplate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    providerType,
    supportsBalanceQuery,
    supportsModelList,
    supportsUsageParsing,
    supportsStreaming,
    requiresManualQuota,
    baseUrlTemplate,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderCapability &&
          other.id == this.id &&
          other.providerType == this.providerType &&
          other.supportsBalanceQuery == this.supportsBalanceQuery &&
          other.supportsModelList == this.supportsModelList &&
          other.supportsUsageParsing == this.supportsUsageParsing &&
          other.supportsStreaming == this.supportsStreaming &&
          other.requiresManualQuota == this.requiresManualQuota &&
          other.baseUrlTemplate == this.baseUrlTemplate &&
          other.updatedAt == this.updatedAt);
}

class ProviderCapabilitiesCompanion
    extends UpdateCompanion<ProviderCapability> {
  final Value<int> id;
  final Value<String> providerType;
  final Value<bool> supportsBalanceQuery;
  final Value<bool> supportsModelList;
  final Value<bool> supportsUsageParsing;
  final Value<bool> supportsStreaming;
  final Value<bool> requiresManualQuota;
  final Value<String?> baseUrlTemplate;
  final Value<DateTime> updatedAt;
  const ProviderCapabilitiesCompanion({
    this.id = const Value.absent(),
    this.providerType = const Value.absent(),
    this.supportsBalanceQuery = const Value.absent(),
    this.supportsModelList = const Value.absent(),
    this.supportsUsageParsing = const Value.absent(),
    this.supportsStreaming = const Value.absent(),
    this.requiresManualQuota = const Value.absent(),
    this.baseUrlTemplate = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProviderCapabilitiesCompanion.insert({
    this.id = const Value.absent(),
    required String providerType,
    this.supportsBalanceQuery = const Value.absent(),
    this.supportsModelList = const Value.absent(),
    this.supportsUsageParsing = const Value.absent(),
    this.supportsStreaming = const Value.absent(),
    this.requiresManualQuota = const Value.absent(),
    this.baseUrlTemplate = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : providerType = Value(providerType);
  static Insertable<ProviderCapability> custom({
    Expression<int>? id,
    Expression<String>? providerType,
    Expression<bool>? supportsBalanceQuery,
    Expression<bool>? supportsModelList,
    Expression<bool>? supportsUsageParsing,
    Expression<bool>? supportsStreaming,
    Expression<bool>? requiresManualQuota,
    Expression<String>? baseUrlTemplate,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (providerType != null) 'provider_type': providerType,
      if (supportsBalanceQuery != null)
        'supports_balance_query': supportsBalanceQuery,
      if (supportsModelList != null) 'supports_model_list': supportsModelList,
      if (supportsUsageParsing != null)
        'supports_usage_parsing': supportsUsageParsing,
      if (supportsStreaming != null) 'supports_streaming': supportsStreaming,
      if (requiresManualQuota != null)
        'requires_manual_quota': requiresManualQuota,
      if (baseUrlTemplate != null) 'base_url_template': baseUrlTemplate,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProviderCapabilitiesCompanion copyWith({
    Value<int>? id,
    Value<String>? providerType,
    Value<bool>? supportsBalanceQuery,
    Value<bool>? supportsModelList,
    Value<bool>? supportsUsageParsing,
    Value<bool>? supportsStreaming,
    Value<bool>? requiresManualQuota,
    Value<String?>? baseUrlTemplate,
    Value<DateTime>? updatedAt,
  }) {
    return ProviderCapabilitiesCompanion(
      id: id ?? this.id,
      providerType: providerType ?? this.providerType,
      supportsBalanceQuery: supportsBalanceQuery ?? this.supportsBalanceQuery,
      supportsModelList: supportsModelList ?? this.supportsModelList,
      supportsUsageParsing: supportsUsageParsing ?? this.supportsUsageParsing,
      supportsStreaming: supportsStreaming ?? this.supportsStreaming,
      requiresManualQuota: requiresManualQuota ?? this.requiresManualQuota,
      baseUrlTemplate: baseUrlTemplate ?? this.baseUrlTemplate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (providerType.present) {
      map['provider_type'] = Variable<String>(providerType.value);
    }
    if (supportsBalanceQuery.present) {
      map['supports_balance_query'] = Variable<bool>(
        supportsBalanceQuery.value,
      );
    }
    if (supportsModelList.present) {
      map['supports_model_list'] = Variable<bool>(supportsModelList.value);
    }
    if (supportsUsageParsing.present) {
      map['supports_usage_parsing'] = Variable<bool>(
        supportsUsageParsing.value,
      );
    }
    if (supportsStreaming.present) {
      map['supports_streaming'] = Variable<bool>(supportsStreaming.value);
    }
    if (requiresManualQuota.present) {
      map['requires_manual_quota'] = Variable<bool>(requiresManualQuota.value);
    }
    if (baseUrlTemplate.present) {
      map['base_url_template'] = Variable<String>(baseUrlTemplate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProviderCapabilitiesCompanion(')
          ..write('id: $id, ')
          ..write('providerType: $providerType, ')
          ..write('supportsBalanceQuery: $supportsBalanceQuery, ')
          ..write('supportsModelList: $supportsModelList, ')
          ..write('supportsUsageParsing: $supportsUsageParsing, ')
          ..write('supportsStreaming: $supportsStreaming, ')
          ..write('requiresManualQuota: $requiresManualQuota, ')
          ..write('baseUrlTemplate: $baseUrlTemplate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SchemaMigrationLogsTable extends SchemaMigrationLogs
    with TableInfo<$SchemaMigrationLogsTable, SchemaMigrationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchemaMigrationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromVersionMeta = const VerificationMeta(
    'fromVersion',
  );
  @override
  late final GeneratedColumn<int> fromVersion = GeneratedColumn<int>(
    'from_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toVersionMeta = const VerificationMeta(
    'toVersion',
  );
  @override
  late final GeneratedColumn<int> toVersion = GeneratedColumn<int>(
    'to_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _migratedAtMeta = const VerificationMeta(
    'migratedAt',
  );
  @override
  late final GeneratedColumn<DateTime> migratedAt = GeneratedColumn<DateTime>(
    'migrated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _successMeta = const VerificationMeta(
    'success',
  );
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
    'success',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success" IN (0, 1))',
    ),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromVersion,
    toVersion,
    migratedAt,
    success,
    errorMessage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schema_migration_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchemaMigrationLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_version')) {
      context.handle(
        _fromVersionMeta,
        fromVersion.isAcceptableOrUnknown(
          data['from_version']!,
          _fromVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromVersionMeta);
    }
    if (data.containsKey('to_version')) {
      context.handle(
        _toVersionMeta,
        toVersion.isAcceptableOrUnknown(data['to_version']!, _toVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_toVersionMeta);
    }
    if (data.containsKey('migrated_at')) {
      context.handle(
        _migratedAtMeta,
        migratedAt.isAcceptableOrUnknown(data['migrated_at']!, _migratedAtMeta),
      );
    }
    if (data.containsKey('success')) {
      context.handle(
        _successMeta,
        success.isAcceptableOrUnknown(data['success']!, _successMeta),
      );
    } else if (isInserting) {
      context.missing(_successMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchemaMigrationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchemaMigrationLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fromVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_version'],
      )!,
      toVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_version'],
      )!,
      migratedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}migrated_at'],
      )!,
      success: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}success'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
    );
  }

  @override
  $SchemaMigrationLogsTable createAlias(String alias) {
    return $SchemaMigrationLogsTable(attachedDatabase, alias);
  }
}

class SchemaMigrationLog extends DataClass
    implements Insertable<SchemaMigrationLog> {
  final int id;
  final int fromVersion;
  final int toVersion;
  final DateTime migratedAt;
  final bool success;
  final String? errorMessage;
  const SchemaMigrationLog({
    required this.id,
    required this.fromVersion,
    required this.toVersion,
    required this.migratedAt,
    required this.success,
    this.errorMessage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_version'] = Variable<int>(fromVersion);
    map['to_version'] = Variable<int>(toVersion);
    map['migrated_at'] = Variable<DateTime>(migratedAt);
    map['success'] = Variable<bool>(success);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  SchemaMigrationLogsCompanion toCompanion(bool nullToAbsent) {
    return SchemaMigrationLogsCompanion(
      id: Value(id),
      fromVersion: Value(fromVersion),
      toVersion: Value(toVersion),
      migratedAt: Value(migratedAt),
      success: Value(success),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory SchemaMigrationLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchemaMigrationLog(
      id: serializer.fromJson<int>(json['id']),
      fromVersion: serializer.fromJson<int>(json['fromVersion']),
      toVersion: serializer.fromJson<int>(json['toVersion']),
      migratedAt: serializer.fromJson<DateTime>(json['migratedAt']),
      success: serializer.fromJson<bool>(json['success']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromVersion': serializer.toJson<int>(fromVersion),
      'toVersion': serializer.toJson<int>(toVersion),
      'migratedAt': serializer.toJson<DateTime>(migratedAt),
      'success': serializer.toJson<bool>(success),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  SchemaMigrationLog copyWith({
    int? id,
    int? fromVersion,
    int? toVersion,
    DateTime? migratedAt,
    bool? success,
    Value<String?> errorMessage = const Value.absent(),
  }) => SchemaMigrationLog(
    id: id ?? this.id,
    fromVersion: fromVersion ?? this.fromVersion,
    toVersion: toVersion ?? this.toVersion,
    migratedAt: migratedAt ?? this.migratedAt,
    success: success ?? this.success,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
  );
  SchemaMigrationLog copyWithCompanion(SchemaMigrationLogsCompanion data) {
    return SchemaMigrationLog(
      id: data.id.present ? data.id.value : this.id,
      fromVersion: data.fromVersion.present
          ? data.fromVersion.value
          : this.fromVersion,
      toVersion: data.toVersion.present ? data.toVersion.value : this.toVersion,
      migratedAt: data.migratedAt.present
          ? data.migratedAt.value
          : this.migratedAt,
      success: data.success.present ? data.success.value : this.success,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchemaMigrationLog(')
          ..write('id: $id, ')
          ..write('fromVersion: $fromVersion, ')
          ..write('toVersion: $toVersion, ')
          ..write('migratedAt: $migratedAt, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromVersion,
    toVersion,
    migratedAt,
    success,
    errorMessage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchemaMigrationLog &&
          other.id == this.id &&
          other.fromVersion == this.fromVersion &&
          other.toVersion == this.toVersion &&
          other.migratedAt == this.migratedAt &&
          other.success == this.success &&
          other.errorMessage == this.errorMessage);
}

class SchemaMigrationLogsCompanion extends UpdateCompanion<SchemaMigrationLog> {
  final Value<int> id;
  final Value<int> fromVersion;
  final Value<int> toVersion;
  final Value<DateTime> migratedAt;
  final Value<bool> success;
  final Value<String?> errorMessage;
  const SchemaMigrationLogsCompanion({
    this.id = const Value.absent(),
    this.fromVersion = const Value.absent(),
    this.toVersion = const Value.absent(),
    this.migratedAt = const Value.absent(),
    this.success = const Value.absent(),
    this.errorMessage = const Value.absent(),
  });
  SchemaMigrationLogsCompanion.insert({
    this.id = const Value.absent(),
    required int fromVersion,
    required int toVersion,
    this.migratedAt = const Value.absent(),
    required bool success,
    this.errorMessage = const Value.absent(),
  }) : fromVersion = Value(fromVersion),
       toVersion = Value(toVersion),
       success = Value(success);
  static Insertable<SchemaMigrationLog> custom({
    Expression<int>? id,
    Expression<int>? fromVersion,
    Expression<int>? toVersion,
    Expression<DateTime>? migratedAt,
    Expression<bool>? success,
    Expression<String>? errorMessage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromVersion != null) 'from_version': fromVersion,
      if (toVersion != null) 'to_version': toVersion,
      if (migratedAt != null) 'migrated_at': migratedAt,
      if (success != null) 'success': success,
      if (errorMessage != null) 'error_message': errorMessage,
    });
  }

  SchemaMigrationLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? fromVersion,
    Value<int>? toVersion,
    Value<DateTime>? migratedAt,
    Value<bool>? success,
    Value<String?>? errorMessage,
  }) {
    return SchemaMigrationLogsCompanion(
      id: id ?? this.id,
      fromVersion: fromVersion ?? this.fromVersion,
      toVersion: toVersion ?? this.toVersion,
      migratedAt: migratedAt ?? this.migratedAt,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromVersion.present) {
      map['from_version'] = Variable<int>(fromVersion.value);
    }
    if (toVersion.present) {
      map['to_version'] = Variable<int>(toVersion.value);
    }
    if (migratedAt.present) {
      map['migrated_at'] = Variable<DateTime>(migratedAt.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchemaMigrationLogsCompanion(')
          ..write('id: $id, ')
          ..write('fromVersion: $fromVersion, ')
          ..write('toVersion: $toVersion, ')
          ..write('migratedAt: $migratedAt, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }
}

class $ProxyRuntimeLogsTable extends ProxyRuntimeLogs
    with TableInfo<$ProxyRuntimeLogsTable, ProxyRuntimeLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProxyRuntimeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousStateMeta = const VerificationMeta(
    'previousState',
  );
  @override
  late final GeneratedColumn<String> previousState = GeneratedColumn<String>(
    'previous_state',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextStateMeta = const VerificationMeta(
    'nextState',
  );
  @override
  late final GeneratedColumn<String> nextState = GeneratedColumn<String>(
    'next_state',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _schemeMeta = const VerificationMeta('scheme');
  @override
  late final GeneratedColumn<String> scheme = GeneratedColumn<String>(
    'scheme',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hostMeta = const VerificationMeta('host');
  @override
  late final GeneratedColumn<String> host = GeneratedColumn<String>(
    'host',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventType,
    previousState,
    nextState,
    scheme,
    host,
    port,
    message,
    errorMessage,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proxy_runtime_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProxyRuntimeLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('previous_state')) {
      context.handle(
        _previousStateMeta,
        previousState.isAcceptableOrUnknown(
          data['previous_state']!,
          _previousStateMeta,
        ),
      );
    }
    if (data.containsKey('next_state')) {
      context.handle(
        _nextStateMeta,
        nextState.isAcceptableOrUnknown(data['next_state']!, _nextStateMeta),
      );
    }
    if (data.containsKey('scheme')) {
      context.handle(
        _schemeMeta,
        scheme.isAcceptableOrUnknown(data['scheme']!, _schemeMeta),
      );
    }
    if (data.containsKey('host')) {
      context.handle(
        _hostMeta,
        host.isAcceptableOrUnknown(data['host']!, _hostMeta),
      );
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProxyRuntimeLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProxyRuntimeLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      previousState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_state'],
      ),
      nextState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_state'],
      ),
      scheme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheme'],
      ),
      host: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}host'],
      ),
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}port'],
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProxyRuntimeLogsTable createAlias(String alias) {
    return $ProxyRuntimeLogsTable(attachedDatabase, alias);
  }
}

class ProxyRuntimeLog extends DataClass implements Insertable<ProxyRuntimeLog> {
  final int id;
  final String eventType;
  final String? previousState;
  final String? nextState;
  final String? scheme;
  final String? host;
  final int? port;
  final String? message;
  final String? errorMessage;
  final DateTime createdAt;
  const ProxyRuntimeLog({
    required this.id,
    required this.eventType,
    this.previousState,
    this.nextState,
    this.scheme,
    this.host,
    this.port,
    this.message,
    this.errorMessage,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_type'] = Variable<String>(eventType);
    if (!nullToAbsent || previousState != null) {
      map['previous_state'] = Variable<String>(previousState);
    }
    if (!nullToAbsent || nextState != null) {
      map['next_state'] = Variable<String>(nextState);
    }
    if (!nullToAbsent || scheme != null) {
      map['scheme'] = Variable<String>(scheme);
    }
    if (!nullToAbsent || host != null) {
      map['host'] = Variable<String>(host);
    }
    if (!nullToAbsent || port != null) {
      map['port'] = Variable<int>(port);
    }
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProxyRuntimeLogsCompanion toCompanion(bool nullToAbsent) {
    return ProxyRuntimeLogsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      previousState: previousState == null && nullToAbsent
          ? const Value.absent()
          : Value(previousState),
      nextState: nextState == null && nullToAbsent
          ? const Value.absent()
          : Value(nextState),
      scheme: scheme == null && nullToAbsent
          ? const Value.absent()
          : Value(scheme),
      host: host == null && nullToAbsent ? const Value.absent() : Value(host),
      port: port == null && nullToAbsent ? const Value.absent() : Value(port),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
    );
  }

  factory ProxyRuntimeLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProxyRuntimeLog(
      id: serializer.fromJson<int>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      previousState: serializer.fromJson<String?>(json['previousState']),
      nextState: serializer.fromJson<String?>(json['nextState']),
      scheme: serializer.fromJson<String?>(json['scheme']),
      host: serializer.fromJson<String?>(json['host']),
      port: serializer.fromJson<int?>(json['port']),
      message: serializer.fromJson<String?>(json['message']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventType': serializer.toJson<String>(eventType),
      'previousState': serializer.toJson<String?>(previousState),
      'nextState': serializer.toJson<String?>(nextState),
      'scheme': serializer.toJson<String?>(scheme),
      'host': serializer.toJson<String?>(host),
      'port': serializer.toJson<int?>(port),
      'message': serializer.toJson<String?>(message),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProxyRuntimeLog copyWith({
    int? id,
    String? eventType,
    Value<String?> previousState = const Value.absent(),
    Value<String?> nextState = const Value.absent(),
    Value<String?> scheme = const Value.absent(),
    Value<String?> host = const Value.absent(),
    Value<int?> port = const Value.absent(),
    Value<String?> message = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
  }) => ProxyRuntimeLog(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    previousState: previousState.present
        ? previousState.value
        : this.previousState,
    nextState: nextState.present ? nextState.value : this.nextState,
    scheme: scheme.present ? scheme.value : this.scheme,
    host: host.present ? host.value : this.host,
    port: port.present ? port.value : this.port,
    message: message.present ? message.value : this.message,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
  );
  ProxyRuntimeLog copyWithCompanion(ProxyRuntimeLogsCompanion data) {
    return ProxyRuntimeLog(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      previousState: data.previousState.present
          ? data.previousState.value
          : this.previousState,
      nextState: data.nextState.present ? data.nextState.value : this.nextState,
      scheme: data.scheme.present ? data.scheme.value : this.scheme,
      host: data.host.present ? data.host.value : this.host,
      port: data.port.present ? data.port.value : this.port,
      message: data.message.present ? data.message.value : this.message,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProxyRuntimeLog(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('previousState: $previousState, ')
          ..write('nextState: $nextState, ')
          ..write('scheme: $scheme, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('message: $message, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventType,
    previousState,
    nextState,
    scheme,
    host,
    port,
    message,
    errorMessage,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProxyRuntimeLog &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.previousState == this.previousState &&
          other.nextState == this.nextState &&
          other.scheme == this.scheme &&
          other.host == this.host &&
          other.port == this.port &&
          other.message == this.message &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt);
}

class ProxyRuntimeLogsCompanion extends UpdateCompanion<ProxyRuntimeLog> {
  final Value<int> id;
  final Value<String> eventType;
  final Value<String?> previousState;
  final Value<String?> nextState;
  final Value<String?> scheme;
  final Value<String?> host;
  final Value<int?> port;
  final Value<String?> message;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  const ProxyRuntimeLogsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.previousState = const Value.absent(),
    this.nextState = const Value.absent(),
    this.scheme = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.message = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProxyRuntimeLogsCompanion.insert({
    this.id = const Value.absent(),
    required String eventType,
    this.previousState = const Value.absent(),
    this.nextState = const Value.absent(),
    this.scheme = const Value.absent(),
    this.host = const Value.absent(),
    this.port = const Value.absent(),
    this.message = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : eventType = Value(eventType);
  static Insertable<ProxyRuntimeLog> custom({
    Expression<int>? id,
    Expression<String>? eventType,
    Expression<String>? previousState,
    Expression<String>? nextState,
    Expression<String>? scheme,
    Expression<String>? host,
    Expression<int>? port,
    Expression<String>? message,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (previousState != null) 'previous_state': previousState,
      if (nextState != null) 'next_state': nextState,
      if (scheme != null) 'scheme': scheme,
      if (host != null) 'host': host,
      if (port != null) 'port': port,
      if (message != null) 'message': message,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProxyRuntimeLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventType,
    Value<String?>? previousState,
    Value<String?>? nextState,
    Value<String?>? scheme,
    Value<String?>? host,
    Value<int?>? port,
    Value<String?>? message,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
  }) {
    return ProxyRuntimeLogsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      previousState: previousState ?? this.previousState,
      nextState: nextState ?? this.nextState,
      scheme: scheme ?? this.scheme,
      host: host ?? this.host,
      port: port ?? this.port,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (previousState.present) {
      map['previous_state'] = Variable<String>(previousState.value);
    }
    if (nextState.present) {
      map['next_state'] = Variable<String>(nextState.value);
    }
    if (scheme.present) {
      map['scheme'] = Variable<String>(scheme.value);
    }
    if (host.present) {
      map['host'] = Variable<String>(host.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProxyRuntimeLogsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('previousState: $previousState, ')
          ..write('nextState: $nextState, ')
          ..write('scheme: $scheme, ')
          ..write('host: $host, ')
          ..write('port: $port, ')
          ..write('message: $message, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $BalanceSnapshotsTable balanceSnapshots = $BalanceSnapshotsTable(
    this,
  );
  late final $UsageLogsTable usageLogs = $UsageLogsTable(this);
  late final $ModelPricesTable modelPrices = $ModelPricesTable(this);
  late final $AlertRulesTable alertRules = $AlertRulesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ProviderCapabilitiesTable providerCapabilities =
      $ProviderCapabilitiesTable(this);
  late final $SchemaMigrationLogsTable schemaMigrationLogs =
      $SchemaMigrationLogsTable(this);
  late final $ProxyRuntimeLogsTable proxyRuntimeLogs = $ProxyRuntimeLogsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    balanceSnapshots,
    usageLogs,
    modelPrices,
    alertRules,
    appSettings,
    providerCapabilities,
    schemaMigrationLogs,
    proxyRuntimeLogs,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required String providerType,
      required String displayName,
      required String baseUrl,
      Value<String?> apiKeyAlias,
      Value<String> currency,
      Value<bool> enabled,
      Value<bool> proxyEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<String> providerType,
      Value<String> displayName,
      Value<String> baseUrl,
      Value<String?> apiKeyAlias,
      Value<String> currency,
      Value<bool> enabled,
      Value<bool> proxyEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BalanceSnapshotsTable, List<BalanceSnapshot>>
  _balanceSnapshotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.balanceSnapshots,
    aliasName: $_aliasNameGenerator(
      db.accounts.id,
      db.balanceSnapshots.accountId,
    ),
  );

  $$BalanceSnapshotsTableProcessedTableManager get balanceSnapshotsRefs {
    final manager = $$BalanceSnapshotsTableTableManager(
      $_db,
      $_db.balanceSnapshots,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _balanceSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UsageLogsTable, List<UsageLog>>
  _usageLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.usageLogs,
    aliasName: $_aliasNameGenerator(db.accounts.id, db.usageLogs.accountId),
  );

  $$UsageLogsTableProcessedTableManager get usageLogsRefs {
    final manager = $$UsageLogsTableTableManager(
      $_db,
      $_db.usageLogs,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_usageLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AlertRulesTable, List<AlertRule>>
  _alertRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.alertRules,
    aliasName: $_aliasNameGenerator(db.accounts.id, db.alertRules.accountId),
  );

  $$AlertRulesTableProcessedTableManager get alertRulesRefs {
    final manager = $$AlertRulesTableTableManager(
      $_db,
      $_db.alertRules,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_alertRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apiKeyAlias => $composableBuilder(
    column: $table.apiKeyAlias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get proxyEnabled => $composableBuilder(
    column: $table.proxyEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> balanceSnapshotsRefs(
    Expression<bool> Function($$BalanceSnapshotsTableFilterComposer f) f,
  ) {
    final $$BalanceSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceSnapshots,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BalanceSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.balanceSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> usageLogsRefs(
    Expression<bool> Function($$UsageLogsTableFilterComposer f) f,
  ) {
    final $$UsageLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usageLogs,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageLogsTableFilterComposer(
            $db: $db,
            $table: $db.usageLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> alertRulesRefs(
    Expression<bool> Function($$AlertRulesTableFilterComposer f) f,
  ) {
    final $$AlertRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alertRules,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlertRulesTableFilterComposer(
            $db: $db,
            $table: $db.alertRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrl => $composableBuilder(
    column: $table.baseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apiKeyAlias => $composableBuilder(
    column: $table.apiKeyAlias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get proxyEnabled => $composableBuilder(
    column: $table.proxyEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get apiKeyAlias => $composableBuilder(
    column: $table.apiKeyAlias,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get proxyEnabled => $composableBuilder(
    column: $table.proxyEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> balanceSnapshotsRefs<T extends Object>(
    Expression<T> Function($$BalanceSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$BalanceSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceSnapshots,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BalanceSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.balanceSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> usageLogsRefs<T extends Object>(
    Expression<T> Function($$UsageLogsTableAnnotationComposer a) f,
  ) {
    final $$UsageLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.usageLogs,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsageLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.usageLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> alertRulesRefs<T extends Object>(
    Expression<T> Function($$AlertRulesTableAnnotationComposer a) f,
  ) {
    final $$AlertRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alertRules,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlertRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.alertRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool balanceSnapshotsRefs,
            bool usageLogsRefs,
            bool alertRulesRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> providerType = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> baseUrl = const Value.absent(),
                Value<String?> apiKeyAlias = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> proxyEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                providerType: providerType,
                displayName: displayName,
                baseUrl: baseUrl,
                apiKeyAlias: apiKeyAlias,
                currency: currency,
                enabled: enabled,
                proxyEnabled: proxyEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String providerType,
                required String displayName,
                required String baseUrl,
                Value<String?> apiKeyAlias = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> proxyEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                providerType: providerType,
                displayName: displayName,
                baseUrl: baseUrl,
                apiKeyAlias: apiKeyAlias,
                currency: currency,
                enabled: enabled,
                proxyEnabled: proxyEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                balanceSnapshotsRefs = false,
                usageLogsRefs = false,
                alertRulesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (balanceSnapshotsRefs) db.balanceSnapshots,
                    if (usageLogsRefs) db.usageLogs,
                    if (alertRulesRefs) db.alertRules,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (balanceSnapshotsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          BalanceSnapshot
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._balanceSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).balanceSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (usageLogsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          UsageLog
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._usageLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).usageLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (alertRulesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          AlertRule
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._alertRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).alertRulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool balanceSnapshotsRefs,
        bool usageLogsRefs,
        bool alertRulesRefs,
      })
    >;
typedef $$BalanceSnapshotsTableCreateCompanionBuilder =
    BalanceSnapshotsCompanion Function({
      Value<int> id,
      required int accountId,
      Value<double?> totalBalance,
      Value<double?> usedBalance,
      Value<double?> remainingBalance,
      Value<double?> grantedBalance,
      Value<double?> toppedUpBalance,
      required String currency,
      Value<bool?> isAvailable,
      required DateTime fetchedAt,
      required String source,
    });
typedef $$BalanceSnapshotsTableUpdateCompanionBuilder =
    BalanceSnapshotsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<double?> totalBalance,
      Value<double?> usedBalance,
      Value<double?> remainingBalance,
      Value<double?> grantedBalance,
      Value<double?> toppedUpBalance,
      Value<String> currency,
      Value<bool?> isAvailable,
      Value<DateTime> fetchedAt,
      Value<String> source,
    });

final class $$BalanceSnapshotsTableReferences
    extends
        BaseReferences<_$AppDatabase, $BalanceSnapshotsTable, BalanceSnapshot> {
  $$BalanceSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.balanceSnapshots.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BalanceSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalBalance => $composableBuilder(
    column: $table.totalBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get usedBalance => $composableBuilder(
    column: $table.usedBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grantedBalance => $composableBuilder(
    column: $table.grantedBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get toppedUpBalance => $composableBuilder(
    column: $table.toppedUpBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BalanceSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalBalance => $composableBuilder(
    column: $table.totalBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get usedBalance => $composableBuilder(
    column: $table.usedBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grantedBalance => $composableBuilder(
    column: $table.grantedBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get toppedUpBalance => $composableBuilder(
    column: $table.toppedUpBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BalanceSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalBalance => $composableBuilder(
    column: $table.totalBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get usedBalance => $composableBuilder(
    column: $table.usedBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get grantedBalance => $composableBuilder(
    column: $table.grantedBalance,
    builder: (column) => column,
  );

  GeneratedColumn<double> get toppedUpBalance => $composableBuilder(
    column: $table.toppedUpBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
    column: $table.isAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BalanceSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BalanceSnapshotsTable,
          BalanceSnapshot,
          $$BalanceSnapshotsTableFilterComposer,
          $$BalanceSnapshotsTableOrderingComposer,
          $$BalanceSnapshotsTableAnnotationComposer,
          $$BalanceSnapshotsTableCreateCompanionBuilder,
          $$BalanceSnapshotsTableUpdateCompanionBuilder,
          (BalanceSnapshot, $$BalanceSnapshotsTableReferences),
          BalanceSnapshot,
          PrefetchHooks Function({bool accountId})
        > {
  $$BalanceSnapshotsTableTableManager(
    _$AppDatabase db,
    $BalanceSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BalanceSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BalanceSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BalanceSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<double?> totalBalance = const Value.absent(),
                Value<double?> usedBalance = const Value.absent(),
                Value<double?> remainingBalance = const Value.absent(),
                Value<double?> grantedBalance = const Value.absent(),
                Value<double?> toppedUpBalance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool?> isAvailable = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => BalanceSnapshotsCompanion(
                id: id,
                accountId: accountId,
                totalBalance: totalBalance,
                usedBalance: usedBalance,
                remainingBalance: remainingBalance,
                grantedBalance: grantedBalance,
                toppedUpBalance: toppedUpBalance,
                currency: currency,
                isAvailable: isAvailable,
                fetchedAt: fetchedAt,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                Value<double?> totalBalance = const Value.absent(),
                Value<double?> usedBalance = const Value.absent(),
                Value<double?> remainingBalance = const Value.absent(),
                Value<double?> grantedBalance = const Value.absent(),
                Value<double?> toppedUpBalance = const Value.absent(),
                required String currency,
                Value<bool?> isAvailable = const Value.absent(),
                required DateTime fetchedAt,
                required String source,
              }) => BalanceSnapshotsCompanion.insert(
                id: id,
                accountId: accountId,
                totalBalance: totalBalance,
                usedBalance: usedBalance,
                remainingBalance: remainingBalance,
                grantedBalance: grantedBalance,
                toppedUpBalance: toppedUpBalance,
                currency: currency,
                isAvailable: isAvailable,
                fetchedAt: fetchedAt,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BalanceSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable:
                                    $$BalanceSnapshotsTableReferences
                                        ._accountIdTable(db),
                                referencedColumn:
                                    $$BalanceSnapshotsTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BalanceSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BalanceSnapshotsTable,
      BalanceSnapshot,
      $$BalanceSnapshotsTableFilterComposer,
      $$BalanceSnapshotsTableOrderingComposer,
      $$BalanceSnapshotsTableAnnotationComposer,
      $$BalanceSnapshotsTableCreateCompanionBuilder,
      $$BalanceSnapshotsTableUpdateCompanionBuilder,
      (BalanceSnapshot, $$BalanceSnapshotsTableReferences),
      BalanceSnapshot,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$UsageLogsTableCreateCompanionBuilder =
    UsageLogsCompanion Function({
      Value<int> id,
      required int accountId,
      required String providerType,
      required String modelName,
      required DateTime requestTime,
      Value<int?> promptTokens,
      Value<int?> completionTokens,
      Value<int?> cachedTokens,
      Value<int?> reasoningTokens,
      Value<int?> totalTokens,
      Value<bool> estimated,
      Value<bool> lowConfidence,
      Value<String?> estimatorName,
      Value<double?> cost,
      required String currency,
      Value<int?> statusCode,
      required String requestStatus,
      Value<String?> errorMessage,
      required String source,
      Value<DateTime> createdAt,
    });
typedef $$UsageLogsTableUpdateCompanionBuilder =
    UsageLogsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<String> providerType,
      Value<String> modelName,
      Value<DateTime> requestTime,
      Value<int?> promptTokens,
      Value<int?> completionTokens,
      Value<int?> cachedTokens,
      Value<int?> reasoningTokens,
      Value<int?> totalTokens,
      Value<bool> estimated,
      Value<bool> lowConfidence,
      Value<String?> estimatorName,
      Value<double?> cost,
      Value<String> currency,
      Value<int?> statusCode,
      Value<String> requestStatus,
      Value<String?> errorMessage,
      Value<String> source,
      Value<DateTime> createdAt,
    });

final class $$UsageLogsTableReferences
    extends BaseReferences<_$AppDatabase, $UsageLogsTable, UsageLog> {
  $$UsageLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.usageLogs.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UsageLogsTableFilterComposer
    extends Composer<_$AppDatabase, $UsageLogsTable> {
  $$UsageLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get requestTime => $composableBuilder(
    column: $table.requestTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get promptTokens => $composableBuilder(
    column: $table.promptTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completionTokens => $composableBuilder(
    column: $table.completionTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cachedTokens => $composableBuilder(
    column: $table.cachedTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reasoningTokens => $composableBuilder(
    column: $table.reasoningTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTokens => $composableBuilder(
    column: $table.totalTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estimated => $composableBuilder(
    column: $table.estimated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lowConfidence => $composableBuilder(
    column: $table.lowConfidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estimatorName => $composableBuilder(
    column: $table.estimatorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestStatus => $composableBuilder(
    column: $table.requestStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsageLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageLogsTable> {
  $$UsageLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get requestTime => $composableBuilder(
    column: $table.requestTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get promptTokens => $composableBuilder(
    column: $table.promptTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completionTokens => $composableBuilder(
    column: $table.completionTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cachedTokens => $composableBuilder(
    column: $table.cachedTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reasoningTokens => $composableBuilder(
    column: $table.reasoningTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTokens => $composableBuilder(
    column: $table.totalTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estimated => $composableBuilder(
    column: $table.estimated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lowConfidence => $composableBuilder(
    column: $table.lowConfidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estimatorName => $composableBuilder(
    column: $table.estimatorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestStatus => $composableBuilder(
    column: $table.requestStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsageLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageLogsTable> {
  $$UsageLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<DateTime> get requestTime => $composableBuilder(
    column: $table.requestTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get promptTokens => $composableBuilder(
    column: $table.promptTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get completionTokens => $composableBuilder(
    column: $table.completionTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cachedTokens => $composableBuilder(
    column: $table.cachedTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reasoningTokens => $composableBuilder(
    column: $table.reasoningTokens,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTokens => $composableBuilder(
    column: $table.totalTokens,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get estimated =>
      $composableBuilder(column: $table.estimated, builder: (column) => column);

  GeneratedColumn<bool> get lowConfidence => $composableBuilder(
    column: $table.lowConfidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estimatorName => $composableBuilder(
    column: $table.estimatorName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestStatus => $composableBuilder(
    column: $table.requestStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UsageLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageLogsTable,
          UsageLog,
          $$UsageLogsTableFilterComposer,
          $$UsageLogsTableOrderingComposer,
          $$UsageLogsTableAnnotationComposer,
          $$UsageLogsTableCreateCompanionBuilder,
          $$UsageLogsTableUpdateCompanionBuilder,
          (UsageLog, $$UsageLogsTableReferences),
          UsageLog,
          PrefetchHooks Function({bool accountId})
        > {
  $$UsageLogsTableTableManager(_$AppDatabase db, $UsageLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<String> providerType = const Value.absent(),
                Value<String> modelName = const Value.absent(),
                Value<DateTime> requestTime = const Value.absent(),
                Value<int?> promptTokens = const Value.absent(),
                Value<int?> completionTokens = const Value.absent(),
                Value<int?> cachedTokens = const Value.absent(),
                Value<int?> reasoningTokens = const Value.absent(),
                Value<int?> totalTokens = const Value.absent(),
                Value<bool> estimated = const Value.absent(),
                Value<bool> lowConfidence = const Value.absent(),
                Value<String?> estimatorName = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int?> statusCode = const Value.absent(),
                Value<String> requestStatus = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsageLogsCompanion(
                id: id,
                accountId: accountId,
                providerType: providerType,
                modelName: modelName,
                requestTime: requestTime,
                promptTokens: promptTokens,
                completionTokens: completionTokens,
                cachedTokens: cachedTokens,
                reasoningTokens: reasoningTokens,
                totalTokens: totalTokens,
                estimated: estimated,
                lowConfidence: lowConfidence,
                estimatorName: estimatorName,
                cost: cost,
                currency: currency,
                statusCode: statusCode,
                requestStatus: requestStatus,
                errorMessage: errorMessage,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required String providerType,
                required String modelName,
                required DateTime requestTime,
                Value<int?> promptTokens = const Value.absent(),
                Value<int?> completionTokens = const Value.absent(),
                Value<int?> cachedTokens = const Value.absent(),
                Value<int?> reasoningTokens = const Value.absent(),
                Value<int?> totalTokens = const Value.absent(),
                Value<bool> estimated = const Value.absent(),
                Value<bool> lowConfidence = const Value.absent(),
                Value<String?> estimatorName = const Value.absent(),
                Value<double?> cost = const Value.absent(),
                required String currency,
                Value<int?> statusCode = const Value.absent(),
                required String requestStatus,
                Value<String?> errorMessage = const Value.absent(),
                required String source,
                Value<DateTime> createdAt = const Value.absent(),
              }) => UsageLogsCompanion.insert(
                id: id,
                accountId: accountId,
                providerType: providerType,
                modelName: modelName,
                requestTime: requestTime,
                promptTokens: promptTokens,
                completionTokens: completionTokens,
                cachedTokens: cachedTokens,
                reasoningTokens: reasoningTokens,
                totalTokens: totalTokens,
                estimated: estimated,
                lowConfidence: lowConfidence,
                estimatorName: estimatorName,
                cost: cost,
                currency: currency,
                statusCode: statusCode,
                requestStatus: requestStatus,
                errorMessage: errorMessage,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UsageLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$UsageLogsTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$UsageLogsTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UsageLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageLogsTable,
      UsageLog,
      $$UsageLogsTableFilterComposer,
      $$UsageLogsTableOrderingComposer,
      $$UsageLogsTableAnnotationComposer,
      $$UsageLogsTableCreateCompanionBuilder,
      $$UsageLogsTableUpdateCompanionBuilder,
      (UsageLog, $$UsageLogsTableReferences),
      UsageLog,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$ModelPricesTableCreateCompanionBuilder =
    ModelPricesCompanion Function({
      Value<int> id,
      required String providerType,
      required String modelName,
      required double inputPricePer1M,
      required double outputPricePer1M,
      Value<double?> cachedInputPricePer1M,
      Value<double?> reasoningOutputPricePer1M,
      Value<String> currency,
      Value<DateTime?> effectiveFrom,
      Value<DateTime?> effectiveTo,
      Value<String?> sourceNote,
      Value<bool> userEditable,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ModelPricesTableUpdateCompanionBuilder =
    ModelPricesCompanion Function({
      Value<int> id,
      Value<String> providerType,
      Value<String> modelName,
      Value<double> inputPricePer1M,
      Value<double> outputPricePer1M,
      Value<double?> cachedInputPricePer1M,
      Value<double?> reasoningOutputPricePer1M,
      Value<String> currency,
      Value<DateTime?> effectiveFrom,
      Value<DateTime?> effectiveTo,
      Value<String?> sourceNote,
      Value<bool> userEditable,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ModelPricesTableFilterComposer
    extends Composer<_$AppDatabase, $ModelPricesTable> {
  $$ModelPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get inputPricePer1M => $composableBuilder(
    column: $table.inputPricePer1M,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get outputPricePer1M => $composableBuilder(
    column: $table.outputPricePer1M,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cachedInputPricePer1M => $composableBuilder(
    column: $table.cachedInputPricePer1M,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get reasoningOutputPricePer1M => $composableBuilder(
    column: $table.reasoningOutputPricePer1M,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceNote => $composableBuilder(
    column: $table.sourceNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userEditable => $composableBuilder(
    column: $table.userEditable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ModelPricesTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelPricesTable> {
  $$ModelPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get inputPricePer1M => $composableBuilder(
    column: $table.inputPricePer1M,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get outputPricePer1M => $composableBuilder(
    column: $table.outputPricePer1M,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cachedInputPricePer1M => $composableBuilder(
    column: $table.cachedInputPricePer1M,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get reasoningOutputPricePer1M => $composableBuilder(
    column: $table.reasoningOutputPricePer1M,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceNote => $composableBuilder(
    column: $table.sourceNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userEditable => $composableBuilder(
    column: $table.userEditable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModelPricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelPricesTable> {
  $$ModelPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<double> get inputPricePer1M => $composableBuilder(
    column: $table.inputPricePer1M,
    builder: (column) => column,
  );

  GeneratedColumn<double> get outputPricePer1M => $composableBuilder(
    column: $table.outputPricePer1M,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cachedInputPricePer1M => $composableBuilder(
    column: $table.cachedInputPricePer1M,
    builder: (column) => column,
  );

  GeneratedColumn<double> get reasoningOutputPricePer1M => $composableBuilder(
    column: $table.reasoningOutputPricePer1M,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveFrom => $composableBuilder(
    column: $table.effectiveFrom,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get effectiveTo => $composableBuilder(
    column: $table.effectiveTo,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceNote => $composableBuilder(
    column: $table.sourceNote,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get userEditable => $composableBuilder(
    column: $table.userEditable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ModelPricesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModelPricesTable,
          ModelPrice,
          $$ModelPricesTableFilterComposer,
          $$ModelPricesTableOrderingComposer,
          $$ModelPricesTableAnnotationComposer,
          $$ModelPricesTableCreateCompanionBuilder,
          $$ModelPricesTableUpdateCompanionBuilder,
          (
            ModelPrice,
            BaseReferences<_$AppDatabase, $ModelPricesTable, ModelPrice>,
          ),
          ModelPrice,
          PrefetchHooks Function()
        > {
  $$ModelPricesTableTableManager(_$AppDatabase db, $ModelPricesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> providerType = const Value.absent(),
                Value<String> modelName = const Value.absent(),
                Value<double> inputPricePer1M = const Value.absent(),
                Value<double> outputPricePer1M = const Value.absent(),
                Value<double?> cachedInputPricePer1M = const Value.absent(),
                Value<double?> reasoningOutputPricePer1M = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime?> effectiveFrom = const Value.absent(),
                Value<DateTime?> effectiveTo = const Value.absent(),
                Value<String?> sourceNote = const Value.absent(),
                Value<bool> userEditable = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ModelPricesCompanion(
                id: id,
                providerType: providerType,
                modelName: modelName,
                inputPricePer1M: inputPricePer1M,
                outputPricePer1M: outputPricePer1M,
                cachedInputPricePer1M: cachedInputPricePer1M,
                reasoningOutputPricePer1M: reasoningOutputPricePer1M,
                currency: currency,
                effectiveFrom: effectiveFrom,
                effectiveTo: effectiveTo,
                sourceNote: sourceNote,
                userEditable: userEditable,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String providerType,
                required String modelName,
                required double inputPricePer1M,
                required double outputPricePer1M,
                Value<double?> cachedInputPricePer1M = const Value.absent(),
                Value<double?> reasoningOutputPricePer1M = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime?> effectiveFrom = const Value.absent(),
                Value<DateTime?> effectiveTo = const Value.absent(),
                Value<String?> sourceNote = const Value.absent(),
                Value<bool> userEditable = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ModelPricesCompanion.insert(
                id: id,
                providerType: providerType,
                modelName: modelName,
                inputPricePer1M: inputPricePer1M,
                outputPricePer1M: outputPricePer1M,
                cachedInputPricePer1M: cachedInputPricePer1M,
                reasoningOutputPricePer1M: reasoningOutputPricePer1M,
                currency: currency,
                effectiveFrom: effectiveFrom,
                effectiveTo: effectiveTo,
                sourceNote: sourceNote,
                userEditable: userEditable,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ModelPricesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModelPricesTable,
      ModelPrice,
      $$ModelPricesTableFilterComposer,
      $$ModelPricesTableOrderingComposer,
      $$ModelPricesTableAnnotationComposer,
      $$ModelPricesTableCreateCompanionBuilder,
      $$ModelPricesTableUpdateCompanionBuilder,
      (
        ModelPrice,
        BaseReferences<_$AppDatabase, $ModelPricesTable, ModelPrice>,
      ),
      ModelPrice,
      PrefetchHooks Function()
    >;
typedef $$AlertRulesTableCreateCompanionBuilder =
    AlertRulesCompanion Function({
      Value<int> id,
      required String alertType,
      required double threshold,
      Value<String?> providerType,
      Value<int?> accountId,
      Value<bool> enabled,
      Value<DateTime> createdAt,
    });
typedef $$AlertRulesTableUpdateCompanionBuilder =
    AlertRulesCompanion Function({
      Value<int> id,
      Value<String> alertType,
      Value<double> threshold,
      Value<String?> providerType,
      Value<int?> accountId,
      Value<bool> enabled,
      Value<DateTime> createdAt,
    });

final class $$AlertRulesTableReferences
    extends BaseReferences<_$AppDatabase, $AlertRulesTable, AlertRule> {
  $$AlertRulesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.alertRules.accountId, db.accounts.id),
      );

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AlertRulesTableFilterComposer
    extends Composer<_$AppDatabase, $AlertRulesTable> {
  $$AlertRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alertType => $composableBuilder(
    column: $table.alertType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertRulesTable> {
  $$AlertRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alertType => $composableBuilder(
    column: $table.alertType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get threshold => $composableBuilder(
    column: $table.threshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertRulesTable> {
  $$AlertRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get alertType =>
      $composableBuilder(column: $table.alertType, builder: (column) => column);

  GeneratedColumn<double> get threshold =>
      $composableBuilder(column: $table.threshold, builder: (column) => column);

  GeneratedColumn<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertRulesTable,
          AlertRule,
          $$AlertRulesTableFilterComposer,
          $$AlertRulesTableOrderingComposer,
          $$AlertRulesTableAnnotationComposer,
          $$AlertRulesTableCreateCompanionBuilder,
          $$AlertRulesTableUpdateCompanionBuilder,
          (AlertRule, $$AlertRulesTableReferences),
          AlertRule,
          PrefetchHooks Function({bool accountId})
        > {
  $$AlertRulesTableTableManager(_$AppDatabase db, $AlertRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> alertType = const Value.absent(),
                Value<double> threshold = const Value.absent(),
                Value<String?> providerType = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AlertRulesCompanion(
                id: id,
                alertType: alertType,
                threshold: threshold,
                providerType: providerType,
                accountId: accountId,
                enabled: enabled,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String alertType,
                required double threshold,
                Value<String?> providerType = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AlertRulesCompanion.insert(
                id: id,
                alertType: alertType,
                threshold: threshold,
                providerType: providerType,
                accountId: accountId,
                enabled: enabled,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AlertRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$AlertRulesTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$AlertRulesTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AlertRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertRulesTable,
      AlertRule,
      $$AlertRulesTableFilterComposer,
      $$AlertRulesTableOrderingComposer,
      $$AlertRulesTableAnnotationComposer,
      $$AlertRulesTableCreateCompanionBuilder,
      $$AlertRulesTableUpdateCompanionBuilder,
      (AlertRule, $$AlertRulesTableReferences),
      AlertRule,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      Value<String?> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$ProviderCapabilitiesTableCreateCompanionBuilder =
    ProviderCapabilitiesCompanion Function({
      Value<int> id,
      required String providerType,
      Value<bool> supportsBalanceQuery,
      Value<bool> supportsModelList,
      Value<bool> supportsUsageParsing,
      Value<bool> supportsStreaming,
      Value<bool> requiresManualQuota,
      Value<String?> baseUrlTemplate,
      Value<DateTime> updatedAt,
    });
typedef $$ProviderCapabilitiesTableUpdateCompanionBuilder =
    ProviderCapabilitiesCompanion Function({
      Value<int> id,
      Value<String> providerType,
      Value<bool> supportsBalanceQuery,
      Value<bool> supportsModelList,
      Value<bool> supportsUsageParsing,
      Value<bool> supportsStreaming,
      Value<bool> requiresManualQuota,
      Value<String?> baseUrlTemplate,
      Value<DateTime> updatedAt,
    });

class $$ProviderCapabilitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ProviderCapabilitiesTable> {
  $$ProviderCapabilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsBalanceQuery => $composableBuilder(
    column: $table.supportsBalanceQuery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsModelList => $composableBuilder(
    column: $table.supportsModelList,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsUsageParsing => $composableBuilder(
    column: $table.supportsUsageParsing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get supportsStreaming => $composableBuilder(
    column: $table.supportsStreaming,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresManualQuota => $composableBuilder(
    column: $table.requiresManualQuota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUrlTemplate => $composableBuilder(
    column: $table.baseUrlTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProviderCapabilitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProviderCapabilitiesTable> {
  $$ProviderCapabilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsBalanceQuery => $composableBuilder(
    column: $table.supportsBalanceQuery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsModelList => $composableBuilder(
    column: $table.supportsModelList,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsUsageParsing => $composableBuilder(
    column: $table.supportsUsageParsing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get supportsStreaming => $composableBuilder(
    column: $table.supportsStreaming,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresManualQuota => $composableBuilder(
    column: $table.requiresManualQuota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUrlTemplate => $composableBuilder(
    column: $table.baseUrlTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProviderCapabilitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProviderCapabilitiesTable> {
  $$ProviderCapabilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get supportsBalanceQuery => $composableBuilder(
    column: $table.supportsBalanceQuery,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get supportsModelList => $composableBuilder(
    column: $table.supportsModelList,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get supportsUsageParsing => $composableBuilder(
    column: $table.supportsUsageParsing,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get supportsStreaming => $composableBuilder(
    column: $table.supportsStreaming,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresManualQuota => $composableBuilder(
    column: $table.requiresManualQuota,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseUrlTemplate => $composableBuilder(
    column: $table.baseUrlTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProviderCapabilitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProviderCapabilitiesTable,
          ProviderCapability,
          $$ProviderCapabilitiesTableFilterComposer,
          $$ProviderCapabilitiesTableOrderingComposer,
          $$ProviderCapabilitiesTableAnnotationComposer,
          $$ProviderCapabilitiesTableCreateCompanionBuilder,
          $$ProviderCapabilitiesTableUpdateCompanionBuilder,
          (
            ProviderCapability,
            BaseReferences<
              _$AppDatabase,
              $ProviderCapabilitiesTable,
              ProviderCapability
            >,
          ),
          ProviderCapability,
          PrefetchHooks Function()
        > {
  $$ProviderCapabilitiesTableTableManager(
    _$AppDatabase db,
    $ProviderCapabilitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProviderCapabilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProviderCapabilitiesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProviderCapabilitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> providerType = const Value.absent(),
                Value<bool> supportsBalanceQuery = const Value.absent(),
                Value<bool> supportsModelList = const Value.absent(),
                Value<bool> supportsUsageParsing = const Value.absent(),
                Value<bool> supportsStreaming = const Value.absent(),
                Value<bool> requiresManualQuota = const Value.absent(),
                Value<String?> baseUrlTemplate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProviderCapabilitiesCompanion(
                id: id,
                providerType: providerType,
                supportsBalanceQuery: supportsBalanceQuery,
                supportsModelList: supportsModelList,
                supportsUsageParsing: supportsUsageParsing,
                supportsStreaming: supportsStreaming,
                requiresManualQuota: requiresManualQuota,
                baseUrlTemplate: baseUrlTemplate,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String providerType,
                Value<bool> supportsBalanceQuery = const Value.absent(),
                Value<bool> supportsModelList = const Value.absent(),
                Value<bool> supportsUsageParsing = const Value.absent(),
                Value<bool> supportsStreaming = const Value.absent(),
                Value<bool> requiresManualQuota = const Value.absent(),
                Value<String?> baseUrlTemplate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProviderCapabilitiesCompanion.insert(
                id: id,
                providerType: providerType,
                supportsBalanceQuery: supportsBalanceQuery,
                supportsModelList: supportsModelList,
                supportsUsageParsing: supportsUsageParsing,
                supportsStreaming: supportsStreaming,
                requiresManualQuota: requiresManualQuota,
                baseUrlTemplate: baseUrlTemplate,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProviderCapabilitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProviderCapabilitiesTable,
      ProviderCapability,
      $$ProviderCapabilitiesTableFilterComposer,
      $$ProviderCapabilitiesTableOrderingComposer,
      $$ProviderCapabilitiesTableAnnotationComposer,
      $$ProviderCapabilitiesTableCreateCompanionBuilder,
      $$ProviderCapabilitiesTableUpdateCompanionBuilder,
      (
        ProviderCapability,
        BaseReferences<
          _$AppDatabase,
          $ProviderCapabilitiesTable,
          ProviderCapability
        >,
      ),
      ProviderCapability,
      PrefetchHooks Function()
    >;
typedef $$SchemaMigrationLogsTableCreateCompanionBuilder =
    SchemaMigrationLogsCompanion Function({
      Value<int> id,
      required int fromVersion,
      required int toVersion,
      Value<DateTime> migratedAt,
      required bool success,
      Value<String?> errorMessage,
    });
typedef $$SchemaMigrationLogsTableUpdateCompanionBuilder =
    SchemaMigrationLogsCompanion Function({
      Value<int> id,
      Value<int> fromVersion,
      Value<int> toVersion,
      Value<DateTime> migratedAt,
      Value<bool> success,
      Value<String?> errorMessage,
    });

class $$SchemaMigrationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SchemaMigrationLogsTable> {
  $$SchemaMigrationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromVersion => $composableBuilder(
    column: $table.fromVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toVersion => $composableBuilder(
    column: $table.toVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchemaMigrationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchemaMigrationLogsTable> {
  $$SchemaMigrationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromVersion => $composableBuilder(
    column: $table.fromVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toVersion => $composableBuilder(
    column: $table.toVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchemaMigrationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchemaMigrationLogsTable> {
  $$SchemaMigrationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fromVersion => $composableBuilder(
    column: $table.fromVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get toVersion =>
      $composableBuilder(column: $table.toVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get migratedAt => $composableBuilder(
    column: $table.migratedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get success =>
      $composableBuilder(column: $table.success, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );
}

class $$SchemaMigrationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchemaMigrationLogsTable,
          SchemaMigrationLog,
          $$SchemaMigrationLogsTableFilterComposer,
          $$SchemaMigrationLogsTableOrderingComposer,
          $$SchemaMigrationLogsTableAnnotationComposer,
          $$SchemaMigrationLogsTableCreateCompanionBuilder,
          $$SchemaMigrationLogsTableUpdateCompanionBuilder,
          (
            SchemaMigrationLog,
            BaseReferences<
              _$AppDatabase,
              $SchemaMigrationLogsTable,
              SchemaMigrationLog
            >,
          ),
          SchemaMigrationLog,
          PrefetchHooks Function()
        > {
  $$SchemaMigrationLogsTableTableManager(
    _$AppDatabase db,
    $SchemaMigrationLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchemaMigrationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchemaMigrationLogsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SchemaMigrationLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fromVersion = const Value.absent(),
                Value<int> toVersion = const Value.absent(),
                Value<DateTime> migratedAt = const Value.absent(),
                Value<bool> success = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
              }) => SchemaMigrationLogsCompanion(
                id: id,
                fromVersion: fromVersion,
                toVersion: toVersion,
                migratedAt: migratedAt,
                success: success,
                errorMessage: errorMessage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fromVersion,
                required int toVersion,
                Value<DateTime> migratedAt = const Value.absent(),
                required bool success,
                Value<String?> errorMessage = const Value.absent(),
              }) => SchemaMigrationLogsCompanion.insert(
                id: id,
                fromVersion: fromVersion,
                toVersion: toVersion,
                migratedAt: migratedAt,
                success: success,
                errorMessage: errorMessage,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchemaMigrationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchemaMigrationLogsTable,
      SchemaMigrationLog,
      $$SchemaMigrationLogsTableFilterComposer,
      $$SchemaMigrationLogsTableOrderingComposer,
      $$SchemaMigrationLogsTableAnnotationComposer,
      $$SchemaMigrationLogsTableCreateCompanionBuilder,
      $$SchemaMigrationLogsTableUpdateCompanionBuilder,
      (
        SchemaMigrationLog,
        BaseReferences<
          _$AppDatabase,
          $SchemaMigrationLogsTable,
          SchemaMigrationLog
        >,
      ),
      SchemaMigrationLog,
      PrefetchHooks Function()
    >;
typedef $$ProxyRuntimeLogsTableCreateCompanionBuilder =
    ProxyRuntimeLogsCompanion Function({
      Value<int> id,
      required String eventType,
      Value<String?> previousState,
      Value<String?> nextState,
      Value<String?> scheme,
      Value<String?> host,
      Value<int?> port,
      Value<String?> message,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
    });
typedef $$ProxyRuntimeLogsTableUpdateCompanionBuilder =
    ProxyRuntimeLogsCompanion Function({
      Value<int> id,
      Value<String> eventType,
      Value<String?> previousState,
      Value<String?> nextState,
      Value<String?> scheme,
      Value<String?> host,
      Value<int?> port,
      Value<String?> message,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
    });

class $$ProxyRuntimeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ProxyRuntimeLogsTable> {
  $$ProxyRuntimeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextState => $composableBuilder(
    column: $table.nextState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scheme => $composableBuilder(
    column: $table.scheme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProxyRuntimeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProxyRuntimeLogsTable> {
  $$ProxyRuntimeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextState => $composableBuilder(
    column: $table.nextState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scheme => $composableBuilder(
    column: $table.scheme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get host => $composableBuilder(
    column: $table.host,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProxyRuntimeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProxyRuntimeLogsTable> {
  $$ProxyRuntimeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get previousState => $composableBuilder(
    column: $table.previousState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextState =>
      $composableBuilder(column: $table.nextState, builder: (column) => column);

  GeneratedColumn<String> get scheme =>
      $composableBuilder(column: $table.scheme, builder: (column) => column);

  GeneratedColumn<String> get host =>
      $composableBuilder(column: $table.host, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProxyRuntimeLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProxyRuntimeLogsTable,
          ProxyRuntimeLog,
          $$ProxyRuntimeLogsTableFilterComposer,
          $$ProxyRuntimeLogsTableOrderingComposer,
          $$ProxyRuntimeLogsTableAnnotationComposer,
          $$ProxyRuntimeLogsTableCreateCompanionBuilder,
          $$ProxyRuntimeLogsTableUpdateCompanionBuilder,
          (
            ProxyRuntimeLog,
            BaseReferences<
              _$AppDatabase,
              $ProxyRuntimeLogsTable,
              ProxyRuntimeLog
            >,
          ),
          ProxyRuntimeLog,
          PrefetchHooks Function()
        > {
  $$ProxyRuntimeLogsTableTableManager(
    _$AppDatabase db,
    $ProxyRuntimeLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProxyRuntimeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProxyRuntimeLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProxyRuntimeLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String?> previousState = const Value.absent(),
                Value<String?> nextState = const Value.absent(),
                Value<String?> scheme = const Value.absent(),
                Value<String?> host = const Value.absent(),
                Value<int?> port = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProxyRuntimeLogsCompanion(
                id: id,
                eventType: eventType,
                previousState: previousState,
                nextState: nextState,
                scheme: scheme,
                host: host,
                port: port,
                message: message,
                errorMessage: errorMessage,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventType,
                Value<String?> previousState = const Value.absent(),
                Value<String?> nextState = const Value.absent(),
                Value<String?> scheme = const Value.absent(),
                Value<String?> host = const Value.absent(),
                Value<int?> port = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProxyRuntimeLogsCompanion.insert(
                id: id,
                eventType: eventType,
                previousState: previousState,
                nextState: nextState,
                scheme: scheme,
                host: host,
                port: port,
                message: message,
                errorMessage: errorMessage,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProxyRuntimeLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProxyRuntimeLogsTable,
      ProxyRuntimeLog,
      $$ProxyRuntimeLogsTableFilterComposer,
      $$ProxyRuntimeLogsTableOrderingComposer,
      $$ProxyRuntimeLogsTableAnnotationComposer,
      $$ProxyRuntimeLogsTableCreateCompanionBuilder,
      $$ProxyRuntimeLogsTableUpdateCompanionBuilder,
      (
        ProxyRuntimeLog,
        BaseReferences<_$AppDatabase, $ProxyRuntimeLogsTable, ProxyRuntimeLog>,
      ),
      ProxyRuntimeLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$BalanceSnapshotsTableTableManager get balanceSnapshots =>
      $$BalanceSnapshotsTableTableManager(_db, _db.balanceSnapshots);
  $$UsageLogsTableTableManager get usageLogs =>
      $$UsageLogsTableTableManager(_db, _db.usageLogs);
  $$ModelPricesTableTableManager get modelPrices =>
      $$ModelPricesTableTableManager(_db, _db.modelPrices);
  $$AlertRulesTableTableManager get alertRules =>
      $$AlertRulesTableTableManager(_db, _db.alertRules);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ProviderCapabilitiesTableTableManager get providerCapabilities =>
      $$ProviderCapabilitiesTableTableManager(_db, _db.providerCapabilities);
  $$SchemaMigrationLogsTableTableManager get schemaMigrationLogs =>
      $$SchemaMigrationLogsTableTableManager(_db, _db.schemaMigrationLogs);
  $$ProxyRuntimeLogsTableTableManager get proxyRuntimeLogs =>
      $$ProxyRuntimeLogsTableTableManager(_db, _db.proxyRuntimeLogs);
}
