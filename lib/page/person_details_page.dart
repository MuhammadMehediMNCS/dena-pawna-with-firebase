import 'package:flutter/material.dart';

class PersonDetailsPage extends StatelessWidget {
  final Map<String, dynamic> person;

  const PersonDetailsPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = person['image'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('পূর্ণাঙ্গ তথ্য'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'TiroBangla-Regular',
          fontSize: 18.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xE3945526).withOpacity(0.1),
                backgroundImage:
                    (imageUrl != null && imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
                child: (imageUrl == null || imageUrl.isEmpty)
                    ? const Icon(Icons.person, color: Color(0xE3945526), size: 40)
                    : null,
              ),
              const SizedBox(height: 20.0),
              _buildDetails(context, 'নাম/প্রতিষ্ঠানের নাম :', "${person['name']}"),
              const SizedBox(height: 6.0),
              _buildDetails(context, 'পিতার/কেন্দ্রের নাম :', "${person['father']}"),
              const SizedBox(height: 6.0),
              _buildDetails(context, 'ঠিকানা :', "${person['address']}"),
              const SizedBox(height: 6.0),
              _buildDetails(context, 'মোবাইল নাম্বার :', "${person['mobile']}"),
              const SizedBox(height: 6.0),
              _buildDetails(context, 'মোট টাকা :', "${person['total']}"),
              const SizedBox(height: 6.0),
              _buildDetails(context, 'তারিখ :', "${person['date']}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, String label, String value) => Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'TiroBangla-Regular', fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'TiroBangla-Regular', fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
}
