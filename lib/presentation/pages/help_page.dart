import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navHelp),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: l10n.helpQuickStart,
            icon: Icons.rocket_launch,
            children: [
              _buildStep(context, '1', l10n.helpStep1AddAccount),
              _buildStep(context, '2', l10n.helpStep2ConfigPrice),
              _buildStep(context, '3', l10n.helpStep3StartProxy),
              _buildStep(context, '4', l10n.helpStep4UseProxy),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpDashboardTitle,
            icon: Icons.dashboard,
            children: [
              _buildInfoCard(
                context,
                l10n.helpDashboardDesc,
                Icons.info_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpAccountsTitle,
            icon: Icons.cloud,
            children: [
              _buildInfoCard(
                context,
                l10n.helpAccountsDesc,
                Icons.info_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpPricingTitle,
            icon: Icons.price_change,
            children: [
              _buildInfoCard(
                context,
                l10n.helpPricingDesc,
                Icons.info_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpLogsTitle,
            icon: Icons.receipt_long,
            children: [
              _buildInfoCard(
                context,
                l10n.helpLogsDesc,
                Icons.info_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpChartsTitle,
            icon: Icons.bar_chart,
            children: [
              _buildInfoCard(
                context,
                l10n.helpChartsDesc,
                Icons.info_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpProxyTitle,
            icon: Icons.router,
            children: [
              _buildInfoCard(
                context,
                l10n.helpProxyDesc,
                Icons.info_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpSettingsTitle,
            icon: Icons.settings,
            children: [
              _buildInfoCard(
                context,
                l10n.helpSettingsDesc,
                Icons.info_outline,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpFaqTitle,
            icon: Icons.help,
            children: [
              _buildFaqItem(context, l10n.helpFaq1Q, l10n.helpFaq1A),
              _buildFaqItem(context, l10n.helpFaq2Q, l10n.helpFaq2A),
              _buildFaqItem(context, l10n.helpFaq3Q, l10n.helpFaq3A),
              _buildFaqItem(context, l10n.helpFaq4Q, l10n.helpFaq4A),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: l10n.helpTipsTitle,
            icon: Icons.lightbulb,
            children: [
              _buildTip(context, l10n.helpTip1),
              _buildTip(context, l10n.helpTip2),
              _buildTip(context, l10n.helpTip3),
              _buildTip(context, l10n.helpTip4),
            ],
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        l10n.helpContactTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.helpContactDesc),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String text, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer),
        ),
      ],
    );
  }

  Widget _buildTip(BuildContext context, String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }
}
