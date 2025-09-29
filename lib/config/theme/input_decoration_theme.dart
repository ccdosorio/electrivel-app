// Flutter
import 'package:flutter/material.dart';

class InputDecorations {

  static InputDecoration decoration({
    FloatingLabelBehavior? floatingLabelBehavior = FloatingLabelBehavior.always,
    String? hintText,
    String? labelText,
    TextStyle? labelStyle,
    Widget? suffixIcon
  }) {
    return InputDecoration(
      floatingLabelBehavior: floatingLabelBehavior,
      hintText: hintText,
      label: Text(labelText ?? ''),
      labelStyle: labelStyle ?? TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF0844A4),
      ),
      suffixIcon: suffixIcon
    );
  }

}