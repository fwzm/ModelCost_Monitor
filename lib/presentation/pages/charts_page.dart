import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../theme/app_theme.dart';

class ChartsPage extends ConsumerStatefulWidget {
  const ChartsPage({super.key});

  @override
  ConsumerState<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends ConsumerState<ChartsPage> {
  int _selectedChart = 0;

  static const _chartLabels = [
    'chart_daily_cost',
    'chart_model_cost',
    'chart_token_comparison',
    'chart_fee_trend',
    'chart_estimated_vs_official',
  ];

  @override
  Widget build(BuildContext context) {
    final usageLogsAsync = ref.watch(usageLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10nLocalizations.of(context).navCharts),
      ),
      body: Column(
        children: [
          // ── ChoiceChip 选择器 ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceL, vertical: AppTheme.spaceS),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _chartLabels.asMap().entries.map((e) {
                  final selected = _selectedChart == e.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spaceS),
                    child: ChoiceChip(
                      label: Text(L10n.of(e.value)),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedChart = e.key),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // ── 图表区域 ──
          Expanded(
            child: usageLogsAsync.when(
              data: (logs) => _buildSelectedChart(logs),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedChart(List<UsageLog> logs) {
    switch (_selectedChart) {
      case 0: return _buildDailyCostChart(logs);
      case 1: return _buildModelCostChart(logs);
      case 2: return _buildTokenComparisonChart(logs);
      case 3: return _buildFeeTrendChart(logs);
      case 4: return _buildEstimatedVsOfficialChart(logs);
      default: return _buildDailyCostChart(logs);
    }
  }

  // ── 通用图形容器 ──
  Widget _chartContainer(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spaceL),
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppTheme.spaceL),
          Expanded(child: child),
        ],
      ),
    );
  }

  // ── 每日消耗 ──
  Widget _buildDailyCostChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final dailyCost = <String, double>{};
    for (final log in logs) {
      if (log.cost == null) continue;
      final dk = '${log.requestTime.year}-${log.requestTime.month.toString().padLeft(2, '0')}-${log.requestTime.day.toString().padLeft(2, '0')}';
      dailyCost[dk] = (dailyCost[dk] ?? 0) + log.cost!;
    }
    final sortedKeys = dailyCost.keys.toList()..sort();
    final spots = [for (int i = 0; i < sortedKeys.length; i++) FlSpot(i.toDouble(), dailyCost[sortedKeys[i]]!)];

    return _chartContainer(l10n.chartDailyCost, spots.isEmpty
        ? const Center(child: Text('No data'))
        : LineChart(LineChartData(
            gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey[200]!, strokeWidth: 1)),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 48)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= sortedKeys.length) return const Text('');
                final p = sortedKeys[i].split('-');
                return Text('${p[1]}-${p[2]}', style: const TextStyle(fontSize: 10));
              })),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [LineChartBarData(
              spots: spots, isCurved: true,
              color: AppTheme.info, barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: AppTheme.info.withValues(alpha: 0.15)),
            )],
          )));
  }

  // ── 模型占比 ──
  Widget _buildModelCostChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final modelCost = <String, double>{};
    for (final log in logs) {
      if (log.cost == null) continue;
      modelCost[log.modelName] = (modelCost[log.modelName] ?? 0) + log.cost!;
    }
    final sorted = modelCost.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total = modelCost.values.fold(0.0, (a, b) => a + b);
    final colors = [AppTheme.info, AppTheme.success, AppTheme.warning, AppTheme.mimoBrand, AppTheme.error, AppTheme.customOpenAIBrand];
    final sections = sorted.asMap().entries.map((e) => PieChartSectionData(
      color: colors[e.key % colors.length],
      value: e.value.value,
      title: '${(e.value.value * 100 / total).toStringAsFixed(1)}%',
      radius: 80,
      titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
    )).toList();

    return _chartContainer(l10n.chartModelCost, sections.isEmpty
        ? const Center(child: Text('No data'))
        : Column(children: [
            Expanded(child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 36))),
            const SizedBox(height: AppTheme.spaceM),
            Wrap(spacing: 12, runSpacing: 6, children: sorted.asMap().entries.map((e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[e.key % colors.length], borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 4),
                Text('${e.value.key}: \$${e.value.value.toStringAsFixed(4)}', style: const TextStyle(fontSize: 12)),
              ],
            )).toList()),
          ]));
  }

  // ── Token 对比 ──
  Widget _buildTokenComparisonChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final dailyP = <String, int>{}, dailyC = <String, int>{};
    for (final log in logs) {
      final dk = '${log.requestTime.year}-${log.requestTime.month.toString().padLeft(2, '0')}-${log.requestTime.day.toString().padLeft(2, '0')}';
      dailyP[dk] = (dailyP[dk] ?? 0) + (log.promptTokens ?? 0);
      dailyC[dk] = (dailyC[dk] ?? 0) + (log.completionTokens ?? 0);
    }
    final keys = dailyP.keys.toList()..sort();
    final pSpots = [for (int i = 0; i < keys.length; i++) FlSpot(i.toDouble(), dailyP[keys[i]]!.toDouble())];
    final cSpots = [for (int i = 0; i < keys.length; i++) FlSpot(i.toDouble(), dailyC[keys[i]]!.toDouble())];

    return _chartContainer(l10n.chartTokenComparison, pSpots.isEmpty
        ? const Center(child: Text('No data'))
        : Column(children: [
            Expanded(child: LineChart(LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey[200]!, strokeWidth: 1)),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 48)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= keys.length) return const Text('');
                  final p = keys[i].split('-');
                  return Text('${p[1]}-${p[2]}', style: const TextStyle(fontSize: 10));
                })),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(spots: pSpots, isCurved: true, color: AppTheme.info, barWidth: 2, dotData: const FlDotData(show: false)),
                LineChartBarData(spots: cSpots, isCurved: true, color: AppTheme.success, barWidth: 2, dotData: const FlDotData(show: false)),
              ],
            ))),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [_legend('Prompt', AppTheme.info), const SizedBox(width: 16), _legend('Completion', AppTheme.success)]),
          ]));
  }

  // ── 费用趋势 ──
  Widget _buildFeeTrendChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final dailyCost = <String, double>{};
    for (final log in logs) {
      if (log.cost == null) continue;
      final dk = '${log.requestTime.year}-${log.requestTime.month.toString().padLeft(2, '0')}-${log.requestTime.day.toString().padLeft(2, '0')}';
      dailyCost[dk] = (dailyCost[dk] ?? 0) + log.cost!;
    }
    final keys = dailyCost.keys.toList()..sort();
    final bars = [for (int i = 0; i < keys.length; i++) BarChartGroupData(x: i, barRods: [BarChartRodData(toY: dailyCost[keys[i]]!, color: AppTheme.warning, width: 14, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))])];

    return _chartContainer(l10n.chartFeeTrend, bars.isEmpty
        ? const Center(child: Text('No data'))
        : BarChart(BarChartData(
            gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey[200]!, strokeWidth: 1)),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 48)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= keys.length) return const Text('');
                final p = keys[i].split('-');
                return Text('${p[1]}-${p[2]}', style: const TextStyle(fontSize: 10));
              })),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: bars,
          )));
  }

  // ── 估算 vs 官方 ──
  Widget _buildEstimatedVsOfficialChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final dailyE = <String, int>{}, dailyO = <String, int>{};
    for (final log in logs) {
      final dk = '${log.requestTime.year}-${log.requestTime.month.toString().padLeft(2, '0')}-${log.requestTime.day.toString().padLeft(2, '0')}';
      if (log.estimated) { dailyE[dk] = (dailyE[dk] ?? 0) + 1; } else { dailyO[dk] = (dailyO[dk] ?? 0) + 1; }
    }
    final allKeys = {...dailyE.keys, ...dailyO.keys}.toList()..sort();
    final eSpots = [for (int i = 0; i < allKeys.length; i++) FlSpot(i.toDouble(), (dailyE[allKeys[i]] ?? 0).toDouble())];
    final oSpots = [for (int i = 0; i < allKeys.length; i++) FlSpot(i.toDouble(), (dailyO[allKeys[i]] ?? 0).toDouble())];

    return _chartContainer(l10n.chartEstimatedVsOfficial, eSpots.isEmpty && oSpots.isEmpty
        ? const Center(child: Text('No data'))
        : Column(children: [
            Expanded(child: LineChart(LineChartData(
              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey[200]!, strokeWidth: 1)),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 48)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, _) {
                  final i = v.toInt();
                  if (i < 0 || i >= allKeys.length) return const Text('');
                  final p = allKeys[i].split('-');
                  return Text('${p[1]}-${p[2]}', style: const TextStyle(fontSize: 10));
                })),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(spots: eSpots, isCurved: true, color: AppTheme.warning, barWidth: 2, dotData: FlDotData(show: true, getDotPainter: (a, b, c, d) => FlDotCirclePainter(radius: 3, color: AppTheme.warning, strokeWidth: 0))),
                LineChartBarData(spots: oSpots, isCurved: true, color: AppTheme.success, barWidth: 2, dotData: FlDotData(show: true, getDotPainter: (a, b, c, d) => FlDotCirclePainter(radius: 3, color: AppTheme.success, strokeWidth: 0))),
              ],
            ))),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [_legend('Estimated', AppTheme.warning), const SizedBox(width: 16), _legend('Official', AppTheme.success)]),
          ]));
  }

  Widget _legend(String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]);
  }
}
