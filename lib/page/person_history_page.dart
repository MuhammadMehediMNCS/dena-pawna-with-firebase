import 'package:dena_pawna/controller/person_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// `receive_history` ও `diposit_history` — এখন দুটো আলাদা সাব-কালেকশন,
/// তাই এই পেজে কোনটা দেখাতে হবে তা এই এনাম দিয়ে বলে দেওয়া হয়।
enum HistoryType { receive, deposit }

class PersonHistoryPage extends StatefulWidget {
  const PersonHistoryPage({
    super.key,
    required this.personId,
    required this.controller,
    required this.historyType,
  });

  final String personId;
  final PersonController controller;
  final HistoryType historyType;

  @override
  State<PersonHistoryPage> createState() => _PersonHistoryPageState();
}

class _PersonHistoryPageState extends State<PersonHistoryPage> {
  @override
  void initState() {
    super.initState();

    if (widget.historyType == HistoryType.receive) {
      widget.controller.fetchReceiveHistoryForPerson(widget.personId);
    } else {
      widget.controller.fetchDepositHistoryForPerson(widget.personId);
    }
  }

  String get _pageTitle => widget.historyType == HistoryType.receive ? 'গ্রহণের তথ্য' : 'জমার তথ্য';

  String get _amountLabel => widget.historyType == HistoryType.receive ? 'গ্রহণের পরিমাণ' : 'জমার পরিমাণ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(_pageTitle),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'TiroBangla-Regular',
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Obx(() {
        final history = widget.controller.historyList;

        if (history.isEmpty) {
          return const Center(
            child: Text(
              'কোনো তথ্য পাওয়া যায় নি',
              style: TextStyle(fontFamily: 'TiroBangla-Regular', fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];

            return Card(
              color: const Color(0xFFEACDA3),
              child: ListTile(
                title: Text("${item['date'] ?? ''} তারিখের তথ্য :"),
                titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w700),
                subtitle: Padding(
                  padding: const EdgeInsets.only(left: 28.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("নাম/প্রতিষ্ঠানের নাম : ${item['name']}"),
                      const SizedBox(height: 6),
                      Text("পিতার/কেন্দ্রের নাম : ${item['father']}"),
                      const SizedBox(height: 6),
                      Text("ঠিকানা : ${item['address']}"),
                      const SizedBox(height: 6),
                      Text("মোবাইল নাম্বার : ${item['mobile']}"),
                      const SizedBox(height: 6),
                      Text("$_amountLabel : ${item['amount']}"),
                      const SizedBox(height: 6),
                      Text("এই লেনদেনের পর মোট : ${item['totalAfter']}"),
                    ],
                  ),
                ),
                subtitleTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            );
          },
        );
      }),
    );
  }
}
