import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../../core/models/models.dart';
import '../theme/app_theme.dart';

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
    _resetAccountForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusL),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppTheme.spaceL,
          right: AppTheme.spaceL,
          top: AppTheme.spaceL,
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
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceL),
                Text(
                  l10n.addAccount,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppTheme.spaceXL),
                DropdownButtonFormField<ProviderType>(
                  initialValue: _selectedProvider,
                  decoration: InputDecoration(
                    labelText: l10n.provider,
                    prefixIcon: Icon(
                      _getProviderIcon(_selectedProvider),
                      color: _getProviderColor(_selectedProvider),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: ProviderType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getProviderColor(type),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(l10n.providerName(type.name)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectProvider(value));
                    }
                  },
                ),
                const SizedBox(height: AppTheme.spaceM),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.displayName,
                    prefixIcon: const Icon(Icons.label_rounded),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.required : null,
                ),
                const SizedBox(height: AppTheme.spaceM),
                TextFormField(
                  controller: _baseUrlController,
                  decoration: InputDecoration(
                    labelText: l10n.baseUrl,
                    prefixIcon: const Icon(Icons.link_rounded),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.required : null,
                ),
                const SizedBox(height: AppTheme.spaceM),
                TextFormField(
                  controller: _apiKeyController,
                  decoration: InputDecoration(
                    labelText: l10n.apiKey,
                    prefixIcon: const Icon(Icons.key_rounded),
                  ),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? l10n.required : null,
                ),
                const SizedBox(height: AppTheme.spaceM),
                DropdownButtonFormField<String>(
                  initialValue: _currency,
                  decoration: InputDecoration(
                    labelText: l10n.currency,
                    prefixIcon: const Icon(Icons.monetization_on_rounded),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: const [
                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                    DropdownMenuItem(value: 'CNY', child: Text('CNY')),
                    DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                  ],
                  onChanged: (value) => setState(() => _currency = value!),
                ),
                const SizedBox(height: AppTheme.spaceXL),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _addAccount,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.addAccount),
                  ),
                ),
              ],
            ),
          ),
        ),
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
          providerType: _selectedProvider.name,
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
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  void _resetAccountForm() {
    _selectedProvider = ProviderType.deepseek;
    _currency = 'USD';
    _nameController.clear();
    _apiKeyController.clear();
    _baseUrlController.text = _defaultBaseUrl(_selectedProvider);
  }

  void _selectProvider(ProviderType provider) {
    final currentDefault = _defaultBaseUrl(_selectedProvider);
    final shouldReplaceBaseUrl =
        _baseUrlController.text.trim().isEmpty ||
        _baseUrlController.text.trim() == currentDefault;

    _selectedProvider = provider;
    if (shouldReplaceBaseUrl) {
      _baseUrlController.text = _defaultBaseUrl(provider);
    }
  }

  String _defaultBaseUrl(ProviderType provider) {
    switch (provider) {
      case ProviderType.deepseek:
        return 'https://api.deepseek.com';
      case ProviderType.mimo:
        return 'https://api.mimo.ai/v1';
      case ProviderType.gemini:
        return 'https://generativelanguage.googleapis.com/v1beta';
      case ProviderType.openrouter:
        return 'https://openrouter.ai/api/v1';
      case ProviderType.customOpenAI:
        return '';
    }
  }

  Future<void> _deleteAccount(int id) async {
    final l10n = L10nLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppTheme.warning),
            const SizedBox(width: 8),
            Text(l10n.deleteAccount),
          ],
        ),
        content: Text(l10n.deleteAccountConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppTheme.error),
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
    if (alias == null) return '****';
    if (alias.length <= 4) return '****';
    return '****${alias.substring(alias.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final accountsAsync = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navAccounts),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.tonalIcon(
              onPressed: _showAddAccountDialog,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addAccount),
            ),
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
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noAccounts,
                    style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tapToAddAccount,
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              final color = _getProviderColor(
                _parseProviderType(account.providerType),
              );
              return Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spaceL),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                        ),
                        child: Icon(
                          _getProviderIcon(
                            _parseProviderType(account.providerType),
                          ),
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.displayName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${l10n.providerName(account.providerType)}  ${account.baseUrl}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _maskApiKey(account.apiKeyAlias),
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: account.enabled,
                        activeThumbColor: color,
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
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppTheme.error,
                        ),
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
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  ProviderType _parseProviderType(String name) {
    return ProviderType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ProviderType.customOpenAI,
    );
  }

  Color _getProviderColor(ProviderType type) {
    switch (type) {
      case ProviderType.deepseek:
        return AppTheme.deepseekBrand;
      case ProviderType.mimo:
        return AppTheme.mimoBrand;
      case ProviderType.gemini:
        return AppTheme.geminiBrand;
      case ProviderType.openrouter:
        return AppTheme.openrouterBrand;
      case ProviderType.customOpenAI:
        return AppTheme.customOpenAIBrand;
    }
  }

  IconData _getProviderIcon(ProviderType type) {
    switch (type) {
      case ProviderType.deepseek:
        return Icons.language_rounded;
      case ProviderType.mimo:
        return Icons.phone_android_rounded;
      case ProviderType.gemini:
        return Icons.auto_awesome_rounded;
      case ProviderType.openrouter:
        return Icons.route_rounded;
      case ProviderType.customOpenAI:
        return Icons.code_rounded;
    }
  }
}
