import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../../core/models/models.dart';
import '../theme/app_theme.dart';

class LogsPage extends ConsumerStatefulWidget {
  const LogsPage({super.key});

  @override
  ConsumerState<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends ConsumerState<LogsPage> {
  ProviderType? _filterProvider;
  String? _filterModel;
  DateTime? _filterFrom;
  DateTime? _filterTo;
  bool _filterEstimatedOnly = false;
  RequestStatus? _filterStatus;

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final usageLogsAsync = ref.watch(usageLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.logsPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: _showFilterDialog,
            tooltip: l10n.filter,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.download_rounded),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'csv', child: Row(children: [const Icon(Icons.table_chart_rounded), const SizedBox(width: 8), Text(l10n.exportCsv)])),
              PopupMenuItem(value: 'json', child: Row(children: [const Icon(Icons.code_rounded), const SizedBox(width: 8), Text(l10n.exportJson)])),
            ],
            onSelected: _exportData,
          ),
        ],
      ),
      body: usageLogsAsync.when(
        data: (logs) {
          final filteredLogs = _applyFilters(logs);
          if (filteredLogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(l10n.noLogs, style: TextStyle(fontSize: 18, color: Colors.grey[500])),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            itemCount: filteredLogs.length,
            itemBuilder: (context, index) {
              final log = filteredLogs[index];
              return _buildLogItem(log, l10n);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildLogItem(UsageLog log, L10nLocalizations l10n) {
    final statusColor = _getStatusColor(log);
    final statusIcon = _getStatusIcon(log);

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceS),
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(log.modelName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ),
              if (log.cost != null)
                Text(
                  '\$${log.cost!.toStringAsFixed(4)}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _statusChip(l10n.requestStatusName(log.requestStatus), statusIcon, statusColor),
              if (log.estimated) ...[
                const SizedBox(width: 6),
                _statusChip('Estimated', Icons.calculate_rounded, AppTheme.warning),
              ],
              const SizedBox(width: 6),
              Text(
                _formatDateTime(log.requestTime),
                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.providerName(log.providerType),
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _tokenBadge('P', log.promptTokens ?? 0, AppTheme.info),
              const SizedBox(width: 6),
              _tokenBadge('C', log.completionTokens ?? 0, AppTheme.success),
              const SizedBox(width: 6),
              _tokenBadge('T', log.totalTokens ?? 0, AppTheme.deepseekBrand),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _tokenBadge(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('$label: $value', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500, fontFamily: 'monospace')),
    );
  }

  List<UsageLog> _applyFilters(List<UsageLog> logs) {
    return logs.where((log) {
      if (_filterProvider != null && log.providerType != _filterProvider!.name) return false;
      if (_filterModel != null && log.modelName != _filterModel) return false;
      if (_filterFrom != null && log.requestTime.isBefore(_filterFrom!)) return false;
      if (_filterTo != null && log.requestTime.isAfter(_filterTo!)) return false;
      if (_filterEstimatedOnly && !log.estimated) return false;
      if (_filterStatus != null && log.requestStatus != _filterStatus!.name) return false;
      return true;
    }).toList();
  }

  IconData _getStatusIcon(UsageLog log) {
    if (log.estimated) return Icons.calculate_rounded;
    switch (log.requestStatus) {
      case 'completed':     return Icons.check_circle_rounded;
      case 'interrupted':   return Icons.warning_rounded;
      case 'timeout':       return Icons.timer_off_rounded;
      case 'clientCancelled': return Icons.cancel_rounded;
      case 'providerError': return Icons.error_rounded;
      case 'parseError':    return Icons.bug_report_rounded;
      case 'estimatedOnly': return Icons.calculate_rounded;
      default: return Icons.help_rounded;
    }
  }

  Color _getStatusColor(UsageLog log) {
    if (log.estimated) return AppTheme.warning;
    switch (log.requestStatus) {
      case 'completed':     return AppTheme.success;
      case 'interrupted':   return AppTheme.warning;
      case 'timeout':       return AppTheme.error;
      case 'clientCancelled': return Colors.blueGrey;
      case 'providerError': return AppTheme.error;
      case 'parseError':    return AppTheme.warning;
      case 'estimatedOnly': return AppTheme.warning;
      default: return Colors.grey;
    }
  }

  void _showFilterDialog() {
    final l10n = L10nLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(children: [const Icon(Icons.filter_list_rounded), const SizedBox(width: 8), Text(l10n.filter)]),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusL)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ProviderType?>(
                  initialValue: _filterProvider,
                  decoration: InputDecoration(labelText: l10n.filterProvider),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All')),
                    ...ProviderType.values.map((type) => DropdownMenuItem(value: type, child: Text(l10n.providerName(type.name)))),
                  ],
                  onChanged: (value) => setDialogState(() => _filterProvider = value),
                ),
                SwitchListTile(
                  title: Text(l10n.filterEstimated),
                  value: _filterEstimatedOnly,
                  onChanged: (value) => setDialogState(() => _filterEstimatedOnly = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => setDialogState(() {
                _filterProvider = null; _filterModel = null;
                _filterFrom = null; _filterTo = null;
                _filterEstimatedOnly = false; _filterStatus = null;
              }),
              child: const Text('Reset'),
            ),
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () { setState(() {}); Navigator.pop(context); },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(String type) async {
    final usageLogs = ref.read(usageLogsProvider).value ?? [];
    if (usageLogs.isEmpty) return;
    final filteredLogs = _applyFilters(usageLogs);
    if (type == 'csv') {
      await _saveFile(_exportToCsv(filteredLogs), 'modelcost_logs.csv', 'text/csv');
    } else if (type == 'json') {
      await _saveFile(_exportToJson(filteredLogs), 'modelcost_logs.json', 'application/json');
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export completed')));
    }
  }

  String _exportToCsv(List<UsageLog> logs) {
    final csvData = [
      ['ID', 'Provider', 'Model', 'Request Time', 'Prompt Tokens', 'Completion Tokens', 'Cached Tokens', 'Reasoning Tokens', 'Total Tokens', 'Estimated', 'Cost', 'Currency', 'Status', 'Source'],
      ...logs.map((log) => [log.id, log.providerType, log.modelName, log.requestTime.toIso8601String(), log.promptTokens ?? 0, log.completionTokens ?? 0, log.cachedTokens ?? 0, log.reasoningTokens ?? 0, log.totalTokens ?? 0, log.estimated, log.cost ?? 0.0, log.currency, log.requestStatus, log.source]),
    ];
    return const ListToCsvConverter().convert(csvData);
  }

  String _exportToJson(List<UsageLog> logs) {
    final data = logs.map((log) => {
      'id': log.id, 'provider': log.providerType, 'model': log.modelName,
      'requestTime': log.requestTime.toIso8601String(),
      'promptTokens': log.promptTokens, 'completionTokens': log.completionTokens,
      'cachedTokens': log.cachedTokens, 'reasoningTokens': log.reasoningTokens,
      'totalTokens': log.totalTokens, 'estimated': log.estimated,
      'lowConfidence': log.lowConfidence, 'cost': log.cost, 'currency': log.currency,
      'status': log.requestStatus, 'source': log.source, 'createdAt': log.createdAt.toIso8601String(),
    }).toList();
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<void> _saveFile(String content, String fileName, String mimeType) async {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save $fileName', fileName: fileName,
      type: FileType.custom, allowedExtensions: [fileName.split('.').last],
    );
    if (result != null) {
      await File(result).writeAsString(content);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
