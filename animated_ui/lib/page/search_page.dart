import 'package:animated_ui/core/transitions/card_expand_route.dart';
import 'package:animated_ui/page/person_details_page.dart';
import 'package:animated_ui/providers/person_providers.dart';
import 'package:animated_ui/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// নাম ও ঠিকানা দিয়ে পাওনাদার-দেনাদার উভয় তালিকায় খোঁজার পেজ। একটি
/// ফলাফলে ট্যাপ করলে পূর্ণাঙ্গ তথ্য পেজে যাওয়া হয় — সেখানে ঠিক
/// লিস্টভিউয়ের মতোই গ্রহণ/জমা/এডিট/ডিলিট বাটন পাওয়া যায়, কারণ উভয়
/// জায়গাতেই একই [PersonDetailsPage] ব্যবহার হয়।
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  List<_SearchResult> _filter(List<Map<String, dynamic>> list, PersonProvider provider) {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];

    return list
        .where((person) {
          final String name = (person['name'] ?? '').toString().toLowerCase();
          final String address = (person['address'] ?? '').toString().toLowerCase();
          return name.contains(q) || address.contains(q);
        })
        .map((person) => _SearchResult(person: person, provider: provider))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ref.watch(appColorsProvider);
    final creditorState = ref.watch(creditorProvider);
    final debtorState = ref.watch(debtorProvider);

    final results = <_SearchResult>[
      ..._filter(creditorState.personList, creditorProvider),
      ..._filter(debtorState.personList, debtorProvider),
    ];

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: colors.headerColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.headerOnColor),
        title: Text(
          'খুঁজুন',
          style: TextStyle(
            fontFamily: 'TiroBangla-Regular',
            color: colors.headerOnColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: TextField(
              controller: _queryController,
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
              style: TextStyle(color: colors.primaryText, fontFamily: 'TiroBangla-Regular'),
              decoration: InputDecoration(
                hintText: 'নাম অথবা ঠিকানা লিখুন...',
                hintStyle: TextStyle(color: colors.secondaryText, fontFamily: 'TiroBangla-Regular'),
                prefixIcon: Icon(Icons.search, color: colors.accentColor),
                filled: true,
                fillColor: colors.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? Center(
                    child: Text(
                      'নাম বা ঠিকানা দিয়ে খুঁজুন',
                      style: TextStyle(fontFamily: 'TiroBangla-Regular', color: colors.secondaryText),
                    ),
                  )
                : results.isEmpty
                    ? Center(
                        child: Text(
                          'কোনো ফলাফল পাওয়া যায়নি',
                          style: TextStyle(fontFamily: 'TiroBangla-Regular', color: colors.secondaryText),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results[index];
                          final person = result.person;
                          final String? imageUrl = person['image'];

                          return Card(
                            color: colors.cardColor,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: colors.accentColor.withOpacity(0.15),
                                backgroundImage:
                                    (imageUrl != null && imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
                                child: (imageUrl == null || imageUrl.isEmpty)
                                    ? Icon(Icons.person, color: colors.accentColor)
                                    : null,
                              ),
                              title: Text(
                                person['name'] ?? '',
                                style: TextStyle(fontFamily: 'TiroBangla-Regular', color: colors.primaryText),
                              ),
                              subtitle: Text(
                                person['address'] ?? '',
                                style: TextStyle(fontFamily: 'TiroBangla-Regular', color: colors.secondaryText),
                              ),
                              onTap: () => Navigator.of(context).push(
                                CardExpandRoute(
                                  page: PersonDetailsPage(person: person, provider: result.provider),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _SearchResult {
  _SearchResult({required this.person, required this.provider});

  final Map<String, dynamic> person;
  final PersonProvider provider;
}
