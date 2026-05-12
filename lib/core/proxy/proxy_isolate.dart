import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import '../models/models.dart';
import '../proxy/proxy_server.dart';

const String proxyVersion = '1.0.0';

class ProxyIsolateManager {
  Isolate? _isolate;
  late final ReceivePort _receivePort;
  SendPort? _sendToIsolate;
  ProxyState _state = ProxyState.stopped;
  DateTime? _startTime;
  String _actualUrl = '';

  Function(ProxyStatusEvent)? onEvent;
  Function(Object)? onError;

  ProxyState get state => _state;
  DateTime? get startTime => _startTime;
  String get actualUrl => _actualUrl;
  int get uptime => _startTime != null ? DateTime.now().difference(_startTime!).inMilliseconds : 0;

  Future<bool> start({
    required String host,
    required int port,
    required List<AccountConfig> accounts,
    required List<ModelPriceConfig> prices,
    required List<ProxyRouteConfig> routes,
    required ProxySettings settings,
  }) async {
    _state = ProxyState.starting;
    _receivePort = ReceivePort();

    try {
      final accountsList = accounts
          .map((a) => {
                'accountId': a.accountId,
                'providerType': a.providerType.name,
                'displayName': a.displayName,
                'baseUrl': a.baseUrl,
                'apiKeyAlias': a.apiKeyAlias,
                'apiKey': a.apiKey,
                'currency': a.currency,
                'enabled': a.enabled,
                'proxyEnabled': a.proxyEnabled,
              })
          .toList();

      final pricesList = prices
          .map((p) => {
                'providerType': p.providerType.name,
                'modelName': p.modelName,
                'inputPricePer1M': p.inputPricePer1M,
                'outputPricePer1M': p.outputPricePer1M,
                'cachedInputPricePer1M': p.cachedInputPricePer1M,
                'reasoningOutputPricePer1M': p.reasoningOutputPricePer1M,
                'currency': p.currency,
              })
          .toList();

      final routesList = routes
          .map((r) => {
                'pathPrefix': r.pathPrefix,
                'accountId': r.accountId,
                'targetBaseUrl': r.targetBaseUrl,
              })
          .toList();

      _isolate = await Isolate.spawn(
        _proxyIsolateEntry,
        {
          'proxyHost': host,
          'proxyPort': port,
          'accounts': accountsList,
          'prices': pricesList,
          'routes': routesList,
          'mainSendPort': _receivePort.sendPort,
        },
        onError: _receivePort.sendPort,
        onExit: _receivePort.sendPort,
      );

      _receivePort.listen((message) {
        _handleIsolateMessage(message);
      }, onError: (error) {
        _state = ProxyState.crashed;
        onError?.call(error);
      });

      return true;
    } catch (e) {
      _state = ProxyState.crashed;
      onError?.call(e);
      return false;
    }
  }

  Future<void> stop() async {
    if (_state == ProxyState.stopped || _state == ProxyState.crashed) return;

    _state = ProxyState.stopping;
    _sendToIsolate?.send({'type': 'stop'});

    await Future.delayed(const Duration(seconds: 2));
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendToIsolate = null;
    _receivePort.close();

    _state = ProxyState.stopped;
    _startTime = null;
  }

  Future<void> sendHealthCheck() async {
    if (_sendToIsolate != null && _state == ProxyState.running) {
      _sendToIsolate!.send({'type': 'health_check'});
    }
  }

  void _handleIsolateMessage(dynamic message) {
    if (message is SendPort) {
      _sendToIsolate = message;
      return;
    }

    if (message is! Map) return;

    switch (message['type']) {
      case 'proxy_started':
        _state = ProxyState.running;
        _startTime = DateTime.now();
        final port = message['port'] ?? 8787;
        final host = message['host'] ?? '127.0.0.1';
        _actualUrl = 'http://$host:$port';
        onEvent?.call(ProxyStarted(host: host, port: port, scheme: 'http'));
        break;

      case 'proxy_stopped':
        _state = ProxyState.stopped;
        onEvent?.call(const ProxyStopped());
        break;

      case 'proxy_error':
        _state = ProxyState.degraded;
        onEvent?.call(ProxyError(message: message['error']?.toString() ?? 'Unknown error'));
        break;

      case 'proxy_port_changed':
        final newPort = message['new_port'] ?? message['port'];
        _actualUrl = 'http://127.0.0.1:$newPort';
        onEvent?.call(ProxyPortChanged(newPort: newPort, reason: 'Port auto-fallback'));
        break;
    }
  }

  Future<void> dispose() async {
    await stop();
  }
}

Future<void> _proxyIsolateEntry(Map<String, dynamic> args) async {
  final mainSendPort = args['mainSendPort'] as SendPort;
  final isolateReceivePort = ReceivePort();

  mainSendPort.send(isolateReceivePort.sendPort);

  ProxyServer? server;
  final startTime = DateTime.now();

  try {
    final host = args['proxyHost'] as String? ?? '127.0.0.1';
    final port = args['proxyPort'] as int? ?? 8787;

    final accountsJson = args['accounts'] as List<dynamic>? ?? [];
    final pricesJson = args['prices'] as List<dynamic>? ?? [];
    final routesJson = args['routes'] as List<dynamic>? ?? [];

    final accounts = accountsJson.map((e) {
      final m = e as Map<String, dynamic>;
      return AccountConfig(
        accountId: m['accountId'] as int,
        providerType: ProviderType.values.firstWhere((et) => et.name == m['providerType'], orElse: () => ProviderType.customOpenAI),
        displayName: m['displayName'] as String,
        baseUrl: m['baseUrl'] as String,
        apiKeyAlias: m['apiKeyAlias'] as String? ?? '',
        apiKey: m['apiKey'] as String,
        currency: m['currency'] as String? ?? 'USD',
        enabled: m['enabled'] as bool? ?? true,
        proxyEnabled: m['proxyEnabled'] as bool? ?? true,
      );
    }).toList();

    final prices = pricesJson.map((e) {
      final m = e as Map<String, dynamic>;
      return ModelPriceConfig(
        providerType: ProviderType.values.firstWhere((et) => et.name == m['providerType'], orElse: () => ProviderType.customOpenAI),
        modelName: m['modelName'] as String,
        inputPricePer1M: (m['inputPricePer1M'] as num).toDouble(),
        outputPricePer1M: (m['outputPricePer1M'] as num).toDouble(),
        cachedInputPricePer1M: m['cachedInputPricePer1M'] != null ? (m['cachedInputPricePer1M'] as num).toDouble() : null,
        reasoningOutputPricePer1M: m['reasoningOutputPricePer1M'] != null ? (m['reasoningOutputPricePer1M'] as num).toDouble() : null,
        currency: m['currency'] as String? ?? 'USD',
      );
    }).toList();

    final routes = routesJson.map((e) {
      final m = e as Map<String, dynamic>;
      return ProxyRouteConfig(
        pathPrefix: m['pathPrefix'] as String,
        accountId: m['accountId'] as int,
        targetBaseUrl: m['targetBaseUrl'] as String,
      );
    }).toList();

    server = ProxyServer(
      host: host,
      port: port,
      accounts: accounts,
      prices: prices,
      routes: routes,
    );

    final actualPort = await server.start();
    if (actualPort != port) {
      mainSendPort.send({'type': 'proxy_port_changed', 'old_port': port, 'new_port': actualPort, 'host': host});
    }

    mainSendPort.send({'type': 'proxy_started', 'host': host, 'port': actualPort, 'state': 'running'});

    isolateReceivePort.listen((message) {
      if (message is! Map) return;

      switch (message['type']) {
        case 'stop':
          server?.stop();
          mainSendPort.send({'type': 'proxy_stopped', 'uptime_ms': DateTime.now().difference(startTime).inMilliseconds});
          break;
      }
    });

    await Completer<void>().future;
  } catch (e, stackTrace) {
    server?.stop();
    mainSendPort.send({'type': 'proxy_crashed', 'error': e.toString(), 'stack_trace': stackTrace.toString()});
  }
}
