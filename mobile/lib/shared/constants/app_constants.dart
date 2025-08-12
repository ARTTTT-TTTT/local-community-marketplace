class AppConstants {
  // App Strings
  static const String appName = 'Community Marketplace';
  static const String appVersion = '1.0.0';

  // Network
  static const Duration apiTimeout = Duration(seconds: 30);

  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Password Requirements
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 20;

  // Regular Expressions
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^[0-9]{10}$';
  // TODO: passwordRegex

  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
}
