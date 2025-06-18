import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/page/creditor_details_page.dart';
import 'package:dena_pawna/screen/add_creditor_info_screen.dart';
import 'package:dena_pawna/screen/edit_creditor_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreditorPage extends StatefulWidget {
  const CreditorPage({super.key});

  @override
  State<CreditorPage> createState() => _CreditorPageState();
}

class _CreditorPageState extends State<CreditorPage> {
  final controller = Get.find<CreditorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        if (controller.creditorList.isEmpty) {
          return const Center(child: Text("কোনো তথ্য পাওয়া যায়নি"));
        }
        return ListView.builder(
          itemCount: controller.creditorList.length,
          itemBuilder: (context, index) {
            final creditor = controller.creditorList[index];

            return Card(
              shadowColor: Color(0xADCD852F),
              shape: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xE3945526)),
                borderRadius: BorderRadius.circular(12)
              ),
              child: ListTile(
                leading: IconButton(
                  onPressed: () {
                    Get.to(() => EditCreditorInfoScreen(creditor: creditor));
                  },
                  icon: Icon(Icons.edit_square),
                  color: Colors.green,
                  highlightColor: Color(0xADCD852F),
                ),
                title: Text(creditor['name']),
                titleTextStyle: TextStyle(color: Color(0xE3945526), fontFamily: 'TiroBangla-Regular', fontSize: 18, fontWeight: FontWeight.bold),
                subtitle: Text(creditor['father']),
                subtitleTextStyle: TextStyle(color: Color(0xADCD852F), fontFamily: 'TiroBangla-Regular'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${creditor['total']} ৳",
                      style: TextStyle(color: Color(0xE3945526), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.deleteCreditor(creditor['id']);
                      },
                      icon: const Icon(Icons.delete_rounded),
                      color: Colors.red,
                      highlightColor: Color(0xADCD852F),
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(CreditorDetailsPage(creditor: creditor));
                },
              ),
            );
          }
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddCreditorInfoScreen());
        },
        shape: CircleBorder(),
        backgroundColor: Color(0xADCD852F),
        child: Icon(Icons.add),
      ),
    );
  }
}