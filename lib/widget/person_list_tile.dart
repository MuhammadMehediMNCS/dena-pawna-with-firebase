import 'dart:io';

import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:dena_pawna/widget/circle_image_picker.dart';
import 'package:flutter/material.dart';

/// পাওনাদার ও দেনাদার — দুই তালিকার জন্যই একই লিস্টভিউ ডিজাইন এই একটি
/// শেয়ার্ড উইজেট দিয়ে তৈরি হয়, যাতে দুই ট্যাবের UI সবসময় সিঙ্কে থাকে।
///
/// [colors] দিয়ে বর্তমান থিম (ডার্ক/লাইট/কালার) অনুযায়ী কার্ডের
/// ব্যাকগ্রাউন্ড/বর্ডার/টেক্সট রঙ আসে। [amountColor] দিয়ে টাকার অংকের
/// রঙ (পাবো ট্যাবে সবুজ, দিবো ট্যাবে লাল) — এটি থিম-নিরপেক্ষ, সবসময়
/// একই অর্থবহ রঙ বহন করে।
class PersonListTile extends StatelessWidget {
  const PersonListTile({
    super.key,
    required this.person,
    required this.colors,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onReceiveHistory,
    required this.onDepositHistory,
    required this.onImagePicked,
    this.amountColor = const Color(0xE3945526),
  });

  final Map<String, dynamic> person;
  final AppColors colors;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReceiveHistory;
  final VoidCallback onDepositHistory;
  final ValueChanged<File> onImagePicked;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: onTap,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleImagePicker(
                  radius: 28,
                  imageUrl: person['image'],
                  placeholderText: 'ছবি',
                  borderColor: colors.accent,
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
                          color: colors.textPrimary,
                          fontFamily: 'TiroBangla-Regular',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${person['father'] ?? ''}, ${person['address'] ?? ''}',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontFamily: 'TiroBangla-Regular',
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${person['total']} ৳',
                  style: TextStyle(
                    color: amountColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: onReceiveHistory,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: Colors.orange, width: 1),
                        ),
                      ),
                      child: Text(
                        'গ্রহণের তথ্য',
                        style: TextStyle(color: colors.textPrimary, fontFamily: 'TiroBangla-Regular'),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                    TextButton(
                      onPressed: onDepositHistory,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.deepOrange, width: 1),
                        ),
                      ),
                      child: Text(
                        'জমার তথ্য',
                        style: TextStyle(color: colors.textPrimary, fontFamily: 'TiroBangla-Regular'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_square),
                      color: Colors.green,
                      highlightColor: colors.accent.withOpacity(0.2),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_rounded),
                      color: Colors.red,
                      highlightColor: colors.accent.withOpacity(0.2),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
