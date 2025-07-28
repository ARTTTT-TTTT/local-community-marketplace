# Firebase Authentication Setup Instructions

## Prerequisites

You mentioned you have already set up Firebase Authentication. Here's what you need to do to integrate it with your Flutter app:

## 1. Install FlutterFire CLI (if not already done)

```bash
pnpm install -g firebase-tools
dart pub global activate flutterfire_cli
```

## 2. Configure Firebase for Flutter

Run this command in your project root directory:

```bash
flutterfire configure
```

This will:

- Generate `firebase_options.dart` with your actual Firebase configuration
- Configure your Android and iOS apps
- Set up the necessary Firebase files

## 3. Replace the placeholder firebase_options.dart

The current `lib/firebase_options.dart` file contains placeholder values. After running `flutterfire configure`, replace it with the generated file.

## 4. Firebase Project Setup

Make sure your Firebase project has:

- Authentication enabled
- Email/Password sign-in method enabled
- (Optional) Google, Facebook, Apple sign-in methods if you want to use them

## 5. Android Configuration

If you're building for Android, make sure:

- `android/app/google-services.json` exists (created by flutterfire configure)
- `android/app/build.gradle` has the Google services plugin:
  ```gradle
  apply plugin: 'com.google.gms.google-services'
  ```

## 6. iOS Configuration

If you're building for iOS, make sure:

- `ios/Runner/GoogleService-Info.plist` exists (created by flutterfire configure)
- The bundle ID matches your Firebase project configuration

## 7. Test the Integration

After proper configuration, you can:

1. Run `flutter run` to test the app
2. Try signing up with email/password
3. Check Firebase Console to see if users are being created
4. Test sign-in functionality

## Current Implementation Features

✅ Firebase Authentication Service with Thai error messages
✅ Sign up with email and password
✅ Sign in with email and password  
✅ Password reset functionality
✅ Email verification
✅ Proper error handling
✅ Loading states
✅ Form validation
✅ Auth state management with StreamBuilder

## Important Notes

- Users will receive an email verification after signing up
- The app includes proper error handling with Thai language messages
- Social login buttons are ready but need additional setup for Google/Facebook/Apple Sign-In
- The AuthWrapper automatically handles authentication state changes

## Next Steps

1. Run `flutterfire configure` to replace placeholder configuration
2. Test signup and login functionality
3. Customize the home screen in AuthWrapper
4. Add social login implementations if needed

## Usage in Your App

To use authentication state management, replace the home screen in `main.dart` with:

```dart
import 'widgets/auth_wrapper.dart';

// In your MaterialApp:
home: const AuthWrapper(),
```
