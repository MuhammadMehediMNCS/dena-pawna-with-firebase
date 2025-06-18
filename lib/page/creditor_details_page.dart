import 'package:flutter/material.dart';

class CreditorDetailsPage extends StatefulWidget {
  final Map<String, dynamic> creditor;

  const CreditorDetailsPage({super.key, required this.creditor});

  @override
  State<CreditorDetailsPage> createState() => _CreditorDetailsPageState();
}

class _CreditorDetailsPageState extends State<CreditorDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('পূর্ণাঙ্গ তথ্য'),
        titleTextStyle: const TextStyle(color: Colors.black, fontFamily: 'TiroBangla-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildDetails('নাম/প্রতিষ্ঠানের নাম :', "${widget.creditor['name']}"),
              const SizedBox(height: 6.0),
              buildDetails('পিতার/কেন্দ্রের নাম :', "${widget.creditor['father']}"),
              const SizedBox(height: 6.0),
              buildDetails('ঠিকানা :', "${widget.creditor['address']}"),
              const SizedBox(height: 6.0),
              buildDetails('মোবাইল নাম্বার :', "${widget.creditor['mobile']}"),
              const SizedBox(height: 6.0),
              buildDetails('মোট টাকা :', "${widget.creditor['total']}"),
              const SizedBox(height: 6.0),
              buildDetails('তারিখ :', "${widget.creditor['date']}"),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildDetails(String firstName, String lastName) => Row(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * .4,
        child: Text(
          firstName,
          style: TextStyle(fontFamily: 'TiroBangla-Regular', fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      Expanded(
        child: Text(
          lastName,
          style: TextStyle(fontFamily: 'TiroBangla-Regular', fontSize: 18, fontWeight: FontWeight.bold),
        )
      )
    ],
  );
}