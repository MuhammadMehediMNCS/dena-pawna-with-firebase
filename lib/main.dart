import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/controller/debtor_controller.dart';
import 'package:dena_pawna/firebase_options.dart';
import 'package:dena_pawna/page/creditor_page.dart';
import 'package:dena_pawna/page/debtor_page.dart';
import 'package:dena_pawna/widget/shimmer_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(CreditorController());

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

  final CreditorController creditorController = Get.put(CreditorController());
  final DebtorController debtorController = Get.put(DebtorController());

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  void changePage(int index) {
    if (index >= 0 && index <= 1) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
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
                    Flexible(
                      child: Obx(() {
                        if (creditorController.totalAmount.value == 0) {
                          return buildShimmerContainer();
                        }
                        return buildContainer('মোট পাবো :', creditorController.totalAmount.value);
                      // This is for Double Value : return buildContainer('মোট পাবো :', controller.totalAmount.value.toStringAsFixed(2));
                      }),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1 -20,),
                    Flexible(
                      child: Obx(() {
                        if (debtorController.totalAmount.value == 0) {
                          return buildShimmerContainer();
                        }
                        return buildContainer('মোট দিবো :', debtorController.totalAmount.value);
                      }),
                    )
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
                    CreditorPage(),
                    DebtorPage()
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
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
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
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isSelected ?  Color(0xADCD852F) : Color(0xFFEACDA3),
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? Color(0xADCD852F) : Color(0xFFEACDA3)),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Color(0xE3945526) : Color(0xFFEACDA3),
              fontFamily: 'TiroBangla-Regular',
              fontSize: isSelected ? 18 : 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      )
    );
  }

  Widget buildShimmerContainer() => ShimmerWidget.rectangular(
    height: MediaQuery.of(context).size.height * 0.1,
    width: double.infinity,
  );
}