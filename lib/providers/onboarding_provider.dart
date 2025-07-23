import 'package:flutter/material.dart';
import 'package:community_marketplace/models/onboarding_model.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  PageController get pageController => _pageController;
  int get currentPage => _currentPage;

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

  List<OnboardingModel> get pages => _pages;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  bool get isLastPage => _currentPage == _pages.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
