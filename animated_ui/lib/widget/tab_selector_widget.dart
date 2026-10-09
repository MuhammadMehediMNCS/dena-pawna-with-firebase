import 'package:animated_ui/core/utils/bengali_digits.dart';
import 'package:flutter/material.dart';

/// হোমপেজের 'পাবো' / 'দিবো' ট্যাব বাছাইয়ের বাটন। নির্বাচিত ট্যাবটি একটি
/// পিল আকৃতির বক্সে দেখানো হয়, আর প্রতিটি ট্যাবের পাশে বন্ধনীতে সংশ্লিষ্ট
/// তালিকায় মোট কতগুলো আইটেম আছে তা বাংলা সংখ্যায় দেখানো হয়।
///
/// রং এখন কনস্ট্রাক্টর-প্যারামিটার হিসেবে আসে (সক্রিয় থিম থেকে), আগের
/// মতো হার্ডকোড করা না — ডিফল্ট মান লাইট থিমের সাথে মেলে, তাই পুরনো
/// কল-সাইট ভাঙবে না।
class TabSelectorWidget extends StatelessWidget {
  const TabSelectorWidget({
    super.key,
    required this.title,
    required this.count,
    required this.isSelected,
    required this.onTap,
    this.selectedBackground = Colors.white,
    this.selectedText = const Color(0xFFB5792B),
    this.unselectedText = const Color(0xFFF3E4D0),
  });

  final String title;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedBackground;
  final Color selectedText;
  final Color unselectedText;

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
          color: isSelected ? selectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(30.0),
          border: isSelected ? Border.all(color: selectedText, width: 1.4) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? selectedText : unselectedText,
            fontFamily: 'TiroBangla-Regular',
            fontSize: isSelected ? 16.0 : 14.0,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
