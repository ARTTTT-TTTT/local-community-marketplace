import 'package:flutter/material.dart';
import 'dart:async';

class EmailVerificationProvider extends ChangeNotifier {
  // Controllers for each OTP input field
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  // Focus nodes to manage focus movement between input fields
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  // Timer for resend code functionality
  Timer? _timer;
  int _start = 120; // 2 minutes in seconds for countdown

  // Email and reference code
  final String _email;
  final String _referenceCode;

  EmailVerificationProvider({required String email, String? referenceCode})
    : _email = email,
      _referenceCode = referenceCode ?? 'XYLP' {
    startTimer();
  }

  // Getters
  List<TextEditingController> get otpControllers => _otpControllers;
  List<FocusNode> get otpFocusNodes => _otpFocusNodes;
  int get remainingTime => _start;
  String get email => _email;
  String get referenceCode => _referenceCode;
  bool get canResend => _start == 0;

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} นาที';
  }

  void startTimer() {
    // Cancel existing timer if any
    _timer?.cancel();
    _start = 120; // Reset timer to 2 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        notifyListeners();
      } else {
        _start--;
        notifyListeners();
      }
    });
  }

  void onOtpChanged(String value, int index) {
    if (value.length == 1) {
      if (index < _otpControllers.length - 1) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus(); // Last field, unfocus keyboard
        verifyOtp(); // Optionally verify OTP here
      }
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus(); // Backspace moves focus back
    }
  }

  void verifyOtp() {
    String otp = _otpControllers.map((c) => c.text).join();
    // TODO: Implement your OTP verification logic here
    if (otp.length == 6) {
      // For now, just store the OTP or handle it as needed
      // In a real app, you would send this to your backend
      print('Verifying OTP: $otp');
    }
  }

  void resendOtp(BuildContext context) {
    if (canResend) {
      // TODO: Implement actual resend OTP logic here
      startTimer(); // Restart timer
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ส่งรหัสใหม่แล้ว!')));
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is disposed
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
