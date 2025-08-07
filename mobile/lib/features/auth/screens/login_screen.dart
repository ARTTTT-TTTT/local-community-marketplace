import 'package:community_marketplace/features/auth/widgets/login_form.dart';
import 'package:community_marketplace/features/auth/providers/login_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context),
              const SizedBox(height: 40),
              Selector<LoginProvider, LoginProvider>(
                selector: (_, provider) => provider,
                builder: (context, provider, child) {
                  return LoginForm(provider: provider);
                },
              ),
              const SizedBox(height: 40),
              _buildDivider(),

              // * GOOGLE
              const SizedBox(height: 24),
              Selector<LoginProvider, LoginProvider>(
                selector: (_, provider) => provider,
                builder: (context, provider, child) {
                  return _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    text: 'เข้าใช้งานด้วย Google',
                    backgroundColor: const Color(0xFF4285F4),
                    textColor: Colors.white,
                    onPressed: () => provider.signInWithGoogle(),
                  );
                },
              ),

              // * FACEBOOK
              const SizedBox(height: 12),
              Selector<LoginProvider, LoginProvider>(
                selector: (_, provider) => provider,
                builder: (context, provider, child) {
                  return _buildSocialButton(
                    icon: Icons.facebook,
                    text: 'เข้าใช้งานด้วย Facebook',
                    backgroundColor: const Color(0xFF1877F2),
                    textColor: Colors.white,
                    onPressed: () => provider.signInWithFacebook(),
                  );
                },
              ),

              // * APPLE
              // TODO: CHECK SHOW IF APPLE DEVICE
              const SizedBox(height: 12),
              Selector<LoginProvider, LoginProvider>(
                selector: (_, provider) => provider,
                builder: (context, provider, child) {
                  return _buildSocialButton(
                    icon: Icons.apple,
                    text: 'เข้าใช้งานด้วย Apple',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () => provider.signInWithApple(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Community Marketplace',
        style: Theme.of(context).textTheme.displayLarge,
      ),
      const SizedBox(height: 40),
      Text(
        'สมัครบัญชีใหม่ หรือเข้าสู่ระบบ',
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildDivider() {
  return Row(
    children: [
      Expanded(child: Container(height: 1, color: Colors.grey[300])),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text('หรือ', style: TextStyle(color: Colors.grey, fontSize: 14)),
      ),
      Expanded(child: Container(height: 1, color: Colors.grey[300])),
    ],
  );
}

Widget _buildSocialButton({
  required IconData icon,
  required String text,
  required Color backgroundColor,
  required Color textColor,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    ),
  );
}
