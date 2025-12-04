import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyListWidget({
    super.key,
    this.message = 'No se encontraron resultados',
    this.icon = Icons.search_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
