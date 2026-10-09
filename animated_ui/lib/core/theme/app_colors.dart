import 'package:flutter/material.dart';

/// পুরো অ্যাপের জন্য একটি সম্পূর্ণ, অপরিবর্তনীয় (immutable) কালার-সেট।
/// তিনটি থিমের (Light/Dark/Colorful) প্রতিটির জন্য এই ক্লাসের একটি করে
/// স্ট্যাটিক প্রিসেট আছে। সব উইজেট সরাসরি কালার হার্ডকোড না করে এই
/// অবজেক্টের মাধ্যমে কালার নেয়, যাতে থিম বদলালে পুরো অ্যাপ একযোগে বদলায়।
///
/// লক্ষ্য রাখা হয়েছে, "গ্রহণ"-এর সবুজ/টিল আর "জমা"-র লাল/নীল রঙের মতো
/// সিমান্টিক (অর্থবহ) রংগুলো থিম-নিরপেক্ষ রাখা হয়েছে — এগুলো থিম বদলালেও
/// বদলায় না, কারণ এরা নির্দিষ্ট অর্থ বহন করে।
@immutable
class AppColors {
  const AppColors({
    required this.scaffoldBackground,
    required this.headerColor,
    required this.headerGradient,
    required this.headerOnColor,
    required this.cardColor,
    required this.primaryText,
    required this.secondaryText,
    required this.accentColor,
    required this.tabSelectedBackground,
    required this.tabSelectedText,
    required this.tabUnselectedText,
    required this.dividerColor,
    required this.inputFill,
    required this.inputBorder,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.drawerBackground,
    required this.drawerOnColor,
    required this.totalBoxBackground,
    required this.fabColor,
    required this.fabOnColor,
  });

  final Color scaffoldBackground;
  final Color headerColor;
  final List<Color> headerGradient;
  final Color headerOnColor;
  final Color cardColor;
  final Color primaryText;
  final Color secondaryText;
  final Color accentColor;
  final Color tabSelectedBackground;
  final Color tabSelectedText;
  final Color tabUnselectedText;
  final Color dividerColor;
  final Color inputFill;
  final Color inputBorder;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color drawerBackground;
  final Color drawerOnColor;
  final Color totalBoxBackground;
  final Color fabColor;
  final Color fabOnColor;

  // থিম-নিরপেক্ষ সিমান্টিক রং (সব থিমেই অপরিবর্তিত) —————————————
  static const Color receiveColor = Color(0xFF00897B); // টিল — গ্রহণ
  static const Color depositColor = Color(0xFF1E88E5); // নীল — জমা
  static const Color editColor = Color(0xFF43A047); // সবুজ — এডিট
  static const Color deleteColor = Color(0xFFE53935); // লাল — ডিলিট
  static const Color creditColor = Color(0xFF2E7D32); // মোট পাবো
  static const Color debitColor = Color(0xFFC62828); // মোট দিবো

  static const AppColors light = AppColors(
    scaffoldBackground: Colors.white,
    headerColor: Color(0xFFB5792B),
    headerGradient: [Color(0xFFB5792B), Color(0xFF9C6324)],
    headerOnColor: Colors.white,
    cardColor: Colors.white,
    primaryText: Color(0xE3945526),
    secondaryText: Color(0xADCD852F),
    accentColor: Color(0xADCD852F),
    tabSelectedBackground: Colors.white,
    tabSelectedText: Color(0xFFB5792B),
    tabUnselectedText: Color(0xFFF3E4D0),
    dividerColor: Color(0xFFB5792B),
    inputFill: Colors.white,
    inputBorder: Color(0xADCD852F),
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    drawerBackground: Color(0xFFB5792B),
    drawerOnColor: Colors.white,
    totalBoxBackground: Color(0xFFDFBF9C),
    fabColor: Color(0xFFB5792B),
    fabOnColor: Color(0xFFDFBF9C),
  );

  static const AppColors dark = AppColors(
    scaffoldBackground: Color(0xFF121212),
    headerColor: Color(0xFF2A2A2A),
    headerGradient: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
    headerOnColor: Colors.white,
    cardColor: Color(0xFF1E1E1E),
    primaryText: Color(0xFFE8C98B),
    secondaryText: Color(0xFFBDBDBD),
    accentColor: Color(0xFFE8C98B),
    tabSelectedBackground: Color(0xFF3A3A3A),
    tabSelectedText: Color(0xFFE8C98B),
    tabUnselectedText: Color(0xFF9E9E9E),
    dividerColor: Color(0xFF3A3A3A),
    inputFill: Color(0xFF1E1E1E),
    inputBorder: Color(0xFFE8C98B),
    shimmerBase: Color(0xFF2A2A2A),
    shimmerHighlight: Color(0xFF3A3A3A),
    drawerBackground: Color(0xFF1A1A1A),
    drawerOnColor: Colors.white,
    totalBoxBackground: Color(0xFF2A2A2A),
    fabColor: Color(0xFFE8C98B),
    fabOnColor: Color(0xFF121212),
  );

  static const AppColors colorful = AppColors(
    scaffoldBackground: Color(0xFFF4F1FB),
    headerColor: Color(0xFF7C4DFF),
    headerGradient: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
    headerOnColor: Colors.white,
    cardColor: Colors.white,
    primaryText: Color(0xFF512DA8),
    secondaryText: Color(0xFF9575CD),
    accentColor: Color(0xFF7C4DFF),
    tabSelectedBackground: Colors.white,
    tabSelectedText: Color(0xFF7C4DFF),
    tabUnselectedText: Color(0xFFE1D7FB),
    dividerColor: Color(0xFFD1C4E9),
    inputFill: Colors.white,
    inputBorder: Color(0xFF7C4DFF),
    shimmerBase: Color(0xFFE1D7FB),
    shimmerHighlight: Color(0xFFF4F1FB),
    drawerBackground: Color(0xFF7C4DFF),
    drawerOnColor: Colors.white,
    totalBoxBackground: Color(0xFFEDE7F6),
    fabColor: Color(0xFF7C4DFF),
    fabOnColor: Colors.white,
  );
}
