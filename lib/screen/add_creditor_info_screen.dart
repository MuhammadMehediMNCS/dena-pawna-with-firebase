import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/widget/button_widget.dart';
import 'package:dena_pawna/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddCreditorInfoScreen extends StatefulWidget {
  const AddCreditorInfoScreen({super.key});

  @override
  State<AddCreditorInfoScreen> createState() => _AddCreditorInfoScreenState();
}

class _AddCreditorInfoScreenState extends State<AddCreditorInfoScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final creditorController = Get.put(CreditorController());

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    super.initState();
  }

  void saveData() {
    Map<String, dynamic> data = {
      'name': nameController.text,
      'father': fatherController.text,
      'address': addressController.text,
      'mobile': mobileController.text,
      'total': int.parse(totalController.text),
      'date': dateController.text
    };

    creditorController.addCreditor(data);

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('নতুন পাওনাদারের তথ্য'),
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
                    ),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ButtonWidget(
                title: 'নিশ্চিত',
                onPressed: saveData
              ),
              const SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}