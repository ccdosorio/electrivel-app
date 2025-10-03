import 'package:flutter/material.dart';


class HomeIcon extends StatelessWidget {
  final IconData icon;

  const HomeIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 60, color: Colors.white);
  }
}
