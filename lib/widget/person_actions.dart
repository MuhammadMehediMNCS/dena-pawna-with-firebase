import 'package:dena_pawna/controller/person_controller.dart';
import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:dena_pawna/page/person_history_page.dart';
import 'package:dena_pawna/screen/person_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// গ্রহণের তথ্য / জমার তথ্য / এডিট / ডিলিট — এই চারটি কাজ লিস্টভিউ ও
/// পূর্ণাঙ্গ তথ্য পেজ — দুই জায়গাতেই হুবহু একইভাবে করা যায়। তাই কাজগুলোর
/// আসল লজিক এখানে এক জায়গায় রাখা হয়েছে, যাতে দুই জায়গায় দুই রকম আচরণ
/// হয়ে না যায়।
class PersonActions {
  const PersonActions({
    required this.person,
    required this.controller,
  });

  final Map<String, dynamic> person;
  final PersonController controller;

  String get _id => person['id'];

  void openReceiveHistory() => Get.to(() => PersonHistoryPage(
        personId: _id,
        controller: controller,
        historyType: HistoryType.receive,
      ));

  void openDepositHistory() => Get.to(() => PersonHistoryPage(
        personId: _id,
        controller: controller,
        historyType: HistoryType.deposit,
      ));

  void openEdit() => Get.to(() => PersonFormScreen(
        controller: controller,
        appBarTitle: 'তথ্য এডিট করুন',
        person: person,
      ));

  /// ডিলিট করার আগে নিশ্চিতকরণ ডায়ালগ দেখায় — ভুল করে ট্যাপ করে ফেললে
  /// যেন সব তথ্য হারিয়ে না যায়। [afterDelete] দিয়ে ডিলিটের পর অতিরিক্ত
  /// কিছু করানো যায় (যেমন পূর্ণাঙ্গ তথ্য পেজ থেকে ডিলিট করলে সেই পেজ
  /// বন্ধ করে দেওয়া, কারণ ঐ ব্যক্তি আর নেই)।
  Future<void> confirmDelete({VoidCallback? afterDelete}) async {
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(
          'নিশ্চিত করুন',
          style: TextStyle(fontFamily: 'TiroBangla-Regular', fontWeight: FontWeight.bold),
        ),
        content: Text(
          '${person['name'] ?? ''} — এর সব তথ্য ও লেনদেনের ইতিহাস মুছে যাবে। আপনি কি নিশ্চিত?',
          style: const TextStyle(fontFamily: 'TiroBangla-Regular'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('না', style: TextStyle(fontFamily: 'TiroBangla-Regular')),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'হ্যাঁ, মুছে ফেলুন',
              style: TextStyle(fontFamily: 'TiroBangla-Regular', color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.deletePerson(_id);
      afterDelete?.call();
    }
  }
}

/// উপরের চারটি কাজের বাটনগুলোর সারি — লিস্টভিউ ও পূর্ণাঙ্গ তথ্য পেজ
/// দুই জায়গাতেই একই চেহারায় ব্যবহৃত হয়।
class PersonActionBar extends StatelessWidget {
  const PersonActionBar({
    super.key,
    required this.actions,
    required this.colors,
    this.onDeleted,
  });

  final PersonActions actions;
  final AppColors colors;

  /// ডিলিট সম্পন্ন হওয়ার পর কী করতে হবে (যেমন পেজ বন্ধ করা)।
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextButton(
                  onPressed: actions.openReceiveHistory,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: const BorderSide(color: Colors.orange, width: 1),
                    ),
                  ),
                  child: Text(
                    'গ্রহণের তথ্য',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.textPrimary, fontFamily: 'TiroBangla-Regular'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextButton(
                  onPressed: actions.openDepositHistory,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Colors.deepOrange, width: 1),
                    ),
                  ),
                  child: Text(
                    'জমার তথ্য',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.textPrimary, fontFamily: 'TiroBangla-Regular'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: actions.openEdit,
              icon: const Icon(Icons.edit_square),
              color: Colors.green,
              highlightColor: colors.accent.withOpacity(0.2),
            ),
            IconButton(
              onPressed: () => actions.confirmDelete(afterDelete: onDeleted),
              icon: const Icon(Icons.delete_rounded),
              color: Colors.red,
              highlightColor: colors.accent.withOpacity(0.2),
            ),
          ],
        ),
      ],
    );
  }
}
