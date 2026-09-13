import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/controller/theme_controller.dart';
import 'package:dena_pawna/page/person_details_page.dart';
import 'package:dena_pawna/page/person_history_page.dart';
import 'package:dena_pawna/screen/person_form_screen.dart';
import 'package:dena_pawna/widget/person_list_tile.dart';
import 'package:dena_pawna/widget/shimmer_widget.dart';
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
          if (controller.personList.isEmpty) {
            return _buildShimmer();
          }
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(12, widget.topPadding + 12, 12, 12),
            itemCount: controller.personList.length,
            itemBuilder: (context, index) {
              final creditor = controller.personList[index];
              final String id = creditor['id'];

              return PersonListTile(
                person: creditor,
                colors: colors,
                amountColor: amountColor,
                onTap: () => Get.to(() => PersonDetailsPage(person: creditor)),
                onEdit: () => Get.to(() => PersonFormScreen(
                      controller: controller,
                      appBarTitle: 'তথ্য এডিট করুন',
                      person: creditor,
                    )),
                onDelete: () => controller.deletePerson(id),
                onReceiveHistory: () => Get.to(() => PersonHistoryPage(
                      personId: id,
                      controller: controller,
                      historyType: HistoryType.receive,
                    )),
                onDepositHistory: () => Get.to(() => PersonHistoryPage(
                      personId: id,
                      controller: controller,
                      historyType: HistoryType.deposit,
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

  Widget _buildShimmer() => Padding(
        padding: EdgeInsets.fromLTRB(12, widget.topPadding + 12, 12, 12),
        child: Column(
          children: List.generate(
            4,
            (_) => Card(
              shape: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black26, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: ShimmerWidget.rectangular(height: 22),
                subtitle: ShimmerWidget.rectangular(height: 8),
                trailing: ShimmerWidget.circular(width: 24, height: 24),
              ),
            ),
          ),
        ),
      );
}
