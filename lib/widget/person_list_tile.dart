import 'dart:io';

import 'package:dena_pawna/widget/circle_image_picker.dart';
import 'package:flutter/material.dart';

/// পাওনাদার ও দেনাদার — দুই তালিকার জন্যই একই লিস্টভিউ ডিজাইন এই একটি
/// শেয়ার্ড উইজেট দিয়ে তৈরি হয়, যাতে দুই ট্যাবের UI সবসময় সিঙ্কে থাকে।
class PersonListTile extends StatelessWidget {
  const PersonListTile({
    super.key,
    required this.person,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onReceiveHistory,
    required this.onDepositHistory,
    required this.onImagePicked,
    this.primaryColor = const Color(0xE3945526),
    this.secondaryColor = const Color(0xADCD852F),
  });

  final Map<String, dynamic> person;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReceiveHistory;
  final VoidCallback onDepositHistory;
  final ValueChanged<File> onImagePicked;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(12),
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
                    borderColor: primaryColor,
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
                            color: primaryColor,
                            fontFamily: 'TiroBangla-Regular',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${person['father'] ?? ''}, ${person['address'] ?? ''}',
                          style: TextStyle(
                            color: secondaryColor,
                            fontFamily: 'TiroBangla-Regular',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${person['total']} ৳',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
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
                          style: TextStyle(color: primaryColor, fontFamily: 'TiroBangla-Regular'),
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
                          style: TextStyle(color: primaryColor, fontFamily: 'TiroBangla-Regular'),
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
                        highlightColor: secondaryColor,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_rounded),
                        color: Colors.red,
                        highlightColor: secondaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Divider(color: const Color(0xFFB5792B)),
        ),
      ],
    );
  }
}
