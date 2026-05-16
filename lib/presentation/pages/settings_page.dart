import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../theme/app_theme.dart';
import 'help_page.dart';

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

    if (mounted) {
      setState(() {
        _hostController.text = host;
        _portController.text = port.toString();
        _corsEnabled = cors;
        _httpsEnabled = https;
        _selectedLocale = locale;
        _balanceThresholdController.text = (prefs.getDouble('balance_threshold') ?? 0.0).toStringAsFixed(2);
        _monthlyBudgetController.text = (prefs.getDouble('monthly_budget') ?? 0.0).toStringAsFixed(2);
        _logRetentionController.text = (prefs.getInt('log_retention_days') ?? 30).toString();
        _enableTray = prefs.getBool('enable_tray') ?? true;
        _enableStartup = prefs.getBool('enable_startup') ?? false;
        _enableWidget = prefs.getBool('enable_widget') ?? true;
        _enableLanAccess = prefs.getBool('enable_lan_access') ?? false;
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
    await prefs.setDouble('balance_threshold', double.tryParse(_balanceThresholdController.text) ?? 0.0);
    await prefs.setDouble('monthly_budget', double.tryParse(_monthlyBudgetController.text) ?? 0.0);
    await prefs.setInt('log_retention_days', int.tryParse(_logRetentionController.text) ?? 30);
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
    if (mounted) setState(() => _selectedLocale = locale);
  }

  void _showLanAccessWarning() {
    final l10n = L10nLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [const Icon(Icons.warning_amber_rounded, color: AppTheme.warning), const SizedBox(width: 8), Text(l10n.lanAccess)]),
        content: Text(l10n.lanAccessWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          FilledButton(onPressed: () { setState(() => _enableLanAccess = true); Navigator.pop(context); }, child: Text(l10n.confirm)),
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
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.icon(
              onPressed: _saveProxySettings,
              icon: const Icon(Icons.save_rounded, size: 18),
              label: Text(l10n.confirm),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceL),
        children: [
          // ── 语言 ──
          _sectionCard(
            icon: Icons.translate_rounded,
            color: AppTheme.deepseekBrand,
            title: l10n.language,
            children: [
              SegmentedButton<AppLocale>(
                segments: [
                  ButtonSegment(value: AppLocale.zhCN, label: Text(l10n.languageZhCN)),
                  ButtonSegment(value: AppLocale.zhTW, label: Text(l10n.languageZhTW)),
                  ButtonSegment(value: AppLocale.en, label: Text(l10n.languageEn)),
                ],
                selected: {_selectedLocale},
                onSelectionChanged: (set) => _changeLocale(set.first),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 代理设置 ──
          _sectionCard(
            icon: Icons.router_rounded,
            color: AppTheme.mimoBrand,
            title: l10n.proxySettings,
            children: [
              Row(children: [
                Expanded(child: TextField(controller: _hostController, decoration: InputDecoration(labelText: l10n.proxyHost, hintText: '127.0.0.1'))),
                const SizedBox(width: AppTheme.spaceM),
                SizedBox(width: 100, child: TextField(controller: _portController, decoration: InputDecoration(labelText: l10n.proxyPort, hintText: '8787'), keyboardType: TextInputType.number)),
              ]),
              const SizedBox(height: AppTheme.spaceM),
              _switchTile(Icons.http_rounded, l10n.enableCors, l10n.enableCorsSubtitle, _corsEnabled, (v) => setState(() => _corsEnabled = v)),
              _switchTile(Icons.https_rounded, l10n.enableHttps, l10n.enableHttpsSubtitle, _httpsEnabled, (v) => setState(() => _httpsEnabled = v)),
              _switchTile(Icons.lan_rounded, l10n.enableLanAccess, null, _enableLanAccess, (v) {
                if (v) {
                  _showLanAccessWarning();
                } else {
                  setState(() => _enableLanAccess = false);
                }
              }),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 预算提醒 ──
          _sectionCard(
            icon: Icons.account_balance_wallet_rounded,
            color: AppTheme.success,
            title: l10n.alertMonthlyBudget,
            children: [
              Row(children: [
                Expanded(child: TextField(controller: _balanceThresholdController, decoration: InputDecoration(labelText: l10n.balanceThreshold), keyboardType: const TextInputType.numberWithOptions(decimal: true))),
                const SizedBox(width: AppTheme.spaceM),
                Expanded(child: TextField(controller: _monthlyBudgetController, decoration: InputDecoration(labelText: l10n.monthlyBudget), keyboardType: const TextInputType.numberWithOptions(decimal: true))),
              ]),
              const SizedBox(height: AppTheme.spaceM),
              TextField(controller: _logRetentionController, decoration: InputDecoration(labelText: l10n.logRetentionDays), keyboardType: TextInputType.number),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 系统集成 ──
          _sectionCard(
            icon: Icons.integration_instructions_rounded,
            color: AppTheme.warning,
            title: '系统集成',
            children: [
              if (Platform.isWindows) ...[
                _switchTile(Icons.dashboard_customize_rounded, l10n.enableTray, null, _enableTray, (v) => setState(() => _enableTray = v)),
                _switchTile(Icons.start_rounded, l10n.enableWindowsStartup, null, _enableStartup, (v) => setState(() => _enableStartup = v)),
              ],
              if (Platform.isAndroid)
                _switchTile(Icons.widgets_rounded, l10n.enableAndroidWidget, null, _enableWidget, (v) => setState(() => _enableWidget = v)),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 安全信息 ──
          _sectionCard(
            icon: Icons.shield_rounded,
            color: AppTheme.info,
            title: l10n.security,
            children: [
              _infoRow(Icons.lock_rounded, l10n.apiKeyStorage, l10n.apiKeyStorageSubtitle),
              _infoRow(Icons.visibility_off_rounded, l10n.apiKeyMasking, l10n.apiKeyMaskingSubtitle),
              _infoRow(Icons.cloud_off_rounded, l10n.noDataUpload, l10n.noDataUploadSubtitle),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 使用说明 ──
          _sectionCard(
            icon: Icons.menu_book_rounded,
            color: AppTheme.seedColor,
            title: l10n.navHelp,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpPage())),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceS),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_forward_rounded, size: 20, color: AppTheme.seedColor),
                      const SizedBox(width: 10),
                      Expanded(child: Text(l10n.helpOverviewDesc, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 关于（只有一个） ──
          _sectionCard(
            icon: Icons.info_rounded,
            color: Colors.grey,
            title: l10n.about,
            children: [
              _infoRow(Icons.apps_rounded, L10n.of('app_title'), '${L10n.of('version')} 1.0.0'),
              _infoRow(Icons.description_rounded, l10n.license, 'MIT License'),
            ],
          ),
          const SizedBox(height: AppTheme.spaceXXL),
        ],
      ),
    );
  }

  // ── 分段卡片 ──
  Widget _sectionCard({required IconData icon, required Color color, required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: AppTheme.spaceL),
          ...children,
        ],
      ),
    );
  }

  Widget _switchTile(IconData icon, String title, String? subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])) : null,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
