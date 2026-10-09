import 'package:flutter/material.dart';

/// "Liquid Swipe" রেফারেন্স GIF-এর আদলে একটি হাতে-তৈরি পেজ ট্রানজিশন।
///
/// নতুন পেজটি একটি ঢেউ-আকৃতির (wavy) সীমানা দিয়ে পুরনো পেজের উপর
/// বাম থেকে ডানে ছড়িয়ে পড়ে ঢুকে আসে। `pop()` করলে Navigator স্বয়ংক্রিয়ভাবে
/// এই একই অ্যানিমেশনটি উল্টো দিকে চালায় (reverse animation), তাই আলাদা
/// করে "ফিরে যাওয়ার" অ্যানিমেশন লেখার দরকার হয় না — এটি "ফ্রি"-তেই আসে।
///
/// pub.dev-এর `liquid_swipe` প্যাকেজটি মূলত অনবোর্ডিং কারুসেলের জন্য
/// বানানো (পাতার মধ্যে swipe gesture-ভিত্তিক), স্বাভাবিক Navigator পুশের
/// জন্য উপযুক্ত নয় — তাই এখানে CustomClipper দিয়ে কাছাকাছি একটি ভিজুয়াল
/// এফেক্ট হাতে বানানো হয়েছে।
class LiquidPageRoute<T> extends PageRouteBuilder<T> {
  LiquidPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 520),
          reverseTransitionDuration: const Duration(milliseconds: 420),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return AnimatedBuilder(
              animation: curved,
              child: child,
              builder: (context, child) {
                return ClipPath(
                  clipper: _LiquidWaveClipper(progress: curved.value),
                  child: child,
                );
              },
            );
          },
        );

  final Widget page;
}

class _LiquidWaveClipper extends CustomClipper<Path> {
  _LiquidWaveClipper({required this.progress});

  /// ০.০ (সম্পূর্ণ লুকানো) থেকে ১.০ (সম্পূর্ণ দেখানো) পর্যন্ত।
  final double progress;

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    // তরঙ্গের "মাথা"-র অবস্থান — বাম থেকে ডানে অ্যানিমেট হয়, সাথে
    // সামান্য বাড়তি দূরত্ব যোগ করে ঢেউয়ের বাঁকটা পুরোপুরি স্ক্রিনের
    // বাইরে চলে যায় শেষ ফ্রেমে।
    final double headX = (w + w * 0.28) * progress - w * 0.14;
    final double waveAmplitude = w * 0.14 * (1 - progress) + 6.0;

    final path = Path()..moveTo(0, 0);

    path.lineTo(headX - waveAmplitude, 0);

    // উপরের বাঁক
    path.quadraticBezierTo(
      headX + waveAmplitude,
      h * 0.22,
      headX - waveAmplitude * 0.4,
      h * 0.5,
    );

    // নিচের বাঁক (S-শেপ ঢেউ তৈরি করতে)
    path.quadraticBezierTo(
      headX - waveAmplitude * 1.6,
      h * 0.78,
      headX - waveAmplitude,
      h,
    );

    path.lineTo(0, h);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant _LiquidWaveClipper oldClipper) =>
      oldClipper.progress != progress;
}
