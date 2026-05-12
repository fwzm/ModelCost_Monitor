import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/l10n.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
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
  int _selectedIndex = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
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
        return const SettingsPage();
      case 7:
        return const HelpPage();
      default:
        return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10nLocalizations.of(context);

    return Scaffold(
      body: _getPage(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.cloud),
            label: l10n.navAccounts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.price_change),
            label: l10n.navPricing,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long),
            label: l10n.navLogs,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart),
            label: l10n.navCharts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.help_outline),
            label: l10n.navHelp,
          ),
        ],
      ),
    );
  }
}
