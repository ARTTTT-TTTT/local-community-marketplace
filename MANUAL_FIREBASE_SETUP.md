# Manual Firebase Setup Guide

Since FlutterFire CLI is not available, let's set up Firebase manually:

## Step 1: Install Firebase CLI (Optional but Recommended)

1. Install Node.js from https://nodejs.org/
2. Run: `npm install -g firebase-tools`
3. Run: `firebase login`

## Step 2: Install FlutterFire CLI

1. Run: `dart pub global activate flutterfire_cli`
2. Make sure Dart is in your PATH
3. Run: `flutterfire configure`

## Alternative: Manual Setup

### For Android:

1. Go to Firebase Console → Project Settings → General
2. Click "Add app" → Android
3. Enter your package name (from android/app/src/main/AndroidManifest.xml)
4. Download `google-services.json`
5. Place it in `android/app/` directory

### For iOS (if needed):

1. Go to Firebase Console → Project Settings → General
2. Click "Add app" → iOS
3. Enter your bundle ID (from ios/Runner/Info.plist)
4. Download `GoogleService-Info.plist`
5. Place it in `ios/Runner/` directory

### Get Firebase Configuration:

1. Go to Firebase Console → Project Settings → General
2. Scroll down to "Your apps"
3. Click on the web app configuration icon (</>)
4. Copy the configuration object

## Step 3: Update firebase_options.dart

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration.

Example structure:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-api-key-here',
  appId: 'your-app-id-here',
  messagingSenderId: 'your-sender-id-here',
  projectId: 'your-project-id-here',
  storageBucket: 'your-project-id.appspot.com',
);
```

## Step 4: Update Android build.gradle

Add to `android/app/build.gradle`:

```gradle
dependencies {
    implementation 'com.google.firebase:firebase-bom:32.7.0'
    // other dependencies
}

apply plugin: 'com.google.gms.google-services'
```

Add to `android/build.gradle`:

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.4.0'
    // other dependencies
}
```

## Current Status

✅ Firebase dependencies added to pubspec.yaml
✅ Firebase Auth Service created
✅ Signup/Login screens integrated
✅ Error handling in Thai language
✅ Auth state management ready

## Next Steps

1. Get your Firebase project configuration
2. Replace placeholder values in firebase_options.dart
3. Add google-services.json (Android)
4. Test the authentication flow
