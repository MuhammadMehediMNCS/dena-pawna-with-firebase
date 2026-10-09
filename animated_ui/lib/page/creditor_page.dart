import 'package:animated_ui/providers/person_providers.dart';
import 'package:animated_ui/widget/person_list_page_body.dart';
import 'package:flutter/material.dart';

class CreditorPage extends StatelessWidget {
  const CreditorPage({super.key, this.topPadding = 0});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return PersonListPageBody(
      provider: creditorProvider,
      topPadding: topPadding,
      emptyMessage: 'এখনো কোনো পাওনাদার যোগ করা হয়নি',
      addTitle: 'নতুন পাওনাদারের তথ্য',
    );
  }
}
