import 'package:dena_pawna/controller/debtor_controller.dart';
import 'package:dena_pawna/controller/theme_controller.dart';
import 'package:dena_pawna/page/person_details_page.dart';
import 'package:dena_pawna/screen/person_form_screen.dart';
import 'package:dena_pawna/widget/person_list_states.dart';
import 'package:dena_pawna/widget/person_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtorPage extends StatefulWidget {
  final double topPadding;

  const DebtorPage({super.key, this.topPadding = 0});

  @override
  State<DebtorPage> createState() => _DebtorPageState();
}

class _DebtorPageState extends State<DebtorPage> {
  final controller = Get.find<DebtorController>();
  final themeController = Get.find<ThemeController>();

  // 'দিবো' ট্যাবে টাকার অংক সবসময় লাল — এটি থিম-নিরপেক্ষ অর্থবহ রঙ।
  static const Color amountColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final colors = themeController.colors;

      return Scaffold(
        backgroundColor: colors.pageBackground,
        body: Obx(() {
          // ১. এখনো ডাটা আসছে → শিমার
          if (controller.isLoading.value) {
            return PersonListShimmer(colors: colors, topPadding: widget.topPadding);
          }

          // ২. লোডিং শেষ, কিন্তু তালিকা ফাঁকা → বার্তা
          if (controller.personList.isEmpty) {
            return PersonListEmptyView(
              colors: colors,
              topPadding: widget.topPadding,
              message: 'এখনো কোনো দেনাদার যোগ করা হয়নি',
              hint: 'যাদের টাকা দিতে হবে তাদের তথ্য যোগ করতে\nনিচের + বাটনে চাপ দিন',
            );
          }

          // ৩. ডাটা আছে → তালিকা
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(12, widget.topPadding + 12, 12, 12),
            itemCount: controller.personList.length,
            itemBuilder: (context, index) {
              final debtor = controller.personList[index];
              final String id = debtor['id'];

              return PersonListTile(
                person: debtor,
                controller: controller,
                colors: colors,
                amountColor: amountColor,
                onTap: () => Get.to(() => PersonDetailsPage(
                      person: debtor,
                      controller: controller,
                    )),
                onImagePicked: (file) => controller.updatePersonImage(id, file),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => PersonFormScreen(
                controller: controller,
                appBarTitle: 'নতুন দেনাদারের তথ্য',
              )),
          shape: const CircleBorder(),
          backgroundColor: colors.fabBackground,
          child: Icon(Icons.add, color: colors.fabIcon),
        ),
      );
    });
  }
}
