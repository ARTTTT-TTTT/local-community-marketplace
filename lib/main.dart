import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';

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
                  MaterialPageRoute(
                    builder: (context) => const SplashScreen(),
                  ),
                );
              },
              child: const Text('Open Splash Screen'),
            ),  
          ],
        ),
      ),
    );
  }
}
