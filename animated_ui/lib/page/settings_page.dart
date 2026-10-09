import 'package:animated_ui/core/theme/app_colors.dart';
import 'package:animated_ui/core/theme/app_theme_mode.dart';
import 'package:animated_ui/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// সেটিংস পেজ — থিম সিলেকশন এখন চেক-আইকন টাইলের বদলে Switch বাটন দিয়ে
/// করা, যা একসাথে একটিমাত্র থিম সক্রিয় রাখে (অন্যটি অন করলে আগেরটি
/// স্বয়ংক্রিয়ভাবে অফ হয়ে যায়; বর্তমানে সক্রিয় থিমের সুইচে চাপ দিলে কিছু
/// হয় না, যাতে সবকটি থিম বন্ধ হয়ে না যায়)।
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final currentMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: colors.headerColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.headerOnColor),
        title: Text(
          'সেটিংস',
          style: TextStyle(
            fontFamily: 'TiroBangla-Regular',
            color: colors.headerOnColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'থিম',
            style: TextStyle(
              fontFamily: 'TiroBangla-Regular',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          _ThemeSwitchTile(
            title: 'লাইট মোড',
            icon: Icons.light_mode_outlined,
            mode: AppThemeMode.light,
            currentMode: currentMode,
            colors: colors,
          ),
          _ThemeSwitchTile(
            title: 'ডার্ক মোড',
            icon: Icons.dark_mode_outlined,
            mode: AppThemeMode.dark,
            currentMode: currentMode,
            colors: colors,
          ),
          _ThemeSwitchTile(
            title: 'কালারফুল মোড',
            icon: Icons.palette_outlined,
            mode: AppThemeMode.colorful,
            currentMode: currentMode,
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _ThemeSwitchTile extends ConsumerWidget {
  const _ThemeSwitchTile({
    required this.title,
    required this.icon,
    required this.mode,
    required this.currentMode,
    required this.colors,
  });

  final String title;
  final IconData icon;
  final AppThemeMode mode;
  final AppThemeMode currentMode;
  final AppColors colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isActive = currentMode == mode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isActive ? colors.accentColor : colors.dividerColor.withOpacity(0.3)),
      ),
      child: SwitchListTile(
        secondary: Icon(icon, color: isActive ? colors.accentColor : colors.secondaryText),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'TiroBangla-Regular',
            fontWeight: FontWeight.w600,
            color: colors.primaryText,
          ),
        ),
        value: isActive,
        activeColor: colors.accentColor,
        onChanged: (bool value) {
          // শুধু অন করার দিকেই প্রতিক্রিয়া — বর্তমান সক্রিয় থিমের সুইচে
          // ট্যাপ করে সেটি অফ করা যাবে না (তাহলে কোনো থিমই সক্রিয় থাকবে না)।
          if (value) {
            ref.read(themeProvider.notifier).setTheme(mode);
          }
        },
      ),
    );
  }
}
