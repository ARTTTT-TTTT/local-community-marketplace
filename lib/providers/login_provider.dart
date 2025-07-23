import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  bool _isEmailValid = false;
  bool _isLoading = false;

  // Getters
  bool get isEmailValid => _isEmailValid;
  bool get isLoading => _isLoading;

  // Email validation
  void onEmailChanged(String email) {
    _isEmailValid = _isValidEmail(email);
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

  // Social login methods
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      // TODO: Implement Google Sign In
      await Future.delayed(const Duration(seconds: 2));

      // For now, just show a message
      print('Google Sign In clicked');
    } catch (error) {
      print('Google Sign In error: $error');
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
      print('Facebook Sign In clicked');
    } catch (error) {
      print('Facebook Sign In error: $error');
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
      print('Apple Sign In clicked');
    } catch (error) {
      print('Apple Sign In error: $error');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithEmail() async {
    if (!_isEmailValid) return;

    _setLoading(true);
    try {
      // TODO: Implement email sign in logic
      await Future.delayed(const Duration(seconds: 2));

      // For now, just show a message
      print('Email Sign In: ${emailController.text}');
    } catch (error) {
      print('Email Sign In error: $error');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Reset form
  void resetForm() {
    emailController.clear();
    _isEmailValid = false;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
