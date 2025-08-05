import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:community_marketplace/utils/env_config.dart';
import 'package:community_marketplace/firebase_options.dart';
import 'package:community_marketplace/constants/app_constants.dart';
import 'package:community_marketplace/theme/app_theme.dart';

import 'package:community_marketplace/screens/add_item_screen.dart';
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

    runApp(const MyApp());
  } catch (e) {
    runApp(ErrorScreen(error: e.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        'name': 'Email Verification Screen',
        'screen': const EmailVerificationScreen(
          email: 'register@gmail.com',
          referenceCode: 'XYLP',
        ),
        'color': Colors.blue,
      },
      {
        'name': 'Firebase Test',
        'screen': const FirebaseTestScreen(),
        'color': Colors.cyan,
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
      {
        'name': 'Add Item Screen',
        'screen': const AddItemScreen(),
        'color': Colors.pink,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.separated(
        itemCount: screenList.length,
        itemBuilder: (BuildContext context, int index) {
          final screenData = screenList[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => screenData['screen'] as Widget,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: screenData['color'] as Color,
                foregroundColor:
                    screenData['textColor'] as Color? ?? Colors.white,
              ),
              child: Text(screenData['name'] as String),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 16);
        },
      ),
    );
  }
}
