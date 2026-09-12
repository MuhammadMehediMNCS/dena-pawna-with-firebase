import 'dart:io';

import 'package:dena_pawna/controller/person_controller.dart';
import 'package:dena_pawna/widget/button_widget.dart';
import 'package:dena_pawna/widget/circle_image_picker.dart';
import 'package:dena_pawna/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// একটি স্ক্রিন — নতুন পাওনাদার/দেনাদার যোগ করতে এবং বিদ্যমান তথ্য এডিট
/// করতে দুই ক্ষেত্রেই ব্যবহৃত হয় ([person] null হলে 'যোগ' মোড, নাহলে
/// 'এডিট' মোড)। যেই কন্ট্রোলার (Creditor/Debtor) পাস করা হবে সেই
/// কালেকশনেই সেভ হবে — তাই একই ফর্ম দুই ট্যাবের জন্যই কাজ করে।
class PersonFormScreen extends StatefulWidget {
  const PersonFormScreen({
    super.key,
    required this.controller,
    required this.appBarTitle,
    this.person,
  });

  final PersonController controller;
  final String appBarTitle;
  final Map<String, dynamic>? person;

  bool get isEditMode => person != null;

  @override
  State<PersonFormScreen> createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  late final TextEditingController nameController;
  late final TextEditingController fatherController;
  late final TextEditingController addressController;
  late final TextEditingController mobileController;
  late final TextEditingController totalController;
  late final TextEditingController dateController; // যোগ করার তারিখ / গ্রহণের তারিখ

  final TextEditingController receiveController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController depositDateController = TextEditingController();

  File? _pickedImageFile;
  late final int _baseTotal;
  bool _isSaving = false;

  bool get _isEdit => widget.isEditMode;

  @override
  void initState() {
    super.initState();

    final person = widget.person;

    _baseTotal = int.tryParse(person?['total']?.toString() ?? '0') ?? 0;

    nameController = TextEditingController(text: person?['name']);
    fatherController = TextEditingController(text: person?['father']);
    addressController = TextEditingController(text: person?['address']);
    mobileController = TextEditingController(text: person?['mobile']);
    totalController = TextEditingController(text: person?['total']?.toString());

    if (_isEdit) {
      // এডিট মোডে গ্রহণের তারিখ শুরুতে ফাঁকা থাকে — নতুন কিছু গ্রহণ করলে
      // তবেই আজকের তারিখ বসবে, নাহলে আগের সংরক্ষিত তারিখ অক্ষত থাকবে।
      dateController = TextEditingController();
    } else {
      dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
      );
    }

    receiveController.addListener(_onReceiveChanged);
    depositController.addListener(_onDepositChanged);
  }

  /// 'গ্রহণের পরিমাণ' ফিল্ডে টাইপ করলে মোট টাকার সাথে লাইভ যোগ হয়ে
  /// totalController-এ দেখাবে, এবং গ্রহণের তারিখ ফাঁকা থাকলে আজকের
  /// তারিখ বসিয়ে দেবে।
  void _onReceiveChanged() {
    final String text = receiveController.text.trim();
    final int receiveAmount = int.tryParse(text) ?? 0;

    totalController.text = (_baseTotal + receiveAmount).toString();

    if (text.isNotEmpty) {
      if (dateController.text.trim().isEmpty) {
        dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      }
    } else {
      dateController.clear();
    }
  }

  /// 'জমার পরিমাণ' ফিল্ডে টাইপ করলে জমার তারিখ ফাঁকা থাকলে আজকের তারিখ
  /// বসিয়ে দেবে — এটি গ্রহণের অংশ থেকে সম্পূর্ণ স্বাধীন।
  void _onDepositChanged() {
    final String text = depositController.text.trim();

    if (text.isNotEmpty) {
      if (depositDateController.text.trim().isEmpty) {
        depositDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
      }
    } else {
      depositDateController.clear();
    }
  }

  @override
  void dispose() {
    receiveController.removeListener(_onReceiveChanged);
    depositController.removeListener(_onDepositChanged);
    nameController.dispose();
    fatherController.dispose();
    addressController.dispose();
    mobileController.dispose();
    totalController.dispose();
    dateController.dispose();
    receiveController.dispose();
    depositController.dispose();
    depositDateController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    if (nameController.text.trim().isEmpty) {
      Get.snackbar('ত্রুটি', 'নাম লিখুন', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (_isEdit) {
        await _updateExistingPerson();
      } else {
        await _createNewPerson();
      }
      Get.back();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _createNewPerson() async {
    final Map<String, dynamic> data = {
      'name': nameController.text.trim(),
      'father': fatherController.text.trim(),
      'address': addressController.text.trim(),
      'mobile': mobileController.text.trim(),
      'total': int.tryParse(totalController.text.trim()) ?? 0,
      'date': dateController.text.trim(),
    };

    await widget.controller.addPerson(data, imageFile: _pickedImageFile);
  }

  Future<void> _updateExistingPerson() async {
    final String id = widget.person!['id'];
    final int totalBeforeDeposit = int.tryParse(totalController.text) ?? 0;
    final int depositAmount = int.tryParse(depositController.text) ?? 0;
    final int receiveAmount = int.tryParse(receiveController.text) ?? 0;
    final int updatedTotal = totalBeforeDeposit - depositAmount;

    final String recordDate = dateController.text.trim().isNotEmpty
        ? dateController.text.trim()
        : (widget.person!['date']?.toString() ?? '');

    final Map<String, dynamic> updatedData = {
      'name': nameController.text.trim(),
      'father': fatherController.text.trim(),
      'address': addressController.text.trim(),
      'mobile': mobileController.text.trim(),
      'total': updatedTotal,
      'date': recordDate,
    };

    await widget.controller.updatePerson(id, updatedData, imageFile: _pickedImageFile);

    // গ্রহণ করলে `receive_history` সাব-কালেকশনে আলাদা এন্ট্রি সেভ হয়
    if (receiveAmount > 0) {
      await widget.controller.saveReceiveHistory(id, {
        'name': nameController.text.trim(),
        'father': fatherController.text.trim(),
        'address': addressController.text.trim(),
        'mobile': mobileController.text.trim(),
        'amount': receiveAmount,
        'date': recordDate,
        'totalAfter': _baseTotal + receiveAmount,
      });
    }

    // জমা করলে `diposit_history` সাব-কালেকশনে আলাদা এন্ট্রি সেভ হয়
    if (depositAmount > 0) {
      await widget.controller.saveDepositHistory(id, {
        'name': nameController.text.trim(),
        'father': fatherController.text.trim(),
        'address': addressController.text.trim(),
        'mobile': mobileController.text.trim(),
        'amount': depositAmount,
        'date': depositDateController.text.trim(),
        'totalAfter': updatedTotal,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.appBarTitle),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'TiroBangla-Regular',
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ছবি সেকশন — ফায়ারবেজ স্টোরেজে আপলোড হবে, ফর্মে এটি
              // সম্পূর্ণ ঐচ্ছিক (optional); না দিলেও তথ্য সেভ হবে এবং
              // পরে লিস্টভিউ থেকেও ছবি যোগ করা যাবে।
              Center(
                child: CircleImagePicker(
                  radius: 48,
                  imageUrl: widget.person?['image'],
                  placeholderText: 'ছবি যোগ করুন\n(ঐচ্ছিক)',
                  onImagePicked: (file) => setState(() => _pickedImageFile = file),
                ),
              ),
              const SizedBox(height: 24.0),
              TextFieldWidget(title: 'নাম/প্রতিষ্ঠানের নাম :', controller: nameController),
              const SizedBox(height: 24.0),
              TextFieldWidget(title: 'পিতার/কেন্দ্রের নাম :', controller: fatherController),
              const SizedBox(height: 24.0),
              TextFieldWidget(title: 'ঠিকানা :', controller: addressController),
              const SizedBox(height: 24.0),
              TextFieldWidget(
                title: 'মোবাইল নাম্বার :',
                controller: mobileController,
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 24.0),
              if (!_isEdit)
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
                    SizedBox(width: MediaQuery.of(context).size.width * .1 - 15),
                    Expanded(
                      flex: 2,
                      child: TextFieldWidget(
                        title: 'তারিখ :',
                        controller: dateController,
                        keyboard: TextInputType.datetime,
                      ),
                    ),
                  ],
                )
              else ...[
                TextFieldWidget(
                  title: 'মোট টাকা :',
                  controller: totalController,
                  keyboard: TextInputType.phone,
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFieldWidget(
                        title: 'গ্রহণের পরিমাণ :',
                        controller: receiveController,
                        keyboard: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * .1 - 15),
                    Expanded(
                      flex: 2,
                      child: TextFieldWidget(
                        title: 'গ্রহণের তারিখ :',
                        controller: dateController,
                        keyboard: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFieldWidget(
                        title: 'জমার পরিমাণ :',
                        controller: depositController,
                        keyboard: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * .1 - 15),
                    Expanded(
                      flex: 2,
                      child: TextFieldWidget(
                        title: 'জমার তারিখ :',
                        controller: depositDateController,
                        keyboard: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              ButtonWidget(
                title: _isEdit ? 'পরিবর্তন' : 'নিশ্চিত',
                onPressed: _save,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
