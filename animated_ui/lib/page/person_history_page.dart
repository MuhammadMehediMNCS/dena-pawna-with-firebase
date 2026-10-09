import 'package:animated_ui/core/theme/app_colors.dart';
import 'package:animated_ui/providers/person_providers.dart';
import 'package:animated_ui/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `receive_history` ও `diposit_history` — দুটো আলাদা সাব-কালেকশন,
/// তাই এই পেজে কোনটা দেখাতে হবে তা এই এনাম দিয়ে বলে দেওয়া হয়।
enum HistoryType { receive, deposit }

class PersonHistoryPage extends ConsumerStatefulWidget {
  const PersonHistoryPage({
    super.key,
    required this.personId,
    required this.provider,
    required this.historyType,
  });

  final String personId;
  final PersonProvider provider;
  final HistoryType historyType;

  @override
  ConsumerState<PersonHistoryPage> createState() => _PersonHistoryPageState();
}

class _PersonHistoryPageState extends ConsumerState<PersonHistoryPage> {
  @override
  void initState() {
    super.initState();

    // উইজেট ইনিশিয়ালাইজ হওয়ার পর ডাটা ফেচ করা হয়।
    Future.microtask(() {
      final notifier = ref.read(widget.provider.notifier);
      if (widget.historyType == HistoryType.receive) {
        notifier.fetchReceiveHistoryForPerson(widget.personId);
      } else {
        notifier.fetchDepositHistoryForPerson(widget.personId);
      }
    });
  }

  String get _pageTitle => widget.historyType == HistoryType.receive ? 'গ্রহণের তথ্য' : 'জমার তথ্য';

  String get _amountLabel => widget.historyType == HistoryType.receive ? 'গ্রহণের পরিমাণ' : 'জমার পরিমাণ';

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final state = ref.watch(widget.provider);

    // এই অংশের হেডার-কালার ইচ্ছাকৃতভাবে থিম-নিরপেক্ষ (সিমান্টিক) —
    // গ্রহণ সবসময় টিল, জমা সবসময় নীল, থিম যাই হোক না কেন।
    final bool isReceive = widget.historyType == HistoryType.receive;
    final Color primaryThemeColor = isReceive ? AppColors.receiveColor : AppColors.depositColor;

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: primaryThemeColor,
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
      body: Builder(builder: (context) {
        if (state.isHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<Map<String, dynamic>> history = state.historyList;

        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open_rounded, size: 70, color: colors.secondaryText),
                const SizedBox(height: 12),
                Text(
                  'কোনো তথ্য পাওয়া যায় নি',
                  style: TextStyle(
                    fontFamily: 'TiroBangla-Regular',
                    fontSize: 18,
                    color: colors.secondaryText,
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
                color: colors.cardColor,
                borderRadius: BorderRadius.circular(16.0),
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
                      color: primaryThemeColor.withOpacity(0.1),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 20, color: primaryThemeColor),
                          const SizedBox(width: 8),
                          Text(
                            "${item['date'] ?? ''} তারিখের তথ্য",
                            style: TextStyle(
                              color: primaryThemeColor,
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
                            label: 'নাম/প্রতিষ্ঠান',
                            value: item['name']?.toString() ?? '',
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            icon: Icons.family_restroom_rounded,
                            iconColor: const Color(0xFFFB8C00),
                            label: 'পিতা/কেন্দ্র',
                            value: item['father']?.toString() ?? '',
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            icon: Icons.location_on_rounded,
                            iconColor: const Color(0xFFE53935),
                            label: 'ঠিকানা',
                            value: item['address']?.toString() ?? '',
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            icon: Icons.phone_android_rounded,
                            iconColor: const Color(0xFF43A047),
                            label: 'মোবাইল নাম্বার',
                            value: item['mobile']?.toString() ?? '',
                            colors: colors,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Divider(height: 1, color: colors.dividerColor.withOpacity(0.3)),
                          ),

                          // ৩. লেনদেনের সামারি বক্স
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: colors.scaffoldBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: colors.dividerColor.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$_amountLabel :',
                                      style: TextStyle(
                                        fontFamily: 'TiroBangla-Regular',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: colors.primaryText,
                                      ),
                                    ),
                                    Text(
                                      '৳ ${item['amount'] ?? '০'}',
                                      style: TextStyle(
                                        fontFamily: 'TiroBangla-Regular',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primaryThemeColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'এই লেনদেনের পর মোট :',
                                      style: TextStyle(
                                        fontFamily: 'TiroBangla-Regular',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: colors.secondaryText,
                                      ),
                                    ),
                                    Text(
                                      '৳ ${item['totalAfter'] ?? '০'}',
                                      style: TextStyle(
                                        fontFamily: 'TiroBangla-Regular',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primaryText,
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
                color: colors.primaryText,
                height: 1.3,
              ),
              children: [
                TextSpan(
                  text: '$label : ',
                  style: TextStyle(fontWeight: FontWeight.w600, color: colors.secondaryText),
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
