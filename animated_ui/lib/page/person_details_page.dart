import 'package:animated_ui/core/theme/app_colors.dart';
import 'package:animated_ui/providers/person_providers.dart';
import 'package:animated_ui/providers/theme_provider.dart';
import 'package:animated_ui/widget/person_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// পূর্ণাঙ্গ তথ্য পেজ — লিস্টভিউ থেকে ট্যাপ করলে অথবা সার্চ-ফলাফল থেকে,
/// দুই জায়গা থেকেই এই একই পেজে আসা হয়। [provider] দিয়ে বলা থাকে এই
/// ব্যক্তি creditor নাকি debtor তালিকার, যাতে PersonActionBar-এর
/// গ্রহণ/জমা/এডিট/ডিলিট বাটনগুলো ঠিক লিস্টভিউয়ের সোয়াইপ-অ্যাকশনের মতোই
/// আচরণ করে।
class PersonDetailsPage extends ConsumerWidget {
  const PersonDetailsPage({super.key, required this.person, required this.provider});

  final Map<String, dynamic> person;
  final PersonProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);
    final String? imageUrl = person['image'];
    final actions = PersonActions(context: context, ref: ref, provider: provider, person: person);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors.headerGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: colors.headerOnColor),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Text(
                            'পূর্ণাঙ্গ তথ্য',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.headerOnColor,
                              fontFamily: 'TiroBangla-Regular',
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            (imageUrl != null && imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
                        child: (imageUrl == null || imageUrl.isEmpty)
                            ? Icon(Icons.person, color: colors.accentColor, size: 40)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${person['name'] ?? ''}',
                      style: TextStyle(
                        fontFamily: 'TiroBangla-Regular',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.headerOnColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'প্রয়োজনীয় তথ্যের বিবরণী',
                      style: TextStyle(
                        fontFamily: 'TiroBangla-Regular',
                        fontSize: 14,
                        color: colors.headerOnColor.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.person,
                          iconBgColor: const Color(0xFF1E88E5),
                          title: 'বাবার নাম:',
                          value: '${person['father'] ?? ''}',
                          colors: colors,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.calendar_today_rounded,
                          iconBgColor: const Color(0xFFFB8C00),
                          title: 'তারিখ:',
                          value: '${person['date'] ?? ''}',
                          colors: colors,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.location_on,
                          iconBgColor: const Color(0xFF00ACC1),
                          title: 'ঠিকানা:',
                          value: '${person['address'] ?? ''}',
                          colors: colors,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.call,
                          iconBgColor: const Color(0xFF43A047),
                          title: 'মোবাইল নাম্বার:',
                          value: '${person['mobile'] ?? ''}',
                          colors: colors,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.currency_rupee,
                    iconBgColor: const Color(0xFFE53935),
                    title: 'মোট টাকা:',
                    value: '${person['total'] ?? 0} ৳',
                    colors: colors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: PersonActionBar(actions: actions),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.value,
    required this.colors,
  });

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String value;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconBgColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 18, backgroundColor: iconBgColor, child: Icon(icon, color: Colors.white, size: 20)),
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
                    color: colors.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'TiroBangla-Regular',
                    fontSize: 12,
                    color: colors.secondaryText,
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
