// TODO: Splash → Terms → Onboarding → Home
// TODO: Login

import 'package:flutter/material.dart';
import 'screens/email_verification_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Marketplace',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Arial', // หรือใช้ Google Fonts ก็ได้
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 1. Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoOpacity, _logoScale, _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
          ),
        );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TermsScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => Opacity(
                opacity: _logoOpacity.value,
                child: Transform.scale(
                  scale: _logoScale.value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.store_mall_directory_rounded,
                      size: 80,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => SlideTransition(
                position: _textSlide,
                child: Opacity(
                  opacity: _textOpacity.value,
                  child: Text(
                    'Community Marketplace',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Terms & Conditions Screen
class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _showAcceptButtons = false;

  // ใช้ NotificationListener เพื่อตรวจจับการเลื่อนถึงล่าง
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent - 1.0 &&
          !_showAcceptButtons) {
        setState(() {
          _showAcceptButtons = true;
        });
      }
    }
    return false;
  }

  void _showExitDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'การไม่ยอมรับหมายถึงต้องออกจากแอปพลิเคชั่น',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ข้อตกลงและเงื่อนไข')),
      body: Stack(
        children: [
          // ใช้ NotificationListener ตรวจจับการเลื่อน
          NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildTermSection(
                        'การลงทะเบียน',
                        'ผู้ใช้ต้องกรอกข้อมูลจริง...',
                      ),
                      _buildTermSection(
                        'ความเป็นส่วนตัว',
                        'ข้อมูลจะไม่ถูกเปิดเผยให้บุคคลที่สาม...',
                      ),
                      _buildTermSection(
                        'การซื้อขาย',
                        'ผู้ใช้รับผิดชอบต่อการทำรายการเอง...',
                      ),
                      _buildTermSection(
                        'ข้อจำกัดความรับผิดชอบ',
                        'แอปไม่รับผิดชอบหากเกิดปัญหาการซื้อขาย...',
                      ),
                      const SizedBox(
                        height: 80,
                      ), // พื้นที่ท้ายเพื่อให้เลื่อนถึงได้
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // ข้อความ "เลื่อนลง" (ถ้ายังไม่ถึงล่าง)
          if (!_showAcceptButtons)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 40),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                color: Colors.white.withOpacity(0.9),
                child: const Text(
                  'เลื่อนลงไปล่างสุดเพื่อยอมรับ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),

          // ปุ่ม ยอมรับ / ไม่ยอมรับ (เมื่อเลื่อนถึงล่างแล้ว)
          if (_showAcceptButtons)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                minimum: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _showExitDialog,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('ไม่ยอมรับ'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OnboardingScreen(),
                            ),
                          );
                        },
                        child: const Text('ยอมรับ'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTermSection(String title, String content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(
              content,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Onboarding Screens
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      title: "ยินดีต้อนรับสู่ Community Marketplace",
      description:
          "ตลาดออนไลน์สำหรับคนในชุมชนเดียวกัน เพื่อซื้อ ขาย และแลกเปลี่ยนบริการแบบใกล้บ้าน",
      icon: Icons.groups_rounded,
    ),
    OnboardingPageModel(
      title: "ลงขายสินค้าได้ง่าย ๆ",
      description:
          "แค่ถ่ายภาพ ตั้งราคา และบรรยายสินค้า ทุกคนในละแวกจะเห็นสินค้าของคุณทันที",
      icon: Icons.add_business_rounded,
    ),
    OnboardingPageModel(
      title: "ค้นหาและสื่อสารได้ทันที",
      description: "ค้นหาสินค้าด้วยคำค้น ระบบกรองละเอียด และแชทกับผู้ขายโดยตรง",
      icon: Icons.search_rounded,
    ),
    OnboardingPageModel(
      title: "ปลอดภัยด้วยรีวิวและคะแนน",
      description:
          "ดูประวัติผู้ขาย รีวิวจากเพื่อนบ้าน และทำรายการได้อย่างมั่นใจ",
      icon: Icons.star_rate_rounded,
    ),
    OnboardingPageModel(
      title: "ติดตามทุกการแจ้งเตือน",
      description:
          "ไม่พลาดทุกโอกาส เพราะเรามีการแจ้งเตือนเมื่อมีคนสนใจสินค้าคุณ",
      icon: Icons.notifications_active_rounded,
    ),
  ];

  void _onNextTap() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Progress Bar บนสุด
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              children: _pages.asMap().entries.map((entry) {
                int index = entry.key;
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: _currentPage >= index
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // ภาษา (ไทย | EN)
          Positioned(
            top: 80,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "ไทย | EN",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return OnboardingPageContent(page: page);
            },
          ),

          // ปุ่ม Next / Done ด้านล่าง
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: FilledButton(
              onPressed: _onNextTap,
              child: Text(
                _currentPage == _pages.length - 1 ? "เริ่มใช้งาน" : "ถัดไป",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// โมเดลข้อมูล Onboarding
class OnboardingPageModel {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}

// ส่วนเนื้อหาแต่ละหน้า Onboarding
class OnboardingPageContent extends StatefulWidget {
  final OnboardingPageModel page;

  const OnboardingPageContent({super.key, required this.page});

  @override
  State<OnboardingPageContent> createState() => _OnboardingPageContentState();
}

class _OnboardingPageContentState extends State<OnboardingPageContent>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _iconAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(_iconController);
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _iconController,
              builder: (context, _) => Transform.translate(
                offset: Offset(0, _iconAnimation.value),
                child: Icon(widget.page.icon, size: 100, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              widget.page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              widget.page.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. HomeScreen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ยินดีต้อนรับสู่ Community Marketplace!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailVerificationScreen(
                      email: 'register@gmail.com',
                      referenceCode: 'XYLP',
                    ),
                  ),
                );
              },
              child: const Text('Test Email Verification'),
            ),
          ],
        ),
      ),
    );
  }
}
