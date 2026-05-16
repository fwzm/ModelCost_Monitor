import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';

class ChartsPage extends ConsumerStatefulWidget {
  const ChartsPage({super.key});

  @override
  ConsumerState<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends ConsumerState<ChartsPage> {
  int _selectedChart = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final usageLogsAsync = ref.watch(usageLogsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCharts)),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildChartButton(l10n.chartDailyCost, 0),
                const SizedBox(width: 8),
                _buildChartButton(l10n.chartModelCost, 1),
                const SizedBox(width: 8),
                _buildChartButton(l10n.chartTokenComparison, 2),
                const SizedBox(width: 8),
                _buildChartButton(l10n.chartFeeTrend, 3),
                const SizedBox(width: 8),
                _buildChartButton(l10n.chartEstimatedVsOfficial, 4),
              ],
            ),
          ),
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

  Widget _buildChartButton(String label, int index) {
    final isSelected = _selectedChart == index;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedChart = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : null,
        foregroundColor: isSelected ? Colors.white : null,
      ),
      child: Text(label),
    );
  }

  Widget _buildSelectedChart(List<UsageLog> logs) {
    switch (_selectedChart) {
      case 0:
        return _buildDailyCostChart(logs);
      case 1:
        return _buildModelCostChart(logs);
      case 2:
        return _buildTokenComparisonChart(logs);
      case 3:
        return _buildFeeTrendChart(logs);
      case 4:
        return _buildEstimatedVsOfficialChart(logs);
      default:
        return _buildDailyCostChart(logs);
    }
  }

  Widget _buildDailyCostChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final dailyCost = <String, double>{};

    for (final log in logs) {
      if (log.cost == null) continue;
      final dateKey =
          '${log.requestTime.year}-${log.requestTime.month.toString().padLeft(2, '0')}-${log.requestTime.day.toString().padLeft(2, '0')}';
      dailyCost[dateKey] = (dailyCost[dateKey] ?? 0) + log.cost!;
    }

    final sortedKeys = dailyCost.keys.toList()..sort();
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedKeys.length; i++) {
      spots.add(FlSpot(i.toDouble(), dailyCost[sortedKeys[i]]!));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chartDailyCost,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: spots.isEmpty
                ? const Center(child: Text('No data'))
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= sortedKeys.length) {
                                return const Text('');
                              }
                              final parts = sortedKeys[index].split('-');
                              return Text(
                                '${parts[1]}-${parts[2]}',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.blue.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelCostChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final modelCost = <String, double>{};

    for (final log in logs) {
      if (log.cost == null) continue;
      modelCost[log.modelName] = (modelCost[log.modelName] ?? 0) + log.cost!;
    }

    final sortedEntries = modelCost.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final sections = sortedEntries.asMap().entries.map((entry) {
      final colors = [
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.red,
        Colors.teal,
      ];
      return PieChartSectionData(
        color: colors[entry.key % colors.length],
        value: entry.value.value,
        title:
            '${(entry.value.value * 100 / (modelCost.values.fold(0.0, (a, b) => a + b))).toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chartModelCost,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: sections.isEmpty
                ? const Center(child: Text('No data'))
                : Column(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: sections,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: sortedEntries.asMap().entries.map((entry) {
                          final colors = [
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.purple,
                            Colors.red,
                            Colors.teal,
                          ];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: colors[entry.key % colors.length],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${entry.value.key}: \$${entry.value.value.toStringAsFixed(4)}',
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenComparisonChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final dailyPrompt = <String, int>{};
    final dailyCompletion = <String, int>{};

    for (final log in logs) {
      final dateKey =
          '${log.requestTime.year}-${log.requestTime.month.toString().padLeft(2, '0')}-${log.requestTime.day.toString().padLeft(2, '0')}';
      dailyPrompt[dateKey] =
          (dailyPrompt[dateKey] ?? 0) + (log.promptTokens ?? 0);
      dailyCompletion[dateKey] =
          (dailyCompletion[dateKey] ?? 0) + (log.completionTokens ?? 0);
    }

    final sortedKeys = dailyPrompt.keys.toList()..sort();
    final promptSpots = <FlSpot>[];
    final completionSpots = <FlSpot>[];

    for (int i = 0; i < sortedKeys.length; i++) {
      promptSpots.add(
        FlSpot(i.toDouble(), dailyPrompt[sortedKeys[i]]!.toDouble()),
      );
      completionSpots.add(
        FlSpot(i.toDouble(), dailyCompletion[sortedKeys[i]]!.toDouble()),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chartTokenComparison,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: promptSpots.isEmpty
                ? const Center(child: Text('No data'))
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= sortedKeys.length) {
                                return const Text('');
                              }
                              final parts = sortedKeys[index].split('-');
                              return Text(
                                '${parts[1]}-${parts[2]}',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: promptSpots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                        ),
                        LineChartBarData(
                          spots: completionSpots,
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Prompt', Colors.blue),
              const SizedBox(width: 16),
              _buildLegend('Completion', Colors.green),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeeTrendChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final dailyCost = <String, double>{};

    for (final log in logs) {
      if (log.cost == null) continue;
      final dateKey =
          '${log.requestTime.year}-${log.requestTime.month.toString().padLeft(2, '0')}-${log.requestTime.day.toString().padLeft(2, '0')}';
      dailyCost[dateKey] = (dailyCost[dateKey] ?? 0) + log.cost!;
    }

    final sortedKeys = dailyCost.keys.toList()..sort();
    final bars = <BarChartGroupData>[];

    for (int i = 0; i < sortedKeys.length; i++) {
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: dailyCost[sortedKeys[i]]!,
              color: Colors.orange,
              width: 16,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chartFeeTrend,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: bars.isEmpty
                ? const Center(child: Text('No data'))
                : BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= sortedKeys.length) {
                                return const Text('');
                              }
                              final parts = sortedKeys[index].split('-');
                              return Text(
                                '${parts[1]}-${parts[2]}',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: bars,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedVsOfficialChart(List<UsageLog> logs) {
    final l10n = L10nLocalizations.of(context);
    final dailyEstimated = <String, int>{};
    final dailyOfficial = <String, int>{};

    for (final log in logs) {
      final dateKey =
          '${log.requestTime.year}-${log.requestTime.month.toString().padLeft(2, '0')}-${log.requestTime.day.toString().padLeft(2, '0')}';
      if (log.estimated) {
        dailyEstimated[dateKey] = (dailyEstimated[dateKey] ?? 0) + 1;
      } else {
        dailyOfficial[dateKey] = (dailyOfficial[dateKey] ?? 0) + 1;
      }
    }

    final allKeys = {...dailyEstimated.keys, ...dailyOfficial.keys}.toList()
      ..sort();
    final estimatedSpots = <FlSpot>[];
    final officialSpots = <FlSpot>[];

    for (int i = 0; i < allKeys.length; i++) {
      estimatedSpots.add(
        FlSpot(i.toDouble(), (dailyEstimated[allKeys[i]] ?? 0).toDouble()),
      );
      officialSpots.add(
        FlSpot(i.toDouble(), (dailyOfficial[allKeys[i]] ?? 0).toDouble()),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.chartEstimatedVsOfficial,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: estimatedSpots.isEmpty && officialSpots.isEmpty
                ? const Center(child: Text('No data'))
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= allKeys.length) {
                                return const Text('');
                              }
                              final parts = allKeys[index].split('-');
                              return Text(
                                '${parts[1]}-${parts[2]}',
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: estimatedSpots,
                          isCurved: true,
                          color: Colors.orange,
                          barWidth: 2,
                          dotData: const FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: officialSpots,
                          isCurved: true,
                          color: Colors.green,
                          barWidth: 2,
                          dotData: const FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend('Estimated', Colors.orange),
              const SizedBox(width: 16),
              _buildLegend('Official', Colors.green),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
