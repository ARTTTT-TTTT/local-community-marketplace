import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/signup_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/password_field.dart';

class SignupScreen extends StatelessWidget {
  final String email;

  const SignupScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: _SignupScreenContent(email: email),
    );
  }
}

class _SignupScreenContent extends StatelessWidget {
  final String email;

  const _SignupScreenContent({required this.email});

  void _onNextPressed(BuildContext context, SignupProvider provider) async {
    try {
      await provider.submitSignup();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('บัญชีถูกสร้างเรียบร้อยแล้ว!'),
            backgroundColor: Colors.green,
          ),
        );

        // TODO: Navigate to next screen
        // Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'สมัครบัญชีใหม่',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    RichText(
                      text: TextSpan(
                        text: 'สร้างรหัสผ่านสำหรับบัญชี ',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: 'Dime!',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppConstants.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' ของคุณ',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Email display
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Password requirements
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(),
                      child: const Text(
                        'ABC  |  abc  |  123  |  8-20 ตัวอักษร',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Password field
                    PasswordField(
                      controller: provider.passwordController,
                      labelText: "",
                      hintText: 'รหัสผ่าน',
                      isPasswordVisible: provider.isPasswordVisible,
                      onVisibilityToggle: provider.togglePasswordVisibility,
                      onChanged: provider.validatePassword,
                      validator: provider.validatePasswordField,
                    ),

                    const SizedBox(height: 20),

                    // Confirm password field
                    PasswordField(
                      controller: provider.confirmPasswordController,
                      labelText: "",
                      hintText: 'ยืนยันรหัสผ่าน',
                      isPasswordVisible: provider.isConfirmPasswordVisible,
                      onVisibilityToggle:
                          provider.toggleConfirmPasswordVisibility,
                      validator: provider.validateConfirmPasswordField,
                    ),

                    const Spacer(),

                    // Next button
                    CustomButton(
                      text: provider.isLoading ? 'กำลังสร้างบัญชี...' : 'ถัดไป',
                      onPressed: provider.canProceed
                          ? () => _onNextPressed(context, provider)
                          : () {},
                      isEnabled: provider.canProceed,
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
}
