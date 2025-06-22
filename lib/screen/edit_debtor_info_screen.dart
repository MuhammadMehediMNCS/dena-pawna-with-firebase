import 'package:dena_pawna/widget/button_widget.dart';
import 'package:dena_pawna/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDebtorInfoScreen extends StatefulWidget {
  final Map<String, dynamic> debtor;

  const EditDebtorInfoScreen({super.key, required this.debtor});

  @override
  State<EditDebtorInfoScreen> createState() => _EditDebtorInfoScreenState();
}

class _EditDebtorInfoScreenState extends State<EditDebtorInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController fatherController;
  late TextEditingController addressController;
  late TextEditingController mobileController;
  late TextEditingController totalController;
  late TextEditingController dateController;
  final TextEditingController dipositController = TextEditingController();
  final TextEditingController dipositDateController = TextEditingController();
  @override
  void initState() {
    nameController = TextEditingController(text: widget.debtor['name']);
    fatherController = TextEditingController(text: widget.debtor['father']);
    addressController = TextEditingController(text: widget.debtor['address']);
    mobileController = TextEditingController(text: widget.debtor['mobile']);
    totalController = TextEditingController(text: widget.debtor['total'].toString());
    dateController = TextEditingController(text: widget.debtor['date']);
    dipositDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
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
            onPressed: () {},
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
            )
          )
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
                onPressed: () {}
              ),
              const SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }
}