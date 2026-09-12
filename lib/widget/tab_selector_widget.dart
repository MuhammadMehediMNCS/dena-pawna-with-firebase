import 'package:dena_pawna/core/utils/bengali_digits.dart';
import 'package:flutter/material.dart';

/// হোমপেজের 'পাবো' / 'দিবো' ট্যাব বাছাইয়ের বাটন। নির্বাচিত ট্যাবটি সাদা
/// ব্যাকগ্রাউন্ড ও কমলা বর্ডারের একটি পিল আকৃতির বক্সে দেখানো হয়
/// (রেফারেন্স ইমেজ অনুযায়ী), আর প্রতিটি ট্যাবের পাশে বন্ধনীতে সংশ্লিষ্ট
/// তালিকায় মোট কতগুলো আইটেম আছে তা বাংলা সংখ্যায় দেখানো হয়।
class TabSelectorWidget extends StatelessWidget {
  const TabSelectorWidget({
    super.key,
    required this.title,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color _selectedBackground = Colors.white;
  static const Color _selectedBorderAndText = Color(0xFFB5792B);
  static const Color _unselectedText = Color(0xFFF3E4D0);

  @override
  Widget build(BuildContext context) {
    final String label = '$title (${toBengaliDigits(count)})';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? _selectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(30.0),
          border: isSelected
              ? Border.all(color: _selectedBorderAndText, width: 1.4)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _selectedBorderAndText : _unselectedText,
            fontFamily: 'TiroBangla-Regular',
            fontSize: isSelected ? 16.0 : 14.0,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
