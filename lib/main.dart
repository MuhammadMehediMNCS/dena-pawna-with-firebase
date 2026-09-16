import 'package:dena_pawna/controller/creditor_controller.dart';
import 'package:dena_pawna/controller/debtor_controller.dart';
import 'package:dena_pawna/controller/theme_controller.dart';
import 'package:dena_pawna/core/utils/bengali_digits.dart';
import 'package:dena_pawna/firebase_options.dart';
import 'package:dena_pawna/page/creditor_page.dart';
import 'package:dena_pawna/page/debtor_page.dart';
import 'package:dena_pawna/page/search_page.dart';
import 'package:dena_pawna/page/settings_page.dart';
import 'package:dena_pawna/widget/shimmer_widget.dart';
import 'package:dena_pawna/widget/tab_selector_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // থিম বাছাই (ডার্ক/লাইট/কালার) ডিভাইসে সংরক্ষণ করার জন্য GetStorage।
  await GetStorage.init();

  Get.put(CreditorController());
  Get.put(DebtorController());
  Get.put(ThemeController());

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
  final ThemeController themeController = Get.find<ThemeController>();

  /// হেডার (দুটো টোটাল-বক্স + ট্যাব) এর প্রকৃত রেন্ডার হওয়া উচ্চতা।
  /// স্ক্রল না করা অবস্থায় লিস্টের প্রথম আইটেম যেন ঠিক হেডারের নিচেই
  /// শুরু হয়, তার জন্য এই মানটি প্রথম ফ্রেমের পরে মেপে নেওয়া হয় এবং
  /// লিস্টের top padding হিসেবে পাস করা হয়।
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeader());

    // পুরো HomePage একটি Obx-এ মোড়ানো, যাতে সেটিংস থেকে থিম বদলালে
    // হেডার/ড্রয়ার/ট্যাব/ব্যাকগ্রাউন্ড — সবকিছু সাথে সাথে রিবিল্ড হয়।
    return Obx(() {
      final colors = themeController.colors;

      return Scaffold(
        backgroundColor: colors.pageBackground,
        appBar: AppBar(
          backgroundColor: colors.headerColor,
          elevation: 12,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu_rounded, color: colors.headerTextColor, size: 26),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            'আমার লেনদেনের হিসাব',
            style: TextStyle(
              fontFamily: 'TiroBangla-Regular',
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: colors.headerTextColor,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search_rounded, color: colors.headerTextColor, size: 26),
              tooltip: 'খুঁজুন',
              onPressed: () => Get.to(() => const SearchPage()),
            ),
            const SizedBox(width: 6),
          ],
        ),
        drawer: Drawer(
          backgroundColor: colors.drawerBackground,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'দেনা-পাওনা',
                    style: TextStyle(
                      fontFamily: 'TiroBangla-Regular',
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                      color: colors.drawerTextColor,
                    ),
                  ),
                ),
                Divider(color: colors.drawerTextColor.withOpacity(0.4)),
                ListTile(
                  leading: Icon(Icons.home_rounded, color: colors.drawerTextColor),
                  title: Text('হোমপেজ', style: TextStyle(color: colors.drawerTextColor)),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: Icon(Icons.settings_outlined, color: colors.drawerTextColor),
                  title: Text('সেটিংস', style: TextStyle(color: colors.drawerTextColor)),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const SettingsPage());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline, color: colors.drawerTextColor),
                  title: Text('সম্পর্কে', style: TextStyle(color: colors.drawerTextColor)),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
        // Stack ব্যবহার করে লিস্টকে হেডারের 'পিছনে' রাখা হয়েছে, যাতে
        // স্ক্রল করার সময় আইটেম বক্ররেখা বরাবর মিলিয়ে যায়।
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
                    color: colors.headerColor,
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0 + 28.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() {
                                if (creditorController.isLoading.value) {
                                  return buildShimmerContainer();
                                }
                                return buildContainer(
                                  'মোট পাবো :',
                                  creditorController.totalAmount.value,
                                  Colors.green,
                                  colors.totalBoxBackground,
                                );
                              }),
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Obx(() {
                                if (debtorController.isLoading.value) {
                                  return buildShimmerContainer();
                                }
                                return buildContainer(
                                  'মোট দিবো :',
                                  debtorController.totalAmount.value,
                                  Colors.red,
                                  colors.totalBoxBackground,
                                );
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
                                  selectedBackground: colors.tabSelectedBackground,
                                  selectedText: colors.tabSelectedText,
                                  unselectedText: colors.tabUnselectedText,
                                )),
                            Obx(() => TabSelectorWidget(
                                  title: 'দিবো',
                                  count: debtorController.personList.length,
                                  isSelected: currentPage == 1,
                                  onTap: () => changePage(1),
                                  selectedBackground: colors.tabSelectedBackground,
                                  selectedText: colors.tabSelectedText,
                                  unselectedText: colors.tabUnselectedText,
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
    });
  }

  Widget buildContainer(String title, int total, Color valueColor, Color boxColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: boxColor,
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
              // কোনো লেনদেন না থাকলে (total == 0) '০০' দেখানো হয়,
              // নাহলে প্রকৃত অংক — দুই ক্ষেত্রেই বাংলা সংখ্যায়।
              '${total == 0 ? '০০' : toBengaliDigits(total)} ৳',
              style: TextStyle(
                fontFamily: 'TiroBangla-Regular',
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
