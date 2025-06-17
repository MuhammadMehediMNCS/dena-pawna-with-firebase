import 'package:dena_pawna/screen/add_creditor_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class DuePage extends StatefulWidget {
  const DuePage({super.key});

  @override
  State<DuePage> createState() => _DuePageState();
}

class _DuePageState extends State<DuePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('DuePage')),
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