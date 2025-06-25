import 'package:dena_pawna/controller/debtor_controller.dart';
import 'package:dena_pawna/page/debtor_details_page.dart';
import 'package:dena_pawna/screen/add_debtor_info_screen.dart';
import 'package:dena_pawna/screen/edit_debtor_info_screen.dart';
import 'package:dena_pawna/widget/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtorPage extends StatefulWidget {
  const DebtorPage({super.key});

  @override
  State<DebtorPage> createState() => _DebtorPageState();
}

class _DebtorPageState extends State<DebtorPage> {
  final controller = Get.find<DebtorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.debtorList.isEmpty) {
          return buildDebtorShimmer();
        }
        return ListView.builder(
          itemCount: controller.debtorList.length,
          itemBuilder: (context, index) {
            final debtor = controller.debtorList[index];

            return Card(
              shadowColor: Color(0xADCD852F),
              shape: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xE3945526)),
                borderRadius: BorderRadius.circular(12)
              ),
              child: ListTile(
                leading: IconButton(
                  onPressed: () {
                    Get.to(EditDebtorInfoScreen(debtor: debtor));
                  },
                  icon: Icon(Icons.edit_square),
                  color: Colors.green,
                  highlightColor: Color(0xADCD852F),
                ),
                title: Text(debtor['name']),
                titleTextStyle: TextStyle(color: Color(0xE3945526), fontFamily: 'TiroBangla-Regular', fontSize: 18, fontWeight: FontWeight.bold),
                subtitle: Text(debtor['father']),
                subtitleTextStyle: TextStyle(color: Color(0xADCD852F), fontFamily: 'TiroBangla-Regular'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${debtor['total']} ৳",
                      style: TextStyle(color: Color(0xE3945526), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.deleteDebtor(debtor['id']);
                      },
                      icon: const Icon(Icons.delete_rounded),
                      color: Colors.red,
                      highlightColor: Color(0xADCD852F),
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(DebtorDetailsPage(debtor: debtor));
                },
              ),
            );
          }
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddDebtorInfoScreen());
        },
        backgroundColor: Color(0xADCD852F),
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildDebtorShimmer() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Card(
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black26, width: 2),
        borderRadius: BorderRadius.circular(12)
      ),
      child: ListTile(
        title: ShimmerWidget.rectangular(
          height: 22
        ),
        subtitle: ShimmerWidget.rectangular(
          height: 8
        ),
        trailing: ShimmerWidget.circular(
          width: 24, 
          height: 24
        ),
      ),
    ),
  );
}