import 'package:flutter/material.dart';

/// "ListView Click" রেফারেন্স GIF-এর আদলে — লিস্টের কোনো আইটেমে ট্যাপ
/// করলে পূর্ণাঙ্গ তথ্য পেজটি যেন একটি কার্ড হালকা স্কেল-আপ ও ফেড হয়ে
/// পর্দাজুড়ে প্রসারিত (expand) হয়ে আসছে — এমন অনুভূতি দেয়।
///
/// সত্যিকারের element-to-element Hero flight এখানে ব্যবহার না করার কারণ:
/// লিস্টের টাইল এখন সোয়াইপ-রিভিল ফিচারের (flutter_slidable) ভেতরে থাকে,
/// যেখানে Hero ট্যাগ মেলানো জটিল/ভঙ্গুর হয়ে যায়। তাই এর বদলে
/// scale + fade ব্যবহার করে কাছাকাছি ভিজুয়াল এফেক্ট তৈরি করা হয়েছে।
class CardExpandRoute<T> extends PageRouteBuilder<T> {
  CardExpandRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 380),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.88, end: 1.0).animate(curved),
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
        );

  final Widget page;
}
