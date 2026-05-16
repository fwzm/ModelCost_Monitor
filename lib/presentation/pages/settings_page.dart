import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _portController = TextEditingController();
  final _hostController = TextEditingController();
  final _balanceThresholdController = TextEditingController();
  final _monthlyBudgetController = TextEditingController();
  final _logRetentionController = TextEditingController();
  bool _corsEnabled = true;
  bool _httpsEnabled = false;
  bool _enableTray = true;
  bool _enableStartup = false;
  bool _enableWidget = true;
  bool _enableLanAccess = false;
  AppLocale _selectedLocale = AppLocale.zhCN;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _portController.dispose();
    _hostController.dispose();
    _balanceThresholdController.dispose();
    _monthlyBudgetController.dispose();
    _logRetentionController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final service = ref.read(settingsServiceProvider);
    final host = await service.getProxyHost();
    final port = await service.getProxyPort();
    final cors = await service.isCorsEnabled();
    final https = await service.isHttpsEnabled();
    final locale = L10n.current;

    final prefs = await SharedPreferences.getInstance();
    final balanceThreshold = prefs.getDouble('balance_threshold') ?? 0.0;
    final monthlyBudget = prefs.getDouble('monthly_budget') ?? 0.0;
    final logRetention = prefs.getInt('log_retention_days') ?? 30;
    final enableTray = prefs.getBool('enable_tray') ?? true;
    final enableStartup = prefs.getBool('enable_startup') ?? false;
    final enableWidget = prefs.getBool('enable_widget') ?? true;
    final enableLanAccess = prefs.getBool('enable_lan_access') ?? false;

    if (mounted) {
      setState(() {
        _hostController.text = host;
        _portController.text = port.toString();
        _corsEnabled = cors;
        _httpsEnabled = https;
        _selectedLocale = locale;
        _balanceThresholdController.text = balanceThreshold.toStringAsFixed(2);
        _monthlyBudgetController.text = monthlyBudget.toStringAsFixed(2);
        _logRetentionController.text = logRetention.toString();
        _enableTray = enableTray;
        _enableStartup = enableStartup;
        _enableWidget = enableWidget;
        _enableLanAccess = enableLanAccess;
      });
    }
  }

  Future<void> _saveProxySettings() async {
    final service = ref.read(settingsServiceProvider);
    await service.setSetting('proxy_host', _hostController.text);
    await service.setSetting('proxy_port', _portController.text);
    await service.setSetting('enable_cors', _corsEnabled.toString());
    await service.setSetting('enable_https', _httpsEnabled.toString());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(
      'balance_threshold',
      double.tryParse(_balanceThresholdController.text) ?? 0.0,
    );
    await prefs.setDouble(
      'monthly_budget',
      double.tryParse(_monthlyBudgetController.text) ?? 0.0,
    );
    await prefs.setInt(
      'log_retention_days',
      int.tryParse(_logRetentionController.text) ?? 30,
    );
    await prefs.setBool('enable_tray', _enableTray);
    await prefs.setBool('enable_startup', _enableStartup);
    await prefs.setBool('enable_widget', _enableWidget);
    await prefs.setBool('enable_lan_access', _enableLanAccess);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10nLocalizations.of(context).settingsSaved)),
      );
    }
  }

  Future<void> _changeLocale(AppLocale locale) async {
    await L10n.setLocale(locale);
    if (mounted) {
      setState(() {
        _selectedLocale = locale;
      });
    }
  }

  void _showLanAccessWarning() {
    final l10n = L10nLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.lanAccess),
          ],
        ),
        content: Text(l10n.lanAccessWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _enableLanAccess = true;
              });
              Navigator.pop(context);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navSettings),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProxySettings,
            tooltip: 'Save',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<AppLocale>(
                    segments: [
                      ButtonSegment(
                        value: AppLocale.zhCN,
                        label: Text(l10n.languageZhCN),
                      ),
                      ButtonSegment(
                        value: AppLocale.zhTW,
                        label: Text(l10n.languageZhTW),
                      ),
                      ButtonSegment(
                        value: AppLocale.en,
                        label: Text(l10n.languageEn),
                      ),
                    ],
                    selected: {_selectedLocale},
                    onSelectionChanged: (set) => _changeLocale(set.first),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.proxySettings,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _hostController,
                    decoration: InputDecoration(
                      labelText: l10n.proxyHost,
                      hintText: '127.0.0.1',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _portController,
                    decoration: InputDecoration(
                      labelText: l10n.proxyPort,
                      hintText: '8787',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.enableCors),
                    subtitle: Text(l10n.enableCorsSubtitle),
                    value: _corsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _corsEnabled = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.enableHttps),
                    subtitle: Text(l10n.enableHttpsSubtitle),
                    value: _httpsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _httpsEnabled = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.enableLanAccess),
                    value: _enableLanAccess,
                    onChanged: (value) {
                      if (value) {
                        _showLanAccessWarning();
                      } else {
                        setState(() {
                          _enableLanAccess = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.alertMonthlyBudget,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _balanceThresholdController,
                    decoration: InputDecoration(
                      labelText: l10n.balanceThreshold,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _monthlyBudgetController,
                    decoration: InputDecoration(labelText: l10n.monthlyBudget),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _logRetentionController,
                    decoration: InputDecoration(
                      labelText: l10n.logRetentionDays,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.about,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (Platform.isWindows)
                    SwitchListTile(
                      title: Text(l10n.enableTray),
                      value: _enableTray,
                      onChanged: (value) {
                        setState(() {
                          _enableTray = value;
                        });
                      },
                    ),
                  if (Platform.isWindows)
                    SwitchListTile(
                      title: Text(l10n.enableWindowsStartup),
                      value: _enableStartup,
                      onChanged: (value) {
                        setState(() {
                          _enableStartup = value;
                        });
                      },
                    ),
                  if (Platform.isAndroid)
                    SwitchListTile(
                      title: Text(l10n.enableAndroidWidget),
                      value: _enableWidget,
                      onChanged: (value) {
                        setState(() {
                          _enableWidget = value;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.security,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: Text(l10n.apiKeyStorage),
                    subtitle: Text(l10n.apiKeyStorageSubtitle),
                  ),
                  ListTile(
                    leading: const Icon(Icons.visibility_off),
                    title: Text(l10n.apiKeyMasking),
                    subtitle: Text(l10n.apiKeyMaskingSubtitle),
                  ),
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: Text(l10n.noDataUpload),
                    subtitle: Text(l10n.noDataUploadSubtitle),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.about,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(L10n.of('app_title')),
                    subtitle: Text('${L10n.of('version')} 1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(l10n.license),
                    subtitle: const Text('MIT License'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
