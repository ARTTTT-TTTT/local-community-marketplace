# 🔥 Firebase Android Setup Guide

## 📋 **Complete Setup Checklist**

### **1. Firebase Console Setup**

1. **Go to Firebase Console:**

   ```
   https://console.firebase.google.com/
   ```

2. **Create/Select Project:**

   - Create new project or select existing one
   - Project ID should match what's in your `.env` file: `marketplace123-87584`

3. **Add Android App:**

   - Click "Add app" → **Android** 🤖
   - **Android package name:** `com.example.community_marketplace`
   - **App nickname:** `Community Marketplace Android`
   - **Debug signing certificate SHA-1:** (Leave blank for development)
   - Click **"Register app"**

4. **Download Configuration:**
   - Download `google-services.json`
   - **CRITICAL:** Place it in `android/app/google-services.json`

### **2. Enable Authentication**

1. **Go to Authentication:**

   - In Firebase Console → **Authentication**
   - Click **"Get started"**

2. **Set Sign-in Methods:**

   - Go to **"Sign-in method"** tab
   - Enable **"Email/Password"**
   - Enable **"Email link (passwordless sign-in)"** if needed

3. **Configure Authorized Domains:**
   - Add your domains if needed (localhost is enabled by default)

### **3. Get Configuration Values**

1. **For Web Configuration:**

   - Go to **Project Settings** ⚙️
   - Scroll to **"Your apps"**
   - Click on **Web app** (if you haven't created one, add it)
   - Copy the config values:

   ```javascript
   const firebaseConfig = {
     apiKey: "AIzaSy...", // ← FIREBASE_WEB_API_KEY
     authDomain: "project.firebaseapp.com", // ← FIREBASE_AUTH_DOMAIN
     projectId: "your-project-id", // ← FIREBASE_PROJECT_ID
     storageBucket: "project.appspot.com", // ← FIREBASE_STORAGE_BUCKET
     messagingSenderId: "123456789", // ← FIREBASE_WEB_MESSAGING_SENDER_ID
     appId: "1:123:web:abc123", // ← FIREBASE_WEB_APP_ID
   };
   ```

2. **For Android Configuration:**
   - In **Project Settings** → **Your apps**
   - Click on your **Android app**
   - Copy the values:
   - **API Key** → `FIREBASE_ANDROID_API_KEY`
   - **App ID** → `FIREBASE_ANDROID_APP_ID`

### **4. Update Your .env File**

Replace the placeholder values in your `.env` file with actual values:

```env
# Web Configuration (from Firebase Console Web App)
FIREBASE_WEB_API_KEY=AIzaSyC_your_actual_web_api_key_here
FIREBASE_WEB_APP_ID=1:123456789012:web:your_actual_app_id
FIREBASE_WEB_MESSAGING_SENDER_ID=123456789012
FIREBASE_PROJECT_ID=marketplace123-87584
FIREBASE_AUTH_DOMAIN=marketplace123-87584.firebaseapp.com
FIREBASE_STORAGE_BUCKET=marketplace123-87584.appspot.com

# Android Configuration (from Firebase Console Android App)
FIREBASE_ANDROID_API_KEY=AIzaSyC_your_actual_android_api_key_here
FIREBASE_ANDROID_APP_ID=1:123456789012:android:your_actual_android_app_id
```

### **5. File Structure Check**

Make sure you have these files:

```
android/
├── app/
│   ├── google-services.json  ← **MUST EXIST**
│   └── build.gradle.kts      ← **Updated with Firebase plugin**
└── build.gradle.kts          ← **Updated with Firebase classpath**

.env                          ← **Updated with real values**
```

### **6. Test Your Setup**

1. **Run the app:**

   ```bash
   flutter run
   ```

2. **Check for errors:**

   - Look for Firebase initialization errors
   - Check that Firebase Test screen loads without errors

3. **Test Authentication:**
   - Try to sign up with a test email
   - Check Firebase Console → Authentication → Users

## 🚨 **Common Issues**

### **Issue 1: google-services.json Missing**

```
Error: File google-services.json is missing
```

**Solution:** Download from Firebase Console and place in `android/app/`

### **Issue 2: Wrong Package Name**

```
Error: No matching client found for package name
```

**Solution:** Make sure Firebase Android app uses `com.example.community_marketplace`

### **Issue 3: Environment Variables Not Loading**

```
Error: Environment variable XXXX not found
```

**Solution:** Check your `.env` file has actual values, not placeholders

## ✅ **Success Indicators**

- ✅ App starts without Firebase errors
- ✅ Firebase Test screen shows "Connected to Firebase"
- ✅ Sign up creates user in Firebase Console
- ✅ Email verification works

---

**Need help?** Check the logs in VS Code terminal for specific error messages.
