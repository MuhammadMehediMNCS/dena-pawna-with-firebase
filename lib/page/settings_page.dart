import 'package:dena_pawna/controller/theme_controller.dart';
import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:dena_pawna/core/theme/app_theme_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ড্রয়ারের 'সেটিংস' থেকে এখানে আসা হয়। এই পেজে একটি 'থিম' সেকশন আছে,
/// যেখানে ডার্ক/লাইট/কালার — প্রতিটি অপশনের পাশে একটি সুইচ বাটন আছে।
/// যেই থিম বর্তমানে চালু আছে তার সুইচটি অন থাকে; অন্য কোনো সুইচে ট্যাপ
/// করলে সেই থিম চালু হয়ে যায় ও বাকি সুইচগুলো স্বয়ংক্রিয়ভাবে অফ হয়ে যায়
/// (যেহেতু একসাথে একটিমাত্র থিমই চালু থাকতে পারে)।
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final colors = themeController.colors;

      return Scaffold(
        backgroundColor: colors.pageBackground,
        appBar: AppBar(
          backgroundColor: colors.headerColor,
          elevation: 0,
          title: Text(
            'সেটিংস',
            style: TextStyle(
              color: colors.headerTextColor,
              fontFamily: 'TiroBangla-Regular',
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          iconTheme: IconThemeData(color: colors.headerTextColor),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'থিম',
              style: TextStyle(
                color: colors.textPrimary,
                fontFamily: 'TiroBangla-Regular',
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8.0),
            _ThemeOptionTile(
              title: 'ডার্ক',
              subtitle: 'গাঢ় ব্যাকগ্রাউন্ড, চোখে আরামদায়ক',
              icon: Icons.dark_mode_rounded,
              mode: AppThemeMode.dark,
              currentMode: themeController.mode.value,
              colors: colors,
              onSelected: () => themeController.changeTheme(AppThemeMode.dark),
            ),
            const SizedBox(height: 10.0),
            _ThemeOptionTile(
              title: 'লাইট',
              subtitle: 'উজ্জ্বল সাদা ব্যাকগ্রাউন্ড (ডিফল্ট)',
              icon: Icons.light_mode_rounded,
              mode: AppThemeMode.light,
              currentMode: themeController.mode.value,
              colors: colors,
              onSelected: () => themeController.changeTheme(AppThemeMode.light),
            ),
            const SizedBox(height: 10.0),
            _ThemeOptionTile(
              title: 'কালার',
              subtitle: 'উষ্ণ ক্রিম ও গোল্ড রঙের থিম',
              icon: Icons.palette_rounded,
              mode: AppThemeMode.colorful,
              currentMode: themeController.mode.value,
              colors: colors,
              onSelected: () => themeController.changeTheme(AppThemeMode.colorful),
            ),
          ],
        ),
      );
    });
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.mode,
    required this.currentMode,
    required this.colors,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final AppThemeMode mode;
  final AppThemeMode currentMode;
  final AppColors colors;
  final VoidCallback onSelected;

  bool get _isSelected => mode == currentMode;

  void _handleToggle(bool value) {
    // সুইচ অফ করার চেষ্টা করলেও কিছু হবে না — একটিমাত্র থিম সবসময় চালু
    // থাকতেই হবে, তাই শুধু 'অন করার' ট্যাপেই থিম বদলানো হয়।
    if (value) onSelected();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: _isSelected ? colors.accent : colors.cardBorder,
            width: _isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colors.accent.withOpacity(0.12),
              child: Icon(icon, color: colors.accent),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontFamily: 'TiroBangla-Regular',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontFamily: 'TiroBangla-Regular',
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: _isSelected,
              onChanged: _handleToggle,
              activeColor: colors.accent,
            ),
          ],
        ),
      ),
    );
  }
}