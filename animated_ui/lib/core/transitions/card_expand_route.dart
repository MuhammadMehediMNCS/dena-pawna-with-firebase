import 'package:flutter/material.dart';

/// "ListView Click" রেফারেন্স GIF অনুযায়ী — লিস্টের লিডিং ছবিটি Hero
/// অ্যানিমেশনের মাধ্যমে বড় হয়ে পেজের উপরের মাঝখানে উড়ে যায়; পপ করলে
/// ঠিক উল্টো দিকে ছোট হয়ে লিস্টের সাবেক জায়গায় ফিরে যায় — এটি Hero
/// উইজেট নিজে থেকেই করে (দুই পাশে একই ট্যাগ থাকলেই যথেষ্ট), এই রুটে
/// আলাদা করে কিছু করতে হয় না।
///
/// ছবি বাদে পেজের বাকি অংশ (নাম, তথ্য-কার্ড, অ্যাকশন বার) পুরো পেজকে
/// একটি [FadeTransition]-এ মুড়িয়ে অদৃশ্য থেকে ধীরে ধীরে দৃশ্যমান করা
/// হয়েছে। Hero ফ্লাইট Navigator-এর নিজস্ব Overlay-তে আলাদাভাবে আঁকা হয়
/// বলে এই ফেড তার উপর প্রভাব ফেলে না — ছবিটি উড়ে আসার পুরো সময় সবসময়
/// সম্পূর্ণ দৃশ্যমান থাকে, শুধু বাকি ডিজাইনটাই ধীরে ধীরে ফুটে ওঠে।
class CardExpandRoute<T> extends PageRouteBuilder<T> {
  CardExpandRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 340),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              // ছবি উড়তে শুরু করার কিছুক্ষণ পর থেকে বাকি ডিজাইন ফুটে
              // ওঠা শুরু হয় (Interval দিয়ে সামান্য বিলম্ব)।
              curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
              reverseCurve: const Interval(0.0, 0.85, curve: Curves.easeIn),
            );
            return FadeTransition(opacity: curved, child: child);
          },
        );

  final Widget page;
}
