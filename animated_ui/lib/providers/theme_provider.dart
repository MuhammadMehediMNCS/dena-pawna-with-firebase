import 'package:animated_ui/core/theme/app_colors.dart';
import 'package:animated_ui/core/theme/app_theme_mode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

/// থিম সিলেকশন GetStorage দিয়ে ডিস্কে সেভ থাকে (এটি `get` প্যাকেজের
/// GetxController-নির্ভর নয়, তাই Riverpod মাইগ্রেশনের পরও এটি রেখে
/// দেওয়া নিরাপদ এবং সহজ)।
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(_readInitial());

  static const String _storageKey = 'app_theme_mode';
  final GetStorage _box = GetStorage();

  static AppThemeMode _readInitial() {
    final box = GetStorage();
    final String? saved = box.read<String>(_storageKey);
    return AppThemeModeStorage.fromStorageKey(saved);
  }

  void setTheme(AppThemeMode mode) {
    if (state == mode) return;
    state = mode;
    _box.write(_storageKey, mode.storageKey);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>(
  (ref) => ThemeNotifier(),
);

/// বর্তমানে সক্রিয় থিমের সম্পূর্ণ কালার-সেট — UI এই প্রোভাইডার watch করে
/// কালার নেয়, থিম enum সরাসরি নয়।
final appColorsProvider = Provider<AppColors>((ref) {
  final mode = ref.watch(themeProvider);
  switch (mode) {
    case AppThemeMode.dark:
      return AppColors.dark;
    case AppThemeMode.colorful:
      return AppColors.colorful;
    case AppThemeMode.light:
      return AppColors.light;
  }
});
