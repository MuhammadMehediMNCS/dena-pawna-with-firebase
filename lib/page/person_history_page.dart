import 'package:dena_pawna/controller/person_controller.dart';
import 'package:dena_pawna/controller/theme_controller.dart';
import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// `receive_history` ও `diposit_history` — এখন দুটো আলাদা সাব-কালেকশন,
/// তাই এই পেজে কোনটা দেখাতে হবে তা এই এনাম দিয়ে বলে দেওয়া হয়।
enum HistoryType { receive, deposit }

class PersonHistoryPage extends StatefulWidget {
  const PersonHistoryPage({
    super.key,
    required this.personId,
    required this.controller,
    required this.historyType,
  });

  final String personId;
  final PersonController controller;
  final HistoryType historyType;

  @override
  State<PersonHistoryPage> createState() => _PersonHistoryPageState();
}

class _PersonHistoryPageState extends State<PersonHistoryPage> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();

    // উইজেট ইনিশিয়ালাইজ হওয়ার পর ডাটা ফেচ করা
    if (widget.historyType == HistoryType.receive) {
      widget.controller.fetchReceiveHistoryForPerson(widget.personId);
    } else {
      widget.controller.fetchDepositHistoryForPerson(widget.personId);
    }
  }

  String get _pageTitle =>
      widget.historyType == HistoryType.receive ? 'গ্রহণের তথ্য' : 'জমার তথ্য';

  String get _amountLabel =>
      widget.historyType == HistoryType.receive ? 'গ্রহণের পরিমাণ' : 'জমার পরিমাণ';

  @override
  Widget build(BuildContext context) {
    // গ্রহণ/জমা টাইপের এই accent রঙটি থিম-নিরপেক্ষ — সবুজ/লাল টাকার
    // অংকের মতোই এটিও একটি অর্থবহ (সব সময় একই) রঙ, থিম বদলালেও বদলায় না।
    final bool isReceive = widget.historyType == HistoryType.receive;
    final Color typeAccentColor = isReceive ? const Color(0xFF00897B) : const Color(0xFF1E88E5);

    return Obx(() {
      final colors = themeController.colors;

      return Scaffold(
        backgroundColor: colors.pageBackground,
        appBar: AppBar(
          backgroundColor: typeAccentColor,
          elevation: 0,
          centerTitle: true,
          title: Text(_pageTitle),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'TiroBangla-Regular',
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Obx(() {
          // PersonController ইন্টারফেস থেকে historyList রিড করা হচ্ছে
          final List<Map<String, dynamic>> history = widget.controller.historyList;

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_rounded, size: 70, color: colors.textSecondary),
                  const SizedBox(height: 12),
                  Text(
                    'কোনো তথ্য পাওয়া যায় নি',
                    style: TextStyle(
                      fontFamily: 'TiroBangla-Regular',
                      fontSize: 18,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: colors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ১. তারিখের হেডার
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        color: typeAccentColor.withOpacity(0.14),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_rounded, size: 20, color: typeAccentColor),
                            const SizedBox(width: 8),
                            Text(
                              "${item['date'] ?? ''} তারিখের তথ্য",
                              style: TextStyle(
                                color: typeAccentColor,
                                fontFamily: 'TiroBangla-Regular',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ২. তথ্যের বডি সেকশন
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              icon: Icons.person,
                              iconColor: const Color(0xFF3F51B5),
                              label: "নাম/প্রতিষ্ঠান",
                              value: item['name']?.toString() ?? '',
                              colors: colors,
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                              icon: Icons.family_restroom_rounded,
                              iconColor: const Color(0xFFFB8C00),
                              label: "পিতা/কেন্দ্র",
                              value: item['father']?.toString() ?? '',
                              colors: colors,
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                              icon: Icons.location_on_rounded,
                              iconColor: const Color(0xFFE53935),
                              label: "ঠিকানা",
                              value: item['address']?.toString() ?? '',
                              colors: colors,
                            ),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                              icon: Icons.phone_android_rounded,
                              iconColor: const Color(0xFF43A047),
                              label: "মোবাইল নাম্বার",
                              value: item['mobile']?.toString() ?? '',
                              colors: colors,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Divider(height: 1, color: colors.cardBorder),
                            ),

                            // ৩. লেনদেনের সামারি বক্স
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: typeAccentColor.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: colors.cardBorder),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$_amountLabel :",
                                        style: TextStyle(
                                          fontFamily: 'TiroBangla-Regular',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        "৳ ${item['amount'] ?? '০'}",
                                        style: TextStyle(
                                          fontFamily: 'TiroBangla-Regular',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: typeAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "এই লেনদেনের পর মোট :",
                                        style: TextStyle(
                                          fontFamily: 'TiroBangla-Regular',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        "৳ ${item['totalAfter'] ?? '০'}",
                                        style: TextStyle(
                                          fontFamily: 'TiroBangla-Regular',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      );
    });
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required AppColors colors,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: iconColor.withOpacity(0.12),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'TiroBangla-Regular',
                fontSize: 15.0,
                color: colors.textPrimary,
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: "$label : ",
                  style: TextStyle(fontWeight: FontWeight.w600, color: colors.textSecondary),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
