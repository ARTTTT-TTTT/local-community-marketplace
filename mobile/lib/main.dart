import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'utils/env_config.dart';
import 'screens/signup_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/login_screen.dart';
import 'screens/firebase_test_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/item_search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: "../.env");

    // Validate Firebase configuration
    EnvConfig.validateConfiguration();

    // Initialize Firebase with manual configuration instead of plist
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const MyApp());
  } catch (e) {
    // If there's an error with configuration, show error screen
    runApp(_ConfigErrorApp(error: e.toString()));
  }
}

class _ConfigErrorApp extends StatelessWidget {
  final String error;

  const _ConfigErrorApp({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configuration Error',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        appBar: AppBar(
          title: const Text('Configuration Error'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Firebase Configuration Error',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  error,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'How to fix:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Copy .env.example to .env\n'
                '2. Get your Firebase configuration from Firebase Console\n'
                '3. Replace placeholder values in .env with your actual values\n'
                '4. Restart the app',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
        fontFamily: 'Prompt', // Support Thai fonts
      ),
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
        'name': 'Splash Screen',
        'screen': const SplashScreen(),
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
        'screen': const SignupScreen(email: 'register@gmail.com'),
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
