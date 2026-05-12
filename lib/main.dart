import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await L10n.init();

  if (Platform.isWindows) {
    try {
      await windowManager.ensureInitialized();
      await windowManager.setSize(const Size(1200, 800));
      await windowManager.setMinimumSize(const Size(800, 600));
      await windowManager.setTitle('ModelCost Monitor');
    } catch (e) {
      // ignore: avoid_print
      print('Window manager init failed: $e');
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}
