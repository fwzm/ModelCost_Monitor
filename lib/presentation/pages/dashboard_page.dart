import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/proxy/proxy_isolate.dart';
import '../../data/database/database.dart';
import '../../l10n/l10n.dart';
import '../../providers/providers.dart';

class DashboardPage extends ConsumerStatefulWidget {
  final ValueChanged<int>? onNavigate;

  const DashboardPage({super.key, this.onNavigate});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late final ProxyIsolateManager _proxyManager;
  ProxyState _proxyState = ProxyState.stopped;
  String _proxyUrl = 'http://127.0.0.1:8787';
  String? _lastCrashError;

  @override
  void initState() {
    super.initState();
    _proxyManager = ref.read(proxyManagerProvider);
    _proxyState = _proxyManager.state;
    if (_proxyManager.actualUrl.isNotEmpty) {
      _proxyUrl = _proxyManager.actualUrl;
    }
    _proxyManager.onEvent = _handleProxyEvent;
    _proxyManager.onError = (error) {
      if (!mounted) return;
      setState(() {
        _proxyState = ProxyState.crashed;
        _lastCrashError = error.toString();
      });
    };
    _loadProxySettings();
  }

  @override
  void dispose() {
    _proxyManager.onEvent = null;
    _proxyManager.onError = null;
    super.dispose();
  }

  Future<void> _loadProxySettings() async {
    if (_proxyManager.actualUrl.isNotEmpty) {
      setState(() => _proxyUrl = _proxyManager.actualUrl);
      return;
    }

    final settings = ref.read(settingsServiceProvider);
    final host = await settings.getProxyHost();
    final port = await settings.getProxyPort();
    if (mounted) {
      setState(() {
        _proxyUrl = 'http://$host:$port';
      });
    }
  }

  void _handleProxyEvent(ProxyStatusEvent event) {
    if (!mounted) return;
    setState(() {
      if (event is ProxyStarted) {
        _proxyState = ProxyState.running;
        _proxyUrl = '${event.scheme}://${event.host}:${event.port}';
      } else if (event is ProxyStopped) {
        _proxyState = ProxyState.stopped;
      } else if (event is ProxyError) {
        _proxyState = ProxyState.degraded;
      } else if (event is ProxyPortChanged) {
        _proxyUrl = 'http://127.0.0.1:${event.newPort}';
        ref
            .read(settingsServiceProvider)
            .setSetting('proxy_port', event.newPort.toString());
      }
    });
  }

  Future<void> _startProxy() async {
    final l10n = L10nLocalizations.of(context);
    setState(() => _proxyState = ProxyState.starting);

    try {
      final accountService = ref.read(accountServiceProvider);
      final pricingService = ref.read(pricingServiceProvider);
      final settings = ref.read(settingsServiceProvider);

      final accounts = await accountService.getAllAccounts();
      final prices = await pricingService.getAllPrices();
      final host = await settings.getProxyHost();
      final port = await settings.getProxyPort();
      final corsEnabled = await settings.isCorsEnabled();

      final accountConfigs = <AccountConfig>[];
      for (final account in accounts) {
        if (!account.enabled || !account.proxyEnabled) continue;
        final apiKey = await accountService.getApiKey(account.id);
        if (apiKey == null || apiKey.isEmpty) continue;
        accountConfigs.add(
          AccountConfig(
            accountId: account.id,
            providerType: account.providerType,
            displayName: account.displayName,
            baseUrl: account.baseUrl,
            apiKeyAlias: account.apiKeyAlias,
            apiKey: apiKey,
            currency: account.currency,
            enabled: account.enabled,
            proxyEnabled: account.proxyEnabled,
          ),
        );
      }

      if (accountConfigs.isEmpty) {
        setState(() => _proxyState = ProxyState.stopped);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(L10n.of('proxy_no_accounts'))));
        }
        return;
      }

      final routes = accountConfigs
          .where((account) => account.accountId != null)
          .map(
            (account) => ProxyRouteConfig(
              pathPrefix: _pathPrefixForAccount(account),
              accountId: account.accountId!,
              targetBaseUrl: _normalizeBaseUrl(account.baseUrl),
            ),
          )
          .toList();

      final priceConfigs = prices
          .map(
            (p) => ModelPriceConfig(
              providerType: p.providerType,
              modelName: p.modelName,
              inputPricePer1M: p.inputPricePer1M,
              outputPricePer1M: p.outputPricePer1M,
              cachedInputPricePer1M: p.cachedInputPricePer1M,
              reasoningOutputPricePer1M: p.reasoningOutputPricePer1M,
              currency: p.currency,
            ),
          )
          .toList();

      final success = await _proxyManager.start(
        host: host,
        port: port,
        accounts: accountConfigs,
        prices: priceConfigs,
        routes: routes,
        settings: ProxySettings(
          enableCors: corsEnabled,
          enableHttps: false,
          enableTokenizerFallback: true,
          requestTimeoutPolicy: 'streamingCompletion',
          uiRefreshIntervalMs: 500,
          maxRetries: 5,
          retryBaseIntervalMs: 100,
        ),
      );

      if (!mounted) return;
      if (success) {
        setState(() => _lastCrashError = null);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.proxyStarted)));
      } else {
        setState(() {
          _proxyState = ProxyState.crashed;
          _lastCrashError = l10n.proxyStartFailed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _proxyState = ProxyState.crashed;
        _lastCrashError = e.toString();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${l10n.errorStartingProxy}: $e')));
    }
  }

  Future<void> _stopProxy() async {
    setState(() => _proxyState = ProxyState.stopping);
    await _proxyManager.stop();
    if (mounted) {
      setState(() => _proxyState = ProxyState.stopped);
    }
  }

  Future<void> _copyProxyUrl() async {
    final l10n = L10nLocalizations.of(context);
    await Clipboard.setData(ClipboardData(text: _proxyUrl));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.addressCopied)));
    }
  }

  void _goToPage(int index) {
    widget.onNavigate?.call(index);
  }

  Future<void> _handleQuickStartProxy() async {
    final accounts =
        ref.read(accountsProvider).valueOrNull ?? const <Account>[];
    if (accounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of('quick_need_account_first'))),
      );
      _goToPage(1);
      return;
    }

    if (_proxyState == ProxyState.running) {
      _showUsageGuide();
      return;
    }

    await _startProxy();
  }

  void _showUsageGuide() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.route_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(L10n.of('usage_guide_title'))),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GuideStep(number: 1, text: L10n.of('usage_guide_step_1')),
                _GuideStep(
                  number: 2,
                  text: L10n.of(
                    'usage_guide_step_2',
                  ).replaceFirst('{url}', _proxyUrl),
                ),
                _GuideStep(number: 3, text: L10n.of('usage_guide_step_3')),
                _GuideStep(number: 4, text: L10n.of('usage_guide_step_4')),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    _proxyUrl,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(L10nLocalizations.of(context).cancel),
            ),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _copyProxyUrl();
              },
              icon: const Icon(Icons.copy),
              label: Text(L10nLocalizations.of(context).copyAddress),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _goToPage(3);
              },
              icon: const Icon(Icons.receipt_long_outlined),
              label: Text(L10n.of('open_logs')),
            ),
          ],
        );
      },
    );
  }

  void _showCrashDialog() {
    final l10n = L10nLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final errorDetail = _lastCrashError ?? l10n.errorProxyCrashed;

    String solution = '';
    if (errorDetail.contains('address already in use') ||
        errorDetail.contains('Address already in use') ||
        errorDetail.contains('bind')) {
      solution = L10n.of('crash_solution_port_in_use');
    } else if (errorDetail.contains('permission') ||
        errorDetail.contains('Permission')) {
      solution = L10n.of('crash_solution_permission');
    } else if (errorDetail.contains('timeout') ||
        errorDetail.contains('Timeout')) {
      solution = L10n.of('crash_solution_timeout');
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.error, color: colorScheme.error, size: 36),
          title: Text(l10n.proxyStatusCrashed),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10n.of('crash_dialog_reason'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    errorDetail,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                if (solution.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    L10n.of('crash_dialog_solution'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(solution, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _startProxy();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.proxyRestart),
            ),
          ],
        );
      },
    );
  }

  String _pathPrefixForAccount(AccountConfig account) {
    if (account.providerType == ProviderType.customOpenAI) {
      return '/proxy/custom/${account.accountId}';
    }
    return '/proxy/${account.providerType.name}';
  }

  String _normalizeBaseUrl(String baseUrl) {
    return baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
  }

  IconData _stateIcon() {
    switch (_proxyState) {
      case ProxyState.running:
        return Icons.check_circle;
      case ProxyState.starting:
      case ProxyState.stopping:
        return Icons.sync;
      case ProxyState.degraded:
        return Icons.warning_amber;
      case ProxyState.crashed:
        return Icons.error;
      case ProxyState.stopped:
        return Icons.pause_circle;
    }
  }

  String _stateText() {
    final l10n = L10nLocalizations.of(context);
    switch (_proxyState) {
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
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final todayCostAsync = ref.watch(todayCostProvider);
    final monthCostAsync = ref.watch(monthCostProvider);
    final accountsAsync = ref.watch(accountsProvider);
    final usageLogsAsync = ref.watch(usageLogsProvider);
    final logs = usageLogsAsync.valueOrNull ?? const <UsageLog>[];
    final accounts = accountsAsync.valueOrNull ?? const <Account>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: L10n.of('refresh'),
            onPressed: () {
              ref.invalidate(todayCostProvider);
              ref.invalidate(monthCostProvider);
              ref.invalidate(accountsProvider);
              ref.invalidate(usageLogsProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayCostProvider);
          ref.invalidate(monthCostProvider);
          ref.invalidate(accountsProvider);
          ref.invalidate(usageLogsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _ProxyHero(
              proxyUrl: _proxyUrl,
              stateText: _stateText(),
              stateIcon: _stateIcon(),
              isRunning: _proxyState == ProxyState.running,
              isStopped: _proxyState == ProxyState.stopped,
              isCrashed: _proxyState == ProxyState.crashed,
              isBusy:
                  _proxyState == ProxyState.starting ||
                  _proxyState == ProxyState.stopping,
              onStart: _startProxy,
              onStop: _stopProxy,
              onCopy: _copyProxyUrl,
              onGuide: _showUsageGuide,
              onCrashTap: _showCrashDialog,
            ),
            const SizedBox(height: 16),
            if (accounts.isEmpty || logs.isEmpty) ...[
              _QuickStartCard(
                hasAccount: accounts.isNotEmpty,
                hasUsage: logs.isNotEmpty,
                proxyRunning: _proxyState == ProxyState.running,
                onAccountTap: () => _goToPage(1),
                onPricingTap: () => _goToPage(2),
                onProxyTap: _handleQuickStartProxy,
                onUsageTap: logs.isNotEmpty
                    ? () => _goToPage(3)
                    : _showUsageGuide,
                onGuideTap: _showUsageGuide,
              ),
              const SizedBox(height: 16),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final columns = width >= 1120
                    ? 4
                    : width >= 720
                    ? 3
                    : 2;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: width < 380 ? 1.05 : 1.5,
                  children: [
                    todayCostAsync.when(
                      data: (cost) => _MetricCard(
                        label: l10n.todayCost,
                        value: _formatCurrency(cost),
                        icon: Icons.payments_outlined,
                        color: const Color(0xFF16A34A),
                      ),
                      loading: () => _MetricCard.loading(label: l10n.todayCost),
                      error: (e, _) =>
                          _MetricCard.error(label: l10n.todayCost, error: e),
                    ),
                    monthCostAsync.when(
                      data: (cost) => _MetricCard(
                        label: l10n.monthCost,
                        value: _formatCurrency(cost),
                        icon: Icons.calendar_month_outlined,
                        color: const Color(0xFF2563EB),
                      ),
                      loading: () => _MetricCard.loading(label: l10n.monthCost),
                      error: (e, _) =>
                          _MetricCard.error(label: l10n.monthCost, error: e),
                    ),
                    _MetricCard(
                      label: l10n.totalRequests,
                      value: _formatCompact(logs.length),
                      icon: Icons.route_outlined,
                      color: const Color(0xFFF97316),
                    ),
                    _MetricCard(
                      label: l10n.totalTokens,
                      value: _formatTokens(logs),
                      icon: Icons.data_usage,
                      color: const Color(0xFF0F766E),
                    ),
                    _MetricCard(
                      label: l10n.totalAccounts,
                      value: _formatCompact(accounts.length),
                      icon: Icons.cloud_queue_outlined,
                      color: const Color(0xFF7C3AED),
                    ),
                    _MetricCard(
                      label: l10n.estimatedRecords,
                      value: _formatEstimatedRatio(logs),
                      icon: Icons.calculate_outlined,
                      color: const Color(0xFFDC2626),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _RecentActivityCard(logs: logs),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) =>
      '\$${value.toStringAsFixed(value >= 10 ? 2 : 4)}';

  String _formatEstimatedRatio(List<UsageLog> logs) {
    if (logs.isEmpty) return '0%';
    final estimated = logs.where((log) => log.estimated).length;
    return '${(estimated * 100 / logs.length).toStringAsFixed(0)}%';
  }

  String _formatTokens(List<UsageLog> logs) {
    final total = logs.fold<int>(0, (sum, log) => sum + (log.totalTokens ?? 0));
    return _formatCompact(total);
  }

  String _formatCompact(num value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }
}

class _ProxyHero extends StatelessWidget {
  final String proxyUrl;
  final String stateText;
  final IconData stateIcon;
  final bool isRunning;
  final bool isStopped;
  final bool isCrashed;
  final bool isBusy;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCopy;
  final VoidCallback onGuide;
  final VoidCallback onCrashTap;

  const _ProxyHero({
    required this.proxyUrl,
    required this.stateText,
    required this.stateIcon,
    required this.isRunning,
    required this.isStopped,
    required this.isCrashed,
    required this.isBusy,
    required this.onStart,
    required this.onStop,
    required this.onCopy,
    required this.onGuide,
    required this.onCrashTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.tertiary.withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 720;
            final foreground = colorScheme.onPrimary;
            final subtleForeground = foreground.withValues(alpha: 0.76);
            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, color: foreground, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.currentProxyUrl,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: subtleForeground,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SelectableText(
                      proxyUrl,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: foreground,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Tooltip(
                      message: l10n.copyAddress,
                      child: IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: foreground.withValues(alpha: 0.16),
                          foregroundColor: foreground,
                        ),
                        onPressed: onCopy,
                        icon: const Icon(Icons.copy, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  L10n.of('proxy_url_hint'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: subtleForeground),
                ),
              ],
            );
            final statusAndActions = Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: stacked ? WrapAlignment.start : WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (!isStopped)
                  GestureDetector(
                    onTap: isCrashed ? onCrashTap : null,
                    child: _StatusPill(
                      icon: stateIcon,
                      text: stateText,
                      color: foreground,
                      isCrashed: isCrashed,
                    ),
                  ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: foreground,
                    foregroundColor: colorScheme.primary,
                  ),
                  onPressed: isBusy ? null : (isRunning ? onStop : onStart),
                  icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(isRunning ? l10n.proxyStop : l10n.proxyStart),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: foreground,
                    side: BorderSide(color: foreground.withValues(alpha: 0.45)),
                  ),
                  onPressed: onGuide,
                  icon: const Icon(Icons.help_outline),
                  label: Text(L10n.of('usage_guide_button')),
                ),
              ],
            );

            return Flex(
              direction: stacked ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: stacked
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                if (stacked) content else Expanded(child: content),
                SizedBox(width: stacked ? 0 : 16, height: stacked ? 16 : 0),
                statusAndActions,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final bool isCrashed;

  const _StatusPill({
    required this.icon,
    required this.text,
    required this.color,
    this.isCrashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCrashed
            ? color.withValues(alpha: 0.22)
            : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isCrashed
              ? color.withValues(alpha: 0.55)
              : color.withValues(alpha: 0.38),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
          if (isCrashed) ...[
            const SizedBox(width: 4),
            Icon(Icons.info_outline, color: color, size: 14),
          ],
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool loading;
  final Object? error;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.loading = false,
    this.error,
  });

  factory _MetricCard.loading({required String label}) {
    return _MetricCard(
      label: label,
      value: '',
      icon: Icons.hourglass_empty,
      color: const Color(0xFF64748B),
      loading: true,
    );
  }

  factory _MetricCard.error({required String label, required Object error}) {
    return _MetricCard(
      label: label,
      value: L10n.of('load_failed'),
      icon: Icons.error_outline,
      color: const Color(0xFFDC2626),
      error: error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 19),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (loading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Tooltip(
                message: error?.toString() ?? value,
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QuickStartCard extends StatelessWidget {
  final bool hasAccount;
  final bool hasUsage;
  final bool proxyRunning;
  final VoidCallback onAccountTap;
  final VoidCallback onPricingTap;
  final VoidCallback onProxyTap;
  final VoidCallback onUsageTap;
  final VoidCallback onGuideTap;

  const _QuickStartCard({
    required this.hasAccount,
    required this.hasUsage,
    required this.proxyRunning,
    required this.onAccountTap,
    required this.onPricingTap,
    required this.onProxyTap,
    required this.onUsageTap,
    required this.onGuideTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  L10n.of('quick_start_title'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onGuideTap,
                  icon: const Icon(Icons.help_outline, size: 18),
                  label: Text(L10n.of('usage_guide_button')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              L10n.of('quick_start_subtitle'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StepChip(
                  done: hasAccount,
                  text: L10n.of('quick_step_account'),
                  icon: Icons.cloud_queue_outlined,
                  onTap: onAccountTap,
                ),
                _StepChip(
                  done: false,
                  text: L10n.of('quick_step_pricing'),
                  icon: Icons.sell_outlined,
                  onTap: onPricingTap,
                ),
                _StepChip(
                  done: proxyRunning,
                  text: L10n.of('quick_step_proxy'),
                  icon: Icons.play_arrow,
                  onTap: onProxyTap,
                ),
                _StepChip(
                  done: hasUsage,
                  text: hasUsage
                      ? L10n.of('quick_step_logs')
                      : L10n.of('quick_step_usage'),
                  icon: Icons.receipt_long_outlined,
                  onTap: onUsageTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  final bool done;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _StepChip({
    required this.done,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = done
        ? const Color(0xFF16A34A)
        : Theme.of(context).colorScheme.primary;
    return ActionChip(
      avatar: Icon(done ? Icons.check_circle : icon, size: 18, color: color),
      label: Text(text),
      onPressed: onTap,
      side: BorderSide(color: color.withValues(alpha: 0.35)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w700),
      backgroundColor: color.withValues(alpha: 0.08),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final int number;
  final String text;

  const _GuideStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$number',
              style: TextStyle(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final List<UsageLog> logs;

  const _RecentActivityCard({required this.logs});

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final recentLogs = logs.take(8).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.recentActivity,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${logs.length} ${L10n.of('records')}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (recentLogs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    l10n.noLogs,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              )
            else
              for (final log in recentLogs)
                ListTile(
                  leading: Icon(
                    log.estimated
                        ? Icons.calculate_outlined
                        : Icons.verified_outlined,
                    color: log.estimated
                        ? const Color(0xFFF97316)
                        : const Color(0xFF16A34A),
                  ),
                  title: Text(
                    log.modelName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${l10n.providerName(log.providerType.name)}  ${_formatDateTime(log.requestTime)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    log.cost != null
                        ? '\$${log.cost!.toStringAsFixed(4)}'
                        : L10n.of('missing_price'),
                    style: TextStyle(
                      color: log.cost == null
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
