import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../../core/models/models.dart';

class AccountsPage extends ConsumerStatefulWidget {
  const AccountsPage({super.key});

  @override
  ConsumerState<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends ConsumerState<AccountsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  ProviderType _selectedProvider = ProviderType.deepseek;
  String _currency = 'USD';

  @override
  void dispose() {
    _nameController.dispose();
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _showAddAccountDialog() {
    final l10n = L10nLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addAccount),
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
                  controller: _nameController,
                  decoration: InputDecoration(labelText: l10n.displayName),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _baseUrlController,
                  decoration: InputDecoration(labelText: l10n.baseUrl),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apiKeyController,
                  decoration: InputDecoration(labelText: l10n.apiKey),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.required;
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  initialValue: _currency,
                  decoration: InputDecoration(labelText: l10n.currency),
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'CNY', child: Text('CNY')),
                    DropdownMenuItem(value: 'EUR', child: Text('EUR')),
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
          ElevatedButton(onPressed: _addAccount, child: Text(l10n.addAccount)),
        ],
      ),
    );
  }

  Future<void> _addAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = L10nLocalizations.of(context);
    final service = ref.read(accountServiceProvider);
    try {
      await service.createAccount(
        AccountsCompanion.insert(
          providerType: _selectedProvider,
          displayName: _nameController.text,
          baseUrl: _baseUrlController.text,
          currency: Value(_currency),
        ),
        _apiKeyController.text,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.accountAdded)));
        _nameController.clear();
        _baseUrlController.clear();
        _apiKeyController.clear();
        ref.invalidate(accountsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add account: \$e')));
      }
    }
  }

  Future<void> _deleteAccount(int id) async {
    final l10n = L10nLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Text(l10n.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(accountServiceProvider);
      await service.deleteAccount(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.accountDeleted)));
        ref.invalidate(accountsProvider);
      }
    }
  }

  String _maskApiKey(String? alias) {
    if (alias == null) return 'Not set';
    if (alias.length <= 4) return '****';
    return '****\${alias.substring(alias.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navAccounts),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddAccountDialog,
          ),
        ],
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noAccounts,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tapToAddAccount,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getProviderColor(account.providerType),
                    child: Icon(
                      _getProviderIcon(account.providerType),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(account.displayName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\${l10n.providerName(account.providerType.name)} \${account.baseUrl}',
                      ),
                      Text(_maskApiKey(account.apiKeyAlias)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: account.enabled,
                        onChanged: (value) async {
                          final service = ref.read(accountServiceProvider);
                          await service.updateAccount(
                            account.id,
                            AccountsCompanion(enabled: Value(value)),
                          );
                          ref.invalidate(accountsProvider);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAccount(account.id),
                      ),
                    ],
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

  Color _getProviderColor(ProviderType type) {
    switch (type) {
      case ProviderType.deepseek:
        return Colors.blue;
      case ProviderType.mimo:
        return Colors.purple;
      case ProviderType.gemini:
        return Colors.green;
      case ProviderType.openrouter:
        return Colors.orange;
      case ProviderType.customOpenAI:
        return Colors.teal;
    }
  }

  IconData _getProviderIcon(ProviderType type) {
    switch (type) {
      case ProviderType.deepseek:
        return Icons.language;
      case ProviderType.mimo:
        return Icons.phone_android;
      case ProviderType.gemini:
        return Icons.auto_awesome;
      case ProviderType.openrouter:
        return Icons.route;
      case ProviderType.customOpenAI:
        return Icons.code;
    }
  }
}
