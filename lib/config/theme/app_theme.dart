// Flutter
import 'package:flutter/material.dart';

class AppTheme {

  static final secondaryColor = Color(0xFF0844A4);
  static Color successColor({double opacity = 1}) {
    return Color(0xFF00C853).withAlpha(calculateAlpha(opacity));
  }

  static int calculateAlpha(double value) {
    return (value * 255).round();
  }

  static final theme = ThemeData().copyWith();
}