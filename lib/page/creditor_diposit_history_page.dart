import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class CreditorDipositHistoryPage extends StatefulWidget {
  final String creditorId;

  const CreditorDipositHistoryPage({super.key, required this.creditorId});

  @override
  State<CreditorDipositHistoryPage> createState() => _CreditorDipositHistoryPageState();
}

class _CreditorDipositHistoryPageState extends State<CreditorDipositHistoryPage> {
  final controller = Get.find<CreditorController>();

  @override
  Widget build(BuildContext context) {
    controller.fetchDipositHistoryForCreditor(widget.creditorId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('টাকা জমাদানের তথ্য'),
        titleTextStyle: const TextStyle(color: Colors.black, fontFamily: 'TiroBangla-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
      body: Obx(() {
        final history = controller.singleDipositList;

        if (history.isEmpty) {
          return Center(child: Text('জমার কোনো তথ্য পাওয়া যায় নি'));
        }

        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];

            return Card(
              color: Color(0xFFEACDA3),
              child: ListTile(
                title: Text("${item['dipositDate']} তারিখের তথ্য :"),
                titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w700),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 28.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("নাম/প্রতিষ্ঠানের নাম : ${item['name']}"),
                      const SizedBox(height: 6),
                      Text("পিতার/কেন্দ্রের নাম : ${item['father']}"),
                      const SizedBox(height: 6),
                      Text("ঠিকানা : ${item['address']}"),
                      const SizedBox(height: 6),
                      Text("মোবাইল নাম্বার : ${item['mobile']}"),
                      const SizedBox(height: 6),
                      Text("প্রদান : ${item['diposit'].toString()}"),
                      const SizedBox(height: 6),
                      Text("গ্রহণের তারিখ : ${item['date'].toString()}"),
                      const SizedBox(height: 6),
                      Text("বাঁকি : ${item['total'].toString()}"),
                    ],
                  ),
                ),
                subtitleTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          }
        );
      }),
    );
  }
}
