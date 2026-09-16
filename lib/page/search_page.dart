import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/controller/debtor_controller.dart';
import 'package:dena_pawna/controller/person_controller.dart';
import 'package:dena_pawna/controller/theme_controller.dart';
import 'package:dena_pawna/core/theme/app_colors.dart';
import 'package:dena_pawna/page/person_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// একটি সার্চ ফলাফল — ব্যক্তির তথ্যের সাথে সে কোন তালিকার (পাবো নাকি
/// দিবো) তাও ধরে রাখে, কারণ ট্যাপ করলে সঠিক কন্ট্রোলার পাস করতে হয়।
class _SearchResult {
  const _SearchResult({
    required this.person,
    required this.controller,
    required this.isCreditor,
  });

  final Map<String, dynamic> person;
  final PersonController controller;
  final bool isCreditor;
}

/// হোমপেজের অ্যাপবারের সার্চ আইকন থেকে এই পেজে আসা হয়।
/// নাম ও ঠিকানা — দুটোর যেকোনোটিতে মিল পেলেই ফলাফলে দেখাবে, এবং পাবো ও
/// দিবো — দুই তালিকাতেই একসাথে খোঁজা হয়।
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _queryController = TextEditingController();
  final CreditorController _creditorController = Get.find<CreditorController>();
  final DebtorController _debtorController = Get.find<DebtorController>();
  final ThemeController _themeController = Get.find<ThemeController>();

  String _query = '';

  @override
  void initState() {
    super.initState();
    _queryController.addListener(() {
      setState(() => _query = _queryController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  /// নাম অথবা ঠিকানায় লেখা টেক্সট আছে কিনা দেখে। খালি সার্চে কিছুই
  /// দেখানো হয় না (নিচে আলাদা করে হ্যান্ডেল করা)।
  bool _matches(Map<String, dynamic> person) {
    final String name = (person['name'] ?? '').toString().toLowerCase();
    final String address = (person['address'] ?? '').toString().toLowerCase();
    return name.contains(_query) || address.contains(_query);
  }

  List<_SearchResult> get _results {
    if (_query.isEmpty) return const [];

    final List<_SearchResult> results = [];

    for (final person in _creditorController.personList) {
      if (_matches(person)) {
        results.add(_SearchResult(
          person: person,
          controller: _creditorController,
          isCreditor: true,
        ));
      }
    }

    for (final person in _debtorController.personList) {
      if (_matches(person)) {
        results.add(_SearchResult(
          person: person,
          controller: _debtorController,
          isCreditor: false,
        ));
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final colors = _themeController.colors;

      return Scaffold(
        backgroundColor: colors.pageBackground,
        appBar: AppBar(
          backgroundColor: colors.headerColor,
          elevation: 0,
          iconTheme: IconThemeData(color: colors.headerTextColor),
          title: TextField(
            controller: _queryController,
            autofocus: true,
            style: TextStyle(
              color: colors.headerTextColor,
              fontFamily: 'TiroBangla-Regular',
              fontSize: 17,
            ),
            cursorColor: colors.headerTextColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'নাম বা ঠিকানা লিখুন...',
              hintStyle: TextStyle(
                color: colors.headerTextColor.withOpacity(0.7),
                fontFamily: 'TiroBangla-Regular',
                fontSize: 16,
              ),
            ),
          ),
          actions: [
            if (_query.isNotEmpty)
              IconButton(
                icon: Icon(Icons.clear, color: colors.headerTextColor),
                onPressed: () => _queryController.clear(),
              ),
          ],
        ),
        // Obx — তালিকা বদলালে (যেমন সার্চ থেকে কাউকে ডিলিট করে ফিরে
        // আসলে) ফলাফলও সাথে সাথে হালনাগাদ হয়।
        body: Obx(() {
          // কন্ট্রোলারের তালিকা 'পড়া' হচ্ছে যাতে Obx এগুলোর পরিবর্তন
          // শুনতে পায়।
          _creditorController.personList.length;
          _debtorController.personList.length;

          if (_query.isEmpty) {
            return _buildMessage(
              colors: colors,
              icon: Icons.search_rounded,
              title: 'নাম বা ঠিকানা দিয়ে খুঁজুন',
              subtitle: 'পাবো ও দিবো — দুই তালিকাতেই একসাথে খোঁজা হবে',
            );
          }

          final results = _results;

          if (results.isEmpty) {
            return _buildMessage(
              colors: colors,
              icon: Icons.search_off_rounded,
              title: 'কিছুই পাওয়া যায়নি',
              subtitle: 'অন্য কোনো নাম বা ঠিকানা দিয়ে চেষ্টা করুন',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: results.length,
            itemBuilder: (context, index) => _buildResultTile(results[index], colors),
          );
        }),
      );
    });
  }

  Widget _buildResultTile(_SearchResult result, AppColors colors) {
    final person = result.person;
    final String? imageUrl = person['image'];

    // পাবো → সবুজ, দিবো → লাল — তালিকার মতোই একই অর্থবহ রঙ।
    final Color amountColor = result.isCreditor ? Colors.green : Colors.red;
    final String badgeLabel = result.isCreditor ? 'পাবো' : 'দিবো';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.cardBorder),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        onTap: () => Get.to(() => PersonDetailsPage(
              person: person,
              controller: result.controller,
            )),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: colors.accent.withOpacity(0.12),
          backgroundImage:
              (imageUrl != null && imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
          child: (imageUrl == null || imageUrl.isEmpty)
              ? Icon(Icons.person, color: colors.accent)
              : null,
        ),
        title: Text(
          person['name'] ?? '',
          style: TextStyle(
            color: colors.textPrimary,
            fontFamily: 'TiroBangla-Regular',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            '${person['father'] ?? ''}, ${person['address'] ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textSecondary,
              fontFamily: 'TiroBangla-Regular',
            ),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: amountColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badgeLabel,
                style: TextStyle(
                  color: amountColor,
                  fontFamily: 'TiroBangla-Regular',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${person['total']} ৳',
              style: TextStyle(
                color: amountColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage({
    required AppColors colors,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.accent.withOpacity(0.10),
              ),
              child: Icon(icon, size: 52, color: colors.accent),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textPrimary,
                fontFamily: 'TiroBangla-Regular',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
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
