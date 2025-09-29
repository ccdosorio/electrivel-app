import 'package:flutter/material.dart';

class LoadingFeedbackWidget extends StatelessWidget {
  final String message;
  final Color? indicatorColor;

  const LoadingFeedbackWidget({super.key, this.message = 'Cargando datos', this.indicatorColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
