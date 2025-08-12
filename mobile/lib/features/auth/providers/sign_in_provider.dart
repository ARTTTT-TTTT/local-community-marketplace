import 'package:community_marketplace/features/auth/services/firebase_auth_service.dart';
import 'package:community_marketplace/shared/constants/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SignInProvider extends ChangeNotifier {
  final logger = Logger();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isEmailValid = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _showPasswordField = false;
  bool _emailChecked = false;

  // Getters
  bool get isEmailValid => _isEmailValid;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  bool get showPasswordField => _showPasswordField;
  bool get emailChecked => _emailChecked;
  bool get canCheckEmail => _isEmailValid && !_isLoading && !_emailChecked;
  bool get canSignIn {
    final result =
        _isEmailValid &&
        passwordController.text.isNotEmpty &&
        !_isLoading &&
        _showPasswordField;
    return result;
  }

  // Email validation
  void onEmailChanged(String email) {
    _isEmailValid = _isValidEmail(email);
    _showPasswordField = false;
    _emailChecked = false;
    notifyListeners();
  }

  // Password change handler
  void onPasswordChanged(String password) {
    notifyListeners();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(AppConstants.emailRegex);
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

  // Social signIn methods
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      // TODO: Implement Google signIn
      await Future.delayed(const Duration(seconds: 2));
    } catch (error) {
      logger.e('signIn with google:', error: error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithFacebook() async {
    _setLoading(true);
    try {
      // TODO: Implement Facebook signIn
      await Future.delayed(const Duration(seconds: 2));
    } catch (error) {
      logger.e('Google signIn error:', error: error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithApple() async {
    _setLoading(true);
    try {
      // TODO: Implement Apple signIn
      await Future.delayed(const Duration(seconds: 2));
    } catch (error) {
      logger.e('Apple signIn error:', error: error);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkEmailExists() async {
    if (!_isEmailValid) return false;

    _setLoading(true);
    try {
      final emailExists = await FirebaseAuthService.checkEmailExists(
        emailController.text.trim(),
      );

      _emailChecked = true;

      if (emailExists) {
        _showPasswordField = true;
      }

      _setLoading(false);
      notifyListeners();
      return emailExists;
    } catch (error) {
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signInWithEmail() async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);
    try {
      await FirebaseAuthService.signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } catch (error) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> sendPasswordReset() async {
    if (!_isEmailValid) return;

    _setLoading(true);
    try {
      await FirebaseAuthService.sendPasswordResetEmail(
        emailController.text.trim(),
      );
      _setLoading(false);
    } catch (error) {
      _setLoading(false);
      rethrow;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void resetForm() {
    emailController.clear();
    passwordController.clear();
    _isEmailValid = false;
    _isPasswordVisible = false;
    _isLoading = false;
    _showPasswordField = false;
    _emailChecked = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
