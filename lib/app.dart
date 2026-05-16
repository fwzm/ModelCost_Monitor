import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/l10n.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/pages/dashboard_page.dart';
import 'presentation/pages/accounts_page.dart';
import 'presentation/pages/pricing_page.dart';
import 'presentation/pages/settings_page.dart';
import 'presentation/pages/logs_page.dart';
import 'presentation/pages/charts_page.dart';
import 'presentation/pages/help_page.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: L10n.of('app_title'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  /// 核心 5 个 Tab
  late final List<_NavTarget> _tabs = [
    _NavTarget(
      DashboardPage.new,
      Icons.space_dashboard_rounded,
      Icons.dashboard_outlined,
      'nav_dashboard',
    ),
    _NavTarget(
      AccountsPage.new,
      Icons.cloud_rounded,
      Icons.cloud_outlined,
      'nav_accounts',
    ),
    _NavTarget(
      LogsPage.new,
      Icons.receipt_long_rounded,
      Icons.receipt_long_outlined,
      'nav_logs',
    ),
    _NavTarget(
      ChartsPage.new,
      Icons.bar_chart_rounded,
      Icons.bar_chart_outlined,
      'nav_charts',
    ),
    _NavTarget(
      SettingsPage.new,
      Icons.settings_rounded,
      Icons.settings_outlined,
      'nav_settings',
    ),
  ];

  /// 更多页面
  late final List<_NavTarget> _drawerItems = [
    _NavTarget(
      PricingPage.new,
      Icons.price_change_rounded,
      Icons.price_change_outlined,
      'nav_pricing',
    ),
    _NavTarget(
      HelpPage.new,
      Icons.help_outline_rounded,
      Icons.help_outline_outlined,
      'nav_help',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 840;
        return Scaffold(
          key: _scaffoldKey,
          body: useRail
              ? _buildWideLayout(context, constraints.maxWidth)
              : _tabs[_selectedIndex].builder(),
          bottomNavigationBar: useRail ? null : _buildBottomNavigation(),
          endDrawer: useRail ? null : _buildMoreDrawer(context),
        );
      },
    );
  }

  Widget _buildWideLayout(BuildContext context, double width) {
    final destinations = [..._tabs, ..._drawerItems];
    final selected = _selectedIndex < destinations.length
        ? _selectedIndex
        : destinations.length - 1;

    return Row(
      children: [
        NavigationRail(
          extended: width >= 1120,
          minExtendedWidth: 216,
          selectedIndex: selected,
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          leading: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceL),
            child: Icon(
              Icons.monitor_heart_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          destinations: [
            ...destinations.map(
              (t) => NavigationRailDestination(
                icon: Icon(t.outlinedIcon),
                selectedIcon: Icon(t.filledIcon),
                label: Text(L10n.of(t.labelKey)),
              ),
            ),
          ],
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        Expanded(child: destinations[selected].builder()),
      ],
    );
  }

  NavigationBar _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: _selectedIndex < _tabs.length ? _selectedIndex : 0,
      onDestinationSelected: (i) {
        if (i == _tabs.length) {
          _scaffoldKey.currentState?.openEndDrawer();
        } else {
          setState(() => _selectedIndex = i);
        }
      },
      destinations: [
        ..._tabs.map(
          (t) => NavigationDestination(
            icon: Icon(t.outlinedIcon),
            selectedIcon: Icon(t.filledIcon),
            label: L10n.of(t.labelKey),
          ),
        ),
        NavigationDestination(
          icon: const Icon(Icons.menu_rounded),
          selectedIcon: const Icon(Icons.menu_rounded),
          label: L10n.of('nav_more'),
        ),
      ],
    );
  }

  Drawer _buildMoreDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spaceL),
              child: Row(
                children: [
                  Icon(
                    Icons.more_horiz_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppTheme.spaceS),
                  Text(
                    L10n.of('nav_more'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const Divider(indent: 16, endIndent: 16),
            ..._drawerItems.map(
              (t) => ListTile(
                leading: Icon(
                  t.filledIcon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(L10n.of(t.labelKey)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => t.builder()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTarget {
  final Widget Function() builder;
  final IconData filledIcon;
  final IconData outlinedIcon;
  final String labelKey;
  _NavTarget(this.builder, this.filledIcon, this.outlinedIcon, this.labelKey);
}
