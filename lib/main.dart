import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/controller/debtor_controller.dart';
import 'package:dena_pawna/firebase_options.dart';
import 'package:dena_pawna/page/creditor_page.dart';
import 'package:dena_pawna/page/debtor_page.dart';
import 'package:dena_pawna/widget/shimmer_widget.dart';
import 'package:dena_pawna/widget/tab_selector_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // নোট: আগে এখানে এবং HomePage-এ, দুই জায়গাতেই CreditorController
  // Get.put করা হতো — যা কন্ট্রোলারকে অপ্রয়োজনে দুইবার তৈরি করত। এখন
  // দুটো কন্ট্রোলারই এখানে একবারই put করা হচ্ছে, বাকি সব জায়গায়
  // Get.find() দিয়ে একই ইনস্ট্যান্স ব্যবহার হবে।
  Get.put(CreditorController());
  Get.put(DebtorController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xADCD852F),
      ),
      home: const HomePage(),
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

  final CreditorController creditorController = Get.find<CreditorController>();
  final DebtorController debtorController = Get.find<DebtorController>();

  static const Color appBarColor = Color(0xFFB5792B);
  static const Color pageBackgroundColor = Colors.white;

  /// হেডার (দুটো টোটাল-বক্স + ট্যাব) এর প্রকৃত রেন্ডার হওয়া উচ্চতা।
  /// স্ক্রল না করা অবস্থায় লিস্টের প্রথম আইটেম যেন ঠিক হেডারের নিচেই
  /// শুরু হয়, তার জন্য এই মানটি প্রথম ফ্রেমের পরে মেপে নেওয়া হয় এবং
  /// লিস্টের top padding হিসেবে পাস করা হয়। মাপার আগে একটি আনুমানিক
  /// মান দেওয়া আছে, যাতে প্রথম ফ্রেমে হঠাৎ লাফ (jump) চোখে না পড়ে।
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 195.0;

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  void _measureHeader() {
    final renderObject = _headerKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final double measuredHeight = renderObject.size.height;
    if ((measuredHeight - _headerHeight).abs() > 0.5) {
      setState(() => _headerHeight = measuredHeight);
    }
  }

  void changePage(int index) {
    if (index >= 0 && index <= 1) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() => currentPage = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // প্রতিটি ফ্রেমের পরে হেডারের উচ্চতা যাচাই করা হয় (কনটেন্ট বদলালে,
    // যেমন শিমার থেকে আসল ডাটায় পরিবর্তনের সময়, উচ্চতা পাল্টাতে পারে)।
    // মান আসলেই বদলালে তবেই setState হয়, তাই এটি লুপে পড়ে না।
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeader());

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 12,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'আমার লেনদেনের হিসাব',
          style: TextStyle(
            fontFamily: 'TiroBangla-Regular',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: appBarColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  'দেনা-পাওনা',
                  style: TextStyle(
                    fontFamily: 'TiroBangla-Regular',
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const Divider(color: Colors.white54),
              ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.white),
                title: const Text('প্রোফাইল', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined, color: Colors.white),
                title: const Text('সেটিংস', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text('সম্পর্কে', style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      // আগে এখানে Column ছিল: হেডার তারপর Expanded(লিস্ট) — দুটো সম্পূর্ণ
      // আলাদা, ওভারল্যাপবিহীন সিবলিং, তাই লিস্টের viewport সবসময় হেডারের
      // বাউন্ডিং বক্সের একদম সমান-উচ্চতার (সোজা রেখা বরাবর) নিচে কাটা
      // পড়ত — বক্ররেখার (arc) আকৃতি অনুযায়ী নয়। ফলে স্ক্রল করলে আইটেম
      // বক্ররেখার রঙের সাথে না মিলিয়ে খানিকটা নিচে গিয়ে হঠাৎ কাটা পড়ত।
      //
      // এখন Stack ব্যবহার করে লিস্টকে হেডারের 'পিছনে' রাখা হয়েছে —
      // লিস্ট (PageView) সম্পূর্ণ স্ক্রিন জুড়ে থাকে (Positioned.fill),
      // আর বক্র-আকৃতির হেডারটি তার উপরে (Positioned, top: 0) বসানো।
      // ClipPath যেহেতু আর্চের বাইরের কোণাগুলো স্বচ্ছ রাখে, তাই স্ক্রল
      // করার সময় লিস্টের আইটেম ঠিক ঐ বক্ররেখা বরাবরই আড়াল হয়ে যায় —
      // 0xFFB5792B রঙের সাথে নিখুঁতভাবে মিলে যায়।
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                children: [
                  CreditorPage(topPadding: _headerHeight),
                  DebtorPage(topPadding: _headerHeight),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipPath(
                key: _headerKey,
                clipper: _ArcBottomClipper(archHeight: 48.0),
                child: Container(
                  width: double.infinity,
                  color: appBarColor,
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0 + 28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              if (creditorController.personList.isEmpty) {
                                return buildShimmerContainer();
                              }
                              return buildContainer('মোট পাবো :', creditorController.totalAmount.value, Colors.green);
                            }),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Obx(() {
                              if (debtorController.personList.isEmpty) {
                                return buildShimmerContainer();
                              }
                              return buildContainer('মোট দিবো :', debtorController.totalAmount.value, Colors.red);
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Obx(() => TabSelectorWidget(
                                title: 'পাবো',
                                count: creditorController.personList.length,
                                isSelected: currentPage == 0,
                                onTap: () => changePage(0),
                              )),
                          Obx(() => TabSelectorWidget(
                                title: 'দিবো',
                                count: debtorController.personList.length,
                                isSelected: currentPage == 1,
                                onTap: () => changePage(1),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer(String title, int total, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFDFBF9C),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'TiroBangla-Regular',
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              '${total.toString()} ৳',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildShimmerContainer() => ShimmerWidget.rectangular(
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
      );
}

class _ArcBottomClipper extends CustomClipper<Path> {
  final double archHeight;

  _ArcBottomClipper({this.archHeight = 32.0});

  @override
  Path getClip(Size size) {
    final double radius = archHeight;

    final path = Path()
      ..lineTo(0, size.height - radius)
      ..quadraticBezierTo(0, size.height, radius, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
