import 'package:animated_ui/core/theme/app_colors.dart';
import 'package:animated_ui/core/transitions/liquid_page_route.dart';
import 'package:animated_ui/page/person_history_page.dart';
import 'package:animated_ui/providers/person_providers.dart';
import 'package:animated_ui/screen/person_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// লিস্টের সোয়াইপ-রিভিল অ্যাকশন আর পূর্ণাঙ্গ তথ্য পেজের বাটন — দুই জায়গা
/// থেকেই ঠিক একই লজিক কল হয়, যাতে আচরণ কখনো আলাদা না হয়ে যায়।
/// রিভিল-হওয়া সোয়াইপ অ্যাকশন থেকে নেভিগেট করা পেজগুলো (গ্রহণ/জমা/এডিট)
/// এখন "Liquid Swipe" অ্যানিমেশন দিয়ে খোলে; ফিরে আসার (pop) সময় সেই
/// একই অ্যানিমেশনটি Navigator স্বয়ংক্রিয়ভাবে উল্টো দিকে চালায়।
class PersonActions {
  PersonActions({
    required this.context,
    required this.ref,
    required this.provider,
    required this.person,
  });

  final BuildContext context;
  final WidgetRef ref;
  final PersonProvider provider;
  final Map<String, dynamic> person;

  String get _id => person['id'] as String;

  void openReceiveHistory() {
    Navigator.of(context).push(
      LiquidPageRoute(
        page: PersonHistoryPage(
          personId: _id,
          provider: provider,
          historyType: HistoryType.receive,
        ),
      ),
    );
  }

  void openDepositHistory() {
    Navigator.of(context).push(
      LiquidPageRoute(
        page: PersonHistoryPage(
          personId: _id,
          provider: provider,
          historyType: HistoryType.deposit,
        ),
      ),
    );
  }

  void openEdit() {
    Navigator.of(context).push(
      LiquidPageRoute(
        page: PersonFormScreen(
          provider: provider,
          appBarTitle: 'তথ্য এডিট করুন',
          person: person,
        ),
      ),
    );
  }

  Future<void> confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'তথ্য মুছে ফেলবেন?',
          style: TextStyle(fontFamily: 'TiroBangla-Regular'),
        ),
        content: Text(
          '"${person['name'] ?? ''}" এর সমস্ত তথ্য ও লেনদেনের ইতিহাস স্থায়ীভাবে মুছে যাবে। আপনি কি নিশ্চিত?',
          style: const TextStyle(fontFamily: 'TiroBangla-Regular'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('বাতিল', style: TextStyle(fontFamily: 'TiroBangla-Regular')),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'মুছে ফেলুন',
              style: TextStyle(fontFamily: 'TiroBangla-Regular', color: AppColors.deleteColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(provider.notifier).deletePerson(_id);
    }
  }
}

/// পূর্ণাঙ্গ তথ্য পেজে ব্যবহারের জন্য — লিস্টের সোয়াইপ-অ্যাকশনের মতোই
/// রঙিন আইকন-বাটন সারি, কিন্তু সবসময় দৃশ্যমান (এখানে সোয়াইপ-রিভিল নেই)।
class PersonActionBar extends StatelessWidget {
  const PersonActionBar({super.key, required this.actions});

  final PersonActions actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.call_received_rounded,
          label: 'গ্রহণের তথ্য',
          color: AppColors.receiveColor,
          onTap: actions.openReceiveHistory,
        ),
        _ActionButton(
          icon: Icons.call_made_rounded,
          label: 'জমার তথ্য',
          color: AppColors.depositColor,
          onTap: actions.openDepositHistory,
        ),
        _ActionButton(
          icon: Icons.edit_square,
          label: 'এডিট',
          color: AppColors.editColor,
          onTap: actions.openEdit,
        ),
        _ActionButton(
          icon: Icons.delete_rounded,
          label: 'ডিলিট',
          color: AppColors.deleteColor,
          onTap: actions.confirmDelete,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'TiroBangla-Regular',
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
