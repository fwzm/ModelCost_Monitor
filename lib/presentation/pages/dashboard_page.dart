import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../../core/models/models.dart';
import '../../core/proxy/proxy_isolate.dart';
import '../theme/app_theme.dart';
import 'accounts_page.dart';
import 'help_page.dart';
import 'pricing_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final _proxyManager = ProxyIsolateManager();
  ProxyState _proxyState = ProxyState.stopped;
  String _proxyUrl = 'http://127.0.0.1:8787';

  @override
  void initState() {
    super.initState();
    _proxyManager.onEvent = _handleProxyEvent;
    _proxyManager.onError = (error) {
      if (mounted) {
        final l10n = L10nLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorStartingProxy}: $error')),
        );
      }
    };
    _loadProxySettings();
  }

  @override
  void dispose() {
    _proxyManager.dispose();
    super.dispose();
  }

  Future<void> _loadProxySettings() async {
    final settings = ref.read(settingsServiceProvider);
    final host = await settings.getProxyHost();
    final port = await settings.getProxyPort();
    final httpsEnabled = await settings.isHttpsEnabled();
    if (mounted) {
      setState(() {
        _proxyUrl = '${httpsEnabled ? 'https' : 'http'}://$host:$port';
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
        final settings = ref.read(settingsServiceProvider);
        settings.setSetting('proxy_port', event.newPort.toString());
        _loadProxySettings();
      }
    });
  }

  Future<void> _startProxy() async {
    final l10n = L10nLocalizations.of(context);
    try {
      final accountService = ref.read(accountServiceProvider);
      final pricingService = ref.read(pricingServiceProvider);

      final accounts = await accountService.getAllAccounts();
      final prices = await pricingService.getAllPrices();
      final settings = ref.read(settingsServiceProvider);

      final host = await settings.getProxyHost();
      final port = await settings.getProxyPort();
      final corsEnabled = await settings.isCorsEnabled();
      final httpsEnabled = await settings.isHttpsEnabled();

      final accountConfigs = <AccountConfig>[];
      for (final account in accounts) {
        if (account.enabled && account.proxyEnabled) {
          final apiKey = await accountService.getApiKey(account.id);
          if (apiKey != null) {
            accountConfigs.add(
              AccountConfig(
                accountId: account.id,
                providerType: ProviderType.values.firstWhere(
                  (e) => e.name == account.providerType,
                  orElse: () => ProviderType.customOpenAI,
                ),
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
        }
      }

      final priceConfigs = prices
          .map(
            (p) => ModelPriceConfig(
              providerType: ProviderType.values.firstWhere(
                (e) => e.name == p.providerType,
                orElse: () => ProviderType.customOpenAI,
              ),
              modelName: p.modelName,
              inputPricePer1M: p.inputPricePer1M,
              outputPricePer1M: p.outputPricePer1M,
              cachedInputPricePer1M: p.cachedInputPricePer1M,
              reasoningOutputPricePer1M: p.reasoningOutputPricePer1M,
              currency: p.currency,
            ),
          )
          .toList();

      final settingsConfig = ProxySettings(
        enableCors: corsEnabled,
        enableHttps: httpsEnabled,
        enableTokenizerFallback: true,
        requestTimeoutPolicy: 'streamingCompletion',
        uiRefreshIntervalMs: 500,
        maxRetries: 5,
        retryBaseIntervalMs: 100,
      );

      final success = await _proxyManager.start(
        host: host,
        port: port,
        accounts: accountConfigs,
        prices: priceConfigs,
        routes: _buildDefaultRoutes(accountConfigs),
        settings: settingsConfig,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.proxyStarted)));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.proxyStartFailed)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorStartingProxy}: $e')),
        );
      }
    }
  }

  Future<void> _stopProxy() async {
    await _proxyManager.stop();
  }

  List<ProxyRouteConfig> _buildDefaultRoutes(List<AccountConfig> accounts) {
    final routes = <ProxyRouteConfig>[];
    final genericProviderRoutes = <String>{};

    for (final account in accounts) {
      final accountId = account.accountId;
      if (accountId == null) continue;

      final providerPath = _providerPath(account.providerType);
      final accountRoute = '/proxy/$providerPath/$accountId';
      routes.add(
        ProxyRouteConfig(
          pathPrefix: accountRoute,
          accountId: accountId,
          targetBaseUrl: account.baseUrl,
        ),
      );

      final genericRoute = '/proxy/$providerPath';
      if (genericProviderRoutes.add(genericRoute)) {
        routes.add(
          ProxyRouteConfig(
            pathPrefix: genericRoute,
            accountId: accountId,
            targetBaseUrl: account.baseUrl,
          ),
        );
      }
    }

    return routes;
  }

  String _providerPath(ProviderType type) {
    switch (type) {
      case ProviderType.customOpenAI:
        return 'custom';
      case ProviderType.deepseek:
      case ProviderType.mimo:
      case ProviderType.gemini:
      case ProviderType.openrouter:
        return type.name;
    }
  }

  Color _getStateColor() {
    switch (_proxyState) {
      case ProxyState.running:
        return AppTheme.success;
      case ProxyState.starting:
        return AppTheme.warning;
      case ProxyState.stopping:
        return Colors.blueGrey;
      case ProxyState.degraded:
        return AppTheme.warning;
      case ProxyState.crashed:
        return AppTheme.error;
      case ProxyState.stopped:
        return Colors.grey;
    }
  }

  String _getStateText() {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          _buildProxyControl(l10n),
          const SizedBox(width: AppTheme.spaceM),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayCostProvider);
          ref.invalidate(monthCostProvider);
          ref.invalidate(accountsProvider);
          ref.invalidate(usageLogsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 代理地址卡片 ──
              _buildProxyUrlCard(l10n),
              _buildSetupPanel(accountsAsync, usageLogsAsync, l10n),

              // ── 统计卡片 ──
              _buildStatsGrid(
                todayCostAsync,
                monthCostAsync,
                accountsAsync,
                usageLogsAsync,
              ),
              const SizedBox(height: AppTheme.spaceXL),

              // ── 最近活动 ──
              Text(
                l10n.recentActivity,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppTheme.spaceM),
              usageLogsAsync.when(
                data: (logs) => _buildRecentList(logs, l10n),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 代理控制区 ──────────────────────────────────────────
  Widget _buildProxyControl(L10nLocalizations l10n) {
    final stateColor = _getStateColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: stateColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: stateColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: stateColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: stateColor.withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _getStateText(),
            style: TextStyle(
              color: stateColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          if (_proxyState == ProxyState.running)
            _proxyButton(l10n.proxyStop, Icons.stop_rounded, _stopProxy)
          else if (_proxyState == ProxyState.stopped ||
              _proxyState == ProxyState.crashed)
            _proxyButton(
              l10n.proxyStart,
              Icons.play_arrow_rounded,
              _startProxy,
            ),
        ],
      ),
    );
  }

  Widget _proxyButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 代理地址卡片 ────────────────────────────────────────
  Widget _buildProxyUrlCard(L10nLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: AppTheme.shadowM(Theme.of(context).colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.swap_horiz_rounded,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                l10n.currentProxyUrl,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const Spacer(),
              _copyButton(l10n),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            _proxyUrl,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _copyButton(L10nLocalizations l10n) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Clipboard.setData(ClipboardData(text: _proxyUrl));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(L10nLocalizations.of(context).addressCopied),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.copy_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                l10n.copy,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 统计网格 ────────────────────────────────────────────
  Widget _buildStatsGrid(
    AsyncValue<double> todayCost,
    AsyncValue<double> monthCost,
    AsyncValue<List<Account>> accounts,
    AsyncValue<List<UsageLog>> logs,
  ) {
    final items = [
      _StatItem(
        L10nLocalizations.of(context).todayCost,
        todayCost.when(
          data: (v) => '\$${v.toStringAsFixed(4)}',
          loading: () => '...',
          error: (_, _) => '-',
        ),
        Icons.attach_money_rounded,
        0,
      ),
      _StatItem(
        L10nLocalizations.of(context).monthCost,
        monthCost.when(
          data: (v) => '\$${v.toStringAsFixed(4)}',
          loading: () => '...',
          error: (_, _) => '-',
        ),
        Icons.calendar_month_rounded,
        1,
      ),
      _StatItem(
        L10nLocalizations.of(context).totalAccounts,
        accounts.when(
          data: (v) => '${v.length}',
          loading: () => '...',
          error: (_, _) => '-',
        ),
        Icons.cloud_rounded,
        2,
      ),
      _StatItem(
        L10nLocalizations.of(context).totalRequests,
        logs.when(
          data: (v) => '${v.length}',
          loading: () => '...',
          error: (_, _) => '-',
        ),
        Icons.list_alt_rounded,
        3,
      ),
      _StatItem(
        L10nLocalizations.of(context).estimatedRecords,
        '${logs.value?.where((l) => l.estimated).length ?? 0}',
        Icons.calculate_rounded,
        4,
      ),
      _StatItem(
        L10nLocalizations.of(context).totalTokens,
        _formatTokens(logs.value),
        Icons.data_usage_rounded,
        5,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1180
            ? 6
            : width >= 760
            ? 3
            : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: AppTheme.spaceM,
          mainAxisSpacing: AppTheme.spaceM,
          childAspectRatio: columns >= 6 ? 1.25 : 1.45,
          children: items
              .asMap()
              .entries
              .map((e) => _buildGradientStatCard(e.value))
              .toList(),
        );
      },
    );
  }

  Widget _buildSetupPanel(
    AsyncValue<List<Account>> accounts,
    AsyncValue<List<UsageLog>> logs,
    L10nLocalizations l10n,
  ) {
    final hasAccounts = accounts.valueOrNull?.isNotEmpty ?? false;
    final hasLogs = logs.valueOrNull?.isNotEmpty ?? false;
    if (hasAccounts && hasLogs) {
      return const SizedBox(height: AppTheme.spaceXL);
    }

    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppTheme.spaceM,
        bottom: AppTheme.spaceXL,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spaceL),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Wrap(
          spacing: AppTheme.spaceM,
          runSpacing: AppTheme.spaceM,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch_rounded, color: colorScheme.primary),
                  const SizedBox(width: AppTheme.spaceM),
                  Flexible(
                    child: Text(
                      hasAccounts
                          ? l10n.helpStep3StartProxy
                          : l10n.helpStep1AddAccount,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: AppTheme.spaceS,
              runSpacing: AppTheme.spaceS,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AccountsPage()),
                  ),
                  icon: const Icon(Icons.cloud_rounded),
                  label: Text(l10n.addAccount),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PricingPage()),
                  ),
                  icon: const Icon(Icons.price_change_rounded),
                  label: Text(l10n.navPricing),
                ),
                OutlinedButton.icon(
                  onPressed: _proxyState == ProxyState.running
                      ? null
                      : _startProxy,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l10n.proxyStart),
                ),
                IconButton.filledTonal(
                  tooltip: l10n.navHelp,
                  onPressed: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const HelpPage())),
                  icon: const Icon(Icons.help_outline_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientStatCard(_StatItem item) {
    final gradient =
        AppTheme.statGradients[item.colorIndex % AppTheme.statGradients.length];
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: AppTheme.shadowS(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                item.icon,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            item.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── 最近活动列表 ────────────────────────────────────────
  Widget _buildRecentList(List<UsageLog> logs, L10nLocalizations l10n) {
    if (logs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox_rounded, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(l10n.noLogs, style: TextStyle(color: Colors.grey[500])),
            ],
          ),
        ),
      );
    }
    return Column(
      children: logs
          .take(10)
          .map((log) => _buildRecentItem(log, l10n))
          .toList(),
    );
  }

  Widget _buildRecentItem(UsageLog log, L10nLocalizations l10n) {
    final isEstimated = log.estimated;
    final statusColor = isEstimated ? AppTheme.warning : AppTheme.success;
    final statusIcon = isEstimated
        ? Icons.calculate_rounded
        : Icons.check_circle_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceS),
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceL,
        vertical: AppTheme.spaceM,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusS),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.modelName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${l10n.providerName(log.providerType)}  ${_formatDateTime(log.requestTime)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            log.cost != null ? '\$${log.cost!.toStringAsFixed(4)}' : '-',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTokens(List<UsageLog>? logs) {
    if (logs == null) return '0';
    final total = logs.fold(0, (sum, log) => sum + (log.totalTokens ?? 0));
    if (total > 1000000) {
      return '${(total / 1000000).toStringAsFixed(2)}M';
    } else if (total > 1000) {
      return '${(total / 1000).toStringAsFixed(2)}K';
    }
    return '$total';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final int colorIndex;
  const _StatItem(this.label, this.value, this.icon, this.colorIndex);
}
