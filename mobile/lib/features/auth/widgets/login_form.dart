import 'package:community_marketplace/features/auth/screens/register_screen.dart';
import 'package:community_marketplace/features/auth/providers/login_provider.dart';
import 'package:community_marketplace/features/auth/widgets/password_field.dart';
import 'package:community_marketplace/features/auth/widgets/confirm_button.dart';
import 'package:community_marketplace/screens/dashboard_screen.dart';
import 'package:community_marketplace/shared/theme/color_schemas.dart';

import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final LoginProvider provider;

  const LoginForm({super.key, required this.provider});

  void _handleForgotPassword(
    BuildContext context,
    LoginProvider provider,
  ) async {
    if (!provider.isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text('กรุณากรอกอีเมลที่ถูกต้องก่อน')),
          backgroundColor: AppColors.error,
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
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text(error.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _handleEmailLogin(BuildContext context, LoginProvider provider) async {
    try {
      await provider.signInWithEmail();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('เข้าสู่ระบบสำเร็จ!')),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pushReplacementNamed(
          context,
          const DashboardScreen() as String,
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: AppColors.error,
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
          final result = await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RegisterScreen(email: provider.emailController.text.trim()),
            ),
          );

          // Check mounted again after navigation
          if (context.mounted) {
            // If signup was successful, reset the form for login
            if (result == true) {
              provider.resetEmailCheck();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text('สมัครสมาชิกสำเร็จ! กรุณาเข้าสู่ระบบ'),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          }
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: provider.formKey,
      child: Column(
        children: [
          _buildEmailField(provider),
          const SizedBox(height: 24),
          if (provider.showPasswordField) ...[
            _buildPasswordField(provider),
            const SizedBox(height: 16),
          ],

          SizedBox(height: provider.showPasswordField ? 16 : 32),
          _buildActionButton(context, provider),
          const SizedBox(height: 16),
          _buildChangeEmailOrForgot(context, provider),
        ],
      ),
    );
  }

  Widget _buildEmailField(LoginProvider provider) {
    return TextFormField(
      controller: provider.emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 16, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'อีเมล',
        hintText: 'กรอกอีเมลของคุณ',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      ),
      onChanged: provider.onEmailChanged,
      validator: provider.validateEmail,
    );
  }

  Widget _buildPasswordField(LoginProvider provider) {
    return PasswordField(
      controller: provider.passwordController,
      labelText: "รหัสผ่าน",
      hintText: 'กรอกรหัสผ่านของคุณ',
      isPasswordVisible: provider.isPasswordVisible,
      onVisibilityToggle: provider.togglePasswordVisibility,
      onChanged: provider.onPasswordChanged,
      validator: provider.validatePassword,
    );
  }

  Widget _buildActionButton(BuildContext context, LoginProvider provider) {
    if (!provider.emailChecked) {
      return ConfirmButton(
        text: provider.isLoading ? 'กำลังตรวจสอบ...' : 'เข้าใช้งานด้วยอีเมล',
        onPressed: provider.canCheckEmail
            ? () => _handleEmailCheck(context, provider)
            : () {},
        isEnabled: provider.canCheckEmail,
      );
    } else if (provider.showPasswordField) {
      return ConfirmButton(
        text: provider.isLoading ? 'กำลังเข้าสู่ระบบ...' : 'เข้าสู่ระบบ',
        onPressed: provider.canSignIn
            ? () => _handleEmailLogin(context, provider)
            : () {},
        isEnabled: provider.canSignIn,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildChangeEmailOrForgot(
    BuildContext context,
    LoginProvider provider,
  ) {
    if (!provider.emailChecked) return const SizedBox.shrink();
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => provider.resetEmailCheck(),
            child: const Text(
              'เปลี่ยนอีเมล',
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ),
          if (provider.showPasswordField)
            TextButton(
              onPressed: () => _handleForgotPassword(context, provider),
              child: const Text(
                'ลืมรหัสผ่าน?',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }
}
