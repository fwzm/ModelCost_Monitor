import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';
import '../theme/app_theme.dart';

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
        padding: const EdgeInsets.all(AppTheme.spaceL),
        children: [
          // ── 软件简介 ──
          _ChapterCard(
            icon: Icons.info_outline_rounded,
            color: AppTheme.info,
            title: l10n.helpOverviewTitle,
            children: [
              _BodyText(l10n.helpOverviewDesc),
              const SizedBox(height: AppTheme.spaceM),
              _BulletItem(l10n.helpOverviewFeature1),
              _BulletItem(l10n.helpOverviewFeature2),
              _BulletItem(l10n.helpOverviewFeature3),
              _BulletItem(l10n.helpOverviewFeature4),
              _BulletItem(l10n.helpOverviewFeature5),
              _BulletItem(l10n.helpOverviewFeature6),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 快速开始 ──
          _ChapterCard(
            icon: Icons.rocket_launch_rounded,
            color: AppTheme.success,
            title: l10n.helpQuickStart,
            children: [
              _StepItem('1', l10n.helpStep1AddAccount),
              _StepItem('2', l10n.helpStep2ConfigPrice),
              _StepItem('3', l10n.helpStep3StartProxy),
              _StepItem('4', l10n.helpStep4UseProxy),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 总览页面 ──
          _ChapterCard(
            icon: Icons.space_dashboard_rounded,
            color: AppTheme.seedColor,
            title: l10n.helpDashboardTitle,
            children: [
              _BodyText(l10n.helpDashboardDesc),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpDashboardProxyCard),
              const SizedBox(height: AppTheme.spaceS),
              _SubSection(l10n.helpDashboardStats),
              const SizedBox(height: AppTheme.spaceS),
              _SubSection(l10n.helpDashboardActivity),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 账号管理 ──
          _ChapterCard(
            icon: Icons.cloud_rounded,
            color: AppTheme.deepseekBrand,
            title: l10n.helpAccountsTitle,
            children: [
              _BodyText(l10n.helpAccountsDesc),
              const SizedBox(height: AppTheme.spaceM),
              _SubTitle(l10n.addAccount),
              const SizedBox(height: AppTheme.spaceXS),
              _BodyText(l10n.helpAccountsAdd),
              const SizedBox(height: AppTheme.spaceM),
              _SubTitle(l10n.editAccount),
              const SizedBox(height: AppTheme.spaceXS),
              _BodyText(l10n.helpAccountsManage),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 价格配置 ──
          _ChapterCard(
            icon: Icons.price_change_rounded,
            color: AppTheme.openrouterBrand,
            title: l10n.helpPricingTitle,
            children: [
              _BodyText(l10n.helpPricingDesc),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpPricingWhy),
              const SizedBox(height: AppTheme.spaceM),
              _SubTitle(l10n.addPrice),
              const SizedBox(height: AppTheme.spaceXS),
              _BodyText(l10n.helpPricingAdd),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpPricingView),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 请求日志 ──
          _ChapterCard(
            icon: Icons.receipt_long_rounded,
            color: AppTheme.mimoBrand,
            title: l10n.helpLogsTitle,
            children: [
              _BodyText(l10n.helpLogsDesc),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpLogsFilter),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpLogsRecord),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpLogsExport),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 图表分析 ──
          _ChapterCard(
            icon: Icons.bar_chart_rounded,
            color: AppTheme.geminiBrand,
            title: l10n.helpChartsTitle,
            children: [
              _BodyText(l10n.helpChartsDesc),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpChartsTypes),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 本地代理 ──
          _ChapterCard(
            icon: Icons.router_rounded,
            color: AppTheme.warning,
            title: l10n.helpProxyTitle,
            children: [
              _BodyText(l10n.helpProxyDesc),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpProxyHow),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpProxySetup),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpProxyHttps),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpProxyLan),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpProxyCors),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 设置选项 ──
          _ChapterCard(
            icon: Icons.settings_rounded,
            color: Colors.grey,
            title: l10n.helpSettingsTitle,
            children: [
              _BodyText(l10n.helpSettingsDesc),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpSettingsProxy),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpSettingsBudget),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpSettingsSystem),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpSettingsLang),
              const SizedBox(height: AppTheme.spaceM),
              _SubSection(l10n.helpSettingsSecurity),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 常见问题 ──
          _ChapterCard(
            icon: Icons.help_outline_rounded,
            color: AppTheme.error,
            title: l10n.helpFaqTitle,
            children: [
              _FaqItem(question: l10n.helpFaq1Q, answer: l10n.helpFaq1A),
              _FaqItem(question: l10n.helpFaq2Q, answer: l10n.helpFaq2A),
              _FaqItem(question: l10n.helpFaq3Q, answer: l10n.helpFaq3A),
              _FaqItem(question: l10n.helpFaq4Q, answer: l10n.helpFaq4A),
              _FaqItem(question: l10n.helpFaq5Q, answer: l10n.helpFaq5A),
              _FaqItem(question: l10n.helpFaq6Q, answer: l10n.helpFaq6A),
              _FaqItem(question: l10n.helpFaq7Q, answer: l10n.helpFaq7A),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 使用技巧 ──
          _ChapterCard(
            icon: Icons.lightbulb_rounded,
            color: Colors.amber,
            title: l10n.helpTipsTitle,
            children: [
              _TipItem(l10n.helpTip1),
              _TipItem(l10n.helpTip2),
              _TipItem(l10n.helpTip3),
              _TipItem(l10n.helpTip4),
              _TipItem(l10n.helpTip5),
              _TipItem(l10n.helpTip6),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),

          // ── 联系我们 ──
          _ChapterCard(
            icon: Icons.mail_outline_rounded,
            color: AppTheme.info,
            title: l10n.helpContactTitle,
            children: [
              _BodyText(l10n.helpContactDesc),
            ],
          ),
          const SizedBox(height: AppTheme.spaceXXL),
        ],
      ),
    );
  }
}

// ── 章节卡片 ──
class _ChapterCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<Widget> children;

  const _ChapterCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceL),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ]),
          const SizedBox(height: AppTheme.spaceL),
          ...children,
        ],
      ),
    );
  }
}

// ── 正文文本（支持 \n 换行） ──
class _BodyText extends StatelessWidget {
  final String text;
  const _BodyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

// ── 子标题 ──
class _SubTitle extends StatelessWidget {
  final String text;
  const _SubTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}

// ── 子段落 ──
class _SubSection extends StatelessWidget {
  final String text;
  const _SubSection(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              height: 1.7,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

// ── 步骤条 ──
class _StepItem extends StatelessWidget {
  final String number;
  final String text;
  const _StepItem(this.number, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.seedColor, AppTheme.seedColor.withValues(alpha: 0.7)],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 列表项 ──
class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppTheme.seedColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceS),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ── FAQ 可展开项 ──
class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(
          left: AppTheme.spaceL,
          bottom: AppTheme.spaceS,
        ),
        dense: true,
        title: Row(
          children: [
            Icon(Icons.help_outline_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                question,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
        children: [
          Text(
            answer,
            style: TextStyle(fontSize: 13, height: 1.7, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

// ── 使用技巧条目 ──
class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(Icons.tips_and_updates_rounded, size: 16, color: Colors.amber[700]),
          ),
          const SizedBox(width: AppTheme.spaceS),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
