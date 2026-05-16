import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../../core/models/models.dart';
import '../theme/app_theme.dart';

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppTheme.spaceL, right: AppTheme.spaceL, top: AppTheme.spaceL,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceL,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceL),
                Text(l10n.addPrice, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppTheme.spaceXL),
                DropdownButtonFormField<ProviderType>(
                  initialValue: _selectedProvider,
                  decoration: InputDecoration(labelText: l10n.provider),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: ProviderType.values.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(l10n.providerName(type.name)),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedProvider = value!),
                ),
                const SizedBox(height: AppTheme.spaceM),
                TextFormField(
                  controller: _modelNameController,
                  decoration: InputDecoration(labelText: l10n.modelName, prefixIcon: const Icon(Icons.smart_toy_rounded)),
                  validator: (v) => v == null || v.isEmpty ? l10n.required : null,
                ),
                const SizedBox(height: AppTheme.spaceM),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _inputPriceController,
                        decoration: InputDecoration(labelText: l10n.inputPricePer1M),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) => v == null || v.isEmpty ? l10n.required : (double.tryParse(v) == null ? l10n.invalidNumber : null),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceS),
                    Expanded(
                      child: TextFormField(
                        controller: _outputPriceController,
                        decoration: InputDecoration(labelText: l10n.outputPricePer1M),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) => v == null || v.isEmpty ? l10n.required : (double.tryParse(v) == null ? l10n.invalidNumber : null),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceM),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cachedPriceController,
                        decoration: InputDecoration(labelText: l10n.cachedInputPrice),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceS),
                    Expanded(
                      child: TextFormField(
                        controller: _reasoningPriceController,
                        decoration: InputDecoration(labelText: l10n.reasoningOutputPrice),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceM),
                DropdownButtonFormField<String>(
                  initialValue: _currency,
                  decoration: InputDecoration(labelText: l10n.currency),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'CNY', child: Text('CNY')),
                  ],
                  onChanged: (value) => setState(() => _currency = value!),
                ),
                const SizedBox(height: AppTheme.spaceXL),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _addPrice,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.addPrice),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addPrice() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = L10nLocalizations.of(context);
    final service = ref.read(pricingServiceProvider);
    try {
      await service.addPrice(
        ModelPricesCompanion.insert(
          providerType: _selectedProvider.name,
          modelName: _modelNameController.text,
          inputPricePer1M: double.parse(_inputPriceController.text),
          outputPricePer1M: double.parse(_outputPriceController.text),
          cachedInputPricePer1M: _cachedPriceController.text.isEmpty ? const Value.absent() : Value(double.parse(_cachedPriceController.text)),
          reasoningOutputPricePer1M: _reasoningPriceController.text.isEmpty ? const Value.absent() : Value(double.parse(_reasoningPriceController.text)),
          currency: Value(_currency),
        ),
      );
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.priceAdded)));
        _modelNameController.clear();
        _inputPriceController.clear();
        _outputPriceController.clear();
        _cachedPriceController.clear();
        _reasoningPriceController.clear();
        ref.invalidate(modelPricesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _deletePrice(int id) async {
    final l10n = L10nLocalizations.of(context);
    final service = ref.read(pricingServiceProvider);
    await service.deletePrice(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.priceDeleted)));
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
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.tonalIcon(
              onPressed: _showAddPriceDialog,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addPrice),
            ),
          ),
        ],
      ),
      body: pricesAsync.when(
        data: (prices) {
          if (prices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.price_check_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(l10n.noPrices, style: TextStyle(fontSize: 18, color: Colors.grey[500])),
                  const SizedBox(height: 8),
                  Text(l10n.tapToAddPrice, style: TextStyle(color: Colors.grey[400])),
                ],
              ),
            );
          }

          // 按 Provider 分组
          final grouped = <String, List<ModelPrice>>{};
          for (final p in prices) {
            grouped.putIfAbsent(p.providerType, () => []).add(p);
          }

          return ListView(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            children: grouped.entries.map((entry) {
              final color = _getProviderColor(_parseProviderType(entry.key));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spaceS),
                    child: Row(
                      children: [
                        Container(width: 4, height: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 8),
                        Text(l10n.providerName(entry.key), style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 15)),
                        const SizedBox(width: 8),
                        Text('${entry.value.length}', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                      ],
                    ),
                  ),
                  ...entry.value.map((price) => Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spaceS),
                    padding: const EdgeInsets.all(AppTheme.spaceM),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(price.modelName, style: const TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _priceChip('In', '\$${price.inputPricePer1M}', AppTheme.info),
                                  const SizedBox(width: 8),
                                  _priceChip('Out', '\$${price.outputPricePer1M}', AppTheme.success),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded, color: Colors.grey[400], size: 20),
                          onPressed: () => _deletePrice(price.id),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: AppTheme.spaceM),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _priceChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$label: $value', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  ProviderType _parseProviderType(String name) {
    return ProviderType.values.firstWhere((e) => e.name == name, orElse: () => ProviderType.customOpenAI);
  }

  Color _getProviderColor(ProviderType type) {
    switch (type) {
      case ProviderType.deepseek:     return AppTheme.deepseekBrand;
      case ProviderType.mimo:         return AppTheme.mimoBrand;
      case ProviderType.gemini:       return AppTheme.geminiBrand;
      case ProviderType.openrouter:   return AppTheme.openrouterBrand;
      case ProviderType.customOpenAI: return AppTheme.customOpenAIBrand;
    }
  }
}
