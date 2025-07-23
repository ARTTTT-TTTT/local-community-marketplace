import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  // Form controllers
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Password visibility states
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Password validation state
  bool _isPasswordValid = false;

  // Loading state
  bool _isLoading = false;

  // Getters
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  bool get isPasswordValid => _isPasswordValid;
  bool get isLoading => _isLoading;

  bool get canProceed =>
      _isPasswordValid &&
      passwordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty &&
      !_isLoading;

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

  // Submit signup
  Future<void> submitSignup() async {
    if (!formKey.currentState!.validate() || !_isPasswordValid) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual signup logic here
      // await AuthService.signup(email, password);

      _isLoading = false;
      notifyListeners();

      // Return success - UI will handle navigation
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      // Rethrow error to be handled by UI
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
