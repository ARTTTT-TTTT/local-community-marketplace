import 'package:community_marketplace/features/auth/providers/sign_up_provider.dart';
import 'package:community_marketplace/features/auth/widgets/password_field.dart';
import 'package:community_marketplace/features/auth/widgets/confirm_button.dart';
import 'package:community_marketplace/features/auth/screens/sign_in_screen.dart';
import 'package:community_marketplace/shared/theme/color_schemas.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {
  final SignUpProvider provider;
  final String email;

  const SignUpForm({super.key, required this.provider, required this.email});

  void _handleSignUp(BuildContext context, SignUpProvider provider) async {
    try {
      await provider.submitSignUp();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('บัญชีถูกสร้างเรียบร้อยแล้ว!')),
            backgroundColor: AppColors.success,
          ),
        );

        await Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SignInScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(child: Text('เกิดข้อผิดพลาด: ${error.toString()}')),
            backgroundColor: AppColors.error,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtitle(),
          const SizedBox(height: 8),
          _buildEmailDisplay(),
          const SizedBox(height: 16),
          _buildPasswordRequirements(),
          const SizedBox(height: 20),
          _buildPasswordField(provider),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(provider),
          const SizedBox(height: 24),
          _buildSignUpButton(context, provider),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return RichText(
      text: TextSpan(
        text: 'สร้างรหัสผ่านสำหรับบัญชีของคุณ',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildEmailDisplay() {
    return Text(
      email,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(),
      child: const Text(
        'ABC  |  abc  |  123  |  8-20 ตัวอักษร',
        style: TextStyle(fontSize: 14, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildPasswordField(SignUpProvider provider) {
    return PasswordField(
      controller: provider.passwordController,
      labelText: "รหัสผ่าน",
      hintText: 'กรอกรหัสผ่านของคุณ',
      isPasswordVisible: provider.isPasswordVisible,
      onVisibilityToggle: provider.togglePasswordVisibility,
      validator: provider.validatePasswordField,
    );
  }

  Widget _buildConfirmPasswordField(SignUpProvider provider) {
    return PasswordField(
      controller: provider.confirmPasswordController,
      labelText: "ยืนยันรหัสผ่าน",
      hintText: 'กรอกรหัสผ่านของคุณอีกครั้ง',
      isPasswordVisible: provider.isConfirmPasswordVisible,
      onVisibilityToggle: provider.toggleConfirmPasswordVisibility,
      validator: provider.validateConfirmPasswordField,
    );
  }

  Widget _buildSignUpButton(BuildContext context, SignUpProvider provider) {
    return Selector<SignUpProvider, ({bool canProceed, bool isLoading})>(
      selector: (_, p) => (canProceed: p.canProceed, isLoading: p.isLoading),
      builder: (context, state, child) {
        return ConfirmButton(
          text: state.isLoading ? 'กำลังสร้างบัญชี...' : 'ถัดไป',
          onPressed: state.canProceed
              ? () => _handleSignUp(context, provider)
              : () {},
          isEnabled: state.canProceed,
        );
      },
    );
  }
}
