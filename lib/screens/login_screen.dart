import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_marketplace/providers/login_provider.dart';
import 'package:community_marketplace/screens/email_verification_screen.dart';

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
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // App Logo and Name
                  Row(
                    children: [
                      const Text(
                        'OurIconProduction',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  // Title
                  const Text(
                    'สมัครบัญชีใหม่ หรือเข้าสู่ระบบ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 40),

                  const SizedBox(height: 16),

                  // Email Input Field and Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: provider.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'อีเมล',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onChanged: provider.onEmailChanged,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Continue with Email Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: provider.isEmailValid
                          ? () => _handleEmailLogin(context, provider)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey[200],
                      ),
                      child: Text(
                        'เข้าใช้งานด้วยอีเมล',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: provider.isEmailValid
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Divider with "หรือ"
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: Colors.grey[300]),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'หรือ',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(height: 1, color: Colors.grey[300]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Social Login Buttons
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    text: 'เข้าใช้งานด้วย Google',
                    backgroundColor: const Color(0xFF4285F4),
                    textColor: Colors.white,
                    onPressed: () => provider.signInWithGoogle(),
                  ),

                  const SizedBox(height: 12),

                  _buildSocialButton(
                    icon: Icons.facebook,
                    text: 'เข้าใช้งานด้วย Facebook',
                    backgroundColor: const Color(0xFF1877F2),
                    textColor: Colors.white,
                    onPressed: () => provider.signInWithFacebook(),
                  ),

                  const SizedBox(height: 12),

                  _buildSocialButton(
                    icon: Icons.apple,
                    text: 'เข้าใช้งานด้วย Apple',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () => provider.signInWithApple(),
                  ),

                  const Spacer(),

                  // Terms and Conditions
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Navigate to terms screen
                      },
                      child: const Text(
                        'ลืมรหัสผ่าน',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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

  void _handleEmailLogin(BuildContext context, LoginProvider provider) {
    // Navigate to email verification screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailVerificationScreen(
          email: provider.emailController.text,
          referenceCode: 'XYLP',
        ),
      ),
    );
  }
}
