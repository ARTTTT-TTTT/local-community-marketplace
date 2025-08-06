import 'package:community_marketplace/screens/presentation/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:community_marketplace/utils/env_config.dart';
import 'package:community_marketplace/firebase_options.dart';
import 'package:community_marketplace/constants/app_constants.dart';
import 'package:community_marketplace/theme/app_theme.dart';
import 'package:community_marketplace/services/terms_service.dart';

import 'package:community_marketplace/screens/auth/login_screen.dart';
import 'package:community_marketplace/screens/auth/register_screen.dart';
import 'package:community_marketplace/screens/auth/email_verification_screen.dart';
import 'package:community_marketplace/screens/presentation/onboarding_screen.dart';
import 'package:community_marketplace/screens/presentation/splash_screen.dart';
import 'package:community_marketplace/screens/error_screen.dart';
import 'package:community_marketplace/screens/test/firebase_test_screen.dart';
import 'package:community_marketplace/screens/dashboard_screen.dart';
import 'package:community_marketplace/screens/item_search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    // Validate Firebase configuration
    EnvConfig.validateConfiguration();

    // Initialize Firebase with manual configuration instead of plist
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final hasAccepted = await TermsService.hasAcceptedTerms();
    runApp(MyApp(hasAcceptedTerms: hasAccepted));
  } catch (e) {
    runApp(ErrorScreen(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required bool hasAcceptedTerms});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> screenList = [
      {
        'name': 'Continue',
        'screen': const SplashScreen(isFreshInstall: true),
        'color': Colors.amber,
      },
      {
        'name': 'Fresh Install',
        'screen': const SplashScreen(isFreshInstall: true),
        'color': Colors.red,
      },
      {
        'name': 'Terms Screen',
        'screen': const TermsScreen(),
        'color': Colors.pink,
      },
      {
        'name': 'Onboarding Screen',
        'screen': const OnboardingScreen(),
        'textColor': Colors.black,
        'color': Colors.yellow,
      },
      {
        'name': 'Register Screen',
        'screen': const RegisterScreen(email: 'register@gmail.com'),
        'color': Colors.orange,
      },
      {
        'name': 'Login Screen',
        'screen': const LoginScreen(),
        'color': Colors.purple,
      },
      {
        'name': 'Firebase Test',
        'screen': const FirebaseTestScreen(),
        'color': Colors.cyan,
      },
      {
        'name': 'Email Verification Screen',
        'screen': const EmailVerificationScreen(
          email: 'register@gmail.com',
          referenceCode: 'XYLP',
        ),
        'color': Colors.blue,
      },
      {
        'name': 'Dashboard Screen',
        'screen': const DashboardScreen(),
        'color': Colors.green,
      },
      {
        'name': 'Item Search Screen',
        'screen': const ItemSearchScreen(),
        'color': Colors.red,
      },
    ];

    final List<Map<String, dynamic>> serviceList = [
      {
        'name': 'reset terms',
        'service': () => TermsService.resetTerms(),
        'color': Colors.red,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            /// Left Column: Screens
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: screenList.length + 1, // +1 สำหรับ header
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Screens',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  final screenData = screenList[index - 1];
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => screenData['screen'] as Widget,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: screenData['color'] as Color,
                      foregroundColor:
                          screenData['textColor'] as Color? ?? Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: Text(screenData['name'] as String),
                  );
                },
              ),
            ),

            /// Right Column: Services
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: serviceList.length + 1, // +1 สำหรับ header
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  final serviceData = serviceList[index - 1];
                  return ElevatedButton(
                    onPressed: () {
                      final serviceFunction =
                          serviceData['service'] as void Function();
                      serviceFunction();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: serviceData['color'] as Color,
                      foregroundColor:
                          serviceData['textColor'] as Color? ?? Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: Text(serviceData['name'] as String),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
