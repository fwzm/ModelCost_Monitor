import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../../core/models/models.dart';

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
                TextFormField(
                  controller: _modelNameController,
                  decoration: InputDecoration(labelText: l10n.modelName),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _inputPriceController,
                  decoration: InputDecoration(labelText: l10n.inputPricePer1M),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    if (double.tryParse(value) == null) {
                      return l10n.invalidNumber;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _outputPriceController,
                  decoration: InputDecoration(labelText: l10n.outputPricePer1M),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    if (double.tryParse(value) == null) {
                      return l10n.invalidNumber;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cachedPriceController,
                  decoration: InputDecoration(labelText: l10n.cachedInputPrice),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                TextFormField(
                  controller: _reasoningPriceController,
                  decoration: InputDecoration(labelText: l10n.reasoningOutputPrice),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
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
          ElevatedButton(
            onPressed: _addPrice,
            child: Text(l10n.addPrice),
          ),
        ],
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
          providerType: _selectedProvider,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.priceAdded)),
        );
        _modelNameController.clear();
        _inputPriceController.clear();
        _outputPriceController.clear();
        _cachedPriceController.clear();
        _reasoningPriceController.clear();
        ref.invalidate(modelPricesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add price: \$e')),
        );
      }
    }
  }

  Future<void> _deletePrice(int id) async {
    final l10n = L10nLocalizations.of(context);
    final service = ref.read(pricingServiceProvider);
    await service.deletePrice(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.priceDeleted)),
      );
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
            icon: const Icon(Icons.add),
            onPressed: _showAddPriceDialog,
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
                  const Icon(Icons.price_check, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noPrices,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tapToAddPrice,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: prices.length,
            itemBuilder: (context, index) {
              final price = prices[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(price.modelName),
                  subtitle: Text(
                    '\${l10n.providerName(price.providerType.name)} Input: \$\${price.inputPricePer1M}/1M Output: \$\${price.outputPricePer1M}/1M',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletePrice(price.id),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: \$e')),
      ),
    );
  }
}
