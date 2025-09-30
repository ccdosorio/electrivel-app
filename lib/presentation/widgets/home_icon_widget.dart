import 'package:flutter/material.dart';
import 'package:electrivel_app/config/config.dart';


class HomeIcon extends StatelessWidget {
  final IconData icon;

  const HomeIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 60, color: AppTheme.secondaryColor);
  }
}
