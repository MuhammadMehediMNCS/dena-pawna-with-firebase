import 'dart:io';

import 'package:dena_pawna/controller/person_controller.dart';
import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:dena_pawna/widget/circle_image_picker.dart';
import 'package:dena_pawna/widget/person_actions.dart';
import 'package:flutter/material.dart';

/// পাওনাদার ও দেনাদার — দুই তালিকার জন্যই একই লিস্টভিউ ডিজাইন এই একটি
/// শেয়ার্ড উইজেট দিয়ে তৈরি হয়।
///
/// গ্রহণ/জমা/এডিট/ডিলিট — চারটি কাজই এখন [PersonActionBar] থেকে আসে, যা
/// পূর্ণাঙ্গ তথ্য পেজেও ব্যবহৃত হয় — তাই দুই জায়গায় আচরণ সবসময় একই।
class PersonListTile extends StatelessWidget {
  const PersonListTile({
    super.key,
    required this.person,
    required this.controller,
    required this.colors,
    required this.onTap,
    required this.onImagePicked,
    this.amountColor = const Color(0xE3945526),
  });

  final Map<String, dynamic> person;
  final PersonController controller;
  final AppColors colors;
  final VoidCallback onTap;
  final ValueChanged<File> onImagePicked;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    final actions = PersonActions(person: person, controller: controller);

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
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: onTap,
            child: Row(
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
          ),
          const SizedBox(height: 6),
          PersonActionBar(actions: actions, colors: colors),
        ],
      ),
    );
  }
}
