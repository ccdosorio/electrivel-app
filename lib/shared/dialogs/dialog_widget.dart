import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  final String title;
  final Widget? content;
  final Color titleColor;
  final List<Widget>? actions;

  const DialogWidget({super.key, required this.title, this.content, this.titleColor = Colors.black, this.actions});

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(color: titleColor, fontWeight: FontWeight.bold);

    return AlertDialog(
      title: Text(title, textAlign: TextAlign.left, style: titleStyle),
      content: content,
      actions: actions,
    );
  }
}
