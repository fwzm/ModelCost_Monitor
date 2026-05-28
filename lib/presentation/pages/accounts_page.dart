import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../l10n/l10n.dart';
import '../../providers/providers.dart';
import '../../data/database/database.dart';
import '../../core/models/models.dart';
import '../../core/providers/provider_catalog.dart';

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
    _fillDefaultAccountFields();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                      setDialogState(() {
                        _selectedProvider = value!;
                        _fillDefaultAccountFields(force: true);
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _ProviderInfoCard(
                    entry: providerCatalogFor(_selectedProvider),
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _baseUrlController,
                    decoration: InputDecoration(
                      labelText: l10n.baseUrl,
                      suffixIcon: IconButton(
                        tooltip: L10n.of('default_base_url_filled'),
                        icon: const Icon(Icons.auto_fix_high),
                        onPressed: () {
                          setDialogState(
                            () => _fillDefaultAccountFields(force: true),
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.required;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _currency,
                    decoration: InputDecoration(labelText: l10n.currency),
                    items: const [
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'CNY', child: Text('CNY')),
                      DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
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
            FilledButton(onPressed: _addAccount, child: Text(l10n.addAccount)),
          ],
        ),
      ),
    );
  }

  void _fillDefaultAccountFields({bool force = false}) {
    final defaultUrl = providerCatalogFor(_selectedProvider).defaultBaseUrl;
    if (force || _baseUrlController.text.trim().isEmpty) {
      _baseUrlController.text = defaultUrl;
    }
    if (force || _nameController.text.trim().isEmpty) {
      _nameController.text = _defaultDisplayName(_selectedProvider);
    }
  }

  String _defaultDisplayName(ProviderType type) {
    final l10n = L10nLocalizations.of(context);
    return l10n.providerName(type.name);
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
        ).showSnackBar(SnackBar(content: Text('Failed to add account: $e')));
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
    return alias;
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
            tooltip: l10n.addAccount,
            icon: const Icon(Icons.add),
            onPressed: _showAddAccountDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddAccountDialog,
        icon: const Icon(Icons.add),
        label: Text(l10n.addAccount),
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return _EmptyAccountsState(onAdd: _showAddAccountDialog);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              final providerColor = _getProviderColor(account.providerType);
              return _AccountCard(
                account: account,
                providerName: l10n.providerName(account.providerType.name),
                apiKeyAlias: _maskApiKey(account.apiKeyAlias),
                providerColor: providerColor,
                providerIcon: _getProviderIcon(account.providerType),
                onEnabledChanged: (value) async {
                  final service = ref.read(accountServiceProvider);
                  await service.updateAccount(
                    account.id,
                    AccountsCompanion(enabled: Value(value)),
                  );
                  ref.invalidate(accountsProvider);
                },
                onDelete: () => _deleteAccount(account.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Color _getProviderColor(ProviderType type) {
    switch (type) {
      case ProviderType.deepseek:
        return Colors.blue;
      case ProviderType.openai:
        return Colors.black87;
      case ProviderType.anthropic:
        return Colors.brown;
      case ProviderType.mimo:
        return Colors.purple;
      case ProviderType.gemini:
        return Colors.green;
      case ProviderType.openrouter:
        return Colors.orange;
      case ProviderType.azureOpenAI:
        return Colors.indigo;
      case ProviderType.qwen:
      case ProviderType.zhipu:
      case ProviderType.siliconFlow:
      case ProviderType.volcengineArk:
      case ProviderType.tencentHunyuan:
      case ProviderType.moonshot:
        return Colors.redAccent;
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
        return Colors.deepPurple;
      case ProviderType.customOpenAI:
        return Colors.teal;
    }
  }

  IconData _getProviderIcon(ProviderType type) {
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
}

class _EmptyAccountsState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyAccountsState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.tertiary],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.cloud_queue,
                      size: 36,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.noAccounts,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.tapToAddAccount,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addAccount),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final Account account;
  final String providerName;
  final String apiKeyAlias;
  final Color providerColor;
  final IconData providerIcon;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onDelete;

  const _AccountCard({
    required this.account,
    required this.providerName,
    required this.apiKeyAlias,
    required this.providerColor,
    required this.providerIcon,
    required this.onEnabledChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: providerColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(providerIcon, color: providerColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            account.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        _EnabledBadge(enabled: account.enabled),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _AccountChip(icon: Icons.business, label: providerName),
                        _AccountChip(
                          icon: Icons.key_outlined,
                          label: apiKeyAlias,
                        ),
                        _AccountChip(
                          icon: Icons.payments_outlined,
                          label: account.currency,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SelectableText(
                      account.baseUrl,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Switch(value: account.enabled, onChanged: onEnabledChanged),
                  IconButton(
                    tooltip: L10n.of('delete'),
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnabledBadge extends StatelessWidget {
  final bool enabled;

  const _EnabledBadge({required this.enabled});

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? const Color(0xFF16A34A)
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(
        enabled ? Icons.check_circle : Icons.pause_circle,
        color: color,
        size: 16,
      ),
    );
  }
}

class _AccountChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AccountChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderInfoCard extends StatelessWidget {
  final ProviderCatalogEntry entry;

  const _ProviderInfoCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.75),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_fix_high, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  L10n.of('provider_base_url_hint'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            entry.defaultBaseUrl,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CapabilityChip(
                icon: Icons.memory_outlined,
                label:
                    '${L10n.of('provider_default_model')}: ${entry.defaultModel}',
              ),
              _CapabilityChip(
                icon: Icons.api_outlined,
                label:
                    '${L10n.of('provider_api_style')}: ${_apiStyleLabel(entry.apiStyle)}',
              ),
              _CapabilityChip(
                icon: Icons.calculate_outlined,
                label: L10n.of('provider_supports_usage'),
                active: entry.supportsUsageParsing,
              ),
              _CapabilityChip(
                icon: Icons.stream_outlined,
                label: L10n.of('provider_supports_streaming'),
                active: entry.supportsStreaming,
              ),
              _CapabilityChip(
                icon: Icons.account_balance_wallet_outlined,
                label: L10n.of('provider_supports_balance'),
                active: entry.supportsBalanceQuery,
              ),
              _CapabilityChip(
                icon: Icons.list_alt_outlined,
                label: L10n.of('provider_supports_models'),
                active: entry.supportsModelList,
              ),
              if (entry.requiresCustomBaseUrl)
                _CapabilityChip(
                  icon: Icons.edit_location_alt_outlined,
                  label: L10n.of('provider_needs_custom_url'),
                  active: true,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            L10n.of(entry.noteKey),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (entry.docsUrl.isNotEmpty) ...[
            const SizedBox(height: 6),
            SelectableText(
              entry.docsUrl,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _apiStyleLabel(ProviderApiStyle style) {
    switch (style) {
      case ProviderApiStyle.openAICompatible:
        return L10n.of('api_style_openai');
      case ProviderApiStyle.anthropicMessages:
        return L10n.of('api_style_anthropic');
      case ProviderApiStyle.gemini:
        return L10n.of('api_style_gemini');
      case ProviderApiStyle.azureOpenAI:
        return L10n.of('api_style_azure');
      case ProviderApiStyle.custom:
        return L10n.of('api_style_custom');
    }
  }
}

class _CapabilityChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _CapabilityChip({
    required this.icon,
    required this.label,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = active ? colorScheme.primary : colorScheme.onSurfaceVariant;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: active ? 0.1 : 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
