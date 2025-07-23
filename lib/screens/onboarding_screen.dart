import 'package:flutter/material.dart';

import 'package:community_marketplace/models/onboarding_model.dart';
import 'package:community_marketplace/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      title: "ยินดีต้อนรับสู่ Community Marketplace",
      description:
          "ตลาดออนไลน์สำหรับคนในชุมชนเดียวกัน เพื่อซื้อ ขาย และแลกเปลี่ยนบริการแบบใกล้บ้าน",
      icon: Icons.groups_rounded,
    ),
    OnboardingModel(
      title: "ลงขายสินค้าได้ง่าย ๆ",
      description:
          "แค่ถ่ายภาพ ตั้งราคา และบรรยายสินค้า ทุกคนในละแวกจะเห็นสินค้าของคุณทันที",
      icon: Icons.add_business_rounded,
    ),
    OnboardingModel(
      title: "ค้นหาและสื่อสารได้ทันที",
      description: "ค้นหาสินค้าด้วยคำค้น ระบบกรองละเอียด และแชทกับผู้ขายโดยตรง",
      icon: Icons.search_rounded,
    ),
    OnboardingModel(
      title: "ปลอดภัยด้วยรีวิวและคะแนน",
      description:
          "ดูประวัติผู้ขาย รีวิวจากเพื่อนบ้าน และทำรายการได้อย่างมั่นใจ",
      icon: Icons.star_rate_rounded,
    ),
    OnboardingModel(
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
        MaterialPageRoute(builder: (_) => const DemoHomeScreen()),
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
              return OnboardingContent(page: page);
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

class OnboardingContent extends StatefulWidget {
  final OnboardingModel page;

  const OnboardingContent({super.key, required this.page});

  @override
  State<OnboardingContent> createState() => _OnboardingContentState();
}

class _OnboardingContentState extends State<OnboardingContent>
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
