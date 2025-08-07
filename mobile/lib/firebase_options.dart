import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'shared/utils/env_config.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError('FirebaseOptions not configured for Linux.');
      default:
        throw UnsupportedError(
          'FirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Common base options
  static FirebaseOptions get _base => FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: EnvConfig.firebaseMessagingSenderId,
    projectId: EnvConfig.firebaseProjectId,
    storageBucket: EnvConfig.firebaseStorageBucket,
  );

  static FirebaseOptions get web => _base.copyWith(
    apiKey: EnvConfig.firebaseWebApiKey,
    appId: EnvConfig.firebaseWebAppId,
    authDomain: EnvConfig.firebaseAuthDomain,
  );

  static FirebaseOptions get android => _base.copyWith(
    apiKey: EnvConfig.firebaseAndroidApiKey,
    appId: EnvConfig.firebaseAndroidAppId,
  );

  static FirebaseOptions get ios => _base.copyWith(
    apiKey: EnvConfig.firebaseIosApiKey,
    appId: EnvConfig.firebaseIosAppId,
    iosBundleId: EnvConfig.firebaseIosBundleId,
  );

  static FirebaseOptions get macos => _base.copyWith(
    apiKey: EnvConfig.firebaseMacosApiKey,
    appId: EnvConfig.firebaseMacosAppId,
    iosBundleId: EnvConfig.firebaseIosBundleId,
  );

  static FirebaseOptions get windows => _base.copyWith(
    apiKey: EnvConfig.firebaseWindowsApiKey,
    appId: EnvConfig.firebaseWindowsAppId,
    authDomain: EnvConfig.firebaseAuthDomain,
  );
}
