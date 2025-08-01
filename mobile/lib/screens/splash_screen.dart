import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:community_marketplace/screens/term_screen.dart';
import 'package:community_marketplace/providers/splash_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashProvider(),
      child: const _SplashScreenContent(),
    );
  }
}

class _SplashScreenContent extends StatefulWidget {
  const _SplashScreenContent();

  @override
  State<_SplashScreenContent> createState() => _SplashScreenContentState();
}

class _SplashScreenContentState extends State<_SplashScreenContent>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SplashProvider>(context, listen: false);
    provider.initializeAnimations(this);

    // Start navigation timer
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TermsScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: provider.controller,
                  builder: (_, _) => Opacity(
                    opacity: provider.logoOpacity.value,
                    child: Transform.scale(
                      scale: provider.logoScale.value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.2),
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
                  animation: provider.controller,
                  builder: (_, _) => SlideTransition(
                    position: provider.textSlide,
                    child: Opacity(
                      opacity: provider.textOpacity.value,
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
      },
    );
  }
}
