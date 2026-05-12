import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../../core/models/models.dart';
import '../../core/proxy/proxy_isolate.dart';

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
          SnackBar(content: Text('\${l10n.errorStartingProxy}: \$error')),
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
    if (mounted) {
      setState(() {
        _proxyUrl = 'http://\$host:\$port';
      });
    }
  }

  void _handleProxyEvent(ProxyStatusEvent event) {
    if (!mounted) return;
    final l10n = L10nLocalizations.of(context);
    setState(() {
      if (event is ProxyStarted) {
        _proxyState = ProxyState.running;
        _proxyUrl = 'http://\${event.host}:\${event.port}';
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

      final accountConfigs = <AccountConfig>[];
      for (final account in accounts) {
        if (account.enabled && account.proxyEnabled) {
          final apiKey = await accountService.getApiKey(account.id);
          if (apiKey != null) {
            accountConfigs.add(AccountConfig(
              accountId: account.id,
              providerType: account.providerType,
              displayName: account.displayName,
              baseUrl: account.baseUrl,
              apiKeyAlias: account.apiKeyAlias,
              apiKey: apiKey,
              currency: account.currency,
              enabled: account.enabled,
              proxyEnabled: account.proxyEnabled,
            ));
          }
        }
      }

      final priceConfigs = prices
          .map((p) => ModelPriceConfig(
                providerType: p.providerType,
                modelName: p.modelName,
                inputPricePer1M: p.inputPricePer1M,
                outputPricePer1M: p.outputPricePer1M,
                cachedInputPricePer1M: p.cachedInputPricePer1M,
                reasoningOutputPricePer1M: p.reasoningOutputPricePer1M,
                currency: p.currency,
              ))
          .toList();

      final settingsConfig = ProxySettings(
        enableCors: corsEnabled,
        enableHttps: false,
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
        routes: [],
        settings: settingsConfig,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.proxyStarted)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.proxyStartFailed)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('\${l10n.errorStartingProxy}: \$e')),
        );
      }
    }
  }

  Future<void> _stopProxy() async {
    await _proxyManager.stop();
  }

  Color _getStateColor() {
    switch (_proxyState) {
      case ProxyState.running:
        return Colors.green;
      case ProxyState.starting:
        return Colors.orange;
      case ProxyState.stopping:
        return Colors.blueGrey;
      case ProxyState.degraded:
        return Colors.orange;
      case ProxyState.crashed:
        return Colors.red;
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStateColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _getStateColor()),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getStateColor(),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getStateText(),
                        style: TextStyle(color: _getStateColor(), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (_proxyState == ProxyState.running)
                  ElevatedButton.icon(
                    onPressed: _stopProxy,
                    icon: const Icon(Icons.stop, size: 16),
                    label: Text(l10n.proxyStop),
                  )
                else if (_proxyState == ProxyState.stopped || _proxyState == ProxyState.crashed)
                  ElevatedButton.icon(
                    onPressed: _startProxy,
                    icon: const Icon(Icons.play_arrow, size: 16),
                    label: Text(l10n.proxyStart),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.currentProxyUrl,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _proxyUrl,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontFamily: 'monospace',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                todayCostAsync.when(
                  data: (cost) => _buildStatCard(
                    context,
                    l10n.todayCost,
                    '\$\${cost.toStringAsFixed(4)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                  loading: () => _buildLoadingCard('Loading...'),
                  error: (e, _) => _buildErrorCard('Error: \$e'),
                ),
                monthCostAsync.when(
                  data: (cost) => _buildStatCard(
                    context,
                    l10n.monthCost,
                    '\$\${cost.toStringAsFixed(4)}',
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                  loading: () => _buildLoadingCard('Loading...'),
                  error: (e, _) => _buildErrorCard('Error: \$e'),
                ),
                accountsAsync.when(
                  data: (accounts) => _buildStatCard(
                    context,
                    l10n.totalAccounts,
                    '\${accounts.length}',
                    Icons.cloud,
                    Colors.purple,
                  ),
                  loading: () => _buildLoadingCard('Loading...'),
                  error: (e, _) => _buildErrorCard('Error: \$e'),
                ),
                usageLogsAsync.when(
                  data: (logs) => _buildStatCard(
                    context,
                    l10n.totalRequests,
                    '\${logs.length}',
                    Icons.list_alt,
                    Colors.orange,
                  ),
                  loading: () => _buildLoadingCard('Loading...'),
                  error: (e, _) => _buildErrorCard('Error: \$e'),
                ),
                _buildStatCard(
                  context,
                  l10n.estimatedRecords,
                  '\${usageLogsAsync.value?.where((l) => l.estimated).length ?? 0}',
                  Icons.calculate,
                  Colors.red,
                ),
                _buildStatCard(
                  context,
                  l10n.totalTokens,
                  _formatTokens(usageLogsAsync.value),
                  Icons.data_usage,
                  Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              l10n.recentActivity,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            usageLogsAsync.when(
              data: (logs) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.take(10).length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return ListTile(
                    leading: Icon(
                      log.estimated ? Icons.calculate : Icons.check_circle,
                      color: log.estimated ? Colors.orange : Colors.green,
                    ),
                    title: Text(log.modelName),
                    subtitle: Text(
                      '\${l10n.providerName(log.providerType.name)} \${_formatDateTime(log.requestTime)}',
                    ),
                    trailing: Text(
                      log.cost != null ? '\$\${log.cost!.toStringAsFixed(4)}' : '-',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: \$e')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard(String text) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String text) {
    return Card(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.red, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _formatTokens(List<UsageLog>? logs) {
    if (logs == null) return '0';
    final total = logs.fold(0, (sum, log) {
      return sum + (log.totalTokens ?? 0);
    });
    if (total > 1000000) {
      return '\${(total / 1000000).toStringAsFixed(2)}M';
    } else if (total > 1000) {
      return '\${(total / 1000).toStringAsFixed(2)}K';
    }
    return '\$total';
  }

  String _formatDateTime(DateTime dateTime) {
    return '\${dateTime.year}-\${dateTime.month.toString().padLeft(2, '0')}-\${dateTime.day.toString().padLeft(2, '0')} '
        '\${dateTime.hour.toString().padLeft(2, '0')}:\${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
