import 'package:dena_pawna/controller/debtor_controller.dart';
import 'package:dena_pawna/page/person_details_page.dart';
import 'package:dena_pawna/page/person_history_page.dart';
import 'package:dena_pawna/screen/person_form_screen.dart';
import 'package:dena_pawna/widget/person_list_tile.dart';
import 'package:dena_pawna/widget/shimmer_widget.dart';
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

  // দিবো ট্যাবেও পাবো ট্যাবের মতো একই কালার স্কিম, যাতে ডিজাইন সিঙ্কে থাকে।
  static const Color primaryColor = Color(0xE3945526);
  static const Color secondaryColor = Color(0xADCD852F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.personList.isEmpty) {
          return _buildShimmer();
        }
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(12, widget.topPadding + 12, 12, 12),
          itemCount: controller.personList.length,
          itemBuilder: (context, index) {
            final debtor = controller.personList[index];
            final String id = debtor['id'];

            return PersonListTile(
              person: debtor,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
              onTap: () => Get.to(() => PersonDetailsPage(person: debtor)),
              onEdit: () => Get.to(() => PersonFormScreen(
                    controller: controller,
                    appBarTitle: 'তথ্য এডিট করুন',
                    person: debtor,
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
              appBarTitle: 'নতুন দেনাদারের তথ্য',
            )),
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFFB5792B),
        child: const Icon(Icons.add, color: Color(0xFFDFBF9C)),
      ),
    );
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
