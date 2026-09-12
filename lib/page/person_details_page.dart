import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonDetailsPage extends StatelessWidget {
  final Map<String, dynamic> person;

  const PersonDetailsPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = person['image'];

    return Scaffold(
      //backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'পূর্ণাঙ্গ তথ্য',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'TiroBangla-Regular',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // টপ প্রোফাইল হেডার সেকশন
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: const BoxDecoration(
                color: Color(0xADCD852F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage:
                              (imageUrl != null && imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
                              child: (imageUrl == null || imageUrl.isEmpty)
                              ? const Icon(Icons.person, color: Color(0xE3945526), size: 40)
                              : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${person['name']}",
                    style: TextStyle(
                      fontFamily: 'TiroBangla-Regular',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'প্রয়োজনীয় তথ্যের বিবরণী',
                    style: TextStyle(
                      fontFamily: 'TiroBangla-Regular',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // গ্রিড ইনফরমেশন কার্ডস
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          icon: Icons.person,
                          iconBgColor: Color(0xFF1E88E5),
                          title: 'বাবার নাম:',
                          value: "${person['father']}",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          icon: Icons.calendar_today_rounded,
                          iconBgColor: Color(0xFFFB8C00),
                          title: 'গ্রহণের তারিখ:',
                          value: "${person['date']}",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          icon: Icons.location_on,
                          iconBgColor: Color(0xFF00ACC1),
                          title: 'ঠিকানা:',
                          value: "${person['address']}",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          icon: Icons.call,
                          iconBgColor: Color(0xFF43A047),
                          title: 'মোবাইল নাম্বার:',
                          value: '+88${person['mobile']}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InfoCard(
                          icon: Icons.currency_rupee,
                          iconBgColor: Color(0xFFE53935),
                          title: 'মোট টাকা:',
                          value: "${person['total']}",
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: InfoCard(
                          icon: Icons.stars,
                          iconBgColor: Color(0xFF8E24AA),
                          title: 'মেম্বারশিপ টাইপ:',
                          value: 'সাধারণ সদস্য (General)',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      /*
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
      ), */
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconBgColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconBgColor,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'TiroBangla-Regular',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'TiroBangla-Regular',
                    fontSize: 12,
                    color: Colors.grey[800],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}