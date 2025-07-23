import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isEmailValid = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Getters
  bool get isEmailValid => _isEmailValid;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  bool get canSignIn =>
      _isEmailValid && passwordController.text.isNotEmpty && !_isLoading;

  // Email validation
  void onEmailChanged(String email) {
    _isEmailValid = _isValidEmail(email);
    notifyListeners();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;

    // Basic email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Form validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    if (!_isValidEmail(value)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    if (value.length < 6) {
      return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
    }
    return null;
  }

  // Social login methods
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      // TODO: Implement Google Sign In
      await Future.delayed(const Duration(seconds: 2));

      // For now, just show a message
      //print('Google Sign In clicked');
    } catch (error) {
      //print('Google Sign In error: $error');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithFacebook() async {
    _setLoading(true);
    try {
      // TODO: Implement Facebook Sign In
      await Future.delayed(const Duration(seconds: 2));

      // For now, just show a message
      //print('Facebook Sign In clicked');
    } catch (error) {
      //print('Facebook Sign In error: $error');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithApple() async {
    _setLoading(true);
    try {
      // TODO: Implement Apple Sign In
      await Future.delayed(const Duration(seconds: 2));

      // For now, just show a message
      //print('Apple Sign In clicked');
    } catch (error) {
      //print('Apple Sign In error: $error');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithEmail() async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      // Sign in with Firebase Authentication
      await FirebaseAuthService.signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Success - UI will handle navigation
    } catch (error) {
      _setLoading(false);
      rethrow; // Let UI handle the error display
    }
  }

  // Send password reset email
  Future<void> sendPasswordReset() async {
    if (!_isEmailValid) return;

    _setLoading(true);
    try {
      await FirebaseAuthService.sendPasswordResetEmail(
        emailController.text.trim(),
      );
      _setLoading(false);
      // Success - UI will show confirmation
    } catch (error) {
      _setLoading(false);
      rethrow; // Let UI handle the error display
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    emailController.clear();
    passwordController.clear();
    _isEmailValid = false;
    _isPasswordVisible = false;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
