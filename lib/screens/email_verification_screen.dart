import 'package:flutter/material.dart';
import 'dart:async';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String? referenceCode;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.referenceCode,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
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

  late String _referenceCode;

  @override
  void initState() {
    super.initState();
    _referenceCode = widget.referenceCode ?? 'XYLP';
    startTimer();
  }

  void startTimer() {
    // Cancel existing timer if any
    _timer?.cancel();
    _start = 120; // Reset timer to 2 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
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

  void _onOtpChanged(String value, int index) {
    if (value.length == 1) {
      if (index < _otpControllers.length - 1) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus(); // Last field, unfocus keyboard
        _verifyOtp(); // Optionally verify OTP here
      }
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus(); // Backspace moves focus back
    }
  }

  void _verifyOtp() {
    String otp = _otpControllers.map((c) => c.text).join();
    // TODO: Implement your OTP verification logic here
    if (otp.length == 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('กำลังตรวจสอบรหัส: $otp')));
    }
  }

  void _resendOtp() {
    if (_start == 0) {
      // TODO: Implement actual resend OTP logic here
      startTimer(); // Restart timer
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ส่งรหัสใหม่แล้ว!')));
    }
  }

  String get _timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} นาที';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _buildCustomTheme(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Go back
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
            children: <Widget>[
              const SizedBox(height: 16),
              Text(
                'ยืนยันอีเมล',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'กรอกรหัสที่ระบบส่งไปที่ ${widget.email}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'รหัสมีอายุ 2 นาที',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 48), // Space before OTP inputs
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_otpControllers.length, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1, // Only one digit per field
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        counterText: "", // Hide the default character counter
                      ),
                      onChanged: (value) => _onOtpChanged(value, index),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 48), // Space after OTP inputs
              // Reference Code Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'รหัสอ้างอิง: $_referenceCode',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'รหัสมีผล 2 นาที ก่อนหมดอายุ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _start == 0
                          ? _resendOtp
                          : null, // Disable tap if timer is running
                      child: Text(
                        _start == 0
                            ? 'ส่งรหัสใหม่'
                            : 'ส่งรหัสใหม่ครั้งถัดไปใน $_timerText',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: _start == 0
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ThemeData _buildCustomTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
      ), // Minimal color scheme
      useMaterial3: true,
      fontFamily:
          'SF Pro Display', // Example: If you want to use a custom font like SF Pro
      // You'll need to add it to pubspec.yaml and assets
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(
          255,
          255,
          255,
          255,
        ), // White app bar background
        foregroundColor: Colors.black, // Black text/icons on app bar
        elevation: 0, // No shadow
        scrolledUnderElevation: 0, // No shadow when scrolled
      ),
      textTheme: const TextTheme(
        // Styles matching the screenshot
        headlineMedium: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          height: 1.5, // Line height for readability
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: Colors.grey, // Lighter color for secondary text
        ),
        labelLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.grey, // Grey for the resend timer text
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100], // Light grey background for input fields
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, // No border line
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ), // Black border when focused
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, // No border line when enabled
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 1.0,
          ), // Red border on error
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ), // Red border on focused error
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 10.0,
        ),
      ),
    );
  }
}
