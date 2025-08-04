import 'package:flutter/material.dart';

class EmailVerificationTheme {
  static ThemeData get theme {
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
