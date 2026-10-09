import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.baseColor = const Color(0xFFBDBDBD),
    this.highlightColor = const Color(0xFFE0E0E0),
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
    this.baseColor = const Color(0xFFBDBDBD),
    this.highlightColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        period: const Duration(seconds: 3),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(shape: shapeBorder, color: Colors.grey),
        ),
      );
}
