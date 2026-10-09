import 'dart:math' as math;
import 'package:flutter/material.dart';

/// "Search" রেফারেন্স GIF-এর আদলে — সার্চ আইকনে ট্যাপ করলে সার্চ পেজটি
/// ঠিক সেই আইকনের অবস্থান থেকে একটি বৃত্তাকার (circular) ক্লিপ ক্রমশ
/// বড় হয়ে পুরো স্ক্রিন ঢেকে ফেলার মতো অ্যানিমেট হয়ে আসে।
///
/// [centerOffset] হলো সার্চ আইকনের স্ক্রিন-পজিশন (একটি GlobalKey দিয়ে
/// মাপা), যেখান থেকে বৃত্তটি ছড়াতে শুরু করবে।
class CircularRevealRoute<T> extends PageRouteBuilder<T> {
  CircularRevealRoute({required this.page, required this.centerOffset})
      : super(
          opaque: false,
          barrierColor: Colors.transparent,
          transitionDuration: const Duration(milliseconds: 480),
          reverseTransitionDuration: const Duration(milliseconds: 360),
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
                  clipper: _CircularRevealClipper(
                    fraction: curved.value,
                    centerOffset: centerOffset,
                  ),
                  child: child,
                );
              },
            );
          },
        );

  final Widget page;
  final Offset centerOffset;
}

class _CircularRevealClipper extends CustomClipper<Path> {
  _CircularRevealClipper({required this.fraction, required this.centerOffset});

  final double fraction;
  final Offset centerOffset;

  @override
  Path getClip(Size size) {
    final double maxRadius = _maxRadiusFor(size, centerOffset);
    final double radius = maxRadius * fraction;

    return Path()
      ..addOval(Rect.fromCircle(center: centerOffset, radius: radius));
  }

  double _maxRadiusFor(Size size, Offset center) {
    final double dx = math.max(center.dx, size.width - center.dx);
    final double dy = math.max(center.dy, size.height - center.dy);
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool shouldReclip(covariant _CircularRevealClipper oldClipper) =>
      oldClipper.fraction != fraction || oldClipper.centerOffset != centerOffset;
}
