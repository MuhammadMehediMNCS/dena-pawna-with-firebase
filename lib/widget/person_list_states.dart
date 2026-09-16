import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:dena_pawna/widget/shimmer_widget.dart';
import 'package:flutter/material.dart';

/// লিস্ট লোড হওয়ার সময়ের প্লেসহোল্ডার। আগের শিমার ডিজাইনটি পুরনো
/// `Card`+`ListTile` লেআউট অনুসরণ করত, কিন্তু আসল লিস্ট আইটেম এখন
/// [PersonListTile]-এর গোলাকার কার্ড ডিজাইন ব্যবহার করে — তাই শিমারও
/// এখন হুবহু সেই আকৃতি (গোল ছবি + দুই লাইন টেক্সট + দুটি বাটন) অনুকরণ
/// করে, যাতে লোডিং থেকে আসল ডাটায় রূপান্তরটা লাফ না দিয়ে মসৃণ হয়।
class PersonListShimmer extends StatelessWidget {
  const PersonListShimmer({
    super.key,
    required this.colors,
    this.topPadding = 0,
    this.itemCount = 4,
  });

  final AppColors colors;
  final double topPadding;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(12, topPadding + 12, 12, 12),
      itemCount: itemCount,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 14.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: colors.cardBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const ShimmerWidget.circular(width: 56, height: 56),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerWidget.rectangular(height: 16),
                      SizedBox(height: 8),
                      ShimmerWidget.rectangular(height: 10),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 60,
                  child: ShimmerWidget.rectangular(height: 18),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                SizedBox(width: 90, child: ShimmerWidget.rectangular(height: 28)),
                SizedBox(width: 12),
                SizedBox(width: 90, child: ShimmerWidget.rectangular(height: 28)),
                Spacer(),
                ShimmerWidget.circular(width: 24, height: 24),
                SizedBox(width: 10),
                ShimmerWidget.circular(width: 24, height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// লোডিং শেষ হওয়ার পর তালিকা সত্যিই ফাঁকা থাকলে এটি দেখানো হয়।
class PersonListEmptyView extends StatelessWidget {
  const PersonListEmptyView({
    super.key,
    required this.colors,
    required this.message,
    required this.hint,
    this.topPadding = 0,
  });

  final AppColors colors;

  /// প্রধান বার্তা — যেমন 'এখনো কোনো পাওনাদার যোগ করা হয়নি'
  final String message;

  /// ছোট সহায়ক বার্তা — যেমন 'নিচের + বাটনে চাপ দিয়ে শুরু করুন'
  final String hint;

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, topPadding + 12, 24, 12),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.accent.withOpacity(0.10),
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 56,
                color: colors.accent,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textPrimary,
                fontFamily: 'TiroBangla-Regular',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontFamily: 'TiroBangla-Regular',
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
