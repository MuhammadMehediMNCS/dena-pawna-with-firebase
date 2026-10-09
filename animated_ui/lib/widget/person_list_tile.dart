import 'dart:io';

import 'package:animated_ui/core/theme/app_colors.dart';
import 'package:animated_ui/widget/circle_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// পাওনাদার ও দেনাদার — দুই তালিকার জন্যই একই লিস্টভিউ ডিজাইন এই একটি
/// শেয়ার্ড উইজেট দিয়ে তৈরি হয়, যাতে দুই ট্যাবের UI সবসময় সিঙ্কে থাকে।
///
/// "ListView Animation" রেফারেন্স অনুযায়ী — গ্রহণের তথ্য/জমার তথ্য/এডিট/
/// ডিলিট অ্যাকশনগুলো ডিফল্টভাবে অদৃশ্য থাকে; তালিকার আইটেমটি ডানদিক
/// থেকে বামে সোয়াইপ করলে flutter_slidable দিয়ে রঙিন বৃত্তাকার
/// আইকন-বাটনগুলো প্রকাশিত (reveal) হয়।
class PersonListTile extends StatelessWidget {
  const PersonListTile({
    super.key,
    required this.id,
    required this.person,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onReceiveHistory,
    required this.onDepositHistory,
    required this.onImagePicked,
    required this.colors,
  });

  final String id;
  final Map<String, dynamic> person;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReceiveHistory;
  final VoidCallback onDepositHistory;
  final ValueChanged<File> onImagePicked;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.68,
        children: [
          SlidableAction(
            onPressed: (_) => onReceiveHistory(),
            backgroundColor: AppColors.receiveColor,
            foregroundColor: Colors.white,
            icon: Icons.call_received_rounded,
            label: 'গ্রহণ',
            borderRadius: BorderRadius.circular(12),
            spacing: 2,
          ),
          SlidableAction(
            onPressed: (_) => onDepositHistory(),
            backgroundColor: AppColors.depositColor,
            foregroundColor: Colors.white,
            icon: Icons.call_made_rounded,
            label: 'জমা',
            borderRadius: BorderRadius.circular(12),
            spacing: 2,
          ),
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: AppColors.editColor,
            foregroundColor: Colors.white,
            icon: Icons.edit_square,
            label: 'এডিট',
            borderRadius: BorderRadius.circular(12),
            spacing: 2,
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: AppColors.deleteColor,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'ডিলিট',
            borderRadius: BorderRadius.circular(12),
            spacing: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              color: colors.cardColor,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleImagePicker(
                    radius: 28,
                    imageUrl: person['image'],
                    placeholderText: 'ছবি',
                    borderColor: colors.primaryText,
                    onImagePicked: onImagePicked,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          person['name'] ?? '',
                          style: TextStyle(
                            color: colors.primaryText,
                            fontFamily: 'TiroBangla-Regular',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${person['father'] ?? ''}, ${person['address'] ?? ''}',
                          style: TextStyle(
                            color: colors.secondaryText,
                            fontFamily: 'TiroBangla-Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${person['total']} ৳',
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(Icons.swipe_left_alt_rounded, size: 18, color: colors.secondaryText),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Divider(color: colors.dividerColor),
          ),
        ],
      ),
    );
  }
}
