import 'package:animated_ui/providers/person_providers.dart';
import 'package:animated_ui/widget/person_list_page_body.dart';
import 'package:flutter/material.dart';

class DebtorPage extends StatelessWidget {
  const DebtorPage({super.key, this.topPadding = 0});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return PersonListPageBody(
      provider: debtorProvider,
      topPadding: topPadding,
      emptyMessage: 'এখনো কোনো দেনাদার যোগ করা হয়নি',
      addTitle: 'নতুন দেনাদারের তথ্য',
    );
  }
}
