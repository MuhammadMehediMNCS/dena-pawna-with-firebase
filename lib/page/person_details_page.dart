import 'package:dena_pawna/controller/person_controller.dart';
import 'package:dena_pawna/controller/theme_controller.dart';
import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:dena_pawna/main.dart';
import 'package:dena_pawna/widget/person_actions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonDetailsPage extends StatelessWidget {
  final Map<String, dynamic> person;
  final PersonController controller;

  const PersonDetailsPage({
    super.key,
    required this.person,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = person['image'];
    final themeController = Get.find<ThemeController>();
    final actions = PersonActions(person: person, controller: controller);

    return Obx(() {
      final colors = themeController.colors;

      return Scaffold(
        backgroundColor: colors.pageBackground,
        appBar: AppBar(
          backgroundColor: colors.headerColor,
          elevation: 0,
          title: Text(
            'পূর্ণাঙ্গ তথ্য',
            style: TextStyle(
              color: colors.headerTextColor,
              fontFamily: 'TiroBangla-Regular',
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.headerTextColor),
            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // টপ প্রোফাইল হেডার সেকশন
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: colors.headerColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: colors.cardBackground,
                          backgroundImage:
                              (imageUrl != null && imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
                          child: (imageUrl == null || imageUrl.isEmpty)
                              ? Icon(Icons.person, color: colors.accent, size: 40)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${person['name']}",
                      style: const TextStyle(
                        fontFamily: 'TiroBangla-Regular',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'প্রয়োজনীয় তথ্যের বিবরণী',
                      style: TextStyle(
                        fontFamily: 'TiroBangla-Regular',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              
              // গ্রিড ইনফরমেশন কার্ডস
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            icon: Icons.person,
                            iconBgColor: const Color(0xFF1E88E5),
                            title: 'বাবার নাম:',
                            value: "${person['father']}",
                            colors: colors,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InfoCard(
                            icon: Icons.calendar_today_rounded,
                            iconBgColor: const Color(0xFFFB8C00),
                            title: 'গ্রহণের তারিখ:',
                            value: "${person['date']}",
                            colors: colors,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            icon: Icons.location_on,
                            iconBgColor: const Color(0xFF00ACC1),
                            title: 'ঠিকানা:',
                            value: "${person['address']}",
                            colors: colors,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InfoCard(
                            icon: Icons.call,
                            iconBgColor: const Color(0xFF43A047),
                            title: 'মোবাইল নাম্বার:',
                            value: '+88${person['mobile']}',
                            colors: colors,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            icon: Icons.currency_rupee,
                            iconBgColor: const Color(0xFFE53935),
                            title: 'মোট টাকা:',
                            value: "${person['total']}",
                            colors: colors,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InfoCard(
                            icon: Icons.stars,
                            iconBgColor: const Color(0xFF8E24AA),
                            title: 'মেম্বারশিপ টাইপ:',
                            value: 'সাধারণ সদস্য (General)',
                            colors: colors,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.sizeOf(context).height *.12),
              // লিস্টভিউয়ের মতোই গ্রহণ/জমা/এডিট/ডিলিট বাটনগুলো — এখান
              // থেকেও হুবহু একই কাজ করা যায়। ডিলিট করলে এই পেজটি বন্ধ
              // হয়ে যাবে, কারণ ব্যক্তিটি আর নেই।
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.cardBorder),
                  ),
                  child: PersonActionBar(
                    actions: actions,
                    colors: colors,
                    onDeleted: () => Get.back(),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    });
  }
}

/// প্রতিটি তথ্যের কার্ড — আইকনের নিজস্ব রঙ (iconBgColor) তিনটি থিমেই
/// অপরিবর্তিত থাকে, শুধু কার্ডের ব্যাকগ্রাউন্ড ও টেক্সট রঙ বর্তমান থিম
/// ([colors]) অনুযায়ী বদলায়।
class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String value;
  final AppColors colors;

  const InfoCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconBgColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconBgColor,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'TiroBangla-Regular',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'TiroBangla-Regular',
                    fontSize: 12,
                    color: colors.textSecondary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
