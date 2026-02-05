// Flutter
import 'package:flutter/material.dart';

// Internal dependencies
import 'package:electrivel_app/main.dart';
import 'package:electrivel_app/config/config.dart';


enum InfoThemeSnackBar { ok, info, alert }

class SnackBarNotifications {
  static Color _getBackgroundColor(InfoThemeSnackBar theme) {
    switch (theme) {
      case InfoThemeSnackBar.ok:
        return AppTheme.successColor();
      case InfoThemeSnackBar.info:
        return AppTheme.secondaryColor;
      case InfoThemeSnackBar.alert:
        return Colors.red;
    }
  }

  static Duration _getDuration(InfoThemeSnackBar theme, {bool isActionPressed = false}) {
    switch (theme) {
      case InfoThemeSnackBar.ok:
      case InfoThemeSnackBar.info:
        return !isActionPressed ? const Duration(seconds: 3) : const Duration(days: 2);
      case InfoThemeSnackBar.alert:
        return !isActionPressed ? const Duration(seconds: 6) : const Duration(days: 2);
    }
  }

  static void showGeneralSnackBar({
    required String title,
    required String content,
    required InfoThemeSnackBar theme,
    VoidCallback? onActionPressed,
    Duration? specificDuration,
  }) {
    final backgroundColor = _getBackgroundColor(theme);
    final duration = specificDuration ?? _getDuration(theme, isActionPressed: onActionPressed != null);
    final messenger = scaffoldMessengerKey.currentState;

    if (messenger == null) return;

    messenger.showSnackBar(
      GeneralSnackBarNotificationWidget(
        backgroundColor: backgroundColor,
        duration: duration,
        title: title,
        content: content,
        onActionPressed: onActionPressed != null
            ? () {
          onActionPressed.call();
          messenger.hideCurrentSnackBar();
        }
            : null,
      ).getSnackBar,
    );
  }

  static void showContextSnackBar({
    required BuildContext context,
    required String title,
    required String content,
    required InfoThemeSnackBar theme,
    VoidCallback? onActionPressed,
    Duration? specificDuration,
  }) {
    final backgroundColor = _getBackgroundColor(theme);
    final duration = specificDuration ?? _getDuration(theme, isActionPressed: onActionPressed != null);

    ScaffoldMessenger.of(context).showSnackBar(
      GeneralSnackBarNotificationWidget(
        backgroundColor: backgroundColor,
        duration: duration,
        title: title,
        content: content,
        onActionPressed: theme == InfoThemeSnackBar.alert
            ? () {
          onActionPressed?.call();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }
            : null,
      ).getSnackBar,
    );
  }
}

class GeneralSnackBarNotificationWidget {
  final String title;
  final String content;
  final String snackBarActionLabel;
  final Color textColor;
  final Color backgroundColor;
  final Color snackBarActionColorLabel;
  final Duration duration;
  final VoidCallback? onActionPressed;

  const GeneralSnackBarNotificationWidget({
    this.textColor = Colors.white,
    required this.backgroundColor,
    required this.duration,
    required this.title,
    required this.content,
    this.onActionPressed,
    this.snackBarActionLabel = 'Ok',
    this.snackBarActionColorLabel = Colors.white,
  });

  SnackBar get getSnackBar {
    return SnackBar(
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16.0), left: Radius.circular(16.0)),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title.isNotEmpty) ...[Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold))],
          if (content.isNotEmpty) ...[Text(content, style: TextStyle(color: textColor), textAlign: TextAlign.center)],
        ],
      ),
      action: onActionPressed == null
          ? null
          : SnackBarAction(
        label: snackBarActionLabel,
        textColor: snackBarActionColorLabel,
        onPressed: onActionPressed!,
      ),
    );
  }
}

