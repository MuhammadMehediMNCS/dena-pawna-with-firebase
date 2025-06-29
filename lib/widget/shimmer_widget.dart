import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey[400]!,
    highlightColor: Colors.grey[300]!,
    period: const Duration(seconds: 3),
    child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: shapeBorder,
        color: Colors.grey,
      ),
    ),
  );
}