import 'package:flutter/material.dart';

/// 统一设计系统 — 色板、圆角、阴影、渐变
class AppTheme {
  AppTheme._();

  // ── 种子色 ──────────────────────────────────────────────
  static const Color seedColor = Color(0xFF4F6BF6);

  // ── 语义色 ──────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF3B82F6);

  // ── 统计卡渐变色 ────────────────────────────────────────
  static const List<Gradient> statGradients = [
    LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF16A34A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)], begin: Alignment.topLeft, end: Alignment.bottomRight),
    LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF0D9488)], begin: Alignment.topLeft, end: Alignment.bottomRight),
  ];

  // ── Provider 品牌色 ─────────────────────────────────────
  static const Color deepseekBrand     = Color(0xFF3B82F6);
  static const Color mimoBrand         = Color(0xFF8B5CF6);
  static const Color geminiBrand       = Color(0xFF22C55E);
  static const Color openrouterBrand   = Color(0xFFF59E0B);
  static const Color customOpenAIBrand = Color(0xFF14B8A6);

  // ── 圆角 ────────────────────────────────────────────────
  static const double radiusS  = 8;
  static const double radiusM  = 12;
  static const double radiusL  = 16;
  static const double radiusXL = 24;

  // ── 间距 ────────────────────────────────────────────────
  static const double spaceXS  = 4;
  static const double spaceS   = 8;
  static const double spaceM   = 12;
  static const double spaceL   = 16;
  static const double spaceXL  = 24;
  static const double spaceXXL = 32;

  // ── 阴影 ────────────────────────────────────────────────
  static List<BoxShadow> shadowS([Color? color]) => [
        BoxShadow(
          color: (color ?? Colors.black).withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> shadowM([Color? color]) => [
        BoxShadow(
          color: (color ?? Colors.black).withValues(alpha: 0.10),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // ── ThemeData ───────────────────────────────────────────
  static ThemeData lightTheme() => _buildTheme(Brightness.light);
  static ThemeData darkTheme()  => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: null,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusS),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusS),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusL),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
      ),
    );
  }
}
