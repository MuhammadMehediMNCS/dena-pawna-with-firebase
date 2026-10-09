import 'package:animated_ui/core/theme/app_colors.dart';
import 'package:animated_ui/widget/shimmer_widget.dart';
import 'package:flutter/material.dart';

/// isLoading == true থাকা অবস্থায় দেখানো শিমার — বর্তমান কার্ড-ভিত্তিক
/// লিস্ট ডিজাইনের (অ্যাভাটার বৃত্ত, দুই লাইন টেক্সট, আইকন-বৃত্ত) সাথে
/// মিলিয়ে বানানো, পুরনো জেনেরিক প্লেসহোল্ডার নয়।
class PersonListShimmer extends StatelessWidget {
  const PersonListShimmer({super.key, required this.colors, this.topPadding = 0});

  final AppColors colors;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(12, topPadding + 12, 12, 12),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            ShimmerWidget.circular(
              width: 56,
              height: 56,
              baseColor: colors.shimmerBase,
              highlightColor: colors.shimmerHighlight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(
                    height: 16,
                    width: 140,
                    baseColor: colors.shimmerBase,
                    highlightColor: colors.shimmerHighlight,
                  ),
                  const SizedBox(height: 8),
                  ShimmerWidget.rectangular(
                    height: 12,
                    width: 200,
                    baseColor: colors.shimmerBase,
                    highlightColor: colors.shimmerHighlight,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ShimmerWidget.rectangular(
              height: 22,
              width: 48,
              baseColor: colors.shimmerBase,
              highlightColor: colors.shimmerHighlight,
            ),
          ],
        ),
      ),
    );
  }
}

/// isLoading == false এবং তালিকা আসলেই খালি হলে (ডাটাবেজে ০টি এন্ট্রি)
/// এই এম্পটি-স্টেট দেখানো হয় — শিমার নয়, কারণ শিমার শুধু "লোড হচ্ছে"
/// বোঝাতে ব্যবহৃত হওয়া উচিত।
class PersonListEmptyView extends StatelessWidget {
  const PersonListEmptyView({super.key, required this.colors, this.message = 'কোনো তথ্য পাওয়া যায়নি'});

  final AppColors colors;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 72, color: colors.secondaryText),
          const SizedBox(height: 14),
          Text(
            message,
            style: TextStyle(
              fontFamily: 'TiroBangla-Regular',
              fontSize: 17,
              color: colors.secondaryText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
