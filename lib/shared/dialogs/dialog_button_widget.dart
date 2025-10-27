import 'package:flutter/material.dart';
import 'package:electrivel_app/config/config.dart';

class DialogButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String textButton;
  final bool isPrimary;
  final bool isDisabled;

  const DialogButtonWidget(
      {super.key, this.onPressed, required this.textButton, required this.isPrimary, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: isDisabled ? _disabledStyle() : (isPrimary ? _primaryStyle() : _secondaryStyle()),
      child: Text(textButton),
    );
  }

  ButtonStyle _disabledStyle() {
    return FilledButton.styleFrom(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.grey.withAlpha(100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      disabledBackgroundColor: Colors.grey.withAlpha(25),
      disabledForegroundColor: Colors.grey,
    );
  }

  ButtonStyle _primaryStyle() {
    return FilledButton.styleFrom(
      backgroundColor: AppTheme.secondaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  ButtonStyle _secondaryStyle() {
    return FilledButton.styleFrom(
      backgroundColor: Colors.red.withAlpha(13),
      foregroundColor: Colors.red,
      textStyle: TextStyle(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
