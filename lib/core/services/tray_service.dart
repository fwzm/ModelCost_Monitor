import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';

import '../../l10n/l10n.dart';
import '../models/models.dart';

class TrayService with TrayListener {
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;
  TrayService._internal();

  bool _initialized = false;
  ProxyState _currentState = ProxyState.stopped;
  String _proxyUrl = 'http://127.0.0.1:8787';
  double _todayCost = 0.0;
  double _monthCost = 0.0;
  int _accountCount = 0;

  VoidCallback? onProxyStart;
  VoidCallback? onProxyStop;
  VoidCallback? onShowWindow;
  VoidCallback? onQuit;

  Future<void> initialize() async {
    if (_initialized) return;
    if (!Platform.isWindows) return;

    try {
      final iconPath = _getTrayIconPath();
      if (await File(iconPath).exists()) {
        await trayManager.setIcon(iconPath);
      }
      await trayManager.setToolTip('ModelCost Monitor');
      trayManager.addListener(this);
      await _updateMenu();
      _initialized = true;
    } catch (e) {
      debugPrint('Failed to initialize tray: $e');
    }
  }

  String _getTrayIconPath() {
    if (Platform.isWindows) {
      return 'assets/icons/app_icon.ico';
    }
    return 'assets/icons/app_icon.png';
  }

  Future<void> updateState({
    required ProxyState state,
    required String proxyUrl,
    double? todayCost,
    double? monthCost,
    int? accountCount,
  }) async {
    _currentState = state;
    _proxyUrl = proxyUrl;
    if (todayCost != null) _todayCost = todayCost;
    if (monthCost != null) _monthCost = monthCost;
    if (accountCount != null) _accountCount = accountCount;

    await _updateMenu();
    await _updateTooltip();
  }

  Future<void> _updateMenu() async {
    final l10n = L10nLocalizations.of(navigatorKey.currentContext!);

    final menu = Menu(
      items: [
        MenuItem(
          label: '${l10n.proxyStatusStopped}: ${_getStateText(l10n)}',
          disabled: true,
        ),
        MenuItem.separator(),
        MenuItem(
          label: '${l10n.todayCost}: \$${_todayCost.toStringAsFixed(4)}',
          disabled: true,
        ),
        MenuItem(
          label: '${l10n.monthCost}: \$${_monthCost.toStringAsFixed(4)}',
          disabled: true,
        ),
        MenuItem(
          label: '${l10n.totalAccounts}: $_accountCount',
          disabled: true,
        ),
        MenuItem.separator(),
        MenuItem(label: '${l10n.currentProxyUrl}: $_proxyUrl', disabled: true),
        MenuItem.separator(),
        if (_currentState == ProxyState.running)
          MenuItem(key: 'stop_proxy', label: l10n.proxyStop)
        else
          MenuItem(key: 'start_proxy', label: l10n.proxyStart),
        MenuItem.separator(),
        MenuItem(key: 'show_window', label: L10n.of('show_window')),
        MenuItem(key: 'quit', label: L10n.of('quit')),
      ],
    );

    await trayManager.setContextMenu(menu);
  }

  Future<void> _updateTooltip() async {
    final l10n = L10nLocalizations.of(navigatorKey.currentContext!);
    final stateText = _getStateText(l10n);
    await trayManager.setToolTip(
      'ModelCost Monitor - $stateText\n'
      '${l10n.todayCost}: \$${_todayCost.toStringAsFixed(4)}\n'
      '${l10n.monthCost}: \$${_monthCost.toStringAsFixed(4)}',
    );
  }

  String _getStateText(L10nLocalizations l10n) {
    switch (_currentState) {
      case ProxyState.running:
        return l10n.proxyStatusRunning;
      case ProxyState.starting:
        return l10n.proxyStatusStarting;
      case ProxyState.stopping:
        return l10n.proxyStatusStopping;
      case ProxyState.degraded:
        return l10n.proxyStatusDegraded;
      case ProxyState.crashed:
        return l10n.proxyStatusCrashed;
      case ProxyState.stopped:
        return l10n.proxyStatusStopped;
    }
  }

  @override
  void onTrayIconMouseDown() {
    onShowWindow?.call();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'start_proxy':
        onProxyStart?.call();
        break;
      case 'stop_proxy':
        onProxyStop?.call();
        break;
      case 'show_window':
        onShowWindow?.call();
        break;
      case 'quit':
        onQuit?.call();
        break;
    }
  }

  Future<void> dispose() async {
    if (!_initialized) return;
    trayManager.removeListener(this);
    await trayManager.destroy();
    _initialized = false;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
