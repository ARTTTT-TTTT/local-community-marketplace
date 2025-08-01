import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    await dotenv.load(fileName: ".env");

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
        fontFamily: 'Noto Sans Thai', // Support Thai fonts
      ),
      home: const DemoHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoHomeScreen extends StatelessWidget {
  const DemoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo - Signup Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                );
              },
              child: const Text('Open Onboarding Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SignupScreen(email: 'register@gmail.com'),
                  ),
                );
              },
              child: const Text('Open Signup Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                );
              },
              child: const Text('Open Splash Screen'),
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
              child: const Text('Open Email Verification Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Open Login Screen'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirebaseTestScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('🔥 Firebase Test'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('🏪 Dashboard Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ItemSearchScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text('🔍 Item Search Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
