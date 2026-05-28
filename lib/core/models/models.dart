enum ProviderType {
  deepseek,
  openai,
  anthropic,
  gemini,
  openrouter,
  mimo,
  azureOpenAI,
  groq,
  mistral,
  togetherAI,
  fireworksAI,
  perplexity,
  xai,
  cohere,
  cerebras,
  moonshot,
  qwen,
  zhipu,
  siliconFlow,
  volcengineArk,
  tencentHunyuan,
  minimax,
  novita,
  customOpenAI,
}

enum RequestStatus {
  completed,
  interrupted,
  timeout,
  clientCancelled,
  providerError,
  parseError,
  estimatedOnly,
}

enum UsageSource {
  officialApi,
  proxy,
  manualImport,
  localEstimator,
  countTokensApi,
}

enum ProxyRuntimeEventType {
  proxyStarting,
  proxyStarted,
  proxyStopping,
  proxyStopped,
  proxyCrashed,
  proxyDegraded,
  proxyRecovered,
  proxyRestartRequested,
  proxyRestartSuccess,
  proxyRestartFailed,
  portChanged,
  healthCheckSuccess,
  healthCheckFailed,
  sleepResumeDetected,
  networkChangeDetected,
  corsPreflightHandled,
}

enum ProxyState { stopped, starting, running, degraded, stopping, crashed }

class BalanceResult {
  final double? totalBalance;
  final double? usedBalance;
  final double? remainingBalance;
  final double? grantedBalance;
  final double? toppedUpBalance;
  final String currency;
  final bool? isAvailable;
  final DateTime fetchedAt;
  final String source;

  const BalanceResult({
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
}

class ModelInfo {
  final String modelId;
  final String? displayName;
  final String? providerType;
  final Map<String, dynamic>? metadata;

  const ModelInfo({
    required this.modelId,
    this.displayName,
    this.providerType,
    this.metadata,
  });
}

class UsageParseResult {
  final int? promptTokens;
  final int? completionTokens;
  final int? cachedTokens;
  final int? reasoningTokens;
  final int? totalTokens;
  final bool estimated;
  final String? estimatorName;
  final RequestStatus requestStatus;

  const UsageParseResult({
    this.promptTokens,
    this.completionTokens,
    this.cachedTokens,
    this.reasoningTokens,
    this.totalTokens,
    required this.estimated,
    this.estimatorName,
    required this.requestStatus,
  });
}

class TokenEstimateResult {
  final int promptTokens;
  final int completionTokens;
  final int cachedTokens;
  final int reasoningTokens;
  final int totalTokens;
  final bool estimated;
  final bool lowConfidence;
  final String estimatorName;
  final String? estimatorVersion;

  const TokenEstimateResult({
    required this.promptTokens,
    required this.completionTokens,
    required this.cachedTokens,
    required this.reasoningTokens,
    required this.totalTokens,
    required this.estimated,
    required this.lowConfidence,
    required this.estimatorName,
    this.estimatorVersion,
  });
}

class AccountConfig {
  final int? accountId;
  final ProviderType providerType;
  final String displayName;
  final String baseUrl;
  final String? apiKeyAlias;
  final String apiKey;
  final String currency;
  final bool enabled;
  final bool proxyEnabled;

  const AccountConfig({
    this.accountId,
    required this.providerType,
    required this.displayName,
    required this.baseUrl,
    this.apiKeyAlias,
    required this.apiKey,
    required this.currency,
    required this.enabled,
    required this.proxyEnabled,
  });

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'providerType': providerType.name,
      'displayName': displayName,
      'baseUrl': baseUrl,
      'apiKeyAlias': apiKeyAlias,
      'apiKey': apiKey,
      'currency': currency,
      'enabled': enabled,
      'proxyEnabled': proxyEnabled,
    };
  }

  factory AccountConfig.fromMap(Map<String, dynamic> map) {
    return AccountConfig(
      accountId: map['accountId'] as int?,
      providerType: ProviderType.values.firstWhere(
        (e) => e.name == map['providerType'],
        orElse: () => ProviderType.customOpenAI,
      ),
      displayName: map['displayName'] as String,
      baseUrl: map['baseUrl'] as String,
      apiKeyAlias: map['apiKeyAlias'] as String?,
      apiKey: map['apiKey'] as String,
      currency: map['currency'] as String? ?? 'USD',
      enabled: map['enabled'] as bool? ?? true,
      proxyEnabled: map['proxyEnabled'] as bool? ?? true,
    );
  }
}

class ModelPriceConfig {
  final ProviderType providerType;
  final String modelName;
  final double inputPricePer1M;
  final double outputPricePer1M;
  final double? cachedInputPricePer1M;
  final double? reasoningOutputPricePer1M;
  final String currency;

  const ModelPriceConfig({
    required this.providerType,
    required this.modelName,
    required this.inputPricePer1M,
    required this.outputPricePer1M,
    this.cachedInputPricePer1M,
    this.reasoningOutputPricePer1M,
    required this.currency,
  });
}

class ProxyRouteConfig {
  final String pathPrefix;
  final int accountId;
  final String targetBaseUrl;

  const ProxyRouteConfig({
    required this.pathPrefix,
    required this.accountId,
    required this.targetBaseUrl,
  });
}

class ProxySettings {
  final bool enableCors;
  final bool enableHttps;
  final bool enableTokenizerFallback;
  final String requestTimeoutPolicy;
  final int uiRefreshIntervalMs;
  final int maxRetries;
  final int retryBaseIntervalMs;

  const ProxySettings({
    required this.enableCors,
    required this.enableHttps,
    required this.enableTokenizerFallback,
    required this.requestTimeoutPolicy,
    required this.uiRefreshIntervalMs,
    required this.maxRetries,
    required this.retryBaseIntervalMs,
  });
}

sealed class ProxyStatusEvent {
  const ProxyStatusEvent();
}

class ProxyStarted extends ProxyStatusEvent {
  final String host;
  final int port;
  final String scheme;

  const ProxyStarted({
    required this.host,
    required this.port,
    required this.scheme,
  });
}

class ProxyStopped extends ProxyStatusEvent {
  const ProxyStopped();
}

class ProxyError extends ProxyStatusEvent {
  final String message;
  final String? stackTrace;

  const ProxyError({required this.message, this.stackTrace});
}

class ProxyPortChanged extends ProxyStatusEvent {
  final int newPort;
  final String reason;

  const ProxyPortChanged({required this.newPort, required this.reason});
}

class HealthCheckResult {
  final bool ok;
  final String state;
  final String scheme;
  final String host;
  final int port;
  final String database;
  final int pendingQueue;
  final int uptimeMs;
  final String version;

  const HealthCheckResult({
    required this.ok,
    required this.state,
    required this.scheme,
    required this.host,
    required this.port,
    required this.database,
    required this.pendingQueue,
    required this.uptimeMs,
    required this.version,
  });
}
