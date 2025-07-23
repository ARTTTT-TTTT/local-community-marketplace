import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Utility class for accessing environment variables
class EnvConfig {
  // Firebase Web Configuration
  static String get firebaseWebApiKey =>
      dotenv.env['FIREBASE_WEB_API_KEY'] ?? 'temporary-web-api-key';

  static String get firebaseWebAppId =>
      dotenv.env['FIREBASE_WEB_APP_ID'] ?? '1:000000000000:web:temporary';

  static String get firebaseMessagingSenderId =>
      dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '000000000000';

  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ??
      _throwMissingEnvError('FIREBASE_PROJECT_ID');

  static String get firebaseAuthDomain =>
      dotenv.env['FIREBASE_AUTH_DOMAIN'] ??
      '$firebaseProjectId.firebaseapp.com';

  static String get firebaseStorageBucket =>
      dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '$firebaseProjectId.appspot.com';

  // Firebase Android Configuration
  static String get firebaseAndroidApiKey =>
      dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? firebaseWebApiKey;

  static String get firebaseAndroidAppId =>
      dotenv.env['FIREBASE_ANDROID_APP_ID'] ??
      _throwMissingEnvError('FIREBASE_ANDROID_APP_ID');

  // Firebase iOS Configuration
  static String get firebaseIosApiKey =>
      dotenv.env['FIREBASE_IOS_API_KEY'] ?? firebaseWebApiKey;

  static String get firebaseIosAppId =>
      dotenv.env['FIREBASE_IOS_APP_ID'] ??
      _throwMissingEnvError('FIREBASE_IOS_APP_ID');

  static String get firebaseIosBundleId =>
      dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ??
      'com.example.communityMarketplace';

  // Firebase macOS Configuration
  static String get firebaseMacosApiKey =>
      dotenv.env['FIREBASE_MACOS_API_KEY'] ?? firebaseIosApiKey;

  static String get firebaseMacosAppId =>
      dotenv.env['FIREBASE_MACOS_APP_ID'] ?? firebaseIosAppId;

  // Firebase Windows Configuration
  static String get firebaseWindowsApiKey =>
      dotenv.env['FIREBASE_WINDOWS_API_KEY'] ?? firebaseWebApiKey;

  static String get firebaseWindowsAppId =>
      dotenv.env['FIREBASE_WINDOWS_APP_ID'] ?? firebaseWebAppId;

  // Helper methods
  static bool get isConfigured =>
      dotenv.env['FIREBASE_PROJECT_ID'] != null &&
      dotenv.env['FIREBASE_PROJECT_ID'] != 'your-project-id-here';

  static String _throwMissingEnvError(String key) {
    throw Exception(
      'Missing required environment variable: $key\n'
      'Please check your .env file and make sure all Firebase configuration values are set.\n'
      'See .env.example for reference.',
    );
  }

  /// Check if all required environment variables are set
  static void validateConfiguration() {
    final requiredKeys = [
      'FIREBASE_PROJECT_ID',
      'FIREBASE_ANDROID_API_KEY', // Only require Android keys for now
      'FIREBASE_ANDROID_APP_ID',
    ];

    final missingKeys = <String>[];

    for (final key in requiredKeys) {
      final value = dotenv.env[key];
      if (value == null || value.isEmpty || value.contains('your-')) {
        missingKeys.add(key);
      }
    }

    if (missingKeys.isNotEmpty) {
      throw Exception(
        'Missing or invalid Firebase configuration:\n'
        '${missingKeys.map((key) => '- $key').join('\n')}\n\n'
        'Please update your .env file with actual Firebase values.\n'
        'See .env.example for reference and FIREBASE_SETUP.md for instructions.',
      );
    }
  }
}
