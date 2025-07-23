import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  late AnimationController _controller;
  late Animation<double> _logoOpacity, _logoScale, _textOpacity;
  late Animation<Offset> _textSlide;

  AnimationController get controller => _controller;
  Animation<double> get logoOpacity => _logoOpacity;
  Animation<double> get logoScale => _logoScale;
  Animation<double> get textOpacity => _textOpacity;
  Animation<Offset> get textSlide => _textSlide;

  void initializeAnimations(TickerProvider vsync) {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
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
  }

  void startNavigation(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // Note: Import the target screen in the widget file
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const NextScreen()),
      // );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
