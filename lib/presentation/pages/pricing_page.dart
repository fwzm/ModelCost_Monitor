import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
import '../../core/providers/provider_catalog.dart';
import '../../data/database/database.dart';
import '../../l10n/l10n.dart';
import '../../providers/providers.dart';

class PricingPage extends ConsumerStatefulWidget {
  const PricingPage({super.key});

  @override
  ConsumerState<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends ConsumerState<PricingPage> {
  final _formKey = GlobalKey<FormState>();
  final _modelNameController = TextEditingController();
  final _inputPriceController = TextEditingController();
  final _outputPriceController = TextEditingController();
  final _cachedPriceController = TextEditingController();
  final _reasoningPriceController = TextEditingController();
  ProviderType _selectedProvider = ProviderType.deepseek;
  String _currency = 'USD';
  bool _isImporting = false;
  _PricingViewMode _viewMode = _PricingViewMode.provider;
  final Set<String> _expandedKeys = {};

  @override
  void dispose() {
    _modelNameController.dispose();
    _inputPriceController.dispose();
    _outputPriceController.dispose();
    _cachedPriceController.dispose();
    _reasoningPriceController.dispose();
    super.dispose();
  }

  void _showAddPriceDialog() {
    final l10n = L10nLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addPrice),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<ProviderType>(
                  initialValue: _selectedProvider,
                  decoration: InputDecoration(labelText: l10n.provider),
                  isExpanded: true,
                  items: providerCatalog.map((entry) {
                    final type = entry.type;
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        l10n.providerName(type.name),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProvider = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _modelNameController,
                  decoration: InputDecoration(
                    labelText: l10n.modelName,
                    hintText: _modelHint(_selectedProvider),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.required;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _inputPriceController,
                        decoration: InputDecoration(
                          labelText: l10n.inputPricePer1M,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _validateNumber,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _outputPriceController,
                        decoration: InputDecoration(
                          labelText: l10n.outputPricePer1M,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: _validateNumber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cachedPriceController,
                        decoration: InputDecoration(
                          labelText: l10n.cachedInputPrice,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _reasoningPriceController,
                        decoration: InputDecoration(
                          labelText: l10n.reasoningOutputPrice,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _currency,
                  decoration: InputDecoration(labelText: l10n.currency),
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'CNY', child: Text('CNY')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _currency = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(onPressed: _addPrice, child: Text(l10n.addPrice)),
        ],
      ),
    );
  }

  String? _validateNumber(String? value) {
    final l10n = L10nLocalizations.of(context);
    if (value == null || value.trim().isEmpty) return l10n.required;
    if (double.tryParse(value) == null) return l10n.invalidNumber;
    return null;
  }

  String _modelHint(ProviderType providerType) {
    return providerCatalogFor(providerType).defaultModel;
  }

  Future<void> _addPrice() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = L10nLocalizations.of(context);
    final service = ref.read(pricingServiceProvider);
    try {
      await service.upsertPrice(
        ModelPricesCompanion.insert(
          providerType: _selectedProvider,
          modelName: _modelNameController.text.trim(),
          inputPricePer1M: double.parse(_inputPriceController.text),
          outputPricePer1M: double.parse(_outputPriceController.text),
          cachedInputPricePer1M: _optionalDouble(_cachedPriceController.text),
          reasoningOutputPricePer1M: _optionalDouble(
            _reasoningPriceController.text,
          ),
          currency: Value(_currency),
          sourceNote: const Value('User configured in ModelCost Monitor.'),
        ),
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.priceAdded)));
        _modelNameController.clear();
        _inputPriceController.clear();
        _outputPriceController.clear();
        _cachedPriceController.clear();
        _reasoningPriceController.clear();
        ref.invalidate(modelPricesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add price: $e')));
      }
    }
  }

  Value<double?> _optionalDouble(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? const Value(null) : Value(double.parse(trimmed));
  }

  Future<void> _applyBuiltInPrices() async {
    await _runImport(() async {
      final result = await ref
          .read(pricingPresetServiceProvider)
          .applyBuiltInPresets(ref.read(pricingServiceProvider));
      return result.importedCount;
    });
  }

  Future<void> _importOpenRouterPrices() async {
    await _runImport(() async {
      final result = await ref
          .read(pricingPresetServiceProvider)
          .importOpenRouterPrices(ref.read(pricingServiceProvider));
      return result.importedCount;
    });
  }

  Future<void> _runImport(Future<int> Function() action) async {
    if (_isImporting) return;
    setState(() => _isImporting = true);
    try {
      final count = await action();
      ref.invalidate(modelPricesProvider);
      if (mounted) {
        final text = L10n.of(
          'prices_imported',
        ).replaceFirst('{count}', count.toString());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _deletePrice(int id) async {
    final l10n = L10nLocalizations.of(context);
    final service = ref.read(pricingServiceProvider);
    await service.deletePrice(id);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.priceDeleted)));
      ref.invalidate(modelPricesProvider);
    }
  }

  void _toggleExpand(String key) {
    setState(() {
      if (_expandedKeys.contains(key)) {
        _expandedKeys.remove(key);
      } else {
        _expandedKeys.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final pricesAsync = ref.watch(modelPricesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navPricing),
        actions: [
          IconButton(
            tooltip: l10n.addPrice,
            icon: const Icon(Icons.add),
            onPressed: _showAddPriceDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pricesAsync.when(
        data: (prices) {
          if (prices.isEmpty) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _PricingImportCard(
                  isImporting: _isImporting,
                  onApplyBuiltIn: _applyBuiltInPrices,
                  onImportOpenRouter: _importOpenRouterPrices,
                  onAddManual: _showAddPriceDialog,
                ),
              ],
            );
          }

          final providerGroups = _groupByProvider(prices);
          final familyGroups = _groupByFamily(prices);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: _PricingImportCard(
                    isImporting: _isImporting,
                    onApplyBuiltIn: _applyBuiltInPrices,
                    onImportOpenRouter: _importOpenRouterPrices,
                    onAddManual: _showAddPriceDialog,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: _ViewModeToggle(
                    mode: _viewMode,
                    onChanged: (m) => setState(() => _viewMode = m),
                  ),
                ),
              ),
              if (_viewMode == _PricingViewMode.provider)
                ...providerGroups.map((entry) {
                  final key = 'p_${entry.key.name}';
                  final expanded = _expandedKeys.contains(key);
                  return _buildProviderGroup(
                    l10n,
                    entry.key,
                    entry.value,
                    key,
                    expanded,
                  );
                })
              else
                ...familyGroups.map((entry) {
                  final key = 'f_${entry.key}';
                  final expanded = _expandedKeys.contains(key);
                  return _buildFamilyGroup(
                    l10n,
                    entry.key,
                    entry.value,
                    key,
                    expanded,
                  );
                }),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildProviderGroup(
    L10nLocalizations l10n,
    ProviderType providerType,
    List<ModelPrice> prices,
    String key,
    bool expanded,
  ) {
    final providerName = l10n.providerName(providerType.name);
    final color = _providerColor(providerType);

    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyDelegate(
            child: _GroupHeader(
              icon: _providerIcon(providerType),
              iconColor: color,
              iconBg: color.withValues(alpha: 0.12),
              title: providerName,
              subtitle: '${prices.length}',
              expanded: expanded,
              onTap: () => _toggleExpand(key),
              priceRange: _PriceRangeBadge(
                minIn: prices
                    .map((p) => p.inputPricePer1M)
                    .reduce((a, b) => a < b ? a : b),
                maxIn: prices
                    .map((p) => p.inputPricePer1M)
                    .reduce((a, b) => a > b ? a : b),
                minOut: prices
                    .map((p) => p.outputPricePer1M)
                    .reduce((a, b) => a < b ? a : b),
                maxOut: prices
                    .map((p) => p.outputPricePer1M)
                    .reduce((a, b) => a > b ? a : b),
              ),
            ),
          ),
        ),
        if (expanded)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _CompactModelRow(
                  price: prices[index],
                  onDelete: () => _deletePrice(prices[index].id),
                ),
              ),
              childCount: prices.length,
            ),
          ),
      ],
    );
  }

  Widget _buildFamilyGroup(
    L10nLocalizations l10n,
    String family,
    List<ModelPrice> prices,
    String key,
    bool expanded,
  ) {
    final color = _familyColor(family);

    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyDelegate(
            child: _GroupHeader(
              icon: _familyIcon(family),
              iconColor: color,
              iconBg: color.withValues(alpha: 0.12),
              title: family,
              subtitle: '${prices.length}',
              expanded: expanded,
              onTap: () => _toggleExpand(key),
              priceRange: _PriceRangeBadge(
                minIn: prices
                    .map((p) => p.inputPricePer1M)
                    .reduce((a, b) => a < b ? a : b),
                maxIn: prices
                    .map((p) => p.inputPricePer1M)
                    .reduce((a, b) => a > b ? a : b),
                minOut: prices
                    .map((p) => p.outputPricePer1M)
                    .reduce((a, b) => a < b ? a : b),
                maxOut: prices
                    .map((p) => p.outputPricePer1M)
                    .reduce((a, b) => a > b ? a : b),
              ),
            ),
          ),
        ),
        if (expanded)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _FamilyModelRow(
                  price: prices[index],
                  onDelete: () => _deletePrice(prices[index].id),
                ),
              ),
              childCount: prices.length,
            ),
          ),
      ],
    );
  }

  List<MapEntry<ProviderType, List<ModelPrice>>> _groupByProvider(
    List<ModelPrice> prices,
  ) {
    final map = <ProviderType, List<ModelPrice>>{};
    for (final price in prices) {
      map.putIfAbsent(price.providerType, () => []).add(price);
    }
    return map.entries.toList()
      ..sort((a, b) => a.key.index.compareTo(b.key.index));
  }

  List<MapEntry<String, List<ModelPrice>>> _groupByFamily(
    List<ModelPrice> prices,
  ) {
    final map = <String, List<ModelPrice>>{};
    for (final price in prices) {
      final family = _modelFamily(price.modelName);
      map.putIfAbsent(family, () => []).add(price);
    }
    final entries = map.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  static String _modelFamily(String modelName) {
    final lower = modelName.toLowerCase();
    if (lower.startsWith('claude')) return 'Claude';
    if (lower.startsWith('gpt-') ||
        lower.startsWith('o1') ||
        lower.startsWith('o3') ||
        lower.startsWith('o4'))
      return 'OpenAI';
    if (lower.startsWith('gemini')) return 'Gemini';
    if (lower.startsWith('deepseek')) return 'DeepSeek';
    if (lower.startsWith('qwen')) return 'Qwen';
    if (lower.startsWith('grok')) return 'Grok';
    if (lower.startsWith('glm')) return 'GLM';
    if (lower.startsWith('moonshot') || lower.startsWith('kimi')) return 'Kimi';
    if (lower.startsWith('mistral') || lower.startsWith('codestral'))
      return 'Mistral';
    if (lower.startsWith('llama')) return 'Llama';
    if (lower.startsWith('mixtral')) return 'Mixtral';
    if (lower.startsWith('command')) return 'Cohere';
    if (lower.startsWith('sonar')) return 'Perplexity';
    if (lower.startsWith('minimax') || lower.startsWith('abab'))
      return 'MiniMax';
    if (lower.startsWith('hunyuan')) return 'Hunyuan';
    if (lower.startsWith('doubao')) return 'Doubao';
    final parts = modelName.split(RegExp(r'[-_/.]'));
    return parts.isNotEmpty ? parts.first : modelName;
  }

  static Color _familyColor(String family) {
    switch (family) {
      case 'Claude':
        return const Color(0xFF92400E);
      case 'OpenAI':
        return const Color(0xFF111827);
      case 'Gemini':
        return const Color(0xFF16A34A);
      case 'DeepSeek':
        return const Color(0xFF2563EB);
      case 'Qwen':
        return const Color(0xFFDC2626);
      case 'Grok':
        return const Color(0xFF111827);
      case 'GLM':
        return const Color(0xFF0891B2);
      case 'Kimi':
        return const Color(0xFF7C3AED);
      case 'Mistral':
        return const Color(0xFFDC2626);
      case 'Llama':
        return const Color(0xFF4F46E5);
      case 'Mixtral':
        return const Color(0xFFF97316);
      case 'Cohere':
        return const Color(0xFF7C3AED);
      case 'Perplexity':
        return const Color(0xFF0891B2);
      case 'MiniMax':
        return const Color(0xFF0D9488);
      case 'Hunyuan':
        return const Color(0xFF2563EB);
      case 'Doubao':
        return const Color(0xFFE11D48);
      default:
        return const Color(0xFF64748B);
    }
  }

  static IconData _familyIcon(String family) {
    switch (family) {
      case 'Claude':
        return Icons.psychology_alt_outlined;
      case 'OpenAI':
        return Icons.bubble_chart_outlined;
      case 'Gemini':
        return Icons.auto_awesome;
      case 'DeepSeek':
        return Icons.language;
      case 'Qwen':
        return Icons.public;
      case 'Grok':
        return Icons.smart_toy_outlined;
      case 'GLM':
        return Icons.public;
      case 'Kimi':
        return Icons.nights_stay_outlined;
      case 'Mistral':
        return Icons.air_outlined;
      case 'Llama':
        return Icons.pets;
      case 'Mixtral':
        return Icons.hub_outlined;
      case 'Cohere':
        return Icons.hub_outlined;
      case 'Perplexity':
        return Icons.search;
      case 'MiniMax':
        return Icons.compress;
      case 'Hunyuan':
        return Icons.cloud_outlined;
      case 'Doubao':
        return Icons.whatshot;
      default:
        return Icons.code;
    }
  }
}

class _PricingImportCard extends StatelessWidget {
  final bool isImporting;
  final VoidCallback onApplyBuiltIn;
  final VoidCallback onImportOpenRouter;
  final VoidCallback onAddManual;

  const _PricingImportCard({
    required this.isImporting,
    required this.onApplyBuiltIn,
    required this.onImportOpenRouter,
    required this.onAddManual,
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
                Icon(Icons.auto_fix_high, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    L10n.of('apply_builtin_prices'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              L10n.of('price_source_notice'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                FilledButton.icon(
                  onPressed: isImporting ? null : onApplyBuiltIn,
                  icon: isImporting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.offline_bolt_outlined),
                  label: Text(L10n.of('apply_builtin_prices')),
                ),
                OutlinedButton.icon(
                  onPressed: isImporting ? null : onImportOpenRouter,
                  icon: const Icon(Icons.public),
                  label: Text(L10n.of('import_openrouter_prices')),
                ),
                TextButton.icon(
                  onPressed: isImporting ? null : onAddManual,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(L10nLocalizations.of(context).addPrice),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _PricingViewMode { provider, model }

class _ViewModeToggle extends StatelessWidget {
  final _PricingViewMode mode;
  final ValueChanged<_PricingViewMode> onChanged;

  const _ViewModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _ToggleBtn(
            icon: Icons.cloud_outlined,
            label: L10n.of('view_by_provider'),
            selected: mode == _PricingViewMode.provider,
            onTap: () => onChanged(_PricingViewMode.provider),
          ),
          _ToggleBtn(
            icon: Icons.smart_toy_outlined,
            label: L10n.of('view_by_model'),
            selected: mode == _PricingViewMode.model,
            onTap: () => onChanged(_PricingViewMode.model),
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleBtn({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? colorScheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool expanded;
  final VoidCallback onTap;
  final Widget priceRange;

  const _GroupHeader({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.onTap,
    required this.priceRange,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              priceRange,
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.expand_more,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FamilyModelRow extends StatelessWidget {
  final ModelPrice price;
  final VoidCallback onDelete;

  const _FamilyModelRow({required this.price, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final providerColor = _providerColor(price.providerType);
    final hasCached = price.cachedInputPricePer1M != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: providerColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _providerIcon(price.providerType),
              color: providerColor,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  price.modelName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  l10n.providerName(price.providerType.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _PriceTag(
              label: l10n.inputShort,
              value: price.inputPricePer1M,
              currency: price.currency,
            ),
          ),
          Expanded(
            flex: 2,
            child: _PriceTag(
              label: l10n.outputShort,
              value: price.outputPricePer1M,
              currency: price.currency,
            ),
          ),
          if (hasCached)
            Expanded(
              flex: 2,
              child: _PriceTag(
                label: l10n.cachedShort,
                value: price.cachedInputPricePer1M!,
                currency: price.currency,
                muted: true,
              ),
            ),
          SizedBox(
            width: 32,
            child: IconButton(
              tooltip: l10n.delete,
              icon: Icon(
                Icons.close,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
        ],
      ),
    );
  }
}

class _StickyDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyDelegate({required this.child});

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(color: colorScheme.surface, child: child);
  }
}

class _PriceRangeBadge extends StatelessWidget {
  final double minIn, maxIn, minOut, maxOut;

  const _PriceRangeBadge({
    required this.minIn,
    required this.maxIn,
    required this.minOut,
    required this.maxOut,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    String fmt(double v) {
      if (v == 0) return '0';
      if (v >= 100) return v.toStringAsFixed(0);
      if (v >= 1) return v.toStringAsFixed(2);
      return v.toStringAsFixed(3);
    }

    String range(double min, double max) =>
        min == max ? '\$${fmt(min)}' : '\$${fmt(min)}~${fmt(max)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'IN ',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                range(minIn, maxIn),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'OUT ',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                range(minOut, maxOut),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactModelRow extends StatelessWidget {
  final ModelPrice price;
  final VoidCallback onDelete;

  const _CompactModelRow({required this.price, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final hasCached = price.cachedInputPricePer1M != null;
    final hasReasoning = price.reasoningOutputPricePer1M != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              price.modelName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            flex: 2,
            child: _PriceTag(
              label: l10n.inputShort,
              value: price.inputPricePer1M,
              currency: price.currency,
            ),
          ),
          Expanded(
            flex: 2,
            child: _PriceTag(
              label: l10n.outputShort,
              value: price.outputPricePer1M,
              currency: price.currency,
            ),
          ),
          if (hasCached)
            Expanded(
              flex: 2,
              child: _PriceTag(
                label: l10n.cachedShort,
                value: price.cachedInputPricePer1M!,
                currency: price.currency,
                muted: true,
              ),
            ),
          if (hasReasoning)
            Expanded(
              flex: 2,
              child: _PriceTag(
                label: l10n.reasoningShort,
                value: price.reasoningOutputPricePer1M!,
                currency: price.currency,
                muted: true,
              ),
            ),
          SizedBox(
            width: 32,
            child: IconButton(
              tooltip: l10n.delete,
              icon: Icon(
                Icons.close,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final String label;
  final double value;
  final String currency;
  final bool muted;

  const _PriceTag({
    required this.label,
    required this.value,
    required this.currency,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '\$${_fmt(value)}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: muted ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

String _fmt(double v) {
  if (v == 0) return '0';
  if (v >= 100) return v.toStringAsFixed(0);
  if (v >= 1) return v.toStringAsFixed(2);
  if (v >= 0.01) return v.toStringAsFixed(3);
  return v.toStringAsFixed(4);
}

Color _providerColor(ProviderType type) {
  switch (type) {
    case ProviderType.deepseek:
      return const Color(0xFF2563EB);
    case ProviderType.openai:
      return const Color(0xFF111827);
    case ProviderType.anthropic:
      return const Color(0xFF92400E);
    case ProviderType.mimo:
      return const Color(0xFF7C3AED);
    case ProviderType.gemini:
      return const Color(0xFF16A34A);
    case ProviderType.openrouter:
      return const Color(0xFFF97316);
    case ProviderType.azureOpenAI:
      return const Color(0xFF4F46E5);
    case ProviderType.qwen:
      return const Color(0xFFDC2626);
    case ProviderType.zhipu:
      return const Color(0xFF0891B2);
    case ProviderType.siliconFlow:
      return const Color(0xFF0D9488);
    case ProviderType.volcengineArk:
      return const Color(0xFFE11D48);
    case ProviderType.tencentHunyuan:
      return const Color(0xFF2563EB);
    case ProviderType.moonshot:
      return const Color(0xFF7C3AED);
    case ProviderType.groq:
      return const Color(0xFFF97316);
    case ProviderType.mistral:
      return const Color(0xFFDC2626);
    case ProviderType.togetherAI:
      return const Color(0xFF4F46E5);
    case ProviderType.fireworksAI:
      return const Color(0xFFE11D48);
    case ProviderType.perplexity:
      return const Color(0xFF0891B2);
    case ProviderType.xai:
      return const Color(0xFF111827);
    case ProviderType.cohere:
      return const Color(0xFF7C3AED);
    case ProviderType.cerebras:
      return const Color(0xFFF97316);
    case ProviderType.minimax:
      return const Color(0xFF0D9488);
    case ProviderType.novita:
      return const Color(0xFF2563EB);
    case ProviderType.customOpenAI:
      return const Color(0xFF0F766E);
  }
}

IconData _providerIcon(ProviderType type) {
  switch (type) {
    case ProviderType.deepseek:
      return Icons.language;
    case ProviderType.openai:
      return Icons.bubble_chart_outlined;
    case ProviderType.anthropic:
      return Icons.psychology_alt_outlined;
    case ProviderType.mimo:
      return Icons.phone_android;
    case ProviderType.gemini:
      return Icons.auto_awesome;
    case ProviderType.openrouter:
      return Icons.route;
    case ProviderType.azureOpenAI:
      return Icons.cloud_sync_outlined;
    case ProviderType.qwen:
    case ProviderType.zhipu:
    case ProviderType.siliconFlow:
    case ProviderType.volcengineArk:
    case ProviderType.tencentHunyuan:
    case ProviderType.moonshot:
      return Icons.public;
    case ProviderType.groq:
    case ProviderType.mistral:
    case ProviderType.togetherAI:
    case ProviderType.fireworksAI:
    case ProviderType.perplexity:
    case ProviderType.xai:
    case ProviderType.cohere:
    case ProviderType.cerebras:
    case ProviderType.minimax:
    case ProviderType.novita:
      return Icons.hub_outlined;
    case ProviderType.customOpenAI:
      return Icons.code;
  }
}
