import 'package:flutter/material.dart';

class AddDebtorInfoScreen extends StatefulWidget {
  const AddDebtorInfoScreen({super.key});

  @override
  State<AddDebtorInfoScreen> createState() => _AddDebtorInfoScreenState();
}

class _AddDebtorInfoScreenState extends State<AddDebtorInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('নতুন দেনাদারের তথ্য'),
        titleTextStyle: const TextStyle(color: Colors.black, fontFamily: 'TiroBangla-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
    );
  }
}