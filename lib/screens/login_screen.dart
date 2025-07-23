import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_marketplace/providers/login_provider.dart';
import 'package:community_marketplace/widgets/password_field.dart';
import 'package:community_marketplace/widgets/custom_button.dart';
import 'package:community_marketplace/screens/signup_screen.dart';

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
              child: Form(
                key: provider.formKey,
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
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email Input Field
                    TextFormField(
                      controller: provider.emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        hintText: 'กรอกอีเมลของคุณ',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 16,
                        ),
                      ),
                      onChanged: provider.onEmailChanged,
                      validator: provider.validateEmail,
                    ),

                    const SizedBox(height: 24),

                    // Conditional Password Field - only show if email is checked and exists
                    if (provider.showPasswordField) ...[
                      PasswordField(
                        controller: provider.passwordController,
                        labelText: "รหัสผ่าน",
                        hintText: 'กรอกรหัสผ่านของคุณ',
                        isPasswordVisible: provider.isPasswordVisible,
                        onVisibilityToggle: provider.togglePasswordVisibility,
                        validator: provider.validatePassword,
                      ),
                      const SizedBox(height: 16),
                    ],

                    SizedBox(height: provider.showPasswordField ? 16 : 32),

                    // Email Check Button OR Login Button
                    if (!provider.emailChecked)
                      CustomButton(
                        text: provider.isLoading
                            ? 'กำลังตรวจสอบ...'
                            : 'เข้าใช้งานด้วย Email',
                        onPressed: provider.canCheckEmail
                            ? () => _handleEmailCheck(context, provider)
                            : () {},
                        isEnabled: provider.canCheckEmail,
                      )
                    else if (provider.showPasswordField)
                      CustomButton(
                        text: provider.isLoading
                            ? 'กำลังเข้าสู่ระบบ...'
                            : 'เข้าสู่ระบบ',
                        onPressed: provider.canSignIn
                            ? () => _handleEmailLogin(context, provider)
                            : () {},
                        isEnabled: provider.canSignIn,
                      ),

                    const SizedBox(height: 16),

                    // Change Email or Forgot Password Link
                    Center(
                      child: provider.emailChecked
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => provider.resetEmailCheck(),
                                  child: const Text(
                                    'เปลี่ยนอีเมล',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                if (provider.showPasswordField)
                                  TextButton(
                                    onPressed: () => _handleForgotPassword(
                                      context,
                                      provider,
                                    ),
                                    child: const Text(
                                      'ลืมรหัสผ่าน?',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : const SizedBox.shrink(),
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
                          // TODO: Navigate to terms screen
                        },
                        child: const Text(
                          'ข้อกำหนดและเงื่อนไข',
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

  void _handleEmailLogin(BuildContext context, LoginProvider provider) async {
    try {
      await provider.signInWithEmail();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('เข้าสู่ระบบสำเร็จ!')),
            backgroundColor: Colors.green,
          ),
        );

        // TODO: Navigate to home screen
        // Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleForgotPassword(
    BuildContext context,
    LoginProvider provider,
  ) async {
    if (!provider.isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('กรุณากรอกอีเมลที่ถูกต้องก่อน')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await provider.sendPasswordReset();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('ส่งลิงก์รีเซ็ตรหัสผ่านไปยังอีเมลของคุณแล้ว'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(error.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleEmailCheck(BuildContext context, LoginProvider provider) async {
    try {
      final emailExists = await provider.checkEmailExists();

      if (context.mounted) {
        if (!emailExists) {
          // Email doesn't exist, navigate to signup
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SignupScreen(email: provider.emailController.text.trim()),
            ),
          ).then((result) {
            // If signup was successful, reset the form for login
            if (result == true) {
              provider.resetEmailCheck();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ'),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        }
        // If email exists, the password field will automatically show
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('เกิดข้อผิดพลาด: ${error.toString()}')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
