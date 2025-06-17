import 'package:dena_pawna/page/due_page.dart';
import 'package:dena_pawna/page/loan_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xADCD852F)
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  void changePage(int index) {
    if (index >= 0 && index <= 1) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut
      );

      setState(() => currentPage = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildContainer('মোট পাবো :', 17000),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1 -20,),
                    buildContainer('মোট দিবো :', 17000),
                  ],
                )
              ),
              const SizedBox(height: 10.0),
              Divider(
                thickness: 2,
                indent: 12,
                endIndent: 12,
                color: Color(0xADCD852F),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTabButton("পাবো", 0),
                  buildTabButton("দিবো", 1),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() => currentPage = index);
                  },
                  children: const [
                    DuePage(),
                    LoanPage()
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  Widget buildContainer(String title, int total) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 + 8,
      width: MediaQuery.of(context).size.width * 0.4 + 10,
      decoration: BoxDecoration(
        color: Color(0xADCD852F),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontFamily: 'TiroBangla-Regular', fontSize: 18.0, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8.0),
            Text(
              '${total.toString()} ৳',
              style: TextStyle(fontFamily: 'TiroBangla-Regular', fontSize: 22.0, fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTabButton(String title, int index) {
    final bool isSelected = currentPage == index;

    return InkWell(
      onTap: () => changePage(index),
      child: Column(
        children: [
          AnimatedContainer(
            height: isSelected ? 24 : 18,
            width: isSelected ? 24 : 18,
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: isSelected ?  Color(0xADCD852F) : Color(0xFFEACDA3),
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Color(0xADCD852F) : Color(0xFFEACDA3)),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Color(0xADCD852F) : Color(0xFFEACDA3),
              fontFamily: 'TiroBangla-Regular',
              fontSize: isSelected ? 18 : 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      )
    );
  }
}