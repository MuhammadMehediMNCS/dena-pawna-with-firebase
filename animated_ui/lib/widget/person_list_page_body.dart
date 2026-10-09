import 'package:animated_ui/core/transitions/card_expand_route.dart';
import 'package:animated_ui/core/transitions/liquid_page_route.dart';
import 'package:animated_ui/page/person_details_page.dart';
import 'package:animated_ui/providers/person_providers.dart';
import 'package:animated_ui/providers/theme_provider.dart';
import 'package:animated_ui/screen/person_form_screen.dart';
import 'package:animated_ui/widget/person_actions.dart';
import 'package:animated_ui/widget/person_list_states.dart';
import 'package:animated_ui/widget/person_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// পাওনাদার ও দেনাদার ট্যাবের UI হুবহু এক — শুধু কোন Riverpod প্রোভাইডার
/// ব্যবহার হচ্ছে তা আলাদা। তাই দুইটা পেজই (CreditorPage/DebtorPage) এই
/// একটিমাত্র শেয়ার্ড বডি উইজেট ব্যবহার করে, যাতে দুই ট্যাব সবসময় সিঙ্কে
/// থাকে।
class PersonListPageBody extends ConsumerWidget {
  const PersonListPageBody({
    super.key,
    required this.provider,
    required this.topPadding,
    required this.emptyMessage,
    required this.addTitle,
  });

  final PersonProvider provider;
  final double topPadding;
  final String emptyMessage;
  final String addTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final colors = ref.watch(appColorsProvider);

    Widget body;
    if (state.isLoading) {
      body = PersonListShimmer(colors: colors, topPadding: topPadding);
    } else if (state.personList.isEmpty) {
      body = Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: PersonListEmptyView(colors: colors, message: emptyMessage),
      );
    } else {
      body = ListView.builder(
        padding: EdgeInsets.fromLTRB(12, topPadding + 12, 12, 12),
        itemCount: state.personList.length,
        itemBuilder: (context, index) {
          final person = state.personList[index];
          final String id = person['id'];
          final actions = PersonActions(
            context: context,
            ref: ref,
            provider: provider,
            person: person,
          );

          return PersonListTile(
            id: id,
            person: person,
            colors: colors,
            onTap: () => Navigator.of(context).push(
              CardExpandRoute(
                page: PersonDetailsPage(person: person, provider: provider),
              ),
            ),
            onEdit: actions.openEdit,
            onDelete: actions.confirmDelete,
            onReceiveHistory: actions.openReceiveHistory,
            onDepositHistory: actions.openDepositHistory,
            onImagePicked: (file) => ref.read(provider.notifier).updatePersonImage(id, file),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          LiquidPageRoute(
            page: PersonFormScreen(provider: provider, appBarTitle: addTitle),
          ),
        ),
        shape: const CircleBorder(),
        backgroundColor: colors.fabColor,
        child: Icon(Icons.add, color: colors.fabOnColor),
      ),
    );
  }
}
