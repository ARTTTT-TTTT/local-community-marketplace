import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Prompt';

  static const TextStyle headline1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.black54,
  );

  static TextTheme get textTheme => const TextTheme(
    displayLarge: headline1,
    displayMedium: headline2,
    bodyMedium: bodyText,
    bodySmall: caption,
  );
}
