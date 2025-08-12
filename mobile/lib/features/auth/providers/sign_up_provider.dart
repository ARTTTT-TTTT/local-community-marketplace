import 'package:flutter/material.dart';

import 'package:community_marketplace/features/auth/services/firebase_auth_service.dart';

class SignUpProvider extends ChangeNotifier {
  // Form controllers
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Email property
  String _email = '';

  // Password visibility states
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Password validation state
  bool _isPasswordValid = false;

  // Loading state
  bool _isLoading = false;

  // Constructor
  SignUpProvider() {
    // Add listeners to update UI when text changes
    passwordController.addListener(_updateState);
    confirmPasswordController.addListener(_updateState);
  }

  void _updateState() {
    // Update password validation state when text changes
    _isPasswordValid = _isValidPassword(passwordController.text);
    notifyListeners();
  }

  // Getters
  String get email => _email;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isPasswordValid => _isPasswordValid;
  bool get isLoading => _isLoading;

  bool get canProceed {
    // Check if both fields have content
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        _isLoading) {
      return false;
    }

    // Check if password is valid
    bool passwordValid = _isValidPassword(passwordController.text);

    // Check if passwords match
    bool passwordsMatch =
        passwordController.text == confirmPasswordController.text;

    return passwordValid && passwordsMatch;
  }

  // Set email
  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  // Validate password
  void validatePassword(String password) {
    _isPasswordValid = _isValidPassword(password);
    notifyListeners();
  }

  bool _isValidPassword(String password) {
    // Check password requirements: ABC | abc | 123 | 8-20 characters
    if (password.length < 8 || password.length > 20) return false;

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));

    return hasUppercase && hasLowercase && hasDigits;
  }

  // Password validation message
  String? validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    if (!_isValidPassword(value)) {
      return 'รหัสผ่านไม่ตรงตามเงื่อนไข';
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณายืนยันรหัสผ่าน';
    }
    if (value != passwordController.text) {
      return 'รหัสผ่านไม่ตรงกัน';
    }
    return null;
  }

  // Submit SignUp
  Future<void> submitSignUp() async {
    if (!formKey.currentState!.validate()) {
      //print('Form validation failed');
      return;
    }

    // Double-check password validity
    bool passwordValid = _isValidPassword(passwordController.text);
    bool passwordsMatch =
        passwordController.text == confirmPasswordController.text;

    if (!passwordValid || !passwordsMatch) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuthService.signUpWithEmail(
        email: _email,
        password: passwordController.text,
      );

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Reset form
  void resetForm() {
    passwordController.clear();
    confirmPasswordController.clear();
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
    _isPasswordValid = false;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    passwordController.removeListener(_updateState);
    confirmPasswordController.removeListener(_updateState);
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
