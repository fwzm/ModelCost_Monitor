import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/proxy/proxy_isolate.dart';
import '../../data/database/database.dart';
import '../../l10n/l10n.dart';
import '../../providers/providers.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  late final ProxyIsolateManager _proxyManager;
  ProxyState _proxyState = ProxyState.stopped;
  String _proxyUrl = 'http://127.0.0.1:8787';

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
      final l10n = L10nLocalizations.of(context);
      setState(() => _proxyState = ProxyState.crashed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.errorStartingProxy}: $error')),
      );
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.proxyStarted)));
      } else {
        setState(() => _proxyState = ProxyState.crashed);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.proxyStartFailed)));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _proxyState = ProxyState.crashed);
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

  Color _stateColor(ColorScheme colorScheme) {
    switch (_proxyState) {
      case ProxyState.running:
        return const Color(0xFF16A34A);
      case ProxyState.starting:
      case ProxyState.stopping:
        return const Color(0xFFCA8A04);
      case ProxyState.degraded:
        return const Color(0xFFF97316);
      case ProxyState.crashed:
        return colorScheme.error;
      case ProxyState.stopped:
        return colorScheme.onSurfaceVariant;
    }
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
              stateColor: _stateColor(Theme.of(context).colorScheme),
              isRunning: _proxyState == ProxyState.running,
              isBusy:
                  _proxyState == ProxyState.starting ||
                  _proxyState == ProxyState.stopping,
              onStart: _startProxy,
              onStop: _stopProxy,
              onCopy: _copyProxyUrl,
            ),
            const SizedBox(height: 16),
            if (accounts.isEmpty || logs.isEmpty) ...[
              _QuickStartCard(
                hasAccount: accounts.isNotEmpty,
                hasUsage: logs.isNotEmpty,
                proxyRunning: _proxyState == ProxyState.running,
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
  final Color stateColor;
  final bool isRunning;
  final bool isBusy;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCopy;

  const _ProxyHero({
    required this.proxyUrl,
    required this.stateText,
    required this.stateIcon,
    required this.stateColor,
    required this.isRunning,
    required this.isBusy,
    required this.onStart,
    required this.onStop,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 720;
            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.currentProxyUrl,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
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
                        color: colorScheme.primary,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Tooltip(
                      message: l10n.copyAddress,
                      child: IconButton.filledTonal(
                        onPressed: onCopy,
                        icon: const Icon(Icons.copy, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  L10n.of('proxy_url_hint'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
            final statusAndActions = Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: stacked ? WrapAlignment.start : WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _StatusPill(
                  icon: stateIcon,
                  text: stateText,
                  color: stateColor,
                ),
                FilledButton.icon(
                  onPressed: isBusy ? null : (isRunning ? onStop : onStart),
                  icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(isRunning ? l10n.proxyStop : l10n.proxyStart),
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

  const _StatusPill({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
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
        padding: const EdgeInsets.all(16),
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
                    borderRadius: BorderRadius.circular(8),
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

  const _QuickStartCard({
    required this.hasAccount,
    required this.hasUsage,
    required this.proxyRunning,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final steps = [
      (hasAccount, L10n.of('quick_step_account')),
      (proxyRunning, L10n.of('quick_step_proxy')),
      (hasUsage, L10n.of('quick_step_usage')),
    ];

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
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final step in steps)
                  _StepChip(done: step.$1, text: step.$2),
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

  const _StepChip({required this.done, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = done
        ? const Color(0xFF16A34A)
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
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
