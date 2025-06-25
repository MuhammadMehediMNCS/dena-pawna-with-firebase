import 'package:flutter/material.dart';

class DebtorDetailsPage extends StatefulWidget {
  final Map<String, dynamic> debtor;

  const DebtorDetailsPage({super.key, required this.debtor});

  @override
  State<DebtorDetailsPage> createState() => _DebtorDetailsPageState();
}

class _DebtorDetailsPageState extends State<DebtorDetailsPage> {
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
              buildDetails('নাম/প্রতিষ্ঠানের নাম :', "${widget.debtor['name']}"),
              const SizedBox(height: 6.0),
              buildDetails('পিতার/কেন্দ্রের নাম :', "${widget.debtor['father']}"),
              const SizedBox(height: 6.0),
              buildDetails('ঠিকানা :', "${widget.debtor['address']}"),
              const SizedBox(height: 6.0),
              buildDetails('মোবাইল নাম্বার :', "${widget.debtor['mobile']}"),
              const SizedBox(height: 6.0),
              buildDetails('মোট টাকা :', "${widget.debtor['total']}"),
              const SizedBox(height: 6.0),
              buildDetails('তারিখ :', "${widget.debtor['date']}"),
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