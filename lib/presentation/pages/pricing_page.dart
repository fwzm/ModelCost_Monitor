import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/models.dart';
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
                  items: ProviderType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(l10n.providerName(type.name)),
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
    switch (providerType) {
      case ProviderType.deepseek:
        return 'deepseek-chat';
      case ProviderType.gemini:
        return 'gemini-2.5-flash';
      case ProviderType.openrouter:
        return 'anthropic/claude-sonnet-4.5';
      case ProviderType.mimo:
        return 'mimo-v2.5';
      case ProviderType.customOpenAI:
        return 'gpt-compatible-model';
    }
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
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: prices.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _PricingImportCard(
                    isImporting: _isImporting,
                    onApplyBuiltIn: _applyBuiltInPrices,
                    onImportOpenRouter: _importOpenRouterPrices,
                    onAddManual: _showAddPriceDialog,
                  ),
                );
              }

              final price = prices[index - 1];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _PriceTile(
                  price: price,
                  onDelete: () => _deletePrice(price.id),
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

class _PriceTile extends StatelessWidget {
  final ModelPrice price;
  final VoidCallback onDelete;

  const _PriceTile({required this.price, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final color = _providerColor(price.providerType);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    l10n.providerName(price.providerType.name),
                    style: TextStyle(color: color, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    price.modelName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.delete,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PriceChip(
                  label: L10n.of('input_short'),
                  value: price.inputPricePer1M,
                  currency: price.currency,
                ),
                _PriceChip(
                  label: L10n.of('output_short'),
                  value: price.outputPricePer1M,
                  currency: price.currency,
                ),
                if (price.cachedInputPricePer1M != null)
                  _PriceChip(
                    label: L10n.of('cached_short'),
                    value: price.cachedInputPricePer1M!,
                    currency: price.currency,
                  ),
                if (price.reasoningOutputPricePer1M != null)
                  _PriceChip(
                    label: L10n.of('reasoning_short'),
                    value: price.reasoningOutputPricePer1M!,
                    currency: price.currency,
                  ),
              ],
            ),
            if (price.sourceNote != null && price.sourceNote!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                price.sourceNote!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _providerColor(ProviderType type) {
    switch (type) {
      case ProviderType.deepseek:
        return const Color(0xFF2563EB);
      case ProviderType.mimo:
        return const Color(0xFF7C3AED);
      case ProviderType.gemini:
        return const Color(0xFF16A34A);
      case ProviderType.openrouter:
        return const Color(0xFFF97316);
      case ProviderType.customOpenAI:
        return const Color(0xFF0F766E);
    }
  }
}

class _PriceChip extends StatelessWidget {
  final String label;
  final double value;
  final String currency;

  const _PriceChip({
    required this.label,
    required this.value,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(
        '$label $currency ${value.toStringAsFixed(value >= 1 ? 2 : 4)}/1M',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
