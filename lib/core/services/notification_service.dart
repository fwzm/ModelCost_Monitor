import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_widget/home_widget.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const String _channelProxy = 'proxy_channel';
  static const String _channelAlert = 'alert_channel';

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannels();
    _initialized = true;
  }

  Future<void> _createNotificationChannels() async {
    if (!Platform.isAndroid) return;

    const proxyChannel = AndroidNotificationChannel(
      _channelProxy,
      'Proxy Service',
      description: 'Shows when the local proxy is running',
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
    );

    const alertChannel = AndroidNotificationChannel(
      _channelAlert,
      'Alerts',
      description: 'Usage and budget alerts',
      importance: Importance.high,
    );

    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(proxyChannel);
    await androidPlugin?.createNotificationChannel(alertChannel);
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: \${response.payload}');
  }

  Future<void> showProxyRunningNotification({
    required String proxyUrl,
    required VoidCallback onStop,
  }) async {
    if (!Platform.isAndroid) return;

    const notification = AndroidNotificationDetails(
      _channelProxy,
      'Proxy Service',
      channelDescription: 'Shows when the local proxy is running',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      actions: [
        AndroidNotificationAction(
          'stop',
          'Stop',
          showsUserInterface: true,
        ),
      ],
    );

    await _notifications.show(
      1,
      'ModelCost Monitor Proxy',
      'Running at \$proxyUrl',
      const NotificationDetails(android: notification),
      payload: 'proxy_running',
    );
  }

  Future<void> cancelProxyNotification() async {
    await _notifications.cancel(1);
  }

  Future<void> showLowBalanceAlert({
    required String providerName,
    required double balance,
    required String currency,
  }) async {
    const notification = AndroidNotificationDetails(
      _channelAlert,
      'Alerts',
      channelDescription: 'Usage and budget alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notifications.show(
      2,
      'Low Balance Alert',
      '\$providerName balance is \${balance.toStringAsFixed(2)} \$currency',
      const NotificationDetails(android: notification),
      payload: 'low_balance',
    );
  }

  Future<void> showBudgetExceededAlert({
    required double currentCost,
    required double budget,
    required String currency,
  }) async {
    const notification = AndroidNotificationDetails(
      _channelAlert,
      'Alerts',
      channelDescription: 'Usage and budget alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notifications.show(
      3,
      'Budget Exceeded',
      'Monthly cost \${currentCost.toStringAsFixed(2)} \$currency exceeds budget \${budget.toStringAsFixed(2)} \$currency',
      const NotificationDetails(android: notification),
      payload: 'budget_exceeded',
    );
  }

  Future<void> showProxyCrashAlert() async {
    const notification = AndroidNotificationDetails(
      _channelAlert,
      'Alerts',
      channelDescription: 'Usage and budget alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notifications.show(
      4,
      'Proxy Service Error',
      'The local proxy has stopped unexpectedly',
      const NotificationDetails(android: notification),
      payload: 'proxy_crash',
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}

class AndroidWidgetService {
  static final AndroidWidgetService _instance = AndroidWidgetService._internal();
  factory AndroidWidgetService() => _instance;
  AndroidWidgetService._internal();

  static const String _appGroupId = 'group.com.modelcost.monitor';
  static const String _androidWidgetName = 'ModelCostWidgetReceiver';

  Future<void> initialize() async {
    if (!Platform.isAndroid) return;

    try {
      await HomeWidget.setAppGroupId(_appGroupId);
    } catch (e) {
      debugPrint('Failed to initialize widget: \$e');
    }
  }

  Future<void> updateWidget({
    required double todayCost,
    required double monthCost,
    required String proxyState,
    required String proxyUrl,
  }) async {
    if (!Platform.isAndroid) return;

    try {
      await HomeWidget.saveWidgetData<String>('proxy_state', proxyState);
      await HomeWidget.saveWidgetData<String>('proxy_url', proxyUrl);
      await HomeWidget.saveWidgetData<String>('today_cost', todayCost.toStringAsFixed(4));
      await HomeWidget.saveWidgetData<String>('month_cost', monthCost.toStringAsFixed(4));
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: 'ModelCostWidget',
      );
    } catch (e) {
      debugPrint('Failed to update widget: \$e');
    }
  }
}
