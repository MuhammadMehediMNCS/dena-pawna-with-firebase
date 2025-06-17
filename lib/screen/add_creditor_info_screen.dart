import 'package:flutter/material.dart';

class AddCreditorInfoScreen extends StatefulWidget {
  const AddCreditorInfoScreen({super.key});

  @override
  State<AddCreditorInfoScreen> createState() => _AddCreditorInfoScreenState();
}

class _AddCreditorInfoScreenState extends State<AddCreditorInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('নতুন পাওনাদারের তথ্য'),
        titleTextStyle: const TextStyle(color: Colors.black, fontFamily: 'TiroBangla-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
    );
  }
}