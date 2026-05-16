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
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'csv',
                child: Row(
                  children: [
                    const Icon(Icons.table_chart),
                    const SizedBox(width: 8),
                    Text(l10n.exportCsv),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'json',
                child: Row(
                  children: [
                    const Icon(Icons.code),
                    const SizedBox(width: 8),
                    Text(l10n.exportJson),
                  ],
                ),
              ),
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
                  const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noLogs,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredLogs.length,
            itemBuilder: (context, index) {
              final log = filteredLogs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    _getStatusIcon(log),
                    color: _getStatusColor(log),
                  ),
                  title: Text(log.modelName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.providerName(log.providerType.name)} ${_formatDateTime(log.requestTime)}',
                      ),
                      Text(
                        'P: ${log.promptTokens ?? 0} | C: ${log.completionTokens ?? 0} | T: ${log.totalTokens ?? 0}',
                      ),
                      if (log.estimated)
                        Text(
                          'Estimated',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        log.cost != null
                            ? '\$${log.cost!.toStringAsFixed(4)}'
                            : '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.requestStatusName(log.requestStatus.name),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getStatusColor(log),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  List<UsageLog> _applyFilters(List<UsageLog> logs) {
    return logs.where((log) {
      if (_filterProvider != null && log.providerType != _filterProvider) {
        return false;
      }
      if (_filterModel != null && log.modelName != _filterModel) return false;
      if (_filterFrom != null && log.requestTime.isBefore(_filterFrom!)) {
        return false;
      }
      if (_filterTo != null && log.requestTime.isAfter(_filterTo!)) {
        return false;
      }
      if (_filterEstimatedOnly && !log.estimated) return false;
      if (_filterStatus != null && log.requestStatus != _filterStatus) {
        return false;
      }
      return true;
    }).toList();
  }

  IconData _getStatusIcon(UsageLog log) {
    if (log.estimated) return Icons.calculate;
    switch (log.requestStatus) {
      case RequestStatus.completed:
        return Icons.check_circle;
      case RequestStatus.interrupted:
        return Icons.warning;
      case RequestStatus.timeout:
        return Icons.timer_off;
      case RequestStatus.clientCancelled:
        return Icons.cancel;
      case RequestStatus.providerError:
        return Icons.error;
      case RequestStatus.parseError:
        return Icons.bug_report;
      case RequestStatus.estimatedOnly:
        return Icons.calculate;
    }
  }

  Color _getStatusColor(UsageLog log) {
    if (log.estimated) return Colors.orange;
    switch (log.requestStatus) {
      case RequestStatus.completed:
        return Colors.green;
      case RequestStatus.interrupted:
        return Colors.orange;
      case RequestStatus.timeout:
        return Colors.red;
      case RequestStatus.clientCancelled:
        return Colors.blueGrey;
      case RequestStatus.providerError:
        return Colors.red;
      case RequestStatus.parseError:
        return Colors.orange;
      case RequestStatus.estimatedOnly:
        return Colors.orange;
    }
  }

  void _showFilterDialog() {
    final l10n = L10nLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.filter),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ProviderType?>(
                  initialValue: _filterProvider,
                  decoration: InputDecoration(labelText: l10n.filterProvider),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All')),
                    ...ProviderType.values.map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(l10n.providerName(type.name)),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      _filterProvider = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.filterEstimated),
                  value: _filterEstimatedOnly,
                  onChanged: (value) {
                    setDialogState(() {
                      _filterEstimatedOnly = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setDialogState(() {
                  _filterProvider = null;
                  _filterModel = null;
                  _filterFrom = null;
                  _filterTo = null;
                  _filterEstimatedOnly = false;
                  _filterStatus = null;
                });
              },
              child: const Text('Reset'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
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
      final csvData = _exportToCsv(filteredLogs);
      await _saveFile(csvData, 'modelcost_logs.csv', 'text/csv');
    } else if (type == 'json') {
      final jsonData = _exportToJson(filteredLogs);
      await _saveFile(jsonData, 'modelcost_logs.json', 'application/json');
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Export completed')));
    }
  }

  String _exportToCsv(List<UsageLog> logs) {
    final csvData = [
      [
        'ID',
        'Provider',
        'Model',
        'Request Time',
        'Prompt Tokens',
        'Completion Tokens',
        'Cached Tokens',
        'Reasoning Tokens',
        'Total Tokens',
        'Estimated',
        'Cost',
        'Currency',
        'Status',
        'Source',
      ],
      ...logs.map(
        (log) => [
          log.id,
          log.providerType.name,
          log.modelName,
          log.requestTime.toIso8601String(),
          log.promptTokens ?? 0,
          log.completionTokens ?? 0,
          log.cachedTokens ?? 0,
          log.reasoningTokens ?? 0,
          log.totalTokens ?? 0,
          log.estimated,
          log.cost ?? 0.0,
          log.currency,
          log.requestStatus.name,
          log.source.name,
        ],
      ),
    ];
    return const ListToCsvConverter().convert(csvData);
  }

  String _exportToJson(List<UsageLog> logs) {
    final data = logs
        .map(
          (log) => {
            'id': log.id,
            'provider': log.providerType.name,
            'model': log.modelName,
            'requestTime': log.requestTime.toIso8601String(),
            'promptTokens': log.promptTokens,
            'completionTokens': log.completionTokens,
            'cachedTokens': log.cachedTokens,
            'reasoningTokens': log.reasoningTokens,
            'totalTokens': log.totalTokens,
            'estimated': log.estimated,
            'lowConfidence': log.lowConfidence,
            'cost': log.cost,
            'currency': log.currency,
            'status': log.requestStatus.name,
            'source': log.source.name,
            'createdAt': log.createdAt.toIso8601String(),
          },
        )
        .toList();
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<void> _saveFile(
    String content,
    String fileName,
    String mimeType,
  ) async {
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save $fileName',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: [fileName.split('.').last],
    );

    if (result != null) {
      final file = File(result);
      await file.writeAsString(content);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
