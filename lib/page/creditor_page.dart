import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/controller/theme_controller.dart';
import 'package:dena_pawna/page/person_details_page.dart';
import 'package:dena_pawna/screen/person_form_screen.dart';
import 'package:dena_pawna/widget/person_list_states.dart';
import 'package:dena_pawna/widget/person_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditorPage extends StatefulWidget {
  final double topPadding;

  const CreditorPage({super.key, this.topPadding = 0});

  @override
  State<CreditorPage> createState() => _CreditorPageState();
}

class _CreditorPageState extends State<CreditorPage> {
  final controller = Get.find<CreditorController>();
  final themeController = Get.find<ThemeController>();

  // 'পাবো' ট্যাবে টাকার অংক সবসময় সবুজ — এটি থিম-নিরপেক্ষ অর্থবহ রঙ।
  static const Color amountColor = Colors.green;

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
              message: 'এখনো কোনো পাওনাদার যোগ করা হয়নি',
              hint: 'যাদের কাছে টাকা পাবেন তাদের তথ্য যোগ করতে\nনিচের + বাটনে চাপ দিন',
            );
          }

          // ৩. ডাটা আছে → তালিকা
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(12, widget.topPadding + 12, 12, 12),
            itemCount: controller.personList.length,
            itemBuilder: (context, index) {
              final creditor = controller.personList[index];
              final String id = creditor['id'];

              return PersonListTile(
                person: creditor,
                controller: controller,
                colors: colors,
                amountColor: amountColor,
                onTap: () => Get.to(() => PersonDetailsPage(
                      person: creditor,
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
                appBarTitle: 'নতুন পাওনাদারের তথ্য',
              )),
          shape: const CircleBorder(),
          backgroundColor: colors.fabBackground,
          child: Icon(Icons.add, color: colors.fabIcon),
        ),
      );
    });
  }
}
