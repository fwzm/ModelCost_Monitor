import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import '../models/models.dart';
import '../proxy/proxy_isolate.dart';

typedef ProxyLifecycleCallback = void Function(ProxyState state, String url);

class ProxyLifecycleService {
  static final ProxyLifecycleService _instance = ProxyLifecycleService._internal();
  factory ProxyLifecycleService() => _instance;
  ProxyLifecycleService._internal();

  final ProxyIsolateManager _proxyManager = ProxyIsolateManager();
  ProxyLifecycleCallback? onStateChanged;
  Timer? _healthCheckTimer;
  Timer? _balanceCheckTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  int _restartAttempts = 0;
  static const int _maxRestartAttempts = 3;

  ProxyState get state => _proxyManager.state;
  String get proxyUrl => _proxyManager.actualUrl;
  Duration get uptime => Duration(milliseconds: _proxyManager.uptime);

  Future<void> initialize({
    required ProxyLifecycleCallback onStateChanged,
  }) async {
    this.onStateChanged = onStateChanged;

    _proxyManager.onEvent = _handleProxyEvent;
    _proxyManager.onError = _handleProxyError;

    await _setupConnectivityListener();
    await _setupDisplayMode();

    _startPeriodicHealthCheck();
    _startPeriodicBalanceCheck();
  }

  Future<void> _setupConnectivityListener() async {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        if (results.contains(ConnectivityResult.none)) {
          debugPrint('Network disconnected');
        } else {
          debugPrint('Network connected: \$results');
          _onNetworkChanged();
        }
      },
    );
  }

  Future<void> _setupDisplayMode() async {
    if (!Platform.isAndroid) return;

    try {
      final modes = await FlutterDisplayMode.supported;
      if (modes.isNotEmpty) {
        await FlutterDisplayMode.setPreferredMode(modes.first);
      }
    } catch (e) {
      debugPrint('Failed to set display mode: \$e');
    }
  }

  void _startPeriodicHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _performHealthCheck(),
    );
  }

  void _startPeriodicBalanceCheck() {
    _balanceCheckTimer?.cancel();
    _balanceCheckTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _checkBalances(),
    );
  }

  Future<void> _performHealthCheck() async {
    if (_proxyManager.state != ProxyState.running) return;

    try {
      await _proxyManager.sendHealthCheck();
    } catch (e) {
      debugPrint('Health check failed: \$e');
    }
  }

  Future<void> _checkBalances() async {
    // Balance checking logic - implemented via provider
  }

  void _handleProxyEvent(ProxyStatusEvent event) {
    if (event is ProxyStarted) {
      _restartAttempts = 0;
      onStateChanged?.call(ProxyState.running, _proxyManager.actualUrl);
    } else if (event is ProxyStopped) {
      onStateChanged?.call(ProxyState.stopped, _proxyManager.actualUrl);
    } else if (event is ProxyError) {
      onStateChanged?.call(ProxyState.degraded, _proxyManager.actualUrl);
    } else if (event is ProxyPortChanged) {
      onStateChanged?.call(ProxyState.running, _proxyManager.actualUrl);
    }
  }

  void _handleProxyError(Object error) {
    debugPrint('Proxy error: \$error');
    onStateChanged?.call(ProxyState.crashed, _proxyManager.actualUrl);
  }

  void _onNetworkChanged() {
    if (_proxyManager.state == ProxyState.running) {
      _performHealthCheck();
    }
  }

  Future<void> onAppLifecycleStateChanged(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _onAppDetached();
        break;
    }
  }

  void _onAppResumed() {
    if (_proxyManager.state == ProxyState.running) {
      _performHealthCheck();
    }
  }

  void _onAppPaused() {
    // App paused - health check will run on resume
  }

  void _onAppDetached() {
    // App is being terminated
  }

  Future<void> onSleepWake() async {
    if (_proxyManager.state != ProxyState.running) return;

    debugPrint('System wake detected, checking proxy health...');
    _restartAttempts = 0;
    await _recoverProxy();
  }

  Future<void> _recoverProxy() async {
    if (_restartAttempts >= _maxRestartAttempts) {
      debugPrint('Max restart attempts reached, giving up');
      onStateChanged?.call(ProxyState.crashed, _proxyManager.actualUrl);
      return;
    }

    try {
      _restartAttempts++;
      await _performHealthCheck();
    } catch (e) {
      debugPrint('Recovery attempt \$_restartAttempts failed: \$e');
      await Future.delayed(Duration(seconds: _restartAttempts * 2));
      await _recoverProxy();
    }
  }

  Future<bool> startProxy({
    required String host,
    required int port,
    required List<AccountConfig> accounts,
    required List<ModelPriceConfig> prices,
    required List<ProxyRouteConfig> routes,
    required ProxySettings settings,
  }) async {
    _restartAttempts = 0;
    return await _proxyManager.start(
      host: host,
      port: port,
      accounts: accounts,
      prices: prices,
      routes: routes,
      settings: settings,
    );
  }

  Future<void> stopProxy() async {
    await _proxyManager.stop();
  }

  Future<void> dispose() async {
    _healthCheckTimer?.cancel();
    _balanceCheckTimer?.cancel();
    await _connectivitySubscription?.cancel();
    await _proxyManager.dispose();
  }
}
