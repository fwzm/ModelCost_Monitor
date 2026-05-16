import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/models.dart';
import '../adapters/deepseek_adapter.dart';
import '../adapters/mimo_adapter.dart';
import '../adapters/gemini_adapter.dart';
import '../adapters/openrouter_adapter.dart';
import '../adapters/custom_openai_adapter.dart';
import '../sse/sse_parser.dart';

class RequestTimeoutPolicy {
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final bool keepAlive;
  final Duration? idleTimeoutWarning;

  const RequestTimeoutPolicy({
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    this.keepAlive = false,
    this.idleTimeoutWarning,
  });

  static const balanceQuery = RequestTimeoutPolicy(
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 20),
    sendTimeout: Duration(seconds: 10),
  );

  static const streamingCompletion = RequestTimeoutPolicy(
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration.zero,
    sendTimeout: Duration(seconds: 60),
    keepAlive: true,
    idleTimeoutWarning: Duration(seconds: 180),
  );
}

class ProxyRouteConfigInternal {
  final String pathPrefix;
  final int accountId;
  final String targetBaseUrl;
  final ProviderType providerType;

  const ProxyRouteConfigInternal({
    required this.pathPrefix,
    required this.accountId,
    required this.targetBaseUrl,
    required this.providerType,
  });
}

class ProxyServer {
  final String host;
  final int port;
  List<AccountConfig> _accounts;
  List<ModelPriceConfig> _prices;
  final Map<int, dynamic> _adapters = {};
  HttpServer? _server;
  final Function(Map<String, dynamic>)? onUsageLog;
  final Function(Map<String, dynamic>)? onStateChange;
  final Map<String, ProxyRouteConfigInternal> _routes = {};
  ProxyState _state = ProxyState.stopped;
  DateTime? _startTime;
  final bool _enableCors;
  final bool _enableHttps;

  ProxyState get state => _state;
  DateTime? get startTime => _startTime;
  int get actualPort => _server?.port ?? port;
  Duration get uptime => _startTime != null
      ? DateTime.now().difference(_startTime!)
      : Duration.zero;
  String get scheme => _enableHttps ? 'https' : 'http';

  ProxyServer({
    required this.host,
    required this.port,
    required List<AccountConfig> accounts,
    required List<ModelPriceConfig> prices,
    this.onUsageLog,
    this.onStateChange,
    bool enableCors = true,
    bool enableHttps = false,
    List<ProxyRouteConfig> routes = const [],
  }) : _accounts = accounts,
       _prices = prices,
       _enableCors = enableCors,
       _enableHttps = enableHttps {
    _initAdapters();
    _initRoutes(routes);
  }

  void _initRoutes(List<ProxyRouteConfig> routes) {
    _routes.clear();
    for (final route in routes) {
      _routes[route.pathPrefix] = ProxyRouteConfigInternal(
        pathPrefix: route.pathPrefix,
        accountId: route.accountId,
        targetBaseUrl: route.targetBaseUrl,
        providerType: _getProviderTypeForAccount(route.accountId),
      );
    }
  }

  ProviderType _getProviderTypeForAccount(int accountId) {
    final account = _accounts
        .where((a) => a.accountId == accountId)
        .firstOrNull;
    return account?.providerType ?? ProviderType.customOpenAI;
  }

  void updateConfig({
    required List<AccountConfig> accounts,
    required List<ModelPriceConfig> prices,
    required List<ProxyRouteConfig> routes,
  }) {
    _accounts = accounts;
    _prices = prices;
    _initAdapters();
    _initRoutes(routes);
  }

  void _initAdapters() {
    _adapters[ProviderType.deepseek.index] = DeepSeekAdapter();
    _adapters[ProviderType.mimo.index] = MiMoAdapter();
    _adapters[ProviderType.gemini.index] = GeminiAdapter();
    _adapters[ProviderType.openrouter.index] = OpenRouterAdapter();
    _adapters[ProviderType.customOpenAI.index] = CustomOpenAIAdapter();
  }

  Future<int> start() async {
    try {
      _state = ProxyState.starting;
      _startTime = DateTime.now();

      final portsToTry = _candidatePorts(port);
      HttpServer? server;
      Object? lastError;
      for (final candidatePort in portsToTry) {
        try {
          if (_enableHttps) {
            // TODO: Load a user-provided local certificate before enabling HTTPS
            // in production. HTTP loopback remains the safe default.
            server = await HttpServer.bindSecure(
              host,
              candidatePort,
              SecurityContext(),
            );
          } else {
            server = await HttpServer.bind(host, candidatePort);
          }
          break;
        } catch (e) {
          lastError = e;
        }
      }

      if (server == null) {
        throw lastError ?? const SocketException('Unable to bind proxy port');
      }

      _server = server;
      _state = ProxyState.running;

      server.listen(_handleRequest);
      return server.port;
    } catch (e) {
      _state = ProxyState.stopped;
      rethrow;
    }
  }

  List<int> _candidatePorts(int preferredPort) {
    final seen = <int>{};
    final candidates = <int>[];

    void add(int value) {
      if (seen.add(value)) candidates.add(value);
    }

    if (preferredPort > 0) add(preferredPort);
    add(8787);
    for (var value = 8788; value <= 8899; value++) {
      add(value);
    }
    add(0);
    return candidates;
  }

  Future<void> stop() async {
    if (_server != null) {
      _state = ProxyState.stopping;
      await _server?.close(force: true);
      _server = null;
      _state = ProxyState.stopped;
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    final method = request.method;
    final path = request.uri.path;

    if (_enableCors) {
      _addCorsHeaders(request);
    }

    if (path == '/__health') {
      await _handleHealthCheck(request);
      return;
    }

    if (method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      return;
    }

    final route = _findRoute(path);
    if (route == null) {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('{"error": "No route matched"}');
      await request.response.close();
      return;
    }

    final account = _accounts
        .where((a) => a.accountId == route.accountId)
        .firstOrNull;
    if (account == null || !account.enabled || account.apiKey.isEmpty) {
      request.response.statusCode = HttpStatus.unauthorized;
      request.response.write('{"error": "Account not found or disabled"}');
      await request.response.close();
      return;
    }

    final targetPath = path.substring(route.pathPrefix.length);
    final targetUrl =
        '${route.targetBaseUrl}$targetPath${request.uri.query.isNotEmpty ? "?${request.uri.query}" : ""}';

    try {
      final uri = Uri.parse(targetUrl);
      final client = HttpClient();
      client.userAgent = 'ModelCost-Monitor/1.0.0';

      HttpClientRequest proxyRequest;
      if (method == 'GET') {
        proxyRequest = await client.getUrl(uri);
      } else {
        proxyRequest = await client.postUrl(uri);
      }

      proxyRequest.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer ${account.apiKey}',
      );
      proxyRequest.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/json',
      );
      proxyRequest.headers.set(
        HttpHeaders.acceptHeader,
        'text/event-stream, application/json',
      );

      if (method != 'GET') {
        final bodyBytes = await request.fold<List<int>>(
          <int>[],
          (previous, element) => previous..addAll(element),
        );
        proxyRequest.add(bodyBytes);
      }

      final proxyResponse = await proxyRequest.close();
      request.response.statusCode = proxyResponse.statusCode;

      final isStreaming =
          proxyResponse.headers
              .value(HttpHeaders.contentTypeHeader)
              ?.contains('text/event-stream') ==
          true;

      if (isStreaming) {
        request.response.headers.set(
          HttpHeaders.contentTypeHeader,
          'text/event-stream',
        );
        request.response.headers.set(
          HttpHeaders.cacheControlHeader,
          'no-cache',
        );
        request.response.headers.set(
          HttpHeaders.connectionHeader,
          'keep-alive',
        );
        request.response.headers.set('Access-Control-Allow-Origin', '*');

        final assembler = SseFrameAssembler();
        final completionBuffer = StringBuffer();
        bool hasUsage = false;
        int promptTokens = 0;
        int completionTokens = 0;

        await for (final chunk in proxyResponse) {
          request.response.add(chunk);
          await request.response.flush();
          assembler.addBytes(chunk);

          for (final event in assembler.drainEvents()) {
            if (event.data == '[DONE]') continue;
            completionBuffer.write(event.data);

            try {
              final json = jsonDecode(event.data) as Map<String, dynamic>;
              final usage = json['usage'];
              if (usage != null) {
                hasUsage = true;
                promptTokens = usage['prompt_tokens'] as int? ?? 0;
                completionTokens = usage['completion_tokens'] as int? ?? 0;
              }
            } catch (_) {}
          }
        }

        await request.response.close();

        if (!hasUsage) {
          promptTokens = (completionBuffer.toString().length * 0.5).ceil();
          completionTokens = (completionBuffer.toString().length * 0.5).ceil();
        }

        final cost = _calculateCost(
          account.providerType,
          _extractModelFromPath(targetPath),
          promptTokens,
          completionTokens,
          0,
          0,
        );

        onUsageLog?.call({
          'accountId': account.accountId,
          'providerType': account.providerType.name,
          'modelName': _extractModelFromPath(targetPath),
          'promptTokens': promptTokens,
          'completionTokens': completionTokens,
          'cachedTokens': 0,
          'reasoningTokens': 0,
          'totalTokens': promptTokens + completionTokens,
          'estimated': !hasUsage,
          'cost': cost,
          'currency': account.currency,
          'status': 'completed',
          'source': 'proxy',
        });
      } else {
        final bodyBytes = await proxyResponse.fold<List<int>>(
          <int>[],
          (previous, element) => previous..addAll(element),
        );

        request.response.add(bodyBytes);
        await request.response.close();

        try {
          final json =
              jsonDecode(utf8.decode(bodyBytes)) as Map<String, dynamic>;
          final usage = json['usage'];
          if (usage != null) {
            final promptTokens = usage['prompt_tokens'] as int? ?? 0;
            final completionTokens = usage['completion_tokens'] as int? ?? 0;
            final cost = _calculateCost(
              account.providerType,
              _extractModelFromPath(targetPath),
              promptTokens,
              completionTokens,
              0,
              0,
            );

            onUsageLog?.call({
              'accountId': account.accountId,
              'providerType': account.providerType.name,
              'modelName': _extractModelFromPath(targetPath),
              'promptTokens': promptTokens,
              'completionTokens': completionTokens,
              'cachedTokens': 0,
              'reasoningTokens': 0,
              'totalTokens': promptTokens + completionTokens,
              'estimated': false,
              'cost': cost,
              'currency': account.currency,
              'status': 'completed',
              'source': 'proxy',
            });
          }
        } catch (_) {}
      }
    } catch (e) {
      request.response.statusCode = HttpStatus.badGateway;
      request.response.write('{"error": "Proxy request failed"}');
      await request.response.close();
    }
  }

  ProxyRouteConfigInternal? _findRoute(String path) {
    for (final route in _routes.values) {
      if (path.startsWith(route.pathPrefix)) {
        return route;
      }
    }
    return null;
  }

  String _extractModelFromPath(String path) {
    try {
      final parts = path.split('/');
      final chatIndex = parts.indexOf('chat');
      if (chatIndex > 0 && parts.length > chatIndex + 2) {
        return parts[chatIndex + 2];
      }
      return 'unknown';
    } catch (_) {
      return 'unknown';
    }
  }

  double? _calculateCost(
    ProviderType providerType,
    String modelName,
    int promptTokens,
    int completionTokens,
    int cachedTokens,
    int reasoningTokens,
  ) {
    final price = _prices
        .where(
          (p) => p.providerType == providerType && p.modelName == modelName,
        )
        .firstOrNull;

    if (price == null) return null;

    double cost = 0;
    cost += promptTokens / 1_000_000 * price.inputPricePer1M;
    cost += completionTokens / 1_000_000 * price.outputPricePer1M;
    if (cachedTokens > 0 && price.cachedInputPricePer1M != null) {
      cost += cachedTokens / 1_000_000 * price.cachedInputPricePer1M!;
    }
    if (reasoningTokens > 0 && price.reasoningOutputPricePer1M != null) {
      cost += reasoningTokens / 1_000_000 * price.reasoningOutputPricePer1M!;
    }

    return cost;
  }

  void _addCorsHeaders(HttpRequest request) {
    final response = request.response;
    response.headers.set('Access-Control-Allow-Origin', '*');
    response.headers.set(
      'Access-Control-Allow-Methods',
      'GET, POST, PUT, PATCH, DELETE, OPTIONS',
    );
    response.headers.set(
      'Access-Control-Allow-Headers',
      'Authorization, Content-Type, Accept, Origin, User-Agent',
    );
    response.headers.set('Access-Control-Max-Age', '86400');
  }

  Future<void> _handleHealthCheck(HttpRequest request) async {
    final healthResponse = {
      'ok': true,
      'state': _state.name,
      'scheme': scheme,
      'host': host,
      'port': actualPort,
      'database': 'ok',
      'uptime_ms': uptime.inMilliseconds,
      'version': '1.0.0',
    };

    request.response.headers.set(
      HttpHeaders.contentTypeHeader,
      'application/json',
    );
    request.response.write(jsonEncode(healthResponse));
    await request.response.close();
  }
}
