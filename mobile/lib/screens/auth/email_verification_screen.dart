import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:community_marketplace/providers/auth/email_verification_provider.dart';
import 'package:community_marketplace/utils/email_verification_theme.dart';

class EmailVerificationScreen extends StatelessWidget {
  final String email;
  final String? referenceCode;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.referenceCode,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          EmailVerificationProvider(email: email, referenceCode: referenceCode),
      child: const _EmailVerificationContent(),
    );
  }
}

class _EmailVerificationContent extends StatelessWidget {
  const _EmailVerificationContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<EmailVerificationProvider>(
      builder: (context, provider, child) {
        return Theme(
          data: EmailVerificationTheme.theme,
          child: Scaffold(
            backgroundColor: Colors.white,
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
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to start
                children: <Widget>[
                  const SizedBox(height: 16),
                  Text(
                    'ยืนยันอีเมล',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'กรอกรหัสที่ระบบส่งไปที่ ${provider.email}',
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
                    children: List.generate(provider.otpControllers.length, (
                      index,
                    ) {
                      return SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: provider.otpControllers[index],
                          focusNode: provider.otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1, // Only one digit per field
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            counterText:
                                "", // Hide the default character counter
                          ),
                          onChanged: (value) =>
                              provider.onOtpChanged(value, index),
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
                          'รหัสอ้างอิง: ${provider.referenceCode}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'รหัสมีผล 2 นาที ก่อนหมดอายุ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: provider.canResend
                              ? () => provider.resendOtp(context)
                              : null, // Disable tap if timer is running
                          child: Text(
                            provider.canResend
                                ? 'ส่งรหัสใหม่'
                                : 'ส่งรหัสใหม่ครั้งถัดไปใน ${provider.timerText}',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: provider.canResend
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
      },
    );
  }
}
