import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:dena_pawna/core/theme/app_theme_mode.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// অ্যাপ জুড়ে কোন থিম (ডার্ক/লাইট/কালার) চালু আছে তা এই কন্ট্রোলার
/// নিয়ন্ত্রণ করে। GetStorage দিয়ে বাছাই করা থিম ডিভাইসে সংরক্ষিত থাকে,
/// তাই অ্যাপ বন্ধ করে আবার খুললেও সর্বশেষ বাছাই করা থিমই থাকে।
///
/// ইনিশিয়ালি [AppThemeMode.light] সিলেক্টেড থাকে (কোনো সংরক্ষিত মান না
/// থাকলে)।
class ThemeController extends GetxController {
  static const String _storageKey = 'app_theme_mode';
  final GetStorage _box = GetStorage();

  final Rx<AppThemeMode> mode = AppThemeMode.light.obs;

  /// বর্তমান থিমের সব রঙ — UI থেকে `themeController.colors.xyz` আকারে
  /// ব্যবহার হবে।
  AppColors get colors => AppColors.of(mode.value);

  @override
  void onInit() {
    super.onInit();

    final String? saved = _box.read<String>(_storageKey);
    if (saved != null) {
      mode.value = AppThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => AppThemeMode.light,
      );
    }
  }

  void changeTheme(AppThemeMode newMode) {
    if (mode.value == newMode) return;

    mode.value = newMode;
    _box.write(_storageKey, newMode.name);
  }
}
