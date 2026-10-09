/// অ্যাপের তিনটি সম্ভাব্য থিম মোড।
enum AppThemeMode { light, dark, colorful }

extension AppThemeModeStorage on AppThemeMode {
  /// GetStorage-তে সেভ করার জন্য সাধারণ স্ট্রিং কী।
  String get storageKey => name;

  static AppThemeMode fromStorageKey(String? key) {
    switch (key) {
      case 'dark':
        return AppThemeMode.dark;
      case 'colorful':
        return AppThemeMode.colorful;
      case 'light':
      default:
        return AppThemeMode.light;
    }
  }
}
