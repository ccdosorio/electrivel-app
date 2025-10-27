// Flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceDateHeader extends StatelessWidget {
  final String date;

  const AttendanceDateHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.parse(date);
    final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(parsedDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(
        formattedDate,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}