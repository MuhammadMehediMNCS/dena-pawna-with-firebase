import 'package:animated_ui/core/theme/app_colors.dart';
import 'package:animated_ui/core/transitions/circular_reveal_route.dart';
import 'package:animated_ui/core/utils/bengali_digits.dart';
import 'package:animated_ui/firebase_options.dart';
import 'package:animated_ui/page/creditor_page.dart';
import 'package:animated_ui/page/debtor_page.dart';
import 'package:animated_ui/page/search_page.dart';
import 'package:animated_ui/page/settings_page.dart';
import 'package:animated_ui/providers/person_providers.dart';
import 'package:animated_ui/providers/theme_provider.dart';
import 'package:animated_ui/widget/tab_selector_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // থিম সিলেকশন সেভ রাখার জন্য GetStorage — এটি `get` প্যাকেজের অংশ নয়,
  // তাই Riverpod মাইগ্রেশনের পরও নিরাপদে রাখা যায়।
  await GetStorage.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = ref.watch(appColorsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colors.accentColor,
        scaffoldBackgroundColor: colors.scaffoldBackground,
        brightness: colors.scaffoldBackground.computeLuminance() < 0.5 ? Brightness.dark : Brightness.light,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController pageController = PageController();
  int currentPage = 0;

  /// সার্চ আইকনের স্ক্রিন-পজিশন — "Search" এনিমেশনের বৃত্তাকার রিভিল এই
  /// পজিশন থেকেই শুরু হয়।
  final GlobalKey _searchIconKey = GlobalKey();

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

  void _openSearch() {
    final renderObject = _searchIconKey.currentContext?.findRenderObject();
    Offset center = const Offset(0, 0);
    if (renderObject is RenderBox && renderObject.hasSize) {
      center = renderObject.localToGlobal(renderObject.size.center(Offset.zero));
    }

    Navigator.of(context).push(
      CircularRevealRoute(page: const SearchPage(), centerOffset: center),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureHeader());

    final colors = ref.watch(appColorsProvider);
    final creditorState = ref.watch(creditorProvider);
    final debtorState = ref.watch(debtorProvider);

    return Scaffold(
      backgroundColor: colors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: colors.headerColor,
        elevation: 12,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded, color: colors.headerOnColor, size: 26),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'আমার লেনদেনের হিসাব',
          style: TextStyle(
            fontFamily: 'TiroBangla-Regular',
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: colors.headerOnColor,
          ),
        ),
        actions: [
          IconButton(
            key: _searchIconKey,
            icon: Icon(Icons.search, color: colors.headerOnColor),
            onPressed: _openSearch,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: colors.drawerBackground,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'দেনা-পাওনা',
                  style: TextStyle(
                    fontFamily: 'TiroBangla-Regular',
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: colors.drawerOnColor,
                  ),
                ),
              ),
              Divider(color: colors.drawerOnColor.withOpacity(0.3)),
              ListTile(
                leading: Icon(Icons.person_outline, color: colors.drawerOnColor),
                title: Text('প্রোফাইল', style: TextStyle(color: colors.drawerOnColor)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.settings_outlined, color: colors.drawerOnColor),
                title: Text('সেটিংস', style: TextStyle(color: colors.drawerOnColor)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline, color: colors.drawerOnColor),
                title: Text('সম্পর্কে', style: TextStyle(color: colors.drawerOnColor)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
      // Stack ব্যবহার করে লিস্টকে হেডারের 'পিছনে' রাখা হয়েছে — লিস্ট
      // (PageView) সম্পূর্ণ স্ক্রিন জুড়ে থাকে (Positioned.fill), আর
      // বক্র-আকৃতির হেডারটি তার উপরে (Positioned, top: 0) বসানো।
      // ClipPath যেহেতু আর্চের বাইরের কোণাগুলো স্বচ্ছ রাখে, তাই স্ক্রল
      // করার সময় লিস্টের আইটেম ঠিক ঐ বক্ররেখা বরাবরই আড়াল হয়ে যায় —
      // হেডারের রঙের সাথে নিখুঁতভাবে মিলে যায়।
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) => setState(() => currentPage = index),
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
                clipper: _ArcBottomClipper(archHeight: 32.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors.headerGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0 + 28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: creditorState.isLoading
                                ? _buildShimmerContainer(context, colors)
                                : _buildTotalContainer(
                                    'মোট পাবো :',
                                    creditorState.totalAmount,
                                    const Color(0xFF2E7D32),
                                    colors,
                                  ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: debtorState.isLoading
                                ? _buildShimmerContainer(context, colors)
                                : _buildTotalContainer(
                                    'মোট দিবো :',
                                    debtorState.totalAmount,
                                    const Color(0xFFC62828),
                                    colors,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TabSelectorWidget(
                            title: 'পাবো',
                            count: creditorState.personList.length,
                            isSelected: currentPage == 0,
                            onTap: () => changePage(0),
                            selectedBackground: colors.tabSelectedBackground,
                            selectedText: colors.tabSelectedText,
                            unselectedText: colors.tabUnselectedText,
                          ),
                          TabSelectorWidget(
                            title: 'দিবো',
                            count: debtorState.personList.length,
                            isSelected: currentPage == 1,
                            onTap: () => changePage(1),
                            selectedBackground: colors.tabSelectedBackground,
                            selectedText: colors.tabSelectedText,
                            unselectedText: colors.tabUnselectedText,
                          ),
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

  Widget _buildTotalContainer(String title, int total, Color valueColor, AppColors colors) {
    final String displayValue = total == 0 ? '০০' : '${toBengaliDigits(total)} ৳';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: colors.totalBoxBackground,
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
              displayValue,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, color: valueColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContainer(BuildContext context, AppColors colors) => Container(
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: colors.totalBoxBackground,
          borderRadius: BorderRadius.circular(14.0),
        ),
      );
}

/// কার্ভটি শুধু নিচের দুই কর্ণারে ৩২ পিক্সেল করে গোল করে — একটি ঢেউ
/// আকৃতির ক্লিপার নয়।
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
