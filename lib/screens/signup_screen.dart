import 'package:flutter/material.dart';

import '../utils/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/password_field.dart';

class SignupScreen extends StatefulWidget {
  final String email;

  const SignupScreen({super.key, required this.email});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordValid = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePassword(String password) {
    setState(() {
      _isPasswordValid = _isValidPassword(password);
    });
  }

  bool _isValidPassword(String password) {
    // Check password requirements: ABC | abc | 123 | 8-20 characters
    if (password.length < 8 || password.length > 20) return false;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));

    return hasUppercase && hasLowercase && hasDigits;
  }

  void _onNextPressed() {
    if (_formKey.currentState!.validate() && _isPasswordValid) {
      // TODO: Navigate to next step or complete registration
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บัญชีถูกสร้างเรียบร้อยแล้ว!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            key: _formKey,
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
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                  widget.email,
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
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade50,
                    // borderRadius: BorderRadius.circular(8),
                    // border: Border.all(color: Colors.grey.shade200),
                  ),
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
                  controller: _passwordController,
                  labelText: 'รหัสผ่าน',
                  isPasswordVisible: _isPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  onChanged: _validatePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรหัสผ่าน';
                    }
                    if (!_isValidPassword(value)) {
                      return 'รหัสผ่านไม่ตรงตามเงื่อนไข';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm password field
                PasswordField(
                  controller: _confirmPasswordController,
                  labelText: 'ยืนยันรหัสผ่าน',
                  isPasswordVisible: _isConfirmPasswordVisible,
                  onVisibilityToggle: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณายืนยันรหัสผ่าน';
                    }
                    if (value != _passwordController.text) {
                      return 'รหัสผ่านไม่ตรงกัน';
                    }
                    return null;
                  },
                ),

                const Spacer(),

                // Next button
                CustomButton(
                  text: 'ถัดไป',
                  onPressed: _onNextPressed,
                  isEnabled:
                      _isPasswordValid &&
                      _passwordController.text.isNotEmpty &&
                      _confirmPasswordController.text.isNotEmpty,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
