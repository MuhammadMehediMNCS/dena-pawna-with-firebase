import 'package:dena_pawna/screen/add_debtor_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebtorPage extends StatefulWidget {
  const DebtorPage({super.key});

  @override
  State<DebtorPage> createState() => _DebtorPageState();
}

class _DebtorPageState extends State<DebtorPage> {
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