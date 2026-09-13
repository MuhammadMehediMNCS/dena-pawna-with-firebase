import 'package:flutter/material.dart';

import 'app_theme_mode.dart';

/// একটি নির্দিষ্ট থিমের সব রঙ এক জায়গায়। কোনো widget সরাসরি রঙ হার্ডকোড
/// না করে এখান থেকে রঙ নেয় (`ThemeController.colors` এর মাধ্যমে), যাতে
/// থিম বদলালে পুরো অ্যাপের রঙ একসাথে বদলে যায়।
class AppColors {
  const AppColors({
    required this.pageBackground,
    required this.headerColor,
    required this.headerTextColor,
    required this.drawerBackground,
    required this.drawerTextColor,
    required this.cardBackground,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.totalBoxBackground,
    required this.tabSelectedBackground,
    required this.tabSelectedText,
    required this.tabUnselectedText,
    required this.fabBackground,
    required this.fabIcon,
  });

  final Color pageBackground;
  final Color headerColor;
  final Color headerTextColor;
  final Color drawerBackground;
  final Color drawerTextColor;
  final Color cardBackground;
  final Color cardBorder;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color totalBoxBackground;
  final Color tabSelectedBackground;
  final Color tabSelectedText;
  final Color tabUnselectedText;
  final Color fabBackground;
  final Color fabIcon;

  /// LIGHT MODE — বর্তমান ডিফল্ট, সাদা ব্যাকগ্রাউন্ড + বাদামি/কমলা হেডার।
  static const AppColors light = AppColors(
    pageBackground: Colors.white,
    headerColor: Color(0xFFB5792B),
    headerTextColor: Colors.white,
    drawerBackground: Color(0xFFB5792B),
    drawerTextColor: Colors.white,
    cardBackground: Colors.white,
    cardBorder: Color(0x33945526),
    textPrimary: Color(0xE3945526),
    textSecondary: Color(0xADCD852F),
    accent: Color(0xFFB5792B),
    totalBoxBackground: Color(0xFFDFBF9C),
    tabSelectedBackground: Colors.white,
    tabSelectedText: Color(0xFFB5792B),
    tabUnselectedText: Color(0xFFF3E4D0),
    fabBackground: Color(0xFFB5792B),
    fabIcon: Color(0xFFDFBF9C),
  );

  /// COLORFUL DARK — প্রায়-কালো ব্যাকগ্রাউন্ড, গাঢ় কার্ড, হালকা টেক্সট।
  static const AppColors dark = AppColors(
    pageBackground: Color(0xFF121212),
    headerColor: Color(0xFF241A12),
    headerTextColor: Colors.white,
    drawerBackground: Color(0xFF1A1A1A),
    drawerTextColor: Colors.white,
    cardBackground: Color(0xFF1E1E1E),
    cardBorder: Color(0xFF333333),
    textPrimary: Color(0xFFECECEC),
    textSecondary: Color(0xFFB0AFAF),
    accent: Color(0xFFCD852F),
    totalBoxBackground: Color(0xFF2E2013),
    tabSelectedBackground: Colors.white,
    tabSelectedText: Color(0xFF6B4419),
    tabUnselectedText: Color(0xFFCBB499),
    fabBackground: Color(0xFFCD852F),
    fabIcon: Color(0xFF1A1A1A),
  );

  /// COLORFUL MODE — উষ্ণ ক্রিম/গোল্ড প্যালেট।
  static const AppColors colorful = AppColors(
    pageBackground: Color(0xFFFCEBC9),
    headerColor: Color(0xFFC98A2C),
    headerTextColor: Colors.white,
    drawerBackground: Color(0xFFC98A2C),
    drawerTextColor: Colors.white,
    cardBackground: Color(0xFFFFFDF7),
    cardBorder: Color(0xFFE7C68A),
    textPrimary: Color(0xFF4A2E12),
    textSecondary: Color(0xFF8A6A4A),
    accent: Color(0xFFC98A2C),
    totalBoxBackground: Color(0xFFF3D9A6),
    tabSelectedBackground: Colors.white,
    tabSelectedText: Color(0xFFC98A2C),
    tabUnselectedText: Color(0xFFEFD8AC),
    fabBackground: Color(0xFFC98A2C),
    fabIcon: Colors.white,
  );

  static AppColors of(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.dark:
        return dark;
      case AppThemeMode.colorful:
        return colorful;
      case AppThemeMode.light:
        return light;
    }
  }
}
