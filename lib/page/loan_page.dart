import 'package:dena_pawna/screen/add_debtor_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('LoanPag')),
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
}