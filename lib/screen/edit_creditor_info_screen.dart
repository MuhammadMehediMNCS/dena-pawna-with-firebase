import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/page/creditor_diposit_history_page.dart';
import 'package:dena_pawna/widget/button_widget.dart';
import 'package:dena_pawna/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditCreditorInfoScreen extends StatefulWidget {
  final Map<String, dynamic> creditor;

  const EditCreditorInfoScreen({super.key, required this.creditor});

  @override
  State<EditCreditorInfoScreen> createState() => _EditCreditorInfoScreenState();
}

class _EditCreditorInfoScreenState extends State<EditCreditorInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController fatherController;
  late TextEditingController addressController;
  late TextEditingController mobileController;
  late TextEditingController totalController;
  late TextEditingController dateController;
  final TextEditingController dipositController = TextEditingController();
  final TextEditingController dipositDateController = TextEditingController();

  final controller = Get.find<CreditorController>();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.creditor['name']);
    fatherController = TextEditingController(text: widget.creditor['father']);
    addressController = TextEditingController(text: widget.creditor['address']);
    mobileController = TextEditingController(text: widget.creditor['mobile']);
    totalController = TextEditingController(text: widget.creditor['total'].toString());
    dateController = TextEditingController(text: widget.creditor['date']);
    dipositDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  void updateData() async {
    final String id = widget.creditor['id'];
    final int total = int.tryParse(totalController.text) ?? 0;
    final int diposit = int.tryParse(dipositController.text) ?? 0;
    final int updatedTotal = total - diposit;

    Map<String, dynamic> updatedData = {
      'name': nameController.text,
      'father': fatherController.text,
      'address': addressController.text,
      'mobile': mobileController.text,
      'total': updatedTotal,
      'date': dateController.text,
    };


    if (dipositController.text.trim().isNotEmpty) {
      Map<String, dynamic> historyData = {
        'name': nameController.text,
        'father': fatherController.text,
        'address': addressController.text,
        'mobile': mobileController.text,
        'total': updatedTotal,
        'diposit': diposit,
        'dipositDate': dipositDateController.text,
        'date': dateController.text
      };

      await controller.saveDipositHistory(id, historyData);
      await controller.updateCreditor(id, updatedData);
    } else {
      await controller.updateCreditor(id, updatedData);
    }
    
    Get.back();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('তথ্য এডিট করুন'),
        titleTextStyle: const TextStyle(color: Colors.black, fontFamily: 'TiroBangla-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => CreditorDipositHistoryPage(creditorId: widget.creditor['id']));
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              'জমার তথ্য দেখুন',
              style: TextStyle(color: Colors.pink, fontFamily: 'TiroBangla-Regular', fontSize: 18.0, fontWeight: FontWeight.w700)
            ),
          ),
          SizedBox(width: 20.0)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFieldWidget(
                title: 'নাম/প্রতিষ্ঠানের নাম :',
                controller: nameController
              ),
              const SizedBox(height: 24.0),
              TextFieldWidget(
                title: 'পিতার/কেন্দ্রের নাম :',
                controller: fatherController
              ),
              const SizedBox(height: 24.0),
              TextFieldWidget(
                title: 'ঠিকানা :',
                controller: addressController
              ),
              const SizedBox(height: 24.0),
              TextFieldWidget(
                title: 'মোবাইল নাম্বার :',
                controller: mobileController,
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                      title: 'মোট টাকা :',
                      controller: totalController,
                      keyboard: TextInputType.number,
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .1 -15),
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                      title: 'গ্রহণের তারিখ :',
                      controller: dateController,
                      keyboard: TextInputType.datetime,
                    )
                  )
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                      title: 'জমার পরিমাণ :',
                      controller: dipositController,
                      keyboard: TextInputType.number,
                    )
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * .1 -15),
                  Expanded(
                    flex: 2,
                    child: TextFieldWidget(
                      title: 'জমার তারিখ :',
                      controller: dipositDateController,
                      keyboard: TextInputType.datetime,
                    )
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ButtonWidget(
                title: 'পরিবর্তন',
                onPressed: updateData
              ),
              const SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}