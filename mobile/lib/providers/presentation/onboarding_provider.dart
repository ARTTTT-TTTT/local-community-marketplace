import 'package:flutter/material.dart';

import 'package:community_marketplace/models/presentation/onboarding_model.dart';
import 'package:community_marketplace/data/onboarding_data.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  PageController get pageController => _pageController;
  int get currentPage => _currentPage;

  final List<OnboardingModel> _pages = onboardingData;

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
