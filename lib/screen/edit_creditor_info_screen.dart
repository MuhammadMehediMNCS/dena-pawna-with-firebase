import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/widget/button_widget.dart';
import 'package:dena_pawna/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final controller = Get.find<CreditorController>();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.creditor['name']);
    fatherController = TextEditingController(text: widget.creditor['father']);
    addressController = TextEditingController(text: widget.creditor['address']);
    mobileController = TextEditingController(text: widget.creditor['mobile']);
    totalController = TextEditingController(text: widget.creditor['total'].toString());
    dateController = TextEditingController(text: widget.creditor['date']);
    super.initState();
  }

  void updateData() {
    final int total = int.tryParse(totalController.text) ?? 0;
    final int dipodit = int.tryParse(dipositController.text) ?? 0;
    final int updatedTotal = total - dipodit;

    Map<String, dynamic> data = {
      'name': nameController.text,
      'father': fatherController.text,
      'address': addressController.text,
      'mobile': mobileController.text,
      'total': updatedTotal,
      'date': dateController.text,
    };
    controller.updateCreditor(widget.creditor['id'], data);
    Get.back();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('তথ্য এডিট করুন'),
        titleTextStyle: const TextStyle(color: Colors.black, fontFamily: 'TiroBangla-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
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
                      title: 'তারিখ :',
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
                  Expanded(
                    flex: 2,
                    child: SizedBox()
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ButtonWidget(
                title: 'আপডেট করুন',
                onPressed: updateData
              ),
            ],
          ),
        ),
      ),
    );
  }
}