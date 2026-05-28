import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/l10n.dart';
import 'presentation/pages/accounts_page.dart';
import 'presentation/pages/charts_page.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/help_page.dart';
import 'presentation/pages/logs_page.dart';
import 'presentation/pages/pricing_page.dart';
import 'presentation/pages/settings_page.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: L10n.of('app_title'),
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }

  static String get _chineseFontFamily {
    if (Platform.isWindows) return 'Microsoft YaHei';
    if (Platform.isAndroid) return 'Noto Sans SC';
    if (Platform.isLinux) return 'Noto Sans CJK SC';
    if (Platform.isMacOS) return 'PingFang SC';
    return 'Noto Sans SC';
  }

  static const _fontFamilyFallback = <String>[
    'Microsoft YaHei',
    'Noto Sans SC',
    'PingFang SC',
    'Noto Sans CJK SC',
    'sans-serif',
  ];

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;
    final surfaceTint = isDark ? const Color(0xFF93C5FD) : colorScheme.primary;

    final baseTextTheme = Typography.material2021(
      platform: Platform.isAndroid
          ? TargetPlatform.android
          : Platform.isIOS
          ? TargetPlatform.iOS
          : Platform.isWindows
          ? TargetPlatform.windows
          : Platform.isMacOS
          ? TargetPlatform.macOS
          : TargetPlatform.linux,
    );
    final brightnessTheme = isDark ? baseTextTheme.white : baseTextTheme.black;
    final textTheme = brightnessTheme.apply(
      fontFamily: _chineseFontFamily,
      fontFamilyFallback: _fontFamilyFallback,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: _chineseFontFamily,
      fontFamilyFallback: _fontFamilyFallback,
      textTheme: textTheme,
      scaffoldBackgroundColor: Color.alphaBlend(
        surfaceTint.withValues(alpha: isDark ? 0.03 : 0.025),
        colorScheme.surface,
      ),
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surface.withValues(alpha: isDark ? 0.92 : 0.96),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.58),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: isDark ? 0.22 : 0.46,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: colorScheme.surface.withValues(
          alpha: isDark ? 0.94 : 0.98,
        ),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface.withValues(
          alpha: isDark ? 0.88 : 0.94,
        ),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        selectedLabelTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _desktopBreakpoint = 900.0;
  static const _moreIndex = 7;
  int _selectedIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return DashboardPage(onNavigate: _selectPage);
      case 1:
        return const AccountsPage();
      case 2:
        return const PricingPage();
      case 3:
        return const LogsPage();
      case 4:
        return const ChartsPage();
      case 5:
        return const SettingsPage();
      case 6:
        return const HelpPage();
      case _moreIndex:
        return _MorePage(onSelectPage: _selectPage);
      default:
        return DashboardPage(onNavigate: _selectPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _desktopBreakpoint;
        final effectiveIndex = isWide && _selectedIndex == _moreIndex
            ? 0
            : _selectedIndex;

        return Scaffold(
          body: Row(
            children: [
              if (isWide)
                _buildNavigationRail(
                  context,
                  l10n,
                  effectiveIndex,
                  constraints.maxWidth,
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: KeyedSubtree(
                    key: ValueKey(effectiveIndex),
                    child: _getPage(effectiveIndex),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide ? null : _buildBottomNavigation(l10n),
        );
      },
    );
  }

  Widget _buildNavigationRail(
    BuildContext context,
    L10nLocalizations l10n,
    int selectedIndex,
    double width,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          ],
        ),
        border: Border(
          right: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: SafeArea(
        child: NavigationRail(
          extended: width >= 1180,
          minExtendedWidth: 206,
          selectedIndex: selectedIndex.clamp(0, 6),
          onDestinationSelected: _selectPage,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: _BrandMark(extended: width >= 1180),
          ),
          destinations: [
            NavigationRailDestination(
              icon: const Icon(Icons.space_dashboard_outlined),
              selectedIcon: const Icon(Icons.space_dashboard),
              label: Text(l10n.navDashboard),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.cloud_queue_outlined),
              selectedIcon: const Icon(Icons.cloud),
              label: Text(l10n.navAccounts),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.sell_outlined),
              selectedIcon: const Icon(Icons.sell),
              label: Text(l10n.navPricing),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long),
              label: Text(l10n.navLogs),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.stacked_line_chart_outlined),
              selectedIcon: const Icon(Icons.stacked_line_chart),
              label: Text(l10n.navCharts),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.tune_outlined),
              selectedIcon: const Icon(Icons.tune),
              label: Text(l10n.navSettings),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.help_outline),
              selectedIcon: const Icon(Icons.help),
              label: Text(l10n.navHelp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(L10nLocalizations l10n) {
    const bottomIndexes = [0, 1, 3, 4, _moreIndex];
    final bottomSelectedIndex = bottomIndexes.contains(_selectedIndex)
        ? bottomIndexes.indexOf(_selectedIndex)
        : bottomIndexes.length - 1;

    return NavigationBar(
      selectedIndex: bottomSelectedIndex,
      onDestinationSelected: (index) => _selectPage(bottomIndexes[index]),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.space_dashboard_outlined),
          selectedIcon: const Icon(Icons.space_dashboard),
          label: l10n.navDashboard,
        ),
        NavigationDestination(
          icon: const Icon(Icons.cloud_queue_outlined),
          selectedIcon: const Icon(Icons.cloud),
          label: l10n.navAccounts,
        ),
        NavigationDestination(
          icon: const Icon(Icons.receipt_long_outlined),
          selectedIcon: const Icon(Icons.receipt_long),
          label: l10n.navLogs,
        ),
        NavigationDestination(
          icon: const Icon(Icons.stacked_line_chart_outlined),
          selectedIcon: const Icon(Icons.stacked_line_chart),
          label: l10n.navCharts,
        ),
        NavigationDestination(
          icon: const Icon(Icons.apps_outlined),
          selectedIcon: const Icon(Icons.apps),
          label: l10n.navMore,
        ),
      ],
    );
  }
}

class _BrandMark extends StatelessWidget {
  final bool extended;

  const _BrandMark({required this.extended});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.tertiary],
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.query_stats, color: colorScheme.onPrimary),
        ),
        if (extended) ...[
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              L10n.of('app_title'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ],
    );
  }
}

class _MorePage extends StatelessWidget {
  final ValueChanged<int> onSelectPage;

  const _MorePage({required this.onSelectPage});

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navMore)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.tertiaryContainer.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(Icons.route, color: colorScheme.onPrimaryContainer),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    L10n.of('more_hint'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _MoreTile(
            icon: Icons.sell_outlined,
            title: l10n.navPricing,
            subtitle: l10n.helpPricingDesc,
            onTap: () => onSelectPage(2),
          ),
          const SizedBox(height: 10),
          _MoreTile(
            icon: Icons.tune_outlined,
            title: l10n.navSettings,
            subtitle: l10n.helpSettingsDesc,
            onTap: () => onSelectPage(5),
          ),
          const SizedBox(height: 10),
          _MoreTile(
            icon: Icons.help_outline,
            title: l10n.navHelp,
            subtitle: l10n.helpQuickStart,
            onTap: () => onSelectPage(6),
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
